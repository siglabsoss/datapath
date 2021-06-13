#!/usr/bin/env node
'use strict';

const reciprocal = (a) => {
    const b = 1.466 - a;
    console.log("b: " + b);
    const c = a * b;
    console.log("c: " + c);
    const d = 1.0012 - c;
    console.log("d: " + d);
    const e = d * b;
    console.log("e: " + e);
  return e * 4;
}

const normalize = (val) => {
    let shift = 0;
    [3, 2, 1].map(s => {
        if (val > Math.pow(2, s - 1)) {
            shift += s;
            val /= Math.pow(2, s);
        }  
    });
    return {
        val: val,
        shift: shift
    };
}

const reciprocal2 = val => {
    const a = val;
    const b = normalize(a);
    console.log("norm: " + b.val + " shift: " + b.shift);
    const c = reciprocal(b.val);
    console.log("reciprocal: " + c);
    const d = c / (1 << b.shift);
    return d;
}

console.log("inv: " + reciprocal2(1.48315429688));
console.log("inv: " + reciprocal2(1.62066650391));
