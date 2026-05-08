----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/08/2026 11:49:23 PM
-- Design Name: 
-- Module Name: Clk_divider - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Clk_divider is
    generic (Period : natural := 1000 );
    port( CLK : in STD_LOGIC;
          RST : in STD_LOGIC;
          CLK_OUT : out STD_LOGIC
          );
end Clk_divider;

architecture Behavioral of Clk_divider is
    constant PER : natural := Period * 50000;
    signal count : natural := 1;
    signal clk_internal_out : STD_LOGIC := '0';
begin
    
    process(CLK,RST)
        begin
            if(RST ='1') then
                count <= 1;
            elsif (rising_edge(CLK)) then
                if(count = PER) then
                    clk_internal_out <= not clk_internal_out;
                    count <= 1;
                else
                    count <= count + 1;
                end if;
            end if;
    end process;
    
    clk_out <= clk_internal_out;
    
end Behavioral;
