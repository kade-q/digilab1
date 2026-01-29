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
-- Schätzung des Signalrauschabstandes bei QPSK modulierten Empfanssymbolen
--
-- =============================================================================
--
-- Die eingehenden Signale out_reverse, komplexe Abtastwerte (Symbole) bestehend
-- aus data_i_in und data_q_in werden abgespeichert.
-- Die Werte psf (Signalleistung FPGA) und prf (Gesamtleistung FPGA) werden 
-- während des Symbolabspeicherns berechnet
-- Sind alle Daten empfangen, werden die berechneten Werte psf und prf und 
-- die Anzhal der empfangenen Symbole ausgegeben. 
-- Anschliessend werden die empfangenen Symbole (komplexe Abtastwerte) 
-- ebenfalls ausgegeben. Dies geschieht entweder in der Reihenfolge wie sie 
-- empfangen wurden oder in umgedrehter Reihenfolge (abhängig von dem 
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







------------------------------------
-- Declare Types used             --
------------------------------------



----------------------------------------
-- Declare Signals used in the design --
----------------------------------------



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


--==============================================================
-- Process(es) Proposal: 1 process describing FSM with datapath
--==============================================================

	
						
						
end rtl;--end of architecture 
