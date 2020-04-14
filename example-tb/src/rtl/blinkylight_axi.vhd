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
    read_delay_g : NATURAL := 2);
  port (
    --! @name AXI clock and reset
    --! @{

    s_axi_aclk_i    : in std_ulogic;
    s_axi_aresetn_i : in std_ulogic;

    --! @}
    --! @name AXI write address
    --! @{

    s_axi_awaddr_i  : in std_ulogic_vector(6 downto 0);
    s_axi_awprot_i  : in std_ulogic_vector(2 downto 0);
    s_axi_awvalid_i : in std_ulogic;
    s_axi_awready_o : out std_ulogic;

    --! @}
    --! @name AXI write data
    --! @{

    s_axi_wdata_i  : in std_ulogic_vector(31 downto 0);
    s_axi_wstrb_i  : in std_ulogic_vector(3 downto 0);
    s_axi_wvalid_i : in std_ulogic;
    s_axi_wready_o : out std_ulogic;

    --! @}
    --! @name AXI write response
    --! @{

    s_axi_bresp_o  : out std_ulogic_vector(1 downto 0);
    s_axi_bvalid_o : out std_ulogic;
    s_axi_bready_i : in std_ulogic;

    --! @}
    --! @name AXI read address
    --! @{

    s_axi_araddr_i  : in std_ulogic_vector(6 downto 0);
    s_axi_arprot_i  : in std_ulogic_vector(2 downto 0);
    s_axi_arvalid_i : in std_ulogic;
    s_axi_arready_o : out std_ulogic;

    --! @}
    --! @name AXI read data
    --! @{

    s_axi_rdata_o  : out std_ulogic_vector(31 downto 0);
    s_axi_rresp_o  : out std_ulogic_vector(1 downto 0);
    s_axi_rvalid_o : out std_ulogic;
    s_axi_rready_i : in std_ulogic;

    --! @}
    --! @name Register interface
    --! @{

    status_i    : in status_t;
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
  signal axi_rvalid  : std_ulogic_vector(read_delay_g - 1 downto 0);
  signal axi_rdata   : std_ulogic_vector(s_axi_rdata_o'range);
  signal axi_rresp   : std_ulogic_vector(s_axi_rresp_o'range);

  --! @}
  -----------------------------------------------------------------------------
  --! @name BlinkyLight Registers
  -----------------------------------------------------------------------------
  --! @{

  signal bl_gui_control_update_enable  : std_ulogic                    := '0';
  signal bl_gui_control_blank_sevseg   : std_ulogic                    := '0';
  signal bl_led_dimmvalue0_value       : std_ulogic_vector(8 downto 0) := std_ulogic_vector(to_unsigned(0, 9));
  signal bl_led_dimmvalue1_value       : std_ulogic_vector(8 downto 0) := std_ulogic_vector(to_unsigned(0, 9));
  signal bl_led_dimmvalue2_value       : std_ulogic_vector(8 downto 0) := std_ulogic_vector(to_unsigned(0, 9));
  signal bl_led_dimmvalue3_value       : std_ulogic_vector(8 downto 0) := std_ulogic_vector(to_unsigned(0, 9));
  signal bl_led_dimmvalue4_value       : std_ulogic_vector(8 downto 0) := std_ulogic_vector(to_unsigned(0, 9));
  signal bl_led_dimmvalue5_value       : std_ulogic_vector(8 downto 0) := std_ulogic_vector(to_unsigned(0, 9));
  signal bl_led_dimmvalue6_value       : std_ulogic_vector(8 downto 0) := std_ulogic_vector(to_unsigned(0, 9));
  signal bl_led_dimmvalue7_value       : std_ulogic_vector(8 downto 0) := std_ulogic_vector(to_unsigned(0, 9));
  signal bl_sev_segment_display0_value : std_ulogic_vector(4 downto 0) := std_ulogic_vector(to_unsigned(17, 5));
  signal bl_sev_segment_display1_value : std_ulogic_vector(4 downto 0) := std_ulogic_vector(to_unsigned(17, 5));
  signal bl_sev_segment_display2_value : std_ulogic_vector(4 downto 0) := std_ulogic_vector(to_unsigned(17, 5));
  signal bl_sev_segment_display3_value : std_ulogic_vector(4 downto 0) := std_ulogic_vector(to_unsigned(17, 5));
  signal bl_sev_segment_display4_value : std_ulogic_vector(4 downto 0) := std_ulogic_vector(to_unsigned(17, 5));
  signal bl_sev_segment_display5_value : std_ulogic_vector(4 downto 0) := std_ulogic_vector(to_unsigned(17, 5));
  signal bl_irqs_valid                 : std_ulogic                    := '0';
  signal bl_irqs                       : std_ulogic                    := '0';
  signal bl_irqs_key                   : std_ulogic                    := '0';
  signal bl_irqs_pps                   : std_ulogic                    := '0';
  signal bl_irq_errors_key             : std_ulogic                    := '0';
  signal bl_irq_errors_pps             : std_ulogic                    := '0';

  --! @}
  -----------------------------------------------------------------------------
  --! @name BlinkyLight Wires
  -----------------------------------------------------------------------------
  --! @{

  signal bl_status_keys         : std_ulogic;
  signal bl_status_fpga_running : std_ulogic;
  signal bl_magic_value_value   : std_ulogic_vector(31 downto 0);
  signal bl_irqs_key_set        : std_ulogic;
  signal bl_irqs_pps_set        : std_ulogic;
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

  control_o.gui_ctrl.enable_update <= bl_gui_control_update_enable;
  control_o.gui_ctrl.blank_sevsegs <= bl_gui_control_blank_sevseg;
  control_o.led_dimmvalues(0)      <= bl_led_dimmvalue0_value;
  control_o.led_dimmvalues(1)      <= bl_led_dimmvalue1_value;
  control_o.led_dimmvalues(2)      <= bl_led_dimmvalue2_value;
  control_o.led_dimmvalues(3)      <= bl_led_dimmvalue3_value;
  control_o.led_dimmvalues(4)      <= bl_led_dimmvalue4_value;
  control_o.led_dimmvalues(5)      <= bl_led_dimmvalue5_value;
  control_o.led_dimmvalues(6)      <= bl_led_dimmvalue6_value;
  control_o.led_dimmvalues(7)      <= bl_led_dimmvalue7_value;
  control_o.sevseg_displays(0)     <= bl_sev_segment_display0_value;
  control_o.sevseg_displays(1)     <= bl_sev_segment_display1_value;
  control_o.sevseg_displays(2)     <= bl_sev_segment_display2_value;
  control_o.sevseg_displays(3)     <= bl_sev_segment_display3_value;
  control_o.sevseg_displays(4)     <= bl_sev_segment_display4_value;
  control_o.sevseg_displays(5)     <= bl_sev_segment_display5_value;
  interrupt_o.irq                  <= bl_irqs;

  -----------------------------------------------------------------------------
  -- Signal Assignments
  -----------------------------------------------------------------------------

  bl_status_keys         <= status_i.key;
  bl_status_fpga_running <= status_i.running;
  bl_magic_value_value   <= status_i.magic_value;
  bl_irqs_key_set        <= status_i.key;
  bl_irqs_pps_set        <= status_i.pps;

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

      axi_rvalid <= axi_rvalid(axi_rvalid'high - 1 downto axi_rvalid'low) & '0';

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
          axi_rdata(0) <= bl_status_keys;
          axi_rdata(1) <= bl_status_fpga_running;
          axi_rresp    <= axi_okay_c;

        when 8 =>
          axi_rdata(8 downto 0) <= bl_led_dimmvalue0_value;
          axi_rresp             <= axi_okay_c;

        when 12 =>
          axi_rdata(8 downto 0) <= bl_led_dimmvalue1_value;
          axi_rresp             <= axi_okay_c;

        when 16 =>
          axi_rdata(8 downto 0) <= bl_led_dimmvalue2_value;
          axi_rresp             <= axi_okay_c;

        when 20 =>
          axi_rdata(8 downto 0) <= bl_led_dimmvalue3_value;
          axi_rresp             <= axi_okay_c;

        when 24 =>
          axi_rdata(8 downto 0) <= bl_led_dimmvalue4_value;
          axi_rresp             <= axi_okay_c;

        when 28 =>
          axi_rdata(8 downto 0) <= bl_led_dimmvalue5_value;
          axi_rresp             <= axi_okay_c;

        when 32 =>
          axi_rdata(8 downto 0) <= bl_led_dimmvalue6_value;
          axi_rresp             <= axi_okay_c;

        when 36 =>
          axi_rdata(8 downto 0) <= bl_led_dimmvalue7_value;
          axi_rresp             <= axi_okay_c;

        when 40 =>
          axi_rdata(4 downto 0) <= bl_sev_segment_display0_value;
          axi_rresp             <= axi_okay_c;

        when 44 =>
          axi_rdata(4 downto 0) <= bl_sev_segment_display1_value;
          axi_rresp             <= axi_okay_c;

        when 48 =>
          axi_rdata(4 downto 0) <= bl_sev_segment_display2_value;
          axi_rresp             <= axi_okay_c;

        when 52 =>
          axi_rdata(4 downto 0) <= bl_sev_segment_display3_value;
          axi_rresp             <= axi_okay_c;

        when 56 =>
          axi_rdata(4 downto 0) <= bl_sev_segment_display4_value;
          axi_rresp             <= axi_okay_c;

        when 60 =>
          axi_rdata(4 downto 0) <= bl_sev_segment_display5_value;
          axi_rresp             <= axi_okay_c;

        when 64 =>
          axi_rdata(31 downto 0) <= bl_magic_value_value;
          axi_rresp              <= axi_okay_c;

        when 68 =>
          axi_rdata(0) <= bl_irqs_key;
          axi_rdata(1) <= bl_irqs_pps;
          axi_rresp    <= axi_okay_c;

        when 72 =>
          axi_rdata(0) <= bl_irq_errors_key;
          axi_rdata(1) <= bl_irq_errors_pps;
          axi_rresp    <= axi_okay_c;

        when others => null;
      end case;
    end if;
  end process reading;

  writing : process (s_axi_aclk_i, s_axi_aresetn_i) is
    procedure reset is
    begin
      axi_bresp <= axi_addr_error_c;

      bl_gui_control_update_enable  <= '0';
      bl_gui_control_blank_sevseg   <= '0';
      bl_led_dimmvalue0_value       <= std_ulogic_vector(to_unsigned(0, 9));
      bl_led_dimmvalue1_value       <= std_ulogic_vector(to_unsigned(0, 9));
      bl_led_dimmvalue2_value       <= std_ulogic_vector(to_unsigned(0, 9));
      bl_led_dimmvalue3_value       <= std_ulogic_vector(to_unsigned(0, 9));
      bl_led_dimmvalue4_value       <= std_ulogic_vector(to_unsigned(0, 9));
      bl_led_dimmvalue5_value       <= std_ulogic_vector(to_unsigned(0, 9));
      bl_led_dimmvalue6_value       <= std_ulogic_vector(to_unsigned(0, 9));
      bl_led_dimmvalue7_value       <= std_ulogic_vector(to_unsigned(0, 9));
      bl_sev_segment_display0_value <= std_ulogic_vector(to_unsigned(17, 5));
      bl_sev_segment_display1_value <= std_ulogic_vector(to_unsigned(17, 5));
      bl_sev_segment_display2_value <= std_ulogic_vector(to_unsigned(17, 5));
      bl_sev_segment_display3_value <= std_ulogic_vector(to_unsigned(17, 5));
      bl_sev_segment_display4_value <= std_ulogic_vector(to_unsigned(17, 5));
      bl_sev_segment_display5_value <= std_ulogic_vector(to_unsigned(17, 5));
      bl_irqs                       <= '0';
      bl_irqs_key                   <= '0';
      bl_irqs_pps                   <= '0';
      bl_irq_errors_key             <= '0';
      bl_irq_errors_pps             <= '0';
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
            bl_gui_control_update_enable <= s_axi_wdata_i(0);
            bl_gui_control_blank_sevseg  <= s_axi_wdata_i(1);
            axi_bresp                    <= axi_okay_c;

          when 8 =>
            bl_led_dimmvalue0_value <= s_axi_wdata_i(8 downto 0);
            axi_bresp               <= axi_okay_c;

          when 12 =>
            bl_led_dimmvalue1_value <= s_axi_wdata_i(8 downto 0);
            axi_bresp               <= axi_okay_c;

          when 16 =>
            bl_led_dimmvalue2_value <= s_axi_wdata_i(8 downto 0);
            axi_bresp               <= axi_okay_c;

          when 20 =>
            bl_led_dimmvalue3_value <= s_axi_wdata_i(8 downto 0);
            axi_bresp               <= axi_okay_c;

          when 24 =>
            bl_led_dimmvalue4_value <= s_axi_wdata_i(8 downto 0);
            axi_bresp               <= axi_okay_c;

          when 28 =>
            bl_led_dimmvalue5_value <= s_axi_wdata_i(8 downto 0);
            axi_bresp               <= axi_okay_c;

          when 32 =>
            bl_led_dimmvalue6_value <= s_axi_wdata_i(8 downto 0);
            axi_bresp               <= axi_okay_c;

          when 36 =>
            bl_led_dimmvalue7_value <= s_axi_wdata_i(8 downto 0);
            axi_bresp               <= axi_okay_c;

          when 40 =>
            bl_sev_segment_display0_value <= s_axi_wdata_i(4 downto 0);
            axi_bresp                     <= axi_okay_c;

          when 44 =>
            bl_sev_segment_display1_value <= s_axi_wdata_i(4 downto 0);
            axi_bresp                     <= axi_okay_c;

          when 48 =>
            bl_sev_segment_display2_value <= s_axi_wdata_i(4 downto 0);
            axi_bresp                     <= axi_okay_c;

          when 52 =>
            bl_sev_segment_display3_value <= s_axi_wdata_i(4 downto 0);
            axi_bresp                     <= axi_okay_c;

          when 56 =>
            bl_sev_segment_display4_value <= s_axi_wdata_i(4 downto 0);
            axi_bresp                     <= axi_okay_c;

          when 60 =>
            bl_sev_segment_display5_value <= s_axi_wdata_i(4 downto 0);
            axi_bresp                     <= axi_okay_c;
            -- Clear interrupts
          when 68 =>
            if s_axi_wdata_i(0) = '1' then
              bl_irqs_key <= '0';
            end if;
            if s_axi_wdata_i(1) = '1' then
              bl_irqs_pps <= '0';
            end if;
            axi_bresp <= axi_okay_c;
            -- Clear interrupt errors
          when 72 =>
            if s_axi_wdata_i(0) = '1' then
              bl_irq_errors_key <= '0';
            end if;
            if s_axi_wdata_i(1) = '1' then
              bl_irq_errors_pps <= '0';
            end if;
            axi_bresp <= axi_okay_c;

          when others => null;
        end case;
      end if;

      -- Set interrupts
      if bl_irqs_key_set = '1' then
        bl_irqs_key <= '1';
      end if;

      if bl_irqs_pps_set = '1' then
        bl_irqs_pps <= '1';
      end if;
      -- Generate interrupts
      if
        bl_irqs_key = '1' or
        bl_irqs_pps = '1'
        then
        bl_irqs <= '1';
      else
        bl_irqs <= '0';
      end if;
      -- Set interrupt errors
      if bl_irqs_key = '1' and
        bl_irqs_key_set = '1'
        then
        bl_irq_errors_key <= '1';
      end if;

      if bl_irqs_pps = '1' and
        bl_irqs_pps_set = '1'
        then
        bl_irq_errors_pps <= '1';
      end if;

    end if;
  end process writing;

end architecture rtl;
