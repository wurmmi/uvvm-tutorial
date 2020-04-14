-------------------------------------------------------------------------------
--! @file      blinkylight_av_mm.vhd
--! @author    Super Easy Register Scripting Engine (SERSE)
--! @copyright 2017-2020 Michael Wurm
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
    read_delay_g : NATURAL := 2);
  port (
    --! @name Clock and reset
    --! @{

    clk_i   : in std_ulogic;
    rst_n_i : in std_ulogic;

    --! @}
    --! @name Avalon MM Interface
    --! @{

    s1_address_i       : in std_ulogic_vector(6 downto 0);
    s1_write_i         : in std_ulogic;
    s1_writedata_i     : in std_ulogic_vector(31 downto 0);
    s1_read_i          : in std_ulogic;
    s1_readdata_o      : out std_ulogic_vector(31 downto 0);
    s1_readdatavalid_o : out std_ulogic;
    s1_response_o      : out std_ulogic_vector(1 downto 0);

    --! @}
    --! @name Register interface
    --! @{

    status_i    : in status_t;
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

  signal rdvalid  : std_ulogic_vector(read_delay_g - 1 downto 0) := (others => '0');
  signal response : std_ulogic_vector(1 downto 0)                := response_decode_err_c;
  signal rresp    : std_ulogic_vector(1 downto 0)                := response_decode_err_c;
  signal wresp    : std_ulogic_vector(1 downto 0)                := response_decode_err_c;
  signal raddr    : NATURAL range 0 to 72;

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

  signal addr     : NATURAL range 0 to 72;
  signal readdata : std_ulogic_vector(s1_readdata_o'range);

  signal bl_status_keys         : std_ulogic;
  signal bl_status_fpga_running : std_ulogic;
  signal bl_magic_value_value   : std_ulogic_vector(31 downto 0);
  signal bl_irqs_key_set        : std_ulogic;
  signal bl_irqs_pps_set        : std_ulogic;

  --! @}

begin

  -----------------------------------------------------------------------------
  -- Outputs
  -----------------------------------------------------------------------------

  s1_readdata_o      <= readdata;
  s1_response_o      <= response;
  s1_readdatavalid_o <= rdvalid(rdvalid'high);

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

  addr     <= to_integer(unsigned(s1_address_i));
  response <= rresp when rdvalid(rdvalid'high) = '1' else
    wresp when s1_write_i = '1' else
    response_decode_err_c;

  bl_status_keys         <= status_i.key;
  bl_status_fpga_running <= status_i.running;
  bl_magic_value_value   <= status_i.magic_value;
  bl_irqs_key_set        <= status_i.key;
  bl_irqs_pps_set        <= status_i.pps;

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
      rdvalid <= rdvalid(read_delay_g - 2 downto 0) & '0';

      if s1_read_i = '1' and rdvalid = (rdvalid'range => '0') then
        rdvalid(rdvalid'low) <= '1';
        raddr                <= addr;
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
      rresp    <= response_decode_err_c;

      if rdvalid(rdvalid'low) = '1' then
        case raddr is
          when 0 =>
            readdata(0) <= bl_status_keys;
            readdata(1) <= bl_status_fpga_running;
            rresp       <= response_okay_c;

          when 8 =>
            readdata(8 downto 0) <= bl_led_dimmvalue0_value;
            rresp                <= response_okay_c;

          when 12 =>
            readdata(8 downto 0) <= bl_led_dimmvalue1_value;
            rresp                <= response_okay_c;

          when 16 =>
            readdata(8 downto 0) <= bl_led_dimmvalue2_value;
            rresp                <= response_okay_c;

          when 20 =>
            readdata(8 downto 0) <= bl_led_dimmvalue3_value;
            rresp                <= response_okay_c;

          when 24 =>
            readdata(8 downto 0) <= bl_led_dimmvalue4_value;
            rresp                <= response_okay_c;

          when 28 =>
            readdata(8 downto 0) <= bl_led_dimmvalue5_value;
            rresp                <= response_okay_c;

          when 32 =>
            readdata(8 downto 0) <= bl_led_dimmvalue6_value;
            rresp                <= response_okay_c;

          when 36 =>
            readdata(8 downto 0) <= bl_led_dimmvalue7_value;
            rresp                <= response_okay_c;

          when 40 =>
            readdata(4 downto 0) <= bl_sev_segment_display0_value;
            rresp                <= response_okay_c;

          when 44 =>
            readdata(4 downto 0) <= bl_sev_segment_display1_value;
            rresp                <= response_okay_c;

          when 48 =>
            readdata(4 downto 0) <= bl_sev_segment_display2_value;
            rresp                <= response_okay_c;

          when 52 =>
            readdata(4 downto 0) <= bl_sev_segment_display3_value;
            rresp                <= response_okay_c;

          when 56 =>
            readdata(4 downto 0) <= bl_sev_segment_display4_value;
            rresp                <= response_okay_c;

          when 60 =>
            readdata(4 downto 0) <= bl_sev_segment_display5_value;
            rresp                <= response_okay_c;

          when 64 =>
            readdata(31 downto 0) <= bl_magic_value_value;
            rresp                 <= response_okay_c;

          when 68 =>
            readdata(0) <= bl_irqs_key;
            readdata(1) <= bl_irqs_pps;
            rresp       <= response_okay_c;

          when 72 =>
            readdata(0) <= bl_irq_errors_key;
            readdata(1) <= bl_irq_errors_pps;
            rresp       <= response_okay_c;

          when others => null;
        end case;
      end if;
    end if;
  end process reading;

  writing : process (clk_i, rst_n_i) is
    procedure reset is
    begin
      wresp <= response_decode_err_c;

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
    if rst_n_i = '0' then
      reset;
    elsif rising_edge(clk_i) then
      -- Defaults

      if s1_write_i = '1' then
        wresp <= response_decode_err_c;

        case addr is
          when 4 =>
            bl_gui_control_update_enable <= s1_writedata_i(0);
            bl_gui_control_blank_sevseg  <= s1_writedata_i(1);
            wresp                        <= response_okay_c;

          when 8 =>
            bl_led_dimmvalue0_value <= s1_writedata_i(8 downto 0);
            wresp                   <= response_okay_c;

          when 12 =>
            bl_led_dimmvalue1_value <= s1_writedata_i(8 downto 0);
            wresp                   <= response_okay_c;

          when 16 =>
            bl_led_dimmvalue2_value <= s1_writedata_i(8 downto 0);
            wresp                   <= response_okay_c;

          when 20 =>
            bl_led_dimmvalue3_value <= s1_writedata_i(8 downto 0);
            wresp                   <= response_okay_c;

          when 24 =>
            bl_led_dimmvalue4_value <= s1_writedata_i(8 downto 0);
            wresp                   <= response_okay_c;

          when 28 =>
            bl_led_dimmvalue5_value <= s1_writedata_i(8 downto 0);
            wresp                   <= response_okay_c;

          when 32 =>
            bl_led_dimmvalue6_value <= s1_writedata_i(8 downto 0);
            wresp                   <= response_okay_c;

          when 36 =>
            bl_led_dimmvalue7_value <= s1_writedata_i(8 downto 0);
            wresp                   <= response_okay_c;

          when 40 =>
            bl_sev_segment_display0_value <= s1_writedata_i(4 downto 0);
            wresp                         <= response_okay_c;

          when 44 =>
            bl_sev_segment_display1_value <= s1_writedata_i(4 downto 0);
            wresp                         <= response_okay_c;

          when 48 =>
            bl_sev_segment_display2_value <= s1_writedata_i(4 downto 0);
            wresp                         <= response_okay_c;

          when 52 =>
            bl_sev_segment_display3_value <= s1_writedata_i(4 downto 0);
            wresp                         <= response_okay_c;

          when 56 =>
            bl_sev_segment_display4_value <= s1_writedata_i(4 downto 0);
            wresp                         <= response_okay_c;

          when 60 =>
            bl_sev_segment_display5_value <= s1_writedata_i(4 downto 0);
            wresp                         <= response_okay_c;
            -- Clear interrupts
          when 68 =>
            if s1_writedata_i(0) = '1' then
              bl_irqs_key <= '0';
            end if;
            if s1_writedata_i(1) = '1' then
              bl_irqs_pps <= '0';
            end if;
            wresp <= response_okay_c;

            -- Clear interrupt errors
          when 72 =>
            if s1_writedata_i(0) = '1' then
              bl_irq_errors_key <= '0';
            end if;
            if s1_writedata_i(1) = '1' then
              bl_irq_errors_pps <= '0';
            end if;
            wresp <= response_okay_c;

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
