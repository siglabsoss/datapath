module g (
    // per node (target / initiator)
    input                clk,
    input                reset_n,

    input en0, en1, en2, en3, en4, en5, en6, en7, en8, en9,

    input         [17:0] t4_dat,
    input                t4_req,
    output logic         t4_ack,
    input         [17:0] t5_dat,
    input                t5_req,
    output logic         t5_ack,
    input         [17:0] t6_dat,
    input                t6_req,
    output logic         t6_ack,
    input         [17:0] t7_dat,
    input                t7_req,
    output logic         t7_ack,
    output logic  [35:0] i10_dat,
    output logic         i10_req,
    input                i10_ack,
    output logic  [35:0] i11_dat,
    output logic         i11_req,
    input                i11_ack
);
// per edge
logic  [17:0] dat0, dat0_nxt;
logic  [17:0] dat1, dat1_nxt;
logic  [17:0] dat2, dat2_nxt;
logic  [17:0] dat3, dat3_nxt;
logic  [35:0] dat4, dat4_nxt;
logic  [35:0] dat5, dat5_nxt;
logic  [35:0] dat6, dat6_nxt;
logic  [35:0] dat7, dat7_nxt;
logic  [35:0] dat8, dat8_nxt;
logic  [35:0] dat9, dat9_nxt;
// per edge
assign dat0_nxt = t4_dat;
assign dat1_nxt = t5_dat;
assign dat2_nxt = t6_dat;
assign dat3_nxt = t7_dat;
assign dat4_nxt = $signed(dat0) * $signed(dat2);
assign dat5_nxt = $signed(dat1) * $signed(dat3);
assign dat6_nxt = $signed(dat0) * $signed(dat3);
assign dat7_nxt = $signed(dat1) * $signed(dat2);
assign dat8_nxt = (dat4 - dat5);
assign dat9_nxt = (dat6 + dat7);
assign i10_dat = dat8;
assign i11_dat = dat9;
// per edge
always_ff @(posedge clk) begin
    if (en0) dat0 <= dat0_nxt;
    if (en0) dat1 <= dat1_nxt;
    if (en2) dat2 <= dat2_nxt;
    if (en2) dat3 <= dat3_nxt;
    if (en4) dat4 <= dat4_nxt;
    if (en4) dat5 <= dat5_nxt;
    if (en6) dat6 <= dat6_nxt;
    if (en6) dat7 <= dat7_nxt;
    if (en8) dat8 <= dat8_nxt;
    if (en9) dat9 <= dat9_nxt;
end

endmodule
