
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pcu_tb is

end pcu_tb;

architecture sim of pcu_tb is

component pcu
    Port (clk: in std_logic;
    reset: in std_logic;
    load: in std_logic;
    jump: in std_logic;
    stop: in std_logic;
    loadvalue: in std_logic_vector (15 downto 0);
    pc: out std_logic_vector (15 downto 0)
     );
end component;

signal clk_tb: std_logic;
signal reset_tb: std_logic;
signal load_tb: std_logic;
signal jump_tb: std_logic;
signal stop_tb: std_logic;
signal loadvalue_tb: std_logic_vector (15 downto 0);
signal pc_tb: std_logic_vector (15 downto 0);
signal initialized: std_logic;
signal inputs_tb: std_logic_vector (2 downto 0);

begin

DUT: pcu port map(
    clk => clk_tb,
    reset => reset_tb,
    load => load_tb,
    jump => jump_tb,
    stop => stop_tb,
    loadvalue => loadvalue_tb,
    pc => pc_tb);
    
clk_gen: process
begin
    clk_tb <= transport '1' after 5 ns, '0' after 10 ns;
    wait for 10 ns;
end process clk_gen;

rst_gen: process
begin
    reset_tb <= transport '1' after 22 ns, '0' after 37 ns;
    wait;
end process rst_gen;

initialize: process
begin
    wait until reset_tb = '1';
    wait until reset_tb = '0';
    loadvalue_tb <= "0000000000001111"; 
    initialized <= '1';
    
end process initialize;

inputs: process
begin
    wait until initialized = '1' and clk_tb = '0';
        case inputs_tb is
        when "---" => inputs_tb <= "1--";
		when "1--" => inputs_tb <= "100";
		when "100" => inputs_tb <= "101";
		when "101" => inputs_tb <= "110";
		when "110" => inputs_tb <= "111";
		when "111" => inputs_tb <= "000";
		when "000" => inputs_tb <= "010";
		when "010" => inputs_tb <= "001";
        when "001" => inputs_tb <= "011";
		when "011" => inputs_tb <= "000";
		when "XXX" => inputs_tb <= "UUU";
		when "UUU" => inputs_tb <= "---";
		when others => inputs_tb <= "000";
				assert false report "Fehler in der Testbench" severity error;       
        end case;
end process inputs;

ljs: process (clk_tb)
    variable counter: unsigned (2 downto 0):= "000";
begin
        stop_tb <= inputs_tb(2);
        jump_tb <= inputs_tb(1);
        load_tb <= inputs_tb(0);

end process ljs;


end sim;
