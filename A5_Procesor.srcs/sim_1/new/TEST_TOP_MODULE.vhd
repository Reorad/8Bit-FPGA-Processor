
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Test_Top_level is
--  Port ( );
end Test_Top_level;

architecture Test of Test_Top_level is

    component TOP_LEVEL is
    port(
          CLk : in STD_LOGIC;
          RST : in STD_LOGIC;
          Operation_out : out STD_LOGIC_VECTOR(7 downto 0);
          Adress_debug : out STD_LOGIC_VECTOR(15 downto 0)
          );
    end component;
    
    signal CLK : STD_LOGIC :='0';
    signal RST : STD_LOGIC :='0';
    signal Operation_out : STD_LOGIC_VECTOR(7 downto 0) :=(others=>'0');
    signal Adress_debug  : STD_LOGIC_VECTOR(15 downto 0) :=(others=>'0');
    
begin

    UUT : TOP_LEVEL port map(CLK,RST,Operation_out,Adress_debug);
    
    process
        begin
            RST<='1';
            wait for 10ns;
            RST<='0';
            wait for 10ns;
            wait;
    end process;
    
    process
        begin
            
            CLK<='1';
            wait for 5ns;
            CLK<='0';
            wait for 5ns;
            
    end process;

end Test;
