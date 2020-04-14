#-------------------------------------------------------------------------------
# file:      sim.tcl
# author:    Michael Wurm <wurm.michael95@gmail.com>
# copyright: 2017-2020 Michael Wurm
# brief:     Compiles and simulates testbench.
#-------------------------------------------------------------------------------

transcript quietly
onerror {quit -f}
onbreak {quit -f}

do tb_compile.tcl

quit -f
