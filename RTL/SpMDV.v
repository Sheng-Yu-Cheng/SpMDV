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
	// localparam S_READ_WEIGHT_START = 24'd;
	localparam S_READ_WEIGHT = 24'd1;
	// localparam S_READ_POSITION_START = 24'd;
	localparam S_READ_POSITION = 24'd2;
	// localparam S_READ_BIAS_START = 24'd;
	localparam S_READ_BIAS = 24'd3;
	// localparam S_IDLE = 24'd;
	// localparam S_IDLE = 24'd;
	// localparam S_IDLE = 24'd;
	// localparam S_IDLE = 24'd;
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

	reg [7:0] row, col;
	reg [11:0] count; reg[1:0]split;

	// reg weight0_chip_enable, weight0_write_enable; 
	// reg [11:0]weight0_address; reg [7:0]weight0_data; wire [7:0]weight0_output; 
	// sram_4096x8 _weight0(.CLK(clk), .CEN(~weight0_chip_enable), .WEN(~weight0_write_enable), .A(weight0_address), .D(weight0_data), .Q(weight0_output));
	// reg weight1_chip_enable, weight1_write_enable;
	// reg [11:0]weight1_address; reg [7:0]weight1_data; wire [7:0]weight1_output; 
	// sram_4096x8 _weight1(.CLK(clk), .CEN(~weight1_chip_enable), .WEN(~weight1_write_enable), .A(weight1_address), .D(weight1_data), .Q(weight1_output));
	// reg weight2_chip_enable, weight2_write_enable; 
	// reg [11:0]weight2_address; reg [7:0]weight2_data;wire [7:0]weight2_output; 
	// sram_4096x8 _weight2(.CLK(clk), .CEN(~weight2_chip_enable), .WEN(~weight2_write_enable), .A(weight2_address), .D(weight2_data), .Q(weight2_output));
	// reg position0_chip_enable, position0_write_enable; 
	// reg [11:0]position0_address; reg [7:0]position0_data; wire [7:0]position0_output; 
	// sram_4096x8 _position0(.CLK(clk), .CEN(~position0_chip_enable), .WEN(~position0_write_enable), .A(position0_address), .D(position0_data), .Q(position0_output));
	// reg position1_chip_enable, position1_write_enable; 
	// reg [11:0]position1_address; reg [7:0]position1_data; wire [7:0]position1_output; 
	// sram_4096x8 _position1(.CLK(clk), .CEN(~position1_chip_enable), .WEN(~position1_write_enable), .A(position1_address), .D(position1_data), .Q(position1_output));
	// reg position2_chip_enable, position2_write_enable; 
	// reg [11:0]position2_address; reg [7:0]position2_data; wire [7:0]position2_output; 
	// sram_4096x8 _position2(.CLK(clk), .CEN(~position2_chip_enable), .WEN(~position2_write_enable), .A(position2_address), .D(position2_data), .Q(position2_output));
	// reg bais_chip_enable, bias_write_enable; 
	// reg [7:0]bias_address; reg [7:0]bias_data; wire [7:0]bias_output; 
	// sram_256x8 _bias(.CLK(clk), .CEN(~bias_chip_enable), .WEN(~bias_write_enable), .A(bias_address), .D(bias_data), .Q(bias_output))
	
	integer i;
	// state logic
	always @(posedge clk or posedge rst) begin
		$display("state=%0d next_state=%0d split=%0d count=%0d", state, next_state, split, count);
		if (rst) begin
			state <= S_IDLE;
			split <= 2'd0; count <= 12'd0;  
		end	else begin
			case (state) 
				S_IDLE: begin
					split <= 2'd0; count <= 12'd0; 
				end
				S_READ_WEIGHT: begin
					for (i = 0; i < 3; i = i + 1) begin
						weight_chip_enable[i] <= 0; weight_write_enable[i] <= 0;
					end
					for (i = 0; i < 3; i = i + 1) begin
						if (split == i) begin
							weight_chip_enable[i] <= 1; weight_write_enable[i] <= 1;
							weight_address[i] <= count; weight_data[i] <= raw_input;
						end					
					end
					if (count != 12'd4095) begin
						count <= count + 12'd1; 
					end else begin
						count <= 12'd0;
						split <= split + 2'd1;
					end
				end
				S_READ_WEIGHT: begin
					for (i = 0; i < 3; i = i + 1) begin
						position_chip_enable[i] <= 0; position_write_enable[i] <= 0;
					end
					for (i = 0; i < 3; i = i + 1) begin
						if (split == i) begin
							position_chip_enable[i] <= 1; position_write_enable[i] <= 1;
							position_address[i] <= count; position_data[i] <= raw_input;
						end					
					end
					if (count != 12'd4095) begin
						count <= count + 12'd1; 
					end else begin
						count <= 12'd0;
						split <= split + 2'd1;
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
			S_IDLE: if (start_init) next_state = S_READ_WEIGHT;
			S_READ_WEIGHT: if (state == 2'd2 && count == 12'd4095) next_state = S_READ_POSITION;
			S_READ_POSITION: if (state == 2'd2 && count == 12'd4095) next_state = S_READ_BIAS;
		endcase
	end
	// output logic
	always @(*) begin
		raw_data_request = 0;
		ld_w_request = 0;
		o_result = 22'd0;
		o_valid = 0;
		case (state)
			S_READ_WEIGHT: ld_w_request = 1;
			S_READ_POSITION: ld_w_request = 1;

		endcase
	end

endmodule