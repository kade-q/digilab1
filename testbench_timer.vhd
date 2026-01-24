library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_timer is 
end testbench_timer;

architecture sim of testbench_timer is
  component timer
    port
     (clk_100mhz: in  std_logic; --100 MHz Systemclock (Quarz auf NEXYS4 )
      reset     : in  std_logic;
      sec_puls  : out std_logic
     );
  end component;

  signal tb_clk : std_logic := '0';
  signal tb_reset: std_logic;
  signal tb_sec_puls: std_logic;

begin
  dut: timer 
    generic map(divide_value => 99)
    port map(clk_100mhz => tb_clk, reset => tb_reset, sec_puls => tb_sec_puls);

  clk_gen: process (tb_clk)
  begin
    tb_clk <= not tb_clk after 5 ns;
  end process clk_gen;

  rst: process
  begin
    tb_reset <= '1';
    wait for 10 ns;
    tb_reset <= '0';   
    wait for 53 ns;
    tb_reset <= '1';
    wait for 21 ns;
    tb_reset <= '0';
    wait;
  end process rst; 

end architecture sim;
