library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dsp_1 is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        data_re    : in  signed(3 downto 0);
        data_im    : in  signed(3 downto 0);
        data_valid : in  std_logic;
        start      : in  std_logic;
        result     : out unsigned(7 downto 0)
    );
end entity dsp_1;

architecture rtl of dsp_1 is
    signal result_reg : unsigned(7 downto 0);
begin
    result <= result_reg;

    process(clk, rst)
        variable abs_re : unsigned(3 downto 0);
        variable abs_im : unsigned(3 downto 0);
    begin
        if rst = '1' then
            result_reg <= (others => '0');

        elsif rising_edge(clk) then
            if start = '1' then
                result_reg <= (others => '0');

            elsif data_valid = '1' then
                abs_re := unsigned(abs(data_re));
                abs_im := unsigned(abs(data_im));
                result_reg <= result_reg + abs_re + abs_im;
            end if;
        end if;
    end process;
end architecture rtl;
