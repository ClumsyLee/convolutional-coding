/*
版本一：每七位中两位0收尾，不停顿
即输入信号在编码前的格式应为：
xxxxx00xxxxx00xxxxx00.....
x为数据，0为收尾所添加的0
*/
module viterbi(
  input  clk,       // clock of decoding
  input  clk_div2,  // clock of output
  input  rst_n,     // reset
  input  x,         // input code
  output y,         // output
  output c,         // path of decoding
  output reg rd,    // signal to receive decoidng
  output reg ready
  );

  reg[13:0]     x_t,x_t1;
  reg[3:0]      cnt;   // counting variable of clk
  reg[2:0]      cnt2;  // counting variable of clk_div2
  reg[13:0]     a_out,a_out1,a1,a2,a3,a4;  // path of decoding
  reg[3:0]      c1,c2,c3,c4;          // cost when a,b,c,d is the last node
  reg[6:0]      c_t1,c_t2,c_t3,c_t4;  // decoding when a,b,c,d is the last node
  reg[6:0]      c_t5;  // intermediate variable of decoding
  reg[6:0]      c_t;   // decoding
   always@(posedge clk)begin
   if(!rst_n)begin
        x_t   <=  0;
    x_t1  <=  0;
    cnt   <=  0;
  end
   else begin
   if(cnt == 4'b1101)
        cnt   <= 4'b0000;
   else
        cnt  <= cnt + 1;
    x_t1 <= {x,x_t1[13:1]};
         if(cnt == 4'b0000)begin
              x_t <= x_t1;
             end
          else
              x_t <= x_t;
   end
  end
   always@(posedge clk_div2)begin
  if(!rst_n)begin
       cnt2 <= 0;
   a1   <= 0;
   a2   <= 0;
   a3   <= 0;
   a4   <= 0;
   c1   <= 0;
   c2   <= 0;
   c3   <= 0;
   c4   <= 0;
   c_t1 <= 0;
   c_t2 <= 0;
   c_t3 <= 0;
   c_t4 <= 0;
  end
 else begin
   if(cnt2 == 3'b110)
        cnt2   <= 3'b000;
   else
        cnt2  <= cnt2 + 1;
     case(cnt2)
       3'b000: begin
         a1[1:0]  <= 2'b00;
         a2[1:0]  <= 2'b00;
         a3[1:0]  <= 2'b11;
         a4[1:0]  <= 2'b11;
         a1[13:2] <= 0;
         a2[13:2] <= 0;
         a3[13:2] <= 0;
         a4[13:2] <= 0;
         c1  <= 0;
         c2  <= 0;
         c3  <= 0;
         c4  <= 0;
         c_t1[6]  <= 0;
         c_t2[6]  <= 0;
         c_t3[6]  <= 1;
         c_t4[6]  <= 1;
      end
     3'b001 : begin
          a1[3:2]  <= 2'b00;
          a2[3:2]  <= 2'b11;
          a3[3:2]  <= 2'b01;
          a4[3:2]  <= 2'b10;
       c1  <= {3'b000,1'b0^x_t[0]} + {3'b000,1'b0^x_t[1]} +
                   {3'b000,1'b0^x_t[2]} + {3'b000,1'b0^x_t[3]};
       c2  <= {3'b000,1'b0^x_t[0]} + {3'b000,1'b0^x_t[1]} +
                   {3'b000,1'b1^x_t[2]} + {3'b000,1'b1^x_t[3]};
       c3  <= {3'b000,1'b1^x_t[0]} + {3'b000,1'b1^x_t[1]} +
                   {3'b000,1'b1^x_t[2]} + {3'b000,1'b0^x_t[3]};
       c4  <= {3'b000,1'b1^x_t[0]} + {3'b000,1'b1^x_t[1]} +
                   {3'b000,1'b0^x_t[2]} + {3'b000,1'b1^x_t[3]};
       c_t1[5] <= 0;
       c_t2[5] <= 1;
       c_t3[5] <= 0;
       c_t4[5] <= 1;
    end
     3'b010 : begin
         //  a = 2'b00
     if(c1 + {3'b000,1'b0^x_t[5]} + {3'b000,1'b0^x_t[4]} >
         c3 + {3'b000,1'b1^x_t[5]} + {3'b000,1'b1^x_t[4]})
      begin
       c1 <= c3 + {3'b000,1'b1^x_t[5]} + {3'b000,1'b1^x_t[4]};
       a1[3:0]    <= a3[3:0];
       a1[5:4]    <= 2'b11;
       c_t1[4]     <= 1'b0;
       c_t1[6:5]  <= c_t3[6:5];
      end
     else begin
       c1 <= c1 + {3'b000,1'b0^x_t[5]} + {3'b000,1'b0^x_t[4]};
       a1[3:0]  <= a1[3:0];
       a1[5:4]  <= 2'b00;
       c_t1[4]  <= 1'b0;
       c_t1[6:5] <= c_t1[6:5];
      end
     // b = 2'b10
     if(c1 + {3'b000,1'b1^x_t[5]} + {3'b000,1'b1^x_t[4]} >
         c3 + {3'b000,1'b0^x_t[5]} + {3'b000,1'b0^x_t[5]})
      begin
        c2  <= c3 + {3'b000,1'b0^x_t[5]} + {3'b000,1'b0^x_t[5]};
      a2[3:0] <= a3[3:0];
      a2[5:4] <= 2'b00;
      c_t2[4] <= 1;
      c_t2[6:5] <= c_t3[6:5];
     end
     else begin
      c2 <= c1 + {3'b000,1'b1^x_t[5]} + {3'b000,1'b1^x_t[4]};
      a2[3:0] <= a1[3:0];
      a2[5:4] <= 2'b11;
      c_t2[4]  <= 1;
      c_t2[6:5] <= c_t1[6:5];
      end
     //c = 2'b01
     if(c2 + {3'b000,1'b0^x_t[5]} + {3'b000,1'b1^x_t[4]} >
         c4 + {3'b000,1'b1^x_t[5]} + {3'b000,1'b0^x_t[4]})
      begin
        c3  <=c4 + {3'b000,1'b1^x_t[5]} + {3'b000,1'b0^x_t[4]};
        a3[3:0] <= a4[3:0];
        a3[5:4] <= 2'b10;
        c_t3[4]  <= 0;
        c_t3[6:5] <= c_t4[6:5];
      end
     else begin
        c3  <= c2 + {3'b000,1'b0^x_t[5]} + {3'b000,1'b1^x_t[4]};
        a3[3:0] <= a2[3:0];
        a3[5:4] <= 2'b01;
        c_t3[4] <= 0;
        c_t3[6:5] <= c_t2[6:5];
      end
     // c = 2'b11
     if(c2 + {3'b000,1'b1^x_t[5]} + {3'b000,1'b0^x_t[4]} >
          c4 + {3'b000,1'b0^x_t[5]} + {3'b000,1'b1^x_t[4]})
      begin
       c4 <= c4 + {3'b000,1'b0^x_t[5]} + {3'b000,1'b1^x_t[4]};
       a4[3:0] <= a4[3:0];
       a4[5:4] <= 2'b01;
       c_t4[4] <= 1;
       c_t4[6:5] <= c_t4[6:5];
      end
     else begin
       c4 <= c2 + {3'b000,1'b1^x_t[5]} + {3'b000,1'b0^x_t[4]};
       a4[3:0] <= a2[3:0];
       a4[5:4] <= 2'b10;
       c_t4[4] <= 1;
       c_t4[6:5] <= c_t2[6:5];
      end
    end
   3'b011 :begin
         //a = 2'b00
         if(c1 + {3'b000,1'b0^x_t[7]} + {3'b000,1'b0^x_t[6]} >
          c3 + {3'b000,1'b1^x_t[7]} + {3'b000,1'b1^x_t[6]})
      begin
       c1  <= c3 + {3'b000,1'b1^x_t[7]} + {3'b000,1'b1^x_t[6]};
       a1[5:0] <= a3[5:0];
       a1[7:6] <= 2'b11;
       c_t1[3] <= 0;
       c_t1[6:4] <= c_t3[6:4];
      end
     else begin
       c1  <= c1 + {3'b000,1'b0^x_t[7]} + {3'b000,1'b0^x_t[6]};
       a1[5:0] <= a1[5:0];
       a1[7:6] <= 2'b00;
       c_t1[3] <= 0;
       c_t1[6:4] <= c_t1[6:4];
      end
     // b = 2'b10
     if(c1 + {3'b000,1'b1^x_t[7]} + {3'b000, 1'b1^x_t[6]} >
          c3+ {3'b000,1'b0^x_t[7]} + {3'b000,1'b0^x_t[6]})
      begin
       c2  <= c3 + {3'b000,1'b0^x_t[7]} + {3'b000,1'b0^x_t[6]};
       a2[5:0] <= a3[5:0];
       a2[7:6] <= 2'b00;
       c_t2[3] <= 1;
       c_t2[6:4] <= c_t3[6:4];
      end
     else begin
       c2 <= c1 + {3'b000,1'b1^x_t[7]} + {3'b000, 1'b1^x_t[6]};
       a2[5:0]  <= a1[5:0];
       a2[7:6]  <= 2'b11;
       c_t2[3]  <= 1;
       c_t2[6:4] <= c_t1[6:4];
      end
     //2'b01
     if(c2 + {3'b000,1'b0^x_t[7]} + {3'b000,1'b1^x_t[6]} >
         c4 + {3'b000,1'b1^x_t[7]} + {3'b000,1'b0^x_t[6]})
      begin
       c3  <= c4 + {3'b000,1'b1^x_t[7]} + {3'b000,1'b0^x_t[6]};
       a3[5:0] <= a4[5:0];
       a3[7:6] <= 2'b10;
       c_t3[3] <= 0;
       c_t3[6:4] <= c_t4[6:4];
      end
     else begin
                 c3  <= c2 + {3'b000,1'b0^x_t[7]} + {3'b000,1'b1^x_t[6]};
       a3[5:0] <= a2[5:0];
       a3[7:6] <= 2'b01;
       c_t3[3] <= 0;
       c_t3[6:4] <= c_t2[6:4];
      end
     // 2'b11
     if(c2 + {3'b000,1'b1^x_t[7]} + {3'b000,1'b0^x_t[6]} >
         c4 + {3'b000,1'b0^x_t[7]} + {3'b000,1'b1^x_t[6]})
      begin
                 c4  <= c4 + {3'b000,1'b1^x_t[7]} + {3'b000,1'b0^x_t[6]};
       a4[5:0] <= a4[5:0];
       a4[7:6] <= 2'b01;
       c_t4[3] <= 1;
       c_t4[6:4] <= c_t4[6:4];
      end
     else begin
       c4  <= c2 + {3'b000,1'b0^x_t[7]} + {3'b000,1'b1^x_t[6]};
       a4[5:0] <= a2[5:0];
       a4[7:6] <= 2'b10;
       c_t4[3] <= 1;
       c_t4[6:4] <= c_t2[6:4];
      end
      end
     3'b100 : begin
         // 2'b00
     if(c1 + {3'b000,1'b0^x_t[9]} + {3'b000,1'b0^x_t[8]} >
         c3 + {3'b000,1'b1^x_t[9]} + {3'b000,1'b1^x_t[8]})
      begin
       c1  <= c3 + {3'b000,1'b1^x_t[9]} + {3'b000,1'b1^x_t[8]};
       a1[7:0] <= a3[7:0];
       a1[9:8] <= 2'b11;
       c_t1[2] <= 0;
       c_t1[6:3] <= c_t3[6:3];
      end
       else begin
       c1 <= c1 + {3'b000,1'b0^x_t[9]} + {3'b000,1'b0^x_t[8]};
       a1[7:0] <= a1[7:0];
       a1[9:8] <= 2'b00;
       c_t1[2] <= 0;
       c_t1[6:3] <= c_t1[6:3];
      end
     //2'b10
     if(c1 + {3'b000,1'b1^x_t[9]} + {3'b000,1'b1^x_t[8]} >
         c3 + {3'b000,1'b0^x_t[9]} + {3'b000,1'b0^x_t[8]})
      begin
       c2 <= c3 + {3'b000,1'b0^x_t[9]} + {3'b000,1'b0^x_t[8]};
       a2[7:0] <= a3[7:0];
       a2[9:8] <= 2'b00;
       c_t2[2] <= 1;
       c_t2[6:3] <= c_t3[6:3];
      end
     else begin
       c2 <= c1 + {3'b000,1'b1^x_t[9]} + {3'b000,1'b1^x_t[8]};
       a2[7:0] <= a1[7:0];
       a2[9:8] <= 2'b11;
       c_t2[2] <= 1;
       c_t2[6:3] <= c_t1[6:3];
      end
     // 2'b01
     if(c2 +{3'b000,1'b0^x_t[9]} + {3'b000,1'b1^x_t[8]} >
         c4 + {3'b000,1'b1^x_t[9]} + {3'b000,1'b0^x_t[8]})
      begin
       c3      <= c4 + {3'b000,1'b1^x_t[9]} + {3'b000,1'b0^x_t[8]};
      a3[7:0] <= a4[7:0];
       a3[9:8] <= 2'b10;
       c_t3[2] <= 0;
       c_t3[6:3] <= c_t4[6:3];
      end
     else begin
       c3  <= c2 + {3'b000,1'b0^x_t[9]} + {3'b000,1'b1^x_t[8]};
       a3[7:0] <= a2[7:0];
       a3[9:8] <= 2'b01;
       c_t3[2] <= 0;
       c_t3[6:3] <= c_t2[6:3];
      end
     // 2'b11
     if(c2 + {3'b000,1'b1^x_t[9]} + {3'b000,1'b0^x_t[8]} >
         c4 + {3'b000,1'b0^x_t[9]} + {3'b000,1'b1^x_t[8]})
      begin
       c4 <= c4 + {3'b000,1'b0^x_t[9]} + {3'b000,1'b1^x_t[8]};
       a4[7:0] <= a4[7:0];
       a4[9:8] <= 2'b01;
       c_t4[2] <= 1;
       c_t4[6:3] <= c_t4[6:3];
      end
     else begin
       c4 <= c2 + {3'b000,1'b1^x_t[9]} + {3'b000,1'b0^x_t[8]};
       a4[7:0] <= a2[7:0];
       a4[9:8] <= 2'b10;
       c_t4[2] <= 1;
       c_t4[6:3] <= c_t2[6:3];
      end
    end
   3'b101: begin
         //2'b00
     if(c1 + {3'b000,1'b0^x_t[11]} + {3'b000,1'b0^x_t[10]} >
         c3 + {3'b000,1'b1^x_t[11]} + {3'b000,1'b1^x_t[10]})
      begin
        c1 <= c3 + {3'b000,1'b1^x_t[11]} + {3'b000,1'b1^x_t[10]};
      a1[9:0] <= a3[9:0];
      a1[11:10] <= 2'b11;
      c_t1[1]   <= 0;
      c_t1[6:2] <= c_t3[6:2];
      end
     else begin
        c1 <= c1 + {3'b000,1'b0^x_t[11]} + {3'b000,1'b0^x_t[10]};
      a1[9:0]   <= a1[9:0];
      a1[11:10] <= 2'b00;
      c_t1[1]   <= 0;
      c_t1[6:2] <= c_t1[6:2];
      end
     //2'b01
     if(c2 + {3'b000,1'b0^x_t[11]} + {3'b000,1'b1^x_t[10]} >
         c4 + {3'b000,1'b1^x_t[11]} + {3'b000,1'b0^x_t[10]})
                begin
       c3 <= c4 + {3'b000,1'b1^x_t[11]} + {3'b000,1'b0^x_t[10]};
       a3[9:0]   <= a4[9:0];
       a3[11:10] <= 2'b10;
       c_t3[1]   <= 0;
       c_t3[6:2] <= c_t4[6:2];
      end
     else begin
       c3 <= c2 + {3'b000,1'b0^x_t[11]} + {3'b000,1'b1^x_t[10]};
       a3[9:0]   <= a2[9:0];
       a3[11:10] <= 2'b01;
       c_t3[1]   <= 0;
       c_t3[6:2] <= c_t2[6:2];
      end
    end
   3'b110 : begin
               // 2'b00
      if(c1 + {3'b000,1'b0^x_t[13]} + {3'b000,1'b0^x_t[12]} >
          c3 + {3'b000,1'b1^x_t[13]} + {3'b000,1'b1^x_t[12]})
      begin
       c1 <= c3 + {3'b000,1'b1^x_t[13]} + {3'b000,1'b1^x_t[12]};
       a1[11:0]    <= a3[11:0];
       a1[13:12]   <= 2'b11;
       a_out[11:0] <= a3[11:0];
       a_out[13:12]<= 2'b11;
       c_t5[0]     <= 0;
       c_t5[6:1]   <= c_t3[6:1];
      end
      else begin
       c1 <= c1 + {3'b000,1'b0^x_t[13]} + {3'b000,1'b0^x_t[12]};
       a1[11:0]    <= a1[11:0];
       a1[13:12]   <= 2'b00;
       a_out[11:0] <= a1[11:0];
       a_out[13:12]<= 2'b00;
       c_t5[0]     <= 0;
       c_t5[6:1]   <= c_t1[6:1];
      end
     end
// 3'b111 :  c_t5[6:0] <= c_t1[6:0];
   default :begin//??
         a1[1:0] <= 2'b00;
         a2[1:0] <= 2'b00;
         a3[1:0] <= 2'b11;
         a4[1:0] <= 2'b11;
         c1  <= 0;
         c2  <= 0;
         c3  <= 0;
         c4  <= 0;
         c_t1 <= 0;
         c_t2 <= 0;
         c_t3 <= 0;
         c_t4 <= 0;
    end
  endcase
  end
 end
  always@(posedge clk)begin
    if(!rst_n)begin
     ready   <= 0;
   a_out1  <= 0;
   c_t     <= 0;
   rd      <= 0;
   end
  else begin
     if(cnt == 0)
       rd   <= 1;
   else
           rd  <= 0 ;
   if(cnt == 1)begin
      c_t    <= c_t5;
      a_out1 <= a_out;
    ready  <= 1;
      end
     else begin
      ready  <= 0;
    // shift the register of path of decoding to output
    a_out1[13:0] <= {a_out1[0],a_out1[13:1]};
    if(cnt[0]==1)
       // shift the register of decoding to output
       c_t[6:0]  <= {c_t[5:0],c_t[6]};
   end
    end
  end
    assign y = a_out1[0];
  assign c = c_t[6];
endmodule
