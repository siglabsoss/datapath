'use strict';

module.exports = {
    top: 'datapath',
    topFile: 'datapath.v',
    clk: 'clk',
    'reset_n': 'reset_n',
    targets: [
        {
            data: 't_k8_dat',
            valid: 't_k8_req',
            ready: 't_k8_ack',
            width: 1024,
            length: 1024
        },
        {
            data: 't_k9_dat',
            valid: 't_k9_req',
            ready: 't_k9_ack',
            width: 1024,
            length: 1024
        },
        {
            data: 't_k14_dat',
            valid: 't_k14_req',
            ready: 't_k14_ack',
            width: 1024,
            length: 1024
        }
    ],
    initiators: [
        {
            data: 'i_k1_dat',
            valid: 'i_k1_req',
            ready: 'i_k1_ack',
            width: 1024,
            length: 1024
        }
    ]
};
