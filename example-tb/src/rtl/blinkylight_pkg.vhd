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

  --! Number of keys
  constant num_of_leds_c : natural := 8;

  --! Number of switches
  constant num_of_switches_c : natural := 10;

  --! Size of RAM
  constant ram_length_c : natural := spec_ram_length;

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

  --! RAM data element
  subtype ram_data_elem_t is std_ulogic_vector(31 downto 0);

  --! Array of dimmvalues
  type ram_t is array(0 to ram_length_c - 1) of ram_data_elem_t;


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
    --! @param ram Data store.
    --! @param gui_ctrl GUI Controls.
    ram  : ram_t;
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

  --! Returns the logarithm of base 2 as an integer
  function log_dualis(number : natural
                      ) return natural;

end package blinkylight_pkg;

package body blinkylight_pkg is

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
