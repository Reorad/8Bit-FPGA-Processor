
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
        
     0 => "0000" & "0000" & "00000001",  -- Load into s0 1
        
        1 => "1000000000110000",  -- interupt enable
        
        2 => "0000" & "0001" & "00000001", -- Load into s1 1 
        
        3 => "0000" & "0010" & "00000000", -- SUM will be s2 
        
        4 => "1010" & "1010" & "00000000", -- INPUT s10, 00 lowers witches in s10
        
        5 => "1110" & "1010" & "00000000", -- Print Counter 
        
        6 => "1100" & "0010" & "0000" & "0000", -- Adding into sum s0 
        
        7 => "1100" & "0010" & "0001" & "0100", -- Adding into sum s1
        
        8 => "1100" & "0000" & "0001" & "0000", -- Load into s0 , s1 
        
        9 => "1100" & "0001" & "0010" & "0000", -- Load into s1 , sum (s2)
        
        10 => "1110" & "0010" & "00000000", -- print Sum
        
        11 => "0110" & "1010" & "00000001", -- Sub from counter 
        
        12 => "100" & '1' & "01" & "01" & "00000110",  -- JUMP NZ, addr 6
        
--        13 => "1010" & "1000" & "00000000", -- Input value in register 8
        
        13 => "1110" & "1000" & "00000000", -- print value in register 8, 0000 
        
        14 => "100" & '0' & "00" & "01" & "00000000",  -- JUMP, addr 0
            others => "0000000000000000"

    );

begin
    Data <= ROM_Mem(to_integer(unsigned(Add))) when CS = '1' else (others=>'Z');

end Behavioral;