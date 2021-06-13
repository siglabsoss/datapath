vlog ./muladdsub.v
vlog ./muladdsub_tb.v

vsim -novopt work.muladdsub_tb -L ecp5u -suppress 3009

run 0

log -r /*

add wave -position insertpoint  \
sim:/muladdsub_tb/muladdsub_inst/CLK0 \
sim:/muladdsub_tb/muladdsub_inst/CE0 \
sim:/muladdsub_tb/muladdsub_inst/CE1 \
sim:/muladdsub_tb/muladdsub_inst/CE2 \
sim:/muladdsub_tb/muladdsub_inst/RST0 \
sim:/muladdsub_tb/muladdsub_inst/ADDNSUB \
sim:/muladdsub_tb/muladdsub_inst/A0 \
sim:/muladdsub_tb/muladdsub_inst/A1 \
sim:/muladdsub_tb/muladdsub_inst/B0 \
sim:/muladdsub_tb/muladdsub_inst/B1 \
sim:/muladdsub_tb/muladdsub_inst/SUM

do wave.do

run -a
