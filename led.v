module led(anodes, cathodes, num, clk);

output reg [3:0] anodes;
output [7:0] cathodes;
input [15:0] num;
input clk;

reg [3:0] digit = 0;
wire [6:0] bcd;

BCD7 bcd71(digit, bcd);
assign cathodes = ~{bcd, 1'b0};

always @(posedge clk) begin
    case (anodes)
        4'b0111: begin
            digit <= (num / 100) % 10;
            anodes <= 4'b1011;
        end
        4'b1011: begin
            digit <= (num / 10) % 10;
            anodes <= 4'b1101;
        end
        4'b1101: begin
            digit <= num % 10;
            anodes <= 4'b1110;
        end
        default: begin
            digit <= (num / 1000) % 10;
            anodes <= 4'b0111;
        end
    endcase
end

endmodule
