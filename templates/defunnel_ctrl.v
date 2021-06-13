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

module defunnel_ctrl_${local.join('_')} (

<% range(maxChunks).map(index => { %>
    input        t_${index}_req,
    output       t_${index}_ack,
<% }) %>
    input        t_cfg_req,
    output       t_cfg_ack,
<% [0].map(index => { %>
    output       i_${index}_req,
    input        i_${index}_ack,
<% }) %>
    output       ${ dim(8) } enable,
    input        ${ dim(8) } mode,
    input clk, reset_n
);

wire ${ dim(steps) } reduct; assign reduct = mode${ dim(steps) };

wire t_req; assign t_req = (<%  range(steps).map(index => { %>
    reduct[${index}] ? (<%= range(1 << index).map(j => `t_${j}_req`).join(' & ') %>) :<% }); %>
    1'b0
);

reg ${ dim(chunks) } valid;
wire ${ dim(chunks) } valid_nxt; // data valid bit

wire t_ack; assign t_ack = i_0_ack | (~&valid);

wire progress; assign progress = t_req & ((~&valid) | (&valid & i_0_ack));

reg ${ dim(steps) } state;
wire ${ dim(steps) } state_nxt; assign state_nxt = state + reduct;

assign valid_nxt = ((i_0_ack & (state === 'b0)) ? ${chunks}'b0 : valid) | enable${ dim(chunks) };

always @(posedge clk or negedge reset_n)
    if (~reset_n)      state <= ${ steps }'b0;
    else if (progress) state <= state_nxt;

always @(posedge clk or negedge reset_n)
    if (~reset_n) valid <= ${chunks}'b0;
    else          valid <= valid_nxt;


assign enable = {${chunks}{progress}} & (<%  range(steps).map(index => { %>
    reduct[${index}] ? (${ 1 << index }'b${ '1'.repeat(index + 1) } << state):<% }); %>
    1'b0
);

<% range(maxChunks).map(index => { %>
assign t_${index}_ack = t_req & (<%
    range(steps).reverse().some(step => {
        if ((index >> step) & 1) { return 1; }
%>
    reduct[${ step }] ? t_ack :<% }) %>
    1'b1
);
<% }); %>

assign t_cfg_ack = 1'b1;

assign i_0_req = &valid;

endmodule
