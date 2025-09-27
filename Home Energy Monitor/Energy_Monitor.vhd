library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Energy_Monitor is port(
	vaca_mode, MC_test, win_open, door_open, AgB, AlB, AeB : in std_logic;
	inc, dec, run, vaca, door, win, blower, AC, at_temp, furnace : out std_logic
);
end entity;

architecture one of Energy_Monitor is 
begin

	inc <= AgB;
	dec <= AlB;
	at_temp <= AeB;
	run <= (not(AeB)) and (not(win_open or door_open)) and (not(MC_test));
	vaca <= vaca_mode; 
	door <= door_open;
	win <= win_open;
	AC <= AlB;
	furnace <= AgB;
	blower <= (not(AeB)) and (not(win_open or door_open)) and (not(MC_test));

end one;