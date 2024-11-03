module reg_file (
    input logic clk,
    input logic rstn,
    input logic reg_wen,

    input logic [31:0] rd_data,
    input logic [5:0]  rd_addr,
    input logic [5:0]  rs1_addr,
    input logic [5:0]  rs2_addr,

    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data
);
   logic [31:0][31:0] RegisterR; 
   always_ff @ (posedge clk or negedge rstn) begin
    if (!rstn) begin
      RegisterR <= '0;
    end
    else begin
      if (reg_wen)
        if (rd_addr == 5'h0) begin
          RegisterR[0] <= 32'h0;
        end
        else begin
          RegisterR[rd_addr] <= rd_data;
        end
      else begin
        RegisterR <= RegisterR;      
      end
    end
   end
   always_comb begin
     rs1_data = RegisterR[rs1_addr];
     rs2_data = RegisterR[rs2_addr];
   end
endmodule