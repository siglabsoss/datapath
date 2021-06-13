Mapping to the target technology.

## Lattice ECP5

### sysDSP slice

  * 2 18-bit pre-adders (+-)
  * 2 18-bit multipliers (*)
  * 1 54-bit post-adder (+-)

http://www.latticesemi.com/~/media/LatticeSemi/Documents/ApplicationNotes/EH/TN1267.pdf

Examples of Verilog code that infer sysDSP resources.

  * mul18 -> MULT18X18D
  * mul18_add36 -> 2x MULT18X18D; ALU54B
  * add18_mul18 -> PRADD18A; MULT18X18D
  * cmul18 -> complex multiplier (39 per FPGA)
  * addsub36 -> real add/sub (774 per FPGA)
