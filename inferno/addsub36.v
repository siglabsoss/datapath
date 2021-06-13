// FD1P3DX = 108
// CCU2C = 19
// FF = 108
// Fmax = 278MHz
module addsub36 (
    input [35:0] a, b,
    input en0, en1, en2,
    input sign,
    output logic [35:0] x,
    input clk, reset_n
);

logic [35:0] e0, e0_nxt, e1, e1_nxt;
logic [35:0] e2, e2_nxt;

assign e0_nxt = a;
assign e1_nxt = b;

assign e2_nxt = sign ? (e0 - e1) : (e0 + e1);
// assign e2_nxt = e0 * e1;

assign x = e2;

// enable; async reset
always @(posedge clk or negedge reset_n)
    if (~reset_n) begin
        e0 <= 36'b0;
        e1 <= 36'b0;
        e2 <= 36'b0;
    end else begin
        if (en0) e0 <= e0_nxt;
        if (en1) e1 <= e1_nxt;
        if (en2) e2 <= e2_nxt;
    end

endmodule
