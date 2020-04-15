#-------------------------------------------------------------------------------
# file:      Makefile
# author:    Michael Wurm <wurm.michael95@gmail.com>
# copyright: 2017-2020 Michael Wurm
# brief:     Makefile for SomeMemory Testench.
#-------------------------------------------------------------------------------

fail_on_error = \
	!(grep -q "\*\* Error" ./build/log/$1.log); \
	!(grep -q "\*\* Fatal" ./build/log/$1.log);

create_build_dirs = \
	mkdir -p ./build/sim; \
	mkdir -p ./build/log

##--------------------------------------------------------------------
##Makefile for SomeMemory Testench.
##--------------------------------------------------------------------
##
##Supported Targets
##-----------------

all: uvvm ip test ##	- Default target.

ip: ##			- Compile IP library components.
	@echo "Compiling IP library components..."
	@$(call create_build_dirs)
	@cd ./build/sim && vsim -c -do ../../scripts/compile_ip.tcl 2>&1 | tee ../log/compile_ip.log
	@$(call fail_on_error,compile_ip)

test: ##			- Compile test library components.
	@echo "Running test..."
	@$(call create_build_dirs)
	@cd ./build/sim && vsim -c -do ../../scripts/sim.tcl 2>&1 | tee ../log/sim.log
	@$(call fail_on_error,sim)

uvvm: ##			- Compile UVVM library components.
	@echo "Compiling UVVM library components..."
	@$(call create_build_dirs)
	@cd ./build/sim && vsim -c -do ../../scripts/compile_uvvm.tcl 2>&1 | tee ../log/compile_uvvm.log
	@$(call fail_on_error,compile_uvvm)

format: ##		- Formatting for VHDL code.
	@./scripts/format.sh

clean: ##			- Clean outputs.
	@echo "Cleaning..."
	git clean -xdf

help: ##			- Show this help message.
	@grep -h "##" Makefile | grep -v "\"##\"" | sed -e 's/##//g'

.PHONY: all ip test uvvm format clean help

##
##--------------------------------------------------------------------
##*** NOTE: Makefile requires following setup:
##      - Modelsim (vsim) installed.
##      - Emacs (emacs) installed.
##
##--------------------------------------------------------------------
