#-------------------------------------------------------------------------------
# file:      uvvm_compile.tcl
# author:    Michael Wurm <wurm.michael95@gmail.com>
# copyright: 2017-2020 Michael Wurm
# brief:     Compiles UVVM components.
#------------------------------------------------------------------------------

transcript quietly
onerror {quit -f}
onbreak {quit -f}

# Set compiler flags
#set vhdl_version "-2008"

# Create and map work library
set work_lib "uvvmlib"
vlib $work_lib
vmap $work_lib $work_lib

set uvvm_dir "../../../UVVM"
set target_path [pwd]

set parts_list [list "uvvm_util" \
                     "uvvm_vvc_framework" \
                     "bitvis_vip_scoreboard" \
                     "bitvis_vip_avalon_mm" \
                     "bitvis_vip_axilite" \
                     "bitvis_vip_gpio" \
                     "xConstrRandFuncCov"]

foreach uvvm_part $parts_list {
  set util_part_path $uvvm_dir/$uvvm_part
  do $util_part_path/script/compile_src.do $util_part_path $target_path
}

quit -f
