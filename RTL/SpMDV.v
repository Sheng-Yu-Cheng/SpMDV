`define DEBUG

`define DEBUG_TARGET_FEATURE 4'd0
`define DEBUG_TARGET_ROW     8'd0
`define DEBUG_STOP_AFTER_FIRST_VECTOR

module SpMDV 
(
	input clk,
	input rst,

	// Input signals
	input start_init,
    input [7 : 0] raw_input,
    input raw_data_valid,
	input w_input_valid,

	// Ouput signals
    output reg raw_data_request,
	output reg ld_w_request,
	output reg [21 : 0] o_result,
	output reg o_valid
);
	reg [23:0]state, next_state;
	localparam S_IDLE                = 24'd0;
	localparam S_START_READ_WEIGHT   = 24'd1;
	localparam S_READ_WEIGHT         = 24'd2;
	localparam S_START_READ_POSITION = 24'd3;
	localparam S_READ_POSITION       = 24'd4;
	localparam S_START_READ_BIAS     = 24'd5;
	localparam S_READ_BIAS           = 24'd6;
	localparam S_START_READ_VECTOR   = 24'd7;
	localparam S_READ_VECTOR         = 24'd8;
	localparam S_COMPUTE_INIT        = 24'd9;
	localparam S_READ_MATRIX_ELEM    = 24'd10;
	localparam S_WAIT_MATRIX_ELEM    = 24'd11;
	localparam S_READ_VECTOR_ELEM    = 24'd12;
	localparam S_WAIT_VECTOR_ELEM    = 24'd13;
	localparam S_MAC                 = 24'd14;
	localparam S_READ_BIAS_FOR_ROW   = 24'd15;
	localparam S_WAIT_BIAS_FOR_ROW   = 24'd16;
	localparam S_OUTPUT              = 24'd17;
	localparam S_CAPTURE_MATRIX_ELEM = 24'd18;
	localparam S_CAPTURE_BIAS_FOR_ROW = 24'd19;


	reg weight_chip_enable[2:0]; reg weight_write_enable[2:0]; 
	reg [11:0]weight_address[2:0]; reg [7:0]weight_data[2:0]; wire [7:0]weight_output[2:0];
	reg position_chip_enable[2:0]; reg position_write_enable[2:0]; 
	reg [11:0]position_address[2:0]; reg [7:0]position_data[2:0]; wire [7:0]position_output[2:0];
	reg bias_chip_enable, bias_write_enable; 
	reg [7:0]bias_address; reg [7:0]bias_data; wire [7:0]bias_output; 
	reg vector_chip_enable, vector_write_enable; 
	reg [11:0] vector_address; reg [7:0] vector_data; wire [7:0] vector_output; 
	genvar _;
	generate
		for (_ = 0; _ < 3; _ = _ + 1) begin : GEN_SRAM
			sram_4096x8 _weight(.CLK(clk), .CEN(~weight_chip_enable[_]), .WEN(~weight_write_enable[_]), .A(weight_address[_]), .D(weight_data[_]), .Q(weight_output[_]));
			sram_4096x8 _position(.CLK(clk), .CEN(~position_chip_enable[_]), .WEN(~position_write_enable[_]), .A(position_address[_]), .D(position_data[_]), .Q(position_output[_]));
		end
		sram_256x8 _bias(.CLK(clk), .CEN(~bias_chip_enable), .WEN(~bias_write_enable), .A(bias_address), .D(bias_data), .Q(bias_output));
		sram_4096x8  _vector(.CLK(clk), .CEN(~vector_chip_enable), .WEN(~vector_write_enable), .A(vector_address), .D(vector_data), .Q(vector_output));
	endgenerate;

	reg [7:0] row, col; // 0~255

	reg [3:0] group; //0~11
	reg [1:0] bank; // 0~3
	reg [13:0] global_address; // 0~12287

	reg [5:0] element_count; // 0~47

	reg signed [15:0] mult_product;   // S4.11
	reg signed [21:0] acc;            // S10.11
	reg signed [21:0] result_hold;    // S10.11
	reg signed [7:0]  weight_hold;
	reg signed [7:0]  bias_hold;

	reg [3:0] feature_id;
	reg [3:0] load_feature_id;
	reg [7:0] load_elem_id;

	reg [1:0] selected_sram;
	
	reg [7:0] output_row;
	reg [3:0] output_feature;

	reg [7:0]  pos_hold;
	reg signed [7:0] vec_hold;
	reg [13:0] term_gaddr_hold;
	reg [5:0]  term_elem_hold;

	`ifdef DEBUG
		reg dbg_stop_pending;
	`endif

	integer i;
	`ifdef DEBUG
		integer dbg_cycle;
	`endif
	// state logic
	always @(posedge clk or posedge rst) begin

		`ifdef DEBUG
		if (state != next_state) begin
			$display("[C%0d] STATE %0d -> %0d | row=%0d bank=%0d group=%0d elem=%0d feature=%0d load_feature=%0d load_elem=%0d",
					dbg_cycle, state, next_state,
					row, bank, group, element_count,
					feature_id, load_feature_id, load_elem_id);
		end
		`endif

		if (rst) begin
			state <= S_IDLE;

			`ifdef DEBUG
			dbg_cycle <= 0;
			dbg_stop_pending <= 1'b0;
			`endif

		end	else begin
			`ifdef DEBUG_STOP_AFTER_FIRST_VECTOR
			`ifdef DEBUG
				if (dbg_stop_pending) begin
					$display("============================================================");
					$display("[C%0d][DEBUG_STOP] Finished outputting feature 0, row 0~255. Stop simulation here.", dbg_cycle);
					$display("============================================================");
					$finish;
				end
			`endif
			`endif

			`ifdef DEBUG
				dbg_cycle <= dbg_cycle + 1;
			`endif

			for (i = 0; i < 3; i = i + 1) begin
				weight_chip_enable[i]    <= 0;
				weight_write_enable[i]   <= 0;
				position_chip_enable[i]  <= 0;
				position_write_enable[i] <= 0;
			end

			bias_chip_enable    <= 0;
			bias_write_enable   <= 0;
			vector_chip_enable  <= 0;
			vector_write_enable <= 0;
			o_valid <= 1'b0;
			`ifdef DEBUG
			// global sparse address should never exceed 12287 during matrix load/compute
			if ((state == S_READ_WEIGHT || state == S_READ_POSITION || state == S_READ_MATRIX_ELEM) &&
				global_address > 14'd12287) begin
				$display("[C%0d][ERROR] global_address overflow: %0d", dbg_cycle, global_address);
			end

			// Compute should never select non-existing fourth SRAM
			if ((state == S_READ_MATRIX_ELEM || state == S_WAIT_MATRIX_ELEM) &&
				selected_sram == 2'd3) begin
				$display("[C%0d][ERROR] selected_sram=3, illegal for only 3 SRAMs | gaddr=%0d",
						dbg_cycle, global_address);
			end

			// element_count should stay 0~47 in compute
			if ((state >= S_COMPUTE_INIT && state <= S_OUTPUT) &&
				element_count > 6'd47) begin
				$display("[C%0d][ERROR] element_count overflow: %0d", dbg_cycle, element_count);
			end
			`endif
			case (state) 
				S_IDLE: begin
					row <= 8'd0;
					col <= 8'd0;
					bank <= 2'd0;
					group <= 4'd0;
					global_address <= 14'd0;

					feature_id <= 4'd0;
					load_feature_id <= 4'd0;
					load_elem_id <= 8'd0;
					element_count <= 6'd0;

					mult_product <= 16'sd0;
					acc <= 22'sd0;
					result_hold <= 22'sd0;
					weight_hold <= 8'sd0;
					bias_hold <= 8'sd0;
					pos_hold <= 8'd0;
					vec_hold <= 8'sd0;
					term_gaddr_hold <= 14'd0;
					term_elem_hold <= 6'd0;

					output_row <= 8'd0;
					output_feature <= 4'd0;

					o_result <= 22'd0;
					o_valid <= 1'b0;
				end
				S_START_READ_WEIGHT: begin
				end

				S_START_READ_POSITION: begin
				end

				S_START_READ_BIAS: begin
				end
				S_READ_WEIGHT: begin
					if (w_input_valid) begin
						global_address = ({6'd0, row}  << 5) + ({6'd0, row}  << 4)
										+ ({12'd0, bank} << 3) + ({12'd0, bank} << 2)
										+ {10'd0, group};  // 48 * row + 12 * bank + group
						for (i = 0; i < 3; i = i + 1) begin
							if (global_address[13:12] == i[1:0]) begin
								weight_chip_enable[i] <= 1; 
								weight_write_enable[i] <= 1;
								weight_address[i] <= global_address[11:0];
								weight_data[i] <= raw_input;
								`ifdef DEBUG
								if (row == `DEBUG_TARGET_ROW) begin
									$display("[C%0d][LOAD_W_TARGET] row=%0d group=%0d bank=%0d gaddr=%0d sram=%0d laddr=%0d weight_raw=0x%02h signed=%0d",
											dbg_cycle, row, group, bank,
											global_address, global_address[13:12], global_address[11:0],
											raw_input, $signed(raw_input));
								end
								`endif
							end
						end

						if (bank == 2'd3) begin
							if (group != 4'd11) group <= group + 4'd1;
							else begin 
								group <= 4'd0;
								row <= row + 8'd1;
							end
						end
						bank <= bank + 2'd1; // cycle back to 2'd0 after bank == 2'd3
					end
				end
				S_READ_POSITION: begin
					if (w_input_valid) begin
						global_address = ({6'd0, row}  << 5) + ({6'd0, row}  << 4)
										+ ({12'd0, bank} << 3) + ({12'd0, bank} << 2)
										+ {10'd0, group};  // 48 * row + 12 * bank + group
						for (i = 0; i < 3; i = i + 1) begin
							if (global_address[13:12] == i[1:0]) begin
								position_chip_enable[i] <= 1; 
								position_write_enable[i] <= 1;
								position_address[i] <= global_address[11:0];
								position_data[i] <= {bank, raw_input[5:0]};
								`ifdef DEBUG
								if (row == `DEBUG_TARGET_ROW) begin
									$display("[C%0d][LOAD_P_TARGET] row=%0d group=%0d bank=%0d gaddr=%0d sram=%0d laddr=%0d raw_pos=%0d full_col=%0d",
											dbg_cycle, row, group, bank,
											global_address, global_address[13:12], global_address[11:0],
											raw_input[5:0], {bank, raw_input[5:0]});
								end
								`endif
							end
						end
						
						if (bank == 2'd3) begin
							if (group != 4'd11) group <= group + 4'd1;
							else begin 
								group <= 4'd0;
								row <= row + 8'd1;
							end
						end
						bank <= bank + 2'd1; // cycle back to 2'd0 after bank == 2'd3
					end
				end
				S_READ_BIAS: begin
					if (w_input_valid) begin
						bias_chip_enable <= 1; bias_write_enable <= 1;
						bias_address <= row; bias_data <= raw_input;
						row <= row + 8'd1; // cycle back to 8'd0 after bank == 8'd255
						`ifdef DEBUG
						if ((row < 4) || (row >= 8'd252)) begin
							$display("[C%0d][LOAD_B] row=%0d bias_raw=0x%02h signed=%0d",
									dbg_cycle, row, raw_input, $signed(raw_input));
						end
						`endif
					end
				end
				S_START_READ_VECTOR: begin
					load_feature_id <= 4'd0;
					load_elem_id    <= 8'd0;
				end

				S_READ_VECTOR: begin
					if (raw_data_valid) begin
						vector_chip_enable  <= 1;
						vector_write_enable <= 1;

						// 16 vectors × 256 elements
						vector_address <= {load_feature_id, load_elem_id};
						vector_data    <= raw_input;

						if (load_elem_id == 8'd255) begin
							load_elem_id <= 8'd0;
							load_feature_id <= load_feature_id + 4'd1;
						end else begin
							load_elem_id <= load_elem_id + 8'd1;
						end
						`ifdef DEBUG
						if ((load_feature_id < 2 && load_elem_id < 4) ||
							(load_feature_id == 4'd15 && load_elem_id >= 8'd252)) begin
							$display("[C%0d][LOAD_V] feature=%0d elem=%0d vaddr=%0d raw=0x%02h signed=%0d",
									dbg_cycle,
									load_feature_id,
									load_elem_id,
									{load_feature_id, load_elem_id},
									raw_input,
									$signed(raw_input));
						end

						if (load_elem_id == 8'd255) begin
							$display("[C%0d][LOAD_V_DONE] feature %0d finished",
									dbg_cycle, load_feature_id);
						end
						`endif
					end
				end
				S_COMPUTE_INIT: begin
					row           <= 8'd0;
					feature_id    <= 4'd0;
					element_count <= 6'd0;
					acc           <= 22'sd0;
				end

				S_READ_MATRIX_ELEM: begin
					global_address = ({6'd0, row} << 5) +
						({6'd0, row} << 4) +
						{8'd0, element_count};   // 48*row + element_count

					selected_sram <= global_address[13:12];

					for (i = 0; i < 3; i = i + 1) begin
						weight_chip_enable[i]   <= 0;
						weight_write_enable[i]  <= 0;
						position_chip_enable[i] <= 0;
						position_write_enable[i]<= 0;
					end

					for (i = 0; i < 3; i = i + 1) begin
						if (global_address[13:12] == i[1:0]) begin
							weight_chip_enable[i]   <= 1;
							weight_write_enable[i]  <= 0; // read
							weight_address[i]       <= global_address[11:0];

							position_chip_enable[i] <= 1;
							position_write_enable[i]<= 0; // read
							position_address[i]     <= global_address[11:0];
						end
					end

					`ifdef DEBUG
					if (feature_id == `DEBUG_TARGET_FEATURE &&
   						row        == `DEBUG_TARGET_ROW) begin
						$display("[C%0d][MREQ] feature=%0d row=%0d elem=%0d gaddr=%0d sram=%0d laddr=%0d",
								dbg_cycle, feature_id, row, element_count,
								global_address, global_address[13:12], global_address[11:0]);
					end
					`endif
				end

				S_WAIT_MATRIX_ELEM: begin
					// Intentionally empty:
					// give synchronous SRAM one full cycle to update Q
				end

				S_CAPTURE_MATRIX_ELEM: begin
					// SRAM Q is valid now
					weight_hold     <= $signed(weight_output[selected_sram]);
					pos_hold        <= position_output[selected_sram];
					term_gaddr_hold <= global_address;
					term_elem_hold  <= element_count;

					vector_chip_enable  <= 1;
					vector_write_enable <= 0;
					vector_address <= {feature_id, position_output[selected_sram]};

				`ifdef DEBUG
					if (feature_id == `DEBUG_TARGET_FEATURE &&
						row        == `DEBUG_TARGET_ROW) begin
						$strobe("[C%0d][MRET] feature=%0d row=%0d elem=%0d sram=%0d weight=0x%02h(%0d) pos=0x%02h(%0d) -> vector_addr=%0d",
								dbg_cycle, feature_id, row, element_count,
								selected_sram,
								weight_output[selected_sram], $signed(weight_output[selected_sram]),
								position_output[selected_sram], position_output[selected_sram],
								{feature_id, position_output[selected_sram]});
					end
				`endif
				end

				S_READ_VECTOR_ELEM: begin
					// just one wait state for vector SRAM read
				end

				S_WAIT_VECTOR_ELEM: begin
					mult_product <=
						$signed({{8{weight_hold[7]}}, weight_hold}) *
						$signed({{8{vector_output[7]}}, vector_output});
					vec_hold <= $signed(vector_output);

				`ifdef DEBUG
					if (feature_id == `DEBUG_TARGET_FEATURE &&
    					row        == `DEBUG_TARGET_ROW) begin
						$strobe("[C%0d][VRET] feature=%0d row=%0d elem=%0d weight_hold=%0d vector=0x%02h(%0d) product(next)=0x%04h(%0d)",
								dbg_cycle, feature_id, row, element_count,
								weight_hold,
								vector_output, $signed(vector_output),
								$signed({{8{weight_hold[7]}}, weight_hold}) *
								$signed({{8{vector_output[7]}}, vector_output}),
								$signed({{8{weight_hold[7]}}, weight_hold}) *
								$signed({{8{vector_output[7]}}, vector_output}));
					end
				`endif
				end

				S_MAC: begin
					acc <= acc + {{6{mult_product[15]}}, mult_product};
					`ifdef DEBUG
					if (feature_id == `DEBUG_TARGET_FEATURE &&
    					row        == `DEBUG_TARGET_ROW) begin
						$display("[C%0d][MAC] feature=%0d row=%0d elem=%0d mult_product=%0d acc_before=%0d acc_after=%0d",
							dbg_cycle, feature_id, row, element_count,
							mult_product,
							acc,
							acc + {{6{mult_product[15]}}, mult_product});
					end
					`endif
					`ifdef DEBUG
					if (feature_id == `DEBUG_TARGET_FEATURE &&
						row        == `DEBUG_TARGET_ROW) begin
						$display("[C%0d][TERM] feature=%0d row=%0d elem=%0d gaddr=%0d weight=%0d pos=%0d vector_addr=%0d vector=%0d product=%0d acc_before=%0d acc_after=%0d",
								dbg_cycle,
								feature_id,
								row,
								term_elem_hold,
								term_gaddr_hold,
								weight_hold,
								pos_hold,
								{feature_id, pos_hold},
								vec_hold,
								mult_product,
								acc,
								acc + $signed({{6{mult_product[15]}}, mult_product}));
					end
					`endif
					if (element_count != 6'd47)
						element_count <= element_count + 6'd1;
				end

				S_READ_BIAS_FOR_ROW: begin
					bias_chip_enable  <= 1;
					bias_write_enable <= 0;
					bias_address      <= row;
				end

				S_WAIT_BIAS_FOR_ROW: begin
					// Intentionally empty:
					// give synchronous bias SRAM one full cycle to update Q
				end

				S_CAPTURE_BIAS_FOR_ROW: begin
					bias_hold <= $signed(bias_output);

					result_hold <= acc + $signed({{10{bias_output[7]}}, bias_output, 4'b0000});

					output_row <= row;
					output_feature <= feature_id;

				`ifdef DEBUG
					if (feature_id == 4'd0) begin
						$display("[C%0d][ROW_SUMMARY_F0] row=%0d dot=%0d bias_raw=%0d bias_aligned=%0d result=%0d",
								dbg_cycle,
								row,
								acc,
								$signed(bias_output),
								$signed({{10{bias_output[7]}}, bias_output, 4'b0000}),
								acc + $signed({{10{bias_output[7]}}, bias_output, 4'b0000}));
					end

					if ((feature_id == 0 && row < 4) ||
						(feature_id == 4'd15 && row >= 8'd252)) begin
						$display("[C%0d][BIAS] feature=%0d row=%0d acc=%0d bias_raw=0x%02h(%0d) bias_aligned=%0d result=%0d",
								dbg_cycle, feature_id, row,
								acc,
								bias_output, $signed(bias_output),
								$signed({{10{bias_output[7]}}, bias_output, 4'b0000}),
								acc + $signed({{10{bias_output[7]}}, bias_output, 4'b0000}));
					end
				`endif
				end

				S_OUTPUT: begin
					o_result <= result_hold;
					o_valid  <= 1;

					`ifdef DEBUG
					$display("[C%0d][OUT] feature=%0d row=%0d o_result=0x%06h signed=%0d o_valid=1",
							dbg_cycle, output_feature, output_row,
							result_hold, $signed(result_hold));
					`endif

					`ifdef DEBUG_STOP_AFTER_FIRST_VECTOR
					`ifdef DEBUG
					if (output_feature == 4'd0 && output_row == 8'd255) begin
						dbg_stop_pending <= 1'b1;
					end
					`endif
					`endif
					

					// 下一個 row / 下一個 feature
					if (row != 8'd255) begin
						row           <= row + 8'd1;
						element_count <= 6'd0;
						acc           <= 22'sd0;
					end else begin
						row           <= 8'd0;
						element_count <= 6'd0;
						acc           <= 22'sd0;

						if (feature_id != 4'd15)
							feature_id <= feature_id + 4'd1;
					end
				end
			endcase
			state <= next_state;
		end	
	end	
	// next state logic
	always @(*) begin
		next_state = state;
		case (state)
			S_IDLE:
				if (start_init) next_state = S_START_READ_WEIGHT;

			S_START_READ_WEIGHT:
				next_state = S_READ_WEIGHT;

			S_READ_WEIGHT:
				if (w_input_valid &&
					row == 8'd255 && bank == 2'd3 && group == 4'd11)
					next_state = S_START_READ_POSITION;

			S_START_READ_POSITION:
				next_state = S_READ_POSITION;

			S_READ_POSITION:
				if (w_input_valid &&
					row == 8'd255 && bank == 2'd3 && group == 4'd11)
					next_state = S_START_READ_BIAS;

			S_START_READ_BIAS:
				next_state = S_READ_BIAS;

			S_READ_BIAS:
				if (w_input_valid && row == 8'd255)
					next_state = S_START_READ_VECTOR;

			S_START_READ_VECTOR:
				next_state = S_READ_VECTOR;

			// 收滿 16×256 = 4096 個 vector elements 後才能開始 output
			S_READ_VECTOR:
				if (raw_data_valid &&
					load_feature_id == 4'd15 &&
					load_elem_id == 8'd255)
					next_state = S_COMPUTE_INIT;

			S_COMPUTE_INIT:
				next_state = S_READ_MATRIX_ELEM;

			S_READ_MATRIX_ELEM:
				next_state = S_WAIT_MATRIX_ELEM;

			S_WAIT_MATRIX_ELEM:
				next_state = S_CAPTURE_MATRIX_ELEM;

			S_CAPTURE_MATRIX_ELEM:
				next_state = S_READ_VECTOR_ELEM;

			S_READ_VECTOR_ELEM:
				next_state = S_WAIT_VECTOR_ELEM;

			S_WAIT_VECTOR_ELEM:
				next_state = S_MAC;

			S_MAC:
				if (element_count == 6'd47)
					next_state = S_READ_BIAS_FOR_ROW;
				else
					next_state = S_READ_MATRIX_ELEM;

			S_READ_BIAS_FOR_ROW:
				next_state = S_WAIT_BIAS_FOR_ROW;

			S_WAIT_BIAS_FOR_ROW:
				next_state = S_CAPTURE_BIAS_FOR_ROW;

			S_CAPTURE_BIAS_FOR_ROW:
				next_state = S_OUTPUT;

			S_OUTPUT:
				if (row == 8'd255 && feature_id == 4'd15)
					next_state = S_START_READ_VECTOR; // 下一 round 的 16 個 vectors
				else
					next_state = S_READ_MATRIX_ELEM;
		endcase
	end
	// output logic
	always @(*) begin
		raw_data_request = 0;
		ld_w_request = 0;

		case (state)
			S_START_READ_WEIGHT:   ld_w_request = 1;
			S_READ_WEIGHT:         ld_w_request = 1;

			S_START_READ_POSITION: ld_w_request = 1;
			S_READ_POSITION:       ld_w_request = 1;

			S_START_READ_BIAS:     ld_w_request = 1;
			S_READ_BIAS:           ld_w_request = 1;

			S_START_READ_VECTOR: raw_data_request = 1;
			S_READ_VECTOR:       raw_data_request = 1;
		endcase
	end

endmodule