module RegsIfId(
    input clk, rst,
    input freeze, flush,
    input [31:0] pcIn, instructionIn,
    output [31:0] pcOut, instructionOut
);
    Register #(32) pcReg(
        .clk(clk), .rst(rst | flush),
        .in(pcIn), .ld(~freeze), .clr(1'b0),
        .out(pcOut)
    );
endmodule
