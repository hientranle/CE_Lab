import control_types::*;
module singlecycle (
     input logic i_clk,								// Global clock, active on the rising edge
     input logic i_rst_n,							// Global low active reset
     input  logic [31:0] i_io_sw,				// Input for switches
     input  logic [3:0]  i_io_btn,				// Input for buttons
	  output logic [31:0] o_pc_debug,			// Debug program counter
     output logic        o_insn_vld,			// Instruction valid
     output logic [31:0] o_io_ledr,				// Output for driving red LEDs
     output logic [31:0] o_io_ledg,				// Output for driving green LEDs
     output logic [6:0]  o_io_hex0_7,			// Output for driving 7-segment LED displays
     output logic [31:0] o_io_lcd				// Output for driving the LCD register
);
     // Wire declaration
	  wire [31:0] pc_current;
	  wire [31:0] pc_next;
	  wire [31:0] inst;
	  wire [31:0] pc_four;
	  wire [31:0] alu_out;
	  wire [31:0] wb_data;
	  wire [31:0] rs1_data;
	  wire [31:0] rs2_data;
	  wire [31:0] imm_gen_out;
	  wire [31:0] alu_in1, alu_in2;
	  wire [31:0] ld_data;
	  pc_ctrl pc_sel;
	  reg_en reg_wen;
	  imm_ctrl imm_sel;
	  wire br_eq;
	  wire br_lt;
	  wire inst_vld;
	  operand a_sel, b_sel;
	  alu_ctrl alu_sel;
	  mem_op mem_rw;
	  sign_comp br_un;
	  wb_ctrl wb_sel;
	  
     // Module implementation
	  
	  // IF
	  mux2to1 pc_mux (
	      .i0(pc_four),
			.i1(alu_out),
			.sel(pc_sel),
			.out(pc_next)
	  );
	  
	  pc pc (
	      .clk(i_clk),
		   .rst_n(i_rst_n),
		   .pc_in(pc_next),
			.pc_out(pc_current)
	  );
	  
	  add_four add_four (
	      .pc_in(pc_current),
	      .pc_out(pc_four)
	  );
	  
	  imem imem (
	      .addr(pc_current),
			.inst(inst)
	  );

	  // ID
	  reg_file reg_file(
	      .clk(i_clk),
			.rstn(i_rst_n),
			.reg_wen(reg_wen),
			.rd_addr(inst[11:7]),
			.rd_data(wb_data),
			.rs1_addr(inst[19:15]),
			.rs2_addr(inst[19:15]),
			.rs1_data(rs1_data),
			.rs2_data(rs2_data)
	  );
	  
	  imm_gen imm_gen (
	      .in(inst[31:7]),
			.imm_sel(imm_sel),
			.out(imm_gen_out)
	  );
	  
	  control_unit control_unit (
	      .opcode(inst[6:2]),
			.inst({inst[30], inst[14:12]}),
			.br_eq(br_eq),
			.br_lt(br_lt),
			.pc_sel(pc_sel),
			.imm_sel(imm_sel),
			.a_sel(a_sel),
			.b_sel(b_sel),
			.alu_sel(alu_sel),
			.mem_rw(mem_rw),
			.reg_wen(reg_wen),
			.wb_sel(wb_sel),
			.br_un(br_un),
			.inst_vld(inst_vld)
	  );
	  
	  // EX
	  comparator comparator (
	      .i_rs1_data(rs1_data),
			.i_rs2_data(rs2_data),
			.i_br_un(br_un),
			.o_br_less(br_lt),
			.o_br_equal(br_eq)
	  );
	  
	  mux2to1 a_mux(
	      .i0(rs1_data),
			.i1(pc_current),
			.sel(a_sel),
			.out(alu_in1)	      
	  );
	  
	  mux2to1 b_mux(
	      .i0(rs2_data),
			.i1(imm_gen_out),
			.sel(b_sel),
			.out(alu_in2)	      
	  );
	  
	  alu alu (
	      .i_op_a(alu_in1),
			.i_op_b(alu_in2),
			.i_alu_op(alu_sel),
			.i_br_lt(br_lt),
			.o_alu_data(alu_out)
	  );
	  
	  // MEM
	  
	  // WB
	  mux4to1 wb_mux (
	      .i0(pc_four),
			.i1(alu_out),
			.i2(ld_data),
			.sel(wb_sel),
			.out(wb_data)
	  );
endmodule