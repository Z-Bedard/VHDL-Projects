library ieee;
use ieee.std_logic_1164.all;


entity LogicalStep_Lab3_top is port (
	clkin_50		: in 	std_logic;
	pb_n			: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); 	
	
	----------------------------------------------------
--	HVAC_temp : out std_logic_vector(3 downto 0); -- used for simulations only. Comment out for FPGA download compiles.
	----------------------------------------------------
	
   leds			: out std_logic_vector(7 downto 0);
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  : out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab3_top;

architecture design of LogicalStep_Lab3_top is
--
-- Provided Project Components Used
------------------------------------------------------------------- 

component SevenSegment  port (
   hex	   :  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg :  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
); 
end component SevenSegment;

component segment7_mux port (
          clk        : in  std_logic := '0';
			 DIN2 		: in  std_logic_vector(6 downto 0);	
			 DIN1 		: in  std_logic_vector(6 downto 0);
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
        );
end component segment7_mux;
--	
component Tester port (
	MC_TESTMODE				: in  std_logic;
	I1EQI2,I1GTI2,I1LTI2	: in	std_logic;
	input1					: in  std_logic_vector(3 downto 0);
	input2					: in  std_logic_vector(3 downto 0);
	TEST_PASS  				: out	std_logic							 
); 
end component;
----	
component HVAC 	port (
	HVAC_SIM					: in boolean;
	clk						: in std_logic; 
	run		   			: in std_logic;
	increase, decrease	: in std_logic;
	temp						: out std_logic_vector (3 downto 0)
);
end component;
------------------------------------------------------------------
-- Add any Other Components here
------------------------------------------------------------------
component Compx4 port(
	A : in std_logic_vector(3 downto 0);
	B : in std_logic_vector(3 downto 0);
	Greater : out std_logic;
	Less : out std_logic;
	Equal : out std_logic
);
end component;

component Counter8bit port(
	CLk : in std_logic;
	RESET : in std_logic;
	CLK_EN : in std_logic;
	UP1_DOWN0 : in std_logic;
	COUNTER_BITS : out std_logic_vector(7 downto 0)
);
end component;

component PB_Inverters port(
		pb_n : IN std_logic_vector(3 downto 0);
		pg : OUT std_logic_vector(3 downto 0)
	);
end component;

component Energy_Monitor port(
	vaca_mode, MC_test, win_open, door_open, AgB, AlB, AeB : in std_logic;
	inc, dec, run, vaca, door, win, blower, AC, at_temp, furnace : out std_logic
);
end component;
------------------------------------------------------------------	
-- Create any additional internal signals to be used
------------------------------------------------------------------	
constant HVAC_SIM : boolean := FALSE; -- set to FALSE when compiling for FPGA download to LogicalStep board 
                                      -- or TRUE for doing simulations with the HVAC Component
------------------------------------------------------------------	

-- global clock
signal clk_in					: std_logic;
signal hex_A, hex_B 			: std_logic_vector(3 downto 0);
signal hexA_7seg, hexB_7seg: std_logic_vector(6 downto 0);
signal pb 						: std_logic_vector(3 downto 0);
signal AgB, AlB, AeB			: std_logic;	
signal inc, dec, run 		: std_logic;
signal temp_current, temp_desired, temp_vaca	: std_logic_vector(3 downto 0);
signal mux_temp				: std_logic_vector(3 downto 0);
------------------------------------------------------------------- 
begin -- Here the circuit begins

clk_in <= clkin_50;	--hook up the clock input

-- temp inputs hook-up to internal busses.
temp_desired <= sw(3 downto 0);
temp_vaca <= sw(7 downto 4);

with pb(3) select
	mux_temp <= temp_desired when '0', temp_vaca when '1';

inst1: sevensegment port map (mux_temp, hexA_7seg);
inst2: sevensegment port map (temp_current, hexB_7seg);
inst3: segment7_mux port map (clk_in, hexA_7seg, hexB_7seg, seg7_data, seg7_char2, seg7_char1);
inst4: Compx4 port map(mux_temp, temp_current, AgB, Alb, AeB); --Greater, Less, Equal
--inst5: Counter8bit port map (clk_in, not(pb_n(0)), sw(0), sw(1), leds(7 downto 0));
inst6: PB_Inverters port map(pb_n(3 downto 0), pb);
inst7: Energy_Monitor port map(pb(3), pb(2), pb(1), pb(0), AgB, AlB, AeB, inc, dec, run, leds(7), leds(5), leds(4), leds(3), leds(2), leds(1), leds(0));
inst8: HVAC port map(HVAC_SIM, clk_in, run, inc, dec, temp_current);
inst9: Tester port map(pb(2), AeB, AgB, AlB, temp_desired, temp_current, leds(6));
		
end design;

