library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
Port (
    re1, im1, re2, im2 : in signed (7 downto 0) := "00000000";
    re_o, im_o : out signed (7 downto 0)
);
end top;

architecture Behavioral of top is

begin
  multiply : process (re1, im1, re2, im2)
    begin
      re_o <= re1 * re2 - im1 * im2;
      im_o <= re1 * im2 + re2 * im1;
    end process multiply;

end Behavioral;
