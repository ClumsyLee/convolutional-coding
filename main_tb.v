module main_tb;

reg clk = 0;
always #1 clk = ~clk;

reg rst_n = 0;
reg [3:0] btns = 5'b1101;
reg inform = 0;

main main1(btns, clk, rst_n,inform);

initial begin
    // $monitor($time, " x_clk: %b, regs: %b, encoder.regs: %b, rst_n: %b, y: %b, dout2: %b",
    //          main1.x_clk, main1.regs, main1.encoder.regs, rst_n, main1.y, main1.dout2);
    $monitor($time, " x_clk: %b, regs: %b, encoder.regs: %b, rst_n: %b, y: %b, dout2: %b, c: %b, ready: %b",
             main1.x_clk, main1.regs, main1.encoder.regs, rst_n, main1.y, main1.dout2, main1.c, main1.ready);

    #10 rst_n = 1;
    #425 inform =1;
    #100000 $finish;
end

endmodule