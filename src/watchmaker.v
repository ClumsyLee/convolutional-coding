`timescale 10ns/1ns

module watchmaker(new_clk, clk);

output reg new_clk = 0;
input clk;

parameter RATIO = 100_000_000,  // V10 = 10MHz
          HALF_RATIO = RATIO / 2;

integer counter = 1;

always @(posedge clk) begin
    if (counter >= HALF_RATIO) begin
        counter <= 1;
        new_clk <= ~new_clk;
    end else begin
        counter <= counter + 1;
    end
end

endmodule
