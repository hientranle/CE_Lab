module ff_1bit (
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
