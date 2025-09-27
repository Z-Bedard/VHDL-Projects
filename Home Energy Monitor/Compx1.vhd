library ieee;
use ieee.std_logic_1164.all;

entity Compx1 is port(
	inputA: in std_logic;
	inputB: in std_logic;
	outless: out std_logic;
	outgreater: out std_logic;
	outequal: out std_logic
); 
end Compx1;

architecture design of Compx1 is
	begin
		outequal <= (inputA xnor inputB);
		outless <= ((not inputA) and inputB);
		outgreater <= (inputA and (not inputB));
end design;