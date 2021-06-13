from decimal import Decimal
import math

def toFixed(val, m=2, n=14):
    if val>=2.0:
        return 2**(m+n)-1
    else:
        fixedVal=int(math.floor(val))
        val=val-math.floor(val)
        for i in range(n):
            iVal = 1.0/(2**(i+1))
            if(val >= iVal):
                fixedVal = fixedVal << 1 | 1
                val = val - iVal
            else:
                fixedVal = fixedVal << 1
        return fixedVal

def toFloat(val, m=2, n=14):
    floatVal=(val>>n)*1.0
    val=((2**n)-1)&val
    for i in range(n):
        iVal = 1.0/(2**(i+1))
        if(val>>(n-i-1)&0x1 == 1):
            floatVal = floatVal + iVal
    return floatVal

def testQmn():
    print hex(toFixed(1.466))
    print hex(toFixed(1.0012))
    
    print toFloat(0x2000)
    print toFloat(0x5dd2)
    print toFloat(0x4013)

    print hex(toFixed(toFloat(0x2000)))
    print hex(toFixed(toFloat(0x5dd2)))
    print hex(toFixed(toFloat(0x4013)))

testQmn()
    
with open('t_0_dat.mif') as f:
    tlines = f.read().splitlines()

with open('i_13_dat.mif') as f:
    ilines = f.read().splitlines()
    
t0=[]
for val in tlines:
    t0.append(int(val,16)&0x7FFF)

i0=[]
for val in ilines:
    i0.append(int(val,16)&0x7FFF)
    
t0float=[]
for t in t0:
    t0float.append(toFloat(t))

t0rec=[]
for t in t0float:
    t0rec.append(1.0/t)

t0fixed=[]
for t in t0rec:
    t0fixed.append(toFixed(t))
    
print '--------------t0'
for i in range(len(t0)):
    print "float: " + str(t0float[i]) + " inv float: " + str(t0rec[i]) + " fixed: " + hex(t0fixed[i])

t0calc=[]
print '--------------t0clac'
for t in t0:
    val=t
    shift=0
    if((t>>14)>=4):
        val=val>>3
        shift=3
    if (t>>14)>=2:
        val=val>>2
        shift=shift+2
    if (t>>14)>=1:
        val=val>>1
        shift=shift+1

    print hex(val) + " shift: " + str(shift)
    b=toFixed(1.466)-val
    c=((val*b)>>14)&0xFFFF
    d=toFixed(1.0012)-c
    e=(((d*b)&0xFFFFFFFF)>>14)&0xFFFF
    e1=(e<<2)&0xFFFF
    inv=(e1 >> shift)&0x7FFF
    print "b: " + hex(b) + " c: " + hex(c) + " d: " + hex(d) + " e: "  + hex(e) + " e1: "  + hex(e1) + " inv: " + hex(inv)  + " val: " + str(toFloat(val))

print "norm: " + hex(toFixed(0.810333251955))
print "reciprocal: " + hex(toFixed(1.2323687482420054))
print "inv: " + hex(toFixed(0.616843741210027))
print "b: " + hex(toFixed(0.655666748045))
print "c: " + hex(toFixed(0.5313085681420645))
print "d: " + hex(toFixed(0.4698914318579356))
print "e: " + hex(toFixed(0.30809218706050134))
            
print '--------------i0'
for t in i0:
    print hex(t)

print hex(toFixed(math.pi/4))
print toFloat(0x8e07)*(math.pi/2.0)*(180/math.pi)-180
