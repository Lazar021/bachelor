----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/07/2021 03:09:17 PM
-- Design Name: 
-- Module Name: mem_subsystem - Behavioral
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
--use work.package_rom_han.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mem_subsystem is
    generic(

        ADDR_W                      : integer := 16;
        C_M_AXI_ADDR_WIDTH	        : integer	:= 20;


        --OPSEG memorija
        SIZE_OPSEG_TOP              : integer := 5000;
        W_HIGH_OPSEG_ADDR_TOP       : integer := 14;
        W_HIGH_OPSEG_TOP            : integer := 2;
        W_LOW_OPSEG_TOP             : integer := -25;
        --M memorija
        SIZE_M_TOP                 : integer := 1000;
        SIZE_ADDR_W_M              : integer := 14;
        W_HIGH_M_TOP               : integer := 32;
        W_LOW_M_TOP                : integer := 0;
        --OUT memorija
        SIZE_OUT_TOP               : integer := 1000;
        SIZE_ADDR_W_OUT            : integer := 14;
        W_HIGH_OUT_TOP             : integer := 1;
        W_LOW_OUT_TOP              : integer := -30;
        --PAR1 memorija
        SIZE_PAR1              : integer := 2500;
        W_HIGH_PAR1            : integer := 12;
        W_LOW_PAR1             : integer := 0;
        --GR memorija
        SIZE_GR                : integer := 4500;
        W_HIGH_GR              : integer := 1;
        W_LOW_GR               : integer := -40;
        --W memorija
        SIZE_W                 : integer := 5000;
        W_HIGH_W               : integer := 1;
        W_LOW_W                : integer := -31

  );
  port(
        clk                    : in std_logic;
        reset                  : in std_logic;

        --Interface to the AXI controllers
        abg_i                       : in std_logic_vector(32 - 1 downto 0);
        in_size_top_i               : in std_logic_vector(W_HIGH_M_TOP - 1 downto 0);
        m_size_top_i                : in std_logic_vector(log2c(SIZE_M_TOP) - 1 downto 0);
        alpha_wr_i                  : in std_logic;                        
        beta_wr_i                   : in std_logic;    
        gamma_wr_i                  : in std_logic;   
        gamma_rec_wr_i              : in std_logic;  
        in_size_wr_i                : in std_logic;    
        m_size_wr_i                 : in std_logic;  
        ready_han_top_i             : in std_logic;  
        ready_wr_top_i				: in std_logic;
        ready_psolaf_top_i          : in std_logic;
        ready_psolaf_wr_top_i	    : in std_logic;
                        
        
        alpha_axi_o                 : out sfixed(9 downto -22);
        beta_axi_o                  : out sfixed(9 downto -22);
        gamma_axi_o                 : out sfixed(9 downto -22);
        gamma_rec_axi_o             : out sfixed(9 downto -22);
        in_size_axi_o               : out std_logic_vector(W_HIGH_M_TOP - 1 downto 0);
        m_size_axi_o                : out std_logic_vector(log2c(SIZE_M_TOP) - 1 downto 0);
        ready_han_axi_o             : out std_logic; 
        ready_psolaf_axi_o          : out std_logic;

        --Interface to the psolaf module
        alpha_o                     : out sfixed(9 downto -22);
        beta_o                      : out sfixed(9 downto -22);
        gamma_o                     : out sfixed(9 downto -22);
        gamma_rec_o                 : out sfixed(9 downto -22);
        in_size_o                   : out std_logic_vector(W_HIGH_M_TOP - 1 downto 0);

        --Interfejs par 1 memorije-----------------------------------------------------------------------------------
        itp_sel_i          : in std_logic;
        reset_par1_i       : in std_logic;
        --Port 1 interface
        p1_addr_par1_i     : in std_logic_vector(log2c(SIZE_PAR1) - 1 downto 0);
        p1_wdata_par1_i    : in sfixed(W_HIGH_PAR1 - 1 downto W_LOW_PAR1);
        p1_rdata_par1_o    : out sfixed(W_HIGH_PAR1 - 1 downto W_LOW_PAR1);
        p1_write_par1_i    : in std_logic;
        --Port 2 interface
        p2_addr_par1_i     : in std_logic_vector(log2c(SIZE_PAR1) - 1 downto 0);
        p2_wdata_par1_i    : in sfixed(W_HIGH_PAR1 - 1 downto W_LOW_PAR1);
        p2_rdata_par1_o    : out sfixed(W_HIGH_PAR1 - 1 downto W_LOW_PAR1);
        p2_write_par1_i    : in std_logic;
        --Port 3 interface
        p3_addr_par1_i     : in std_logic_vector(log2c(SIZE_PAR1) - 1 downto 0);
        p3_wdata_par1_i    : in sfixed(W_HIGH_PAR1 - 1 downto W_LOW_PAR1);
        p3_rdata_par1_o    : out sfixed(W_HIGH_PAR1 - 1 downto W_LOW_PAR1);
        p3_write_par1_i    : in std_logic;
        --Port 4 interface
        p4_addr_par1_i     : in std_logic_vector(log2c(SIZE_PAR1) - 1 downto 0);
        p4_wdata_par1_i    : in sfixed(W_HIGH_PAR1 - 1 downto W_LOW_PAR1);
        p4_rdata_par1_o    : out sfixed(W_HIGH_PAR1 - 1 downto W_LOW_PAR1);
        p4_write_par1_i    : in std_logic;
        num_of_elements_par1_o : out std_logic_vector(log2c(SIZE_PAR1) - 1 downto 0);      
   
        --Interfejs gr memorije-----------------------------------------------------------------------------------
        reset_gr_i       : in std_logic;
        --Port 1 interface
        p1_addr_gr_i     : in std_logic_vector(log2c(SIZE_GR) - 1 downto 0);
        p1_wdata_gr_i    : in sfixed(W_HIGH_GR - 1 downto W_LOW_GR);
        p1_rdata_gr_o    : out sfixed(W_HIGH_GR - 1 downto W_LOW_GR);
        p1_write_gr_i    : in std_logic;
        --Port 2 interface
        p2_addr_gr_i     : in std_logic_vector(log2c(SIZE_GR) - 1 downto 0);
        p2_wdata_gr_i    : in sfixed(W_HIGH_GR - 1 downto W_LOW_GR);
        p2_rdata_gr_o    : out sfixed(W_HIGH_GR - 1 downto W_LOW_GR);
        p2_write_gr_i    : in std_logic;
        --Port 3 interface
        p3_addr_gr_i     : in std_logic_vector(log2c(SIZE_GR) - 1 downto 0);
        p3_wdata_gr_i    : in sfixed(W_HIGH_GR - 1 downto W_LOW_GR);
        p3_rdata_gr_o    : out sfixed(W_HIGH_GR - 1 downto W_LOW_GR);
        p3_write_gr_i    : in std_logic;
        num_of_elements_gr_o : out std_logic_vector(log2c(SIZE_GR) - 1 downto 0);

        --Interfejs w memorije-----------------------------------------------------------------------------------
        han_sel_i       : in std_logic;
        reset_w_i       : in std_logic;
        --Port 1 interface
        p1_addr_w_i     : in std_logic_vector(log2c(SIZE_W) - 1 downto 0);
        p1_wdata_w_i    : in sfixed(W_HIGH_W - 1 downto W_LOW_W);
        p1_rdata_w_o    : out sfixed(W_HIGH_W - 1 downto W_LOW_W);
        p1_write_w_i    : in std_logic;
        --Port 2 interface
        p2_addr_w_i     : in std_logic_vector(log2c(SIZE_W) - 1 downto 0);
        p2_wdata_w_i    : in sfixed(W_HIGH_W - 1 downto W_LOW_W);
        p2_rdata_w_o    : out sfixed(W_HIGH_W - 1 downto W_LOW_W);
        p2_write_w_i    : in std_logic;
        --Port 3 interface
        p3_addr_w_i     : in std_logic_vector(log2c(SIZE_W) - 1 downto 0);
        p3_wdata_w_i    : in sfixed(W_HIGH_W - 1 downto W_LOW_W);
        p3_rdata_w_o    : out sfixed(W_HIGH_W - 1 downto W_LOW_W);
        p3_write_w_i    : in std_logic;
        num_of_elements_w_o : out std_logic_vector(log2c(SIZE_W) - 1 downto 0)
    );
end mem_subsystem;

architecture Behavioral of mem_subsystem is

    signal  alpha_s     : sfixed(9 downto -22);
    signal  beta_s      : sfixed(9 downto -22);
    signal  gamma_s     : sfixed(9 downto -22);
    signal  gamma_rec_s : sfixed(9 downto -22);
    signal  in_size_s   : std_logic_vector(W_HIGH_M_TOP - 1 downto 0);
    signal  m_size_s    : std_logic_vector(log2c(SIZE_M_TOP) - 1 downto 0);
    signal  en_opseg_s  : std_logic;
    signal  en_m_s      : std_logic;
    signal  en_out_s    : std_logic;
    signal  ready_han_s    : std_logic;
    signal  ready_psolaf_s    : std_logic;
    
    signal  m_reg       : unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP); 
    signal  m_stall_reg : unsigned(W_HIGH_M_TOP - 1 downto W_LOW_M_TOP); 

    signal reset_par1_s           : std_logic;
    signal p1_addr_par1_o_s         : std_logic_vector(log2c(SIZE_PAR1) - 1 downto 0);
    signal p1_rdata_par1_i_s        : sfixed(W_HIGH_PAR1 - 1 downto W_LOW_PAR1);
    signal p1_wdata_par1_o_s        : sfixed(W_HIGH_PAR1 - 1 downto W_LOW_PAR1);
    signal p1_write_par1_o_s        : std_logic;
    signal p2_addr_par1_o_s         : std_logic_vector(log2c(SIZE_PAR1) - 1 downto 0);
    signal p2_rdata_par1_i_s        : sfixed(W_HIGH_PAR1 - 1 downto W_LOW_PAR1);
    signal p2_wdata_par1_o_s        : sfixed(W_HIGH_PAR1 - 1 downto W_LOW_PAR1);
    signal p2_write_par1_o_s        : std_logic;
    signal num_of_elements_par1_i_s : std_logic_vector(log2c(SIZE_PAR1) - 1 downto 0);  

    signal reset_gr_s           : std_logic;
    signal p1_addr_gr_o_s         : std_logic_vector(log2c(SIZE_GR) - 1 downto 0);
    signal p1_rdata_gr_i_s        : sfixed(W_HIGH_GR - 1 downto W_LOW_GR);
    signal p1_wdata_gr_o_s        : sfixed(W_HIGH_GR - 1 downto W_LOW_GR);
    signal p1_write_gr_o_s        : std_logic;
    signal p2_addr_gr_o_s         : std_logic_vector(log2c(SIZE_GR) - 1 downto 0);
    signal p2_rdata_gr_i_s        : sfixed(W_HIGH_GR - 1 downto W_LOW_GR);
    signal p2_wdata_gr_o_s        : sfixed(W_HIGH_GR - 1 downto W_LOW_GR);
    signal p2_write_gr_o_s        : std_logic;
    signal num_of_elements_gr_i_s : std_logic_vector(log2c(SIZE_GR) - 1 downto 0);  

    signal han_sel_s            : std_logic;
    signal reset_w_s           : std_logic;
    signal p1_addr_w_o_s         : std_logic_vector(log2c(SIZE_W) - 1 downto 0);
    signal p1_rdata_w_i_s        : sfixed(W_HIGH_W - 1 downto W_LOW_W);
    signal p1_wdata_w_o_s        : sfixed(W_HIGH_W - 1 downto W_LOW_W);
    signal p1_write_w_o_s        : std_logic;
    signal p2_addr_w_o_s         : std_logic_vector(log2c(SIZE_W) - 1 downto 0);
    signal p2_rdata_w_i_s        : sfixed(W_HIGH_W - 1 downto W_LOW_W);
    signal p2_wdata_w_o_s        : sfixed(W_HIGH_W - 1 downto W_LOW_W);
    signal p2_write_w_o_s        : std_logic;
    signal num_of_elements_w_i_s : std_logic_vector(log2c(SIZE_W) - 1 downto 0);  

begin

    alpha_o      <= alpha_s;
    beta_o       <= beta_s;
    gamma_o      <= gamma_s;
    gamma_rec_o  <= gamma_rec_s;
    in_size_o    <= in_size_s;


    -------------------------REGISTERS----------------------------
    alpha_axi_o     <= alpha_s;
    beta_axi_o      <= beta_s;
    gamma_axi_o     <= gamma_s;
    gamma_rec_axi_o <= gamma_rec_s;
    in_size_axi_o   <= in_size_s;
    m_size_axi_o    <= m_size_s;
    ready_han_axi_o <= ready_han_s;
    ready_psolaf_axi_o <= ready_psolaf_s;

    --Alpha register
    process(clk)
    begin
        if clk'event and clk ='1' then
            if reset = '1' then
                alpha_s <= (others => '0');
            elsif alpha_wr_i = '1' then
                alpha_s <= to_sfixed(abg_i,alpha_s);
            end if;          
        end if;
    end process;

    --Beta register
    process(clk)
    begin
        if clk'event and clk ='1' then
            if reset = '1' then
                beta_s <= (others => '0');
            elsif beta_wr_i = '1' then
                beta_s <= to_sfixed(abg_i,beta_s);
            end if;          
        end if;
    end process;

    --Gamma register
    process(clk)
    begin
        if clk'event and clk ='1' then
            if reset = '1' then
                gamma_s <= (others => '0');
            elsif gamma_wr_i = '1' then
                gamma_s <= to_sfixed(abg_i,gamma_s);
            end if;          
        end if;
    end process;

    --Gamma_rec register
    process(clk)
    begin
        if clk'event and clk ='1' then
            if reset = '1' then
                gamma_rec_s <= (others => '0');
            elsif gamma_rec_wr_i = '1' then
                gamma_rec_s <= to_sfixed(abg_i,gamma_rec_s);
            end if;          
        end if;
    end process;

    --In_size register
    process(clk)
    begin
        if clk'event and clk ='1' then
            if reset = '1' then
                in_size_s <= (others => '0');
            elsif in_size_wr_i = '1' then
                in_size_s <= in_size_top_i;
            end if;          
        end if;
    end process;
    

    --M_size register
    process(clk)
    begin
        if clk'event and clk ='1' then
            if reset = '1' then
                m_size_s <= (others => '0');
            elsif m_size_wr_i = '1' then
                m_size_s <= m_size_top_i;
            end if;          
        end if;
    end process;

    --HAN_READY register
    process(clk)
    begin
        if clk'event and clk ='1' then
            if reset = '1' then
                ready_han_s <= '0';
            elsif(ready_wr_top_i = '1')then
                ready_han_s <= ready_han_top_i;
            end if;          
        end if;
    end process;

    --PSOLAF_READY register
    process(clk)
    begin
        if clk'event and clk ='1' then
            if reset = '1' then
                ready_psolaf_s <= '0';
            elsif(ready_psolaf_wr_top_i = '1')then
                ready_psolaf_s <= ready_psolaf_top_i;
            end if;          
        end if;
    end process;

   --PAR1 memorija
   mem_par1: entity work.mem_double_port_par1(Beh)
   generic map(
       SIZE_PAR1    => SIZE_PAR1,
       W_HIGH_PAR1 => W_HIGH_PAR1,
       W_LOW_PAR1  => W_LOW_PAR1
   )
   port map(
       clk => clk,
       --reset => reset_par1_s,
       reset => reset_par1_i,
       p1_addr_i =>       p1_addr_par1_o_s,
       p1_rdata_o =>      p1_rdata_par1_i_s,
       p1_wdata_i =>      p1_wdata_par1_o_s,
       p1_write_i =>      p1_write_par1_o_s,
       p2_addr_i =>       p2_addr_par1_o_s,
       p2_rdata_o =>      p2_rdata_par1_i_s,
       p2_wdata_i =>      p2_wdata_par1_o_s,
       p2_write_i =>      p2_write_par1_o_s,
       num_of_elements => num_of_elements_par1_i_s
   );

    p1_addr_par1_o_s  <= p1_addr_par1_i when itp_sel_i = '1' else p3_addr_par1_i;
    p1_rdata_par1_o <= p1_rdata_par1_i_s when itp_sel_i = '1' else (others => '0');
    p3_rdata_par1_o <= p1_rdata_par1_i_s when itp_sel_i = '0' else (others => '0');
    p1_wdata_par1_o_s <= p1_wdata_par1_i when itp_sel_i = '1' else p3_wdata_par1_i;
    p1_write_par1_o_s <= p1_write_par1_i when itp_sel_i = '1' else p3_write_par1_i;
    p2_addr_par1_o_s  <= p2_addr_par1_i when itp_sel_i = '1' else p4_addr_par1_i;
    p2_rdata_par1_o <= p2_rdata_par1_i_s when itp_sel_i = '1' else (others => '0');
    p4_rdata_par1_o <= p2_rdata_par1_i_s when itp_sel_i = '0' else (others => '0');
    p2_wdata_par1_o_s <= p2_wdata_par1_i when itp_sel_i = '1' else p4_wdata_par1_i;
    p2_write_par1_o_s <= p2_write_par1_i when itp_sel_i = '1' else p4_write_par1_i;
    num_of_elements_par1_o <= num_of_elements_par1_i_s when itp_sel_i = '1' else (others => '0');


   --GR memorija
   mem_gr: entity work.mem_double_port_gr(Beh)
   generic map(
        SIZE_GR    => SIZE_GR,
        W_HIGH_GR => W_HIGH_GR,
        W_LOW_GR  => W_LOW_GR
   )
   port map(
       clk => clk,
       --reset => reset_gr_s,
       reset => reset_gr_i,
       p1_addr_i =>       p1_addr_gr_o_s,
       p1_rdata_o =>      p1_rdata_gr_i_s,
       p1_wdata_i =>      p1_wdata_gr_o_s,
       p1_write_i =>      p1_write_gr_o_s,
       p2_addr_i =>       p2_addr_gr_o_s,
       p2_rdata_o =>      p2_rdata_gr_i_s,
       p2_wdata_i =>      p2_wdata_gr_o_s,
       p2_write_i =>      p2_write_gr_o_s,
       num_of_elements => num_of_elements_gr_i_s
   );


   reset_gr_s <= reset_gr_i;
   p1_addr_gr_o_s  <= p1_addr_gr_i when itp_sel_i = '1' else p3_addr_gr_i;
   p1_rdata_gr_o <= p1_rdata_gr_i_s when itp_sel_i = '1' else (others => '0');
   p3_rdata_gr_o <= p1_rdata_gr_i_s when itp_sel_i = '0' else (others => '0');

   p1_wdata_gr_o_s <= p1_wdata_gr_i when itp_sel_i = '1' else p3_wdata_gr_i;
   p1_write_gr_o_s <= p1_write_gr_i when itp_sel_i = '1' else p3_write_gr_i;
   p2_addr_gr_o_s  <= p2_addr_gr_i when itp_sel_i = '1' else (others => '0');

   p2_rdata_gr_o <= p2_rdata_gr_i_s when itp_sel_i = '1' else (others => '0');
   p2_wdata_gr_o_s <= p2_wdata_gr_i when itp_sel_i = '1' else (others => '0');
   p2_write_gr_o_s <= p2_write_gr_i when itp_sel_i = '1' else '0';
   num_of_elements_gr_o <= num_of_elements_gr_i_s when itp_sel_i = '1' else (others => '0');


    --W memorija
    mem_w: entity work.mem_w_triple(Beh)
    generic map(
        SIZE_W  => SIZE_W,
        W_HIGH_W => W_HIGH_W,
        W_LOW_W  => W_LOW_W
    )
    port map(
        clk => clk,
        reset =>           reset_w_s,
        p1_addr_i =>       p1_addr_w_o_s,
        p1_rdata_o =>      p1_rdata_w_i_s,
        p1_wdata_i =>      p1_wdata_w_o_s,
        p1_write_i =>      p1_write_w_o_s,
        p2_addr_i =>       p2_addr_w_o_s,
        p2_rdata_o =>      p2_rdata_w_i_s,
        p2_wdata_i =>      p2_wdata_w_o_s,
        p2_write_i =>      p2_write_w_o_s,
        num_of_elements => num_of_elements_w_i_s
    );

    reset_w_s <= reset_w_i;
    p1_addr_w_o_s  <= p1_addr_w_i when han_sel_i = '1' else p3_addr_w_i;
    p1_rdata_w_o <= p1_rdata_w_i_s when han_sel_i = '1' else (others => '0');
    p3_rdata_w_o <= p1_rdata_w_i_s when han_sel_i = '0' else (others => '0');
 
    p1_wdata_w_o_s <= p1_wdata_w_i when han_sel_i = '1' else p3_wdata_w_i;
    p1_write_w_o_s <= p1_write_w_i when han_sel_i = '1' else p3_write_w_i;
    p2_addr_w_o_s  <= p2_addr_w_i when han_sel_i = '1' else (others => '0');
 
    p2_rdata_w_o <= p2_rdata_w_i_s when han_sel_i = '1' else (others => '0');
    p2_wdata_w_o_s <= p2_wdata_w_i when han_sel_i = '1' else (others => '0');
    p2_write_w_o_s <= p2_write_w_i when han_sel_i = '1' else '0';
    num_of_elements_w_o <= num_of_elements_w_i_s when han_sel_i = '1' else (others => '0');
 
end Behavioral;
