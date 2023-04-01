module RegsExMem(
    input clk, rst,
    input wbEnIn, memREnIn, memWEnIn,
    input [31:0] aluResIn, valRmIn,
    input [3:0] destIn,
    output wbEnOut, memREnOut, memWEnOut,
    output [31:0] aluResOut, valRmOut,
    output [3:0] destOut
);
    Register #(1) wbEn(
        .clk(clk),
        .rst(rst),
        .in(wbEnIn),
        .ld(1'b1),
        .clr(1'b0),
        .out(wbEnOut)
    );
    Register #(1) memREn(
        .clk(clk),
        .rst(rst),
        .in(memREnIn),
        .ld(1'b1),
        .clr(1'b0),
        .out(memREnOut)
    );
    Register #(1) memWEn(
        .clk(clk),
        .rst(rst),
        .in(memWEnIn),
        .ld(1'b1),
        .clr(1'b0),
        .out(memWEnOut)
    );
    Register #(32) aluRes(
        .clk(clk),
        .rst(rst),
        .in(aluResIn),
        .ld(1'b1),
        .clr(1'b0),
        .out(aluResOut)
    );
    Register #(32) valRm(
        .clk(clk),
        .rst(rst),
        .in(valRmIn),
        .ld(1'b1),
        .clr(1'b0),
        .out(valRmOut)
    );
    Register #(4) dest(
        .clk(clk),
        .rst(rst),
        .in(destIn),
        .ld(1'b1),
        .clr(1'b0),
        .out(destOut)
    );
endmodule
