library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity blu is
  Port (operation: in std_logic_vector (1 downto 0):= "00";
    a,b: in std_logic_vector (7 downto 0) := "00";
    result: out std_logic_vector (7 downto 0)
    );
end blu;

architecture Behavioral of blu is

begin
    process(operation, a, b)
    begin
        case operation is
        when "00" =>    result <= "00000000";
        when "01" =>    result <= a and b;
        when "10" =>    result <= a or b;
        when "11" =>    result <= a xnor b;
        when others => null;
        end case;
    end process;

end Behavioral;
