
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rom2 is
  Port (address: in std_logic_vector (2 downto 0);
    clk: in std_logic ;
    data: out std_logic_vector (7 downto 0) 
    );
end rom2;

architecture rtl of rom2 is

    signal q: std_logic_vector (2 downto 0);

begin
    rom: process(q)
    begin
        case q is
            when "000" => data <= "00000001";
            when "001" => data <= "00000100";
            when "010" => data <= "00001001";
            when "011" => data <= "00010000";
            when "100" => data <= "00011001";
            when "101" => data <= "00100100";
            when "110" => data <= "00110001";
            when others => ndata <= "00000000";
        end case;
end process rom;

    ff: process(clk)
    begin
        if clk'event and clk='1' then
            q <= address;
        end if;
    end process ff;

end rtl;
