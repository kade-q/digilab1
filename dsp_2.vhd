library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dsp_2 is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        data_re    : in  signed(3 downto 0);
        data_im    : in  signed(3 downto 0);
        data_valid : in  std_logic;
        start      : in  std_logic;
        result     : out unsigned(7 downto 0)
    );
end entity dsp_2;

architecture rtl of dsp_2 is
    signal sum_absre_absim : unsigned(4 downto 0);
    signal result_reg      : unsigned(7 downto 0);
    signal data_valid_d    : std_logic;
    signal start_d         : std_logic;
begin
    result <= result_reg;

    process(clk, rst)
    begin
        if rst = '1' then
            sum_absre_absim <= (others => '0');
            result_reg      <= (others => '0');
            data_valid_d    <= '0';
            start_d         <= '0';

        elsif rising_edge(clk) then
            data_valid_d <= data_valid;
            start_d      <= start;

            if data_valid = '1' then
                sum_absre_absim <=
                    unsigned('0' & abs(data_re)) +
                    unsigned('0' & abs(data_im));
            end if;

            if start_d = '1' then
                result_reg <= (others => '0');
            elsif data_valid_d = '1' then
                result_reg <= result_reg + sum_absre_absim;
            end if;
        end if;
    end process;
end architecture rtl;
