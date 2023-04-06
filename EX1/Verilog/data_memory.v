module DataMemory(
    input clk, rst,
    input [31:0] memAdr, writeData,
    input memRead, memWrite,
    output reg [31:0] readData
);
    localparam WordCount = 4096;

    reg [7:0] dataMem [0:WordCount-1]; // 4KB memory

    wire [31:0] adr;
    assign adr = {memAdr[31:2], 2'b00}; // Align address to the word boundary

    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst)
            for (i = 0; i < WordCount; i = i + 1) begin
                dataMem[i] <= 8'd0;
            end
        else if (memWrite)
            {dataMem[adr + 3], dataMem[adr + 2], dataMem[adr + 1], dataMem[adr]} <= writeData;
    end

    always @(memRead or adr) begin
        if (memRead)
            readData = {dataMem[adr + 3], dataMem[adr + 2], dataMem[adr + 1], dataMem[adr]};
    end
endmodule
