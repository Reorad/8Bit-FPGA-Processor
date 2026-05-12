
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BCD_conv is
    port( Data_in : in STD_LOGIC_VECTOR(7 downto 0);
          First_digit : out STD_LOGIC_VECTOR(3 downto 0);
          Second_digit : out STD_LOGIC_VECTOR(3 downto 0);
          Last_digit : out STD_LOGIC_VECTOR(3 downto 0)
          );
end BCD_conv;

architecture Behavioral of BCD_conv is
     signal Numb : integer := 0;
begin
    
    Numb <= to_integer(unsigned(Data_in));
    
    First_digit  <= std_logic_vector(to_unsigned(Numb / 100, 4));
    Second_digit <= std_logic_vector(to_unsigned((Numb / 10) mod 10, 4));
    Last_digit   <= std_logic_vector(to_unsigned(Numb mod 10, 4));

end Behavioral;
