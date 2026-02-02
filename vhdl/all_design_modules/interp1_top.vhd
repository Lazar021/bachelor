----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/13/2021 01:32:06 PM
-- Design Name: 
-- Module Name: interp1_top - Behavioral
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
--use ieee.fixed_pkg.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity interp1_top is
    generic(
        SIZE_gr         : integer := 1000;
        SIZE_par1       : integer := 1000;
        SIZE_par3       : integer := 1000;
        SIZE_rez        : integer := 1000;
        W_HIGH_PAR1     : integer := 12;
        W_HIGH_PAR3     : integer := 12;
        W_HIGH_GR       : integer := 1;
        W_HIGH_REZ      : integer := 12;
        W_LOW_PAR1      : integer := 0;
        W_LOW_PAR3      : integer := -50;
        W_LOW_GR        : integer := -40;
        W_LOW_REZ       : integer := -50
    );
    port(
        clk                    : in std_logic;
        reset                  : in std_logic;
        start                  : in std_logic;
        ready                  : out std_logic;

        --Interfejs par 1 memorije-----------------------------------------------------------------------------------
        --Port 1 interface
         p1_addr_par1_o         : out std_logic_vector(log2c(SIZE_par1) - 1 downto 0);
         p1_wdata_par1_o        : out sfixed(W_HIGH_PAR1 - 1 downto W_LOW_PAR1);
         p1_rdata_par1_i        : in sfixed(W_HIGH_PAR1 - 1 downto W_LOW_PAR1);
         p1_write_par1_o        : out std_logic;
         --Port 2 interface
         p2_addr_par1_o         : out std_logic_vector(log2c(SIZE_par1) - 1 downto 0);
         p2_wdata_par1_o        : out sfixed(W_HIGH_PAR1 - 1 downto W_LOW_PAR1);
         p2_rdata_par1_i        : in sfixed(W_HIGH_PAR1 - 1 downto W_LOW_PAR1);
         p2_write_par1_o        : out std_logic;
         num_of_elements_par1_i : in std_logic_vector(log2c(SIZE_par1) - 1 downto 0);  
         --Interfejs gr memorije--------------------------------------------------------------------------------------
         --Port 1 interface
         p1_addr_gr_o           : out std_logic_vector(log2c(SIZE_gr) - 1 downto 0);
         p1_wdata_gr_o          : out sfixed(W_HIGH_GR - 1 downto W_LOW_GR);
         p1_rdata_gr_i          : in sfixed(W_HIGH_GR - 1 downto W_LOW_GR);
         p1_write_gr_o          : out std_logic;
         --Port 2 interface
         p2_addr_gr_o           : out std_logic_vector(log2c(SIZE_gr) - 1 downto 0);
         p2_wdata_gr_o          : out sfixed(W_HIGH_GR - 1 downto W_LOW_GR);
         p2_rdata_gr_i          : in sfixed(W_HIGH_GR - 1 downto W_LOW_GR);
         p2_write_gr_o          : out std_logic;
         --Interfejs par 3 memorije------------------------------------------------------------------------------------
         --Port 1 interface
         p1_addr_par3_o         : out std_logic_vector(log2c(SIZE_par3) - 1 downto 0);
         p1_wdata_par3_o        : out sfixed(W_HIGH_PAR3 - 1 downto W_LOW_PAR3);
         p1_rdata_par3_i        : in sfixed(W_HIGH_PAR3 - 1 downto W_LOW_PAR3);
         p1_write_par3_o        : out std_logic;
         num_of_elements_par3_i : in std_logic_vector(log2c(SIZE_par3) - 1 downto 0);
         --Interfejs rez memorije--------------------------------------------------------------------------------------
         p1_addr_rez_o          : out std_logic_vector(log2c(SIZE_rez) - 1 downto 0);
         p1_wdata_rez_o         : out sfixed(W_HIGH_REZ - 1  downto W_LOW_REZ );
         p1_write_rez_o         : out std_logic
    );
end interp1_top;

architecture Behavioral of interp1_top is

    type state_type is(idle,nni,dist,par1_adr_inc,cmp_calc,DxDy,rcpDx,calc_m,m_setup,calc_b,b_setup,end_asmd,
    calc_par3m);
    signal  state_reg,state_next                 : state_type;
    signal  k_reg,k_next                         : unsigned(log2c(SIZE_par1) - 1 downto 0);
    signal  i_reg,i_next                         : unsigned(log2c(SIZE_par3) - 1 downto 0);
    signal  dx_reg,dx_next                       : sfixed(W_HIGH_PAR1 downto W_LOW_PAR1);
    signal  dy_reg,dy_next                       : sfixed(1 downto -30);

    signal  m_reg,m_next                         : sfixed(1 downto -30);

    signal  b_reg,b_next                         : sfixed(W_HIGH_PAR1 downto W_LOW_GR);
    
    
    signal  x_max_idx_reg,x_max_idx_next         : unsigned(log2c(SIZE_par1) - 1 downto 0);
    signal  x_new_size_reg,x_new_size_next       : unsigned(log2c(SIZE_par3) - 1 downto 0);
    signal  dist_reg,dist_next                   : ufixed(W_HIGH_PAR3 downto -25);
    signal  new_dist_reg,new_dist_next           : ufixed(W_HIGH_PAR3 downto -25);
    signal  idx_reg,idx_next                     : unsigned(log2c(SIZE_par1) - 1 downto 0);
    signal  idx_m_one_reg,idx_m_one_next         : unsigned(log2c(SIZE_par1) - 1 downto 0);
    signal  idx_p_one_reg,idx_p_one_next         : unsigned(log2c(SIZE_par1) - 1 downto 0);
    signal  par1_idx_m_one_reg,par1_idx_m_one_next  : sfixed(W_HIGH_PAR1 - 1 downto W_LOW_PAR1); 
    signal  par1_idx_p_one_reg,par1_idx_p_one_next  : sfixed(W_HIGH_PAR1 - 1 downto W_LOW_PAR1);


    signal  gr_idx_m_one_reg,gr_idx_m_one_next      : sfixed(1 downto -30);
    signal  gr_idx_p_one_reg,gr_idx_p_one_next      : sfixed(1 downto -30);


    signal stage1_m_next,stage1_m_reg    : sfixed(1 downto -30);
    signal stage1_b_next,stage1_b_reg       : sfixed(W_HIGH_PAR1 downto W_LOW_GR);
    signal cmp1_next,cmp2_next,cmp3_next,cmp1_reg,cmp2_reg,cmp3_reg : boolean;


    signal rcp_dx_next,rcp_dx_reg                      : sfixed(W_HIGH_PAR1 downto W_LOW_PAR1);
    signal stage1_par3m_next,stage1_par3m_reg   : sfixed(W_HIGH_PAR3 downto -25);
    signal stage1_par3m_next_debug              : sfixed(W_HIGH_PAR3 - 1 downto W_LOW_PAR3);
    signal m_mult_par3                         : sfixed(W_HIGH_PAR1 - 1 downto W_LOW_GR);

begin

    --State and data registers
    process(clk,reset)
    begin
        if(clk'event and clk = '1')then
            if reset = '1' then
                state_reg <= idle;
                k_reg <= (others => '0');
                i_reg <= (others => '0');
                dx_reg <= (others => '0');
                dy_reg <= (others => '0');
                m_reg <= (others => '0');
                b_reg <= (others => '0');
                x_max_idx_reg <= (others => '0');
                x_new_size_reg <= (others => '0');
                dist_reg <= (others => '0');
                new_dist_reg <= (others => '0');
                idx_reg <= (others => '0');
                idx_m_one_reg <= (others => '0');
                idx_p_one_reg <= (others => '0');
                par1_idx_m_one_reg <= (others => '0');
                par1_idx_p_one_reg <= (others => '0');
                gr_idx_m_one_reg <= (others => '0');
                gr_idx_p_one_reg <= (others => '0');

                stage1_m_reg <= (others => '0');
                stage1_b_reg <= (others => '0');
                cmp1_reg <= false;
                cmp2_reg <= false;
                cmp3_reg <= false;

                rcp_dx_reg <= (others => '0');
                stage1_par3m_reg <= (others => '0');
             else
                state_reg <= state_next;
                k_reg <= k_next;
                i_reg <= i_next;
                dx_reg <= dx_next;
                dy_reg <= dy_next;
                m_reg <= m_next;
                b_reg <= b_next;
                x_max_idx_reg <= x_max_idx_next;
                x_new_size_reg <= x_new_size_next;
                dist_reg <= dist_next;
                new_dist_reg <= new_dist_next;
                idx_reg <= idx_next;
                idx_m_one_reg <= idx_m_one_next;
                idx_p_one_reg <= idx_p_one_next;
                par1_idx_m_one_reg <= par1_idx_m_one_next;
                par1_idx_p_one_reg <= par1_idx_p_one_next;
                gr_idx_m_one_reg <= gr_idx_m_one_next;
                gr_idx_p_one_reg <= gr_idx_p_one_next;

                stage1_m_reg <= stage1_m_next;
                stage1_b_reg <= stage1_b_next;
                cmp1_reg <= cmp1_next;
                cmp2_reg <= cmp2_next;
                cmp3_reg <= cmp3_next;

                rcp_dx_reg <= rcp_dx_next;
                stage1_par3m_reg <= stage1_par3m_next;
              end if;
        end if;                
    end process;    

    --Combinatorial circuits 
    process(state_reg,start,p1_rdata_par1_i,p2_rdata_par1_i,num_of_elements_par1_i,
            p1_rdata_gr_i,p2_rdata_gr_i,p1_rdata_par3_i,
            num_of_elements_par3_i,k_reg,i_reg,
            dx_reg,dy_reg,m_reg,b_reg,x_max_idx_reg,x_new_size_reg,dist_reg,new_dist_reg,
            idx_reg,idx_m_one_reg,idx_p_one_reg,par1_idx_m_one_reg,par1_idx_p_one_reg,
            gr_idx_m_one_reg,gr_idx_p_one_reg,k_next,i_next,dx_next,dy_next,m_next,b_next,
            x_max_idx_next,x_new_size_next,dist_next,new_dist_next,idx_next,idx_m_one_next,
            idx_p_one_next,par1_idx_m_one_next,par1_idx_p_one_next,gr_idx_m_one_next,gr_idx_p_one_next
            ,stage1_m_reg,stage1_m_next,
            stage1_b_reg,stage1_b_next,cmp1_next,cmp2_next,cmp3_next,cmp1_reg,cmp2_reg,cmp3_reg,
            rcp_dx_reg,rcp_dx_next,stage1_par3m_reg,stage1_par3m_next)
            
    begin
        
        --default assignments
        k_next <= k_reg;
        i_next <= i_reg;
        dx_next <= dx_reg;
        dy_next <= dy_reg;
        m_next <= m_reg;
        b_next <= b_reg;
        x_max_idx_next <= x_max_idx_reg;
        x_new_size_next <= x_new_size_reg;
        dist_next <= dist_reg;
        new_dist_next <= new_dist_reg;
        idx_next <= idx_reg;
        idx_m_one_next <= idx_m_one_reg;
        idx_p_one_next <= idx_p_one_reg;
        par1_idx_m_one_next <= par1_idx_m_one_reg;
        par1_idx_p_one_next <= par1_idx_p_one_reg;
        gr_idx_m_one_next <= gr_idx_m_one_reg;
        gr_idx_p_one_next <= gr_idx_p_one_reg;

        stage1_m_next <= stage1_m_reg;
        stage1_b_next <= stage1_b_reg;
        cmp1_next <= cmp1_reg;
        cmp2_next <= cmp2_reg;
        cmp3_next <= cmp3_reg;

        rcp_dx_next <= rcp_dx_reg;
        stage1_par3m_next <= stage1_par3m_reg;

        p1_addr_par1_o <= (others => '0');
        p2_addr_par1_o <= (others => '0');
        p1_write_par1_o <= '0';
        p2_write_par1_o <= '0';
        p1_addr_gr_o <= (others => '0');
        p2_addr_gr_o <= (others => '0');
        p1_write_gr_o <= '0';
        p2_write_gr_o <= '0';
        p1_addr_par3_o <= (others => '0');
        p1_write_par3_o <= '0';
        p2_wdata_gr_o <= (others => '0');
        p1_wdata_par1_o <= (others => '0');
        p2_wdata_par1_o <= (others => '0');
        p1_wdata_gr_o <= (others => '0');
        p1_wdata_par3_o <= (others => '0');
        p1_addr_rez_o <= (others => '0');
        p1_wdata_rez_o <= (others => '0');
        p1_write_rez_o <= '0';
        
        ready <= '0';
        
        case state_reg is
                when idle =>
                    if start = '1' then
                        x_max_idx_next <= unsigned(num_of_elements_par1_i) - to_unsigned(1,x_max_idx_next'length);
                        x_new_size_next <= unsigned(num_of_elements_par3_i);
                        i_next <= to_unsigned(0,log2c(SIZE_par3));
                        p1_addr_par3_o <= std_logic_vector(i_next);
                        state_next <= nni;
                    else
                        state_next <= idle;
                    end if;
                
                when nni =>
                    dist_next <= to_ufixed(8191,dist_next);
                    new_dist_next <= to_ufixed(8191,dist_next);
                    idx_next <= to_unsigned(0,log2c(SIZE_par1));
                    k_next <= to_unsigned(0,log2c(SIZE_par1));
                    p1_addr_par1_o <= std_logic_vector(k_next); 
                    p1_addr_par3_o <= std_logic_vector(i_reg);
                    state_next <= dist;
                    
                    
                when dist =>
                    new_dist_next <= resize(abs(p1_rdata_par3_i - p1_rdata_par1_i),new_dist_next);
                    if(to_unsigned(new_dist_next,new_dist_next'length) <= to_unsigned(dist_reg,new_dist_next'length)) then
                        dist_next <= new_dist_next;
                        idx_next <= k_reg;
                        if(k_reg = to_unsigned(0,k_reg'length)) then
                            idx_m_one_next <= idx_next;
                            idx_p_one_next <= idx_next + 1;
                        else
                            idx_m_one_next <= idx_next - 1;
                            idx_p_one_next <= idx_next + 1;
                        end if;
                        p1_addr_par3_o <= std_logic_vector(i_reg);           
                    else
                        p1_addr_par1_o <= std_logic_vector(k_reg); 
                        p1_addr_par3_o <= std_logic_vector(i_reg);
                    end if;
                    
                    if(k_reg > (unsigned(num_of_elements_par1_i) - 2))then
                        p1_addr_par1_o <= std_logic_vector(idx_m_one_next); 
                        p2_addr_par1_o <= std_logic_vector(idx_p_one_next);
                        p1_addr_gr_o <= std_logic_vector(resize(idx_m_one_next,p1_addr_gr_o'length)); 
                        p2_addr_gr_o <= std_logic_vector(resize(idx_p_one_next,p2_addr_gr_o'length));
                    end if;
                    state_next <= par1_adr_inc;
                    
                 when par1_adr_inc =>

                    k_next <= k_reg + 1;
                    if(k_next < unsigned(num_of_elements_par1_i)) then
                        p1_addr_par1_o <= std_logic_vector(k_next); 
                        p1_addr_par3_o <= std_logic_vector(i_reg);
                        state_next <= dist;
                    else
                        par1_idx_m_one_next <= p1_rdata_par1_i;
                        par1_idx_p_one_next <= p2_rdata_par1_i;
                        gr_idx_m_one_next <= resize(p1_rdata_gr_i,gr_idx_m_one_next);
                        gr_idx_p_one_next <= resize(p2_rdata_gr_i,gr_idx_p_one_next);
                        
                        p1_addr_par1_o <= std_logic_vector(idx_reg); 
                        p1_addr_gr_o <= std_logic_vector(resize(idx_reg,p1_addr_gr_o'length)); 
                        p1_addr_par3_o <= std_logic_vector(i_reg);

                        

                        state_next <= cmp_calc;
                    end if;

                when cmp_calc =>
                    cmp1_next <= p1_rdata_par1_i > p1_rdata_par3_i;
                    cmp2_next <= idx_reg > to_unsigned(0,log2c(SIZE_par1));
                    cmp3_next <= idx_reg < x_max_idx_reg;
                    p1_addr_par1_o <= std_logic_vector(idx_reg); 
                    p1_addr_gr_o <= std_logic_vector(resize(idx_reg,p1_addr_gr_o'length)); 
                    state_next <= DxDy;
                    
                when DxDy =>
                    p1_addr_par1_o <= std_logic_vector(idx_reg); 
                    p1_addr_gr_o <= std_logic_vector(resize(idx_reg,p1_addr_gr_o'length)); 
                    
                    if(cmp1_reg)then
                        if(cmp2_reg)then
                            dx_next <= p1_rdata_par1_i - par1_idx_m_one_reg;
                            dy_next <= resize((p1_rdata_gr_i - gr_idx_m_one_reg),dy_next);
                        else
                            dx_next <= par1_idx_p_one_reg - p1_rdata_par1_i;
                            dy_next <= resize((gr_idx_p_one_reg - p1_rdata_gr_i),dy_next);
                        end if;
                    else
                        if(cmp3_reg)then
                            dx_next <= par1_idx_p_one_reg - p1_rdata_par1_i;
                            dy_next <= resize((gr_idx_p_one_reg - p1_rdata_gr_i),dy_next);
                        else
                            dx_next <= p1_rdata_par1_i - par1_idx_m_one_reg;
                            dy_next <= resize((p1_rdata_gr_i - gr_idx_m_one_reg),dy_next);
                        end if; 
                    end if;

                    state_next <= rcpDx;

               

                when rcpDx =>
                    rcp_dx_next <= resize(1 / dx_reg,rcp_dx_next);
                    state_next <= calc_m;
                    -- izmena 11.sep.2024
                when calc_m =>
                    stage1_m_next <= resize((dy_reg * rcp_dx_reg),stage1_m_next);

                    
                    state_next <= m_setup;

                when m_setup =>
                    p1_addr_par1_o <= std_logic_vector(idx_reg); 
                    p1_addr_gr_o <= std_logic_vector(resize(idx_reg,p1_addr_gr_o'length)); 
                    m_next <= stage1_m_reg;

                    state_next <= calc_b;

                when calc_b =>

                    stage1_b_next <= resize((resize(p1_rdata_gr_i,stage1_b_next) - resize((p1_rdata_par1_i * m_reg),stage1_b_next)),stage1_b_next);
                    p1_addr_par3_o <= std_logic_vector(i_reg);
                    
                    state_next <= b_setup;

                when b_setup =>
                    b_next <= stage1_b_reg;
                    p1_addr_par3_o <= std_logic_vector(i_reg);
                    state_next <= calc_par3m;

                when calc_par3m =>
                    stage1_par3m_next <= resize(p1_rdata_par3_i * m_reg,stage1_par3m_next);
                    state_next <= end_asmd;

                when end_asmd =>
                    p1_addr_rez_o <= std_logic_vector(resize(i_reg,p1_addr_rez_o'length));
                    p1_write_rez_o <= '1';

                    p1_wdata_rez_o <= resize(stage1_par3m_reg + resize(b_reg,stage1_par3m_reg), p1_wdata_rez_o);


                    i_next <= i_reg + 1;
                    p1_addr_par3_o <= std_logic_vector(i_next);

                    if(i_next < x_new_size_reg)then
                        state_next <= nni;
                    else
                        ready <= '1';
                        state_next <= idle;
                    end if; 

                    
        end case;
          
    
    end process;   
end Behavioral;
