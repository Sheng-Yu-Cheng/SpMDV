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

    reg [23:0] state, next_state;

    localparam S_IDLE                  = 24'd0;
    localparam S_LOAD_INIT             = 24'd1;
    localparam S_START_READ_VECTOR     = 24'd2;
    localparam S_READ_VECTOR           = 24'd3;
    localparam S_COMPUTE_INIT          = 24'd4;
    localparam S_READ_MATRIX_ELEM      = 24'd5;
    localparam S_WAIT_MATRIX_ELEM      = 24'd6;
    localparam S_READ_VECTOR_ELEM      = 24'd7;
    localparam S_WAIT_VECTOR_ELEM      = 24'd8;
    localparam S_MAC                   = 24'd9;
    localparam S_READ_BIAS_FOR_ROW     = 24'd10;
    localparam S_WAIT_BIAS_FOR_ROW     = 24'd11;
    localparam S_OUTPUT                = 24'd12;
    localparam S_CAPTURE_MATRIX_ELEM   = 24'd13;
    localparam S_CAPTURE_BIAS_FOR_ROW  = 24'd14;

    // SRAM signals
    reg weight_chip_enable[2:0];
    reg weight_write_enable[2:0];
    reg [11:0] weight_address[2:0];
    reg [7:0] weight_data[2:0];
    wire [7:0] weight_output[2:0];

    reg position_chip_enable[2:0];
    reg position_write_enable[2:0];
    reg [11:0] position_address[2:0];
    reg [7:0] position_data[2:0];
    wire [7:0] position_output[2:0];

    reg bias_chip_enable, bias_write_enable;
    reg [7:0] bias_address;
    reg [7:0] bias_data;
    wire [7:0] bias_output;

    reg vector_chip_enable, vector_write_enable;
    reg [11:0] vector_address;
    reg [7:0] vector_data;
    wire [7:0] vector_output;

    genvar gi;
    generate
        for (gi = 0; gi < 3; gi = gi + 1) begin : GEN_SRAM
            sram_4096x8 _weight(
                .CLK(clk),
                .CEN(~weight_chip_enable[gi]),
                .WEN(~weight_write_enable[gi]),
                .A(weight_address[gi]),
                .D(weight_data[gi]),
                .Q(weight_output[gi])
            );

            sram_4096x8 _position(
                .CLK(clk),
                .CEN(~position_chip_enable[gi]),
                .WEN(~position_write_enable[gi]),
                .A(position_address[gi]),
                .D(position_data[gi]),
                .Q(position_output[gi])
            );
        end

        sram_256x8 _bias(
            .CLK(clk),
            .CEN(~bias_chip_enable),
            .WEN(~bias_write_enable),
            .A(bias_address),
            .D(bias_data),
            .Q(bias_output)
        );

        sram_4096x8 _vector(
            .CLK(clk),
            .CEN(~vector_chip_enable),
            .WEN(~vector_write_enable),
            .A(vector_address),
            .D(vector_data),
            .Q(vector_output)
        );
    endgenerate

    reg [7:0] row;                 // 0 ~ 255
    reg [3:0] group;               // 0 ~ 11
    reg [1:0] bank;                // 0 ~ 3
    reg [13:0] global_address;     // 0 ~ 12287

    reg [5:0] element_count;       // 0 ~ 47

    reg signed [15:0] mult_product; // S4.11
    reg signed [21:0] acc;          // S10.11
    reg signed [21:0] result_hold;  // S10.11
    reg signed [7:0]  weight_hold;

    reg [3:0] feature_id;
    reg [3:0] load_feature_id;
    reg [7:0] load_elem_id;

    reg [1:0] selected_sram;
    reg [14:0] init_count;         // 0 ~ 24831

    integer i;

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_IDLE;
        end else begin
            // Default SRAM controls
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

            case (state)
                S_IDLE: begin
                    row <= 8'd0;
                    bank <= 2'd0;
                    group <= 4'd0;

                    feature_id <= 4'd0;
                    load_feature_id <= 4'd0;
                    load_elem_id <= 8'd0;
                    element_count <= 6'd0;

                    mult_product <= 16'sd0;
                    acc <= 22'sd0;
                    result_hold <= 22'sd0;
                    weight_hold <= 8'sd0;

                    o_result <= 22'd0;
                    o_valid <= 1'b0;

                    init_count <= 15'd0;
                end

                S_LOAD_INIT: begin
                    if (w_input_valid) begin
                        // 0 ~ 12287: weight stream
                        if (init_count < 15'd12288) begin
                            global_address =
                                ({6'd0, row} << 5) +
                                ({6'd0, row} << 4) +
                                ({12'd0, bank} << 3) +
                                ({12'd0, bank} << 2) +
                                {10'd0, group};

                            for (i = 0; i < 3; i = i + 1) begin
                                if (global_address[13:12] == i[1:0]) begin
                                    weight_chip_enable[i]  <= 1;
                                    weight_write_enable[i] <= 1;
                                    weight_address[i]      <= global_address[11:0];
                                    weight_data[i]         <= raw_input;
                                end
                            end

                            if (bank == 2'd3) begin
                                if (group != 4'd11) begin
                                    group <= group + 4'd1;
                                end else begin
                                    group <= 4'd0;
                                    row   <= row + 8'd1;
                                end
                            end
                            bank <= bank + 2'd1;
                        end

                        // 12288 ~ 24575: position stream
                        else if (init_count < 15'd24576) begin
                            global_address =
                                ({6'd0, row} << 5) +
                                ({6'd0, row} << 4) +
                                ({12'd0, bank} << 3) +
                                ({12'd0, bank} << 2) +
                                {10'd0, group};

                            for (i = 0; i < 3; i = i + 1) begin
                                if (global_address[13:12] == i[1:0]) begin
                                    position_chip_enable[i]  <= 1;
                                    position_write_enable[i] <= 1;
                                    position_address[i]      <= global_address[11:0];
                                    position_data[i]         <= {bank, raw_input[5:0]};
                                end
                            end

                            if (bank == 2'd3) begin
                                if (group != 4'd11) begin
                                    group <= group + 4'd1;
                                end else begin
                                    group <= 4'd0;
                                    row   <= row + 8'd1;
                                end
                            end
                            bank <= bank + 2'd1;
                        end

                        // 24576 ~ 24831: bias stream
                        else begin
                            bias_chip_enable  <= 1;
                            bias_write_enable <= 1;
                            bias_address      <= row;
                            bias_data         <= raw_input;
                            row <= row + 8'd1;
                        end

                        init_count <= init_count + 15'd1;
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
                        vector_address <= {load_feature_id, load_elem_id};
                        vector_data    <= raw_input;

                        if (load_elem_id == 8'd255) begin
                            load_elem_id <= 8'd0;
                            load_feature_id <= load_feature_id + 4'd1;
                        end else begin
                            load_elem_id <= load_elem_id + 8'd1;
                        end
                    end
                end

                S_COMPUTE_INIT: begin
                    row           <= 8'd0;
                    feature_id    <= 4'd0;
                    element_count <= 6'd0;
                    acc           <= 22'sd0;
                end

                S_READ_MATRIX_ELEM: begin
                    global_address =
                        ({6'd0, row} << 5) +
                        ({6'd0, row} << 4) +
                        {8'd0, element_count};

                    selected_sram <= global_address[13:12];

                    for (i = 0; i < 3; i = i + 1) begin
                        if (global_address[13:12] == i[1:0]) begin
                            weight_chip_enable[i]   <= 1;
                            weight_write_enable[i]  <= 0;
                            weight_address[i]       <= global_address[11:0];

                            position_chip_enable[i] <= 1;
                            position_write_enable[i] <= 0;
                            position_address[i]     <= global_address[11:0];
                        end
                    end
                end

                S_WAIT_MATRIX_ELEM: begin
                    // Wait one cycle for synchronous SRAM read
                end

                S_CAPTURE_MATRIX_ELEM: begin
                    weight_hold <= $signed(weight_output[selected_sram]);

                    vector_chip_enable  <= 1;
                    vector_write_enable <= 0;
                    vector_address <= {feature_id, position_output[selected_sram]};
                end

                S_READ_VECTOR_ELEM: begin
                    // Wait one cycle for synchronous SRAM read
                end

                S_WAIT_VECTOR_ELEM: begin
                    mult_product <=
                        $signed({{8{weight_hold[7]}}, weight_hold}) *
                        $signed({{8{vector_output[7]}}, vector_output});
                end

                S_MAC: begin
                    acc <= acc + {{6{mult_product[15]}}, mult_product};

                    if (element_count != 6'd47)
                        element_count <= element_count + 6'd1;
                end

                S_READ_BIAS_FOR_ROW: begin
                    bias_chip_enable  <= 1;
                    bias_write_enable <= 0;
                    bias_address      <= row;
                end

                S_WAIT_BIAS_FOR_ROW: begin
                    // Wait one cycle for synchronous SRAM read
                end

                S_CAPTURE_BIAS_FOR_ROW: begin
                    result_hold <=
                        acc + $signed({{10{bias_output[7]}}, bias_output, 4'b0000});
                end

                S_OUTPUT: begin
                    o_result <= result_hold;
                    o_valid  <= 1;

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

    // Next-state logic
    always @(*) begin
        next_state = state;

        case (state)
            S_IDLE:
                if (start_init)
                    next_state = S_LOAD_INIT;

            S_LOAD_INIT:
                if (w_input_valid && init_count == 15'd24831)
                    next_state = S_START_READ_VECTOR;

            S_START_READ_VECTOR:
                next_state = S_READ_VECTOR;

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
                    next_state = S_START_READ_VECTOR;
                else
                    next_state = S_READ_MATRIX_ELEM;
        endcase
    end

    // Request logic
    always @(*) begin
        raw_data_request = 0;
        ld_w_request = 0;

        case (state)
            S_LOAD_INIT: begin
                ld_w_request = 1;
            end

            S_START_READ_VECTOR: begin
                raw_data_request = 1;
            end

            S_READ_VECTOR: begin
                if (!(load_feature_id == 4'd15 && load_elem_id == 8'd255))
                    raw_data_request = 1;
            end
        endcase
    end

endmodule