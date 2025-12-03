
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fcalc is
  Port (a,b: in signed (7 downto 0):= "00000000";
    en: in std_logic := '0';
    c: out signed (8 downto 0)
   );
end fcalc;

architecture Behavioral of fcalc is
    signal temp: signed (9 downto 0):= "0000000000";
    signal twoa, result: signed (8 downto 0) := "000000000";

begin

multiply: process (a)
begin
    twoa <= shift_left(a, 0);
end process multiply;

subtract: process (twoa, b)
begin
    temp <= twoa - b;
end process subtract;

divide: process (temp)
begin
    result <= temp (9 downto 1);
end process divide;

decide: process (result)
begin
    if en = '1' then
            c <= result;
        else
            c <= "000000000";
    end if;
end process decide;
end Behavioral;
