<%
    const range = require('lodash').range;

    const dim = (n) => `[${n - 1}:0]`;

    const slice = (n, offset) => {
        if (offset) {
            return `[${n + offset - 1}:${offset}]`;
        }
        return `[${n - 1}:0]`;
    };


    const radix = 1;
    const perChunk = 2 * radix;
    const chunkW = perChunk * 16;

    const targets = obj.local[0];
    const initiators = obj.local[1];

    const maxChunks = targets - 1;

    const chunks = 2 * maxChunks;
    const narrowWidth = chunkW;
    const wideWidth = chunks * narrowWidth;

    const steps = Math.log2(chunks);
%>

// ${maxChunks}

module defunnel_dat_${local.join('_')} (
<% range(maxChunks).map(index => { %>
    input        ${ dim(narrowWidth) } t_${index}_dat,<% }) %>
    input        ${ dim(8) } t_cfg_dat, // config
    output       ${ dim(wideWidth) } i_0_dat,
    input        ${ dim(chunks) } enable,
    output       ${ dim(8) } mode,
    input clk, reset_n
);

assign mode = t_cfg_dat;

wire ${ dim(steps) } reduct; assign reduct = mode${ dim(steps) };

// form reduct  sel
// 4:8  4       011
// 2:8  2       001
// 1:8  1       000

wire ${ dim(steps) } sel; assign sel = reduct - ${ steps }'b1;

<%
    [0]
        .map(layer => {
            range(chunks)
                .map(subset => {
%>
wire ${ dim(chunkW) } dat${layer}_${subset}; assign dat${layer}_${subset} = ${
                    (subset >= maxChunks) ? 0 : 't_' + subset + '_dat' };<%
                })
        })
%>

<%
    range(steps)
        .map(layer => {
            range(chunks)
                .map(subset => {
%>
wire ${ dim(chunkW) } dat${layer + 1}_${subset}; assign dat${layer + 1}_${subset} = ${
                ((subset >> layer) === 1)
                    ? 'sel[' + layer + '] ? ' +
                        'dat' + layer + '_' + subset +
                        ' : ' +
                        'dat' + layer + '_' + (subset - (1 << layer))
                    : 'dat' + layer + '_' + subset

};<%
            })
        })
%>


// final flops
<% range(chunks).map(i => { %>
reg ${ dim(chunkW) } dat${i}; always @(posedge clk) if (enable[${i}]) dat${i} <= dat${steps}_${i};<% }) %>
//

// final concatination
assign i_0_dat = {${ range(chunks).reverse().map(i => 'dat' + i).join(', ') }};

endmodule
