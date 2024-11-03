package control_types;
    typedef enum logic {
        REG = 1'b0,
		  OTHER_OPERAND = 1'b1
	 } operand;
	 
	 typedef enum logic {
	     ALU_OUT = 1'b1,
		  PC_FOUR = 1'b0
	 } pc_ctrl;
	 
	 typedef enum logic [3:0] {
	     ADD = 4'h0,
        SUB = 4'h1,
		  SLT = 4'h2,
		  L_XOR = 4'h4,
		  L_OR = 4'h5,
        L_AND = 4'h6,
        SLL = 4'h7,
        SRL = 4'h8,
        SRA = 4'h9,
		  LUI = 4'hA
	 } alu_ctrl;
	 
	 typedef enum logic [1:0]{
        PC,
        ALU,
        LD_DATA
	 } wb_ctrl;
	 
	 typedef enum logic [2:0] {
	     SE20_UI,
        SE12_LI,
        SE12_BR,
        SE12_ST,
        SE20_JP,
		  OTHER_IMM_CTRL
	 } imm_ctrl;
	 
	typedef enum logic {
		  READ = 1'b0,
		  WRITE = 1'b1		  
	} mem_op;
	
	typedef enum logic {
	     ENABLE = 1'b1,
		  DISABLE = 1'b0
	} reg_en;
	
	typedef enum logic {
	     SIGN = 1'b0,
		  UNSIGN = 1'b1
	} sign_comp;
endpackage

import control_types::*;

`define R_TYPE      5'b01100  // R-type (e.g., ADD, SUB, AND, OR, etc.)
`define I_TYPE      5'b00100  // I-type (e.g., ADDI, SLLI, SRLI, etc.)
`define LOAD        5'b00000  // Load instructions (e.g., LB, LH, LW, etc.)
`define STORE       5'b01000  // Store instructions (e.g., SB, SH, SW, etc.)
`define BRANCH      5'b11000  // Branch instructions (e.g., BEQ, BNE, etc.)
`define JAL         5'b11011  // JAL (Jump and Link)
`define JALR        5'b11001  // JALR (Jump and Link Register)
`define LUI         5'b01101  // LUI (Load Upper Immediate)
`define AUIPC       5'b00101  // AUIPC (Add Upper Immediate to PC)

module control_unit (
    input  logic [4:0]   opcode,      // 5-bit opcode input
	 input  logic [3:0]   inst,        // 4-bit instruction  
    input  logic         br_eq,        // Branch Equal flag
    input  logic         br_lt,        // Branch Less Than flag
//	 input  logic         data_vld,     // Valid load data
    output pc_ctrl       pc_sel,       // Program Counter Select
    output imm_ctrl      imm_sel,      // Immediate Select
    output operand       a_sel,        // A input Select
    output operand       b_sel,        // B input Select
    output alu_ctrl      alu_sel,      // ALU operation Select
    output mem_op        mem_rw,       // Memory Read/Write
    output reg_en        reg_wen,      // Register Write Enable
    output wb_ctrl       wb_sel,        // Write Back Select
	 output sign_comp     br_un,         // Unsigned compare 
	 output logic         inst_vld       // Instruction valid
);

    always_comb begin
	     case (opcode)
		      `R_TYPE: begin
				    case (inst[2:0])
					     3'b000: begin
				            imm_sel = OTHER_IMM_CTRL;
					         a_sel = REG;
					         b_sel = REG;
								if (inst[3]) begin
								    alu_sel = SUB;
								end else begin
								    alu_sel = ADD;
								end
								mem_rw = READ;		// Not use Memory so set to READ to not change the value
								reg_wen = ENABLE;
								wb_sel = ALU;
								pc_sel = PC_FOUR;
								br_un = SIGN;
								inst_vld = 1'b1;
						  end
						  3'b001: begin
						      imm_sel = OTHER_IMM_CTRL;
					         a_sel = REG;
					         b_sel = REG;
								alu_sel = SLL;
								mem_rw = READ;		// Not use Memory so set to READ to not change the value
								reg_wen = ENABLE;
								wb_sel = ALU;
								pc_sel = PC_FOUR;
								br_un = SIGN;
								inst_vld = 1'b1;
						  end
						  3'b010: begin
						      imm_sel = OTHER_IMM_CTRL;
					         a_sel = REG;
					         b_sel = REG;
								alu_sel = SLT;
								mem_rw = READ;		// Not use Memory so set to READ to not change the value
								reg_wen = ENABLE;
								wb_sel = ALU;
								pc_sel = PC_FOUR;
								br_un = SIGN;
								inst_vld = 1'b1;
						  end
						  3'b011: begin
						      imm_sel = OTHER_IMM_CTRL;
					         a_sel = REG;
					         b_sel = REG;
								alu_sel = SLT;
								mem_rw = READ;		// Not use Memory so set to READ to not change the value
								reg_wen = ENABLE;
								wb_sel = ALU;
								pc_sel = PC_FOUR;
								br_un = SIGN;
								inst_vld = 1'b1;
						  end
						  3'b100: begin
						      imm_sel = OTHER_IMM_CTRL;
					         a_sel = REG;
					         b_sel = REG;
								alu_sel = L_XOR;
								mem_rw = READ;		// Not use Memory so set to READ to not change the value
								reg_wen = ENABLE;
								wb_sel = ALU;
								pc_sel = PC_FOUR;
								br_un = SIGN;
								inst_vld = 1'b1;
						  end
						  3'b101: begin
						      imm_sel = OTHER_IMM_CTRL;
					         a_sel = REG;
					         b_sel = REG;
								if (inst[3]) begin
								    alu_sel = SRA;
								end else begin
								    alu_sel = SRL;
								end
								mem_rw = READ;		// Not use Memory so set to READ to not change the value
								reg_wen = ENABLE;
								wb_sel = ALU;
								pc_sel = PC_FOUR;
								br_un = SIGN;
								inst_vld = 1'b1;
						  end
						  3'b110: begin
						      imm_sel = OTHER_IMM_CTRL;
					         a_sel = REG;
					         b_sel = REG;
                        alu_sel = L_OR;
								mem_rw = READ;		// Not use Memory so set to READ to not change the value
								reg_wen = ENABLE;
								wb_sel = ALU;
								pc_sel = PC_FOUR;
								br_un = SIGN;
								inst_vld = 1'b1;
						  end
						  3'b111: begin
						      imm_sel = OTHER_IMM_CTRL;
					         a_sel = REG;
					         b_sel = REG;
                        alu_sel = L_AND;
								mem_rw = READ;		// Not use Memory so set to READ to not change the value
								reg_wen = ENABLE;
								wb_sel = ALU;
								pc_sel = PC_FOUR;
								br_un = SIGN;
								inst_vld = 1'b1;
						  end
					 endcase
				end
				`I_TYPE: begin
				    case (inst[2:0])
					     3'b000: begin
						      imm_sel = SE12_LI;
					         a_sel = REG;
					         b_sel = OTHER_OPERAND;
								alu_sel = ADD;
								mem_rw = READ;		// Not use Memory so set to READ to not change the value
								reg_wen = ENABLE;
								wb_sel = ALU;
								pc_sel = PC_FOUR;
								br_un = SIGN;
								inst_vld = 1'b1;
						  end
						  3'b010: begin
						      imm_sel = SE12_LI;
					         a_sel = REG;
					         b_sel = OTHER_OPERAND;
								alu_sel = SLT;
								mem_rw = READ;		// Not use Memory so set to READ to not change the value
								reg_wen = ENABLE;
								wb_sel = ALU;
								pc_sel = PC_FOUR;
								br_un = SIGN;
								inst_vld = 1'b1;
						  end
						  3'b011: begin
						      imm_sel = SE12_LI;
					         a_sel = REG;
					         b_sel = OTHER_OPERAND;
								alu_sel = SLT;
								mem_rw = READ;		// Not use Memory so set to READ to not change the value
								reg_wen = ENABLE;
								wb_sel = ALU;
								pc_sel = PC_FOUR;
								br_un = SIGN;
								inst_vld = 1'b1;
						  end
						  3'b100: begin
						      imm_sel = SE12_LI;
					         a_sel = REG;
					         b_sel = OTHER_OPERAND;
								alu_sel = L_XOR;
								mem_rw = READ;		// Not use Memory so set to READ to not change the value
								reg_wen = ENABLE;
								wb_sel = ALU;
								pc_sel = PC_FOUR;
								br_un = SIGN;
								inst_vld = 1'b1;
						  end
						  3'b110: begin
						      imm_sel = SE12_LI;
					         a_sel = REG;
					         b_sel = OTHER_OPERAND;
								alu_sel = L_OR;
								mem_rw = READ;		// Not use Memory so set to READ to not change the value
								reg_wen = ENABLE;
								wb_sel = ALU;
								pc_sel = PC_FOUR;
								br_un = SIGN;
								inst_vld = 1'b1;
						  end
						  3'b111: begin
						      imm_sel = SE12_LI;
					         a_sel = REG;
					         b_sel = OTHER_OPERAND;
								alu_sel = L_AND;
								mem_rw = READ;		// Not use Memory so set to READ to not change the value
								reg_wen = ENABLE;
								wb_sel = ALU;
								pc_sel = PC_FOUR;
								br_un = SIGN;
								inst_vld = 1'b1;
						  end
						  3'b001: begin
						      imm_sel = SE12_LI;
								a_sel = REG;
								b_sel = OTHER_OPERAND;
								alu_sel = SLL;
								mem_rw = READ;		// Not use Memory so set to READ to not change the value
								reg_wen = ENABLE;
								wb_sel = ALU;
								pc_sel = PC_FOUR;
								br_un = SIGN;
								inst_vld = 1'b1;
						  end
						  3'b101: begin
						      imm_sel = SE12_LI;
								a_sel = REG;
								b_sel = OTHER_OPERAND;
								if (inst[3]) begin
								    alu_sel = SRA;
								end else begin
								    alu_sel = SRL;
								end
								mem_rw = READ;		// Not use Memory so set to READ to not change the value
								reg_wen = ENABLE;
								wb_sel = ALU;
								pc_sel = PC_FOUR;
								br_un = SIGN;
								inst_vld = 1'b1;
						  end
					 endcase	 
				end
				`STORE: begin
				    imm_sel = SE12_ST;
					 a_sel = REG;
			       b_sel = OTHER_OPERAND;
				    alu_sel = ADD;
			       mem_rw = WRITE;
			       reg_wen = DISABLE;
   		       wb_sel = ALU;
					 pc_sel = PC_FOUR;
					 br_un = SIGN;
				    inst_vld = 1'b1;
				end
				`BRANCH: begin
				    case (inst[2:0])
					     3'b000: begin						// BEQ
					         imm_sel = SE12_BR;
					         a_sel = OTHER_OPERAND;
					         b_sel = OTHER_OPERAND;
					         alu_sel = ADD;
					         mem_rw = READ;
					         reg_wen = DISABLE;
					         wb_sel = ALU;
								if (br_eq) begin				// Equal => Branch taken
								    pc_sel = ALU_OUT;
								end else begin					// Not equal => Branch NOT taken
								    pc_sel = PC_FOUR;
								end
								br_un = SIGN;
					         inst_vld = 1'b1;
						  end
						  3'b001: begin						// BNE
					         imm_sel = SE12_BR;
					         a_sel = OTHER_OPERAND;
					         b_sel = OTHER_OPERAND;
					         alu_sel = ADD;
					         mem_rw = READ;
					         reg_wen = DISABLE;
					         wb_sel = ALU;
								if (br_eq) begin				// Equal => Branch NOT taken
								    pc_sel = PC_FOUR;
								end else begin					// Not equal => Branch taken
								    pc_sel = ALU_OUT;
								end
								br_un = SIGN;
					         inst_vld = 1'b1;
						  end
						  3'b100: begin						// BLT
					         imm_sel = SE12_BR;
					         a_sel = OTHER_OPERAND;
					         b_sel = OTHER_OPERAND;
					         alu_sel = ADD;
					         mem_rw = READ;
					         reg_wen = DISABLE;
					         wb_sel = ALU;
								if (br_lt) begin				// Less than => Branch taken
								    pc_sel = ALU_OUT;
								end else begin					// Greater => Branch NOT taken
								    pc_sel = PC_FOUR;
								end
								br_un = SIGN;
					         inst_vld = 1'b1;
						  end
						  3'b101: begin						// BGE
					         imm_sel = SE12_BR;
					         a_sel = OTHER_OPERAND;
					         b_sel = OTHER_OPERAND;
					         alu_sel = ADD;
					         mem_rw = READ;
					         reg_wen = DISABLE;
					         wb_sel = ALU;
								if (br_lt) begin				// Less than => Branch NOT taken
								    pc_sel = PC_FOUR;
								end else begin					// Greater => Branch taken
								    pc_sel = ALU_OUT;
								end
								br_un = SIGN;
					         inst_vld = 1'b1;
						  end
						  3'b110: begin						// BLTU
					         imm_sel = SE12_BR;
					         a_sel = OTHER_OPERAND;
					         b_sel = OTHER_OPERAND;
					         alu_sel = ADD;
					         mem_rw = READ;
					         reg_wen = DISABLE;
					         wb_sel = ALU;
								if (br_lt) begin				// Less than => Branch taken
								    pc_sel = ALU_OUT;
								end else begin					// Greater => Branch NOT taken
								    pc_sel = PC_FOUR;
								end
								br_un = UNSIGN;
					         inst_vld = 1'b1;
						  end
						  3'b111: begin						// BGEU
					         imm_sel = SE12_BR;
					         a_sel = OTHER_OPERAND;
					         b_sel = OTHER_OPERAND;
					         alu_sel = ADD;
					         mem_rw = READ;
					         reg_wen = DISABLE;
					         wb_sel = ALU;
								if (br_lt) begin				// Less than => Branch NOT taken
								    pc_sel = PC_FOUR;
								end else begin					// Greater => Branch taken
								    pc_sel = ALU_OUT;
								end
								br_un = SIGN;
					         inst_vld = 1'b1;
						  end
						  default: begin
						      imm_sel = SE12_BR;
					         a_sel = OTHER_OPERAND;
					         b_sel = OTHER_OPERAND;
					         alu_sel = ADD;
					         mem_rw = READ;
					         reg_wen = DISABLE;
					         wb_sel = ALU;
								pc_sel = PC_FOUR;
								br_un = SIGN;
					         inst_vld = 1'b0;
						  end
					 endcase
				end
				`JAL: begin
				    imm_sel = SE20_JP;
				    a_sel = OTHER_OPERAND;
				    b_sel = OTHER_OPERAND;
				    alu_sel = ADD;
				    mem_rw = READ;
					 reg_wen = ENABLE;
					 wb_sel = PC;
					 pc_sel = ALU_OUT;
					 br_un = UNSIGN;
					 inst_vld = 1'b1;
				end
				`JALR: begin
				    imm_sel = SE12_LI;
					 a_sel = REG;
					 b_sel = OTHER_OPERAND;
					 alu_sel = ADD;
					 mem_rw = READ;
					 reg_wen = ENABLE;
					 wb_sel = PC;
					 pc_sel = ALU_OUT;
					 br_un = UNSIGN;
					 inst_vld = 1'b1;
				end
				`LUI: begin
				    imm_sel = SE20_UI;
					 a_sel = REG;
					 b_sel = OTHER_OPERAND;
					 alu_sel = LUI;
					 mem_rw = READ;
					 reg_wen = ENABLE;
					 wb_sel = ALU;
					 pc_sel = PC_FOUR;
					 br_un = UNSIGN;
					 inst_vld = 1'b1;
				end
				`AUIPC: begin
				    imm_sel = SE20_UI;
					 a_sel = OTHER_OPERAND;
					 b_sel = OTHER_OPERAND;
					 alu_sel = ADD;
					 mem_rw = READ;
					 reg_wen = ENABLE;
					 wb_sel = ALU;
					 pc_sel = PC_FOUR;
					 br_un = UNSIGN;
					 inst_vld = 1'b1;
				end
				`LOAD: begin
				    imm_sel = SE12_LI;
				    a_sel = REG;
				    b_sel = OTHER_OPERAND;
				    alu_sel = ADD;
				    mem_rw = READ;
				    reg_wen = ENABLE;
				    wb_sel = LD_DATA;
				    pc_sel = PC_FOUR;
				    br_un = UNSIGN;
				    inst_vld = 1'b1;
				end
				default: begin
				    imm_sel = OTHER_IMM_CTRL;
				    a_sel = REG;
				    b_sel = REG;
				    alu_sel = ADD;
				    mem_rw = READ;
				    reg_wen = DISABLE;
				    wb_sel = ALU;
				    pc_sel = PC_FOUR;
				    br_un = UNSIGN;
				    inst_vld = 1'b0;
				end
		  endcase
	 end
endmodule
