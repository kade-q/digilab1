library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top is
Port (
    re1, im1, re2, im2 : in integer range -128 to 127 := 0;
    re_o, im_o : out integer range -128 to 127
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
