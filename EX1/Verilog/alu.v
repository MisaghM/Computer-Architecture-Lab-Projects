module ALU #(
    parameter N = 32
)(
    input [N-1:0] a, b,
    input carryIn,
    input [3:0] exeCmd,
    output reg [N-1:0] out,
    output [3:0] status
);
    reg c, v;
    wire z, n;
    assign status = {n, z, c, v};
    assign z = out == 0;
    assign n = out[N-1];

    always @(exeCmd or a or b or carryIn) begin
        out = {N{1'b0}};
        c = 1'b0;

        case (exeCmd)
            4'b0001: out = b;                       // MOV
            4'b1001: out = ~b;                      // MVN
            4'b0010: {c, out} = a + b;              // ADD
            4'b0011: {c, out} = a + b + carryIn;    // ADC
            4'b0100: {c, out} = a - b;              // SUB
            4'b0101: {c, out} = a - b - (~carryIn); // SBC
            4'b0110: out = a & b;                   // AND
            4'b0111: out = a | b;                   // ORR
            4'b1000: out = a ^ b;                   // EOR
            default: out = {N{1'b0}};
        endcase

        v = 1'b0;
        if (exeCmd[3:1] == 3'b001) begin      // ADD, ADC
            v = (a[N-1] == b[N-1]) && (a[N-1] != out[N-1]);
        end
        else if (exeCmd[3:1] == 3'b010) begin // SUB, SBC
            v = (a[N-1] != b[N-1]) && (a[N-1] != out[N-1]);
        end
    end
endmodule
