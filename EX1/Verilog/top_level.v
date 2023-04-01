module TopLevel(
    input clk, rst
);
    wire branchTaken;
    wire [31:0] branchAddr;
    wire hazard, hazardTwoSrc;
    wire [3:0] hazardRn;
    assign {branchTaken, hazard} = 2'b00;
    // assign branchTaken = branchOutIdEx;
    assign branchAddr = 32'd0;

    wire [3:0] status; // N Z C V
    wire carryIn;
    assign status = 4'd0;
    assign carryIn = status[1];

    wire [31:0] instOutIf, instOutIfId;
    wire [31:0] pcOutIfId, pcOutIdEx, pcOutExMem, pcOutMemWb;
    wire [31:0] pcOutIf, pcOutId, pcOutEx, pcOutMem, pcOutWb;

    wire [3:0] aluCmdOutId;
    wire memReadOutId, memWriteOutId, wbEnOutId, branchOutId, sOutId;
    wire [31:0] reg1OutId, reg2OutId;
    wire immOutId;
    wire [11:0] shiftOperandOutId;
    wire [23:0] imm24OutId;
    wire [3:0] destOutId;

    wire [3:0] aluCmdOutIdEx;
    wire memReadOutIdEx, memWriteOutIdEx, wbEnOutIdEx, branchOutIdEx, sOutIdEx;
    wire [31:0] reg1OutIdEx, reg2OutIdEx;
    wire immOutIdEx;
    wire [11:0] shiftOperandOutIdEx;
    wire [23:0] imm24OutIdEx;
    wire [3:0] destOutIdEx;
    wire carryOut;

    wire wbEn;
    wire [31:0] wbValue;
    wire [3:0] wbDest;
    assign wbEn = 1'b0;
    assign wbValue = 32'd0;
    assign wbDest = 4'd0;

    StageIf stIf(
        .clk(clk), .rst(rst),
        .branchTaken(branchTaken), .freeze(hazard),
        .branchAddr(branchAddr),
        .pc(pcOutIf), .instruction(instOutIf)
    );
    RegsIfId regsIf(
        .clk(clk), .rst(rst),
        .freeze(hazard), .flush(branchTaken),
        .pcIn(pcOutIf), .instructionIn(instOutIf),
        .pcOut(pcOutIfId), .instructionOut(instOutIfId)
    );

    StageId stId(
        .clk(clk), .rst(rst),
        .pcIn(pcOutIfId), .inst(instOutIfId),
        .status(status),
        .wbWbEn(wbEn), .wbValue(wbValue), .wbDest(wbDest),
        .hazard(hazard),
        .pcOut(pcOutId),
        .aluCmd(aluCmdOutId), .memRead(memReadOutId), .memWrite(memWriteOutId),
        .wbEn(wbEnOutId), .branch(branchOutId), .s(sOutId),
        .reg1(reg1OutId), .reg2(reg2OutId),
        .imm(immOutId), .shiftOperand(shiftOperandOutId), .imm24(imm24OutId), .dest(destOutId),
        .hazardRn(hazardRn), .hazardTwoSrc(hazardTwoSrc)
    );
    RegsIdEx regsId(
        .clk(clk), .rst(rst),
        .pcIn(pcOutId),
        .aluCmdIn(aluCmdOutId), .memReadIn(memReadOutId), .memWriteIn(memWriteOutId),
        .wbEnIn(wbEnOutId), .branchIn(branchOutId), .sIn(sOutId),
        .reg1In(reg1OutId), .reg2In(reg2OutId),
        .immIn(immOutId), .shiftOperandIn(shiftOperandOutId), .imm24In(imm24OutId), .destIn(destOutId),
        .carryIn(carryIn), .flush(branchTaken),
        .pcOut(pcOutIdEx),
        .aluCmdOut(aluCmdOutIdEx), .memReadOut(memReadOutIdEx), .memWriteOut(memWriteOutIdEx),
        .wbEnOut(wbEnOutIdEx), .branchOut(branchOutIdEx), .sOut(sOutIdEx),
        .reg1Out(reg1OutIdEx), .reg2Out(reg2OutIdEx),
        .immOut(immOutIdEx), .shiftOperandOut(shiftOperandOutIdEx), .imm24Out(imm24OutIdEx), .destOut(destOutIdEx),
        .carryOut(carryOut)
    );

    StageEx stEx(
        .clk(clk), .rst(rst),
        .pcIn(pcOutIdEx), .pcOut(pcOutEx)
    );
    RegsExMem regsEx(
        .clk(clk), .rst(rst),
        .pcIn(pcOutEx), .pcOut(pcOutExMem)
    );

    StageMem stMem(
        .clk(clk), .rst(rst),
        .pcIn(pcOutExMem), .pcOut(pcOutMem)
    );
    RegsMemWb regsMem(
        .clk(clk), .rst(rst),
        .pcIn(pcOutMem), .pcOut(pcOutMemWb)
    );

    StageWb stWb(
        .clk(clk), .rst(rst),
        .pcIn(pcOutMemWb), .pcOut(pcOutWb)
    );
endmodule
