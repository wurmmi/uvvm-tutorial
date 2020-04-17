-------------------------------------------------------------------------------
--! @file      blinkylight_tb.vhd
--! @author    Michael Wurm <wurm.michael95@gmail.com>
--! @copyright 2017-2020 Michael Wurm
--! @brief     Testbench of blinkylight.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library blinkylightlib;
use blinkylightlib.blinkylight_pkg.all;

library testbenchlib;
use testbenchlib.blinkylight_uvvm_pkg.all;
use testbenchlib.av_mm_reg_seq_pkg.all;
use testbenchlib.axi_reg_seq_pkg.all;

library uvvm_util;
context uvvm_util.uvvm_util_context;

library uvvm_vvc_framework;
use uvvm_vvc_framework.ti_vvc_framework_support_pkg.all;

library bitvis_vip_avalon_mm;
use bitvis_vip_avalon_mm.vvc_methods_pkg.all;
use bitvis_vip_avalon_mm.td_vvc_framework_common_methods_pkg.all;

library bitvis_vip_axilite;
use bitvis_vip_axilite.vvc_methods_pkg.all;
use bitvis_vip_axilite.td_vvc_framework_common_methods_pkg.all;

library bitvis_vip_gpio;
use bitvis_vip_gpio.vvc_methods_pkg.all;
use bitvis_vip_gpio.td_vvc_framework_common_methods_pkg.all;

library bitvis_vip_scoreboard;
use bitvis_vip_scoreboard.slv_sb_pkg.all;
use bitvis_vip_scoreboard.generic_sb_support_pkg.all;


--! @brief Entity declaration of blinkylight_tb
--! @details
--! The BlinkyLight testbench implementation.

entity blinkylight_tb is
end entity blinkylight_tb;

--! Testbench main architecture
architecture struct of blinkylight_tb is
  -----------------------------------------------------------------------------
  --! @name Types and Constants
  -----------------------------------------------------------------------------
  --! @{

  constant clk_duty_cycle_c : natural := 50;

  --! @}
  -----------------------------------------------------------------------------
  --! @name Internal Wires
  -----------------------------------------------------------------------------
  --! @{

  signal clk     : std_ulogic;
  signal clk_ena : boolean;
  signal rst_n   : std_ulogic;
  signal running : std_ulogic;

  signal start_av_mm_reg_seq : boolean := false;
  signal start_axi_reg_seq   : boolean := false;

  --! @}
  -----------------------------------------------------------------------------
  --! @name Shared Variables
  -----------------------------------------------------------------------------
  --! @{

  shared variable av_mm_sb_sv : t_generic_sb;

  --! @}

begin  -- architecture struct

  -----------------------------------------------------------------------------
  -- Instantiations
  -----------------------------------------------------------------------------

  test_harness : entity testbenchlib.blinkylight_vvc_th
    port map (clk_i     => clk,
              rst_n_i   => rst_n,
              running_o => running);

  -----------------------------------------------------------------------------
  -- Physical connections
  -----------------------------------------------------------------------------

  clock_generator(clk, clk_ena, clk_period_c, "clk", clk_duty_cycle_c);
  rstgen : rst_n <= '0', '1' after 200 ns;

  -----------------------------------------------------------------------------
  -- Actual testing main process
  -----------------------------------------------------------------------------
  main : process
    variable local_verbose : boolean := true;
  begin
    -- Wait for UVVM to finish initialization
    await_uvvm_initialization(VOID);

    set_log_file_name(LOG_ALL_FILE);
    set_alert_file_name(LOG_ALERTS_FILE);

    disable_log_msg(ALL_MESSAGES);
    enable_log_msg(ID_CLOCK_GEN);
    enable_log_msg(ID_LOG_HDR);
    enable_log_msg(ID_LOG_HDR_LARGE);
    enable_log_msg(ID_SEQUENCER);

    disable_log_msg(VVC_BROADCAST, ALL_MESSAGES);
    enable_log_msg(VVC_BROADCAST, ID_BFM);
    enable_log_msg(VVC_BROADCAST, ID_FINISH_OR_STOP);
    enable_log_msg(VVC_BROADCAST, ID_IMMEDIATE_CMD);
    enable_log_msg(VVC_BROADCAST, ID_IMMEDIATE_CMD_WAIT);

    if VERBOSE = true then
      enable_log_msg(ALL_MESSAGES);
      enable_log_msg(VVC_BROADCAST, ALL_MESSAGES);

      report_global_ctrl(VOID);
      report_msg_id_panel(VOID);
    end if;

    log(ID_LOG_HDR, "Configure Scoreboard parameters.", INFO);
    av_mm_sb_sv.set_scope("Avalon MM Scoreboard");
    av_mm_sb_sv.config(C_SB_CONFIG_DEFAULT, "Set config for Avalon MM Scoreboard");
    av_mm_sb_sv.enable(VOID);
    av_mm_sb_sv.enable_log_msg(ID_DATA);

    log(ID_LOG_HDR, "Configure UVVM parameters.", INFO);
    shared_axilite_vvc_config(1).bfm_config.clock_period            := clk_period_c;
    shared_avalon_mm_vvc_config(1).bfm_config.clock_period          := clk_period_c;
    shared_avalon_mm_vvc_config(1).bfm_config.use_readdatavalid     := true;
    shared_avalon_mm_vvc_config(1).bfm_config.use_waitrequest       := false;
    shared_avalon_mm_vvc_config(1).bfm_config.num_wait_states_read  := 2;
    shared_avalon_mm_vvc_config(1).bfm_config.num_wait_states_write := 2;


    log(ID_LOG_HDR_LARGE, "Starting simulation of testbench for BlinkyLight.", INFO);
    --=========================================================================
    clk_ena <= false, true after 30 ns;

    log(ID_LOG_HDR, "Wait for reset to release.", INFO);
    await_value(rst_n, '1', 180 ns, 220 ns, error, "Release reset", TB_HW, ID_SEQUENCER);

    ---------------------------------------------------------------------------
    log(ID_LOG_HDR, "Wait for FPGA design to start.", INFO);
    await_value(running, '1', 220 ns, startup_delay_num_clks_c * clk_period_c, error, "Indicate running status", TB_HW, ID_SEQUENCER);

    ---------------------------------------------------------------------------
    log(ID_LOG_HDR_LARGE, "Register Test Sequence AXI.", TB_REG);
    start_axi_reg_seq <= true;
    blinkylight_axi_reg_seq(start_axi_reg_seq, AXILITE_VVCT);
    start_axi_reg_seq <= false;

    ---------------------------------------------------------------------------
    log(ID_LOG_HDR_LARGE, "Register Test Sequence Avalon MM.", TB_REG);
    start_av_mm_reg_seq <= true;
    blinkylight_av_mm_reg_seq(start_av_mm_reg_seq, AVALON_MM_VVCT, av_mm_sb_sv);
    start_av_mm_reg_seq <= false;


    --=========================================================================
    wait for 1000 * clk_period_c;
    log(ID_LOG_HDR_LARGE, "End of testbench. Await completion of all VVCs.", INFO);
    await_completion(VVC_BROADCAST, 100 * clk_period_c, "Waiting for all VVCs to finish.");

    clk_ena <= false;
    wait for 100 * clk_period_c;

    report_alert_counters(FINAL);
    log(ID_LOG_HDR_LARGE, "SIMULATION COMPLETED", INFO);

    -- Stop the simulation
    std.env.stop;
    wait;
  end process main;

end architecture struct;
