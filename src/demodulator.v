module demodulator(
        output reg dout,
        input din,
        input rst,
        input clk);

  reg [2:0]m;
  reg [3:0]count;

  // 对接受信号上升沿计数
  always@(posedge din or negedge rst)
    begin
      if(!rst)
        begin
          m <= 0;
        end
      else
        begin
          m <= m + 1;
        end
    end

  // 16个clk信号周期里，8分频clk有2个周期
  // 16分频clk有1个周期，以此做判据解调
  always@(posedge clk or negedge rst)
    begin
      if(!rst)
        begin
          count <= 0;
          dout <= 0;
        end
      else if(count == 4'b1111)  // 计数16
        begin
          if(m > 3'b001)  // 大于1个周期为8分频信号
            dout <= 1;
          else            // 否则为16分频信号
            dout <= 0;
          m <= 0;
          count <= 0;
        end
      else
        begin
          count <= count + 1;
        end
    end

endmodule
