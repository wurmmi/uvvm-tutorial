-------------------------------------------------------------------------------
--! @file      startup_delay.vhd
--! @author    Michael Wurm <wurm.michael95@gmail.com>
--! @copyright 2017-2020 Michael Wurm
--! @brief     Implementation of startup_delay.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library blinkylightlib;

--! @brief Entity declaration of startup_delay
--! @details
--! The startup_delay implementation.

entity startup_delay is
  generic (
    num_clk_cycles : natural := 1024);
  port (
    --! @name Clocks and resets
    --! @{

    --! System clock
    clk_i   : in std_logic;
    --! Asynchronous reset
    rst_n_i : in std_logic;

    --! @}

    --! @name Startup delay signals
    --! @{

    signal_o : out std_ulogic);

  --! @}

end entity startup_delay;

--! RTL implementation of startup_delay
architecture rtl of startup_delay is
  -----------------------------------------------------------------------------
  --! @name Internal Wires
  -----------------------------------------------------------------------------
  --! @{

  signal sig : std_ulogic;

  --! @}
  -----------------------------------------------------------------------------
  --! @name Internal Registers
  -----------------------------------------------------------------------------
  --! @{

  signal cnt : natural range 0 to num_clk_cycles-1 := num_clk_cycles-1;

  --! @}

begin  -- architecture rtl

  -----------------------------------------------------------------------------
  -- Outputs
  -----------------------------------------------------------------------------

  signal_o <= sig;

  ------------------------------------------------------------------------------
  -- Registers
  ------------------------------------------------------------------------------

  regs : process(clk_i, rst_n_i)
    procedure reset is
    begin
      sig <= '0';
      cnt <= num_clk_cycles-1;
    end procedure reset;
  begin  -- process regs
    if rst_n_i = '0' then
      reset;
    elsif rising_edge(clk_i) then
      if cnt = 0 then
        sig <= '1';
      else
        cnt <= cnt - 1;
      end if;
    end if;
  end process regs;

end architecture rtl;
