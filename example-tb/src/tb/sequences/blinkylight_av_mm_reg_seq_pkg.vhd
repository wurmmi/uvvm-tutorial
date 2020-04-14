-------------------------------------------------------------------------------
--! @file      blinkylight_av_mm_reg_seq_pkg.vhd
--! @author    Michael Wurm <wurm.michael95@gmail.com>
--! @copyright 2017-2019 Michael Wurm
--! @brief     BlinkyLight Avalon MM register test sequence.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library blinkylightlib;
use blinkylightlib.blinkylight_pkg.all;

library testbenchlib;
use testbenchlib.blinkylight_uvvm_pkg.all;
use testbenchlib.blinkylight_reg_pkg.all;

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


--! @brief Package declaration of blinkylight_av_mm_reg_seq_pkg
--! @details
--! The BlinkyLight Avalon MM registers test sequence.

package blinkylight_av_mm_reg_seq_pkg is

  -----------------------------------------------------------------------------
  -- Procedures
  -----------------------------------------------------------------------------
  --! @{

  procedure blinkylight_av_mm_reg_seq (
    signal start_i      : in    boolean;
    signal av_mm_vvc_i  : inout t_vvc_target_record;
    variable av_mm_sb_i : inout t_generic_sb);

  --! @}

end package blinkylight_av_mm_reg_seq_pkg;


package body blinkylight_av_mm_reg_seq_pkg is

  procedure blinkylight_av_mm_reg_seq (
    signal start_i      : in    boolean;
    signal av_mm_vvc_i  : inout t_vvc_target_record;
    variable av_mm_sb_i : inout t_generic_sb) is

    variable value_v   : bitvis_vip_avalon_mm.vvc_cmd_pkg.t_vvc_result;
    variable cmd_idx_v : natural;
  begin

    await_value(start_i, true, 0 ns, 10 ns, error, "Wait for AV_MM_REG_SEQ to enable start.", TB_REG, ID_SEQUENCER);

    log(ID_LOG_HDR, "Check default register values.", TB_REG);
    ---------------------------------------------------------------------------
    for i in 0 to num_registers_c - 1 loop
      if register_map_c(i).access_type /= WRITE_ONLY then
        av_mm_sb_i.add_expected(register_map_c(i).reset);

        avalon_mm_read(av_mm_vvc_i, 1, register_map_c(i).address, "Read register: " & get_register_name(i));
        cmd_idx_v := shared_cmd_idx;
        await_completion(av_mm_vvc_i, 1, axi_access_time_c*2 + 1 ns, "Wait for read to finish.");
        fetch_result(av_mm_vvc_i, 1, cmd_idx_v, value_v, "Fetching result from read operation.");

        av_mm_sb_i.check_received(value_v(register_map_c(i).reset'range));
      end if;
    end loop;

    check_value(av_mm_sb_i.is_empty(VOID), error, "Check that scoreboard is empty");
    av_mm_sb_i.report_counters(VOID);
    av_mm_sb_i.reset("Reset Avalon MM scoreboard statistics for later use in other tb sequences");

    log(ID_LOG_HDR, "Apply write-read sequence on registers.", TB_REG);
    ---------------------------------------------------------------------------
    for i in 0 to num_registers_c - 1 loop
      -- Write
      if register_map_c(i).access_type /= READ_ONLY then
        avalon_mm_write(av_mm_vvc_i, 1,
                        register_map_c(i).address, not(register_map_c(i).reset),
                        "Writing inverted reset value to " & get_register_name(i));
      end if;

      -- Read back
      if register_map_c(i).access_type = READ_WRITE then
        avalon_mm_check(av_mm_vvc_i, 1,
                        register_map_c(i).address,
                        not(register_map_c(i).reset) and register_map_c(i).mask,
                        "Check data in register: " & get_register_name(i));
      end if;

      -- Check interrupt registers
      if register_map_c(i).access_type = INTERRUPT or
        register_map_c(i).access_type = INTERRUPT_ERROR then
        avalon_mm_check(av_mm_vvc_i, 1,
                        register_map_c(i).address, x"00000000",
                        "Check cleared interrupts: " & get_register_name(i));
      end if;

      -- Restore defaults
      if register_map_c(i).access_type /= READ_ONLY then
        avalon_mm_write(av_mm_vvc_i, 1,
                        register_map_c(i).address, register_map_c(i).reset,
                        "Restore defaults: " & get_register_name(i));
      end if;
    end loop;

    await_completion(av_mm_vvc_i, 1, num_registers_c*4 * axi_access_time_c, "Waiting for restoring register defaults.");
  end procedure blinkylight_av_mm_reg_seq;

end package body blinkylight_av_mm_reg_seq_pkg;
