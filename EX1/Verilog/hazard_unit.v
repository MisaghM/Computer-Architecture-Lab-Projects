module HazardUnit(
    input [3:0] rn, rdm,
    input twoSrc,
    input [3:0] destEx, destMem,
    input wbEnEx, wbEnMem,
    output reg hazard
);
    always @(rn, rdm, destEx, destMem, wbEnEx, wbEnMem, twoSrc) begin
        hazard = 1'b0;
        if (wbEnEx) begin
            if (rn == destEx || (twoSrc && rdm == destEx)) begin
                hazard = 1'b1;
            end
        end
        if (wbEnMem) begin
            if (rn == destMem || (twoSrc && rdm == destMem)) begin
                hazard = 1'b1;
            end
        end
    end
endmodule
