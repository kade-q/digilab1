
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rom1 is
  Port (address: in std_logic_vector (2 downto 0);
    clk: in std_logic;
    data: out std_logic_vector (7 downto 0) 
    );
end rom1;

architecture rtl of rom1 is

signal ndata: std_logic_vector (7 downto 0);

begin
    rom: process(address)
    begin
        case address is
            when "000" => ndata <= "00000001";
            when "001" => ndata <= "00000100";
            when "010" => ndata <= "00001001";
            when "011" => ndata <= "00010000";
            when "100" => ndata <= "00011001";
            when "101" => ndata <= "00100100";
            when "110" => ndata <= "00110001";
            when others => null;
        end case;
    end process rom;

    ff: process(clk)
    begin
        if clk'event and clk='1' then
            data <= ndata;
        end if;
    end process ff;

end rtl;
