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
	localparam S_IDLE = 24'd0;
	localparam S_START_READ = 24'd1;
	localparam S_READ_WEIGHT = 24'd2;
	localparam S_READ_POSITION = 24'd3;
	localparam S_READ_BIAS = 24'd4;
	localparam S_START_READ_ELEMENT = 24'd5;
	localparam S_READ_ELEMENT = 24'd6;
	// localparam S_IDLE = 24'd;


	reg weight_chip_enable[2:0]; reg weight_write_enable[2:0]; 
	reg [11:0]weight_address[2:0]; reg [7:0]weight_data[2:0]; wire [7:0]weight_output[2:0];
	reg position_chip_enable[2:0]; reg position_write_enable[2:0]; 
	reg [11:0]position_address[2:0]; reg [7:0]position_data[2:0]; wire [7:0]position_output[2:0];
	reg bias_chip_enable, bias_write_enable; 
	reg [7:0]bias_address; reg [7:0]bias_data; wire [7:0]bias_output; 
	genvar _;
	generate
		for (_ = 0; _ < 3; _ = _ + 1) begin : GEN_SRAM
			sram_4096x8 _weight(.CLK(clk), .CEN(~weight_chip_enable[_]), .WEN(~weight_write_enable[_]), .A(weight_address[_]), .D(weight_data[_]), .Q(weight_output[_]));
			sram_4096x8 _position(.CLK(clk), .CEN(~position_chip_enable[_]), .WEN(~position_write_enable[_]), .A(position_address[_]), .D(position_data[_]), .Q(position_output[_]));
		end
		sram_256x8 _bias(.CLK(clk), .CEN(~bias_chip_enable), .WEN(~bias_write_enable), .A(bias_address), .D(bias_data), .Q(bias_output));
	endgenerate;

	reg [7:0]row, col; reg [1:0] bank;
	reg [11:0] count; reg [1:0] split;

	reg [8:0] element;

	reg [21:0] product; 


	integer i;
	// state logic
	always @(posedge clk or posedge rst) begin
		$display("state=%0d next_state=%0d split=%0d count=%0d raw_input=%d w_input_valid=%b", state, next_state, split, count, raw_input, w_input_valid);
		if (rst) begin
			state <= S_IDLE;
			split <= 2'd0; count <= 12'd0;  row <= 8'd0; col <= 8'd0; bank <= 2'd0;
		end	else begin
			case (state) 
				S_IDLE: begin
					split <= 2'd0; count <= 12'd0; row <= 8'b0; col <= 8'd0; bank <= 2'd0;
				end
				S_START_READ: begin
				
				end
				S_READ_WEIGHT: begin
					for (i = 0; i < 3; i = i + 1) begin
						weight_chip_enable[i] <= 0; weight_write_enable[i] <= 0;
					end
					for (i = 0; i < 3; i = i + 1) begin
						if (split == i) begin
							weight_chip_enable[i] <= 1; weight_write_enable[i] <= 1;
							weight_address[i] <= count; weight_data[i] <= raw_input;
							$display("Read value=%0d", raw_input);
						end					
					end
					if (count == 12'd4095) begin
						if (split != 2'd2) split <= split + 2'd1;
						else split <= 2'd0;		
					end
					count <= count + 12'd1; // cycle back to 12'd0 after count == 12'd4095
				end
				S_READ_POSITION: begin
					for (i = 0; i < 3; i = i + 1) begin
						position_chip_enable[i] <= 0; position_write_enable[i] <= 0;
					end
					for (i = 0; i < 3; i = i + 1) begin
						if (split == i) begin
							position_chip_enable[i] <= 1; position_write_enable[i] <= 1;
							position_address[i] <= count; position_data[i] <= {bank, raw_input[5:0]};
							$display("Read position=%0d Bank=%0d Column=%0d", raw_input, bank, {bank, raw_input[5:0]});
						end					
					end
					if (col == 8'd255) bank <= bank + 2'd1; // cycle back to 2'd0 after bank == 2'd3
					col <= col + 1; // cycle back to 8'd0 after bank == 8'd255
					if (count == 12'd4095) begin
						if (split != 2'd2) split <= split + 2'd1;
						else split <= 2'd0;		
					end
					count <= count + 12'd1; // cycle back to 12'd0 after count == 12'd4095
				end
				S_READ_BIAS: begin
					bias_chip_enable <= 1; bias_write_enable <= 1;
					bias_address <= row; bias_data <= raw_input;
					row <= row + 8'd1; // cycle back to 8'd0 after bank == 8'd255
					$display("Read bias=%0d", raw_input);
				end
				S_START_READ_ELEMENT: begin
					
				end
				S_READ_ELEMENT: begin
					element <= raw_input;
					$display("Read element=%0d", element);
				end
			endcase
			state <= next_state;
		end	
	end	
	// next state logic
	always @(*) begin
		next_state = state;
		case (state)
			S_IDLE: if (start_init) next_state = S_START_READ;
			S_START_READ: next_state = S_READ_WEIGHT;
			S_READ_WEIGHT: if (split == 2'd2 && count == 12'd4095) next_state = S_READ_POSITION;
			S_READ_POSITION: if (split == 2'd2 && count == 12'd4095) next_state = S_READ_BIAS;
			S_READ_BIAS: if (row == 12'd255) next_state = S_START_READ_ELEMENT;
			S_START_READ_ELEMENT: next_state = S_READ_ELEMENT;
		endcase
	end
	// output logic
	always @(*) begin
		raw_data_request = 0;
		ld_w_request = 0;
		o_result = 22'd0;
		o_valid = 0;
		case (state)
			S_START_READ: ld_w_request = 1;
			S_READ_WEIGHT: ld_w_request = 1;
			S_READ_POSITION: ld_w_request = 1;
			S_READ_BIAS: ld_w_request = 1;
			S_START_READ_ELEMENT: raw_data_request = 1;
		endcase
	end

endmodule