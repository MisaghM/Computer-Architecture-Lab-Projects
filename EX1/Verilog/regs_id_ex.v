module RegsIdEx(
    input clk, rst,
    input [31:0] pcIn,
    output [31:0] pcOut
);
    Register #(32) pcReg(
        .clk(clk), .rst(rst),
        .in(pcIn), .ld(1'b1), .clr(1'b0),
        .out(pcOut)
    );
endmodule
