---------------------------------------
-- ECE 124 Lab 4
-- Zachary Bedard and Jonathan Lyashko
-- Group 20
-- LS 206
---------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- Entity declaration for PB_inverters
-- This entity inverts the reset signal and the push-button inputs
entity PB_inverters is 
    port (
        rst_n          : in  std_logic;                      -- Active-low reset input
        rst            : out std_logic;                      -- Active-high reset output
        pb_n_filtered  : in  std_logic_vector(3 downto 0);   -- Active-low push-button inputs (filtered)
        pb             : out std_logic_vector(3 downto 0)    -- Active-high push-button outputs
    );
end PB_inverters;

-- Architecture declaration for PB_inverters
architecture ckt of PB_inverters is
begin
    -- Invert the reset signal
    rst <= NOT(rst_n);

    -- Invert the push-button signals
    pb <= NOT(pb_n_filtered);
end ckt;