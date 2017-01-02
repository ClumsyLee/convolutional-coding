module modulator(
        output dout,
        input din,
        input rst,
        input clk);

reg [2:0] count;
reg feq1,feq2;  // 两种载波频率

// “1”信号使用载波频率feq1,“0”信号使用载波频率feq2
assign dout = (din == 1)?feq1:feq2;

// feq1为clk信号8分频，feq2为clk信号16分频
always@(posedge clk or negedge rst)
  begin
    if(!rst)
      begin
        count <= 3'b000;  // 16分频计数到8
        feq1 <= 0;
        feq2 <= 0;
      end
    else
      begin
        if(count == 3'b011)
          begin
            feq1 <= ~feq1;  // 计数到4时8分频信号反向
            count <= count + 1;
          end
        else if(count == 3'b111)
          begin
            feq1 <= ~feq1;  // 计数到8时两信号反向
            feq2 <= ~feq2;
            count <= 3'b000;  // 计数信号重置
          end
        else
          begin
            count <= count + 1;
          end
      end
  end

endmodule
