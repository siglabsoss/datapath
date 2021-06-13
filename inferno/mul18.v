// MULT18X18D = 1
module mul18 (
    input [17:0] a, b,
    input en0, en1, en2,
    output logic [35:0] x,
    input clk, reset_n
);

logic [17:0] e0, e0_nxt, e1, e1_nxt;
logic [35:0] e2, e2_nxt;

assign e0_nxt = a;
assign e1_nxt = b;

assign e2_nxt = $signed(e0) * $signed(e1);
// assign e2_nxt = e0 * e1;

assign x = e2;

// // baseline
// always @(posedge clk)
//     begin
//         e0 <= e0_nxt;
//         e1 <= e1_nxt;
//         e2 <= e2_nxt;
//     end

// // enable
// always @(posedge clk)
//     begin
//         if (en0) e0 <= e0_nxt;
//         if (en1) e1 <= e1_nxt;
//         if (en2) e2 <= e2_nxt;
//     end

// // async reset
// always @(posedge clk or negedge reset_n)
//     if (~reset_n) begin
//         e0 <= 18'b0;
//         e1 <= 18'b0;
//         e2 <= 36'b0;
//     end else begin
//         e0 <= e0_nxt;
//         e1 <= e1_nxt;
//         e2 <= e2_nxt;
//     end

// enable; async reset
always @(posedge clk or negedge reset_n)
    if (~reset_n) begin
        e0 <= 18'b0;
        e1 <= 18'b0;
        e2 <= 36'b0;
    end else begin
        if (en0) e0 <= e0_nxt;
        if (en1) e1 <= e1_nxt;
        if (en2) e2 <= e2_nxt;
    end

endmodule
