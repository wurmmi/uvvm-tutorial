#-------------------------------------------------------------------------------
# file:      sim.tcl
# author:    Michael Wurm <wurm.michael95@gmail.com>
# copyright: 2017-2020 Michael Wurm
# brief:     Compiles and simulates testbench.
#-------------------------------------------------------------------------------

transcript quietly
onerror {quit -f}
onbreak {quit -f}


set start_timestamp [clock format [clock seconds] -format {%m/%d/%Y %I:%M:%S %p}]
puts "\n======================================================================="
puts "Running simulation script ($start_timestamp)."
puts "======================================================================="

# Compile testbench
do tb_compile.tcl

puts "\n-----------------------------------------------------------------------"
puts "Starting simulation."
puts "-----------------------------------------------------------------------"

set log_dir "../log"
set wlf_log_filename "$log_dir/sim_log.wlf"
set sim_log_filename "$log_dir/sim_log.log"

set design "blinkylight_vvc_tb"
set vsim_param ""
set run_time "-all"
set time_unit "ps"
set sim_param ""
set generics ""

set runtime [time [format "vsim %s -novopt -t %s -wlf %s -lib %s -l %s %s %s" $generics $time_unit $wlf_log_filename $work_lib $sim_log_filename $vsim_param $design]]
regexp {\d+} $runtime ct_microsecs
set ct_secs [expr {$ct_microsecs / 1000000.0}]
puts [format "Elaboration time: %.4f sec" $ct_secs]

# Generate waveform
#if {$create_wave == 1} {
#  set wave_expand_param ""
#  if {$wave_expand == 1} {
#    set wave_expand_param "-expand"
#  }
#  source $src_dir/utils/tcl/wave_gen.tcl
#}

# Disable warnings
# set StdArithNoWarnings 1
# set NumericStdNoWarnings 1

# Run
set runtime [time [format "run %s" $run_time]]
regexp {\d+} $runtime ct_microsecs
set ct_secs [expr {$ct_microsecs / 1000000.0}]
puts [format "Simulation time: %s %s" $now $time_unit]
puts [format "Run time: %.4f sec" $ct_secs]


# Set wave time units and zoom
if {[batch_mode] == 0 && $create_wave == 1} {
  configure wave -rowmargin $wave_row_margin -childrowmargin $wave_row_margin -timelineunits $wave_time_unit
  if {$wave_zoom_range == 0} {
    wave zoom full
  } else {
    wave zoom range $wave_zoom_start_time $wave_zoom_end_time
    wave cursor time -time $wave_zoom_start_time
  }
}

quit -f
