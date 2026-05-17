# SPEC.md — SpMDV Multi-MAC / Multi-Algorithm RTL Experiments

## 0. Purpose

Implement and compare multiple RTL versions of the `SpMDV` module for the Sparse Matrix Dense Vector multiplication project:

- **Baseline reference:** current working 1-MAC behavior from the provided `SpMDV` code.
- **Target variants:** 2-MAC, 4-MAC, and possibly algorithm/storage variants.
- **Experiment goal:** measure how increasing compute throughput and/or changing the scheduling/storage algorithm affects cycle count, throughput, synthesis timing, area, and power.

The top-level module interface must remain compatible with the provided testbench.

---

## 1. Top-level module interface: do not change

```verilog
module SpMDV (
    input clk,
    input rst,

    input start_init,
    input [7:0] raw_input,
    input raw_data_valid,
    input w_input_valid,

    output reg raw_data_request,
    output reg ld_w_request,
    output reg [21:0] o_result,
    output reg o_valid
);
```

Signal meaning:

| Signal | Direction | Width | Meaning |
|---|---:|---:|---|
| `clk` | I | 1 | system clock |
| `rst` | I | 1 | reset |
| `start_init` | I | 1 | initialization phase active: weight, position, bias are available by request |
| `raw_input` | I | 8 | shared input bus for weight, position, bias, and dense vector data |
| `raw_data_request` | O | 1 | request next dense-vector element |
| `raw_data_valid` | I | 1 | dense-vector element on `raw_input` is valid |
| `ld_w_request` | O | 1 | request next weight / position / bias item |
| `w_input_valid` | I | 1 | weight / position / bias item on `raw_input` is valid |
| `o_result` | O | 22 | output result, fixed-point S10.11 |
| `o_valid` | O | 1 | output result valid for exactly 1 cycle |

---

## 2. Mathematical task

Compute sparse matrix dense vector multiplication with bias:

```text
for each dense feature f = 0..15:
    for each output row r = 0..255:
        y[f][r] = bias[r] + sum over 48 non-zero weights in row r:
                  weight[r][k] * x[f][col_index[r][k]]
```

Output all 256 results of feature 0, then all 256 results of feature 1, ..., then all 256 results of feature 15.

One dense-vector batch contains **16 dense vectors**, each length **256**, so each batch produces:

```text
16 * 256 = 4096 output results
```

After finishing one batch, the design should request the next 16 dense vectors and repeat without reloading weights unless the external protocol resets/reinitializes.

---

## 3. Sparse matrix configuration

Matrix shape:

```text
W: 256 x 256
```

Bank-Balanced Sparsity format:

```text
bank shape: 1 x 64
4 banks per row
12 non-zero values per bank
48 non-zero values per row
```

Counts:

```text
weight values:    256 rows * 48 NZV = 12288 bytes
positions:        256 rows * 48 NZV = 12288 items
bias values:      256 rows          =   256 bytes
init total:       12288 + 12288 + 256 = 24832 input items
dense vectors:    16 * 256 = 4096 bytes per round
outputs:          16 * 256 = 4096 results per round
```

Position input is unsigned 6-bit position inside a 64-column bank: `0..63`.

For computation, the absolute dense-vector column is:

```text
absolute_col = bank_id * 64 + position_in_bank
             = {bank_id[1:0], position_in_bank[5:0]}   // 8-bit column index
```

The working 1-MAC code stores positions as:

```verilog
position_data <= {bank, raw_input[5:0]};
```

This is intentional. Later, vector SRAM is addressed with:

```verilog
vector_address <= {feature_id, position_output};
```

where `position_output` is the 8-bit absolute column `{bank, pos6}`.

---

## 4. Fixed-point format

All signed values are 2's-complement except the 6-bit non-zero position.

| Quantity | Input width | Fixed-point | Notes |
|---|---:|---|---|
| Weight | 8 | S2.5 | signed |
| Dense vector | 8 | S1.6 | signed |
| Bias | 8 | S0.7 | signed |
| Position | 6 | unsigned | 0..63 inside bank |
| Product | 16 | S4.11 | `S2.5 * S1.6` |
| Accumulator / output | 22 | S10.11 | sum 48 products + bias |

Bias conversion to S10.11:

```verilog
bias_s10_11 = $signed({{10{bias_output[7]}}, bias_output, 4'b0000});
```

Reason: S0.7 has 7 fractional bits; S10.11 has 11 fractional bits, so shift left by 4 fractional bits while sign-extending to 22 bits.

Product accumulation:

```verilog
product_s4_11 = $signed(weight_8) * $signed(vector_8); // 16-bit S4.11
acc_next = acc + {{6{product_s4_11[15]}}, product_s4_11}; // sign-extend to 22 bits
```

Do not round or saturate unless explicitly experimenting with a separate approximate variant. The safe default is exact signed fixed-point accumulation matching the reference.

---

## 5. Critical input protocol: do not break this

This is the part that commonly kills implementations. The external testbench is request/valid driven, and `raw_input` is shared.

### 5.1 Init stream: weights, positions, bias

When `start_init` is high, the design may request initialization data by asserting `ld_w_request`.

Protocol:

```text
cycle N:     SpMDV asserts ld_w_request = 1
cycle N+1:   testbench may assert w_input_valid = 1 and place the requested item on raw_input
```

Only consume `raw_input` when `w_input_valid == 1`.

The stream order is fixed:

```text
1. all weight values
2. all positions of non-zero values
3. all bias values
```

Total init items:

```text
0       .. 12287 : weight stream
12288   .. 24575 : position stream
24576   .. 24831 : bias stream
```

After all initialization data are transmitted, `start_init` will be set low at the negative clock edge by the testbench. The design should not require `start_init` to stay high after initialization.

### 5.2 Weight stream order

The slides describe the order as interleaving banks for each non-zero group, then switching to the next row:

```text
row r:
    group 0: bank0, bank1, bank2, bank3
    group 1: bank0, bank1, bank2, bank3
    ...
    group 11: bank0, bank1, bank2, bank3
then row r+1
```

Equivalent input-stream iteration:

```c
for (row = 0; row < 256; row++) {
    for (group = 0; group < 12; group++) {
        for (bank = 0; bank < 4; bank++) {
            consume weight(row, bank, group);
        }
    }
}
```

The provided working 1-MAC code stores each incoming item at a **bank-contiguous physical address**:

```verilog
physical_index = row * 48 + bank * 12 + group;
```

Even though the incoming stream order is `(group, bank)`, the stored memory order becomes:

```text
row r:
    bank0 group0..11,
    bank1 group0..11,
    bank2 group0..11,
    bank3 group0..11
```

This is okay because summation order does not affect the exact integer result.

### 5.3 Position stream order

The position stream uses the **same order as the weight stream**:

```c
for (row = 0; row < 256; row++) {
    for (group = 0; group < 12; group++) {
        for (bank = 0; bank < 4; bank++) {
            consume pos6(row, bank, group);
            store absolute column as {bank, pos6};
        }
    }
}
```

Use the same physical address mapping as the corresponding weight:

```verilog
physical_index = row * 48 + bank * 12 + group;
position_data  = {bank[1:0], raw_input[5:0]};
```

### 5.4 Bias stream order

Bias values are transmitted in original row order:

```c
for (row = 0; row < 256; row++) {
    consume bias[row];
}
```

### 5.5 Dense-vector stream

After initialization is complete, request dense-vector data with `raw_data_request`.

Protocol:

```text
cycle N:     SpMDV asserts raw_data_request = 1
cycle N+1:   testbench may assert raw_data_valid = 1 and place dense data on raw_input
```

Only consume `raw_input` when `raw_data_valid == 1`.

Each round contains 16 dense vectors. Stream order:

```text
all elements of feature 0
all elements of feature 1
...
all elements of feature 15
```

Equivalent:

```c
for (feature = 0; feature < 16; feature++) {
    for (elem = 0; elem < 256; elem++) {
        consume x[feature][elem];
    }
}
```

The working code stores:

```verilog
vector_address <= {load_feature_id, load_elem_id}; // 4-bit feature + 8-bit element
```

So vector SRAM needs at least 4096 x 8 capacity.

Important reset behavior copied from the working code:

- Reset `row` and `feature_id` to 0 when starting a **new dense-vector batch**.
- Do **not** reset `feature_id` before every row.
- `S_COMPUTE_INIT` should reset per-row counters/pipelines only, not the feature id.
- After outputting row 255 for feature 15, go back to request the next 16 dense vectors.

---

## 6. Output protocol

Output order:

```c
for (feature = 0; feature < 16; feature++) {
    for (row = 0; row < 256; row++) {
        output y[feature][row];
    }
}
```

When outputting a result:

```text
o_valid = 1 for exactly one cycle
o_result = S10.11 result
```

Between outputs, `o_valid` should be 0 unless the architecture truly outputs one result every cycle. Never hold `o_valid` high across multiple cycles for the same result.

---

## 7. SRAM behavior and safe assumptions

The provided 1-MAC code assumes the SRAM model is synchronous and needs one bubble cycle after read request before `Q` is valid.

In the current code:

- read address/control issued in one cycle
- one valid/metadata pipeline stage follows
- data is used after the SRAM output is valid

Do not combine:

```text
SRAM read address issue + SRAM Q use
```

in the same cycle.

Also avoid multiplier + wide accumulator critical path in the same cycle if timing gets tight. The working 1-MAC code registers the product first, then accumulates it in the next stage.

SRAM active-low pins in the project SRAM wrappers:

```verilog
.CEN(~chip_enable)
.WEN(~write_enable)
```

So internal `chip_enable=1` means SRAM selected, and `write_enable=1` means write.

---

## 8. Reference 1-MAC architecture summary

The working 1-MAC code uses these states:

```text
S_IDLE
S_LOAD_INIT
S_START_READ_VECTOR
S_READ_VECTOR
S_COMPUTE_INIT
S_COMPUTE_ROW
S_READ_BIAS_FOR_ROW
S_WAIT_BIAS_FOR_ROW
S_CAPTURE_BIAS_FOR_ROW
S_OUTPUT
```

Reference storage:

```text
weight:   3 x sram_4096x8    // total 12288 bytes
position: 3 x sram_4096x8    // total 12288 bytes
bias:     1 x sram_256x8
vector:   1 x sram_4096x8
```

The 3 weight/position SRAMs are selected by:

```verilog
selected_sram = global_address[13:12];
local_addr    = global_address[11:0];
```

Since 12288 = 3 * 4096, this maps the matrix storage into 3 physical SRAM blocks.

Reference 1-MAC compute pipeline:

```text
Stage 0: issue one weight/position SRAM read
Stage 1: delay / metadata pipeline for matrix SRAM
Stage 2: matrix Q valid; issue vector SRAM read using stored absolute column
Stage 3: vector Q valid; register product = weight * vector
Stage 4: accumulate registered product
```

This makes one matrix element issue per cycle after startup, but each output row still needs at least 48 issued products plus pipeline flush and bias/output overhead.

---

## 9. Multi-MAC design requirements

### 9.1 Parametric goal

Implement a parametric compute-lane count if possible:

```verilog
localparam integer MAC_LANES = 1; // or 2, or 4
```

Then create separate variants/files or compile-time parameters:

```text
SpMDV_1MAC.v
SpMDV_2MAC.v
SpMDV_4MAC.v
```

or keep one RTL with a parameter if the testbench/build flow supports it.

### 9.2 Correctness comes first

All variants must match the exact 1-MAC functional result:

```text
same input stream
same output order
same o_result bit pattern
same one-cycle o_valid pulse semantics
```

Parallelism must not change numerical result. Since all products are integer fixed-point values and accumulation is exact within 22 bits, accumulation tree/order should match the exact integer sum as long as no truncation occurs before final addition.

### 9.3 Multi-lane issue schedule

For `MAC_LANES = L`, per row issue up to `L` non-zero elements per cycle:

```c
for issue_base = 0; issue_base < 48; issue_base += L:
    for lane = 0; lane < L; lane++:
        issue_idx = issue_base + lane
        if issue_idx < 48:
            read weight[row][issue_idx]
            read position[row][issue_idx]
```

Then all lanes proceed through the same matrix-read, vector-read, multiply, and accumulate pipeline.

Expected ideal compute issue cycles per row:

```text
1MAC: 48 issue cycles
2MAC: 24 issue cycles
4MAC: 12 issue cycles
```

Actual per-row latency will be higher due to pipeline fill/flush, bias read, and output.

### 9.4 Memory bandwidth warning

Naively adding MACs is not enough. Each lane needs, per issued non-zero:

```text
1 weight byte
1 position byte
1 dense-vector byte
```

If the design uses single-port SRAMs, simultaneous reads conflict unless each lane reads a different SRAM instance or data is replicated/banked.

The current 1-MAC memory split into 3 SRAMs by `global_address[13:12]` is enough for capacity but not automatically enough for 2 or 4 conflict-free reads. For a robust 2MAC/4MAC implementation, prefer one of these:

#### Option A — Lane-banked storage during init

Store logical issue index `idx = bank * 12 + group` or `idx = group * 4 + bank` into lane-specific SRAMs:

```text
lane = idx % MAC_LANES
lane_local_index = idx / MAC_LANES
```

For each row, each lane has its own weight SRAM and position SRAM, so all lanes can read in parallel.

For 4MAC, each lane stores 12 items per row:

```text
256 rows * 12 = 3072 bytes per lane
```

This fits in one `sram_4096x8` per lane for weights and one for positions.

For 2MAC, each lane stores 24 items per row:

```text
256 rows * 24 = 6144 bytes per lane
```

This does not fit in one `sram_4096x8`; use either two SRAMs per lane, a larger SRAM if allowed, or a different banking scheme.

#### Option B — Bank-based compute lanes

Because BBS has 4 banks per row with 12 NZV each, a natural 4MAC algorithm is:

```text
lane0 handles matrix bank0
lane1 handles matrix bank1
lane2 handles matrix bank2
lane3 handles matrix bank3
```

Each lane processes 12 NZV for the current row. This maps well to 4MAC:

```text
cycle g = 0..11:
    lane0: weight(row, bank0, group g), col={0,pos}
    lane1: weight(row, bank1, group g), col={1,pos}
    lane2: weight(row, bank2, group g), col={2,pos}
    lane3: weight(row, bank3, group g), col={3,pos}
```

For 2MAC, process two banks at a time:

```text
phase 0: bank0 and bank1 for groups 0..11
phase 1: bank2 and bank3 for groups 0..11
```

This is simple and aligned with the input stream. It also reduces address confusion.

Recommended for Codex: implement **Option B first** because it follows the BBS structure and makes 2MAC/4MAC scheduling easy to reason about.

### 9.5 Vector SRAM conflict warning

Even if weight/position reads are conflict-free, multiple lanes may need multiple dense-vector reads in the same cycle.

A single `sram_4096x8` vector memory only supports one read per cycle. For true 2MAC/4MAC throughput, use one of:

1. **Replicate vector SRAM per lane** during dense-vector loading.
   - Store the same dense-vector byte into all lane vector SRAM copies.
   - Then each lane can independently read `x[feature][absolute_col]`.
   - Cost: more SRAM area, much better throughput.

2. **Bank vector SRAM by column**, if you can prove no conflicts.
   - BBS banks correspond to column ranges 0..63, 64..127, 128..191, 192..255.
   - A 4-bank vector SRAM split by `absolute_col[7:6]` pairs naturally with bank-based 4MAC lanes.
   - Lane `b` reads vector bank `b`, local address `{feature_id, pos6}`.
   - This is better than full replication for 4MAC Option B.

Recommended:

- For **4MAC bank-based architecture**, store dense vector into four vector SRAM banks by column bank:
  ```text
  vector_bank = load_elem_id[7:6]
  vector_local_addr = {feature, load_elem_id[5:0]}  // 4 + 6 = 10-bit, 1024 entries per bank
  ```
  A `sram_4096x8` per vector bank is over-capacity but easy if only 4096x8 SRAM is available.

- For **2MAC**, either:
  - use 4 vector banks and read the two active banks each phase, or
  - use two replicated full-vector SRAMs.

### 9.6 Accumulation for multiple lanes

For L lanes:

```verilog
lane_product[lane] = signed(weight[lane]) * signed(vector[lane]); // S4.11
```

Then either:

1. Sum all lane products into a per-cycle partial sum and accumulate once:
   ```verilog
   partial_sum = signext(product0) + signext(product1) + ...;
   acc <= acc + partial_sum;
   ```

2. Maintain per-lane accumulators and reduce at the end:
   ```verilog
   acc_lane[lane] += product[lane];
   final_acc = acc_lane0 + acc_lane1 + ... + bias;
   ```

Preferred for timing: **per-lane accumulators**, then reduce after all groups finish. This avoids a multiplier plus multi-input adder in the same cycle.

---

## 10. Recommended 4MAC bank-based algorithm

Storage:

```text
weight_bank[4]:   one SRAM per BBS bank, 256*12 = 3072 entries each
pos_bank[4]:      one SRAM per BBS bank, 256*12 = 3072 entries each
vector_bank[4]:   one SRAM per dense column bank, 16*64 = 1024 entries each
bias:             256 entries
```

Initialization:

```c
// weight stream
for row in 0..255:
  for group in 0..11:
    for bank in 0..3:
      addr = row*12 + group;
      weight_bank[bank][addr] = raw_input;

// position stream
for row in 0..255:
  for group in 0..11:
    for bank in 0..3:
      addr = row*12 + group;
      pos_bank[bank][addr] = raw_input[5:0]; // local position only is enough
      // absolute bank is implicit by SRAM/lane index

// bias stream
for row in 0..255:
  bias[row] = raw_input;
```

Dense load:

```c
for feature in 0..15:
  for elem in 0..255:
    bank = elem[7:6];
    local_col = elem[5:0];
    vector_bank[bank][{feature, local_col}] = raw_input;
```

Compute:

```c
for feature in 0..15:
  for row in 0..255:
    acc0 = acc1 = acc2 = acc3 = 0
    for group in 0..11:
      for bank/lane in 0..3 in parallel:
        w = weight_bank[bank][row*12 + group]
        p = pos_bank[bank][row*12 + group]       // 0..63
        x = vector_bank[bank][{feature, p}]
        acc_lane[bank] += w * x
    result = acc0 + acc1 + acc2 + acc3 + (bias[row] << 4)
    output result
```

Pipeline with synchronous SRAM:

```text
cycle t:      issue weight/position reads for all 4 banks
cycle t+1:    capture weight/position Q; issue vector reads for all 4 banks
cycle t+2:    capture vector Q; compute/register 4 products
cycle t+3:    accumulate products into lane accumulators
```

Need valid shift registers to handle the pipeline. Stop after 12 groups are issued, then flush remaining valid products before reading bias and outputting.

---

## 11. Recommended 2MAC bank-based algorithm

Use the same storage as 4MAC if possible:

```text
weight_bank[4], pos_bank[4], vector_bank[4]
```

Compute in two phases:

```c
for feature in 0..15:
  for row in 0..255:
    acc0 = acc1 = acc2 = acc3 = 0

    // phase 0: banks 0 and 1
    for group in 0..11:
      lane0 handles bank0
      lane1 handles bank1

    // phase 1: banks 2 and 3
    for group in 0..11:
      lane0 handles bank2
      lane1 handles bank3

    result = acc0 + acc1 + acc2 + acc3 + (bias[row] << 4)
    output result
```

This needs 24 issue cycles per row, plus pipeline overhead.

Alternative 2MAC schedule:

```text
issue_idx 0..47, two per cycle
bank = issue_idx / 12
group = issue_idx % 12
```

But bank-phase scheduling is simpler and maps better to SRAM banks.

---

## 12. Experimental algorithm variants

Implement in this priority order:

### Variant 1 — `SpMDV_1MAC_ref`

Purpose: preserve or minimally clean up the provided working 1-MAC code.

Requirements:

- Keep exact behavior.
- Use it as correctness oracle and baseline cycle count.
- Do not over-optimize until 2MAC/4MAC exist.

### Variant 2 — `SpMDV_4MAC_bank_parallel`

Purpose: exploit the 4 BBS banks per row.

Expected benefit:

- Reduce per-row NZV issue count from 48 to 12.
- Requires enough memory banking for 4 weight, 4 position, and 4 vector reads per cycle.

### Variant 3 — `SpMDV_2MAC_bank_pair`

Purpose: middle point between 1MAC and 4MAC.

Expected benefit:

- Reduce per-row NZV issue count from 48 to 24.
- Usually lower area/power than 4MAC.

### Variant 4 — `SpMDV_4MAC_shared_vector_stalled` optional

Purpose: understand whether MAC parallelism is useless if vector memory bandwidth is not improved.

Behavior:

- 4 weight/position reads may be possible, but dense-vector reads are serialized or conflict-resolved.
- This may show poor speedup and demonstrates memory bandwidth bottlenecks.

### Variant 5 — row/feature loop interchange optional

Current output order requires feature-major output:

```text
feature 0 rows 0..255, feature 1 rows 0..255, ...
```

You may compute internally in a different order only if outputs are buffered and emitted in the required order. Because buffering 4096 S10.11 outputs is expensive, do not change loop order unless explicitly exploring a storage/output-buffer variant.

---

## 13. Performance measurement plan

For each variant, report:

```text
1. RTL simulation pass/fail
2. Total cycles for one dense-vector batch after initialization
3. Cycles per 4096 outputs
4. Average cycles per output
5. Approximate useful MACs per cycle:
   total_MACs = 16 * 256 * 48 = 196608
   useful_MACs_per_cycle = total_MACs / compute_cycles
6. Synthesis clock period achieved
7. Area
8. Gate-level simulation pass/fail
9. Power if available
10. Energy per output = power * time / 4096
```

Separate initialization cycles from steady-state dense-vector compute cycles:

```text
init load cycles: matrix weights + positions + bias
dense load cycles per round: 4096
compute/output cycles per round: architecture-dependent
```

Do not claim throughput speedup using initialization-dominated timing unless that is explicitly the metric. The interesting metric is steady-state batches after weights are already loaded.

---

## 14. Verification checklist

A variant is acceptable only if:

- Top-level interface unchanged.
- `ld_w_request` and `raw_data_request` follow request/valid protocol.
- Initialization consumes exactly 24832 valid items:
  - 12288 weights
  - 12288 positions
  - 256 biases
- Dense round consumes exactly 4096 valid dense-vector items.
- Produces exactly 4096 outputs per dense round.
- Output order is feature-major then row-major.
- `o_valid` is exactly one cycle per output.
- Bias is added once per output row/feature.
- Positions use absolute column `{bank, pos6}` or equivalent banked-vector addressing.
- Signed multiplications use 8-bit signed operands.
- Product is sign-extended before accumulation.
- Bias is sign-extended and shifted left by 4 before addition.
- SRAM read latency is handled with valid/metadata pipelines.
- No lane reads stale SRAM output due to missing bubble cycle.
- No accidental reset of `feature_id` per row.
- After feature 15 row 255, the design requests the next dense-vector batch.

---

## 15. Common bugs to avoid

1. **Consuming `raw_input` in the same cycle as request.**
   - Wrong. Data arrives next cycle with valid.

2. **Ignoring valid signals.**
   - Only update load counters when `w_input_valid` or `raw_data_valid` is high.

3. **Resetting `feature_id` in every row init.**
   - This recomputes feature 0 repeatedly.

4. **Using 6-bit position directly as vector column.**
   - Wrong for banks 1..3. Need `{bank, pos6}` or vector bank selected by bank.

5. **Assuming combinational SRAM read.**
   - The provided SRAM models are synchronous. Add valid/metadata pipelines.

6. **Adding bias with the wrong fixed-point alignment.**
   - Bias S0.7 must become S10.11 via sign extension and `<< 4`.

7. **Changing output order.**
   - The grader expects feature-major, row-major output order.

8. **Adding more MACs but not enough vector read ports.**
   - This can produce wrong data or no speedup.

9. **Memory conflicts hidden by nonblocking assignment.**
   - Multiple writes/reads to a single SRAM instance in one cycle will not create multiple ports.

10. **Using 15-bit init counter but overflowing logic.**
    - 24831 is the last valid init index; transition after consuming it.

---

## 16. Suggested file organization for Codex

```text
rtl/
  SpMDV.v                    // selected final implementation for grading
  SpMDV_1MAC_ref.v            // working baseline
  SpMDV_2MAC_bank_pair.v      // experiment
  SpMDV_4MAC_bank_parallel.v  // experiment
  spmdv_common.vh             // optional constants/functions
docs/
  SPEC.md
  RESULTS.md                 // fill after experiments
```

If the build flow only accepts `SpMDV.v`, keep variant files separately and copy/symlink the selected version into `SpMDV.v` before each run.

---

## 17. Implementation request for Codex

When modifying RTL, proceed in small steps:

1. Preserve the working 1-MAC code as `SpMDV_1MAC_ref.v`.
2. Add a self-contained 4-bank storage version for 4MAC:
   - 4 weight SRAMs
   - 4 position SRAMs
   - 4 vector SRAM banks
   - 1 bias SRAM
3. Implement and test init loading only.
4. Implement and test dense-vector loading only.
5. Implement compute for one row/one feature.
6. Expand to all 256 rows and 16 features.
7. Only after 4MAC works, derive 2MAC by using the same storage and two active lanes over two phases.
8. Keep cycle counters or optional debug `ifdef`s for measurement, but do not change the public interface.

Do not “simplify” the data input protocol. The slides are ambiguous visually, but the working 1-MAC code confirms the correct handshake and stream interpretation.

---

## 18. Minimal pseudo-FSM for 4MAC

```text
IDLE
  wait start_init

LOAD_W
  request/consume 12288 weight bytes
  decode stream counters row/group/bank
  write weight_bank[bank][row*12 + group]

LOAD_POS
  request/consume 12288 pos bytes
  decode stream counters row/group/bank
  write pos_bank[bank][row*12 + group]

LOAD_BIAS
  request/consume 256 bias bytes
  write bias[row]

START_READ_VECTOR
  reset load_feature, load_elem, compute feature,row

READ_VECTOR
  request/consume 4096 dense bytes
  write vector_bank[elem[7:6]][{feature, elem[5:0]}]

COMPUTE_INIT
  reset row accumulators, group issue counter, pipeline valids

COMPUTE_ROW
  issue group 0..11 reads to all four banks
  pipeline:
    matrix Q -> vector read -> product register -> lane accumulator
  after all products accumulated, go read bias

READ_BIAS
  issue bias read for row

WAIT_BIAS
  wait SRAM latency

CAPTURE_RESULT
  result = lane_acc0 + lane_acc1 + lane_acc2 + lane_acc3 + bias_s10_11

OUTPUT
  pulse o_valid for 1 cycle
  advance row/feature
  if feature,row complete: START_READ_VECTOR
  else: COMPUTE_INIT
```

---

## 19. Expected speedup intuition

Ignoring pipeline overhead and output/bias overhead:

```text
1MAC: 48 NZV cycles per row
2MAC: 24 NZV cycles per row
4MAC: 12 NZV cycles per row
```

But real speedup is limited by:

- dense-vector load time: fixed 4096 valid input items per round
- result output count: fixed 4096 outputs per round
- SRAM latency pipeline fill/flush per row
- bias read latency per row
- memory port conflicts
- synthesis timing degradation from wider parallel datapaths

The experiment should therefore report both:

```text
raw compute speedup
end-to-end steady-state batch speedup
```

A 4MAC design may not achieve 4x end-to-end speedup once loading/output overhead and timing/power are included. This is exactly what the experiments are meant to quantify.
