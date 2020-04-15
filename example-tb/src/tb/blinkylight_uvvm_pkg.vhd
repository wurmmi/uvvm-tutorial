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
  constant INFO    : string := "BLY-INFO";
  constant DEBUG   : string := "BLY-DEBUG";
  constant TB_DFLT : string := "BLY-SIG-DFLT";
  constant TB_HW   : string := "BLY-HW";
  constant TB_REG  : string := "BLY-REGS";
  constant TB_IRQ  : string := "BLY-IRQ";
  constant TB_LED  : string := "BLY-LED";

  --! GPIO VVC instance numbers
  constant KEYS_VVC_INST : natural := 1;
  constant SWIT_VVC_INST : natural := 2;
  constant LEDS_VVC_INST : natural := 3;

  --! Log files
  constant LOG_ALL_FILE    : string := "../log/uvvm_log_latest_run.log";
  constant LOG_ALERTS_FILE : string := "../log/uvvm_log_alerts_latest_run.log";

--! @}
end package blinkylight_uvvm_pkg;

package body blinkylight_uvvm_pkg is
end package body blinkylight_uvvm_pkg;
