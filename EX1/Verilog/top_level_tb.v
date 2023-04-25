`timescale 1ns/1ns

module TopLevelTB();
    localparam HCLK = 5;

    reg clk, rst, forwardEn;

    TopLevel tl(clk, rst, forwardEn);

    always #HCLK clk = ~clk;

    initial begin
        {clk, rst, forwardEn} = 3'b011;
        #10 rst = 1'b0;
        #3000 $stop;
    end
endmodule
