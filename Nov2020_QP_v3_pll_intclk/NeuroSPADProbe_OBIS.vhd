--------------------------------------------------------------------------------------
-- Company: Columbia University
-- Engineers: Adriaan Taal
--
-- Create Date:    16:30:32 09/16/2016 
-- Design Name:    NeuroSPADProbe
-- Module Name:    NeuroSPADProbe
-- Project Name: 	 SPAD shank
-- Target Devices: SPARTAN 6 on Opal Kelly XEM6310LX45
-- Tool versions:  ISE 14.7
--
-- Dependencies:   
--	at_pll_prog
-- 
--
-----------------------------------------------------------------------------------------------


-----Required libraries
library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;
use work.FRONTPANEL.all;
library UNISIM;
use UNISIM.VComponents.all;


----The entity------------------
entity NeuroSPADProbe_OBIS is
generic(
	--Opal Kelly user variables
	N : INTEGER := 30;
	BLOCK_SIZE : INTEGER := 256;		--in bytes!
	BLOCK_SIZE_MASK : INTEGER := 128;		--in bytes!
	
	--FIFO and Pipe stuff
	GPIO_IN_LEN :INTEGER := 6;
	PIPE_LEN : INTEGER := 4; 		 	--in bytes!
	
	--laser stuff
	LASER_CLK_PERIOD_NS : real := 50.000; 
	SYS_CLK_PERIOD_NS : real := 10.000; --nanosecond
	SYS_CLK_PERIOD_NS_STRING : string := "10.000";--nanosecond
	
	FIFO_d_128b : INTEGER := 11;
	FIFO_d_32b : INTEGER := 13;
	FIFO_d_16b : INTEGER := 14;
	FIFO_HALF_d_16b : INTEGER := 8192;
	FIFO_d_8b : INTEGER := 15;
	FIFO_d_4b : INTEGER := 16;
		
	FIFO_SIZE_128b : INTEGER := 2047;
	FIFO_SIZE_32b : INTEGER := 8188;
	FIFO_SIZE_16b : INTEGER := 16383;
	FIFO_SIZE_8b : INTEGER := 32767;
	FIFO_SIZE_4b : INTEGER := 65535;
	
	LEDMASK_WR_SIZE : INTEGER := 1023;

	--DDR2 Stuff
	BURST_LEN					: INTEGER := 8;
	P0_WR_SIZE         : INTEGER := 63;
	C3_P0_MASK_SIZE         : INTEGER := 16;
	C3_P0_DATA_PORT_SIZE 	: INTEGER := 128;
	C3_P1_MASK_SIZE         : integer := 16;
	C3_P1_DATA_PORT_SIZE    : integer := 128;
			 
	C3_MEMCLK_PERIOD        : integer := 3200;
												-- Memory data transfer clock period.
	C3_RST_ACT_LOW          : integer := 0; 
												-- # = 1 for active low reset,
												-- # = 0 for active high reset.
	C3_INPUT_CLK_TYPE       : string := "DIFFERENTIAL"; 
												-- input clock type DIFFERENTIAL or SINGLE_ENDED.
	C3_CALIB_SOFT_IP        : string := "TRUE"; 
												-- # = TRUE, Enables the soft calibration logic,
												-- # = FALSE, Disables the soft calibration logic.
	C3_SIMULATION           : string := "FALSE"; 
												-- # = TRUE, Simulating the design. Useful to reduce the simulation time,
												-- # = FALSE, Implementing the design.
	DEBUG_EN                : integer := 0; 
												-- # = 1, Enable debug signals/controls,
												--   = 0, Disable debug signals/controls.
	C3_MEM_ADDR_ORDER       : string := "ROW_BANK_COLUMN"; 
												-- The order in which user address is provided to the memory controller,
												-- ROW_BANK_COLUMN or BANK_ROW_COLUMN.
	C3_NUM_DQ_PINS          : integer := 16; 
												-- External memory data width.
	C3_MEM_ADDR_WIDTH       : integer := 13; 
												-- External memory address width.
	C3_MEM_BANKADDR_WIDTH   : integer := 3 ;
												-- External memory bank address width.
	C3_MEM_TWTR : integer := 7500
												--Latencies in picosecond, unused for low memory clock speeds
);

port (
	--Opal Kelly Host input/output
	okUH :  in std_logic_vector( 4  downto 0  );
	okHU :  out std_logic_vector( 2  downto 0  );
	okUHU :  inout std_logic_vector( 31  downto 0  );
	okAA :  inout std_logic;
	sys_clkp :  in std_logic;
	sys_clkn :  in std_logic;

	--Physical input frfifoom IC     
	DOUT : in std_logic_vector(GPIO_IN_LEN -1 downto 0);
	
	--Physical output to IC
--	DREAD : out STD_LOGIC;		--unused on 2020QP
	MEM_CLEAR : out STD_LOGIC;
	LOAD : out STD_LOGIC;
--	PIX_OFF : out STD_LOGIC;	--unused on 2020QP
	CAMERA_FRAME : out std_logic;
	DIS_LED : out STD_LOGIC;
	RSTB : out STD_LOGIC;
	SPAD_ON_OUT : out STD_LOGIC; 
	LED_ON_OUT: out STD_LOGIC;
	
	PROBE_SEL : out STD_LOGIC_vector(1 downto 0);
	ADDR : out std_logic_vector(5 downto 0);
	SIDE: out STD_LOGIC;
	BETA: out STD_LOGIC;

	--SPI inouts
	MOSI : out std_logic;
	MISO : in std_logic;
	SCLK : out std_logic;
	SSEL : out std_logic;

	--Other PCB control
--	REF_SPAD : out STD_LOGIC; 	--
--	LASER_IN : in STD_LOGIC; 	--let external clock drive FPGA
--	REF_LED_env : out std_logic;
	DIS_LED_ref : out std_logic;

	REF_LED : out STD_LOGIC; 	
--	LED_ON_ext : in std_logic;
	LOAD_ref : out std_logic;
	fsm_enable_ext : in std_logic;  -- a pulse for single shot run the FSM

	--Physical output to the opal kelly PCB
	led :  out std_logic_vector( 7  downto 0  );
		
	--RAM in/output 
	ddr2_dq :  inout std_logic_vector( 15  downto 0  );
	ddr2_a :  out std_logic_vector( 12  downto 0  );
	ddr2_ba :  out std_logic_vector( 2  downto 0  );
	ddr2_ras_n :  out std_logic;
	ddr2_cas_n :  out std_logic;
	ddr2_we_n :  out std_logic;
	ddr2_odt :  out std_logic;
	ddr2_cke :  out std_logic;
	ddr2_dm :  out std_logic;
	ddr2_udqs :  inout std_logic;
	ddr2_udqs_n :  inout std_logic;
	ddr2_rzq :  inout std_logic;
	ddr2_zio :  inout std_logic;
	ddr2_udm :  out std_logic;
	ddr2_dqs :  inout std_logic;
	ddr2_dqs_n :  inout std_logic;
	ddr2_ck :  inout std_logic;
	ddr2_ck_n :  inout std_logic;
	ddr2_cs_n :  out std_logic
 );
end entity; 



----The architecture
architecture Behavioral of NeuroSPADProbe_OBIS is

--	function reverse_any_vector (a: in std_logic_vector)
--		return std_logic_vector is
--		  variable result: std_logic_vector(a'RANGE);
--		  alias aa: std_logic_vector(a'REVERSE_RANGE) is a;
--		begin
--		  for i in aa'RANGE loop
--			 result(i) := aa(i);
--		  end loop;
--		  return result;
--	end; -- function reverse_any_vector

	--Reset signals
	signal reset : STD_LOGIC;
	signal fifo_reset : STD_LOGIC;
	signal rst_cnt : unsigned(3 downto 0) := "0000";
	signal dataPL_reset: std_logic;
	 
	--Opal kelly signals
	signal okClk : std_logic;
	signal okHE : std_logic_vector( 112  downto 0  );
	signal okEH : std_logic_vector( 64  downto 0  );
	signal okEHx : std_logic_vector( N*65-1  downto 0  );

	--ZZ. Standard useful signals
	signal one : STD_LOGIC := '1';
	signal zero : STD_LOGIC := '0';
	
	signal data_value : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000111000111";	
	 
	 
--A. Endpoint connections:
--WIREIN
	signal ep00wire        : STD_LOGIC_VECTOR(31 downto 0)  := (others => '0');
	--hex0: resets
			--bit0: reset
			--bit1: drp_reset
			--bit2: ram reset
			--bit3: fsm_reset
	--hex1: datapath enable
			--bit4: RAM write_enable
			--bit5: RAM read_enable
			--bit6: calib_int
			--bit7: unused
	--hex2: FSM settings
			--bit8: fsm_enable
			--bit9: divcnt_reset
			--bit10 : SPAD_outputs_en
			--bit11 : LED_outputs_en
	--hex3: PLL settings
			--bit12 : unused
			--bit13 : unused
			--bit14 : unused
			--bit15 : unused
	--hex4: IC settings
			--bit16 : RSTB
			--bit17 : unused
			--bit18 : unused
			--bit19 : unused
	--hex5: Internal debug
			--bit20 : unused
			--bit21 : unused
			--bit22 : unused
			--bit23 : unused
	--hex6: SPI/DTC
			--bit24 : EN_DTC
			--bit25 :
			--bit26 :
			--bit27 :
	
	signal ep01wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--all bits: fsm_pattern_frames
						
	signal ep02wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--all bits: fsm_stim_periods
			
	signal ep03wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--all bits: fsm_rest_periods
	
	signal ep04wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--bits 15 downto 8: PLL division
			--bits 7 downto 0: PLL multiplier
			
	signal ep05wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--all bits: CLKOUT0 phase
			
	signal ep06wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--all bits: CLKOUT0 duty cycle
			
	signal ep07wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--all bits: CLKOUT1 phase
			
	signal ep08wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--all bits: CLKOUT1 duty cycle
			
	signal ep09wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--all bits: CLKOUT2 phase
			
	signal ep10wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--all bits: CLKOUT2 duty cycle
			
	signal ep11wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--all bits: pix_off_mask_shift_in(31 downto 0)
	
	signal ep12wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--all bits: pix_off_mask_shift_in(63 downto 32)	
			
	signal ep13wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--CLKFBOUTMULT
	
	signal ep14wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--all bits: CLKFBOUT PHASE
			
	signal ep15wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--CLKFBOUTDIV
			
	signal ep16wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--camdiv
	signal ep17wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--unused
	signal ep18wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--t-high led clock
	signal ep19wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--t_low led clock
		
	
--WIREOUT
	signal ep20wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--bit 8 downto 7 : PROBE_SEL
			--bit 7 downto 2 : ADDR
			--bit 1 downto 0 : PIX_SEL
			
	signal ep21wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--bit 15 downto 7 : FSMOUT8b
			--bit 4 downto 0 : DOUT
   signal ep22wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--all bits: fifo_ia_rd_count
	signal ep23wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--all bits: fifoc_rd_count
	signal ep24wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--all bits: unused
	signal ep25wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--all bits: 
	signal ep26wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			--all bits: memorycount
	signal ep27wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal ep28wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal ep29wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal ep30wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal ep31wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal ep32wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal ep33wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal ep34wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal ep35wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal ep36wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal ep37wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal ep38wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal ep39wire        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

--TRIGGERIN
	signal ep40TrigIn : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');	
			--bit0: enable trigger for the pll programmer
	signal ep41TrigIn : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');	
			--bit0: enable programmer for SPI
			
--TRIGGEROUT			
	signal ep60TrigOut : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');	
			--bit7: pipe_out_ready
	
--B. 		Component signals
--B1. 	RAM system signals
	 signal sys_clk_ibufg :  std_logic;
	 signal c3_pll_lock : std_logic;
	 signal c3_calib_done: std_logic;
	 signal calib_done: std_logic;
    signal c3_clk0 : std_logic;
	 signal c3_clk0_n : std_logic;
    signal c3_sys_rst_i : std_logic;
    signal c3_rst0 : std_logic;
	 signal ddr2_ck_sig : std_logic;
	 signal ddr2_ck_n_sig : std_logic;
	 --RAM Command signals
    signal c3_p0_cmd_en : std_logic;
    signal c3_p0_cmd_instr : std_logic_vector( 2  downto 0  );
    signal c3_p0_cmd_bl : std_logic_vector( 5  downto 0  );
    signal c3_p0_cmd_byte_addr : std_logic_vector( 29  downto 0  );
    signal c3_p0_cmd_empty : std_logic;
    signal c3_p0_cmd_full : std_logic;
	 --RAM Read signals
    signal c3_p0_wr_en : std_logic;
    signal c3_p0_wr_mask : std_logic_vector(C3_P0_MASK_SIZE - 1 downto 0);
    signal c3_p0_wr_data : std_logic_vector(C3_P0_DATA_PORT_SIZE - 1 downto 0);
    signal c3_p0_wr_full : std_logic;
    signal c3_p0_wr_empty : std_logic;
    signal c3_p0_wr_count : std_logic_vector( 6  downto 0  );
    signal c3_p0_wr_underrun : std_logic;
    signal c3_p0_wr_error : std_logic;
	 --RAM Write signals
    signal c3_p0_rd_en : std_logic;
    signal c3_p0_rd_data : std_logic_vector(C3_P0_DATA_PORT_SIZE - 1 downto 0);
    signal c3_p0_rd_full : std_logic;
    signal c3_p0_rd_empty : std_logic;
    signal c3_p0_rd_count : std_logic_vector( 6  downto 0  );
    signal c3_p0_rd_overflow : std_logic;
    signal c3_p0_rd_error : std_logic;

	
--B2 RAM controller signals
	 signal ob_count: std_logic_vector( 6  downto 0  ); --in
	 signal ob_data : std_logic_vector( C3_P0_DATA_PORT_SIZE - 1  downto 0  ); --in
	 signal ob_write_en: std_logic;		--out
	 signal ob_full: std_logic;		--out
	 
	 signal ib_count: std_logic_vector(6  downto 0); --in
	 signal ib_data: std_logic_vector( C3_P0_DATA_PORT_SIZE -1  downto 0  )  := (others => '0');	--in
    signal ib_empty: std_logic;			--in
    signal ib_valid: std_logic;			--in
	 signal ib_read_en: std_logic;		--out
	 --status 
	 signal memoryCount :  std_logic_vector(26 downto 0); 
	 signal mcbstate :  std_logic_vector(3 downto 0); 

--B3. FSM signals
	signal clk_FSM_FIFO 		: std_logic;
	signal clk_FSM_FIFO_n 	: std_logic;
	signal fsm_req_fifowr 	: STD_LOGIC;
	signal fsmout16b 			: std_logic_vector(15 downto 0) := (others => '0');
	signal fsm_enable 		: STD_LOGIC;
	signal fsm_SPAD_ON_CLK_EN	: STD_LOGIC;
	signal fsm_LED_ON_CLK_EN	: STD_LOGIC;
	signal fsm_CAMERA_CLK_EN : std_logic;
	signal fsm_pattern_frames : std_logic_vector(31 downto 0);
	signal fsm_rest_periods : std_logic_vector(31 downto 0);
	signal fsm_PROBE_SEL 		: STD_LOGIC_vector(1 downto 0);
	signal fsm_ADDR 					: std_logic_vector(5 downto 0);
	signal fsm_SIDE	 					: std_logic;
	signal fsm_BETA	 				: std_logic;
	signal fsm_reset					: std_logic;
	signal fsm_frame_periods : std_logic_vector(31 downto 0);
	signal NEXT_PATTERN		: std_logic;
	signal pattern_valid				: std_logic;
	signal spad_outputs_en 	: std_logic;
	signal led_outputs_en 		: std_logic;
	signal MEM_CLEAR_fsm	: std_logic;
	signal LOAD_fsm 					: std_logic;
	signal DIS_LED_fsm 			: std_logic;
	
	 
--B4. FIFO_IB signals
	signal fifo_ib_wren : std_logic;
	signal fifo_ib_full : std_logic;
	signal fifo_ib_wr_count: std_logic_vector(9 downto 0);
	 
--B5. FIFO_O & pipe signals
	signal pipe_out_ready :std_logic;
	signal po0_ep_read : std_logic;
	signal fifo_o_rd_count: std_logic_vector(8 downto 0);
	signal fifo_o_data_out: std_logic_vector(31 downto 0);
	signal pipe_out_data : std_logic_vector(31 downto 0);
	signal fifo_o_rd_en : std_logic;
	signal fifo_o_empty : std_logic;

--B6. FIFO_I & BTpipeIN signals
	signal pipe_in_data : std_logic_vector(31 downto 0);
	signal pipe_in_data_adj : std_logic_vector(31 downto 0);
	signal pi0_ep_write : std_logic;
	signal pipe_in_ready : std_logic;
	
	signal fifoa_ledmask_full : std_logic := '0';
	signal fifoa_ledmask_empty : std_logic := '0';
	signal dis_led_mask256b: std_logic_vector(255 downto 0);
	signal dis_led_mask1024b_adjusted: std_logic_vector(1023 downto 0);
	
	signal fifoa_ledmask_wr_count : std_logic_vector(4 downto 0);
	signal fifoa_ledmask_rd_count: std_logic_vector(3 downto 0);

	--fifoB
	signal fifob_ledmask_full : std_logic := '0';  
	signal fifob_ledmask_empty : std_logic := '1'; 
	signal fifob_dout : std_logic_vector(1023 downto 0);
	signal fifob_wren : std_logic := '0';  
	signal fifob_rden : std_logic := '0';  
	signal fifob_ledmask_wr_count : std_logic_vector(7 downto 0);
	signal fifob_ledmask_rd_count: std_logic_vector(5 downto 0);
	
	--fifoC
	signal fifoc_readswitch : std_logic := '0';
	signal fifoc_wren : std_logic := '0';  
	signal fifoc_rden : std_logic := '0';  
	signal fifoc_dout : std_logic_vector(1023 downto 0);
	signal fifoc_din : std_logic_vector(1023 downto 0);
	signal fifoc_ledmask_full : std_logic := '0';
	signal fifoc_ledmask_empty : std_logic := '1'; 
	signal fifoc_ledmask_rd_count: std_logic_vector(5 downto 0);
	signal fifocindex : std_logic_vector(5 downto 0);
		
	--FIFO SPIA signals
	signal fifospia_wren : std_logic := '0';
	signal fifospia_rden : std_logic := '0';
	signal fifospia_full : std_logic := '0';
	signal fifospia_empty : std_logic := '0';
	signal fifospia_dout : std_logic_vector(127 downto 0);
	signal fifospia_DIN : std_logic_vector(1023 downto 0);
	signal spi_di_req : std_logic;
	signal spi_di : std_logic_vector(15 downto 0);
	signal spi_do : std_logic_vector(15 downto 0);
	signal fifospib_rden : std_logic := '0';
	signal fifospib_wren : std_logic := '0';
	signal fifospib_full : std_logic := '0';
	signal fifospib_empty : std_logic := '0';
	signal fifospib_wrcount : std_logic_vector(3 downto 0);
	

--B7. Clock forwarding signals
	signal pll_sys_clk : std_logic;
	
	signal SPAD_ON_CLK 		: std_logic;
	signal ce_spadclk	: std_logic;
	signal rst_spadclk	: std_logic;
	signal spad_on_clk_bufin : std_logic;
	signal SPAD_ON_CLK_n : std_logic;
	signal SPAD_ON_clk_sel : std_logic;
	signal SPAD_ON_clk_out : std_logic;

	signal led_on_clk 		: std_logic;
	signal ce_ledclk			:	 std_logic;
	signal rst_ledclk		: std_logic;
	signal led_on_clk_bufin : std_logic;
	signal led_on_clk_n : std_logic;
	signal led_on_clk_sel : std_logic;
	signal led_on_clk_out : std_logic;
	
	signal led_on_clk_divcnt : std_logic;
	signal divcnt_reset : std_logic;
	signal ce_cameraclk : std_logic;
	signal rst_cameraclk : std_logic;
	signal CAMERA_CLK : std_logic;
	signal CAMERA_CLK_n : std_logic;

--B8. Programmer signals
	signal drp_sen : std_logic;
	signal pll_drp_reset :std_logic;
	signal drp_reset : std_logic;
	signal drp_saddr : std_logic;
	signal drp_srdy : std_logic;
	
	signal CLKOUT0_DIVIDE 	  :  std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(32,8));
	signal CLKOUT0_PHASE  	  :  signed(31 downto 0)				:= (others => '0');
	signal CLKOUT0_DUTY   	  :  std_logic_vector(31 downto 0):= std_logic_vector(to_unsigned(20000,32));
	
	signal CLKOUT1_DIVIDE     :  std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(32,8));
	signal CLKOUT1_PHASE      :  signed(31 downto 0)			 := (others => '0');
	signal CLKOUT1_DUTY       :  std_logic_vector(31 downto 0):= std_logic_vector(to_unsigned(20000,32));
	
	signal CLKOUT2_DIVIDE     :  std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(2,8));
	signal CLKOUT2_PHASE      :  signed(31 downto 0)			 := (others => '0');
	signal CLKOUT2_DUTY       :  std_logic_vector(31 downto 0):= std_logic_vector(to_unsigned(50000,32));
	
	signal CLKOUT3_DIVIDE     :  std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(64,8));
	signal CLKOUT3_PHASE      :  signed(31 downto 0)		    := (others => '0');
	signal CLKOUT3_DUTY       :  std_logic_vector(31 downto 0):= std_logic_vector(to_unsigned(50000,32));
	
	signal CLKOUT4_DIVIDE     :  std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(48,8));
	signal CLKOUT4_PHASE      :  signed(31 downto 0)			 := (others => '0');
	signal CLKOUT4_DUTY       :  std_logic_vector(31 downto 0):= std_logic_vector(to_unsigned(50000,32));
	
	signal CLKOUT5_DIVIDE     :  std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(48,8));
	signal CLKOUT5_PHASE      :  signed(31 downto 0)			 := (others => '0');
	signal CLKOUT5_DUTY       :  std_logic_vector(31 downto 0):= std_logic_vector(to_unsigned(50000,32));
	
	
--B9. Programmer to PLL signals
	signal pll_drp_dclk : std_logic;
	signal pll_drp_den : std_logic;
	signal pll_drp_di : std_logic_vector (15 downto 0);
	signal pll_drp_dwe : std_logic;
	signal pll_drp_do : std_logic_vector (15 downto 0);
	signal pll_drp_drdy : std_logic;
	signal pll_drp_daddr : std_logic_vector (4 downto 0);
	

--B10. PLL signals
	signal pll_LASER_TRIG : std_logic;
	signal LASER_TRIG_in : std_logic;
	signal LASER_TRIG_buf : std_logic;
	signal clkfbout_bufin : std_logic;
	signal clkfbout_clkfbio : std_logic;
	signal clkfbin : std_logic;
	signal pll_locked : std_logic;
	signal pll_clkinsel : std_logic;
	
	
--B11. pix_off mask signals
	signal fifo_mask_full : std_logic;
	signal fifo_mask_empty : std_logic;
	signal fifo_mask_wr_count: std_logic_vector(7 downto 0);
	signal fifo_mask_rd_count : std_logic_vector(4 downto 0);
	signal pix_off_mask : std_logic_vector(1023 downto 0) := (others => '0');
	signal dis_led_mask : std_logic_vector(1023 downto 0) := (others => '0');
	signal dis_led_mask_in : std_logic_vector(63 downto 0) := (others => '0');

	
--C. Custom signals
	--nothing here yet!
	signal dummydata : std_logic_vector (7 downto 0) := "00000000";
	
----END OF SIGNAL DECLARATION-----------------------------------------------------------------------------


----BEGIN COMPONENT DECLARATION----------------------------------------------------------------------------
component spi_master is generic (   
        N : positive := 16;                                             -- 32bit serial word length is default
        CPOL : std_logic := '0';                                        -- SPI mode selection (mode 0 default)
        CPHA : std_logic := '0';                                        -- CPOL = clock polarity, CPHA = clock phase.
        PREFETCH : positive := 2;                                       -- prefetch lookahead cycles
        SPI_2X_CLK_DIV : positive := 10);                              -- for a 39MHz sclk_i, value of 5 yields a 3.9MHz SCK
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
 );   end component;

component fifoindexcounter_v1 is 
	generic( N : positive);
	port(
		--control
		rst : in std_logic;
		clk : in std_logic;
		maxindex : in std_logic_vector(5 downto 0); 
		index : out std_logic_vector(5 downto 0));
end component;

component clkdivcounter_v1 is port(
		--control
		en : in std_logic; 
		t_high : in std_logic_vector(31 downto 0); 
		t_low : in std_logic_vector(31 downto 0); 
		clk : in std_logic;
		rst : in std_logic;
		clkout : out std_logic);
end component;


--AT revised SPI writing fuction for DTC on probe (dual,quads)
component SPI_write_atv2 is port (
		--FSM internal control signals
		en : in std_logic; 
		masterdata : in std_logic_vector(63 downto 0); 
		clk : in std_logic;
		rst : in std_logic;
		
		--addressing signals to IC
		SWR : out std_logic;
		sdin : out std_logic;	--MOSI
		sdout : in std_logic;	--MISO
		sload : out std_logic;
		sreset : out std_logic;
		datareadback : out std_logic_vector(63 downto 0)); 
end component;		


component OLEDSTIMFSMv1 is port (
	--inputs
	en : in std_logic; 
	clk : in std_logic; 
	rst : in std_logic;
	stim_pulses : in std_logic_vector (31 downto 0);
	rest_pulses : in std_logic_vector (31 downto 0);
	stim_frames : in std_logic_vector (31 downto 0);
	dis_led_mask : in std_logic_vector (1023 downto 0);
	pll_locked : in std_logic;
	PATTERN_VALID : in std_logic;
	LED_ON_CLK_DIVCNT : in std_logic;
	data_settle_wait  : std_logic_vector(3 downto 0);
	
	--outputs to IC
	PROBE_SEL : out std_logic_vector(1 downto 0);
	ADDR : out std_logic_vector(5 downto 0);
	SIDE : out std_logic;
	BETA : out std_logic;
	LOAD : out std_logic;
	
	--outputs to FPGA
	DIS_LED : out std_logic;
	NEXT_PATTERN : out std_logic;
	LED_ON_CLK_EN : out std_logic;
	CAMERA_CLK_EN : out std_logic); 
end component;


component FSM_v10_quad is port (
	--FSM internal control signals
	en : in std_logic; 
	clk : in std_logic; 
	rst : in std_logic;
	frame_periods : in std_logic_vector (31 downto 0);
	data_wait_cycles : in std_logic_vector (3 downto 0);
	pattern_frames : in std_logic_vector (31 downto 0);
	PIX_OFF_mask : in std_logic_vector (1023 downto 0);
	DIS_LED_mask : in std_logic_vector (1023 downto 0);

	spad_on_clk : in std_logic;
	pll_locked : in std_logic;
	
	--control signals to IC
	PIX_OFF : out std_logic;
	DIS_LED : out std_logic;
	READ_EN : out std_logic;
	SPAD_ON_CLK_EN : out std_logic; 
	LED_ON_CLK_EN : out std_logic; 
	MEM_CLEAR : out std_logic;
	LOAD : out std_logic;
	
	--data signals from IC
	DIN : in std_logic_vector(5 downto 0);
	
	--data signals to pattern FIFO
	PATTERN_VALID : in std_logic;
	NEXT_PATTERN  : out std_logic;
	
	--data signals to FIFO
	dout : out std_logic_vector(15 downto 0);
	req_fifowr : out std_logic;
	
	--addressing signals to IC
	PROBE_SEL : out std_logic_vector(1 downto 0);
	ADDR : out std_logic_vector(5 downto 0);
	SIDE : out std_logic;
	BETA : out std_logic); 
end component;

component mig_XEM6310_3125MHz is
generic
  (
	C3_P0_MASK_SIZE           : integer;
	C3_P0_DATA_PORT_SIZE      : integer;
	C3_P1_MASK_SIZE           : integer;
	C3_P1_DATA_PORT_SIZE      : integer;
	C3_MEMCLK_PERIOD        : integer; -- Memory data transfer clock period.
	C3_RST_ACT_LOW          : integer; -- # = 1 for active low reset,
												  -- # = 0 for active high reset.
	C3_INPUT_CLK_TYPE       : string; -- input clock type DIFFERENTIAL or SINGLE_ENDED.
	C3_CALIB_SOFT_IP        : string; -- # = TRUE, Enables the soft calibration logic,
												 -- # = FALSE, Disables the soft calibration logic.
	C3_SIMULATION           : string; -- # = TRUE, Simulating the design. Useful to reduce the simulation time,
												 -- # = FALSE, Implementing the design.
	DEBUG_EN                : integer; -- # = 1, Enable debug signals/controls,
												  --   = 0, Disable debug signals/controls.
	C3_MEM_ADDR_ORDER       : string; -- The order in which user address is provided to the memory controller,
												 -- ROW_BANK_COLUMN or BANK_ROW_COLUMN.
	C3_NUM_DQ_PINS          : integer; -- External memory data width.
	C3_MEM_ADDR_WIDTH       : integer; -- External memory address width.
	C3_MEM_BANKADDR_WIDTH   : integer -- External memory bank address width.
);
   
port(
	mcb3_dram_dq                            : inout  std_logic_vector(C3_NUM_DQ_PINS-1 downto 0);
   mcb3_dram_a                             : out std_logic_vector(C3_MEM_ADDR_WIDTH-1 downto 0);
   mcb3_dram_ba                            : out std_logic_vector(C3_MEM_BANKADDR_WIDTH-1 downto 0);
   mcb3_dram_ras_n                         : out std_logic;
   mcb3_dram_cas_n                         : out std_logic;
   mcb3_dram_we_n                          : out std_logic;
   mcb3_dram_odt                           : out std_logic;
   mcb3_dram_cke                           : out std_logic;
   mcb3_dram_dm                            : out std_logic;
   mcb3_dram_udqs                          : inout  std_logic;
   mcb3_dram_udqs_n                        : inout  std_logic;
   mcb3_rzq                                : inout  std_logic;
   mcb3_zio                                : inout  std_logic;
   mcb3_dram_udm                           : out std_logic;
   c3_sys_clk_p                            : in  std_logic;
   c3_sys_clk_n                            : in  std_logic;
--	c3_sys_clk                              : in  std_logic;
   c3_sys_rst_i                            : in  std_logic;
   c3_calib_done                           : out std_logic;
   c3_clk0                                 : out std_logic;
   c3_rst0                                 : out std_logic;
   mcb3_dram_dqs                           : inout  std_logic;
   mcb3_dram_dqs_n                         : inout  std_logic;
   mcb3_dram_ck                            : out std_logic;
   mcb3_dram_ck_n                          : out std_logic;
   c3_p0_cmd_clk                           : in std_logic;
   c3_p0_cmd_en                            : in std_logic;
   c3_p0_cmd_instr                         : in std_logic_vector(2 downto 0);
   c3_p0_cmd_bl                            : in std_logic_vector(5 downto 0);
   c3_p0_cmd_byte_addr                     : in std_logic_vector(29 downto 0);
   c3_p0_cmd_empty                         : out std_logic;
   c3_p0_cmd_full                          : out std_logic;
   c3_p0_wr_clk                            : in std_logic;
   c3_p0_wr_en                             : in std_logic;
   c3_p0_wr_mask                           : in std_logic_vector(C3_P0_MASK_SIZE - 1 downto 0);
   c3_p0_wr_data                           : in std_logic_vector(C3_P0_DATA_PORT_SIZE - 1 downto 0);
   c3_p0_wr_full                           : out std_logic;
   c3_p0_wr_empty                          : out std_logic;
   c3_p0_wr_count                          : out std_logic_vector(6 downto 0);
   c3_p0_wr_underrun                       : out std_logic;
   c3_p0_wr_error                          : out std_logic;
   c3_p0_rd_clk                            : in std_logic;
   c3_p0_rd_en                             : in std_logic;
   c3_p0_rd_data                           : out std_logic_vector(C3_P0_DATA_PORT_SIZE - 1 downto 0);
   c3_p0_rd_full                           : out std_logic;
   c3_p0_rd_empty                          : out std_logic;
   c3_p0_rd_count                          : out std_logic_vector(6 downto 0);
   c3_p0_rd_overflow                       : out std_logic;
   c3_p0_rd_error                          : out std_logic;
	sys_clk_ibufg									 : out std_logic;
	c3_pll_lock_o									: out std_logic
);
end component;


component at_mcbController is 
generic (
	FIFO_SIZE : INTEGER ;
	BURST_LEN : INTEGER;
	P0_WR_SIZE : INTEGER);
port(clk : in std_logic;
	reset : in std_logic;
	writes_en : in std_logic;
	reads_en : in std_logic;
	calib_done : in std_logic;
	--DRAM input buffer
	inputBufferReadEnable : out std_logic;
	inputBufferData : in std_logic_vector(C3_P0_DATA_PORT_SIZE - 1 downto 0);
	inputBufferCount : in std_logic_vector(6 downto 0);
	inputBufferValid : in std_logic;
	inputBufferEmpty : in std_logic;
	--DRAM output buffer
	outputBufferWriteEnable : out std_logic;
	outputBufferData : out std_logic_vector(C3_P0_DATA_PORT_SIZE - 1 downto 0);
	outputBufferCount : in std_logic_vector(6 downto 0);
	outputBufferFull : in std_logic;
	--RAM Usage
	memoryCount : out std_logic_vector(26 downto 0); 
	mcbstate : out std_logic_vector(3 downto 0); 
	--Read signals
	p0_rd_en : out std_logic;  
	p0_rd_empty : in std_logic;
	p0_rd_data : in std_logic_vector(C3_P0_DATA_PORT_SIZE - 1 downto 0);
	--Command signals
	p0_cmd_full  : in std_logic;
	p0_cmd_en  : out std_logic;  
	p0_cmd_instr :  out std_logic_vector( 2  downto 0  );
	p0_cmd_byte_addr :  out std_logic_vector( 29  downto 0  );
	p0_cmd_bl :  out std_logic_vector( 5  downto 0  );
	--Write signals
	p0_wr_count : in std_logic_vector(6 downto 0);
	p0_wr_empty : in std_logic;
	p0_wr_full : in std_logic;
	p0_wr_en : out std_logic;
	p0_wr_underrun : in std_logic;
	p0_wr_data : out std_logic_vector(C3_P0_DATA_PORT_SIZE - 1 downto 0);
	p0_wr_mask : out std_logic_vector(C3_P0_MASK_SIZE - 1 downto 0));
end component;

component FIFO_I16b_O128b is port (
		rst :  in std_logic;
		wr_clk :  in std_logic;
		rd_clk :  in std_logic;
		din :  in std_logic_vector( 15  downto 0  );
		wr_en :  in std_logic;
		rd_en :  in std_logic;
		dout :  out std_logic_vector( C3_P0_DATA_PORT_SIZE -1  downto 0  );
		full :  out std_logic;
		empty : out std_logic;
		valid : out std_logic;
		rd_data_count :  out std_logic_vector( 6  downto 0  );
		wr_data_count :  out std_logic_vector( 9  downto 0  ));
end component; 
	 
component FIFO_I128b_O32b is port (
		rst :  in std_logic;
		wr_clk :  in std_logic;
		rd_clk :  in std_logic;
		din :  in std_logic_vector( C3_P0_DATA_PORT_SIZE -1  downto 0  );
		wr_en :  in std_logic;
		rd_en :  in std_logic;
		dout :  out std_logic_vector( 31  downto 0  );
		full :  out std_logic;
		empty : out std_logic;
		rd_data_count :  out std_logic_vector( 8  downto 0  );
		wr_data_count :  out std_logic_vector( 6  downto 0  ));
end component;
	 
component FIFO_I128b_O16b is port (
		rst :  in std_logic;
		wr_clk :  in std_logic;
		rd_clk :  in std_logic;
		din :  in std_logic_vector(127  downto 0  );
		wr_en :  in std_logic;
		rd_en :  in std_logic;
		dout :  out std_logic_vector( 15  downto 0  );
		full :  out std_logic;
		empty : out std_logic;
		rd_data_count :  out std_logic_vector( 6 downto 0  );
		wr_data_count :  out std_logic_vector( 3  downto 0  ));
end component;

component FIFO_I32b_O256b is port (
		rst :  in std_logic;
		wr_clk :  in std_logic;
		rd_clk :  in std_logic;
		din :  in std_logic_vector( 31  downto 0  );
		wr_en :  in std_logic;
		rd_en :  in std_logic;
		dout :  out std_logic_vector( 255  downto 0  );
		full :  out std_logic;
		empty : out std_logic;
		rd_data_count :  out std_logic_vector( 3 downto 0  );
		wr_data_count :  out std_logic_vector( 4 downto 0  ));
end component;


component FIFO_I256b_O1024b is port (
		rst :  in std_logic;
		wr_clk :  in std_logic;
		rd_clk :  in std_logic;
		din :  in std_logic_vector( 255  downto 0  );
		wr_en :  in std_logic;
		rd_en :  in std_logic;
		dout :  out std_logic_vector( 1023  downto 0  );
		full :  out std_logic;
		empty : out std_logic;
		rd_data_count :  out std_logic_vector( 5 downto 0  );
		wr_data_count :  out std_logic_vector( 7 downto 0  ));
end component;

component FIFO_I1024b_O1024b is port (
		rst :  in std_logic;
		clk :  in std_logic;
		din :  in std_logic_vector( 1023  downto 0  );
		wr_en :  in std_logic;
		rd_en :  in std_logic;
		dout :  out std_logic_vector( 1023  downto 0  );
		full :  out std_logic;
		empty : out std_logic;
		valid : out std_logic;
		data_count :  out std_logic_vector(5 downto 0));
end component;

component FIFO_I1024_O128b is port (
		rst :  in std_logic;
		wr_clk :  in std_logic;
		rd_clk : in std_logic;
		din :  in std_logic_vector(1023  downto 0);
		wr_en :  in std_logic;
		rd_en :  in std_logic;
		dout :  out std_logic_vector(127  downto 0);
		full :  out std_logic;
		empty : out std_logic;
		rd_data_count :  out std_logic_vector( 8 downto 0 );
		wr_data_count :  out std_logic_vector( 5 downto 0 ));
end component;

component at_pll_prog is 
generic(
      CLKFBOUT_MULT : integer;
      CLKFBOUT_PHASE : real;
      DIVCLK_DIVIDE  : integer);
 port( 		
      CLKOUT0_DIVIDE 	 : in  std_logic_vector(7 downto 0);
      CLKOUT0_PHASE  	 : in  signed(31 downto 0);
      CLKOUT0_DUTY   	 : in  std_logic_vector(31 downto 0);
      
      CLKOUT1_DIVIDE     : in  std_logic_vector(7 downto 0);
      CLKOUT1_PHASE      : in  signed(31 downto 0);
      CLKOUT1_DUTY       : in  std_logic_vector(31 downto 0);
      
      CLKOUT2_DIVIDE     : in  std_logic_vector(7 downto 0);
      CLKOUT2_PHASE      : in  signed(31 downto 0);
      CLKOUT2_DUTY       : in  std_logic_vector(31 downto 0);
      
      CLKOUT3_DIVIDE     : in  std_logic_vector(7 downto 0);
      CLKOUT3_PHASE      : in  signed(31 downto 0);
      CLKOUT3_DUTY       : in  std_logic_vector(31 downto 0);
      
      CLKOUT4_DIVIDE     : in  std_logic_vector(7 downto 0);
      CLKOUT4_PHASE      : in  signed(31 downto 0);
      CLKOUT4_DUTY       : in  std_logic_vector(31 downto 0);
      
      CLKOUT5_DIVIDE     : in  std_logic_vector(7 downto 0);
      CLKOUT5_PHASE      : in  signed(31 downto 0);
      CLKOUT5_DUTY       : in  std_logic_vector(31 downto 0);
     
      SEN: in std_logic;
      SCLK: in std_logic;
      RST: in std_logic;
      SRDY: out std_logic;
      
      DO : in std_logic_vector(15 downto 0);
      DRDY : in std_logic;
      LOCKED : in std_logic;
      DWE : out std_logic;
      DEN : out std_logic;
      DADDR : out std_logic_vector(4 downto 0);
      DI : out std_logic_vector(15 downto 0);
      DCLK : out std_logic;
      RST_PLL : out std_logic); 
end component;

----END OF COMPONENT DECLARATION----------------------------------------------------------------------------




----EXECUTION----------------------------------------------------------------------------------------------
begin --Concurrent part

--A. Import all required data
	--A1 Resets
	reset <= ep00wire(0);							--Everything reset except items below
	drp_reset <= ep00wire(1);						--PLL programmer reset
	dataPL_reset <= ( ep00wire(2) or c3_rst0); 	--RAM and memory reset, FIFO reset
	c3_sys_rst_i <= ep00wire(2);					--RAM reset
	fsm_reset <= ep00wire(3);						--FSM and SPI reset
	
	--A2 Signals set for RAM functionality
   ddr2_cs_n <= '0';  --chip select enable active low, has to be 0!
	ddr2_ck <= ddr2_ck_sig;
	ddr2_ck_n <= ddr2_ck_n_sig;
	calib_done <= c3_calib_done or ep00wire(6);
	calib_done <= c3_calib_done or ep00wire(6);
	
	--A3. FSM control signals
	fsm_enable 		<= ep00wire(8) OR fsm_enable_ext;
	divcnt_reset 			<= ep00wire(9);
	spad_outputs_en 	<= ep00wire(10);
	led_outputs_en 		<= ep00wire(11);
	
	ce_spadclk 		<= pll_locked and fsm_SPAD_ON_CLK_EN and spad_outputs_en; 	--important, only put out spad_on_clk when pll_locked and in record state! 
	ce_ledclk 		   <= fsm_LED_ON_CLK_EN and led_outputs_en;
	ce_cameraclk  <= fsm_CAMERA_CLK_EN and led_outputs_en;
	
	fsm_pattern_frames  		<= ep01wire;
	fsm_frame_periods			<= ep02wire;
	fsm_rest_periods				<= ep03wire;


--B do concurrent logic
	--B1. Set simple signals
--	dummydata <= "000" & DOUT;
	
	--B2. Datapath control logic
	--Data is written by the FSM, important to not write when full!
	fifo_ib_wren <= '1' when ((fsm_req_fifowr = '1') AND (fifo_ib_full = '0') AND (reset = '0') AND (dataPL_reset = '0'))
							 else '0';			
	fifo_o_rd_en <= '1' when ((po0_ep_read = '1') AND (fifo_o_empty = '0') AND (reset = '0') AND (dataPL_reset = '0'))
							 else '0';	 
	pipe_out_ready <=  '1' when ((to_integer(unsigned(fifo_o_rd_count)) >= BLOCK_SIZE)  AND (reset = '0') )
						else '0';

	--PipeIn control logic
	--Important not to write when full, or read when empty!
	fifob_wren <= '1' when ((fifoa_ledmask_empty = '0') AND (fifob_ledmask_full = '0') AND (reset = '0'))
							 else '0';	
							 
	pipe_in_ready <= '1' when (  (to_integer(unsigned(fifoa_ledmask_wr_count)) <= (LEDMASK_WR_SIZE - BLOCK_SIZE_MASK)) AND (fifoa_ledmask_full = '0') AND (fifob_ledmask_full = '0') AND (reset = '0'))
								else '0';								 
	
	
	--fifoC, the looping FIFO. User is responsible to not flash more patterns than fit in fifo, otherwise it will lock up
	--Do not transfer automatically from B to C, only using the trigger
	--This needs to be completed before enabling FSM!!
		fifob_rden <= '1' when ((ep41TrigIn(0) = '1')  AND (fifob_ledmask_empty = '0')) else '0';
	
	--write to fifoc from either fifob (on trigger) or itself (on NEXT_PATTERN), when not full
		fifoc_wren <=  '1' when (     ((fifob_rden = '1') OR (NEXT_PATTERN = '1'))  AND (fifoc_ledmask_full = '0')) else '0';	
	
	--Data comes from itself fifoC (on NEXT_PATTERN) else from fifoB. Can be swapped with Trigger
		fifoc_DIN <= fifoc_DOUT when (NEXT_PATTERN = '1') 	else fifoB_DOUT;
	
	--read from fifoc to FSM on next pattern request (when not empty). 
	--Transfer first pattern with trigger to eliminate the initial zero pattern
		fifoc_rden <= '1' when (((NEXT_PATTERN= '1') OR (ep41TrigIn(1) = '1') ) AND (fifoc_ledmask_empty = '0'))  else '0';	


	--FIFOspia is parallel to fifoc. Requires transfer from fifob->fifospia to fill up FIFOspia
		fifospia_wren <=  '1' when (((fifob_rden = '1') OR (NEXT_PATTERN = '1'))  AND (fifospia_full = '0')) else '0';	
											
	 --transfer the data from fifospia->fifospib anytime there is data
		fifospia_rden <= '1' when ((fifospib_full= '0')  AND (fifospia_empty = '0') AND (reset ='0')) else '0';

	--transfer the data from fifospia->fifospib anytime there is data
		fifospib_rden <= '1' when (      ((spi_di_req= '1') OR (ep41TrigIn(3) = '1'))  AND (fifospib_empty = '0') AND (reset ='0')) else '0';


	
	--B3. Clock signals

	--B4. Programmable PLL signals
--	SPAD_ON_clk_sel <= ep00wire(12);
	drp_sen <= ep40TrigIn(0);   --enable comes before the ready
--	pll_clkinsel <= ep00wire(13); 	--LOW is external clock sourcing, HIGH is internal
	  
	CLKOUT0_DIVIDE <= ep04wire(7 downto 0);
	CLKOUT0_PHASE  <= signed(ep05wire);
	CLKOUT0_DUTY  	<= ep06wire;
	
	CLKOUT1_DIVIDE <= ep04wire(15 downto 8);
	CLKOUT1_PHASE  <= signed(ep07wire);
	CLKOUT1_DUTY   <= ep08wire;
	
	CLKOUT2_DIVIDE <= ep04wire(23 downto 16);
	CLKOUT2_PHASE  <= signed(ep09wire);
	CLKOUT2_DUTY   <= ep10wire;
	
	CLKOUT3_DIVIDE <= ep04wire(31 downto 24);
	CLKOUT3_PHASE  <= signed(ep14wire);
	CLKOUT3_DUTY   <= ep15wire;
	
		
--C. Output the data
--c1. GPIO 
RSTB <= ep00wire(16);
--EN_DTC <= ep00wire(24);

PROBE_SEL 	<= fsm_PROBE_SEL when ((spad_outputs_en= '1') OR (led_outputs_en= '1')) else "00";
ADDR		 		<= fsm_ADDR when ((spad_outputs_en= '1') OR (led_outputs_en= '1')) else "000000";
SIDE	 	 			<= fsm_SIDE when ((spad_outputs_en= '1') OR (led_outputs_en= '1')) else '0';
BETA	 	 			<= fsm_BETA when ((spad_outputs_en= '1') OR (led_outputs_en= '1')) else '0';
MEM_CLEAR <= MEM_CLEAR_fsm when (spad_outputs_en = '1') else '0';
LOAD 				<= LOAD_fsm when (led_outputs_en = '1') else '0';
LOAD_ref		<= LOAD_fsm when (led_outputs_en = '1') else '0';
DIS_LED 		<= DIS_LED_fsm when (led_outputs_en = '1') else '0';

--REF_LED_env <= fsm_LED_ON_CLK_EN;
DIS_LED_ref <= DIS_LED_fsm when (led_outputs_en = '1') else '0';

--the MSB (left) is the one closest to the USB cable
--led <= (not( pll_locked & ce_spadclk & ce_ledclk & ce_dtcclk & fsm_PROBE_SEL(1) & fsm_PROBE_SEL(0) & fsm_SIDE & fsm_BETA));
--led <= not(fifospib_wrcount & fifocindex(3 downto 0)) ;
led <= not("00" & fifocindex);

--C2. Pipe data. Somehow the bytes are intact but get reversed when they are put out via the pipe
pipe_out_data(15 downto 0) <= fifo_o_data_out(31 downto 16);
pipe_out_data(31 downto 16) <= fifo_o_data_out(15 downto 0);


--swap first and last
pipe_in_data_adj(31 downto 24) <= pipe_in_data(7 downto 0);
pipe_in_data_adj(7 downto 0) <= pipe_in_data(31 downto 24);
--swap middle 2
pipe_in_data_adj(23 downto 16) <= pipe_in_data(15 downto 8);
pipe_in_data_adj(15 downto 8) <= pipe_in_data(23 downto 16);


--connect the data
--1->2
--2->3
--3->4
--4->1
dis_led_mask1024b_adjusted(511 downto 256) <= fifoc_DOUT(255 downto 0);
dis_led_mask1024b_adjusted(767 downto 512) <= fifoc_DOUT(511 downto 256);
dis_led_mask1024b_adjusted(1023 downto 768) <= fifoc_DOUT(767 downto 512);
dis_led_mask1024b_adjusted(255 downto 0) <= fifoc_DOUT(1023 downto 768);

fifospia_DIN <= fifoc_DIN;

--BIT_REVERSE: for i in 0 to 1023 generate
--    fifospia_DIN(i) <= fifoc_DIN(1023-i);
--end generate;

--fifospia_DIN <= reverse_any_vector(fifoc_DIN);

--C3. Endpoints
--ep20wire(9 downto 0) <= fsm_PROBE_SEL & fsm_ADDR & fsm_SIDE & fsm_BETA;
ep20wire(15 downto 0) <= spi_di;
--ep21wire <= fifospia_dout(31 downto 0);
--ep22wire(15 downto 0) <= spi_do;
 
--ep21wire(23 downto 8) <= fsmout16b;
--ep21wire(GPIO_IN_LEN-1 downto 0) <= DOUT;
--ep22wire(FIFO_d_128b-1 downto 0) <= ib_count;

ep23wire(5 downto 0) <= fifoc_ledmask_rd_count;
ep24wire(5 downto 0) <= fifob_ledmask_rd_count;

--ep25wire <= fifospia_dout(31 downto 0);
--ep27wire <= fifospia_dout(63 downto 32);
--ep28wire <= fifospia_dout(95 downto 64);
--ep29wire <= fifospia_dout(127 downto 96);
--ep30wire <= dis_led_mask1024b_adjusted(159 downto 128);
--ep31wire <= dis_led_mask1024b_adjusted(191 downto 160);
--ep32wire <= dis_led_mask1024b_adjusted(223 downto 192);
--ep33wire <= dis_led_mask1024b_adjusted(255 downto 224);
--
--ep34wire <= dis_led_mask1024b_adjusted(287 downto 256);
--ep35wire <= dis_led_mask1024b_adjusted(319 downto 288);
--ep36wire <= dis_led_mask1024b_adjusted(351 downto 320);
--ep37wire <= dis_led_mask1024b_adjusted(383 downto 352);
--ep38wire <= dis_led_mask1024b_adjusted(415 downto 384);
--ep39wire <= dis_led_mask1024b_adjusted(447 downto 416);
--ep21wire <= dis_led_mask1024b_adjusted(479 downto 448);
--ep22wire <= dis_led_mask1024b_adjusted(511 downto 480);

ep26wire(26 downto 0) <= memoryCount;

--ep60TrigOut(0) <= spi_di_req;

--D. Run process synchronous to 100MHz internal clock, AKA sequential part
--process (sys_clk_ibufg, reset)
--	begin
--	
--	if (reset = '1') then
--	else	
--	end if;
--end process;
--END OF LOGIC

--Start port maps
MIG: mig_XEM6310_3125MHz generic map ( C3_P0_MASK_SIZE    => C3_P0_MASK_SIZE,
		C3_P0_DATA_PORT_SIZE   => C3_P0_DATA_PORT_SIZE,
		C3_P1_MASK_SIZE       => C3_P1_MASK_SIZE,
		C3_P1_DATA_PORT_SIZE   => C3_P1_DATA_PORT_SIZE,
		C3_MEMCLK_PERIOD      => C3_MEMCLK_PERIOD,
		C3_RST_ACT_LOW     =>C3_RST_ACT_LOW,
		C3_INPUT_CLK_TYPE=>C3_INPUT_CLK_TYPE,
		C3_CALIB_SOFT_IP   => C3_CALIB_SOFT_IP,
		C3_SIMULATION      =>C3_SIMULATION,
		DEBUG_EN    =>DEBUG_EN                ,
		C3_MEM_ADDR_ORDER=>C3_MEM_ADDR_ORDER,
		C3_NUM_DQ_PINS    =>C3_NUM_DQ_PINS,
		C3_MEM_ADDR_WIDTH  => C3_MEM_ADDR_WIDTH,
		C3_MEM_BANKADDR_WIDTH   =>C3_MEM_BANKADDR_WIDTH
		)
   
	port map(--These signals come directly from the DDR GPIO
		mcb3_dram_dq                            =>ddr2_dq,
		mcb3_dram_a                             =>ddr2_a,
		mcb3_dram_ba                            =>ddr2_ba,
		mcb3_dram_ras_n                         =>ddr2_ras_n,
		mcb3_dram_cas_n                         =>ddr2_cas_n,
		mcb3_dram_we_n                          =>ddr2_we_n,
		mcb3_dram_odt                           =>ddr2_odt,
		mcb3_dram_cke                           =>ddr2_cke,
		mcb3_dram_dm                            =>ddr2_dm,
		mcb3_dram_udqs                          =>ddr2_udqs,
		mcb3_dram_udqs_n                        =>ddr2_udqs_n,
		mcb3_rzq                                =>ddr2_rzq,
		mcb3_zio                                =>ddr2_zio,
		mcb3_dram_udm                           =>ddr2_udm,
		mcb3_dram_dqs                           =>ddr2_dqs,
		mcb3_dram_dqs_n                         =>ddr2_dqs_n,
		mcb3_dram_ck                            =>ddr2_ck_sig,
		mcb3_dram_ck_n                          =>ddr2_ck_n_sig,
		
		--Clocks input. Differential 100Mhz is used
		c3_sys_clk_p                            => sys_clkp,
		c3_sys_clk_n                            => sys_clkn,
		c3_pll_lock_o									=> c3_pll_lock,

		--The signals created from the DDR2 controller
		c3_sys_rst_i                            => c3_sys_rst_i,
		c3_calib_done                           => c3_calib_done,
		
		--RAM controller Output clock and reset
		c3_clk0                                 => c3_clk0,
		c3_rst0                                 => c3_rst0,
		
		--Command signals
		c3_p0_cmd_clk                           => c3_clk0,
		c3_p0_cmd_en                            => c3_p0_cmd_en,
		c3_p0_cmd_instr                         => c3_p0_cmd_instr,
		c3_p0_cmd_bl                            => c3_p0_cmd_bl,
		c3_p0_cmd_byte_addr                     => c3_p0_cmd_byte_addr,
		c3_p0_cmd_empty                         => c3_p0_cmd_empty,
		c3_p0_cmd_full                          => c3_p0_cmd_full, 
		--DDR write signals
		c3_p0_wr_clk                            => c3_clk0,
		c3_p0_wr_en                             => c3_p0_wr_en,
		c3_p0_wr_mask                           => c3_p0_wr_mask,
		c3_p0_wr_data                           => c3_p0_wr_data,
		c3_p0_wr_full                           => c3_p0_wr_full,
		c3_p0_wr_empty                          => c3_p0_wr_empty,
		c3_p0_wr_count                          => c3_p0_wr_count,
		c3_p0_wr_underrun                       => c3_p0_wr_underrun,
		c3_p0_wr_error                          => c3_p0_wr_error,
		--DDR read signals
		c3_p0_rd_clk                            => c3_clk0,
		c3_p0_rd_en                             => c3_p0_rd_en,
		c3_p0_rd_data                           => c3_p0_rd_data,
		c3_p0_rd_full                           => c3_p0_rd_full,
		c3_p0_rd_empty                          => c3_p0_rd_empty,
		c3_p0_rd_count                          => c3_p0_rd_count,
		c3_p0_rd_overflow                       => c3_p0_rd_overflow,
		c3_p0_rd_error                          => c3_p0_rd_error,
		sys_clk_ibufg									 => sys_clk_ibufg
		);


mcbcontroller : at_mcbcontroller
	generic map(
		BURST_LEN => BURST_LEN,
		FIFO_SIZE => FIFO_SIZE_128b,
		P0_WR_SIZE=> P0_WR_SIZE)

	port map (			
		writes_en => ep00wire(4),
		reads_en => ep00wire(5),
		reset => dataPL_reset,
		calib_done => calib_done,
		clk => c3_clk0,

		--Make a _top-variable for the 4 input signals that are being changed by "mode"
		--Input buffer
		inputBufferCount => ib_count,				--in
		inputBufferData  => ib_data,			   	--in
		inputBufferEmpty => ib_empty,				--in, but compiler says its never used			 
		inputBufferValid => ib_valid,				--in, has to be enabled on the FIFO to synchronize better

		inputBufferReadEnable => ib_read_en,   	--out

		--output buffer
		outputBufferCount => ob_count, 				--in
		outputBufferData => ob_data,					--out
		outputBufferWriteEnable => ob_write_en,	--out
		outputBufferFull => ob_full,	--in

		--RAM usage
		mcbstate => mcbstate,
		memoryCount => memoryCount,
		--RAM Command signals
		p0_cmd_bl => c3_p0_cmd_bl,
		p0_cmd_byte_addr => c3_p0_cmd_byte_addr,
		p0_cmd_en => c3_p0_cmd_en,
		p0_cmd_full => c3_p0_cmd_full,
		p0_cmd_instr => c3_p0_cmd_instr,
		--RAM Read signals
		p0_rd_data => c3_p0_rd_data,
		p0_rd_empty => c3_p0_rd_empty,
		p0_rd_en => c3_p0_rd_en,
		--RAM Write signals
		p0_wr_count => c3_p0_wr_count,
		p0_wr_empty => c3_p0_wr_empty,
		p0_wr_data => c3_p0_wr_data,
		p0_wr_en => c3_p0_wr_en,
		p0_wr_full => c3_p0_wr_full,
		p0_wr_underrun => c3_p0_wr_underrun,
		p0_wr_mask => c3_p0_wr_mask);


okHI : okHost   port map (okAA => okAA, okClk => okClk, okEH => okEH, okHE => okHE, okHU => okHU, okUH => okUH, okUHU => okUHU);
wireOR : okWireOR generic map (N=>N) port map (okEH => okEH, okEHx => okEHx);
wi00 : okWireIn 	  port map (ep_addr => x"00" ,     ep_dataout => ep00wire,       okHE => okHE);
wi01 : okWireIn 	  port map (ep_addr => x"01" ,     ep_dataout => ep01wire,       okHE => okHE);
wi02 : okWireIn 	  port map (ep_addr => x"02" ,     ep_dataout => ep02wire,       okHE => okHE);
wi03 : okWireIn 	  port map (ep_addr => x"03" ,     ep_dataout => ep03wire,       okHE => okHE);
wi04 : okWireIn 	  port map (ep_addr => x"04" ,     ep_dataout => ep04wire,       okHE => okHE);
wi05 : okWireIn 	  port map (ep_addr => x"05" ,     ep_dataout => ep05wire,       okHE => okHE);
wi06 : okWireIn 	  port map (ep_addr => x"06" ,     ep_dataout => ep06wire,       okHE => okHE);
wi07 : okWireIn 	  port map (ep_addr => x"07" ,     ep_dataout => ep07wire,       okHE => okHE);
wi08 : okWireIn 	  port map (ep_addr => x"08" ,     ep_dataout => ep08wire,       okHE => okHE);
wi09 : okWireIn 	  port map (ep_addr => x"09" ,     ep_dataout => ep09wire,       okHE => okHE);
wi10 : okWireIn 	  port map (ep_addr => x"10" ,     ep_dataout => ep10wire,       okHE => okHE);
wi11 : okWireIn 	  port map (ep_addr => x"11" ,     ep_dataout => ep11wire,       okHE => okHE);
wi12 : okWireIn 	  port map (ep_addr => x"12" ,     ep_dataout => ep12wire,       okHE => okHE);
wi13 : okWireIn 	  port map (ep_addr => x"13" ,     ep_dataout => ep13wire,       okHE => okHE);
wi14 : okWireIn 	  port map (ep_addr => x"14" ,     ep_dataout => ep14wire,       okHE => okHE);
wi15 : okWireIn 	  port map (ep_addr => x"15" ,     ep_dataout => ep15wire,       okHE => okHE);
wi16 : okWireIn 	  port map (ep_addr => x"16" ,     ep_dataout => ep16wire,       okHE => okHE);
wi17 : okWireIn 	  port map (ep_addr => x"17" ,     ep_dataout => ep17wire,       okHE => okHE);
wi18 : okWireIn 	  port map (ep_addr => x"18" ,     ep_dataout => ep18wire,       okHE => okHE);
wi19 : okWireIn 	  port map (ep_addr => x"19" ,     ep_dataout => ep19wire,       okHE => okHE);
wo20 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 1*65-1 downto 0*65 ),  ep_addr=>x"20", ep_datain=>ep20wire);
--wo21 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 2*65-1 downto 1*65 ),  ep_addr=>x"21", ep_datain=>ep21wire);
--wo22 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 3*65-1 downto 2*65 ),  ep_addr=>x"22", ep_datain=>ep22wire);
wo23 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 4*65-1 downto 3*65 ),  ep_addr=>x"23", ep_datain=>ep23wire);
wo24 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 5*65-1 downto 4*65 ),  ep_addr=>x"24", ep_datain=>ep24wire);
--wo25 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 10*65-1 downto 9*65 ),  ep_addr=>x"25", ep_datain=>ep25wire);
wo26 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 6*65-1 downto 5*65 ),  ep_addr=>x"26", ep_datain=>ep26wire);
--wo27 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 11*65-1 downto 10*65 ),  ep_addr=>x"27", ep_datain=>ep27wire);
--wo28 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 12*65-1 downto 11*65 ),  ep_addr=>x"28", ep_datain=>ep28wire);
--wo29 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 13*65-1 downto 12*65 ),  ep_addr=>x"29", ep_datain=>ep29wire);
--wo30 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 14*65-1 downto 13*65 ),  ep_addr=>x"30", ep_datain=>ep30wire);
--wo31 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 15*65-1 downto 14*65 ),  ep_addr=>x"31", ep_datain=>ep31wire);
--wo32 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 16*65-1 downto 15*65 ),  ep_addr=>x"32", ep_datain=>ep32wire);
--wo33 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 17*65-1 downto 16*65 ),  ep_addr=>x"33", ep_datain=>ep33wire);
--wo34 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 18*65-1 downto 17*65 ),  ep_addr=>x"34", ep_datain=>ep34wire);
--wo35 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 19*65-1 downto 18*65 ),  ep_addr=>x"35", ep_datain=>ep35wire);
--wo36 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 20*65-1 downto 19*65 ),  ep_addr=>x"36", ep_datain=>ep36wire);
--wo37 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 21*65-1 downto 20*65 ),  ep_addr=>x"37", ep_datain=>ep37wire);
--wo38 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 22*65-1 downto 21*65 ),  ep_addr=>x"38", ep_datain=>ep38wire);
--wo39 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 23*65-1 downto 22*65 ),  ep_addr=>x"39", ep_datain=>ep39wire);
ti40 : okTriggerIn    port map (okHE=>okHE, ep_clk =>okClk,                     ep_addr=>x"40", ep_trigger=>ep40TrigIn);
ti41 : okTriggerIn    port map (okHE=>okHE, ep_clk =>c3_clk0,                     ep_addr=>x"41", ep_trigger=>ep41TrigIn);
to60 : okTriggerOut    port map (okHE=>okHE, ep_clk =>okClk, okEH => okEHx(7*65-1  downto 6*65),  ep_addr=>x"60", ep_trigger=>ep60TrigOut);
ep80 : okBTPipeIn  port map (okHE=>okHE, okEH=>okEHx( 8*65-1 downto 7*65 ),  ep_addr=>x"80", 
                          ep_write=>pi0_ep_write, ep_blockstrobe=>open, ep_dataout=>pipe_in_data, ep_ready=>pipe_in_ready);								  
epA0 : okBTPipeOut  port map (okHE=>okHE, okEH=>okEHx( 9*65-1 downto 8*65 ),  ep_addr=>x"A0", 
                          ep_read=>po0_ep_read, ep_blockstrobe=>open, ep_datain=>pipe_out_data, ep_ready=>pipe_out_ready);
								  
okPipeOut_fifo : FIFO_I128b_O32b
	port map (
		 din => ob_data,							 --connects to the RAM 
		 dout => fifo_o_data_out,				 --connects to the Pipe
		 empty => fifo_o_empty,
		 full => ob_full,							
		 rd_clk => okClk, 						 --synchronize with the Pipe fpga/host interface
		 rd_data_count => fifo_o_rd_count, 	 --enables the pipe through a threshold
		 rd_en => fifo_o_rd_en, 					 --connects to the Pipe
		 rst => dataPL_reset,
		 wr_clk => c3_clk0, 						 --synchronize with memory @312.5MHZ
		 wr_data_count => ob_count,			 --synchronize with memory
		 wr_en => ob_write_en); 				 	 --the RAM decides when to write
	 
FIFO_i : FIFO_I16b_O128b
	port map(
		rst => dataPL_reset, 
		wr_clk => c3_clk0,			 	--Internal FSM and FIFO clk
		rd_clk => c3_clk0, 				 --synchronize with the RAM @312.5MHZ
		din 	 => fsmout16b,	 			 --
		wr_en  => fifo_ib_wren,			 --enable fifo when requested but not full
		rd_en  => ib_read_en,			 --the RAM decides when to read from the FIFO
		dout   => ib_data,				 --
		full   => fifo_ib_full,			 --dont write when full!
		empty  => ib_empty,				 --Required but not used in the MCBcontroller
		valid  => ib_valid,				 --Required by MCBcontroller
		rd_data_count => ib_count, 	 --Required by MCBcontroller
		wr_data_count => fifo_ib_wr_count);
	

FIFOa_ledmask : FIFO_I32b_O256b port map(
		rst => reset, 
		wr_clk => okClk,					 	--Needs okClk to synchronize with the BTPipeIn
		rd_clk => c3_clk0, 				 		--Synchronize with the FSM
		din 	 => pipe_in_data_adj,	 			 --
		wr_en  => pi0_ep_write,			 	 --enable fifo when data is available from the pipeIn
		rd_en  => fifob_wren,				 --read from this fifo when writing to the other fifo
		dout   => dis_led_mask256b,				 --
		full   => fifoa_ledmask_full,			 	--dont write when full!
		empty  => fifoa_ledmask_empty,				--dont read when empty!
		rd_data_count => fifoa_ledmask_rd_count, 	
		wr_data_count => fifoa_ledmask_wr_count);
		
FIFOb_ledmask : FIFO_I256b_O1024b port map(
		rst => reset, 
		wr_clk => c3_clk0,					 		--Synchronize with the FSM
		rd_clk => c3_clk0, 					 			--synchronize with the FSM
		din 	 => dis_led_mask256b,	 	 	--from previous fifo
		wr_en  => fifob_wren,			 	 	--always pull data from fifo A to place in fifo B
		rd_en  => fifob_rden,			 		--transfer whenever there is data!
		dout   => fifob_dout,					--goes to fifoc
		full   => fifob_ledmask_full,			--dont write when full!
		empty  => fifob_ledmask_empty,		--dont read when empty!
		rd_data_count => fifob_ledmask_rd_count, 	
		wr_data_count => fifob_ledmask_wr_count);


--This FIFO is a looping FIFO, it guarantees all the patterns are stored and looped
FIFOc_ledmask : FIFO_I1024b_O1024b port map(
		rst => reset, 
		clk => c3_clk0,					 					--Synchronize with the FSM
		din 	 => fifoc_DIN,	 	 					--
		wr_en  => fifoc_wren,			 	 	--
		rd_en  => fifoc_rden,				 		--Transfer the data to the FSM when fsm requests new pattern
		dout   => fifoc_dout,					--
		full   => fifoc_ledmask_full,			--dont write when full!
		empty  => fifoc_ledmask_empty,		--dont read when empty!
		valid => PATTERN_VALID,
		data_count => fifoc_ledmask_rd_count);
	

slowledclkdiv : clkdivcounter_v1
	port map(
	en => '1',
	rst => divcnt_reset,
	clk => SPAD_ON_clk,	--20MHz
	t_high => ep18wire,
	t_low => ep18wire,
	clkout => LED_ON_CLK_divcnt);
	
cameraclkdiv : clkdivcounter_v1
	port map(
	en => '1',
	rst => divcnt_reset,
	clk => SPAD_ON_clk,	--20MHz
	t_high => ep16wire,
	t_low => ep16wire,
	clkout => CAMERA_CLK);

fifospia : FIFO_I1024_O128b port map(
		rst => reset,
		wr_clk => c3_clk0,
		rd_clk => c3_clk0,
		din => fifospia_DIN,
--		din => fifoc_DIN,
--		wr_en => fifospia_wren,
		wr_en => fifoc_wren,
		rd_en => fifospia_rden,
		dout => fifospia_dout,
		full => fifospia_full,
		empty => fifospia_empty,
		rd_data_count  => open,
		wr_data_count => open);
		
fifospib : FIFO_I128b_O16b port map(
		rst => reset,
		wr_clk => c3_clk0,
		rd_clk => c3_clk0,
		din => fifospia_dout,
		wr_en => fifospia_rden,
		rd_en => fifospib_rden,
		dout => spi_di,
		full => fifospib_full,
		empty => fifospib_empty,
		rd_data_count => open,
		wr_data_count => fifospib_wrcount);

spimaster : spi_master generic map (   
        N  => 16,                                             -- 32bit serial word length is default
        CPOL => '0',                                        -- SPI mode selection (mode 0 default)
        CPHA => '0',                                        -- CPOL = clock polarity, CPHA = clock phase.
        PREFETCH => 2,                                       -- prefetch lookahead cycles
        SPI_2X_CLK_DIV => 100)                              -- for a 39MHz sclk_i, value of 10 yields a 1.95MHz SCK
    port map (  
        sclk_i => c3_clk0,                    -- high-speed serial interface system clock
        pclk_i =>  c3_clk0,                    -- high-speed parallel interface system clock
        rst_i   =>  reset,             				-- reset core
        ---- serial interface ----
        spi_ssel_o => SSEL,                                    -- spi bus slave select line
        spi_sck_o => SCLK,                                      -- spi bus sck
        spi_mosi_o => MOSI,                                 -- spi bus mosi output
        spi_miso_i => MISO,                               -- spi bus spi_miso_i input
        ---- parallel interface ----
        di_req_o =>  spi_di_req,                                     -- preload lookahead data request line
        di_i =>  			spi_di,											-- parallel data in (clocked on rising spi_clk after last bit)
        wren_i =>     ep41Trigin(2),                                    -- user data write enable, starts transmission when interface is idle
        wr_ack_o =>  open, 		                 -- write acknowledge
        do_valid_o => open,                   		-- do_o data valid signal, valid during one spi_clk rising edge.
        do_o => 	spi_do,			                 			-- parallel output (clocked on rising spi_clk after last bit)
				
		--- debug ports: can be removed or left unconnected for the application circuit ---
        sck_ena_o => open,
        sck_ena_ce_o => open,
        do_transfer_o => open,
        wren_o => open,
        rx_bit_reg_o => open,
        state_dbg_o => open,
        core_clk_o => open,
        core_n_clk_o => open,
        core_ce_o => open,
        core_n_ce_o => open,
        sh_reg_dbg_o => open); 
	
oledstimfsm: OLEDSTIMFSMv1 port map (
--inputs
	en => fsm_enable,
	clk => c3_clk0,
	rst => fsm_reset,
	stim_frames => fsm_pattern_frames,
	stim_pulses => fsm_frame_periods,
	rest_pulses => fsm_rest_periods,
	LED_ON_CLK_DIVCNT => LED_ON_CLK_DIVCNT,
	pll_locked => pll_locked,
	PATTERN_VALID => '1',	
	dis_led_mask => dis_led_mask1024b_adjusted,
	data_settle_wait => "0111",
	
	--outputs to FPGA
	LOAD => LOAD_fsm,
	NEXT_PATTERN => NEXT_PATTERN,
	LED_ON_CLK_EN => fsm_LED_ON_CLK_EN,
	CAMERA_CLK_EN => fsm_CAMERA_CLK_EN,
	
	--	addressing signals to IC
	DIS_LED => DIS_LED_fsm,
	PROBE_SEL => fsm_PROBE_SEL,
	ADDR => fsm_ADDR,
	SIDE => fsm_SIDE,
	BETA => fsm_BETA);

fifoindexcounter : fifoindexcounter_v1
	generic map (N => 6)
	
	port map(
	rst => reset,
	clk => NEXT_PATTERN,
	maxindex => fifoc_ledmask_rd_count,
	index => fifocindex);
	
--FSM_SPADProbe : FSM_v10_quad
--	port map(
----	FSM control signals
--	DIS_LED => DIS_LED_fsm,
--	PIX_OFF => open,
--	en => fsm_enable,
--	clk => c3_clk0,
--	rst => fsm_reset,
--	frame_periods => fsm_frame_periods,
--	pattern_frames => fsm_pattern_frames,
--	data_wait_cycles => "0111",
--	pix_off_mask => dis_led_mask1024b_adjusted,		--for easy testing of the mask
--	dis_led_mask => dis_led_mask1024b_adjusted,		
--	LOAD => LOAD_fsm,
--	
--	spad_on_clk => spad_on_clk, 		--globally buffered spad_on_clk
--	pll_locked => pll_locked,
--	
----	control signals to IC
--	READ_EN => open,
--	SPAD_ON_CLK_EN => fsm_SPAD_ON_CLK_EN,
--	LED_ON_CLK_EN => open,
--	MEM_CLEAR => MEM_CLEAR_fsm,
--
----	data signals from the pattern fifo
--	PATTERN_VALID => '1',
----	PATTERN_VALID => PATTERN_VALID,
--	NEXT_PATTERN => NEXT_PATTERN,
--	
----	data signals from IC
--	DIN => DOUT,
--	
----	data signals to FIFO
--	dout => fsmout16b,
--	req_fifowr => fsm_req_fifowr,
--	
----	addressing signals to IC
--	PROBE_SEL => fsm_PROBE_SEL,
--	ADDR => fsm_ADDR,
--	SIDE => fsm_SIDE,
--	BETA => fsm_BETA);


--This PLL feeds in two clock signals:
			--1). the internal 100MHz sys_clk_ibufg clock signal
			--2). the external 80 MHz signal or external 20MHz signal
--It then puts out:
			--0). SPAD_ON_CLK 	
			--1). LED_ON_CLK
			--2). SPI_clk, the slow SPI programmer clock
			--3). DTC_clk, the fast DTC reference

--lasertrigbuf : IBUFG port map(
--	i => LASER_IN,
--	O => LASER_TRIG_buf);
--
--laserclkbufio2 : BUFIO2 
--	  generic map(
--	  DIVIDE => 1,
--	  USE_DOUBLER => FALSE)
--	  port map(
--     I => LASER_TRIG_buf,
--	  DIVCLK => pll_laser_trig);
 
  
pllProgIntClk : PLL_ADV generic map 
        (BANDWIDTH          => "OPTIMIZED",
         CLKIN1_PERIOD      => SYS_CLK_PERIOD_NS,  
         CLKIN2_PERIOD      => LASER_CLK_PERIOD_NS,  
			
         CLKOUT0_DIVIDE     => 40,	  --20MHz clock SPAD_ON
         CLKOUT0_PHASE      => 0.000,
			CLKOUT0_DUTY_CYCLE => 0.500,			
			
			CLKOUT1_DIVIDE     => 40,	  --20MHz clock LED_ON
         CLKOUT1_PHASE      => 180.000,
			CLKOUT1_DUTY_CYCLE => 0.500, 
			
         CLKOUT2_DIVIDE     => 80,	  --TRIGGER slow clock, 10MHz
			CLKOUT2_PHASE      => 0.000,			
         CLKOUT2_DUTY_CYCLE => 0.500,
			
			--dont do anything with these
			
			CLKOUT3_DIVIDE     => 40,	  --unused
         CLKOUT3_PHASE      => 0.000,
			CLKOUT3_DUTY_CYCLE => 0.500,			
						
			CLKOUT4_DIVIDE     => 40,	  
         CLKOUT4_PHASE      => 0.000,
			CLKOUT4_DUTY_CYCLE => 0.500, 
			
         CLKOUT5_DIVIDE     => 40,
			CLKOUT5_PHASE      => 0.000,			
         CLKOUT5_DUTY_CYCLE => 0.500,
		
			SIM_DEVICE         => "SPARTAN6",
--			COMPENSATION       => "INTERNAL",
			COMPENSATION       => "SYSTEM_SYNCHRONOUS",
         DIVCLK_DIVIDE      => 1, 	--
         CLKFBOUT_MULT      => 8, 	--100MHZ input resolves to 800MHz VCO clock, allows for 20MHz SPAD ON
         CLKFBOUT_PHASE     => 0.000,
         REF_JITTER         => 0.005000)
		port map(
           CLKFBIN          => clkfbin,			
           CLKINSEL         => '1',     --HIGH is clkin1 (internal), LOW is clkin2 (external)
			  CLKIN1           => sys_clk_ibufg,  	--internal clock, sourced by IBUFGDS
--			  CLKIN1           => '0',  	--internal clock, sourced by IBUFGDS
			  CLKIN2 			 => '0',
--           CLKIN2           => pll_laser_trig,		--80Mhz external clock, sourced by IBUFG and BUFIO2
           DADDR            => pll_drp_daddr,
           DCLK             => pll_drp_dclk,
           DEN              => pll_drp_den,
           DI               => pll_drp_di,
           DWE              => pll_drp_dwe,
           REL              => '0',						--reserved, dont change
           RST              => pll_drp_reset,	
			  CLKFBOUT         => clkfbout_bufin,
           CLKFBDCM         => open,
           CLKOUTDCM0       => open,
			  CLKOUTDCM1       => open,							
           CLKOUTDCM2       => open,
           CLKOUTDCM3       => open,
           CLKOUTDCM4       => open,
           CLKOUTDCM5       => open,
			  CLKOUT0          => SPAD_ON_clk_bufin,			
			  CLKOUT1        	 => open,	
			  CLKOUT2          => open,
           CLKOUT3          => open,
           CLKOUT4          => open,
           CLKOUT5          => open,
           DO               => pll_drp_do,
           DRDY             => pll_drp_drdy,
           LOCKED           => pll_locked
           );

--The feedback loop is compensated with to have a very well defined delay from input to output
--See figure 3-11 of the UG382
fbiobuf : BUFG port map(
     I => clkfbout_bufin,
	  O => clkfbout_clkfbio);

io2fbbuf : BUFIO2FB port map(
     I => clkfbout_clkfbio,
	  O => clkfbin);




--PLL -> BUFG -> ODDR2 -> (OBUF). OBUF is instantiated automatically when placing the pin on an output
spadonclkbuf : BUFG port map(
     I => SPAD_ON_clk_bufin,
	  O => SPAD_ON_clk);

SPAD_ON_clk_n <= not(SPAD_ON_clk);
rst_spadclk <= not(ce_spadclk);
--This kind of buffer is necessary to forward the SPAD_ON on the output
spadoutbuffer : ODDR2 generic map(
    DDR_ALIGNMENT => "NONE", -- Sets output alignment to "NONE", "C0", "C1"
    INIT => '0', -- Sets initial state of the Q output to '0' or '1'
    SRTYPE => "SYNC" -- Specifies "SYNC" or "ASYNC" set/reset
    )
 port map (
    Q  => SPAD_ON_OUT,    -- 1-bit output data
    C0 => SPAD_ON_clk,    -- 1-bit clock input
    C1 => SPAD_ON_clk_n,  -- 1-bit clock input
    CE => ce_spadclk,   -- 1-bit clock enable input
    D0 => '1',   -- 1-bit data input (associated with C0)
    D1 => '0',   -- 1-bit data input (associated with C1)
    R  => rst_spadclk,   -- 1-bit reset input
    S  => '0'    -- 1-bit set input
);


--led_on_clk_bufin <= LED_ON_CLK_DIVCNT or LED_ON_ext;
led_on_clk_bufin <= LED_ON_CLK_DIVCNT;

--PLL -> BUFG -> ODDR2 -> (OBUF). OBUF is instantiated automatically when placing the pin on an output
ledonclkbuf : BUFG port map(
     I => led_on_clk_bufin,
	  O => led_on_clk); 

led_on_clk_n <= not(led_on_clk);
rst_ledclk <= not(ce_ledclk);

--This kind of buffer is necessary to forward the led_ON on the output
ledoutbuffer : ODDR2 generic map(
    DDR_ALIGNMENT => "NONE", -- Sets output alignment to "NONE", "C0", "C1"
    INIT => '0', -- Sets initial state of the Q output to '0' or '1'
    SRTYPE => "SYNC" -- Specifies "SYNC" or "ASYNC" set/reset
    )
 port map (
    Q  => led_on_out,    -- 1-bit output data
    C0 => led_on_clk,    -- 1-bit clock input
    C1 => led_on_clk_n,  -- 1-bit clock input
    CE => ce_ledclk,   -- 1-bit clock enable input
    D0 => '1',   -- 1-bit data input (associated with C0)
    D1 => '0',   -- 1-bit data input (associated with C1)
    R  => rst_ledclk,   -- 1-bit reset input
    S  => '0'    -- 1-bit set input
);


CAMERA_CLK_n <= not(CAMERA_CLK);
rst_cameraclk <= not(ce_cameraclk);

cameraclkbuffer : ODDR2 generic map(
    DDR_ALIGNMENT => "NONE", -- Sets output alignment to "NONE", "C0", "C1"
    INIT => '0', -- Sets initial state of the Q output to '0' or '1'
    SRTYPE => "SYNC" -- Specifies "SYNC" or "ASYNC" set/reset
    )
 port map (
    Q  => CAMERA_FRAME,    -- 1-bit output data
    C0 => CAMERA_CLK,    -- 1-bit clock input
    C1 => CAMERA_CLK_n,  -- 1-bit clock input
    CE => ce_cameraclk,   -- 1-bit clock enable input
    D0 => '1',   -- 1-bit data input (associated with C0)
    D1 => '0',   -- 1-bit data input (associated with C1)
    R  => rst_cameraclk,   -- 1-bit reset input
    S  => '0'    -- 1-bit set input
);


--This kind of buffer is necessary to forward the REF_LED on the output
refledbuffer : ODDR2 generic map(
    DDR_ALIGNMENT => "NONE", -- Sets output alignment to "NONE", "C0", "C1"
    INIT => '0', -- Sets initial state of the Q output to '0' or '1'
    SRTYPE => "SYNC" -- Specifies "SYNC" or "ASYNC" set/reset
    )
 port map (
    Q  => REF_LED,    -- 1-bit output data
--	 Q  => open,    -- 1-bit output data
    C0 => led_on_clk,    -- 1-bit clock input
    C1 => led_on_clk_n,  -- 1-bit clock input
    CE => ce_ledclk,   -- 1-bit clock enable input
    D0 => '1',   -- 1-bit data input (associated with C0)
    D1 => '0',   -- 1-bit data input (associated with C1)
    R  => rst_ledclk,   -- 1-bit reset input
    S  => '0'    -- 1-bit set input
);


pll_Prog_AT : at_pll_prog generic map(
	   CLKFBOUT_MULT 		 => 8, --FVCO after drp reprogramming = 100*8 = 800MHz
      CLKFBOUT_PHASE 	 => 0.000,
      DIVCLK_DIVIDE  	 => 1)
port map(
      --the parameters are now inputs!
   
      CLKOUT0_DIVIDE         => CLKOUT0_DIVIDE,	   
      CLKOUT0_PHASE          => CLKOUT0_PHASE,		
      CLKOUT0_DUTY           => CLKOUT0_DUTY, 
		
		CLKOUT1_DIVIDE         => CLKOUT1_DIVIDE,	   
      CLKOUT1_PHASE          => CLKOUT1_PHASE,	
      CLKOUT1_DUTY           => CLKOUT1_DUTY, 
		
      CLKOUT2_DIVIDE         => CLKOUT2_DIVIDE,
      CLKOUT2_PHASE          => CLKOUT2_PHASE,	
      CLKOUT2_DUTY           => CLKOUT2_DUTY, 
		
		--dont do anything with these		
		
		CLKOUT3_DIVIDE         => CLKOUT3_DIVIDE,	--
      CLKOUT3_PHASE          => CLKOUT3_PHASE,		--
      CLKOUT3_DUTY           => CLKOUT3_DUTY, --
		
		CLKOUT4_DIVIDE         => CLKOUT4_DIVIDE,	--
      CLKOUT4_PHASE          => CLKOUT4_PHASE,		--
      CLKOUT4_DUTY           => CLKOUT4_DUTY, --
		
		CLKOUT5_DIVIDE         => CLKOUT5_DIVIDE,	--
      CLKOUT5_PHASE          => CLKOUT5_PHASE,		--
      CLKOUT5_DUTY           => CLKOUT5_DUTY,  --
     
--    These signals are controlled by user logic interface and are covered
--     in more detail within the XAPP.
     	SEN=> drp_sen,
      SCLK=> okClk,		--use okClk (108MHz) as this is synchronous to the triggerin
      RST=> drp_reset,
      SRDY=> drp_srdy,
      
--    These signals are to be connected to the PLL_ADV by port name.
--    Their use matches the PLL port description in the Device User Guide.
      DO => pll_drp_do,
      DRDY => pll_drp_drdy,
      LOCKED => pll_locked,
      DWE => pll_drp_dwe,
      DEN => pll_drp_den,
      DADDR => pll_drp_daddr,
      DI => pll_drp_di,
      DCLK => pll_drp_dclk,
      RST_PLL=> pll_drp_reset);
	
end Behavioral;
