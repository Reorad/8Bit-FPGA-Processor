----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/08/2026 11:53:45 PM
-- Design Name: 
-- Module Name: SSD_Driver - Behavioral
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

entity SSD_Driver is
    port(  CLK : in STD_LOGIC;
           Data_from_procesor : in STD_LOGIC_VECTOR(11 downto 0);
           RST : in STD_LOGIC;
           Disable_anodes : in STD_LOGIC;
           Anodes : out STD_LOGIC_VECTOR(3 downto 0);
           Cathodes : out STD_LOGIC_VECTOR(7 downto 0)
           );
end SSD_Driver;

architecture Behavioral of SSD_Driver is
    
    component ssd_7seg is
    Port ( DataIn : in STD_LOGIC_VECTOR (3 downto 0);
           SegOut : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component Clk_divider is
    generic (Period : natural := 1000 );
    port( CLK : in STD_LOGIC;
          RST : in STD_LOGIC;
          CLK_OUT : out STD_LOGIC
          );
    end component;
    
    signal CLK_2_ms_signal : STD_LOGIC :='0';
    signal Count : natural := 0;
    signal Print_Data_4bits : STD_LOGIC_VECTOR(3 downto 0) := (others =>'0');
    
begin
    
    CLK_small : Clk_divider generic map(2)
        port map(
            CLK=>CLK,
            RST => RST,
            CLK_OUT => CLK_2_ms_signal
        );
        
    Segment : ssd_7seg port map(
            DataIn => Print_Data_4bits,
            SegOut => Cathodes);
        
    process(CLK_2_ms_signal, RST)
        begin
           if(RST = '1' ) then
              Count <= 0;
           elsif (rising_edge(CLK_2_ms_signal)) then
               if(count = 2 ) then
                    count <= 0;
               else 
                    count <= count + 1;
               end if;
           end if;
    end process;
    
    process(Count)
        begin
            case Count is
                when 0 => Anodes <= "1110" ;
                when 1 => Anodes <= "1101" ;
                when 2 => Anodes <= "1011" ;
                when others => Anodes <= "1111" ;
            end case;
    end process;
    
    process(Count,Data_from_procesor,Disable_anodes)
        begin
            if (Disable_anodes = '1') then
                case count is 
                    when 2 => Print_Data_4bits <= "0001"; -- '1' for I
                    when 1 => Print_Data_4bits <= "1010"; -- 'A' as closest to N
                    when 0 => Print_Data_4bits <= "0111"; -- '7' for T
                    when others => Print_Data_4bits <= (others => '0');
                end case;
            else
                case count is 
                    when 0 => Print_Data_4bits <= Data_from_procesor(3 downto 0);  -- Anode one means rightest most digit --
                    when 1 => Print_Data_4bits <= Data_from_procesor(7 downto 4);  -- Anode two means middle digit --
                    when 2 => Print_Data_4bits <= Data_from_procesor(11 downto 8); -- Anode tree means lefr most digit --
                    when others => Print_Data_4bits <= (others => '0' );
                end case;
            end if;
    end process;

end Behavioral;
