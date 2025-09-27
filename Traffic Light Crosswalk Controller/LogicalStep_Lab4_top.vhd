---------------------------------------
-- ECE 124 Lab 4
-- Zachary Bedard and Jonathan Lyashko
-- Group 20
-- LS 206
---------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
   PORT
	(
    clkin_50	    : in	std_logic;							-- The 50 MHz FPGA Clockinput
	rst_n			: in	std_logic;							-- The RESET input (ACTIVE LOW)
	pb_n			: in	std_logic_vector(3 downto 0); -- The push-button inputs (ACTIVE LOW)
 	sw   			: in  	std_logic_vector(7 downto 0); -- The switch inputs
   leds			: out 	std_logic_vector(7 downto 0);	-- for displaying the the lab4 project details
	-------------------------------------------------------------
	-- you can add temporary output ports here if you need to debug your design 
	-- or to add internal signals for your simulations
	-------------------------------------------------------------
	
   seg7_data 	: out 	std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic;							-- seg7 digi selectors
	
	--Simulation Variables
	--sim_sm_clken, sim_blink_sig, sim_ns_green, sim_ns_amber, sim_ns_red, sim_ew_green, sim_ew_amber, sim_ew_red	:	out std_logic
	);
END LogicalStep_Lab4_top;

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS
   component segment7_mux port (
             clk        	: in  	std_logic := '0';
			 DIN2 			: in  	std_logic_vector(6 downto 0);	--bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DIN1 			: in  	std_logic_vector(6 downto 0); --bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
   );
   end component;

   component clock_generator port (
			sim_mode			: in boolean;
			reset				: in std_logic;
            clkin      		    : in  std_logic;
			sm_clken			: out	std_logic;
			blink		  		: out std_logic
  );
   end component;

    component pb_filters port (
			clkin				: in std_logic;
			rst_n				: in std_logic;
			rst_n_filtered	    : out std_logic;
			pb_n				: in  std_logic_vector (3 downto 0);
			pb_n_filtered	    : out	std_logic_vector(3 downto 0)							 
 );
   end component;

	component pb_inverters port (
			rst_n				: in  std_logic;
			rst				    : out	std_logic;							 
			pb_n_filtered	    : in  std_logic_vector (3 downto 0);
			pb					: out	std_logic_vector(3 downto 0)							 
  );
   end component;
	
	--Synchronizer Component
	component synchronizer port(
			clk					: in std_logic; --Clock Input
			reset					: in std_logic; --Reset Input
			din					: in std_logic; --In data
			dout					: out std_logic --Out data
  );
	end component; 
	
  --Holding Register Component	
  component holding_register port (
			clk					: in std_logic; --Clock Input
			reset					: in std_logic; --Reset Input 
			register_clr		: in std_logic; --Clear Input
			din					: in std_logic; --In data
			dout					: out std_logic --Out data
  );
  end component;			
  
  --State Machine Component
  component State_Machine_Example port (
			clk_input 			:in std_logic; --Clock Input
			synch_rst 			:in std_logic; --Reset Input
			NS_req, EW_req		:in std_logic; --Pedestrian Request Inputs
			sm_clken				:in std_logic; --Enable Input
			NS_green, NS_amber, NS_red, EW_green, EW_amber, EW_red 			:out std_logic; --Light value outputs
			crossing_NS, crossing_EW :out std_logic; --Crossing state output
			NS_clear, EW_clear		 :out std_logic; --Clear output 
			Four_Bit_State				 :out std_logic_vector(3 downto 0); --State output for LEDS(7 downto 4)
			blink_sig					 :in std_logic --Input for the blink state
  );
  end component;
----------------------------------------------------------------------------------------------------
	CONSTANT	sim_mode								: boolean := TRUE;  -- set to FALSE for LogicalStep board downloads																						-- set to TRUE for SIMULATIONS
	SIGNAL rst, rst_n_filtered, synch_rst			    : std_logic;
	SIGNAL sm_clken, blink_sig							: std_logic; 
	SIGNAL pb_n_filtered, pb							: std_logic_vector(3 downto 0); 
	SIGNAL synch_out0, synch_out1						: std_logic;
	SIGNAL NS_green, NS_amber, NS_red, EW_green, EW_amber, EW_red					: std_logic;
	SIGNAL crossing_NS, crossing_EW				: std_logic; --Store output value of crossing
	SIGNAL HR_out0, HR_out1							: std_logic;
	SIGNAL NS_clear, EW_clear						: std_logic;
	SIGNAL blink_set									: std_logic;
	SIGNAL NSlight, EWlight							: std_logic_vector(6 downto 0);
	
BEGIN
----------------------------------------------------------------------------------------------------
INST0: pb_filters		port map (clkin_50, rst_n, rst_n_filtered, pb_n, pb_n_filtered);
INST1: pb_inverters		port map (rst_n_filtered, rst, pb_n_filtered, pb);
INST2: synchronizer     port map (clkin_50, '0', rst, synch_rst);	-- the synchronizer is also reset by synch_rst.
INST3: clock_generator 	port map (sim_mode, synch_rst, clkin_50, sm_clken, blink_set);

--Synchronizer and Holding Register Instances
INST4: synchronizer     port map (clkin_50,synch_rst, pb(0), synch_out0); --Synchronizer for NS
INST5: synchronizer     port map (clkin_50,synch_rst, pb(1), synch_out1); --Synchronizer for EW
INST6: holding_register port map (clkin_50, synch_rst, NS_clear, synch_out0, HR_out0); --Holding Register for NS
INST7: holding_register port map	(clkin_50, synch_rst, EW_clear, synch_out1, HR_out1); --Holding Register for EW

--State Machine Instances
INST8: State_Machine_Example port map (clkin_50, synch_rst, HR_out0, HR_out1, sm_clken, NS_green, NS_amber, NS_red, EW_green, EW_amber, EW_red, crossing_NS, crossing_EW, NS_clear, EW_clear, LEDS(7 downto 4), blink_set);

--Concatinated values for output to display
NSlight(6 downto 0) <= NS_amber & "00" & NS_green & "00" & NS_red;
EWlight(6 downto 0) <= EW_amber & "00" & EW_green & "00" & EW_red;

--Instance of Display
INST9: segment7_mux port map(clkin_50, EWlight, NSlight, seg7_data, seg7_char2, seg7_char1);

--Assignments to LEDS to show crossing and requests
LEDS(0) <= crossing_NS;
LEDS(2) <= crossing_EW;
LEDS(1) <= HR_out0;
LEDS(3) <= HR_out1;

-- Simulation Values for Part F
--sim_sm_clken <= sm_clken;
--sim_blink_sig <= blink_set;
--sim_ns_green <= ns_green;
--sim_ns_amber <= ns_amber;
--sim_ns_red <= ns_red;
--sim_ew_green <= ew_green;
--sim_ew_amber <= ew_amber;
--sim_ew_red <= ew_red;

END SimpleCircuit;
