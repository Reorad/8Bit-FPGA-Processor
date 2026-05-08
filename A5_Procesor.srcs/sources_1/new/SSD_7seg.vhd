
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity ssd_7seg is
    Port ( DataIn : in STD_LOGIC_VECTOR (3 downto 0);
           SegOut : out STD_LOGIC_VECTOR (7 downto 0));
end ssd_7seg;

architecture Behavioral of ssd_7seg is

begin
SegOut <= "11000000" when DataIn = "0000" else
          "11111001" when DataIn = "0001" else
          "10100100" when DataIn = "0010" else
          "10110000" when DataIn = "0011" else
          "10011001" when DataIn = "0100" else
          "10010010" when DataIn = "0101" else
          "10000010" when DataIn = "0110" else
          "11111000" when DataIn = "0111" else 
          "10000000" when DataIn = "1000" else 
          "10010000" when DataIn = "1001" else
          "10001000" when DataIn = "1010" else
          "10000011" when DataIn = "1011" else
          "11000110" when DataIn = "1100" else
          "10100001" when DataIn = "1101" else
          "10000110" when DataIn = "1110" else
          "10001110" when DataIn = "1111" else
          "11111111";

end Behavioral;