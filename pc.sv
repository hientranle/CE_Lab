module pc (
    input  logic [31:0] pc_in,
    input  logic        rst_n,
    input  logic        clk,
    output logic [31:0] pc_out
);

    genvar i;
    generate
        for (i = 0; i < 32; i++) begin : gen_ff
            ff u_ff (
                .CK(clk),
                .SD_N(1'b1),
                .RD_N(rst_n),
                .D(pc_in[i]),
                .Q(pc_out[i])
            );
        end
    endgenerate

endmodule