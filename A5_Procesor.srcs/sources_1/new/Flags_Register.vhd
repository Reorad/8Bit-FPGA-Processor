
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Flags_Register is
    port(
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        Enable_int : in STD_LOGIC;
        Disable_int : in STD_LOGIC;
        Flag_C_ALU : in STD_LOGIC;
        Flag_Z_ALU : in STD_LOGIC;
        Update_carry_zero_PC : in STD_LOGIC;
        Z_flag : out STD_LOGIC;
        Interupt_triger : out STD_LOGIC;
        C_flag : out STD_LOGIC
        );
end Flags_Register;

architecture Behavioral of Flags_Register is
begin
    process(CLK,RST)
        begin
            if(RST = '1') then
                Z_flag <='0';
                C_flag <='0';
                Interupt_triger <='0';
            elsif (rising_edge(CLK)) then
                if(Update_carry_zero_PC ='1') then
                    Z_flag <= Flag_Z_ALU;
                    C_flag <= Flag_C_ALU;
                end if;
                
                if(Enable_int ='1' ) then
                    Interupt_triger <= '1';
                elsif(Disable_int ='1') then
                    Interupt_triger <='0';
                end if;
            end if;
    end process;

end Behavioral;
