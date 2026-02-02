----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2021 07:54:39 PM
-- Design Name: 
-- Module Name: psolaf_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
use STD.textio.all;
use ieee.std_logic_textio.all;
use work.utils_pkg.all;
library ieee_proposed;
use ieee_proposed.fixed_pkg.all;

use IEEE.math_real.all;

entity axi_psolaf_top_tb_TEST is
--  Port ( );
end axi_psolaf_top_tb_TEST;

architecture AXI_Behavioral of axi_psolaf_top_tb_TEST is
    constant SIZE_ADDR_W_c            : integer := 16;

    constant SIZE_OPSEG_TOP_c         : integer := 5000;   
    constant W_HIGH_OPSEG_TOP_c       : integer := 1;
    constant W_LOW_OPSEG_TOP_c        : integer := -25;
    
    constant SIZE_M_TOP_c             : integer := 5000;
    constant W_HIGH_M_TOP_c           : integer := 32;
    constant W_LOW_M_TOP_c            : integer := 0;

    --constant SIZE_OUT_TOP_c             : integer := 15000;
    constant SIZE_OUT_TOP_c             : integer := 70000;
    constant W_HIGH_OUT_TOP_c           : integer := 1;
    constant W_LOW_OUT_TOP_c            : integer := -31;

    --IN memorija
    constant SIZE_IN_c                : integer := 10000;
    constant W_HIGH_IN_c              : integer := 1;
    constant W_LOW_IN_c               : integer := -25;

    constant SIZE_HANNING_TOP_c             : integer := 5000;
    constant W_HIGH_HANNING_TOP_c           : integer := 1;
    constant W_LOW_HANNING_TOP_c            : integer := -31;


    --constant in_size_c             : std_logic_vector(W_HIGH_M_TOP_c - 1 downto 0) := std_logic_vector(to_unsigned(27753,W_HIGH_M_TOP_c));--yo
    constant in_size_c             : std_logic_vector(W_HIGH_M_TOP_c - 1 downto 0) := std_logic_vector(to_unsigned(28012,W_HIGH_M_TOP_c));--do_not_listen
    --constant in_size_c             : std_logic_vector(W_HIGH_M_TOP_c - 1 downto 0) := std_logic_vector(to_unsigned(83968,W_HIGH_M_TOP_c));--bond
    --constant in_size_c             : std_logic_vector(W_HIGH_M_TOP_c - 1 downto 0) := std_logic_vector(to_unsigned(46464,W_HIGH_M_TOP_c));--bullock_action


    --constant alpha_c               : sfixed(9 downto -22) := to_sfixed(0.8,9,-22);--bullock_action
    --constant beta_c                : sfixed(9 downto -22) := to_sfixed(1.4,9,-22);--bullock_action
    --constant gamma_c               : sfixed(9 downto -22) := to_sfixed(1.3,9,-22);--bullock_action

    --constant alpha_c               : sfixed(9 downto -22) := to_sfixed(0.7,9,-22);--bond_james_bond
    --constant beta_c                : sfixed(9 downto -22) := to_sfixed(0.9,9,-22);--bond_james_bond
    --constant gamma_c               : sfixed(9 downto -22) := to_sfixed(1.5,9,-22);--bond_james_bond

    --constant alpha_c               : sfixed(9 downto -22) := to_sfixed(0.8,9,-22);--yo
    --constant beta_c                : sfixed(9 downto -22) := to_sfixed(0.5,9,-22);--yo
    --constant gamma_c               : sfixed(9 downto -22) := to_sfixed(1.5,9,-22);--yo

    --constant alpha_c               : sfixed(9 downto -22) := to_sfixed(1.2,9,-22);--bullock_action22 DRUGO
    --constant beta_c                : sfixed(9 downto -22) := to_sfixed(0.6,9,-22);--bullock_action22
    --constant gamma_c               : sfixed(9 downto -22) := to_sfixed(1.4,9,-22);--bullock_action22

    --constant alpha_c               : sfixed(9 downto -22) := to_sfixed(1.3,9,-22);--do_not_listen
    --constant beta_c                : sfixed(9 downto -22) := to_sfixed(1.5,9,-22);--do_not_listen
    --constant gamma_c               : sfixed(9 downto -22) := to_sfixed(1.3,9,-22);--do_not_listen

    constant alpha_c               : sfixed(9 downto -22) := to_sfixed(1.6,9,-22);--do_not_listen DRUGO
    constant beta_c                : sfixed(9 downto -22) := to_sfixed(0.4,9,-22);--do_not_listen
    constant gamma_c               : sfixed(9 downto -22) := to_sfixed(1.8,9,-22);--do_not_listen

    --constant alpha_c               : sfixed(9 downto -22) := to_sfixed(0.8,9,-22);--do_not_listen TRI
    --constant beta_c                : sfixed(9 downto -22) := to_sfixed(1.5,9,-22);--do_not_listen
    --constant gamma_c               : sfixed(9 downto -22) := to_sfixed(1.3,9,-22);--do_not_listen

    --constant alpha_c               : sfixed(9 downto -22) := to_sfixed(0.8,9,-22);--do_not_listen TRI
    --constant beta_c                : sfixed(9 downto -22) := to_sfixed(1.5,9,-22);--do_not_listen
    --constant gamma_c               : sfixed(9 downto -22) := to_sfixed(1.3,9,-22);--do_not_listen

    --constant alpha_c               : sfixed(9 downto -22) := to_sfixed(0.5,9,-22);--do_not_listen CETIRI
    --constant beta_c                : sfixed(9 downto -22) := to_sfixed(0.6,9,-22);--do_not_listen
    --constant gamma_c               : sfixed(9 downto -22) := to_sfixed(1.3,9,-22);--do_not_listen

    --constant m_size_c              : integer := 196;--do_not_listen
    constant m_size_c              : integer := 233;--yo
    --constant m_size_c              : integer := 615;--bond_james_bond
    --constant m_size_c              : integer := 258;--bullock_action

    type mem_in_t is array(0 to to_integer(unsigned(in_size_c))) of sfixed(W_HIGH_OPSEG_TOP_c - 1 downto W_LOW_OPSEG_TOP_c);
    type mem_m_t is array(0 to SIZE_M_TOP_c) of std_logic_vector(W_HIGH_M_TOP_c - 1 downto W_LOW_M_TOP_c);
    type mem_opseg_t is array(0 to SIZE_OPSEG_TOP_c) of sfixed(W_HIGH_OPSEG_TOP_c - 1 downto W_LOW_OPSEG_TOP_c);
    type mem_hanning_t is array(0 to SIZE_HANNING_TOP_c) of sfixed(W_HIGH_HANNING_TOP_c - 1 downto W_LOW_HANNING_TOP_c);
    type mem_out_t is array(0 to SIZE_OUT_TOP_c) of sfixed(W_HIGH_OUT_TOP_c - 1 downto W_LOW_OUT_TOP_c);



    signal MEM_IN : mem_in_t := (others => (others => '0'));
    shared variable MEM_M : mem_m_t := (others => (others => '0'));
    signal MEM_OPSEG : mem_opseg_t := (others => (others => '0'));
    signal MEM_HAN : mem_hanning_t := (others => (others => '0'));
    shared variable MEM_OUT : mem_out_t := (others => (others => '0'));
    
    
    signal in_size_s                          : std_logic_vector(W_HIGH_M_TOP_c - 1 downto 0);
    

    --Psolaf core's address map
    constant ALPHA_REG_ADDR_C              : integer := 0;
    constant BETA_REG_ADDR_C               : integer := 4;
    constant GAMMA_REG_ADDR_C              : integer := 8;
    constant IN_SIZE_REG_ADDR_C            : integer := 12;
    constant M_SIZE_REG_ADDR_C             : integer := 16;
    constant START_REG_ADDR_C              : integer := 20;
    constant READY_REG_ADDR_C              : integer := 24;
    constant PIT_REG_ADDR_C                : integer := 28;
    constant PLACE_EN_ADDR_C               : integer := 32;
    constant HAN_READY_ADDR_C              : integer := 36;
    

    constant C_S00_AXI_DATA_WIDTH_c                 : integer := 32;
    constant C_S00_AXI_ADDR_WIDTH_c                 : integer := 6;

    ---------------AXI Interfaces signals---------------------------
    --Parameters of Axi-Full Master Bus Interface M00_AXI
     
    -- Base address of targeted slave
  
    constant C_M00_TARGET_SLAVE_BASE_ADDR_c	: std_logic_vector	:= x"00000";
    -- Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
    constant C_M00_AXI_BURST_LEN_c	: integer	:= 128;
    -- Thread ID Width
    constant C_M00_AXI_ID_WIDTH_c	: integer	:= 1;
    -- Width of Address Bus
    --constant C_M00_AXI_ADDR_WIDTH_c	: integer	:= 18;
    constant C_M00_AXI_ADDR_WIDTH_c	: integer	:= 32;
    -- Width of Data Bus
    constant C_M00_AXI_DATA_WIDTH_c	: integer	:= 32;
    -- Width of User Write Address Bus
    constant C_M00_AXI_AWUSER_WIDTH_c	: integer	:= 0;
    -- Width of User Read Address Bus
    constant C_M00_AXI_ARUSER_WIDTH_c	: integer	:= 0;
    -- Width of User Write Data Bus
    constant C_M00_AXI_WUSER_WIDTH_c	: integer	:= 0;
    -- Width of User Read Data Bus
    constant C_M00_AXI_RUSER_WIDTH_c	: integer	:= 0;
    -- Width of User Response Bus
    constant C_M00_AXI_BUSER_WIDTH_c	: integer	:= 0;

     -- Ports of Axi Slave Bus Interface S00_AXI
     signal s00_axi_aclk_s	    :  std_logic;
     signal s00_axi_aresetn_s	:  std_logic;
     signal s00_axi_awaddr_s	    :  std_logic_vector(C_S00_AXI_ADDR_WIDTH_c -1 downto 0);
     signal s00_axi_awprot_s	    :  std_logic_vector(2 downto 0);
     signal s00_axi_awvalid_s	:  std_logic;
     signal s00_axi_awready_s	:  std_logic;
     signal s00_axi_wdata_s	    :  std_logic_vector(C_S00_AXI_DATA_WIDTH_c-1 downto 0);
     signal s00_axi_wstrb_s	    :  std_logic_vector((C_S00_AXI_DATA_WIDTH_c/8)-1 downto 0);
     signal s00_axi_wvalid_s	    :  std_logic;
     signal s00_axi_wready_s	    :  std_logic;
     signal s00_axi_bresp_s	    :  std_logic_vector(1 downto 0);
     signal s00_axi_bvalid_s	    :  std_logic;
     signal s00_axi_bready_s	    :  std_logic;
     signal s00_axi_araddr_s	    :  std_logic_vector(C_S00_AXI_ADDR_WIDTH_c-1 downto 0);
     signal s00_axi_arprot_s	    :  std_logic_vector(2 downto 0);
     signal s00_axi_arvalid_s	:  std_logic;
     signal s00_axi_arready_s	:  std_logic;
     signal s00_axi_rdata_s	    :  std_logic_vector(C_S00_AXI_DATA_WIDTH_c-1 downto 0);
     signal s00_axi_rresp_s	    :  std_logic_vector(1 downto 0);
     signal s00_axi_rvalid_s	    :  std_logic;
     signal s00_axi_rready_s	    :  std_logic;
 
     signal s00_busy_s           :  std_logic;
 
 
     --Ports of Axi_Full Master Bus Interface M00_AXI
     signal m00_init_axi_txn_s       : std_logic;
     signal m00_axi_txn_done_s       : std_logic;
     signal m00_axi_error_s              : std_logic;    
     signal m00_axi_aclk_s           : std_logic;
     signal m00_axi_aresetn_s        : std_logic;
     signal m00_axi_awid_s           : std_logic_vector(C_M00_AXI_ID_WIDTH_c - 1 downto 0) := (others => '0');
     signal m00_axi_awaddr_s         : std_logic_vector(C_M00_AXI_ADDR_WIDTH_c - 1 downto 0) := (others => '0');
     --signal m00_axi_awlen_s          : std_logic_vector(7 downto 0)  := (others => '0');
     signal m00_axi_awlen_s          : std_logic_vector(W_HIGH_M_TOP_c - 1 downto W_LOW_M_TOP_c)  := (others => '0'); 
 
     signal m00_axi_awsize_s         : std_logic_vector(2 downto 0)  := (others => '0');
     signal m00_axi_awburst_s        : std_logic_vector(1 downto 0)  := (others => '0');
     signal m00_axi_awlock_s         : std_logic := '0';
     signal m00_axi_awcache_s        : std_logic_vector(3 downto 0)  := (others => '0');
     signal m00_axi_awprot_s         : std_logic_vector(2 downto 0)  := (others => '0');
     signal m00_axi_awqos_s        : std_logic_vector(3 downto 0)  := (others => '0');
     signal m00_axi_awregion_s        : std_logic_vector(3 downto 0)  := (others => '0');
     signal m00_axi_awuser_s        : std_logic_vector(C_M00_AXI_AWUSER_WIDTH_c - 1 downto 0)  := (others => '0');
     signal m00_axi_awvalid_s         : std_logic := '0';
     signal m00_axi_awready_s         : std_logic := '0';
     signal m00_axi_wdata_s        : std_logic_vector(C_M00_AXI_DATA_WIDTH_c - 1 downto 0)  := (others => '0');
     signal m00_axi_wstrb_s        : std_logic_vector((C_M00_AXI_DATA_WIDTH_c/8) - 1 downto 0)  := (others => '0');
     signal m00_axi_wlast_s         : std_logic := '0';
     signal m00_axi_wuser_s        : std_logic_vector(C_M00_AXI_WUSER_WIDTH_c - 1 downto 0)  := (others => '0');
     signal m00_axi_wvalid_s         : std_logic := '0';
     signal m00_axi_wready_s         : std_logic := '0';
     signal m00_axi_bid_s           : std_logic_vector(C_M00_AXI_ID_WIDTH_c - 1 downto 0) := (others => '0');
     signal m00_axi_bresp_s        : std_logic_vector(1 downto 0)  := (others => '0');
     signal m00_axi_buser_s           : std_logic_vector(C_M00_AXI_BUSER_WIDTH_c - 1 downto 0) := (others => '0');
     signal m00_axi_bvalid_s         : std_logic := '0';
     signal m00_axi_bready_s         : std_logic := '0';
     signal m00_axi_arid_s           : std_logic_vector(C_M00_AXI_ID_WIDTH_c - 1 downto 0) := (others => '0');
     signal m00_axi_araddr_s         : std_logic_vector(C_M00_AXI_ADDR_WIDTH_c - 1 downto 0);
     --signal m00_axi_arlen_s          : std_logic_vector(7 downto 0)  := (others => '0'); 
     signal m00_axi_arlen_s          : std_logic_vector(W_HIGH_M_TOP_c - 1 downto W_LOW_M_TOP_c)  := (others => '0'); 
     signal m00_axi_arsize_s         : std_logic_vector(2 downto 0)  := (others => '0');
     signal m00_axi_arburst_s        : std_logic_vector(1 downto 0)  := (others => '0');
     signal m00_axi_arlock_s         : std_logic := '0';
     signal m00_axi_arcache_s        : std_logic_vector(3 downto 0)  := (others => '0');
     signal m00_axi_arprot_s         : std_logic_vector(2 downto 0)  := (others => '0');
     signal m00_axi_arqos_s          : std_logic_vector(3 downto 0)  := (others => '0');
     signal m00_axi_arregion_s       : std_logic_vector(3 downto 0)  := (others => '0');
     signal m00_axi_aruser_s         : std_logic_vector(C_M00_AXI_AWUSER_WIDTH_c - 1 downto 0) := (others => '0');
     signal m00_axi_arvalid_s        : std_logic := '0';
     signal m00_axi_arready_s        : std_logic := '0';
     signal m00_axi_rid_s           : std_logic_vector(C_M00_AXI_ID_WIDTH_c - 1 downto 0) := (others => '0');
     signal m00_axi_rdata_s        : std_logic_vector(C_M00_AXI_DATA_WIDTH_c - 1 downto 0)  := (others => '0');
     signal m00_axi_rresp_s        : std_logic_vector(1 downto 0)  := (others => '0');
     signal m00_axi_rlast_s         : std_logic := '0';
     signal m00_axi_ruser_s        : std_logic_vector(C_M00_AXI_RUSER_WIDTH_c - 1 downto 0)  := (others => '0');
     signal m00_axi_rvalid_s         : std_logic := '0';
     signal m00_axi_rready_s         : std_logic := '0';


     constant ADDR_LSB		            : integer := (C_M00_AXI_DATA_WIDTH_c/32) + 1;
     --pomocni signali
     --adresni dekorder
     signal  en_code_s           : std_logic_vector(2-1 downto 0);
     signal  en_code_wr_s           : std_logic_vector(2-1 downto 0);

     signal mem_addr_s          : std_logic_vector(C_M00_AXI_ADDR_WIDTH_c - en_code_s'length - ((C_M00_AXI_DATA_WIDTH_c/32) + 1) - 1 downto 0);
     signal mem_addr_wr_s          : std_logic_vector(C_M00_AXI_ADDR_WIDTH_c - en_code_s'length - ((C_M00_AXI_DATA_WIDTH_c/32) + 1) - 1 downto 0);
     signal  en_a_s,en_b_s,en_c_s    : std_logic;

     signal cnt_s                           : unsigned(W_HIGH_M_TOP_c - 1 downto W_LOW_M_TOP_c)  := (others => '0'); 
     signal axi_arv_arr_flag                : std_logic;
     signal axi_awv_awr_flag                : std_logic;
     signal axi_arlen_cntr                  : std_logic_vector(W_HIGH_M_TOP_c - 1 downto W_LOW_M_TOP_c)  := (others => '0');
     signal tmp_m00_axi_araddr_s            : std_logic_vector(C_M00_AXI_ADDR_WIDTH_c - 1 downto 0) := (others => '0');
     signal axi_araddr_s                    : std_logic_vector(C_M00_AXI_ADDR_WIDTH_c - 1 downto 0) := (others => '0');
     signal addr_field_read_s	            : std_logic_vector(1 downto 0);
     signal axi_awlen_cntr                  : std_logic_vector(W_HIGH_M_TOP_c - 1 downto W_LOW_M_TOP_c)  := (others => '0');
     signal axi_awaddr_s                    : std_logic_vector(C_M00_AXI_ADDR_WIDTH_c - 1 downto 0) := (others => '0');
     signal axi_awready_s	                : std_logic;
     signal axi_wready_s	                : std_logic;
     signal axi_bresp_s	                    : std_logic_vector(1 downto 0);
     signal axi_bvalid_s	                : std_logic;
     signal axi_arready_s	                : std_logic;
     signal axi_rlast_s	                    : std_logic;
     signal axi_ruser_s	                    : std_logic_vector(C_M00_AXI_RUSER_WIDTH_c-1 downto 0);
     signal axi_rvalid_s	                : std_logic;
     signal axi_arburst                     : std_logic_vector(m00_axi_arburst_s'length-1 downto 0);
	 signal axi_awburst                     : std_logic_vector(m00_axi_awburst_s'length -1 downto 0);
     signal axi_arlen                       : std_logic_vector(m00_axi_arlen_s'length -1 downto 0);
	 signal axi_arlen_next,axi_arlen_reg    : std_logic_vector(m00_axi_arlen_s'length -1 downto 0);
     signal axi_awlen                       : std_logic_vector(m00_axi_awlen_s'length-1 downto 0);
     signal axi_awlen_next,axi_awrlen_reg                       : std_logic_vector(m00_axi_awlen_s'length-1 downto 0);
     signal  en_m_s,en_opseg_s,en_out_s,en_hanning_s             : std_logic;
     signal  en_w_m_s,en_w_opseg_s,en_w_out_s       : std_logic;
     signal  mem_wr_s                               :  std_logic;
    

    signal clk_s                            : std_logic;
    signal reset_s                          : std_logic;

    signal alpha_top_i_s                        : sfixed(22 downto -22);
    signal beta_top_i_s                         : sfixed(22 downto -22);
    signal gamma_top_i_s                        : sfixed(22 downto -22);
    signal in_size_top_i_s                      :  std_logic_vector(W_HIGH_M_TOP_c - 1 downto W_LOW_M_TOP_c);
    signal start_top_i_s                        :  std_logic;
    signal ready_top_o_s                        :  std_logic;
    signal start_addr_in_read_top_o_s           :  std_logic_vector(W_HIGH_M_TOP_c - 1 downto W_LOW_M_TOP_c);
    signal place_wr_top_o_s                     :  std_logic;
    signal pit_mem_sub_top_o_s                  :  signed(W_HIGH_M_TOP_c - 1 downto W_LOW_M_TOP_c);

    signal  i_opseg_begin,i_opseg_end       : unsigned(W_HIGH_M_TOP_c - 1 downto W_LOW_M_TOP_c);
    signal  enable_m                        : std_logic;

    signal  repetition_counter_s     : unsigned(W_HIGH_M_TOP_c - 1 downto W_LOW_M_TOP_c);

    signal  debugMEM_OUT_s     : sfixed(W_HIGH_OUT_TOP_c - 1 downto W_LOW_OUT_TOP_c);

    file     file_in                         :   text;
    file     file_prefix_in                  :   text;     
    file        file_OUT_in                  :   text;
    
    file     file_m                          :   text;
    file     file_prefix_m                   :   text;
    file     file_han_real_in                :   text;
    file     file_han_debug                :   text;


    signal  han_val_ready_s                 : std_logic := '0';

    --debug signals
    signal  han_val_sf_s,v_time_step_sf_s          : sfixed(W_HIGH_OUT_TOP_c - 1 downto W_LOW_OUT_TOP_c) := to_sfixed(0,W_HIGH_OUT_TOP_c -1,W_LOW_OUT_TOP_c);
    signal  axi_read_place_en_s         : std_logic_vector(31 downto 0);
    signal  axi_read_pit_s,n_han_s,han_val_s         : unsigned(31 downto 0);
    signal  i_han_s         : unsigned(31 downto 0);
    signal  axi_read_hanning_ready_s         : std_logic_vector(31 downto 0);
    
        
begin

    axi_psolaf: entity work.psolaf_axi_v1_0(arch_imp) 
                generic map(
                    -- Users to add parameters here
                    ADDR_W                      => SIZE_ADDR_W_c, 
                    --IN memorija 
                    SIZE_IN_TOP                 => SIZE_IN_c,
                    W_HIGH_IN_TOP               => W_HIGH_IN_c,
                    W_LOW_IN_TOP                => W_LOW_IN_c,
                    --OPSEG memorija
                    SIZE_OPSEG_TOP              => SIZE_OPSEG_TOP_c,
                    W_HIGH_OPSEG_ADDR_TOP       => SIZE_ADDR_W_c,
                    W_HIGH_OPSEG_TOP            => W_HIGH_OPSEG_TOP_c,
                    W_LOW_OPSEG_TOP             => W_LOW_OPSEG_TOP_c,
                    --M memorija
                    SIZE_M_TOP                 => SIZE_M_TOP_c,
                    SIZE_ADDR_W_M              => SIZE_ADDR_W_c,
                    W_HIGH_M_TOP               => W_HIGH_M_TOP_c,
                    W_LOW_M_TOP                => W_LOW_M_TOP_c,
                    --OUT memorija
                    SIZE_OUT_TOP               => SIZE_OUT_TOP_c,
                    SIZE_ADDR_W_OUT            => SIZE_ADDR_W_c,
                    W_HIGH_OUT_TOP             => W_HIGH_OUT_TOP_c,
                    W_LOW_OUT_TOP              => W_LOW_OUT_TOP_c, 
                    
                    -- User parameters ends
                    -- Do not modify the parameters beyond this line
            
            
                    -- Parameters of Axi Slave Bus Interface S00_AXI
                    C_S00_AXI_DATA_WIDTH	        => C_S00_AXI_DATA_WIDTH_c,
                    C_S00_AXI_ADDR_WIDTH	        => C_S00_AXI_ADDR_WIDTH_c,
            
                    -- Parameters of Axi Master Bus Interface M00_AXI
                    C_M00_AXI_TARGET_SLAVE_BASE_ADDR	=> C_M00_TARGET_SLAVE_BASE_ADDR_c,
                    C_M00_AXI_BURST_LEN	                => C_M00_AXI_BURST_LEN_c,
                    C_M00_AXI_ID_WIDTH	                => C_M00_AXI_ID_WIDTH_c,
                    C_M00_AXI_ADDR_WIDTH	            => C_M00_AXI_ADDR_WIDTH_c,
                    C_M00_AXI_DATA_WIDTH	            => C_M00_AXI_DATA_WIDTH_c,
                    C_M00_AXI_AWUSER_WIDTH	            => C_M00_AXI_AWUSER_WIDTH_c,
                    C_M00_AXI_ARUSER_WIDTH	            => C_M00_AXI_ARUSER_WIDTH_c,
                    C_M00_AXI_WUSER_WIDTH	            => C_M00_AXI_WUSER_WIDTH_c,
                    C_M00_AXI_RUSER_WIDTH	            => C_M00_AXI_RUSER_WIDTH_c,
                    C_M00_AXI_BUSER_WIDTH	            => C_M00_AXI_BUSER_WIDTH_c)
                port map(
                    -- Users to add ports here
            
                    -- User ports ends
                    -- Do not modify the ports beyond this line
            
            
                    -- Ports of Axi Slave Bus Interface S00_AXI
                    s00_axi_aclk	=> clk_s,
                    s00_axi_aresetn	=> s00_axi_aresetn_s,
                    s00_axi_awaddr	=> s00_axi_awaddr_s,
                    s00_axi_awprot	=> s00_axi_awprot_s,
                    s00_axi_awvalid	=> s00_axi_awvalid_s,
                    s00_axi_awready	=> s00_axi_awready_s,
                    s00_axi_wdata	=> s00_axi_wdata_s,
                    s00_axi_wstrb	=> s00_axi_wstrb_s,
                    s00_axi_wvalid	=> s00_axi_wvalid_s,
                    s00_axi_wready	=> s00_axi_wready_s,
                    s00_axi_bresp	=> s00_axi_bresp_s,
                    s00_axi_bvalid	=> s00_axi_bvalid_s,
                    s00_axi_bready	=> s00_axi_bready_s,
                    s00_axi_araddr	=> s00_axi_araddr_s, 
                    s00_axi_arprot	=> s00_axi_arprot_s,
                    s00_axi_arvalid => s00_axi_arvalid_s,	
                    s00_axi_arready	=> s00_axi_arready_s,
                    s00_axi_rdata	=> s00_axi_rdata_s,
                    s00_axi_rresp	=> s00_axi_rresp_s,
                    s00_axi_rvalid	=> s00_axi_rvalid_s,
                    s00_axi_rready	=> s00_axi_rready_s,
            
                    -- Ports of Axi Master Bus Interface M00_AXI
                    m00_axi_init_axi_txn    => m00_init_axi_txn_s,	
                    m00_axi_txn_done	    => m00_axi_txn_done_s,
                    m00_axi_error           => m00_axi_error_s,	
                    m00_axi_aclk	        => clk_s,
                    m00_axi_aresetn	        => m00_axi_aresetn_s,
                    m00_axi_awid	        => m00_axi_awid_s,
                    m00_axi_awaddr	        => m00_axi_awaddr_s,
                    m00_axi_awlen	        => m00_axi_awlen_s,
                    m00_axi_awsize	        => m00_axi_awsize_s,
                    m00_axi_awburst         => m00_axi_awburst_s,	
                    m00_axi_awlock          => m00_axi_awlock_s,	
                    m00_axi_awcache         => m00_axi_awcache_s,	
                    m00_axi_awprot          => m00_axi_awprot_s,	
                    m00_axi_awqos	        => m00_axi_awqos_s,
                    m00_axi_awuser          => m00_axi_awuser_s,	
                    m00_axi_awvalid	        => m00_axi_awvalid_s,
                    m00_axi_awready         => m00_axi_awready_s,	
                    m00_axi_wdata           => m00_axi_wdata_s,	
                    m00_axi_wstrb           => m00_axi_wstrb_s,	
                    m00_axi_wlast           => m00_axi_wlast_s,	
                    m00_axi_wuser           => m00_axi_wuser_s,	
                    m00_axi_wvalid          => m00_axi_wvalid_s,	
                    m00_axi_wready	        => m00_axi_wready_s,
                    m00_axi_bid             => m00_axi_bid_s,	
                    m00_axi_bresp           => m00_axi_bresp_s,	
                    m00_axi_buser           => m00_axi_buser_s,	
                    m00_axi_bvalid          => m00_axi_bvalid_s,	
                    m00_axi_bready          => m00_axi_bready_s,	
                    m00_axi_arid            => m00_axi_arid_s,	
                    m00_axi_araddr	        => m00_axi_araddr_s,
                    m00_axi_arlen           => m00_axi_arlen_s,	
                    m00_axi_arsize	        => m00_axi_arsize_s,
                    m00_axi_arburst         => m00_axi_arburst_s,	
                    m00_axi_arlock          => m00_axi_arlock_s,	
                    m00_axi_arcache         => m00_axi_arcache_s,	
                    m00_axi_arprot          => m00_axi_arprot_s,	
                    m00_axi_arqos           => m00_axi_arqos_s,	
                    m00_axi_aruser          => m00_axi_aruser_s,	
                    m00_axi_arvalid         => m00_axi_arvalid_s,	
                    m00_axi_arready         => m00_axi_arready_s,	
                    m00_axi_rid             => m00_axi_rid_s,	
                    m00_axi_rdata           => m00_axi_rdata_s,	 
                    m00_axi_rresp           => m00_axi_rresp_s,	  
                    m00_axi_rlast           => m00_axi_rlast_s,	 
                    m00_axi_ruser           => m00_axi_ruser_s,	  
                    m00_axi_rvalid          => m00_axi_rvalid_s,	 
                    m00_axi_rready          => m00_axi_rready_s);

    clk_gen: process
    begin
       clk_s <= '0','1' after 100 ns;
       wait for 200 ns;
    end process;





    -- I/O Connections assignments

	m00_axi_awready_s	<= axi_awready_s;
	m00_axi_wready_s	<= axi_wready_s;
	m00_axi_bresp_s	<= axi_bresp_s;
	m00_axi_bvalid_s	<= axi_bvalid_s;
	m00_axi_rlast_s	<= axi_rlast_s;
	m00_axi_ruser_s	<= axi_ruser_s;
	m00_axi_rvalid_s	<= axi_rvalid_s;

        --Implement m00_axi_arready generation
        process(clk_s)
        begin
                if(clk_s'event and clk_s = '1')then
                    if(m00_axi_aresetn_s = '0') then
                        m00_axi_arready_s <=  '0';
                        axi_arv_arr_flag <= '0';
                    else
                        if(m00_axi_arready_s = '0' and m00_axi_arvalid_s = '1' and axi_arv_arr_flag = '0') then
                            m00_axi_arready_s <= '1';
                            axi_arv_arr_flag <= '1';
                        elsif(axi_rvalid_s = '1' and m00_axi_rready_s = '1' and (axi_arlen_cntr = m00_axi_arlen_s))then
                            --preparing to accept next address after current read completion
                            axi_arv_arr_flag <= '0';
                        else
                            m00_axi_arready_s <= '0';
                        
                        end if;
                    end if;
                end if;
        end process;
    

    --Implement axi_araddr latching
    --This process is used to latch the address when both M_AXI_ARVALID and M_AXI_RVALID are valid
    process(clk_s)
        variable v_m00_axi_arburst          : std_logic_vector(m00_axi_arburst_s'length - 1 downto 0);
        variable v_m00_axi_arlen            : std_logic_vector(m00_axi_arlen_s'length - 1 downto 0);

    begin

        --default assignments
        
        if (clk_s'event and clk_s = '1') then
            if(m00_axi_aresetn_s = '0') then

                axi_arlen_cntr <= (others => '0');
                axi_arburst <= (others => '0');
                axi_arlen <= (others => '0'); 
                axi_rlast_s <= '0';
                axi_ruser_s <= (others => '0');

                axi_arlen_next <= (others => '0');
            else
                if(m00_axi_arready_s = '0' and m00_axi_arvalid_s = '1' and axi_arv_arr_flag = '0')then
                    --address latching
                    --start address of transfer
                    axi_araddr_s <= m00_axi_araddr_s(C_M00_AXI_ADDR_WIDTH_c - 1 downto 0);
                    axi_arlen_cntr <= (others => '0');
                    axi_rlast_s <= '0';
                    axi_arburst <= m00_axi_arburst_s;
                    axi_arlen_next <= m00_axi_arlen_s;

                -- kada je axi_arlen nece da radi, kada se zameni axi_arlen sa m00_axi_arlen_s uvecava adresu...
                elsif((axi_arlen_cntr <= axi_arlen_next) and axi_rvalid_s = '1' and m00_axi_rready_s = '1') then
                    axi_arlen_cntr <= std_logic_vector(unsigned(axi_arlen_cntr) + 1);
                    axi_rlast_s <= '0';

                    case(axi_arburst) is
                        when "01" =>
                        --incremental burst
                        --The read address for all the beats in the transcation are increments by awsize
                        axi_araddr_s(C_M00_AXI_ADDR_WIDTH_c - 1 downto ADDR_LSB) <= std_logic_vector(unsigned(axi_araddr_s(C_M00_AXI_ADDR_WIDTH_c - 1 downto ADDR_LSB)) + 1); --araddr aligned to 4 byte boundary
                        axi_araddr_s(ADDR_LSB - 1 downto 0) <= (others => '0'); --for arsize = 4 bytes (010)
                        when others => 
                            report "ERROR WRONG BURST CODE!!!!!!!!!";
                    end case;


                elsif((axi_arlen_cntr = m00_axi_arlen_s) and m00_axi_rlast_s = '0' and axi_arv_arr_flag = '1') then
                    axi_rlast_s <= '1';
                elsif (m00_axi_rready_s = '1') then
                    axi_rlast_s <= '0';
                end if;
            end if;
        end if;
    end process;

    --Implement axi_rvalid
    process(clk_s)
    begin
        if(clk_s'event and clk_s = '1')then
            if(m00_axi_aresetn_s = '0')then
                axi_rvalid_s <= '0';
                m00_axi_rresp_s <= "00";
            else
                if(axi_arv_arr_flag = '1' and axi_rvalid_s = '0')then
                    axi_rvalid_s <= '1';
                    m00_axi_rresp_s <= "00"; --OKAY response
                elsif(axi_rvalid_s = '1' and m00_axi_rready_s = '1')then
                    axi_rvalid_s <= '0';
                end if;
            end if;
        end if;
    end process;

    --Implement axi_awready
    process (clk_s)
    begin
        if(clk_s'event and clk_s = '1')Then
            if(m00_axi_aresetn_s = '0') then
                axi_awready_s <= '0';
                axi_awv_awr_flag <= '0';
            else
                if(axi_awready_s = '0' and m00_axi_awvalid_s = '1' and axi_awv_awr_flag = '0')then
                    --slave is ready to accept an address and assiciated control signals
                    axi_awv_awr_flag <= '1';--used for generation of bresp and bvalid
                    axi_awready_s <= '1';
                elsif(m00_axi_wlast_s = '1' and axi_wready_s = '1')then
                    --preparing to accept next address after current write burst tx completion
                    axi_awv_awr_flag <= '0';
                else
                    axi_awready_s <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Implement axi_awaddr latching

	-- This process is used to latch the address when both 
	-- S_AXI_AWVALID and S_AXI_WVALID are valid. 

	process (clk_s)
        --variable v_m00_axi_awburst          : std_logic_vector(m00_axi_arburst_s'length - 1 downto 0);
        variable v_m00_axi_awlen           : std_logic_vector(m00_axi_awlen_s'length - 1 downto 0);
	begin
	  if rising_edge(clk_s) then 
	    if m00_axi_aresetn_s = '0' then
            axi_awaddr_s <= (others => '0');
	        axi_awlen_cntr <= (others => '0');
            axi_awburst <= (others => '0'); 
	        axi_awlen <= (others => '0'); 
            axi_awlen_next <= (others => '0'); 
	    else
	      if (axi_awready_s = '0' and m00_axi_awvalid_s = '1' and axi_awv_awr_flag = '0') then
	      -- address latching 
            axi_awaddr_s <= m00_axi_awaddr_s(C_M00_AXI_ADDR_WIDTH_c - 1 downto 0);
            axi_awlen_cntr <= (others => '0');
            axi_awburst <= m00_axi_awburst_s;
            axi_awlen_next <= m00_axi_awlen_s;
          elsif((axi_awlen_cntr <= axi_awlen_next) and m00_axi_wready_s = '1' and m00_axi_wvalid_s = '1') then   
	        axi_awlen_cntr <= std_logic_vector (unsigned(axi_awlen_cntr) + 1);

	        case (axi_awburst) is

	          when "01" => --incremental burst
	            -- The write address for all the beats in the transaction are increments by awsize
	            axi_awaddr_s(C_M00_AXI_ADDR_WIDTH_c - 1 downto ADDR_LSB) <= std_logic_vector (unsigned(axi_awaddr_s(C_M00_AXI_ADDR_WIDTH_c - 1 downto ADDR_LSB)) + 1);--awaddr aligned to 4 byte boundary
	            axi_awaddr_s(ADDR_LSB-1 downto 0)  <= (others => '0');  ----for awsize = 4 bytes (010)

	          when others => --reserved (incremental burst for example)
	            axi_awaddr_s(C_M00_AXI_ADDR_WIDTH_c - 1 downto ADDR_LSB) <= std_logic_vector (unsigned(axi_awaddr_s(C_M00_AXI_ADDR_WIDTH_c - 1 downto ADDR_LSB)) + 1);--for awsize = 4 bytes (010)
	            axi_awaddr_s(ADDR_LSB-1 downto 0)  <= (others => '0');
	        end case;        
	      end if;
	    end if;
	  end if;
	end process;

    -- Implement axi_wready generation

	-- axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	-- de-asserted when reset is low. 

	process (clk_s)
	begin
	  if rising_edge(clk_s) then 
	    if m00_axi_aresetn_s = '0' then
            axi_wready_s <= '0';
	    else
	      if (axi_wready_s = '0' and m00_axi_wvalid_s = '1' and axi_awv_awr_flag = '1') then
	        axi_wready_s <= '1';
          elsif (m00_axi_wvalid_s = '1' and axi_wready_s = '1') then 

	        axi_wready_s <= '0';
	      end if;
	    end if;
	  end if;         
	end process; 


    -- Implement write response logic generation

	-- The write response and response valid signals are asserted by the slave 
	-- when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	-- This marks the acceptance of address and indicates the status of 
	-- write transaction.
 
	process (clk_s)
	begin
	  if rising_edge(clk_s) then 
	    if m00_axi_aresetn_s = '0' then
            axi_bvalid_s  <= '0';
            axi_bresp_s  <= "00"; --need to work more on the responses
            m00_axi_buser_s <= (others => '0');
	    else
	      if (axi_awv_awr_flag = '1' and m00_axi_wready_s = '1' and m00_axi_wvalid_s = '1' and m00_axi_bvalid_s = '0' and m00_axi_wlast_s = '1' ) then
	        axi_bvalid_s <= '1';
	        axi_bresp_s  <= "00"; 
	      elsif (m00_axi_bready_s = '1' and axi_bvalid_s = '1') then  
	      --check if bready is asserted while bvalid is high)
          axi_bvalid_s <= '0';                      
	      end if;
	    end if;
	  end if;         
	end process; 

    mem_wr_s <= axi_wready_s and m00_axi_wvalid_s;
    mem_addr_s <= axi_araddr_s(C_M00_AXI_ADDR_WIDTH_c - 3 downto ADDR_LSB) when axi_arv_arr_flag = '1' else (others => '0');
    en_code_s <= axi_araddr_s(C_M00_AXI_ADDR_WIDTH_c - 1 downto C_M00_AXI_ADDR_WIDTH_c - 2) when axi_arv_arr_flag = '1' else (others => '0');


    mem_addr_wr_s <= axi_awaddr_s(C_M00_AXI_ADDR_WIDTH_c - 3 downto ADDR_LSB) when axi_awv_awr_flag = '1' else (others => '0');
    en_code_wr_s <= axi_awaddr_s(C_M00_AXI_ADDR_WIDTH_c - 1 downto C_M00_AXI_ADDR_WIDTH_c - 2) when axi_awv_awr_flag = '1' else (others => '0');



    --Address decoder
    addr_dec: process(mem_addr_s,en_code_s)
    begin
        --Default assignments
        en_m_s  <= '0';
        en_opseg_s  <= '0';
        en_hanning_s <= '0';
        en_out_s  <= '0';
        case en_code_s is
            when "00" =>
                en_m_s <= '1';
            when "01" =>
                en_opseg_s <= '1';
            when "10" =>
                en_hanning_s <= '1';
            when others =>
                en_out_s <= '1';
        end case;                        
    end process;      

    --write Address decoder
    write_addr_dec: process(mem_addr_wr_s,en_code_wr_s)
    begin
        --Default assignments
        en_w_m_s  <= '0';
        en_w_opseg_s  <= '0';
        en_w_out_s  <= '0';
        case en_code_wr_s is
            when "00" =>
                en_w_m_s <= '1';
            when "01" =>
                en_w_opseg_s <= '1';
            when others =>
                en_w_out_s <= '1';
        end case;                        
    end process;  



    All_memory: process(clk_s) is   

        
        variable    v_output_line            :   line;
        variable    debugRealMEM_OUT_v          : real;
        variable    addr_out_v                    : integer;
        file file_OUT_novo_in    : text open write_mode is "debugOut_novo_tb.txt";

    begin

        if(clk_s'event and clk_s = '1')then
            if en_m_s = '1' then
                
                m00_axi_rdata_s <= MEM_M(to_integer(unsigned(mem_addr_s)));

            elsif en_opseg_s = '1' then
                m00_axi_rdata_s <= std_logic_vector(resize(unsigned(to_slv(MEM_IN(to_integer(unsigned(mem_addr_s))))),m00_axi_rdata_s'length));

            elsif (en_hanning_s = '1' and han_val_ready_s = '1') then
                m00_axi_rdata_s <= std_logic_vector(resize(unsigned(to_slv(MEM_HAN(to_integer(unsigned(mem_addr_s))))),m00_axi_rdata_s'length));

            elsif en_out_s = '1' then
                m00_axi_rdata_s <= std_logic_vector(resize(signed(to_slv(MEM_OUT(to_integer(unsigned(mem_addr_s))))),m00_axi_rdata_s'length));
            end if;

            if en_w_m_s = '1' then
                if(mem_wr_s = '1' and (unsigned(mem_addr_wr_s) > to_unsigned(5,mem_addr_wr_s'length)) )then
                   MEM_M(to_integer(unsigned(mem_addr_wr_s))) := m00_axi_wdata_s;
                end if;
            elsif en_w_opseg_s = '1' then

            elsif en_w_out_s = '1' then

                if(mem_wr_s = '1')then
                    MEM_OUT(to_integer(unsigned(mem_addr_wr_s))) := to_sfixed(m00_axi_wdata_s,W_HIGH_OUT_TOP_c - 1 ,W_LOW_OUT_TOP_c);
                end if;

            end if;
        end if;
    end process;


    Loading_in_mem: process

        variable    v_input_line             :   line;
        variable    v_output_line            :   line;
        variable    v_wdata_real             :   real;
        variable    v_rdata_real             :   real;
        variable    v_prefix_string_in       :   string(1 to 5);
        variable    v_wdata_in               :   sfixed(W_HIGH_IN_c - 1 downto W_LOW_IN_c) := (others => '0');

        




    begin
       
        -------------------------------------------------------------------------------------------
        --                              Loading elements of memory in                             --
        -------------------------------------------------------------------------------------------
        
            --IN FAJLOVI
            --file_open(file_in,"debugIn_do_not_listen.txt",read_mode);
            file_open(file_in,"debugIn_yo.txt",read_mode);
            --file_open(file_in,"debugIn_yo11.txt",read_mode);
            --file_open(file_in,"debugIn_yo22.txt",read_mode);
            --file_open(file_in,"debugIn_yo33.txt",read_mode);
            --file_open(file_in,"debugIn_do_not_listen11.txt",read_mode);
            --file_open(file_in,"debugIn_do_not_listen33.txt",read_mode);--NA GITU
            --file_open(file_in,"debugIn_bond_james_bond.txt",read_mode);
            --file_open(file_in,"debugIn_bond_james_bond11.txt",read_mode);
            --file_open(file_in,"debugInBu.txt",read_mode);
            file_open(file_prefix_in,"debugPrefix_in_tb.txt",write_mode);

            for cnt in 0 to to_integer(unsigned(in_size_c)) - 1 loop
                readline(file_in,v_input_line);
                read(v_input_line,v_prefix_string_in);
                
                write(v_output_line,v_prefix_string_in);
                writeline(file_prefix_in,v_output_line);

                read(v_input_line,v_rdata_real);
            
                v_wdata_in := to_sfixed(v_rdata_real,v_wdata_in);
                
                MEM_IN(cnt) <= v_wdata_in;
                wait until falling_edge(clk_s);
            end loop;

        wait;
    end process;
    

    stim_gen: process
      variable    v_input_line             :   line;
      variable    v_output_line            :   line;
      variable    v_wdata_real             :   real;

      variable    v_address_print          :   integer;
      variable    v_wdata_int              :   integer;
      variable    cnt_opseg                :   integer;

      variable    file_status_m            :   file_open_status;
      variable      end_message             : string(1 to 15);
      

    --M memory variables
    variable    v_wdata_m_slv           : std_logic_vector(W_HIGH_M_TOP_c - 1 downto W_LOW_M_TOP_c);
    variable    v_wdata_int_test        : integer;
    variable    v_wdata_m_test          : integer;
    variable    v_prefix_string_m       : string(1 to 4);
    variable    v_num_of_elements_m     : integer := 0;

    --OPSEG memory variables
    variable    v_wdata_opseg           : sfixed(W_HIGH_OPSEG_TOP_c - 1 downto W_LOW_OPSEG_TOP_c);

    --pit,place, hanning mem
    variable  i_han,n_han           : integer := 0;
    variable  axi_read_pit_v         : std_logic_vector(31 downto 0);
    variable  han_val_v             : real;
    variable  han_val_sf_v          : sfixed(W_HIGH_HANNING_TOP_c - 1 downto W_LOW_HANNING_TOP_c);
    variable  axi_read_place_en_v         : std_logic_vector(31 downto 0);
    variable  axi_read_ready_v         : std_logic_vector(31 downto 0);
    variable  axi_read_hanning_ready_v         : std_logic_vector(31 downto 0);


    variable  v_time_step                     : real := real(i_han+1)/real(n_han+1);

    --debug han prolaz
    variable  han_ciklus           : integer := 0;

    begin
        report "Loading memory elements!";



        -------------------------------------------------------------------------------------------
        --                              Loading elements of memory m                             --
        -------------------------------------------------------------------------------------------

            --M FAJLOVI
            --file_open(file_m,"debugM2_do_not_listen.txt",read_mode);
            file_open(file_m,"debugM2_yo.txt",read_mode);
            --file_open(file_m,"debugM2_yo11.txt",read_mode);
            --file_open(file_m,"debugM2_yo22.txt",read_mode);
            --file_open(file_m,"debugM2_yo33.txt",read_mode);
            --file_open(file_m,"debugM2_do_not_listen11.txt",read_mode);
            --file_open(file_m,"debugM2_do_not_listen33.txt",read_mode);--NA GITU
            --file_open(file_m,"debugM2_bond_james_bond.txt",read_mode);
            --file_open(file_m,"debugM2_bond_james_bond11.txt",read_mode);
            --file_open(file_m,"debugM2Bu.txt",read_mode);
            file_open(file_prefix_m,"debugPrefix_m_tb.txt",write_mode);

            
            if(endfile(file_m)) then 
                report "END_OF_FILE";
            end if;
            
            case file_status_m is
                when open_ok =>
                   report "file_status_m = open_ok ";
                when status_error =>
                   report "file_status_m = status_error ";
                when name_error =>
                   report "file_status_m = name_error ";
                when others =>
                   report "file_status_m = mode_error ";
    
            end case;

            for cnt in 0 to m_size_c - 1 loop
                readline(file_m,v_input_line);
                read(v_input_line,v_prefix_string_m);
                
                write(v_output_line,v_prefix_string_m);
                writeline(file_prefix_m,v_output_line);
                
                read(v_input_line,v_wdata_int);
                
                v_wdata_m_slv := std_logic_vector(to_unsigned(v_wdata_int,v_wdata_m_slv'length));
                v_wdata_int_test := to_integer(unsigned(v_wdata_m_slv));
                

                MEM_M(cnt) := v_wdata_m_slv;
                wait until falling_edge(clk_s);

                v_num_of_elements_m := v_num_of_elements_m + 1;


            end loop;

        -------------------------------------------------------------------------------------------
        --                              Loading elements of memory out with zeros                --
        -------------------------------------------------------------------------------------------

        for cnt in 0 to SIZE_OUT_TOP_c - 1 loop
           MEM_OUT(cnt) := to_sfixed(to_signed(0,W_HIGH_OUT_TOP_c - W_LOW_OUT_TOP_c));
            wait until falling_edge(clk_s);
        end loop;



        --reset AXI-lite interface
        s00_axi_aresetn_s <= '0';
        --wait for 5 falling edges of AXI-lite clock signal
        for i in 1 to 5 loop
            wait until falling_edge(clk_s);
        end loop;
        --release reset 
        s00_axi_aresetn_s <= '1';

        -----------------------------------------------------------
        --              setting m_size                           --
        -----------------------------------------------------------
        s00_axi_awaddr_s <= std_logic_vector(to_unsigned(M_SIZE_REG_ADDR_C,s00_axi_awaddr_s'length));
        s00_axi_awvalid_s <= '1';
        s00_axi_wdata_s <= std_logic_vector(to_unsigned(v_num_of_elements_m,s00_axi_wdata_s'length));
        s00_axi_wvalid_s <= '1';
        s00_axi_wstrb_s <= "1111";
        s00_axi_bready_s <= '1';
        wait until s00_axi_awready_s = '1';
        wait until s00_axi_awready_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_awaddr_s <= std_logic_vector(to_unsigned(0,s00_axi_awaddr_s'length));
        s00_axi_awvalid_s <= '0';
        s00_axi_wdata_s <= std_logic_vector(to_unsigned(0,s00_axi_wdata_s'length));
        s00_axi_wvalid_s <= '0';
        s00_axi_wstrb_s <= "0000";
        wait until s00_axi_bvalid_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_bready_s <= '0';
        wait until falling_edge(clk_s);

        --wait for 5 falling edges of AXI-lite clock signal
        for i in 1 to 5 loop
            wait until falling_edge(clk_s);
        end loop;

        -----------------------------------------------------------
        --              setting in_size                          --
        -----------------------------------------------------------
        s00_axi_awaddr_s <= std_logic_vector(to_unsigned(IN_SIZE_REG_ADDR_C,s00_axi_awaddr_s'length));
        s00_axi_awvalid_s <= '1';
        s00_axi_wdata_s <= std_logic_vector(resize(unsigned(in_size_c),s00_axi_wdata_s'length));
        s00_axi_wvalid_s <= '1';
        s00_axi_wstrb_s <= "1111";
        s00_axi_bready_s <= '1';
        wait until s00_axi_awready_s = '1';
        wait until s00_axi_awready_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_awaddr_s <= std_logic_vector(to_unsigned(0,s00_axi_awaddr_s'length));
        s00_axi_awvalid_s <= '0';
        s00_axi_wdata_s <= std_logic_vector(to_unsigned(0,s00_axi_wdata_s'length));
        s00_axi_wvalid_s <= '0';
        s00_axi_wstrb_s <= "0000";
        wait until s00_axi_bvalid_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_bready_s <= '0';
        wait until falling_edge(clk_s);

        --wait for 5 falling edges of AXI-lite clock signal
        for i in 1 to 5 loop
            wait until falling_edge(clk_s);
        end loop;

        -----------------------------------------------------------
        --              setting alpha                           --
        -----------------------------------------------------------
        s00_axi_awaddr_s <= std_logic_vector(to_unsigned(ALPHA_REG_ADDR_C,s00_axi_awaddr_s'length));
        s00_axi_awvalid_s <= '1';
        s00_axi_wdata_s <= to_slv(alpha_c);
        s00_axi_wvalid_s <= '1';
        s00_axi_wstrb_s <= "1111";
        s00_axi_bready_s <= '1';
        wait until s00_axi_awready_s = '1';
        wait until s00_axi_awready_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_awaddr_s <= std_logic_vector(to_unsigned(0,s00_axi_awaddr_s'length));
        s00_axi_awvalid_s <= '0';
        s00_axi_wdata_s <= std_logic_vector(to_unsigned(0,s00_axi_wdata_s'length));
        s00_axi_wvalid_s <= '0';
        s00_axi_wstrb_s <= "0000";
        wait until s00_axi_bvalid_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_bready_s <= '0';
        wait until falling_edge(clk_s);

        --wait for 5 falling edges of AXI-lite clock signal
        for i in 1 to 5 loop
            wait until falling_edge(clk_s);
        end loop;

        -----------------------------------------------------------
        --              setting beta                             --
        -----------------------------------------------------------
        s00_axi_awaddr_s <= std_logic_vector(to_unsigned(BETA_REG_ADDR_C,s00_axi_awaddr_s'length));
        s00_axi_awvalid_s <= '1';
        s00_axi_wdata_s <= to_slv(beta_c);
        s00_axi_wvalid_s <= '1';
        s00_axi_wstrb_s <= "1111";
        s00_axi_bready_s <= '1';
        wait until s00_axi_awready_s = '1';
        wait until s00_axi_awready_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_awaddr_s <= std_logic_vector(to_unsigned(0,s00_axi_awaddr_s'length));
        s00_axi_awvalid_s <= '0';
        s00_axi_wdata_s <= std_logic_vector(to_unsigned(0,s00_axi_wdata_s'length));
        s00_axi_wvalid_s <= '0';
        s00_axi_wstrb_s <= "0000";
        wait until s00_axi_bvalid_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_bready_s <= '0';
        wait until falling_edge(clk_s);

        --wait for 5 falling edges of AXI-lite clock signal
        for i in 1 to 5 loop
            wait until falling_edge(clk_s);
        end loop;

        -----------------------------------------------------------
        --              setting gamma                            --
        -----------------------------------------------------------
        s00_axi_awaddr_s <= std_logic_vector(to_unsigned(GAMMA_REG_ADDR_C,s00_axi_awaddr_s'length));
        s00_axi_awvalid_s <= '1';
        s00_axi_wdata_s <= to_slv(gamma_c);
        s00_axi_wvalid_s <= '1';
        s00_axi_wstrb_s <= "1111";
        s00_axi_bready_s <= '1';
        wait until s00_axi_awready_s = '1';
        wait until s00_axi_awready_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_awaddr_s <= std_logic_vector(to_unsigned(0,s00_axi_awaddr_s'length));
        s00_axi_awvalid_s <= '0';
        s00_axi_wdata_s <= std_logic_vector(to_unsigned(0,s00_axi_wdata_s'length));
        s00_axi_wvalid_s <= '0';
        s00_axi_wstrb_s <= "0000";
        wait until s00_axi_bvalid_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_bready_s <= '0';
        wait until falling_edge(clk_s);




        --reset AXI-lite interface
        m00_axi_aresetn_s <= '0';
        --wait for 5 falling edges of AXI-lite clock signal
        for i in 1 to 5 loop
            wait until falling_edge(clk_s);
        end loop;
        --release reset 
        m00_axi_aresetn_s <= '1';

        m00_init_axi_txn_s <= '1';
        
        

        wait until falling_edge(clk_s);
        wait until falling_edge(clk_s);
        wait until falling_edge(clk_s);
        wait until falling_edge(clk_s);
        wait until falling_edge(clk_s);
        wait until falling_edge(clk_s);
        m00_init_axi_txn_s <= '0';


        

        loop

            if(han_val_ready_s = '0')then
                report "Inside loop!";
                report "Read the content of the place enable register!";
                --Read the content of the place enable register
                wait until falling_edge(clk_s);
                s00_axi_araddr_s        <= std_logic_vector(to_unsigned(PLACE_EN_ADDR_C,s00_axi_araddr_s'length));
                s00_axi_arvalid_s       <= '1';
                s00_axi_rready_s        <= '1';
                wait until s00_axi_arready_s = '1';
                wait until s00_axi_arready_s = '0';
                axi_read_place_en_v    := s00_axi_rdata_s;
                
                wait until falling_edge(clk_s);
                s00_axi_araddr_s        <= std_logic_vector(to_unsigned(0,s00_axi_araddr_s'length));
                s00_axi_arvalid_s       <= '0';
                s00_axi_rready_s        <= '0';  
                
                axi_read_place_en_s <= axi_read_place_en_v;
                report "after Read the content of the place enable register!";
                if(axi_read_place_en_v(0) = '1')then 
                    report "Inside if!";
                    report "Read the content of the Pit register!";
                    --Read the content of the Pit register
                    wait until falling_edge(clk_s);
                    s00_axi_araddr_s        <= std_logic_vector(to_unsigned(PIT_REG_ADDR_C,s00_axi_araddr_s'length));
                    s00_axi_arvalid_s       <= '1';
                    s00_axi_rready_s        <= '1';
                    wait until s00_axi_arready_s = '1';
                    wait until s00_axi_arready_s = '0';
                    axi_read_pit_v    := s00_axi_rdata_s;
                    
                    wait until falling_edge(clk_s);
                    s00_axi_araddr_s        <= std_logic_vector(to_unsigned(0,s00_axi_araddr_s'length));
                    s00_axi_arvalid_s       <= '0';
                    s00_axi_rready_s        <= '0';    
                    report "after Read the content of the Pit register!";

                    i_han := 0;

                    n_han := to_integer(unsigned(axi_read_pit_v)) * 2 + 1;
                
                    v_time_step := real(i_han+1)/real(n_han+1);

                    han_val_ready_s <= '1';


                    han_ciklus := han_ciklus + 1;

                    for cnt in 0 to to_integer(unsigned(axi_read_pit_v)) loop
                        report "Inside for!";
                        han_val_v := real(0.5) * (real(1) - cos(MATH_2_PI*v_time_step));

                        i_han := i_han + 1;

                        v_time_step := real(i_han+1)/real(n_han+1);

                        han_val_sf_v := to_sfixed(han_val_v,han_val_sf_v);

                        MEM_HAN(cnt) <= han_val_sf_v;
                        
                        cnt_s <= to_unsigned(cnt,cnt_s'length);
                        
                        han_val_sf_s <= han_val_sf_v;
                        wait until rising_edge(clk_s);
                    end loop;
                end if;
            end if; 

            
    
            if(han_val_ready_s = '1')then
                loop
                    --Read the content of the place enable register
                    wait until falling_edge(clk_s);
                    s00_axi_araddr_s        <= std_logic_vector(to_unsigned(PLACE_EN_ADDR_C,s00_axi_araddr_s'length));
                    s00_axi_arvalid_s       <= '1';
                    s00_axi_rready_s        <= '1';
                    wait until s00_axi_arready_s = '1';
                    wait until s00_axi_arready_s = '0';
                    axi_read_place_en_v    := s00_axi_rdata_s;
                    
                    wait until falling_edge(clk_s);
                    s00_axi_araddr_s        <= std_logic_vector(to_unsigned(0,s00_axi_araddr_s'length));
                    s00_axi_arvalid_s       <= '0';
                    s00_axi_rready_s        <= '0';  

                    report "Read the content of the HANNIG_READY register!";

                    --Read the content of the HANNIG_READY register
                    wait until falling_edge(clk_s);
                    s00_axi_araddr_s        <= std_logic_vector(to_unsigned(HAN_READY_ADDR_C,s00_axi_araddr_s'length));
                    s00_axi_arvalid_s       <= '1';
                    s00_axi_rready_s        <= '1';
                    wait until s00_axi_arready_s = '1';
                    wait until s00_axi_arready_s = '0';
                    axi_read_hanning_ready_v    := s00_axi_rdata_s;
                    
                    wait until falling_edge(clk_s);
                    s00_axi_araddr_s        <= std_logic_vector(to_unsigned(0,s00_axi_araddr_s'length));
                    s00_axi_arvalid_s       <= '0';
                    s00_axi_rready_s        <= '0';  

                    report "after Read the content of the HANNIG_READY register!";
                    --axi_read_hanning_ready_s <= axi_read_hanning_ready_v;

                    --Check is the 1st bit of the Status register set to one
                    if(axi_read_hanning_ready_v(0) = '1')then
                        --Hanning process completed
                        han_val_ready_s <= '0';
                        exit;
                    end if;

                end loop;
            end if;

                    
            --------------------------------------------------------------------------------------
            --                     Wait until Psolaf core finishes calculations                 --
            --------------------------------------------------------------------------------------
            report "Waiting to complete!";
            wait until falling_edge(clk_s);
            s00_axi_araddr_s        <= std_logic_vector(to_unsigned(READY_REG_ADDR_C,s00_axi_araddr_s'length));
            s00_axi_arvalid_s       <= '1';
            s00_axi_rready_s        <= '1';
            wait until s00_axi_arready_s = '1';
            wait until s00_axi_arready_s = '0';
            axi_read_ready_v    := s00_axi_rdata_s;
            
            wait until falling_edge(clk_s);
            s00_axi_araddr_s        <= std_logic_vector(to_unsigned(0,s00_axi_araddr_s'length));
            s00_axi_arvalid_s       <= '0';
            s00_axi_rready_s        <= '0';    

            --Check is the 1st bit of the Status register set to one
            if(axi_read_ready_v(0) = '1')then
                --Psolaf process completed
                exit;
            else
                wait for 1000 ns;
            end if;

        end loop;

        wait;
     end process;
    
end AXI_Behavioral;
