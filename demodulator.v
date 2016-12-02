
module demodulator(
        output reg dout,
        input din,
        input rst,
        input clk);
  
  reg [2:0]m;
  reg [3:0]count;
  
  //??????????
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
  
  //16?clk????feq1?8???din?2?????feq2?16???din?1????
  //m????1????0???????1??
  always@(posedge clk or negedge rst)
    begin
      if(!rst)
        begin
          count <= 0;
          dout <= 0;
        end
      /*
      else if(count == 4'b1110)
        begin
          if(m > 3'b001)
            dout <= 1;
          else
            begin
              dout <= 0;
              count <= count + 1;
            end
        end
      */
      else if(count == 4'b1111)
        begin
          if(m > 3'b001)
            dout <= 1;
          else
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

  
  