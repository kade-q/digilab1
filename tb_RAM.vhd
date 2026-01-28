library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity tb_RAM is
--  Port ( );
end tb_RAM;

architecture sim of tb_RAM is
    component ram_samples_255x16 is port (
	clka 	: in std_logic;                      -- Takt fuer PORT A
	wea  	: in std_logic;                      -- Write Enable Signal fuer Port A
	ena  	: in std_logic;                      -- Enable Signal fuer Port A
	addra 	: in std_logic_vector(7 downto 0);   -- Adresse fuer PORT A
	dina  	: in std_logic_vector(15 downto 0);  -- Dateneingang fuer Port A
	clkb 	: in std_logic;                      -- Takt fuer PORT B
	enb  	: in std_logic;                      -- Enable Signal fuer Port B (Speicherung der unten angegebenen Adresse)
	addrb 	: in std_logic_vector(7 downto 0);   -- Adresse fuer PORT B
	doutb  	: out std_logic_vector(15 downto 0)  -- Datenausgang fuer Port B
	);
end component ram_samples_255x16;

signal tb_clk, tb_wea, tb_ena, tb_enb: std_logic := '0';
signal tb_addra, tb_addrb: std_logic_vector(7 downto 0);
signal tb_dina, tb_doutb: std_logic_vector(15 downto 0);

begin
    DUT: ram_samples_255x16 port map(
        clka => tb_clk,
        wea => tb_wea,
        ena => tb_ena,
        addra => tb_addra,
        dina => tb_dina,
        clkb => tb_clk,
        enb => tb_enb,
        addrb => tb_addrb,
        doutb => tb_doutb);
        
    
    clk_gen: process (tb_clk)
    begin
        tb_clk <= not tb_clk after 5ns;
    end process clk_gen;     
    
    write_and_read: process
    begin
        -- write
            tb_addra <= (others => '0');
            tb_dina <= (others => '0');
            tb_wea <= '1';
            tb_ena <= '1';
        wait for 10 ns;
            tb_addra <= ("00001010");
            tb_dina <= ("0000000010100000");
        wait for 10 ns;
            tb_addra <= ("00001111");
            tb_dina <= ("0000000010101111");
        wait for 10 ns;
            tb_addra <= ("10001111");
            tb_dina <= ("1000000010101111");
        wait for 10 ns;
            tb_addra <= ("11111111");
            tb_dina <= ("1111000010101111");
        wait for 10 ns;
            tb_addra <= (others => '0');
            tb_dina <= (others => '0');
            tb_wea <= '0';
            tb_ena <= '0';
        
        -- read
        wait for 20 ns;
            tb_enb <= '1';
            tb_addrb <= (others => '0');   
        wait for 10 ns;
            tb_addrb <= ("00001111");
        wait for 10 ns;
            tb_addrb <= ("00001111");
        wait for 10 ns;
            tb_addrb <= ("10001111");
        wait for 10 ns;
            tb_addrb <= ("11111111");
        wait for 10 ns;
            tb_enb <= '0';
        wait;

    end process write_and_read;

end sim;
