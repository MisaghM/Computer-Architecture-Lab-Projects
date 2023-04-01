module RegsMemWb(
    input clk, rst,
    input wbEnIn, memREnIn,
    input [31:0] aluResIn, memDataIn,
    input [3:0] destIn,
    output wbEnOut, memREnOut,
    output [31:0] aluResOut, memDataOut,
    output [3:0] destOut
);
    Register #(1) wbEnReg(
        .clk(clk), .rst(rst),
        .in(wbEnIn), .ld(1'b1), .clr(1'b0),
        .out(wbEnOut)
    );

    Register #(1) memREnReg(
        .clk(clk), .rst(rst),
        .in(memREnIn), .ld(1'b1), .clr(1'b0),
        .out(memREnOut)
    );

    Register #(32) aluResReg(
        .clk(clk), .rst(rst),
        .in(aluResIn), .ld(1'b1), .clr(1'b0),
        .out(aluResOut)
    );

    Register #(32) memDataReg(
        .clk(clk), .rst(rst),
        .in(memDataIn), .ld(1'b1), .clr(1'b0),
        .out(memDataOut)
    );

    Register #(4) destReg(
        .clk(clk), .rst(rst),
        .in(destIn), .ld(1'b1), .clr(1'b0),
        .out(destOut)
    );
endmodule
