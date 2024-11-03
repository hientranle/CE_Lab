module ff_1bit (
    input  logic CK,     // Clock
    input  logic SD_N,   // Active low set
    input  logic RD_N,   // Active low reset
    input  logic D,      // Data input
    output logic Q       // Data output
);
    // Register behavior
    always_ff @(posedge CK or negedge SD_N or negedge RD_N) begin
        if (!SD_N)
            Q <= 1'b1;    // Set
        else if (!RD_N)
            Q <= 1'b0;    // Reset
        else
            Q <= D;       // Normal operation
    end
endmodule


module ff (
    input  logic CK,
    input  logic SD_N,
    input  logic RD_N,
    input  logic [31:0] D,
    output logic [31:0] Q
);

    genvar i;
    generate
        for (i = 0; i < 32; i++) begin: reg_gen
            ff_1bit ff_inst (
                .CK(CK),
                .SD_N(SD_N),
                .RD_N(RD_N),
                .D(D[i]),
                .Q(Q[i])
            );
        end
    endgenerate

endmodule
