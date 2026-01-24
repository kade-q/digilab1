----------------------------------------------------------------------------------
-- Company: Lehrstuhl Entwurf Mikroelektronischer Systeme
--          TU Kaiserslautern
-- Engineer: Goldhammer
-- 
-- Create Date:    01.11.2021
-- Design Name:    Ampel (traffic light) Digilab1
-- Module Name:    ampel_sm.vhd
-- Project Name: 
-- Target Devices: 
-- Tool versions:  Vivado 2018.2 / Modelsim 2019
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
-- Revision 0.02: adaptation Nexys Board
----------------------------------------------------------------------------------
--
--
--                          |                  |
--                          |                  |
--                          |                  |
--                         O|                  |
--                         O|        H         | ampel neben4
--            ampel haupt2 O|        a         |OOO
--    ______________________+        u         +_________________________
--                                   p
--                                   t
--                                   s
--                                   t
--    ______________________+        r         +_________________________
--                     OOO  |        a         |O ampel haupt1
--             ampel neben3 |        s         |O
--                          |        s         |O
--                          |        e         |
--                          |                  |
--                          |                  |
--
--
--
--in unserem Beispiel laufen die beiden Ampeln HAUPTSTRASSE wie auch die beiden NEBENSTRASSE immer
--gleich (es w�rden also 6 IOs genuegen, man koennte aber auch z.B. fuer Linksabbieger die eine
--Ampel der Hauptstrasse frueher gruen machen und die andere laenger gruen lassen)

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity ampel_sm is
  port
   (clk_100mhz: in  std_logic; --100 MHz Systemclock (Quarz)
    reset     : in  std_logic;
    sec_puls  : in  std_logic;
    haupt1    : out std_logic_vector(2 downto 0);
    haupt2    : out std_logic_vector(2 downto 0);
    neben3    : out std_logic_vector(2 downto 0);
    neben4    : out std_logic_vector(2 downto 0) 
   );
end ampel_sm;

architecture behavioral of ampel_sm is
--interner Signale deklarieren
  type states is (s0, s1, s2, s3, s4, s5, s6, s7);
  signal state: states;
  signal counter: unsigned (2 downto 0);
--Konstanten deklarieren

begin
--Concurrent Assignments

--Steuerwerk Ampel
  fsm: process(clk_100mhz, reset)
  begin
    if reset = '1' then
      state <= s0;
      haupt1 <= "001"; 
      haupt2 <= "001"; 
      neben3 <= "001"; 
      neben4 <= "001";
      counter <= (others => '0');
    elsif rising_edge(clk_100mhz) then
      case state is
        when s0 =>
	  haupt1 <= "001";
	  haupt2 <= "001";
	  neben3 <= "001"; 
	  neben4 <= "001";
    if sec_puls = '1' then
  	  state <= s1;
    end if;	
    counter <= (others => '0');
        when s1 =>
	  haupt1 <= "011"; 
	  haupt2 <= "011";
	  neben3 <= "001";
	  neben4 <= "001";
    if sec_puls = '1' then
	    state <= s2;
    end if;
        when s2 =>
	  haupt1 <= "100"; 
	  haupt2 <= "100";
	  neben3 <= "001";
	  neben4 <= "001";
	     if sec_puls = '1' then
    	    counter <= counter + 1;
	     end if;                      #
	  if counter = 7 then
	    counter <= (others => '0');
	    state <= s3;
	  end if;
        when s3 =>
	  haupt1 <= "010";
	  haupt2 <= "010";
	  neben3 <= "001";
	  neben4 <= "001";
	    if sec_puls = '1' then
	      counter <= counter + 1;
	    end if;
	  if counter = 1 then
	    counter <= (others => '0');
	    state <= s4;
	  end if;
        when s4 =>
	  haupt1 <= "001";
	  haupt2 <= "001";
	  neben3 <= "001";
	  neben4 <= "001";
    if sec_puls = '1' then
	    state <= s5;
    end if;
        when s5 =>
	  haupt1 <= "001";
	  haupt2 <= "001";
	  neben3 <= "011";
	  neben4 <= "011";
    if sec_puls = '1' then
	    state <= s6;
    end if;
        when s6 =>
	  haupt1 <= "001";
	  haupt2 <= "001";
	  neben3 <= "100";
	  neben4 <= "100";
	    if sec_puls = '1' then
	      counter <= counter + 1;
	    end if;
	  if counter = 3 then
	    counter <= (others => '0');
	    state <= s7;
	  end if;
        when s7 =>
	  haupt1 <= "001";
	  haupt2 <= "001";
	  neben3 <= "010";
	  neben4 <= "010";
	    if sec_puls = '1' then
	      counter <= counter + 1;
	    end if;
	  if counter = 1 then
	    counter <= (others => '0');
	    state <= s0;
	  end if;
      end case;
    end if;
  end process;
end Behavioral;
