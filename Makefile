all: build verilate compile run show

clean:
	rm hdl/*
	rm -rf obj_dir

build:
	npm run build
	./bin/gen-datapath.js
	npm run redot

verilate:
	verilator \
	-Wno-WIDTH \
	-Wno-PINMISSING \
	--trace \
	-cc \
	-O3 \
	-Ihdl \
	--top-module datapath \
	--exe hdl/tb.cpp \
	hdl/*.v

compile:
	make -j -C obj_dir/ -f Vdatapath.mk Vdatapath

run:
	./obj_dir/Vdatapath

show:
	gtkwave ./datapath.vcd -S hdl/top-wave.tcl &
