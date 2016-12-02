module conv_encoder_tb;

reg clk = 1, clk_div2 = 0;
always #1 clk = ~clk;
always #2 clk_div2 = ~clk_div2;

reg x = 0;
reg rst_n = 0;

wire y;

conv_encoder encoder(clk, clk_div2, x, rst_n, y);

initial begin
    $monitor($time, " clk: %b, clk_div2: %b, x: %b, rst_n: %b, y: %b, regs: %b, status: %b",
             clk, clk_div2, x, rst_n, y, encoder.regs, encoder.status);

    #5 rst_n = 1;

    #4 x = 1;
    #4 x = 1;
    #4 x = 0;
    #4 x = 1;
    #4 x = 0;
    #4 x = 0;
    #4 x = 0;
    #20 $finish;
end

endmodule
