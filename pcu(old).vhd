
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity pcu is
  Port (clk: in std_logic;
    reset: in std_logic;
    load: in std_logic;
    jump: in std_logic;
    stop: in std_logic;
    loadvalue: in std_logic_vector (15 downto 0);
    pc: out std_logic_vector (15 downto 0)
     );
end pcu;

architecture Behavioral of pcu is
    signal next_pc: std_logic_vector (15 downto 0);
    
    
begin
    process(clk)
    variable n_pc_us: unsigned (15 downto 0);
    begin
        if rising_edge(clk) then
            if reset = '1' then
                pc <= "0000000000000000";
            else
                --everything else goes here!
                if stop = '1' then
                    null;
                elsif load = '0' and jump = '0' then
                    n_pc_us := unsigned (next_pc);
                    n_pc_us := n_pc_us + 1;
                    next_pc <= std_logic_vector (n_pc_us);
                elsif load = '1' and jump = '0' then
                    next_pc <= loadvalue;
                elsif load = '0' and jump = '1' then
                    n_pc_us := unsigned (next_pc);
                    n_pc_us := n_pc_us + unsigned (loadvalue);
                    next_pc <= std_logic_vector (n_pc_us);
                else
                    null;
                end if; 
                                    
            end if;
        end if;
   end process; 
   
   pc <= next_pc;
end Behavioral;
