-- TestBench Template 
-----Required libraries
library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

entity testbench is
end testbench;

ARCHITECTURE behavior OF testbench IS 


--A. Component Declaration
--component mycomp is
--    Generic (   
--        N : positive);                                -- some static parameter
--    Port (  
--        clk : in std_logic;
--        ---- input ----
--        input : in std_logic;                                    
--        ---- parallel interface ----
--        output : out std_logic
--	   );                      
--end component;


--B. signals
	signal 	clk				:std_logic := '0';
	signal 	input				:std_logic := '0';
	signal	output	 		:std_logic;
	signal   reset   			:std_logic;
	
BEGIN
--C. Component port mapping
--mycomp: mycomp generic map(   
--        N => 32)
--    Port map(  
--        clk 	=> clk,                            	
--        ---- inputs ----
--        input => input,                
--        ---- outputs ----
--        output => output);        

--D. Concurrent Logic
clk <= not clk AFTER 5 ns;

--E. Sequential Logic
tb : PROCESS
     BEGIN
		reset <= '1';
	  wait for 100 ns; 
		reset <= '0';
	  -- Add user defined stimulus here
		input <= '1';
		wait for 100 ns; 
		input <= '0';
			
	   wait; -- will wait forever
  END PROCESS tb;
  --  End Test Bench 
END;
