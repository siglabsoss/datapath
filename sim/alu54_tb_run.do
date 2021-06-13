vlog ../rtl/alu54b_wrapper.v
vlog ./alu54b_wrapper_tb.v

vsim -novopt work.alu54b_wrapper_tb -L ecp5u -suppress 3009

run 0

log -r /*

run -a
