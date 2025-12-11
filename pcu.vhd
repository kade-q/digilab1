
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
    signal inputs: std_logic_vector (2 downto 0);
    
    
begin
    table: process(clk)
    variable n_pc_us: unsigned (15 downto 0);
    begin
        if rising_edge(clk) then
            if reset = '1' then
                next_pc <= "0000000000000000";
            else
                case inputs is
                    when "1--" => next_pc <= next_pc;
                    when "000" => next_pc <= std_logic_vector (unsigned(next_pc) + 1);
                    when "010" => next_pc <= loadvalue;
                    when "001" => next_pc <= std_logic_vector (unsigned(next_pc) + unsigned(loadvalue));
                    when "011" => next_pc <= next_pc;
                        assert false report "setting load and jump at the same time is illegal!" severity note;
                    when others => next_pc <= (others => 'X');
                        assert false report "undefined entry!" severity note; 
               end case;                                       
            end if;
        end if; 
   end process table; 
   
   input: process (stop, jump, load)
   begin
        inputs <= stop & load & jump;
   end process input; 
   
   update_pc: process (next_pc)
   begin
        pc <= next_pc;
   end process update_pc;
end Behavioral;
