library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dsp_tb is
end entity dsp_tb;

architecture Testbench of dsp_tb is
    signal clk        : std_logic := '0';
    signal rst        : std_logic := '0';
    signal data_re    : signed(3 downto 0) := (others => '0');
    signal data_im    : signed(3 downto 0) := (others => '0');
    signal data_valid : std_logic := '0';
    signal start      : std_logic := '0';
    signal res1       : unsigned(7 downto 0);
    signal res2       : unsigned(7 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin
    u1: entity work.dsp_1 port map (clk, rst, data_re, data_im, data_valid, start, res1);
    u2: entity work.dsp_2 port map (clk, rst, data_re, data_im, data_valid, start, res2);

    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    stimuli: process
    begin
        -- Reset
        rst <= '1';
        wait for 25 ns;
        rst <= '0';
        wait for CLK_PERIOD /2;

        -- Test 1: Normale Werte
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';

        data_valid <= '1';
        data_re <= to_signed(2, 4);   -- |2| = 2
        data_im <= to_signed(-3, 4);  -- |3| = 3 -> Summe 5
        wait for CLK_PERIOD;

        data_re <= to_signed(-1, 4);  -- |1| = 1
        data_im <= to_signed(4, 4);   -- |4| = 4 -> Summe 5 (Total 10)
        wait for CLK_PERIOD;

        data_valid <= '0';
        wait for 5 * CLK_PERIOD;

        -- Test 2: Maximale Werte (8 Zahlen mit max. Werten)
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';

        data_valid <= '1';
        -- 8 Zahlen mit maximalen Beträgen
        -- |data_re| = 7 (max), |data_im| = 7 (max) -> Summe 14 pro Zahl
        -- Gesamtsumme für 8 Zahlen: 14 * 8 = 112 (innerhalb von 8 Bits)
        for i in 1 to 8 loop
            data_re <= to_signed(7, 4);   -- Maximaler positiver Wert
            data_im <= to_signed(-7, 4);  -- Maximaler negativer Wert (Betrag = 7)
            wait for CLK_PERIOD;
        end loop;

        data_valid <= '0';
        wait for 5 * CLK_PERIOD;

        -- Test 3: Minimale Werte (8 Zahlen mit min. Werten)
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';

        data_valid <= '1';
        -- 8 Zahlen mit minimalen Beträgen (alle 0)
        -- |data_re| = 0, |data_im| = 0 -> Summe 0 pro Zahl
        for i in 1 to 8 loop
            data_re <= to_signed(0, 4);
            data_im <= to_signed(0, 4);
            wait for CLK_PERIOD;
        end loop;

        data_valid <= '0';
        wait for 5 * CLK_PERIOD;

        -- Test 4: Extremfall -8 (maximaler Betrag 8)
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';

        data_valid <= '1';
        -- |data_re| = 8 (max. Betrag), |data_im| = 8 (max. Betrag) -> Summe 16 pro Zahl
        -- Für 8 Zahlen: 16 * 8 = 128 (benötigt 8 Bits, 0-255)
        for i in 1 to 8 loop
            data_re <= to_signed(-8, 4);  -- Minimaler Wert, Betrag = 8
            data_im <= to_signed(-8, 4);  -- Minimaler Wert, Betrag = 8
            wait for CLK_PERIOD;
        end loop;

        data_valid <= '0';
        wait for 5 * CLK_PERIOD;

        -- Test 5: Gemischte extremale Werte
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';

        data_valid <= '1';
        -- Verschiedene extremale Kombinationen
        data_re <= to_signed(-8, 4);  -- |8|
        data_im <= to_signed(7, 4);   -- |7| -> Summe 15
        wait for CLK_PERIOD;

        data_re <= to_signed(7, 4);   -- |7|
        data_im <= to_signed(-8, 4);  -- |8| -> Summe 15 (Total 30)
        wait for CLK_PERIOD;

        data_re <= to_signed(-8, 4);  -- |8|
        data_im <= to_signed(-8, 4);  -- |8| -> Summe 16 (Total 46)
        wait for CLK_PERIOD;

        data_re <= to_signed(7, 4);   -- |7|
        data_im <= to_signed(7, 4);   -- |7| -> Summe 14 (Total 60)
        wait for CLK_PERIOD;

        data_valid <= '0';
        wait for 10 * CLK_PERIOD;

        wait;
    end process;

end architecture Testbench;
