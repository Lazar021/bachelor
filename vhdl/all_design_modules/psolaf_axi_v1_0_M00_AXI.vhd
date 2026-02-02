library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utils_pkg.all;
library ieee_proposed;
use ieee_proposed.fixed_pkg.all;

entity psolaf_axi_v1_0_M00_AXI is
	generic (
		-- Users to add parameters here
		--Oduzimaju se gornja dva bita od ADDR_W da bi znali u koju memoriju ide
		ADDR_W                      : integer := 16; --12 je dosta za 1500  tj 4095 podataka

		--IN memorija 
		SIZE_IN_TOP                 : integer := 1500;
		W_HIGH_IN_TOP               : integer := 1;
		W_LOW_IN_TOP                : integer := -25;
		--OPSEG memorija
		SIZE_OPSEG_TOP              : integer := 5000;
		W_HIGH_OPSEG_ADDR_TOP       : integer := 14;
		W_HIGH_OPSEG_TOP            : integer := 1;
		W_LOW_OPSEG_TOP             : integer := -25;
		--M memorija
		--kod ove memorije pogledaj kako kada su vrednosti preko 20k kako se cita in memorija
		SIZE_M_TOP                 : integer := 1000;
		SIZE_ADDR_W_M              : integer := 14;
		--W_HIGH_M_TOP               : integer := 20;
		W_HIGH_M_TOP               : integer := 32;
		W_LOW_M_TOP                : integer := 0;
		--HAN memorija
		W_HAN_TOP		            : integer := 32;
		--OUT memorija
		SIZE_OUT_TOP               : integer := 1000;
		SIZE_ADDR_W_OUT            : integer := 14;
		W_HIGH_OUT_TOP             : integer := 1;
		W_LOW_OUT_TOP              : integer := -31;
		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- Base address of targeted slave
		C_M_TARGET_SLAVE_BASE_ADDR	: std_logic_vector	:= x"40000";
		-- Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
		C_M_AXI_BURST_LEN	: integer	:= 16;
		-- Thread ID Width
		C_M_AXI_ID_WIDTH	: integer	:= 1;
		-- Width of Address Bus
		--C_M_AXI_ADDR_WIDTH	: integer	:= 20;
		C_M_AXI_ADDR_WIDTH	: integer	:= 32;
		-- Width of Data Bus
		C_M_AXI_DATA_WIDTH	: integer	:= 32;
		-- Width of User Write Address Bus
		C_M_AXI_AWUSER_WIDTH	: integer	:= 0;
		-- Width of User Read Address Bus
		C_M_AXI_ARUSER_WIDTH	: integer	:= 0;
		-- Width of User Write Data Bus
		C_M_AXI_WUSER_WIDTH	: integer	:= 0;
		-- Width of User Read Data Bus
		C_M_AXI_RUSER_WIDTH	: integer	:= 0;
		-- Width of User Response Bus
		C_M_AXI_BUSER_WIDTH	: integer	:= 0
	);
	port (
		-- Users to add ports here

        
		--portovi za psolaf modul

		start_psolaf_o				: out std_logic;
		rnext_out_o					: out std_logic;
		wnext_out_o					: out std_logic;

		--Interfejs m memorije--------------------------------------------------------------------------------------
        --Port 1 interface
        p1_addr_m_top_i             : in std_logic_vector(ADDR_W - 1 downto 0);
        p1_wdata_m_top_i            : in std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
        p1_rdata_m_top_o            : out std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);

        --Port 2 interface
        p2_addr_m_top_i             : out std_logic_vector(ADDR_W - 1 downto 0);
        p2_wdata_m_top_i            : in std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
        --p2_rdata_m_top_o            : out std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
		p2_write_m_top_i            : in std_logic;
        num_of_elements_m_top_o     : out std_logic_vector(log2c(SIZE_M_TOP) - 1 downto 0);

		--Interfejs hanning memorije--------------------------------------------------------------------------------------
		rdata_cos_top_o              		: out std_logic_vector(W_HAN_TOP - 1 downto 0);
		

		--Interfejs opseg memorije--------------------------------------------------------------------------------------
		--Port 1 interface
		--p1_addr_opseg_top_i            : out std_logic_vector(ADDR_W - 1 - 2 downto 0);
		p1_wdata_opseg_top_i           : in sfixed(W_HIGH_OPSEG_TOP - 1 downto W_LOW_OPSEG_TOP);
		p1_rdata_opseg_top_o           : out sfixed(W_HIGH_OPSEG_TOP - 1 downto W_LOW_OPSEG_TOP);

		num_of_elements_opseg_top_o    : out std_logic_vector(log2c(SIZE_OPSEG_TOP) - 1 downto 0);

				
        --Interfejs out memorije--------------------------------------------------------------------------------------
        --Port 1 interface
        --p1_addr_out_top_o           : out std_logic_vector(ADDR_W - 1 - 2 downto 0);
        --p1_wdata_out_top_o          : out sfixed(W_HIGH_OUT_TOP - 1 downto W_LOW_OUT_TOP);
        p1_rdata_out_top_o          : out sfixed(W_HIGH_OUT_TOP - 1 downto W_LOW_OUT_TOP);
        --p1_write_out_top_o          : out std_logic;
        --Port 2 interface      
        --p2_addr_out_top_o           : out std_logic_vector(ADDR_W - 1 - 2 downto 0);
        p2_wdata_out_top_i          : in sfixed(W_HIGH_OUT_TOP - 1 downto W_LOW_OUT_TOP);
        --p2_rdata_out_top_i          : in sfixed(W_HIGH_OUT_TOP - 1 downto W_LOW_OUT_TOP);
        --p2_write_out_top_o          : out std_logic;
        num_of_elements_out_top_o   : out std_logic_vector(log2c(SIZE_OUT_TOP) - 1 downto 0);

		m_size_i					: in std_logic_vector(log2c(SIZE_M_TOP) - 1 downto 0);
		erase_flag_i				: in std_logic;
		num_of_m_i					: in unsigned(log2c(SIZE_M_TOP) - 1 downto 0);
		reads_last_done_o			: out std_logic;
		ready_han_i					: in std_logic;
		pit_i						: in std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
		place_i						: in unsigned(log2c(SIZE_M_TOP) - 1 downto 0);
		place_enable_i				: in std_logic;
		opseg_addr_valid_i			: in std_logic;
		opseg_begin_i				: in unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
		opseg_end_i					: in unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
		endGr_i						: in unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
		ready_interp1_i				: in std_logic;
		iniGr_i						: in unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
		matk_valid_o				: out std_logic;
		ready_psolaf_i              : in std_logic;	
		reads_done_psolaf_o 		: out std_logic;
		end_flag_o					: out std_logic;
		-- for coverage
		mst_state_o					: out std_logic_vector(6 downto 0);

		-- User ports ends
		-- Do not modify the ports beyond this line

		-- Initiate AXI transactions
		INIT_AXI_TXN	: in std_logic;
		-- Asserts when transaction is complete
		TXN_DONE	: out std_logic;
		-- Asserts when ERROR is detected
		ERROR	: out std_logic;
		-- Global Clock Signal.
		M_AXI_ACLK	: in std_logic;
		-- Global Reset Singal. This Signal is Active Low
		M_AXI_ARESETN	: in std_logic;
		-- Master Interface Write Address ID
		M_AXI_AWID	: out std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
		-- Master Interface Write Address
		M_AXI_AWADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		-- Burst length. The burst length gives the exact number of transfers in a burst
		--M_AXI_AWLEN	: out std_logic_vector(7 downto 0);
		M_AXI_AWLEN	: out std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
		-- Burst size. This signal indicates the size of each transfer in the burst
		M_AXI_AWSIZE	: out std_logic_vector(2 downto 0);
		-- Burst type. The burst type and the size information, 
    -- determine how the address for each transfer within the burst is calculated.
		M_AXI_AWBURST	: out std_logic_vector(1 downto 0);
		-- Lock type. Provides additional information about the
    -- atomic characteristics of the transfer.
		M_AXI_AWLOCK	: out std_logic;
		-- Memory type. This signal indicates how transactions
    -- are required to progress through a system.
		M_AXI_AWCACHE	: out std_logic_vector(3 downto 0);
		-- Protection type. This signal indicates the privilege
    -- and security level of the transaction, and whether
    -- the transaction is a data access or an instruction access.
		M_AXI_AWPROT	: out std_logic_vector(2 downto 0);
		-- Quality of Service, QoS identifier sent for each write transaction.
		M_AXI_AWQOS	: out std_logic_vector(3 downto 0);
		-- Optional User-defined signal in the write address channel.
		M_AXI_AWUSER	: out std_logic_vector(C_M_AXI_AWUSER_WIDTH-1 downto 0);
		-- Write address valid. This signal indicates that
    -- the channel is signaling valid write address and control information.
		M_AXI_AWVALID	: out std_logic;
		-- Write address ready. This signal indicates that
    -- the slave is ready to accept an address and associated control signals
		M_AXI_AWREADY	: in std_logic;
		-- Master Interface Write Data.
		M_AXI_WDATA	: out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		-- Write strobes. This signal indicates which byte
    -- lanes hold valid data. There is one write strobe
    -- bit for each eight bits of the write data bus.
		M_AXI_WSTRB	: out std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
		-- Write last. This signal indicates the last transfer in a write burst.
		M_AXI_WLAST	: out std_logic;
		-- Optional User-defined signal in the write data channel.
		M_AXI_WUSER	: out std_logic_vector(C_M_AXI_WUSER_WIDTH-1 downto 0);
		-- Write valid. This signal indicates that valid write
    -- data and strobes are available
		M_AXI_WVALID	: out std_logic;
		-- Write ready. This signal indicates that the slave
    -- can accept the write data.
		M_AXI_WREADY	: in std_logic;
		-- Master Interface Write Response.
		M_AXI_BID	: in std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
		-- Write response. This signal indicates the status of the write transaction.
		M_AXI_BRESP	: in std_logic_vector(1 downto 0);
		-- Optional User-defined signal in the write response channel
		M_AXI_BUSER	: in std_logic_vector(C_M_AXI_BUSER_WIDTH-1 downto 0);
		-- Write response valid. This signal indicates that the
    -- channel is signaling a valid write response.
		M_AXI_BVALID	: in std_logic;
		-- Response ready. This signal indicates that the master
    -- can accept a write response.
		M_AXI_BREADY	: out std_logic;
		-- Master Interface Read Address.
		M_AXI_ARID	: out std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
		-- Read address. This signal indicates the initial
    -- address of a read burst transaction.
		M_AXI_ARADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		-- Burst length. The burst length gives the exact number of transfers in a burst
		--M_AXI_ARLEN	: out std_logic_vector(7 downto 0);
		M_AXI_ARLEN	: out std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
		-- Burst size. This signal indicates the size of each transfer in the burst
		M_AXI_ARSIZE	: out std_logic_vector(2 downto 0);
		-- Burst type. The burst type and the size information, 
    -- determine how the address for each transfer within the burst is calculated.
		M_AXI_ARBURST	: out std_logic_vector(1 downto 0);
		-- Lock type. Provides additional information about the
    -- atomic characteristics of the transfer.
		M_AXI_ARLOCK	: out std_logic;
		-- Memory type. This signal indicates how transactions
    -- are required to progress through a system.
		M_AXI_ARCACHE	: out std_logic_vector(3 downto 0);
		-- Protection type. This signal indicates the privilege
    -- and security level of the transaction, and whether
    -- the transaction is a data access or an instruction access.
		M_AXI_ARPROT	: out std_logic_vector(2 downto 0);
		-- Quality of Service, QoS identifier sent for each read transaction
		M_AXI_ARQOS	: out std_logic_vector(3 downto 0);
		-- Optional User-defined signal in the read address channel.
		M_AXI_ARUSER	: out std_logic_vector(C_M_AXI_ARUSER_WIDTH-1 downto 0);
		-- Write address valid. This signal indicates that
    -- the channel is signaling valid read address and control information
		M_AXI_ARVALID	: out std_logic;
		-- Read address ready. This signal indicates that
    -- the slave is ready to accept an address and associated control signals
		M_AXI_ARREADY	: in std_logic;
		-- Read ID tag. This signal is the identification tag
    -- for the read data group of signals generated by the slave.
		M_AXI_RID	: in std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
		-- Master Read Data
		M_AXI_RDATA	: in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		-- Read response. This signal indicates the status of the read transfer
		M_AXI_RRESP	: in std_logic_vector(1 downto 0);
		-- Read last. This signal indicates the last transfer in a read burst
		M_AXI_RLAST	: in std_logic;
		-- Optional User-defined signal in the read address channel.
		M_AXI_RUSER	: in std_logic_vector(C_M_AXI_RUSER_WIDTH-1 downto 0);
		-- Read valid. This signal indicates that the channel
    -- is signaling the required read data.
		M_AXI_RVALID	: in std_logic;
		-- Read ready. This signal indicates that the master can
    -- accept the read data and response information.
		M_AXI_RREADY	: out std_logic
	);
end psolaf_axi_v1_0_M00_AXI;

architecture implementation of psolaf_axi_v1_0_M00_AXI is


	-- function called clogb2 that returns an integer which has the
	--value of the ceiling of the log base 2

	function clogb2 (bit_depth : integer) return integer is            
	 	variable depth  : integer := bit_depth;                               
	 	variable count  : integer := 1;                                       
	 begin                                                                   
	 	 for clogb2 in 1 to bit_depth loop  -- Works for up to 32 bit integers
	      if (bit_depth <= 2) then                                           
	        count := 1;                                                      
	      else                                                               
	        if(depth <= 1) then                                              
	 	       count := count;                                                
	 	     else                                                             
	 	       depth := depth / 2;                                            
	          count := count + 1;                                            
	 	     end if;                                                          
	 	   end if;                                                            
	   end loop;                                                             
	   return(count);        	                                              
	 end;                                                                    

	-- C_TRANSACTIONS_NUM is the width of the index counter for
	-- number of beats in a burst write or burst read transaction.
	 constant  C_TRANSACTIONS_NUM : integer := clogb2(C_M_AXI_BURST_LEN-1);
	-- Burst length for transactions, in C_M_AXI_DATA_WIDTHs.
	-- Non-2^n lengths will eventually cause bursts across 4K address boundaries.
	 constant  C_MASTER_LENGTH  : integer := 12;
	-- total number of burst transfers is master length divided by burst length and burst size
	 constant  C_NO_BURSTS_REQ  : integer := (C_MASTER_LENGTH-clogb2((C_M_AXI_BURST_LEN*C_M_AXI_DATA_WIDTH/8)-1));
	-- Example State machine to initialize counter, initialize write transactions, 
	 -- initialize read transactions and comparison of read data with the 
	 -- written data words.
	 type state is ( IDLE,
	 				INIT_WRITE,  
					INIT_READ_M, 
					READ_M,
					ERASE_FIRST_M,
					M_LAST,
					WRITE_P,
					M_WRITE_LAST,
					--INIT_READ_M_MATK,
					READ_M_MATK,
					PLACE,
					-- INIT_READ_HAN_ADDR,
					INIT_READ_HAN,
					READ_HAN,
					INIT_READ_OPSEG,    
					READ_OPSEG,
					READ_OPSEG_2,
	 				INIT_COMPARE,
					WRITE_OUT,
					WRITE_OUT_2,
					M_WRITE_LAST_ADDR_SETUP);
	 signal mst_exec_state  : state ; 

	-- AXI4FULL signals
	--AXI4 internal temp signals
	signal axi_awaddr	: std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_awvalid	: std_logic;
	signal axi_wdata	: std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
	signal axi_wlast	: std_logic;
	signal axi_wvalid	: std_logic;
	signal axi_bready	: std_logic;
	signal axi_araddr	: std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_arvalid	: std_logic;
	signal axi_rready	: std_logic;

	signal axi_arqos	: std_logic_vector(3 downto 0);
	--write beat count in a burst
	signal write_index	: std_logic_vector(C_TRANSACTIONS_NUM downto 0);
	--read beat count in a burst
	signal read_index	: std_logic_vector(C_TRANSACTIONS_NUM downto 0);
	--size of C_M_AXI_BURST_LEN length burst in bytes
	signal burst_size_bytes	: std_logic_vector(C_TRANSACTIONS_NUM+2 downto 0);
	--The burst counters are used to track the number of burst transfers of C_M_AXI_BURST_LEN burst length needed to transfer 2^C_MASTER_LENGTH bytes of data.
	signal write_burst_counter	: std_logic_vector(C_NO_BURSTS_REQ downto 0);
	signal read_burst_counter	: std_logic_vector(C_NO_BURSTS_REQ downto 0);
	signal start_single_burst_write	: std_logic;
	signal start_single_burst_read	: std_logic;
	signal writes_done	: std_logic;
	signal reads_done	: std_logic;
	signal error_reg	: std_logic;
	signal compare_done	: std_logic;
	signal read_mismatch	: std_logic;
	signal burst_write_active	: std_logic;
	signal burst_read_active	: std_logic;
	signal expected_rdata	: std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
	--Interface response error flags
	signal write_resp_error	: std_logic;
	signal read_resp_error	: std_logic;
	signal wnext	: std_logic;
	signal rnext	: std_logic;
	signal init_txn_ff	: std_logic;
	signal init_txn_ff2	: std_logic;
	signal init_txn_edge	: std_logic;
	signal init_txn_pulse	: std_logic;


	constant ADDR_LSB		: integer := (C_M_AXI_DATA_WIDTH/32) + 1;

	signal	addr_field_write_s			: std_logic_vector(1 downto 0);
	signal	addr_field_read_s			: std_logic_vector(1 downto 0);
	signal 	axi_arlen					: std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
	signal  data_available				: unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
	signal  end_flag					: std_logic;
	signal  flag_opseg_read				: std_logic;
	signal	flag_m_setup				: std_logic;
	signal	end_flag_write				: std_logic;
	signal  data_available_write		: unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
	signal 	axi_awlen					: std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
	signal	flag_m_write				: std_logic;
	signal	reads_done_opseg			: std_logic;
	signal 	axi_araddr_incr				: std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
	signal  start_has_been				: std_logic;
	signal	flag_m_first				: std_logic;
	signal 	axi_awaddr_incr				: std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);

	-- type state_type is(opseg_read,m_setup,m_first,m_last,m_stall,skip_m);
	-- signal  state_read            		: state_type;
	signal	reads_first_done			: std_logic;
	signal	reads_last_done				: std_logic;
	signal	write_last_done				: std_logic;
	signal  write_out_done				: std_logic;
	signal	stall_cnt					: unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
	signal  reads_opseg_done			: std_logic;
	signal	reads_m_matk_done			: std_logic;
	signal  reads_write_out_done		: std_logic;
	signal 	reads_hanning_done			: std_logic;

	signal	read_stall					: unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
	signal  write_stall					: unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);

	signal 	last_read					: std_logic;
	
	signal axi_araddr_next,axi_araddr_reg				: std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
	signal stall_cnt_next,stall_cnt_reg					: unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
	signal read_stall_next,read_stall_reg					: unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
	signal data_available_next,data_available_reg  		: unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
	signal  data_available_write_next,data_available_write_reg		: unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);


	--debug
	signal rdata_cos_debug						: sfixed(W_HIGH_OUT_TOP - 1 downto W_LOW_OUT_TOP);
	 
begin
	-- I/O Connections assignments

	--I/O Connections. Write Address (AW)
	M_AXI_AWID	<= (others => '0');
	--The AXI address is a concatenation of the target base address + active offset range
	--M_AXI_AWADDR	<= std_logic_vector( unsigned(C_M_TARGET_SLAVE_BASE_ADDR) + unsigned(axi_awaddr) );
	M_AXI_AWADDR	<= axi_awaddr;
	--Burst LENgth is number of transaction beats, minus 1
	--M_AXI_AWLEN	<= std_logic_vector( to_unsigned(C_M_AXI_BURST_LEN - 1, 8) );
	M_AXI_AWLEN	<= axi_awlen;
	--Size should be C_M_AXI_DATA_WIDTH, in 2^SIZE bytes, otherwise narrow bursts are used
	M_AXI_AWSIZE	<= std_logic_vector( to_unsigned(clogb2((C_M_AXI_DATA_WIDTH/8)-1), 3) );
	--INCR burst type is usually used, except for keyhole bursts
	M_AXI_AWBURST	<= "01";
	M_AXI_AWLOCK	<= '0';
	--Update value to 4'b0011 if coherent accesses to be used via the Zynq ACP port. Not Allocated, Modifiable, not Bufferable. Not Bufferable since this example is meant to test memory, not intermediate cache. 
	M_AXI_AWCACHE	<= "0010";
	M_AXI_AWPROT	<= "000";
	M_AXI_AWQOS	<= x"0";
	M_AXI_AWUSER	<= (others => '1');
	M_AXI_AWVALID	<= axi_awvalid;
	--Write Data(W)
	M_AXI_WDATA	<= axi_wdata;
	--All bursts are complete and aligned in this example
	M_AXI_WSTRB	<= (others => '1');
	M_AXI_WLAST	<= axi_wlast;
	M_AXI_WUSER	<= (others => '0');
	M_AXI_WVALID	<= axi_wvalid;
	--Write Response (B)
	M_AXI_BREADY	<= axi_bready;
	--Read Address (AR)
	M_AXI_ARID	<= (others => '0');
	--M_AXI_ARADDR	<= std_logic_vector( unsigned( C_M_TARGET_SLAVE_BASE_ADDR ) + unsigned( axi_araddr ) );
	-- M_AXI_ARADDR	<= axi_araddr;
	M_AXI_ARADDR	<= axi_araddr_next;
	--Burst LENgth is number of transaction beats, minus 1
	--M_AXI_ARLEN	<= std_logic_vector( to_unsigned(C_M_AXI_BURST_LEN - 1, 8) );
	M_AXI_ARLEN <= axi_arlen;
	--Size should be C_M_AXI_DATA_WIDTH, in 2^n bytes, otherwise narrow bursts are used
	M_AXI_ARSIZE	<= std_logic_vector( to_unsigned( clogb2((C_M_AXI_DATA_WIDTH/8)-1),3 ));
	--INCR burst type is usually used, except for keyhole bursts
	M_AXI_ARBURST	<= "01";
	M_AXI_ARLOCK	<= '0';
	--Update value to 4'b0011 if coherent accesses to be used via the Zynq ACP port. Not Allocated, Modifiable, not Bufferable. Not Bufferable since this example is meant to test memory, not intermediate cache. 
	M_AXI_ARCACHE	<= "0010";
	M_AXI_ARPROT	<= "000";
	--18. mart 2024
	M_AXI_ARQOS	<= x"0";
	--M_AXI_ARQOS	<= axi_arqos;
	M_AXI_ARUSER	<= (others => '1');
	M_AXI_ARVALID	<= axi_arvalid;
	--Read and Read Response (R)
	M_AXI_RREADY	<= axi_rready;
	--Example design I/O
	TXN_DONE	<= compare_done;
	--Burst size in bytes
	burst_size_bytes	<= std_logic_vector( to_unsigned((C_M_AXI_BURST_LEN * (C_M_AXI_DATA_WIDTH/8)),C_TRANSACTIONS_NUM+3) );
	init_txn_pulse	<= ( not init_txn_ff2)  and  init_txn_ff;

	--User defined 
	reads_last_done_o <= M_AXI_RLAST;
	end_flag_o <= end_flag;




	--Generate a pulse to initiate AXI transaction.
	process(M_AXI_ACLK)                                                          
	begin                                                                             
	  if (rising_edge (M_AXI_ACLK)) then                                              
	      -- Initiates AXI transaction delay        
	    if (M_AXI_ARESETN = '0' ) then                                                
	      init_txn_ff <= '0';                                                   
	        init_txn_ff2 <= '0';                                                          
	    else                                                                                       
	      init_txn_ff <= INIT_AXI_TXN;
	        init_txn_ff2 <= init_txn_ff;                                                                     
	    end if;                                                                       
	  end if;                                                                         
	end process; 


	----------------------
	--Write Address Channel
	----------------------

	-- The purpose of the write address channel is to request the address and 
	-- command information for the entire transaction.  It is a single beat
	-- of information.

	-- The AXI4 Write address channel in this example will continue to initiate
	-- write commands as fast as it is allowed by the slave/interconnect.
	-- The address will be incremented on each accepted address transaction,
	-- by burst_size_byte to point to the next address. 

	  process(M_AXI_ACLK)                                            
	  begin                                                                
	    if (rising_edge (M_AXI_ACLK)) then                                 
	      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then                                   
	        axi_awvalid <= '0';                                            
	      else                                                             
	        -- If previously not valid , start next transaction            
			if (axi_awvalid = '0'and write_stall = 2) then 
	          axi_awvalid <= '1';                                          
	          -- Once asserted, VALIDs cannot be deasserted, so axi_awvalid
	          -- must wait until transaction is accepted                   
	        elsif (M_AXI_AWREADY = '1' and axi_awvalid = '1') then         
	          axi_awvalid <= '0';                                          
	        else                                                           
	          axi_awvalid <= axi_awvalid;                                  
	        end if;                                                        
	      end if;                                                          
	    end if;                                                            
	  end process;                                                                                                               


	----------------------
	--Write Data Channel
	----------------------

	--The write data will continually try to push write data across the interface.

	--The amount of data accepted will depend on the AXI slave and the AXI
	--Interconnect settings, such as if there are FIFOs enabled in interconnect.

	--Note that there is no explicit timing relationship to the write address channel.
	--The write channel has its own throttling flag, separate from the AW channel.

	--Synchronization between the channels must be determined by the user.

	--The simpliest but lowest performance would be to only issue one address write
	--and write data burst at a time.

	--In this example they are kept in sync by using the same address increment
	--and burst sizes. Then the AW and W channels have their transactions measured
	--with threshold counters as part of the user logic, to make sure neither 
	--channel gets too far ahead of each other.

	--Forward movement occurs when the write channel is valid and ready

	  wnext <= M_AXI_WREADY and axi_wvalid;
	  wnext_out_o <= M_AXI_WREADY and axi_wvalid;                                       
	                                                                                    
	-- WVALID logic, similar to the axi_awvalid always block above                      
	  process(M_AXI_ACLK)                                                               
	  begin                                                                             
	    if (rising_edge (M_AXI_ACLK)) then                                              
	      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then                                                
	        axi_wvalid <= '0';                                                          
	      else                                                                          
			if (axi_wvalid = '0' and  M_AXI_AWREADY = '1' and axi_awvalid = '1') then               
	          -- If previously not valid, start next transaction                        
	          axi_wvalid <= '1';                                                        
	          --     /* If WREADY and too many writes, throttle WVALID                  
	          --      Once asserted, VALIDs cannot be deasserted, so WVALID             
	          --      must wait until burst is complete with WLAST */                   
	        elsif (wnext = '1' and axi_wlast = '1') then                                
	          axi_wvalid <= '0';                                                        
	        else                                                                        
	          axi_wvalid <= axi_wvalid;                                                 
	        end if;                                                                     
	      end if;                                                                       
	    end if;                                                                         
	  end process;                                                                      
	                                                                                    
	--WLAST generation on the MSB of a counter underflow                                
	-- WVALID logic, similar to the axi_awvalid always block above                      
	  process(M_AXI_ACLK)                                                               
	  begin                                                                             
	    if (rising_edge (M_AXI_ACLK)) then                                              
	      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then                                                
	        axi_wlast <= '0';                                                           
	        -- axi_wlast is asserted when the write index                               
	        -- count reaches the penultimate count to synchronize                       
	        -- with the last write data when write_index is b1111                       
	        -- elsif (&(write_index[C_TRANSACTIONS_NUM-1:1])&& ~write_index[0] && wnext)
	      else                                                                          
			--if ((((write_index = std_logic_vector(to_unsigned(C_M_AXI_BURST_LEN-2,C_TRANSACTIONS_NUM+1))) and C_M_AXI_BURST_LEN >= 2) and wnext = '1' and axi_wlast = '0') or (C_M_AXI_BURST_LEN = 1) or (end_flag_write = '1' and (write_index = std_logic_vector(resize(data_available_write - 1,write_index'length))) and wnext = '1' and axi_wlast = '0')) then
			
			--IZMENJENJO 3. maja 2024
			-- if ((((write_index = std_logic_vector(to_unsigned(C_M_AXI_BURST_LEN-2,C_TRANSACTIONS_NUM+1))) and C_M_AXI_BURST_LEN >= 2) and wnext = '1' and axi_wlast = '0') or (C_M_AXI_BURST_LEN = 1) or (end_flag_write = '1' and (write_index = std_logic_vector(resize(data_available_write - 2,write_index'length))) and wnext = '1' and axi_wlast = '0')) then
			--IZMENJENJO 4. juna 2024
			-- if ((((write_index = std_logic_vector(to_unsigned(C_M_AXI_BURST_LEN-2,C_TRANSACTIONS_NUM+1))) and C_M_AXI_BURST_LEN >= 2) and wnext = '1' and axi_wlast = '0') or (C_M_AXI_BURST_LEN = 1) or (end_flag_write = '1' and data_available_write = 0 and wnext = '1' and axi_wlast = '0') or (end_flag_write = '1' and (write_index = std_logic_vector(resize(data_available_write_reg - 1,write_index'length))) and wnext = '1' and axi_wlast = '0')) then
			--IZMENJENJO 4. juna 2024 posle podne
			if ((((write_index = std_logic_vector(to_unsigned(C_M_AXI_BURST_LEN-2,C_TRANSACTIONS_NUM+1))) and C_M_AXI_BURST_LEN >= 2) and wnext = '1' and axi_wlast = '0') or (C_M_AXI_BURST_LEN = 1) or (end_flag_write = '1' and data_available_write_reg = 0 and axi_wvalid = '1' and axi_wlast = '0') or (end_flag_write = '1' and (write_index = std_logic_vector(resize(data_available_write_reg - 1,write_index'length))) and wnext = '1' and axi_wlast = '0')) then
			--IZMENJENJO 4. juna 2024 uvece
			-- if ((((write_index = std_logic_vector(to_unsigned(C_M_AXI_BURST_LEN-2,C_TRANSACTIONS_NUM+1))) and C_M_AXI_BURST_LEN >= 2) and wnext = '1' and axi_wlast = '0') or (C_M_AXI_BURST_LEN = 1) or (end_flag_write = '1' and data_available_write = 0 and axi_wlast = '0') or (end_flag_write = '1' and (write_index = std_logic_vector(resize(data_available_write - 1,write_index'length))) and wnext = '1' and axi_wlast = '0')) then

				axi_wlast <= '1';                                                         
	          -- Deassrt axi_wlast when the last write data has been                    
	          -- accepted by the slave with a valid response                            
	        elsif (wnext = '1') then                                                    
	          axi_wlast <= '0';                                                         
	        elsif (axi_wlast = '1' and C_M_AXI_BURST_LEN = 1) then                      
	          axi_wlast <= '0';                                                         
	        end if;                                                                     
	      end if;                                                                       
	    end if;                                                                         
	  end process;                                                                      
	                                                                                    
	-- Burst length counter. Uses extra counter register bit to indicate terminal       
	-- count to reduce decode logic */                                                  
	  process(M_AXI_ACLK)                                                               
	  begin                                                                             
	    if (rising_edge (M_AXI_ACLK)) then                                              
	      if (M_AXI_ARESETN = '0' or start_single_burst_write = '1' or init_txn_pulse = '1') then               
	        write_index <= (others => '0');                                             
	      else                                                                           
			if (wnext = '1' and (write_index < std_logic_vector(to_unsigned(C_M_AXI_BURST_LEN-1,C_TRANSACTIONS_NUM+1)))) then              
				write_index <= std_logic_vector(unsigned(write_index) + 1);                                         
	        end if;                                                                     
	      end if;                                                                       
	    end if;                                                                         
	  end process;                                                                      
	                                                                                    


	------------------------------
	--Write Response (B) Channel
	------------------------------

	--The write response channel provides feedback that the write has committed
	--to memory. BREADY will occur when all of the data and the write address
	--has arrived and been accepted by the slave.

	--The write issuance (number of outstanding write addresses) is started by 
	--the Address Write transfer, and is completed by a BREADY/BRESP.

	--While negating BREADY will eventually throttle the AWREADY signal, 
	--it is best not to throttle the whole data channel this way.

	--The BRESP bit [1] is used indicate any errors from the interconnect or
	--slave for the entire write burst. This example will capture the error 
	--into the ERROR output. 

	  process(M_AXI_ACLK)                                             
	  begin                                                                 
	    if (rising_edge (M_AXI_ACLK)) then                                  
	      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then                                    
	        axi_bready <= '0';                                              
	        -- accept/acknowledge bresp with axi_bready by the master       
	        -- when M_AXI_BVALID is asserted by slave                       
	      else                                                              
	        if (M_AXI_BVALID = '1' and axi_bready = '0') then               
	          axi_bready <= '1';                                            
	          -- deassert after one clock cycle                             
	        elsif (axi_bready = '1') then                                   
	          axi_bready <= '0';                                            
	        end if;                                                         
	      end if;                                                           
	    end if;                                                             
	  end process;                                                          
	                                                                        
	                                                                        
	--Flag any write response errors                                        
	  write_resp_error <= axi_bready and M_AXI_BVALID and M_AXI_BRESP(1);   


	------------------------------
	--Read Address Channel
	------------------------------

	--The Read Address Channel (AW) provides a similar function to the
	--Write Address channel- to provide the tranfer qualifiers for the burst.

	--In this example, the read address increments in the same
	--manner as the write address channel.

	  process(M_AXI_ACLK)										  
	  begin                                                              
	    if (rising_edge (M_AXI_ACLK)) then                               
	      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then                                 
	        axi_arvalid <= '0';                                          
	     -- If previously not valid , start next transaction             
	      else                                                           
			-- if (axi_arvalid = '0' and read_stall_reg = 2) then
			if (axi_arvalid = '0' and read_stall_reg = 1) then
	          axi_arvalid <= '1';                                        
	        elsif (M_AXI_ARREADY = '1' and axi_arvalid = '1') then       
	          axi_arvalid <= '0';                                        
	        end if;                                                      
	      end if;                                                        
	    end if;                                                          
	  end process;                                                       
                                                      



	----------------------------------
	--Read Data (and Response) Channel
	----------------------------------

	 -- Forward movement occurs when the channel is valid and ready   
	  rnext <= M_AXI_RVALID and axi_rready;                                 
	  rnext_out_o <= M_AXI_RVALID and axi_rready; 

	-- Burst length counter. Uses extra counter register bit to indicate    
	-- terminal count to reduce decode logic                                
	  process(M_AXI_ACLK)                                                   
	  begin                                                                 
	    if (rising_edge (M_AXI_ACLK)) then                                  
	      if (M_AXI_ARESETN = '0' or start_single_burst_read = '1' or init_txn_pulse = '1') then    
	        read_index <= (others => '0');                                  
	      else                                                              
	        if (rnext = '1' and (read_index <= std_logic_vector(to_unsigned(C_M_AXI_BURST_LEN-1,C_TRANSACTIONS_NUM+1)))) then   
	          read_index <= std_logic_vector(unsigned(read_index) + 1);                               
	        end if;                                                         
	      end if;                                                           
	    end if;                                                             
	  end process;                                                          
	                                                                        
	--/*                                                                    
	-- The Read Data channel returns the results of the read request        
	--                                                                      
	-- In this example the data checker is always able to accept            
	-- more data, so no need to throttle the RREADY signal                  
	-- */                                                                   
	  process(M_AXI_ACLK)                                                   
	  begin                                                                 
	    if (rising_edge (M_AXI_ACLK)) then                                  
	      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then             
	        axi_rready <= '0';                                              
	     -- accept/acknowledge rdata/rresp with axi_rready by the master    
	      -- when M_AXI_RVALID is asserted by slave                         
	      else                                                   
	        if (M_AXI_RVALID = '1') then                         
	          if (M_AXI_RLAST = '1' and axi_rready = '1') then   
	            axi_rready <= '0';                               
	           else                                              
	             axi_rready <= '1';                              
	          end if;                                            
	        end if;                                              
	      end if;                                                
	    end if;                                                  
	  end process;                                               
                
	----------------------------------
	--Example design throttling
	----------------------------------

	-- For maximum port throughput, this user example code will try to allow
	-- each channel to run as independently and as quickly as possible.

	-- However, there are times when the flow of data needs to be throtted by
	-- the user application. This example application requires that data is
	-- not read before it is written and that the write channels do not
	-- advance beyond an arbitrary threshold (say to prevent an 
	-- overrun of the current read address by the write address).

	-- From AXI4 Specification, 13.13.1: "If a master requires ordering between 
	-- read and write transactions, it must ensure that a response is received 
	-- for the previous transaction before issuing the next transaction."

	-- This example accomplishes this user application throttling through:
	-- -Reads wait for writes to fully complete
	-- -Address writes wait when not read + issued transaction counts pass 
	-- a parameterized threshold
	-- -Writes wait when a not read + active data burst count pass 
	-- a parameterized threshold

                                                             
	                                                                                                             
	  MASTER_EXECUTION_PROC:process(M_AXI_ACLK)                                                                  
	  begin                                       
		
		--test_bench for coverage sginal
		mst_state_o <= std_logic_vector(to_unsigned(state'pos(mst_exec_state),mst_state_o'length));

		if (rising_edge (M_AXI_ACLK)) then                                                                       
		  if (M_AXI_ARESETN = '0') then                                                                         
			-- reset condition                                                                                   
			-- All the signals are ed default values under reset condition                                       
			mst_exec_state     <= IDLE;                                                                  
			compare_done       <= '0';                                                                           
			start_single_burst_write <= '0';                                                                     
			start_single_burst_read  <= '0';                                                                     
			ERROR <= '0'; 

			start_has_been <= '0';
			start_psolaf_o <= '0';
			stall_cnt_next <= to_unsigned(0,stall_cnt_reg'length);
			matk_valid_o <= '0';
			reads_done_psolaf_o <= '0';
			read_stall_next <= to_unsigned(0,read_stall_reg'length);

			last_read <= '0'; 
			
  
		  else                                                                                                   
			-- state transition                                                                                  
			case (mst_exec_state) is                                                                             
		  
			   when IDLE =>                                                                              
				 -- This state is responsible to initiate                               
				 -- AXI transaction when init_txn_pulse is asserted 
				 	
				   if ( init_txn_pulse = '1') then       
					 mst_exec_state  <= INIT_READ_M;                                                              
					 ERROR <= '0'; 
					 compare_done <= '0'; 
					  
					 read_stall_next <= to_unsigned(0,read_stall_reg'length);   
					 write_stall <= to_unsigned(0,write_stall'length);   

					 flag_opseg_read <= '0';
				  else                                                                                          
					 mst_exec_state  <= IDLE;
                                                         
				   end if;         
																							  
			  
			   when INIT_READ_M =>                                                                                
				  -- This state is responsible to issue start_single_read pulse to                               
				  -- initiate a read transaction. Read transactions will be                                      
				  -- issued until burst_read_active signal is asserted.                                          
				  -- read controller      

					if (axi_arvalid = '0' and ((burst_read_active = '0' and start_single_burst_read = '0') or read_stall_reg = 1)) then       
						read_stall_next <= read_stall_reg + to_unsigned(1,read_stall_reg'length);
						start_single_burst_read <= '1';
						mst_exec_state  <= INIT_READ_M;                                                            
					else              
						read_stall_next <= to_unsigned(0,read_stall_reg'length);                                                                           
						start_single_burst_read <= '0'; --Negate to generate a pulse                               
						mst_exec_state  <= READ_M; 
					end if;   



					 

				when READ_M =>
					if(M_AXI_RVALID = '1' and axi_rready = '1' and start_has_been = '0') then
						start_psolaf_o <= '1';
						start_has_been <= '1';
					else
						start_psolaf_o <= '0';
					end if;

					if (axi_arvalid = '0' and ((burst_read_active = '0' and start_single_burst_read = '0') or read_stall_next = 1)) then       
						read_stall_next <= read_stall_reg + to_unsigned(1,read_stall_reg'length);
						start_single_burst_read <= '1';
                                                           
					else              
						read_stall_next <= to_unsigned(0,read_stall_reg'length);                                                                           
						start_single_burst_read <= '0'; --Negate to generate a pulse                               

					end if;  


					if (reads_done = '1' and end_flag = '1') then 
						reads_done_psolaf_o <= '1';
						mst_exec_state <= ERASE_FIRST_M;
					else              									
						mst_exec_state  <= READ_M;                                                              
					end if; 

				when ERASE_FIRST_M =>  
						
						if (axi_arvalid = '0' and ((burst_read_active = '0' and start_single_burst_read = '0') or read_stall_reg = 1)) then       
							read_stall_next <= read_stall_reg + to_unsigned(1,read_stall_reg'length);
							start_single_burst_read <= '1';
															   
						else              
							read_stall_next <= to_unsigned(0,read_stall_reg'length);                                                                           
							start_single_burst_read <= '0'; --Negate to generate a pulse                               
	
						end if;  

						if (reads_first_done = '1' and end_flag = '1') then 
							reads_done_psolaf_o <= '0';
							mst_exec_state <= M_LAST;
						else
							mst_exec_state  <= ERASE_FIRST_M;                                                              
						end if; 

				when M_LAST => 

							if (axi_arvalid = '0' and ((burst_read_active = '0' and start_single_burst_read = '0') or read_stall_reg = 1)) then       
								read_stall_next <= read_stall_reg + to_unsigned(1,read_stall_reg'length);
								start_single_burst_read <= '1';
																   
							else              
								read_stall_next <= to_unsigned(0,read_stall_reg'length);                                                                           
								start_single_burst_read <= '0'; --Negate to generate a pulse                               
		
							end if;  

						if (reads_last_done = '1' and end_flag = '1') then 

							if(p2_write_m_top_i = '1')then

								if (axi_arvalid = '0' and ((burst_read_active = '0' and start_single_burst_read = '0') or read_stall_reg = 1)) then       
									read_stall_next <= read_stall_reg + to_unsigned(1,read_stall_reg'length);
									start_single_burst_read <= '1';
									mst_exec_state  <= M_LAST; 						   
								else              
									read_stall_next <= to_unsigned(0,read_stall_reg'length);                                                                           
									start_single_burst_read <= '0'; --Negate to generate a pulse                               
									mst_exec_state <= M_WRITE_LAST;
								end if;  

							else
								stall_cnt_next <= to_unsigned(1,stall_cnt_reg);
								mst_exec_state <= M_WRITE_LAST;
							end if;

						else              									
							mst_exec_state  <= M_LAST;                                                              
						end if; 

				when M_WRITE_LAST => 
					
						if ((M_AXI_BVALID = '1' and axi_bready = '1') or stall_cnt_reg = 1) then
							if (axi_arvalid = '0' and ((burst_read_active = '0' and start_single_burst_read = '0') or read_stall_reg = 1)) then       
								read_stall_next <= read_stall_reg + to_unsigned(1,read_stall_reg'length);
								start_single_burst_read <= '1';
								stall_cnt_next <= to_unsigned(1,stall_cnt_reg);
								matk_valid_o <= '1';
								mst_exec_state  <= M_WRITE_LAST; 					   
							else              
								read_stall_next <= to_unsigned(0,read_stall_reg'length);                                                                           
								start_single_burst_read <= '0'; --Negate to generate a pulse    
								stall_cnt_next <= to_unsigned(0,stall_cnt_reg);                             
								mst_exec_state  <= READ_M_MATK; 
							end if;  

						else              									
							mst_exec_state  <= M_WRITE_LAST;                                                              
						end if; 


				when READ_M_MATK =>

					if ((reads_m_matk_done = '1' and end_flag = '1' and place_enable_i = '1') or ((stall_cnt_reg > 0 or stall_cnt_reg < 4) and end_flag = '1' and place_enable_i = '1')) then 
						if (axi_arvalid = '0' and ((burst_read_active = '0' and start_single_burst_read = '0') or read_stall_reg = 1)) then       
								read_stall_next <= read_stall_reg + to_unsigned(1,read_stall_reg'length);
								start_single_burst_read <= '1';	
								stall_cnt_next <= stall_cnt_reg + to_unsigned(1,stall_cnt_reg);			   
						else         

							read_stall_next <= to_unsigned(0,read_stall_reg'length);                                                                           
							start_single_burst_read <= '0'; --Negate to generate a pulse 
						end if;  
						
						-- izmena 13.09.2024
						-- if(axi_arvalid = '1' and M_AXI_ARREADY = '1')then
						if (M_AXI_RVALID = '1' and axi_rready = '1') then 
							stall_cnt_next <= to_unsigned(0,stall_cnt_reg); 
							mst_exec_state <= PLACE;
						else
							mst_exec_state  <= READ_M_MATK;	
						end if;
					else              									
						mst_exec_state  <= READ_M_MATK;                                                              
					end if;    



					if(data_available_next > 0)then
						if (axi_arvalid = '0' and ((burst_read_active = '0' and start_single_burst_read = '0') or read_stall_reg = 1)) then       
								read_stall_next <= read_stall_reg + to_unsigned(1,read_stall_reg'length);
								start_single_burst_read <= '1';				   
						else         

							read_stall_next <= to_unsigned(0,read_stall_reg'length);                                                                           
							start_single_burst_read <= '0'; --Negate to generate a pulse 
							stall_cnt_next <= to_unsigned(0,stall_cnt_reg);                            
						end if;  
					end if; 

				when PLACE =>
					if (axi_arvalid = '0' and ((burst_read_active = '0' and start_single_burst_read = '0') or read_stall_reg = 1)) then       
						read_stall_next <= read_stall_reg + to_unsigned(1,read_stall_reg'length);
						start_single_burst_read <= '1';      
						-- mst_exec_state  <= PLACE;                                               
					else              
						read_stall_next <= to_unsigned(0,read_stall_reg'length);                                                                           
						start_single_burst_read <= '0'; --Negate to generate a pulse  
						-- mst_exec_state  <= INIT_READ_HAN;                              
					end if;  

					-- if(axi_arvalid = '1' and M_AXI_ARREADY = '1')then

					-- 	stall_cnt_next <= to_unsigned(0,stall_cnt_reg);  
					-- 	mst_exec_state  <= INIT_READ_HAN;  
					-- else
					-- 	mst_exec_state  <= PLACE;	
					-- end if;

					if (M_AXI_RVALID = '1' and axi_rready = '1') then 
						stall_cnt_next <= stall_cnt_reg + to_unsigned(1,stall_cnt_reg);                                                          
					end if; 

					if(stall_cnt_reg = 1) then
						mst_exec_state <= INIT_READ_HAN;
					else              									
						mst_exec_state  <= PLACE;                                                              
					end if; 

				-- when INIT_READ_HAN_ADDR =>
				-- 	if (axi_arvalid = '0' and ((burst_read_active = '0' and start_single_burst_read = '0') or read_stall_reg = 1)) then       
				-- 		read_stall_next <= read_stall_reg + to_unsigned(1,read_stall_reg'length);
				-- 		start_single_burst_read <= '1';      
				-- 		mst_exec_state  <= INIT_READ_HAN_ADDR;                                               
				-- 	else              
				-- 		read_stall_next <= to_unsigned(0,read_stall_reg'length);                                                                           
				-- 		start_single_burst_read <= '0'; --Negate to generate a pulse  
				-- 		mst_exec_state  <= INIT_READ_HAN;                              
				-- 	end if;  

				-- 	if(axi_arvalid = '1' and M_AXI_ARREADY = '1')then

				-- 		stall_cnt_next <= to_unsigned(0,stall_cnt_reg);  
				-- 		mst_exec_state  <= INIT_READ_HAN;  
				-- 	else
				-- 		mst_exec_state  <= INIT_READ_HAN_ADDR;	
				-- 	end if;

				when INIT_READ_HAN =>                                                                                
				-- This state is responsible to issue start_single_read pulse to                               
				-- initiate a read transaction. Read transactions will be                                      
				-- issued until burst_read_active signal is asserted.                                          
				-- read controller      
				

					--UBACI OVDE DA CITAS PLACE JER TI TREBA ZA ODREDJIVANJE OPSEG BEGIN I END U PSOLAF MODULU
					-- if(place_enable_i = '1') then
					-- 	if (axi_arvalid = '0' and ((burst_read_active = '0' and start_single_burst_read = '0') or read_stall = 1)) then       
					-- 		read_stall <= read_stall + to_unsigned(1,read_stall'length);
					-- 		start_single_burst_read <= '1';      
					-- 	else              
					-- 		read_stall <= to_unsigned(0,read_stall'length);                                                                           
					-- 		start_single_burst_read <= '0'; --Negate to generate a pulse  
					-- 	end if;   
					-- end if;

					-- IZMENA 24.maj 2024
					-- if(place_enable_i = '1') then
						if (axi_arvalid = '0' and ((burst_read_active = '0' and start_single_burst_read = '0') or read_stall_reg = 1)) then       
							read_stall_next <= read_stall_reg + to_unsigned(1,read_stall_reg'length);
							start_single_burst_read <= '1';      
						else              
							read_stall_next <= to_unsigned(0,read_stall_reg'length);                                                                           
							start_single_burst_read <= '0'; --Negate to generate a pulse  
						end if;   
					-- end if;
					
						-- if (stall_cnt_reg = 2) then 
						if (end_flag = '0' and M_AXI_RVALID = '1' and axi_rready = '1') then 
							stall_cnt_next <= to_unsigned(0,stall_cnt_reg);
							mst_exec_state <= READ_HAN;
						else              									
							mst_exec_state  <= INIT_READ_HAN;                                                              
						end if; 
						
						-- if(M_AXI_RVALID = '1' and axi_rready = '1')then
						-- 	stall_cnt_next <= stall_cnt_reg + to_unsigned(1,stall_cnt_reg);
						-- end if;
						


				when READ_HAN =>

					-- if(place_enable_i = '1' and reads_hanning_done = '0') then
					-- 	if (axi_arvalid = '0' and ((burst_read_active = '0' and start_single_burst_read = '0') or read_stall = 1)) then       
					-- 		read_stall <= read_stall + to_unsigned(1,read_stall'length);
					-- 		start_single_burst_read <= '1';
															
					-- 	else              
					-- 		read_stall <= to_unsigned(0,read_stall'length);                                                                           
					-- 		start_single_burst_read <= '0'; --Negate to generate a pulse                               

					-- 	end if;  
					-- end if;

					-- IZMENA 24.maj 2024
					if(reads_hanning_done = '0') then
						if (axi_arvalid = '0' and ((burst_read_active = '0' and start_single_burst_read = '0') or read_stall_reg = 1)) then       
							read_stall_next <= read_stall_reg + to_unsigned(1,read_stall_reg'length);
							start_single_burst_read <= '1';
															
						else              
							read_stall_next <= to_unsigned(0,read_stall_reg'length);                                                                           
							start_single_burst_read <= '0'; --Negate to generate a pulse                               

						end if;  
					end if;

					if(M_AXI_RVALID = '1' and axi_rready = '1')then
						stall_cnt_next <= stall_cnt_reg + to_unsigned(1,stall_cnt_reg);
					end if;

					if (reads_hanning_done = '1' and end_flag = '1') then 
						stall_cnt_next <= to_unsigned(0,stall_cnt_reg);
						mst_exec_state <= INIT_READ_OPSEG;
					else              									
						mst_exec_state  <= READ_HAN;                                                              
					end if; 

				when INIT_READ_OPSEG => 
					
					if(opseg_addr_valid_i = '1' and stall_cnt_reg = 0)then
						if (axi_arvalid = '0' and ((burst_read_active = '0' and start_single_burst_read = '0') or read_stall_reg = 1)) then       
							read_stall_next <= read_stall_reg + to_unsigned(1,read_stall_reg'length);
							start_single_burst_read <= '1';				   
						else              
							read_stall_next <= to_unsigned(0,read_stall_reg'length);                                                                           
							start_single_burst_read <= '0'; --Negate to generate a pulse                               
						end if; 
					end if;
					
					if(axi_arvalid = '1' and M_AXI_ARREADY = '1')then
						stall_cnt_next <= stall_cnt_reg + to_unsigned(1,stall_cnt_reg);
					end if;

					if(ready_han_i = '1') then

						stall_cnt_next <= to_unsigned(0,stall_cnt_reg);
						mst_exec_state <= READ_OPSEG;
						
					else
						matk_valid_o <= '0';

						mst_exec_state <= INIT_READ_OPSEG;
					end if;

  
			   when READ_OPSEG =>                                                                                 

							if (axi_arvalid = '0' and ((burst_read_active = '0' and start_single_burst_read = '0') or read_stall_reg = 1)) then       
								read_stall_next <= read_stall_reg + to_unsigned(1,read_stall_reg'length);
								start_single_burst_read <= '1';
								mst_exec_state  <= READ_OPSEG;				   
							else              
								read_stall_next <= to_unsigned(0,read_stall_reg'length);                                                                           
								start_single_burst_read <= '0'; --Negate to generate a pulse
								mst_exec_state <= READ_OPSEG_2;                                
							end if; 


				when READ_OPSEG_2 => 

					if (reads_opseg_done = '1' and end_flag = '1') then 
															
						stall_cnt_next <= to_unsigned(0,stall_cnt_reg);    

						mst_exec_state <= INIT_WRITE; 
					else

							if (axi_arvalid = '0' and ((burst_read_active = '0' and start_single_burst_read = '0') or read_stall_reg = 1)) then       
								read_stall_next <= read_stall_reg + to_unsigned(1,read_stall_reg'length);
								start_single_burst_read <= '1';				   
							else              
								read_stall_next <= to_unsigned(0,read_stall_reg'length);                                                                           
								start_single_burst_read <= '0'; --Negate to generate a pulse                               
							end if; 

						mst_exec_state <= READ_OPSEG_2; 
					end if;

				when INIT_WRITE =>  
					if (axi_arvalid = '0' and ((burst_read_active = '0' and start_single_burst_read = '0') or read_stall_reg = 1)) then       
						read_stall_next <= read_stall_reg + to_unsigned(1,read_stall_reg'length);
						start_single_burst_read <= '1';				   
					else              
						read_stall_next <= to_unsigned(0,read_stall_reg'length);                                                                           
						start_single_burst_read <= '0'; --Negate to generate a pulse  
						                            
					end if;
					if(M_AXI_RVALID = '1' and axi_rready = '1')then
						stall_cnt_next <= to_unsigned(0,stall_cnt_reg);  
						mst_exec_state <= WRITE_OUT;  
					end if;
					
					if ((axi_awvalid = '0' and start_single_burst_write = '0' and burst_write_active = '0') or write_stall = 1 ) then 
						write_stall <= write_stall + to_unsigned(1,write_stall'length);
						start_single_burst_write <= '1';                                                           
					else     
						write_stall <= to_unsigned(0,write_stall'length);                                                                                      
						start_single_burst_write <= '0'; --Negate to generate a pulse                              
					end if; 
			  
				when WRITE_OUT =>                                                                                                                                                          

					if (reads_write_out_done = '1' and end_flag = '1') then 
																
  
						stall_cnt_next <= to_unsigned(0,stall_cnt_reg);   

						mst_exec_state <= M_WRITE_LAST;  

					else       
						
						if( (ready_interp1_i = '1') or start_single_burst_read = '1' or start_single_burst_write = '1') then
							if (axi_arvalid = '0' and ((burst_read_active = '0' and start_single_burst_read = '0') or read_stall_reg = 1)) then       
								read_stall_next <= read_stall_reg + to_unsigned(1,read_stall_reg'length);
								start_single_burst_read <= '1';				   
							else              
								read_stall_next <= to_unsigned(0,read_stall_reg'length);                                                                           
								start_single_burst_read <= '0'; --Negate to generate a pulse                               
							end if;

								if ((axi_awvalid = '0' and start_single_burst_write = '0' and burst_write_active = '0') or write_stall = 1 ) then 
									write_stall <= write_stall + to_unsigned(1,write_stall'length);
									start_single_burst_write <= '1';                                                           
								else     
									write_stall <= to_unsigned(0,write_stall'length);                                                                                      
									start_single_burst_write <= '0'; --Negate to generate a pulse                              
									mst_exec_state  <= WRITE_OUT_2;
									if (ready_psolaf_i = '1') then                                                                  
										mst_exec_state <= IDLE;                                                               
									else
										mst_exec_state  <= WRITE_OUT_2;
									end if;  
										
								end if; 
						end if;
 
					end if;                                                                
				 
					when WRITE_OUT_2 => 
						if (write_out_done = '1' and end_flag_write = '1') then
	
							stall_cnt_next <= to_unsigned(1,stall_cnt_reg);  
							last_read <= '0'; 
							mst_exec_state <= M_WRITE_LAST_ADDR_SETUP;     
						else 

							if(burst_read_active = '0')then--
								stall_cnt_next <= stall_cnt_reg + to_unsigned(1,stall_cnt_reg);
							end if;

								
							-- if(M_AXI_RLAST = '1')then--
							-- 	stall_cnt_next <= to_unsigned(0,stall_cnt_reg);
							-- end if;

							if(M_AXI_RVALID = '1' and axi_rready = '1')then
								stall_cnt_next <= to_unsigned(0,stall_cnt_reg);
							end if;

							if((data_available_reg > 0) and (burst_read_active = '0' or stall_cnt_reg < 5 ))then--

									if (axi_arvalid = '0' and ((burst_read_active = '0' and start_single_burst_read = '0' and stall_cnt_reg > 1) or read_stall_reg = 1)) then       
										read_stall_next <= read_stall_reg + to_unsigned(1,read_stall_reg'length);
										start_single_burst_read <= '1';				 
										stall_cnt_next <= stall_cnt_reg + to_unsigned(1,stall_cnt_reg);  
									else              
										read_stall_next <= to_unsigned(0,read_stall_reg'length);                                                                           
										start_single_burst_read <= '0'; --Negate to generate a pulse                             
									end if;
								
							end if;


							-- Izmena 20. jun 2024
							-- if(data_available_reg = 0 and last_read = '0')then
							if(data_available_reg = 0 and last_read = '1')then
								if (axi_arvalid = '0' and ((burst_read_active = '0' and start_single_burst_read = '0' and stall_cnt_reg > 1) or read_stall_reg = 1)) then       
									read_stall_next <= read_stall_reg + to_unsigned(1,read_stall_reg'length);
									start_single_burst_read <= '1';				 
									stall_cnt_next <= stall_cnt_reg + to_unsigned(1,stall_cnt_reg); 
									 
								else              
									read_stall_next <= to_unsigned(0,read_stall_reg'length);                                                                           
									start_single_burst_read <= '0'; --Negate to generate a pulse   
									last_read <= '0';                          
								end if;
							end if;

							-- Mozda treba dodati and data_available = 127,ali mislim da nema potrebe
							-- je slucaj gde je data_available_write_reg = 128 na pocetku tad je data_available = 127
							if(data_available_write_reg = 128)then
								last_read <= '1';
							
							end if;
							-- dovde

							if ((axi_awvalid = '0' and start_single_burst_write = '0' and burst_write_active = '0') or write_stall = 1 ) then 
								write_stall <= write_stall + to_unsigned(1,write_stall'length);
								start_single_burst_write <= '1';                                                           
							else     
								write_stall <= to_unsigned(0,write_stall'length);                                                                                      
								start_single_burst_write <= '0'; --Negate to generate a pulse                              
							end if; 
							
							mst_exec_state <= WRITE_OUT_2; 
						end if;


					when M_WRITE_LAST_ADDR_SETUP =>  
						stall_cnt_next <= to_unsigned(1,stall_cnt_reg);

						if (axi_arvalid = '0' and ((burst_read_active = '0' and start_single_burst_read = '0') or read_stall_reg = 1)) then       
							read_stall_next <= read_stall_reg + to_unsigned(1,read_stall_reg'length);
							start_single_burst_read <= '1';				   
						else              
							read_stall_next <= to_unsigned(0,read_stall_reg'length);                                                                           
							start_single_burst_read <= '0'; --Negate to generate a pulse  
														
						end if;
						if(M_AXI_RVALID = '1' and axi_rready = '1')then 
							mst_exec_state <= M_WRITE_LAST; 
						end if;
                                                                         
			  
				when others  =>                                                                                  
				  mst_exec_state  <= IDLE;                                                               
			  end case  ;                                                                                        
		   end if;                                                                                               
		end if;                                                                                                  
	  end process;                                                                                           
                                                                                 
	 -- Check for last write completion.                                                                         
	                                                                                                             
	 -- This logic is to qualify the last write count with the final write                                       
	 -- response. This demonstrates how to confirm that a write has been                                         
	 -- committed.                                                                                               
	                                                                                                             
	  process(M_AXI_ACLK)                                                                                        
	  begin                                                                                                      
	    if (rising_edge (M_AXI_ACLK)) then                                                                       
		  if (M_AXI_ARESETN = '0' or init_txn_pulse = '1' or start_single_burst_write = '1') then                                                                       
	       writes_done <= '0';      
		   write_last_done <= '0'; 
		   write_out_done <= '0';                                                                              
	      --The reads_done should be associated with a rready response                                           
	      else                                                                                                   
			if (end_flag_write = '1' and M_AXI_BVALID = '1' and axi_bready = '1') then   
	          
			  	if(mst_exec_state = M_WRITE_LAST) then
					write_last_done <= '1'; 
				elsif(mst_exec_state = ERASE_FIRST_M) then
					writes_done <= '1';
				elsif(mst_exec_state = WRITE_OUT_2) then
					write_out_done <= '1';  
				else
					writes_done <= '1';  
				end if;                                                                             
	        end if;                                                                                              
	      end if;                                                                                                
	    end if;                                                                                                  
	  end process;                                                                                               
	                                                                                                             
	                                                                                           
	                                                                                                             
	 -- Check for last read completion.                                                                          
	                                                                                                             
	 -- This logic is to qualify the last read count with the final read                                         
	 -- response. This demonstrates how to confirm that a read has been                                          
	 -- committed.                                                                                               
	                                                                                                             
	 process(M_AXI_ACLK)                                                                                        
	 begin                                                                                                      
	   if (rising_edge (M_AXI_ACLK)) then                                                                       
		 if (M_AXI_ARESETN = '0' or init_txn_pulse = '1' or start_single_burst_read = '1') then                                                                         

		   reads_done <= '0';        
		   reads_first_done <= '0'; 
		   reads_last_done <= '0';
		   reads_m_matk_done <= '0';
		   reads_opseg_done <= '0';
		   reads_hanning_done <= '0';
		   reads_write_out_done <= '0'; 

		 else                                                                                                   
		   if (end_flag = '1' and M_AXI_RLAST = '1') then
			
			   if(mst_exec_state = READ_M) then
				    reads_done <= '1';
				elsif(mst_exec_state = ERASE_FIRST_M) then
					reads_first_done <= '1'; 
				elsif(mst_exec_state = M_LAST) then
					reads_last_done <= '1';
				elsif(mst_exec_state = READ_M_MATK) then
					reads_m_matk_done <= '1';
				elsif(mst_exec_state = READ_HAN) then
					reads_hanning_done <= '1';
				elsif(mst_exec_state = READ_OPSEG_2) then
					reads_opseg_done <= '1'; 
			    elsif(mst_exec_state = WRITE_OUT_2) then
					reads_write_out_done <= '1'; 
			    end if;

		   end if;                                                                                              
		 end if;                                                                                                
	   end if;                                                                                                  
	 end process;                                                                                                  

	-- Add user logic here	    
	process(M_AXI_ACLK)
    begin
        if M_AXI_ACLK'event and M_AXI_ACLK ='1' then
            if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
                -- opseg_end_s <= (others => '0');
				-- opseg_begin_s <= (others => '0');
				read_stall_reg <= to_unsigned(0,read_stall_next'length);
				axi_araddr_reg <= (others => '0');
				data_available_reg <= to_unsigned(0,data_available_reg'length);
				stall_cnt_reg <= to_unsigned(0,stall_cnt_reg'length);
				-- -- mst_exec_state_reg <= IDLE;
				data_available_write_reg <= to_unsigned(0,data_available_write_reg'length);
			else
				-- opseg_end_s <= opseg_end_i;
				-- opseg_begin_s <= opseg_begin_i;
				read_stall_reg <= read_stall_next;
				axi_araddr_reg <= axi_araddr_next;
				data_available_reg <= data_available_next;
				stall_cnt_reg <= stall_cnt_next;
				-- -- mst_exec_state_reg <= mst_exec_state_next;
				data_available_write_reg <= data_available_write_next;
            end if;          
        end if;
    end process;

	-- burst_read_active signal is asserted when there is a burst read transaction                            
	  -- is initiated by the assertion of start_single_burst_read. start_single_burst_read                      
	  -- signal remains asserted until the burst read is accepted by the master                                  
	  process(M_AXI_ACLK)                                                                                        
	  begin                                                                                                      
	    if (rising_edge (M_AXI_ACLK)) then                                                                       
	      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then                                                                         
	        burst_read_active <= '0';   

			data_available_next <= resize(unsigned(m_size_i) - 2,data_available_next'length);                                                                                
	       --The burst_read_active is asserted when a read burst transaction is initiated
	      else                                                                                                   
	        if (start_single_burst_read = '1')then                                                               
	          burst_read_active <= '1';
				case mst_exec_state is
					when INIT_READ_M =>
						data_available_next <= resize(unsigned(m_size_i) - 2,data_available_next'length);
					when ERASE_FIRST_M =>
						data_available_next <= to_unsigned(0,data_available_next'length);
					when M_LAST =>
						data_available_next <= to_unsigned(0,data_available_next'length);
					when M_WRITE_LAST =>
							data_available_next <= resize(num_of_m_i - 2,data_available_next'length);
					
					when INIT_READ_HAN =>
						-- data_available <= to_unsigned(0,data_available'length);
						data_available_next <= resize(unsigned(pit_i),data_available_next'length);
			
					when READ_HAN =>
							if(stall_cnt_reg < 4)then
								--data_available <= resize(unsigned(pit_i) - 1,data_available'length);	
								data_available_next <= resize(unsigned(pit_i),data_available_next'length);						
							end if;


					when INIT_READ_OPSEG =>
						if(opseg_addr_valid_i = '1' and stall_cnt_reg = 4)then
							data_available_next <= resize(opseg_end_i - opseg_begin_i,data_available_next'length);
						end if;

					when READ_OPSEG =>
						data_available_next <= resize(opseg_end_i - opseg_begin_i,data_available_next'length);

					when WRITE_OUT =>
							--7. MART 2024
							--OVDE MOZDA BUDE GRESKA jer je u data_available_write endGr_i - iniGr_i samo
							data_available_next <= resize((endGr_i - iniGr_i) - 1,data_available_next'length);
					when others =>
				end case;
			elsif (M_AXI_RVALID = '1' and axi_rready = '1' and M_AXI_RLAST = '1') then
				
				if(end_flag = '0')then	
					data_available_next <= data_available_reg - resize((unsigned(read_index)),data_available_reg); 
				else
					data_available_next <= to_unsigned(0,data_available_next'length);
				end if;

				burst_read_active <= '0';                                                                          
	        end if;                                                                                              
	      end if;                                                                                                
	    end if;                                                                                                  
	  end process;      
	 
	 process(M_AXI_ACLK)                                                   
	 begin                                                                 
		 if (rising_edge (M_AXI_ACLK)) then                                  
			 if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then        
				 axi_arlen <= (others => '0'); 
			 else        
				 
				 if(data_available_next > to_unsigned(C_M_AXI_BURST_LEN - 1,data_available_reg'length)) then
					 axi_arlen <= std_logic_vector(to_unsigned(C_M_AXI_BURST_LEN - 1,axi_arlen'length));
					 axi_araddr_incr <= std_logic_vector( resize(to_unsigned((C_M_AXI_BURST_LEN * (C_M_AXI_DATA_WIDTH/8)),C_TRANSACTIONS_NUM+3),axi_araddr_incr'length) );

					 end_flag <= '0';   
				 else
					 axi_arlen <= std_logic_vector(data_available_next);
					 axi_araddr_incr <= std_logic_vector( resize(to_unsigned((to_integer(data_available_reg) * (C_M_AXI_DATA_WIDTH/8)),C_TRANSACTIONS_NUM+3),axi_araddr_incr'length) );
					 end_flag <= '1';
				 end if;                                                     
			 end if;                                                           
		 end if;                                                             
	 end process;    


	-- Next address after ARREADY indicates previous address acceptance  
	process(M_AXI_ACLK)                                                
	begin                                                              
	  if (rising_edge (M_AXI_ACLK)) then                               
		if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then                                 
			axi_araddr_next <= (others => '0');                               
		else                                                           
		  if (M_AXI_ARREADY = '1' and axi_arvalid = '1') then            
			case mst_exec_state is
				when INIT_READ_M =>
					axi_araddr_next <= std_logic_vector(resize((unsigned(axi_araddr_next) + unsigned(axi_araddr_incr)),axi_araddr_next'length)); 
				when READ_M =>
					if(end_flag = '1')then
						axi_araddr_next <= (others => '0');
					else
						axi_araddr_next <= std_logic_vector(resize((unsigned(axi_araddr_reg) + unsigned(axi_araddr_incr)),axi_araddr_reg'length)); 
					end if;
				when ERASE_FIRST_M =>
					axi_araddr_next <= std_logic_vector(resize((unsigned(m_size_i) - to_unsigned(1,m_size_i'length)),axi_araddr_next'length - ADDR_LSB)) & std_logic_vector(to_unsigned(0,ADDR_LSB));	
				when M_LAST =>
					if(erase_flag_i = '1')then
						axi_araddr_next <= std_logic_vector( to_unsigned((3 * (C_M_AXI_DATA_WIDTH/8)),axi_araddr_reg'length) );
					else
						axi_araddr_next <= (others => '0');	
					end if;
					
				--when INIT_READ_M_MATK =>
				--	axi_araddr <= std_logic_vector(resize((unsigned(axi_araddr) + unsigned(axi_araddr_incr)),axi_araddr'length)); 
					
				when READ_M_MATK =>
					if(end_flag = '1')then
						axi_araddr_next <= std_logic_vector(resize(place_i * (C_M_AXI_DATA_WIDTH/8),axi_araddr_reg'length));  
					else
						axi_araddr_next <= std_logic_vector(resize((unsigned(axi_araddr_reg) + unsigned(axi_araddr_incr)),axi_araddr_reg'length)); 
					end if;
					
				-- PLACE dodato 13 sep 2024
				when PLACE =>
					if (stall_cnt_reg = 1) then 
						axi_araddr_next <= std_logic_vector(to_unsigned(2,2)) & std_logic_vector(to_unsigned(0,axi_araddr_reg'length - 2)); 
					else
						axi_araddr_next <= std_logic_vector(resize(place_i * (C_M_AXI_DATA_WIDTH/8),axi_araddr_reg'length));  
					end if;

				when INIT_READ_HAN =>
					axi_araddr_next <= std_logic_vector(to_unsigned(2,2)) & std_logic_vector(to_unsigned(0,axi_araddr_reg'length - 2)); 

				when READ_HAN =>
						axi_araddr_next <= std_logic_vector(resize((unsigned(axi_araddr_reg) + unsigned(axi_araddr_incr)),axi_araddr_reg'length)); 
					
				when INIT_READ_OPSEG =>
					if(opseg_addr_valid_i = '1' and stall_cnt_reg = 0)then
						axi_araddr_next <= std_logic_vector(to_unsigned(1,2)) & std_logic_vector(resize(opseg_begin_i * (C_M_AXI_DATA_WIDTH/8),axi_araddr_reg'length - 2));	
					end if;
				
				when INIT_WRITE =>
					axi_araddr_next <= std_logic_vector(to_unsigned(3,2)) & std_logic_vector(resize((iniGr_i - 1) * (C_M_AXI_DATA_WIDTH/8),axi_araddr_reg'length - 2)); -- ADDR_LSB)) & std_logic_vector(to_unsigned(0,ADDR_LSB));	

				when WRITE_OUT =>
						axi_araddr_next <= std_logic_vector(resize((unsigned(axi_araddr_reg) + unsigned(axi_araddr_incr)),axi_araddr_reg'length)); 

				when WRITE_OUT_2 =>
						axi_araddr_next <= std_logic_vector(resize((unsigned(axi_araddr_reg) + unsigned(axi_araddr_incr)),axi_araddr_reg'length)); 

				when M_WRITE_LAST_ADDR_SETUP =>
					if(erase_flag_i = '1')then
						axi_araddr_next <= std_logic_vector( to_unsigned((3 * (C_M_AXI_DATA_WIDTH/8)),axi_araddr_reg'length) );
					else
						axi_araddr_next <= (others => '0');	
					end if;


				when others =>
					axi_araddr_next <= std_logic_vector(resize((unsigned(axi_araddr_reg) + unsigned(axi_araddr_incr)),axi_araddr_reg'length)); 
			end case;

		  end if;                                                      
		end if;                                                        
	  end if;                                                          
	end process;

	addr_field_read_s <= axi_araddr_next(C_M_AXI_ADDR_WIDTH - 1 downto C_M_AXI_ADDR_WIDTH - 2);

	process(addr_field_read_s,M_AXI_RVALID,M_AXI_RDATA,axi_rready) is
	begin
		-- if(M_AXI_RVALID = '1' and axi_rready = '1') then 
		-- Izmena 24.jun 2024
		if(M_AXI_RVALID = '1') then 
			case addr_field_read_s is
				when "00" =>
					p1_rdata_m_top_o <= M_AXI_RDATA;
					p1_rdata_opseg_top_o <=  (others => '0');
					p1_rdata_out_top_o <=  (others => '0');
					rdata_cos_top_o <= (others => '0');
				when "01" =>
					p1_rdata_opseg_top_o <=  to_sfixed(M_AXI_RDATA(p1_rdata_opseg_top_o'length - 1 downto 0),p1_rdata_opseg_top_o'high,p1_rdata_opseg_top_o'low);
					p1_rdata_m_top_o <= (others => '0');
					p1_rdata_out_top_o <=  (others => '0');	
					rdata_cos_top_o <= (others => '0');
				when "10" =>
					p1_rdata_out_top_o <=  (others => '0');
					p1_rdata_m_top_o <= (others => '0');
					p1_rdata_opseg_top_o <=  (others => '0');
					rdata_cos_top_o <= M_AXI_RDATA;
					rdata_cos_debug <= to_sfixed(M_AXI_RDATA(rdata_cos_debug'length - 1 downto 0),rdata_cos_debug'high,rdata_cos_debug'low);
				when "11" =>
					p1_rdata_out_top_o <=  to_sfixed(M_AXI_RDATA(p1_rdata_out_top_o'length - 1 downto 0),p1_rdata_out_top_o'high,p1_rdata_out_top_o'low);
					p1_rdata_m_top_o <= (others => '0');
					p1_rdata_opseg_top_o <=  (others => '0');
					rdata_cos_top_o <= (others => '0');
				when others =>
					p1_rdata_m_top_o <= (others => '0');
					p1_rdata_opseg_top_o <=  (others => '0');
					p1_rdata_out_top_o <=  (others => '0');
					rdata_cos_top_o <= (others => '0');
			end case;
		else
			p1_rdata_m_top_o <= (others => '0');
			p1_rdata_opseg_top_o <=  (others => '0');
			p1_rdata_out_top_o <=  (others => '0');
			rdata_cos_top_o <= (others => '0');
		end if;

	end process;

	addr_field_write_s <= axi_awaddr(C_M_AXI_ADDR_WIDTH - 1 downto C_M_AXI_ADDR_WIDTH - 2);

	process(addr_field_write_s,axi_wdata,axi_wvalid,wnext,M_AXI_ARESETN,init_txn_pulse,p2_wdata_m_top_i,p1_wdata_opseg_top_i,p2_wdata_out_top_i)                                                            
		variable  sig_one : integer := 1;                                                 
		begin                                                                             
			if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then                                                
			  axi_wdata <= std_logic_vector (to_unsigned(sig_one, C_M_AXI_DATA_WIDTH));                                                               
			else                                                                          
			--   if (wnext = '1') then  
			  --IZMENA 4. juni 2024
			  if (axi_wvalid = '1') then                                                     
				case addr_field_write_s is
					when "00" =>
						axi_wdata <=  std_logic_vector(resize(signed(p2_wdata_m_top_i),axi_wdata'length));
					when "01" =>
						axi_wdata <=  std_logic_vector(resize(signed(to_slv(p1_wdata_opseg_top_i)),axi_wdata'length));
					when others =>
						axi_wdata <=  std_logic_vector(resize(signed(to_slv(p2_wdata_out_top_i)),axi_wdata'length));
				end case;
			  else
					axi_wdata <= (others => '0');                                  
			  end if;                                                                     
			end if;                                                                       
	end process;  

	process(M_AXI_ACLK)                                                   
	begin                                                                 
		if (rising_edge (M_AXI_ACLK)) then                                  
			if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then      

				axi_awlen <= (others => '0'); 
				end_flag_write <= '0'; 
			else        
				
				if(data_available_write_next > to_unsigned(C_M_AXI_BURST_LEN - 1,data_available_write_next'length)) then
					axi_awlen <= std_logic_vector(to_unsigned(C_M_AXI_BURST_LEN - 1,axi_awlen'length));
					--axi_awlen <= std_logic_vector(to_unsigned(C_M_AXI_BURST_LEN,axi_awlen'length));
					axi_awaddr_incr <= std_logic_vector( resize(to_unsigned((C_M_AXI_BURST_LEN * (C_M_AXI_DATA_WIDTH/8)),C_TRANSACTIONS_NUM+3),axi_awaddr_incr'length) );

					end_flag_write <= '0';   
				else
					axi_awlen <= std_logic_vector(data_available_write_next);
					axi_awaddr_incr <= std_logic_vector( resize(to_unsigned((to_integer(data_available_write_reg) * (C_M_AXI_DATA_WIDTH/8)),C_TRANSACTIONS_NUM+3),axi_awaddr_incr'length) );
					end_flag_write <= '1';
				end if;                                                     
			end if;                                                           
		end if;                                                             
	end process;   


	-- Next address after AWREADY indicates previous address acceptance    
	process(M_AXI_ACLK)                                                  
	begin                                                                
		if (rising_edge (M_AXI_ACLK)) then                                 
			if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then                                   
				axi_awaddr <= (others => '0');                                 
			else                                                             
				if (M_AXI_AWREADY= '1' and axi_awvalid = '1') then             
					case mst_exec_state is
						when INIT_READ_OPSEG =>

						when READ_M =>

						when ERASE_FIRST_M =>
							axi_awaddr <= std_logic_vector(resize(num_of_m_i,axi_awaddr'length)); 
						when M_LAST =>
							axi_awaddr <= std_logic_vector(resize(num_of_m_i,axi_awaddr'length)); 
						when M_WRITE_LAST =>
							axi_awaddr <= std_logic_vector(resize((unsigned(axi_awaddr) + unsigned(axi_awaddr_incr)),axi_awaddr'length)); 
						when INIT_WRITE =>
							axi_awaddr <= std_logic_vector(to_unsigned(2,2)) & std_logic_vector(resize((iniGr_i - 1) * (C_M_AXI_DATA_WIDTH/8),axi_awaddr'length - 2));
						when others =>
							axi_awaddr <= std_logic_vector(resize((unsigned(axi_awaddr) + unsigned(axi_awaddr_incr)),axi_awaddr'length)); 
					end case;
				end if;
			end if;                                                        
			                                                         
		end if;                                                            
	end process; 



	-- burst_write_active signal is asserted when there is a burst write transaction                           
	-- is initiated by the assertion of start_single_burst_write. burst_write_active                           
	-- signal remains asserted until the burst write is accepted by the slave                                  
	process(M_AXI_ACLK)                                                                                        
	begin                                                                                                      
		if (rising_edge (M_AXI_ACLK)) then                                                                       
			if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then                                                                         
				burst_write_active <= '0';                                                                           
				data_available_write_next <= to_unsigned(0,data_available_write_next'length);
			--flag_m_write <= '0';                                                                                           
			--The burst_write_active is asserted when a write burst transaction is initiated                      
			else                                                                                                   
				if (start_single_burst_write = '1') then                                                             
					burst_write_active <= '1'; 
					case mst_exec_state is
						when ERASE_FIRST_M =>
							data_available_write_next <= to_unsigned(0,data_available_write_next'length);

						when M_LAST =>
							data_available_write_next <= to_unsigned(0,data_available_write_next'length);
							
						when M_WRITE_LAST =>
							data_available_write_next <= to_unsigned(0,data_available_write_next'length);
						when INIT_WRITE =>
							data_available_write_next <= to_unsigned(1,data_available_write_next'length);
							--IZMENJENO 3. maj 2024
							-- data_available_write <= to_unsigned(2,data_available_write'length);
						
						when WRITE_OUT =>
							--IZMENJENO 21. Februar 2024
							--data_available_write <= resize((endGr_i - iniGr_i) + 1,data_available_write'length);
							--IZMENJENO 17. April 2024
							data_available_write_next <= resize((endGr_i - iniGr_i),data_available_write_next'length);
							--data_available_write <= resize((endGr_i - iniGr_i) - 1,data_available_write'length);
						when others =>
					end case;

				elsif (M_AXI_BVALID = '1' and axi_bready = '1') then     
					if(end_flag_write = '0')then	
						--data_available_write <= data_available_write - resize((unsigned(write_index) ),data_available_write); 
						--IZMENJENO 17. April 2024
						data_available_write_next <= data_available_write_reg - resize((unsigned(write_index) + 1),data_available_write_reg); 
					else
						data_available_write_next <= to_unsigned(0,data_available_write_next'length);
					end if;

					burst_write_active <= '0';                                                                         
				end if;                                                                                              
			end if;                                                                                                
		end if;                                                                                                  
	end process; 
	-- User logic ends

end implementation;
