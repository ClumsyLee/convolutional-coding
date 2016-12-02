module watchmaker(
    output reg new_clk,
    input clk,
    input rst_n
);

parameter RATIO = 100_000_000,  // V10 = 10MHz
          HALF_RATIO = RATIO / 2;

integer counter = 1;

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        counter <= 1;
        new_clk <= 1;
    end else if (counter >= HALF_RATIO) begin
        counter <= 1;
        new_clk <= ~new_clk;
    end else begin
        counter <= counter + 1;
    end
end

endmodule
