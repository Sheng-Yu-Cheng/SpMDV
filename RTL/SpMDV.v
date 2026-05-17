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

    // ============================================================
    // 32-MAC architecture: 2 BBS matrix banks x 16 dense vectors.
    //
    // Data format is intentionally kept identical to the original
    // 1-MAC reference:
    //   weight       : S2.5  signed 8-bit
    //   dense vector : S1.6  signed 8-bit
    //   product      : S4.11 signed 16-bit
    //   bias         : S0.7  signed 8-bit, shifted left 4 to S10.11
    //   result       : S10.11 signed 22-bit
    //
    // Important SRAM latency assumption:
    //   These SRAM macros are synchronous single-port memories. A read
    //   request is issued in one cycle, and Q is used after the same
    //   kind of valid/bubble pipeline used in the 1-MAC reference.
    // ============================================================

    reg [23:0] state, next_state;

    localparam S_IDLE              = 24'd0;
    localparam S_LOAD_INIT         = 24'd1;
    localparam S_START_READ_VECTOR = 24'd2;
    localparam S_READ_VECTOR       = 24'd3;

    // Optimized 32MAC flow:
    //   - no result-SRAM bias prefill
    //   - no result-SRAM read-to-acc before every row
    //   - acc[0..15] are initialized directly from prefetched bias
    //   - result output is pipelined to one result per cycle after fill
    localparam S_BIAS_READ         = 24'd4;
    localparam S_BIAS_WAIT         = 24'd5;
    localparam S_BIAS_CAPTURE      = 24'd6;
    localparam S_COMPUTE_INIT      = 24'd7;
    localparam S_COMPUTE_ROW       = 24'd8;
    localparam S_WRITE_RESULT      = 24'd9;
    localparam S_OUTPUT_INIT       = 24'd10;
    localparam S_OUTPUT_PIPE       = 24'd11;

    // ============================================================
    // SRAM ports
    // ============================================================

    // 4 matrix BBS banks for weight and 4 for position.
    // Each bank stores 256 rows x 12 groups = 3072 bytes.
    reg        weight_chip_enable [0:3];
    reg        weight_write_enable[0:3];
    reg [11:0] weight_address     [0:3];
    reg [7:0]  weight_data        [0:3];
    wire [7:0] weight_output      [0:3];

    reg        position_chip_enable [0:3];
    reg        position_write_enable[0:3];
    reg [11:0] position_address     [0:3];
    reg [7:0]  position_data        [0:3];
    wire [7:0] position_output      [0:3];

    // Bias: 256 x 8.
    reg        bias_chip_enable, bias_write_enable;
    reg [7:0]  bias_address;
    reg [7:0]  bias_data;
    wire [7:0] bias_output;

    // Dense vectors: 16 features x 2 pair-banks = 32 SRAMs.
    // vector index = feature * 2 + pair_bank.
    // Each SRAM packs two column banks: banks 0/2 in pair 0 and banks 1/3 in pair 1.
    reg        vector_chip_enable [0:31];
    reg        vector_write_enable[0:31];
    reg [7:0]  vector_address     [0:31];
    reg [7:0]  vector_data        [0:31];
    wire [7:0] vector_output      [0:31];

    // Result buffer: 16 features x 3 bytes = 48 SRAMs.
    // result index = feature * 3 + byte_id, byte_id = 0 low, 1 mid, 2 high.
    // high byte stores {2'b00, result[21:16]}; reconstruction uses [5:0].
    reg        result_chip_enable [0:47];
    reg        result_write_enable[0:47];
    reg [7:0]  result_address     [0:47];
    reg [7:0]  result_data        [0:47];
    wire [7:0] result_output      [0:47];

    genvar gi, gf, gb;
    generate
        for (gi = 0; gi < 4; gi = gi + 1) begin : GEN_MATRIX_SRAM
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

        for (gf = 0; gf < 16; gf = gf + 1) begin : GEN_VECTOR_FEATURE
            for (gb = 0; gb < 2; gb = gb + 1) begin : GEN_VECTOR_PAIR
                localparam integer VID = gf * 2 + gb;
                sram_256x8 _vector(
                    .CLK(clk),
                    .CEN(~vector_chip_enable[VID]),
                    .WEN(~vector_write_enable[VID]),
                    .A(vector_address[VID]),
                    .D(vector_data[VID]),
                    .Q(vector_output[VID])
                );
            end
        end

        for (gf = 0; gf < 16; gf = gf + 1) begin : GEN_RESULT_FEATURE
            for (gb = 0; gb < 3; gb = gb + 1) begin : GEN_RESULT_BYTE
                localparam integer RID = gf * 3 + gb;
                sram_256x8 _result(
                    .CLK(clk),
                    .CEN(~result_chip_enable[RID]),
                    .WEN(~result_write_enable[RID]),
                    .A(result_address[RID]),
                    .D(result_data[RID]),
                    .Q(result_output[RID])
                );
            end
        end
    endgenerate

    // ============================================================
    // Counters / pipeline registers
    // ============================================================

    reg [7:0] row;             // 0..255 compute/result row
    reg [7:0] output_row;      // 0..255 output row
    reg [3:0] output_feature;  // 0..15 output feature

    reg [12:0] output_issue_count; // 0..4096, pipelined output read issue count
    reg [12:0] output_sent_count;  // 0..4096, number of valid outputs sent
    reg        out_valid_1, out_valid_2;
    reg [3:0]  out_feature_1, out_feature_2;
    reg [7:0]  out_row_1, out_row_2;

    reg [3:0] group;           // 0..11, for load stream and compute issue
    reg [1:0] bank;            // 0..3, for load stream
    reg [14:0] init_count;     // 0..24831

    reg [3:0] load_feature_id;
    reg [7:0] load_elem_id;

    reg [4:0] issue_bundle;    // issued bank-pair bundles, 0..24, {group, phase}
    reg [4:0] acc_bundle_count; // accumulated bank-pair bundles, 0..24

    reg        mat_valid_1, mat_valid_2;
    reg        vec_valid_1, vec_valid_2;
    reg        sum_valid;
    reg        mat_phase_1, mat_phase_2; // 0: banks 0/1, 1: banks 2/3

    reg signed [7:0] vec_weight_1[0:1];
    reg signed [7:0] vec_weight_2[0:1];
    reg signed [17:0] partial_sum_pipe[0:15]; // 2 x S4.11 products -> sign-extended to 18-bit
    reg signed [21:0] acc[0:15];              // S10.11 accumulators for 16 features

    reg signed [21:0] current_bias_s10_11;
    reg signed [21:0] prefetched_bias_s10_11;
    reg               prefetched_bias_valid;
    reg               bias_pf_v1, bias_pf_v2;

    integer i, f, b;

    // ============================================================
    // Helpers
    // ============================================================

    function [11:0] row_group_addr;
        input [7:0] r;
        input [3:0] g;
        begin
            // r * 12 + g = r*8 + r*4 + g
            row_group_addr = ({4'd0, r} << 3) + ({4'd0, r} << 2) + {8'd0, g};
        end
    endfunction

    function signed [21:0] bias_to_s10_11;
        input [7:0] bias_byte;
        begin
            // S0.7 -> S10.11: sign extend and append 4 fractional zeros.
            bias_to_s10_11 = $signed({{10{bias_byte[7]}}, bias_byte, 4'b0000});
        end
    endfunction



    function signed [17:0] mul_s2p5_s1p6_ext;
        input signed [7:0] w;
        input signed [7:0] x;
        reg signed [15:0] prod;
        begin
            // S2.5 * S1.6 = S4.11. Keep the exact 16-bit product,
            // then sign-extend to 18 bits so a four-bank sum cannot truncate.
            prod = w * x;
            mul_s2p5_s1p6_ext = {{2{prod[15]}}, prod};
        end
    endfunction

    wire signed [21:0] bias_shifted_comb;
    assign bias_shifted_comb = bias_to_s10_11(bias_output);

    // ============================================================
    // Sequential logic
    // ============================================================

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_IDLE;
        end else begin
            // Default: all SRAMs disabled, no writes, output invalid.
            for (i = 0; i < 4; i = i + 1) begin
                weight_chip_enable[i]     <= 1'b0;
                weight_write_enable[i]    <= 1'b0;
                position_chip_enable[i]   <= 1'b0;
                position_write_enable[i]  <= 1'b0;
            end
            for (i = 0; i < 32; i = i + 1) begin
                vector_chip_enable[i]     <= 1'b0;
                vector_write_enable[i]    <= 1'b0;
            end
            for (i = 0; i < 48; i = i + 1) begin
                result_chip_enable[i]     <= 1'b0;
                result_write_enable[i]    <= 1'b0;
            end

            bias_chip_enable    <= 1'b0;
            bias_write_enable   <= 1'b0;
            o_valid             <= 1'b0;

            case (state)
                S_IDLE: begin
                    row <= 8'd0;
                    output_row <= 8'd0;
                    output_feature <= 4'd0;
                    output_issue_count <= 13'd0;
                    output_sent_count <= 13'd0;
                    out_valid_1 <= 1'b0;
                    out_valid_2 <= 1'b0;
                    out_feature_1 <= 4'd0;
                    out_feature_2 <= 4'd0;
                    out_row_1 <= 8'd0;
                    out_row_2 <= 8'd0;
                    bank <= 2'd0;
                    group <= 4'd0;
                    init_count <= 15'd0;

                    load_feature_id <= 4'd0;
                    load_elem_id <= 8'd0;

                    issue_bundle <= 5'd0;
                    acc_bundle_count <= 5'd0;
                    mat_valid_1 <= 1'b0;
                    mat_valid_2 <= 1'b0;
                    vec_valid_1 <= 1'b0;
                    vec_valid_2 <= 1'b0;
                    sum_valid <= 1'b0;
                    mat_phase_1 <= 1'b0;
                    mat_phase_2 <= 1'b0;
                    current_bias_s10_11 <= 22'sd0;
                    prefetched_bias_s10_11 <= 22'sd0;
                    prefetched_bias_valid <= 1'b0;
                    bias_pf_v1 <= 1'b0;
                    bias_pf_v2 <= 1'b0;

                    for (f = 0; f < 16; f = f + 1) begin
                        acc[f] <= 22'sd0;
                        partial_sum_pipe[f] <= 18'sd0;
                    end
                    for (b = 0; b < 2; b = b + 1) begin
                        vec_weight_1[b] <= 8'sd0;
                        vec_weight_2[b] <= 8'sd0;
                    end

                    o_result <= 22'd0;
                end

                // --------------------------------------------------------
                // Matrix/bias initialization. External stream order remains:
                // all weight values -> all positions -> all bias values.
                // For weight/position, external order is row, group, bank.
                // We store into true BBS banked SRAMs at addr=row*12+group.
                // --------------------------------------------------------
                S_LOAD_INIT: begin
                    if (w_input_valid) begin
                        if (init_count < 15'd12288) begin
                            weight_chip_enable[bank]  <= 1'b1;
                            weight_write_enable[bank] <= 1'b1;
                            weight_address[bank]      <= row_group_addr(row, group);
                            weight_data[bank]         <= raw_input;
                        end else if (init_count < 15'd24576) begin
                            position_chip_enable[bank]  <= 1'b1;
                            position_write_enable[bank] <= 1'b1;
                            position_address[bank]      <= row_group_addr(row, group);
                            position_data[bank]         <= {2'b00, raw_input[5:0]};
                        end else begin
                            bias_chip_enable  <= 1'b1;
                            bias_write_enable <= 1'b1;
                            bias_address      <= row;
                            bias_data         <= raw_input;
                        end

                        // Advance row/group/bank counters exactly like the
                        // original stream: bank 0,1,2,3, then next group,
                        // then next row. During bias stream only row matters.
                        if (init_count < 15'd24576) begin
                            if (bank == 2'd3) begin
                                bank <= 2'd0;
                                if (group != 4'd11) begin
                                    group <= group + 4'd1;
                                end else begin
                                    group <= 4'd0;
                                    row <= row + 8'd1;
                                end
                            end else begin
                                bank <= bank + 2'd1;
                            end
                        end else begin
                            row <= row + 8'd1;
                        end

                        init_count <= init_count + 15'd1;
                    end
                end

                // --------------------------------------------------------
                // Dense vector loading. External stream order remains:
                // feature0 element0..255, feature1 element0..255, ...
                // Store into 16 features x 4 column-bank SRAMs.
                // --------------------------------------------------------
                S_START_READ_VECTOR: begin
                    row <= 8'd0;
                    output_row <= 8'd0;
                    output_feature <= 4'd0;
                    output_issue_count <= 13'd0;
                    output_sent_count <= 13'd0;
                    out_valid_1 <= 1'b0;
                    out_valid_2 <= 1'b0;
                    out_feature_1 <= 4'd0;
                    out_feature_2 <= 4'd0;
                    out_row_1 <= 8'd0;
                    out_row_2 <= 8'd0;
                    current_bias_s10_11 <= 22'sd0;
                    prefetched_bias_s10_11 <= 22'sd0;
                    prefetched_bias_valid <= 1'b0;
                    bias_pf_v1 <= 1'b0;
                    bias_pf_v2 <= 1'b0;
                    load_feature_id <= 4'd0;
                    load_elem_id <= 8'd0;
`ifdef DEBUG_SPMDV
                    $display("[SpMDV32] start loading 16 dense vectors at t=%0t", $time);
`endif
                end

                S_READ_VECTOR: begin
                    if (raw_data_valid) begin
                        // index = feature*4 + element[7:6], local addr = element[5:0]
                        vector_chip_enable[{load_feature_id, load_elem_id[6]}]  <= 1'b1;
                        vector_write_enable[{load_feature_id, load_elem_id[6]}] <= 1'b1;
                        vector_address[{load_feature_id, load_elem_id[6]}]      <= {1'b0, load_elem_id[7], load_elem_id[5:0]};
                        vector_data[{load_feature_id, load_elem_id[6]}]         <= raw_input;

                        if (load_elem_id == 8'd255) begin
                            load_elem_id <= 8'd0;
                            load_feature_id <= load_feature_id + 4'd1;
                        end else begin
                            load_elem_id <= load_elem_id + 8'd1;
                        end
                    end
                end

                // --------------------------------------------------------
                // Initial bias read for row 0.
                // Later rows use bias prefetch issued during the previous
                // row's compute pipeline.
                // --------------------------------------------------------
                S_BIAS_READ: begin
                    bias_chip_enable  <= 1'b1;
                    bias_write_enable <= 1'b0;
                    bias_address      <= row;
                end

                S_BIAS_WAIT: begin
                    // Bubble for synchronous bias SRAM read.
                end

                S_BIAS_CAPTURE: begin
                    current_bias_s10_11 <= bias_shifted_comb;
                    prefetched_bias_valid <= 1'b0;
`ifdef DEBUG_SPMDV
                    $display("[SpMDV32_OPT] capture initial/current bias row=%0d bias=%0d shifted=%0d t=%0t",
                             row, $signed(bias_output), bias_shifted_comb, $time);
`endif
                end

                S_COMPUTE_INIT: begin
                    issue_bundle <= 5'd0;
                    acc_bundle_count <= 5'd0;
                    mat_valid_1 <= 1'b0;
                    mat_valid_2 <= 1'b0;
                    vec_valid_1 <= 1'b0;
                    vec_valid_2 <= 1'b0;
                    sum_valid <= 1'b0;
                    mat_phase_1 <= 1'b0;
                    mat_phase_2 <= 1'b0;
                    bias_pf_v1 <= 1'b0;
                    bias_pf_v2 <= 1'b0;
                    prefetched_bias_valid <= 1'b0;
                    for (f = 0; f < 16; f = f + 1) begin
                        // Direct bias initialization: S0.7 bias has already
                        // been converted to S10.11 in current_bias_s10_11.
                        // This replaces result-SRAM bias prefill + result read.
                        acc[f] <= current_bias_s10_11;
                        partial_sum_pipe[f] <= 18'sd0;
                    end
                    for (b = 0; b < 2; b = b + 1) begin
                        vec_weight_1[b] <= 8'sd0;
                        vec_weight_2[b] <= 8'sd0;
                    end
`ifdef DEBUG_SPMDV
                    if (row[5:0] == 6'd0)
                        $display("[SpMDV32] compute row=%0d t=%0t", row, $time);
`endif
                end

                // --------------------------------------------------------
                // 32-MAC row compute pipeline.
                // Stage 0: issue 2 W/P bank reads for one group/phase.
                //          phase 0 uses banks 0/1, phase 1 uses banks 2/3.
                // Stage 1/2: wait/metadata, then issue 32 vector reads.
                // Stage 3: 32 multiplies and 16 two-product reductions.
                // Stage 4: accumulate 16 partial sums into acc[0..15].
                // --------------------------------------------------------
                S_COMPUTE_ROW: begin
                    // Bias prefetch pipeline for the next row. Bias SRAM is
                    // independent of matrix/vector/result SRAMs, so this can
                    // be overlapped with the current row compute.
                    if (bias_pf_v2) begin
                        prefetched_bias_s10_11 <= bias_shifted_comb;
                        prefetched_bias_valid  <= 1'b1;
`ifdef DEBUG_SPMDV
                        if (row[5:0] == 6'd0)
                            $display("[SpMDV32] prefetched bias for row=%0d shifted=%0d t=%0t",
                                     row + 8'd1, bias_shifted_comb, $time);
`endif
                    end
                    bias_pf_v2 <= bias_pf_v1;
                    bias_pf_v1 <= 1'b0;

                    // Issue the next-row bias read early in the current row.
                    if (issue_bundle == 5'd0 && row != 8'd255) begin
                        bias_chip_enable  <= 1'b1;
                        bias_write_enable <= 1'b0;
                        bias_address      <= row + 8'd1;
                        bias_pf_v1        <= 1'b1;
                    end

                    // Stage 4: accumulate one bank-pair bundle into all features.
                    if (sum_valid) begin
                        for (f = 0; f < 16; f = f + 1) begin
                            acc[f] <= acc[f] + {{4{partial_sum_pipe[f][17]}}, partial_sum_pipe[f]};
                        end
                        acc_bundle_count <= acc_bundle_count + 5'd1;
                    end

                    // Stage 3: vector Q valid; compute 16 partial sums.
                    sum_valid <= vec_valid_2;
                    if (vec_valid_2) begin
                        for (f = 0; f < 16; f = f + 1) begin
                            partial_sum_pipe[f] <=
                                mul_s2p5_s1p6_ext(vec_weight_2[0], $signed(vector_output[f*2 + 0])) +
                                mul_s2p5_s1p6_ext(vec_weight_2[1], $signed(vector_output[f*2 + 1]));
                        end
                    end

                    // Stage 2: matrix Q valid; issue vector reads for 16 features x 2 banks.
                    vec_valid_2 <= vec_valid_1;
                    for (b = 0; b < 2; b = b + 1) begin
                        vec_weight_2[b] <= vec_weight_1[b];
                    end

                    vec_valid_1 <= mat_valid_2;
                    if (mat_valid_2) begin
                        if (mat_phase_2 == 1'b0) begin
                            // Phase 0: banks 0 and 1. Both use offset 0 in the pair SRAMs.
                            vec_weight_1[0] <= $signed(weight_output[0]);
                            vec_weight_1[1] <= $signed(weight_output[1]);
                            for (f = 0; f < 16; f = f + 1) begin
                                vector_chip_enable[f*2 + 0]  <= 1'b1;
                                vector_write_enable[f*2 + 0] <= 1'b0;
                                vector_address[f*2 + 0]      <= {2'b00, position_output[0][5:0]};

                                vector_chip_enable[f*2 + 1]  <= 1'b1;
                                vector_write_enable[f*2 + 1] <= 1'b0;
                                vector_address[f*2 + 1]      <= {2'b00, position_output[1][5:0]};
                            end
                        end else begin
                            // Phase 1: banks 2 and 3. Both use offset 64 in the pair SRAMs.
                            vec_weight_1[0] <= $signed(weight_output[2]);
                            vec_weight_1[1] <= $signed(weight_output[3]);
                            for (f = 0; f < 16; f = f + 1) begin
                                vector_chip_enable[f*2 + 0]  <= 1'b1;
                                vector_write_enable[f*2 + 0] <= 1'b0;
                                vector_address[f*2 + 0]      <= {2'b01, position_output[2][5:0]};

                                vector_chip_enable[f*2 + 1]  <= 1'b1;
                                vector_write_enable[f*2 + 1] <= 1'b0;
                                vector_address[f*2 + 1]      <= {2'b01, position_output[3][5:0]};
                            end
                        end
                    end

                    // Stage 1: shift matrix valid/phase pipeline.
                    mat_valid_2 <= mat_valid_1;
                    mat_phase_2 <= mat_phase_1;

                    // Stage 0: issue 2 matrix bank reads for the next bundle.
                    if (issue_bundle < 5'd24) begin
                        mat_valid_1 <= 1'b1;
                        mat_phase_1 <= issue_bundle[0];

                        if (issue_bundle[0] == 1'b0) begin
                            // Phase 0: banks 0 and 1 for group issue_bundle[4:1].
                            weight_chip_enable[0]    <= 1'b1;
                            weight_write_enable[0]   <= 1'b0;
                            weight_address[0]        <= row_group_addr(row, issue_bundle[4:1]);
                            position_chip_enable[0]  <= 1'b1;
                            position_write_enable[0] <= 1'b0;
                            position_address[0]      <= row_group_addr(row, issue_bundle[4:1]);

                            weight_chip_enable[1]    <= 1'b1;
                            weight_write_enable[1]   <= 1'b0;
                            weight_address[1]        <= row_group_addr(row, issue_bundle[4:1]);
                            position_chip_enable[1]  <= 1'b1;
                            position_write_enable[1] <= 1'b0;
                            position_address[1]      <= row_group_addr(row, issue_bundle[4:1]);
                        end else begin
                            // Phase 1: banks 2 and 3 for group issue_bundle[4:1].
                            weight_chip_enable[2]    <= 1'b1;
                            weight_write_enable[2]   <= 1'b0;
                            weight_address[2]        <= row_group_addr(row, issue_bundle[4:1]);
                            position_chip_enable[2]  <= 1'b1;
                            position_write_enable[2] <= 1'b0;
                            position_address[2]      <= row_group_addr(row, issue_bundle[4:1]);

                            weight_chip_enable[3]    <= 1'b1;
                            weight_write_enable[3]   <= 1'b0;
                            weight_address[3]        <= row_group_addr(row, issue_bundle[4:1]);
                            position_chip_enable[3]  <= 1'b1;
                            position_write_enable[3] <= 1'b0;
                            position_address[3]      <= row_group_addr(row, issue_bundle[4:1]);
                        end

                        issue_bundle <= issue_bundle + 5'd1;
                    end else begin
                        mat_valid_1 <= 1'b0;
                    end
                end

                // --------------------------------------------------------
                // Write the completed row accumulators back to result SRAM.
                // --------------------------------------------------------
                S_WRITE_RESULT: begin
                    for (f = 0; f < 16; f = f + 1) begin
                        result_chip_enable[f*3 + 0]  <= 1'b1;
                        result_write_enable[f*3 + 0] <= 1'b1;
                        result_address[f*3 + 0]      <= row;
                        result_data[f*3 + 0]         <= acc[f][7:0];

                        result_chip_enable[f*3 + 1]  <= 1'b1;
                        result_write_enable[f*3 + 1] <= 1'b1;
                        result_address[f*3 + 1]      <= row;
                        result_data[f*3 + 1]         <= acc[f][15:8];

                        result_chip_enable[f*3 + 2]  <= 1'b1;
                        result_write_enable[f*3 + 2] <= 1'b1;
                        result_address[f*3 + 2]      <= row;
                        result_data[f*3 + 2]         <= {2'b00, acc[f][21:16]};
                    end

`ifdef DEBUG_SPMDV
                    if (row[5:0] == 6'd0)
                        $display("[SpMDV32] write result row=%0d acc0=%0d acc15=%0d t=%0t",
                                 row, acc[0], acc[15], $time);
`endif

                    if (row != 8'd255) begin
                        row <= row + 8'd1;
                        // Use the bias prefetched during this row's compute
                        // as the direct accumulator initial value for next row.
                        current_bias_s10_11 <= prefetched_bias_s10_11;
                    end else begin
                        output_feature <= 4'd0;
                        output_row <= 8'd0;
                        output_issue_count <= 13'd0;
                        output_sent_count <= 13'd0;
                        out_valid_1 <= 1'b0;
                        out_valid_2 <= 1'b0;
                    end
                end

                // --------------------------------------------------------
                // Output order: feature0 row0..255, feature1 row0..255, ...
                // Pipelined result SRAM reads: after initial fill, this emits
                // one o_valid result per cycle instead of request/wait/send.
                // --------------------------------------------------------
                S_OUTPUT_INIT: begin
                    output_feature <= 4'd0;
                    output_row <= 8'd0;
                    output_issue_count <= 13'd0;
                    output_sent_count <= 13'd0;
                    out_valid_1 <= 1'b0;
                    out_valid_2 <= 1'b0;
                    out_feature_1 <= 4'd0;
                    out_feature_2 <= 4'd0;
                    out_row_1 <= 8'd0;
                    out_row_2 <= 8'd0;
`ifdef DEBUG_SPMDV
                    $display("[SpMDV32_OPT] start pipelined output at t=%0t", $time);
`endif
                end

                S_OUTPUT_PIPE: begin
                    // Emit data for the read issued two cycles ago.
                    if (out_valid_2) begin
                        o_result <= {result_output[out_feature_2*3 + 2][5:0],
                                     result_output[out_feature_2*3 + 1],
                                     result_output[out_feature_2*3 + 0]};
                        o_valid <= 1'b1;
                        output_sent_count <= output_sent_count + 13'd1;

`ifdef DEBUG_SPMDV
                        if ((out_row_2 == 8'd0) || (out_row_2 == 8'd255))
                            $strobe("[SpMDV32_OPT] output f=%0d row=%0d result=%0d raw=%h t=%0t",
                                    out_feature_2, out_row_2,
                                    $signed({result_output[out_feature_2*3 + 2][5:0],
                                             result_output[out_feature_2*3 + 1],
                                             result_output[out_feature_2*3 + 0]}),
                                    {result_output[out_feature_2*3 + 2][5:0],
                                     result_output[out_feature_2*3 + 1],
                                     result_output[out_feature_2*3 + 0]},
                                    $time);
`endif
                    end

                    // Shift output-read metadata pipeline.
                    out_valid_2   <= out_valid_1;
                    out_feature_2 <= out_feature_1;
                    out_row_2     <= out_row_1;

                    // Issue next result read if any remain.
                    if (output_issue_count < 13'd4096) begin
                        output_feature <= output_issue_count[11:8];
                        output_row     <= output_issue_count[7:0];

                        result_chip_enable[output_issue_count[11:8]*3 + 0] <= 1'b1;
                        result_write_enable[output_issue_count[11:8]*3 + 0] <= 1'b0;
                        result_address[output_issue_count[11:8]*3 + 0] <= output_issue_count[7:0];

                        result_chip_enable[output_issue_count[11:8]*3 + 1] <= 1'b1;
                        result_write_enable[output_issue_count[11:8]*3 + 1] <= 1'b0;
                        result_address[output_issue_count[11:8]*3 + 1] <= output_issue_count[7:0];

                        result_chip_enable[output_issue_count[11:8]*3 + 2] <= 1'b1;
                        result_write_enable[output_issue_count[11:8]*3 + 2] <= 1'b0;
                        result_address[output_issue_count[11:8]*3 + 2] <= output_issue_count[7:0];

                        out_valid_1   <= 1'b1;
                        out_feature_1 <= output_issue_count[11:8];
                        out_row_1     <= output_issue_count[7:0];

                        output_issue_count <= output_issue_count + 13'd1;
                    end else begin
                        out_valid_1 <= 1'b0;
                    end
                end
            endcase

            state <= next_state;
        end
    end

    // ============================================================
    // Next-state logic
    // ============================================================

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
                if (raw_data_valid && load_feature_id == 4'd15 && load_elem_id == 8'd255)
                    next_state = S_BIAS_READ;

            S_BIAS_READ:
                next_state = S_BIAS_WAIT;

            S_BIAS_WAIT:
                next_state = S_BIAS_CAPTURE;

            S_BIAS_CAPTURE:
                next_state = S_COMPUTE_INIT;

            S_COMPUTE_INIT:
                next_state = S_COMPUTE_ROW;

            S_COMPUTE_ROW:
                if (sum_valid && acc_bundle_count == 5'd23)
                    next_state = S_WRITE_RESULT;
                else
                    next_state = S_COMPUTE_ROW;

            S_WRITE_RESULT:
                if (row == 8'd255)
                    next_state = S_OUTPUT_INIT;
                else
                    next_state = S_COMPUTE_INIT;

            S_OUTPUT_INIT:
                next_state = S_OUTPUT_PIPE;

            S_OUTPUT_PIPE:
                if (output_sent_count == 13'd4096)
                    next_state = S_START_READ_VECTOR;
                else
                    next_state = S_OUTPUT_PIPE;

            default:
                next_state = S_IDLE;
        endcase
    end

    // ============================================================
    // Request logic, kept compatible with original testbench protocol.
    // ============================================================

    always @(*) begin
        raw_data_request = 1'b0;
        ld_w_request = 1'b0;

        case (state)
            S_LOAD_INIT: begin
                ld_w_request = 1'b1;
            end

            S_START_READ_VECTOR: begin
                raw_data_request = 1'b1;
            end

            S_READ_VECTOR: begin
                if (!(load_feature_id == 4'd15 && load_elem_id == 8'd255))
                    raw_data_request = 1'b1;
            end
        endcase
    end

endmodule
