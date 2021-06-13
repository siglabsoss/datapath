#!/usr/bin/env node
'use strict';

const path = require('path');
const fs = require('fs-extra');

const templates = require('../templates.js');
const bs_dat = require('../lib/bs_dat.js');

const log2slices = 4;
const slices = 1 << log2slices;
const log2sections = 1;
const sections = 1 << log2sections;

const generators = Object.assign(templates, {
    'bs_dat.v': bs_dat
});

const props = {
    dataWidth: 32,
    narrowWidth: 18,
    wideWidth: 36,
    law: {
        inmux: [1, 2, 7],
        oumux: [8, 9, 10, 11, 14, 15],
        selin: 4,
        selou: 4,
        perin: 5,
        perou: 5,
        baddr: 11,
        k15: 32
    },
    log2slices: log2slices,
    slices: slices,
    sections: sections,
    funnel: {
        minWidth: 4, // 4x18-bit outputs
        maxWidth: 4 * sections, // 16x18-bit outputs
        steps: 3 // 64:4 64:8 64:16
    },
    cfg: [
        8, 8, 8, 8, 8, 8, 8, 8, // bs
        8, 8, 8 // funnel funnel defunnel
    ]
};

const fineGrain = {
    // 'rdp_x_demux.v': [[2], [3], [4], [5], [6], [7], [8], [9], [10]],
    // 'rdp_x_mux.v': [[2], [3], [4], [7], [8], [9]],
    // 'rdp_x_mulc.v': [
    //     ['00', 0.38269043],
    //     ['01', 0.54119873],
    //     ['03', 0.707092285],
    //     ['05', 1.30657959],
    //     ['06', 0.923828125]
    // ],
    'round_sat_dat.v': [[1, 1]],
    'bs_dat.v': [[2, 1]],

    'funnel_dat.v':    [[2, 4], [2, 8], [2, 16]],
    'funnel_ctrl.v':   [[2, 4], [2, 8], [2, 16]],

    'defunnel_dat.v':  [[5, 1], [9, 1], [17, 1]],
    'defunnel_ctrl.v': [[5, 1], [9, 1], [17, 1]]
};

Object.keys(generators).forEach(fileName => {
    const extName = path.extname(fileName);
    const baseName = path.basename(fileName, extName);
    (fineGrain[fileName] || [[]]).forEach(subUnit => {
        const body = generators[fileName](Object.assign({local: subUnit}, props));
        const outPath = path.resolve(process.cwd(), 'hdl', baseName + subUnit.map(e => '_' + e).join('') + extName);
        fs.outputFile(
            outPath,
            body,
            'utf-8',
            function (err) { if (err) { throw err; } }
        );
    });
});
