
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rom3_alternate is
  Port (address: in std_logic_vector (2 downto 0);
    clk: in std_logic;
    data: out std_logic_vector (7 downto 0) 
    );
end rom3_alternate;

architecture rtl of rom3_alternate is

    signal ndata: std_logic_vector (7 downto 0);
    signal q: std_logic_vector (2 downto 0);
    
begin

    dat: process(clk)
    begin
        if clk'event and clk='1' then
            data <= ndata;
        end if;
    end process dat;
    
    adr: process(clk)
    begin
        if clk'event and clk='1' then
            q <= address;
        end if;
    end process adr;
    
    rom: process(q)
    begin
        case q is
            when "000" => ndata <= "00000001";
            when "001" => ndata <= "00000100";
            when "010" => ndata <= "00001001";
            when "011" => ndata <= "00010000";
            when "100" => ndata <= "00011001";
            when "101" => ndata <= "00100100";
            when "110" => ndata <= "00110001";
            when others => ndata <= "00000000";
        end case;
    end process rom;
end rtl;
