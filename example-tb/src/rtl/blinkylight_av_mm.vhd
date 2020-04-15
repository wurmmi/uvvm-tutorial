-------------------------------------------------------------------------------
--! @file      blinkylight_av_mm.vhd
--! @author    Super Easy Register Scripting Engine (SERSE)
--! @copyright 2017-2019 Michael Wurm
--! @brief     Avalon MM register interface for BlinkyLight
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library blinkylightlib;
use blinkylightlib.blinkylight_pkg.all;

--! @brief Entity declaration of blinkylight_av_mm
--! @details
--! This is a generated wrapper to combine registers into record types for
--! easier component connection in the design.

entity blinkylight_av_mm is
  generic (
    read_delay_g : natural := 2);
  port (
    --! @name Clock and reset
    --! @{

    clk_i   : in std_ulogic;
    rst_n_i : in std_ulogic;

    --! @}
    --! @name Avalon MM Interface
    --! @{

    s1_address_i   : in  std_ulogic_vector(9 downto 0);
    s1_write_i     : in  std_ulogic;
    s1_writedata_i : in  std_ulogic_vector(31 downto 0);
    s1_read_i      : in  std_ulogic;
    s1_readdata_o  : out std_ulogic_vector(31 downto 0);
    s1_readdatavalid_o  : out std_ulogic;
    s1_response_o  : out std_ulogic_vector(1 downto 0);

    --! @}
    --! @name Register interface
    --! @{

    status_i    : in  status_t;
    control_o   : out control_t;
    interrupt_o : out interrupt_t);

    --! @}

end entity blinkylight_av_mm;


architecture rtl of blinkylight_av_mm is

  -----------------------------------------------------------------------------
  --! @name BlinkyLight Avalon MM Constants
  -----------------------------------------------------------------------------
  --! @{

  constant response_okay_c       : std_ulogic_vector(1 downto 0) := b"00";
  constant response_reserved_c   : std_ulogic_vector(1 downto 0) := b"01";
  constant response_slave_err_c  : std_ulogic_vector(1 downto 0) := b"10";
  constant response_decode_err_c : std_ulogic_vector(1 downto 0) := b"11";

  --! @}
  -----------------------------------------------------------------------------
  --! @name BlinkyLight Registers
  -----------------------------------------------------------------------------
  --! @{

  signal rdvalid  : std_ulogic_vector(read_delay_g-1 downto 0) := (others => '0');
  signal response : std_ulogic_vector(1 downto 0) := response_decode_err_c;
  signal rresp    : std_ulogic_vector(1 downto 0) := response_decode_err_c;
  signal wresp    : std_ulogic_vector(1 downto 0) := response_decode_err_c;
  signal raddr    : natural range 0 to 1020;

  signal bl_led_control_value : std_ulogic_vector(7 downto 0) := std_ulogic_vector(to_unsigned(0, 8));
  signal bl_ram0_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram1_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram2_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram3_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram4_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram5_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram6_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram7_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram8_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram9_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram10_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram11_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram12_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram13_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram14_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram15_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram16_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram17_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram18_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram19_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram20_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram21_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram22_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram23_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram24_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram25_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram26_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram27_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram28_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram29_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram30_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram31_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram32_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram33_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram34_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram35_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram36_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram37_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram38_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram39_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram40_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram41_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram42_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram43_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram44_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram45_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram46_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram47_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram48_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram49_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram50_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram51_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram52_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram53_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram54_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram55_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram56_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram57_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram58_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram59_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram60_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram61_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram62_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram63_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram64_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram65_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram66_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram67_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram68_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram69_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram70_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram71_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram72_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram73_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram74_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram75_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram76_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram77_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram78_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram79_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram80_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram81_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram82_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram83_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram84_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram85_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram86_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram87_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram88_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram89_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram90_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram91_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram92_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram93_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram94_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram95_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram96_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram97_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram98_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram99_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram100_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram101_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram102_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram103_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram104_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram105_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram106_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram107_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram108_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram109_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram110_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram111_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram112_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram113_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram114_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram115_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram116_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram117_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram118_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram119_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram120_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram121_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram122_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram123_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram124_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram125_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram126_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram127_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram128_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram129_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram130_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram131_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram132_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram133_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram134_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram135_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram136_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram137_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram138_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram139_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram140_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram141_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram142_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram143_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram144_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram145_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram146_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram147_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram148_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram149_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram150_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram151_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram152_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram153_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram154_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram155_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram156_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram157_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram158_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram159_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram160_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram161_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram162_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram163_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram164_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram165_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram166_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram167_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram168_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram169_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram170_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram171_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram172_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram173_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram174_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram175_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram176_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram177_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram178_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram179_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram180_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram181_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram182_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram183_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram184_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram185_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram186_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram187_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram188_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram189_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram190_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram191_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram192_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram193_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram194_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram195_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram196_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram197_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram198_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram199_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram200_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram201_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram202_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram203_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram204_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram205_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram206_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram207_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram208_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram209_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram210_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram211_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram212_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram213_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram214_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram215_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram216_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram217_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram218_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram219_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram220_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram221_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram222_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram223_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram224_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram225_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram226_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram227_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram228_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram229_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram230_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram231_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram232_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram233_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram234_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram235_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram236_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram237_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram238_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram239_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram240_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram241_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram242_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram243_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram244_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram245_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram246_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram247_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram248_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram249_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram250_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram251_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram252_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));
  signal bl_ram253_value : std_ulogic_vector(31 downto 0) := std_ulogic_vector(to_unsigned(305441741, 32));

  --! @}
  -----------------------------------------------------------------------------
  --! @name BlinkyLight Wires
  -----------------------------------------------------------------------------
  --! @{

  signal addr     : natural range 0 to 1020;
  signal readdata : std_ulogic_vector(s1_readdata_o'range);

  signal bl_magic_value_value : std_ulogic_vector(31 downto 0);

  --! @}

begin

  -----------------------------------------------------------------------------
  -- Outputs
  -----------------------------------------------------------------------------

  s1_readdata_o      <= readdata;
  s1_response_o      <= response;
  s1_readdatavalid_o <= rdvalid(rdvalid'high);

  control_o.led <= bl_led_control_value;
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

  addr <= to_integer(unsigned(s1_address_i));
  response <= rresp when rdvalid(rdvalid'high) = '1' else
              wresp when s1_write_i = '1' else
              response_decode_err_c;

  bl_magic_value_value <= status_i.magic_value;

  -----------------------------------------------------------------------------
  -- Registers
  -----------------------------------------------------------------------------

  regs : process (clk_i, rst_n_i) is
  procedure reset is
  begin
  end procedure reset;
  begin
    if rst_n_i = '0' then
      reset;
    elsif rising_edge(clk_i) then
      -- Defaults
      rdvalid <= rdvalid(read_delay_g-2 downto 0) & '0';

      if s1_read_i = '1' and rdvalid = (rdvalid'range => '0') then
        rdvalid(rdvalid'low) <= '1';
        raddr <= addr;
      end if;
    end if;
  end process regs;

  reading : process (clk_i, rst_n_i) is
  procedure reset is
  begin
    readdata <= (others => '0');
    --rdvalid <= (others => '0');
    rresp <= response_decode_err_c;
  end procedure reset;
  begin -- process reading
    if rst_n_i = '0' then
      reset;
    elsif rising_edge(clk_i) then
      -- Defaults
      readdata <= (others => '0');
      rresp <= response_decode_err_c;

      if rdvalid(rdvalid'low) = '1' then
        case raddr is
          when 0 =>
            readdata(31 downto 0) <= bl_magic_value_value;
            rresp <= response_okay_c;

          when 4 =>
            readdata(7 downto 0) <= bl_led_control_value;
            rresp <= response_okay_c;

          when 8 =>
            readdata(31 downto 0) <= bl_ram0_value;
            rresp <= response_okay_c;

          when 12 =>
            readdata(31 downto 0) <= bl_ram1_value;
            rresp <= response_okay_c;

          when 16 =>
            readdata(31 downto 0) <= bl_ram2_value;
            rresp <= response_okay_c;

          when 20 =>
            readdata(31 downto 0) <= bl_ram3_value;
            rresp <= response_okay_c;

          when 24 =>
            readdata(31 downto 0) <= bl_ram4_value;
            rresp <= response_okay_c;

          when 28 =>
            readdata(31 downto 0) <= bl_ram5_value;
            rresp <= response_okay_c;

          when 32 =>
            readdata(31 downto 0) <= bl_ram6_value;
            rresp <= response_okay_c;

          when 36 =>
            readdata(31 downto 0) <= bl_ram7_value;
            rresp <= response_okay_c;

          when 40 =>
            readdata(31 downto 0) <= bl_ram8_value;
            rresp <= response_okay_c;

          when 44 =>
            readdata(31 downto 0) <= bl_ram9_value;
            rresp <= response_okay_c;

          when 48 =>
            readdata(31 downto 0) <= bl_ram10_value;
            rresp <= response_okay_c;

          when 52 =>
            readdata(31 downto 0) <= bl_ram11_value;
            rresp <= response_okay_c;

          when 56 =>
            readdata(31 downto 0) <= bl_ram12_value;
            rresp <= response_okay_c;

          when 60 =>
            readdata(31 downto 0) <= bl_ram13_value;
            rresp <= response_okay_c;

          when 64 =>
            readdata(31 downto 0) <= bl_ram14_value;
            rresp <= response_okay_c;

          when 68 =>
            readdata(31 downto 0) <= bl_ram15_value;
            rresp <= response_okay_c;

          when 72 =>
            readdata(31 downto 0) <= bl_ram16_value;
            rresp <= response_okay_c;

          when 76 =>
            readdata(31 downto 0) <= bl_ram17_value;
            rresp <= response_okay_c;

          when 80 =>
            readdata(31 downto 0) <= bl_ram18_value;
            rresp <= response_okay_c;

          when 84 =>
            readdata(31 downto 0) <= bl_ram19_value;
            rresp <= response_okay_c;

          when 88 =>
            readdata(31 downto 0) <= bl_ram20_value;
            rresp <= response_okay_c;

          when 92 =>
            readdata(31 downto 0) <= bl_ram21_value;
            rresp <= response_okay_c;

          when 96 =>
            readdata(31 downto 0) <= bl_ram22_value;
            rresp <= response_okay_c;

          when 100 =>
            readdata(31 downto 0) <= bl_ram23_value;
            rresp <= response_okay_c;

          when 104 =>
            readdata(31 downto 0) <= bl_ram24_value;
            rresp <= response_okay_c;

          when 108 =>
            readdata(31 downto 0) <= bl_ram25_value;
            rresp <= response_okay_c;

          when 112 =>
            readdata(31 downto 0) <= bl_ram26_value;
            rresp <= response_okay_c;

          when 116 =>
            readdata(31 downto 0) <= bl_ram27_value;
            rresp <= response_okay_c;

          when 120 =>
            readdata(31 downto 0) <= bl_ram28_value;
            rresp <= response_okay_c;

          when 124 =>
            readdata(31 downto 0) <= bl_ram29_value;
            rresp <= response_okay_c;

          when 128 =>
            readdata(31 downto 0) <= bl_ram30_value;
            rresp <= response_okay_c;

          when 132 =>
            readdata(31 downto 0) <= bl_ram31_value;
            rresp <= response_okay_c;

          when 136 =>
            readdata(31 downto 0) <= bl_ram32_value;
            rresp <= response_okay_c;

          when 140 =>
            readdata(31 downto 0) <= bl_ram33_value;
            rresp <= response_okay_c;

          when 144 =>
            readdata(31 downto 0) <= bl_ram34_value;
            rresp <= response_okay_c;

          when 148 =>
            readdata(31 downto 0) <= bl_ram35_value;
            rresp <= response_okay_c;

          when 152 =>
            readdata(31 downto 0) <= bl_ram36_value;
            rresp <= response_okay_c;

          when 156 =>
            readdata(31 downto 0) <= bl_ram37_value;
            rresp <= response_okay_c;

          when 160 =>
            readdata(31 downto 0) <= bl_ram38_value;
            rresp <= response_okay_c;

          when 164 =>
            readdata(31 downto 0) <= bl_ram39_value;
            rresp <= response_okay_c;

          when 168 =>
            readdata(31 downto 0) <= bl_ram40_value;
            rresp <= response_okay_c;

          when 172 =>
            readdata(31 downto 0) <= bl_ram41_value;
            rresp <= response_okay_c;

          when 176 =>
            readdata(31 downto 0) <= bl_ram42_value;
            rresp <= response_okay_c;

          when 180 =>
            readdata(31 downto 0) <= bl_ram43_value;
            rresp <= response_okay_c;

          when 184 =>
            readdata(31 downto 0) <= bl_ram44_value;
            rresp <= response_okay_c;

          when 188 =>
            readdata(31 downto 0) <= bl_ram45_value;
            rresp <= response_okay_c;

          when 192 =>
            readdata(31 downto 0) <= bl_ram46_value;
            rresp <= response_okay_c;

          when 196 =>
            readdata(31 downto 0) <= bl_ram47_value;
            rresp <= response_okay_c;

          when 200 =>
            readdata(31 downto 0) <= bl_ram48_value;
            rresp <= response_okay_c;

          when 204 =>
            readdata(31 downto 0) <= bl_ram49_value;
            rresp <= response_okay_c;

          when 208 =>
            readdata(31 downto 0) <= bl_ram50_value;
            rresp <= response_okay_c;

          when 212 =>
            readdata(31 downto 0) <= bl_ram51_value;
            rresp <= response_okay_c;

          when 216 =>
            readdata(31 downto 0) <= bl_ram52_value;
            rresp <= response_okay_c;

          when 220 =>
            readdata(31 downto 0) <= bl_ram53_value;
            rresp <= response_okay_c;

          when 224 =>
            readdata(31 downto 0) <= bl_ram54_value;
            rresp <= response_okay_c;

          when 228 =>
            readdata(31 downto 0) <= bl_ram55_value;
            rresp <= response_okay_c;

          when 232 =>
            readdata(31 downto 0) <= bl_ram56_value;
            rresp <= response_okay_c;

          when 236 =>
            readdata(31 downto 0) <= bl_ram57_value;
            rresp <= response_okay_c;

          when 240 =>
            readdata(31 downto 0) <= bl_ram58_value;
            rresp <= response_okay_c;

          when 244 =>
            readdata(31 downto 0) <= bl_ram59_value;
            rresp <= response_okay_c;

          when 248 =>
            readdata(31 downto 0) <= bl_ram60_value;
            rresp <= response_okay_c;

          when 252 =>
            readdata(31 downto 0) <= bl_ram61_value;
            rresp <= response_okay_c;

          when 256 =>
            readdata(31 downto 0) <= bl_ram62_value;
            rresp <= response_okay_c;

          when 260 =>
            readdata(31 downto 0) <= bl_ram63_value;
            rresp <= response_okay_c;

          when 264 =>
            readdata(31 downto 0) <= bl_ram64_value;
            rresp <= response_okay_c;

          when 268 =>
            readdata(31 downto 0) <= bl_ram65_value;
            rresp <= response_okay_c;

          when 272 =>
            readdata(31 downto 0) <= bl_ram66_value;
            rresp <= response_okay_c;

          when 276 =>
            readdata(31 downto 0) <= bl_ram67_value;
            rresp <= response_okay_c;

          when 280 =>
            readdata(31 downto 0) <= bl_ram68_value;
            rresp <= response_okay_c;

          when 284 =>
            readdata(31 downto 0) <= bl_ram69_value;
            rresp <= response_okay_c;

          when 288 =>
            readdata(31 downto 0) <= bl_ram70_value;
            rresp <= response_okay_c;

          when 292 =>
            readdata(31 downto 0) <= bl_ram71_value;
            rresp <= response_okay_c;

          when 296 =>
            readdata(31 downto 0) <= bl_ram72_value;
            rresp <= response_okay_c;

          when 300 =>
            readdata(31 downto 0) <= bl_ram73_value;
            rresp <= response_okay_c;

          when 304 =>
            readdata(31 downto 0) <= bl_ram74_value;
            rresp <= response_okay_c;

          when 308 =>
            readdata(31 downto 0) <= bl_ram75_value;
            rresp <= response_okay_c;

          when 312 =>
            readdata(31 downto 0) <= bl_ram76_value;
            rresp <= response_okay_c;

          when 316 =>
            readdata(31 downto 0) <= bl_ram77_value;
            rresp <= response_okay_c;

          when 320 =>
            readdata(31 downto 0) <= bl_ram78_value;
            rresp <= response_okay_c;

          when 324 =>
            readdata(31 downto 0) <= bl_ram79_value;
            rresp <= response_okay_c;

          when 328 =>
            readdata(31 downto 0) <= bl_ram80_value;
            rresp <= response_okay_c;

          when 332 =>
            readdata(31 downto 0) <= bl_ram81_value;
            rresp <= response_okay_c;

          when 336 =>
            readdata(31 downto 0) <= bl_ram82_value;
            rresp <= response_okay_c;

          when 340 =>
            readdata(31 downto 0) <= bl_ram83_value;
            rresp <= response_okay_c;

          when 344 =>
            readdata(31 downto 0) <= bl_ram84_value;
            rresp <= response_okay_c;

          when 348 =>
            readdata(31 downto 0) <= bl_ram85_value;
            rresp <= response_okay_c;

          when 352 =>
            readdata(31 downto 0) <= bl_ram86_value;
            rresp <= response_okay_c;

          when 356 =>
            readdata(31 downto 0) <= bl_ram87_value;
            rresp <= response_okay_c;

          when 360 =>
            readdata(31 downto 0) <= bl_ram88_value;
            rresp <= response_okay_c;

          when 364 =>
            readdata(31 downto 0) <= bl_ram89_value;
            rresp <= response_okay_c;

          when 368 =>
            readdata(31 downto 0) <= bl_ram90_value;
            rresp <= response_okay_c;

          when 372 =>
            readdata(31 downto 0) <= bl_ram91_value;
            rresp <= response_okay_c;

          when 376 =>
            readdata(31 downto 0) <= bl_ram92_value;
            rresp <= response_okay_c;

          when 380 =>
            readdata(31 downto 0) <= bl_ram93_value;
            rresp <= response_okay_c;

          when 384 =>
            readdata(31 downto 0) <= bl_ram94_value;
            rresp <= response_okay_c;

          when 388 =>
            readdata(31 downto 0) <= bl_ram95_value;
            rresp <= response_okay_c;

          when 392 =>
            readdata(31 downto 0) <= bl_ram96_value;
            rresp <= response_okay_c;

          when 396 =>
            readdata(31 downto 0) <= bl_ram97_value;
            rresp <= response_okay_c;

          when 400 =>
            readdata(31 downto 0) <= bl_ram98_value;
            rresp <= response_okay_c;

          when 404 =>
            readdata(31 downto 0) <= bl_ram99_value;
            rresp <= response_okay_c;

          when 408 =>
            readdata(31 downto 0) <= bl_ram100_value;
            rresp <= response_okay_c;

          when 412 =>
            readdata(31 downto 0) <= bl_ram101_value;
            rresp <= response_okay_c;

          when 416 =>
            readdata(31 downto 0) <= bl_ram102_value;
            rresp <= response_okay_c;

          when 420 =>
            readdata(31 downto 0) <= bl_ram103_value;
            rresp <= response_okay_c;

          when 424 =>
            readdata(31 downto 0) <= bl_ram104_value;
            rresp <= response_okay_c;

          when 428 =>
            readdata(31 downto 0) <= bl_ram105_value;
            rresp <= response_okay_c;

          when 432 =>
            readdata(31 downto 0) <= bl_ram106_value;
            rresp <= response_okay_c;

          when 436 =>
            readdata(31 downto 0) <= bl_ram107_value;
            rresp <= response_okay_c;

          when 440 =>
            readdata(31 downto 0) <= bl_ram108_value;
            rresp <= response_okay_c;

          when 444 =>
            readdata(31 downto 0) <= bl_ram109_value;
            rresp <= response_okay_c;

          when 448 =>
            readdata(31 downto 0) <= bl_ram110_value;
            rresp <= response_okay_c;

          when 452 =>
            readdata(31 downto 0) <= bl_ram111_value;
            rresp <= response_okay_c;

          when 456 =>
            readdata(31 downto 0) <= bl_ram112_value;
            rresp <= response_okay_c;

          when 460 =>
            readdata(31 downto 0) <= bl_ram113_value;
            rresp <= response_okay_c;

          when 464 =>
            readdata(31 downto 0) <= bl_ram114_value;
            rresp <= response_okay_c;

          when 468 =>
            readdata(31 downto 0) <= bl_ram115_value;
            rresp <= response_okay_c;

          when 472 =>
            readdata(31 downto 0) <= bl_ram116_value;
            rresp <= response_okay_c;

          when 476 =>
            readdata(31 downto 0) <= bl_ram117_value;
            rresp <= response_okay_c;

          when 480 =>
            readdata(31 downto 0) <= bl_ram118_value;
            rresp <= response_okay_c;

          when 484 =>
            readdata(31 downto 0) <= bl_ram119_value;
            rresp <= response_okay_c;

          when 488 =>
            readdata(31 downto 0) <= bl_ram120_value;
            rresp <= response_okay_c;

          when 492 =>
            readdata(31 downto 0) <= bl_ram121_value;
            rresp <= response_okay_c;

          when 496 =>
            readdata(31 downto 0) <= bl_ram122_value;
            rresp <= response_okay_c;

          when 500 =>
            readdata(31 downto 0) <= bl_ram123_value;
            rresp <= response_okay_c;

          when 504 =>
            readdata(31 downto 0) <= bl_ram124_value;
            rresp <= response_okay_c;

          when 508 =>
            readdata(31 downto 0) <= bl_ram125_value;
            rresp <= response_okay_c;

          when 512 =>
            readdata(31 downto 0) <= bl_ram126_value;
            rresp <= response_okay_c;

          when 516 =>
            readdata(31 downto 0) <= bl_ram127_value;
            rresp <= response_okay_c;

          when 520 =>
            readdata(31 downto 0) <= bl_ram128_value;
            rresp <= response_okay_c;

          when 524 =>
            readdata(31 downto 0) <= bl_ram129_value;
            rresp <= response_okay_c;

          when 528 =>
            readdata(31 downto 0) <= bl_ram130_value;
            rresp <= response_okay_c;

          when 532 =>
            readdata(31 downto 0) <= bl_ram131_value;
            rresp <= response_okay_c;

          when 536 =>
            readdata(31 downto 0) <= bl_ram132_value;
            rresp <= response_okay_c;

          when 540 =>
            readdata(31 downto 0) <= bl_ram133_value;
            rresp <= response_okay_c;

          when 544 =>
            readdata(31 downto 0) <= bl_ram134_value;
            rresp <= response_okay_c;

          when 548 =>
            readdata(31 downto 0) <= bl_ram135_value;
            rresp <= response_okay_c;

          when 552 =>
            readdata(31 downto 0) <= bl_ram136_value;
            rresp <= response_okay_c;

          when 556 =>
            readdata(31 downto 0) <= bl_ram137_value;
            rresp <= response_okay_c;

          when 560 =>
            readdata(31 downto 0) <= bl_ram138_value;
            rresp <= response_okay_c;

          when 564 =>
            readdata(31 downto 0) <= bl_ram139_value;
            rresp <= response_okay_c;

          when 568 =>
            readdata(31 downto 0) <= bl_ram140_value;
            rresp <= response_okay_c;

          when 572 =>
            readdata(31 downto 0) <= bl_ram141_value;
            rresp <= response_okay_c;

          when 576 =>
            readdata(31 downto 0) <= bl_ram142_value;
            rresp <= response_okay_c;

          when 580 =>
            readdata(31 downto 0) <= bl_ram143_value;
            rresp <= response_okay_c;

          when 584 =>
            readdata(31 downto 0) <= bl_ram144_value;
            rresp <= response_okay_c;

          when 588 =>
            readdata(31 downto 0) <= bl_ram145_value;
            rresp <= response_okay_c;

          when 592 =>
            readdata(31 downto 0) <= bl_ram146_value;
            rresp <= response_okay_c;

          when 596 =>
            readdata(31 downto 0) <= bl_ram147_value;
            rresp <= response_okay_c;

          when 600 =>
            readdata(31 downto 0) <= bl_ram148_value;
            rresp <= response_okay_c;

          when 604 =>
            readdata(31 downto 0) <= bl_ram149_value;
            rresp <= response_okay_c;

          when 608 =>
            readdata(31 downto 0) <= bl_ram150_value;
            rresp <= response_okay_c;

          when 612 =>
            readdata(31 downto 0) <= bl_ram151_value;
            rresp <= response_okay_c;

          when 616 =>
            readdata(31 downto 0) <= bl_ram152_value;
            rresp <= response_okay_c;

          when 620 =>
            readdata(31 downto 0) <= bl_ram153_value;
            rresp <= response_okay_c;

          when 624 =>
            readdata(31 downto 0) <= bl_ram154_value;
            rresp <= response_okay_c;

          when 628 =>
            readdata(31 downto 0) <= bl_ram155_value;
            rresp <= response_okay_c;

          when 632 =>
            readdata(31 downto 0) <= bl_ram156_value;
            rresp <= response_okay_c;

          when 636 =>
            readdata(31 downto 0) <= bl_ram157_value;
            rresp <= response_okay_c;

          when 640 =>
            readdata(31 downto 0) <= bl_ram158_value;
            rresp <= response_okay_c;

          when 644 =>
            readdata(31 downto 0) <= bl_ram159_value;
            rresp <= response_okay_c;

          when 648 =>
            readdata(31 downto 0) <= bl_ram160_value;
            rresp <= response_okay_c;

          when 652 =>
            readdata(31 downto 0) <= bl_ram161_value;
            rresp <= response_okay_c;

          when 656 =>
            readdata(31 downto 0) <= bl_ram162_value;
            rresp <= response_okay_c;

          when 660 =>
            readdata(31 downto 0) <= bl_ram163_value;
            rresp <= response_okay_c;

          when 664 =>
            readdata(31 downto 0) <= bl_ram164_value;
            rresp <= response_okay_c;

          when 668 =>
            readdata(31 downto 0) <= bl_ram165_value;
            rresp <= response_okay_c;

          when 672 =>
            readdata(31 downto 0) <= bl_ram166_value;
            rresp <= response_okay_c;

          when 676 =>
            readdata(31 downto 0) <= bl_ram167_value;
            rresp <= response_okay_c;

          when 680 =>
            readdata(31 downto 0) <= bl_ram168_value;
            rresp <= response_okay_c;

          when 684 =>
            readdata(31 downto 0) <= bl_ram169_value;
            rresp <= response_okay_c;

          when 688 =>
            readdata(31 downto 0) <= bl_ram170_value;
            rresp <= response_okay_c;

          when 692 =>
            readdata(31 downto 0) <= bl_ram171_value;
            rresp <= response_okay_c;

          when 696 =>
            readdata(31 downto 0) <= bl_ram172_value;
            rresp <= response_okay_c;

          when 700 =>
            readdata(31 downto 0) <= bl_ram173_value;
            rresp <= response_okay_c;

          when 704 =>
            readdata(31 downto 0) <= bl_ram174_value;
            rresp <= response_okay_c;

          when 708 =>
            readdata(31 downto 0) <= bl_ram175_value;
            rresp <= response_okay_c;

          when 712 =>
            readdata(31 downto 0) <= bl_ram176_value;
            rresp <= response_okay_c;

          when 716 =>
            readdata(31 downto 0) <= bl_ram177_value;
            rresp <= response_okay_c;

          when 720 =>
            readdata(31 downto 0) <= bl_ram178_value;
            rresp <= response_okay_c;

          when 724 =>
            readdata(31 downto 0) <= bl_ram179_value;
            rresp <= response_okay_c;

          when 728 =>
            readdata(31 downto 0) <= bl_ram180_value;
            rresp <= response_okay_c;

          when 732 =>
            readdata(31 downto 0) <= bl_ram181_value;
            rresp <= response_okay_c;

          when 736 =>
            readdata(31 downto 0) <= bl_ram182_value;
            rresp <= response_okay_c;

          when 740 =>
            readdata(31 downto 0) <= bl_ram183_value;
            rresp <= response_okay_c;

          when 744 =>
            readdata(31 downto 0) <= bl_ram184_value;
            rresp <= response_okay_c;

          when 748 =>
            readdata(31 downto 0) <= bl_ram185_value;
            rresp <= response_okay_c;

          when 752 =>
            readdata(31 downto 0) <= bl_ram186_value;
            rresp <= response_okay_c;

          when 756 =>
            readdata(31 downto 0) <= bl_ram187_value;
            rresp <= response_okay_c;

          when 760 =>
            readdata(31 downto 0) <= bl_ram188_value;
            rresp <= response_okay_c;

          when 764 =>
            readdata(31 downto 0) <= bl_ram189_value;
            rresp <= response_okay_c;

          when 768 =>
            readdata(31 downto 0) <= bl_ram190_value;
            rresp <= response_okay_c;

          when 772 =>
            readdata(31 downto 0) <= bl_ram191_value;
            rresp <= response_okay_c;

          when 776 =>
            readdata(31 downto 0) <= bl_ram192_value;
            rresp <= response_okay_c;

          when 780 =>
            readdata(31 downto 0) <= bl_ram193_value;
            rresp <= response_okay_c;

          when 784 =>
            readdata(31 downto 0) <= bl_ram194_value;
            rresp <= response_okay_c;

          when 788 =>
            readdata(31 downto 0) <= bl_ram195_value;
            rresp <= response_okay_c;

          when 792 =>
            readdata(31 downto 0) <= bl_ram196_value;
            rresp <= response_okay_c;

          when 796 =>
            readdata(31 downto 0) <= bl_ram197_value;
            rresp <= response_okay_c;

          when 800 =>
            readdata(31 downto 0) <= bl_ram198_value;
            rresp <= response_okay_c;

          when 804 =>
            readdata(31 downto 0) <= bl_ram199_value;
            rresp <= response_okay_c;

          when 808 =>
            readdata(31 downto 0) <= bl_ram200_value;
            rresp <= response_okay_c;

          when 812 =>
            readdata(31 downto 0) <= bl_ram201_value;
            rresp <= response_okay_c;

          when 816 =>
            readdata(31 downto 0) <= bl_ram202_value;
            rresp <= response_okay_c;

          when 820 =>
            readdata(31 downto 0) <= bl_ram203_value;
            rresp <= response_okay_c;

          when 824 =>
            readdata(31 downto 0) <= bl_ram204_value;
            rresp <= response_okay_c;

          when 828 =>
            readdata(31 downto 0) <= bl_ram205_value;
            rresp <= response_okay_c;

          when 832 =>
            readdata(31 downto 0) <= bl_ram206_value;
            rresp <= response_okay_c;

          when 836 =>
            readdata(31 downto 0) <= bl_ram207_value;
            rresp <= response_okay_c;

          when 840 =>
            readdata(31 downto 0) <= bl_ram208_value;
            rresp <= response_okay_c;

          when 844 =>
            readdata(31 downto 0) <= bl_ram209_value;
            rresp <= response_okay_c;

          when 848 =>
            readdata(31 downto 0) <= bl_ram210_value;
            rresp <= response_okay_c;

          when 852 =>
            readdata(31 downto 0) <= bl_ram211_value;
            rresp <= response_okay_c;

          when 856 =>
            readdata(31 downto 0) <= bl_ram212_value;
            rresp <= response_okay_c;

          when 860 =>
            readdata(31 downto 0) <= bl_ram213_value;
            rresp <= response_okay_c;

          when 864 =>
            readdata(31 downto 0) <= bl_ram214_value;
            rresp <= response_okay_c;

          when 868 =>
            readdata(31 downto 0) <= bl_ram215_value;
            rresp <= response_okay_c;

          when 872 =>
            readdata(31 downto 0) <= bl_ram216_value;
            rresp <= response_okay_c;

          when 876 =>
            readdata(31 downto 0) <= bl_ram217_value;
            rresp <= response_okay_c;

          when 880 =>
            readdata(31 downto 0) <= bl_ram218_value;
            rresp <= response_okay_c;

          when 884 =>
            readdata(31 downto 0) <= bl_ram219_value;
            rresp <= response_okay_c;

          when 888 =>
            readdata(31 downto 0) <= bl_ram220_value;
            rresp <= response_okay_c;

          when 892 =>
            readdata(31 downto 0) <= bl_ram221_value;
            rresp <= response_okay_c;

          when 896 =>
            readdata(31 downto 0) <= bl_ram222_value;
            rresp <= response_okay_c;

          when 900 =>
            readdata(31 downto 0) <= bl_ram223_value;
            rresp <= response_okay_c;

          when 904 =>
            readdata(31 downto 0) <= bl_ram224_value;
            rresp <= response_okay_c;

          when 908 =>
            readdata(31 downto 0) <= bl_ram225_value;
            rresp <= response_okay_c;

          when 912 =>
            readdata(31 downto 0) <= bl_ram226_value;
            rresp <= response_okay_c;

          when 916 =>
            readdata(31 downto 0) <= bl_ram227_value;
            rresp <= response_okay_c;

          when 920 =>
            readdata(31 downto 0) <= bl_ram228_value;
            rresp <= response_okay_c;

          when 924 =>
            readdata(31 downto 0) <= bl_ram229_value;
            rresp <= response_okay_c;

          when 928 =>
            readdata(31 downto 0) <= bl_ram230_value;
            rresp <= response_okay_c;

          when 932 =>
            readdata(31 downto 0) <= bl_ram231_value;
            rresp <= response_okay_c;

          when 936 =>
            readdata(31 downto 0) <= bl_ram232_value;
            rresp <= response_okay_c;

          when 940 =>
            readdata(31 downto 0) <= bl_ram233_value;
            rresp <= response_okay_c;

          when 944 =>
            readdata(31 downto 0) <= bl_ram234_value;
            rresp <= response_okay_c;

          when 948 =>
            readdata(31 downto 0) <= bl_ram235_value;
            rresp <= response_okay_c;

          when 952 =>
            readdata(31 downto 0) <= bl_ram236_value;
            rresp <= response_okay_c;

          when 956 =>
            readdata(31 downto 0) <= bl_ram237_value;
            rresp <= response_okay_c;

          when 960 =>
            readdata(31 downto 0) <= bl_ram238_value;
            rresp <= response_okay_c;

          when 964 =>
            readdata(31 downto 0) <= bl_ram239_value;
            rresp <= response_okay_c;

          when 968 =>
            readdata(31 downto 0) <= bl_ram240_value;
            rresp <= response_okay_c;

          when 972 =>
            readdata(31 downto 0) <= bl_ram241_value;
            rresp <= response_okay_c;

          when 976 =>
            readdata(31 downto 0) <= bl_ram242_value;
            rresp <= response_okay_c;

          when 980 =>
            readdata(31 downto 0) <= bl_ram243_value;
            rresp <= response_okay_c;

          when 984 =>
            readdata(31 downto 0) <= bl_ram244_value;
            rresp <= response_okay_c;

          when 988 =>
            readdata(31 downto 0) <= bl_ram245_value;
            rresp <= response_okay_c;

          when 992 =>
            readdata(31 downto 0) <= bl_ram246_value;
            rresp <= response_okay_c;

          when 996 =>
            readdata(31 downto 0) <= bl_ram247_value;
            rresp <= response_okay_c;

          when 1000 =>
            readdata(31 downto 0) <= bl_ram248_value;
            rresp <= response_okay_c;

          when 1004 =>
            readdata(31 downto 0) <= bl_ram249_value;
            rresp <= response_okay_c;

          when 1008 =>
            readdata(31 downto 0) <= bl_ram250_value;
            rresp <= response_okay_c;

          when 1012 =>
            readdata(31 downto 0) <= bl_ram251_value;
            rresp <= response_okay_c;

          when 1016 =>
            readdata(31 downto 0) <= bl_ram252_value;
            rresp <= response_okay_c;

          when 1020 =>
            readdata(31 downto 0) <= bl_ram253_value;
            rresp <= response_okay_c;

          when others => null;
        end case;
      end if;
    end if;
  end process reading;

  writing : process (clk_i, rst_n_i) is
  procedure reset is
  begin
    wresp <= response_decode_err_c;

    bl_led_control_value <= std_ulogic_vector(to_unsigned(0, 8));
    bl_ram0_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram1_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram2_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram3_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram4_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram5_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram6_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram7_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram8_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram9_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram10_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram11_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram12_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram13_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram14_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram15_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram16_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram17_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram18_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram19_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram20_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram21_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram22_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram23_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram24_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram25_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram26_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram27_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram28_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram29_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram30_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram31_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram32_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram33_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram34_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram35_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram36_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram37_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram38_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram39_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram40_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram41_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram42_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram43_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram44_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram45_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram46_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram47_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram48_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram49_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram50_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram51_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram52_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram53_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram54_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram55_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram56_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram57_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram58_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram59_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram60_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram61_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram62_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram63_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram64_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram65_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram66_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram67_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram68_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram69_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram70_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram71_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram72_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram73_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram74_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram75_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram76_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram77_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram78_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram79_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram80_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram81_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram82_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram83_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram84_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram85_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram86_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram87_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram88_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram89_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram90_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram91_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram92_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram93_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram94_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram95_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram96_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram97_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram98_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram99_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram100_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram101_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram102_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram103_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram104_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram105_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram106_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram107_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram108_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram109_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram110_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram111_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram112_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram113_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram114_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram115_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram116_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram117_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram118_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram119_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram120_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram121_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram122_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram123_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram124_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram125_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram126_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram127_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram128_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram129_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram130_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram131_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram132_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram133_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram134_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram135_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram136_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram137_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram138_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram139_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram140_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram141_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram142_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram143_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram144_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram145_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram146_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram147_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram148_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram149_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram150_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram151_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram152_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram153_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram154_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram155_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram156_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram157_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram158_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram159_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram160_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram161_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram162_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram163_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram164_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram165_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram166_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram167_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram168_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram169_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram170_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram171_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram172_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram173_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram174_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram175_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram176_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram177_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram178_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram179_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram180_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram181_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram182_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram183_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram184_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram185_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram186_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram187_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram188_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram189_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram190_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram191_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram192_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram193_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram194_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram195_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram196_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram197_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram198_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram199_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram200_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram201_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram202_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram203_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram204_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram205_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram206_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram207_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram208_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram209_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram210_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram211_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram212_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram213_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram214_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram215_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram216_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram217_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram218_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram219_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram220_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram221_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram222_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram223_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram224_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram225_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram226_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram227_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram228_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram229_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram230_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram231_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram232_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram233_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram234_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram235_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram236_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram237_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram238_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram239_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram240_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram241_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram242_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram243_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram244_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram245_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram246_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram247_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram248_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram249_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram250_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram251_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram252_value <= std_ulogic_vector(to_unsigned(305441741, 32));
    bl_ram253_value <= std_ulogic_vector(to_unsigned(305441741, 32));
  end procedure reset;
  begin -- process writing
    if rst_n_i = '0' then
      reset;
    elsif rising_edge(clk_i) then
      -- Defaults

      if s1_write_i = '1' then
        wresp <= response_decode_err_c;

        case addr is
          when 4 =>
            bl_led_control_value <= s1_writedata_i(7 downto 0);
            wresp <= response_okay_c;

          when 8 =>
            bl_ram0_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 12 =>
            bl_ram1_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 16 =>
            bl_ram2_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 20 =>
            bl_ram3_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 24 =>
            bl_ram4_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 28 =>
            bl_ram5_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 32 =>
            bl_ram6_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 36 =>
            bl_ram7_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 40 =>
            bl_ram8_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 44 =>
            bl_ram9_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 48 =>
            bl_ram10_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 52 =>
            bl_ram11_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 56 =>
            bl_ram12_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 60 =>
            bl_ram13_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 64 =>
            bl_ram14_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 68 =>
            bl_ram15_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 72 =>
            bl_ram16_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 76 =>
            bl_ram17_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 80 =>
            bl_ram18_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 84 =>
            bl_ram19_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 88 =>
            bl_ram20_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 92 =>
            bl_ram21_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 96 =>
            bl_ram22_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 100 =>
            bl_ram23_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 104 =>
            bl_ram24_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 108 =>
            bl_ram25_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 112 =>
            bl_ram26_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 116 =>
            bl_ram27_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 120 =>
            bl_ram28_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 124 =>
            bl_ram29_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 128 =>
            bl_ram30_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 132 =>
            bl_ram31_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 136 =>
            bl_ram32_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 140 =>
            bl_ram33_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 144 =>
            bl_ram34_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 148 =>
            bl_ram35_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 152 =>
            bl_ram36_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 156 =>
            bl_ram37_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 160 =>
            bl_ram38_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 164 =>
            bl_ram39_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 168 =>
            bl_ram40_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 172 =>
            bl_ram41_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 176 =>
            bl_ram42_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 180 =>
            bl_ram43_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 184 =>
            bl_ram44_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 188 =>
            bl_ram45_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 192 =>
            bl_ram46_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 196 =>
            bl_ram47_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 200 =>
            bl_ram48_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 204 =>
            bl_ram49_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 208 =>
            bl_ram50_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 212 =>
            bl_ram51_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 216 =>
            bl_ram52_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 220 =>
            bl_ram53_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 224 =>
            bl_ram54_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 228 =>
            bl_ram55_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 232 =>
            bl_ram56_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 236 =>
            bl_ram57_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 240 =>
            bl_ram58_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 244 =>
            bl_ram59_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 248 =>
            bl_ram60_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 252 =>
            bl_ram61_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 256 =>
            bl_ram62_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 260 =>
            bl_ram63_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 264 =>
            bl_ram64_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 268 =>
            bl_ram65_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 272 =>
            bl_ram66_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 276 =>
            bl_ram67_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 280 =>
            bl_ram68_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 284 =>
            bl_ram69_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 288 =>
            bl_ram70_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 292 =>
            bl_ram71_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 296 =>
            bl_ram72_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 300 =>
            bl_ram73_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 304 =>
            bl_ram74_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 308 =>
            bl_ram75_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 312 =>
            bl_ram76_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 316 =>
            bl_ram77_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 320 =>
            bl_ram78_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 324 =>
            bl_ram79_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 328 =>
            bl_ram80_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 332 =>
            bl_ram81_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 336 =>
            bl_ram82_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 340 =>
            bl_ram83_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 344 =>
            bl_ram84_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 348 =>
            bl_ram85_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 352 =>
            bl_ram86_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 356 =>
            bl_ram87_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 360 =>
            bl_ram88_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 364 =>
            bl_ram89_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 368 =>
            bl_ram90_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 372 =>
            bl_ram91_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 376 =>
            bl_ram92_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 380 =>
            bl_ram93_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 384 =>
            bl_ram94_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 388 =>
            bl_ram95_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 392 =>
            bl_ram96_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 396 =>
            bl_ram97_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 400 =>
            bl_ram98_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 404 =>
            bl_ram99_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 408 =>
            bl_ram100_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 412 =>
            bl_ram101_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 416 =>
            bl_ram102_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 420 =>
            bl_ram103_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 424 =>
            bl_ram104_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 428 =>
            bl_ram105_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 432 =>
            bl_ram106_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 436 =>
            bl_ram107_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 440 =>
            bl_ram108_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 444 =>
            bl_ram109_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 448 =>
            bl_ram110_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 452 =>
            bl_ram111_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 456 =>
            bl_ram112_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 460 =>
            bl_ram113_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 464 =>
            bl_ram114_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 468 =>
            bl_ram115_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 472 =>
            bl_ram116_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 476 =>
            bl_ram117_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 480 =>
            bl_ram118_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 484 =>
            bl_ram119_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 488 =>
            bl_ram120_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 492 =>
            bl_ram121_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 496 =>
            bl_ram122_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 500 =>
            bl_ram123_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 504 =>
            bl_ram124_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 508 =>
            bl_ram125_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 512 =>
            bl_ram126_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 516 =>
            bl_ram127_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 520 =>
            bl_ram128_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 524 =>
            bl_ram129_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 528 =>
            bl_ram130_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 532 =>
            bl_ram131_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 536 =>
            bl_ram132_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 540 =>
            bl_ram133_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 544 =>
            bl_ram134_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 548 =>
            bl_ram135_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 552 =>
            bl_ram136_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 556 =>
            bl_ram137_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 560 =>
            bl_ram138_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 564 =>
            bl_ram139_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 568 =>
            bl_ram140_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 572 =>
            bl_ram141_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 576 =>
            bl_ram142_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 580 =>
            bl_ram143_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 584 =>
            bl_ram144_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 588 =>
            bl_ram145_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 592 =>
            bl_ram146_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 596 =>
            bl_ram147_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 600 =>
            bl_ram148_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 604 =>
            bl_ram149_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 608 =>
            bl_ram150_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 612 =>
            bl_ram151_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 616 =>
            bl_ram152_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 620 =>
            bl_ram153_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 624 =>
            bl_ram154_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 628 =>
            bl_ram155_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 632 =>
            bl_ram156_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 636 =>
            bl_ram157_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 640 =>
            bl_ram158_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 644 =>
            bl_ram159_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 648 =>
            bl_ram160_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 652 =>
            bl_ram161_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 656 =>
            bl_ram162_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 660 =>
            bl_ram163_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 664 =>
            bl_ram164_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 668 =>
            bl_ram165_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 672 =>
            bl_ram166_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 676 =>
            bl_ram167_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 680 =>
            bl_ram168_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 684 =>
            bl_ram169_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 688 =>
            bl_ram170_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 692 =>
            bl_ram171_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 696 =>
            bl_ram172_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 700 =>
            bl_ram173_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 704 =>
            bl_ram174_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 708 =>
            bl_ram175_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 712 =>
            bl_ram176_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 716 =>
            bl_ram177_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 720 =>
            bl_ram178_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 724 =>
            bl_ram179_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 728 =>
            bl_ram180_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 732 =>
            bl_ram181_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 736 =>
            bl_ram182_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 740 =>
            bl_ram183_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 744 =>
            bl_ram184_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 748 =>
            bl_ram185_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 752 =>
            bl_ram186_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 756 =>
            bl_ram187_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 760 =>
            bl_ram188_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 764 =>
            bl_ram189_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 768 =>
            bl_ram190_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 772 =>
            bl_ram191_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 776 =>
            bl_ram192_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 780 =>
            bl_ram193_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 784 =>
            bl_ram194_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 788 =>
            bl_ram195_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 792 =>
            bl_ram196_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 796 =>
            bl_ram197_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 800 =>
            bl_ram198_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 804 =>
            bl_ram199_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 808 =>
            bl_ram200_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 812 =>
            bl_ram201_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 816 =>
            bl_ram202_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 820 =>
            bl_ram203_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 824 =>
            bl_ram204_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 828 =>
            bl_ram205_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 832 =>
            bl_ram206_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 836 =>
            bl_ram207_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 840 =>
            bl_ram208_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 844 =>
            bl_ram209_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 848 =>
            bl_ram210_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 852 =>
            bl_ram211_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 856 =>
            bl_ram212_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 860 =>
            bl_ram213_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 864 =>
            bl_ram214_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 868 =>
            bl_ram215_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 872 =>
            bl_ram216_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 876 =>
            bl_ram217_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 880 =>
            bl_ram218_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 884 =>
            bl_ram219_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 888 =>
            bl_ram220_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 892 =>
            bl_ram221_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 896 =>
            bl_ram222_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 900 =>
            bl_ram223_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 904 =>
            bl_ram224_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 908 =>
            bl_ram225_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 912 =>
            bl_ram226_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 916 =>
            bl_ram227_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 920 =>
            bl_ram228_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 924 =>
            bl_ram229_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 928 =>
            bl_ram230_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 932 =>
            bl_ram231_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 936 =>
            bl_ram232_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 940 =>
            bl_ram233_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 944 =>
            bl_ram234_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 948 =>
            bl_ram235_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 952 =>
            bl_ram236_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 956 =>
            bl_ram237_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 960 =>
            bl_ram238_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 964 =>
            bl_ram239_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 968 =>
            bl_ram240_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 972 =>
            bl_ram241_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 976 =>
            bl_ram242_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 980 =>
            bl_ram243_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 984 =>
            bl_ram244_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 988 =>
            bl_ram245_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 992 =>
            bl_ram246_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 996 =>
            bl_ram247_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 1000 =>
            bl_ram248_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 1004 =>
            bl_ram249_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 1008 =>
            bl_ram250_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 1012 =>
            bl_ram251_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 1016 =>
            bl_ram252_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;

          when 1020 =>
            bl_ram253_value <= s1_writedata_i(31 downto 0);
            wresp <= response_okay_c;


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
