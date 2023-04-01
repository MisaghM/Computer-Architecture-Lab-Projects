module RegsMemWb(
    input clk, rst,
    input wbEnIn, memREnIn,
    input [31:0] aluRes, memData,
    input [3:0] destIn,
    output wbEnOut, memREnOut,
    output [31:0] wbData,
    output [3:0] destOut
);
    Mux2To1 #(32) wbMux(
        .a0(aluRes),
        .a1(memData),
        .sel(memREnIn),
        .out(wbData)
    );
endmodule
