
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fcalc_tb is
   
end fcalc_tb;

architecture sim of fcalc_tb is
    component fcalc
         Port (a,b: in signed (7 downto 0);
         en: in std_logic;
         c: out signed (8 downto 0)
         );
    end component;
    signal ta, tb: signed (7 downto 0);
    signal ten: std_logic; 
    signal tc: signed (8 downto 0);
begin
    dut: fcalc port map (a => ta, b => tb, en => ten, c => tc);
    stimuli: process
    begin
        wait for 50 ns;
        ten <= '1';
        ta <= "10000000";
        tb <= "01111111";
        wait for 50 ns;
        ten <= '0';
        wait for 50 ns;
        ta <= "01111111";
        tb <= "10000000";
        wait for 50 ns;
        ten <= '1';
        wait for 50 ns;
        ta <= "01010101";
        tb <= "10000000";
        wait for 50 ns;
        ta <= "01111111";
        tb <= "10101010";
        wait for 50 ns;
        ta <= "11111110";
        tb <= "10101010";
        wait;
    end process stimuli;
end sim;
