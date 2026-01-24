----------------------------------------------------------------------------------
-- Company: Lehrstuhl Entwurf Mikroelektronischer Systeme
--          TU Kaiserslautern
-- Engineer: Goldhammer
-- 
-- Create Date:    01.11.2021 
-- Design Name:    Ampel (traffic light) DIGILAB 1
-- Module Name:    sek_puls.vhd
-- Project Name: 
-- Target Devices: 
-- Tool versions:  Vivado 2018.2 / Modelsim 2019

-- Description: Module generates every second one pulse of
--              one single clock length
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
-- Revision 0.02: new tool versions; comments updated
-- Revision 0.03: layout fully compliant to guidelines
-- Revision 0.04: adaptation Nexys Board
-- Revision 0.05: Zaehlerendwert wird vom Toplevel-VHDL-Code bestimmt
--                damit kann Simulation beschleunigt ablaufen

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity  timer is
  generic(
    divide_value : integer := 99);   --Zaehlerendwert Hardware / Simulation
  port
   (clk_100mhz: in  std_logic; --100 MHz Systemclock (Quarz auf NEXYS4 )
    reset     : in  std_logic;
    sec_puls  : out std_logic
   );
end  timer;

architecture behavioral of  timer is
--Clock (100 MHz) teilen auf 1 Hz
--wie viele Bit sind noetig, um bis 100 Millionen zaehlen zu koennen ?
  signal count        : unsigned(26 downto 0);   --Bitbreite festlegen
--Deklaration interner Signale
--Declaration constants


--DELETE (count): :=(others => '0') ;


begin
  convert: process (reset, clk_100mhz)
    begin
    if reset = '1' then 
      count <= (others => '0');
      sec_puls <= '0';
    elsif rising_edge(clk_100mhz) then
        if count = divide_value then 
          count <= (others => '0');
          sec_puls <= '1';
        else
          sec_puls <= '0';
          count <= count + 1;
	end if;
    end if;
  end process;
end;
