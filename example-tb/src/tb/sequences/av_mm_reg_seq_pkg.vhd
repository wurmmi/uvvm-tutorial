-------------------------------------------------------------------------------
--! @file      av_mm_reg_seq_pkg.vhd
--! @author    Michael Wurm <wurm.michael95@gmail.com>
--! @copyright 2017-2020 Michael Wurm
--! @brief     BlinkyLight Avalon MM register test sequence.
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

library bitvis_vip_avalon_mm;
use bitvis_vip_avalon_mm.vvc_methods_pkg.all;
use bitvis_vip_avalon_mm.td_vvc_framework_common_methods_pkg.all;
use bitvis_vip_avalon_mm.td_target_support_pkg.all;

library bitvis_vip_scoreboard;
use bitvis_vip_scoreboard.slv_sb_pkg.all;


--! @brief Package declaration of av_mm_reg_seq_pkg
--! @details
--! The BlinkyLight Avalon MM registers test sequence.

package av_mm_reg_seq_pkg is

  -----------------------------------------------------------------------------
  -- Procedures
  -----------------------------------------------------------------------------
  --! @{

  procedure blinkylight_av_mm_reg_seq (
    signal start_i      : in    boolean;
    signal av_mm_vvc_i  : inout t_vvc_target_record;
    variable av_mm_sb_i : inout t_generic_sb);

  --! @}

end package av_mm_reg_seq_pkg;


package body av_mm_reg_seq_pkg is

  procedure blinkylight_av_mm_reg_seq (
    signal start_i      : in    boolean;
    signal av_mm_vvc_i  : inout t_vvc_target_record;
    variable av_mm_sb_i : inout t_generic_sb) is

    variable wr_data_v : std_logic_vector(31 downto 0);
    variable rd_data_v : bitvis_vip_avalon_mm.vvc_cmd_pkg.t_vvc_result;
    variable addr      : unsigned(31 downto 0);
    variable cmd_idx_v : natural;
  begin
    await_value(start_i, true, 0 ns, 10 ns, error, "Wait for AV_MM_REG_SEQ to enable start.", TB_REG, ID_SEQUENCER);

    log(ID_LOG_HDR, "Check macic number register.", TB_REG);
    ---------------------------------------------------------------------------
    avalon_mm_check(av_mm_vvc_i, 1,
                    to_unsigned(0, wr_data_v'length), x"4711ABCD",
                    "Check magic value register");
    await_completion(av_mm_vvc_i, 1, axi_access_time_c, "Waiting to read magic number reg.");

    log(ID_LOG_HDR, "Test LED control register.", TB_REG);
    ---------------------------------------------------------------------------
    -- memory uses word addresses
    addr      := to_unsigned(1 * 4, addr'length);
    -- Write
    wr_data_v := x"000000C4";
    avalon_mm_write(av_mm_vvc_i, 1,
                    addr, wr_data_v,
                    "Writing value to LED control reg.");

    -- Read back
    avalon_mm_check(av_mm_vvc_i, 1,
                    addr, wr_data_v,
                    "Check data in LED control reg.");
    await_completion(av_mm_vvc_i, 1, 2*axi_access_time_c, "Waiting to read led control reg.");

    log(ID_LOG_HDR, "Apply write-read sequence on registers.", TB_REG);
    ---------------------------------------------------------------------------
    for i in 2 to num_registers_c - 1 loop
      -- memory uses word addresses
      addr      := to_unsigned(i * 4, addr'length);
      -- Write
      wr_data_v := std_logic_vector(addr);
      av_mm_sb_i.add_expected(wr_data_v);

      avalon_mm_write(av_mm_vvc_i, 1,
                      addr, wr_data_v,
                      "Writing data to reg addr " & integer'image(to_integer(addr)));

      -- Read back
      avalon_mm_read(av_mm_vvc_i, 1, addr,
                     "Check data in reg addr " & integer'image(to_integer(addr)));
      cmd_idx_v := get_last_received_cmd_idx(av_mm_vvc_i, 1);  -- Store the command index (integer) for the last read
      await_completion(av_mm_vvc_i, 1, cmd_idx_v, 2*axi_access_time_c, "Wait for read to finish");
      fetch_result(av_mm_vvc_i, 1, cmd_idx_v, rd_data_v, "Fetching result from read operation");

      av_mm_sb_i.check_received(rd_data_v(wr_data_v'range));
    end loop;

    av_mm_sb_i.report_counters(VOID);

  end procedure blinkylight_av_mm_reg_seq;

end package body av_mm_reg_seq_pkg;
