-------------------------------------------------------------------------------
--! @file      blinkylight_vvc_th.vhd
--! @author    Michael Wurm <wurm.michael95@gmail.com>
--! @copyright 2017-2019 Michael Wurm
--! @brief     Test harness of blinkylight.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library blinkylightlib;
use blinkylightlib.blinkylight_pkg.all;

library testbenchlib;
use testbenchlib.blinkylight_uvvm_pkg.all;

library uvvm_vvc_framework;

library bitvis_vip_avalon_mm;
library bitvis_vip_axilite;
library bitvis_vip_gpio;

--! @brief Entity declaration of blinkylight_vvc_th
--! @details
--! The BlinkyLight test harness implementation.

entity blinkylight_vvc_th is
  port (
    clk_i        : in  std_ulogic;
    rst_n_i      : in  std_ulogic;
    blinky_irq_o : out std_ulogic;
    blinky_pps_o : out std_ulogic;
    running_o    : out std_ulogic);
end entity blinkylight_vvc_th;

--! Test harness architecture
architecture struct of blinkylight_vvc_th is
  -----------------------------------------------------------------------------
  --! @name Internal Wires
  -----------------------------------------------------------------------------
  --! @{

  -- Physical connections
  signal key    : std_ulogic_vector(num_of_keys_c-1 downto 0);
  signal switch : std_ulogic_vector(num_of_switches_c-1 downto 0);
  signal led    : std_logic_vector(num_of_leds_c-1 downto 0);
  signal hex    : sevsegs_logic_t;

  -- Interrupts
  signal blinky_irq : std_ulogic;
  signal blinky_pps : std_ulogic;

  -- Status
  signal running : std_ulogic;

  -- Avalon MM interface
  signal s1_address       : std_ulogic_vector(reg_if_addr_width_c-1 downto 0);
  signal s1_write         : std_ulogic;
  signal s1_writedata     : std_ulogic_vector(31 downto 0);
  signal s1_read          : std_ulogic;
  signal s1_readdata      : std_logic_vector(31 downto 0);
  signal s1_response      : std_logic_vector(1 downto 0);
  signal s1_readdatavalid : std_logic;

  signal s1_reset         : std_ulogic;
  signal s1_chipselect    : std_ulogic;
  signal s1_lock          : std_ulogic;
  signal s1_byte_enable   : std_ulogic_vector(3 downto 0);
  signal s1_begintransfer : std_ulogic;
  signal s1_waitrequest   : std_ulogic;
  signal s1_irq           : std_ulogic;

  -- AXI interface
  signal s_axi_awaddr  : std_ulogic_vector(reg_if_addr_width_c-1 downto 0);
  signal s_axi_awprot  : std_ulogic_vector(2 downto 0);
  signal s_axi_awvalid : std_ulogic;
  signal s_axi_awready : std_logic;
  signal s_axi_wdata   : std_ulogic_vector(31 downto 0);
  signal s_axi_wstrb   : std_ulogic_vector(3 downto 0);
  signal s_axi_wvalid  : std_ulogic;
  signal s_axi_wready  : std_logic;
  signal s_axi_bresp   : std_logic_vector(1 downto 0);
  signal s_axi_bvalid  : std_logic;
  signal s_axi_bready  : std_ulogic;
  signal s_axi_araddr  : std_ulogic_vector(reg_if_addr_width_c-1 downto 0);
  signal s_axi_arprot  : std_ulogic_vector(2 downto 0);
  signal s_axi_arvalid : std_ulogic;
  signal s_axi_arready : std_logic;
  signal s_axi_rdata   : std_logic_vector(31 downto 0);
  signal s_axi_rresp   : std_logic_vector(1 downto 0);
  signal s_axi_rvalid  : std_logic;
  signal s_axi_rready  : std_ulogic;

  --! @}

begin  -- architecture struct

  -----------------------------------------------------------------------------
  -- Outputs
  -----------------------------------------------------------------------------

  blinky_irq_o <= blinky_irq;
  blinky_pps_o <= blinky_pps;
  running_o    <= running;

  -----------------------------------------------------------------------------
  -- Instantiations
  -----------------------------------------------------------------------------

  -- Initialize UVVM
  ti_uvvm_engine_inst : entity uvvm_vvc_framework.ti_uvvm_engine;

  -- Keys
  gpio_vvc_keys_inst : entity bitvis_vip_gpio.gpio_vvc
    generic map(
      GC_DATA_WIDTH         => key'length,
      GC_INSTANCE_IDX       => KEYS_VVC_INST,
      GC_DEFAULT_LINE_VALUE => (key'range => '0'))
    port map (
      gpio_vvc_if => key);

  -- Switches
  gpio_vvc_switches_inst : entity bitvis_vip_gpio.gpio_vvc
    generic map(
      GC_DATA_WIDTH         => switch'length,
      GC_INSTANCE_IDX       => SWIT_VVC_INST,
      GC_DEFAULT_LINE_VALUE => (switch'range => '0'))
    port map (
      gpio_vvc_if => switch);

  -- LEDs
  gpio_vvc_leds_inst : entity bitvis_vip_gpio.gpio_vvc
    generic map(
      GC_DATA_WIDTH         => led'length,
      GC_INSTANCE_IDX       => LEDS_VVC_INST,
      GC_DEFAULT_LINE_VALUE => (led'range => 'Z'))
    port map (
      gpio_vvc_if => led);

  -- Sevensegments
  gpio_vvc_sevsegs_gen : for i in 0 to num_of_sevsegs_c-1 generate
    gpio_vvc_sevseg_inst : entity bitvis_vip_gpio.gpio_vvc
      generic map(
        GC_DATA_WIDTH         => sevseg_t'length,
        GC_INSTANCE_IDX       => SEVSEG_VVC_INST(i),
        GC_DEFAULT_LINE_VALUE => (sevseg_t'range => 'Z'))
      port map (
        gpio_vvc_if => hex(i));
  end generate gpio_vvc_sevsegs_gen;

  -- Avalon MM VVC
  av_mm_vvc_inst : entity bitvis_vip_avalon_mm.avalon_mm_vvc
    generic map (
      GC_ADDR_WIDTH   => reg_if_addr_width_c,
      GC_DATA_WIDTH   => 32,
      GC_INSTANCE_IDX => 1)
    port map (
      clk => clk_i,

      avalon_mm_vvc_master_if.address       => s1_address,
      avalon_mm_vvc_master_if.writedata     => s1_writedata,
      avalon_mm_vvc_master_if.readdata      => s1_readdata,
      avalon_mm_vvc_master_if.read          => s1_read,
      avalon_mm_vvc_master_if.write         => s1_write,
      avalon_mm_vvc_master_if.response      => s1_response,
      avalon_mm_vvc_master_if.readdatavalid => s1_readdatavalid,

      -- not implemented
      avalon_mm_vvc_master_if.reset         => s1_reset,
      avalon_mm_vvc_master_if.chipselect    => s1_chipselect,
      avalon_mm_vvc_master_if.lock          => s1_lock,
      avalon_mm_vvc_master_if.byte_enable   => s1_byte_enable,
      avalon_mm_vvc_master_if.waitrequest   => s1_waitrequest,
      avalon_mm_vvc_master_if.irq           => s1_irq,
      avalon_mm_vvc_master_if.begintransfer => s1_begintransfer);

  -- AXI-Lite VVC
  axi_lite_vvc_inst : entity bitvis_vip_axilite.axilite_vvc
    generic map (
      GC_ADDR_WIDTH   => reg_if_addr_width_c,
      GC_DATA_WIDTH   => 32,
      GC_INSTANCE_IDX => 1)
    port map (
      clk => clk_i,

      axilite_vvc_master_if.write_address_channel.awaddr  => s_axi_awaddr,
      axilite_vvc_master_if.write_address_channel.awvalid => s_axi_awvalid,
      axilite_vvc_master_if.write_address_channel.awprot  => s_axi_awprot,
      axilite_vvc_master_if.write_address_channel.awready => s_axi_awready,

      axilite_vvc_master_if.write_data_channel.wdata  => s_axi_wdata,
      axilite_vvc_master_if.write_data_channel.wstrb  => s_axi_wstrb,
      axilite_vvc_master_if.write_data_channel.wvalid => s_axi_wvalid,
      axilite_vvc_master_if.write_data_channel.wready => s_axi_wready,

      axilite_vvc_master_if.write_response_channel.bready => s_axi_bready,
      axilite_vvc_master_if.write_response_channel.bresp  => s_axi_bresp,
      axilite_vvc_master_if.write_response_channel.bvalid => s_axi_bvalid,
      axilite_vvc_master_if.read_address_channel.araddr   => s_axi_araddr,

      axilite_vvc_master_if.read_address_channel.arvalid => s_axi_arvalid,
      axilite_vvc_master_if.read_address_channel.arprot  => s_axi_arprot,
      axilite_vvc_master_if.read_address_channel.arready => s_axi_arready,

      axilite_vvc_master_if.read_data_channel.rready => s_axi_rready,
      axilite_vvc_master_if.read_data_channel.rdata  => s_axi_rdata,
      axilite_vvc_master_if.read_data_channel.rresp  => s_axi_rresp,
      axilite_vvc_master_if.read_data_channel.rvalid => s_axi_rvalid);

  -- DUT (AXI Register Interface)
  dut_blinkylight_axi_inst : entity blinkylightlib.blinkylight_top
    generic map (
      is_simulation_g => true,
      avalon_mm_inc_g => false,
      axi4_lite_inc_g => true)
    port map (
      clk_i   => clk_i,
      rst_n_i => rst_n_i,

      key_i    => not(key),
      switch_i => switch,
      led_o    => led,
      hex0_o   => hex(0),
      hex1_o   => hex(1),
      hex2_o   => hex(2),
      hex3_o   => hex(3),
      hex4_o   => hex(4),
      hex5_o   => hex(5),

      blinky_irq_o => blinky_irq,
      blinky_pps_o => blinky_pps,

      running_o => running,

      -- unused
      s1_address_i   => (others => '0'),
      s1_write_i     => '0',
      s1_writedata_i => (others => '0'),
      s1_read_i      => '0',
      s1_readdata_o  => open,
      s1_response_o  => open,

      s_axi_awaddr_i  => s_axi_awaddr,
      s_axi_awprot_i  => s_axi_awprot,
      s_axi_awvalid_i => s_axi_awvalid,
      s_axi_awready_o => s_axi_awready,
      s_axi_wdata_i   => s_axi_wdata,
      s_axi_wstrb_i   => s_axi_wstrb,
      s_axi_wvalid_i  => s_axi_wvalid,
      s_axi_wready_o  => s_axi_wready,
      s_axi_bresp_o   => s_axi_bresp,
      s_axi_bvalid_o  => s_axi_bvalid,
      s_axi_bready_i  => s_axi_bready,
      s_axi_araddr_i  => s_axi_araddr,
      s_axi_arprot_i  => s_axi_arprot,
      s_axi_arvalid_i => s_axi_arvalid,
      s_axi_arready_o => s_axi_arready,
      s_axi_rdata_o   => s_axi_rdata,
      s_axi_rresp_o   => s_axi_rresp,
      s_axi_rvalid_o  => s_axi_rvalid,
      s_axi_rready_i  => s_axi_rready);

  -- DUT (Avalon MM Interface)
  dut_blinkylight_av_mm_inst : entity blinkylightlib.blinkylight_top
    generic map (
      is_simulation_g => true,
      avalon_mm_inc_g => true,
      axi4_lite_inc_g => false)
    port map (
      clk_i   => clk_i,
      rst_n_i => rst_n_i,

      key_i    => not(key),
      switch_i => switch,
      led_o    => open,
      hex0_o   => open,
      hex1_o   => open,
      hex2_o   => open,
      hex3_o   => open,
      hex4_o   => open,
      hex5_o   => open,

      blinky_irq_o => open,
      blinky_pps_o => open,

      running_o => open,

      s1_address_i       => s1_address,
      s1_write_i         => s1_write,
      s1_writedata_i     => s1_writedata,
      s1_read_i          => s1_read,
      s1_readdata_o      => s1_readdata,
      s1_readdatavalid_o => s1_readdatavalid,
      s1_response_o      => s1_response,

      -- unused
      s_axi_awaddr_i  => (others => '0'),
      s_axi_awprot_i  => (others => '0'),
      s_axi_awvalid_i => '0',
      s_axi_awready_o => open,
      s_axi_wdata_i   => (others => '0'),
      s_axi_wstrb_i   => (others => '0'),
      s_axi_wvalid_i  => '0',
      s_axi_wready_o  => open,
      s_axi_bresp_o   => open,
      s_axi_bvalid_o  => open,
      s_axi_bready_i  => '0',
      s_axi_araddr_i  => (others => '0'),
      s_axi_arprot_i  => (others => '0'),
      s_axi_arvalid_i => '0',
      s_axi_arready_o => open,
      s_axi_rdata_o   => open,
      s_axi_rresp_o   => open,
      s_axi_rvalid_o  => open,
      s_axi_rready_i  => '0');

end architecture struct;
