-------------------------------------------------------------------------------
--! @file      blinkylight_uvvm_pkg.vhd
--! @author    Michael Wurm <wurm.michael95@gmail.com>
--! @copyright 2017-2019 Michael Wurm
--! @brief     BlinkyLight UVVM package for global testbench defines.
-------------------------------------------------------------------------------

library blinkylightlib;
use blinkylightlib.blinkylight_pkg.all;

package blinkylight_uvvm_pkg is
  -----------------------------------------------------------------------------
  --! @name Types and Constants
  -----------------------------------------------------------------------------
  --! @{

  --! Log verbosity
  constant VERBOSE : boolean := false;

  --! Message scopes
  constant INFO    : string := "BL-INFO";
  constant DEBUG   : string := "BL-DEBUG";
  constant TB_HW   : string := "BL-HW";
  constant TB_REG  : string := "BL-REGS";
  constant TB_LED  : string := "BL-LED";

  --! GPIO VVC instance numbers
  constant LEDS_VVC_INST : natural := 1;

  --! Log files
  constant LOG_ALL_FILE    : string := "../log/uvvm_log_latest_run.log";
  constant LOG_ALERTS_FILE : string := "../log/uvvm_log_alerts_latest_run.log";

--! @}
end package blinkylight_uvvm_pkg;

package body blinkylight_uvvm_pkg is
end package body blinkylight_uvvm_pkg;
