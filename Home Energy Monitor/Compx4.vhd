library ieee;
use ieee.std_logic_1164.all;

entity Compx4 is port(
	A : in std_logic_vector(3 downto 0); --4 bit input value 
	B : in std_logic_vector(3 downto 0); --4 bit input value
	Greater : out std_logic;
	Less : out std_logic;
	Equal : out std_logic
);
end Compx4;

architecture design of Compx4 is
	
	component Compx1 port(
		inputA : in std_logic;
		inputB : in std_logic;
		outless : out std_logic;
		outgreater : out std_logic;
		outequal : out std_logic
	);
	end component;
	
	signal AgB : std_logic_vector(3 downto 0); --Signals to store the values of each bit of the inputs
	signal AlB : std_logic_vector(3 downto 0);
	signal AeB : std_logic_vector(3 downto 0);

begin	

	INST1: Compx1 port map(A(3), B(3), AlB(3), AgB(3), AeB(3));
	INST2: Compx1 port map(A(2), B(2), AlB(2), AgB(2), AeB(2));
	INST3: Compx1 port map(A(1), B(1), AlB(1), AgB(1), AeB(1));
	INST4: Compx1 port map(A(0), B(0), AlB(0), AgB(0), AeB(0));
	
	Equal <= AeB(3) and AeB(2) and AeB(1) and AeB(0);
	Greater <= (AgB(3) or (AeB(3) and AgB(2)) or (AeB(3) and AeB(2) and AgB(1)) or (AeB(3) and AeB(2) and AeB(1) and AgB(0)));
	Less <= (AlB(3) or (AeB(3) and AlB(2)) or (AeB(3) and AeB(2) and AlB(1)) or (AeB(3) and AeB(2) and AeB(1) and AlB(0)));
	
end design;
	
	