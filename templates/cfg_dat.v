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

module cfg_dat_${local.join('_')} (
    input        ${ dim(slices * dataWidth) } t_0_dat,
<% cfg.map((width, index) => { %>
    output       ${ dim(width) } i_${index}_dat,
<% }) %>
    input clk, reset_n
);

assign {${ range(cfg.length).map(index => 'i_' + index + '_dat').join(', ') }} = t_0_dat;

endmodule
