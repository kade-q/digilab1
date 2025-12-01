library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
  Port (operation: in std_logic_vector (2 downto 0) := "000";
    a,b: in std_logic_vector (7 downto 0) := "00000000";
    result: out std_logic_vector (8 downto 0)
    );
end alu;

architecture Behavioral of alu is
    signal a_s, b_s, result_s: signed (8 downto 0) := "000000000";
    signal MSB_a, MSB_b: std_logic_vector (7 downto 0):= "00000000";

begin
    convert: process (a, b, MSB_a, MSB_b)
    begin
        MSB_a <= a and "10000000";
        MSB_b <= b and "10000000";
        if MSB_a = "00000000" then
                a_s <= signed ('0' & a);
            else
                a_s <= signed ('1' & a);
        end if;
        if MSB_b = "00000000" then
                b_s <= signed ('0' & b);
            else
                b_s <= signed ('1' & b);
        end if;
    end process;
    
    opcode: process(operation, a, b, a_s, b_s, result_s)
    begin
        case operation is
        when "000" =>    result <= "000000000";
        when "001" =>    result <= '0' & (a and b);
        when "010" =>    result <= '0' & (a or b);
        when "011" =>    result <= '0' & (a xnor b);
        when "100" =>    
            result_s <= a_s + b_s; 
            result <= std_logic_vector(result_s);
        when "101" =>    
            result_s <= a_s - b_s;
            result <= std_logic_vector(result_s);
        when "110" => result <= "XXXXXXXXX";
        when "111" => result <= "XXXXXXXXX";
        when others => null;
        end case;
    end process;

end Behavioral;
