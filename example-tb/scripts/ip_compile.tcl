#-------------------------------------------------------------------------------
# file:      ip_compile.tcl
# author:    Michael Wurm <wurm.michael95@gmail.com>
# copyright: 2017-2020 Michael Wurm
# brief:     Compiles IP files into respective work libraries.
#-------------------------------------------------------------------------------

transcript quietly
onerror {quit -f}
onbreak {quit -f}

# Set compiler flags
set param "-fsmverbose btw"
set vhdl_version "-2008"

# Create and map work library
set work_lib "blinkylightlib"
vlib $work_lib
vmap $work_lib $work_lib

set ipsrc ip_compile_order.txt

# Compile all files
if {[file isfile $ipsrc]} {
    set fp [open $ipsrc r]
    while {[gets $fp line] >= 0} {
        scan $line "%s" filename
        echo $line
        echo $filename
        if {[string match "*.vhd" $filename]} {
            vcom $param $vhdl_version -work $work_lib $root_dir/$filename
        }
    }
}

quit -f
