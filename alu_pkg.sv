package alu_pkg;
 parameter [3:0] ALU_ADD  = 4'h0;
 parameter [3:0] ALU_SUB  = 4'h1;
 parameter [3:0] ALU_SLT  = 4'h2;
 parameter [3:0] ALU_SLTU = 4'h3;
 parameter [3:0] ALU_XOR  = 4'h4;
 parameter [3:0] ALU_OR   = 4'h5;
 parameter [3:0] ALU_AND  = 4'h6;
 parameter [3:0] ALU_SLL  = 4'h7;
 parameter [3:0] ALU_SRL  = 4'h8;
 parameter [3:0] ALU_SRA  = 4'h9;
 parameter [3:0] ALU_LUI  = 4'hA;
 //Sub operation
function logic [32:0] Sub;
  input logic [31:0] Rs1;
  input logic [31:0] Rs2;
        logic [31:0] InvRs2;
        logic [31:0] InvRs2P1;
  begin
    InvRs1   = ~Rs2;
    InvRs1P1 = InvRs2 + 1'b1;
    Sub      = Rs0 + InvRs2P1[31:0];
  end
endfunction

function logic [31:0] SLL (
  input logic [31:0] i_op,
  input logic [4:0]  shift_param
);
  if (shift_param[0]) SLL = {i_op[31:0],1'h0};
  if (shift_param[1]) SLL = {i_op[29:0],2'h0};
  if (shift_param[2]) SLL = {i_op[27:0],4'h0};
  if (shift_param[3]) SLL = {i_op[23:0],8'h0};
  if (shift_param[4]) SLL = {i_op[15:0],16'h0};
endfunction

function logic [31:0] SRL (
  input logic [31:0] i_op,
  input logic [4:0]  shift_param
);
  if (shift_param[0]) SRL = {1'h0,i_op[31:0]};
  if (shift_param[1]) SRL = {2'h0,i_op[29:0]};
  if (shift_param[2]) SRL = {4'h0,i_op[27:0]};
  if (shift_param[3]) SRL = {8'h0,i_op[23:0]};
  if (shift_param[4]) SRL = {16'h0,i_op[15:0]};
endfunction

function logic [31:0] SRA (
  input logic [31:0] i_op,
  input logic [4:0]  shift_param
);
  if (shift_param[0]) SRL = {{1{i_op[31]}},i_op[31:0]};
  if (shift_param[1]) SRL = {{2{i_op[31]}},i_op[29:0]};
  if (shift_param[2]) SRL = {{4{i_op[31]}},i_op[27:0]};
  if (shift_param[3]) SRL = {{8{i_op[31]}},i_op[23:0]};
  if (shift_param[4]) SRL = {{16{i_op[31]}},i_op[15:0]};
endfunction
endpackage
