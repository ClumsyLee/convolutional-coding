module modulator_tb();
  
  reg clk;
  reg rst;
  
  reg din;
  wire pass;
  wire dout;
  
  modulator mod(pass,din,rst,clk);
  demodulator mod2(dout,pass,rst,clk);
  
  initial 
  begin
    clk <= 0;
    rst <= 1;
    din = 0;
    #10;
    rst = 0;
    #10;
    rst = 1;
    #300;
    din = 1;
    #800;
    din = 1;
    #800;
    din = 1;
    #800;
    din = 0;
    #800;
    din = 1;
    #800;
    din = 1;
    #800;
    din = 0;
    #800;
    din = 0;
    #800;
    din = 0;
    #800;
    din = 0;
    #800;
    din = 0;
    #800;
    din = 1;
    #800;
    din = 0;
    #800;
    din = 1;
    #800;
    din = 1;
    #800;
    din = 1;
    #800;
    din = 0;
    #800;
    din = 1;
    #800;
    din = 1;
    #800;
    din = 1;
    #800;
    din = 1;
    #800;
    din = 1;
    #800;
    din = 0;
    #800;
    din = 0;
    #800;
    din = 0;
    #800;
    din = 1;
    #800;
    din = 1;
    #800;
    din = 1;
    #800;
    din = 0;
    #800;
    din = 1;
    #800;
    din = 0;
    #800;
    din = 0;
    #800;
    din = 0;
    #800;
    din = 1;
    #800;
    din = 1;
    #800;
    din = 1;
  end
  
  always #5 clk = ~clk;
  
endmodule
