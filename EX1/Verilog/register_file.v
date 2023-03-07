module RegisterFile #(
    parameter WordLen = 32,
    parameter WordCount = 16
)(
    input clk, rst,
    input [Bits-1:0] readRegister1, readRegister2, writeRegister,
    input [WordLen-1:0] writeData,
    input regWrite, sclr,
    output [WordLen-1:0] readData1, readData2
);
    localparam Bits = $clog2(WordCount);
    reg [WordLen-1:0] regFile [0:WordCount-1];

    assign readData1 = regFile[readRegister1];
    assign readData2 = regFile[readRegister2];

    integer i;

    initial begin
        for (i = 0; i < WordCount; i = i + 1)
            regFile[i] <= i;
    end

    always @(negedge clk or posedge rst) begin
        if (rst)
            for (i = 0; i < WordCount; i = i + 1)
                regFile[i] <= i;
        else if (sclr)
            regFile[writeRegister] <= {WordLen{1'b0}};
        else if (regWrite)
            regFile[writeRegister] <= writeData;
    end
endmodule
