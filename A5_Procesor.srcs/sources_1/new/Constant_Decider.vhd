
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Constant_Decider is
    port( B : in STD_LOGIC_VECTOR(7 downto 0);
          KK : in STD_LOGIC_VECTOR(7 downto 0);
          MSB_DECIDE : in STD_LOGIC;
          O : OUT STD_LOGIC_VECTOR(7 downto 0)
          );
end Constant_Decider;

architecture Behavioral of Constant_Decider is

begin
    O <= KK when MSB_DECIDE ='0' else B;
end Behavioral;
