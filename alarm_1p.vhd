library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alarm_1p is
  Port (
  pc: in std_logic_vector (15 downto 0);
  validate, door_open, go, reset, clk: in std_logic;
  alarm, stop, load: out std_logic;
  loadvalue: out std_logic_vector (15 downto 0);
  jump: out std_logic := '0' 
   );
end alarm_1p;

architecture rtl of alarm_1p is
    type states is (s0, s1, s2, s3);
    signal state: states;
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

begin

p1: process(clk, reset)
begin
    if rising_edge(clk) then
        -- synchronous reset
        if reset = '1' then
            --Zähler pc wird auf Null gesetzt
            loadvalue <= (others => '0');
            load <= '1';
            stop <= '0';
            -- initial state, initialize registers
            state <= s0;
            alarm <= '0';
        else
            case state is     
                when s0 =>
                    -- initial state
                    -- outputs
                    alarm <= '0';
                    stop <= '1';
                    load <= '0';
                    loadvalue <= (others => '0');
                    -- next state
                    if go = '1' then
                        state <= s1;
                    end if;   
                when s1 =>
                    -- loadvalue set to zero, waiting for door_open
                    -- outputs
                    alarm <= '0';
                    stop <= '0';
                    load <= '1';
                    loadvalue <= (others => '0');          
                    -- next state
                    if go = '1' and door_open = '1' then
                        state <= s2;
                    end if;
                when s2 =>
                    -- begins counting to 25 clock cycles to allow for disarming with validate before sounding alarm
                    -- outputs
                    alarm <= '0';
                    stop <= '0';
                    load <= '0';   
                    -- next state
                    if validate = '0' and unsigned(pc) >= "0000000000011001" and go = '1' then
                        state <= s3;
                    elsif validate = '1' and go = '1' then
                        state <= s1;                 
                    end if;
                when s3 =>
                    -- alarm goes off
                    -- outputs
                    alarm <= '1';
                    stop <= '0';
                    load <= '0';
                    -- next state
                    if validate = '1' and go = '0' then
                        state <= s0;
                    end if;                 
            end case;                
        end if;
    end if;
end process p1;


end rtl;
