----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/02/2021 12:54:35 PM
-- Design Name: 
-- Module Name: fixed_pkg_test_memory - Behavioral
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
-- 15 i 10
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
library ieee_proposed;
use ieee_proposed.fixed_pkg.all;
--use ieee.fixed_pkg.all;
use work.utils_pkg.all;

entity mem_matk is
generic(
        SIZE_MATK      : integer := 4500;
        W_HIGH_MATK    : integer := 24;
        W_LOW_MATK     : integer := -16
    );
    port(clk             : in std_logic;
         reset           : in std_logic;
         --Port 1 interface
         p1_addr_i       : in std_logic_vector(log2c(SIZE_MATK) - 1 downto 0);
         p1_wdata_i      : in sfixed(W_HIGH_MATK - 1 downto W_LOW_MATK);
         p1_rdata_o      : out sfixed(W_HIGH_MATK - 1 downto W_LOW_MATK);
         p1_write_i      : in std_logic;
         --Port 2 interface
         p2_addr_i       : in std_logic_vector(log2c(SIZE_MATK) - 1 downto 0);
         p2_wdata_i      : in sfixed(W_HIGH_MATK - 1 downto W_LOW_MATK);
         p2_rdata_o      : out sfixed(W_HIGH_MATK - 1 downto W_LOW_MATK);
         p2_write_i      : in std_logic;
         num_of_elements : out std_logic_vector(log2c(SIZE_MATK) - 1 downto 0)      
    );
end entity mem_matk;

architecture Beh of mem_matk is
    type ram_type_t is array (SIZE_MATK - 1 downto 0) of sfixed(W_HIGH_MATK - 1 downto W_LOW_MATK);
    shared variable ram_var : ram_type_t := (others=>(others => '0'));
    signal cnt    :   natural := 0;
    
    
begin
    

    cnt_reg: process(clk) is   
        variable pw  : std_logic_vector(1 downto 0);
    begin
        if(clk'event and clk = '1') then
            if(reset = '1') then
                cnt <= 0;
            else
                pw := p1_write_i & p2_write_i;
                case pw is
                    when "10"  =>
                        cnt <= cnt + 1;
                    when "01" =>
                        cnt <= cnt + 1;
                    when "11" =>
                        cnt <= cnt + 2;
                    when others =>

                end case;
            end if;
        end if;   
    end process;

    ram_test_port_1: process(clk) is   
    begin
        if(clk'event and clk = '1') then
                if(p1_write_i = '1') then
                    ram_var(to_integer(unsigned(p1_addr_i))) := p1_wdata_i;
                end if;
            p1_rdata_o <= ram_var(to_integer(unsigned(p1_addr_i)));
        end if;   
    end process;

    ram_test_port_2: process(clk) is   
    begin
        if(clk'event and clk = '1') then
                if(p2_write_i = '1') then
                    ram_var(to_integer(unsigned(p2_addr_i))) := p2_wdata_i;
                end if;
            p2_rdata_o <= ram_var(to_integer(unsigned(p2_addr_i)));
        end if;  
    end process;

    num_of_elements <= std_logic_vector(to_signed(cnt, num_of_elements'length)); 
end architecture Beh;