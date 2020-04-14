-------------------------------------------------------------------------------
--! @file      blinkylight_spec_pkg.vhd
--! @author    Super Easy Register Scripting Engine (SERSE)
--! @copyright 2017-2020 Michael Wurm
--! @brief     Specification package for BlinkyLight
-------------------------------------------------------------------------------

package blinkylight_spec_pkg is
  -----------------------------------------------------------------------------
  --! @name Types and Constants
  -----------------------------------------------------------------------------
  --! @{

  -- Number of registers in AXI register map
  constant spec_num_registers_c : NATURAL := 19;

  -- Register interface address bus width
  constant spec_reg_if_addr_width_c : NATURAL := 7;

  -- Constants inferred from blinkylight.yaml
  constant spec_num_leds_c    : NATURAL := 8;
  constant spec_num_sevsegs_c : NATURAL := 6;

  --! @}

end package blinkylight_spec_pkg;

package body blinkylight_spec_pkg is
end package body blinkylight_spec_pkg;
