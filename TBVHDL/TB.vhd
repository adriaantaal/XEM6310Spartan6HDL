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
component fifoindexcounter_v1 is
    Generic (   
        N : positive);                                -- some static parameter
    Port (  
        rst : in std_logic;
        ---- input ----
        clk : in std_logic;       
		  maxindex : in std_logic_vector(5 downto 0);	   
        ---- parallel interface ----
        index : out std_logic_vector(5 downto 0)
	   );                      
end component;


--B. signals
	signal 	clk				:std_logic:='0';
	signal	index 	 		:std_logic_vector(5 downto 0);
	signal	maxindex	 		:std_logic_vector(5 downto 0);
	signal   rst   			:std_logic;
	
BEGIN
--C. Component port mapping
mycomp: fifoindexcounter_v1
 generic map(   
        N => 6)
    Port map(  
        rst => rst,                            	
        ---- inputs ----
		  clk => clk,
		  maxindex => maxindex,
        ---- outputs ----
        index => index);        

--D. Concurrent Logic
clk <= not clk AFTER 5 ns;

--E. Sequential Logic
tb : PROCESS
		BEGIN
--		clk <= '0';
	   maxindex <= "000000";
		rst <= '1';
	wait for 10 ns; 
		rst <= '0';
	  -- Add user defined stimulus here
		
	wait for 5 ns; 	
		maxindex <= "010000";
		
	wait; -- will wait forever
  END PROCESS tb;
  --  End Test Bench 
END;
