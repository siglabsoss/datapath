'use strict';

const radix4genGen = require('./radix4');
const cmulGenGen = require('./cmul');
const range = require('lodash').range;
const reciprocalGenGen = require('./reciprocal');

// const range = require('lodash.range');

// const nSlices = 4;
// const s16 = {width: 16};
const rs16 = {width: 16, capacity: 1};
// const rs16_15 = {width: 16, capacity: 1.5};
const s18 = {width: 18};
// const rs18 = {width: 18, capacity: 1};
// const s36 = {width: 36};
// const rs36 = {width: 36, capacity: 1};
// const s36 = {width: 36};
// const s4 = {width: 4};
// const rs8 = {width: 8, capacity: 1};
const rs8_0 = {width: 8, capacity: 0};
const rs20 = {width: 20, capacity: 1.5};
// const kw = {width: 32 * 32};
// const rs72 = {width: 72, capacity: 1};

module.exports = function (g, params) {
    params = params || {};
    const nSlices = params.nSlices || 16;
    const nSections = params.nSections || 2;
    const hasReciprocal = params.hasReciprocal || false;
    const radix = 4;

    const cmulGen = cmulGenGen(g);
    const reciprocalGen = reciprocalGenGen(g);

    const rkw = {width: nSlices * 32, capacity: 1.5};

    return function (dpTargets) {

        // const k1 = g('k1');
        // const k2 = g();
        // const k10 = g();
        // const k11 = g();
        const k14 = dpTargets.k14;

        const iport8 = g('funnel', dpTargets.k8);
        const iport9 = g('funnel', dpTargets.k9);
        const oport1 = g('defunnel');
        const cfg = g('deconcat');

        const k1 = oport1(rkw);

        const radix4gen = radix4genGen(g, {width: 36, capacity: 1}, cfg);

        let e2 = [];
        range(nSections)
            .map((secname, secidx) => range(radix)
                .map((subname, subidx) => {
                    const iport8chunk = g('slice16', iport8({width: 2 * 16, capacity: 1}));
                    const iport9chunk = g('slice16', iport9({width: 2 * 16, capacity: 1}));

                    const e0 = {re: iport8chunk(s18), im: iport8chunk(s18)};
                    const e1 = {re: iport9chunk(s18), im: iport9chunk(s18)};
                    if (hasReciprocal && (secidx === 0) && ((subidx & 2) === 0)) {
                        e2.push(e1.re);
                        e2.push(e1.im);
                        return [e0, e1, reciprocalGen(e2.shift()), cfg];
                    }
                    return [e0, e1, 1, cfg];
                })
                .map(cmulGen)
            )
            .map(radix4gen)
            .map(e => e.map(ee => {
                const oport1chunk = g('concat');
                oport1chunk({width: 2 * 16})(oport1);

                const node = {
                    re: g('bs', ee.re),
                    im: g('bs', ee.im)
                };

                cfg(rs8_0)(node.re, 'cfg');
                cfg(rs8_0)(node.im, 'cfg');

                const node1 = {
                    re: g('round_sat', node.re(rs20)),
                    im: g('round_sat', node.im(rs20))
                };

                node1.re(rs16)(oport1chunk);
                node1.im(rs16)(oport1chunk);

                ee.re = oport1chunk;
                ee.im = oport1chunk;
            }));

        k14(cfg);
        cfg(rs8_0)(iport8, 'cfg');
        cfg(rs8_0)(iport9, 'cfg');
        cfg(rs8_0)(oport1, 'cfg');

        return {
            k1: k1
        };
    };
};
