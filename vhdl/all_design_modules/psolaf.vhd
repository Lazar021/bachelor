----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2021 10:06:55 AM
-- Design Name: 
-- Module Name: psolaf - Behavioral
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

entity psolaf is
    generic(
        --ADDR WIDTH
        SIZE_ADDR_W                : integer := 16;

        --REZ memorija
        SIZE_REZ               : integer := 2200;
        W_HIGH_REZ             : integer := 12;
        W_LOW_REZ              : integer := -32;
        --M memorija
        SIZE_M                 : integer := 1000;
        SIZE_ADDR_W_M          : integer := 14;
        --W_HIGH_M               : integer := 20;--Bilo je 32
        W_HIGH_M               : integer := 32;
        W_LOW_M                : integer := 0;
        --MATK memorija
        SIZE_MATK              : integer := 1000;
        W_HIGH_MATK            : integer := 24;
        W_LOW_MATK             : integer := -16;
        --OPSEG memorija
        SIZE_OPSEG             : integer := 5000;
        W_HIGH_OPSEG_ADDR      : integer := 14;
        W_HIGH_OPSEG           : integer := 1;
        W_LOW_OPSEG            : integer := -25;
        --OUT memorija
        SIZE_OUT               : integer := 1000;
        W_HIGH_OUT             : integer := 1;
        W_LOW_OUT              : integer := -64;
        --P memorija
        SIZE_P                 : integer := 1000;
        W_HIGH_P               : integer := 16;
        W_LOW_P                : integer := 0;
        --W memorija
        SIZE_W                 : integer := 2500;
        W_HIGH_W               : integer := 1;
        W_LOW_W                : integer := -50;
        --GR memorija
        SIZE_GR                : integer := 4500;
        W_HIGH_GR              : integer := 1;
        W_LOW_GR               : integer := -40;
        --PAR1 memorija
        SIZE_PAR1              : integer := 2500;
        W_HIGH_PAR1            : integer := 12;
        W_LOW_PAR1             : integer := 0;
        --PAR3 memorija
        SIZE_PAR3              : integer := 2000;
        W_HIGH_PAR3            : integer := 12;
        W_LOW_PAR3             : integer := -32

        
    );
    port(
        clk                    : in std_logic;
        reset                  : in std_logic;
        start                  : in std_logic;
        ready                  : out std_logic;
        --signal za smmallest next tj. place koji je potreban za opseg memoriju
        erase_flag_o                    : out std_logic;
        num_of_m_o                      : out unsigned(log2c(SIZE_M) - 1 downto 0);
        opseg_addr_valid_o              : out std_logic;
        pit_mem_sub_o                   : out signed(W_HIGH_M - 1 downto W_LOW_M);
        place_o                         : out unsigned(log2c(SIZE_M) - 1 downto 0);
        place_enable_o                  : out std_logic;
        opseg_begin_o                   : out unsigned(W_HIGH_M - 1 downto W_LOW_M);
        opseg_end_o                     : out unsigned(W_HIGH_M - 1 downto W_LOW_M);
        endGr_o                         : out unsigned(W_HIGH_M - 1 downto W_LOW_M);
        iniGr_o                         : out unsigned(W_HIGH_M - 1 downto W_LOW_M);
        matk_valid_i                    : in std_logic;
        reads_done_psolaf_i             : in std_logic;
        ready_psolaf_wr_o               : out std_logic;

        --hanning kontrolni i statusni signali
        start_han_o                : out std_logic;
        ready_han_i                : in std_logic;
        itype1_han_o               : out std_logic;
        --Dodatni portovi za hanning modul
        pit_o                      : out std_logic_vector(W_HIGH_M - 1 downto W_LOW_M);   

        --interp1 kontorlni i statusni signali
        start_interp1_o            : out std_logic;
        ready_interp1_i            : in std_logic;
        itp_sel_o                  : out std_logic;
        han_sel_o                  : out std_logic;

        in_size_i               : in std_logic_vector(W_HIGH_M - 1 downto 0);
        alpha_reg_i      	    : in sfixed(9 downto -22);
		beta_reg_i              : in sfixed(9 downto -22);
		gamma_reg_i     	    : in sfixed(9 downto -22);
        gamma_rec_reg_i         : in sfixed(9 downto -22);

        --protovi za axi master
        axi_rnext_out_i		        : in std_logic;
        axi_wnext_out_i		        : in std_logic;
        axi_rready_i               : in std_logic;
        axi_rvalid_i               : in std_logic;
        axi_bready_i                : in std_logic;
        axi_bvalid_i                : in std_logic;
        reads_last_m_matk_done_i           : in std_logic;

        --kontrolni i statusni portovi za memorije
        reset_matk_o            : out std_logic;
        reset_opseg_o           : out std_logic;
        reset_han_o             : out std_logic;
        reset_gr_o              : out std_logic;
        reset_par1_o            : out std_logic;
        reset_par3_o            : out std_logic;
        reset_rez_o             : out std_logic;

        --Interfejs par 1 memorije-----------------------------------------------------------------------------------
        --Port 1 interface
        p1_addr_par1_o         : out std_logic_vector(log2c(SIZE_PAR1) - 1 downto 0);
        p1_wdata_par1_o        : out sfixed(W_HIGH_PAR1 - 1 downto W_LOW_PAR1);
        p1_rdata_par1_i        : in sfixed(W_HIGH_PAR1 - 1 downto W_LOW_PAR1);
        p1_write_par1_o        : out std_logic;
        --Port 2 interface
        p2_addr_par1_o         : out std_logic_vector(log2c(SIZE_PAR1) - 1 downto 0);
        p2_wdata_par1_o        : out sfixed(W_HIGH_PAR1 - 1 downto W_LOW_PAR1);
        p2_rdata_par1_i        : in sfixed(W_HIGH_PAR1 - 1 downto W_LOW_PAR1);
        p2_write_par1_o        : out std_logic;
        num_of_elements_par1_i : in std_logic_vector(log2c(SIZE_PAR1) - 1 downto 0);  
        --Interfejs gr memorije--------------------------------------------------------------------------------------
        --Port 1 interface
        p1_addr_gr_o           : out std_logic_vector(log2c(SIZE_GR) - 1 downto 0);
        p1_wdata_gr_o          : out sfixed(W_HIGH_GR - 1 downto W_LOW_GR);
        p1_rdata_gr_i          : in sfixed(W_HIGH_GR - 1 downto W_LOW_GR);
        p1_write_gr_o          : out std_logic;
        num_of_elements_gr_i   : in std_logic_vector(log2c(SIZE_GR) - 1 downto 0);
        --Interfejs par 3 memorije------------------------------------------------------------------------------------
        --Port 1 interface
        p1_addr_par3_o         : out std_logic_vector(log2c(SIZE_PAR3) - 1 downto 0);
        p1_wdata_par3_o        : out sfixed(W_HIGH_PAR3 - 1 downto W_LOW_PAR3);
        p1_rdata_par3_i        : in sfixed(W_HIGH_PAR3 - 1 downto W_LOW_PAR3);
        p1_write_par3_o        : out std_logic;
        num_of_elements_par3_i : in std_logic_vector(log2c(SIZE_PAR3) - 1 downto 0);
        --Interfejs rez memorije------------------------------------------------------------------------------------
        --Port 1 interface
        p1_addr_rez_o          : out std_logic_vector(log2c(SIZE_REZ) - 1 downto 0);
        p1_wdata_rez_o         : out sfixed(W_HIGH_REZ- 1  downto W_LOW_REZ );
        p1_rdata_rez_i         : in sfixed(W_HIGH_REZ - 1  downto W_LOW_REZ );
        p1_write_rez_o         : out std_logic;
        num_of_elements_rez_i  : in std_logic_vector(log2c(SIZE_REZ) - 1 downto 0);
        --Interfejs w memorije--------------------------------------------------------------------------------------
        --Port 1 interface
        p1_addr_w_o          : out std_logic_vector(log2c(SIZE_W) - 1 downto 0);
        p1_wdata_w_o         : out sfixed(W_HIGH_W - 1 downto W_LOW_W);
        p1_rdata_w_i         : in sfixed(W_HIGH_W - 1 downto W_LOW_W);
        p1_write_w_o         : out std_logic;
        num_of_elements_w_i  : in std_logic_vector(log2c(SIZE_W) - 1 downto 0);
        --Port za reset memorije w
        reset_w                  : out std_logic;
        --Interfejs m memorije--------------------------------------------------------------------------------------
        --Port 1 interface
        p1_addr_m_o     : out std_logic_vector(SIZE_ADDR_W - 1 downto 0);
        p1_wdata_m_o    : out std_logic_vector(W_HIGH_M - 1 downto W_LOW_M);
        p1_rdata_m_i    : in std_logic_vector(W_HIGH_M - 1 downto W_LOW_M);
        p1_write_m_o    : out std_logic;
        --Port 2 interface
        p2_addr_m_o     : out std_logic_vector(SIZE_ADDR_W - 1 downto 0);
        p2_wdata_m_o    : out std_logic_vector(W_HIGH_M - 1 downto W_LOW_M);
        p2_rdata_m_i    : in std_logic_vector(W_HIGH_M - 1 downto W_LOW_M);
        p2_write_m_o    : out std_logic;
        num_of_elements_m_i : in std_logic_vector(log2c(SIZE_M) - 1 downto 0);
        --Interfejs matk memorije--------------------------------------------------------------------------------------
        --Port 1 interface
        p1_addr_matk_o     : out std_logic_vector(log2c(SIZE_M) - 1 downto 0);
        p1_wdata_matk_o    : out sfixed(W_HIGH_MATK - 1 downto W_LOW_MATK);
        p1_rdata_matk_i    : in sfixed(W_HIGH_MATK - 1 downto W_LOW_MATK);
        p1_write_matk_o    : out std_logic;
        --Port 2 interface
        p2_addr_matk_o     : out std_logic_vector(log2c(SIZE_M) - 1 downto 0);
        p2_wdata_matk_o    : out sfixed(W_HIGH_MATK - 1 downto W_LOW_MATK);
        p2_rdata_matk_i    : in sfixed(W_HIGH_MATK - 1 downto W_LOW_MATK);
        p2_write_matk_o    : out std_logic;
        num_of_elements_matk_i : in std_logic_vector(log2c(SIZE_M) - 1 downto 0);
        --Interfejs opseg memorije--------------------------------------------------------------------------------------
        --Port 1 interface
        p1_addr_opseg_o     : out std_logic_vector(SIZE_ADDR_W - 1 downto 0);
        p1_wdata_opseg_o    : out sfixed(W_HIGH_OPSEG - 1 downto W_LOW_OPSEG);
        p1_rdata_opseg_i    : in sfixed(W_HIGH_OPSEG - 1 downto W_LOW_OPSEG);
        p1_write_opseg_o    : out std_logic;
        num_of_elements_opseg_i : in std_logic_vector(log2c(SIZE_OPSEG) - 1 downto 0);
        --Interfejs out memorije--------------------------------------------------------------------------------------
        --Port 1 interface
        p1_addr_out_o     : out std_logic_vector(SIZE_ADDR_W - 1 downto 0);
        p1_wdata_out_o    : out sfixed(W_HIGH_OUT - 1 downto W_LOW_OUT);
        p1_rdata_out_i    : in sfixed(W_HIGH_OUT - 1 downto W_LOW_OUT);
        p1_write_out_o    : out std_logic;
        --Port 2 interface
        p2_addr_out_o     : out std_logic_vector(SIZE_ADDR_W - 1 downto 0);
        p2_wdata_out_o    : out sfixed(W_HIGH_OUT - 1 downto W_LOW_OUT);
        p2_rdata_out_i    : in sfixed(W_HIGH_OUT - 1 downto W_LOW_OUT);
        p2_write_out_o    : out std_logic;
        num_of_elements_out_i : in std_logic_vector(log2c(SIZE_OUT) - 1 downto 0);
        --Interfejs p memorije--------------------------------------------------------------------------------------
        --Port 1 interface
        p1_addr_p_o     : out std_logic_vector(log2c(SIZE_P) - 1 downto 0);
        p1_wdata_p_o    : out std_logic_vector(W_HIGH_P - 1 downto W_LOW_P);
        p1_rdata_p_i    : in std_logic_vector(W_HIGH_P - 1 downto W_LOW_P);
        p1_write_p_o    : out std_logic;
        --Port 2 interface
        p2_addr_p_o     : out std_logic_vector(log2c(SIZE_P) - 1 downto 0);
        p2_wdata_p_o    : out std_logic_vector(W_HIGH_P - 1 downto W_LOW_P);
        p2_rdata_p_i    : in std_logic_vector(W_HIGH_P - 1 downto W_LOW_P);
        p2_write_p_o    : out std_logic;
        num_of_elements_p_i : in std_logic_vector(log2c(SIZE_P) - 1 downto 0);

        -- test_bench_signals
        state_o             : out std_logic_vector(6 downto 0)
    );
end psolaf;

architecture Behavioral of psolaf is
    type state_type is(idle,razdaljina,addr_set,erase,addr_set_p,mPLast,p_addr_setup,tk,matk,last_matk,addr_min,min,p_addr,place,
    pitStr_calc,opseg_set,opseg,start_han,han,gr,par1_addr,par1,par1_last,par3,start_interp1,interp1,out_asmd,out_asmd_2);
    signal  state_reg,state_next            : state_type;
    signal  place_reg,place_next            : unsigned(log2c(SIZE_M) - 1 downto 0);
    signal  pit_reg,pit_next                : signed(W_HIGH_M - 1 downto W_LOW_M);
    signal  pitStr_reg,pitStr_next          : signed(W_HIGH_M - 1 downto 0);
    signal  k_reg,k_next                    : unsigned(log2c(SIZE_REZ) - 1 downto 0);
    signal  iniGr_reg,iniGr_next            : unsigned(W_HIGH_MATK - 1 downto 0);
    signal  endGr_reg,endGr_next            : unsigned(W_HIGH_MATK - 1 downto 0);
    signal  mLen_reg,mLen_next              : unsigned(log2c(SIZE_M) - 1 downto 0);
    signal  dist_reg,dist_next              : unsigned(log2c(SIZE_M) - 1 downto 0);
    signal  razdaljina_reg,razdaljina_next  : unsigned(W_HIGH_M - 1 downto W_LOW_M);
    signal  it1_reg,it1_next                : unsigned(log2c(SIZE_MATK) - 1 downto 0);
    signal  erase_flag_next,erase_flag_reg  : std_logic;
    signal  num_of_m_next,num_of_m_reg      : unsigned(log2c(SIZE_M) - 1 downto 0);
    signal  lout_next,lout_reg              : unsigned(W_HIGH_M - 1 downto 0);
    signal  n_next,n_reg                    : unsigned(log2c(SIZE_REZ) - 1 downto 0);
    signal  tk_next,tk_reg                  : sfixed(W_HIGH_M downto -31);
    signal  first_next,first_reg            : unsigned(log2c(SIZE_M) - 1 downto 0);
    signal  smallest_next,smallest_reg      : unsigned(log2c(SIZE_M) - 1 downto 0);
    signal  i_next,i_reg                    : unsigned(W_HIGH_M - 1 downto W_LOW_M);
    signal  opseg_begin_next,opseg_begin_reg        : unsigned(W_HIGH_M - 1 downto W_LOW_M);
    signal  opseg_end_next,opseg_end_reg            : unsigned(W_HIGH_M - 1 downto W_LOW_M);
    signal  han_start_cnt_reg,han_start_cnt_next        : unsigned(2 downto 0);
    signal  pit_temp_next,pit_temp_reg                  : signed(W_HIGH_M - 1 downto W_LOW_P);
    signal  iter_reg,iter_next                          : sfixed(W_HIGH_PAR3 - 1 downto W_LOW_PAR3);
    signal  w_reg,w_next                                : sfixed(W_HIGH_W - 1 downto W_LOW_W);
    signal  rez_reg,rez_next                            : sfixed(W_HIGH_REZ - 1 downto W_LOW_REZ);

    signal  par1_addr_next,par1_addr_reg                : unsigned(log2c(SIZE_PAR1) - 1 downto 0); 
    signal  flag_stop_dec_m                             : std_logic;
    signal  opseg_addr_valid_next,opseg_addr_valid_reg  : std_logic;

    signal m_stall_next,m_stall_reg                     : signed(W_HIGH_M - 1 downto W_LOW_M);

    
    signal itp_sel_next,itp_sel_reg                     : std_logic;
    signal han_sel_next,han_sel_reg                     : std_logic;

    --DEBUG
    signal read_m_matk_sf         : sfixed(W_HIGH_M - 1 downto W_LOW_M);

    signal tk_temp_next,tk_temp_reg                                                 : sfixed(W_HIGH_M downto -31);
    signal pitStr_tmp_next,pitStr_tmp_reg                                           : sfixed(9 downto -22);
    signal pitStr_singed                                                            : signed(W_HIGH_M - 1 downto 0);          
    signal pitStr_int                                                               : integer;
    signal pit_next_Debug,pit_div_gamma_Debug,pit_mod_gamma_Debug                   : sfixed(9 downto -22);
    signal iter_next_debug                          : integer;  --sfixed(9 downto -22);
    signal  pitStr_next_signed_Debug                : signed(W_HIGH_M - 1 downto W_LOW_M);
    signal  pit_beta,beta_signed                    : signed(W_HIGH_M - 1 downto W_LOW_M);
    signal beta_slv                                 : std_logic_vector(W_HIGH_M - 1 downto W_LOW_M);
    signal beta_sfixed                              : sfixed(W_HIGH_M downto -31);
    signal gamma_reg,gamma_next                     : sfixed(9 downto -22);
    signal  tk_matk_next,tk_matk_reg                  : sfixed(W_HIGH_M downto -31);
    signal  matk_before_abs_next,matk_before_abs_reg                      : sfixed(W_HIGH_M downto -31);
    signal dva_next,dva_reg                                     : unsigned(log2c(SIZE_MATK) - 1 downto 0);
    signal matk_addr_next,matk_addr_reg                         : unsigned(log2c(SIZE_MATK) - 1 downto 0);
    signal matk_addr_2_next ,matk_addr_2_reg                                    : unsigned(log2c(SIZE_MATK) - 1 downto 0);
    signal opseg_val_next,opseg_val_reg                         : sfixed(W_HIGH_OPSEG - 1 downto W_LOW_OPSEG);
    signal beta_reg,beta_next                                   : sfixed(9 downto -22);
    signal neg_pitStr_next,neg_pitStr_reg                       : sfixed(W_HIGH_PAR3 - 1 downto W_LOW_PAR3);
    signal alpha_reg,alpha_next                                 : sfixed(9 downto -22);

begin

    --State and data registers
    process(clk,reset)
    begin
        if(clk'event and clk = '1')then
            if reset = '1' then
                state_reg <= idle;
                place_reg <= (others => '0');
                pit_reg <= (others => '0');
                pitStr_reg <= (others => '0');
                k_reg <= (others => '0');
                iniGr_reg <= (others => '0');
                endGr_reg <= (others => '0');
                mLen_reg <= (others => '0');
                dist_reg <= (others => '0');
                razdaljina_reg <= (others => '0');
                it1_reg <= (others => '0');
                erase_flag_reg <= '0';
                num_of_m_reg <= (others => '0');
                lout_reg <= (others => '0');
                n_reg <= (others => '0');
                tk_reg <= (others => '0');
                first_reg <= (others => '0');
                smallest_reg <= (others => '0');
                i_reg <= (others => '0');
                opseg_end_reg <= (others => '0');
                opseg_begin_reg <= (others => '0');
                han_start_cnt_reg <= (others => '0');
                pit_temp_reg <= (others => '0');
                iter_reg <= (others => '0');
                w_reg <= (others => '0');
                rez_reg <= (others => '0'); 
                par1_addr_reg <= (others => '0'); 

                m_stall_reg <= (others => '0');

                itp_sel_reg <= '0';
                han_sel_reg <= '0';
                opseg_addr_valid_reg <= '0';

                tk_temp_reg <= (others => '0');
                pitStr_tmp_reg <= (others => '0');
                gamma_reg <= (others => '0');
                matk_before_abs_reg <= (others => '0');
                dva_reg <= (others => '0');
                matk_addr_reg <= (others => '0');
                matk_addr_2_reg <= (others => '0');
                opseg_val_reg <= (others => '0');
                beta_reg <= (others => '0');
                neg_pitStr_reg <= (others => '0');
                alpha_reg <= (others => '0');
            else
                state_reg <= state_next;
                place_reg <= place_next;
                pit_reg <= pit_next;
                pitStr_reg <= pitStr_next;
                k_reg <= k_next;
                iniGr_reg <= iniGr_next;
                endGr_reg <= endGr_next;
                mLen_reg <= mLen_next;
                dist_reg <= dist_next;
                razdaljina_reg <= razdaljina_next;
                it1_reg <= it1_next;
                erase_flag_reg <= erase_flag_next;
                num_of_m_reg <= num_of_m_next;
                lout_reg <= lout_next;
                n_reg <= n_next;
                tk_reg <= tk_next;
                first_reg <= first_next;
                smallest_reg <= smallest_next;
                i_reg <= i_next;
                opseg_end_reg <= opseg_end_next;
                opseg_begin_reg <= opseg_begin_next;
                han_start_cnt_reg <= han_start_cnt_next;
                pit_temp_reg <= pit_temp_next;
                iter_reg <= iter_next;
                w_reg <= w_next;
                rez_reg <= rez_next; 
                par1_addr_reg <= par1_addr_next;
                
                m_stall_reg <= m_stall_next;

                itp_sel_reg <= itp_sel_next; 
                han_sel_reg <= han_sel_next; 
                opseg_addr_valid_reg <= opseg_addr_valid_next;
                tk_temp_reg <= tk_temp_next;
                pitStr_tmp_reg <= pitStr_tmp_next;
                gamma_reg <= gamma_next;
                matk_before_abs_reg <= matk_before_abs_next;
                dva_reg <= dva_next;
                matk_addr_reg <= matk_addr_next;
                matk_addr_2_reg <= matk_addr_2_next;
                opseg_val_reg <= opseg_val_next;
                beta_reg <= beta_next;
                neg_pitStr_reg <= neg_pitStr_next;
                alpha_reg <= alpha_next;
            end if;
        end if;
    end process; 

    --Combinatorial circuits   
    process(state_reg,start,p1_rdata_par1_i,p2_rdata_par1_i,num_of_elements_par1_i,
            p1_rdata_gr_i,num_of_elements_gr_i,p1_rdata_par3_i,
            num_of_elements_par3_i,p1_rdata_rez_i,num_of_elements_rez_i,
            p1_rdata_w_i,num_of_elements_w_i,
            p1_rdata_m_i,p2_rdata_m_i,num_of_elements_m_i,
            p1_rdata_matk_i,p2_rdata_matk_i,num_of_elements_matk_i,p1_rdata_opseg_i,
            num_of_elements_opseg_i,p1_rdata_out_i,p2_rdata_out_i,num_of_elements_out_i,
            p1_rdata_p_i,p2_rdata_p_i,num_of_elements_p_i,place_reg,pit_reg,pitStr_reg,
            k_reg,iniGr_reg,endGr_reg,mLen_reg,dist_reg,razdaljina_reg,place_next,pit_next,
            pitStr_next,k_next,iniGr_next,endGr_next,mLen_next,dist_next,razdaljina_next
            ,it1_next,it1_reg,erase_flag_reg,erase_flag_next,num_of_m_reg,num_of_m_next,
            lout_reg,lout_next,n_reg,n_next,tk_reg,tk_next,first_reg,first_next,smallest_reg,
            smallest_next,i_reg,i_next,opseg_end_reg,opseg_end_next,han_start_cnt_reg,han_start_cnt_next,
            pit_temp_reg,pit_temp_next,iter_reg,iter_next,w_reg,
            w_next,rez_next,rez_reg,par1_addr_next,par1_addr_reg,p1_addr_p_o,p2_addr_p_o,
            axi_rready_i,axi_rvalid_i,p2_addr_m_o,p2_write_m_o,p2_wdata_m_o,axi_bready_i,axi_bvalid_i,axi_rnext_out_i,
            num_of_m_next,num_of_m_reg,flag_stop_dec_m,opseg_begin_reg,opseg_begin_next,axi_wnext_out_i,
            reads_done_psolaf_i,in_size_i,alpha_reg_i,p2_write_p_o,matk_valid_i,gamma_reg_i,ready_han_i,beta_reg_i,
            ready_interp1_i,m_stall_next,m_stall_reg,itp_sel_next,itp_sel_reg,han_sel_reg,han_sel_next,
            opseg_addr_valid_next,opseg_addr_valid_reg,pitStr_tmp_reg,pitStr_tmp_next,gamma_next,gamma_reg,
            matk_before_abs_reg,matk_before_abs_next,dva_reg,dva_next,matk_addr_reg,matk_addr_next,matk_addr_2_next,
            matk_addr_2_reg,opseg_val_next,opseg_val_reg,tk_temp_next,tk_temp_reg,beta_reg,beta_next,neg_pitStr_reg,
            neg_pitStr_next,alpha_next,alpha_reg

            )
    
            variable conversion_sfixed_65_0         : sfixed(W_HIGH_M - 1 downto W_LOW_M);
            variable conversion_sfixed_lout         : sfixed(W_HIGH_M - 1 downto W_LOW_PAR3);

            
    begin
        
        --default assignments
        state_next <= state_reg;
        place_next <= place_reg;
        pit_next <= pit_reg;
        pitStr_next <= pitStr_reg;
        k_next <= k_reg;
        iniGr_next <= iniGr_reg;
        endGr_next <= endGr_reg;
        mLen_next <= mLen_reg;
        dist_next <= dist_reg;
        razdaljina_next <= razdaljina_reg;
        it1_next <= it1_reg;
        erase_flag_next <= erase_flag_reg;
        num_of_m_next <= num_of_m_reg;
        lout_next <= lout_reg;
        n_next <= n_reg;
        tk_next <= tk_reg;
        first_next <= first_reg;
        smallest_next <= smallest_reg;
        i_next <= i_reg;
        opseg_end_next <= opseg_end_reg;
        opseg_begin_next <= opseg_begin_reg;
        han_start_cnt_next <= han_start_cnt_reg;
        pit_temp_next <= pit_temp_reg;
        iter_next <= iter_reg;
        w_next <= w_reg;
        rez_next <= rez_reg;
        par1_addr_next <= par1_addr_reg;

        m_stall_next <= m_stall_reg;

        itp_sel_next <= itp_sel_reg;
        han_sel_next <= han_sel_reg;
        opseg_addr_valid_next <= opseg_addr_valid_reg;
        pitStr_tmp_next <= pitStr_tmp_reg;
        matk_before_abs_next <= matk_before_abs_reg;
        dva_next <= dva_reg;
        matk_addr_next <= matk_addr_reg;
        matk_addr_2_next <= matk_addr_2_reg;
        opseg_val_next <= opseg_val_reg;
        gamma_next <= gamma_reg;
        tk_temp_next <= tk_temp_reg;
        beta_next <= beta_reg;
        neg_pitStr_next <= neg_pitStr_reg;
        alpha_next <= alpha_reg;

        p1_addr_par1_o <= (others => '0');
        p2_addr_par1_o <= (others => '0');
        p1_write_par1_o <= '0';
        p2_write_par1_o <= '0';
        p1_addr_gr_o <= (others => '0');
        p1_write_gr_o <= '0';
        p1_addr_par3_o <= (others => '0');
        p1_write_par3_o <= '0';
        p1_addr_rez_o <= (others => '0');
        p1_write_rez_o <= '0';

        p1_addr_w_o <= (others => '0');
        p1_write_w_o <= '0';

        if(erase_flag_reg = '1') then
            p1_addr_m_o <= std_logic_vector(TO_UNSIGNED(3,p1_addr_m_o'length));
        else
            p1_addr_m_o <= (others => '0');
        end if;

        if(erase_flag_reg = '1') then
            p2_addr_m_o <= std_logic_vector(TO_UNSIGNED(3,p2_addr_m_o'length));
        else
            p2_addr_m_o <= (others => '0');
        end if;

        p1_write_m_o <= '0';
        p2_write_m_o <= '0';
        p1_addr_matk_o <= (others => '0');
        p2_addr_matk_o <= (others => '0');
        p1_write_matk_o <= '0';
        p2_write_matk_o <= '0';
        p1_addr_opseg_o <= (others => '0');
        p1_write_opseg_o <= '0';
        p1_addr_out_o <= (others => '0');
        p2_addr_out_o <= (others => '0');
        p1_write_out_o <= '0';
        p2_write_out_o <= '0';
        
        if(erase_flag_reg = '1') then
            p1_addr_p_o <= std_logic_vector(TO_UNSIGNED(3,p1_addr_p_o'length));
        else
            p1_addr_p_o <= (others => '0');
        end if;

        if(erase_flag_reg = '1') then
            p2_addr_p_o <= std_logic_vector(TO_UNSIGNED(3,p2_addr_p_o'length));
        else
            p2_addr_p_o <= (others => '0');
        end if;

        p1_write_p_o <= '0';
        p2_write_p_o <= '0';
        p2_wdata_p_o <= (others => '0');
        p1_wdata_opseg_o <= (others => '0');
        p2_wdata_out_o <= (others => '0');

        p1_wdata_p_o <= (others => '0');
        p1_wdata_par1_o <= (others => '0');
        p2_wdata_par1_o <= (others => '0');
        p1_wdata_gr_o <= (others => '0');
        p1_wdata_par3_o <= (others => '0');
        p2_wdata_m_o <= (others => '0');
        p1_wdata_matk_o <= (others => '0');



        ready <= '0';
        start_han_o <= '0';
        itype1_han_o <= '0';
        start_interp1_o <= '0';
        reset_matk_o <= '0';
        reset_opseg_o <= '0';
        reset_han_o <= '0';
        reset_gr_o <= '0';
        reset_par1_o <= '0';
        reset_par3_o <= '0';
        reset_rez_o <= '0';
        ready_psolaf_wr_o <= '0';

        --Signal out for memory_subsystem
        pit_mem_sub_o <= pit_next;
        
        --Signals for axi synchronization
        erase_flag_o <= erase_flag_reg;
        num_of_m_o <= num_of_m_reg;
        place_o <= smallest_reg;
        pit_o <= std_logic_vector(pit_reg);
        place_enable_o <= '0';
        opseg_addr_valid_o <= '0';
        opseg_begin_o <= opseg_begin_reg;
        opseg_end_o <= opseg_end_reg;
        endGr_o <= resize(endGr_reg,endGr_o'length);
        iniGr_o <= resize(iniGr_reg,iniGr_o'length);
        itp_sel_o <= itp_sel_reg;
        han_sel_o <= han_sel_reg;
        opseg_addr_valid_o <= opseg_addr_valid_reg;

        -- test_bench_signals
        state_o <= std_logic_vector(to_unsigned(state_type'pos(state_next),state_o'length));
    


        case state_reg is
            when idle =>
                ready <= '1';
                ready_psolaf_wr_o <= '1';
                if start = '1' then
                    p1_addr_p_o <= std_logic_vector(resize(it1_reg,p1_addr_p_o'length));
                    m_stall_next <= signed(p1_rdata_m_i);
                    it1_next <= it1_reg + 1;
                    razdaljina_next <= UNSIGNED(p1_rdata_m_i) - unsigned(m_stall_reg);
                    p1_wdata_p_o <= std_logic_vector(resize(razdaljina_next,p1_wdata_p_o'length));
                    p1_write_p_o <= '1';


                    state_next <= razdaljina;
                else
                    it1_next <= (others => '0');


                    m_stall_next <= signed(p1_rdata_m_i);
                    state_next <= idle;
                end if;
                
            when razdaljina =>
                ready_psolaf_wr_o <= '1';
                
                razdaljina_next <= UNSIGNED(p1_rdata_m_i) - unsigned(m_stall_reg);
                p1_wdata_p_o <= std_logic_vector(resize(razdaljina_next,p1_wdata_p_o'length));
                if(axi_rnext_out_i = '1' or (it1_reg = unsigned(num_of_elements_m_i) - 1)) then

                    it1_next <= it1_reg + 1;
                    p1_addr_p_o <= std_logic_vector(resize(it1_reg,p1_addr_p_o'length));

                    if(it1_reg >= unsigned(num_of_elements_m_i) - 1) then
                        p1_write_p_o <= '0';
                        state_next <= addr_set;
                    else
                        p1_write_p_o <= '1';
                        m_stall_next <= signed(p1_rdata_m_i);
                        state_next <= razdaljina;
                    end if;
                else
                    state_next <= razdaljina;
                end if;

            when addr_set =>     
                    if(axi_rready_i = '1' and axi_rvalid_i = '1')then
                        p1_addr_p_o <= std_logic_vector(TO_UNSIGNED(0,p1_addr_p_o'length));
                        p1_write_p_o <= '0';

                        m_stall_next <= signed(p1_rdata_m_i);
                        state_next <= erase;
                    end if;
            
            when erase =>
                if (unsigned(m_stall_reg) <= resize(unsigned(p1_rdata_p_i),p1_rdata_m_i'length)) then
                    num_of_m_next <= unsigned(num_of_elements_m_i) - TO_UNSIGNED(3,num_of_m_next'length);
                    
                    erase_flag_next <= '1';
                else
                    num_of_m_next <= unsigned(num_of_elements_m_i);
                    erase_flag_next <= '0';
                end if;

                state_next <= addr_set_p;
               

            when addr_set_p =>
                if(axi_rready_i = '1' and axi_rvalid_i = '1')then
                    p1_addr_p_o <= std_logic_vector(resize((unsigned(num_of_elements_p_i) - 1),p1_addr_p_o'length));
                    p2_addr_p_o <= std_logic_vector(resize((unsigned(num_of_elements_p_i)),p1_addr_p_o'length));
                    alpha_next <= alpha_reg_i;

                    state_next <= mPLast;
                else
                    state_next <= addr_set_p;
                end if;


            when mPLast =>
                
                if((unsigned(m_stall_reg) + unsigned(p1_rdata_p_i)) > unsigned(in_size_i)) then

                    num_of_m_next <= num_of_m_reg - TO_UNSIGNED(1,num_of_m_next'length);
                    lout_next <= to_unsigned(to_integer(to_sfixed(signed(in_size_i),conversion_sfixed_lout) * resize(alpha_reg,conversion_sfixed_lout)),lout_next'length);
                    
                    if(((to_sfixed(signed(in_size_i),conversion_sfixed_lout) * resize(alpha_reg,conversion_sfixed_lout)) mod 1) < 0.5 )then
                        lout_next <= resize(to_unsigned(to_integer(to_sfixed(signed(in_size_i),conversion_sfixed_lout) * resize(alpha_reg,conversion_sfixed_lout)),lout_next'length) + to_unsigned(1,lout_next),lout_next'length); 
                    end if;
                else
                    p2_addr_p_o <= std_logic_vector(resize((unsigned(num_of_elements_p_i)),p2_addr_p_o'length));
                    p2_write_p_o <= '1';
                    p2_wdata_p_o <= p1_rdata_p_i;
                    lout_next <= to_unsigned(to_integer(to_sfixed(signed(in_size_i),conversion_sfixed_lout) * resize(alpha_reg,conversion_sfixed_lout)),lout_next'length);
                    if(((to_sfixed(signed(in_size_i),conversion_sfixed_lout) * resize(alpha_reg,conversion_sfixed_lout)) mod 1) < 0.5 )then
                        lout_next <= resize(to_unsigned(to_integer(to_sfixed(signed(in_size_i),conversion_sfixed_lout) * resize(alpha_reg,conversion_sfixed_lout)),lout_next'length) + to_unsigned(1,lout_next),lout_next'length); 
                    end if;

                end if;

                state_next <= p_addr_setup;
                
            when p_addr_setup =>

                    if(erase_flag_reg = '1')then
                        p1_addr_p_o <= std_logic_vector(TO_UNSIGNED(3,p1_addr_p_o'length));
                        n_next <= TO_UNSIGNED(3,n_next'length);
                    else
                        p1_addr_p_o <= std_logic_vector(TO_UNSIGNED(0,p1_addr_p_o'length));
                        n_next <= TO_UNSIGNED(0,n_next'length);
                    end if;
                    state_next <= tk;


            when tk =>
                tk_next <= to_sfixed(signed(p1_rdata_p_i) + 1,tk_next);
                it1_next <= TO_UNSIGNED(0,it1_next'length);
                n_next <= TO_UNSIGNED(0,n_next'length);
                state_next <= matk;


            when matk =>
                     m_stall_next <= signed(p1_rdata_m_i);
                    
                    matk_before_abs_next <= resize(resize((to_sfixed(resize(signed(m_stall_reg),tk_reg'length),tk_reg) * alpha_reg),tk_reg) - tk_reg,tk_reg);
                    p1_wdata_matk_o <= resize(abs(matk_before_abs_reg),p1_wdata_matk_o);

                
                read_m_matk_sf <= to_sfixed(p1_rdata_m_i,conversion_sfixed_65_0);



                if(axi_rnext_out_i = '1' and matk_valid_i = '1') then
                        dva_next <= dva_reg + to_unsigned(1,dva_reg'length);
                        if(dva_reg > to_unsigned(1,dva_next'length))then
                            p1_write_matk_o <= '1';
                            it1_next <= it1_reg + 1;
                        end if;

                        p1_addr_matk_o <= std_logic_vector(it1_reg);

                        if(it1_next < num_of_m_reg - 2) then

                                if(reads_last_m_matk_done_i = '1')then
                                    dva_next <= to_unsigned(0,dva_reg'length);
                                    state_next <= last_matk;
                                else
                                    state_next <= matk;
                                end if;

                        else
                            reset_rez_o <= '1';
                            dva_next <= to_unsigned(0,dva_reg'length);
                            state_next <= last_matk;
                        end if;
                 else

                     state_next <= matk;
                end if;

            

                
            when last_matk =>   
                it1_next <= it1_reg + 1;
                m_stall_next <= signed(p1_rdata_m_i);
                matk_before_abs_next <= resize(resize((to_sfixed(resize(signed(m_stall_reg),tk_reg'length),tk_reg) * alpha_reg),tk_reg) - tk_reg,tk_reg);
                p1_addr_matk_o <= std_logic_vector(it1_reg);
                p1_wdata_matk_o <= resize(abs(matk_before_abs_reg),p1_wdata_matk_o);
                p1_write_matk_o <= '1';

                if(it1_next < num_of_m_reg) then
                    dva_next <= dva_reg + to_unsigned(1,dva_reg'length);
                    if(dva_reg < to_unsigned(1,dva_next'length))then
                        
                        state_next <= last_matk;
                    else
                        dva_next <= to_unsigned(0,dva_reg'length);
                        state_next <= matk;    
                    end if;

                else
                    dva_next <= to_unsigned(0,dva_reg'length);
                    state_next <= addr_min;
                end if;

                    
            when addr_min =>
                first_next <= TO_UNSIGNED(0,first_next'length);
                smallest_next <= TO_UNSIGNED(0,smallest_next'length);
                p1_addr_matk_o <= std_logic_vector(first_next);
                p2_addr_matk_o <= std_logic_vector(smallest_next);
                if(first_next = unsigned(num_of_elements_matk_i)) then
                    smallest_next <= first_next;
                    state_next <= min;
                else
                    state_next <= min;
                end if;
                
            when min =>
                k_next <= to_unsigned(0,k_next'length);
                n_next <= to_unsigned(0,n_next'length);

                if(first_reg < unsigned(num_of_elements_matk_i)) then
                    first_next <= first_reg + TO_UNSIGNED(1,first_next'length);
                    p1_addr_matk_o <= std_logic_vector(first_next);
                    p2_addr_matk_o <= std_logic_vector(smallest_reg);
                    if( p1_rdata_matk_i < p2_rdata_matk_i)then
                        smallest_next <= first_reg;
                        p2_addr_matk_o <= std_logic_vector(smallest_next);

                        state_next <= min;
                    else
                        state_next <= min;
                    end if;
                else
                    state_next <= p_addr;
                end if;

            when p_addr =>
                if(erase_flag_reg = '1') then
                    p1_addr_p_o <= std_logic_vector(resize(smallest_next,p1_addr_p_o'length));
                    smallest_next <= smallest_reg + TO_UNSIGNED(3,smallest_next'length);
                    state_next <= place;
                else
                    p1_addr_p_o <= std_logic_vector(resize(smallest_next,p1_addr_p_o'length));
                    state_next <= place;
                
                end if;

            when place =>
                pit_next <= resize(signed(p1_rdata_p_i),pit_next'length);
                place_enable_o <= '1';
                state_next <= pitStr_calc;

            when pitStr_calc =>
                pitStr_tmp_next <= resize((to_sfixed(pit_reg,gamma_reg) * gamma_rec_reg_i), pitStr_tmp_next);

                han_start_cnt_next <= TO_UNSIGNED(0,han_start_cnt_next'length);
                
                han_sel_next <= '1';

                state_next <= opseg_set;


            when opseg_set =>
                place_enable_o <= '1';
                    pitStr_next <= to_signed(to_integer(pitStr_tmp_reg),pitStr_next'length);

                if(axi_rready_i = '1' and axi_rvalid_i = '1')then

                        state_next <= opseg;

                else
                    state_next <= opseg_set;
                end if;

            when opseg =>
                place_enable_o <= '1';
                
                if(axi_rready_i = '1' and axi_rvalid_i = '1')then
                    opseg_begin_next <= resize((unsigned(p1_rdata_m_i) - resize((unsigned(pit_next) + to_unsigned(1,pit_next'length)),p1_rdata_m_i'length)),opseg_begin_next'length);
                    opseg_end_next <= resize((unsigned(p1_rdata_m_i) + resize(unsigned(pit_next),p1_rdata_m_i'length)),opseg_end_next'length);
                    opseg_addr_valid_next <= '1';
                    place_enable_o <= '1';

                    state_next <= start_han;
                else
                    state_next <= opseg;
                end if;

            when start_han =>
                itype1_han_o <= '0';
                if(han_start_cnt_reg < to_unsigned(7,han_start_cnt_reg'length)) then
                    han_start_cnt_next <= han_start_cnt_reg + TO_UNSIGNED(1,han_start_cnt_next'length);
                    start_han_o <= '1';

                    state_next <= start_han;
                else
                    state_next <= han;
                end if;  

            when han =>

                    if(ready_han_i = '1') then
                        i_next <= TO_UNSIGNED(0,i_next'length);
                        w_next <= p1_rdata_w_i;
                        p1_addr_opseg_o <= std_logic_vector(resize(i_next,p1_addr_opseg_o'length));
                        p1_addr_gr_o <= std_logic_vector(resize(i_next,p1_addr_gr_o'length));
                        p1_addr_w_o <= std_logic_vector(resize(i_next,p1_addr_w_o'length));

                        iniGr_next <= to_unsigned(to_integer(tk_reg) - to_integer(pitStr_reg),iniGr_next'length);
                        endGr_next <= to_unsigned(to_integer(tk_reg) + to_integer(pitStr_reg),endGr_next'length);

                        state_next <= gr;
                
                    else
                        state_next <= han;
                    end if;

                when gr =>
                    han_sel_next <= '0';
                    p1_addr_w_o <= std_logic_vector(resize(i_next,p1_addr_w_o'length));
                        w_next <= p1_rdata_w_i;

                        p1_wdata_gr_o <= resize(p1_rdata_opseg_i * w_next,p1_wdata_gr_o);

                        if(axi_rnext_out_i = '1') then
                            i_next <= i_reg + TO_UNSIGNED(1,i_next'length);
                            p1_addr_gr_o <= std_logic_vector(resize(i_reg,p1_addr_gr_o'length));
                            p1_write_gr_o <= '1';

                            if(resize(i_next,num_of_elements_opseg_i'length) < (opseg_end_reg - opseg_begin_reg)) then
                                state_next <= gr;
                            else
                                state_next <= par1_addr;
                            end if;

                        else
                            state_next <= gr;
                        end if;


                when par1_addr =>
                    opseg_addr_valid_next <= '0';
                    par1_addr_next <= TO_UNSIGNED(0,par1_addr_next'length);
                    pit_temp_next <= resize(-pit_reg,pit_temp_next'length);
                    p1_addr_par1_o <= std_logic_vector(resize(par1_addr_next,p1_addr_par1_o'length));
                    if(pit_temp_next <= resize(pit_reg - TO_SIGNED(1,pit_reg'length),pit_temp_next'length)) then
                        p2_addr_par1_o <= std_logic_vector(resize(par1_addr_next + TO_UNSIGNED(1,par1_addr_next'length),p2_addr_par1_o'length));
                        
                        state_next <= par1;
                    else

                        state_next <= par1;
                    end if;


                when par1 =>
                    pit_temp_next <= pit_temp_reg + to_signed(2,pit_temp_next'length);
                    p1_wdata_par1_o <= to_sfixed(pit_temp_reg,p1_wdata_par1_o);
                    p1_write_par1_o <= '1';
                    p2_wdata_par1_o <= to_sfixed(pit_temp_reg + TO_SIGNED(1,pit_temp_reg'length),p2_wdata_par1_o);
                    par1_addr_next <= par1_addr_reg + TO_UNSIGNED(2,par1_addr_next'length);
                    p1_addr_par1_o <= std_logic_vector(resize(par1_addr_reg,p1_addr_par1_o'length));
                    if(pit_temp_reg < resize(pit_reg - TO_SIGNED(1,pit_reg'length),pit_temp_next'length)) then
                        p2_addr_par1_o <= std_logic_vector(resize(par1_addr_reg + TO_UNSIGNED(1,par1_addr_next'length),p2_addr_par1_o'length));
                        p2_write_par1_o <= '1';
                        state_next <= par1;
                    else
                        neg_pitStr_next <= to_sfixed(-pitStr_reg,neg_pitStr_next);
                        gamma_next <= gamma_reg_i;
                        state_next <= par1_last;
                    end if;

                
                when par1_last =>
                    pit_temp_next <= pit_temp_reg + to_signed(2,pit_temp_next'length);
                   
                    p1_wdata_par1_o <= to_sfixed(pit_temp_reg,p1_wdata_par1_o);
                    
                    p2_wdata_par1_o <= to_sfixed(pit_temp_reg + TO_SIGNED(1,pit_temp_reg'length),p2_wdata_par1_o);
                    par1_addr_next <= par1_addr_reg + TO_UNSIGNED(2,par1_addr_next'length);
                    p1_addr_par1_o <= std_logic_vector(resize(par1_addr_reg,p1_addr_par1_o'length));
                    if(pit_temp_reg < pit_reg) then
                        p1_write_par1_o <= '1';
                        p2_write_par1_o <= '1';
                        state_next <= par1_last;
                    else
                        i_next <= TO_UNSIGNED(0,i_next'length);

                        iter_next <= (resize(neg_pitStr_reg * gamma_reg,iter_next));

                        state_next <= par3;
                    end if;

                
                when par3 =>
                    iter_next <= resize(iter_reg + gamma_reg,iter_next);
                    p1_wdata_par3_o <= iter_reg;
                    p1_write_par3_o <= '1';
                    i_next <= i_reg + TO_UNSIGNED(1,i_next'length);
                    p1_addr_par3_o <= std_logic_vector(resize(i_reg,p1_addr_par3_o'length));
                    
                    iter_next_debug <= to_integer(iter_next);
                    
                    if(to_integer(iter_next) <= pit_reg) then
                        state_next <= par3;
                    else
                        han_start_cnt_next <= TO_UNSIGNED(0,han_start_cnt_next'length);
                        
                        state_next <= start_interp1;
                    end if;

                
                when start_interp1 =>
                    if(han_start_cnt_reg < to_unsigned(7,han_start_cnt_reg'length)) then
                        han_start_cnt_next <= han_start_cnt_reg + TO_UNSIGNED(1,han_start_cnt_next'length);

                        itp_sel_next <= '1';
                        start_interp1_o <= '1';

                        state_next <= start_interp1;
                    else
                        state_next <= interp1;
                    end if; 

                when interp1 =>

                    if(ready_interp1_i = '1') then
                        if(resize(endGr_reg,lout_reg'length) > lout_reg) then
                            state_next <= idle;
                        else
                            k_next <= to_unsigned(0,k_next'length);
                            i_next <= resize(iniGr_reg - 1,i_next'length);

                            state_next <= out_asmd;
                        end if;
                    else

                        state_next <= interp1;
                    end if;

                when out_asmd =>
                    p2_wdata_out_o <= resize(p1_rdata_out_i + resize(rez_next,p1_rdata_out_i),p2_wdata_out_o);

                    p1_addr_out_o <= std_logic_vector(resize(i_next,p1_addr_out_o'length));
                    p2_addr_out_o <= std_logic_vector(resize(i_reg,p2_addr_out_o'length));
                    p1_addr_rez_o <= std_logic_vector(resize(k_next,p1_addr_rez_o'length));
                    rez_next <= p1_rdata_rez_i;

                    if(axi_wnext_out_i = '1') then
                        p2_write_out_o <= '1';
                        i_next <= i_reg + TO_UNSIGNED(1,i_next'length);
                        --Izmenjeno 15. april 2024
                        if(i_next < resize(endGr_reg,i_next'length)) then
                            if(k_reg < (unsigned(num_of_elements_rez_i))) then

                                k_next <= k_reg + to_unsigned(1,k_next'length);
                            end if;

                            state_next <= out_asmd;
                        else
                            tk_temp_next <= resize((to_sfixed(pit_reg,beta_reg)*beta_reg_i),tk_temp_next);

                            state_next <= out_asmd_2;
                        end if;
                    else
                        
                        state_next <= out_asmd;
                    end if;


                    when out_asmd_2 =>
                        tk_next <= resize((tk_reg + tk_temp_reg),tk_next);

                        reset_matk_o <= '1';
                        reset_opseg_o <= '1';
                        reset_han_o <= '1';
                        reset_gr_o <= '1';
                        reset_par1_o <= '1';
                        reset_par3_o <= '1';

                        itp_sel_next <= '0';
                        it1_next <= TO_UNSIGNED(0,it1_next'length);
                            if(to_unsigned(to_integer(tk_next),lout_reg) < lout_reg) then
                                n_next <= TO_UNSIGNED(0,n_next'length);
                                m_stall_next <= signed(p1_rdata_m_i);
                                state_next <= matk;
                            else
                                state_next <= idle;
                            end if;
                        
        end case;
    end process; 
end Behavioral;
