module SramController(
    input clk, rst,
    input wrEn, rdEn,
    input [31:0] address,
    input [31:0] writeData,
    output reg [31:0] readData,
    output reg ready,            // to freeze other stages

    inout [15:0] SRAM_DQ,        // SRAM Data bus 16 bits
    output reg [17:0] SRAM_ADDR, // SRAM Address bus 18 bits
    output SRAM_UB_N,            // SRAM High-byte data mask
    output SRAM_LB_N,            // SRAM Low-byte data mask
    output reg SRAM_WE_N,        // SRAM Write enable
    output SRAM_CE_N,            // SRAM Chip enable
    output SRAM_OE_N             // SRAM Output enable
);
    wire [31:0] memAddr;
    assign memAddr = address - 32'd1024;
    wire [17:0] sramLowAddr, sramHighAddr;
    assign sramLowAddr = memAddr[18:1];
    assign sramHighAddr = sramLowAddr + 18'd1;

    assign {SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N} = 4'b0000;

    reg [15:0] dq;
    assign SRAM_DQ = SRAM_WE_N ? 16'bz : dq;

    localparam Idle = 3'd0, DataLow = 3'd1, DataHigh = 3'd2, Finish = 3'd3, NoOp = 3'd4, Done = 3'd5;
    reg [2:0] cycleCount = Idle;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ready <= 1'b1;
            readData <= 32'd0;
            SRAM_ADDR <= 18'b0;
            SRAM_WE_N <= 1'b1;
            cycleCount <= Idle;
        end
        else if (wrEn == 1'b1 || rdEn == 1'b1) begin
            case (cycleCount)
                Idle: ready <= 1'b0;
                DataLow: begin
                    SRAM_ADDR <= sramLowAddr;
                    SRAM_WE_N <= !wrEn;
                    dq <= writeData[15:0];
                end
                DataHigh: begin
                    SRAM_ADDR <= sramHighAddr;
                    SRAM_WE_N <= !wrEn;
                    dq <= writeData[31:0];
                    if (rdEn)
                        readData[15:0] <= SRAM_DQ;
                end
                Finish: begin
                    SRAM_WE_N = 1'b1;
                    if (rdEn)
                        readData[31:0] <= SRAM_DQ;
                end
                NoOp:;
                Done:;
                default: ready <= 1'b1;
            endcase

            cycleCount <= (cycleCount == Done ? Idle : cycleCount + 3'd1);
        end
    end
endmodule
