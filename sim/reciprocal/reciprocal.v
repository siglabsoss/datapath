module reciprocal (
    // per node (target / initiator)
    input              clk,
    input              reset_n,
    input       [15:0] t_0_dat,
    input              t_0_req,
    output             t_0_ack,
    output      [15:0] i_13_dat,
    output             i_13_req,
    input              i_13_ack
);
// per edge
wire      [15:0] dat0;
wire      [15:0] dat1, dat1_nxt;
wire       [4:0] dat2;
wire      [15:0] dat3;
wire       [4:0] dat4;
wire      [15:0] dat5;
wire      [31:0] dat6, dat6_nxt;
wire      [15:0] dat7;
wire      [15:0] dat8;
wire      [31:0] dat9, dat9_nxt;
wire      [15:0] dat10;
wire      [15:0] dat11;
wire      [15:0] dat12, dat12_nxt;
wire      [15:0] dat13, dat13_nxt;
// per node
// node:0 is target port
assign dat0 = t_0_dat;

// node:1 macro normalize
// node:1 normalize (reciprocal)

//wire [2:0] shift1_0,shift1_1,shift1_2;
//wire [15:0] val1_0,val1_1,val1_2;

//assign val1_0   = dat1[14]?dat1>>1:dat1;
//assign shift1_0 = dat1>4?3'b1:0;

//assign val1_1   = val1_0>2?val1_0>>2:val1_0;
//assign shift1_1 = val1_0>2?shift1_0+3'b10:shift1_0;

//assign val1_2   = val1_1>1?val1_1>>1:val1_1;
//assign shift1_2 = val1_1>1?shift1_1+3'b1:shift1_1;

assign dat3 = dat1 >> (5'd6-dat2);
assign dat4 = 5'd6-dat2;

// node:2 equality
assign dat1_nxt = dat0;

// node:3 macro lzc

//node:3 leading zeros counter

wire [15:0] pad_signal3;
assign pad_signal3 = dat1|16'd1023;

wire[15:0] stage0;
wire[7:0] stage1;
wire[3:0] stage2;
wire[1:0] stage3;

assign stage0 = pad_signal3;
assign stage1 = {stage0[14] | stage0[15],stage0[12] | stage0[13],stage0[10] | stage0[11],stage0[8] | stage0[9],stage0[6] | stage0[7],stage0[4] | stage0[5],stage0[2] | stage0[3],stage0[0] | stage0[1]};
assign stage2 = {stage1[6] | stage1[7],stage1[4] | stage1[5],stage1[2] | stage1[3],stage1[0] | stage1[1]};
assign stage3 = {stage2[2] | stage2[3],stage2[0] | stage2[1]};

wire[4:0] lzc3;

assign lzc3[0] = ~((stage0[15]) | (stage0[13] & ~stage0[14]) | (stage0[11] & ~stage0[14] & ~stage0[12]) | (stage0[9] & ~stage0[14] & ~stage0[12] & ~stage0[10]) | (stage0[7] & ~stage0[14] & ~stage0[12] & ~stage0[10] & ~stage0[8]) | (stage0[5] & ~stage0[14] & ~stage0[12] & ~stage0[10] & ~stage0[8] & ~stage0[6]) | (stage0[3] & ~stage0[14] & ~stage0[12] & ~stage0[10] & ~stage0[8] & ~stage0[6] & ~stage0[4]) | (stage0[1] & ~stage0[14] & ~stage0[12] & ~stage0[10] & ~stage0[8] & ~stage0[6] & ~stage0[4] & ~stage0[2]));
assign lzc3[1] = ~((stage1[7]) | (stage1[5] & ~stage1[6]) | (stage1[3] & ~stage1[6] & ~stage1[4]) | (stage1[1] & ~stage1[6] & ~stage1[4] & ~stage1[2]));
assign lzc3[2] = ~((stage2[3]) | (stage2[1] & ~stage2[2]));
assign lzc3[3] = ~((stage3[1]));
assign lzc3[4] = ~(|pad_signal3);

assign dat2 = lzc3;

// node:4 macro lhsOp
assign dat5 = 16'h5dd - dat3;
// node:5 macro lhsOp
assign dat8 = 16'h401 - dat7;
// node:6 operator mul
assign dat6_nxt = ($signed(dat3) * $signed(dat5));

// node:7 operator mul
assign dat9_nxt = ($signed(dat8) * $signed(dat5));

// node:8 macro bitSelect
assign dat7 = dat6[25:10]; //{"port":"i_0_dat","wire":"dat7","width":16,"highSelect":25,"lowSelect":10}
// node:9 macro bitSelect
assign dat10 = dat9[25:10]; //{"port":"i_0_dat","wire":"dat10","width":16,"highSelect":25,"lowSelect":10}
// node:10 macro reciprocalSatShift2
assign dat11 = |dat10[15:14] ? 16'd32767 : dat10 << 2;
// node:11 operator srl
assign dat12_nxt = (dat11 >>> dat4);

// node:12 macro reciprocalSat
assign dat13_nxt = dat12[15]?  16'd32767:dat12;
// node:13 is initiator port
assign i_13_dat = dat13;

// per edge

// edge:0 EB0


// edge:1 EB1.5
wire en1_0, en1_1, sel1;
reg [15:0] dat1_r0, dat1_r1;
always @(posedge clk) if (en1_0) dat1_r0 <= dat1_nxt;
always @(posedge clk) if (en1_1) dat1_r1 <= dat1_nxt;

assign dat1 = sel1 ? dat1_r1 : dat1_r0;


// edge:2 EB0


// edge:3 EB0


// edge:4 EB0


// edge:5 EB0


// edge:6 EB1
wire en6;
reg [31:0] dat6_r;
always @(posedge clk) if (en6) dat6_r <= dat6_nxt;
assign dat6 = dat6_r;


// edge:7 EB0


// edge:8 EB0


// edge:9 EB1
wire en9;
reg [31:0] dat9_r;
always @(posedge clk) if (en9) dat9_r <= dat9_nxt;
assign dat9 = dat9_r;


// edge:10 EB0


// edge:11 EB0


// edge:12 EB1.5
wire en12_0, en12_1, sel12;
reg [15:0] dat12_r0, dat12_r1;
always @(posedge clk) if (en12_0) dat12_r0 <= dat12_nxt;
always @(posedge clk) if (en12_1) dat12_r1 <= dat12_nxt;

assign dat12 = sel12 ? dat12_r1 : dat12_r0;


// edge:13 EB1.5
wire en13_0, en13_1, sel13;
reg [15:0] dat13_r0, dat13_r1;
always @(posedge clk) if (en13_0) dat13_r0 <= dat13_nxt;
always @(posedge clk) if (en13_1) dat13_r1 <= dat13_nxt;

assign dat13 = sel13 ? dat13_r1 : dat13_r0;

reciprocal_ctrl uctrl (
    .clk(clk),
    .reset_n(reset_n),
    .t_0_req(t_0_req),
    .t_0_ack(t_0_ack),
    .i_13_req(i_13_req),
    .i_13_ack(i_13_ack),
    .en1_0(en1_0),
    .en1_1(en1_1),
    .sel1(sel1),
    .en6(en6),
    .en9(en9),
    .en12_0(en12_0),
    .en12_1(en12_1),
    .sel12(sel12),
    .en13_0(en13_0),
    .en13_1(en13_1),
    .sel13(sel13)
);
endmodule // reciprocal

module reciprocal_ctrl (
    // per node (target / initiator)
    input              clk,
    input              reset_n,
    input              t_0_req,
    output             t_0_ack,
    output             i_13_req,
    input              i_13_ack,
    output             en1_0,
    output             en1_1,
    output             sel1,
    output             en6,
    output             en9,
    output             en12_0,
    output             en12_1,
    output             sel12,
    output             en13_0,
    output             en13_1,
    output             sel13
);
// per edge
wire             req0, ack0, ack0_0, req0_0;
wire             req1, ack1, ack1_0, req1_0, ack1_1, req1_1;
wire             req2, ack2, ack2_0, req2_0;
wire             req3, ack3, ack3_0, req3_0, ack3_1, req3_1;
wire             req4, ack4, ack4_0, req4_0;
wire             req5, ack5, ack5_0, req5_0, ack5_1, req5_1;
wire             req6, ack6, ack6_0, req6_0;
wire             req7, ack7, ack7_0, req7_0;
wire             req8, ack8, ack8_0, req8_0;
wire             req9, ack9, ack9_0, req9_0;
wire             req10, ack10, ack10_0, req10_0;
wire             req11, ack11, ack11_0, req11_0;
wire             req12, ack12, ack12_0, req12_0;
wire             req13, ack13, ack13_0, req13_0;
// node:t_0 target
assign req0 = t_0_req;
assign t_0_ack = ack0;

// edge:0 EB0
wire ack0m, req0m;
assign req0m = req0;
assign ack0 = ack0m;


// edge:0 fork


assign req0_0 = req0m;

assign ack0m = ack0_0;



// edge:1 EB1.5
wire ack1m, req1m;
eb15_ctrl uctrl_1 (
    .t_0_req(req1), .t_0_ack(ack1),
    .i_0_req(req1m), .i_0_ack(ack1m),
    .en0(en1_0), .en1(en1_1), .sel(sel1),
    .clk(clk), .reset_n(reset_n)
);


// edge:1 fork
reg  ack1_0_r, ack1_1_r;
wire ack1_0_s, ack1_1_s;
assign req1_0 = req1m & ~ack1_0_r;
assign req1_1 = req1m & ~ack1_1_r;
assign ack1_0_s = ack1_0 | ~req1_0;
assign ack1_1_s = ack1_1 | ~req1_1;
assign ack1m = ack1_0_s & ack1_1_s;
always @(posedge clk or negedge reset_n) if (~reset_n) ack1_0_r <= 1'b0; else ack1_0_r <= ack1_0_s & ~ack1m;
always @(posedge clk or negedge reset_n) if (~reset_n) ack1_1_r <= 1'b0; else ack1_1_r <= ack1_1_s & ~ack1m;


// edge:2 EB0
wire ack2m, req2m;
assign req2m = req2;
assign ack2 = ack2m;


// edge:2 fork


assign req2_0 = req2m;

assign ack2m = ack2_0;



// edge:3 EB0
wire ack3m, req3m;
assign req3m = req3;
assign ack3 = ack3m;


// edge:3 fork
reg  ack3_0_r, ack3_1_r;
wire ack3_0_s, ack3_1_s;
assign req3_0 = req3m & ~ack3_0_r;
assign req3_1 = req3m & ~ack3_1_r;
assign ack3_0_s = ack3_0 | ~req3_0;
assign ack3_1_s = ack3_1 | ~req3_1;
assign ack3m = ack3_0_s & ack3_1_s;
always @(posedge clk or negedge reset_n) if (~reset_n) ack3_0_r <= 1'b0; else ack3_0_r <= ack3_0_s & ~ack3m;
always @(posedge clk or negedge reset_n) if (~reset_n) ack3_1_r <= 1'b0; else ack3_1_r <= ack3_1_s & ~ack3m;


// edge:4 EB0
wire ack4m, req4m;
assign req4m = req4;
assign ack4 = ack4m;


// edge:4 fork


assign req4_0 = req4m;

assign ack4m = ack4_0;



// edge:5 EB0
wire ack5m, req5m;
assign req5m = req5;
assign ack5 = ack5m;


// edge:5 fork
reg  ack5_0_r, ack5_1_r;
wire ack5_0_s, ack5_1_s;
assign req5_0 = req5m & ~ack5_0_r;
assign req5_1 = req5m & ~ack5_1_r;
assign ack5_0_s = ack5_0 | ~req5_0;
assign ack5_1_s = ack5_1 | ~req5_1;
assign ack5m = ack5_0_s & ack5_1_s;
always @(posedge clk or negedge reset_n) if (~reset_n) ack5_0_r <= 1'b0; else ack5_0_r <= ack5_0_s & ~ack5m;
always @(posedge clk or negedge reset_n) if (~reset_n) ack5_1_r <= 1'b0; else ack5_1_r <= ack5_1_s & ~ack5m;


// edge:6 EB1
wire ack6m;
reg req6m;
assign en6 = req6 & ack6;
assign ack6 = ~req6m | ack6m;
always @(posedge clk or negedge reset_n) if (~reset_n) req6m <= 1'b0; else req6m <= ~ack6 | req6;


// edge:6 fork


assign req6_0 = req6m;

assign ack6m = ack6_0;



// edge:7 EB0
wire ack7m, req7m;
assign req7m = req7;
assign ack7 = ack7m;


// edge:7 fork


assign req7_0 = req7m;

assign ack7m = ack7_0;



// edge:8 EB0
wire ack8m, req8m;
assign req8m = req8;
assign ack8 = ack8m;


// edge:8 fork


assign req8_0 = req8m;

assign ack8m = ack8_0;



// edge:9 EB1
wire ack9m;
reg req9m;
assign en9 = req9 & ack9;
assign ack9 = ~req9m | ack9m;
always @(posedge clk or negedge reset_n) if (~reset_n) req9m <= 1'b0; else req9m <= ~ack9 | req9;


// edge:9 fork


assign req9_0 = req9m;

assign ack9m = ack9_0;



// edge:10 EB0
wire ack10m, req10m;
assign req10m = req10;
assign ack10 = ack10m;


// edge:10 fork


assign req10_0 = req10m;

assign ack10m = ack10_0;



// edge:11 EB0
wire ack11m, req11m;
assign req11m = req11;
assign ack11 = ack11m;


// edge:11 fork


assign req11_0 = req11m;

assign ack11m = ack11_0;



// edge:12 EB1.5
wire ack12m, req12m;
eb15_ctrl uctrl_12 (
    .t_0_req(req12), .t_0_ack(ack12),
    .i_0_req(req12m), .i_0_ack(ack12m),
    .en0(en12_0), .en1(en12_1), .sel(sel12),
    .clk(clk), .reset_n(reset_n)
);


// edge:12 fork


assign req12_0 = req12m;

assign ack12m = ack12_0;



// edge:13 EB1.5
wire ack13m, req13m;
eb15_ctrl uctrl_13 (
    .t_0_req(req13), .t_0_ack(ack13),
    .i_0_req(req13m), .i_0_ack(ack13m),
    .en0(en13_0), .en1(en13_1), .sel(sel13),
    .clk(clk), .reset_n(reset_n)
);


// edge:13 fork


assign req13_0 = req13m;

assign ack13m = ack13_0;


// node:1 join normalize
// join:2, fork:2
wire             req3_q, ack1_1_m;
assign req3_q = req1_1 & req2_0;
reg        [1:0] ack3_r;
wire       [1:0] req3_c, ack3_s;
assign req3_c = ~ack3_r & {2{req3_q}};
assign {req4, req3} = req3_c;
assign ack3_s = {ack4, ack3} | ~req3_c;
assign ack1_1_m = &ack3_s;
always @(posedge clk or negedge reset_n) if (~reset_n) ack3_r <= 2'b0; else ack3_r <= ack3_s & ~{2{ack1_1_m}};
assign ack1_1 = ack1_1_m & req2_0;
assign ack2_0 = ack1_1_m & req1_1;
// node:2 join undefined
// join:1, fork:1
assign req1 = req0_0;
assign ack0_0 = ack1;
// node:3 join lzc
// join:1, fork:1
assign req2 = req1_0;
assign ack1_0 = ack2;
// node:4 join lhsOp
// join:1, fork:1
assign req5 = req3_0;
assign ack3_0 = ack5;
// node:5 join lhsOp
// join:1, fork:1
assign req8 = req7_0;
assign ack7_0 = ack8;
// node:6 join mul
// join:2, fork:1
assign req6 = req3_1 & req5_0;
assign ack3_1 = ack6 & req5_0;
assign ack5_0 = ack6 & req3_1;
// node:7 join mul
// join:2, fork:1
assign req9 = req8_0 & req5_1;
assign ack8_0 = ack9 & req5_1;
assign ack5_1 = ack9 & req8_0;
// node:8 join bitSelect
// join:1, fork:1
assign req7 = req6_0;
assign ack6_0 = ack7;
// node:9 join bitSelect
// join:1, fork:1
assign req10 = req9_0;
assign ack9_0 = ack10;
// node:10 join reciprocalSatShift2
// join:1, fork:1
assign req11 = req10_0;
assign ack10_0 = ack11;
// node:11 join srl
// join:2, fork:1
assign req12 = req11_0 & req4_0;
assign ack11_0 = ack12 & req4_0;
assign ack4_0 = ack12 & req11_0;
// node:12 join reciprocalSat
// join:1, fork:1
assign req13 = req12_0;
assign ack12_0 = ack13;
// node:13 initiator
assign i_13_req = req13_0;
assign ack13_0 = i_13_ack;
endmodule // reciprocal_ctrl
