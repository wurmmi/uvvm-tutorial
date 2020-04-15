-------------------------------------------------------------------------------
--! @file      blinkylight_axi_reg_seq_pkg.vhd
--! @author    Michael Wurm <wurm.michael95@gmail.com>
--! @copyright 2017-2019 Michael Wurm
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


--! @brief Package declaration of blinkylight_axi_reg_seq_pkg
--! @details
--! The BlinkyLight AXI registers test sequence.

package blinkylight_axi_reg_seq_pkg is

  -----------------------------------------------------------------------------
  -- Procedures
  -----------------------------------------------------------------------------
  --! @{

  procedure blinkylight_axi_reg_seq (
    signal start_i    : in    boolean;
    signal axi_vvc_i  : inout t_vvc_target_record;
    variable axi_sb_i : inout t_generic_sb);

  --! @}

end package blinkylight_axi_reg_seq_pkg;


package body blinkylight_axi_reg_seq_pkg is

  procedure blinkylight_axi_reg_seq (
    signal start_i    : in    boolean;
    signal axi_vvc_i  : inout t_vvc_target_record;
    variable axi_sb_i : inout t_generic_sb) is

    variable wr_data_v : std_logic_vector(31 downto 0);
    variable addr      : unsigned(31 downto 0);
  begin

    await_value(start_i, true, 0 ns, 10 ns, error, "Wait for AXI_REG_SEQ to enable start.", TB_REG, ID_SEQUENCER);

    log(ID_LOG_HDR, "Check macic number register.", TB_REG);
    ---------------------------------------------------------------------------
    axilite_check(axi_vvc_i, 1,
                  to_unsigned(0, wr_data_v'length), x"4711ABCD",
                  "Check magic value register");
    await_completion(axi_vvc_i, 1, 2*axi_access_time_c, "Waiting to read magic number reg.");

    log(ID_LOG_HDR, "Test LED control register.", TB_REG);
    ---------------------------------------------------------------------------
    -- Write
    wr_data_v := x"000000C4";
    axilite_write(axi_vvc_i, 1,
                  to_unsigned(1*4, wr_data_v'length), wr_data_v,
                  "Writing value to LED control reg.");

    -- Read back
    axilite_check(axi_vvc_i, 1,
                  to_unsigned(1*4, wr_data_v'length), wr_data_v,
                  "Check data in LED control reg.");
    await_completion(axi_vvc_i, 1, 4*axi_access_time_c, "Waiting to read led control reg.");


    log(ID_LOG_HDR, "Apply write-read sequence on registers.", TB_REG);
    ---------------------------------------------------------------------------
    for i in 2 to num_registers_c - 1 loop
      -- memory uses word addresses
      addr      := to_unsigned(i * 4, addr'length);
      -- Write
      wr_data_v := std_logic_vector(addr);
      axilite_write(axi_vvc_i, 1,
                    addr, wr_data_v,
                    "Writing data to reg addr " & integer'image(to_integer(addr)));

      -- Read back
      axilite_check(axi_vvc_i, 1,
                    addr, wr_data_v,
                    "Check data in reg addr " & integer'image(to_integer(addr)));
    end loop;

    await_completion(axi_vvc_i, 1, num_registers_c*3 * axi_access_time_c, "Waiting for write-read sequence.");
  end procedure blinkylight_axi_reg_seq;

end package body blinkylight_axi_reg_seq_pkg;
