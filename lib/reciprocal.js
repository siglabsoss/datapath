'use strict';
const m = 6;
// const n = 10;
const rs16 = {width: 16, capacity: 1.5, m: 6, n: 10};
const rs32 = {width: 32, capacity: 1};
const s16 = {width: 16};
const bitSelect_s16 = {
    width: 16,
    highSelect: 31 - m,
    lowSelect: 32 - m - 16
};
// const sl_s16 = {width:  16, shiftLeft: 2};
const sub1_s16 = {width: 16, op: '16\'h5dd -'};
const sub2_s16 = {width: 16, op: '16\'h401 -'};
const shift1_s16 = {width: 16, op: '<< 2'};
const s5 = {width: 5};

module.exports = g => t => {

    const dummy_edge = g('=', t)(rs16);
    const lzc = g('lzc', dummy_edge);
    const norm = g('normalize', dummy_edge);

    lzc(s5)(norm, 'lzc');

    const norm_d = norm(s16, 'data');
    const norm_s = norm(s5, 'shift');
    const sub1_d = g('lhsOp', norm_d)(sub1_s16);

    return g('reciprocalSat',
        g('srl',
            g('reciprocalSatShift2',
                g('bitSelect',
                    g('mul',
                        g('lhsOp',
                            g('bitSelect',
                                g('mul',
                                    norm_d,
                                    sub1_d
                                )(rs32)
                            )(bitSelect_s16)
                        )(sub2_s16),
                        sub1_d
                    )(rs32)
                )(bitSelect_s16)
            )(shift1_s16),
            norm_s
        )(rs16)
    )(rs16);
};
