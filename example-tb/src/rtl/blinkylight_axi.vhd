-------------------------------------------------------------------------------
--! @file      blinkylight_axi.vhd
--! @author    Super Easy Register Scripting Engine (SERSE)
--! @copyright 2017-2019 Michael Wurm
--! @brief     AXI4-Lite register interface for BlinkyLight
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library blinkylightlib;
use blinkylightlib.blinkylight_pkg.all;

--! @brief Entity declaration of blinkylight_axi
--! @details
--! This is a generated wrapper to combine registers into record types for
--! easier component connection in the design.

entity blinkylight_axi is
  generic (
    read_delay_g : natural := 2);
  port (
    --! @name AXI clock and reset
    --! @{

    s_axi_aclk_i    : in std_ulogic;
    s_axi_aresetn_i : in std_ulogic;

    --! @}
    --! @name AXI write address
    --! @{

    s_axi_awaddr_i  : in  std_ulogic_vector(9 downto 0);
    s_axi_awprot_i  : in  std_ulogic_vector(2 downto 0);
    s_axi_awvalid_i : in  std_ulogic;
    s_axi_awready_o : out std_ulogic;

    --! @}
    --! @name AXI write data
    --! @{

    s_axi_wdata_i  : in  std_ulogic_vector(31 downto 0);
    s_axi_wstrb_i  : in  std_ulogic_vector(3 downto 0);
    s_axi_wvalid_i : in  std_ulogic;
    s_axi_wready_o : out std_ulogic;

    --! @}
    --! @name AXI write response
    --! @{

    s_axi_bresp_o  : out std_ulogic_vector(1 downto 0);
    s_axi_bvalid_o : out std_ulogic;
    s_axi_bready_i : in  std_ulogic;

    --! @}
    --! @name AXI read address
    --! @{

    s_axi_araddr_i  : in  std_ulogic_vector(9 downto 0);
    s_axi_arprot_i  : in  std_ulogic_vector(2 downto 0);
    s_axi_arvalid_i : in  std_ulogic;
    s_axi_arready_o : out std_ulogic;

    --! @}
    --! @name AXI read data
    --! @{

    s_axi_rdata_o  : out std_ulogic_vector(31 downto 0);
    s_axi_rresp_o  : out std_ulogic_vector(1 downto 0);
    s_axi_rvalid_o : out std_ulogic;
    s_axi_rready_i : in  std_ulogic;

    --! @}
    --! @name Register interface
    --! @{

    status_i    : in  status_t;
    control_o   : out control_t;
    interrupt_o : out interrupt_t);

    --! @}

end entity blinkylight_axi;


--! RTL implementation of blinkylight_axi
architecture rtl of blinkylight_axi is
  -----------------------------------------------------------------------------
  --! @name Types and Constants
  -----------------------------------------------------------------------------
  --! @{

  constant axi_okay_c       : std_ulogic_vector(1 downto 0) := "00";
  constant axi_addr_error_c : std_ulogic_vector(1 downto 0) := "11";

  --! @}
  -----------------------------------------------------------------------------
  --! @name AXI Registers
  -----------------------------------------------------------------------------
  --! @{

  signal axi_awready : std_ulogic;
  signal axi_awaddr  : unsigned(s_axi_awaddr_i'range);
  signal axi_wready  : std_ulogic;
  signal axi_bvalid  : std_ulogic;
  signal axi_bresp   : std_ulogic_vector(s_axi_bresp_o'range);
  signal axi_arready : std_ulogic;
  signal axi_araddr  : unsigned(s_axi_araddr_i'range);
  signal axi_rvalid  : std_ulogic_vector(read_delay_g-1 downto 0);
  signal axi_rdata   : std_ulogic_vector(s_axi_rdata_o'range);
  signal axi_rresp   : std_ulogic_vector(s_axi_rresp_o'range);

  --! @}
  -----------------------------------------------------------------------------
  --! @name BlinkyLight Registers
  -----------------------------------------------------------------------------
  --! @{

  signal bl_ram0_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram1_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram2_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram3_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram4_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram5_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram6_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram7_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram8_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram9_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram10_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram11_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram12_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram13_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram14_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram15_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram16_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram17_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram18_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram19_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram20_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram21_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram22_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram23_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram24_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram25_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram26_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram27_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram28_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram29_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram30_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram31_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram32_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram33_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram34_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram35_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram36_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram37_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram38_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram39_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram40_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram41_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram42_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram43_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram44_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram45_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram46_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram47_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram48_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram49_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram50_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram51_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram52_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram53_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram54_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram55_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram56_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram57_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram58_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram59_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram60_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram61_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram62_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram63_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram64_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram65_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram66_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram67_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram68_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram69_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram70_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram71_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram72_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram73_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram74_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram75_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram76_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram77_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram78_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram79_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram80_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram81_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram82_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram83_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram84_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram85_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram86_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram87_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram88_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram89_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram90_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram91_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram92_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram93_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram94_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram95_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram96_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram97_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram98_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram99_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram100_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram101_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram102_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram103_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram104_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram105_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram106_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram107_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram108_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram109_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram110_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram111_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram112_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram113_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram114_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram115_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram116_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram117_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram118_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram119_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram120_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram121_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram122_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram123_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram124_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram125_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram126_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram127_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram128_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram129_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram130_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram131_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram132_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram133_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram134_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram135_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram136_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram137_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram138_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram139_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram140_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram141_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram142_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram143_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram144_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram145_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram146_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram147_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram148_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram149_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram150_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram151_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram152_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram153_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram154_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram155_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram156_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram157_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram158_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram159_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram160_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram161_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram162_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram163_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram164_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram165_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram166_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram167_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram168_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram169_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram170_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram171_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram172_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram173_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram174_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram175_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram176_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram177_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram178_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram179_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram180_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram181_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram182_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram183_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram184_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram185_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram186_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram187_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram188_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram189_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram190_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram191_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram192_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram193_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram194_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram195_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram196_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram197_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram198_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram199_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram200_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram201_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram202_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram203_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram204_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram205_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram206_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram207_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram208_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram209_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram210_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram211_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram212_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram213_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram214_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram215_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram216_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram217_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram218_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram219_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram220_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram221_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram222_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram223_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram224_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram225_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram226_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram227_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram228_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram229_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram230_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram231_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram232_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram233_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram234_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram235_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram236_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram237_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram238_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram239_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram240_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram241_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram242_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram243_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram244_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram245_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram246_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram247_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram248_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram249_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram250_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram251_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram252_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));
  signal bl_ram253_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(0, 32));

  --! @}
  -----------------------------------------------------------------------------
  --! @name BlinkyLight Wires
  -----------------------------------------------------------------------------
  --! @{

  signal bl_magic_value_value : std_ulogic_vector(31 downto 0);
  --! @}

begin -- architecture rtl

  -----------------------------------------------------------------------------
  -- Outputs
  -----------------------------------------------------------------------------

  s_axi_awready_o <= axi_awready;
  s_axi_wready_o  <= axi_wready;
  s_axi_bvalid_o  <= axi_bvalid;
  s_axi_bresp_o   <= axi_bresp;
  s_axi_arready_o <= axi_arready;
  s_axi_rvalid_o  <= axi_rvalid(axi_rvalid'high);
  s_axi_rdata_o   <= axi_rdata;
  s_axi_rresp_o   <= axi_rresp;

  control_o.ram(0) <= bl_ram0_value;
  control_o.ram(1) <= bl_ram1_value;
  control_o.ram(2) <= bl_ram2_value;
  control_o.ram(3) <= bl_ram3_value;
  control_o.ram(4) <= bl_ram4_value;
  control_o.ram(5) <= bl_ram5_value;
  control_o.ram(6) <= bl_ram6_value;
  control_o.ram(7) <= bl_ram7_value;
  control_o.ram(8) <= bl_ram8_value;
  control_o.ram(9) <= bl_ram9_value;
  control_o.ram(10) <= bl_ram10_value;
  control_o.ram(11) <= bl_ram11_value;
  control_o.ram(12) <= bl_ram12_value;
  control_o.ram(13) <= bl_ram13_value;
  control_o.ram(14) <= bl_ram14_value;
  control_o.ram(15) <= bl_ram15_value;
  control_o.ram(16) <= bl_ram16_value;
  control_o.ram(17) <= bl_ram17_value;
  control_o.ram(18) <= bl_ram18_value;
  control_o.ram(19) <= bl_ram19_value;
  control_o.ram(20) <= bl_ram20_value;
  control_o.ram(21) <= bl_ram21_value;
  control_o.ram(22) <= bl_ram22_value;
  control_o.ram(23) <= bl_ram23_value;
  control_o.ram(24) <= bl_ram24_value;
  control_o.ram(25) <= bl_ram25_value;
  control_o.ram(26) <= bl_ram26_value;
  control_o.ram(27) <= bl_ram27_value;
  control_o.ram(28) <= bl_ram28_value;
  control_o.ram(29) <= bl_ram29_value;
  control_o.ram(30) <= bl_ram30_value;
  control_o.ram(31) <= bl_ram31_value;
  control_o.ram(32) <= bl_ram32_value;
  control_o.ram(33) <= bl_ram33_value;
  control_o.ram(34) <= bl_ram34_value;
  control_o.ram(35) <= bl_ram35_value;
  control_o.ram(36) <= bl_ram36_value;
  control_o.ram(37) <= bl_ram37_value;
  control_o.ram(38) <= bl_ram38_value;
  control_o.ram(39) <= bl_ram39_value;
  control_o.ram(40) <= bl_ram40_value;
  control_o.ram(41) <= bl_ram41_value;
  control_o.ram(42) <= bl_ram42_value;
  control_o.ram(43) <= bl_ram43_value;
  control_o.ram(44) <= bl_ram44_value;
  control_o.ram(45) <= bl_ram45_value;
  control_o.ram(46) <= bl_ram46_value;
  control_o.ram(47) <= bl_ram47_value;
  control_o.ram(48) <= bl_ram48_value;
  control_o.ram(49) <= bl_ram49_value;
  control_o.ram(50) <= bl_ram50_value;
  control_o.ram(51) <= bl_ram51_value;
  control_o.ram(52) <= bl_ram52_value;
  control_o.ram(53) <= bl_ram53_value;
  control_o.ram(54) <= bl_ram54_value;
  control_o.ram(55) <= bl_ram55_value;
  control_o.ram(56) <= bl_ram56_value;
  control_o.ram(57) <= bl_ram57_value;
  control_o.ram(58) <= bl_ram58_value;
  control_o.ram(59) <= bl_ram59_value;
  control_o.ram(60) <= bl_ram60_value;
  control_o.ram(61) <= bl_ram61_value;
  control_o.ram(62) <= bl_ram62_value;
  control_o.ram(63) <= bl_ram63_value;
  control_o.ram(64) <= bl_ram64_value;
  control_o.ram(65) <= bl_ram65_value;
  control_o.ram(66) <= bl_ram66_value;
  control_o.ram(67) <= bl_ram67_value;
  control_o.ram(68) <= bl_ram68_value;
  control_o.ram(69) <= bl_ram69_value;
  control_o.ram(70) <= bl_ram70_value;
  control_o.ram(71) <= bl_ram71_value;
  control_o.ram(72) <= bl_ram72_value;
  control_o.ram(73) <= bl_ram73_value;
  control_o.ram(74) <= bl_ram74_value;
  control_o.ram(75) <= bl_ram75_value;
  control_o.ram(76) <= bl_ram76_value;
  control_o.ram(77) <= bl_ram77_value;
  control_o.ram(78) <= bl_ram78_value;
  control_o.ram(79) <= bl_ram79_value;
  control_o.ram(80) <= bl_ram80_value;
  control_o.ram(81) <= bl_ram81_value;
  control_o.ram(82) <= bl_ram82_value;
  control_o.ram(83) <= bl_ram83_value;
  control_o.ram(84) <= bl_ram84_value;
  control_o.ram(85) <= bl_ram85_value;
  control_o.ram(86) <= bl_ram86_value;
  control_o.ram(87) <= bl_ram87_value;
  control_o.ram(88) <= bl_ram88_value;
  control_o.ram(89) <= bl_ram89_value;
  control_o.ram(90) <= bl_ram90_value;
  control_o.ram(91) <= bl_ram91_value;
  control_o.ram(92) <= bl_ram92_value;
  control_o.ram(93) <= bl_ram93_value;
  control_o.ram(94) <= bl_ram94_value;
  control_o.ram(95) <= bl_ram95_value;
  control_o.ram(96) <= bl_ram96_value;
  control_o.ram(97) <= bl_ram97_value;
  control_o.ram(98) <= bl_ram98_value;
  control_o.ram(99) <= bl_ram99_value;
  control_o.ram(100) <= bl_ram100_value;
  control_o.ram(101) <= bl_ram101_value;
  control_o.ram(102) <= bl_ram102_value;
  control_o.ram(103) <= bl_ram103_value;
  control_o.ram(104) <= bl_ram104_value;
  control_o.ram(105) <= bl_ram105_value;
  control_o.ram(106) <= bl_ram106_value;
  control_o.ram(107) <= bl_ram107_value;
  control_o.ram(108) <= bl_ram108_value;
  control_o.ram(109) <= bl_ram109_value;
  control_o.ram(110) <= bl_ram110_value;
  control_o.ram(111) <= bl_ram111_value;
  control_o.ram(112) <= bl_ram112_value;
  control_o.ram(113) <= bl_ram113_value;
  control_o.ram(114) <= bl_ram114_value;
  control_o.ram(115) <= bl_ram115_value;
  control_o.ram(116) <= bl_ram116_value;
  control_o.ram(117) <= bl_ram117_value;
  control_o.ram(118) <= bl_ram118_value;
  control_o.ram(119) <= bl_ram119_value;
  control_o.ram(120) <= bl_ram120_value;
  control_o.ram(121) <= bl_ram121_value;
  control_o.ram(122) <= bl_ram122_value;
  control_o.ram(123) <= bl_ram123_value;
  control_o.ram(124) <= bl_ram124_value;
  control_o.ram(125) <= bl_ram125_value;
  control_o.ram(126) <= bl_ram126_value;
  control_o.ram(127) <= bl_ram127_value;
  control_o.ram(128) <= bl_ram128_value;
  control_o.ram(129) <= bl_ram129_value;
  control_o.ram(130) <= bl_ram130_value;
  control_o.ram(131) <= bl_ram131_value;
  control_o.ram(132) <= bl_ram132_value;
  control_o.ram(133) <= bl_ram133_value;
  control_o.ram(134) <= bl_ram134_value;
  control_o.ram(135) <= bl_ram135_value;
  control_o.ram(136) <= bl_ram136_value;
  control_o.ram(137) <= bl_ram137_value;
  control_o.ram(138) <= bl_ram138_value;
  control_o.ram(139) <= bl_ram139_value;
  control_o.ram(140) <= bl_ram140_value;
  control_o.ram(141) <= bl_ram141_value;
  control_o.ram(142) <= bl_ram142_value;
  control_o.ram(143) <= bl_ram143_value;
  control_o.ram(144) <= bl_ram144_value;
  control_o.ram(145) <= bl_ram145_value;
  control_o.ram(146) <= bl_ram146_value;
  control_o.ram(147) <= bl_ram147_value;
  control_o.ram(148) <= bl_ram148_value;
  control_o.ram(149) <= bl_ram149_value;
  control_o.ram(150) <= bl_ram150_value;
  control_o.ram(151) <= bl_ram151_value;
  control_o.ram(152) <= bl_ram152_value;
  control_o.ram(153) <= bl_ram153_value;
  control_o.ram(154) <= bl_ram154_value;
  control_o.ram(155) <= bl_ram155_value;
  control_o.ram(156) <= bl_ram156_value;
  control_o.ram(157) <= bl_ram157_value;
  control_o.ram(158) <= bl_ram158_value;
  control_o.ram(159) <= bl_ram159_value;
  control_o.ram(160) <= bl_ram160_value;
  control_o.ram(161) <= bl_ram161_value;
  control_o.ram(162) <= bl_ram162_value;
  control_o.ram(163) <= bl_ram163_value;
  control_o.ram(164) <= bl_ram164_value;
  control_o.ram(165) <= bl_ram165_value;
  control_o.ram(166) <= bl_ram166_value;
  control_o.ram(167) <= bl_ram167_value;
  control_o.ram(168) <= bl_ram168_value;
  control_o.ram(169) <= bl_ram169_value;
  control_o.ram(170) <= bl_ram170_value;
  control_o.ram(171) <= bl_ram171_value;
  control_o.ram(172) <= bl_ram172_value;
  control_o.ram(173) <= bl_ram173_value;
  control_o.ram(174) <= bl_ram174_value;
  control_o.ram(175) <= bl_ram175_value;
  control_o.ram(176) <= bl_ram176_value;
  control_o.ram(177) <= bl_ram177_value;
  control_o.ram(178) <= bl_ram178_value;
  control_o.ram(179) <= bl_ram179_value;
  control_o.ram(180) <= bl_ram180_value;
  control_o.ram(181) <= bl_ram181_value;
  control_o.ram(182) <= bl_ram182_value;
  control_o.ram(183) <= bl_ram183_value;
  control_o.ram(184) <= bl_ram184_value;
  control_o.ram(185) <= bl_ram185_value;
  control_o.ram(186) <= bl_ram186_value;
  control_o.ram(187) <= bl_ram187_value;
  control_o.ram(188) <= bl_ram188_value;
  control_o.ram(189) <= bl_ram189_value;
  control_o.ram(190) <= bl_ram190_value;
  control_o.ram(191) <= bl_ram191_value;
  control_o.ram(192) <= bl_ram192_value;
  control_o.ram(193) <= bl_ram193_value;
  control_o.ram(194) <= bl_ram194_value;
  control_o.ram(195) <= bl_ram195_value;
  control_o.ram(196) <= bl_ram196_value;
  control_o.ram(197) <= bl_ram197_value;
  control_o.ram(198) <= bl_ram198_value;
  control_o.ram(199) <= bl_ram199_value;
  control_o.ram(200) <= bl_ram200_value;
  control_o.ram(201) <= bl_ram201_value;
  control_o.ram(202) <= bl_ram202_value;
  control_o.ram(203) <= bl_ram203_value;
  control_o.ram(204) <= bl_ram204_value;
  control_o.ram(205) <= bl_ram205_value;
  control_o.ram(206) <= bl_ram206_value;
  control_o.ram(207) <= bl_ram207_value;
  control_o.ram(208) <= bl_ram208_value;
  control_o.ram(209) <= bl_ram209_value;
  control_o.ram(210) <= bl_ram210_value;
  control_o.ram(211) <= bl_ram211_value;
  control_o.ram(212) <= bl_ram212_value;
  control_o.ram(213) <= bl_ram213_value;
  control_o.ram(214) <= bl_ram214_value;
  control_o.ram(215) <= bl_ram215_value;
  control_o.ram(216) <= bl_ram216_value;
  control_o.ram(217) <= bl_ram217_value;
  control_o.ram(218) <= bl_ram218_value;
  control_o.ram(219) <= bl_ram219_value;
  control_o.ram(220) <= bl_ram220_value;
  control_o.ram(221) <= bl_ram221_value;
  control_o.ram(222) <= bl_ram222_value;
  control_o.ram(223) <= bl_ram223_value;
  control_o.ram(224) <= bl_ram224_value;
  control_o.ram(225) <= bl_ram225_value;
  control_o.ram(226) <= bl_ram226_value;
  control_o.ram(227) <= bl_ram227_value;
  control_o.ram(228) <= bl_ram228_value;
  control_o.ram(229) <= bl_ram229_value;
  control_o.ram(230) <= bl_ram230_value;
  control_o.ram(231) <= bl_ram231_value;
  control_o.ram(232) <= bl_ram232_value;
  control_o.ram(233) <= bl_ram233_value;
  control_o.ram(234) <= bl_ram234_value;
  control_o.ram(235) <= bl_ram235_value;
  control_o.ram(236) <= bl_ram236_value;
  control_o.ram(237) <= bl_ram237_value;
  control_o.ram(238) <= bl_ram238_value;
  control_o.ram(239) <= bl_ram239_value;
  control_o.ram(240) <= bl_ram240_value;
  control_o.ram(241) <= bl_ram241_value;
  control_o.ram(242) <= bl_ram242_value;
  control_o.ram(243) <= bl_ram243_value;
  control_o.ram(244) <= bl_ram244_value;
  control_o.ram(245) <= bl_ram245_value;
  control_o.ram(246) <= bl_ram246_value;
  control_o.ram(247) <= bl_ram247_value;
  control_o.ram(248) <= bl_ram248_value;
  control_o.ram(249) <= bl_ram249_value;
  control_o.ram(250) <= bl_ram250_value;
  control_o.ram(251) <= bl_ram251_value;
  control_o.ram(252) <= bl_ram252_value;
  control_o.ram(253) <= bl_ram253_value;

  -----------------------------------------------------------------------------
  -- Signal Assignments
  -----------------------------------------------------------------------------

  bl_magic_value_value <= status_i.magic_value;

  -----------------------------------------------------------------------------
  -- Registers
  -----------------------------------------------------------------------------

  regs : process (s_axi_aclk_i, s_axi_aresetn_i) is
    procedure reset is
    begin
      axi_awready <= '0';
      axi_awaddr  <= (others => '0');
      axi_wready  <= '0';
      axi_bvalid  <= '0';
      axi_arready <= '0';
      axi_araddr  <= (others => '0');
      axi_rvalid  <= (others => '0');
    end procedure reset;
  begin -- process regs
    if s_axi_aresetn_i = '0' then
      reset;
    elsif rising_edge(s_axi_aclk_i) then
      -- Defaults
      axi_awready <= '0';
      axi_wready  <= '0';
      axi_arready <= '0';

      -- Write
      if axi_awready = '0' and s_axi_awvalid_i = '1' and
        s_axi_wvalid_i = '1'
      then
        axi_awready <= '1';
        axi_awaddr  <= unsigned(s_axi_awaddr_i);
      end if;

      if axi_wready = '0' and s_axi_awvalid_i = '1' and
        s_axi_wvalid_i = '1'
      then
        axi_wready <= '1';
      end if;

      if axi_awready = '1' and axi_wready = '1' and
        s_axi_awvalid_i = '1' and s_axi_wvalid_i = '1'
      then
        -- NOTE: This is where the write operation happens
        -- See process "writing" below

        axi_bvalid <= '1';
      end if;

      if s_axi_bready_i = '1' and axi_bvalid = '1' then
        axi_bvalid <= '0';
      end if;

      -- Read
      if axi_arready = '0' and s_axi_arvalid_i = '1' then
        axi_arready <= '1';
        axi_araddr  <= unsigned(s_axi_araddr_i);
      end if;

      axi_rvalid <= axi_rvalid(axi_rvalid'high-1 downto axi_rvalid'low) & '0';

      if axi_arready = '1' and s_axi_arvalid_i = '1' and
        axi_rvalid = (axi_rvalid'range => '0')
      then
        -- NOTE: This is where the read operation happens
        -- See process "reading" below

        axi_rvalid(axi_rvalid'low) <= '1';
      end if;

      if axi_rvalid(axi_rvalid'high) = '1' and s_axi_rready_i = '1' then
        axi_rvalid <= (others => '0');
        axi_araddr <= (others => '0');
      end if;
    end if;
  end process regs;

  reading : process (s_axi_aclk_i, s_axi_aresetn_i) is
    procedure reset is
    begin
      axi_rdata <= (others => '0');
      axi_rresp <= axi_addr_error_c;
    end procedure reset;
  begin -- process reading
    if s_axi_aresetn_i = '0' then
      reset;
    elsif rising_edge(s_axi_aclk_i) then
      -- Defaults
      axi_rdata <= (others => '0');
      axi_rresp <= axi_addr_error_c;

      case to_integer(axi_araddr) is
        when 0 =>
          axi_rdata(31 downto 0) <= bl_magic_value_value;
          axi_rresp <= axi_okay_c;

        when 4 =>
          axi_rdata(31 downto 0) <= bl_ram0_value;
          axi_rresp <= axi_okay_c;

        when 8 =>
          axi_rdata(31 downto 0) <= bl_ram1_value;
          axi_rresp <= axi_okay_c;

        when 12 =>
          axi_rdata(31 downto 0) <= bl_ram2_value;
          axi_rresp <= axi_okay_c;

        when 16 =>
          axi_rdata(31 downto 0) <= bl_ram3_value;
          axi_rresp <= axi_okay_c;

        when 20 =>
          axi_rdata(31 downto 0) <= bl_ram4_value;
          axi_rresp <= axi_okay_c;

        when 24 =>
          axi_rdata(31 downto 0) <= bl_ram5_value;
          axi_rresp <= axi_okay_c;

        when 28 =>
          axi_rdata(31 downto 0) <= bl_ram6_value;
          axi_rresp <= axi_okay_c;

        when 32 =>
          axi_rdata(31 downto 0) <= bl_ram7_value;
          axi_rresp <= axi_okay_c;

        when 36 =>
          axi_rdata(31 downto 0) <= bl_ram8_value;
          axi_rresp <= axi_okay_c;

        when 40 =>
          axi_rdata(31 downto 0) <= bl_ram9_value;
          axi_rresp <= axi_okay_c;

        when 44 =>
          axi_rdata(31 downto 0) <= bl_ram10_value;
          axi_rresp <= axi_okay_c;

        when 48 =>
          axi_rdata(31 downto 0) <= bl_ram11_value;
          axi_rresp <= axi_okay_c;

        when 52 =>
          axi_rdata(31 downto 0) <= bl_ram12_value;
          axi_rresp <= axi_okay_c;

        when 56 =>
          axi_rdata(31 downto 0) <= bl_ram13_value;
          axi_rresp <= axi_okay_c;

        when 60 =>
          axi_rdata(31 downto 0) <= bl_ram14_value;
          axi_rresp <= axi_okay_c;

        when 64 =>
          axi_rdata(31 downto 0) <= bl_ram15_value;
          axi_rresp <= axi_okay_c;

        when 68 =>
          axi_rdata(31 downto 0) <= bl_ram16_value;
          axi_rresp <= axi_okay_c;

        when 72 =>
          axi_rdata(31 downto 0) <= bl_ram17_value;
          axi_rresp <= axi_okay_c;

        when 76 =>
          axi_rdata(31 downto 0) <= bl_ram18_value;
          axi_rresp <= axi_okay_c;

        when 80 =>
          axi_rdata(31 downto 0) <= bl_ram19_value;
          axi_rresp <= axi_okay_c;

        when 84 =>
          axi_rdata(31 downto 0) <= bl_ram20_value;
          axi_rresp <= axi_okay_c;

        when 88 =>
          axi_rdata(31 downto 0) <= bl_ram21_value;
          axi_rresp <= axi_okay_c;

        when 92 =>
          axi_rdata(31 downto 0) <= bl_ram22_value;
          axi_rresp <= axi_okay_c;

        when 96 =>
          axi_rdata(31 downto 0) <= bl_ram23_value;
          axi_rresp <= axi_okay_c;

        when 100 =>
          axi_rdata(31 downto 0) <= bl_ram24_value;
          axi_rresp <= axi_okay_c;

        when 104 =>
          axi_rdata(31 downto 0) <= bl_ram25_value;
          axi_rresp <= axi_okay_c;

        when 108 =>
          axi_rdata(31 downto 0) <= bl_ram26_value;
          axi_rresp <= axi_okay_c;

        when 112 =>
          axi_rdata(31 downto 0) <= bl_ram27_value;
          axi_rresp <= axi_okay_c;

        when 116 =>
          axi_rdata(31 downto 0) <= bl_ram28_value;
          axi_rresp <= axi_okay_c;

        when 120 =>
          axi_rdata(31 downto 0) <= bl_ram29_value;
          axi_rresp <= axi_okay_c;

        when 124 =>
          axi_rdata(31 downto 0) <= bl_ram30_value;
          axi_rresp <= axi_okay_c;

        when 128 =>
          axi_rdata(31 downto 0) <= bl_ram31_value;
          axi_rresp <= axi_okay_c;

        when 132 =>
          axi_rdata(31 downto 0) <= bl_ram32_value;
          axi_rresp <= axi_okay_c;

        when 136 =>
          axi_rdata(31 downto 0) <= bl_ram33_value;
          axi_rresp <= axi_okay_c;

        when 140 =>
          axi_rdata(31 downto 0) <= bl_ram34_value;
          axi_rresp <= axi_okay_c;

        when 144 =>
          axi_rdata(31 downto 0) <= bl_ram35_value;
          axi_rresp <= axi_okay_c;

        when 148 =>
          axi_rdata(31 downto 0) <= bl_ram36_value;
          axi_rresp <= axi_okay_c;

        when 152 =>
          axi_rdata(31 downto 0) <= bl_ram37_value;
          axi_rresp <= axi_okay_c;

        when 156 =>
          axi_rdata(31 downto 0) <= bl_ram38_value;
          axi_rresp <= axi_okay_c;

        when 160 =>
          axi_rdata(31 downto 0) <= bl_ram39_value;
          axi_rresp <= axi_okay_c;

        when 164 =>
          axi_rdata(31 downto 0) <= bl_ram40_value;
          axi_rresp <= axi_okay_c;

        when 168 =>
          axi_rdata(31 downto 0) <= bl_ram41_value;
          axi_rresp <= axi_okay_c;

        when 172 =>
          axi_rdata(31 downto 0) <= bl_ram42_value;
          axi_rresp <= axi_okay_c;

        when 176 =>
          axi_rdata(31 downto 0) <= bl_ram43_value;
          axi_rresp <= axi_okay_c;

        when 180 =>
          axi_rdata(31 downto 0) <= bl_ram44_value;
          axi_rresp <= axi_okay_c;

        when 184 =>
          axi_rdata(31 downto 0) <= bl_ram45_value;
          axi_rresp <= axi_okay_c;

        when 188 =>
          axi_rdata(31 downto 0) <= bl_ram46_value;
          axi_rresp <= axi_okay_c;

        when 192 =>
          axi_rdata(31 downto 0) <= bl_ram47_value;
          axi_rresp <= axi_okay_c;

        when 196 =>
          axi_rdata(31 downto 0) <= bl_ram48_value;
          axi_rresp <= axi_okay_c;

        when 200 =>
          axi_rdata(31 downto 0) <= bl_ram49_value;
          axi_rresp <= axi_okay_c;

        when 204 =>
          axi_rdata(31 downto 0) <= bl_ram50_value;
          axi_rresp <= axi_okay_c;

        when 208 =>
          axi_rdata(31 downto 0) <= bl_ram51_value;
          axi_rresp <= axi_okay_c;

        when 212 =>
          axi_rdata(31 downto 0) <= bl_ram52_value;
          axi_rresp <= axi_okay_c;

        when 216 =>
          axi_rdata(31 downto 0) <= bl_ram53_value;
          axi_rresp <= axi_okay_c;

        when 220 =>
          axi_rdata(31 downto 0) <= bl_ram54_value;
          axi_rresp <= axi_okay_c;

        when 224 =>
          axi_rdata(31 downto 0) <= bl_ram55_value;
          axi_rresp <= axi_okay_c;

        when 228 =>
          axi_rdata(31 downto 0) <= bl_ram56_value;
          axi_rresp <= axi_okay_c;

        when 232 =>
          axi_rdata(31 downto 0) <= bl_ram57_value;
          axi_rresp <= axi_okay_c;

        when 236 =>
          axi_rdata(31 downto 0) <= bl_ram58_value;
          axi_rresp <= axi_okay_c;

        when 240 =>
          axi_rdata(31 downto 0) <= bl_ram59_value;
          axi_rresp <= axi_okay_c;

        when 244 =>
          axi_rdata(31 downto 0) <= bl_ram60_value;
          axi_rresp <= axi_okay_c;

        when 248 =>
          axi_rdata(31 downto 0) <= bl_ram61_value;
          axi_rresp <= axi_okay_c;

        when 252 =>
          axi_rdata(31 downto 0) <= bl_ram62_value;
          axi_rresp <= axi_okay_c;

        when 256 =>
          axi_rdata(31 downto 0) <= bl_ram63_value;
          axi_rresp <= axi_okay_c;

        when 260 =>
          axi_rdata(31 downto 0) <= bl_ram64_value;
          axi_rresp <= axi_okay_c;

        when 264 =>
          axi_rdata(31 downto 0) <= bl_ram65_value;
          axi_rresp <= axi_okay_c;

        when 268 =>
          axi_rdata(31 downto 0) <= bl_ram66_value;
          axi_rresp <= axi_okay_c;

        when 272 =>
          axi_rdata(31 downto 0) <= bl_ram67_value;
          axi_rresp <= axi_okay_c;

        when 276 =>
          axi_rdata(31 downto 0) <= bl_ram68_value;
          axi_rresp <= axi_okay_c;

        when 280 =>
          axi_rdata(31 downto 0) <= bl_ram69_value;
          axi_rresp <= axi_okay_c;

        when 284 =>
          axi_rdata(31 downto 0) <= bl_ram70_value;
          axi_rresp <= axi_okay_c;

        when 288 =>
          axi_rdata(31 downto 0) <= bl_ram71_value;
          axi_rresp <= axi_okay_c;

        when 292 =>
          axi_rdata(31 downto 0) <= bl_ram72_value;
          axi_rresp <= axi_okay_c;

        when 296 =>
          axi_rdata(31 downto 0) <= bl_ram73_value;
          axi_rresp <= axi_okay_c;

        when 300 =>
          axi_rdata(31 downto 0) <= bl_ram74_value;
          axi_rresp <= axi_okay_c;

        when 304 =>
          axi_rdata(31 downto 0) <= bl_ram75_value;
          axi_rresp <= axi_okay_c;

        when 308 =>
          axi_rdata(31 downto 0) <= bl_ram76_value;
          axi_rresp <= axi_okay_c;

        when 312 =>
          axi_rdata(31 downto 0) <= bl_ram77_value;
          axi_rresp <= axi_okay_c;

        when 316 =>
          axi_rdata(31 downto 0) <= bl_ram78_value;
          axi_rresp <= axi_okay_c;

        when 320 =>
          axi_rdata(31 downto 0) <= bl_ram79_value;
          axi_rresp <= axi_okay_c;

        when 324 =>
          axi_rdata(31 downto 0) <= bl_ram80_value;
          axi_rresp <= axi_okay_c;

        when 328 =>
          axi_rdata(31 downto 0) <= bl_ram81_value;
          axi_rresp <= axi_okay_c;

        when 332 =>
          axi_rdata(31 downto 0) <= bl_ram82_value;
          axi_rresp <= axi_okay_c;

        when 336 =>
          axi_rdata(31 downto 0) <= bl_ram83_value;
          axi_rresp <= axi_okay_c;

        when 340 =>
          axi_rdata(31 downto 0) <= bl_ram84_value;
          axi_rresp <= axi_okay_c;

        when 344 =>
          axi_rdata(31 downto 0) <= bl_ram85_value;
          axi_rresp <= axi_okay_c;

        when 348 =>
          axi_rdata(31 downto 0) <= bl_ram86_value;
          axi_rresp <= axi_okay_c;

        when 352 =>
          axi_rdata(31 downto 0) <= bl_ram87_value;
          axi_rresp <= axi_okay_c;

        when 356 =>
          axi_rdata(31 downto 0) <= bl_ram88_value;
          axi_rresp <= axi_okay_c;

        when 360 =>
          axi_rdata(31 downto 0) <= bl_ram89_value;
          axi_rresp <= axi_okay_c;

        when 364 =>
          axi_rdata(31 downto 0) <= bl_ram90_value;
          axi_rresp <= axi_okay_c;

        when 368 =>
          axi_rdata(31 downto 0) <= bl_ram91_value;
          axi_rresp <= axi_okay_c;

        when 372 =>
          axi_rdata(31 downto 0) <= bl_ram92_value;
          axi_rresp <= axi_okay_c;

        when 376 =>
          axi_rdata(31 downto 0) <= bl_ram93_value;
          axi_rresp <= axi_okay_c;

        when 380 =>
          axi_rdata(31 downto 0) <= bl_ram94_value;
          axi_rresp <= axi_okay_c;

        when 384 =>
          axi_rdata(31 downto 0) <= bl_ram95_value;
          axi_rresp <= axi_okay_c;

        when 388 =>
          axi_rdata(31 downto 0) <= bl_ram96_value;
          axi_rresp <= axi_okay_c;

        when 392 =>
          axi_rdata(31 downto 0) <= bl_ram97_value;
          axi_rresp <= axi_okay_c;

        when 396 =>
          axi_rdata(31 downto 0) <= bl_ram98_value;
          axi_rresp <= axi_okay_c;

        when 400 =>
          axi_rdata(31 downto 0) <= bl_ram99_value;
          axi_rresp <= axi_okay_c;

        when 404 =>
          axi_rdata(31 downto 0) <= bl_ram100_value;
          axi_rresp <= axi_okay_c;

        when 408 =>
          axi_rdata(31 downto 0) <= bl_ram101_value;
          axi_rresp <= axi_okay_c;

        when 412 =>
          axi_rdata(31 downto 0) <= bl_ram102_value;
          axi_rresp <= axi_okay_c;

        when 416 =>
          axi_rdata(31 downto 0) <= bl_ram103_value;
          axi_rresp <= axi_okay_c;

        when 420 =>
          axi_rdata(31 downto 0) <= bl_ram104_value;
          axi_rresp <= axi_okay_c;

        when 424 =>
          axi_rdata(31 downto 0) <= bl_ram105_value;
          axi_rresp <= axi_okay_c;

        when 428 =>
          axi_rdata(31 downto 0) <= bl_ram106_value;
          axi_rresp <= axi_okay_c;

        when 432 =>
          axi_rdata(31 downto 0) <= bl_ram107_value;
          axi_rresp <= axi_okay_c;

        when 436 =>
          axi_rdata(31 downto 0) <= bl_ram108_value;
          axi_rresp <= axi_okay_c;

        when 440 =>
          axi_rdata(31 downto 0) <= bl_ram109_value;
          axi_rresp <= axi_okay_c;

        when 444 =>
          axi_rdata(31 downto 0) <= bl_ram110_value;
          axi_rresp <= axi_okay_c;

        when 448 =>
          axi_rdata(31 downto 0) <= bl_ram111_value;
          axi_rresp <= axi_okay_c;

        when 452 =>
          axi_rdata(31 downto 0) <= bl_ram112_value;
          axi_rresp <= axi_okay_c;

        when 456 =>
          axi_rdata(31 downto 0) <= bl_ram113_value;
          axi_rresp <= axi_okay_c;

        when 460 =>
          axi_rdata(31 downto 0) <= bl_ram114_value;
          axi_rresp <= axi_okay_c;

        when 464 =>
          axi_rdata(31 downto 0) <= bl_ram115_value;
          axi_rresp <= axi_okay_c;

        when 468 =>
          axi_rdata(31 downto 0) <= bl_ram116_value;
          axi_rresp <= axi_okay_c;

        when 472 =>
          axi_rdata(31 downto 0) <= bl_ram117_value;
          axi_rresp <= axi_okay_c;

        when 476 =>
          axi_rdata(31 downto 0) <= bl_ram118_value;
          axi_rresp <= axi_okay_c;

        when 480 =>
          axi_rdata(31 downto 0) <= bl_ram119_value;
          axi_rresp <= axi_okay_c;

        when 484 =>
          axi_rdata(31 downto 0) <= bl_ram120_value;
          axi_rresp <= axi_okay_c;

        when 488 =>
          axi_rdata(31 downto 0) <= bl_ram121_value;
          axi_rresp <= axi_okay_c;

        when 492 =>
          axi_rdata(31 downto 0) <= bl_ram122_value;
          axi_rresp <= axi_okay_c;

        when 496 =>
          axi_rdata(31 downto 0) <= bl_ram123_value;
          axi_rresp <= axi_okay_c;

        when 500 =>
          axi_rdata(31 downto 0) <= bl_ram124_value;
          axi_rresp <= axi_okay_c;

        when 504 =>
          axi_rdata(31 downto 0) <= bl_ram125_value;
          axi_rresp <= axi_okay_c;

        when 508 =>
          axi_rdata(31 downto 0) <= bl_ram126_value;
          axi_rresp <= axi_okay_c;

        when 512 =>
          axi_rdata(31 downto 0) <= bl_ram127_value;
          axi_rresp <= axi_okay_c;

        when 516 =>
          axi_rdata(31 downto 0) <= bl_ram128_value;
          axi_rresp <= axi_okay_c;

        when 520 =>
          axi_rdata(31 downto 0) <= bl_ram129_value;
          axi_rresp <= axi_okay_c;

        when 524 =>
          axi_rdata(31 downto 0) <= bl_ram130_value;
          axi_rresp <= axi_okay_c;

        when 528 =>
          axi_rdata(31 downto 0) <= bl_ram131_value;
          axi_rresp <= axi_okay_c;

        when 532 =>
          axi_rdata(31 downto 0) <= bl_ram132_value;
          axi_rresp <= axi_okay_c;

        when 536 =>
          axi_rdata(31 downto 0) <= bl_ram133_value;
          axi_rresp <= axi_okay_c;

        when 540 =>
          axi_rdata(31 downto 0) <= bl_ram134_value;
          axi_rresp <= axi_okay_c;

        when 544 =>
          axi_rdata(31 downto 0) <= bl_ram135_value;
          axi_rresp <= axi_okay_c;

        when 548 =>
          axi_rdata(31 downto 0) <= bl_ram136_value;
          axi_rresp <= axi_okay_c;

        when 552 =>
          axi_rdata(31 downto 0) <= bl_ram137_value;
          axi_rresp <= axi_okay_c;

        when 556 =>
          axi_rdata(31 downto 0) <= bl_ram138_value;
          axi_rresp <= axi_okay_c;

        when 560 =>
          axi_rdata(31 downto 0) <= bl_ram139_value;
          axi_rresp <= axi_okay_c;

        when 564 =>
          axi_rdata(31 downto 0) <= bl_ram140_value;
          axi_rresp <= axi_okay_c;

        when 568 =>
          axi_rdata(31 downto 0) <= bl_ram141_value;
          axi_rresp <= axi_okay_c;

        when 572 =>
          axi_rdata(31 downto 0) <= bl_ram142_value;
          axi_rresp <= axi_okay_c;

        when 576 =>
          axi_rdata(31 downto 0) <= bl_ram143_value;
          axi_rresp <= axi_okay_c;

        when 580 =>
          axi_rdata(31 downto 0) <= bl_ram144_value;
          axi_rresp <= axi_okay_c;

        when 584 =>
          axi_rdata(31 downto 0) <= bl_ram145_value;
          axi_rresp <= axi_okay_c;

        when 588 =>
          axi_rdata(31 downto 0) <= bl_ram146_value;
          axi_rresp <= axi_okay_c;

        when 592 =>
          axi_rdata(31 downto 0) <= bl_ram147_value;
          axi_rresp <= axi_okay_c;

        when 596 =>
          axi_rdata(31 downto 0) <= bl_ram148_value;
          axi_rresp <= axi_okay_c;

        when 600 =>
          axi_rdata(31 downto 0) <= bl_ram149_value;
          axi_rresp <= axi_okay_c;

        when 604 =>
          axi_rdata(31 downto 0) <= bl_ram150_value;
          axi_rresp <= axi_okay_c;

        when 608 =>
          axi_rdata(31 downto 0) <= bl_ram151_value;
          axi_rresp <= axi_okay_c;

        when 612 =>
          axi_rdata(31 downto 0) <= bl_ram152_value;
          axi_rresp <= axi_okay_c;

        when 616 =>
          axi_rdata(31 downto 0) <= bl_ram153_value;
          axi_rresp <= axi_okay_c;

        when 620 =>
          axi_rdata(31 downto 0) <= bl_ram154_value;
          axi_rresp <= axi_okay_c;

        when 624 =>
          axi_rdata(31 downto 0) <= bl_ram155_value;
          axi_rresp <= axi_okay_c;

        when 628 =>
          axi_rdata(31 downto 0) <= bl_ram156_value;
          axi_rresp <= axi_okay_c;

        when 632 =>
          axi_rdata(31 downto 0) <= bl_ram157_value;
          axi_rresp <= axi_okay_c;

        when 636 =>
          axi_rdata(31 downto 0) <= bl_ram158_value;
          axi_rresp <= axi_okay_c;

        when 640 =>
          axi_rdata(31 downto 0) <= bl_ram159_value;
          axi_rresp <= axi_okay_c;

        when 644 =>
          axi_rdata(31 downto 0) <= bl_ram160_value;
          axi_rresp <= axi_okay_c;

        when 648 =>
          axi_rdata(31 downto 0) <= bl_ram161_value;
          axi_rresp <= axi_okay_c;

        when 652 =>
          axi_rdata(31 downto 0) <= bl_ram162_value;
          axi_rresp <= axi_okay_c;

        when 656 =>
          axi_rdata(31 downto 0) <= bl_ram163_value;
          axi_rresp <= axi_okay_c;

        when 660 =>
          axi_rdata(31 downto 0) <= bl_ram164_value;
          axi_rresp <= axi_okay_c;

        when 664 =>
          axi_rdata(31 downto 0) <= bl_ram165_value;
          axi_rresp <= axi_okay_c;

        when 668 =>
          axi_rdata(31 downto 0) <= bl_ram166_value;
          axi_rresp <= axi_okay_c;

        when 672 =>
          axi_rdata(31 downto 0) <= bl_ram167_value;
          axi_rresp <= axi_okay_c;

        when 676 =>
          axi_rdata(31 downto 0) <= bl_ram168_value;
          axi_rresp <= axi_okay_c;

        when 680 =>
          axi_rdata(31 downto 0) <= bl_ram169_value;
          axi_rresp <= axi_okay_c;

        when 684 =>
          axi_rdata(31 downto 0) <= bl_ram170_value;
          axi_rresp <= axi_okay_c;

        when 688 =>
          axi_rdata(31 downto 0) <= bl_ram171_value;
          axi_rresp <= axi_okay_c;

        when 692 =>
          axi_rdata(31 downto 0) <= bl_ram172_value;
          axi_rresp <= axi_okay_c;

        when 696 =>
          axi_rdata(31 downto 0) <= bl_ram173_value;
          axi_rresp <= axi_okay_c;

        when 700 =>
          axi_rdata(31 downto 0) <= bl_ram174_value;
          axi_rresp <= axi_okay_c;

        when 704 =>
          axi_rdata(31 downto 0) <= bl_ram175_value;
          axi_rresp <= axi_okay_c;

        when 708 =>
          axi_rdata(31 downto 0) <= bl_ram176_value;
          axi_rresp <= axi_okay_c;

        when 712 =>
          axi_rdata(31 downto 0) <= bl_ram177_value;
          axi_rresp <= axi_okay_c;

        when 716 =>
          axi_rdata(31 downto 0) <= bl_ram178_value;
          axi_rresp <= axi_okay_c;

        when 720 =>
          axi_rdata(31 downto 0) <= bl_ram179_value;
          axi_rresp <= axi_okay_c;

        when 724 =>
          axi_rdata(31 downto 0) <= bl_ram180_value;
          axi_rresp <= axi_okay_c;

        when 728 =>
          axi_rdata(31 downto 0) <= bl_ram181_value;
          axi_rresp <= axi_okay_c;

        when 732 =>
          axi_rdata(31 downto 0) <= bl_ram182_value;
          axi_rresp <= axi_okay_c;

        when 736 =>
          axi_rdata(31 downto 0) <= bl_ram183_value;
          axi_rresp <= axi_okay_c;

        when 740 =>
          axi_rdata(31 downto 0) <= bl_ram184_value;
          axi_rresp <= axi_okay_c;

        when 744 =>
          axi_rdata(31 downto 0) <= bl_ram185_value;
          axi_rresp <= axi_okay_c;

        when 748 =>
          axi_rdata(31 downto 0) <= bl_ram186_value;
          axi_rresp <= axi_okay_c;

        when 752 =>
          axi_rdata(31 downto 0) <= bl_ram187_value;
          axi_rresp <= axi_okay_c;

        when 756 =>
          axi_rdata(31 downto 0) <= bl_ram188_value;
          axi_rresp <= axi_okay_c;

        when 760 =>
          axi_rdata(31 downto 0) <= bl_ram189_value;
          axi_rresp <= axi_okay_c;

        when 764 =>
          axi_rdata(31 downto 0) <= bl_ram190_value;
          axi_rresp <= axi_okay_c;

        when 768 =>
          axi_rdata(31 downto 0) <= bl_ram191_value;
          axi_rresp <= axi_okay_c;

        when 772 =>
          axi_rdata(31 downto 0) <= bl_ram192_value;
          axi_rresp <= axi_okay_c;

        when 776 =>
          axi_rdata(31 downto 0) <= bl_ram193_value;
          axi_rresp <= axi_okay_c;

        when 780 =>
          axi_rdata(31 downto 0) <= bl_ram194_value;
          axi_rresp <= axi_okay_c;

        when 784 =>
          axi_rdata(31 downto 0) <= bl_ram195_value;
          axi_rresp <= axi_okay_c;

        when 788 =>
          axi_rdata(31 downto 0) <= bl_ram196_value;
          axi_rresp <= axi_okay_c;

        when 792 =>
          axi_rdata(31 downto 0) <= bl_ram197_value;
          axi_rresp <= axi_okay_c;

        when 796 =>
          axi_rdata(31 downto 0) <= bl_ram198_value;
          axi_rresp <= axi_okay_c;

        when 800 =>
          axi_rdata(31 downto 0) <= bl_ram199_value;
          axi_rresp <= axi_okay_c;

        when 804 =>
          axi_rdata(31 downto 0) <= bl_ram200_value;
          axi_rresp <= axi_okay_c;

        when 808 =>
          axi_rdata(31 downto 0) <= bl_ram201_value;
          axi_rresp <= axi_okay_c;

        when 812 =>
          axi_rdata(31 downto 0) <= bl_ram202_value;
          axi_rresp <= axi_okay_c;

        when 816 =>
          axi_rdata(31 downto 0) <= bl_ram203_value;
          axi_rresp <= axi_okay_c;

        when 820 =>
          axi_rdata(31 downto 0) <= bl_ram204_value;
          axi_rresp <= axi_okay_c;

        when 824 =>
          axi_rdata(31 downto 0) <= bl_ram205_value;
          axi_rresp <= axi_okay_c;

        when 828 =>
          axi_rdata(31 downto 0) <= bl_ram206_value;
          axi_rresp <= axi_okay_c;

        when 832 =>
          axi_rdata(31 downto 0) <= bl_ram207_value;
          axi_rresp <= axi_okay_c;

        when 836 =>
          axi_rdata(31 downto 0) <= bl_ram208_value;
          axi_rresp <= axi_okay_c;

        when 840 =>
          axi_rdata(31 downto 0) <= bl_ram209_value;
          axi_rresp <= axi_okay_c;

        when 844 =>
          axi_rdata(31 downto 0) <= bl_ram210_value;
          axi_rresp <= axi_okay_c;

        when 848 =>
          axi_rdata(31 downto 0) <= bl_ram211_value;
          axi_rresp <= axi_okay_c;

        when 852 =>
          axi_rdata(31 downto 0) <= bl_ram212_value;
          axi_rresp <= axi_okay_c;

        when 856 =>
          axi_rdata(31 downto 0) <= bl_ram213_value;
          axi_rresp <= axi_okay_c;

        when 860 =>
          axi_rdata(31 downto 0) <= bl_ram214_value;
          axi_rresp <= axi_okay_c;

        when 864 =>
          axi_rdata(31 downto 0) <= bl_ram215_value;
          axi_rresp <= axi_okay_c;

        when 868 =>
          axi_rdata(31 downto 0) <= bl_ram216_value;
          axi_rresp <= axi_okay_c;

        when 872 =>
          axi_rdata(31 downto 0) <= bl_ram217_value;
          axi_rresp <= axi_okay_c;

        when 876 =>
          axi_rdata(31 downto 0) <= bl_ram218_value;
          axi_rresp <= axi_okay_c;

        when 880 =>
          axi_rdata(31 downto 0) <= bl_ram219_value;
          axi_rresp <= axi_okay_c;

        when 884 =>
          axi_rdata(31 downto 0) <= bl_ram220_value;
          axi_rresp <= axi_okay_c;

        when 888 =>
          axi_rdata(31 downto 0) <= bl_ram221_value;
          axi_rresp <= axi_okay_c;

        when 892 =>
          axi_rdata(31 downto 0) <= bl_ram222_value;
          axi_rresp <= axi_okay_c;

        when 896 =>
          axi_rdata(31 downto 0) <= bl_ram223_value;
          axi_rresp <= axi_okay_c;

        when 900 =>
          axi_rdata(31 downto 0) <= bl_ram224_value;
          axi_rresp <= axi_okay_c;

        when 904 =>
          axi_rdata(31 downto 0) <= bl_ram225_value;
          axi_rresp <= axi_okay_c;

        when 908 =>
          axi_rdata(31 downto 0) <= bl_ram226_value;
          axi_rresp <= axi_okay_c;

        when 912 =>
          axi_rdata(31 downto 0) <= bl_ram227_value;
          axi_rresp <= axi_okay_c;

        when 916 =>
          axi_rdata(31 downto 0) <= bl_ram228_value;
          axi_rresp <= axi_okay_c;

        when 920 =>
          axi_rdata(31 downto 0) <= bl_ram229_value;
          axi_rresp <= axi_okay_c;

        when 924 =>
          axi_rdata(31 downto 0) <= bl_ram230_value;
          axi_rresp <= axi_okay_c;

        when 928 =>
          axi_rdata(31 downto 0) <= bl_ram231_value;
          axi_rresp <= axi_okay_c;

        when 932 =>
          axi_rdata(31 downto 0) <= bl_ram232_value;
          axi_rresp <= axi_okay_c;

        when 936 =>
          axi_rdata(31 downto 0) <= bl_ram233_value;
          axi_rresp <= axi_okay_c;

        when 940 =>
          axi_rdata(31 downto 0) <= bl_ram234_value;
          axi_rresp <= axi_okay_c;

        when 944 =>
          axi_rdata(31 downto 0) <= bl_ram235_value;
          axi_rresp <= axi_okay_c;

        when 948 =>
          axi_rdata(31 downto 0) <= bl_ram236_value;
          axi_rresp <= axi_okay_c;

        when 952 =>
          axi_rdata(31 downto 0) <= bl_ram237_value;
          axi_rresp <= axi_okay_c;

        when 956 =>
          axi_rdata(31 downto 0) <= bl_ram238_value;
          axi_rresp <= axi_okay_c;

        when 960 =>
          axi_rdata(31 downto 0) <= bl_ram239_value;
          axi_rresp <= axi_okay_c;

        when 964 =>
          axi_rdata(31 downto 0) <= bl_ram240_value;
          axi_rresp <= axi_okay_c;

        when 968 =>
          axi_rdata(31 downto 0) <= bl_ram241_value;
          axi_rresp <= axi_okay_c;

        when 972 =>
          axi_rdata(31 downto 0) <= bl_ram242_value;
          axi_rresp <= axi_okay_c;

        when 976 =>
          axi_rdata(31 downto 0) <= bl_ram243_value;
          axi_rresp <= axi_okay_c;

        when 980 =>
          axi_rdata(31 downto 0) <= bl_ram244_value;
          axi_rresp <= axi_okay_c;

        when 984 =>
          axi_rdata(31 downto 0) <= bl_ram245_value;
          axi_rresp <= axi_okay_c;

        when 988 =>
          axi_rdata(31 downto 0) <= bl_ram246_value;
          axi_rresp <= axi_okay_c;

        when 992 =>
          axi_rdata(31 downto 0) <= bl_ram247_value;
          axi_rresp <= axi_okay_c;

        when 996 =>
          axi_rdata(31 downto 0) <= bl_ram248_value;
          axi_rresp <= axi_okay_c;

        when 1000 =>
          axi_rdata(31 downto 0) <= bl_ram249_value;
          axi_rresp <= axi_okay_c;

        when 1004 =>
          axi_rdata(31 downto 0) <= bl_ram250_value;
          axi_rresp <= axi_okay_c;

        when 1008 =>
          axi_rdata(31 downto 0) <= bl_ram251_value;
          axi_rresp <= axi_okay_c;

        when 1012 =>
          axi_rdata(31 downto 0) <= bl_ram252_value;
          axi_rresp <= axi_okay_c;

        when 1016 =>
          axi_rdata(31 downto 0) <= bl_ram253_value;
          axi_rresp <= axi_okay_c;

        when others => null;
      end case;
    end if;
  end process reading;

  writing : process (s_axi_aclk_i, s_axi_aresetn_i) is
    procedure reset is
    begin
      axi_bresp <= axi_addr_error_c;

      bl_ram0_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram1_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram2_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram3_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram4_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram5_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram6_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram7_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram8_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram9_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram10_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram11_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram12_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram13_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram14_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram15_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram16_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram17_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram18_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram19_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram20_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram21_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram22_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram23_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram24_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram25_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram26_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram27_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram28_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram29_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram30_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram31_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram32_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram33_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram34_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram35_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram36_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram37_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram38_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram39_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram40_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram41_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram42_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram43_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram44_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram45_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram46_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram47_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram48_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram49_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram50_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram51_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram52_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram53_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram54_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram55_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram56_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram57_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram58_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram59_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram60_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram61_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram62_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram63_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram64_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram65_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram66_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram67_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram68_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram69_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram70_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram71_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram72_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram73_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram74_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram75_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram76_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram77_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram78_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram79_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram80_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram81_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram82_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram83_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram84_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram85_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram86_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram87_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram88_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram89_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram90_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram91_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram92_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram93_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram94_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram95_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram96_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram97_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram98_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram99_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram100_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram101_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram102_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram103_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram104_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram105_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram106_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram107_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram108_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram109_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram110_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram111_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram112_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram113_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram114_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram115_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram116_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram117_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram118_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram119_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram120_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram121_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram122_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram123_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram124_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram125_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram126_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram127_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram128_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram129_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram130_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram131_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram132_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram133_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram134_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram135_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram136_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram137_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram138_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram139_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram140_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram141_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram142_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram143_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram144_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram145_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram146_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram147_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram148_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram149_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram150_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram151_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram152_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram153_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram154_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram155_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram156_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram157_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram158_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram159_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram160_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram161_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram162_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram163_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram164_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram165_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram166_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram167_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram168_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram169_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram170_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram171_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram172_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram173_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram174_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram175_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram176_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram177_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram178_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram179_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram180_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram181_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram182_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram183_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram184_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram185_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram186_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram187_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram188_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram189_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram190_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram191_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram192_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram193_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram194_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram195_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram196_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram197_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram198_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram199_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram200_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram201_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram202_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram203_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram204_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram205_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram206_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram207_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram208_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram209_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram210_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram211_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram212_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram213_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram214_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram215_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram216_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram217_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram218_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram219_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram220_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram221_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram222_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram223_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram224_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram225_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram226_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram227_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram228_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram229_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram230_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram231_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram232_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram233_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram234_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram235_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram236_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram237_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram238_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram239_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram240_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram241_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram242_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram243_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram244_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram245_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram246_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram247_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram248_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram249_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram250_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram251_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram252_value <= std_ulogic_vector(to_unsigned(0, 32));
      bl_ram253_value <= std_ulogic_vector(to_unsigned(0, 32));
    end procedure reset;
  begin -- process writing
    if s_axi_aresetn_i = '0' then
      reset;
    elsif rising_edge(s_axi_aclk_i) then
      -- Defaults

      if axi_awready = '1' and axi_wready = '1' and
        s_axi_awvalid_i = '1' and s_axi_wvalid_i = '1'
      then
        -- Defaults
        axi_bresp <= axi_addr_error_c;

        case to_integer(axi_awaddr) is
          when 4 =>
            bl_ram0_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 8 =>
            bl_ram1_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 12 =>
            bl_ram2_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 16 =>
            bl_ram3_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 20 =>
            bl_ram4_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 24 =>
            bl_ram5_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 28 =>
            bl_ram6_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 32 =>
            bl_ram7_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 36 =>
            bl_ram8_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 40 =>
            bl_ram9_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 44 =>
            bl_ram10_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 48 =>
            bl_ram11_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 52 =>
            bl_ram12_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 56 =>
            bl_ram13_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 60 =>
            bl_ram14_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 64 =>
            bl_ram15_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 68 =>
            bl_ram16_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 72 =>
            bl_ram17_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 76 =>
            bl_ram18_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 80 =>
            bl_ram19_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 84 =>
            bl_ram20_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 88 =>
            bl_ram21_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 92 =>
            bl_ram22_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 96 =>
            bl_ram23_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 100 =>
            bl_ram24_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 104 =>
            bl_ram25_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 108 =>
            bl_ram26_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 112 =>
            bl_ram27_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 116 =>
            bl_ram28_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 120 =>
            bl_ram29_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 124 =>
            bl_ram30_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 128 =>
            bl_ram31_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 132 =>
            bl_ram32_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 136 =>
            bl_ram33_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 140 =>
            bl_ram34_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 144 =>
            bl_ram35_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 148 =>
            bl_ram36_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 152 =>
            bl_ram37_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 156 =>
            bl_ram38_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 160 =>
            bl_ram39_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 164 =>
            bl_ram40_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 168 =>
            bl_ram41_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 172 =>
            bl_ram42_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 176 =>
            bl_ram43_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 180 =>
            bl_ram44_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 184 =>
            bl_ram45_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 188 =>
            bl_ram46_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 192 =>
            bl_ram47_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 196 =>
            bl_ram48_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 200 =>
            bl_ram49_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 204 =>
            bl_ram50_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 208 =>
            bl_ram51_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 212 =>
            bl_ram52_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 216 =>
            bl_ram53_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 220 =>
            bl_ram54_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 224 =>
            bl_ram55_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 228 =>
            bl_ram56_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 232 =>
            bl_ram57_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 236 =>
            bl_ram58_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 240 =>
            bl_ram59_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 244 =>
            bl_ram60_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 248 =>
            bl_ram61_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 252 =>
            bl_ram62_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 256 =>
            bl_ram63_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 260 =>
            bl_ram64_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 264 =>
            bl_ram65_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 268 =>
            bl_ram66_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 272 =>
            bl_ram67_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 276 =>
            bl_ram68_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 280 =>
            bl_ram69_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 284 =>
            bl_ram70_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 288 =>
            bl_ram71_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 292 =>
            bl_ram72_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 296 =>
            bl_ram73_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 300 =>
            bl_ram74_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 304 =>
            bl_ram75_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 308 =>
            bl_ram76_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 312 =>
            bl_ram77_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 316 =>
            bl_ram78_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 320 =>
            bl_ram79_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 324 =>
            bl_ram80_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 328 =>
            bl_ram81_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 332 =>
            bl_ram82_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 336 =>
            bl_ram83_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 340 =>
            bl_ram84_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 344 =>
            bl_ram85_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 348 =>
            bl_ram86_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 352 =>
            bl_ram87_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 356 =>
            bl_ram88_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 360 =>
            bl_ram89_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 364 =>
            bl_ram90_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 368 =>
            bl_ram91_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 372 =>
            bl_ram92_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 376 =>
            bl_ram93_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 380 =>
            bl_ram94_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 384 =>
            bl_ram95_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 388 =>
            bl_ram96_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 392 =>
            bl_ram97_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 396 =>
            bl_ram98_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 400 =>
            bl_ram99_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 404 =>
            bl_ram100_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 408 =>
            bl_ram101_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 412 =>
            bl_ram102_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 416 =>
            bl_ram103_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 420 =>
            bl_ram104_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 424 =>
            bl_ram105_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 428 =>
            bl_ram106_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 432 =>
            bl_ram107_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 436 =>
            bl_ram108_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 440 =>
            bl_ram109_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 444 =>
            bl_ram110_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 448 =>
            bl_ram111_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 452 =>
            bl_ram112_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 456 =>
            bl_ram113_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 460 =>
            bl_ram114_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 464 =>
            bl_ram115_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 468 =>
            bl_ram116_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 472 =>
            bl_ram117_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 476 =>
            bl_ram118_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 480 =>
            bl_ram119_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 484 =>
            bl_ram120_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 488 =>
            bl_ram121_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 492 =>
            bl_ram122_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 496 =>
            bl_ram123_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 500 =>
            bl_ram124_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 504 =>
            bl_ram125_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 508 =>
            bl_ram126_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 512 =>
            bl_ram127_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 516 =>
            bl_ram128_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 520 =>
            bl_ram129_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 524 =>
            bl_ram130_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 528 =>
            bl_ram131_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 532 =>
            bl_ram132_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 536 =>
            bl_ram133_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 540 =>
            bl_ram134_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 544 =>
            bl_ram135_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 548 =>
            bl_ram136_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 552 =>
            bl_ram137_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 556 =>
            bl_ram138_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 560 =>
            bl_ram139_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 564 =>
            bl_ram140_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 568 =>
            bl_ram141_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 572 =>
            bl_ram142_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 576 =>
            bl_ram143_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 580 =>
            bl_ram144_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 584 =>
            bl_ram145_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 588 =>
            bl_ram146_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 592 =>
            bl_ram147_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 596 =>
            bl_ram148_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 600 =>
            bl_ram149_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 604 =>
            bl_ram150_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 608 =>
            bl_ram151_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 612 =>
            bl_ram152_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 616 =>
            bl_ram153_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 620 =>
            bl_ram154_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 624 =>
            bl_ram155_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 628 =>
            bl_ram156_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 632 =>
            bl_ram157_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 636 =>
            bl_ram158_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 640 =>
            bl_ram159_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 644 =>
            bl_ram160_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 648 =>
            bl_ram161_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 652 =>
            bl_ram162_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 656 =>
            bl_ram163_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 660 =>
            bl_ram164_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 664 =>
            bl_ram165_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 668 =>
            bl_ram166_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 672 =>
            bl_ram167_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 676 =>
            bl_ram168_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 680 =>
            bl_ram169_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 684 =>
            bl_ram170_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 688 =>
            bl_ram171_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 692 =>
            bl_ram172_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 696 =>
            bl_ram173_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 700 =>
            bl_ram174_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 704 =>
            bl_ram175_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 708 =>
            bl_ram176_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 712 =>
            bl_ram177_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 716 =>
            bl_ram178_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 720 =>
            bl_ram179_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 724 =>
            bl_ram180_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 728 =>
            bl_ram181_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 732 =>
            bl_ram182_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 736 =>
            bl_ram183_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 740 =>
            bl_ram184_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 744 =>
            bl_ram185_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 748 =>
            bl_ram186_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 752 =>
            bl_ram187_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 756 =>
            bl_ram188_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 760 =>
            bl_ram189_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 764 =>
            bl_ram190_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 768 =>
            bl_ram191_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 772 =>
            bl_ram192_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 776 =>
            bl_ram193_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 780 =>
            bl_ram194_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 784 =>
            bl_ram195_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 788 =>
            bl_ram196_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 792 =>
            bl_ram197_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 796 =>
            bl_ram198_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 800 =>
            bl_ram199_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 804 =>
            bl_ram200_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 808 =>
            bl_ram201_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 812 =>
            bl_ram202_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 816 =>
            bl_ram203_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 820 =>
            bl_ram204_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 824 =>
            bl_ram205_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 828 =>
            bl_ram206_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 832 =>
            bl_ram207_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 836 =>
            bl_ram208_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 840 =>
            bl_ram209_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 844 =>
            bl_ram210_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 848 =>
            bl_ram211_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 852 =>
            bl_ram212_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 856 =>
            bl_ram213_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 860 =>
            bl_ram214_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 864 =>
            bl_ram215_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 868 =>
            bl_ram216_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 872 =>
            bl_ram217_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 876 =>
            bl_ram218_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 880 =>
            bl_ram219_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 884 =>
            bl_ram220_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 888 =>
            bl_ram221_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 892 =>
            bl_ram222_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 896 =>
            bl_ram223_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 900 =>
            bl_ram224_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 904 =>
            bl_ram225_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 908 =>
            bl_ram226_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 912 =>
            bl_ram227_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 916 =>
            bl_ram228_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 920 =>
            bl_ram229_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 924 =>
            bl_ram230_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 928 =>
            bl_ram231_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 932 =>
            bl_ram232_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 936 =>
            bl_ram233_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 940 =>
            bl_ram234_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 944 =>
            bl_ram235_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 948 =>
            bl_ram236_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 952 =>
            bl_ram237_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 956 =>
            bl_ram238_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 960 =>
            bl_ram239_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 964 =>
            bl_ram240_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 968 =>
            bl_ram241_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 972 =>
            bl_ram242_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 976 =>
            bl_ram243_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 980 =>
            bl_ram244_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 984 =>
            bl_ram245_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 988 =>
            bl_ram246_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 992 =>
            bl_ram247_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 996 =>
            bl_ram248_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 1000 =>
            bl_ram249_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 1004 =>
            bl_ram250_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 1008 =>
            bl_ram251_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 1012 =>
            bl_ram252_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;

          when 1016 =>
            bl_ram253_value <= s_axi_wdata_i(31 downto 0);
            axi_bresp <= axi_okay_c;


        -- Clear interrupts

        -- Clear interrupt errors
          when others => null;
        end case;
      end if;

      -- Set interrupts

      -- Generate interrupts

      -- Set interrupt errors
    end if;
  end process writing;

end architecture rtl;
