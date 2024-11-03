import control_types::*;
module imm_gen (
    input logic [24:0] in,					// inst[31:7]
    input imm_ctrl imm_sel,
    output logic [31:0] out
);

//    `define SE20_UI 3'b000
//    `define SE12_LI 3'b001
//    `define SE05    3'b011
//    `define SE12_BR 3'b010
//    `define SE12_ST 3'b110
//    `define SE20_JP 3'b111
    
    always_comb begin
        if (imm_sel == SE20_UI) begin 				// U TYPE
            out = {in[24:5], 12'b0};
        end else if (imm_sel == SE12_LI) begin			//  I TYPE - LOAD INSTRUCTION
            out = {{20{in[24]}}, in[24:13]};
        end else if (imm_sel == SE12_BR) begin			// B TYPE
           out = {{19{in[24]}}, in[24], in[0], in[23:18], in[4:1], 1'b0};
        end else if (imm_sel == SE12_ST) begin			// S TYPE
            out = {{20{in[24]}}, in[24:18], in[4:0]};
        end else if (imm_sel == SE20_JP) begin			// JAL
				out = {{11{in[24]}}, in[24], in[12:5], in[13], in[23:14], 1'b0};
        end else begin
            out = 32'h0;
        end   
    end
endmodule