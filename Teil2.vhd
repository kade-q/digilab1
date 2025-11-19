library ieee;
use ieee.std_locig_1164.all;

entity teil2 is
  port (
    re1, im1, re2, : in signed (7 downto 0) := 0;
    re_o, im_o : out signed (7 downto 0)
    );
end teil2;

architecture behav of teil2 is
begin
  multiply : process (re1, im1, re2, im2)
    begin
      re_o <= re1 * re2 - im1 * im2;
      im_o <= re1 * im2 + re2 * im1;
    end process multiply;
end behav;
      
