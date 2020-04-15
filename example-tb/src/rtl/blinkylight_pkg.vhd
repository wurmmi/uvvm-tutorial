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

  --! AXI access time for a single access
  constant axi_access_time_c : time := 4 * clk_period_c;

  --! Number of leds
  constant num_of_leds_c : natural := 8;

  --! Size of RAM
  constant ram_length_c : natural := spec_ram_length_c;

  --! Startup delay
  constant startup_delay_num_clks_c : natural := 512;

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
    --! @param magic_value Magic value constant.
    running     : std_ulogic;
    magic_value : std_ulogic_vector(31 downto 0);
  end record status_t;

  subtype led_port_t is std_ulogic_vector(num_of_leds_c - 1 downto 0);

  type control_t is record
    --! @brief BlinkyLight's control registers
    --! @param ram Data store.
    --! @param led Physical LED value representation.
    ram  : ram_t;
    led  : led_port_t;
  end record control_t;

  type interrupt_t is record
    --! @brief Interrupts
    --! @param irq Global interrupt.
    irq : std_ulogic;
  end record interrupt_t;

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
