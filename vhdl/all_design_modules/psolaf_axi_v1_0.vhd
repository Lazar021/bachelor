library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utils_pkg.all;
library ieee_proposed;
use ieee_proposed.fixed_pkg.all;

entity psolaf_axi_v1_0 is
	generic (
		-- Users to add parameters here
		--Oduzimaju se gornja dva bita od ADDR_W da bi znali u koju memoriju ide
        ADDR_W                      : integer := 16; --12 je dosta za 1500  tj 4095 podataka

        --IN memorija 
        SIZE_IN_TOP                 : integer := 10000;
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
		W_HIGH_M_TOP               : integer := 32;
        W_LOW_M_TOP                : integer := 0;
		--HAN memorija
		W_HAN_TOP		            : integer := 32;
        --OUT memorija
        SIZE_OUT_TOP               : integer := 15000;
        SIZE_ADDR_W_OUT            : integer := 14;
        -- W_HIGH_OUT_TOP             : integer := 1;
        -- W_LOW_OUT_TOP              : integer := -31;
		-- izmena 2. jul 2024
		W_HIGH_OUT_TOP             : integer := 2;
        W_LOW_OUT_TOP              : integer := -30;
		
		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 6;

		-- Parameters of Axi Master Bus Interface M00_AXI
		C_M00_AXI_TARGET_SLAVE_BASE_ADDR	: std_logic_vector	:= x"40000";
		C_M00_AXI_BURST_LEN					: integer	:= 16;
		C_M00_AXI_ID_WIDTH					: integer	:= 1;
		C_M00_AXI_ADDR_WIDTH				: integer	:= 20;
		C_M00_AXI_DATA_WIDTH				: integer	:= 32;
		C_M00_AXI_AWUSER_WIDTH				: integer	:= 1;
		C_M00_AXI_ARUSER_WIDTH				: integer	:= 1;
		C_M00_AXI_WUSER_WIDTH				: integer	:= 1;
		C_M00_AXI_RUSER_WIDTH				: integer	:= 1;
		C_M00_AXI_BUSER_WIDTH				: integer	:= 1
	);
	port (
		-- Users to add ports here

		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic;

		-- Ports of Axi Master Bus Interface M00_AXI
		m00_axi_init_axi_txn	: in std_logic;
		m00_axi_txn_done	: out std_logic;
		m00_axi_error	: out std_logic;
		m00_axi_aclk	: in std_logic;
		m00_axi_aresetn	: in std_logic;
		m00_axi_awid	: out std_logic_vector(C_M00_AXI_ID_WIDTH-1 downto 0);
		m00_axi_awaddr	: out std_logic_vector(C_M00_AXI_ADDR_WIDTH-1 downto 0);
		m00_axi_awlen	: out std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
		m00_axi_awsize	: out std_logic_vector(2 downto 0);
		m00_axi_awburst	: out std_logic_vector(1 downto 0);
		m00_axi_awlock	: out std_logic;
		m00_axi_awcache	: out std_logic_vector(3 downto 0);
		m00_axi_awprot	: out std_logic_vector(2 downto 0);
		m00_axi_awqos	: out std_logic_vector(3 downto 0);
		m00_axi_awuser	: out std_logic_vector(C_M00_AXI_AWUSER_WIDTH-1 downto 0);
		m00_axi_awvalid	: out std_logic;
		m00_axi_awready	: in std_logic;
		m00_axi_wdata	: out std_logic_vector(C_M00_AXI_DATA_WIDTH-1 downto 0);
		m00_axi_wstrb	: out std_logic_vector(C_M00_AXI_DATA_WIDTH/8-1 downto 0);
		m00_axi_wlast	: out std_logic;
		m00_axi_wuser	: out std_logic_vector(C_M00_AXI_WUSER_WIDTH-1 downto 0);
		m00_axi_wvalid	: out std_logic;
		m00_axi_wready	: in std_logic;
		m00_axi_bid		: in std_logic_vector(C_M00_AXI_ID_WIDTH-1 downto 0);
		m00_axi_bresp	: in std_logic_vector(1 downto 0);
		m00_axi_buser	: in std_logic_vector(C_M00_AXI_BUSER_WIDTH-1 downto 0);
		m00_axi_bvalid	: in std_logic;
		m00_axi_bready	: out std_logic;
		m00_axi_arid	: out std_logic_vector(C_M00_AXI_ID_WIDTH-1 downto 0);
		m00_axi_araddr	: out std_logic_vector(C_M00_AXI_ADDR_WIDTH-1 downto 0);
		m00_axi_arlen	: out std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
		m00_axi_arsize	: out std_logic_vector(2 downto 0);
		m00_axi_arburst	: out std_logic_vector(1 downto 0);
		m00_axi_arlock	: out std_logic;
		m00_axi_arcache	: out std_logic_vector(3 downto 0);
		m00_axi_arprot	: out std_logic_vector(2 downto 0);
		m00_axi_arqos	: out std_logic_vector(3 downto 0);
		m00_axi_aruser	: out std_logic_vector(C_M00_AXI_ARUSER_WIDTH-1 downto 0);
		m00_axi_arvalid	: out std_logic;
		m00_axi_arready	: in std_logic;
		m00_axi_rid		: in std_logic_vector(C_M00_AXI_ID_WIDTH-1 downto 0);
		m00_axi_rdata	: in std_logic_vector(C_M00_AXI_DATA_WIDTH-1 downto 0);
		m00_axi_rresp	: in std_logic_vector(1 downto 0);
		m00_axi_rlast	: in std_logic;
		m00_axi_ruser	: in std_logic_vector(C_M00_AXI_RUSER_WIDTH-1 downto 0);
		m00_axi_rvalid	: in std_logic;
		m00_axi_rready	: out std_logic;

		-- test_bench signals for coverage
		state_tb_o      : out std_logic_vector(6 downto 0);
		mst_state_tb_o		: out std_logic_vector(6 downto 0)

	);
end psolaf_axi_v1_0;

architecture arch_imp of psolaf_axi_v1_0 is

	--PAR1 memorija
	constant SIZE_PAR1_c              : integer := 5000;
	constant W_HIGH_PAR1_c            : integer := 16;
	constant W_LOW_PAR1_c             : integer := 0;

    --GR memorija
    constant SIZE_GR_c                : integer := 4500;
    constant W_HIGH_GR_c              : integer := 1;
    --constant W_LOW_GR_c               : integer := -40;
	constant W_LOW_GR_c               : integer := -50;

	--W memorija
	-- constant SIZE_W_c                : integer := 5000;
	constant SIZE_W_c                : integer := 15000;
	constant W_HIGH_W_c              : integer := 1;
	--constant W_LOW_W_c               : integer := -50;
	constant W_LOW_W_c               : integer := -31;

	constant W_HAN_c					: integer := 32;

	--signal declarations
	signal reset_s                  : std_logic;

	
	--Interface to the AXI controllers
	signal abg_s                       : std_logic_vector(32 - 1 downto 0);
	signal alpha_wr_s                  : std_logic;                        
	signal beta_wr_s                   : std_logic;    
	signal gamma_wr_s                  : std_logic;   
	signal gamma_rec_wr_s			   : std_logic;   
	signal in_size_wr_s                : std_logic;    
	signal start_wr_s                  : std_logic;     
	signal m_size_top_s                : std_logic_vector(log2c(SIZE_M_TOP) - 1 downto 0);
	signal m_size_wr_s				   : std_logic; 
	
	signal alpha_axi_s                 : sfixed(9 downto -22);
	signal beta_axi_s                  : sfixed(9 downto -22);
	signal gamma_axi_s                 : sfixed(9 downto -22);
	signal gamma_rec_axi_s             : sfixed(9 downto -22);
	signal in_size_axi_s               : std_logic_vector(W_HIGH_M_TOP - 1 downto 0);
	signal start_axi_s                 : std_logic;
	signal ready_axi_s                 : std_logic;
	signal m_size_axi_s                : std_logic_vector(log2c(SIZE_M_TOP) - 1 downto 0);
	signal m_next_s                    : unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
	signal reading_m_s				   : std_logic;
	signal mem_addr_s                  : std_logic_vector(C_M00_AXI_ADDR_WIDTH - ((C_M00_AXI_ADDR_WIDTH/32)+1) - 1 downto 0);

	signal mem_wr_s                    : std_logic;

	--Interface to the psolaf module
	signal alpha_s                     : sfixed(9 downto -22);
	signal beta_s                      : sfixed(9 downto -22);
	signal gamma_s                     : sfixed(9 downto -22);
	signal gamma_rec_s                     : sfixed(9 downto -22);
	signal in_size_s                   : std_logic_vector(W_HIGH_M_TOP - 1 downto 0);
	signal start_s                     : std_logic;
	signal ready_s                     : std_logic;

	--Interfejs hanning memorije--------------------------------------------------------------------------------------
	signal rdata_cos_top_s			   : std_logic_vector(W_HAN_TOP - 1 downto 0);

	--Interfejs opseg memorije--------------------------------------------------------------------------------------
	--Port 1 interface
	signal p1_addr_opseg_top_s             : std_logic_vector(ADDR_W - 1 downto 0);
	signal p1_wdata_opseg_top_s            : sfixed(W_HIGH_OPSEG_TOP - 1 downto W_LOW_OPSEG_TOP);
	signal p1_rdata_opseg_top_s            : sfixed(W_HIGH_OPSEG_TOP - 1 downto W_LOW_OPSEG_TOP);
	signal p1_write_opseg_top_s            : std_logic;
	signal num_of_elements_opseg_top_s     : std_logic_vector(log2c(SIZE_OPSEG_TOP) - 1 downto 0);

	--Interfejs m memorije--------------------------------------------------------------------------------------
	--Port 1 interface
	signal p1_addr_m_top_s             : std_logic_vector(ADDR_W - 1 downto 0);
	signal p1_wdata_m_top_s            : std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
	signal p1_rdata_m_top_s            : std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
	signal p1_write_m_top_s            : std_logic;
	--Port 2 interface
	signal p2_addr_m_top_s             : std_logic_vector(ADDR_W - 1 downto 0);
	signal p2_wdata_m_top_s            : std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
	signal p2_rdata_m_top_s            : std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
	signal p2_write_m_top_s            : std_logic;
	signal num_of_elements_m_top_s     : std_logic_vector(log2c(SIZE_M_TOP) - 1 downto 0);

	--Interfejs out memorije--------------------------------------------------------------------------------------
	--Port 1 interface
	signal p1_addr_out_top_s           : std_logic_vector(ADDR_W - 1 downto 0);
	signal p1_wdata_out_top_s          : sfixed(W_HIGH_OUT_TOP - 1 downto W_LOW_OUT_TOP);
	signal p1_rdata_out_top_s          : sfixed(W_HIGH_OUT_TOP - 1 downto W_LOW_OUT_TOP);
	signal p1_write_out_top_s          : std_logic;
	--Port 2 interface      
	signal p2_addr_out_top_s           : std_logic_vector(ADDR_W - 1 downto 0);
	signal p2_wdata_out_top_s          : sfixed(W_HIGH_OUT_TOP - 1 downto W_LOW_OUT_TOP);
	signal p2_rdata_out_top_s          : sfixed(W_HIGH_OUT_TOP - 1 downto W_LOW_OUT_TOP);
	signal p2_write_out_top_s          : std_logic;
	signal num_of_elements_out_top_s   : std_logic_vector(log2c(SIZE_OUT_TOP) - 1 downto 0);


	signal alpha_top_s                        : sfixed(22 downto -22);
    signal beta_top_s                         : sfixed(22 downto -22);
    signal gamma_top_s                        : sfixed(22 downto -22);
    signal in_size_top_s                      :  std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
    signal start_top_s                        :  std_logic;
    signal ready_top_s                        :  std_logic;
    signal start_addr_in_read_top_s           :  std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
    signal place_wr_top_s                     :  std_logic;
    signal pit_mem_sub_top_s                  :  signed(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
	signal pit_mem_sub_axi_s				  :  signed(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
	signal opseg_addr_valid_s				  :  std_logic;
	signal place_axi_s						  :  std_logic_vector(ADDR_W - 1 downto 0);
	signal pit_top_s 						  : std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
	signal place_top_s						  : unsigned(log2c(SIZE_M_TOP) - 1 downto 0);
	signal place_enable_top_s				  : std_logic;
	signal ready_han_top_s					  : std_logic;
	signal opseg_begin_top_s                  : unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
	signal opseg_end_top_s                    : unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
	signal endGr_top_s						  : unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
	signal iniGr_top_s						  : unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);

	signal start_psolaf_s					  :  std_logic;
	signal rnext_out_s						  :	 std_logic;
	signal wnext_out_s						  :	 std_logic;
	signal erase_flag_top_s					  :	 std_logic;
	signal num_of_m_top_s					  :  unsigned(log2c(SIZE_M_TOP) - 1 downto 0);

	signal m00_axi_rready_s					  :	 std_logic;
	signal m00_axi_bready_s					  :	 std_logic;
	signal reads_last_done_s				  :	 std_logic;
	signal ready_han_s						  :  std_logic;
	signal ready_interp1_s					  :  std_logic;
	signal matk_valid_top_s					  :  std_logic;
	signal reads_done_psolaf_top_s			  :  std_logic;
	signal ready_han_axi_s					  :  std_logic;
	signal ready_han_wr_s					  :  std_logic;
	signal ready_psolaf_s					  :  std_logic;	
	signal ready_psolaf_wr_s				  :  std_logic;
	signal ready_psolaf_axi_s				  :	 std_logic;
	signal end_flag_s						  :	 std_logic;	



    --Interfejs par 1 memorije-----------------------------------------------------------------------------------
	signal itp_sel_s				 : std_logic;
	signal reset_par1_s				 : std_logic;
	--Port 1 interface
    signal p1_addr_par1_s          : std_logic_vector(log2c(SIZE_PAR1_c) - 1 downto 0);
    signal p1_rdata_par1_s         : sfixed(W_HIGH_PAR1_c - 1 downto W_LOW_PAR1_c);
    signal p1_wdata_par1_s         : sfixed(W_HIGH_PAR1_c - 1 downto W_LOW_PAR1_c);
    signal p1_write_par1_s         : std_logic;
    --Port 2 interface
    signal p2_addr_par1_s          : std_logic_vector(log2c(SIZE_PAR1_c) - 1 downto 0);
    signal p2_rdata_par1_s         : sfixed(W_HIGH_PAR1_c - 1 downto W_LOW_PAR1_c);
    signal p2_wdata_par1_s         : sfixed(W_HIGH_PAR1_c - 1 downto W_LOW_PAR1_c);
    signal p2_write_par1_s         : std_logic;
    --Port 3 interface
    signal p3_addr_par1_s          : std_logic_vector(log2c(SIZE_PAR1_c) - 1 downto 0);
    signal p3_wdata_par1_s         : sfixed(W_HIGH_PAR1_c - 1 downto W_LOW_PAR1_c);
    signal p3_rdata_par1_s         : sfixed(W_HIGH_PAR1_c - 1 downto W_LOW_PAR1_c);
    signal p3_write_par1_s         : std_logic;
    --Port 4 interface
    signal p4_addr_par1_s          : std_logic_vector(log2c(SIZE_PAR1_c) - 1 downto 0);
    signal p4_wdata_par1_s         : sfixed(W_HIGH_PAR1_c - 1 downto W_LOW_PAR1_c);
    signal p4_rdata_par1_s         : sfixed(W_HIGH_PAR1_c - 1 downto W_LOW_PAR1_c);
    signal p4_write_par1_s         : std_logic;
    signal num_of_elements_par1_i_s  : std_logic_vector(log2c(SIZE_PAR1_c) - 1 downto 0);  
   
    --Interfejs gr memorije-----------------------------------------------------------------------------------
	signal reset_gr_s				 : std_logic;
	--Port 1 interface
    signal p1_addr_gr_s          : std_logic_vector(log2c(SIZE_GR_c) - 1 downto 0);
    signal p1_rdata_gr_s         : sfixed(W_HIGH_GR_c - 1 downto W_LOW_GR_c);
    signal p1_wdata_gr_s         : sfixed(W_HIGH_GR_c - 1 downto W_LOW_GR_c);
    signal p1_write_gr_s         : std_logic;
    --Port 2 interface
    signal p2_addr_gr_s          : std_logic_vector(log2c(SIZE_GR_c) - 1 downto 0);
    signal p2_rdata_gr_s         : sfixed(W_HIGH_GR_c - 1 downto W_LOW_GR_c);
    signal p2_wdata_gr_s         : sfixed(W_HIGH_GR_c - 1 downto W_LOW_GR_c);
    signal p2_write_gr_s         : std_logic;
    --Port 3 interface
    signal p3_addr_gr_s          : std_logic_vector(log2c(SIZE_GR_c) - 1 downto 0);
    signal p3_wdata_gr_s         : sfixed(W_HIGH_GR_c - 1 downto W_LOW_GR_c);
    signal p3_rdata_gr_s         : sfixed(W_HIGH_GR_c - 1 downto W_LOW_GR_c);
    signal p3_write_gr_s         : std_logic;
	signal num_of_elements_gr_s  : std_logic_vector(log2c(SIZE_GR_c) - 1 downto 0);  
   
	--Interfejs w memorije-----------------------------------------------------------------------------------
	signal han_sel_s				 : std_logic;
	signal reset_w_s				 : std_logic;
	--Port 1 interface
	signal p1_addr_w_s          : std_logic_vector(log2c(SIZE_W_c) - 1 downto 0);
	signal p1_rdata_w_s         : sfixed(W_HIGH_W_c - 1 downto W_LOW_W_c);
	signal p1_wdata_w_s         : sfixed(W_HIGH_W_c - 1 downto W_LOW_W_c);
	signal p1_write_w_s         : std_logic;
	--Port 2 interface
	signal p2_addr_w_s          : std_logic_vector(log2c(SIZE_W_c) - 1 downto 0);
	signal p2_rdata_w_s         : sfixed(W_HIGH_W_c - 1 downto W_LOW_W_c);
	signal p2_wdata_w_s         : sfixed(W_HIGH_W_c - 1 downto W_LOW_W_c);
	signal p2_write_w_s         : std_logic;
	--Port 3 interface
	signal p3_addr_w_s          : std_logic_vector(log2c(SIZE_W_c) - 1 downto 0);
	signal p3_wdata_w_s         : sfixed(W_HIGH_W_c - 1 downto W_LOW_W_c);
	signal p3_rdata_w_s         : sfixed(W_HIGH_W_c - 1 downto W_LOW_W_c);
	signal p3_write_w_s         : std_logic;
	signal num_of_elements_w_s  : std_logic_vector(log2c(SIZE_W_c) - 1 downto 0);  
	
	-- test_bench signals
	signal state_s           	: std_logic_vector(6 downto 0);
	
	-- component declaration
	component psolaf_axi_v1_0_S00_AXI is
		generic (
		-- Users to add parameters here
		W_HIGH_M_TOP               : integer := 18;
		SIZE_M_TOP					: integer := 1000;
		-- User parameters ends
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 5
		);
		port (
		-- Users to add ports here
		abg_o                       : out std_logic_vector(32 - 1 downto 0);
        in_size_top_o               : out std_logic_vector(W_HIGH_M_TOP - 1 downto 0);
        m_size_top_o                : out std_logic_vector(log2c(SIZE_M_TOP) - 1 downto 0);
        alpha_wr_o                  : out std_logic;                        
        beta_wr_o                   : out std_logic;    
        gamma_wr_o                  : out std_logic;   
		gamma_rec_wr_o   			: out std_logic;  
        in_size_wr_o                : out std_logic;    
        start_wr_o                  : out std_logic;     
		m_size_wr_o					: out std_logic;
                        
        
        alpha_axi_i                 : in sfixed(9 downto -22);
        beta_axi_i                  : in sfixed(9 downto -22);
        gamma_axi_i                 : in sfixed(9 downto -22);
		gamma_rec_axi_i				: in sfixed(9 downto -22);
        in_size_axi_i               : in std_logic_vector(W_HIGH_M_TOP - 1 downto 0);
        start_axi_i                 : in std_logic;
        --ready_axi_i                 : in std_logic;
        m_size_axi_i                : in std_logic_vector(log2c(SIZE_M_TOP) - 1 downto 0);
		pit_axi_i					: in std_logic_vector(W_HIGH_M_TOP - 1 downto 0);
		place_enable_axi_i			: in std_logic;
		ready_han_axi_i				: in std_logic;
		ready_psolaf_axi_i			: in std_logic;
		end_flag_axi_i					: in std_logic;
		
		-- User ports ends


		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component psolaf_axi_v1_0_S00_AXI;


begin

-- Instantiation of Axi Bus Interface S00_AXI
psolaf_axi_v1_0_S00_AXI_inst : psolaf_axi_v1_0_S00_AXI
	generic map (
		-- Users to add parameters here
		W_HIGH_M_TOP        => W_HIGH_M_TOP,
		SIZE_M_TOP			=> SIZE_M_TOP,
		-- User parameters ends
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
		-- Users to add ports here
		abg_o                       => abg_s,
        in_size_top_o               => in_size_top_s,
        m_size_top_o                => m_size_top_s,
        alpha_wr_o                  => alpha_wr_s,                        
        beta_wr_o                   => beta_wr_s,    
        gamma_wr_o                  => gamma_wr_s,
		gamma_rec_wr_o   			=> gamma_rec_wr_s,
        in_size_wr_o                => in_size_wr_s,    
        start_wr_o                  => start_wr_s,     
		m_size_wr_o					=> m_size_wr_s,
                        
        
        alpha_axi_i                 => alpha_axi_s,
        beta_axi_i                  => beta_axi_s,
        gamma_axi_i                 => gamma_axi_s,
		gamma_rec_axi_i				=> gamma_rec_axi_s,
        in_size_axi_i               => in_size_axi_s,
        start_axi_i                 => start_axi_s,
        --ready_axi_i                 => ready_axi_s,
		--ready_axi_i                 => ready_s,
        m_size_axi_i                => m_size_axi_s,
		pit_axi_i					=> pit_top_s,
		place_enable_axi_i			=> place_enable_top_s,
		--ready_han_axi_i				=> ready_han_s,						
		ready_han_axi_i				=> ready_han_axi_s,
		ready_psolaf_axi_i			=> ready_psolaf_axi_s,
		end_flag_axi_i				=> end_flag_s,
		
		
		       
		-- User ports ends
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);



-- Instantiation of Axi Bus Interface M00_AXI
psolaf_axi_v1_0_M00_AXI_inst : entity work.psolaf_axi_v1_0_M00_AXI(implementation)
generic map (
	-- Users to add parameters here
	--Oduzimaju se gornja dva bita od ADDR_W da bi znali u koju memoriju ide
	ADDR_W                      => ADDR_W, --12 je dosta za 1500  tj 4095 podataka

	--IN memorija 
	SIZE_IN_TOP                 => SIZE_IN_TOP,                 
	W_HIGH_IN_TOP               => W_HIGH_IN_TOP,               
	W_LOW_IN_TOP                => W_LOW_IN_TOP,                
	--OPSEG memorija
	SIZE_OPSEG_TOP              => SIZE_OPSEG_TOP,              
	W_HIGH_OPSEG_ADDR_TOP       => W_HIGH_OPSEG_ADDR_TOP,       
	W_HIGH_OPSEG_TOP            => W_HIGH_OPSEG_TOP,            
	W_LOW_OPSEG_TOP             => W_LOW_OPSEG_TOP,             
	--M memorija
	--kod ove memorije pogledaj kako kada su vrednosti preko 20k kako se cita in memorija
	SIZE_M_TOP                 => SIZE_M_TOP,                 
	SIZE_ADDR_W_M              => SIZE_ADDR_W_M,              
	W_HIGH_M_TOP               => W_HIGH_M_TOP,               
	W_LOW_M_TOP                => W_LOW_M_TOP,    
	--HAN memorija
	W_HAN_TOP		           => W_HAN_TOP,            
	--OUT memorija
	SIZE_OUT_TOP               => SIZE_OUT_TOP,               
	SIZE_ADDR_W_OUT            => SIZE_ADDR_W_OUT,            
	W_HIGH_OUT_TOP             => W_HIGH_OUT_TOP,             
	W_LOW_OUT_TOP              => W_LOW_OUT_TOP,              
	-- User parameters ends

	C_M_TARGET_SLAVE_BASE_ADDR	=> C_M00_AXI_TARGET_SLAVE_BASE_ADDR,
	C_M_AXI_BURST_LEN	=> C_M00_AXI_BURST_LEN,
	C_M_AXI_ID_WIDTH	=> C_M00_AXI_ID_WIDTH,
	C_M_AXI_ADDR_WIDTH	=> C_M00_AXI_ADDR_WIDTH,
	C_M_AXI_DATA_WIDTH	=> C_M00_AXI_DATA_WIDTH,
	C_M_AXI_AWUSER_WIDTH	=> C_M00_AXI_AWUSER_WIDTH,
	C_M_AXI_ARUSER_WIDTH	=> C_M00_AXI_ARUSER_WIDTH,
	C_M_AXI_WUSER_WIDTH	=> C_M00_AXI_WUSER_WIDTH,
	C_M_AXI_RUSER_WIDTH	=> C_M00_AXI_RUSER_WIDTH,
	C_M_AXI_BUSER_WIDTH	=> C_M00_AXI_BUSER_WIDTH
)
port map (
	-- Users to add ports here
	start_psolaf_o				=> start_psolaf_s,
	rnext_out_o					=> rnext_out_s,
	wnext_out_o					=> wnext_out_s,
	--Interfejs m memorije--------------------------------------------------------------------------------------
	--Port 1 interface
	p1_addr_m_top_i             => p1_addr_m_top_s,
	p1_wdata_m_top_i            => p1_wdata_m_top_s,
	p1_rdata_m_top_o            => p1_rdata_m_top_s,
	--p1_write_m_top_i            => p1_write_m_top_s,
	--Port 2 interface
	p2_addr_m_top_i             => p2_addr_m_top_s,
	p2_wdata_m_top_i            => p2_wdata_m_top_s,
	--p2_rdata_m_top_o            => p2_rdata_m_top_s,
	p2_write_m_top_i            => p2_write_m_top_s,
	num_of_elements_m_top_o     => num_of_elements_m_top_s,

	--Interfejs hanning memorije--------------------------------------------------------------------------------------
	rdata_cos_top_o              	=> rdata_cos_top_s,

	--Interfejs opseg memorije--------------------------------------------------------------------------------------
	--Port 1 interface
	--p1_addr_opseg_top_o            => p1_addr_opseg_top_s,
	p1_wdata_opseg_top_i           => p1_wdata_opseg_top_s,
	p1_rdata_opseg_top_o           => p1_rdata_opseg_top_s,
	--p1_write_opseg_top_o           => p1_write_opseg_top_s,
	num_of_elements_opseg_top_o    => num_of_elements_opseg_top_s,


	--Interfejs out memorije--------------------------------------------------------------------------------------
	--Port 1 interface
	--p1_addr_out_top_o           => p1_addr_out_top_s,
	--p1_wdata_out_top_o          => p1_wdata_out_top_s,
	p1_rdata_out_top_o          => p1_rdata_out_top_s,
	--p1_write_out_top_o          => p1_write_out_top_s,
	--Port 2 interface      
	--p2_addr_out_top_o           =>  p2_addr_out_top_s,           
	p2_wdata_out_top_i          =>  p2_wdata_out_top_s,          
	--p2_rdata_out_top_i          =>  p2_rdata_out_top_s,          
	--p2_write_out_top_o          =>  p2_write_out_top_s,          
	num_of_elements_out_top_o   =>  num_of_elements_out_top_s, 




	m_size_i					=> m_size_axi_s,
	erase_flag_i				=> erase_flag_top_s,
	num_of_m_i					=> num_of_m_top_s,
	reads_last_done_o			=> reads_last_done_s,
	ready_han_i					=> ready_han_s,
	pit_i						=> pit_top_s,
	place_i						=> place_top_s,
	place_enable_i 				=> place_enable_top_s,
	opseg_addr_valid_i			=> opseg_addr_valid_s,
	opseg_begin_i				=> opseg_begin_top_s,
	opseg_end_i					=> opseg_end_top_s,
	endGr_i						=> endGr_top_s,
	ready_interp1_i				=> ready_interp1_s,
	iniGr_i						=> iniGr_top_s,
	matk_valid_o				=> matk_valid_top_s,
	--ready_psolaf_i              => ready_s,
	--ready_psolaf_i              => ready_psolaf_s,
	ready_psolaf_i              => ready_psolaf_axi_s,
	reads_done_psolaf_o			=> reads_done_psolaf_top_s,
	end_flag_o					=> end_flag_s,

	mst_state_o					=> mst_state_tb_o,

	-- User ports ends
	INIT_AXI_TXN	=> m00_axi_init_axi_txn,
	TXN_DONE	=> m00_axi_txn_done,
	ERROR	=> m00_axi_error,
	M_AXI_ACLK	=> m00_axi_aclk,
	M_AXI_ARESETN	=> m00_axi_aresetn,
	M_AXI_AWID	=> m00_axi_awid,
	M_AXI_AWADDR	=> m00_axi_awaddr,
	M_AXI_AWLEN	=> m00_axi_awlen,
	M_AXI_AWSIZE	=> m00_axi_awsize,
	M_AXI_AWBURST	=> m00_axi_awburst,
	M_AXI_AWLOCK	=> m00_axi_awlock,
	M_AXI_AWCACHE	=> m00_axi_awcache,
	M_AXI_AWPROT	=> m00_axi_awprot,
	M_AXI_AWQOS	=> m00_axi_awqos,
	M_AXI_AWUSER	=> m00_axi_awuser,
	M_AXI_AWVALID	=> m00_axi_awvalid,
	M_AXI_AWREADY	=> m00_axi_awready,
	M_AXI_WDATA	=> m00_axi_wdata,
	M_AXI_WSTRB	=> m00_axi_wstrb,
	M_AXI_WLAST	=> m00_axi_wlast,
	M_AXI_WUSER	=> m00_axi_wuser,
	M_AXI_WVALID	=> m00_axi_wvalid,
	M_AXI_WREADY	=> m00_axi_wready,
	M_AXI_BID	=> m00_axi_bid,
	M_AXI_BRESP	=> m00_axi_bresp,
	M_AXI_BUSER	=> m00_axi_buser,
	M_AXI_BVALID	=> m00_axi_bvalid,
	--M_AXI_BREADY	=> m00_axi_bready,
	M_AXI_BREADY	=> m00_axi_bready_s,
	M_AXI_ARID	=> m00_axi_arid,
	M_AXI_ARADDR	=> m00_axi_araddr,
	M_AXI_ARLEN	=> m00_axi_arlen,
	M_AXI_ARSIZE	=> m00_axi_arsize,
	M_AXI_ARBURST	=> m00_axi_arburst,
	M_AXI_ARLOCK	=> m00_axi_arlock,
	M_AXI_ARCACHE	=> m00_axi_arcache,
	M_AXI_ARPROT	=> m00_axi_arprot,
	M_AXI_ARQOS	=> m00_axi_arqos,
	M_AXI_ARUSER	=> m00_axi_aruser,
	M_AXI_ARVALID	=> m00_axi_arvalid,
	M_AXI_ARREADY	=> m00_axi_arready,
	M_AXI_RID	=> m00_axi_rid,
	M_AXI_RDATA	=> m00_axi_rdata,
	M_AXI_RRESP	=> m00_axi_rresp,
	M_AXI_RLAST	=> m00_axi_rlast,
	M_AXI_RUSER	=> m00_axi_ruser,
	M_AXI_RVALID	=> m00_axi_rvalid,
	M_AXI_RREADY	=> m00_axi_rready_s
);


    -- Add user logic here

	m00_axi_rready <= m00_axi_rready_s;
	m00_axi_bready <= m00_axi_bready_s;

	reset_s <= not s00_axi_aresetn;

	--Memory subsytem
	memory_subststem: entity work.mem_subsystem(Behavioral)
	generic map(
		ADDR_W  				=> ADDR_W,
		C_M_AXI_ADDR_WIDTH	    => C_M00_AXI_ADDR_WIDTH,
		--OPSEG memorija
		SIZE_OPSEG_TOP			=> SIZE_OPSEG_TOP,
		W_HIGH_OPSEG_ADDR_TOP	=> W_HIGH_OPSEG_ADDR_TOP,
		W_HIGH_OPSEG_TOP		=> W_HIGH_OPSEG_TOP,
		W_LOW_OPSEG_TOP			=> W_LOW_OPSEG_TOP,
		--M memorija
		SIZE_M_TOP				=> SIZE_M_TOP,
		SIZE_ADDR_W_M			=> SIZE_ADDR_W_M,
		W_HIGH_M_TOP			=> W_HIGH_M_TOP,
		W_LOW_M_TOP				=> W_LOW_M_TOP,
		--OUT memorija
		SIZE_OUT_TOP			=> SIZE_OUT_TOP,
		SIZE_ADDR_W_OUT			=> SIZE_ADDR_W_OUT,
		W_HIGH_OUT_TOP			=> W_HIGH_OUT_TOP,
		W_LOW_OUT_TOP			=> W_LOW_OUT_TOP,
        --PAR1 memorija
        SIZE_PAR1              => SIZE_PAR1_c,
        W_HIGH_PAR1            => W_HIGH_PAR1_c,
        W_LOW_PAR1             => W_LOW_PAR1_c,
		--GR memorija
		SIZE_GR						=> SIZE_GR_c,
		W_HIGH_GR					=> W_HIGH_GR_c,
		W_LOW_GR					=> W_LOW_GR_c,
		--W memorija
		SIZE_W						=> SIZE_W_c,
		W_HIGH_W					=> W_HIGH_W_c,
		W_LOW_W						=> W_LOW_W_c

	)
	port map(
		clk				=> s00_axi_aclk,
		reset			=> reset_s,
		--Interface to the AXI controllers
		abg_i			=> abg_s,
		in_size_top_i	=> in_size_top_s,
		m_size_top_i	=> m_size_top_s,
		alpha_wr_i		=> alpha_wr_s,
		beta_wr_i		=> beta_wr_s,
		gamma_wr_i		=> gamma_wr_s,
		gamma_rec_wr_i		=> gamma_rec_wr_s,
		in_size_wr_i	=> in_size_wr_s,
		m_size_wr_i		=> m_size_wr_s,
		ready_han_top_i => ready_han_s,
		ready_wr_top_i	=> ready_han_wr_s,
		ready_psolaf_top_i => ready_psolaf_s,
		ready_psolaf_wr_top_i => ready_psolaf_wr_s,

		
		alpha_axi_o		=> alpha_axi_s,
		beta_axi_o		=> beta_axi_s,
		gamma_axi_o		=> gamma_axi_s,
		gamma_rec_axi_o		=> gamma_rec_axi_s,
		in_size_axi_o	=> in_size_axi_s, 
		m_size_axi_o	=> m_size_axi_s,
		ready_han_axi_o	=> ready_han_axi_s,
		ready_psolaf_axi_o => ready_psolaf_axi_s,

		--Interface to the psolaf module
		alpha_o				 => alpha_s,
		beta_o				 => beta_s,
		gamma_o				 => gamma_s,
		gamma_rec_o			 => gamma_rec_s,
		in_size_o			 => in_size_s,
		
		
        --Interfejs par 1 memorije-----------------------------------------------------------------------------------
		itp_sel_i          => itp_sel_s, 
        reset_par1_i       => reset_par1_s, 
		--Port 1 interface
        p1_addr_par1_i     => p1_addr_par1_s,
        p1_wdata_par1_i    => p1_wdata_par1_s,
        p1_rdata_par1_o    => p1_rdata_par1_s,
        p1_write_par1_i    => p1_write_par1_s,
        --Port 2 interface
        p2_addr_par1_i     => p2_addr_par1_s,
        p2_wdata_par1_i    => p2_wdata_par1_s,
        p2_rdata_par1_o    => p2_rdata_par1_s,
        p2_write_par1_i    => p2_write_par1_s,
        --Port 3 interface
        p3_addr_par1_i     => p3_addr_par1_s,
        p3_wdata_par1_i    => p3_wdata_par1_s,
        p3_rdata_par1_o    => p3_rdata_par1_s,
        p3_write_par1_i    => p3_write_par1_s,
        --Port 4 interface
        p4_addr_par1_i     => p4_addr_par1_s,		
        p4_wdata_par1_i    => p4_wdata_par1_s,		
        p4_rdata_par1_o    => p4_rdata_par1_s,		
        p4_write_par1_i    => p4_write_par1_s,		
        num_of_elements_par1_o  => num_of_elements_par1_i_s,      
		

		--Interfejs gr memorije-----------------------------------------------------------------------------------
		reset_gr_i       	=> reset_gr_s,
		--Port 1 interface
		p1_addr_gr_i  		=> p1_addr_gr_s,   
		p1_wdata_gr_i  		=> p1_wdata_gr_s,  
		p1_rdata_gr_o  		=> p1_rdata_gr_s,  
		p1_write_gr_i  		=> p1_write_gr_s,  
		--Port 2 interface
		p2_addr_gr_i		=> p2_addr_gr_s,     
		p2_wdata_gr_i		=> p2_wdata_gr_s,    
		p2_rdata_gr_o		=> p2_rdata_gr_s,    
		p2_write_gr_i		=> p2_write_gr_s,    
		--Port 3 interface
		p3_addr_gr_i		=> p3_addr_gr_s,     
		p3_wdata_gr_i		=> p3_wdata_gr_s,    
		p3_rdata_gr_o		=> p3_rdata_gr_s,    
		p3_write_gr_i		=> p3_write_gr_s,    
		num_of_elements_gr_o	=> num_of_elements_gr_s, 

		--Interfejs w memorije-----------------------------------------------------------------------------------
		han_sel_i			=> han_sel_s,
		reset_w_i       	=> reset_w_s,
		--Port 1 interface
		p1_addr_w_i  		=> p1_addr_w_s,   
		p1_wdata_w_i  		=> p1_wdata_w_s,  
		p1_rdata_w_o  		=> p1_rdata_w_s,  
		p1_write_w_i  		=> p1_write_w_s,  
		--Port 2 interface
		p2_addr_w_i			=> p2_addr_w_s,     
		p2_wdata_w_i		=> p2_wdata_w_s,    
		p2_rdata_w_o		=> p2_rdata_w_s,    
		p2_write_w_i		=> p2_write_w_s,    
		--Port 3 interface
		p3_addr_w_i			=> p3_addr_w_s,     
		p3_wdata_w_i		=> p3_wdata_w_s,    
		p3_rdata_w_o		=> p3_rdata_w_s,    
		p3_write_w_i		=> p3_write_w_s,    
		num_of_elements_w_o	=> num_of_elements_w_s 
		);

		psolaf_top:  entity work.psolaf_top(Behavioral)
		generic map(
			--ADDR WIDTH
			SIZE_ADDR_W                => ADDR_W,
			--IN memorija
			SIZE_OPSEG_TOP             => SIZE_OPSEG_TOP,
			W_HIGH_OPSEG_TOP           => W_HIGH_OPSEG_TOP,
			W_LOW_OPSEG_TOP            => W_LOW_OPSEG_TOP,
			--M memorija
			SIZE_M_TOP                 => SIZE_M_TOP,
			W_HIGH_M_TOP               => W_HIGH_M_TOP,
			W_LOW_M_TOP                => W_LOW_M_TOP,
			--OUT memorija
			SIZE_OUT_TOP               => SIZE_OUT_TOP,
			W_HIGH_OUT_TOP             => W_HIGH_OUT_TOP,
			W_LOW_OUT_TOP              => W_LOW_OUT_TOP, 
			--PAR1 memorija
			SIZE_PAR1_TOP			   => SIZE_PAR1_c,
			W_HIGH_PAR1_TOP			   => W_HIGH_PAR1_c,
			W_LOW_PAR1_TOP			   => W_LOW_PAR1_c,
			--GR memorija
			SIZE_GR_TOP               => SIZE_GR_c,
			W_HIGH_GR_TOP             => W_HIGH_GR_c,
			W_LOW_GR_TOP  			  => W_LOW_GR_c,
			--W memorija
			SIZE_W_TOP               => SIZE_W_c,
			W_HIGH_W_TOP             => W_HIGH_W_c,
			W_LOW_W_TOP  			  => W_LOW_W_c,
			--HAN memorija
			W_HAN_TOP                 => W_HAN_c
		)
		port map(
			clk_top                    => s00_axi_aclk, 
			reset_top                  => reset_s, 
	
			--Interface to the mem_subsytem
			alpha_top_i                     => alpha_s, 
			beta_top_i                      => beta_s, 
			gamma_top_i                     => gamma_s, 
			gamma_rec_top_i					=> gamma_rec_s,
			in_size_top_i                   => in_size_s,
			start_top_i                     => start_psolaf_s,
			--ready_top_o                     => ready_s,
			ready_top_o                     => ready_psolaf_s,
			erase_flag_top_o				=> erase_flag_top_s,
			num_of_m_top_o					=> num_of_m_top_s,

			--start_addr_in_read_top_o        => start_addr_in_read_s, 
			
			opseg_addr_valid_top_o          => opseg_addr_valid_s,
			pit_top_o						=> pit_top_s,
			place_top_o						=> place_top_s,
			place_enable_top_o				=> place_enable_top_s,
			opseg_begin_top_o				=> opseg_begin_top_s,
			opseg_end_top_o					=> opseg_end_top_s,
			endGr_top_o						=> endGr_top_s,
			iniGr_top_o						=> iniGr_top_s,
			matk_valid_top_i				=> matk_valid_top_s,
			reads_done_psolaf_top_i			=> reads_done_psolaf_top_s,
			


			--protovi za axi master
			axi_rnext_out_top_i					=> rnext_out_s,
			axi_wnext_out_top_i					=> wnext_out_s,
			axi_rready_top_i               	=> m00_axi_rready_s,
			axi_rvalid_top_i   				=> m00_axi_rvalid,
			axi_bready_top_i               	=> m00_axi_bready_s,
			axi_bvalid_top_i   				=> m00_axi_bvalid,
			ready_han_o                     => ready_han_s,
			reads_last_done_top_i			=> reads_last_done_s,
			ready_interp1_o					=> ready_interp1_s,
			ready_han_wr_top_o				=> ready_han_wr_s,
			ready_psolaf_wr_top_o			=> ready_psolaf_wr_s,
			--ready_psolaf_top_o				=> ready_psolaf_s,

			--Interfejs hanning memorije--------------------------------------------------------------------------------------
			rdata_cos_top_i 				=> rdata_cos_top_s,

			--Interfejs opseg memorije--------------------------------------------------------------------------------------
			--Port 1 interface
			p1_addr_opseg_top_o            => p1_addr_opseg_top_s,
			p1_wdata_opseg_top_o           => p1_wdata_opseg_top_s,
			p1_rdata_opseg_top_i           => p1_rdata_opseg_top_s,
			p1_write_opseg_top_o           => p1_write_opseg_top_s,
			num_of_elements_opseg_top_i    => num_of_elements_opseg_top_s,
	
			--Interfejs m memorije--------------------------------------------------------------------------------------
			--Port 1 interface
			p1_addr_m_top_o             => p1_addr_m_top_s,
			p1_wdata_m_top_o            => p1_wdata_m_top_s,
			p1_rdata_m_top_i            => p1_rdata_m_top_s,
			p1_write_m_top_o            => p1_write_m_top_s,
			--Port 2 interface
			p2_addr_m_top_o             => p2_addr_m_top_s,
			p2_wdata_m_top_o            => p2_wdata_m_top_s,
			p2_rdata_m_top_i            => p2_rdata_m_top_s,
			p2_write_m_top_o            => p2_write_m_top_s,
			num_of_elements_m_top_i     => m_size_axi_s,

			--Interfejs out memorije--------------------------------------------------------------------------------------
			--Port 1 interface
			p1_addr_out_top_o           => p1_addr_out_top_s,
			p1_wdata_out_top_o          => p1_wdata_out_top_s,
			p1_rdata_out_top_i          => p1_rdata_out_top_s,
			p1_write_out_top_o          => p1_write_out_top_s,
			--Port 2 interface      
			p2_addr_out_top_o           =>  p2_addr_out_top_s,           
			p2_wdata_out_top_o          =>  p2_wdata_out_top_s,          
			p2_rdata_out_top_i          =>  p2_rdata_out_top_s,          
			p2_write_out_top_o          =>  p2_write_out_top_s,          
			num_of_elements_out_top_i   =>  num_of_elements_out_top_s,
			
			--Interfejs par 1 memorije-----------------------------------------------------------------------------------
			itp_sel_top_o          => itp_sel_s, 
        	reset_par1_o       => reset_par1_s, 
			--Port 1 interface
        	p1_addr_par1_top_o     => p1_addr_par1_s,
        	p1_wdata_par1_top_o    => p1_wdata_par1_s,
        	p1_rdata_par1_top_i    => p1_rdata_par1_s,
        	p1_write_par1_top_o    => p1_write_par1_s,
        	--Port 2 interface
        	p2_addr_par1_top_o     => p2_addr_par1_s,
        	p2_wdata_par1_top_o    => p2_wdata_par1_s,
        	p2_rdata_par1_top_i    => p2_rdata_par1_s,
        	p2_write_par1_top_o    => p2_write_par1_s,
        	--Port 3 interface
        	p3_addr_par1_top_o     => p3_addr_par1_s,
        	p3_wdata_par1_top_o    => p3_wdata_par1_s,
        	p3_rdata_par1_top_i    => p3_rdata_par1_s,
        	p3_write_par1_top_o    => p3_write_par1_s,
        	--Port 4 interface
        	p4_addr_par1_top_o     => p4_addr_par1_s,		
        	p4_wdata_par1_top_o    => p4_wdata_par1_s,		
        	p4_rdata_par1_top_i    => p4_rdata_par1_s,		
        	p4_write_par1_top_o    => p4_write_par1_s,		
        	num_of_elements_par1_top_i  => num_of_elements_par1_i_s,   
		
			--Interfejs gr memorije-----------------------------------------------------------------------------------
			reset_gr_top_o       => reset_gr_s,
			--Port 1 interface
			p1_addr_gr_top_o  		=> p1_addr_gr_s,   
			p1_wdata_gr_top_o  		=> p1_wdata_gr_s,  
			p1_rdata_gr_top_i  		=> p1_rdata_gr_s,  
			p1_write_gr_top_o  		=> p1_write_gr_s,  
			--Port 2 interface
			p2_addr_gr_top_o		=> p2_addr_gr_s,     
			p2_wdata_gr_top_o		=> p2_wdata_gr_s,    
			p2_rdata_gr_top_i		=> p2_rdata_gr_s,    
			p2_write_gr_top_o		=> p2_write_gr_s,    
			--Port 3 interface
			p3_addr_gr_top_o		=> p3_addr_gr_s,     
			p3_wdata_gr_top_o		=> p3_wdata_gr_s,    
			p3_rdata_gr_top_i		=> p3_rdata_gr_s,    
			p3_write_gr_top_o		=> p3_write_gr_s,    
			num_of_elements_gr_top_i	=> num_of_elements_gr_s, 

			--Interfejs han memorije-----------------------------------------------------------------------------------
			han_sel_top_o			=> han_sel_s,
			reset_w_top_o       	=> reset_w_s,
			--Port 1 interface
			p1_addr_w_top_o  		=> p1_addr_w_s,   
			p1_wdata_w_top_o  		=> p1_wdata_w_s,  
			p1_rdata_w_top_i  		=> p1_rdata_w_s,  
			p1_write_w_top_o  		=> p1_write_w_s,  
			--Port 2 interface
			p2_addr_w_top_o			=> p2_addr_w_s,     
			p2_wdata_w_top_o		=> p2_wdata_w_s,    
			p2_rdata_w_top_i		=> p2_rdata_w_s,    
			p2_write_w_top_o		=> p2_write_w_s,    
			--Port 3 interface
			p3_addr_w_top_o			=> p3_addr_w_s,     
			p3_wdata_w_top_o		=> p3_wdata_w_s,    
			p3_rdata_w_top_i		=> p3_rdata_w_s,    
			p3_write_w_top_o		=> p3_write_w_s,    
			num_of_elements_w_top_i	=> num_of_elements_w_s,
			
			state_top_o => state_s
		);

		state_tb_o <= state_s;

	-- User logic ends

end arch_imp;
