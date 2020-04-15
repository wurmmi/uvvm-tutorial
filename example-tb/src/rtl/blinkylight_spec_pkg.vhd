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
  constant spec_num_registers_c     : natural := 256;

  -- Register interface address bus width
  constant spec_reg_if_addr_width_c : natural := 10;

  -- Constants inferred from blinkylight.yaml
  constant spec_ram_length_c : natural := 254;

  --! @}

end package blinkylight_spec_pkg;

package body blinkylight_spec_pkg is
end package body blinkylight_spec_pkg;
