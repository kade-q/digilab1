
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity blu_tb is
--  Port ( );
end blu_tb;

architecture sim of blu_tb is
    component blu
        Port (operation: in std_logic_vector (1 downto 0);
          a,b: in std_logic_vector (7 downto 0);
          result: out std_logic_vector (7 downto 0)
        );
    end component;
    signal toperation: std_logic_vector (1 downto 0);
    signal ta, tb, tresult: std_logic_vector (7 downto 0);

begin
    dut: blu port map (operation => toperation, a => ta, b => tb, result => tresult);
    stimuli: process
    begin
        ta <= (others => '0');
        tb <= (others => '0');
        toperation <= "00";
        wait for 50 ns;
        ta <= "00000001";
        tb <= "00000001";
        toperation <= "00";
        wait for 50 ns;
        ta <= "01010101";
        tb <= "01101001";
        toperation <= "00";
        wait for 50 ns;
        ta <= (others => '0');
        tb <= (others => '0');
        toperation <= "01";
        wait for 50 ns;
        ta <= "00000001";
        tb <= "00000001";
        toperation <= "01";
        wait for 50 ns;
        ta <= "01010101";
        tb <= "01101001";
        toperation <= "01";
        wait for 50 ns;
        ta <= (others => '0');
        tb <= (others => '0');
        toperation <= "10";
        wait for 50 ns;
        ta <= "00000001";
        tb <= "00000001";
        toperation <= "10";
        wait for 50 ns;
        ta <= "01010101";
        tb <= "01101001";
        toperation <= "10";
        wait for 50 ns;
        ta <= (others => '0');
        tb <= (others => '0');
        toperation <= "11";
        wait for 50 ns;
        ta <= "00000001";
        tb <= "00000001";
        toperation <= "11";
        wait for 50 ns;
        ta <= "01010101";
        tb <= "01101001";
        toperation <= "11";
        wait for 50 ns;
        ta <= (others => 'U');
        tb <= (others => 'U');
        toperation <= "00";
        wait for 50 ns;
        ta <= "000000UX";
        tb <= "000000XX";
        toperation <= "00";
        wait for 50 ns;
        ta <= "0-UUU10-";
        tb <= "XX10-0-1";
        toperation <= "00";
        ta <= (others => 'U');
        tb <= (others => 'U');
        toperation <= "01";
        wait for 50 ns;
        ta <= "000000UX";
        tb <= "000000XX";
        toperation <= "01";
        wait for 50 ns;
        ta <= "0-UUU10-";
        tb <= "XX10-0-1";
        toperation <= "01";
        wait for 50 ns;
        ta <= (others => 'U');
        tb <= (others => 'U');
        toperation <= "10";
        wait for 50 ns;
        ta <= "000000UX";
        tb <= "000000XX";
        toperation <= "10";
        wait for 50 ns;
        ta <= "0-UUU10-";
        tb <= "XX10-0-1";
        toperation <= "10";
        wait for 50 ns; 
        ta <= (others => 'U');
        tb <= (others => 'U');
        toperation <= "11";
        wait for 50 ns;
        ta <= "000000UX";
        tb <= "000000XX";
        toperation <= "11";
        wait for 50 ns;
        ta <= "0-UUU10-";
        tb <= "XX10-0-1";
        toperation <= "11";      
        wait;
    end process stimuli;
    

end sim;
