-------------------------------------------------------------------------------
--! @file      blinkylight_spec_pkg.vhd
--! @author    Super Easy Register Scripting Engine (SERSE)
--! @copyright 2017-2019 Michael Wurm
--! @brief     Specification package for BlinkyLight
-------------------------------------------------------------------------------

package blinkylight_spec_pkg is
  -----------------------------------------------------------------------------
  --! @name Types and Constants
  -----------------------------------------------------------------------------
  --! @{

  -- Number of registers in AXI register map
  constant spec_num_registers_c     : natural := 19;

  -- Register interface address bus width
  constant spec_reg_if_addr_width_c : natural := 7;

  -- Constants inferred from blinkylight.yaml
  constant spec_num_leds_c : natural := 8;
  constant spec_num_sevsegs_c : natural := 6;

  --! @}

end package blinkylight_spec_pkg;

package body blinkylight_spec_pkg is
end package body blinkylight_spec_pkg;
