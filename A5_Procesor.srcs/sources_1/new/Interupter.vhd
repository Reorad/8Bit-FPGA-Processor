
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
        CLK_Fast : in STD_LOGIC;
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
    signal Int_latch : STD_LOGIC;
begin
    Trigger_leg <= Q_led;
    
    process(CLK_Fast, RST)
    begin
        if RST = '1' then
            Int_latch <= '0'; 
        elsif rising_edge(CLK_Fast) then
            if Interupt_sw = '1' then
                Int_latch <= '1';         
            elsif Q_led = '1' then
                Int_latch <= '0';          
            end if;
        end if;
    end process;
    
    process(CLK, RST)
    variable runn : STD_LOGIC := '0';
    begin
    if(RST = '1') then
        Hold_all <= '0';
        Done <= '1';
        Count <= 0;
        Q_led <= '0';
    elsif(rising_edge(CLK)) then
    
        if (Int_latch = '1' AND Interupt_FLAG = '1') then
            runn := '1';
            Hold_all <= '1';
            Done <= '0';
            Q_led <= '1';
            Count <= 0;
        elsif (runn = '1') then
            if (Count = 5) then
                runn := '0';
                Done <= '1';
                Hold_all <= '0';
                Q_led <= '0';
                Count <= 0;
            else
                Count <= Count + 1;
            end if;
        end if;
    end if;
end process;

    

end Behavioral;
