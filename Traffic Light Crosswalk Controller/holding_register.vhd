---------------------------------------
-- ECE 124 Lab 4
-- Zachary Bedard and Jonathan Lyashko
-- Group 20
-- LS 206
---------------------------------------

library ieee;
use ieee.std_logic_1164.all;


entity holding_register is port (

			clk					: in std_logic; --Clock Input
			reset				: in std_logic; --Reset Input
			register_clr		: in std_logic; --Clear Input
			din					: in std_logic; --Input data
			dout				: out std_logic --Output Data
  );
 end holding_register;
 
 architecture circuit of holding_register is

	Signal sreg				: std_logic; --Holds the register value
	signal input_final   : std_logic; --Holds the final value


BEGIN
--Assigns input value using the logic given in the diagram
input_final <= ((sreg or din) and (not(register_clr or reset)));
	process(clk, reset)
	begin
		--reset the register value if reset is pushed
		if(reset = '1') then
			sreg <= '0';
		--Change output based on rising edge
		elsif(rising_edge(clk)) then
			sreg <= input_final;
		end if;
dout <= sreg;
end process;
end;