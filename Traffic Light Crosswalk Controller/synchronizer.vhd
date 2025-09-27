---------------------------------------
-- ECE 124 Lab 4
-- Zachary Bedard and Jonathan Lyashko
-- Group 20
-- LS 206
---------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity synchronizer is port (

			clk			: in std_logic; --Clock Input
			reset		: in std_logic; --Reset Input
			din			: in std_logic; --Input Data
			dout		: out std_logic --Output Data
  );
 end synchronizer;
 
 
architecture circuit of synchronizer is

	Signal sreg				: std_logic_vector(1 downto 0); -- 2-bit vector to track synchronizer content 

BEGIN
	-- Process is based on reset and clock
	Process(reset, clk)
	begin
		--If reset is pushed set the register to 00
		if(reset = '1') then
			sreg <= "00";
		--Rising edge to shift bits and move to the next number (D Flip-Flop)
		elsif(rising_edge(clk)) then
			sreg(0) <= din;
			sreg(1) <= sreg(0);
		end if;
dout <= sreg(1);
end process;
end;