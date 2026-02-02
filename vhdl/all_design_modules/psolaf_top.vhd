----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/05/2021 05:31:05 PM
-- Design Name: 
-- Module Name: psolaf_top - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use work.utils_pkg.all;
library ieee_proposed;
use ieee_proposed.fixed_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity psolaf_top is
  generic(
        --ADDR WIDTH
        SIZE_ADDR_W                : integer := 16;
        --OPSEG memorija
        SIZE_OPSEG_TOP                : integer := 5000;
        W_HIGH_OPSEG_TOP              : integer := 1;
        W_LOW_OPSEG_TOP               : integer := -25;
        --M memorija
        SIZE_M_TOP                 : integer := 1000;
        --W_HIGH_M_TOP               : integer := 20;--bilo je 32
        W_HIGH_M_TOP               : integer := 32;--bilo je 32
        W_LOW_M_TOP                : integer := 0;
        --OUT memorija
        SIZE_OUT_TOP               : integer := 1000;
        -- W_HIGH_OUT_TOP             : integer := 1;
        -- W_LOW_OUT_TOP              : integer := -32;
        W_HIGH_OUT_TOP             : integer := 2;
        W_LOW_OUT_TOP              : integer := -30;
        --PAR1 memorija
		SIZE_PAR1_TOP			   : integer := 1000;
		W_HIGH_PAR1_TOP			   : integer := 1;
		W_LOW_PAR1_TOP			   : integer := -32;
        --GR memorija
        SIZE_GR_TOP                : integer := 4500;
        W_HIGH_GR_TOP              : integer := 1;
        W_LOW_GR_TOP               : integer := -40;
        --W memorija
        SIZE_W_TOP                : integer := 5000;
        W_HIGH_W_TOP              : integer := 1;
        W_LOW_W_TOP               : integer := -50;
        --HAN memorija
        W_HAN_TOP                 : integer := 32
  );
  port(
        clk_top                    : in std_logic;
        reset_top                  : in std_logic;
        

        --Interface to the mem_subsytem

        alpha_top_i                     : in sfixed(9 downto -22);
        beta_top_i                      : in sfixed(9 downto -22);
        gamma_top_i                     : in sfixed(9 downto -22);
        gamma_rec_top_i                 : in sfixed(9 downto -22);
        in_size_top_i                   : in std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
        start_top_i                     : in std_logic;
        ready_top_o                     : out std_logic;
        erase_flag_top_o                : out std_logic;
        num_of_m_top_o                  : out unsigned(log2c(SIZE_M_TOP) - 1 downto 0);
        opseg_addr_valid_top_o          : out std_logic;
        pit_top_o                       : out std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
        place_top_o                     : out unsigned(log2c(SIZE_M_TOP) - 1 downto 0);
        place_enable_top_o              : out std_logic;
        opseg_begin_top_o               : out unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
        opseg_end_top_o                 : out unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
        endGr_top_o                     : out unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
        iniGr_top_o                     : out unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
        matk_valid_top_i				: in std_logic;
        reads_done_psolaf_top_i			: in std_logic;


        axi_rnext_out_top_i             : in std_logic;
        axi_wnext_out_top_i             : in std_logic;
        axi_rready_top_i               : in std_logic;
        axi_rvalid_top_i               : in std_logic;
        axi_bready_top_i                : in std_logic;
        axi_bvalid_top_i                : in std_logic;
        ready_han_o                     : out std_logic;
        reads_last_done_top_i               : in std_logic;
        ready_interp1_o                 : out std_logic;
        ready_han_wr_top_o                  : out std_logic;
        ready_psolaf_wr_top_o               : out std_logic;
        
                   
        --Interfejs hanning
        rdata_cos_top_i 				 : in std_logic_vector(W_HAN_TOP - 1 downto 0);
        
        --Interfejs opseg memorije--------------------------------------------------------------------------------------
        --Port 1 interface
        p1_addr_opseg_top_o            : out std_logic_vector(SIZE_ADDR_W - 1  downto 0);
        p1_wdata_opseg_top_o           : out sfixed(W_HIGH_OPSEG_TOP - 1 downto W_LOW_OPSEG_TOP);
        p1_rdata_opseg_top_i           : in sfixed(W_HIGH_OPSEG_TOP - 1 downto W_LOW_OPSEG_TOP);
        p1_write_opseg_top_o           : out std_logic;
        num_of_elements_opseg_top_i    : in std_logic_vector(log2c(SIZE_OPSEG_TOP) - 1 downto 0);

        --Interfejs m memorije--------------------------------------------------------------------------------------
        --Port 1 interface
        p1_addr_m_top_o             : out std_logic_vector(SIZE_ADDR_W - 1 downto 0);
        p1_wdata_m_top_o            : out std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
        p1_rdata_m_top_i            : in std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
        p1_write_m_top_o            : out std_logic;
        --Port 2 interface
        p2_addr_m_top_o             : out std_logic_vector(SIZE_ADDR_W - 1  downto 0);
        p2_wdata_m_top_o            : out std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
        p2_rdata_m_top_i            : in std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
        p2_write_m_top_o            : out std_logic;
        num_of_elements_m_top_i     : in std_logic_vector(log2c(SIZE_M_TOP) - 1 downto 0);

        --Interfejs out memorije--------------------------------------------------------------------------------------
        --Port 1 interface
        p1_addr_out_top_o           : out std_logic_vector(SIZE_ADDR_W - 1 downto 0);
        p1_wdata_out_top_o          : out sfixed(W_HIGH_OUT_TOP - 1 downto W_LOW_OUT_TOP);
        p1_rdata_out_top_i          : in sfixed(W_HIGH_OUT_TOP - 1 downto W_LOW_OUT_TOP);
        p1_write_out_top_o          : out std_logic;
        --Port 2 interface      
        p2_addr_out_top_o           : out std_logic_vector(SIZE_ADDR_W - 1  downto 0);
        p2_wdata_out_top_o          : out sfixed(W_HIGH_OUT_TOP - 1 downto W_LOW_OUT_TOP);
        p2_rdata_out_top_i          : in sfixed(W_HIGH_OUT_TOP - 1 downto W_LOW_OUT_TOP);
        p2_write_out_top_o          : out std_logic;
        num_of_elements_out_top_i   : in std_logic_vector(log2c(SIZE_OUT_TOP) - 1 downto 0);

  
        --Interfejs par 1 memorije-----------------------------------------------------------------------------------
        itp_sel_top_o          : out std_logic;
        reset_par1_o           : out std_logic;
        --Port 1 interface
        p1_addr_par1_top_o    : out std_logic_vector(log2c(SIZE_PAR1_TOP) - 1 downto 0);
        p1_wdata_par1_top_o   : out sfixed(W_HIGH_PAR1_TOP - 1 downto W_LOW_PAR1_TOP);
        p1_rdata_par1_top_i   : in sfixed(W_HIGH_PAR1_TOP - 1 downto W_LOW_PAR1_TOP);
        p1_write_par1_top_o   : out std_logic;
        --Port 2 interface
        p2_addr_par1_top_o     : out std_logic_vector(log2c(SIZE_PAR1_TOP) - 1 downto 0);
        p2_wdata_par1_top_o    : out sfixed(W_HIGH_PAR1_TOP - 1 downto W_LOW_PAR1_TOP);
        p2_rdata_par1_top_i    : in sfixed(W_HIGH_PAR1_TOP - 1 downto W_LOW_PAR1_TOP);
        p2_write_par1_top_o    : out std_logic;
        --Port 3 interface
        p3_addr_par1_top_o     : out std_logic_vector(log2c(SIZE_PAR1_TOP) - 1 downto 0);
        p3_wdata_par1_top_o    : out sfixed(W_HIGH_PAR1_TOP - 1 downto W_LOW_PAR1_TOP);
        p3_rdata_par1_top_i    : in sfixed(W_HIGH_PAR1_TOP - 1 downto W_LOW_PAR1_TOP);
        p3_write_par1_top_o    : out std_logic;
        --Port 4 interface
        p4_addr_par1_top_o     : out std_logic_vector(log2c(SIZE_PAR1_TOP) - 1 downto 0);		
        p4_wdata_par1_top_o    : out sfixed(W_HIGH_PAR1_TOP - 1 downto W_LOW_PAR1_TOP);		
        p4_rdata_par1_top_i    : in sfixed(W_HIGH_PAR1_TOP - 1 downto W_LOW_PAR1_TOP);		
        p4_write_par1_top_o    : out std_logic;	
        num_of_elements_par1_top_i  : in std_logic_vector(log2c(SIZE_PAR1_TOP) - 1 downto 0);  

        --Interfejs gr memorije-----------------------------------------------------------------------------------
        reset_gr_top_o           : out std_logic;
        --Port 1 interface
        p1_addr_gr_top_o    : out std_logic_vector(log2c(SIZE_GR_TOP) - 1 downto 0);
        p1_wdata_gr_top_o   : out sfixed(W_HIGH_GR_TOP - 1 downto W_LOW_GR_TOP);
        p1_rdata_gr_top_i   : in sfixed(W_HIGH_GR_TOP - 1 downto W_LOW_GR_TOP);
        p1_write_gr_top_o   : out std_logic;
        --Port 2 interface
        p2_addr_gr_top_o     : out std_logic_vector(log2c(SIZE_GR_TOP) - 1 downto 0);
        p2_wdata_gr_top_o    : out sfixed(W_HIGH_GR_TOP - 1 downto W_LOW_GR_TOP);
        p2_rdata_gr_top_i    : in sfixed(W_HIGH_GR_TOP - 1 downto W_LOW_GR_TOP);
        p2_write_gr_top_o    : out std_logic;
        --Port 3 interface
        p3_addr_gr_top_o     : out std_logic_vector(log2c(SIZE_GR_TOP) - 1 downto 0);
        p3_wdata_gr_top_o    : out sfixed(W_HIGH_GR_TOP - 1 downto W_LOW_GR_TOP);
        p3_rdata_gr_top_i    : in sfixed(W_HIGH_GR_TOP - 1 downto W_LOW_GR_TOP);
        p3_write_gr_top_o    : out std_logic;
        num_of_elements_gr_top_i  : in std_logic_vector(log2c(SIZE_GR_TOP) - 1 downto 0);   
    

        --Interfejs w memorije-----------------------------------------------------------------------------------
        han_sel_top_o          : out std_logic;    
        reset_w_top_o           : out std_logic;
        --Port 1 interface
        p1_addr_w_top_o    : out std_logic_vector(log2c(SIZE_W_TOP) - 1 downto 0);
        p1_wdata_w_top_o   : out sfixed(W_HIGH_W_TOP - 1 downto W_LOW_W_TOP);
        p1_rdata_w_top_i   : in sfixed(W_HIGH_W_TOP - 1 downto W_LOW_W_TOP);
        p1_write_w_top_o   : out std_logic;
        --Port 2 interface
        p2_addr_w_top_o     : out std_logic_vector(log2c(SIZE_W_TOP) - 1 downto 0);
        p2_wdata_w_top_o    : out sfixed(W_HIGH_W_TOP - 1 downto W_LOW_W_TOP);
        p2_rdata_w_top_i    : in sfixed(W_HIGH_W_TOP - 1 downto W_LOW_W_TOP);
        p2_write_w_top_o    : out std_logic;
        --Port 3 interface
        p3_addr_w_top_o     : out std_logic_vector(log2c(SIZE_W_TOP) - 1 downto 0);
        p3_wdata_w_top_o    : out sfixed(W_HIGH_W_TOP - 1 downto W_LOW_W_TOP);
        p3_rdata_w_top_i    : in sfixed(W_HIGH_W_TOP - 1 downto W_LOW_W_TOP);
        p3_write_w_top_o    : out std_logic;
        num_of_elements_w_top_i  : in std_logic_vector(log2c(SIZE_W_TOP) - 1 downto 0);   
    
        
        state_top_o         : out std_logic_vector(6 downto 0)
    );
end psolaf_top;

architecture Behavioral of psolaf_top is
    --IN memorija
    constant SIZE_IN_c                : integer := 10000;
    constant W_HIGH_IN_c              : integer := 1;
    constant W_LOW_IN_c               : integer := -25;
    --REZ memorija
    constant SIZE_REZ_c               : integer := 5000;
    constant W_HIGH_REZ_c             : integer := 16;
    -- constant W_LOW_REZ_c              : integer := -42;
    -- constant W_LOW_REZ_c              : integer := -50;
    constant W_LOW_REZ_c              : integer := -25;
    --M memorija
    constant SIZE_M_c                 : integer := SIZE_M_TOP;
    constant W_HIGH_M_c               : integer := W_HIGH_M_TOP;
    constant W_LOW_M_c                : integer := W_LOW_M_TOP;
    --MATK memorija
    --constant SIZE_MATK_c              : integer := 5000;
    constant SIZE_MATK_c              : integer := SIZE_M_TOP;
    constant W_HIGH_MATK_c            : integer := 24;
    constant W_LOW_MATK_c             : integer := -16;
    --OPSEG memorija
    constant SIZE_OPSEG_c             : integer := SIZE_OPSEG_TOP;
    constant W_HIGH_OPSEG_c           : integer := W_HIGH_OPSEG_TOP;
    constant W_LOW_OPSEG_c            : integer := W_LOW_OPSEG_TOP;
    --OUT memorija
    constant SIZE_OUT_c               : integer := SIZE_OUT_TOP;
    constant W_HIGH_OUT_c             : integer := W_HIGH_OUT_TOP;
    constant W_LOW_OUT_c              : integer := W_LOW_OUT_TOP;
    --P memorija
    constant SIZE_P_c                 : integer := 1000;
    constant W_HIGH_P_c               : integer := 16;
    constant W_LOW_P_c                : integer := 0;
    --W memorija
    -- constant SIZE_W_c                 : integer := 5000;
    constant SIZE_W_c                 : integer := 15000;
    constant W_HIGH_W_c               : integer := 1;
    --constant W_LOW_W_c                : integer := -50;
    constant W_LOW_W_c                : integer := -31;
    --GR memorija
    constant SIZE_GR_c                : integer := 4500;
    constant W_HIGH_GR_c              : integer := 1;
    --constant W_LOW_GR_c               : integer := -40;
    constant W_LOW_GR_c               : integer := -50;
    --PAR1 memorija
    constant SIZE_PAR1_c              : integer := 5000;
    constant W_HIGH_PAR1_c            : integer := 16;
    constant W_LOW_PAR1_c             : integer := 0;
    --PAR3 memorija
    constant SIZE_PAR3_c              : integer := 5000;
    constant W_HIGH_PAR3_c            : integer := 16;
    --constant W_LOW_PAR3_c             : integer := -42;
    constant W_LOW_PAR3_c             : integer := -15;
    --ROM memorija
    --constant W_ROM_c                  : integer := 51;
    constant W_ROM_c                  : integer := 32;
    
    
    signal in_size_s                          : std_logic_vector(W_HIGH_M_c - 1 downto 0);

    signal clk_s                            : std_logic;
    signal reset_s                          : std_logic;
    signal start_s                          : std_logic;
    signal ready_s                          : std_logic;
    signal itype_s                          : std_logic;
    --hanning kontrolni i statusni signali
    signal start_han_o_s                     : std_logic;
    signal ready_han_i_s                     : std_logic;
    signal itype1_han_o_s                    : std_logic;
    signal ready_han_wr_s                        : std_logic;
    signal ready_psolaf_wr_s                     : std_logic;
     --Dodatni portovi za hanning modul
    signal pit_o_s                           : std_logic_vector(W_HIGH_M_c - 1 downto W_LOW_M_c);

    --interp1 kontorlni i statusni signali
    signal start_interp1_o_s                        : std_logic;
    signal ready_interp1_i_s                        : std_logic;
    signal itp_sel_o_s                              : std_logic;
    signal han_sel_o_s                              : std_logic;

    signal alpha_reg_s      	              : sfixed(22 downto -22);
    signal beta_reg_s                         : sfixed(22 downto -22);
    signal gamma_reg_s     	                  : sfixed(22 downto -22);

    --kontrolni i statusni portovi za memorije
    signal ready_w_s                 : std_logic;
    signal reset_matk_o_s            : std_logic;
    signal reset_opseg_o_s           : std_logic;
    signal reset_han_o_s             : std_logic;
    signal reset_gr_o_s              : std_logic;
    signal reset_par1_o_s            : std_logic;
    signal reset_par3_o_s            : std_logic;
    signal reset_rez_o_s             : std_logic;

    --Interfejs par 1 memorije-----------------------------------------------------------------------------------
    --Port 1 interface
    signal p1_addr_par1_o_s          : std_logic_vector(log2c(SIZE_PAR1_c) - 1 downto 0);
    signal p1_wdata_par1_o_s         : sfixed(W_HIGH_PAR1_c - 1 downto W_LOW_PAR1_c);
    signal p1_rdata_par1_i_s         : sfixed(W_HIGH_PAR1_c - 1 downto W_LOW_PAR1_c);
    signal p1_write_par1_o_s         : std_logic;
    --Port 2 interface
    signal p2_addr_par1_o_s          : std_logic_vector(log2c(SIZE_PAR1_c) - 1 downto 0);
    signal p2_wdata_par1_o_s         : sfixed(W_HIGH_PAR1_c - 1 downto W_LOW_PAR1_c);
    signal p2_rdata_par1_i_s         : sfixed(W_HIGH_PAR1_c - 1 downto W_LOW_PAR1_c);
    signal p2_write_par1_o_s         : std_logic;
    --Port 3 interface
    signal p3_addr_par1_o_s          : std_logic_vector(log2c(SIZE_PAR1_c) - 1 downto 0);
    signal p3_wdata_par1_o_s         : sfixed(W_HIGH_PAR1_c - 1 downto W_LOW_PAR1_c);
    signal p3_rdata_par1_i_s         : sfixed(W_HIGH_PAR1_c - 1 downto W_LOW_PAR1_c);
    signal p3_write_par1_o_s         : std_logic;
    --Port 4 interface
    signal p4_addr_par1_o_s          : std_logic_vector(log2c(SIZE_PAR1_c) - 1 downto 0);
    signal p4_wdata_par1_o_s         : sfixed(W_HIGH_PAR1_c - 1 downto W_LOW_PAR1_c);
    signal p4_rdata_par1_i_s         : sfixed(W_HIGH_PAR1_c - 1 downto W_LOW_PAR1_c);
    signal p4_write_par1_o_s         : std_logic;
    signal num_of_elements_par1_i_s  : std_logic_vector(log2c(SIZE_PAR1_c) - 1 downto 0);  
    --Interfejs gr memorije--------------------------------------------------------------------------------------
    --Port 1 interface
    signal p1_addr_gr_o_s            : std_logic_vector(log2c(SIZE_GR_c) - 1 downto 0);
    signal p1_wdata_gr_o_s           : sfixed(W_HIGH_GR_c - 1 downto W_LOW_GR_c);
    signal p1_rdata_gr_i_s           : sfixed(W_HIGH_GR_c - 1 downto W_LOW_GR_c);
    signal p1_write_gr_o_s           : std_logic;
    --Port 2 interface
    signal p2_addr_gr_o_s            : std_logic_vector(log2c(SIZE_GR_c) - 1 downto 0);
    signal p2_wdata_gr_o_s           : sfixed(W_HIGH_GR_c - 1 downto W_LOW_GR_c);
    signal p2_rdata_gr_i_s           : sfixed(W_HIGH_GR_c - 1 downto W_LOW_GR_c);
    signal p2_write_gr_o_s           : std_logic;
    --Port 3 interface
    signal p3_addr_gr_o_s            : std_logic_vector(log2c(SIZE_GR_c) - 1 downto 0);
    signal p3_wdata_gr_o_s           : sfixed(W_HIGH_GR_c - 1 downto W_LOW_GR_c);
    signal p3_rdata_gr_i_s           : sfixed(W_HIGH_GR_c - 1 downto W_LOW_GR_c);
    signal p3_write_gr_o_s           : std_logic;
    signal num_of_elements_gr_i_s    : std_logic_vector(log2c(SIZE_GR_c) - 1 downto 0);
    --Interfejs par 3 memorije------------------------------------------------------------------------------------
    --Port 1 interface
    signal p1_addr_par3_o_s          : std_logic_vector(log2c(SIZE_PAR3_c) - 1 downto 0);
    signal p1_wdata_par3_o_s         : sfixed(W_HIGH_PAR3_c - 1 downto W_LOW_PAR3_c);
    signal p1_rdata_par3_i_s         : sfixed(W_HIGH_PAR3_c - 1 downto W_LOW_PAR3_c);
    signal p1_write_par3_o_s         : std_logic;
    --Port 2 interface
    signal p2_addr_par3_o_s          : std_logic_vector(log2c(SIZE_PAR3_c) - 1 downto 0);
    signal p2_wdata_par3_o_s         : sfixed(W_HIGH_PAR3_c - 1 downto W_LOW_PAR3_c);
    signal p2_rdata_par3_i_s         : sfixed(W_HIGH_PAR3_c - 1 downto W_LOW_PAR3_c);
    signal p2_write_par3_o_s         : std_logic;
    signal num_of_elements_par3_i_s  : std_logic_vector(log2c(SIZE_PAR3_c) - 1 downto 0);
    --Interfejs rez memorije------------------------------------------------------------------------------------
    --Port 1 interface
    signal p1_addr_rez_o_s           : std_logic_vector(log2c(SIZE_REZ_c) - 1 downto 0);
    -- IZMENA 22,seo,2024
    signal p1_wdata_rez_o_s          : sfixed(W_HIGH_REZ_c - 1  downto W_LOW_REZ_c );
    signal p1_rdata_rez_i_s          : sfixed(W_HIGH_REZ_c - 1  downto W_LOW_REZ_c );
    signal p1_write_rez_o_s          : std_logic;
    --Port 2 interface
    signal p2_addr_rez_o_s           : std_logic_vector(log2c(SIZE_REZ_c) - 1 downto 0);
    signal p2_wdata_rez_o_s          : sfixed(W_HIGH_REZ_c - 1  downto W_LOW_REZ_c );
    signal p2_rdata_rez_i_s          : sfixed(W_HIGH_REZ_c - 1  downto W_LOW_REZ_c );
    signal p2_write_rez_o_s          : std_logic;
    signal num_of_elements_rez_i_s   : std_logic_vector(log2c(SIZE_REZ_c) - 1 downto 0);
    --Interfejs w memorije--------------------------------------------------------------------------------------
    --Port 1 interface
    signal p1_addr_w_o_s            : std_logic_vector(log2c(SIZE_W_c) - 1 downto 0);
    signal p1_wdata_w_o_s           : sfixed(W_HIGH_W_c - 1 downto W_LOW_W_c);
    signal p1_rdata_w_i_s           : sfixed(W_HIGH_W_c - 1 downto W_LOW_W_c);
    signal p1_write_w_o_s           : std_logic;
    --Port 2 interface
    signal p2_addr_w_o_s            : std_logic_vector(log2c(SIZE_W_c) - 1 downto 0);
    signal p2_wdata_w_o_s           : sfixed(W_HIGH_W_c - 1 downto W_LOW_W_c);
    signal p2_rdata_w_i_s           : sfixed(W_HIGH_W_c - 1 downto W_LOW_W_c);
    signal p2_write_w_o_s           : std_logic;
    --Port 3 interface
    signal p3_addr_w_o_s            : std_logic_vector(log2c(SIZE_W_c) - 1 downto 0);
    signal p3_wdata_w_o_s           : sfixed(W_HIGH_W_c - 1 downto W_LOW_W_c);
    signal p3_rdata_w_i_s           : sfixed(W_HIGH_W_c - 1 downto W_LOW_W_c);
    signal p3_write_w_o_s           : std_logic;
    signal num_of_elements_w_i_s    : std_logic_vector(log2c(SIZE_W_c) - 1 downto 0);
    --Port za reset memorije w
    signal reset_w_s                : std_logic;
    --Interfejs m memorije--------------------------------------------------------------------------------------
    --Port 1 interface
    signal p1_addr_m_s              : std_logic_vector(SIZE_ADDR_W - 1 - 2 downto 0);
    signal p1_wdata_m_s             : std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
    signal p1_rdata_m_s             : std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
    signal p1_write_m_s             : std_logic;
    --Port 2 interface  
    signal p2_addr_m_s              : std_logic_vector(SIZE_ADDR_W - 1 - 2 downto 0);
    signal p2_wdata_m_s             : std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
    signal p2_rdata_m_s             : std_logic_vector(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP);
    signal p2_write_m_s             : std_logic;
    signal num_of_elements_m_s      : std_logic_vector(log2c(SIZE_M_TOP) - 1 downto 0);
    --Interfejs matk memorije--------------------------------------------------------------------------------------
    --Port 1 interface
    signal p1_addr_matk_o_s         : std_logic_vector(log2c(SIZE_M_TOP) - 1 downto 0);
    signal p1_wdata_matk_o_s        : sfixed(W_HIGH_MATK_c - 1 downto W_LOW_MATK_c);
    signal p1_rdata_matk_i_s        : sfixed(W_HIGH_MATK_c - 1 downto W_LOW_MATK_c);
    signal p1_write_matk_o_s        : std_logic;
    --Port 2 interface
    signal p2_addr_matk_o_s         : std_logic_vector(log2c(SIZE_M_TOP) - 1 downto 0);
    signal p2_wdata_matk_o_s        : sfixed(W_HIGH_MATK_c - 1 downto W_LOW_MATK_c);
    signal p2_rdata_matk_i_s        : sfixed(W_HIGH_MATK_c - 1 downto W_LOW_MATK_c);
    signal p2_write_matk_o_s        : std_logic;
    --Port 3 interface
    signal p3_addr_matk_o_s         : std_logic_vector(log2c(SIZE_M_TOP) - 1 downto 0);
    signal p3_wdata_matk_o_s        : sfixed(W_HIGH_MATK_c - 1 downto W_LOW_MATK_c);
    signal p3_rdata_matk_i_s        : sfixed(W_HIGH_MATK_c - 1 downto W_LOW_MATK_c);
    signal p3_write_matk_o_s        : std_logic;
    signal num_of_elements_matk_i_s : std_logic_vector(log2c(SIZE_MATK_c) - 1 downto 0);
    --Interfejs opseg memorije--------------------------------------------------------------------------------------
    --Port 1 interface
    signal p1_addr_opseg_o_s         : std_logic_vector(log2c(SIZE_OPSEG_c) - 1 downto 0);
    signal p1_wdata_opseg_o_s        : sfixed(W_HIGH_OPSEG_c - 1 downto W_LOW_OPSEG_c);
    signal p1_rdata_opseg_i_s        : sfixed(W_HIGH_OPSEG_c - 1 downto W_LOW_OPSEG_c);
    signal p1_write_opseg_o_s        : std_logic;
    --Port 2 interface
    signal p2_addr_opseg_o_s         : std_logic_vector(log2c(SIZE_OPSEG_c) - 1 downto 0);
    signal p2_wdata_opseg_o_s        : sfixed(W_HIGH_OPSEG_c - 1 downto W_LOW_OPSEG_c);
    signal p2_rdata_opseg_i_s        : sfixed(W_HIGH_OPSEG_c - 1 downto W_LOW_OPSEG_c);
    signal p2_write_opseg_o_s        : std_logic;
    signal num_of_elements_opseg_i_s : std_logic_vector(log2c(SIZE_OPSEG_c) - 1 downto 0);
    --Interfejs out memorije--------------------------------------------------------------------------------------
    --Port 1 interface
    signal p1_addr_out_o_s           : std_logic_vector(SIZE_ADDR_W - 1 - 2 downto 0);
    signal p1_wdata_out_o_s          : sfixed(W_HIGH_OUT_TOP - 1 downto W_LOW_OUT_TOP);
    signal p1_rdata_out_i_s          : sfixed(W_HIGH_OUT_TOP - 1 downto W_LOW_OUT_TOP);
    signal p1_write_out_o_s          : std_logic;
    --Port 2 interface
    signal p2_addr_out_o_s           : std_logic_vector(SIZE_ADDR_W - 1 - 2 downto 0);
    signal p2_wdata_out_o_s          : sfixed(W_HIGH_OUT_TOP - 1 downto W_LOW_OUT_TOP);
    signal p2_rdata_out_i_s          : sfixed(W_HIGH_OUT_TOP - 1 downto W_LOW_OUT_TOP);
    signal p2_write_out_o_s          : std_logic;
    signal num_of_elements_out_i_s   : std_logic_vector(log2c(SIZE_OUT_TOP) - 1 downto 0);
    --Interfejs p memorije--------------------------------------------------------------------------------------
    --Port 1 interface
    signal p1_addr_p_o_s             : std_logic_vector(log2c(SIZE_P_c) - 1 downto 0);
    signal p1_wdata_p_o_s            : std_logic_vector(W_HIGH_P_c - 1 downto W_LOW_P_c);
    signal p1_rdata_p_i_s            : std_logic_vector(W_HIGH_P_c - 1 downto W_LOW_P_c);
    signal p1_write_p_o_s            : std_logic;
    --Port 2 interface
    signal p2_addr_p_o_s             : std_logic_vector(log2c(SIZE_P_c) - 1 downto 0);
    signal p2_wdata_p_o_s            : std_logic_vector(W_HIGH_P_c - 1 downto W_LOW_P_c);
    signal p2_rdata_p_i_s            : std_logic_vector(W_HIGH_P_c - 1 downto W_LOW_P_c);
    signal p2_write_p_o_s            : std_logic;
    --Port 3 interface
    signal p3_addr_p_o_s             : std_logic_vector(log2c(SIZE_P_c) - 1 downto 0);
    signal p3_wdata_p_o_s            : std_logic_vector(W_HIGH_P_c - 1 downto W_LOW_P_c);
    signal p3_rdata_p_i_s            : std_logic_vector(W_HIGH_P_c - 1 downto W_LOW_P_c);
    signal p3_write_p_o_s            : std_logic;
    signal num_of_elements_p_i_s     : std_logic_vector(log2c(SIZE_P_c) - 1 downto 0);
      
begin

--Signal out of psolaf top 
ready_han_o <= ready_han_i_s;
ready_han_wr_top_o <= ready_han_wr_s;
pit_top_o <= pit_o_s;
ready_interp1_o <= ready_interp1_i_s;
ready_psolaf_wr_top_o <= ready_psolaf_wr_s;
--itp_sel_top_o <= itp_sel_o_s;

    itp_sel_top_o <= itp_sel_o_s;          
    reset_par1_o  <= reset_par1_o_s;         
    --Port 1 interface
    p1_addr_par1_top_o     <= p1_addr_par1_o_s;
    p1_wdata_par1_top_o    <= p1_wdata_par1_o_s;
    p1_rdata_par1_i_s <= p1_rdata_par1_top_i;
    p1_write_par1_top_o    <= p1_write_par1_o_s;
    --Port 2 interface
    p2_addr_par1_top_o     <= p2_addr_par1_o_s;
    p2_wdata_par1_top_o    <= p2_wdata_par1_o_s;
    p2_rdata_par1_i_s <= p2_rdata_par1_top_i;
    p2_write_par1_top_o    <= p2_write_par1_o_s;
    --Port 3 interface
    p3_addr_par1_top_o     <= p3_addr_par1_o_s;
    p3_wdata_par1_top_o    <= p3_wdata_par1_o_s;
    p3_rdata_par1_i_s <= p3_rdata_par1_top_i;
    p3_write_par1_top_o    <= p3_write_par1_o_s;
    --Port 4 interface
    p4_addr_par1_top_o     <= p4_addr_par1_o_s;
    p4_wdata_par1_top_o    <= p4_wdata_par1_o_s;
    p4_rdata_par1_i_s <= p4_rdata_par1_top_i;
    p4_write_par1_top_o    <= p4_write_par1_o_s;
    num_of_elements_par1_i_s <= num_of_elements_par1_top_i; 


    --Interfejs gr memorije-----------------------------------------------------------------------------------
    reset_gr_top_o           <= reset_gr_o_s;
    --Port 1 interface
    p1_addr_gr_top_o        <= p1_addr_gr_o_s;    
    p1_wdata_gr_top_o       <= p1_wdata_gr_o_s;   
    p1_rdata_gr_i_s         <= p1_rdata_gr_top_i;   
    p1_write_gr_top_o       <= p1_write_gr_o_s;   
    --Port 2 interface
    p2_addr_gr_top_o        <= p2_addr_gr_o_s;       
    p2_wdata_gr_top_o       <= p2_wdata_gr_o_s;      
    p2_rdata_gr_i_s         <= p2_rdata_gr_top_i;      
    p2_write_gr_top_o       <= p2_write_gr_o_s;      
    --Port 3 interface
    p3_addr_gr_top_o        <= p3_addr_gr_o_s;     
    p3_wdata_gr_top_o       <= p3_wdata_gr_o_s;    
    p3_rdata_gr_i_s         <= p3_rdata_gr_top_i;    
    p3_write_gr_top_o       <= p3_write_gr_o_s;    
    num_of_elements_gr_i_s     <= num_of_elements_gr_top_i;

    --Interfejs w memorije-----------------------------------------------------------------------------------
    han_sel_top_o <= han_sel_o_s;
    --Port 1 interface
    p1_addr_w_top_o        <= p1_addr_w_o_s;    
    p1_wdata_w_top_o       <= p1_wdata_w_o_s;   
    p1_rdata_w_i_s         <= p1_rdata_w_top_i;   
    p1_write_w_top_o       <= p1_write_w_o_s;   
    --Port 2 interface
    p2_addr_w_top_o        <= p2_addr_w_o_s;       
    p2_wdata_w_top_o       <= p2_wdata_w_o_s;      
    p2_rdata_w_i_s         <= p2_rdata_w_top_i;      
    p2_write_w_top_o       <= p2_write_w_o_s;      
    --Port 3 interface
    p3_addr_w_top_o        <= p3_addr_w_o_s;     
    p3_wdata_w_top_o       <= p3_wdata_w_o_s;    
    p3_rdata_w_i_s         <= p3_rdata_w_top_i;    
    p3_write_w_top_o       <= p3_write_w_o_s;    
    num_of_elements_w_i_s     <= num_of_elements_w_top_i;

   --Par3 memorija
   mem_dp_par3: entity work.mem_double_port_par3(Beh)
   generic map(
        SIZE    => SIZE_PAR3_c,
        W_HIGH_PAR3 => W_HIGH_PAR3_c,
        W_LOW_PAR3  => W_LOW_PAR3_c
   )
   port map(
       clk => clk_top,
       reset => reset_par3_o_s,
       p1_addr_i => p1_addr_par3_o_s,
       p1_rdata_o => p1_rdata_par3_i_s,
       p1_wdata_i => p1_wdata_par3_o_s,
       p1_write_i => p1_write_par3_o_s,
       p2_addr_i => p2_addr_par3_o_s,
       p2_rdata_o => p2_rdata_par3_i_s,
       p2_wdata_i => p2_wdata_par3_o_s,
       p2_write_i => p2_write_par3_o_s,
       num_of_elements => num_of_elements_par3_i_s
   );

   --Memorija za rezultat
   mem_rez: entity work.mem_interp1_rez(Beh)
   generic map(
       SIZE    => SIZE_REZ_c,
       W_HIGH_REZ => W_HIGH_REZ_c,
       W_LOW_REZ  => W_LOW_REZ_c
   )
   port map(
       clk => clk_top,
       reset => reset_rez_o_s,
       p1_addr_i => p1_addr_rez_o_s,
       p1_rdata_o => p1_rdata_rez_i_s,
       p1_wdata_i => p1_wdata_rez_o_s,
       p1_write_i => p1_write_rez_o_s,
       p2_addr_i => p2_addr_rez_o_s,
       p2_rdata_o => p2_rdata_rez_i_s,
       p2_wdata_i => p2_wdata_rez_o_s,
       p2_write_i => p2_write_rez_o_s,
       num_of_elements => num_of_elements_rez_i_s
   );

   --Memorija matk
   mem_matk: entity work.mem_matk(Beh)
   generic map(
       SIZE_MATK    => SIZE_MATK_c,
       W_HIGH_MATK => W_HIGH_MATK_c,
       W_LOW_MATK  => W_LOW_MATK_c
   )
   port map(
       clk => clk_top,
       reset => reset_matk_o_s,
       p1_addr_i => p1_addr_matk_o_s,
       p1_rdata_o => p1_rdata_matk_i_s,
       p1_wdata_i => p1_wdata_matk_o_s,
       p1_write_i => p1_write_matk_o_s,
       p2_addr_i => p2_addr_matk_o_s,
       p2_rdata_o => p2_rdata_matk_i_s,
       p2_wdata_i => p2_wdata_matk_o_s,
       p2_write_i => p2_write_matk_o_s,
       num_of_elements => num_of_elements_matk_i_s
   );

   --Memorija p
   mem_p: entity work.mem_double_port_p(Beh)
   generic map(
       SIZE_P    => SIZE_P_c,
       W_HIGH_P => W_HIGH_P_c,
       W_LOW_P  => W_LOW_P_c
   )
   port map(
       clk => clk_top,
       reset => reset_top,
       p1_addr_i => p1_addr_p_o_s,
       p1_rdata_o => p1_rdata_p_i_s,
       p1_wdata_i => p1_wdata_p_o_s,
       p1_write_i => p1_write_p_o_s,
       p2_addr_i => p2_addr_p_o_s,
       p2_rdata_o => p2_rdata_p_i_s,
       p2_wdata_i => p2_wdata_p_o_s,
       p2_write_i => p2_write_p_o_s,
       num_of_elements => num_of_elements_p_i_s
   );

   --Interp1 modul
   interp1_top:   entity work.interp1_top(Behavioral)
   generic map(
       SIZE_gr         => SIZE_gr_c,
       SIZE_par1       => SIZE_par1_c,
       SIZE_par3       => SIZE_par3_c,
       SIZE_rez        => SIZE_rez_c,
       W_HIGH_PAR1     => W_HIGH_PAR1_c,
       W_HIGH_PAR3     => W_HIGH_PAR3_c,
       W_HIGH_GR       => W_HIGH_GR_c,
       W_HIGH_REZ      => W_HIGH_REZ_c,
       W_LOW_PAR1      => W_LOW_PAR1_c,
       W_LOW_PAR3      => W_LOW_PAR3_c,
       W_LOW_GR        => W_LOW_GR_c,
       W_LOW_REZ       => W_LOW_REZ_c
   )
   port map(
       clk                        =>  clk_top,
       reset                      =>  reset_top,
       start                      =>  start_interp1_o_s,
       ready                      =>  ready_interp1_i_s,
       p1_addr_par1_o             =>  p1_addr_par1_o_s,
       p1_wdata_par1_o            =>  p1_wdata_par1_o_s,
       p1_rdata_par1_i            =>  p1_rdata_par1_i_s,
       p1_write_par1_o            =>  p1_write_par1_o_s,
       --Port 2 interface             
       p2_addr_par1_o             =>  p2_addr_par1_o_s,
       p2_wdata_par1_o            =>  p2_wdata_par1_o_s,
       p2_rdata_par1_i            =>  p2_rdata_par1_i_s,
       p2_write_par1_o            =>  p2_write_par1_o_s,
       num_of_elements_par1_i     =>  num_of_elements_par1_i_s,
       --Interfejs gr memorije--------------------------------------------------------------------------------------
       --Port 1 interface
       p1_addr_gr_o               =>  p1_addr_gr_o_s,
       p1_wdata_gr_o              =>  p1_wdata_gr_o_s,
       p1_rdata_gr_i              =>  p1_rdata_gr_i_s,
       p1_write_gr_o              =>  p1_write_gr_o_s,
       --Port 2 interface
       p2_addr_gr_o               =>  p2_addr_gr_o_s,
       p2_wdata_gr_o              =>  p2_wdata_gr_o_s,
       p2_rdata_gr_i              =>  p2_rdata_gr_i_s,
       p2_write_gr_o              =>  p2_write_gr_o_s,
       --Interfejs par 3 memorije------------------------------------------------------------------------------------
       --Port 1 interface
       p1_addr_par3_o             =>  p1_addr_par3_o_s,
       p1_wdata_par3_o            =>  p1_wdata_par3_o_s,
       p1_rdata_par3_i            =>  p1_rdata_par3_i_s,
       p1_write_par3_o            =>  p1_write_par3_o_s,
       num_of_elements_par3_i     =>  num_of_elements_par3_i_s,
       --Interfejs rez memorije--------------------------------------------------------------------------------------
       p1_addr_rez_o              => p1_addr_rez_o_s,
       p1_wdata_rez_o             => p1_wdata_rez_o_s,
       p1_write_rez_o             => p1_write_rez_o_s
   ); 
   
   hanning:   entity work.hanning(Behavioral)
   generic map(
       SIZE_w           => SIZE_W_c,
       W_HIGH_W         => W_HIGH_W_c,
       W_LOW_W          => W_LOW_W_c,
       W_HIGH_PIT       => W_HIGH_M_c,
       W_LOW_PIT        => W_LOW_M_c,
       W_ROM            => W_ROM_c,
       W_HAN            => W_HAN_TOP
   )
   port map(
       clk                        =>  clk_top,
       reset                      =>  reset_top,
       start                      =>  start_han_o_s,
       ready                      =>  ready_han_i_s,
       itype                      =>  itype1_han_o_s,
       --Interfejs gr memorije--------------------------------------------------------------------------------------
       --Port 1 interface
       p1_addr_w_o               =>  p1_addr_w_o_s,
       p1_wdata_w_o              =>  p1_wdata_w_o_s,
       p1_rdata_w_i              =>  p1_rdata_w_i_s,
       p1_write_w_o              =>  p1_write_w_o_s,
       --Port 2 interface
       p2_addr_w_o               =>  p2_addr_w_o_s,
       p2_wdata_w_o              =>  p2_wdata_w_o_s,
       p2_rdata_w_i              =>  p2_rdata_w_i_s,
       p2_write_w_o              =>  p2_write_w_o_s,
       num_of_elements_w_i       =>  num_of_elements_w_i_s,
       --Interfejs hanning memorije--------------------------------------------------------------------------------------
       rdata_cos_novo_i => rdata_cos_top_i,
       --Port za reset memorije w
       reset_w                   =>  reset_w_s,
       ready_w                   =>  ready_w_s,
       pit_i                     =>  pit_o_s,
       --Interfejs za axi protokol
    --    axi_rready_i             => axi_rready_top_i,
    --    axi_rvalid_i             => axi_rvalid_top_i,
       axi_rnext_out_i          => axi_rnext_out_top_i,
       ready_wr                 => ready_han_wr_s
   );



   psolaf:   entity work.psolaf(Behavioral)
   generic map(
       --REZ memorija
       SIZE_REZ => SIZE_REZ_c,          
       W_HIGH_REZ => W_HIGH_REZ_c,   
       W_LOW_REZ => W_LOW_REZ_c,
       --M memorija
       SIZE_M =>    SIZE_M_TOP,   
       W_HIGH_M =>  W_HIGH_M_TOP,    
       W_LOW_M =>   W_LOW_M_TOP,       
       --MATK memorija
       SIZE_MATK => SIZE_MATK_c,      
       W_HIGH_MATK => W_HIGH_MATK_c,  
       W_LOW_MATK => W_LOW_MATK_c,
       --OPSEG memorija
       SIZE_OPSEG => SIZE_OPSEG_c,      
       W_HIGH_OPSEG => W_HIGH_OPSEG_c,
       W_LOW_OPSEG => W_LOW_OPSEG_c,
       --OUT memorija
       SIZE_OUT =>      SIZE_OUT_TOP,   
       W_HIGH_OUT =>    W_HIGH_OUT_TOP,    
       W_LOW_OUT =>     W_LOW_OUT_TOP,   
       --P memorija
       SIZE_P => SIZE_P_c,       
       W_HIGH_P => W_HIGH_P_c,      
       W_LOW_P => W_LOW_P_c,      
       --W memorija
       SIZE_W => SIZE_W_c,        
       W_HIGH_W => W_HIGH_W_c,       
       W_LOW_W => W_LOW_W_c,      
       --GR memorija
       SIZE_GR => SIZE_GR_c,      
       W_HIGH_GR => W_HIGH_GR_c,      
       W_LOW_GR => W_LOW_GR_c,       
       --PAR1 memorija
       SIZE_PAR1 => SIZE_PAR1_c,      
       W_HIGH_PAR1 => W_HIGH_PAR1_c,    
       W_LOW_PAR1 => W_LOW_PAR1_c,
       --PAR3 memorija
       SIZE_PAR3 => SIZE_PAR3_c,      
       W_HIGH_PAR3 => W_HIGH_PAR3_c,   
       W_LOW_PAR3 => W_LOW_PAR3_c     
   )
   port map(
       clk => clk_top,
       reset => reset_top,
       start => start_top_i,
       ready => ready_top_o,
        --signal za smmallest next tj. place koji je potreban za opseg memoriju
        erase_flag_o            => erase_flag_top_o,
        num_of_m_o              => num_of_m_top_o,
        opseg_addr_valid_o      => opseg_addr_valid_top_o,   
        place_o                 => place_top_o,
        place_enable_o          => place_enable_top_o,
        opseg_begin_o           => opseg_begin_top_o,
        opseg_end_o             => opseg_end_top_o,
        endGr_o                 => endGr_top_o,
        iniGr_o                 => iniGr_top_o,
        matk_valid_i            => matk_valid_top_i,
        reads_done_psolaf_i     => reads_done_psolaf_top_i,
        ready_psolaf_wr_o       => ready_psolaf_wr_s,

       --hanning kontrolni i statusni signali
       start_han_o => start_han_o_s,
       ready_han_i => ready_han_i_s,
       itype1_han_o => itype1_han_o_s,
       --Dodatni portovi za hanning modul
       pit_o => pit_o_s,

       --interp1 kontrolni i statusni signali
       start_interp1_o => start_interp1_o_s,
       ready_interp1_i => ready_interp1_i_s,
       itp_sel_o       => itp_sel_o_s,
       han_sel_o       => han_sel_o_s,

       in_size_i => in_size_top_i,         
       alpha_reg_i => alpha_top_i,      	   
       beta_reg_i  => beta_top_i,            
       gamma_reg_i => gamma_top_i,   
       gamma_rec_reg_i => gamma_rec_top_i, 	

       --protovi za axi master
       axi_rnext_out_i          => axi_rnext_out_top_i,
       axi_wnext_out_i          => axi_wnext_out_top_i,
       axi_rready_i             => axi_rready_top_i,
       axi_rvalid_i             => axi_rvalid_top_i,
       axi_bready_i               	=> axi_bready_top_i,
	   axi_bvalid_i   				=> axi_bvalid_top_i,
       reads_last_m_matk_done_i        => reads_last_done_top_i,
       --kontrolni i statusni portovi za memorije
       reset_matk_o => reset_matk_o_s,
       reset_opseg_o => reset_opseg_o_s,
       reset_han_o => reset_han_o_s,
       reset_gr_o => reset_gr_o_s,
       reset_par1_o => reset_par1_o_s,
       reset_par3_o => reset_par3_o_s,
       reset_rez_o => reset_rez_o_s,
       --Interfejs par 1 memorije-----------------------------------------------------------------------------------
       --Port 1 interface
       p1_addr_par1_o => p3_addr_par1_o_s,
       p1_wdata_par1_o => p3_wdata_par1_o_s,
       p1_rdata_par1_i => p3_rdata_par1_i_s,
       p1_write_par1_o => p3_write_par1_o_s,
       --Port 2 interface
       p2_addr_par1_o => p4_addr_par1_o_s,
       p2_wdata_par1_o => p4_wdata_par1_o_s,
       p2_rdata_par1_i => p4_rdata_par1_i_s,
       p2_write_par1_o => p4_write_par1_o_s,
       num_of_elements_par1_i => num_of_elements_par1_i_s,
       --Interfejs gr memorije--------------------------------------------------------------------------------------
       --Port 1 interface
       p1_addr_gr_o => p3_addr_gr_o_s,
       p1_wdata_gr_o => p3_wdata_gr_o_s,
       p1_rdata_gr_i => p3_rdata_gr_i_s,
       p1_write_gr_o => p3_write_gr_o_s,
       num_of_elements_gr_i => num_of_elements_gr_i_s,
       --Interfejs par 3 memorije------------------------------------------------------------------------------------
       --Port 1 interface
       p1_addr_par3_o => p2_addr_par3_o_s,
       p1_wdata_par3_o => p2_wdata_par3_o_s,
       p1_rdata_par3_i => p2_rdata_par3_i_s,
       p1_write_par3_o => p2_write_par3_o_s,
       num_of_elements_par3_i => num_of_elements_par3_i_s,
       --Interfejs rez memorije------------------------------------------------------------------------------------
       --Port 1 interface
       p1_addr_rez_o => p2_addr_rez_o_s,
       p1_wdata_rez_o => p2_wdata_rez_o_s,
       p1_rdata_rez_i => p2_rdata_rez_i_s,
       p1_write_rez_o => p2_write_rez_o_s,
       num_of_elements_rez_i => num_of_elements_rez_i_s,
       --Interfejs w memorije--------------------------------------------------------------------------------------
       --Port 1 interface
       p1_addr_w_o => p3_addr_w_o_s,       
       p1_wdata_w_o => p3_wdata_w_o_s,    
       p1_rdata_w_i => p3_rdata_w_i_s,
       p1_write_w_o => p3_write_w_o_s,  
       num_of_elements_w_i => num_of_elements_w_i_s,
       --Port za reset memorije w
       reset_w => reset_w_s,
       --Interfejs m memorije--------------------------------------------------------------------------------------
       --Port 1 interface
       p1_addr_m_o => p1_addr_m_top_o,
       p1_wdata_m_o => p1_wdata_m_top_o,
       p1_rdata_m_i => p1_rdata_m_top_i, 
       p1_write_m_o => p1_write_m_top_o,
       --Port 2 interface
       p2_addr_m_o =>  p2_addr_m_top_o, 
       p2_wdata_m_o => p2_wdata_m_top_o,
       p2_rdata_m_i => p2_rdata_m_top_i,
       p2_write_m_o => p2_write_m_top_o,
       num_of_elements_m_i => num_of_elements_m_top_i,
       --Interfejs matk memorije--------------------------------------------------------------------------------------
       --Port 1 interface
       p1_addr_matk_o => p1_addr_matk_o_s,
       p1_wdata_matk_o => p1_wdata_matk_o_s, 
       p1_rdata_matk_i => p1_rdata_matk_i_s,
       p1_write_matk_o => p1_write_matk_o_s,
       --Port 2 interface
       p2_addr_matk_o => p2_addr_matk_o_s,
       p2_wdata_matk_o => p2_wdata_matk_o_s,
       p2_rdata_matk_i => p2_rdata_matk_i_s, 
       p2_write_matk_o => p2_write_matk_o_s,
       num_of_elements_matk_i => num_of_elements_matk_i_s,
       --Interfejs opseg memorije--------------------------------------------------------------------------------------
       --Port 1 interface
       p1_addr_opseg_o => p1_addr_opseg_top_o, 
       p1_wdata_opseg_o => p1_wdata_opseg_top_o,
       p1_rdata_opseg_i => p1_rdata_opseg_top_i,
       p1_write_opseg_o => p1_write_opseg_top_o,
       num_of_elements_opseg_i => num_of_elements_opseg_top_i,
       --Interfejs out memorije--------------------------------------------------------------------------------------
       --Port 1 interface
       p1_addr_out_o =>  p1_addr_out_top_o,
       p1_wdata_out_o => p1_wdata_out_top_o,
       p1_rdata_out_i => p1_rdata_out_top_i,
       p1_write_out_o => p1_write_out_top_o,
       --Port 2 interface
       p2_addr_out_o =>  p2_addr_out_top_o,
       p2_wdata_out_o => p2_wdata_out_top_o,
       p2_rdata_out_i => p2_rdata_out_top_i,
       p2_write_out_o => p2_write_out_top_o,
       num_of_elements_out_i => num_of_elements_out_top_i,
       --Interfejs p memorije--------------------------------------------------------------------------------------
       --Port 1 interface
       p1_addr_p_o => p1_addr_p_o_s,
       p1_wdata_p_o => p1_wdata_p_o_s,
       p1_rdata_p_i => p1_rdata_p_i_s,
       p1_write_p_o => p1_write_p_o_s,
       --Port 2 interface
       p2_addr_p_o => p2_addr_p_o_s,
       p2_wdata_p_o => p2_wdata_p_o_s,
       p2_rdata_p_i => p2_rdata_p_i_s,
       p2_write_p_o => p2_write_p_o_s,
       num_of_elements_p_i => num_of_elements_p_i_s,

        -- test_bench_signals
        state_o   => state_top_o
   );
end Behavioral;
