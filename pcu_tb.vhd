
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
    load_tb <= '0';
    jump_tb <= '0';
    stop_tb <= '0';
    initialized <= '1';
end process initialize;

check: process (clk_tb)
    variable counter: unsigned (2 downto 0):= "000";
begin
    if falling_edge (clk_tb) and initialized = '1' then
        counter := counter + 1;
        stop_tb <= counter(2);
        jump_tb <= counter(1);
        load_tb <= counter(0);
        assert (load_tb = '0' and jump_tb = '0') or (load_tb = '0' and jump_tb = '1') or (load_tb = '1' and jump_tb = '0') report "illegal state" severity error;
    end if;
end process check;


end sim;
