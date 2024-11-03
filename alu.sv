module alu 
import alu_pkg::*
(
  input logic [31:0] i_op_a,
  input logic [31:0] i_op_b,
  input logic [3:0]  i_alu_op,
  input logic        i_BrLT,
  
  output logic [31:0] o_alu_data
);
logic [32:0] resultAdd;
logic [32:0] resultSub;
logic [31:0] resultSlt;
logic [31:0] resultSltu;
logic [31:0] resultXor;
logic [31:0] resultOr;
logic [31:0] resultAnd;
logic [31:0] resultSll;
logic [31:0] resultSrl;
logic [31:0] resultSra;
always_comb begin: AluLogic
  case(i_alu_op)
    ALU_ADD  : o_alu_data = resultAdd[31:0]; 
    ALU_SUB  : o_alu_data = resultSub[31:0];
    ALU_SLT  : o_alu_data = {31'h0,i_BrLT}; 
    ALU_SLTU : o_alu_data = {31'h0,i_BrLT}; 
    //ALU_SLT  : o_alu_data = resultSlt;
    //ALU_SLTU : o_alu_data = resultSltu;
    ALU_XOR  : o_alu_data = resultXor;
    ALU_OR   : o_alu_data = resultOr;
    ALU_AND  : o_alu_data = resultAnd;
    ALU_SLL  : o_alu_data = resultSll;
    ALU_SRL  : o_alu_data = resultSrl; 
    ALU_SRA  : o_alu_data = resultSra;
    ALU_LUI  : o_alu_data = LUI_add_zero[31:0];
	 default  :  o_alu_data = 32'h0;
  endcase
end
//Alu output
logic [32:0] SubRet;
logic [32:0] AddRet;
logic [32:0] LUI_add_zero;
assign SubRet = Sub(i_op_a,i_op_b);
assign AddRet = i_op_a + i_op_b;
assign LUI_add_zero = i_op_b + 32'h0;
always_comb begin
  resultAdd = AddRet[31:0];
  resultSub = SubRet[31:0];
  resultXor = i_op_a ^ i_op_b;
  resultOr  = i_op_a | i_op_b;
  resultAnd = i_op_a & i_op_b;
  resultSll = SLL(i_op_a,i_op_b[4:0]);
  resultSll = SRA(i_op_a,i_op_b[4:0]);
  resultSll = SRL(i_op_a,i_op_b[4:0]);
end
//comparator unsigned_comp (
//  .i_rs1_data(i_op_a), 
//  .i_rs2_data(i_op_b),
//  .i_br_un(1'b1),   
//  .o_br_less(resultSlt), 
//  .o_br_equal(),
//  .o_br_greater()
//);
//
//comparator unsigned_comp (
//  .i_rs1_data(i_op_a), 
//  .i_rs2_data(i_op_b),
//  .i_br_un(1'b0),   
//  .o_br_less(resultSltu), 
//  .o_br_equal(),
//  .o_br_greater()
//);
endmodule