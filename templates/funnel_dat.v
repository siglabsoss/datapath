<%
    const range = require('lodash.range');

    const dim = (n) => `[${n - 1}:0]`;

    const slice = (n, offset) => {
        if (offset) {
            return `[${n + offset - 1}:${offset}]`;
        }
        return `[${n - 1}:0]`;
    };


    const radix = 4;
    const chunkW = radix * 2 * 16;

    const targets = obj.local[0];
    const initiators = obj.local[1];

    const chunks = 2 * initiators;
    const narrowWidth = chunkW;
    const wideWidth = chunks * narrowWidth;

    const steps = Math.log2(chunks);
%>

module funnel_dat_${local.join('_')} (
    input        ${ dim(wideWidth) } t_0_dat,
    input        ${ dim(8) } t_cfg_dat, // config
<% range(initiators).map(index => { %>
    output       ${ dim(narrowWidth) } i_${index}_dat,<% }) %>
    input        ${ dim(8) } sel,
    output       ${ dim(8) } mode,
    input clk, reset_n
);

// controller
assign mode = t_cfg_dat;

// initial assignment
<%
    range(chunks).map(column => {
%>
wire ${ dim(chunkW) } dat0_${column}; assign dat0_${column} = t_0_dat${ slice(chunkW, column * chunkW) };<%
    })
%>

<%
    range(steps).map(layer => {
        const subset = chunks >> (layer + 1);
        range(subset).map(column => {
%>
wire ${ dim(chunkW) } dat${layer + 1}_${column}; assign dat${layer + 1}_${column} = sel[${ layer }] ? dat${layer}_${column + subset} : dat${layer}_${column};<%
        if (column >= (subset / 2)) { %> assign i_${column}_dat = dat${layer + 1}_${column};<%
            }
        })
    })
%>

assign i_0_dat = dat${steps}_0;

endmodule
