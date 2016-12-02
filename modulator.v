
module modulator(
        output dout,
        input din,
        input rst,
        input clk);

reg [2:0] count;
reg feq1,feq2;      //??????

//??????1?????feq1?????????0?????feq2??
assign dout = (din == 1)?feq1:feq2;

//feq1?clk??8?????feq2?clk??16????
always@(posedge clk or negedge rst)
  begin
    if(!rst)
      begin
        count <= 3'b000;
        feq1 <= 0;
        feq2 <= 0;
      end
    else
      begin
        if(count == 3'b011)
          begin
            feq1 <= ~feq1;
            count <= count + 1;
          end
        else if(count == 3'b111)
          begin
            feq1 <= ~feq1;
            feq2 <= ~feq2;
            count <= 3'b000;
          end
        else
          begin
            count <= count + 1;
          end
      end
  end

endmodule
            
       
       
