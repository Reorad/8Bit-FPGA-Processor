
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CP_Register is
    port(   
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        PC_HOLD : in STD_LOGIC; -- sound weird but in actuality is done 
        
        COME_MEM_INS : in STD_LOGIC;
        COME_INS_ADD : in STD_LOGIC_VECTOR(7 downto 0);
        PC_OUT : out STD_LOGIC_VECTOR(7 downto 0)
    );
end CP_Register;
    
architecture Behavioral of CP_Register is
    signal Q_aux : STD_LOGIC_VECTOR(7 downto 0);
begin
    process(CLK,RESET)
        begin
        if( RESET = '1' ) then
            Q_aux <= (others => '0');
        elsif ( rising_edge(CLK) ) then
            if(PC_HOLD = '1')  then 
                Q_aux <= Q_aux;
            elsif(COME_MEM_INS = '1' ) then
                Q_aux<=COME_INS_ADD;
            else
                Q_aux<=Q_aux+1;
            end if;
        end if;
    end process;
    PC_OUT<=Q_aux;
end Behavioral;
