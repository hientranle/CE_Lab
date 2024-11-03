module imem (
    input  logic [18:0] addr,
    input  logic        clk,
    output logic [31:0] inst
);

    logic [7:0] rom_memory [0:(2**20)-1]; 

    always_ff @(posedge clk) begin
        inst <= {rom_memory[addr+3], rom_memory[addr+2], rom_memory[addr+1], rom_memory[addr]};
    end

endmodule
