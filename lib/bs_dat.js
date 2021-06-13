'use strict';

const range = require('lodash.range');

const dim = (n) => `[${n - 1}:0]`;

const iw = 36;
const ow = 16;

module.exports = obj => {
    return `
module bs_dat_${obj.local.join('_')} (
    input       ${ dim(iw) } t_0_dat,
    input       [7:0] t_cfg_dat,
    output wire ${ dim(ow + 4) } i_0_dat,
    input clk, reset_n
);

// Data processing
wire ${ dim(ow) } shift_data;   // shifted data
reg         pre_sat;      // preliminary saturation detection
reg         round_flag;   // rounding detection

wire  t_0_dat_sign;
assign t_0_dat_sign = t_0_dat[${ iw - 1 }];

wire  negative_flag; // if the number is negative and the saturation is positive
assign negative_flag = t_cfg_dat[6] & t_0_dat_sign;

assign shift_data = $signed(t_0_dat) >> t_cfg_dat[5:0];

always @*
    casez(t_cfg_dat[5:0])
${ range(iw - ow).map(i =>
        `        ${i}    : pre_sat = ( ((t_0_dat[${iw - 1}:${15 + i}] == 0) || (t_0_dat[${iw - 1}:${15 + i}] == {${21 - i}{1'b1}})) ? 1'b0 : 1'b1 );`
).join('\n')
}
        20-39 : pre_sat = 1'b0; // No saturation is possible becase of most significant part is in use
        default pre_sat = 1'bx; // Incorrect/unsupported control value
    endcase

// Rounding detection
always @*
    casez(t_cfg_dat[5:0])
        0     : round_flag = 1'b0;
${ range(iw - 2).map(i =>
        `        ${i + 1}     : round_flag = t_0_dat[${i}];`
).join('\n')
}
        35    : round_flag = 1'b0;
        default round_flag = 1'bx; // Incorrect/unsupported control value
    endcase

   assign i_0_dat = {negative_flag, pre_sat, round_flag, t_0_dat_sign, shift_data};

endmodule
`;
};
