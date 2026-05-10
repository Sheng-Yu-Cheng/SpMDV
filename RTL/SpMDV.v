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
	logic [3:0]a;
	// state logic
	always @(posedge clk or posedge rst) begin
		
	end	
	// next state logic
	always @(*) begin
		
	end
	// output logic
	always @(*) begin
		
	end

endmodule