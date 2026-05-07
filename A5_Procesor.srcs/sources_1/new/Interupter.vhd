
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Interupter is
    port(
    
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        Interupt_sw : in STD_LOGIC;
        Interupt_FLAG : in STD_LOGIC;
        Hold_all : out STD_LOGIC; -- will go to flags to ensure they dont change -- 
        Trigger_leg : out STD_LOGIC;
        Done : out STD_LOGIC
    );
end Interupter;
    
    
    
architecture Behavioral of Interupter is
    signal Count : natural := 0;
    signal Q_led : STD_LOGIC :='0';
begin
    Trigger_leg <= Q_led;

    process(CLK, RST)
    variable is_running : std_logic := '0';
begin
    if(RST = '1') then
        Hold_all <= '0';
        Done <= '1';
        Count <= 0;
        Q_led <= '0';
        is_running := '0';
    elsif(rising_edge(CLK)) then

        if (is_running = '0') then
            if (Interupt_sw = '1' AND Interupt_FLAG = '1' ) then
                is_running := '1';
                Hold_all <= '1';
                Done <= '0';
                Count <= 0;
                Q_led <='1';
            else
                Hold_all <= '0';
                Done <= '1';
                Q_led <='0';
            end if;
        else
            if (Count = 5) then
                is_running := '0'; 
                Hold_all <= '0';
                Done <= '1';
                Count <= 0;
                Q_led <= '0';
            else
                Count <= Count + 1;
                Hold_all <= '1';
                Done <= '0';
            end if;
        end if;
    end if;
end process;

    

end Behavioral;
