<%
    const range = require('lodash.range');
    const dim = (n) => `[${n - 1}:0]`;
    const slice = (n, offset) => {
        if (offset) {
            return `[${n + offset - 1}:${offset}]`;
        }
        return `[${n - 1}:0]`;
    };
%>

module cfg_ctrl_${local.join('_')} (
<% range(local[0]).map(index => { %>
    input        t_${index}_req,
    output       t_${index}_ack,
<% }) %>
<% range(local[1]).map(index => { %>
    output       i_${index}_req,
    input        i_${index}_ack,
<% }) %>
    input clk, reset_n
);

endmodule
