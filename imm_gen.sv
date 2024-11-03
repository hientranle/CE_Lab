import control_types::*;
module imm_gen (
    input logic [24:0] IN,					// INST[31:7]
    input imm_ctrl IMM_SEL,
    output logic [31:0] OUT
);

//    `define SE20_UI 3'b000
//    `define SE12_LI 3'b001
//    `define SE05    3'b011
//    `define SE12_BR 3'b010
//    `define SE12_ST 3'b110
//    `define SE20_JP 3'b111
    
    always_comb begin
        if (IMM_SEL == SE20_UI) begin 				// U TYPE
            OUT[31:12] = IN[24:5];
            OUT[11:0] = {12{1'b0}};
        end else if (IMM_SEL == SE12_LI) begin			//  I TYPE - LOAD INSTRUCTION
            OUT[11:0] = IN[24:13];
            OUT[31:12] = {20{IN[24]}};
        end else if (IMM_SEL == SE05) begin			// SHIFT IMMEDIATE
            OUT[4:0] = IN[17:13];
            OUT[31:5] = 27'b0;
        end else if (IMM_SEL == SE12_BR) begin			// B TYPE
            OUT[0] = {1'b0};
            OUT[4:1] = IN[4:1];
            OUT[10:5] = IN[23:18];
            OUT[11] = IN[0];
            OUT[12] = IN[24];
            OUT[31:13] = {19{IN[24]}};
        end else if (IMM_SEL == SE12_ST) begin			// S TYPE
            OUT[4:0] = IN[4:0];
            OUT[11:5] = IN[24:18];
            OUT[31:12] = {20{IN[24]}};
        end else if (IMM_SEL == SE20_JP) begin			// JAL
            OUT[0] = {1'b0};
            OUT[10:1] = IN[23:14];
            OUT[11] = IN[13];
            OUT[20] = IN[24];
            OUT[31:21] = {11{IN[24]}};
        end else begin
            OUT = 32'h0;
        end   
    end
endmodule