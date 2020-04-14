-------------------------------------------------------------------------------
--! @file      blinkylight_pkg.vhd
--! @author    Michael Wurm <wurm.michael95@gmail.com>
--! @copyright 2017-2019 Michael Wurm
--! @brief     BlinkyLight package with global types and constants.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library blinkylightlib;
use blinkylightlib.blinkylight_spec_pkg.all;

--! @brief Package declaration of blinkylight_pkg
--! @details
--! The BlinkyLight package with global types and constants.

package blinkylight_pkg is
  -----------------------------------------------------------------------------
  -- Types and Constants
  -----------------------------------------------------------------------------

  --! System clock frequency
  constant clk_freq_c : natural := 50E6;

  --! System clock period
  constant clk_period_c : time := 1 sec / clk_freq_c;

  --! Number of keys
  constant num_of_keys_c : natural := 3;

  --! Number of switches
  constant num_of_switches_c : natural := 10;

  --! Number of leds
  constant num_of_leds_c : natural := spec_num_leds_c;

  --! Number of sevensegment displays
  constant num_of_sevsegs_c : natural := spec_num_sevsegs_c;

  --! Startup delay
  constant startup_delay_num_clks_c : natural := 512;

  --! PPS period
  constant pps_period_c : time := 10 us;

  --! LED dimm counter frequency
  constant led_count_inc_period_c : time := 100 ns;

  --! Number of registers in register interface
  constant num_registers_c : natural := spec_num_registers_c;

  --! Register interface address bus width
  constant reg_if_addr_width_c : natural := spec_reg_if_addr_width_c;

  --! Magic register valus
  constant magic_value_c : std_ulogic_vector(31 downto 0) := x"4711ABCD";

  --! Dimmvalue for a single led
  subtype dimmvalue_t is std_ulogic_vector(8 downto 0);

  --! Array of dimmvalues
  type dimmvalues_t is array(0 to num_of_leds_c - 1) of dimmvalue_t;

  --! Character value for a single sevensegment display
  subtype sevseg_char_t is std_ulogic_vector(4 downto 0);

  --! Array of sevensegment display character values
  type sevseg_displays_t is array(0 to num_of_sevsegs_c - 1)
    of sevseg_char_t;

  --! Value for a single sevensegment display
  subtype sevseg_t is std_ulogic_vector(6 downto 0);
  subtype sevseg_logic_t is std_logic_vector(6 downto 0);

  --! Array of sevensegment display values
  type sevsegs_t is array(0 to num_of_sevsegs_c - 1)
    of sevseg_t;
  type sevsegs_logic_t is array(0 to num_of_sevsegs_c - 1)
    of sevseg_logic_t;

  type status_t is record
    --! @brief BlinkyLight's status registers
    --! @param Signalize that FPGA is running.
    --! @param pps Pulse per second.
    --! @param key Key status of all keys.
    --! @param magic_value Magic value constant.
    running     : std_ulogic;
    pps         : std_ulogic;
    key         : std_ulogic;
    magic_value : std_ulogic_vector(31 downto 0);
  end record status_t;

  type gui_ctrl_t is record
    --! @brief GUI control registers
    --! @param enable_update Enables LEDs and Sevensegments to update.
    --! @param blank Blank Sevenegments.
    enable_update : std_ulogic;
    blank_sevsegs : std_ulogic;
  end record gui_ctrl_t;

  type control_t is record
    --! @brief BlinkyLight's control registers
    --! @param led_dimmvalues Dimmvalues for unit LedDimmable.
    --! @param sevseg_displays Sevensegment displays' values.
    --! @param gui_ctrl GUI Controls.
    led_dimmvalues  : dimmvalues_t;
    sevseg_displays : sevseg_displays_t;
    gui_ctrl        : gui_ctrl_t;
  end record control_t;

  type interrupt_t is record
    --! @brief Interrupts
    --! @param irq Global interrupt.
    irq : std_ulogic;
  end record interrupt_t;

  --! Special characters for sevensegment display
  constant sevseg_char_dash_c  : natural := 16;
  constant sevseg_char_blank_c : natural := 17;

  -----------------------------------------------------------------------------
  -- Functions
  -----------------------------------------------------------------------------

  --! Converts hex to sevensegment binary format
  function to_sevseg(value : sevseg_char_t
                     ) return std_ulogic_vector;

  --! Returns the logarithm of base 2 as an integer
  function log_dualis(number : natural
                      ) return natural;

end package blinkylight_pkg;

package body blinkylight_pkg is

  function to_sevseg(value : sevseg_char_t)
    return std_ulogic_vector is
  begin
    case to_integer(unsigned(value)) is
      when 0  => return "0111111";
      when 1  => return "0000110";
      when 2  => return "1011011";
      when 3  => return "1001111";
      when 4  => return "1100110";
      when 5  => return "1101101";
      when 6  => return "1111101";
      when 7  => return "0000111";
      when 8  => return "1111111";
      when 9  => return "1101111";
      when 10 => return "1110111";
      when 11 => return "1111100";
      when 12 => return "0111001";
      when 13 => return "1011110";
      when 14 => return "1111001";
      when 15 => return "1110001";
      when sevseg_char_dash_c =>
        return "0000001";
      when sevseg_char_blank_c =>
        return "1001001";
      when others => return "XXXXXXX";
    end case;
  end function to_sevseg;

  function log_dualis(number : natural)
    return natural is
    variable climb_up_v : natural := 1;
    variable result_v   : natural := 0;
  begin
    while climb_up_v < number loop
      climb_up_v := climb_up_v * 2;
      result_v   := result_v + 1;
    end loop;
    return result_v;
  end function log_dualis;

end package body blinkylight_pkg;
