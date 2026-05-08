
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Controler_FSM_Data_print is
    port( Write_strobe : in STD_LOGIC;
          RST : in STD_LOGIC;
          CLK : in STD_LOGIC;
          Interupt_strobe : in STD_LOGIC;
          Data_from_print : in STD_LOGIC_VECTOR(11 downto 0);
          Dont_print : out STD_LOGIC;
          Data_out : out STD_LOGIC_VECTOR(11 downto 0) 
         );
end Controler_FSM_Data_print;

architecture Behavioral of Controler_FSM_Data_print is
begin
    process(CLK, RST)
    begin
        if (RST = '1') then
            Data_out <= (others => '0');
            Dont_print <= '0';
        elsif rising_edge(CLK) then
            if (Interupt_strobe = '1') then
                Dont_print <= '1';   
            else
                Dont_print <= '0';   
                Data_out <= (others => '0');
                if (Write_strobe = '1') then
                    Data_out <= Data_from_print; 
                end if;
            end if;
            
        end if;
    end process;
end Behavioral;

