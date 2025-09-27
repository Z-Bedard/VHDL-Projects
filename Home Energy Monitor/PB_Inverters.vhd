--File Name: PB_Inverters.vhd
--Auther: Zachary Bedard & Jonathan Lyashko

LIBRARY ieee;
USE ieee.std_logic_1164.all;

--This whole VHD file is all about inverting the buttons to be active high polarity
ENTITY PB_Inverters IS
Port
	(
		pb_n : IN std_logic_vector(3 downto 0);
		pg : OUT std_logic_vector(3 downto 0)
	);
END PB_Inverters;



ARCHITECTURE gates OF PB_Inverters IS

BEGIN

	pg <= not(pb_n);

END gates; 