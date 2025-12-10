
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity rom1rom2_tb is

end rom1rom2_tb;

architecture sim of rom1rom2_tb is

component rom1
    Port (address: in std_logic_vector (2 downto 0);
        clk: in std_logic;
        data: out std_logic_vector (7 downto 0) 
        );
end component;

component rom2
  Port (address: in std_logic_vector (2 downto 0);
    clk: in std_logic;
    data: out std_logic_vector (7 downto 0) 
    );
end component;

signal tb_address: std_logic_vector (2 downto 0);
signal tb_clk: std_logic;
signal tb_data: std_logic_vector (7 downto 0);
signal next_address: unsigned (2 downto 0);

begin

    DUT1: rom1 port map (
        address => tb_address,
        clk => tb_clk,
        data => tb_data
        );

    DUT2: rom2 port map (
        address => tb_address,
        clk => tb_clk,
        data => tb_data
        );
        
   clk_gen : process
   begin
        tb_clk <= transport '1' after 50 ns, '0' after 100 ns;
        wait for 100ns; 
   end process clk_gen;
   
   update_address: process (tb_clk)
   
   begin
        if falling_edge(tb_clk) then
            tb_address <= std_logic_vector( unsigned (next_address));
            next_address <= next_address + 1;
        end if;
   end process update_address;
   
   check_data: process
   begin
        wait until tb_clk = '1';
        assert tb_data = (tb_address + 1) * (tb_address + 1) report "data does not have the expected value";
   end process check_data;
   
        
end sim;
