module InstructionMemory #(
    parameter Count = 1024
)(
    input [31:0] pc,
    output reg [31:0] inst
);
    wire [31:0] adr;
    assign adr = {pc[31:2], 2'b00}; // Align address to the word boundary

    always @(adr) begin
        case(adr)
            32'd0:  inst = 32'b000000_00001_00010_00000_00000000000;
            32'd4:  inst = 32'b000000_00011_00100_00000_00000000000;
            32'd8:  inst = 32'b000000_00101_00110_00000_00000000000;
            32'd12: inst = 32'b000000_00111_01000_00010_00000000000;
            32'd16: inst = 32'b000000_01001_01010_00011_00000000000;
            32'd20: inst = 32'b000000_01011_01100_00000_00000000000;
            32'd24: inst = 32'b000000_01101_01110_00000_00000000000;
        endcase
    end
endmodule
