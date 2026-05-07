
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
        0 => "0000" & "0000" & "00000001",  -- Load into s0 0
        
        1 => "1000000000110000",  -- interupt enable
        
        2 => "0000" & "0001" & "00000001", -- Load into s1 0
        
        3 => "0000" & "0010" & "00000000", -- SUM will be s2 
        
        4 => "0000" & "1010" & "00000111", -- S10 will be Counter 7 + 2 9th fibonacii
        
        5 => "1100" & "0010" & "0000" & "0000", -- Adding into sum s0 
        
        6 => "1100" & "0010" & "0001" & "0100", -- Adding into sum s1
        
        7 => "1100" & "0000" & "0001" & "0000", -- Load into s0 , s1 
        
        8 => "1100" & "0001" & "0010" & "0000", -- Load into s1 , sum (s2)
        
        9 => "0110" & "1010" & "00000001", -- Sub from counter 
        
        10 => "100" & '1' & "01" & "01" & "00000101",  -- JUMP NZ, addr 4
        
        
        
        11 => "100" & '0' & "00" & "01" & "00000000",  -- JUMP, addr 0
            others => "0000000000000000"
    );

begin
    Data <= ROM_Mem(to_integer(unsigned(Add))) when CS = '1' else (others=>'Z');

end Behavioral;