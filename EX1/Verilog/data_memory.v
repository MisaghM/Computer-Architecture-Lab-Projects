module DataMemory #(
    parameter WordLength = 8,
    parameter WordCount = $rtoi($pow(2, 32)),
    parameter BITS = $clog2(WordCount)
)(
    input clk, rst,
    input [BITS-1:0] memAdr, writeData,
    input memRead, memWrite,
    output reg [BITS-1:0] readData
);
    localparam RealWordCount = $rtoi($pow(2, 12)); // A 4KB memory is used instead of a 4GB one

    reg [WordLength-1:0] dataMem [0:RealWordCount-1];

    wire [BITS-1:0] adr;
    assign adr = {memAdr[BITS-1:2], 2'b00}; // To align the address to the word boundary

    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst)
            for (i = 0; i < RealWordCount; i = i + 1) begin
                dataMem[i] <= {(WordLength-1){1'b0}};
            end
        else if (memWrite)
            {dataMem[adr + 3], dataMem[adr + 2], dataMem[adr + 1], dataMem[adr]} <= writeData;
    end

    always @(memRead or adr) begin
        if (memRead)
            readData = {dataMem[adr + 3], dataMem[adr + 2], dataMem[adr + 1], dataMem[adr]};
    end
endmodule