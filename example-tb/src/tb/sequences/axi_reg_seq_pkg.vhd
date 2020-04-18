-------------------------------------------------------------------------------
--! @file      axi_reg_seq_pkg.vhd
--! @author    Michael Wurm <wurm.michael95@gmail.com>
--! @copyright 2017-2020 Michael Wurm
--! @brief     BlinkyLight AXI register test sequence.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library blinkylightlib;
use blinkylightlib.blinkylight_pkg.all;

library testbenchlib;
use testbenchlib.blinkylight_uvvm_pkg.all;

library uvvm_util;
context uvvm_util.uvvm_util_context;

library uvvm_vvc_framework;
use uvvm_vvc_framework.ti_vvc_framework_support_pkg.all;

library bitvis_vip_axilite;
use bitvis_vip_axilite.vvc_methods_pkg.all;
use bitvis_vip_axilite.td_vvc_framework_common_methods_pkg.all;
use bitvis_vip_axilite.td_target_support_pkg.all;

library bitvis_vip_scoreboard;
use bitvis_vip_scoreboard.slv_sb_pkg.all;


--! @brief Package declaration of axi_reg_seq_pkg
--! @details
--! The BlinkyLight AXI registers test sequence.

package axi_reg_seq_pkg is

  -----------------------------------------------------------------------------
  -- Procedures
  -----------------------------------------------------------------------------
  --! @{

  procedure blinkylight_axi_reg_seq (
    signal start_i   : in    boolean;
    signal axi_vvc_i : inout t_vvc_target_record);

  --! @}

end package axi_reg_seq_pkg;


package body axi_reg_seq_pkg is

  procedure blinkylight_axi_reg_seq (
    signal start_i   : in    boolean;
    signal axi_vvc_i : inout t_vvc_target_record) is

    variable wr_data_v : std_logic_vector(31 downto 0);
    variable addr      : unsigned(31 downto 0);
  begin

    await_value(start_i, true, 0 ns, 10 ns, error, "Wait for AXI_REG_SEQ to enable start.", TB_REG, ID_SEQUENCER);

    log(ID_LOG_HDR, "Check magic number register.", TB_REG);
    ---------------------------------------------------------------------------
    addr := to_unsigned(0, addr'length);
    axilite_check(axi_vvc_i, 1,
                  addr, x"4711ABCD",
                  "Check magic value register");
    await_completion(axi_vvc_i, 1, 2*axi_access_time_c, "Waiting to read magic number reg.");

    -- Demonstrate alert handling (write a read-only register)
    increment_expected_alerts(TB_FAILURE, 1);
    set_alert_stop_limit(TB_FAILURE, 2);
    axilite_write(axi_vvc_i, 1,
                  addr, x"DEADC0DE",
                  "Try to write a read-only register");

    log(ID_LOG_HDR, "Test LED control register.", TB_REG);
    ---------------------------------------------------------------------------
    -- Write
    wr_data_v := x"000000C4";
    addr      := to_unsigned(1 * 4, addr'length);
    axilite_write(axi_vvc_i, 1,
                  addr, wr_data_v,
                  "Writing value to LED control reg.");

    -- Read back
    axilite_check(axi_vvc_i, 1,
                  addr, wr_data_v,
                  "Check data in LED control reg.");
    await_completion(axi_vvc_i, 1, 4*axi_access_time_c, "Waiting to read led control reg.");

    ---------------------------------------------------------------------------
    --
    -- TODO: check the LED output lines
    --
    ---------------------------------------------------------------------------


    log(ID_LOG_HDR, "Apply write-read sequence on registers.", TB_REG);
    ---------------------------------------------------------------------------
    --
    -- TODO: write and read all registers of the memory
    --
    ---------------------------------------------------------------------------


  end procedure blinkylight_axi_reg_seq;

end package body axi_reg_seq_pkg;
