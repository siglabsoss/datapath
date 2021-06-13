// PRADD18A = 1
// MULT18X18D = 1
module add18_mul18 (
    input [17:0] a, b, c,
    input en0, en1, en2, en3, en4, en5,
    input sign,
    output logic [35:0] x,
    input clk, reset_n
);

logic [17:0] e0, e0_nxt, e1, e1_nxt, e2, e2_nxt, e3, e3_nxt;
logic [35:0] e4, e4_nxt;

assign e0_nxt = a;
assign e1_nxt = b;
assign e2_nxt = c;

assign e3_nxt = sign ? e0 - e1 : e0 + e1;

assign e4_nxt = $signed(e2) * $signed(e3);

assign x = e4;

// enable; async reset
always @(posedge clk or negedge reset_n)
    if (~reset_n) begin
        e0 <= 18'b0;
        e1 <= 18'b0;
        e2 <= 18'b0;
        e3 <= 18'b0;
        e4 <= 36'b0;
    end else begin
        if (en0) e0 <= e0_nxt;
        if (en0) e1 <= e1_nxt;
        if (en2) e2 <= e2_nxt;
        if (en3) e3 <= e3_nxt;
        if (en4) e4 <= e4_nxt;
    end

endmodule
