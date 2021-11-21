VFLAGS= -Wall -g2012

all: sim

.PHONY: sim program clean
sim:
	iverilog $(VFLAGS) MDIOulator_tb.v MDIOulator_top.v
	./a.out

program:
	openocd \
	-f /usr/share/openocd/scripts/interface/altera-usb-blaster.cfg \
	-f /usr/share/openocd/scripts/cpld/xilinx-xc6s.cfg \
	-c "init; xc6s_program xc6s.tap; pld load 0 ./synth/RGMIIulator_top.bit ; exit"

clean:
	rm *.vcd a.out

