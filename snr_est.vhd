-- =============================================================================
--
--  Transferstelle fuer Mikroelektronik
--  Dipl. Math. Uwe Wasenmueller
--  Universitaet Kaiserslautern
-- 
--  (C) COPYRIGHT TU Kaiserslautern 2007 - 2017
-- 
-- =============================================================================
-- 
-- Projekt:     Einfuehrung in die Hardware- Beschreibungssprache VHDL
-- 
-- Autor(en):   
-- 
-- =============================================================================
-- 
-- Modulname:   snr_est
--              
-- Sch�tzung des Signalrauschabstandes bei QPSK modulierten Empfanssymbolen
--
-- =============================================================================
--
-- Die eingehenden Signale out_reverse, komplexe Abtastwerte (Symbole) bestehend
-- aus data_i_in und data_q_in werden abgespeichert.
-- Die Werte psf (Signalleistung FPGA) und prf (Gesamtleistung FPGA) werden 
-- w�hrend des Symbolabspeicherns berechnet
-- Sind alle Daten empfangen, werden die berechneten Werte psf und prf und 
-- die Anzhal der empfangenen Symbole ausgegeben. 
-- Anschliessend werden die empfangenen Symbole (komplexe Abtastwerte) 
-- ebenfalls ausgegeben. Dies geschieht entweder in der Reihenfolge wie sie 
-- empfangen wurden oder in umgedrehter Reihenfolge (abh�ngig von dem 
-- Wert des gespeicherten Signals out_reverse).
--
-- Fuer eingehende Symbole wird Interface mit data_valid & data_last verwendet
-- d.h Datenstrom darf "unterbrochen" sein
-- Fuer auszugebende Symbole wird Interface mit data_valid verwendet, d.h.
-- Datenstrom muss kontinuierlich ausgegben werden

-- Das benoetigte RAM wird mit dem Xilinx Core-Generator erzeugt.
-- Diese Komponenten muss deklariert werden und in der architecture 
-- instantiiert werden
-- 
-- =============================================================================


--------------------------------------
-- Used libraries                    
--------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 


-- =============================================================================
----------------------
--ENTITY DECLERATION--
----------------------
entity snr_est is
port(
   clk            : in  std_logic;   -- Clock signal, rising edge active
   rst            : in  std_logic;   -- Asynchronous Reset active with '1'
   rfd            : out std_logic;   -- Output to tell the environment whether 
                                      -- device is ready to receive new data
   -- Input parameter will be valid with the start signal
   start          : in  std_logic;  -- Impulse shows validness of following parameter
   out_reverse    : in  std_logic;  -- How to send received values 
                                     -- ('1':reverse order, '0':normal order)
    --Input data will be valid if the data_valid_in signal is '1'
   data_valid_in  : in  std_logic;  -- '1' data on input are valid
   data_last_in   : in  std_logic;  -- '1' marks the last input data (symbol)
   data_i_in      : in  std_logic_vector(7 downto 0);  -- real part of symbol
   data_q_in      : in  std_logic_vector(7 downto 0);  -- imaginary part of symbol
    --output parameters will be valid when result_valid signal is high 
   result_valid   : out std_logic;  -- Impulse indicates valid result parameters
   num_symbols    : out std_logic_vector( 7 downto 0);  -- Number of received symbols
   psf            : out std_logic_vector(15 downto 0);  -- Estimated signal power 
   prf            : out std_logic_vector(22 downto 0);  -- Estimated received power
    --output data will be valid when data_valid_out signal is '1'
   data_valid_out : out std_logic;  -- '1' indicates the data on outputs are still valid 
   data_i_out     : out std_logic_vector(7 downto 0);  -- Real Part of the symbol 
   data_q_out     : out std_logic_vector(7 downto 0)   -- Imaginary part of the symbol
);
end entity snr_est;



-------------------------------------------
--ARCHITECTURE OF THE snr_est--
-------------------------------------------
architecture rtl of snr_est is

---------------------------------------
-- COMPONENTS TO BE USED IN THE DESIGN
---------------------------------------
--RAM to store the symbols
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






------------------------------------
-- Declare Types used             --
------------------------------------
type states is (s0, s1, s2, s3);


----------------------------------------
-- Declare Signals used in the design --
----------------------------------------
signal state : states;
signal address : unsigned (7 downto 0);
signal reverse : std_logic;
signal counter, length : unsigned (7 downto 0); -- counter = num_symbols, length wird für die Ausgabe der Symbole verwendet (Lücken mitzählen)
signal sum_squared : unsigned (22 downto 0); -- speichert Zwischenwert
signal sum : unsigned (15 downto 0); -- speichert Zwischenwert
signal snr_wea, snr_ena, snr_enb : std_logic;
signal snr_addra, snr_addrb : std_logic_vector(7 downto 0);
signal snr_dina, snr_doutb : std_logic_vector(15 downto 0);


--------------------------------
-- Begin the rtl architecture --
--------------------------------

begin    
	

--================================================
--Concurrent Signal assignments (if any)
--================================================


--======================================
--Instatiation of Components 
--======================================
    c1: ram_samples_255x16 port map(
        clka => clk,
        wea => snr_wea,
        ena => snr_ena,
        addra => snr_addra,
        dina => snr_dina,
        clkb => clk,
        enb => snr_enb,
        addrb => snr_addrb,
        doutb => snr_doutb);

--==============================================================
-- Process(es) Proposal: 1 process describing FSM with datapath
--==============================================================
p1: process (clk)
    variable abs_re: unsigned (7 downto 0);
    variable abs_im: unsigned (7 downto 0);

begin
    if rising_edge (clk) then
        if rst = '1' then
            state <= s0;
            address <= (others => '0');
            reverse <= 'X'; 
            counter <= (others => '0');
            length <= (others => '0');
            sum_squared <= (others => '0');
            sum <= (others => '0');
            snr_wea <= '0';
            snr_ena <= '0';
            snr_enb <= '0';
            snr_addra <= (others => '0');
            snr_addrb <= (others => '0');
            snr_dina <= (others => '0'); 
            result_valid <= '0';
            num_symbols <= (others => 'X');
            psf <= (others => 'X');
            prf <= (others => 'X');
            data_valid_out <= '0';
            data_i_out <= (others => 'X');
            data_q_out <= (others => 'X');
        else
            case state is
                when s0 => -- Startzustand
                    snr_enb <= '0';
                    rfd <= '1';
                    data_valid_out <= '0';
                    data_i_out <= (others => 'X');
                    data_q_out <= (others => 'X');
                    address <= (others => '0');
                    counter <= (others => '0');
                    length <= (others => '0');
                    snr_addra <= (others => '0');
                    snr_addrb <= (others => '0');
                    sum_squared <= (others => '0');
                    sum <= (others => '0');
                    if start = '1' then
                        reverse <= out_reverse;
                        state <= s1;
                        
                    else
                        rfd <= '1';
                    end if;
                
                when s1 => -- Daten in RAM schreiben, ausrechnen, Ausgabeprozess der Symbole vorbereiten
                    rfd <= '0';
                    -- Lücken nicht mitrechnen
                    if data_i_in /= "XXXXXXXX" then
                        abs_re := unsigned (abs(signed(data_i_in)));
                        abs_im := unsigned (abs(signed(data_q_in)));
                        --num_symbols
                        counter <= counter + 1;
                    --end if;
                    -- wird für die Ausgabe der Symbole verwendet
                    length <= length + 1;
                    -- psf
                    sum <= sum + abs_re + abs_im;
                    -- prf
                    sum_squared <= sum_squared + (abs_re * abs_re) + (abs_im * abs_im);
                    --data in
                    snr_dina <= data_i_in & data_q_in;
                    -- in RAM schreiben
                    snr_wea <= '1';
                    snr_ena <= '1';                   
                    snr_addra <= std_logic_vector (address);
                    address <= address + 1;
                    end if;
                    -- Übergang zum nächsten Zustand
                    if data_last_in = '1' then
                        state <= s2;
                        -- Leseprozess der Symbole beginnen
                        snr_enb <= '1';
                        -- Adresse fürs Ablesen zurücksetzen 
                        if reverse = '0' then
                            address <= "00000001";
                            snr_addrb <= "00000000";
                        else
                            address <= length - 1;
                            snr_addrb <= std_logic_vector (length);
                        end if;
                    end if;
                    
                when s2 => -- Ausgabe der Ergebnisse
                    -- schreiben beenden
                    snr_wea <= '0';
                    snr_ena <= '0';
                    -- Ergebnisse ausgeben
                    result_valid <= '1';
                    psf <= std_logic_vector (sum);
                    prf <= std_logic_vector (sum_squared);
                    num_symbols <= std_logic_vector (counter);
                    -- Ausgabe der Daten vorbereiten
                    snr_addrb <= std_logic_vector (address);
                   
                    if reverse = '0' then 
                        address <= address + 1;                        
                    else
                        address <= address -1;                        
                    end if;  
                    state <= s3;
                    
                when s3 => -- Ausgabe der Symbole
                    -- zurücksetzen der Ausgaben von s2
                    result_valid <= '0';
                    psf <= (others => 'X');
                    prf <= (others => 'X');
                    num_symbols <= (others => 'X');
                    -- Ausgabe der Symbole
                    data_valid_out <= '1';                    
                    snr_addrb <= std_logic_vector (address);
                    data_i_out <= snr_doutb (15 downto 8);
                    data_q_out <= snr_doutb (7 downto 0); 
                    length <= length - 1;
                    if reverse = '0' then 
                        address <= address + 1;                        
                    else
                        address <= address -1;                        
                    end if;    
                    -- Übergang zum Startzustand
                    if length = 1 then
                        state <= s0;
                    end if;
                    
            end case;
        end if;
    
    end if;
end process p1;
						
						
end rtl;--end of architecture 
