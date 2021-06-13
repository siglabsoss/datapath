'use strict';

exports.ctrl = p => `// node: ${p.id} muladdsub
reg[3:0] cfg_valid_${p.id};

always @(posedge clk) cfg_valid_${p.id} <= {cfg_valid_${p.id}[2:0],req${p.t[1]}};

assign ack${p.t[1]}=1'b1;

//stage 1
reg req${p.i[0]}_s1_r;
wire req${p.i[0]}_s1,ack${p.i[0]}_s1;

assign req${p.i[0]}_s1 = req${p.i[0]}_s1_r;
assign n${p.id}s1_en = req${p.t[0]} & ack${p.t[0]} | cfg_valid_${p.id}[3];
assign ack${p.t[0]} = ~req${p.i[0]}_s1_r | ack${p.i[0]}_s1;
always @(posedge clk or negedge reset_n) if(~reset_n) req${p.i[0]}_s1_r <= 1'b0; else req${p.i[0]}_s1_r <= ~ack${p.t[0]} | req${p.t[0]};

//stage 2
reg req${p.i[0]}_s2_r;
wire req${p.i[0]}_s2,ack${p.i[0]}_s2;

assign req${p.i[0]}_s2 = req${p.i[0]}_s2_r;
assign n${p.id}s2_en = req${p.i[0]}_s1 & ack${p.i[0]}_s1 | cfg_valid_${p.id}[3];
assign ack${p.i[0]}_s1 = ~req${p.i[0]}_s2_r | ack${p.i[0]}_s2;
always @(posedge clk or negedge reset_n) if(~reset_n) req${p.i[0]}_s2_r <= 1'b0; else req${p.i[0]}_s2_r <= ~ack${p.i[0]}_s1 | req${p.i[0]}_s1;

//stage 3
reg req${p.i[0]}_s3_r;

assign req${p.i[0]} = req${p.i[0]}_s3_r;
assign n${p.id}s3_en = req${p.i[0]}_s2 & ack${p.i[0]}_s2 | cfg_valid_${p.id}[3];
assign ack${p.i[0]}_s2 = ~req${p.i[0]}_s3_r | ack${p.i[0]};
always @(posedge clk or negedge reset_n) if(~reset_n) req${p.i[0]}_s3_r <= 1'b0; else req${p.i[0]}_s3_r <= ~ack${p.i[0]}_s2 | req${p.i[0]}_s2;
`;

exports.data = p => {
    const width = p.t[0].width;
    const a0 = `n${p.id}_a0`;
    const b0 = `n${p.id}_a1`;
    const a1 = `n${p.id}_b0`;
    const b1 = `n${p.id}_b1`;

    return `
wire n${p.id}s1_en;
wire n${p.id}s2_en;
wire n${p.id}s3_en;

wire [${width / 4 - 1}:0] ${a0}, ${a1}, ${b0}, ${b1};
assign {${b1}, ${a1}, ${b0}, ${a0}} = ${p.t[0].wire};

reg[3:0] addsub_shiftreg_${p.id};
reg[3:0] addsub_detect_${p.id};

wire n${p.id}s1_ce;
wire n${p.id}s2_ce;
wire n${p.id}s3_ce;

always @(posedge clk) addsub_shiftreg_${p.id}<={addsub_shiftreg_${p.id}[2:0],${p.t[1].wire}[0]};
always @(posedge clk)
if(addsub_shiftreg_${p.id}[3]^addsub_shiftreg_${p.id}[2]) addsub_detect_${p.id}<=4'hF;
else addsub_detect_${p.id} <=addsub_detect_${p.id}>>1;

assign n${p.id}s1_ce=n${p.id}s1_en|addsub_detect_${p.id}[0];
assign n${p.id}s2_ce=n${p.id}s2_en|addsub_detect_${p.id}[0];
assign n${p.id}s3_ce=n${p.id}s3_en|addsub_detect_${p.id}[0];

muladdsub muladdsub${p.id} (
    .CLK0(clk),
    .RST0(~reset_n),
    .CE0(n${p.id}s1_en),
    .CE1(n${p.id}s2_en),
    .CE2(n${p.id}s3_en),
    .ADDNSUB(${p.t[1].wire}[0]),
    .A0(${a0}),
    .A1(${a1}),
    .B0(${b0}),
    .B1(${b1}),
    .SUM(${p.i[0].wire})
);
`;
};

exports.ctrl2data = p => [
    ['ene1', 'n' + p.id + 's1_en', 1],
    ['ene2', 'n' + p.id + 's2_en', 1],
    ['ene3', 'n' + p.id + 's3_en', 1]
];
