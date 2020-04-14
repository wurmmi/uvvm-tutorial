-------------------------------------------------------------------------------
--! @file      blinkylight.vhd
--! @author    Michael Wurm <wurm.michael95@gmail.com>
--! @copyright 2017-2019 Michael Wurm
--! @brief     BlinkyLight implementation.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library blinkylightlib;
use blinkylightlib.blinkylight_pkg.all;

--! @brief Entity declaration of blinkylight
--! @details
--! The BlinkyLight implementation.

entity blinkylight is
  generic (
    --! Compile for simulation/synthesis
    is_simulation_g : boolean := true;
    --! Build Avalon MM Interface
    avalon_mm_inc_g : boolean := true;
    --! Build AXI4-Lite Interface
    axi4_lite_inc_g : boolean := true);
  port (
    --! @name Clocks and resets
    --! @{

    --! System clock
    clk_i   : in std_ulogic;
    --! Asynchronous reset
    rst_n_i : in std_ulogic;

    --! @}
    --! @name User interface hardware
    --! @{

    key_i    : in  std_ulogic_vector(num_of_keys_c-1 downto 0);
    switch_i : in  std_ulogic_vector(num_of_switches_c-1 downto 0);
    led_o    : out std_ulogic_vector(num_of_leds_c-1 downto 0);
    hex0_o   : out sevseg_t;
    hex1_o   : out sevseg_t;
    hex2_o   : out sevseg_t;
    hex3_o   : out sevseg_t;
    hex4_o   : out sevseg_t;
    hex5_o   : out sevseg_t;

    --! @}
    --! @name Interrupts
    --! @{

    blinky_irq_o : out std_ulogic;
    blinky_pps_o : out std_ulogic;

    --! @}
    --! @name Status
    --! @{

    running_o : out std_ulogic;

    --! @}
    --! @name Avalon MM register interface
    --! @{

    s1_address_i       : in  std_ulogic_vector(reg_if_addr_width_c-1 downto 0);
    s1_write_i         : in  std_ulogic;
    s1_writedata_i     : in  std_ulogic_vector(31 downto 0);
    s1_read_i          : in  std_ulogic;
    s1_readdata_o      : out std_ulogic_vector(31 downto 0);
    s1_readdatavalid_o : out std_ulogic;
    s1_response_o      : out std_ulogic_vector(1 downto 0);

    --! @}
    --! @name AXI-Lite register interface
    --! @{

    s_axi_awaddr_i  : in  std_ulogic_vector(reg_if_addr_width_c-1 downto 0);
    s_axi_awprot_i  : in  std_ulogic_vector(2 downto 0);
    s_axi_awvalid_i : in  std_ulogic;
    s_axi_awready_o : out std_ulogic;
    s_axi_wdata_i   : in  std_ulogic_vector(31 downto 0);
    s_axi_wstrb_i   : in  std_ulogic_vector(3 downto 0);
    s_axi_wvalid_i  : in  std_ulogic;
    s_axi_wready_o  : out std_ulogic;
    s_axi_bresp_o   : out std_ulogic_vector(1 downto 0);
    s_axi_bvalid_o  : out std_ulogic;
    s_axi_bready_i  : in  std_ulogic;
    s_axi_araddr_i  : in  std_ulogic_vector(reg_if_addr_width_c-1 downto 0);
    s_axi_arprot_i  : in  std_ulogic_vector(2 downto 0);
    s_axi_arvalid_i : in  std_ulogic;
    s_axi_arready_o : out std_ulogic;
    s_axi_rdata_o   : out std_ulogic_vector(31 downto 0);
    s_axi_rresp_o   : out std_ulogic_vector(1 downto 0);
    s_axi_rvalid_o  : out std_ulogic;
    s_axi_rready_i  : in  std_ulogic);

  --! @}

end entity blinkylight;

--! Runtime configurable RTL implementation of blinkylight
architecture rtl of blinkylight is
  -----------------------------------------------------------------------------
  --! @name Internal Wires
  -----------------------------------------------------------------------------
  --! @{

  signal leds   : std_ulogic_vector(num_of_leds_c-1 downto 0);
  signal keys   : std_ulogic_vector(num_of_keys_c-1 downto 0);
  signal switch : std_ulogic_vector(num_of_switches_c-1 downto 0);

  signal async_inputs : std_ulogic_vector(num_of_keys_c +
                                          num_of_switches_c-1 downto 0);
  signal sync_inputs : std_ulogic_vector(num_of_keys_c +
                                         num_of_switches_c-1 downto 0);
  signal pps : std_ulogic;

  signal sevseg : sevsegs_t;

  signal status          : status_t;
  signal control         : control_t;
  signal interrupt       : interrupt_t;
  signal control_av_mm   : control_t;
  signal control_axi     : control_t;
  signal interrupt_av_mm : interrupt_t;
  signal interrupt_axi   : interrupt_t;

  --! @}

begin  -- architecture rtl

  -----------------------------------------------------------------------------
  -- Outputs
  -----------------------------------------------------------------------------

  led_o        <= leds or switch(num_of_leds_c-1 downto 0);
  blinky_irq_o <= interrupt.irq;
  blinky_pps_o <= status.pps;
  running_o    <= status.running;

  hex0_o <= not(sevseg(0));
  hex1_o <= not(sevseg(1));
  hex2_o <= not(sevseg(2));
  hex3_o <= not(sevseg(3));
  hex4_o <= not(sevseg(4));
  hex5_o <= not(sevseg(5));

  -----------------------------------------------------------------------------
  -- Signal Assignments
  -----------------------------------------------------------------------------

  -- Input synchronization
  async_inputs <= switch_i & key_i;

  keys   <= not(sync_inputs(num_of_keys_c-1 downto 0));
  switch <= sync_inputs(num_of_keys_c-1 + num_of_switches_c downto num_of_keys_c);

  status.key <= keys(0) or keys(1) or keys(2);
  status.pps <= pps;
  status.magic_value <= magic_value_c;

  -----------------------------------------------------------------------------
  -- Instantiations
  -----------------------------------------------------------------------------

  sync_inst : entity blinkylightlib.sync
    generic map (
      init_value_g => '1',
      num_delays_g => 2,
      sig_width_g  => async_inputs'length)
    port map (
      clk_i   => clk_i,
      rst_n_i => rst_n_i,
      async_i => async_inputs,
      sync_o  => sync_inputs);

  startup_delay_inst : entity blinkylightlib.startup_delay
    generic map (
      num_clk_cycles => startup_delay_num_clks_c)
    port map (
      clk_i    => clk_i,
      rst_n_i  => rst_n_i,
      signal_o => status.running);

  strobe_inst : entity blinkylightlib.strobe_gen
    generic map (
      clk_freq_g => clk_freq_c,
      period_g   => pps_period_c)
    port map (
      clk_i    => clk_i,
      rst_n_i  => rst_n_i,
      enable_i => status.running,
      strobe_o => pps);

  led_dimmable_inst : entity blinkylightlib.led_dimmable
    generic map (
      clk_freq_g => clk_freq_c,
      num_leds_g => num_of_leds_c)
    port map (
      clk_i   => clk_i,
      rst_n_i => rst_n_i,

      led_o => leds,

      enable_update_i => control.gui_ctrl.enable_update,
      dimmvalues_i    => control.led_dimmvalues);

  sevenseg_gen : for i in 0 to num_of_sevsegs_c-1 generate
    sevenseg_inst : entity blinkylightlib.sevensegment
      port map (
        clk_i   => clk_i,
        rst_n_i => rst_n_i,

        sevseg_o => sevseg(i),

        enable_update_i => control.gui_ctrl.enable_update,
        blank_i         => control.gui_ctrl.blank_sevsegs,
        char_value_i    => control.sevseg_displays(i));
  end generate sevenseg_gen;

  reg_if_axi_gen : if axi4_lite_inc_g = true or
                     is_simulation_g = true generate
    -- AXI-Lite registers
    registers_inst : entity blinkylightlib.blinkylight_axi
      port map (
        s_axi_aclk_i    => clk_i,
        s_axi_aresetn_i => rst_n_i,

        s_axi_awaddr_i  => s_axi_awaddr_i,
        s_axi_awprot_i  => s_axi_awprot_i,
        s_axi_awvalid_i => s_axi_awvalid_i,
        s_axi_awready_o => s_axi_awready_o,

        s_axi_wdata_i  => s_axi_wdata_i,
        s_axi_wstrb_i  => s_axi_wstrb_i,
        s_axi_wvalid_i => s_axi_wvalid_i,
        s_axi_wready_o => s_axi_wready_o,

        s_axi_bresp_o  => s_axi_bresp_o,
        s_axi_bvalid_o => s_axi_bvalid_o,
        s_axi_bready_i => s_axi_bready_i,

        s_axi_araddr_i  => s_axi_araddr_i,
        s_axi_arprot_i  => s_axi_arprot_i,
        s_axi_arvalid_i => s_axi_arvalid_i,
        s_axi_arready_o => s_axi_arready_o,

        s_axi_rdata_o  => s_axi_rdata_o,
        s_axi_rresp_o  => s_axi_rresp_o,
        s_axi_rvalid_o => s_axi_rvalid_o,
        s_axi_rready_i => s_axi_rready_i,

        status_i    => status,
        control_o   => control_axi,
        interrupt_o => interrupt_axi);
  end generate reg_if_axi_gen;

  reg_if_av_mm_gen : if avalon_mm_inc_g = true or
                       is_simulation_g = true generate
    -- Avalon MM registers
    registers_inst : entity blinkylightlib.blinkylight_av_mm
      port map (
        clk_i   => clk_i,
        rst_n_i => rst_n_i,

        s1_address_i       => s1_address_i,
        s1_write_i         => s1_write_i,
        s1_writedata_i     => s1_writedata_i,
        s1_read_i          => s1_read_i,
        s1_readdata_o      => s1_readdata_o,
        s1_readdatavalid_o => s1_readdatavalid_o,
        s1_response_o      => s1_response_o,

        status_i    => status,
        control_o   => control_av_mm,
        interrupt_o => interrupt_av_mm);
  end generate reg_if_av_mm_gen;

  -- Simulation only
  sim_avoid_multiple_drivers_gen : if is_simulation_g = true generate
    control <= control_axi when axi4_lite_inc_g = true else
               control_av_mm when avalon_mm_inc_g = true;
    interrupt <= interrupt_axi when axi4_lite_inc_g = true else
                 interrupt_av_mm when avalon_mm_inc_g = true;
  end generate sim_avoid_multiple_drivers_gen;

  -- Bitstream only includes Avalon MM register interface
  axi_connect_gen : if is_simulation_g = false generate
    control   <= control_av_mm;
    interrupt <= interrupt_av_mm;
  end generate axi_connect_gen;

end architecture rtl;
