--------------------------------------------------------------------------------------
-- Company: Columbia University
-- Engineer: Adriaan Taal
--					at3111@columbia.edu
--					+1 (347) 972 1595
-- 
-- Product owner: Adriaan Taal
--
-- Create Date:    16:30:32 09/16/2016 
-- Design Name:    
-- Module Name:    
-- Project Name: 	 Neuroimager
-- Target Devices: SPARTAN 6 on Opal Kelly XEM6310LX45
-- Tool versions:  ISE 14.7
-- Description:    
--
-- Dependencies:   
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--

--ToDo for the project 
		--Test the incoming clock and how it improves by buffering
		
-----------------------------------------------------------------------------------------------

--Simple explanation
--Everytime you pull down SPI_SSEL_i the dual sided transfer is initiated
--This means that the data in the MISO register is transfered to the master
--and the data on the MOSI is being brought in

--Rules for usage when synthesized:
--Reset the unit
--Prepare the data, pull down SPI_SSEL_I
--when SPI_SSEL_I = low, the first rising edge on SPI_SCK_i will latch the first bit
--when 16 bits are transferred, DO will settle and the data is presented immediately
--SPI_SSEL_I = low for at least 1 more cycles to make sure that all N+1 states are reached and syn_do_valid_o is asserted

-----Required libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library UNISIM;
use UNISIM.VComponents.all;

library sc9tap_cm018mg_base_rvt_udp;
use sc9tap_cm018mg_base_rvt_udp.all;

library work;
use work.all;

library std;
use std.textio.all;

entity SPI_masterslave_TB is
end SPI_masterslave_TB;

architecture TB of SPI_masterslave_TB is

component phy_spi_slave is
    Port ( rst : in std_logic := '0';
      
		  --SPI wires directly between IC and FPGA
        spi_ssel_i : in std_logic;                               -- spi bus slave select line
        spi_sck_i : in std_logic;                                -- spi bus sck clock (clocks the shift register core)
        spi_mosi_i : in std_logic;                               -- spi bus mosi input
        spi_miso_o : out std_logic;                              -- spi bus spi_miso_o output
		  
		  --Internal clock 
		  clk_i : in std_logic;                                    -- internal interface clock (clocks di/do registers)

		  --used for writing data from FPGA
--        wr_ack_o : out std_logic;                                       -- write acknowledge
        do_valid_o : out std_logic;                                     -- do_o data valid strobe, valid during one clk_i rising edge.
        do_o : out  std_logic_vector(23 downto 0)                    -- parallel output (clocked out on falling clk_i)
    );                      
end component;

component clkdivcounter_v1
	port (
		--FSM internal control signals
		rst : in std_logic; 
		en : in std_logic; 
		clk : in std_logic;
		t_high : in std_logic_vector (31 downto 0);
		t_low : in std_logic_vector (31 downto 0);
		
		--control signals to IC
		clkout : out std_logic);
end component;

component spi_master is
	Generic (   
		N : positive := 24;                                             -- 32bit serial word length is default
		CPOL : std_logic := '0';                                        -- SPI mode selection (mode 0 default)
		CPHA : std_logic := '0';                                        -- CPOL = clock polarity, CPHA = clock phase.
		PREFETCH : positive := 3;                                       -- prefetch lookahead cycles
		SPI_2X_CLK_DIV : positive := 5);                                -- for a 100MHz sclk_i, value of 5 yields a 10MHz SCK
	Port (  
		sclk_i : in std_logic := 'X';                                   -- high-speed serial interface system clock
		pclk_i : in std_logic := 'X';                                   -- high-speed parallel interface system clock
		rst_i : in std_logic := 'X';                                    -- reset core
		---- serial interface ----
		spi_ssel_o : out std_logic;                                     -- spi bus slave select line
		spi_sck_o : out std_logic;                                      -- spi bus sck
		spi_mosi_o : out std_logic;                                     -- spi bus mosi output
		spi_miso_i : in std_logic := 'X';                               -- spi bus spi_miso_i input
		---- parallel interface ----
		di_req_o : out std_logic;                                       -- preload lookahead data request line
		di_i : in  std_logic_vector (N-1 downto 0) := (others => 'X');  -- parallel data in (clocked on rising spi_clk after last bit)
		wren_i : in std_logic := 'X';                                   -- user data write enable, starts transmission when interface is idle
		wr_ack_o : out std_logic;                                       -- write acknowledge
		do_valid_o : out std_logic;                                     -- do_o data valid signal, valid during one spi_clk rising edge.
		do_o : out  std_logic_vector (N-1 downto 0);                    -- parallel output (clocked on rising spi_clk after last bit)
	
	
		--- debug ports: can be removed or left unconnected for the application circuit ---
		sck_ena_o : out std_logic;                                      -- debug: internal sck enable signal
		sck_ena_ce_o : out std_logic;                                   -- debug: internal sck clock enable signal
		do_transfer_o : out std_logic;                                  -- debug: internal transfer driver
		wren_o : out std_logic;                                         -- debug: internal state of the wren_i pulse stretcher
		rx_bit_reg_o : out std_logic;                                   -- debug: internal rx bit
		state_dbg_o : out std_logic_vector (3 downto 0);                -- debug: internal state register
		core_clk_o : out std_logic;
		core_n_clk_o : out std_logic;
		core_ce_o : out std_logic;
		core_n_ce_o : out std_logic;
		sh_reg_dbg_o : out std_logic_vector (N-1 downto 0)              -- debug: internal shift register
	);                      
end component;

--inputs, these are common
signal rst         : std_logic := '0';
signal spi_ssel_i  : std_logic;
signal spi_sck_i   : std_logic ;
signal spi_mosi_i  : std_logic;
signal clk_i       : std_logic := '0';

--phy outputs
signal phy_spi_miso_o   : std_logic;
signal phy_do_valid_o   : std_logic;
signal phy_do_o         : std_logic_vector(23 downto 0);

-- 
signal do_master : std_logic_vector(23 downto 0);
signal di_master : std_logic_vector(23 downto 0):= (others => '0');
signal valid_master : std_logic;
signal wrack_master : std_logic;
signal wren_master : std_logic := '0';
signal direq_master : std_logic;

--internals
signal state : std_logic := '0';
constant TCLK : time := 50 ns;
constant halfTCLK : time := 25 ns;

signal clkout : std_logic;

begin

FSM_shutter : clkdivcounter_v1
	port map(
		--inputs
		rst => rst,
		en => '1',
		clk => clk_i,
		t_high => "00000000000000000000000001100100",
		t_low => "00000000000000000000000001100100",
		--outputs
		clkout => clkout);

----------------------------
physlave: phy_spi_slave port map (
	-- Clock in ports
    rst            => rst,
    -- Reset for logic in example design
    spi_ssel_i => spi_ssel_i,
    spi_sck_i  => spi_sck_i,
	 spi_mosi_i	=> spi_mosi_i,
	 spi_miso_o	=> phy_spi_miso_o,
    -- High bits of the counters
    clk_i      => clk_i,
	--used for writing data from FPGA
	 do_valid_o => phy_do_valid_o,                                     -- do_o data valid strobe, valid during one clk_i rising edge.
	 do_o 		=> phy_do_o);


----------------------------
master: spi_master generic map(
		N => 24,                                          -- 32bit serial word length is default
		CPOL => '0',                                        -- SPI mode selection (mode 0 default)
		CPHA => '0',                                        -- CPOL = clock polarity, CPHA = clock phase.
		PREFETCH => 3,                                    -- prefetch lookahead cycles
		SPI_2X_CLK_DIV => 5)                             -- for a 100MHz sclk_i, value of 5 yields a 10MHz SCK
	port map (  
		sclk_i => clk_i,                                   -- high-speed serial interface system clock
		pclk_i => clk_i,                                    -- high-speed parallel interface system clock
		rst_i => rst,                                    -- reset core
		---- serial interface ----
		spi_ssel_o => spi_ssel_i,                                     -- spi bus slave select line
		spi_sck_o =>  spi_sck_i,                                    -- spi bus sck
		spi_mosi_o => spi_mosi_i,                                   -- spi bus mosi output
		spi_miso_i => phy_spi_miso_o,                              -- spi bus spi_miso_i input
		---- parallel interface ----
		di_req_o => direq_master,                                    -- preload lookahead data request line
		di_i => di_master, -- parallel data in (clocked on rising spi_clk after last bit)
		wren_i => wren_master,                                  -- user data write enable, starts transmission when interface is idle
		wr_ack_o => wrack_master,                                      -- write acknowledge
		do_valid_o => valid_master,                                    -- do_o data valid signal, valid during one spi_clk rising edge.
		do_o => do_master);                  -- parallel output (clocked on rising spi_clk after last bit)
		
		  
-- Input clock generation
--------------------------------------
process begin
    clk_i <= not clk_i; wait for halfTCLK;
end process;

--process begin
--
--end process;

-- Digital inputs generation
--------------------------------------
process begin
	wait for TCLK;
	rst      	<= '1';
	wait for TCLK;
	wait for TCLK;
	rst      	<= '0';
	
	di_master 			<= "001110001010101011110000";
	wait for 1 us;
	wren_master		<= '1';
	
	wait for TCLK; 
	wren_master		<= '0';
	
	wait for 20 us;
	wren_master		<= '1';
	
	wait for TCLK; 
	wren_master		<= '0';
	
--	wait for TCLK;
--	spi_ssel_i <= '0';
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '0';
--	wait for TCLK;
--	spi_mosi_i <= '0';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '0';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '0';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '0';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '0';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '0';
--	wait for TCLK;
--	spi_mosi_i <= '0';
--	wait for TCLK;
--	spi_mosi_i <= '0';
--	wait for TCLK;
--	spi_mosi_i <= '0';
--	--disable SSEL
--	wait for TCLK;
--	spi_ssel_i <= '1';
--
--	
--	--enable SSEL
--	wait for 13.5 us;
--	spi_ssel_i <= '0';
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '0';
--	wait for TCLK;
--	spi_mosi_i <= '0';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '0';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '0';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '0';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '0';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '1';
--	wait for TCLK;
--	spi_mosi_i <= '0';
--	wait for TCLK;
--	spi_mosi_i <= '0';
--	wait for TCLK;
--	spi_mosi_i <= '0';
--	wait for TCLK;
--	spi_mosi_i <= '0';
--	--disable SSEL
--	wait for TCLK;
--	spi_ssel_i <= '1';
	

-- Make this process wait indefinitely (it will never re-execute from its beginning again).
	wait;

end process;
end TB;