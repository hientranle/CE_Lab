module bit_comparator (
    input logic A,
    input logic B,
    output logic lt,   // A < B
    output logic eq    // A == B
);
    assign lt = ~A & B;
    assign eq = ~(A ^ B);
endmodule


module comparator (
    input  logic [31:0] i_rs1_data,
    input  logic [31:0] i_rs2_data,
    input  logic        i_br_un,   // Unsigned comparison control
    output logic        o_br_less, // Result: i_rs1_data < i_rs2_data
    output logic        o_br_equal // Result: i_rs1_data == i_rs2_data
);

    logic [31:0] lt_bits;   // Store less-than results for each bit
    logic [31:0] eq_bits;   // Store equal results for each bit
    logic lt_temp;
	 
	 genvar i;
    generate
        for (i = 0; i < 32; i++) begin : bit_comps
            bit_comparator bc(
                .A(i_rs1_data[i]),
                .B(i_rs2_data[i]),
                .lt(lt_bits[i]),
                .eq(eq_bits[i])
            );
        end
    endgenerate

//    bit_comparator bc(
//        .A(i_rs1_data[31:0]),
//        .B(i_rs2_data[31:0]),
//        .lt(lt_bits[31:0]),
//        .eq(eq_bits[31:0])
//    );

    assign o_br_equal = &eq_bits;
    assign lt_temp = lt_bits[31] |
                   (eq_bits[31] & lt_bits[30]) |
                   (eq_bits[31] & eq_bits[30] & lt_bits[29]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & lt_bits[28]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & lt_bits[27]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & lt_bits[26]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & lt_bits[25]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & lt_bits[24]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & lt_bits[23]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & eq_bits[23] & lt_bits[22]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & eq_bits[23] & eq_bits[22] & lt_bits[21]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & eq_bits[23] & eq_bits[22] & eq_bits[21] & lt_bits[20]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & eq_bits[23] & eq_bits[22] & eq_bits[21] & eq_bits[20] & lt_bits[19]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & eq_bits[23] & eq_bits[22] & eq_bits[21] & eq_bits[20] & eq_bits[19] & lt_bits[18]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & eq_bits[23] & eq_bits[22] & eq_bits[21] & eq_bits[20] & eq_bits[19] & eq_bits[18] & lt_bits[17]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & eq_bits[23] & eq_bits[22] & eq_bits[21] & eq_bits[20] & eq_bits[19] & eq_bits[18] & eq_bits[17] & lt_bits[16]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & eq_bits[23] & eq_bits[22] & eq_bits[21] & eq_bits[20] & eq_bits[19] & eq_bits[18] & eq_bits[17] & eq_bits[16] & lt_bits[15]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & eq_bits[23] & eq_bits[22] & eq_bits[21] & eq_bits[20] & eq_bits[19] & eq_bits[18] & eq_bits[17] & eq_bits[16] & eq_bits[15] & lt_bits[14]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & eq_bits[23] & eq_bits[22] & eq_bits[21] & eq_bits[20] & eq_bits[19] & eq_bits[18] & eq_bits[17] & eq_bits[16] & eq_bits[15] & eq_bits[14] & lt_bits[13]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & eq_bits[23] & eq_bits[22] & eq_bits[21] & eq_bits[20] & eq_bits[19] & eq_bits[18] & eq_bits[17] & eq_bits[16] & eq_bits[15] & eq_bits[14] & eq_bits[13] & lt_bits[12]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & eq_bits[23] & eq_bits[22] & eq_bits[21] & eq_bits[20] & eq_bits[19] & eq_bits[18] & eq_bits[17] & eq_bits[16] & eq_bits[15] & eq_bits[14] & eq_bits[13] & eq_bits[12] & lt_bits[11]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & eq_bits[23] & eq_bits[22] & eq_bits[21] & eq_bits[20] & eq_bits[19] & eq_bits[18] & eq_bits[17] & eq_bits[16] & eq_bits[15] & eq_bits[14] & eq_bits[13] & eq_bits[12] & eq_bits[11] & lt_bits[10]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & eq_bits[23] & eq_bits[22] & eq_bits[21] & eq_bits[20] & eq_bits[19] & eq_bits[18] & eq_bits[17] & eq_bits[16] & eq_bits[15] & eq_bits[14] & eq_bits[13] & eq_bits[12] & eq_bits[11] & eq_bits[10] & lt_bits[9]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & eq_bits[23] & eq_bits[22] & eq_bits[21] & eq_bits[20] & eq_bits[19] & eq_bits[18] & eq_bits[17] & eq_bits[16] & eq_bits[15] & eq_bits[14] & eq_bits[13] & eq_bits[12] & eq_bits[11] & eq_bits[10] & eq_bits[9] & lt_bits[8]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & eq_bits[23] & eq_bits[22] & eq_bits[21] & eq_bits[20] & eq_bits[19] & eq_bits[18] & eq_bits[17] & eq_bits[16] & eq_bits[15] & eq_bits[14] & eq_bits[13] & eq_bits[12] & eq_bits[11] & eq_bits[10] & eq_bits[9] & eq_bits[8] & lt_bits[7]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & eq_bits[23] & eq_bits[22] & eq_bits[21] & eq_bits[20] & eq_bits[19] & eq_bits[18] & eq_bits[17] & eq_bits[16] & eq_bits[15] & eq_bits[14] & eq_bits[13] & eq_bits[12] & eq_bits[11] & eq_bits[10] & eq_bits[9] & eq_bits[8] & eq_bits[7] & lt_bits[6]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & eq_bits[23] & eq_bits[22] & eq_bits[21] & eq_bits[20] & eq_bits[19] & eq_bits[18] & eq_bits[17] & eq_bits[16] & eq_bits[15] & eq_bits[14] & eq_bits[13] & eq_bits[12] & eq_bits[11] & eq_bits[10] & eq_bits[9] & eq_bits[8] & eq_bits[7] & eq_bits[6] & lt_bits[5]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & eq_bits[23] & eq_bits[22] & eq_bits[21] & eq_bits[20] & eq_bits[19] & eq_bits[18] & eq_bits[17] & eq_bits[16] & eq_bits[15] & eq_bits[14] & eq_bits[13] & eq_bits[12] & eq_bits[11] & eq_bits[10] & eq_bits[9] & eq_bits[8] & eq_bits[7] & eq_bits[6] & eq_bits[5] & lt_bits[4]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & eq_bits[23] & eq_bits[22] & eq_bits[21] & eq_bits[20] & eq_bits[19] & eq_bits[18] & eq_bits[17] & eq_bits[16] & eq_bits[15] & eq_bits[14] & eq_bits[13] & eq_bits[12] & eq_bits[11] & eq_bits[10] & eq_bits[9] & eq_bits[8] & eq_bits[7] & eq_bits[6] & eq_bits[5] & eq_bits[4] & lt_bits[3]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & eq_bits[23] & eq_bits[22] & eq_bits[21] & eq_bits[20] & eq_bits[19] & eq_bits[18] & eq_bits[17] & eq_bits[16] & eq_bits[15] & eq_bits[14] & eq_bits[13] & eq_bits[12] & eq_bits[11] & eq_bits[10] & eq_bits[9] & eq_bits[8] & eq_bits[7] & eq_bits[6] & eq_bits[5] & eq_bits[4] & eq_bits[3] & lt_bits[2]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & eq_bits[23] & eq_bits[22] & eq_bits[21] & eq_bits[20] & eq_bits[19] & eq_bits[18] & eq_bits[17] & eq_bits[16] & eq_bits[15] & eq_bits[14] & eq_bits[13] & eq_bits[12] & eq_bits[11] & eq_bits[10] & eq_bits[9] & eq_bits[8] & eq_bits[7] & eq_bits[6] & eq_bits[5] & eq_bits[4] & eq_bits[3] & eq_bits[2] & lt_bits[1]) |
                   (eq_bits[31] & eq_bits[30] & eq_bits[29] & eq_bits[28] & eq_bits[27] & eq_bits[26] & eq_bits[25] & eq_bits[24] & eq_bits[23] & eq_bits[22] & eq_bits[21] & eq_bits[20] & eq_bits[19] & eq_bits[18] & eq_bits[17] & eq_bits[16] & eq_bits[15] & eq_bits[14] & eq_bits[13] & eq_bits[12] & eq_bits[11] & eq_bits[10] & eq_bits[9] & eq_bits[8] & eq_bits[7] & eq_bits[6] & eq_bits[5] & eq_bits[4] & eq_bits[3] & eq_bits[2] & eq_bits[1] & lt_bits[0]);

	 always_comb begin
        if (i_br_un) begin
            o_br_less = lt_temp;
        end else begin
		      if (i_rs1_data[31] ^ i_rs2_data[31]) begin
				    o_br_less = i_rs1_data[31];				 
				end else begin
                o_br_less = lt_temp;
				end	 
		  end
    end
endmodule