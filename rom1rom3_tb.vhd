
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rom1rom3_tb is

end rom1rom3_tb;

architecture sim of rom1rom3_tb is

component rom1
    Port (address: in std_logic_vector (2 downto 0);
        clk: in std_logic;
        data: out std_logic_vector (7 downto 0) 
        );
end component;

component rom3
  Port (address: in std_logic_vector (2 downto 0);
    clk: in std_logic;
    data: out std_logic_vector (7 downto 0) 
    );
end component;

signal tb_address: std_logic_vector (2 downto 0):= "000";
signal tb_clk: std_logic;
signal tb_data1: std_logic_vector (7 downto 0);
signal tb_data3: std_logic_vector (7 downto 0);
signal next_address: unsigned (2 downto 0):= "000";

begin

    DUT1: rom1 port map (
        address => tb_address,
        clk => tb_clk,
        data => tb_data1
        );

    DUT2: rom3 port map (
        address => tb_address,
        clk => tb_clk,
        data => tb_data3
        );
        
   clk_gen : process
   begin
        tb_clk <= transport '1' after 50 ns, '0' after 100 ns;
        wait for 100 ns; 
   end process clk_gen;
   
   update_address: process (tb_clk)
   begin
        if falling_edge(tb_clk) then
            tb_address <= std_logic_vector( unsigned (next_address));
            next_address <= next_address + 1;
        end if;
   end process update_address;

end sim;

