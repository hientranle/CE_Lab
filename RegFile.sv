module RegFile #(
) (
    input logic clk,
    input logic rstn,
    input logic WriteEn,

    input logic [31:0] WData,
    input logic [5:0]  RsW,
    input logic [5:0]  Rs1,
    input logic [5:0]  Rs2

    output logic [31:0] DataR1,
    output logic [31:0] DataR2
);
   logic [31:0][31:0] RegisterR; 
   always_ff @ (posedge clk or negedge rstn) begin
    if (!rstn) begin
      RegisterR <= '0;
    end
    else begin
      if (WriteEn)
        if (RsW == 5'h0) begin
          RegisterR[0] <= 32'h0;
        end
        else begin
          RegisterR[RsW] <= WData;
        end
      else begin
        RegisterR <= RegisterR;      
      end
    end
   end
   always_comb begin
     DataR1 = RegisterR[Rs1];
     DataR2 = RegisterR[Rs2];
   end
endmodule