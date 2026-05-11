/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : U-2022.12
// Date      : Mon May 11 02:29:23 2026
/////////////////////////////////////////////////////////////


module SpMDV ( clk, rst, start_init, raw_input, raw_data_valid, w_input_valid, 
        raw_data_request, ld_w_request, o_result, o_valid );
  input [7:0] raw_input;
  output [21:0] o_result;
  input clk, rst, start_init, raw_data_valid, w_input_valid;
  output raw_data_request, ld_w_request, o_valid;
  wire   n967, bias_write_enable, bias_chip_enable, vector_write_enable,
         vector_chip_enable, N176, N177, N178, N179, N180, N181, N182, N183,
         N184, N185, N214, N215, N216, N217, N218, N219, N220, N221, N222,
         N223, N224, N225, N226, N227, N355, N356, N357, N358, N359, N360,
         N361, N362, N370, N371, N372, N373, N374, N375, N376, N377, N378,
         N379, N380, N381, N382, N383, N384, N403, N404, N405, N406, N407,
         N408, N409, N410, N434, N435, N436, N437, N438, N439, N440, N441,
         N442, N443, N444, N445, N446, N447, N469, N470, N471, N472, N473,
         N474, N475, N476, N477, N478, N479, N480, N481, N482, N483, N484,
         N486, N487, N488, N489, N490, N491, N492, N493, N494, N495, N496,
         N497, N498, N499, N500, N501, N502, N503, N504, N505, N506, N507,
         N508, N509, N510, N511, N512, N513, N514, N515, N516, N517, N518,
         N519, N520, N521, N522, N523, N524, N525, N526, N527, N528, N529,
         N530, N531, N532, N533, N534, N535, n331, n332, n333, n334, n335,
         n336, n337, n338, n339, n340, n341, n342, n343, n344, n345, n346,
         n347, n353, n354, n3550, n3560, n3570, n3580, n3590, n3600, n3740,
         n3750, n3760, n3770, n3780, n3790, n3800, n3810, n3820, n3830, n3840,
         n385, n386, n387, n388, n389, n390, n391, n392, n393, n394, n395,
         n396, n397, n398, n399, n400, n401, n402, n4030, n4040, n4050, n4060,
         n4070, n4080, n4090, n4100, n411, n412, n413, n414, n415, n416, n417,
         n418, n419, n420, n421, n422, n423, n424, n425, n426, n427, n428,
         n429, n430, n431, n432, n433, n4340, n4350, n4360, n4370, n4380,
         n4390, n4400, n4410, n4420, n4430, n4440, n4450, n4460, n4470, n448,
         n449, n450, n451, n452, n453, n454, n455, n456, n457, n458, n459,
         n460, n461, n462, n463, n464, n465, n466, n467, n468, n4690, n4700,
         n4710, n4720, n4730, n4740, n4750, n4760, n4770, n4780, n4790, n4800,
         n4810, n4820, n4830, n4840, n485, n4860, n4870, n4880, n4890, n4900,
         n4910, n4920, n4930, n4940, n4950, n4960, n4970, n4980, n4990, n5000,
         n5010, n5020, n5030, n5040, n5050, n5060, n5070, n5080, n5090, n5100,
         n5110, n5120, n5130, n5140, n5150, n5160, n5170, n5180, n5190, n5200,
         n5210, n5220, n5230, n5240, n5250, n5260, n5270, n5280, n5290, n5300,
         n5310, n5320, n5330, n5340, n5350, n536, n537, n538, n539, n540, n541,
         n542, n543, n544, n545, n546, n547, n548, n549, n550, n551, n552,
         n553, n554, n555, n556, n557, n558, n559, n560, n561, n562, n563,
         n564, n565, n566, n567, n568, n569, n570, n571, n572, n573, n574,
         n575, n576, n577, n578, n579, n580, n581, n582, n583, n584, n585,
         n586, n587, n588, n589, n590, n591, n592, n593, n594, n595, n596,
         n597, n598, n599, n600, n601, n602, n603, n604, n605, n606, n607,
         n608, n609, n610, n611, n612, n613, n614, n615, n616, n617, n618,
         n619, n620, n621, n622, n623, n624, n625, n626, n627, n628, n629,
         n630, n631, n632, n633, n634, n635, n636, n637, n638, n639, n640,
         n641, n642, n643, n644, n645, n646, n647, n648, n649, n650, n651,
         n652, n653, n654, n655, n656, n657, n658, n659, n660, n661, n662,
         n663, n664, n665, n666, n667, n668, n669, n670, n671, n672, n673,
         n674, n675, N204, N203, N191, N190, add_1_root_r608_carry_4_,
         add_2_root_r608_carry_3_, n676, n677, n678, n679, n680, n681, n682,
         n683, n684, n685, n686, n687, n688, n689, n690, n691, n692, n693,
         n694, n695, n696, n697, n698, n699, n700, n701, n702, n703, n704,
         n705, n706, n707, n708, n709, n710, n711, n712, n713, n714, n715,
         n716, n718, n719, n720, n721, n722, n723, n724, n725, n726, n727,
         n728, n729, n730, n731, n732, n733, n734, n735, n736, n737, n738,
         n739, n740, n741, n742, n743, n744, n745, n746, n747, n748, n749,
         n750, n751, n752, n753, n754, n755, n756, n757, n758, n759, n760,
         n761, n762, n763, n764, n765, n766, n767, n768, n769, n770, n771,
         n772, n773, n774, n775, n776, n777, n778, n779, n780, n781, n782,
         n783, n784, n785, n786, n787, n788, n789, n790, n791, n792, n793,
         n794, n795, n796, n797, n798, n799, n800, n801, n802, n803, n804,
         n805, n806, n807, n808, n809, n810, n811, n812, n813, n814, n815,
         n816, n817, n818, n819, n820, n821, n822, n823, n824, n825, n826,
         n827, n828, n829, n830, n831, n832, n833, n834, n835, n836, n837,
         n838, n839, n840, n841, n842, n843, n844, n845, n846, n847, n848,
         n849, n850, n851, n852, n853, n854, n855, n856, n857, n858, n859,
         n860, n861, n862, n863, n864, n865, n866, n867, n868, n869, n870,
         n871, n872, n873, n874, n875, n876, n877, n878, n879, n880, n881,
         n882, n883, n884, n885, n886, n887, n888, n889, n890, n891, n892,
         n893, n894, n895, n896, n897, n898, n899, n900, n901, n902, n903,
         n904, n905, n906, n907, n908, n909, n910, n911, n912, n913, n914,
         n915, n916, n917, n918, n919, n920, n921, n922, n923, n924, n925,
         n926, n927, n928, n929, n930, n931, n932, n933, n934, n935, n936,
         n937, n938, n939, n940, n941, n942, n943, n944, n945, n946, n947,
         n948, n949, n950, n951, n952, n953, n954, n955, n956, n957, n958,
         n959, n960, n961, n962, n963, n964, n965;
  wire   [35:0] weight_address;
  wire   [23:0] weight_data;
  wire   [23:0] weight_output;
  wire   [2:0] weight_write_enable;
  wire   [2:0] weight_chip_enable;
  wire   [35:0] position_address;
  wire   [23:0] position_data;
  wire   [23:0] position_output;
  wire   [2:0] position_write_enable;
  wire   [2:0] position_chip_enable;
  wire   [7:0] bias_address;
  wire   [7:0] bias_data;
  wire   [7:0] bias_output;
  wire   [11:0] vector_address;
  wire   [7:0] vector_data;
  wire   [7:0] vector_output;
  wire   [3:0] state;
  wire   [7:1] row;
  wire   [1:0] bank;
  wire   [3:2] group;
  wire   [14:0] init_count;
  wire   [3:0] load_feature_id;
  wire   [7:0] load_elem_id;
  wire   [5:4] element_count;
  wire   [1:0] selected_sram;
  wire   [2:0] feature_id;
  wire   [7:0] weight_hold;
  wire   [21:0] acc;
  wire   [15:0] mult_product;
  wire   [21:0] result_hold;
  wire   [5:2] add_311_carry;
  wire   [13:5] add_0_root_add_265_2_carry;
  wire   [12:6] r605_carry;
  wire   [13:5] add_0_root_r608_carry;

  sram_4096x8 GEN_SRAM_0___weight ( .Q(weight_output[7:0]), .A(
        weight_address[11:0]), .D(weight_data[7:0]), .CLK(clk), .CEN(n959), 
        .WEN(n962) );
  sram_4096x8 GEN_SRAM_0___position ( .Q(position_output[7:0]), .A(
        position_address[11:0]), .D(position_data[7:0]), .CLK(clk), .CEN(n965), 
        .WEN(n954) );
  sram_4096x8 GEN_SRAM_1___weight ( .Q(weight_output[15:8]), .A(
        weight_address[23:12]), .D(weight_data[15:8]), .CLK(clk), .CEN(n958), 
        .WEN(n961) );
  sram_4096x8 GEN_SRAM_1___position ( .Q(position_output[15:8]), .A(
        position_address[23:12]), .D(position_data[15:8]), .CLK(clk), .CEN(
        n964), .WEN(n953) );
  sram_4096x8 GEN_SRAM_2___weight ( .Q(weight_output[23:16]), .A(
        weight_address[35:24]), .D(weight_data[23:16]), .CLK(clk), .CEN(n957), 
        .WEN(n960) );
  sram_4096x8 GEN_SRAM_2___position ( .Q(position_output[23:16]), .A(
        position_address[35:24]), .D(position_data[23:16]), .CLK(clk), .CEN(
        n963), .WEN(n952) );
  sram_256x8 u_bias ( .Q(bias_output), .A(bias_address), .D(bias_data), .CLK(
        clk), .CEN(n956), .WEN(n955) );
  sram_4096x8 u_vector ( .Q(vector_output), .A(vector_address), .D(vector_data), .CLK(clk), .CEN(n951), .WEN(n950) );
  SpMDV_DW01_add_0 add_325 ( .A(acc), .SUM({N535, N534, N533, N532, N531, N530, 
        N529, N528, N527, N526, N525, N524, N523, N522, N521, N520, N519, N518, 
        N517, N516, N515, N514}), .\B[21] (n723), .\B[20] (bias_output[7]), 
        .\B[19] (n723), .\B[18] (bias_output[7]), .\B[17] (n723), .\B[16] (
        bias_output[7]), .\B[15] (n723), .\B[14] (bias_output[7]), .\B[13] (
        n723), .\B[12] (bias_output[7]), .\B[11] (n723), .\B[10] (
        bias_output[6]), .\B[9] (bias_output[5]), .\B[8] (bias_output[4]), 
        .\B[7] (bias_output[3]), .\B[6] (bias_output[2]), .\B[5] (
        bias_output[1]), .\B[4] (bias_output[0]) );
  SpMDV_DW01_add_1 add_308 ( .A(acc), .B({mult_product[15], mult_product[15], 
        mult_product[15], mult_product[15], mult_product[15], mult_product[15], 
        mult_product}), .SUM({N507, N506, N505, N504, N503, N502, N501, N500, 
        N499, N498, N497, N496, N495, N494, N493, N492, N491, N490, N489, N488, 
        N487, N486}) );
  SpMDV_DW01_inc_1_DW01_inc_5 add_252 ( .A(load_elem_id), .SUM({N410, N409, 
        N408, N407, N406, N405, N404, N403}) );
  SpMDV_DW01_inc_2_DW01_inc_6 add_232 ( .A(init_count), .SUM({N384, N383, N382, 
        N381, N380, N379, N378, N377, N376, N375, N374, N373, N372, N371, N370}) );
  SpMDV_DW01_inc_3_DW01_inc_7 r613 ( .A({row, n721}), .SUM({N362, N361, N360, 
        N359, N358, N357, N356, N355}) );
  SpMDV_DW_mult_tc_0 mult_302 ( .a(weight_hold), .b(vector_output), .product({
        N484, N483, N482, N481, N480, N479, N478, N477, N476, N475, N474, N473, 
        N472, N471, N470, N469}) );
  DFFQX1 vector_data_reg_7_ ( .D(n416), .CK(clk), .Q(vector_data[7]) );
  DFFQX1 vector_data_reg_6_ ( .D(n417), .CK(clk), .Q(vector_data[6]) );
  DFFQX1 vector_data_reg_5_ ( .D(n418), .CK(clk), .Q(vector_data[5]) );
  DFFQX1 vector_data_reg_4_ ( .D(n419), .CK(clk), .Q(vector_data[4]) );
  DFFQX1 vector_data_reg_3_ ( .D(n420), .CK(clk), .Q(vector_data[3]) );
  DFFQX1 vector_data_reg_2_ ( .D(n421), .CK(clk), .Q(vector_data[2]) );
  DFFQX1 vector_data_reg_1_ ( .D(n422), .CK(clk), .Q(vector_data[1]) );
  DFFQX1 vector_data_reg_0_ ( .D(n423), .CK(clk), .Q(vector_data[0]) );
  DFFQX1 weight_data_reg_2__1_ ( .D(n4840), .CK(clk), .Q(weight_data[17]) );
  DFFQX1 weight_data_reg_2__2_ ( .D(n485), .CK(clk), .Q(weight_data[18]) );
  DFFQX1 weight_data_reg_2__3_ ( .D(n4860), .CK(clk), .Q(weight_data[19]) );
  DFFQX1 weight_data_reg_2__4_ ( .D(n4870), .CK(clk), .Q(weight_data[20]) );
  DFFQX1 weight_data_reg_2__5_ ( .D(n4880), .CK(clk), .Q(weight_data[21]) );
  DFFQX1 weight_data_reg_2__6_ ( .D(n4890), .CK(clk), .Q(weight_data[22]) );
  DFFQX1 weight_data_reg_2__7_ ( .D(n4900), .CK(clk), .Q(weight_data[23]) );
  DFFQX1 weight_data_reg_2__0_ ( .D(n4910), .CK(clk), .Q(weight_data[16]) );
  DFFQX1 weight_data_reg_1__1_ ( .D(n4920), .CK(clk), .Q(weight_data[9]) );
  DFFQX1 weight_data_reg_1__2_ ( .D(n4930), .CK(clk), .Q(weight_data[10]) );
  DFFQX1 weight_data_reg_1__3_ ( .D(n4940), .CK(clk), .Q(weight_data[11]) );
  DFFQX1 weight_data_reg_1__4_ ( .D(n4950), .CK(clk), .Q(weight_data[12]) );
  DFFQX1 weight_data_reg_1__5_ ( .D(n4960), .CK(clk), .Q(weight_data[13]) );
  DFFQX1 weight_data_reg_1__6_ ( .D(n4970), .CK(clk), .Q(weight_data[14]) );
  DFFQX1 weight_data_reg_1__7_ ( .D(n4980), .CK(clk), .Q(weight_data[15]) );
  DFFQX1 weight_data_reg_1__0_ ( .D(n4990), .CK(clk), .Q(weight_data[8]) );
  DFFQX1 weight_data_reg_0__1_ ( .D(n5000), .CK(clk), .Q(weight_data[1]) );
  DFFQX1 weight_data_reg_0__2_ ( .D(n5010), .CK(clk), .Q(weight_data[2]) );
  DFFQX1 weight_data_reg_0__3_ ( .D(n5020), .CK(clk), .Q(weight_data[3]) );
  DFFQX1 weight_data_reg_0__4_ ( .D(n5030), .CK(clk), .Q(weight_data[4]) );
  DFFQX1 weight_data_reg_0__5_ ( .D(n5040), .CK(clk), .Q(weight_data[5]) );
  DFFQX1 weight_data_reg_0__6_ ( .D(n5050), .CK(clk), .Q(weight_data[6]) );
  DFFQX1 weight_data_reg_0__7_ ( .D(n5060), .CK(clk), .Q(weight_data[7]) );
  DFFQX1 weight_data_reg_0__0_ ( .D(n5070), .CK(clk), .Q(weight_data[0]) );
  DFFQX1 position_data_reg_2__1_ ( .D(n424), .CK(clk), .Q(position_data[17])
         );
  DFFQX1 position_data_reg_2__2_ ( .D(n425), .CK(clk), .Q(position_data[18])
         );
  DFFQX1 position_data_reg_2__3_ ( .D(n426), .CK(clk), .Q(position_data[19])
         );
  DFFQX1 position_data_reg_2__4_ ( .D(n427), .CK(clk), .Q(position_data[20])
         );
  DFFQX1 position_data_reg_2__5_ ( .D(n428), .CK(clk), .Q(position_data[21])
         );
  DFFQX1 position_data_reg_2__6_ ( .D(n429), .CK(clk), .Q(position_data[22])
         );
  DFFQX1 position_data_reg_2__7_ ( .D(n430), .CK(clk), .Q(position_data[23])
         );
  DFFQX1 position_data_reg_2__0_ ( .D(n431), .CK(clk), .Q(position_data[16])
         );
  DFFQX1 position_data_reg_1__1_ ( .D(n432), .CK(clk), .Q(position_data[9]) );
  DFFQX1 position_data_reg_1__2_ ( .D(n433), .CK(clk), .Q(position_data[10])
         );
  DFFQX1 position_data_reg_1__3_ ( .D(n4340), .CK(clk), .Q(position_data[11])
         );
  DFFQX1 position_data_reg_1__4_ ( .D(n4350), .CK(clk), .Q(position_data[12])
         );
  DFFQX1 position_data_reg_1__5_ ( .D(n4360), .CK(clk), .Q(position_data[13])
         );
  DFFQX1 position_data_reg_1__0_ ( .D(n4370), .CK(clk), .Q(position_data[8])
         );
  DFFQX1 position_data_reg_1__7_ ( .D(n4380), .CK(clk), .Q(position_data[15])
         );
  DFFQX1 position_data_reg_1__6_ ( .D(n4390), .CK(clk), .Q(position_data[14])
         );
  DFFQX1 position_data_reg_0__1_ ( .D(n4400), .CK(clk), .Q(position_data[1])
         );
  DFFQX1 position_data_reg_0__2_ ( .D(n4410), .CK(clk), .Q(position_data[2])
         );
  DFFQX1 position_data_reg_0__3_ ( .D(n4420), .CK(clk), .Q(position_data[3])
         );
  DFFQX1 position_data_reg_0__4_ ( .D(n4430), .CK(clk), .Q(position_data[4])
         );
  DFFQX1 position_data_reg_0__5_ ( .D(n4440), .CK(clk), .Q(position_data[5])
         );
  DFFQX1 position_data_reg_0__6_ ( .D(n4450), .CK(clk), .Q(position_data[6])
         );
  DFFQX1 position_data_reg_0__7_ ( .D(n4460), .CK(clk), .Q(position_data[7])
         );
  DFFQX1 position_data_reg_0__0_ ( .D(n4470), .CK(clk), .Q(position_data[0])
         );
  DFFQX1 bias_data_reg_7_ ( .D(n566), .CK(clk), .Q(bias_data[7]) );
  DFFQX1 bias_data_reg_6_ ( .D(n567), .CK(clk), .Q(bias_data[6]) );
  DFFQX1 bias_data_reg_5_ ( .D(n568), .CK(clk), .Q(bias_data[5]) );
  DFFQX1 bias_data_reg_4_ ( .D(n569), .CK(clk), .Q(bias_data[4]) );
  DFFQX1 bias_data_reg_3_ ( .D(n570), .CK(clk), .Q(bias_data[3]) );
  DFFQX1 bias_data_reg_2_ ( .D(n571), .CK(clk), .Q(bias_data[2]) );
  DFFQX1 bias_data_reg_1_ ( .D(n572), .CK(clk), .Q(bias_data[1]) );
  DFFQX1 bias_data_reg_0_ ( .D(n573), .CK(clk), .Q(bias_data[0]) );
  DFFQX1 result_hold_reg_0_ ( .D(n565), .CK(clk), .Q(result_hold[0]) );
  DFFQX1 result_hold_reg_1_ ( .D(n564), .CK(clk), .Q(result_hold[1]) );
  DFFQX1 result_hold_reg_2_ ( .D(n563), .CK(clk), .Q(result_hold[2]) );
  DFFQX1 result_hold_reg_3_ ( .D(n562), .CK(clk), .Q(result_hold[3]) );
  DFFQX1 result_hold_reg_4_ ( .D(n561), .CK(clk), .Q(result_hold[4]) );
  DFFQX1 result_hold_reg_5_ ( .D(n560), .CK(clk), .Q(result_hold[5]) );
  DFFQX1 result_hold_reg_6_ ( .D(n559), .CK(clk), .Q(result_hold[6]) );
  DFFQX1 result_hold_reg_7_ ( .D(n558), .CK(clk), .Q(result_hold[7]) );
  DFFQX1 result_hold_reg_8_ ( .D(n557), .CK(clk), .Q(result_hold[8]) );
  DFFQX1 result_hold_reg_9_ ( .D(n556), .CK(clk), .Q(result_hold[9]) );
  DFFQX1 result_hold_reg_10_ ( .D(n555), .CK(clk), .Q(result_hold[10]) );
  DFFQX1 result_hold_reg_11_ ( .D(n554), .CK(clk), .Q(result_hold[11]) );
  DFFQX1 result_hold_reg_12_ ( .D(n553), .CK(clk), .Q(result_hold[12]) );
  DFFQX1 result_hold_reg_13_ ( .D(n552), .CK(clk), .Q(result_hold[13]) );
  DFFQX1 result_hold_reg_14_ ( .D(n551), .CK(clk), .Q(result_hold[14]) );
  DFFQX1 result_hold_reg_15_ ( .D(n550), .CK(clk), .Q(result_hold[15]) );
  DFFQX1 result_hold_reg_16_ ( .D(n549), .CK(clk), .Q(result_hold[16]) );
  DFFQX1 result_hold_reg_17_ ( .D(n548), .CK(clk), .Q(result_hold[17]) );
  DFFQX1 result_hold_reg_18_ ( .D(n547), .CK(clk), .Q(result_hold[18]) );
  DFFQX1 result_hold_reg_19_ ( .D(n546), .CK(clk), .Q(result_hold[19]) );
  DFFQX1 bias_address_reg_7_ ( .D(n574), .CK(clk), .Q(bias_address[7]) );
  DFFQX1 bias_address_reg_6_ ( .D(n575), .CK(clk), .Q(bias_address[6]) );
  DFFQX1 bias_address_reg_5_ ( .D(n576), .CK(clk), .Q(bias_address[5]) );
  DFFQX1 bias_address_reg_4_ ( .D(n577), .CK(clk), .Q(bias_address[4]) );
  DFFQX1 bias_address_reg_3_ ( .D(n578), .CK(clk), .Q(bias_address[3]) );
  DFFQX1 bias_address_reg_2_ ( .D(n579), .CK(clk), .Q(bias_address[2]) );
  DFFQX1 bias_address_reg_1_ ( .D(n580), .CK(clk), .Q(bias_address[1]) );
  DFFQX1 bias_address_reg_0_ ( .D(n581), .CK(clk), .Q(bias_address[0]) );
  DFFQX1 weight_address_reg_2__1_ ( .D(n5080), .CK(clk), .Q(weight_address[25]) );
  DFFQX1 weight_address_reg_2__2_ ( .D(n5090), .CK(clk), .Q(weight_address[26]) );
  DFFQX1 weight_address_reg_2__3_ ( .D(n5100), .CK(clk), .Q(weight_address[27]) );
  DFFQX1 weight_address_reg_2__4_ ( .D(n5110), .CK(clk), .Q(weight_address[28]) );
  DFFQX1 weight_address_reg_2__5_ ( .D(n5120), .CK(clk), .Q(weight_address[29]) );
  DFFQX1 weight_address_reg_2__6_ ( .D(n5130), .CK(clk), .Q(weight_address[30]) );
  DFFQX1 weight_address_reg_2__7_ ( .D(n5140), .CK(clk), .Q(weight_address[31]) );
  DFFQX1 weight_address_reg_2__8_ ( .D(n5150), .CK(clk), .Q(weight_address[32]) );
  DFFQX1 weight_address_reg_2__9_ ( .D(n5160), .CK(clk), .Q(weight_address[33]) );
  DFFQX1 weight_address_reg_2__10_ ( .D(n5170), .CK(clk), .Q(
        weight_address[34]) );
  DFFQX1 weight_address_reg_2__11_ ( .D(n5180), .CK(clk), .Q(
        weight_address[35]) );
  DFFQX1 weight_address_reg_2__0_ ( .D(n5190), .CK(clk), .Q(weight_address[24]) );
  DFFQX1 weight_address_reg_1__1_ ( .D(n5200), .CK(clk), .Q(weight_address[13]) );
  DFFQX1 weight_address_reg_1__2_ ( .D(n5210), .CK(clk), .Q(weight_address[14]) );
  DFFQX1 weight_address_reg_1__3_ ( .D(n5220), .CK(clk), .Q(weight_address[15]) );
  DFFQX1 weight_address_reg_1__4_ ( .D(n5230), .CK(clk), .Q(weight_address[16]) );
  DFFQX1 weight_address_reg_1__5_ ( .D(n5240), .CK(clk), .Q(weight_address[17]) );
  DFFQX1 weight_address_reg_1__6_ ( .D(n5250), .CK(clk), .Q(weight_address[18]) );
  DFFQX1 weight_address_reg_1__7_ ( .D(n5260), .CK(clk), .Q(weight_address[19]) );
  DFFQX1 weight_address_reg_1__8_ ( .D(n5270), .CK(clk), .Q(weight_address[20]) );
  DFFQX1 weight_address_reg_1__9_ ( .D(n5280), .CK(clk), .Q(weight_address[21]) );
  DFFQX1 weight_address_reg_1__10_ ( .D(n5290), .CK(clk), .Q(
        weight_address[22]) );
  DFFQX1 weight_address_reg_1__11_ ( .D(n5300), .CK(clk), .Q(
        weight_address[23]) );
  DFFQX1 weight_address_reg_1__0_ ( .D(n5310), .CK(clk), .Q(weight_address[12]) );
  DFFQX1 weight_address_reg_0__1_ ( .D(n5320), .CK(clk), .Q(weight_address[1])
         );
  DFFQX1 weight_address_reg_0__2_ ( .D(n5330), .CK(clk), .Q(weight_address[2])
         );
  DFFQX1 weight_address_reg_0__3_ ( .D(n5340), .CK(clk), .Q(weight_address[3])
         );
  DFFQX1 weight_address_reg_0__4_ ( .D(n5350), .CK(clk), .Q(weight_address[4])
         );
  DFFQX1 weight_address_reg_0__5_ ( .D(n536), .CK(clk), .Q(weight_address[5])
         );
  DFFQX1 weight_address_reg_0__6_ ( .D(n537), .CK(clk), .Q(weight_address[6])
         );
  DFFQX1 weight_address_reg_0__7_ ( .D(n538), .CK(clk), .Q(weight_address[7])
         );
  DFFQX1 weight_address_reg_0__8_ ( .D(n539), .CK(clk), .Q(weight_address[8])
         );
  DFFQX1 weight_address_reg_0__9_ ( .D(n540), .CK(clk), .Q(weight_address[9])
         );
  DFFQX1 weight_address_reg_0__10_ ( .D(n541), .CK(clk), .Q(weight_address[10]) );
  DFFQX1 weight_address_reg_0__11_ ( .D(n542), .CK(clk), .Q(weight_address[11]) );
  DFFQX1 weight_address_reg_0__0_ ( .D(n543), .CK(clk), .Q(weight_address[0])
         );
  DFFQX1 position_address_reg_2__1_ ( .D(n448), .CK(clk), .Q(
        position_address[25]) );
  DFFQX1 position_address_reg_2__2_ ( .D(n449), .CK(clk), .Q(
        position_address[26]) );
  DFFQX1 position_address_reg_2__3_ ( .D(n450), .CK(clk), .Q(
        position_address[27]) );
  DFFQX1 position_address_reg_2__4_ ( .D(n451), .CK(clk), .Q(
        position_address[28]) );
  DFFQX1 position_address_reg_2__5_ ( .D(n452), .CK(clk), .Q(
        position_address[29]) );
  DFFQX1 position_address_reg_2__6_ ( .D(n453), .CK(clk), .Q(
        position_address[30]) );
  DFFQX1 position_address_reg_2__7_ ( .D(n454), .CK(clk), .Q(
        position_address[31]) );
  DFFQX1 position_address_reg_2__8_ ( .D(n455), .CK(clk), .Q(
        position_address[32]) );
  DFFQX1 position_address_reg_2__9_ ( .D(n456), .CK(clk), .Q(
        position_address[33]) );
  DFFQX1 position_address_reg_2__10_ ( .D(n457), .CK(clk), .Q(
        position_address[34]) );
  DFFQX1 position_address_reg_2__11_ ( .D(n458), .CK(clk), .Q(
        position_address[35]) );
  DFFQX1 position_address_reg_2__0_ ( .D(n459), .CK(clk), .Q(
        position_address[24]) );
  DFFQX1 position_address_reg_1__1_ ( .D(n460), .CK(clk), .Q(
        position_address[13]) );
  DFFQX1 position_address_reg_1__2_ ( .D(n461), .CK(clk), .Q(
        position_address[14]) );
  DFFQX1 position_address_reg_1__3_ ( .D(n462), .CK(clk), .Q(
        position_address[15]) );
  DFFQX1 position_address_reg_1__4_ ( .D(n463), .CK(clk), .Q(
        position_address[16]) );
  DFFQX1 position_address_reg_1__5_ ( .D(n464), .CK(clk), .Q(
        position_address[17]) );
  DFFQX1 position_address_reg_1__6_ ( .D(n465), .CK(clk), .Q(
        position_address[18]) );
  DFFQX1 position_address_reg_1__7_ ( .D(n466), .CK(clk), .Q(
        position_address[19]) );
  DFFQX1 position_address_reg_1__8_ ( .D(n467), .CK(clk), .Q(
        position_address[20]) );
  DFFQX1 position_address_reg_1__9_ ( .D(n468), .CK(clk), .Q(
        position_address[21]) );
  DFFQX1 position_address_reg_1__10_ ( .D(n4690), .CK(clk), .Q(
        position_address[22]) );
  DFFQX1 position_address_reg_1__11_ ( .D(n4700), .CK(clk), .Q(
        position_address[23]) );
  DFFQX1 position_address_reg_1__0_ ( .D(n4710), .CK(clk), .Q(
        position_address[12]) );
  DFFQX1 position_address_reg_0__1_ ( .D(n4720), .CK(clk), .Q(
        position_address[1]) );
  DFFQX1 position_address_reg_0__2_ ( .D(n4730), .CK(clk), .Q(
        position_address[2]) );
  DFFQX1 position_address_reg_0__3_ ( .D(n4740), .CK(clk), .Q(
        position_address[3]) );
  DFFQX1 position_address_reg_0__4_ ( .D(n4750), .CK(clk), .Q(
        position_address[4]) );
  DFFQX1 position_address_reg_0__5_ ( .D(n4760), .CK(clk), .Q(
        position_address[5]) );
  DFFQX1 position_address_reg_0__6_ ( .D(n4770), .CK(clk), .Q(
        position_address[6]) );
  DFFQX1 position_address_reg_0__7_ ( .D(n4780), .CK(clk), .Q(
        position_address[7]) );
  DFFQX1 position_address_reg_0__8_ ( .D(n4790), .CK(clk), .Q(
        position_address[8]) );
  DFFQX1 position_address_reg_0__9_ ( .D(n4800), .CK(clk), .Q(
        position_address[9]) );
  DFFQX1 position_address_reg_0__10_ ( .D(n4810), .CK(clk), .Q(
        position_address[10]) );
  DFFQX1 position_address_reg_0__11_ ( .D(n4820), .CK(clk), .Q(
        position_address[11]) );
  DFFQX1 position_address_reg_0__0_ ( .D(n4830), .CK(clk), .Q(
        position_address[0]) );
  DFFQX1 vector_address_reg_11_ ( .D(n3740), .CK(clk), .Q(vector_address[11])
         );
  DFFQX1 vector_address_reg_10_ ( .D(n3750), .CK(clk), .Q(vector_address[10])
         );
  DFFQX1 vector_address_reg_9_ ( .D(n3760), .CK(clk), .Q(vector_address[9]) );
  DFFQX1 vector_address_reg_8_ ( .D(n3770), .CK(clk), .Q(vector_address[8]) );
  DFFQX1 vector_address_reg_0_ ( .D(n385), .CK(clk), .Q(vector_address[0]) );
  DFFQX1 vector_address_reg_1_ ( .D(n3840), .CK(clk), .Q(vector_address[1]) );
  DFFQX1 vector_address_reg_2_ ( .D(n3830), .CK(clk), .Q(vector_address[2]) );
  DFFQX1 vector_address_reg_3_ ( .D(n3820), .CK(clk), .Q(vector_address[3]) );
  DFFQX1 vector_address_reg_4_ ( .D(n3810), .CK(clk), .Q(vector_address[4]) );
  DFFQX1 vector_address_reg_5_ ( .D(n3800), .CK(clk), .Q(vector_address[5]) );
  DFFQX1 vector_address_reg_6_ ( .D(n3790), .CK(clk), .Q(vector_address[6]) );
  DFFQX1 vector_address_reg_7_ ( .D(n3780), .CK(clk), .Q(vector_address[7]) );
  DFFQX1 vector_write_enable_reg ( .D(n346), .CK(clk), .Q(vector_write_enable)
         );
  DFFQX1 position_write_enable_reg_2_ ( .D(n344), .CK(clk), .Q(
        position_write_enable[2]) );
  DFFQX1 position_write_enable_reg_1_ ( .D(n343), .CK(clk), .Q(
        position_write_enable[1]) );
  DFFQX1 position_write_enable_reg_0_ ( .D(n342), .CK(clk), .Q(
        position_write_enable[0]) );
  DFFQX1 bias_write_enable_reg ( .D(n341), .CK(clk), .Q(bias_write_enable) );
  DFFQX1 weight_write_enable_reg_2_ ( .D(n336), .CK(clk), .Q(
        weight_write_enable[2]) );
  DFFQX1 weight_write_enable_reg_1_ ( .D(n335), .CK(clk), .Q(
        weight_write_enable[1]) );
  DFFQX1 weight_write_enable_reg_0_ ( .D(n334), .CK(clk), .Q(
        weight_write_enable[0]) );
  DFFQX1 vector_chip_enable_reg ( .D(n345), .CK(clk), .Q(vector_chip_enable)
         );
  DFFQX1 bias_chip_enable_reg ( .D(n340), .CK(clk), .Q(bias_chip_enable) );
  DFFQX1 weight_chip_enable_reg_2_ ( .D(n339), .CK(clk), .Q(
        weight_chip_enable[2]) );
  DFFQX1 weight_chip_enable_reg_1_ ( .D(n338), .CK(clk), .Q(
        weight_chip_enable[1]) );
  DFFQX1 weight_chip_enable_reg_0_ ( .D(n337), .CK(clk), .Q(
        weight_chip_enable[0]) );
  DFFQX1 position_chip_enable_reg_2_ ( .D(n333), .CK(clk), .Q(
        position_chip_enable[2]) );
  DFFQX1 position_chip_enable_reg_1_ ( .D(n332), .CK(clk), .Q(
        position_chip_enable[1]) );
  DFFQX1 position_chip_enable_reg_0_ ( .D(n331), .CK(clk), .Q(
        position_chip_enable[0]) );
  DFFQX1 acc_reg_19_ ( .D(n617), .CK(clk), .Q(acc[19]) );
  DFFQX1 acc_reg_18_ ( .D(n618), .CK(clk), .Q(acc[18]) );
  DFFQX1 selected_sram_reg_0_ ( .D(n583), .CK(clk), .Q(selected_sram[0]) );
  DFFQX1 selected_sram_reg_1_ ( .D(n582), .CK(clk), .Q(selected_sram[1]) );
  DFFQX1 acc_reg_14_ ( .D(n622), .CK(clk), .Q(acc[14]) );
  DFFX1 feature_id_reg_3_ ( .D(n587), .CK(clk), .QN(n947) );
  DFFQX1 mult_product_reg_13_ ( .D(n640), .CK(clk), .Q(mult_product[13]) );
  DFFQX1 init_count_reg_9_ ( .D(n607), .CK(clk), .Q(init_count[9]) );
  DFFQX1 o_valid_reg ( .D(n347), .CK(clk), .Q(o_valid) );
  DFFQX1 o_result_reg_21_ ( .D(n415), .CK(clk), .Q(o_result[21]) );
  DFFQX1 o_result_reg_20_ ( .D(n414), .CK(clk), .Q(o_result[20]) );
  DFFQX1 o_result_reg_19_ ( .D(n413), .CK(clk), .Q(o_result[19]) );
  DFFQX1 o_result_reg_18_ ( .D(n412), .CK(clk), .Q(o_result[18]) );
  DFFQX1 o_result_reg_17_ ( .D(n411), .CK(clk), .Q(o_result[17]) );
  DFFQX1 o_result_reg_16_ ( .D(n4100), .CK(clk), .Q(o_result[16]) );
  DFFQX1 o_result_reg_15_ ( .D(n4090), .CK(clk), .Q(o_result[15]) );
  DFFQX1 o_result_reg_14_ ( .D(n4080), .CK(clk), .Q(o_result[14]) );
  DFFQX1 o_result_reg_13_ ( .D(n4070), .CK(clk), .Q(o_result[13]) );
  DFFQX1 o_result_reg_12_ ( .D(n4060), .CK(clk), .Q(o_result[12]) );
  DFFQX1 o_result_reg_11_ ( .D(n4050), .CK(clk), .Q(o_result[11]) );
  DFFQX1 o_result_reg_10_ ( .D(n4040), .CK(clk), .Q(o_result[10]) );
  DFFQX1 o_result_reg_9_ ( .D(n4030), .CK(clk), .Q(o_result[9]) );
  DFFQX1 o_result_reg_8_ ( .D(n402), .CK(clk), .Q(o_result[8]) );
  DFFQX1 o_result_reg_7_ ( .D(n401), .CK(clk), .Q(o_result[7]) );
  DFFQX1 o_result_reg_6_ ( .D(n400), .CK(clk), .Q(o_result[6]) );
  DFFQX1 o_result_reg_5_ ( .D(n399), .CK(clk), .Q(o_result[5]) );
  DFFQX1 o_result_reg_4_ ( .D(n398), .CK(clk), .Q(o_result[4]) );
  DFFQX1 o_result_reg_3_ ( .D(n397), .CK(clk), .Q(o_result[3]) );
  DFFQX1 o_result_reg_2_ ( .D(n396), .CK(clk), .Q(o_result[2]) );
  DFFQX1 o_result_reg_1_ ( .D(n395), .CK(clk), .Q(o_result[1]) );
  DFFQX1 o_result_reg_0_ ( .D(n394), .CK(clk), .Q(o_result[0]) );
  DFFQX1 init_count_reg_8_ ( .D(n608), .CK(clk), .Q(init_count[8]) );
  DFFQX1 init_count_reg_11_ ( .D(n605), .CK(clk), .Q(init_count[11]) );
  DFFQX1 acc_reg_13_ ( .D(n623), .CK(clk), .Q(acc[13]) );
  DFFQX1 init_count_reg_10_ ( .D(n606), .CK(clk), .Q(init_count[10]) );
  DFFQX1 init_count_reg_7_ ( .D(n609), .CK(clk), .Q(init_count[7]) );
  DFFQX1 init_count_reg_5_ ( .D(n611), .CK(clk), .Q(init_count[5]) );
  DFFQX1 init_count_reg_6_ ( .D(n610), .CK(clk), .Q(init_count[6]) );
  DFFQX1 init_count_reg_3_ ( .D(n613), .CK(clk), .Q(init_count[3]) );
  DFFQX1 feature_id_reg_2_ ( .D(n584), .CK(clk), .Q(feature_id[2]) );
  DFFQX1 init_count_reg_4_ ( .D(n612), .CK(clk), .Q(init_count[4]) );
  DFFQX1 init_count_reg_2_ ( .D(n614), .CK(clk), .Q(init_count[2]) );
  DFFQX1 mult_product_reg_12_ ( .D(n641), .CK(clk), .Q(mult_product[12]) );
  DFFQX1 feature_id_reg_1_ ( .D(n585), .CK(clk), .Q(feature_id[1]) );
  DFFQX1 feature_id_reg_0_ ( .D(n586), .CK(clk), .Q(feature_id[0]) );
  DFFQX1 acc_reg_12_ ( .D(n624), .CK(clk), .Q(acc[12]) );
  DFFQX1 init_count_reg_1_ ( .D(n615), .CK(clk), .Q(init_count[1]) );
  DFFQX1 init_count_reg_0_ ( .D(n675), .CK(clk), .Q(init_count[0]) );
  DFFQX1 group_reg_1_ ( .D(n597), .CK(clk), .Q(N215) );
  DFFQX1 group_reg_0_ ( .D(n598), .CK(clk), .Q(N214) );
  DFFQX1 element_count_reg_3_ ( .D(n655), .CK(clk), .Q(N437) );
  DFFQX1 element_count_reg_2_ ( .D(n656), .CK(clk), .Q(N436) );
  DFFQX1 mult_product_reg_9_ ( .D(n644), .CK(clk), .Q(mult_product[9]) );
  DFFQX1 acc_reg_9_ ( .D(n627), .CK(clk), .Q(acc[9]) );
  DFFQX1 mult_product_reg_8_ ( .D(n645), .CK(clk), .Q(mult_product[8]) );
  DFFQX1 element_count_reg_1_ ( .D(n657), .CK(clk), .Q(N435) );
  DFFQX1 element_count_reg_0_ ( .D(n658), .CK(clk), .Q(N434) );
  DFFQX1 mult_product_reg_7_ ( .D(n646), .CK(clk), .Q(mult_product[7]) );
  DFFQX1 init_count_reg_12_ ( .D(n604), .CK(clk), .Q(init_count[12]) );
  DFFQX1 mult_product_reg_6_ ( .D(n647), .CK(clk), .Q(mult_product[6]) );
  DFFQX1 acc_reg_6_ ( .D(n630), .CK(clk), .Q(acc[6]) );
  DFFQX1 mult_product_reg_5_ ( .D(n648), .CK(clk), .Q(mult_product[5]) );
  DFFQX1 load_feature_id_reg_3_ ( .D(n662), .CK(clk), .Q(load_feature_id[3])
         );
  DFFQX1 acc_reg_5_ ( .D(n631), .CK(clk), .Q(acc[5]) );
  DFFQX1 load_feature_id_reg_2_ ( .D(n948), .CK(clk), .Q(load_feature_id[2])
         );
  DFFQX1 load_feature_id_reg_1_ ( .D(n660), .CK(clk), .Q(load_feature_id[1])
         );
  DFFQX1 mult_product_reg_4_ ( .D(n649), .CK(clk), .Q(mult_product[4]) );
  DFFQX1 mult_product_reg_3_ ( .D(n650), .CK(clk), .Q(mult_product[3]) );
  DFFQX1 load_feature_id_reg_0_ ( .D(n661), .CK(clk), .Q(load_feature_id[0])
         );
  DFFQX1 init_count_reg_14_ ( .D(n602), .CK(clk), .Q(init_count[14]) );
  DFFX1 load_elem_id_reg_4_ ( .D(n665), .CK(clk), .Q(load_elem_id[4]), .QN(
        n3560) );
  DFFX1 load_elem_id_reg_0_ ( .D(n669), .CK(clk), .Q(load_elem_id[0]), .QN(
        n3600) );
  DFFX1 load_elem_id_reg_5_ ( .D(n664), .CK(clk), .Q(load_elem_id[5]), .QN(
        n3550) );
  DFFX1 load_elem_id_reg_6_ ( .D(n663), .CK(clk), .Q(load_elem_id[6]), .QN(
        n354) );
  DFFX1 load_elem_id_reg_1_ ( .D(n668), .CK(clk), .Q(load_elem_id[1]), .QN(
        n3590) );
  DFFX1 load_elem_id_reg_7_ ( .D(n670), .CK(clk), .Q(load_elem_id[7]), .QN(
        n353) );
  DFFX1 load_elem_id_reg_2_ ( .D(n667), .CK(clk), .Q(load_elem_id[2]), .QN(
        n3580) );
  DFFQX1 init_count_reg_13_ ( .D(n603), .CK(clk), .Q(init_count[13]) );
  DFFX1 load_elem_id_reg_3_ ( .D(n666), .CK(clk), .Q(load_elem_id[3]), .QN(
        n3570) );
  DFFQX1 element_count_reg_5_ ( .D(n659), .CK(clk), .Q(element_count[5]) );
  DFFQX1 element_count_reg_4_ ( .D(n654), .CK(clk), .Q(element_count[4]) );
  DFFQX1 weight_hold_reg_6_ ( .D(n387), .CK(clk), .Q(weight_hold[6]) );
  DFFQX1 weight_hold_reg_7_ ( .D(n386), .CK(clk), .Q(weight_hold[7]) );
  DFFQX1 weight_hold_reg_0_ ( .D(n393), .CK(clk), .Q(weight_hold[0]) );
  DFFQX1 weight_hold_reg_2_ ( .D(n391), .CK(clk), .Q(weight_hold[2]) );
  DFFQX1 weight_hold_reg_4_ ( .D(n389), .CK(clk), .Q(weight_hold[4]) );
  DFFQX1 weight_hold_reg_3_ ( .D(n390), .CK(clk), .Q(weight_hold[3]) );
  DFFQX1 weight_hold_reg_5_ ( .D(n388), .CK(clk), .Q(weight_hold[5]) );
  DFFX1 row_reg_0_ ( .D(n594), .CK(clk), .Q(N176), .QN(n688) );
  DFFQX1 group_reg_3_ ( .D(n599), .CK(clk), .Q(group[3]) );
  DFFRX1 state_reg_3_ ( .D(n674), .CK(clk), .RN(n725), .Q(state[3]), .QN(n735)
         );
  DFFRX1 state_reg_2_ ( .D(n673), .CK(clk), .RN(n725), .Q(state[2]), .QN(n685)
         );
  DFFRX1 state_reg_1_ ( .D(n672), .CK(clk), .RN(n725), .Q(state[1]), .QN(n684)
         );
  DFFRX1 state_reg_0_ ( .D(n671), .CK(clk), .RN(n725), .Q(state[0]), .QN(n681)
         );
  DFFX1 row_reg_7_ ( .D(n588), .CK(clk), .Q(row[7]), .QN(n677) );
  DFFQX1 weight_hold_reg_1_ ( .D(n392), .CK(clk), .Q(weight_hold[1]) );
  DFFX1 row_reg_6_ ( .D(n589), .CK(clk), .Q(row[6]), .QN(n680) );
  DFFX1 row_reg_5_ ( .D(n590), .CK(clk), .Q(row[5]), .QN(n683) );
  DFFX1 row_reg_4_ ( .D(n591), .CK(clk), .Q(row[4]), .QN(n687) );
  DFFX1 row_reg_3_ ( .D(n592), .CK(clk), .Q(row[3]), .QN(n679) );
  DFFX1 row_reg_2_ ( .D(n593), .CK(clk), .Q(row[2]), .QN(n682) );
  DFFX1 row_reg_1_ ( .D(n595), .CK(clk), .Q(row[1]), .QN(n678) );
  DFFQX1 acc_reg_8_ ( .D(n628), .CK(clk), .Q(acc[8]) );
  DFFQXL result_hold_reg_21_ ( .D(n544), .CK(clk), .Q(result_hold[21]) );
  DFFQXL result_hold_reg_20_ ( .D(n545), .CK(clk), .Q(result_hold[20]) );
  DFFQX1 group_reg_2_ ( .D(n596), .CK(clk), .Q(group[2]) );
  DFFQX1 bank_reg_0_ ( .D(n600), .CK(clk), .Q(bank[0]) );
  DFFQX1 mult_product_reg_14_ ( .D(n639), .CK(clk), .Q(mult_product[14]) );
  DFFQX1 acc_reg_20_ ( .D(n616), .CK(clk), .Q(acc[20]) );
  DFFQX1 mult_product_reg_11_ ( .D(n642), .CK(clk), .Q(mult_product[11]) );
  DFFQX1 acc_reg_15_ ( .D(n621), .CK(clk), .Q(acc[15]) );
  DFFQX2 acc_reg_11_ ( .D(n625), .CK(clk), .Q(acc[11]) );
  DFFQXL acc_reg_21_ ( .D(n637), .CK(clk), .Q(acc[21]) );
  DFFQX1 mult_product_reg_10_ ( .D(n643), .CK(clk), .Q(mult_product[10]) );
  DFFQX1 acc_reg_7_ ( .D(n629), .CK(clk), .Q(acc[7]) );
  DFFQX2 acc_reg_17_ ( .D(n619), .CK(clk), .Q(acc[17]) );
  DFFQX4 mult_product_reg_15_ ( .D(n638), .CK(clk), .Q(mult_product[15]) );
  DFFQX1 acc_reg_3_ ( .D(n633), .CK(clk), .Q(acc[3]) );
  DFFQX1 mult_product_reg_2_ ( .D(n651), .CK(clk), .Q(mult_product[2]) );
  DFFQX1 acc_reg_2_ ( .D(n634), .CK(clk), .Q(acc[2]) );
  DFFQX2 acc_reg_10_ ( .D(n626), .CK(clk), .Q(acc[10]) );
  DFFQX1 acc_reg_4_ ( .D(n632), .CK(clk), .Q(acc[4]) );
  DFFQX2 acc_reg_16_ ( .D(n620), .CK(clk), .Q(acc[16]) );
  DFFQX2 acc_reg_0_ ( .D(n636), .CK(clk), .Q(acc[0]) );
  DFFQX2 acc_reg_1_ ( .D(n635), .CK(clk), .Q(acc[1]) );
  DFFQX2 mult_product_reg_0_ ( .D(n653), .CK(clk), .Q(mult_product[0]) );
  DFFQX2 mult_product_reg_1_ ( .D(n652), .CK(clk), .Q(mult_product[1]) );
  DFFQX2 bank_reg_1_ ( .D(n601), .CK(clk), .Q(bank[1]) );
  BUFX4 U585 ( .A(n839), .Y(n676) );
  NOR2X4 U586 ( .A(n741), .B(n695), .Y(n686) );
  OAI31X1 U587 ( .A0(n822), .A1(n821), .A2(n818), .B0(n798), .Y(n827) );
  NAND2X2 U588 ( .A(n805), .B(n725), .Y(n798) );
  INVX2 U589 ( .A(n895), .Y(n886) );
  AOI211X4 U590 ( .A0(state[0]), .A1(n726), .B0(n684), .C0(n727), .Y(
        raw_data_request) );
  AOI21X2 U591 ( .A0(init_count[13]), .A1(init_count[12]), .B0(init_count[14]), 
        .Y(n939) );
  OAI21X1 U592 ( .A0(n773), .A1(n701), .B0(n786), .Y(n794) );
  NAND2X2 U593 ( .A(n896), .B(n895), .Y(n885) );
  CLKXOR2X2 U594 ( .A(N185), .B(add_0_root_r608_carry[13]), .Y(N227) );
  AND2X2 U595 ( .A(add_0_root_r608_carry[12]), .B(N184), .Y(
        add_0_root_r608_carry[13]) );
  AND3X2 U596 ( .A(n784), .B(n773), .C(n762), .Y(n785) );
  NOR3X2 U597 ( .A(n727), .B(n681), .C(n684), .Y(n762) );
  INVX3 U598 ( .A(n722), .Y(n723) );
  INVX1 U599 ( .A(n762), .Y(n792) );
  CLKBUFX3 U600 ( .A(n873), .Y(n707) );
  CLKINVX1 U601 ( .A(n925), .Y(n943) );
  CLKBUFX3 U602 ( .A(n877), .Y(n715) );
  AND2X2 U603 ( .A(add_0_root_r608_carry[11]), .B(N183), .Y(
        add_0_root_r608_carry[12]) );
  AND2X2 U604 ( .A(add_0_root_r608_carry[7]), .B(N179), .Y(
        add_0_root_r608_carry[8]) );
  AND2X2 U605 ( .A(add_0_root_r608_carry[9]), .B(N181), .Y(
        add_0_root_r608_carry[10]) );
  AND2X2 U606 ( .A(n835), .B(n833), .Y(n834) );
  CLKBUFX3 U607 ( .A(n878), .Y(n714) );
  MXI2XL U608 ( .A(n794), .B(n795), .S0(n774), .Y(n661) );
  NAND2XL U609 ( .A(n762), .B(n794), .Y(n795) );
  NOR4XL U610 ( .A(ld_w_request), .B(n716), .C(n762), .D(n752), .Y(n776) );
  INVX1 U611 ( .A(n939), .Y(n924) );
  NAND3XL U612 ( .A(load_feature_id[0]), .B(n794), .C(n762), .Y(n731) );
  MXI2XL U613 ( .A(n826), .B(n827), .S0(N214), .Y(n598) );
  ADDFXL U614 ( .A(bank[1]), .B(N204), .CI(add_1_root_r608_carry_4_), .CO(N191), .S(N190) );
  ADDFXL U615 ( .A(group[3]), .B(bank[1]), .CI(add_2_root_r608_carry_3_), .CO(
        N204), .S(N203) );
  CLKBUFX3 U616 ( .A(bank[0]), .Y(n718) );
  INVX1 U617 ( .A(N227), .Y(n930) );
  NAND2XL U618 ( .A(n925), .B(n923), .Y(n880) );
  XOR2XL U619 ( .A(N183), .B(add_0_root_r608_carry[11]), .Y(N225) );
  XOR2XL U620 ( .A(N182), .B(add_0_root_r608_carry[10]), .Y(N224) );
  XOR2XL U621 ( .A(N181), .B(add_0_root_r608_carry[9]), .Y(N223) );
  XOR2XL U622 ( .A(N180), .B(add_0_root_r608_carry[8]), .Y(N222) );
  XOR2XL U623 ( .A(N179), .B(add_0_root_r608_carry[7]), .Y(N221) );
  XOR2XL U624 ( .A(N178), .B(add_0_root_r608_carry[6]), .Y(N220) );
  MX2XL U625 ( .A(n718), .B(position_data[14]), .S0(n703), .Y(n4390) );
  MX2XL U626 ( .A(bank[1]), .B(position_data[15]), .S0(n703), .Y(n4380) );
  CLKINVX1 U627 ( .A(bias_output[7]), .Y(n722) );
  MX2XL U628 ( .A(n718), .B(position_data[6]), .S0(n704), .Y(n4450) );
  MX2XL U629 ( .A(bank[1]), .B(position_data[7]), .S0(n704), .Y(n4460) );
  MX2XL U630 ( .A(n718), .B(position_data[22]), .S0(n702), .Y(n429) );
  MX2XL U631 ( .A(bank[1]), .B(position_data[23]), .S0(n702), .Y(n430) );
  MXI2XL U632 ( .A(n823), .B(n824), .S0(group[3]), .Y(n599) );
  NAND4XL U633 ( .A(group[2]), .B(n825), .C(N215), .D(N214), .Y(n823) );
  AO22XL U634 ( .A0(acc[5]), .A1(n692), .B0(N491), .B1(n691), .Y(n631) );
  AO22XL U635 ( .A0(acc[4]), .A1(n692), .B0(N490), .B1(n691), .Y(n632) );
  AO22XL U636 ( .A0(mult_product[0]), .A1(n690), .B0(N469), .B1(n689), .Y(n653) );
  AO22XL U637 ( .A0(mult_product[1]), .A1(n690), .B0(N470), .B1(n689), .Y(n652) );
  AO22XL U638 ( .A0(mult_product[2]), .A1(n690), .B0(N471), .B1(n689), .Y(n651) );
  AO22XL U639 ( .A0(mult_product[3]), .A1(n690), .B0(N472), .B1(n689), .Y(n650) );
  AO22XL U640 ( .A0(mult_product[4]), .A1(n690), .B0(N473), .B1(n689), .Y(n649) );
  AO22XL U641 ( .A0(mult_product[5]), .A1(n690), .B0(N474), .B1(n689), .Y(n648) );
  XOR2XL U642 ( .A(n721), .B(N190), .Y(N218) );
  XOR2XL U643 ( .A(N203), .B(n718), .Y(N217) );
  XOR2XL U644 ( .A(n718), .B(group[2]), .Y(N216) );
  INVXL U645 ( .A(bank[1]), .Y(n818) );
  INVXL U646 ( .A(group[2]), .Y(n830) );
  INVXL U647 ( .A(group[3]), .Y(n832) );
  CLKBUFX3 U648 ( .A(n900), .Y(n699) );
  CLKINVX1 U649 ( .A(n920), .Y(n900) );
  BUFX4 U650 ( .A(n967), .Y(ld_w_request) );
  CLKINVX1 U651 ( .A(n775), .Y(n967) );
  NAND2X1 U652 ( .A(n725), .B(n946), .Y(n877) );
  CLKBUFX3 U653 ( .A(n787), .Y(n701) );
  NAND2X1 U654 ( .A(n744), .B(n725), .Y(n787) );
  NAND2X1 U655 ( .A(n725), .B(n929), .Y(n873) );
  CLKBUFX3 U656 ( .A(n860), .Y(n709) );
  NAND2X1 U657 ( .A(n725), .B(n937), .Y(n860) );
  CLKBUFX3 U658 ( .A(n880), .Y(n704) );
  CLKBUFX3 U659 ( .A(n897), .Y(n698) );
  NAND2XL U660 ( .A(n699), .B(n762), .Y(n897) );
  NAND2X2 U661 ( .A(n699), .B(n896), .Y(n899) );
  NOR2X2 U662 ( .A(n700), .B(n676), .Y(n696) );
  NOR2X2 U663 ( .A(n700), .B(n676), .Y(n883) );
  CLKBUFX3 U664 ( .A(n808), .Y(n689) );
  NOR2X1 U665 ( .A(n778), .B(n690), .Y(n808) );
  CLKBUFX3 U666 ( .A(n757), .Y(n716) );
  CLKINVX1 U667 ( .A(n742), .Y(n757) );
  CLKBUFX3 U668 ( .A(n733), .Y(n693) );
  NOR2X1 U669 ( .A(n694), .B(n775), .Y(n733) );
  ADDFXL U670 ( .A(N191), .B(N177), .CI(add_0_root_r608_carry[5]), .CO(
        add_0_root_r608_carry[6]), .S(N219) );
  NAND2X1 U671 ( .A(n725), .B(n942), .Y(n878) );
  CLKBUFX3 U672 ( .A(n879), .Y(n713) );
  OAI21XL U673 ( .A0(n940), .A1(n933), .B0(n949), .Y(n879) );
  CLKBUFX3 U674 ( .A(n875), .Y(n711) );
  NAND4XL U675 ( .A(N226), .B(n939), .C(n840), .D(n930), .Y(n875) );
  CLKBUFX3 U676 ( .A(n874), .Y(n712) );
  NAND3XL U677 ( .A(n939), .B(n930), .C(n923), .Y(n874) );
  CLKBUFX3 U678 ( .A(n724), .Y(n725) );
  CLKBUFX3 U679 ( .A(n881), .Y(n703) );
  NAND3XL U680 ( .A(N226), .B(n840), .C(n925), .Y(n881) );
  CLKBUFX3 U681 ( .A(n876), .Y(n710) );
  NAND3XL U682 ( .A(N227), .B(n939), .C(n923), .Y(n876) );
  CLKBUFX3 U683 ( .A(n882), .Y(n702) );
  NAND4XL U684 ( .A(n923), .B(N227), .C(n783), .D(n924), .Y(n882) );
  CLKBUFX3 U685 ( .A(n872), .Y(n708) );
  OAI21XL U686 ( .A0(n934), .A1(n935), .B0(n949), .Y(n872) );
  NAND2X2 U687 ( .A(n786), .B(n701), .Y(n784) );
  CLKBUFX3 U688 ( .A(n812), .Y(n691) );
  NOR2X1 U689 ( .A(n737), .B(n692), .Y(n812) );
  CLKBUFX3 U690 ( .A(n838), .Y(n705) );
  NAND2XL U691 ( .A(n840), .B(n926), .Y(n838) );
  CLKBUFX3 U692 ( .A(n768), .Y(n700) );
  NAND2X1 U693 ( .A(n921), .B(n681), .Y(n768) );
  CLKBUFX3 U694 ( .A(n807), .Y(n690) );
  AND2XL U695 ( .A(n798), .B(n809), .Y(n807) );
  CLKBUFX3 U696 ( .A(n732), .Y(n694) );
  OAI21XL U697 ( .A0(n805), .A1(n815), .B0(n724), .Y(n732) );
  CLKBUFX3 U698 ( .A(n857), .Y(n706) );
  NAND2X1 U699 ( .A(n725), .B(n927), .Y(n857) );
  CLKBUFX3 U700 ( .A(n887), .Y(n697) );
  NOR2X1 U701 ( .A(n720), .B(n719), .Y(n887) );
  CLKBUFX3 U702 ( .A(N176), .Y(n721) );
  ADDFX2 U703 ( .A(row[1]), .B(row[2]), .CI(r605_carry[6]), .CO(r605_carry[7]), 
        .S(N178) );
  CLKBUFX3 U704 ( .A(n949), .Y(n724) );
  ADDFX2 U705 ( .A(row[2]), .B(row[3]), .CI(r605_carry[7]), .CO(r605_carry[8]), 
        .S(N179) );
  ADDFXL U706 ( .A(element_count[5]), .B(N177), .CI(
        add_0_root_add_265_2_carry[5]), .CO(add_0_root_add_265_2_carry[6]), 
        .S(N439) );
  ADDFX2 U707 ( .A(row[3]), .B(row[4]), .CI(r605_carry[8]), .CO(r605_carry[9]), 
        .S(N180) );
  ADDFX2 U708 ( .A(row[4]), .B(row[5]), .CI(r605_carry[9]), .CO(r605_carry[10]), .S(N181) );
  BUFX4 U709 ( .A(n811), .Y(n692) );
  OA21XL U710 ( .A0(rst), .A1(n737), .B0(n813), .Y(n811) );
  ADDFX2 U711 ( .A(row[5]), .B(row[6]), .CI(r605_carry[10]), .CO(
        r605_carry[11]), .S(N182) );
  ADDFX2 U712 ( .A(row[6]), .B(row[7]), .CI(r605_carry[11]), .CO(
        r605_carry[12]), .S(N183) );
  BUFX4 U713 ( .A(n858), .Y(n695) );
  OA21XL U714 ( .A0(rst), .A1(n741), .B0(n798), .Y(n858) );
  CLKBUFX3 U715 ( .A(selected_sram[1]), .Y(n719) );
  CLKBUFX3 U716 ( .A(selected_sram[0]), .Y(n720) );
  ADDHXL U717 ( .A(N435), .B(N434), .CO(add_311_carry[2]), .S(N509) );
  ADDHXL U718 ( .A(N437), .B(add_311_carry[3]), .CO(add_311_carry[4]), .S(N511) );
  ADDHXL U719 ( .A(N436), .B(add_311_carry[2]), .CO(add_311_carry[3]), .S(N510) );
  ADDHXL U720 ( .A(element_count[4]), .B(add_311_carry[4]), .CO(
        add_311_carry[5]), .S(N512) );
  OAI211X4 U721 ( .A0(n836), .A1(n837), .B0(n705), .C0(n813), .Y(n833) );
  XOR2X1 U722 ( .A(N184), .B(add_0_root_r608_carry[12]), .Y(N226) );
  AND2X1 U723 ( .A(add_0_root_r608_carry[10]), .B(N182), .Y(
        add_0_root_r608_carry[11]) );
  AND2X1 U724 ( .A(add_0_root_r608_carry[8]), .B(N180), .Y(
        add_0_root_r608_carry[9]) );
  AND2X1 U725 ( .A(add_0_root_r608_carry[6]), .B(N178), .Y(
        add_0_root_r608_carry[7]) );
  AND2X1 U726 ( .A(N190), .B(n721), .Y(add_0_root_r608_carry[5]) );
  AND2X1 U727 ( .A(n718), .B(N203), .Y(add_1_root_r608_carry_4_) );
  AND2X1 U728 ( .A(group[2]), .B(n718), .Y(add_2_root_r608_carry_3_) );
  XOR2X1 U729 ( .A(N185), .B(add_0_root_add_265_2_carry[13]), .Y(N447) );
  AND2X1 U730 ( .A(add_0_root_add_265_2_carry[12]), .B(N184), .Y(
        add_0_root_add_265_2_carry[13]) );
  XOR2X1 U731 ( .A(N184), .B(add_0_root_add_265_2_carry[12]), .Y(N446) );
  AND2X1 U732 ( .A(add_0_root_add_265_2_carry[11]), .B(N183), .Y(
        add_0_root_add_265_2_carry[12]) );
  XOR2X1 U733 ( .A(N183), .B(add_0_root_add_265_2_carry[11]), .Y(N445) );
  AND2X1 U734 ( .A(add_0_root_add_265_2_carry[10]), .B(N182), .Y(
        add_0_root_add_265_2_carry[11]) );
  XOR2X1 U735 ( .A(N182), .B(add_0_root_add_265_2_carry[10]), .Y(N444) );
  AND2X1 U736 ( .A(add_0_root_add_265_2_carry[9]), .B(N181), .Y(
        add_0_root_add_265_2_carry[10]) );
  XOR2X1 U737 ( .A(N181), .B(add_0_root_add_265_2_carry[9]), .Y(N443) );
  AND2X1 U738 ( .A(add_0_root_add_265_2_carry[8]), .B(N180), .Y(
        add_0_root_add_265_2_carry[9]) );
  XOR2X1 U739 ( .A(N180), .B(add_0_root_add_265_2_carry[8]), .Y(N442) );
  AND2X1 U740 ( .A(add_0_root_add_265_2_carry[7]), .B(N179), .Y(
        add_0_root_add_265_2_carry[8]) );
  XOR2X1 U741 ( .A(N179), .B(add_0_root_add_265_2_carry[7]), .Y(N441) );
  AND2X1 U742 ( .A(add_0_root_add_265_2_carry[6]), .B(N178), .Y(
        add_0_root_add_265_2_carry[7]) );
  XOR2X1 U743 ( .A(N178), .B(add_0_root_add_265_2_carry[6]), .Y(N440) );
  AND2X1 U744 ( .A(element_count[4]), .B(n721), .Y(
        add_0_root_add_265_2_carry[5]) );
  XOR2X1 U745 ( .A(n721), .B(element_count[4]), .Y(N438) );
  AND2X1 U746 ( .A(r605_carry[12]), .B(row[7]), .Y(N185) );
  XOR2X1 U747 ( .A(row[7]), .B(r605_carry[12]), .Y(N184) );
  AND2X1 U748 ( .A(n721), .B(row[1]), .Y(r605_carry[6]) );
  XOR2X1 U749 ( .A(row[1]), .B(n721), .Y(N177) );
  CLKINVX1 U750 ( .A(N434), .Y(N508) );
  XOR2X1 U751 ( .A(add_311_carry[5]), .B(element_count[5]), .Y(N513) );
  MXI2X1 U752 ( .A(n728), .B(n729), .S0(n730), .Y(n948) );
  NAND2BX1 U753 ( .AN(n731), .B(load_feature_id[1]), .Y(n729) );
  AO22X1 U754 ( .A0(n694), .A1(init_count[0]), .B0(N370), .B1(n693), .Y(n675)
         );
  OAI221XL U755 ( .A0(n734), .A1(n735), .B0(n736), .B1(n737), .C0(n738), .Y(
        n674) );
  CLKINVX1 U756 ( .A(n739), .Y(n734) );
  NAND4BX1 U757 ( .AN(n740), .B(n741), .C(n742), .D(n743), .Y(n673) );
  AOI221XL U758 ( .A0(n744), .A1(n726), .B0(state[2]), .B1(n745), .C0(n746), 
        .Y(n743) );
  CLKINVX1 U759 ( .A(n747), .Y(n726) );
  NAND4X1 U760 ( .A(n748), .B(n749), .C(n750), .D(n751), .Y(n672) );
  AOI222XL U761 ( .A0(n752), .A1(n753), .B0(n754), .B1(ld_w_request), .C0(n755), .C1(n756), .Y(n751) );
  CLKINVX1 U762 ( .A(n736), .Y(n753) );
  NOR2X1 U763 ( .A(n716), .B(n740), .Y(n750) );
  OAI21XL U764 ( .A0(n758), .A1(n759), .B0(state[1]), .Y(n748) );
  CLKINVX1 U765 ( .A(n760), .Y(n759) );
  OA21XL U766 ( .A0(n747), .A1(n761), .B0(n762), .Y(n758) );
  OA22X1 U767 ( .A0(n739), .A1(n746), .B0(start_init), .B1(n763), .Y(n671) );
  NAND3X1 U768 ( .A(n764), .B(n749), .C(n765), .Y(n746) );
  AOI2BB2X1 U769 ( .B0(n766), .B1(n767), .A0N(n755), .A1N(n700), .Y(n765) );
  NOR3BXL U770 ( .AN(n769), .B(n770), .C(n947), .Y(n755) );
  NAND2BX1 U771 ( .AN(n745), .B(n771), .Y(n739) );
  OAI21XL U772 ( .A0(n747), .A1(n761), .B0(n762), .Y(n771) );
  NAND4X1 U773 ( .A(load_feature_id[3]), .B(load_feature_id[2]), .C(n772), .D(
        load_feature_id[1]), .Y(n747) );
  NOR2X1 U774 ( .A(n773), .B(n774), .Y(n772) );
  OAI21XL U775 ( .A0(n754), .A1(n775), .B0(n760), .Y(n745) );
  NAND4X1 U776 ( .A(n700), .B(n749), .C(n738), .D(n776), .Y(n760) );
  AOI211X1 U777 ( .A0(state[1]), .A1(n766), .B0(n740), .C0(n777), .Y(n738) );
  NOR3X1 U778 ( .A(n684), .B(n681), .C(n778), .Y(n740) );
  AND4X1 U779 ( .A(n779), .B(n780), .C(n781), .D(n782), .Y(n754) );
  NOR4X1 U780 ( .A(init_count[9]), .B(init_count[8]), .C(init_count[12]), .D(
        init_count[11]), .Y(n782) );
  NOR4BBX1 U781 ( .AN(init_count[0]), .BN(w_input_valid), .C(init_count[10]), 
        .D(n783), .Y(n781) );
  AND4X1 U782 ( .A(init_count[1]), .B(init_count[2]), .C(init_count[3]), .D(
        init_count[4]), .Y(n780) );
  AND3X1 U783 ( .A(init_count[7]), .B(init_count[5]), .C(init_count[6]), .Y(
        n779) );
  OAI2BB2XL U784 ( .B0(n353), .B1(n784), .A0N(N410), .A1N(n785), .Y(n670) );
  OAI2BB2XL U785 ( .B0(n3600), .B1(n784), .A0N(N403), .A1N(n785), .Y(n669) );
  OAI2BB2XL U786 ( .B0(n3590), .B1(n784), .A0N(N404), .A1N(n785), .Y(n668) );
  OAI2BB2XL U787 ( .B0(n3580), .B1(n784), .A0N(N405), .A1N(n785), .Y(n667) );
  OAI2BB2XL U788 ( .B0(n3570), .B1(n784), .A0N(N406), .A1N(n785), .Y(n666) );
  OAI2BB2XL U789 ( .B0(n3560), .B1(n784), .A0N(N407), .A1N(n785), .Y(n665) );
  OAI2BB2XL U790 ( .B0(n3550), .B1(n784), .A0N(N408), .A1N(n785), .Y(n664) );
  OAI2BB2XL U791 ( .B0(n354), .B1(n784), .A0N(N409), .A1N(n785), .Y(n663) );
  CLKMX2X2 U792 ( .A(n788), .B(n789), .S0(n790), .Y(n662) );
  NOR3X1 U793 ( .A(n731), .B(n791), .C(n730), .Y(n789) );
  OAI21XL U794 ( .A0(load_feature_id[2]), .A1(n792), .B0(n728), .Y(n788) );
  OA21XL U795 ( .A0(load_feature_id[1]), .A1(n792), .B0(n793), .Y(n728) );
  MXI2X1 U796 ( .A(n793), .B(n731), .S0(n791), .Y(n660) );
  OA21XL U797 ( .A0(load_feature_id[0]), .A1(n792), .B0(n794), .Y(n793) );
  CLKINVX1 U798 ( .A(n796), .Y(n786) );
  OAI31XL U799 ( .A0(n797), .A1(rst), .A2(n727), .B0(n798), .Y(n796) );
  NAND2X1 U800 ( .A(n799), .B(n800), .Y(n773) );
  NOR4X1 U801 ( .A(n3600), .B(n3590), .C(n3580), .D(n3570), .Y(n800) );
  NOR4X1 U802 ( .A(n3560), .B(n3550), .C(n354), .D(n353), .Y(n799) );
  AO22X1 U803 ( .A0(n801), .A1(element_count[5]), .B0(N513), .B1(n802), .Y(
        n659) );
  AO22X1 U804 ( .A0(n801), .A1(N434), .B0(N508), .B1(n802), .Y(n658) );
  AO22X1 U805 ( .A0(n801), .A1(N435), .B0(N509), .B1(n802), .Y(n657) );
  AO22X1 U806 ( .A0(n801), .A1(N436), .B0(N510), .B1(n802), .Y(n656) );
  AO22X1 U807 ( .A0(n801), .A1(N437), .B0(N511), .B1(n802), .Y(n655) );
  AO22X1 U808 ( .A0(n801), .A1(element_count[4]), .B0(N512), .B1(n802), .Y(
        n654) );
  NOR2X1 U809 ( .A(n801), .B(n737), .Y(n802) );
  NAND2X1 U810 ( .A(n725), .B(n803), .Y(n801) );
  NAND4X1 U811 ( .A(n804), .B(n764), .C(n700), .D(n763), .Y(n803) );
  CLKINVX1 U812 ( .A(n805), .Y(n763) );
  NAND2X1 U813 ( .A(n752), .B(n736), .Y(n764) );
  NAND4BX1 U814 ( .AN(n806), .B(N437), .C(N436), .D(element_count[5]), .Y(n736) );
  NAND3BX1 U815 ( .AN(element_count[4]), .B(N435), .C(N434), .Y(n806) );
  CLKINVX1 U816 ( .A(n737), .Y(n752) );
  AO22X1 U817 ( .A0(mult_product[6]), .A1(n690), .B0(N475), .B1(n689), .Y(n647) );
  AO22X1 U818 ( .A0(mult_product[7]), .A1(n690), .B0(N476), .B1(n689), .Y(n646) );
  AO22X1 U819 ( .A0(mult_product[8]), .A1(n690), .B0(N477), .B1(n689), .Y(n645) );
  AO22X1 U820 ( .A0(mult_product[9]), .A1(n690), .B0(N478), .B1(n689), .Y(n644) );
  AO22X1 U821 ( .A0(mult_product[10]), .A1(n690), .B0(N479), .B1(n689), .Y(
        n643) );
  AO22X1 U822 ( .A0(mult_product[11]), .A1(n690), .B0(N480), .B1(n689), .Y(
        n642) );
  AO22X1 U823 ( .A0(mult_product[12]), .A1(n690), .B0(N481), .B1(n689), .Y(
        n641) );
  AO22X1 U824 ( .A0(mult_product[13]), .A1(n690), .B0(N482), .B1(n689), .Y(
        n640) );
  AO22X1 U825 ( .A0(mult_product[14]), .A1(n690), .B0(N483), .B1(n689), .Y(
        n639) );
  AO22X1 U826 ( .A0(mult_product[15]), .A1(n690), .B0(N484), .B1(n689), .Y(
        n638) );
  NAND4X1 U827 ( .A(n810), .B(n725), .C(n681), .D(n684), .Y(n809) );
  AO22X1 U828 ( .A0(acc[21]), .A1(n692), .B0(N507), .B1(n691), .Y(n637) );
  AO22X1 U829 ( .A0(acc[0]), .A1(n692), .B0(N486), .B1(n691), .Y(n636) );
  AO22X1 U830 ( .A0(acc[1]), .A1(n692), .B0(N487), .B1(n691), .Y(n635) );
  AO22X1 U831 ( .A0(acc[2]), .A1(n692), .B0(N488), .B1(n691), .Y(n634) );
  AO22X1 U832 ( .A0(acc[3]), .A1(n692), .B0(N489), .B1(n691), .Y(n633) );
  AO22X1 U833 ( .A0(acc[6]), .A1(n692), .B0(N492), .B1(n691), .Y(n630) );
  AO22X1 U834 ( .A0(acc[7]), .A1(n692), .B0(N493), .B1(n691), .Y(n629) );
  AO22X1 U835 ( .A0(acc[8]), .A1(n692), .B0(N494), .B1(n691), .Y(n628) );
  AO22X1 U836 ( .A0(acc[9]), .A1(n692), .B0(N495), .B1(n691), .Y(n627) );
  AO22X1 U837 ( .A0(acc[10]), .A1(n692), .B0(N496), .B1(n691), .Y(n626) );
  AO22X1 U838 ( .A0(acc[11]), .A1(n692), .B0(N497), .B1(n691), .Y(n625) );
  AO22X1 U839 ( .A0(acc[12]), .A1(n692), .B0(N498), .B1(n691), .Y(n624) );
  AO22X1 U840 ( .A0(acc[13]), .A1(n692), .B0(N499), .B1(n691), .Y(n623) );
  AO22X1 U841 ( .A0(acc[14]), .A1(n692), .B0(N500), .B1(n691), .Y(n622) );
  AO22X1 U842 ( .A0(acc[15]), .A1(n692), .B0(N501), .B1(n691), .Y(n621) );
  AO22X1 U843 ( .A0(acc[16]), .A1(n692), .B0(N502), .B1(n691), .Y(n620) );
  AO22X1 U844 ( .A0(acc[17]), .A1(n692), .B0(N503), .B1(n691), .Y(n619) );
  AO22X1 U845 ( .A0(acc[18]), .A1(n692), .B0(N504), .B1(n691), .Y(n618) );
  AO22X1 U846 ( .A0(acc[19]), .A1(n692), .B0(N505), .B1(n691), .Y(n617) );
  AO22X1 U847 ( .A0(acc[20]), .A1(n692), .B0(N506), .B1(n691), .Y(n616) );
  NAND2X1 U848 ( .A(n810), .B(n814), .Y(n737) );
  AO22X1 U849 ( .A0(n694), .A1(init_count[1]), .B0(N371), .B1(n693), .Y(n615)
         );
  AO22X1 U850 ( .A0(n694), .A1(init_count[2]), .B0(N372), .B1(n693), .Y(n614)
         );
  AO22X1 U851 ( .A0(n694), .A1(init_count[3]), .B0(N373), .B1(n693), .Y(n613)
         );
  AO22X1 U852 ( .A0(n694), .A1(init_count[4]), .B0(N374), .B1(n693), .Y(n612)
         );
  AO22X1 U853 ( .A0(n694), .A1(init_count[5]), .B0(N375), .B1(n693), .Y(n611)
         );
  AO22X1 U854 ( .A0(n694), .A1(init_count[6]), .B0(N376), .B1(n693), .Y(n610)
         );
  AO22X1 U855 ( .A0(n694), .A1(init_count[7]), .B0(N377), .B1(n693), .Y(n609)
         );
  AO22X1 U856 ( .A0(n694), .A1(init_count[8]), .B0(N378), .B1(n693), .Y(n608)
         );
  AO22X1 U857 ( .A0(n694), .A1(init_count[9]), .B0(N379), .B1(n693), .Y(n607)
         );
  AO22X1 U858 ( .A0(n694), .A1(init_count[10]), .B0(N380), .B1(n693), .Y(n606)
         );
  AO22X1 U859 ( .A0(n694), .A1(init_count[11]), .B0(N381), .B1(n693), .Y(n605)
         );
  AO22X1 U860 ( .A0(n694), .A1(init_count[12]), .B0(N382), .B1(n693), .Y(n604)
         );
  AO22X1 U861 ( .A0(n694), .A1(init_count[13]), .B0(N383), .B1(n693), .Y(n603)
         );
  AO22X1 U862 ( .A0(n694), .A1(init_count[14]), .B0(N384), .B1(n693), .Y(n602)
         );
  CLKMX2X2 U863 ( .A(n816), .B(n817), .S0(n818), .Y(n601) );
  AND3X1 U864 ( .A(n819), .B(n718), .C(ld_w_request), .Y(n817) );
  OAI21XL U865 ( .A0(n718), .A1(n775), .B0(n819), .Y(n816) );
  MXI2X1 U866 ( .A(n819), .B(n820), .S0(n821), .Y(n600) );
  NAND2X1 U867 ( .A(ld_w_request), .B(n819), .Y(n820) );
  NAND2X1 U868 ( .A(n798), .B(n822), .Y(n819) );
  MXI2X1 U869 ( .A(n828), .B(n829), .S0(N215), .Y(n597) );
  NAND2X1 U870 ( .A(n825), .B(N214), .Y(n828) );
  CLKINVX1 U871 ( .A(n826), .Y(n825) );
  OAI22XL U872 ( .A0(n824), .A1(n830), .B0(n831), .B1(n826), .Y(n596) );
  OA21XL U873 ( .A0(N215), .A1(n826), .B0(n829), .Y(n824) );
  OA21XL U874 ( .A0(N214), .A1(n826), .B0(n827), .Y(n829) );
  OAI211X1 U875 ( .A0(n831), .A1(n832), .B0(n827), .C0(ld_w_request), .Y(n826)
         );
  CLKINVX1 U876 ( .A(n718), .Y(n821) );
  OAI2BB2XL U877 ( .B0(n678), .B1(n833), .A0N(N356), .A1N(n834), .Y(n595) );
  OAI2BB2XL U878 ( .B0(n688), .B1(n833), .A0N(N355), .A1N(n834), .Y(n594) );
  OAI2BB2XL U879 ( .B0(n682), .B1(n833), .A0N(N357), .A1N(n834), .Y(n593) );
  OAI2BB2XL U880 ( .B0(n679), .B1(n833), .A0N(N358), .A1N(n834), .Y(n592) );
  OAI2BB2XL U881 ( .B0(n687), .B1(n833), .A0N(N359), .A1N(n834), .Y(n591) );
  OAI2BB2XL U882 ( .B0(n683), .B1(n833), .A0N(N360), .A1N(n834), .Y(n590) );
  OAI2BB2XL U883 ( .B0(n680), .B1(n833), .A0N(N361), .A1N(n834), .Y(n589) );
  OAI2BB2XL U884 ( .B0(n677), .B1(n833), .A0N(N362), .A1N(n834), .Y(n588) );
  OAI21XL U885 ( .A0(n769), .A1(n700), .B0(n775), .Y(n835) );
  OA21XL U886 ( .A0(rst), .A1(n804), .B0(n676), .Y(n813) );
  OR2X1 U887 ( .A(n831), .B(n832), .Y(n837) );
  NAND3X1 U888 ( .A(N214), .B(n830), .C(N215), .Y(n831) );
  NAND3BX1 U889 ( .AN(n822), .B(bank[1]), .C(n718), .Y(n836) );
  NAND2X1 U890 ( .A(n840), .B(n783), .Y(n822) );
  OAI21XL U891 ( .A0(n770), .A1(n841), .B0(n842), .Y(n587) );
  AO21X1 U892 ( .A0(n843), .A1(n700), .B0(n947), .Y(n842) );
  MXI2X1 U893 ( .A(n843), .B(n841), .S0(n844), .Y(n586) );
  MXI2X1 U894 ( .A(n845), .B(n846), .S0(n847), .Y(n585) );
  NAND2X1 U895 ( .A(n848), .B(feature_id[0]), .Y(n846) );
  MXI2X1 U896 ( .A(n849), .B(n850), .S0(n851), .Y(n584) );
  NAND3X1 U897 ( .A(feature_id[1]), .B(feature_id[0]), .C(n848), .Y(n850) );
  CLKINVX1 U898 ( .A(n841), .Y(n848) );
  NAND2X1 U899 ( .A(n756), .B(n843), .Y(n841) );
  CLKINVX1 U900 ( .A(n700), .Y(n756) );
  OA21XL U901 ( .A0(feature_id[1]), .A1(n700), .B0(n845), .Y(n849) );
  OA21XL U902 ( .A0(feature_id[0]), .A1(n700), .B0(n843), .Y(n845) );
  OAI211X1 U903 ( .A0(rst), .A1(n804), .B0(n852), .C0(n798), .Y(n843) );
  OAI211X1 U904 ( .A0(n947), .A1(n770), .B0(n769), .C0(n853), .Y(n852) );
  AND2X1 U905 ( .A(n854), .B(n855), .Y(n769) );
  NOR4X1 U906 ( .A(n688), .B(n678), .C(n682), .D(n679), .Y(n855) );
  NOR4X1 U907 ( .A(n687), .B(n683), .C(n680), .D(n677), .Y(n854) );
  NAND3X1 U908 ( .A(feature_id[1]), .B(feature_id[0]), .C(feature_id[2]), .Y(
        n770) );
  NAND3X1 U909 ( .A(n681), .B(n684), .C(n766), .Y(n804) );
  CLKMX2X2 U910 ( .A(n720), .B(N446), .S0(n856), .Y(n583) );
  CLKMX2X2 U911 ( .A(n719), .B(N447), .S0(n856), .Y(n582) );
  NOR2X1 U912 ( .A(n742), .B(rst), .Y(n856) );
  CLKMX2X2 U913 ( .A(n721), .B(bias_address[0]), .S0(n706), .Y(n581) );
  CLKMX2X2 U914 ( .A(row[1]), .B(bias_address[1]), .S0(n706), .Y(n580) );
  CLKMX2X2 U915 ( .A(row[2]), .B(bias_address[2]), .S0(n706), .Y(n579) );
  CLKMX2X2 U916 ( .A(row[3]), .B(bias_address[3]), .S0(n706), .Y(n578) );
  CLKMX2X2 U917 ( .A(row[4]), .B(bias_address[4]), .S0(n706), .Y(n577) );
  CLKMX2X2 U918 ( .A(row[5]), .B(bias_address[5]), .S0(n706), .Y(n576) );
  CLKMX2X2 U919 ( .A(row[6]), .B(bias_address[6]), .S0(n706), .Y(n575) );
  CLKMX2X2 U920 ( .A(row[7]), .B(bias_address[7]), .S0(n706), .Y(n574) );
  CLKMX2X2 U921 ( .A(raw_input[0]), .B(bias_data[0]), .S0(n705), .Y(n573) );
  CLKMX2X2 U922 ( .A(raw_input[1]), .B(bias_data[1]), .S0(n705), .Y(n572) );
  CLKMX2X2 U923 ( .A(raw_input[2]), .B(bias_data[2]), .S0(n705), .Y(n571) );
  CLKMX2X2 U924 ( .A(raw_input[3]), .B(bias_data[3]), .S0(n705), .Y(n570) );
  CLKMX2X2 U925 ( .A(raw_input[4]), .B(bias_data[4]), .S0(n705), .Y(n569) );
  CLKMX2X2 U926 ( .A(raw_input[5]), .B(bias_data[5]), .S0(n705), .Y(n568) );
  CLKMX2X2 U927 ( .A(raw_input[6]), .B(bias_data[6]), .S0(n705), .Y(n567) );
  CLKMX2X2 U928 ( .A(raw_input[7]), .B(bias_data[7]), .S0(n705), .Y(n566) );
  AO22X1 U929 ( .A0(result_hold[0]), .A1(n695), .B0(N514), .B1(n686), .Y(n565)
         );
  AO22X1 U930 ( .A0(result_hold[1]), .A1(n695), .B0(N515), .B1(n686), .Y(n564)
         );
  AO22X1 U931 ( .A0(result_hold[2]), .A1(n695), .B0(N516), .B1(n686), .Y(n563)
         );
  AO22X1 U932 ( .A0(result_hold[3]), .A1(n695), .B0(N517), .B1(n686), .Y(n562)
         );
  AO22X1 U933 ( .A0(result_hold[4]), .A1(n695), .B0(N518), .B1(n686), .Y(n561)
         );
  AO22X1 U934 ( .A0(result_hold[5]), .A1(n695), .B0(N519), .B1(n686), .Y(n560)
         );
  AO22X1 U935 ( .A0(result_hold[6]), .A1(n695), .B0(N520), .B1(n686), .Y(n559)
         );
  AO22X1 U936 ( .A0(result_hold[7]), .A1(n695), .B0(N521), .B1(n686), .Y(n558)
         );
  AO22X1 U937 ( .A0(result_hold[8]), .A1(n695), .B0(N522), .B1(n686), .Y(n557)
         );
  AO22X1 U938 ( .A0(result_hold[9]), .A1(n695), .B0(N523), .B1(n686), .Y(n556)
         );
  AO22X1 U939 ( .A0(result_hold[10]), .A1(n695), .B0(N524), .B1(n686), .Y(n555) );
  AO22X1 U940 ( .A0(result_hold[11]), .A1(n695), .B0(N525), .B1(n686), .Y(n554) );
  AO22X1 U941 ( .A0(result_hold[12]), .A1(n695), .B0(N526), .B1(n686), .Y(n553) );
  AO22X1 U942 ( .A0(result_hold[13]), .A1(n695), .B0(N527), .B1(n686), .Y(n552) );
  AO22X1 U943 ( .A0(result_hold[14]), .A1(n695), .B0(N528), .B1(n686), .Y(n551) );
  AO22X1 U944 ( .A0(result_hold[15]), .A1(n695), .B0(N529), .B1(n686), .Y(n550) );
  AO22X1 U945 ( .A0(result_hold[16]), .A1(n695), .B0(N530), .B1(n686), .Y(n549) );
  AO22X1 U946 ( .A0(result_hold[17]), .A1(n695), .B0(N531), .B1(n686), .Y(n548) );
  AO22X1 U947 ( .A0(result_hold[18]), .A1(n695), .B0(N532), .B1(n686), .Y(n547) );
  AO22X1 U948 ( .A0(result_hold[19]), .A1(n695), .B0(N533), .B1(n686), .Y(n546) );
  AO22X1 U949 ( .A0(result_hold[20]), .A1(n695), .B0(N534), .B1(n686), .Y(n545) );
  AO22X1 U950 ( .A0(result_hold[21]), .A1(n695), .B0(N535), .B1(n686), .Y(n544) );
  CLKINVX1 U951 ( .A(n777), .Y(n741) );
  NOR3X1 U952 ( .A(n685), .B(n797), .C(n735), .Y(n777) );
  CLKMX2X2 U953 ( .A(n859), .B(weight_address[0]), .S0(n709), .Y(n543) );
  CLKMX2X2 U954 ( .A(n861), .B(weight_address[11]), .S0(n709), .Y(n542) );
  CLKMX2X2 U955 ( .A(n862), .B(weight_address[10]), .S0(n709), .Y(n541) );
  CLKMX2X2 U956 ( .A(n863), .B(weight_address[9]), .S0(n709), .Y(n540) );
  CLKMX2X2 U957 ( .A(n864), .B(weight_address[8]), .S0(n709), .Y(n539) );
  CLKMX2X2 U958 ( .A(n865), .B(weight_address[7]), .S0(n709), .Y(n538) );
  CLKMX2X2 U959 ( .A(n866), .B(weight_address[6]), .S0(n709), .Y(n537) );
  CLKMX2X2 U960 ( .A(n867), .B(weight_address[5]), .S0(n709), .Y(n536) );
  CLKMX2X2 U961 ( .A(n868), .B(weight_address[4]), .S0(n709), .Y(n5350) );
  CLKMX2X2 U962 ( .A(n869), .B(weight_address[3]), .S0(n709), .Y(n5340) );
  CLKMX2X2 U963 ( .A(n870), .B(weight_address[2]), .S0(n709), .Y(n5330) );
  CLKMX2X2 U964 ( .A(n871), .B(weight_address[1]), .S0(n709), .Y(n5320) );
  CLKMX2X2 U965 ( .A(n859), .B(weight_address[12]), .S0(n708), .Y(n5310) );
  CLKMX2X2 U966 ( .A(n861), .B(weight_address[23]), .S0(n708), .Y(n5300) );
  CLKMX2X2 U967 ( .A(n862), .B(weight_address[22]), .S0(n708), .Y(n5290) );
  CLKMX2X2 U968 ( .A(n863), .B(weight_address[21]), .S0(n708), .Y(n5280) );
  CLKMX2X2 U969 ( .A(n864), .B(weight_address[20]), .S0(n708), .Y(n5270) );
  CLKMX2X2 U970 ( .A(n865), .B(weight_address[19]), .S0(n708), .Y(n5260) );
  CLKMX2X2 U971 ( .A(n866), .B(weight_address[18]), .S0(n708), .Y(n5250) );
  CLKMX2X2 U972 ( .A(n867), .B(weight_address[17]), .S0(n708), .Y(n5240) );
  CLKMX2X2 U973 ( .A(n868), .B(weight_address[16]), .S0(n708), .Y(n5230) );
  CLKMX2X2 U974 ( .A(n869), .B(weight_address[15]), .S0(n708), .Y(n5220) );
  CLKMX2X2 U975 ( .A(n870), .B(weight_address[14]), .S0(n708), .Y(n5210) );
  CLKMX2X2 U976 ( .A(n871), .B(weight_address[13]), .S0(n708), .Y(n5200) );
  CLKMX2X2 U977 ( .A(n859), .B(weight_address[24]), .S0(n707), .Y(n5190) );
  CLKMX2X2 U978 ( .A(n861), .B(weight_address[35]), .S0(n707), .Y(n5180) );
  CLKMX2X2 U979 ( .A(n862), .B(weight_address[34]), .S0(n707), .Y(n5170) );
  CLKMX2X2 U980 ( .A(n863), .B(weight_address[33]), .S0(n707), .Y(n5160) );
  CLKMX2X2 U981 ( .A(n864), .B(weight_address[32]), .S0(n707), .Y(n5150) );
  CLKMX2X2 U982 ( .A(n865), .B(weight_address[31]), .S0(n707), .Y(n5140) );
  CLKMX2X2 U983 ( .A(n866), .B(weight_address[30]), .S0(n707), .Y(n5130) );
  CLKMX2X2 U984 ( .A(n867), .B(weight_address[29]), .S0(n707), .Y(n5120) );
  CLKMX2X2 U985 ( .A(n868), .B(weight_address[28]), .S0(n707), .Y(n5110) );
  CLKMX2X2 U986 ( .A(n869), .B(weight_address[27]), .S0(n707), .Y(n5100) );
  CLKMX2X2 U987 ( .A(n870), .B(weight_address[26]), .S0(n707), .Y(n5090) );
  CLKMX2X2 U988 ( .A(n871), .B(weight_address[25]), .S0(n707), .Y(n5080) );
  CLKMX2X2 U989 ( .A(raw_input[0]), .B(weight_data[0]), .S0(n712), .Y(n5070)
         );
  CLKMX2X2 U990 ( .A(raw_input[7]), .B(weight_data[7]), .S0(n712), .Y(n5060)
         );
  CLKMX2X2 U991 ( .A(raw_input[6]), .B(weight_data[6]), .S0(n712), .Y(n5050)
         );
  CLKMX2X2 U992 ( .A(raw_input[5]), .B(weight_data[5]), .S0(n712), .Y(n5040)
         );
  CLKMX2X2 U993 ( .A(raw_input[4]), .B(weight_data[4]), .S0(n712), .Y(n5030)
         );
  CLKMX2X2 U994 ( .A(raw_input[3]), .B(weight_data[3]), .S0(n712), .Y(n5020)
         );
  CLKMX2X2 U995 ( .A(raw_input[2]), .B(weight_data[2]), .S0(n712), .Y(n5010)
         );
  CLKMX2X2 U996 ( .A(raw_input[1]), .B(weight_data[1]), .S0(n712), .Y(n5000)
         );
  CLKMX2X2 U997 ( .A(raw_input[0]), .B(weight_data[8]), .S0(n711), .Y(n4990)
         );
  CLKMX2X2 U998 ( .A(raw_input[7]), .B(weight_data[15]), .S0(n711), .Y(n4980)
         );
  CLKMX2X2 U999 ( .A(raw_input[6]), .B(weight_data[14]), .S0(n711), .Y(n4970)
         );
  CLKMX2X2 U1000 ( .A(raw_input[5]), .B(weight_data[13]), .S0(n711), .Y(n4960)
         );
  CLKMX2X2 U1001 ( .A(raw_input[4]), .B(weight_data[12]), .S0(n711), .Y(n4950)
         );
  CLKMX2X2 U1002 ( .A(raw_input[3]), .B(weight_data[11]), .S0(n711), .Y(n4940)
         );
  CLKMX2X2 U1003 ( .A(raw_input[2]), .B(weight_data[10]), .S0(n711), .Y(n4930)
         );
  CLKMX2X2 U1004 ( .A(raw_input[1]), .B(weight_data[9]), .S0(n711), .Y(n4920)
         );
  CLKMX2X2 U1005 ( .A(raw_input[0]), .B(weight_data[16]), .S0(n710), .Y(n4910)
         );
  CLKMX2X2 U1006 ( .A(raw_input[7]), .B(weight_data[23]), .S0(n710), .Y(n4900)
         );
  CLKMX2X2 U1007 ( .A(raw_input[6]), .B(weight_data[22]), .S0(n710), .Y(n4890)
         );
  CLKMX2X2 U1008 ( .A(raw_input[5]), .B(weight_data[21]), .S0(n710), .Y(n4880)
         );
  CLKMX2X2 U1009 ( .A(raw_input[4]), .B(weight_data[20]), .S0(n710), .Y(n4870)
         );
  CLKMX2X2 U1010 ( .A(raw_input[3]), .B(weight_data[19]), .S0(n710), .Y(n4860)
         );
  CLKMX2X2 U1011 ( .A(raw_input[2]), .B(weight_data[18]), .S0(n710), .Y(n485)
         );
  CLKMX2X2 U1012 ( .A(raw_input[1]), .B(weight_data[17]), .S0(n710), .Y(n4840)
         );
  CLKMX2X2 U1013 ( .A(n859), .B(position_address[0]), .S0(n715), .Y(n4830) );
  CLKMX2X2 U1014 ( .A(n861), .B(position_address[11]), .S0(n715), .Y(n4820) );
  CLKMX2X2 U1015 ( .A(n862), .B(position_address[10]), .S0(n715), .Y(n4810) );
  CLKMX2X2 U1016 ( .A(n863), .B(position_address[9]), .S0(n715), .Y(n4800) );
  CLKMX2X2 U1017 ( .A(n864), .B(position_address[8]), .S0(n715), .Y(n4790) );
  CLKMX2X2 U1018 ( .A(n865), .B(position_address[7]), .S0(n715), .Y(n4780) );
  CLKMX2X2 U1019 ( .A(n866), .B(position_address[6]), .S0(n715), .Y(n4770) );
  CLKMX2X2 U1020 ( .A(n867), .B(position_address[5]), .S0(n715), .Y(n4760) );
  CLKMX2X2 U1021 ( .A(n868), .B(position_address[4]), .S0(n715), .Y(n4750) );
  CLKMX2X2 U1022 ( .A(n869), .B(position_address[3]), .S0(n715), .Y(n4740) );
  CLKMX2X2 U1023 ( .A(n870), .B(position_address[2]), .S0(n715), .Y(n4730) );
  CLKMX2X2 U1024 ( .A(n871), .B(position_address[1]), .S0(n715), .Y(n4720) );
  CLKMX2X2 U1025 ( .A(n859), .B(position_address[12]), .S0(n714), .Y(n4710) );
  CLKMX2X2 U1026 ( .A(n861), .B(position_address[23]), .S0(n714), .Y(n4700) );
  CLKMX2X2 U1027 ( .A(n862), .B(position_address[22]), .S0(n714), .Y(n4690) );
  CLKMX2X2 U1028 ( .A(n863), .B(position_address[21]), .S0(n714), .Y(n468) );
  CLKMX2X2 U1029 ( .A(n864), .B(position_address[20]), .S0(n714), .Y(n467) );
  CLKMX2X2 U1030 ( .A(n865), .B(position_address[19]), .S0(n714), .Y(n466) );
  CLKMX2X2 U1031 ( .A(n866), .B(position_address[18]), .S0(n714), .Y(n465) );
  CLKMX2X2 U1032 ( .A(n867), .B(position_address[17]), .S0(n714), .Y(n464) );
  CLKMX2X2 U1033 ( .A(n868), .B(position_address[16]), .S0(n714), .Y(n463) );
  CLKMX2X2 U1034 ( .A(n869), .B(position_address[15]), .S0(n714), .Y(n462) );
  CLKMX2X2 U1035 ( .A(n870), .B(position_address[14]), .S0(n714), .Y(n461) );
  CLKMX2X2 U1036 ( .A(n871), .B(position_address[13]), .S0(n714), .Y(n460) );
  CLKMX2X2 U1037 ( .A(n859), .B(position_address[24]), .S0(n713), .Y(n459) );
  AO22X1 U1038 ( .A0(N434), .A1(n716), .B0(N214), .B1(ld_w_request), .Y(n859)
         );
  CLKMX2X2 U1039 ( .A(n861), .B(position_address[35]), .S0(n713), .Y(n458) );
  AO22X1 U1040 ( .A0(N445), .A1(n716), .B0(N225), .B1(ld_w_request), .Y(n861)
         );
  CLKMX2X2 U1041 ( .A(n862), .B(position_address[34]), .S0(n713), .Y(n457) );
  AO22X1 U1042 ( .A0(N444), .A1(n716), .B0(N224), .B1(ld_w_request), .Y(n862)
         );
  CLKMX2X2 U1043 ( .A(n863), .B(position_address[33]), .S0(n713), .Y(n456) );
  AO22X1 U1044 ( .A0(N443), .A1(n716), .B0(N223), .B1(ld_w_request), .Y(n863)
         );
  CLKMX2X2 U1045 ( .A(n864), .B(position_address[32]), .S0(n713), .Y(n455) );
  AO22X1 U1046 ( .A0(N442), .A1(n716), .B0(N222), .B1(ld_w_request), .Y(n864)
         );
  CLKMX2X2 U1047 ( .A(n865), .B(position_address[31]), .S0(n713), .Y(n454) );
  AO22X1 U1048 ( .A0(N441), .A1(n716), .B0(N221), .B1(ld_w_request), .Y(n865)
         );
  CLKMX2X2 U1049 ( .A(n866), .B(position_address[30]), .S0(n713), .Y(n453) );
  AO22X1 U1050 ( .A0(N440), .A1(n716), .B0(N220), .B1(ld_w_request), .Y(n866)
         );
  CLKMX2X2 U1051 ( .A(n867), .B(position_address[29]), .S0(n713), .Y(n452) );
  AO22X1 U1052 ( .A0(N439), .A1(n716), .B0(N219), .B1(ld_w_request), .Y(n867)
         );
  CLKMX2X2 U1053 ( .A(n868), .B(position_address[28]), .S0(n713), .Y(n451) );
  AO22X1 U1054 ( .A0(N438), .A1(n716), .B0(N218), .B1(ld_w_request), .Y(n868)
         );
  CLKMX2X2 U1055 ( .A(n869), .B(position_address[27]), .S0(n713), .Y(n450) );
  AO22X1 U1056 ( .A0(N437), .A1(n716), .B0(N217), .B1(ld_w_request), .Y(n869)
         );
  CLKMX2X2 U1057 ( .A(n870), .B(position_address[26]), .S0(n713), .Y(n449) );
  AO22X1 U1058 ( .A0(N436), .A1(n716), .B0(N216), .B1(ld_w_request), .Y(n870)
         );
  CLKMX2X2 U1059 ( .A(n871), .B(position_address[25]), .S0(n713), .Y(n448) );
  AO22X1 U1060 ( .A0(N435), .A1(n716), .B0(N215), .B1(ld_w_request), .Y(n871)
         );
  CLKMX2X2 U1061 ( .A(raw_input[0]), .B(position_data[0]), .S0(n704), .Y(n4470) );
  CLKMX2X2 U1062 ( .A(raw_input[5]), .B(position_data[5]), .S0(n704), .Y(n4440) );
  CLKMX2X2 U1063 ( .A(raw_input[4]), .B(position_data[4]), .S0(n704), .Y(n4430) );
  CLKMX2X2 U1064 ( .A(raw_input[3]), .B(position_data[3]), .S0(n704), .Y(n4420) );
  CLKMX2X2 U1065 ( .A(raw_input[2]), .B(position_data[2]), .S0(n704), .Y(n4410) );
  CLKMX2X2 U1066 ( .A(raw_input[1]), .B(position_data[1]), .S0(n704), .Y(n4400) );
  CLKMX2X2 U1067 ( .A(raw_input[0]), .B(position_data[8]), .S0(n703), .Y(n4370) );
  CLKMX2X2 U1068 ( .A(raw_input[5]), .B(position_data[13]), .S0(n703), .Y(
        n4360) );
  CLKMX2X2 U1069 ( .A(raw_input[4]), .B(position_data[12]), .S0(n703), .Y(
        n4350) );
  CLKMX2X2 U1070 ( .A(raw_input[3]), .B(position_data[11]), .S0(n703), .Y(
        n4340) );
  CLKMX2X2 U1071 ( .A(raw_input[2]), .B(position_data[10]), .S0(n703), .Y(n433) );
  CLKMX2X2 U1072 ( .A(raw_input[1]), .B(position_data[9]), .S0(n703), .Y(n432)
         );
  CLKMX2X2 U1073 ( .A(raw_input[0]), .B(position_data[16]), .S0(n702), .Y(n431) );
  CLKMX2X2 U1074 ( .A(raw_input[5]), .B(position_data[21]), .S0(n702), .Y(n428) );
  CLKMX2X2 U1075 ( .A(raw_input[4]), .B(position_data[20]), .S0(n702), .Y(n427) );
  CLKMX2X2 U1076 ( .A(raw_input[3]), .B(position_data[19]), .S0(n702), .Y(n426) );
  CLKMX2X2 U1077 ( .A(raw_input[2]), .B(position_data[18]), .S0(n702), .Y(n425) );
  CLKMX2X2 U1078 ( .A(raw_input[1]), .B(position_data[17]), .S0(n702), .Y(n424) );
  CLKMX2X2 U1079 ( .A(raw_input[0]), .B(vector_data[0]), .S0(n701), .Y(n423)
         );
  CLKMX2X2 U1080 ( .A(raw_input[1]), .B(vector_data[1]), .S0(n701), .Y(n422)
         );
  CLKMX2X2 U1081 ( .A(raw_input[2]), .B(vector_data[2]), .S0(n701), .Y(n421)
         );
  CLKMX2X2 U1082 ( .A(raw_input[3]), .B(vector_data[3]), .S0(n701), .Y(n420)
         );
  CLKMX2X2 U1083 ( .A(raw_input[4]), .B(vector_data[4]), .S0(n701), .Y(n419)
         );
  CLKMX2X2 U1084 ( .A(raw_input[5]), .B(vector_data[5]), .S0(n701), .Y(n418)
         );
  CLKMX2X2 U1085 ( .A(raw_input[6]), .B(vector_data[6]), .S0(n701), .Y(n417)
         );
  CLKMX2X2 U1086 ( .A(raw_input[7]), .B(vector_data[7]), .S0(n701), .Y(n416)
         );
  AO22X1 U1087 ( .A0(o_result[21]), .A1(n676), .B0(n883), .B1(result_hold[21]), 
        .Y(n415) );
  AO22X1 U1088 ( .A0(o_result[20]), .A1(n676), .B0(n696), .B1(result_hold[20]), 
        .Y(n414) );
  AO22X1 U1089 ( .A0(o_result[19]), .A1(n676), .B0(n883), .B1(result_hold[19]), 
        .Y(n413) );
  AO22X1 U1090 ( .A0(o_result[18]), .A1(n676), .B0(n696), .B1(result_hold[18]), 
        .Y(n412) );
  AO22X1 U1091 ( .A0(o_result[17]), .A1(n676), .B0(n883), .B1(result_hold[17]), 
        .Y(n411) );
  AO22X1 U1092 ( .A0(o_result[16]), .A1(n676), .B0(n696), .B1(result_hold[16]), 
        .Y(n4100) );
  AO22X1 U1093 ( .A0(o_result[15]), .A1(n676), .B0(n883), .B1(result_hold[15]), 
        .Y(n4090) );
  AO22X1 U1094 ( .A0(o_result[14]), .A1(n676), .B0(n696), .B1(result_hold[14]), 
        .Y(n4080) );
  AO22X1 U1095 ( .A0(o_result[13]), .A1(n676), .B0(n883), .B1(result_hold[13]), 
        .Y(n4070) );
  AO22X1 U1096 ( .A0(o_result[12]), .A1(n676), .B0(n696), .B1(result_hold[12]), 
        .Y(n4060) );
  AO22X1 U1097 ( .A0(o_result[11]), .A1(n676), .B0(n883), .B1(result_hold[11]), 
        .Y(n4050) );
  AO22X1 U1098 ( .A0(o_result[10]), .A1(n676), .B0(n696), .B1(result_hold[10]), 
        .Y(n4040) );
  AO22X1 U1099 ( .A0(o_result[9]), .A1(n676), .B0(n883), .B1(result_hold[9]), 
        .Y(n4030) );
  AO22X1 U1100 ( .A0(o_result[8]), .A1(n676), .B0(n696), .B1(result_hold[8]), 
        .Y(n402) );
  AO22X1 U1101 ( .A0(o_result[7]), .A1(n676), .B0(n883), .B1(result_hold[7]), 
        .Y(n401) );
  AO22X1 U1102 ( .A0(o_result[6]), .A1(n676), .B0(n696), .B1(result_hold[6]), 
        .Y(n400) );
  AO22X1 U1103 ( .A0(o_result[5]), .A1(n676), .B0(n883), .B1(result_hold[5]), 
        .Y(n399) );
  AO22X1 U1104 ( .A0(o_result[4]), .A1(n676), .B0(n696), .B1(result_hold[4]), 
        .Y(n398) );
  AO22X1 U1105 ( .A0(o_result[3]), .A1(n676), .B0(n883), .B1(result_hold[3]), 
        .Y(n397) );
  AO22X1 U1106 ( .A0(o_result[2]), .A1(n676), .B0(n696), .B1(result_hold[2]), 
        .Y(n396) );
  AO22X1 U1107 ( .A0(o_result[1]), .A1(n676), .B0(n883), .B1(result_hold[1]), 
        .Y(n395) );
  AO22X1 U1108 ( .A0(o_result[0]), .A1(n676), .B0(n696), .B1(result_hold[0]), 
        .Y(n394) );
  NOR2BX1 U1109 ( .AN(n798), .B(n853), .Y(n839) );
  OAI2BB2XL U1110 ( .B0(n884), .B1(n885), .A0N(weight_hold[0]), .A1N(n886), 
        .Y(n393) );
  AOI222XL U1111 ( .A0(weight_output[16]), .A1(n719), .B0(weight_output[0]), 
        .B1(n697), .C0(weight_output[8]), .C1(n720), .Y(n884) );
  OAI2BB2XL U1112 ( .B0(n888), .B1(n885), .A0N(weight_hold[1]), .A1N(n886), 
        .Y(n392) );
  AOI222XL U1113 ( .A0(weight_output[17]), .A1(n719), .B0(weight_output[1]), 
        .B1(n697), .C0(weight_output[9]), .C1(n720), .Y(n888) );
  OAI2BB2XL U1114 ( .B0(n889), .B1(n885), .A0N(weight_hold[2]), .A1N(n886), 
        .Y(n391) );
  AOI222XL U1115 ( .A0(weight_output[18]), .A1(n719), .B0(weight_output[2]), 
        .B1(n697), .C0(weight_output[10]), .C1(n720), .Y(n889) );
  OAI2BB2XL U1116 ( .B0(n890), .B1(n885), .A0N(weight_hold[3]), .A1N(n886), 
        .Y(n390) );
  AOI222XL U1117 ( .A0(weight_output[19]), .A1(n719), .B0(weight_output[3]), 
        .B1(n697), .C0(weight_output[11]), .C1(n720), .Y(n890) );
  OAI2BB2XL U1118 ( .B0(n891), .B1(n885), .A0N(weight_hold[4]), .A1N(n886), 
        .Y(n389) );
  AOI222XL U1119 ( .A0(weight_output[20]), .A1(n719), .B0(weight_output[4]), 
        .B1(n697), .C0(weight_output[12]), .C1(n720), .Y(n891) );
  OAI2BB2XL U1120 ( .B0(n892), .B1(n885), .A0N(weight_hold[5]), .A1N(n886), 
        .Y(n388) );
  AOI222XL U1121 ( .A0(weight_output[21]), .A1(n719), .B0(weight_output[5]), 
        .B1(n697), .C0(weight_output[13]), .C1(n720), .Y(n892) );
  OAI2BB2XL U1122 ( .B0(n893), .B1(n885), .A0N(weight_hold[6]), .A1N(n886), 
        .Y(n387) );
  AOI222XL U1123 ( .A0(weight_output[22]), .A1(n719), .B0(weight_output[6]), 
        .B1(n697), .C0(weight_output[14]), .C1(n720), .Y(n893) );
  OAI2BB2XL U1124 ( .B0(n894), .B1(n885), .A0N(weight_hold[7]), .A1N(n886), 
        .Y(n386) );
  OAI21XL U1125 ( .A0(rst), .A1(n749), .B0(n798), .Y(n895) );
  NOR3X1 U1126 ( .A(state[0]), .B(state[1]), .C(n727), .Y(n805) );
  AOI222XL U1127 ( .A0(weight_output[23]), .A1(n719), .B0(weight_output[7]), 
        .B1(n697), .C0(weight_output[15]), .C1(n720), .Y(n894) );
  OAI222XL U1128 ( .A0(n3600), .A1(n698), .B0(n898), .B1(n899), .C0(n699), 
        .C1(n901), .Y(n385) );
  CLKINVX1 U1129 ( .A(vector_address[0]), .Y(n901) );
  AOI222XL U1130 ( .A0(position_output[16]), .A1(n719), .B0(position_output[0]), .B1(n697), .C0(position_output[8]), .C1(n720), .Y(n898) );
  OAI222XL U1131 ( .A0(n3590), .A1(n698), .B0(n902), .B1(n899), .C0(n699), 
        .C1(n903), .Y(n3840) );
  CLKINVX1 U1132 ( .A(vector_address[1]), .Y(n903) );
  AOI222XL U1133 ( .A0(position_output[17]), .A1(n719), .B0(position_output[1]), .B1(n697), .C0(position_output[9]), .C1(n720), .Y(n902) );
  OAI222XL U1134 ( .A0(n3580), .A1(n698), .B0(n904), .B1(n899), .C0(n699), 
        .C1(n905), .Y(n3830) );
  CLKINVX1 U1135 ( .A(vector_address[2]), .Y(n905) );
  AOI222XL U1136 ( .A0(position_output[18]), .A1(n719), .B0(position_output[2]), .B1(n697), .C0(position_output[10]), .C1(n720), .Y(n904) );
  OAI222XL U1137 ( .A0(n3570), .A1(n698), .B0(n906), .B1(n899), .C0(n699), 
        .C1(n907), .Y(n3820) );
  CLKINVX1 U1138 ( .A(vector_address[3]), .Y(n907) );
  AOI222XL U1139 ( .A0(position_output[19]), .A1(n719), .B0(position_output[3]), .B1(n697), .C0(position_output[11]), .C1(n720), .Y(n906) );
  OAI222XL U1140 ( .A0(n3560), .A1(n698), .B0(n908), .B1(n899), .C0(n699), 
        .C1(n909), .Y(n3810) );
  CLKINVX1 U1141 ( .A(vector_address[4]), .Y(n909) );
  AOI222XL U1142 ( .A0(position_output[20]), .A1(n719), .B0(position_output[4]), .B1(n697), .C0(position_output[12]), .C1(n720), .Y(n908) );
  OAI222XL U1143 ( .A0(n3550), .A1(n698), .B0(n910), .B1(n899), .C0(n699), 
        .C1(n911), .Y(n3800) );
  CLKINVX1 U1144 ( .A(vector_address[5]), .Y(n911) );
  AOI222XL U1145 ( .A0(position_output[21]), .A1(n719), .B0(position_output[5]), .B1(n697), .C0(position_output[13]), .C1(n720), .Y(n910) );
  OAI222XL U1146 ( .A0(n354), .A1(n698), .B0(n912), .B1(n899), .C0(n699), .C1(
        n913), .Y(n3790) );
  CLKINVX1 U1147 ( .A(vector_address[6]), .Y(n913) );
  AOI222XL U1148 ( .A0(position_output[22]), .A1(n719), .B0(position_output[6]), .B1(n697), .C0(position_output[14]), .C1(n720), .Y(n912) );
  OAI222XL U1149 ( .A0(n353), .A1(n698), .B0(n914), .B1(n899), .C0(n699), .C1(
        n915), .Y(n3780) );
  CLKINVX1 U1150 ( .A(vector_address[7]), .Y(n915) );
  AOI222XL U1151 ( .A0(position_output[23]), .A1(n719), .B0(position_output[7]), .B1(n697), .C0(position_output[15]), .C1(n720), .Y(n914) );
  OAI222XL U1152 ( .A0(n774), .A1(n698), .B0(n844), .B1(n899), .C0(n699), .C1(
        n916), .Y(n3770) );
  CLKINVX1 U1153 ( .A(vector_address[8]), .Y(n916) );
  CLKINVX1 U1154 ( .A(feature_id[0]), .Y(n844) );
  CLKINVX1 U1155 ( .A(load_feature_id[0]), .Y(n774) );
  OAI222XL U1156 ( .A0(n791), .A1(n698), .B0(n847), .B1(n899), .C0(n699), .C1(
        n917), .Y(n3760) );
  CLKINVX1 U1157 ( .A(vector_address[9]), .Y(n917) );
  CLKINVX1 U1158 ( .A(feature_id[1]), .Y(n847) );
  CLKINVX1 U1159 ( .A(load_feature_id[1]), .Y(n791) );
  OAI222XL U1160 ( .A0(n730), .A1(n698), .B0(n851), .B1(n899), .C0(n699), .C1(
        n918), .Y(n3750) );
  CLKINVX1 U1161 ( .A(vector_address[10]), .Y(n918) );
  CLKINVX1 U1162 ( .A(feature_id[2]), .Y(n851) );
  CLKINVX1 U1163 ( .A(load_feature_id[2]), .Y(n730) );
  OAI222XL U1164 ( .A0(n790), .A1(n698), .B0(n947), .B1(n899), .C0(n699), .C1(
        n919), .Y(n3740) );
  CLKINVX1 U1165 ( .A(vector_address[11]), .Y(n919) );
  CLKINVX1 U1166 ( .A(load_feature_id[3]), .Y(n790) );
  AO21X1 U1167 ( .A0(o_valid), .A1(rst), .B0(n853), .Y(n347) );
  NOR2X1 U1168 ( .A(n700), .B(rst), .Y(n853) );
  OAI21XL U1169 ( .A0(n949), .A1(n950), .B0(n701), .Y(n346) );
  CLKINVX1 U1170 ( .A(vector_write_enable), .Y(n950) );
  OAI21XL U1171 ( .A0(n949), .A1(n951), .B0(n920), .Y(n345) );
  OAI21XL U1172 ( .A0(n744), .A1(n896), .B0(n725), .Y(n920) );
  CLKINVX1 U1173 ( .A(n749), .Y(n896) );
  NAND2X1 U1174 ( .A(n921), .B(state[0]), .Y(n749) );
  NOR3X1 U1175 ( .A(n685), .B(state[1]), .C(n735), .Y(n921) );
  NOR2X1 U1176 ( .A(n761), .B(n792), .Y(n744) );
  CLKINVX1 U1177 ( .A(n922), .Y(n727) );
  CLKINVX1 U1178 ( .A(raw_data_valid), .Y(n761) );
  CLKINVX1 U1179 ( .A(vector_chip_enable), .Y(n951) );
  OAI21XL U1180 ( .A0(n724), .A1(n952), .B0(n702), .Y(n344) );
  CLKINVX1 U1181 ( .A(position_write_enable[2]), .Y(n952) );
  OAI21XL U1182 ( .A0(n949), .A1(n953), .B0(n703), .Y(n343) );
  CLKINVX1 U1183 ( .A(position_write_enable[1]), .Y(n953) );
  OAI21XL U1184 ( .A0(n949), .A1(n954), .B0(n704), .Y(n342) );
  CLKINVX1 U1185 ( .A(position_write_enable[0]), .Y(n954) );
  OAI21XL U1186 ( .A0(n724), .A1(n955), .B0(n705), .Y(n341) );
  CLKINVX1 U1187 ( .A(bias_write_enable), .Y(n955) );
  OAI21XL U1188 ( .A0(n724), .A1(n956), .B0(n706), .Y(n340) );
  OAI22XL U1189 ( .A0(n797), .A1(n778), .B0(n783), .B1(n928), .Y(n927) );
  CLKINVX1 U1190 ( .A(n810), .Y(n778) );
  NOR2X1 U1191 ( .A(n735), .B(state[2]), .Y(n810) );
  CLKINVX1 U1192 ( .A(n767), .Y(n797) );
  NOR2X1 U1193 ( .A(n684), .B(state[0]), .Y(n767) );
  CLKINVX1 U1194 ( .A(bias_chip_enable), .Y(n956) );
  OAI21XL U1195 ( .A0(n724), .A1(n957), .B0(n707), .Y(n339) );
  OAI31XL U1196 ( .A0(n930), .A1(n931), .A2(n924), .B0(n932), .Y(n929) );
  CLKINVX1 U1197 ( .A(n933), .Y(n932) );
  CLKINVX1 U1198 ( .A(weight_chip_enable[2]), .Y(n957) );
  OAI21XL U1199 ( .A0(n724), .A1(n958), .B0(n708), .Y(n338) );
  NOR4X1 U1200 ( .A(N227), .B(n928), .C(n924), .D(n936), .Y(n934) );
  CLKINVX1 U1201 ( .A(weight_chip_enable[1]), .Y(n958) );
  OAI21XL U1202 ( .A0(n724), .A1(n959), .B0(n709), .Y(n337) );
  OAI31XL U1203 ( .A0(n924), .A1(N227), .A2(n931), .B0(n938), .Y(n937) );
  CLKINVX1 U1204 ( .A(weight_chip_enable[0]), .Y(n959) );
  OAI21XL U1205 ( .A0(n724), .A1(n960), .B0(n710), .Y(n336) );
  CLKINVX1 U1206 ( .A(weight_write_enable[2]), .Y(n960) );
  OAI21XL U1207 ( .A0(n724), .A1(n961), .B0(n711), .Y(n335) );
  CLKINVX1 U1208 ( .A(weight_write_enable[1]), .Y(n961) );
  OAI21XL U1209 ( .A0(n725), .A1(n962), .B0(n712), .Y(n334) );
  AND2X1 U1210 ( .A(n840), .B(n936), .Y(n923) );
  NOR2X1 U1211 ( .A(n928), .B(rst), .Y(n840) );
  CLKINVX1 U1212 ( .A(weight_write_enable[0]), .Y(n962) );
  OAI21XL U1213 ( .A0(n724), .A1(n963), .B0(n713), .Y(n333) );
  NOR3X1 U1214 ( .A(n742), .B(N446), .C(n941), .Y(n933) );
  NOR4X1 U1215 ( .A(n939), .B(n926), .C(n931), .D(n930), .Y(n940) );
  CLKINVX1 U1216 ( .A(position_chip_enable[2]), .Y(n963) );
  OAI21XL U1217 ( .A0(n725), .A1(n964), .B0(n714), .Y(n332) );
  OAI31XL U1218 ( .A0(n943), .A1(n928), .A2(n936), .B0(n944), .Y(n942) );
  CLKINVX1 U1219 ( .A(n935), .Y(n944) );
  NOR3X1 U1220 ( .A(n742), .B(N447), .C(n945), .Y(n935) );
  CLKINVX1 U1221 ( .A(position_chip_enable[1]), .Y(n964) );
  OAI21XL U1222 ( .A0(n724), .A1(n965), .B0(n715), .Y(n331) );
  OAI21XL U1223 ( .A0(n931), .A1(n943), .B0(n938), .Y(n946) );
  NAND3X1 U1224 ( .A(n945), .B(n941), .C(n716), .Y(n938) );
  NAND2X1 U1225 ( .A(n766), .B(n814), .Y(n742) );
  NOR2X1 U1226 ( .A(n685), .B(state[3]), .Y(n766) );
  CLKINVX1 U1227 ( .A(N447), .Y(n941) );
  CLKINVX1 U1228 ( .A(N446), .Y(n945) );
  NOR3X1 U1229 ( .A(n939), .B(N227), .C(n926), .Y(n925) );
  CLKINVX1 U1230 ( .A(n783), .Y(n926) );
  NAND2X1 U1231 ( .A(init_count[14]), .B(init_count[13]), .Y(n783) );
  NAND2X1 U1232 ( .A(n815), .B(n936), .Y(n931) );
  CLKINVX1 U1233 ( .A(N226), .Y(n936) );
  CLKINVX1 U1234 ( .A(n928), .Y(n815) );
  NAND2X1 U1235 ( .A(w_input_valid), .B(ld_w_request), .Y(n928) );
  CLKINVX1 U1236 ( .A(position_chip_enable[0]), .Y(n965) );
  CLKINVX1 U1237 ( .A(rst), .Y(n949) );
  NAND2X1 U1238 ( .A(n814), .B(n922), .Y(n775) );
  NOR2X1 U1239 ( .A(state[3]), .B(state[2]), .Y(n922) );
  NOR2X1 U1240 ( .A(n681), .B(state[1]), .Y(n814) );
endmodule


module SpMDV_DW_mult_tc_0 ( a, b, product );
  input [7:0] a;
  input [7:0] b;
  output [15:0] product;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n17,
         n18, n19, n20, n21, n23, n24, n25, n26, n27, n28, n29, n31, n32, n33,
         n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47,
         n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61,
         n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n74, n75, n76,
         n77, n78, n79, n81, n82, n83, n84, n85, n86, n87, n189, n190, n191,
         n192, n193, n194, n195, n196, n197, n198, n199, n200, n201, n202,
         n203, n204, n205, n206, n207, n208, n209, n210, n211, n212, n213,
         n214, n215, n216, n217, n218, n219, n220, n221, n222, n223, n224,
         n225, n226, n227, n228, n229, n230, n231, n232, n233, n234, n235,
         n236, n237, n238, n239, n240, n241, n242, n243, n244, n245;

  ADDFXL U2 ( .A(n15), .B(n56), .CI(n2), .CO(n1), .S(product[14]) );
  ADDFXL U6 ( .A(n25), .B(n27), .CI(n6), .CO(n5), .S(product[10]) );
  ADDFXL U10 ( .A(n44), .B(n43), .CI(n10), .CO(n9), .S(product[6]) );
  ADDFXL U12 ( .A(n49), .B(n50), .CI(n12), .CO(n11), .S(product[4]) );
  ADDFXL U17 ( .A(n21), .B(n64), .CI(n57), .CO(n17), .S(n18) );
  ADDFXL U18 ( .A(n196), .B(n58), .CI(n23), .CO(n19), .S(n20) );
  CMPR42X1 U20 ( .A(n72), .B(n65), .C(n29), .D(n59), .ICI(n26), .S(n25), .ICO(
        n23), .CO(n24) );
  CMPR42X1 U21 ( .A(n66), .B(n60), .C(n195), .D(n34), .ICI(n31), .S(n28), 
        .ICO(n26), .CO(n27) );
  CMPR42X1 U23 ( .A(n67), .B(n61), .C(n39), .D(n36), .ICI(n35), .S(n33), .ICO(
        n31), .CO(n32) );
  CMPR42X1 U26 ( .A(n81), .B(n68), .C(n74), .D(n41), .ICI(n40), .S(n38), .ICO(
        n36), .CO(n37) );
  ADDHXL U27 ( .A(n62), .B(n52), .CO(n39), .S(n40) );
  CMPR42X1 U28 ( .A(n63), .B(n82), .C(n75), .D(n69), .ICI(n46), .S(n43), .ICO(
        n41), .CO(n42) );
  ADDFX2 U140 ( .A(n33), .B(n37), .CI(n8), .CO(n7), .S(product[8]) );
  ADDFX2 U141 ( .A(n38), .B(n42), .CI(n9), .CO(n8), .S(product[7]) );
  OAI22X2 U142 ( .A0(n214), .A1(n213), .B0(n191), .B1(n215), .Y(n77) );
  NOR2X2 U143 ( .A(n191), .B(n194), .Y(n79) );
  CLKINVX2 U144 ( .A(b[0]), .Y(n194) );
  OAI22X1 U145 ( .A0(n207), .A1(n203), .B0(n208), .B1(n198), .Y(n83) );
  OR2X8 U146 ( .A(n207), .B(n198), .Y(n190) );
  XOR2X4 U147 ( .A(b[4]), .B(n199), .Y(n207) );
  OAI22X2 U148 ( .A0(n204), .A1(n203), .B0(n205), .B1(n198), .Y(n86) );
  XOR2X4 U149 ( .A(b[1]), .B(n199), .Y(n204) );
  CMPR22X2 U150 ( .A(n85), .B(n78), .CO(n50), .S(n51) );
  OAI22X2 U151 ( .A0(n205), .A1(n203), .B0(n206), .B1(n198), .Y(n85) );
  OAI22X4 U152 ( .A0(n212), .A1(n213), .B0(n191), .B1(n214), .Y(n78) );
  XOR2X2 U153 ( .A(n200), .B(b[0]), .Y(n212) );
  ADDHX2 U154 ( .A(n55), .B(n87), .CO(n14), .S(product[1]) );
  OAI21X1 U155 ( .A0(b[0]), .A1(n199), .B0(n203), .Y(n55) );
  XOR2X2 U156 ( .A(b[1]), .B(n200), .Y(n214) );
  OAI22X2 U157 ( .A0(b[0]), .A1(n203), .B0(n204), .B1(n198), .Y(n87) );
  XOR2X4 U158 ( .A(b[2]), .B(n199), .Y(n205) );
  ADDFHX2 U159 ( .A(n84), .B(n71), .CI(n77), .CO(n48), .S(n49) );
  NOR2XL U160 ( .A(n193), .B(n194), .Y(n63) );
  NOR2X2 U161 ( .A(n192), .B(n194), .Y(n71) );
  NOR2XL U162 ( .A(n198), .B(n194), .Y(product[0]) );
  ADDFHX2 U163 ( .A(n76), .B(n83), .CI(n47), .CO(n44), .S(n45) );
  ADDHX1 U164 ( .A(n70), .B(n53), .CO(n46), .S(n47) );
  ADDFHX2 U165 ( .A(n86), .B(n79), .CI(n14), .CO(n13), .S(product[2]) );
  OAI22XL U166 ( .A0(n221), .A1(n222), .B0(n192), .B1(n223), .Y(n70) );
  ADDFXL U167 ( .A(n20), .B(n24), .CI(n5), .CO(n4), .S(product[11]) );
  ADDFXL U168 ( .A(n51), .B(n54), .CI(n13), .CO(n12), .S(product[3]) );
  ADDFXL U169 ( .A(n45), .B(n48), .CI(n11), .CO(n10), .S(product[5]) );
  ADDFX2 U170 ( .A(n28), .B(n32), .CI(n7), .CO(n6), .S(product[9]) );
  ADDFXL U171 ( .A(n19), .B(n18), .CI(n4), .CO(n3), .S(product[12]) );
  XOR2XL U172 ( .A(n201), .B(b[0]), .Y(n221) );
  OR2XL U173 ( .A(n206), .B(n203), .Y(n189) );
  NAND2X1 U174 ( .A(n189), .B(n190), .Y(n84) );
  XOR2X4 U175 ( .A(b[3]), .B(n199), .Y(n206) );
  ADDFXL U176 ( .A(n17), .B(n197), .CI(n3), .CO(n2), .S(product[13]) );
  CLKINVX1 U177 ( .A(n15), .Y(n197) );
  CLKINVX1 U178 ( .A(n29), .Y(n195) );
  CLKINVX1 U179 ( .A(n21), .Y(n196) );
  INVX3 U180 ( .A(a[1]), .Y(n199) );
  NAND2X2 U181 ( .A(n192), .B(n244), .Y(n222) );
  CLKBUFX3 U182 ( .A(n220), .Y(n192) );
  XNOR2X1 U183 ( .A(a[4]), .B(a[3]), .Y(n220) );
  CLKBUFX3 U184 ( .A(n211), .Y(n191) );
  XNOR2X1 U185 ( .A(a[2]), .B(a[1]), .Y(n211) );
  NAND2X2 U186 ( .A(n191), .B(n243), .Y(n213) );
  INVX3 U187 ( .A(a[5]), .Y(n201) );
  INVX3 U188 ( .A(a[3]), .Y(n200) );
  NAND2X2 U189 ( .A(a[1]), .B(n198), .Y(n203) );
  INVX3 U190 ( .A(a[0]), .Y(n198) );
  CLKBUFX3 U191 ( .A(n230), .Y(n193) );
  XNOR2X1 U192 ( .A(a[6]), .B(a[5]), .Y(n230) );
  NAND2X2 U193 ( .A(n193), .B(n245), .Y(n232) );
  INVX3 U194 ( .A(a[7]), .Y(n202) );
  CLKINVX1 U195 ( .A(n1), .Y(product[15]) );
  OAI22XL U196 ( .A0(n208), .A1(n203), .B0(n209), .B1(n198), .Y(n82) );
  XOR2X1 U197 ( .A(b[5]), .B(n199), .Y(n208) );
  OAI2BB2XL U198 ( .B0(n209), .B1(n203), .A0N(n210), .A1N(a[0]), .Y(n81) );
  XOR2X1 U199 ( .A(b[6]), .B(n199), .Y(n209) );
  OAI22XL U200 ( .A0(n215), .A1(n213), .B0(n191), .B1(n216), .Y(n76) );
  XOR2X1 U201 ( .A(b[2]), .B(n200), .Y(n215) );
  OAI22XL U202 ( .A0(n216), .A1(n213), .B0(n191), .B1(n217), .Y(n75) );
  XOR2X1 U203 ( .A(b[3]), .B(n200), .Y(n216) );
  OAI22XL U204 ( .A0(n217), .A1(n213), .B0(n191), .B1(n218), .Y(n74) );
  XOR2X1 U205 ( .A(b[4]), .B(n200), .Y(n217) );
  AO21X1 U206 ( .A0(n213), .A1(n191), .B0(n219), .Y(n72) );
  OAI22XL U207 ( .A0(n223), .A1(n222), .B0(n192), .B1(n224), .Y(n69) );
  XOR2X1 U208 ( .A(b[1]), .B(n201), .Y(n223) );
  OAI22XL U209 ( .A0(n224), .A1(n222), .B0(n192), .B1(n225), .Y(n68) );
  XOR2X1 U210 ( .A(b[2]), .B(n201), .Y(n224) );
  OAI22XL U211 ( .A0(n225), .A1(n222), .B0(n192), .B1(n226), .Y(n67) );
  XOR2X1 U212 ( .A(b[3]), .B(n201), .Y(n225) );
  OAI22XL U213 ( .A0(n226), .A1(n222), .B0(n192), .B1(n227), .Y(n66) );
  XOR2X1 U214 ( .A(b[4]), .B(n201), .Y(n226) );
  OAI22XL U215 ( .A0(n227), .A1(n222), .B0(n192), .B1(n228), .Y(n65) );
  XOR2X1 U216 ( .A(b[5]), .B(n201), .Y(n227) );
  AO21X1 U217 ( .A0(n222), .A1(n192), .B0(n229), .Y(n64) );
  OAI22XL U218 ( .A0(n231), .A1(n232), .B0(n193), .B1(n233), .Y(n62) );
  XOR2X1 U219 ( .A(n202), .B(b[0]), .Y(n231) );
  OAI22XL U220 ( .A0(n233), .A1(n232), .B0(n193), .B1(n234), .Y(n61) );
  XOR2X1 U221 ( .A(b[1]), .B(n202), .Y(n233) );
  OAI22XL U222 ( .A0(n234), .A1(n232), .B0(n193), .B1(n235), .Y(n60) );
  XOR2X1 U223 ( .A(b[2]), .B(n202), .Y(n234) );
  OAI22XL U224 ( .A0(n235), .A1(n232), .B0(n193), .B1(n236), .Y(n59) );
  XOR2X1 U225 ( .A(b[3]), .B(n202), .Y(n235) );
  OAI22XL U226 ( .A0(n236), .A1(n232), .B0(n193), .B1(n237), .Y(n58) );
  XOR2X1 U227 ( .A(b[4]), .B(n202), .Y(n236) );
  OAI22XL U228 ( .A0(n237), .A1(n232), .B0(n193), .B1(n238), .Y(n57) );
  XOR2X1 U229 ( .A(b[5]), .B(n202), .Y(n237) );
  AO21X1 U230 ( .A0(n232), .A1(n193), .B0(n239), .Y(n56) );
  OAI32X1 U231 ( .A0(n200), .A1(b[0]), .A2(n191), .B0(n200), .B1(n213), .Y(n54) );
  OAI32X1 U232 ( .A0(n201), .A1(b[0]), .A2(n192), .B0(n201), .B1(n222), .Y(n53) );
  OAI32X1 U233 ( .A0(n202), .A1(b[0]), .A2(n193), .B0(n202), .B1(n232), .Y(n52) );
  XOR2X1 U234 ( .A(n240), .B(n241), .Y(n35) );
  NAND2BX1 U235 ( .AN(n240), .B(n241), .Y(n34) );
  OA22X1 U236 ( .A0(n218), .A1(n213), .B0(n191), .B1(n242), .Y(n241) );
  XOR2X1 U237 ( .A(b[5]), .B(n200), .Y(n218) );
  OAI2BB1X1 U238 ( .A0N(n198), .A1N(n203), .B0(n210), .Y(n240) );
  XOR2X1 U239 ( .A(b[7]), .B(a[1]), .Y(n210) );
  OAI22XL U240 ( .A0(n191), .A1(n219), .B0(n242), .B1(n213), .Y(n29) );
  XOR2X1 U241 ( .A(a[3]), .B(a[2]), .Y(n243) );
  XOR2X1 U242 ( .A(b[6]), .B(n200), .Y(n242) );
  XOR2X1 U243 ( .A(b[7]), .B(n200), .Y(n219) );
  OAI22XL U244 ( .A0(n192), .A1(n229), .B0(n228), .B1(n222), .Y(n21) );
  XOR2X1 U245 ( .A(a[5]), .B(a[4]), .Y(n244) );
  XOR2X1 U246 ( .A(b[6]), .B(n201), .Y(n228) );
  XOR2X1 U247 ( .A(b[7]), .B(n201), .Y(n229) );
  OAI22XL U248 ( .A0(n193), .A1(n239), .B0(n238), .B1(n232), .Y(n15) );
  XOR2X1 U249 ( .A(a[7]), .B(a[6]), .Y(n245) );
  XOR2X1 U250 ( .A(b[6]), .B(n202), .Y(n238) );
  XOR2X1 U251 ( .A(b[7]), .B(n202), .Y(n239) );
endmodule


module SpMDV_DW01_inc_3_DW01_inc_7 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;

  wire   [7:2] carry;

  ADDHXL U1_1_6 ( .A(A[6]), .B(carry[6]), .CO(carry[7]), .S(SUM[6]) );
  ADDHXL U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  ADDHXL U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHXL U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHXL U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHXL U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  XOR2X1 U1 ( .A(carry[7]), .B(A[7]), .Y(SUM[7]) );
  CLKINVX1 U2 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module SpMDV_DW01_inc_2_DW01_inc_6 ( A, SUM );
  input [14:0] A;
  output [14:0] SUM;

  wire   [14:2] carry;

  ADDHXL U1_1_13 ( .A(A[13]), .B(carry[13]), .CO(carry[14]), .S(SUM[13]) );
  ADDHXL U1_1_7 ( .A(A[7]), .B(carry[7]), .CO(carry[8]), .S(SUM[7]) );
  ADDHXL U1_1_6 ( .A(A[6]), .B(carry[6]), .CO(carry[7]), .S(SUM[6]) );
  ADDHXL U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHXL U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHXL U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHXL U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  ADDHXL U1_1_11 ( .A(A[11]), .B(carry[11]), .CO(carry[12]), .S(SUM[11]) );
  ADDHXL U1_1_10 ( .A(A[10]), .B(carry[10]), .CO(carry[11]), .S(SUM[10]) );
  ADDHXL U1_1_9 ( .A(A[9]), .B(carry[9]), .CO(carry[10]), .S(SUM[9]) );
  ADDHXL U1_1_8 ( .A(A[8]), .B(carry[8]), .CO(carry[9]), .S(SUM[8]) );
  ADDHXL U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  ADDHXL U1_1_12 ( .A(A[12]), .B(carry[12]), .CO(carry[13]), .S(SUM[12]) );
  XOR2X1 U1 ( .A(carry[14]), .B(A[14]), .Y(SUM[14]) );
  CLKINVX1 U2 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module SpMDV_DW01_inc_1_DW01_inc_5 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;

  wire   [7:2] carry;

  ADDHXL U1_1_6 ( .A(A[6]), .B(carry[6]), .CO(carry[7]), .S(SUM[6]) );
  ADDHXL U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHXL U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHXL U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHXL U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  ADDHXL U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  XOR2X1 U1 ( .A(carry[7]), .B(A[7]), .Y(SUM[7]) );
  CLKINVX1 U2 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module SpMDV_DW01_add_1 ( A, B, SUM );
  input [21:0] A;
  input [21:0] B;
  output [21:0] SUM;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16
;
  wire   [21:2] carry;

  ADDFXL U1_5 ( .A(A[5]), .B(B[5]), .CI(carry[5]), .CO(carry[6]), .S(SUM[5])
         );
  XOR3X1 U1_21 ( .A(A[21]), .B(B[21]), .C(carry[21]), .Y(SUM[21]) );
  ADDFXL U1_6 ( .A(A[6]), .B(B[6]), .CI(carry[6]), .CO(carry[7]), .S(SUM[6])
         );
  ADDFXL U1_18 ( .A(A[18]), .B(B[18]), .CI(carry[18]), .CO(carry[19]), .S(
        SUM[18]) );
  ADDFX2 U1_15 ( .A(A[15]), .B(B[15]), .CI(carry[15]), .CO(carry[16]), .S(
        SUM[15]) );
  ADDFXL U1_19 ( .A(A[19]), .B(B[19]), .CI(carry[19]), .CO(carry[20]), .S(
        SUM[19]) );
  ADDFX2 U1_9 ( .A(A[9]), .B(B[9]), .CI(carry[9]), .CO(carry[10]), .S(SUM[9])
         );
  ADDFXL U1_20 ( .A(A[20]), .B(B[20]), .CI(carry[20]), .CO(carry[21]), .S(
        SUM[20]) );
  ADDFX2 U1_7 ( .A(A[7]), .B(B[7]), .CI(carry[7]), .CO(carry[8]), .S(SUM[7])
         );
  ADDFX2 U1_3 ( .A(A[3]), .B(B[3]), .CI(carry[3]), .CO(carry[4]), .S(SUM[3])
         );
  ADDFXL U1_2 ( .A(A[2]), .B(B[2]), .CI(carry[2]), .CO(carry[3]), .S(SUM[2])
         );
  ADDFXL U1_4 ( .A(A[4]), .B(B[4]), .CI(carry[4]), .CO(carry[5]), .S(SUM[4])
         );
  ADDFHX4 U1_1 ( .A(A[1]), .B(B[1]), .CI(n4), .CO(carry[2]), .S(SUM[1]) );
  ADDFHX4 U1_12 ( .A(A[12]), .B(B[12]), .CI(carry[12]), .CO(carry[13]), .S(
        SUM[12]) );
  ADDFHX4 U1_13 ( .A(A[13]), .B(B[13]), .CI(carry[13]), .CO(carry[14]), .S(
        SUM[13]) );
  ADDFX2 U1_8 ( .A(A[8]), .B(B[8]), .CI(carry[8]), .CO(carry[9]), .S(SUM[8])
         );
  CLKAND2X12 U1 ( .A(B[0]), .B(A[0]), .Y(n4) );
  NAND3X1 U2 ( .A(n11), .B(n12), .C(n13), .Y(carry[12]) );
  NAND2X1 U3 ( .A(A[11]), .B(carry[11]), .Y(n12) );
  NAND2X1 U4 ( .A(A[17]), .B(carry[17]), .Y(n6) );
  NAND2X1 U5 ( .A(B[17]), .B(carry[17]), .Y(n5) );
  NAND2X6 U6 ( .A(B[10]), .B(carry[10]), .Y(n9) );
  XOR3XL U7 ( .A(carry[16]), .B(B[16]), .C(A[16]), .Y(SUM[16]) );
  NAND2X6 U8 ( .A(A[16]), .B(carry[16]), .Y(n1) );
  NAND2X8 U9 ( .A(B[16]), .B(carry[16]), .Y(n2) );
  NAND2X6 U10 ( .A(B[16]), .B(A[16]), .Y(n3) );
  NAND3X8 U11 ( .A(n1), .B(n2), .C(n3), .Y(carry[17]) );
  NAND3X1 U12 ( .A(n14), .B(n15), .C(n16), .Y(carry[15]) );
  NAND3X1 U13 ( .A(n5), .B(n6), .C(n7), .Y(carry[18]) );
  NAND2X1 U14 ( .A(B[10]), .B(A[10]), .Y(n10) );
  NAND2X1 U15 ( .A(B[11]), .B(carry[11]), .Y(n11) );
  NAND2XL U16 ( .A(A[17]), .B(B[17]), .Y(n7) );
  XOR3XL U17 ( .A(carry[17]), .B(A[17]), .C(B[17]), .Y(SUM[17]) );
  XOR3XL U18 ( .A(carry[10]), .B(B[10]), .C(A[10]), .Y(SUM[10]) );
  NAND2X4 U19 ( .A(A[10]), .B(carry[10]), .Y(n8) );
  NAND3X8 U20 ( .A(n8), .B(n9), .C(n10), .Y(carry[11]) );
  NAND2X1 U21 ( .A(A[11]), .B(B[11]), .Y(n13) );
  XOR3XL U22 ( .A(carry[11]), .B(A[11]), .C(B[11]), .Y(SUM[11]) );
  XOR3X1 U23 ( .A(carry[14]), .B(B[14]), .C(A[14]), .Y(SUM[14]) );
  NAND2X1 U24 ( .A(A[14]), .B(carry[14]), .Y(n14) );
  NAND2XL U25 ( .A(B[14]), .B(carry[14]), .Y(n15) );
  NAND2X1 U26 ( .A(B[14]), .B(A[14]), .Y(n16) );
  XOR2XL U27 ( .A(B[0]), .B(A[0]), .Y(SUM[0]) );
endmodule


module SpMDV_DW01_add_0 ( A, SUM, \B[21] , \B[20] , \B[19] , \B[18] , \B[17] , 
        \B[16] , \B[15] , \B[14] , \B[13] , \B[12] , \B[11] , \B[10] , \B[9] , 
        \B[8] , \B[7] , \B[6] , \B[5] , \B[4]  );
  input [21:0] A;
  output [21:0] SUM;
  input \B[21] , \B[20] , \B[19] , \B[18] , \B[17] , \B[16] , \B[15] , \B[14] ,
         \B[13] , \B[12] , \B[11] , \B[10] , \B[9] , \B[8] , \B[7] , \B[6] ,
         \B[5] , \B[4] ;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n19, n20, n21, n22, n23, n24, n25, n26;
  wire   [21:4] B;
  wire   [21:6] carry;
  assign B[21] = \B[21] ;
  assign B[20] = \B[20] ;
  assign B[19] = \B[19] ;
  assign B[18] = \B[18] ;
  assign B[17] = \B[17] ;
  assign B[16] = \B[16] ;
  assign B[15] = \B[15] ;
  assign B[14] = \B[14] ;
  assign B[13] = \B[13] ;
  assign B[12] = \B[12] ;
  assign B[11] = \B[11] ;
  assign B[10] = \B[10] ;
  assign B[9] = \B[9] ;
  assign B[8] = \B[8] ;
  assign B[7] = \B[7] ;
  assign B[6] = \B[6] ;
  assign B[5] = \B[5] ;
  assign B[4] = \B[4] ;

  XOR3X1 U1_21 ( .A(A[21]), .B(B[21]), .C(carry[21]), .Y(SUM[21]) );
  ADDFXL U1_12 ( .A(A[12]), .B(B[12]), .CI(carry[12]), .CO(carry[13]), .S(
        SUM[12]) );
  ADDFHX4 U1_6 ( .A(A[6]), .B(B[6]), .CI(carry[6]), .CO(carry[7]), .S(SUM[6])
         );
  ADDFHX4 U1_19 ( .A(A[19]), .B(B[19]), .CI(carry[19]), .CO(carry[20]), .S(
        SUM[19]) );
  ADDFHX4 U1_9 ( .A(A[9]), .B(B[9]), .CI(carry[9]), .CO(carry[10]), .S(SUM[9])
         );
  ADDFXL U1_5 ( .A(A[5]), .B(B[5]), .CI(n1), .CO(carry[6]), .S(SUM[5]) );
  ADDFXL U1_18 ( .A(A[18]), .B(B[18]), .CI(carry[18]), .CO(carry[19]), .S(
        SUM[18]) );
  ADDFHX2 U1_13 ( .A(A[13]), .B(B[13]), .CI(carry[13]), .CO(carry[14]), .S(
        SUM[13]) );
  ADDFHX4 U1_14 ( .A(A[14]), .B(B[14]), .CI(carry[14]), .CO(carry[15]), .S(
        SUM[14]) );
  NAND3X2 U1 ( .A(n11), .B(n12), .C(n13), .Y(carry[8]) );
  NAND3X4 U2 ( .A(n14), .B(n15), .C(n16), .Y(carry[16]) );
  AND2X2 U3 ( .A(B[4]), .B(A[4]), .Y(n1) );
  NAND2X1 U4 ( .A(A[17]), .B(carry[17]), .Y(n9) );
  NAND2X1 U5 ( .A(B[17]), .B(carry[17]), .Y(n8) );
  NAND2X1 U6 ( .A(B[16]), .B(carry[16]), .Y(n2) );
  NAND2X1 U7 ( .A(A[16]), .B(carry[16]), .Y(n3) );
  NAND2X1 U8 ( .A(A[16]), .B(B[16]), .Y(n4) );
  NAND3X1 U9 ( .A(n2), .B(n3), .C(n4), .Y(carry[17]) );
  XOR3XL U10 ( .A(carry[16]), .B(A[16]), .C(B[16]), .Y(SUM[16]) );
  NAND3X2 U11 ( .A(n24), .B(n25), .C(n26), .Y(carry[9]) );
  NAND3X1 U12 ( .A(n21), .B(n22), .C(n23), .Y(carry[21]) );
  NAND2X1 U13 ( .A(A[7]), .B(carry[7]), .Y(n12) );
  NAND2X1 U14 ( .A(A[7]), .B(B[7]), .Y(n13) );
  NAND2X1 U15 ( .A(B[11]), .B(carry[11]), .Y(n17) );
  NAND2X1 U16 ( .A(A[11]), .B(carry[11]), .Y(n18) );
  NAND2X1 U17 ( .A(B[10]), .B(carry[10]), .Y(n5) );
  NAND2X1 U18 ( .A(A[10]), .B(carry[10]), .Y(n6) );
  NAND2X1 U19 ( .A(A[10]), .B(B[10]), .Y(n7) );
  NAND3X1 U20 ( .A(n5), .B(n6), .C(n7), .Y(carry[11]) );
  XOR3XL U21 ( .A(carry[10]), .B(A[10]), .C(B[10]), .Y(SUM[10]) );
  NAND2X1 U22 ( .A(B[8]), .B(carry[8]), .Y(n24) );
  NAND2X1 U23 ( .A(A[8]), .B(carry[8]), .Y(n25) );
  XOR2XL U24 ( .A(carry[20]), .B(n20), .Y(SUM[20]) );
  NAND2X1 U25 ( .A(A[17]), .B(B[17]), .Y(n10) );
  NAND3X1 U26 ( .A(n8), .B(n9), .C(n10), .Y(carry[18]) );
  NAND2X1 U27 ( .A(B[7]), .B(carry[7]), .Y(n11) );
  XOR3XL U28 ( .A(carry[17]), .B(A[17]), .C(B[17]), .Y(SUM[17]) );
  XOR3XL U29 ( .A(carry[7]), .B(A[7]), .C(B[7]), .Y(SUM[7]) );
  NAND2X1 U30 ( .A(B[15]), .B(carry[15]), .Y(n14) );
  NAND2X1 U31 ( .A(A[15]), .B(carry[15]), .Y(n15) );
  NAND2X1 U32 ( .A(A[15]), .B(B[15]), .Y(n16) );
  NAND2X1 U33 ( .A(A[11]), .B(B[11]), .Y(n19) );
  NAND3X1 U34 ( .A(n17), .B(n18), .C(n19), .Y(carry[12]) );
  XOR3XL U35 ( .A(carry[15]), .B(A[15]), .C(B[15]), .Y(SUM[15]) );
  XOR3XL U36 ( .A(carry[11]), .B(A[11]), .C(B[11]), .Y(SUM[11]) );
  XOR2XL U37 ( .A(B[20]), .B(A[20]), .Y(n20) );
  NAND2X1 U38 ( .A(B[20]), .B(carry[20]), .Y(n21) );
  NAND2X1 U39 ( .A(A[20]), .B(carry[20]), .Y(n22) );
  NAND2X1 U40 ( .A(A[20]), .B(B[20]), .Y(n23) );
  NAND2X1 U41 ( .A(A[8]), .B(B[8]), .Y(n26) );
  XOR3XL U42 ( .A(carry[8]), .B(A[8]), .C(B[8]), .Y(SUM[8]) );
  XOR2XL U43 ( .A(B[4]), .B(A[4]), .Y(SUM[4]) );
  CLKBUFX2 U44 ( .A(A[3]), .Y(SUM[3]) );
  CLKBUFX2 U45 ( .A(A[2]), .Y(SUM[2]) );
  CLKBUFX2 U46 ( .A(A[1]), .Y(SUM[1]) );
  CLKBUFX2 U47 ( .A(A[0]), .Y(SUM[0]) );
endmodule

