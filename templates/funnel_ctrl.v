<%
    const range = require('lodash').range;

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
    const initiatorWidth = chunkW;
    const targetWidth = chunks * initiatorWidth;

    const steps = Math.log2(chunks);
%>

module funnel_ctrl_${local.join('_')} (
    input        t_0_req,
    output       t_0_ack,
    input        t_cfg_req,
    output       t_cfg_ack,
<% range(initiators).map(index => { %>
    output       i_${index}_req,
    input        i_${index}_ack,
<% }) %>
    output       ${ dim(8) } sel,
    input        ${ dim(8) } mode,
    input clk, reset_n
);

// 8:4
// reduct   state    sel    req0    req1    req2    req3
// 4        0        000    req     req     req     req
// 4        4        001    req     req     req     req

// 8:2
// reduct   state    sel    req0    req1    req2    req3
// 2        0        000    req     req     0       0
// 2        2        010    req     req     0       0
// 2        4        001    req     req     0       0
// 2        6        011    req     req     0       0

// 8:1
// reduct   state    sel    req0    req1    req2    req3
// 1        0        000    req     0       0       0
// 1        1        100    req     0       0       0
// 1        2        010    req     0       0       0
// 1        3        110    req     0       0       0
// 1        4        001    req     0       0       0
// 1        5        101    req     0       0       0
// 1        6        011    req     0       0       0
// 1        7        111    req     0       0       0

wire ${ dim(steps) } reduct; assign reduct = mode${ dim(steps) };

wire progress; assign progress = (<%  range(steps).map(index => { %>
    reduct[${index}] ? (t_0_req & <%= range(1 << index).map(j => `i_${j}_ack`).join(' & ') %>) :<% }); %>
    1'b0
);

reg ${ dim(steps) } state;
wire ${ dim(steps) } state_nxt; assign state_nxt = state + reduct;

always @(posedge clk or negedge reset_n)
    if (~reset_n)      state <= ${ steps }'b0;
    else if (progress) state <= state_nxt;

wire last; assign last = (state_nxt == ${ steps }'b0);

assign t_0_ack = last & (<%  range(steps).map(index => { %>
    reduct[${index}] ? (<%= range(1 << index).map(j => `i_${j}_ack`).join(' & ') %>) :<% }); %>
    1'b0
);

assign sel = {<%= range(steps).map(index => `state[${index}]`).join(', ') %>}; // reverse order

<%
    range(initiators).map(index => {
        let reduct = [];
        range(steps).reverse().map(i => (index >>> i) & 1).some((bit, i) => {
            if (bit === 0) reduct.push(steps - i - 1);
            return bit;
        });
%>
assign i_${index}_req = t_0_req & <%= reduct.map(index => `reduct[${index}]`).join(' | ') %>;<% }); %>

assign t_cfg_ack = 1'b1;

endmodule
