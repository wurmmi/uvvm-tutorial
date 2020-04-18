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
    clk_i     : in  std_ulogic;
    rst_n_i   : in  std_ulogic;
    running_o : out std_ulogic);
end entity blinkylight_vvc_th;

--! Test harness architecture
architecture struct of blinkylight_vvc_th is
  -----------------------------------------------------------------------------
  --! @name Internal Wires
  -----------------------------------------------------------------------------
  --! @{

  -- Physical connections
  signal led : std_logic_vector(num_of_leds_c-1 downto 0);

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

  running_o <= running;

  -----------------------------------------------------------------------------
  -- Instantiations
  -----------------------------------------------------------------------------

  -- Initialize UVVM
  ti_uvvm_engine_inst : entity uvvm_vvc_framework.ti_uvvm_engine;

  -- LED VVC
  gpio_vvc_leds_inst : entity bitvis_vip_gpio.gpio_vvc
    generic map(
      GC_DATA_WIDTH         => led'length,
      GC_INSTANCE_IDX       => LEDS_VVC_INST,
      GC_DEFAULT_LINE_VALUE => (led'range => 'Z'))
    port map (
      gpio_vvc_if => led);

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
  dut_blinkylight_axi_inst : entity blinkylightlib.blinkylight
    generic map (
      is_simulation_g => true,
      avalon_mm_inc_g => false,
      axi4_lite_inc_g => true)
    port map (
      clk_i   => clk_i,
      rst_n_i => rst_n_i,

      led_o     => led,
      running_o => running,

      -- Avalon MM (unused)
      s1_address_i   => (others => '0'),
      s1_write_i     => '0',
      s1_writedata_i => (others => '0'),
      s1_read_i      => '0',
      s1_readdata_o  => open,
      s1_response_o  => open,

      -- Axilite MM
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
  dut_blinkylight_av_mm_inst : entity blinkylightlib.blinkylight
    generic map (
      is_simulation_g => true,
      avalon_mm_inc_g => true,
      axi4_lite_inc_g => false)
    port map (
      clk_i   => clk_i,
      rst_n_i => rst_n_i,

      led_o     => open,
      running_o => open,

      -- Avalon MM
      s1_address_i       => s1_address,
      s1_write_i         => s1_write,
      s1_writedata_i     => s1_writedata,
      s1_read_i          => s1_read,
      s1_readdata_o      => s1_readdata,
      s1_readdatavalid_o => s1_readdatavalid,
      s1_response_o      => s1_response,

      -- Axilite MM (unused)
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
