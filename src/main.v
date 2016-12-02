module main(
    input [3:0] btns,
    input clk,
    input rst_n
);

reg [6:0] regs = 0;
wire x = regs[6];

wire x_clk, code_clk;
watchmaker #200 x_watch(x_clk, clk, rst_n);
watchmaker #100 code_watch(code_clk, clk, rst_n);

always @(posedge x_clk, negedge rst_n) begin
    if (!rst_n) begin
        regs <= {btns, 3'b0};
    end else begin
        regs <= {regs[5:0], regs[6]};
    end
end

wire y;
conv_encoder encoder(code_clk, x_clk, x, rst_n, y);

wire dout1, dout2;
modulator modulator1(dout1, y, rst_n, clk);
demodulator demodulator1(dout2, dout1, rst_n, clk);

wire c, ready;
viterbi viterbi1(
    .clk(code_clk),
    .clk_div2(x_clk),
    .rst_n(rst_n),
    .x(dout2),
    // .y(),
    .c(c),
    // .rd(),
    .ready(ready)
);

endmodule
