`timescale 1ns/1ns

module TopLevelTB();
    localparam HCLK = 5;

    reg clk, rst;

    TopLevel tl(clk, rst);

    always #HCLK clk = ~clk;

    initial begin
        {clk, rst} = 2'b01;
        #10 rst = 1'b0;
        #500 $stop;
    end
endmodule
