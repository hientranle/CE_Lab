module imem #(
    parameter ADDR_WIDTH = 10,         // Address width, allowing 2^ADDR_WIDTH addresses
    parameter DATA_WIDTH = 32          // Data width for each instruction
)(
    input  logic [ADDR_WIDTH-1:0] addr,  // Address input
    output logic [DATA_WIDTH-1:0] inst   // Instruction output
);

    // ROM memory array with a depth of 2^ADDR_WIDTH
    logic [DATA_WIDTH-1:0] rom_memory [0:(1 << ADDR_WIDTH) - 1];

    // Asynchronous read for ROM
    assign inst = rom_memory[addr];

endmodule