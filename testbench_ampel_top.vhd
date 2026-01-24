-- Testbench Ampel
-- during simulation clock is 10 ms and divider is 100
-- so sec_puls is still every second, but simulation is
-- 1 000 000 times faster
-- otherwise 1 sec simulation time takes 2 minutes real time

--Libraries
library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;

entity testbench_ampel_top is
--port(
--      --keine IOs in Testbench
--    );
end testbench_ampel_top;

architecture sim of testbench_ampel_top is




--Deklaration Signale, Konstante
--Folgende Werte fuer eine schnellere Simulation anpassen. 
--clk_divide_value wird dann als Generic an die zu simulierende
--Schaltung ampel_top weitergegeben
  constant c_divide_value : integer := 99;       --fast simulation parmeters
  constant clk_period     : time    := 10 ms;    --statt 100 MHz nur 100 Hz
--
--Deklaration der Komponenten
  component ampel_top
    generic (
              divide_value : integer := 99_999_999
              ); 
      port(
              clk_100mhz: in  std_logic; --100 MHz Systemclock auf NEXYS4 Board (Quarz)
              rst_n     : in  std_logic; --active low
              led_out   : out std_logic_vector(8 downto 0); --LEDs auf NEXYS4 Board Gruppennummer 0 bis 511
              haupt1    : out std_logic_vector(2 downto 0);
              haupt2    : out std_logic_vector(2 downto 0);
              neben3    : out std_logic_vector(2 downto 0);
              neben4    : out std_logic_vector(2 downto 0)
              );
  end component;

  --Signakle
  signal tb_clk       : std_logic := '0';
  signal tb_rst_n     : std_logic; 
  signal tb_led_out   : std_logic_vector(8 downto 0);
  signal tb_haupt1    : std_logic_vector(2 downto 0);
  signal tb_haupt2    : std_logic_vector(2 downto 0);
  signal tb_neben3    : std_logic_vector(2 downto 0);
  signal tb_neben4    : std_logic_vector(2 downto 0);

begin
    dut: ampel_top
      generic map(
           divide_value => c_divide_value        
                  )
      port map (
           clk_100mhz =>  tb_clk,
           rst_n      =>  tb_rst_n,
           led_out    =>  tb_led_out,
           haupt1     =>  tb_haupt1,
           haupt2     =>  tb_haupt2,
           neben3     =>  tb_neben3,
           neben4     =>  tb_neben4
                );

       --Clock   

      clk_gen: process (tb_clk)
      begin
        tb_clk <= not tb_clk after (clk_period / 2);
      end process clk_gen;
      
      --Reset

      rst_proc: process
      begin
        tb_rst_n <= '0';
        --tb_clk <= '0';
        wait for 50 ms;
        tb_rst_n <= '1';
        wait;
      end process rst_proc;

end architecture sim;
