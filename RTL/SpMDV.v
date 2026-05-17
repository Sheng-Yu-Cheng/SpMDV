module SpMDV 
(
    input clk,
    input rst,

    // Input signals
    input start_init,
    input [7:0] raw_input,
    input raw_data_valid,
    input w_input_valid,

    // Output signals
    output reg raw_data_request,
    output reg ld_w_request,
    output reg [21:0] o_result,
    output reg o_valid
);
    reg [10:0]a, b;
    reg [21:0]c;
    always @(*) begin
        c = a * b;
    end
endmodule

// module SpMDV 
// (
//     input clk,
//     input rst,

//     // Input signals
//     input start_init,
//     input [7:0] raw_input,
//     input raw_data_valid,
//     input w_input_valid,

//     // Output signals
//     output reg raw_data_request,
//     output reg ld_w_request,
//     output reg [21:0] o_result,
//     output reg o_valid
// );

//     reg [23:0] state, next_state;

//     localparam S_IDLE                  = 24'd0;
//     localparam S_LOAD_INIT             = 24'd1;
//     localparam S_START_READ_VECTOR     = 24'd2;
//     localparam S_READ_VECTOR           = 24'd3;
//     localparam S_COMPUTE_INIT          = 24'd4;
//     localparam S_COMPUTE_ROW           = 24'd5;
//     localparam S_READ_BIAS_FOR_ROW     = 24'd6;
//     localparam S_WAIT_BIAS_FOR_ROW     = 24'd7;
//     localparam S_CAPTURE_BIAS_FOR_ROW  = 24'd8;
//     localparam S_OUTPUT                = 24'd9;

//     // SRAM signals
//     reg weight_chip_enable[2:0];
//     reg weight_write_enable[2:0];
//     reg [11:0] weight_address[2:0];
//     reg [7:0] weight_data[2:0];
//     wire [7:0] weight_output[2:0];

//     reg position_chip_enable[2:0];
//     reg position_write_enable[2:0];
//     reg [11:0] position_address[2:0];
//     reg [7:0] position_data[2:0];
//     wire [7:0] position_output[2:0];

//     reg bias_chip_enable, bias_write_enable;
//     reg [7:0] bias_address;
//     reg [7:0] bias_data;
//     wire [7:0] bias_output;

//     reg vector_chip_enable, vector_write_enable;
//     reg [11:0] vector_address;
//     reg [7:0] vector_data;
//     wire [7:0] vector_output;

//     genvar gi;
//     generate
//         for (gi = 0; gi < 3; gi = gi + 1) begin : GEN_SRAM
//             sram_4096x8 _weight(
//                 .CLK(clk),
//                 .CEN(~weight_chip_enable[gi]),
//                 .WEN(~weight_write_enable[gi]),
//                 .A(weight_address[gi]),
//                 .D(weight_data[gi]),
//                 .Q(weight_output[gi])
//             );

//             sram_4096x8 _position(
//                 .CLK(clk),
//                 .CEN(~position_chip_enable[gi]),
//                 .WEN(~position_write_enable[gi]),
//                 .A(position_address[gi]),
//                 .D(position_data[gi]),
//                 .Q(position_output[gi])
//             );
//         end

//         sram_256x8 _bias(
//             .CLK(clk),
//             .CEN(~bias_chip_enable),
//             .WEN(~bias_write_enable),
//             .A(bias_address),
//             .D(bias_data),
//             .Q(bias_output)
//         );

//         sram_4096x8 _vector(
//             .CLK(clk),
//             .CEN(~vector_chip_enable),
//             .WEN(~vector_write_enable),
//             .A(vector_address),
//             .D(vector_data),
//             .Q(vector_output)
//         );
//     endgenerate

//     reg [7:0] row;                 // 0 ~ 255
//     reg [3:0] group;               // 0 ~ 11
//     reg [1:0] bank;                // 0 ~ 3
//     reg [13:0] global_address;     // 0 ~ 12287

//     reg [5:0] element_count;       // 0 ~ 47

//     reg signed [15:0] mult_product; // S4.11
//     reg signed [21:0] acc;          // S10.11
//     reg signed [21:0] result_hold;  // S10.11
//     reg signed [7:0]  weight_hold;

//     reg [3:0] feature_id;
//     reg [3:0] load_feature_id;
//     reg [7:0] load_elem_id;

//     reg [1:0] selected_sram;
//     reg [14:0] init_count;         // 0 ~ 24831

//     // Pipelined 1-MAC compute control.
//     // The SRAM models used in this project need one bubble cycle after a read
//     // request before Q is valid.  Therefore both the matrix SRAM read and the
//     // vector SRAM read use 2-deep valid/metadata pipelines.
//     reg [5:0] issue_count;         // issued matrix elements, 0 ~ 48
//     reg [5:0] mac_count;           // accumulated products, 0 ~ 48

//     reg       mat_valid_1;
//     reg       mat_valid_2;
//     reg [1:0] mat_sram_1;
//     reg [1:0] mat_sram_2;

//     reg       vec_valid_1;
//     reg       vec_valid_2;
//     reg signed [7:0] vec_weight_1;
//     reg signed [7:0] vec_weight_2;

//     reg       prod_valid;
//     reg signed [15:0] product_pipe;

//     integer i;

//     // Sequential logic
//     always @(posedge clk or posedge rst) begin
//         if (rst) begin
//             state <= S_IDLE;
//         end else begin
//             // Default SRAM controls
//             for (i = 0; i < 3; i = i + 1) begin
//                 weight_chip_enable[i]    <= 0;
//                 weight_write_enable[i]   <= 0;
//                 position_chip_enable[i]  <= 0;
//                 position_write_enable[i] <= 0;
//             end

//             bias_chip_enable    <= 0;
//             bias_write_enable   <= 0;
//             vector_chip_enable  <= 0;
//             vector_write_enable <= 0;
//             o_valid <= 1'b0;

//             case (state)
//                 S_IDLE: begin
//                     row <= 8'd0;
//                     bank <= 2'd0;
//                     group <= 4'd0;

//                     feature_id <= 4'd0;
//                     load_feature_id <= 4'd0;
//                     load_elem_id <= 8'd0;
//                     element_count <= 6'd0;

//                     mult_product <= 16'sd0;
//                     acc <= 22'sd0;
//                     result_hold <= 22'sd0;
//                     weight_hold <= 8'sd0;

//                     issue_count <= 6'd0;
//                     mac_count   <= 6'd0;
//                     mat_valid_1 <= 1'b0;
//                     mat_valid_2 <= 1'b0;
//                     mat_sram_1  <= 2'd0;
//                     mat_sram_2  <= 2'd0;
//                     vec_valid_1 <= 1'b0;
//                     vec_valid_2 <= 1'b0;
//                     vec_weight_1 <= 8'sd0;
//                     vec_weight_2 <= 8'sd0;
//                     prod_valid  <= 1'b0;
//                     product_pipe <= 16'sd0;

//                     o_result <= 22'd0;
//                     o_valid <= 1'b0;

//                     init_count <= 15'd0;
//                 end

//                 S_LOAD_INIT: begin
//                     if (w_input_valid) begin
//                         // 0 ~ 12287: weight stream
//                         if (init_count < 15'd12288) begin
//                             global_address =
//                                 ({6'd0, row} << 5) +
//                                 ({6'd0, row} << 4) +
//                                 ({12'd0, bank} << 3) +
//                                 ({12'd0, bank} << 2) +
//                                 {10'd0, group};

//                             for (i = 0; i < 3; i = i + 1) begin
//                                 if (global_address[13:12] == i[1:0]) begin
//                                     weight_chip_enable[i]  <= 1;
//                                     weight_write_enable[i] <= 1;
//                                     weight_address[i]      <= global_address[11:0];
//                                     weight_data[i]         <= raw_input;
//                                 end
//                             end

//                             if (bank == 2'd3) begin
//                                 if (group != 4'd11) begin
//                                     group <= group + 4'd1;
//                                 end else begin
//                                     group <= 4'd0;
//                                     row   <= row + 8'd1;
//                                 end
//                             end
//                             bank <= bank + 2'd1;
//                         end

//                         // 12288 ~ 24575: position stream
//                         else if (init_count < 15'd24576) begin
//                             global_address =
//                                 ({6'd0, row} << 5) +
//                                 ({6'd0, row} << 4) +
//                                 ({12'd0, bank} << 3) +
//                                 ({12'd0, bank} << 2) +
//                                 {10'd0, group};

//                             for (i = 0; i < 3; i = i + 1) begin
//                                 if (global_address[13:12] == i[1:0]) begin
//                                     position_chip_enable[i]  <= 1;
//                                     position_write_enable[i] <= 1;
//                                     position_address[i]      <= global_address[11:0];
//                                     position_data[i]         <= {bank, raw_input[5:0]};
//                                 end
//                             end

//                             if (bank == 2'd3) begin
//                                 if (group != 4'd11) begin
//                                     group <= group + 4'd1;
//                                 end else begin
//                                     group <= 4'd0;
//                                     row   <= row + 8'd1;
//                                 end
//                             end
//                             bank <= bank + 2'd1;
//                         end

//                         // 24576 ~ 24831: bias stream
//                         else begin
//                             bias_chip_enable  <= 1;
//                             bias_write_enable <= 1;
//                             bias_address      <= row;
//                             bias_data         <= raw_input;
//                             row <= row + 8'd1;
//                         end

//                         init_count <= init_count + 15'd1;
//                     end
//                 end

//                 S_START_READ_VECTOR: begin
//                     // A new batch of 16 dense vectors is going to overwrite
//                     // the vector SRAM addresses {feature, element}.
//                     // Reset compute indices here.  S_COMPUTE_INIT is now used
//                     // before every row, so feature_id must NOT be reset there;
//                     // otherwise every row would recompute feature 0.  But when
//                     // the previous 16 features are finished and the testbench
//                     // sends the next 16 dense vectors, we must restart from
//                     // token/feature 0 for this new vector batch.
//                     row             <= 8'd0;
//                     feature_id      <= 4'd0;
//                     load_feature_id <= 4'd0;
//                     load_elem_id    <= 8'd0;
//                 end

//                 S_READ_VECTOR: begin
//                     if (raw_data_valid) begin
//                         vector_chip_enable  <= 1;
//                         vector_write_enable <= 1;
//                         vector_address <= {load_feature_id, load_elem_id};
//                         vector_data    <= raw_input;

//                         if (load_elem_id == 8'd255) begin
//                             load_elem_id <= 8'd0;
//                             load_feature_id <= load_feature_id + 4'd1;
//                         end else begin
//                             load_elem_id <= load_elem_id + 8'd1;
//                         end
//                     end
//                 end

//                 S_COMPUTE_INIT: begin
//                     // This state is intentionally one cycle.  It clears all
//                     // pipeline valids before starting a new output row.
//                     element_count <= 6'd0;
//                     issue_count   <= 6'd0;
//                     mac_count     <= 6'd0;
//                     acc           <= 22'sd0;

//                     mat_valid_1   <= 1'b0;
//                     mat_valid_2   <= 1'b0;
//                     mat_sram_1    <= 2'd0;
//                     mat_sram_2    <= 2'd0;

//                     vec_valid_1   <= 1'b0;
//                     vec_valid_2   <= 1'b0;
//                     vec_weight_1  <= 8'sd0;
//                     vec_weight_2  <= 8'sd0;

//                     prod_valid    <= 1'b0;
//                     product_pipe  <= 16'sd0;
//                     mult_product  <= 16'sd0;
//                 end

//                 S_COMPUTE_ROW: begin
//                     // =====================================================
//                     // Stage 4: accumulate the registered product.
//                     // The last product is accumulated on the same edge that
//                     // leaves S_COMPUTE_ROW for S_READ_BIAS_FOR_ROW.
//                     // =====================================================
//                     if (prod_valid) begin
//                         acc       <= acc + {{6{product_pipe[15]}}, product_pipe};
//                         mac_count <= mac_count + 6'd1;
//                     end

//                     // =====================================================
//                     // Stage 3: vector SRAM Q is valid after one bubble cycle.
//                     // Register the multiplier output to avoid putting
//                     // multiplier + adder in the same cycle.
//                     // =====================================================
//                     prod_valid <= vec_valid_2;
//                     if (vec_valid_2) begin
//                         product_pipe <=
//                             $signed({{8{vec_weight_2[7]}}, vec_weight_2}) *
//                             $signed({{8{vector_output[7]}}, vector_output});
//                     end

//                     // =====================================================
//                     // Stage 2: matrix SRAM Q is valid after one bubble cycle.
//                     // Use the position to issue the vector SRAM read.
//                     // =====================================================
//                     vec_valid_2  <= vec_valid_1;
//                     vec_weight_2 <= vec_weight_1;

//                     vec_valid_1 <= mat_valid_2;
//                     if (mat_valid_2) begin
//                         vec_weight_1 <= $signed(weight_output[mat_sram_2]);

//                         vector_chip_enable  <= 1'b1;
//                         vector_write_enable <= 1'b0;
//                         vector_address      <= {feature_id, position_output[mat_sram_2]};
//                     end

//                     // =====================================================
//                     // Stage 1: shift the matrix-read pipeline.
//                     // mat_valid_2 is the valid that will be captured next
//                     // cycle, i.e. one bubble cycle after the SRAM read issue.
//                     // =====================================================
//                     mat_valid_2 <= mat_valid_1;
//                     mat_sram_2  <= mat_sram_1;

//                     // =====================================================
//                     // Stage 0: issue one matrix weight/position SRAM read.
//                     // This can run every cycle until all 48 NZV are issued.
//                     // =====================================================
//                     if (issue_count < 6'd48) begin
//                         global_address =
//                             ({6'd0, row} << 5) +
//                             ({6'd0, row} << 4) +
//                             {8'd0, issue_count};

//                         selected_sram <= global_address[13:12];
//                         mat_valid_1   <= 1'b1;
//                         mat_sram_1    <= global_address[13:12];
//                         issue_count   <= issue_count + 6'd1;
//                         element_count <= issue_count;

//                         for (i = 0; i < 3; i = i + 1) begin
//                             if (global_address[13:12] == i[1:0]) begin
//                                 weight_chip_enable[i]    <= 1'b1;
//                                 weight_write_enable[i]   <= 1'b0;
//                                 weight_address[i]        <= global_address[11:0];

//                                 position_chip_enable[i]  <= 1'b1;
//                                 position_write_enable[i] <= 1'b0;
//                                 position_address[i]      <= global_address[11:0];
//                             end
//                         end
//                     end else begin
//                         mat_valid_1 <= 1'b0;
//                     end
//                 end

//                 S_READ_BIAS_FOR_ROW: begin
//                     bias_chip_enable  <= 1;
//                     bias_write_enable <= 0;
//                     bias_address      <= row;
//                 end

//                 S_WAIT_BIAS_FOR_ROW: begin
//                     // Wait one cycle for synchronous SRAM read
//                 end

//                 S_CAPTURE_BIAS_FOR_ROW: begin
//                     result_hold <=
//                         acc + $signed({{10{bias_output[7]}}, bias_output, 4'b0000});
//                 end

//                 S_OUTPUT: begin
//                     o_result <= result_hold;
//                     o_valid  <= 1;

//                     if (row != 8'd255) begin
//                         row           <= row + 8'd1;
//                         element_count <= 6'd0;
//                         acc           <= 22'sd0;
//                     end else begin
//                         row           <= 8'd0;
//                         element_count <= 6'd0;
//                         acc           <= 22'sd0;

//                         if (feature_id != 4'd15)
//                             feature_id <= feature_id + 4'd1;
//                     end
//                 end
//             endcase

//             state <= next_state;
//         end
//     end

//     // Next-state logic
//     always @(*) begin
//         next_state = state;

//         case (state)
//             S_IDLE:
//                 if (start_init)
//                     next_state = S_LOAD_INIT;

//             S_LOAD_INIT:
//                 if (w_input_valid && init_count == 15'd24831)
//                     next_state = S_START_READ_VECTOR;

//             S_START_READ_VECTOR:
//                 next_state = S_READ_VECTOR;

//             S_READ_VECTOR:
//                 if (raw_data_valid &&
//                     load_feature_id == 4'd15 &&
//                     load_elem_id == 8'd255)
//                     next_state = S_COMPUTE_INIT;

//             S_COMPUTE_INIT:
//                 next_state = S_COMPUTE_ROW;

//             S_COMPUTE_ROW:
//                 if (prod_valid && mac_count == 6'd47)
//                     next_state = S_READ_BIAS_FOR_ROW;
//                 else
//                     next_state = S_COMPUTE_ROW;

//             S_READ_BIAS_FOR_ROW:
//                 next_state = S_WAIT_BIAS_FOR_ROW;

//             S_WAIT_BIAS_FOR_ROW:
//                 next_state = S_CAPTURE_BIAS_FOR_ROW;

//             S_CAPTURE_BIAS_FOR_ROW:
//                 next_state = S_OUTPUT;

//             S_OUTPUT:
//                 if (row == 8'd255 && feature_id == 4'd15)
//                     next_state = S_START_READ_VECTOR;
//                 else
//                     next_state = S_COMPUTE_INIT;
//         endcase
//     end

//     // Request logic
//     always @(*) begin
//         raw_data_request = 0;
//         ld_w_request = 0;

//         case (state)
//             S_LOAD_INIT: begin
//                 ld_w_request = 1;
//             end

//             S_START_READ_VECTOR: begin
//                 raw_data_request = 1;
//             end

//             S_READ_VECTOR: begin
//                 if (!(load_feature_id == 4'd15 && load_elem_id == 8'd255))
//                     raw_data_request = 1;
//             end
//         endcase
//     end

// endmodule