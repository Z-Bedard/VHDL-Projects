---------------------------------------
-- ECE 124 Lab 4
-- Zachary Bedard and Jonathan Lyashko
-- Group 20
-- LS 206
---------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity State_Machine_Example IS Port
(
 clk_input, synch_rst			: in std_logic; --Inputs for Clock and Reset
 NS_req, EW_req					: in std_logic; --Inputs for Pedestrian Requests
 sm_clken											: in std_logic; --Inputs for enable
 NS_green, NS_amber, NS_red, EW_green, EW_amber, EW_red : out std_logic; --Outputs for traffic light values (color of the light)
 crossing_NS, crossing_EW					: out std_logic; --Outputs for crossing LEDS
 NS_clear, EW_clear							: out std_logic; --Output for clearing Pedestrian requests
 Four_Bit_State								: out std_logic_vector (3 downto 0); --Output for state tracking
 blink_sig										: in std_logic --Input for blink state
 
 );
END ENTITY;
 

 Architecture SM of State_Machine_Example is
 
 
 TYPE STATE_NAMES IS (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15);   -- list all the state names

 
 SIGNAL current_state, next_state	:  STATE_NAMES;     	-- signals of type all states
 
 BEGIN
 

 -------------------------------------------------------------------------------
 --State Machine:
 -------------------------------------------------------------------------------

 -- REGISTER_LOGIC PROCESS EXAMPLE

Register_Section: PROCESS (clk_input)  -- this process updates with a clock
BEGIN
	IF(rising_edge(clk_input)) THEN
		IF (synch_rst = '1') THEN
			current_state <= s0;
		ELSIF (synch_rst = '0' and sm_clken = '1') THEN
			current_state <= next_State;
		END IF;
	END IF;
END PROCESS;	



-- TRANSITION LOGIC PROCESS EXAMPLE

Transition_Section: PROCESS (current_state) 

--Sets the next case for all states
BEGIN
  CASE current_state IS
			--If statements for states s0, s1, s8, s9 could result in jumping to pedestrian  
         WHEN s0 =>
				if(EW_req = '1' and NS_req = '0') then
					next_state <= s6;
				else
					next_state <= s1;
				end if;
				
         WHEN s1 =>		
				if(EW_req = '1' and NS_req = '0') then
					next_state <= s6;
				else
					next_state <= s2;
				end if;
				
         WHEN s2 =>		
				next_state <= s3;
				
         WHEN s3 =>		
				next_state <= s4;
				
         WHEN s4 =>		
				next_state <= s5;

         WHEN s5 =>		
				next_state <= s6;
				
         WHEN s6 =>		
				next_state <= s7;
				
         WHEN s7 =>		
				next_state <= s8;
			
			WHEN s8 =>		
				if(EW_req = '0' and NS_req = '1') then
					next_state <= s14;
				else
					next_state <= s9;
				end if;
			
			WHEN s9 =>		
				if(EW_req = '0' and NS_req = '1') then
					next_state <= s14;
				else
					next_state <= s10;
				end if;
				
			WHEN s10 =>		
				next_state <= s11;
				
			WHEN s11 =>		
				next_state <= s12;
			
			WHEN s12 =>		
				next_state <= s13;
			
			WHEN s13 =>		
				next_state <= s14;
			
			WHEN s14 =>		
				next_state <= s15;
			
			WHEN s15 =>		
				next_state <= s0;
	  END CASE;
 END PROCESS;
 

-- DECODER SECTION PROCESS EXAMPLE (MOORE FORM SHOWN)

Decoder_Section: PROCESS (current_state) 

--Assigns behavior for each state
BEGIN
     CASE current_state IS
	  
         WHEN s0 =>		
			NS_green <= blink_sig;
			NS_amber <= '0';
			NS_red <= '0';
			EW_green <= '0';
			EW_amber <= '0';
			EW_red	<= '1';
			NS_clear <= '0';
			EW_clear <= '0';
			crossing_NS <= '0';
			crossing_EW <= '0';
			
			WHEN s1 =>		
			NS_green <= blink_sig;
			NS_amber <= '0';
			NS_red <= '0';
			EW_green <= '0';
			EW_amber <= '0';
			EW_red	<= '1';
			NS_clear <= '0';
			EW_clear <= '0';
			crossing_NS <= '0';
			crossing_EW <= '0';

         WHEN s2 =>		
			NS_green <= '1';
			NS_amber <= '0';
			NS_red <= '0';
			EW_green <= '0';
			EW_amber <= '0';
			EW_red	<= '1';
			NS_clear <= '0';
			EW_clear <= '0';
			crossing_NS <= '1';
			crossing_EW <= '0';
			
			WHEN s3 =>		
			NS_green <= '1';
			NS_amber <= '0';
			NS_red <= '0';
			EW_green <= '0';
			EW_amber <= '0';
			EW_red	<= '1';
			NS_clear <= '0';
			EW_clear <= '0';
			crossing_NS <= '1';
			crossing_EW <= '0';
			
			WHEN s4 =>		
			NS_green <= '1';
			NS_amber <= '0';
			NS_red <= '0';
			EW_green <= '0';
			EW_amber <= '0';
			EW_red	<= '1';
			NS_clear <= '0';
			EW_clear <= '0';
			crossing_NS <= '1';
			crossing_EW <= '0';
			
			WHEN s5 =>		
			NS_green <= '1';
			NS_amber <= '0';
			NS_red <= '0';
			EW_green <= '0';
			EW_amber <= '0';
			EW_red	<= '1';
			NS_clear <= '0';
			EW_clear <= '0';
			crossing_NS <= '1';
			crossing_EW <= '0';
			
         WHEN s6 =>		
			NS_green <= '0';
			NS_amber <= '1';
			NS_red <= '0';
			EW_green <= '0';
			EW_amber <= '0';
			EW_red	<= '1';
			NS_clear <= '1';
			EW_clear <= '0';
			crossing_NS <= '0';
			crossing_EW <= '0';
			
			WHEN s7 =>		
			NS_green <= '0';
			NS_amber <= '1';
			NS_red <= '0';
			EW_green <= '0';
			EW_amber <= '0';
			EW_red	<= '1';
			NS_clear <= '0';
			EW_clear <= '0';
			crossing_NS <= '0';
			crossing_EW <= '0';
			
			WHEN s8 =>		
			NS_green <= '0';
			NS_amber <= '0';
			NS_red <= '1';
			EW_green <= blink_sig;
			EW_amber <= '0';
			EW_red	<= '0';
			NS_clear <= '0';
			EW_clear <= '0';
			crossing_NS <= '0';
			crossing_EW <= '0';
			
			WHEN s9 =>		
			NS_green <= '0';
			NS_amber <= '0';
			NS_red <= '1';
			EW_green <= blink_sig;
			EW_amber <= '0';
			EW_red	<= '0';
			NS_clear <= '0';
			EW_clear <= '0';
			crossing_NS <= '0';
			crossing_EW <= '0';
			
			WHEN s10 =>		
			NS_green <= '0';
			NS_amber <= '0';
			NS_red <= '1';
			EW_green <= '1';
			EW_amber <= '0';
			EW_red	<= '0';
			NS_clear <= '0';
			EW_clear <= '0';
			crossing_NS <= '0';
			crossing_EW <= '1';
			
			WHEN s11 =>		
			NS_green <= '0';
			NS_amber <= '0';
			NS_red <= '1';
			EW_green <= '1';
			EW_amber <= '0';
			EW_red	<= '0';
			NS_clear <= '0';
			EW_clear <= '0';
			crossing_NS <= '0';
			crossing_EW <= '1';
			
			WHEN s12 =>		
			NS_green <= '0';
			NS_amber <= '0';
			NS_red <= '1';
			EW_green <= '1';
			EW_amber <= '0';
			EW_red	<= '0';
			NS_clear <= '0';
			EW_clear <= '0';
			crossing_NS <= '0';
			crossing_EW <= '1';
			
			WHEN s13 =>		
			NS_green <= '0';
			NS_amber <= '0';
			NS_red <= '1';
			EW_green <= '1';
			EW_amber <= '0';
			EW_red	<= '0';
			NS_clear <= '0';
			EW_clear <= '0';
			crossing_NS <= '0';
			crossing_EW <= '1';
			
			WHEN s14 =>		
			NS_green <= '0';
			NS_amber <= '0';
			NS_red <= '1';
			EW_green <= '0';
			EW_amber <= '1';
			EW_red	<= '0';
			NS_clear <= '0';
			EW_clear <= '1';
			crossing_NS <= '0';
			crossing_EW <= '0';
			
			WHEN s15 =>		
			NS_green <= '0';
			NS_amber <= '0';
			NS_red <= '1';
			EW_green <= '0';
			EW_amber <= '1';
			EW_red	<= '0';
			NS_clear <= '0';
			EW_clear <= '0';
			crossing_NS <= '0';
			crossing_EW <= '0';
			
         WHEN others =>		
 			NS_green <= '0';
			NS_amber <= '0';
			NS_red <= '0';
			EW_green <= '0';
			EW_amber <= '0';
			EW_red	<= '0';
			NS_clear <= '0';
			EW_clear <= '0';
			crossing_NS <= '0';
			crossing_EW <= '0';
	  END CASE;
	  
--Set binary numbers to represent each state to display to LEDs
CASE current_state IS
	When S0 =>
		Four_Bit_State <= "0000";
	When S1 =>
		Four_Bit_State <= "0001";
	When S2 =>
		Four_Bit_State <= "0010";
	When S3 =>
		Four_Bit_State <= "0011";
	When S4 =>
		Four_Bit_State <= "0100";
	When S5 =>
		Four_Bit_State <= "0101";
	When S6 =>
		Four_Bit_State <= "0110";
	When S7 =>
		Four_Bit_State <= "0111";
	When S8 =>
		Four_Bit_State <= "1000";
	When S9 =>
		Four_Bit_State <= "1001";
	When S10 =>
		Four_Bit_State <= "1010";
	When S11 =>
		Four_Bit_State <= "1011";
	When S12 =>
		Four_Bit_State <= "1100";
	When S13 =>
		Four_Bit_State <= "1101";
	When S14 =>
		Four_Bit_State <= "1110";
	When S15 =>
		Four_Bit_State <= "1111";
	END CASE;	
 END PROCESS;

 END ARCHITECTURE SM;
