
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alarm_tb is
--  Port ( );
end alarm_tb;

architecture Behavioral of alarm_tb is

component alarm_1p
   Port (
   pc: in std_logic_vector (15 downto 0);
   validate, door_open, go, reset, clk: in std_logic;
   alarm, stop, load: out std_logic;
   loadvalue: out std_logic_vector (15 downto 0);
   jump: out std_logic := '0' 
    );
end component;

component alarm_mp
   Port (
   pc: in std_logic_vector (15 downto 0);
   validate, door_open, go, reset, clk: in std_logic;
   alarm, stop, load: out std_logic;
   loadvalue: out std_logic_vector (15 downto 0);
   jump: out std_logic := '0' 
    );
end component;

signal pc_tb: std_logic_vector (15 downto 0);
signal validate_tb, door_open_tb, go_tb, reset_tb: std_logic :='0'; 
signal clk_tb: std_logic := '0';
signal alarm_tb_1p, stop_tb_1p, load_tb_1p: std_logic;
signal loadvalue_tb_1p: std_logic_vector (15 downto 0);
signal jump_tb_1p: std_logic;
signal alarm_tb_mp, stop_tb_mp, load_tb_mp: std_logic;
signal loadvalue_tb_mp: std_logic_vector (15 downto 0);
signal jump_tb_mp: std_logic;

begin

DUT1: alarm_1p port map(
    pc => pc_tb,
    validate => validate_tb,
    door_open => door_open_tb,
    go => go_tb,
    reset => reset_tb,
    clk => clk_tb,
    alarm => alarm_tb_1p,
    stop => stop_tb_1p,
    load => load_tb_1p,
    loadvalue => loadvalue_tb_1p,
    jump => jump_tb_1p
    );
    
 DUT2: alarm_mp port map(
    pc => pc_tb,
    validate => validate_tb,
    door_open => door_open_tb,
    go => go_tb,
    reset => reset_tb,
    clk => clk_tb,
    alarm => alarm_tb_mp,
    stop => stop_tb_mp,
    load => load_tb_mp,
    loadvalue => loadvalue_tb_mp,
    jump => jump_tb_mp
    );
    
-- Clock
clk_gen : process
begin
    clk_tb <= not clk_tb after 100 ns;
end process clk_gen;

-- Tests various inputs
input_gen: process
begin
    reset_tb <= '0';
    wait for 500 ns;
    reset_tb <= '1';
    wait for 500 ns;
    reset_tb <= '0';
    wait for 100 ns;
    go_tb <= '1';
    wait for 300 ns;
    door_open_tb <= '1';
    wait for 3000 ns;
    -- triggers alarm
    validate_tb <= '1';
    go_tb <= '0';
    -- turns off alarm
    wait for 300 ns;
    go_tb <= '1';
    wait for 300 ns;
    door_open_tb <= '1';
    wait for 1000 ns;
    validate_tb <= '1';
    -- returns to state 1 without triggering alarm
    wait for 500 ns;
    -- door still open so goes immediately back to state 2 and begins countdown again, then returns immediately to state 1
    reset_tb <= '1';
    validate_tb <= '0';
    door_open_tb <= '0';
    -- restart with go high
    reset_tb <= '0';
    wait for 400 ns;
    go_tb <= '0';
    -- stops in state 1
    wait for 400 ns;
    go_tb <= '1';
    door_open_tb <= '1';
    wait for 400 ns;
    go_tb <= '0';
    -- stops in state 2
    wait for 3000 ns;
    reset_tb <= '1';
    door_open_tb <= '0';
    -- resets out of state 2
    wait for 300 ns;
    reset_tb <= '0';
    wait for 300 ns;
    reset_tb <= '1';
    -- resets out of state 1
    wait for 300 ns;
    wait;
    
        
    
end process input_gen;
    -- input various validate, door_open, go, reset


end Behavioral;
