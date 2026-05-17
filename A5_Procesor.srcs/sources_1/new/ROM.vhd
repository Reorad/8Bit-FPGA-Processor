
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rom is
    Generic (ADD_SIZE  : natural := 8;
             DATA_SIZE : natural := 16);
    Port ( Add  : in STD_LOGIC_VECTOR (ADD_SIZE-1 downto 0);
           CS   : in STD_LOGIC;
           Data : out STD_LOGIC_VECTOR (DATA_SIZE-1 downto 0));
end rom;

architecture Behavioral of rom is
    type ROM_Type is array (0 to (2**ADD_SIZE)-1) of STD_LOGIC_VECTOR (DATA_SIZE-1 downto 0);

    signal ROM_Mem : ROM_Type:=
    (
        
        0 => "0000" & "0000" & "00010100", -- Load 20 into s0
        1 => "100" & "000" & "11" & "00010100", -- Call 
        2 => "0000" & "0001" & "00001111", -- Load s1 , 15
        3 => "1110" & "0001" & "00000000", -- printed 15
        4 => "100" & '0' & "00" & "01" & "00000000",
        
        
        20 => "1110" & "0000" & "00000000", -- print 20
        21 => "1110" & "0001" & "00000000",	 -- print 0 
        22 => "1000000010000000",
            others => "0000000000000000"

    );

begin
    Data <= ROM_Mem(to_integer(unsigned(Add))) when CS = '1' else (others=>'Z');

end Behavioral;