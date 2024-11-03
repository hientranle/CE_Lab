module add_four (
    input  logic [31:0] pc_in,
    output logic [31:0] pc_out
);

    assign pc_out = pc_in + 32'h4;

endmodule
