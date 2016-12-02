module conv_encoder(
    input clk,
    input clk_div2,
    input x,
    input rst_n,
    output reg y
);

reg [2:0] regs;
reg status;

always @(posedge clk_div2, negedge rst_n) begin
    if (!rst_n) begin
        regs <= 0;
    end else begin
        regs <= {x, regs[2:1]};
    end
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        status <= 1;
        y <= 0;
    end else begin
        status <= ~status;
    end
end

always @(*) begin
    if (status) begin
        y <= regs[2] ^ regs[1] ^ regs[0];
    end else begin
        y <= regs[2] ^ regs[0];
    end
end

endmodule
