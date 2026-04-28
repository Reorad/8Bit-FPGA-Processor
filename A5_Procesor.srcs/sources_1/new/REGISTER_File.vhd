
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity REGISTER_File is                                                                                                                                                                                           
    port(
        Sx_add : in STD_LOGIC_VECTOR(3 downto 0);
        Sy_add : in STD_LOGIC_VECTOR(3 downto 0);
        CLK : in STD_LOGIC;
        Write_data : in STD_LOGIC;
        Operation_from_ALU : in STD_LOGIC_VECTOR(7 downto 0);
        RST : in STD_LOGIC;
        
        Sx_out : out STD_LOGIC_VECTOR(7 downto 0);
        Sy_out : out STD_LOGIC_VECTOR(7 downto 0)
    );
end REGISTER_File;

architecture Behavioral of REGISTER_File is
    
    type Reg_file is array (0 to 15) of STD_LOGIC_VECTOR(7 downto 0) ;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    signal S_Register : Reg_file := (others => (others => '0'));
    
begin
    
    Sy_out <= S_register(to_integer(unsigned(Sy_add)));
    Sx_out <= S_register(to_integer(unsigned(Sx_add)));
    
    process(CLK, RST)
        begin   
            if(RST = '1' ) then
                S_Register <= (others => (others => '0'));
            elsif( Write_in = '1' AND rising_edge(CLK)) then
                S_Register(to_integer(unsigned(Sx_add))) <= Operation_from_ALU;                                                                               
            end if;
    end process;
    
end Behavioral;

