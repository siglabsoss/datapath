## Introduction

The elastic, reconfigurable data path (**datapath**) is an RTL block that
contains array of computational resources (**units**) and the mechanism to
connect these resources (**configure**) to perform certain algorithm.

### Design Time

The **datapath** comes as the software tool at design time. Many parameters need
to be defined in design time in order achieve required computational
performance, cost and power target. Designer will usually pass following steps:

  * analyse the application domain to predict required set of computational resources;
  * choose the appropriate memory bandwidth;
  * choose the appropriate set of *units* from the library or introduce new
units if needed;
  * specify the appropriate set of interconnection resources between the units.

Constructed *datapath* can be used as a general purpose processor but will give
extra performance on execution of application specific tasks. The flexibility,
applicability and efficiency of any particular construction will be defined in
design time.

### Run Time

The constructed *datapath* has limited hardware resources but flexible enough to
be used for execution of multiple different tasks. Some parameters of array are
under software control and can be dynamically changed in run-time:

  * number of *units* enabled out of total available amount;
  * operation executed on each *units*;
  * the topology of interconnect between units;

## Theory of operation

The operation of **datapath** based on main principles of systolic array
architecture [Kungt1979systolic]. The construction describe the set of units
witch will be configured.

First incoming data stream is available in one of input data port. The units
connected to this port start fetching data in the configured sequence. The
result goes to the next unit in the pipeline. Finally the result goes to the
output port.

One of the many advantages of this approach is that each input data item can be
used a number of times once it is accessed, and thus, a high computational
throughput can be achieved with only modest memory bandwidth.

Other advantages include modular expandability, reconfigurability, regular data
and control flow, use of simple and uniform cells.

### Data path configuration

Each particular configuration of the data path can be represented in form of
data flow graph (DFG).

## Node types

Any *datapath* constructed in design time consist of fixed number of **nodes**
and **edges** between them. Besides this the behaviour and functionality of the
data path can be reconfigured by rerouting the way how data flows through
*datapath* and changing the opcodes of functional units.

## Usage

Tools to generate elastic reconfigurable data path.
Used by the [Q-engine](https://github.com/siglabs/q-engine)

## Testing

```
npm i
npm test
./bin/mifgen.js
cd hdl
cp ../src/project.js .
./veritb gen
make verilate
make compile
make run
make show
```
