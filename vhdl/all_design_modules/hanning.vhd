
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2021 06:31:52 PM
-- Design Name: 
-- Module Name: hanning - Behavioral
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
library ieee_proposed;
use ieee_proposed.fixed_pkg.all;
use work.utils_pkg.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hanning is
generic(
        SIZE_w           : integer := 100000;
        W_HIGH_W         : integer := 1;
        W_LOW_W          : integer := -31;
        W_HIGH_PIT       : integer := 20;
        W_LOW_PIT        : integer := 0;
        W_ROM            : integer := 51;
        W_HAN               : integer := 32
    );
port(clk                    : in std_logic;
     reset                  : in std_logic;
     start                  : in std_logic;
     ready                  : out std_logic;
     itype                  : in std_logic;
     --Interfejs w memorije
     --Port 1 interface
     p1_addr_w_o          : out std_logic_vector(log2c(SIZE_w) - 1 downto 0);
     p1_wdata_w_o         : out sfixed(W_HIGH_W - 1 downto W_LOW_W);
     p1_rdata_w_i         : in sfixed(W_HIGH_W - 1 downto W_LOW_W);
     p1_write_w_o         : out std_logic;
     --Port 2 interface
     p2_addr_w_o          : out std_logic_vector(log2c(SIZE_w) - 1 downto 0);
     p2_wdata_w_o         : out sfixed(W_HIGH_W - 1 downto W_LOW_W);
     p2_rdata_w_i         : in sfixed(W_HIGH_W - 1 downto W_LOW_W);
     p2_write_w_o         : out std_logic;
     num_of_elements_w_i  : in std_logic_vector(log2c(SIZE_w) - 1 downto 0);
    --Interfejs hanning memorije--------------------------------------------------------------------------------------
    rdata_cos_novo_i               : in std_logic_vector(W_HAN - 1 downto 0);
     --Port za reset memorije w
     reset_w                  : out std_logic;
     ready_w                  : out std_logic;
     pit_i                      : in std_logic_vector(W_HIGH_PIT - 1 downto W_LOW_PIT);
     --Interfejs za axi protokol
     axi_rnext_out_i          : in std_logic;
     ready_wr                 : out std_logic
    );
end hanning;

architecture Behavioral of hanning is
type state_type is(idle,n_state,n_state_decide,cos,w,half,cos2,w2,itype1,end_asmd);
    signal  state_reg,state_next                        : state_type;
    signal  half_reg,half_next                          : unsigned(log2c(SIZE_w) - 1 downto 0);
    signal  i_reg,i_next                                : unsigned(log2c(SIZE_w) - 1 downto 0);
    signal  idx_reg,idx_next                            : unsigned(log2c(SIZE_w) - 1 downto 0);
    signal  n_reg,n_next                                : unsigned(log2c(SIZE_w) - 1 downto 0);
    signal  pit_idx_reg,pit_idx_next                    : unsigned(log2c(SIZE_w) - 1 downto 0);
    signal  addr_offset_cos_reg,addr_offset_cos_next    : unsigned(W_HIGH_PIT - 1 downto W_LOW_PIT);
    signal  first_han_lap_reg,first_han_lap_next        : std_logic;
    signal  stallk_reg,stallk_next                                : unsigned(log2c(SIZE_w) - 1 downto 0);
    signal  j_reg,j_next                                : unsigned(log2c(SIZE_w) - 1 downto 0);
    signal  v_reg,v_next                                : unsigned(log2c(SIZE_w) - 1 downto 0);
begin
    --State and data registers
    process(clk,reset)
    begin
        if(clk'event and clk = '1') then
            if reset = '1' then
                state_reg <= idle;
                half_reg <= (others => '0');
                i_reg <= (others => '0');
                idx_reg <= (others => '0');
                n_reg <= (others => '0');
                pit_idx_reg <= (others => '0');
                addr_offset_cos_reg <= (others => '0');
                first_han_lap_reg <= '0';

                stallk_reg <= (others => '0');
                j_reg <= (others => '0');
                v_reg <= (others => '0');
            else
                state_reg <= state_next;
                half_reg <= half_next;
                i_reg <= i_next;
                idx_reg <= idx_next;
                n_reg <= n_next;
                pit_idx_reg <= pit_idx_next;
                addr_offset_cos_reg <= addr_offset_cos_next;
                first_han_lap_reg <= first_han_lap_next;
                
                stallk_reg <= stallk_next;
                j_reg <= j_next;
                v_reg <= v_next;
            end if;
        end if;    
    end process;
    --Combinatioral circuits
    process(state_reg,start,p1_rdata_w_i,p2_rdata_w_i,stallk_reg,
             half_reg,half_next,i_reg,i_next,idx_reg,idx_next,n_reg,n_next,pit_idx_reg,pit_idx_next,
             addr_offset_cos_reg,addr_offset_cos_next,itype,pit_i,first_han_lap_reg,first_han_lap_next,
             j_reg,j_next,stallk_reg,stallk_next,axi_rnext_out_i,rdata_cos_novo_i,v_reg,v_next)
             
             variable    v_rdata_real             :   real;
             variable    v_rdata_sf               :   sfixed(0 downto -50):= (others => '0');
    begin
        --Default assignments
        half_next <= half_reg;
        i_next <= i_reg;
        idx_next <= idx_reg;
        n_next <= n_reg;
        addr_offset_cos_next <= addr_offset_cos_reg;
        first_han_lap_next <= first_han_lap_reg;

        stallk_next <= stallk_reg;
        j_next <= j_reg;
        v_next <= v_reg;

        p1_addr_w_o <= (others => '0');
        p1_write_w_o <= '0';
        p1_wdata_w_o <= (others => '0');
        p2_addr_w_o <= (others => '0');
        p2_write_w_o <= '0';
        p2_wdata_w_o <= (others => '0');
        ready <= '0';
        ready_wr <= '0';
        reset_w <= '0';
        ready_w <= '0';
        
        case state_reg is
            when idle =>
                if start = '1' then
                    ready_wr <= '1';
                    if(first_han_lap_reg = '0') then
                        addr_offset_cos_next <= to_unsigned(0,addr_offset_cos_next'length);
                    end if;                    
                     state_next <= n_state;
                else
                    state_next <= idle;
                end if; 
                
            when n_state =>
                if itype = '1' then
                    n_next <= (resize((to_unsigned(2,pit_i'length) * unsigned(pit_i)),n_next'length) + to_unsigned(1,n_next'length)) - to_unsigned(1,n_next'length);
                else
                    n_next <= (resize((to_unsigned(2,pit_i'length) * unsigned(pit_i)),n_next'length) + to_unsigned(1,n_next'length));
                end if; 
                state_next <= n_state_decide;

                when n_state_decide =>
                    if (n_reg mod to_unsigned(2,n_next'length) = 0)   then
                        half_next <= resize((n_next / to_unsigned(2,n_next'length)),half_next'length);
                        i_next <= to_unsigned(0,i_next'length);
                        j_next <= to_unsigned(0,j_next'length);
                        stallk_next <= to_unsigned(0,stallk_next'length);
                        p1_addr_w_o <= std_logic_vector(i_next);
                        
                        state_next <= cos;
                    else
                        state_next <= half;
                    end if;  
                                   
            when cos =>
                if(axi_rnext_out_i = '1')then
                    stallk_next <= stallk_reg + to_unsigned(1,stallk_next'length);
                    if(stallk_reg > 0 )then
                        i_next <= i_reg + to_unsigned(1,i_next'length);
                        p1_addr_w_o <= std_logic_vector(i_reg);

                        p1_write_w_o <= '1';  
                    end if;
                    
                end if;         
                p1_wdata_w_o <= to_sfixed(rdata_cos_novo_i(p1_wdata_w_o'length - 1 downto 0),p1_wdata_w_o'high,p1_wdata_w_o'low);

                if(i_next < resize(half_reg,i_next'length)) then
                    state_next <= cos;
                else
                    idx_next <= half_reg - to_unsigned(1,idx_next'length);
                    p2_addr_w_o <= std_logic_vector(resize(idx_next,p2_addr_w_o'length));
                    j_next <= resize(half_reg,j_next'length);
                    p1_addr_w_o <= std_logic_vector(i_reg);
                    state_next <= w;
                end if;
                
            when w =>
                p1_addr_w_o <= std_logic_vector(j_reg);
                p1_write_w_o <= '1';
                p1_wdata_w_o <= p2_rdata_w_i;
                idx_next <= idx_reg - to_unsigned(1,idx_next'length);
                p2_addr_w_o <= std_logic_vector(resize(idx_next,p2_addr_w_o'length));
                j_next <= j_reg + to_unsigned(1,j_next'length);
                if (j_next < n_reg) then
                    state_next <= w;
                else
                    state_next <= itype1;
                end if;
                
            when half =>
                half_next <= resize(((n_reg + to_unsigned(1,n_reg'length)) / to_unsigned(2,n_reg'length)),half_next'length);   
                i_next <= to_unsigned(0,i_next'length);
                j_next <= to_unsigned(0,i_next'length);
                stallk_next <= to_unsigned(0,stallk_next'length);
                state_next <= cos2;
                
            when cos2 =>

                if(axi_rnext_out_i = '1')then
                    stallk_next <= stallk_reg + to_unsigned(1,stallk_next'length);
                    if(stallk_reg > 0 )then
                        i_next <= i_reg + to_unsigned(1,i_next'length);
                        p1_addr_w_o <= std_logic_vector(i_reg);

                        p1_write_w_o <= '1';  
                    end if;
                    
                end if;         
                p1_wdata_w_o <= to_sfixed(rdata_cos_novo_i(p1_wdata_w_o'length - 1 downto 0),p1_wdata_w_o'high,p1_wdata_w_o'low);

                if ( i_next < resize(half_reg ,i_next'length)) then
                    state_next <= cos2;
                else            
                    idx_next <= half_reg - to_unsigned(2,idx_next'length);
                    p2_addr_w_o <= std_logic_vector(resize(idx_next,p2_addr_w_o'length));
                    j_next <= resize(half_reg,j_next'length);
                    p1_addr_w_o <= std_logic_vector(i_reg);
                    state_next <= w2;
                end if;
            
            when w2 =>
                p1_write_w_o <= '1';
                p1_addr_w_o <= std_logic_vector(j_reg);
                p1_wdata_w_o <= p2_rdata_w_i;
                idx_next <= idx_reg - to_unsigned(1,idx_next'length);
                p2_addr_w_o <= std_logic_vector(resize(idx_next,p2_addr_w_o'length));
                j_next <= j_reg + to_unsigned(1,j_next'length);
                if(j_next < n_reg - 1) then
                    state_next <= w2;
                else
                    state_next <= itype1;
                end if;
                
            when itype1 =>
                p1_write_w_o <= '1';
                p1_addr_w_o <= std_logic_vector(j_reg);
                p1_wdata_w_o <= p2_rdata_w_i;
                if itype = '1' then
                    first_han_lap_next <= '1';
                    i_next <= (resize((to_unsigned(2,pit_i'length) * unsigned(pit_i)),n_next'length) + to_unsigned(1,n_next'length)) - to_unsigned(1,n_next'length);
                    p1_addr_w_o <= std_logic_vector(i_next);
                    p2_addr_w_o <= std_logic_vector(i_next - to_unsigned(1,i_next'length));
                    state_next <= end_asmd;
                else
                        addr_offset_cos_next <= addr_offset_cos_reg + half_reg;
                        first_han_lap_next <= '1';
                        ready_w <= '1';
                        ready_wr <= '1';
                        ready <= '1';
                        
                        state_next <= idle;
                end if;
            
            when end_asmd =>
                p1_write_w_o <= '1';
                p1_wdata_w_o <= p2_rdata_w_i;
                v_next <= v_reg - to_unsigned(1,v_next'length);
                p1_addr_w_o <= std_logic_vector(v_next);
                p2_addr_w_o <= std_logic_vector(v_next - to_unsigned(1,v_next'length));

                if (v_next >= to_unsigned(2,v_next'length)) then
                    state_next <= end_asmd;
                else
                    p1_write_w_o <= '1';
                    p1_wdata_w_o <= p2_rdata_w_i;
                    p2_write_w_o <= '1'; 
                    p2_wdata_w_o <= to_sfixed(0,p2_wdata_w_o);
                    ready <= '1';
                    state_next <= n_state;
                end if;    

        end case;
        
    end process;
end Behavioral;
