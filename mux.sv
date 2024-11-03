module mux2to1_1bit (
    input  logic i0,
    input  logic i1,
    input  logic sel,
    output logic out
);

    logic n_sel;
    logic and0;
    logic and1;

    assign n_sel = ~sel;

    assign and0 = i0 & n_sel;
    assign and1 = i1 & sel;

    assign out = and0 | and1;
endmodule

module mux2to1 (
    input  logic [31:0] i0,
    input  logic [31:0] i1,
    input  logic sel,
    output logic [31:0] out
);

    genvar i;
    generate
        for (i = 0; i < 32; i++) begin: mux_gen
            mux2to1_1bit mux_inst (
                .i0(i0[i]),
                .i1(i1[i]),
                .sel(sel),
                .out(out[i])
            );
        end
    endgenerate
endmodule

module mux4to1_1bit (
    input  logic i0,
    input  logic i1,
    input  logic i2,
    input  logic i3,
    input  logic [1:0] sel,
    output logic out
);

    logic mux0_out, mux1_out;

    mux2to1_1bit mux0 (
        .i0(i0),
        .i1(i1),
        .sel(sel[0]),
        .out(mux0_out)
    );

    mux2to1_1bit mux1 (
        .i0(i2),
        .i1(i3),
        .sel(sel[0]),
        .out(mux1_out)
    );

    mux2to1_1bit mux2 (
        .i0(mux0_out),
        .i1(mux1_out),
        .sel(sel[1]),
        .out(out)
    );

endmodule

module mux4to1 (
    input  logic [31:0] i0,
    input  logic [31:0] i1,
    input  logic [31:0] i2,
    input  logic [31:0] i3,
    input  logic [1:0] sel,
    output logic [31:0] out
);

    genvar i;
    generate
        for (i = 0; i < 32; i++) begin: mux_gen
            mux4to1_1bit mux_inst (
                .i0(i0[i]),
                .i1(i1[i]),
                .i2(i2[i]),
                .i3(i3[i]),
                .sel(sel),
                .out(out[i])
            );
        end
    endgenerate
endmodule
