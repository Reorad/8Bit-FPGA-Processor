
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
        0 => "0000000000001111", -- Load into s0 0001111 , 15 
        1 => "0000000011100000", -- LOAD into s0 1110000,  224
        2 => "0000001011000000", -- Load into s2 1100000
        3 => "1100000010100010", -- ADD into s0 the value of s10
        4 => "0010000111111111", -- Add into s1 111111111
        5 => "0000111100000000", -- Loads into register s15 0
        6 => "0110111100000001", -- Substract s15 1 should trigger carry flag
        7 => "1000000100000000", -- jump back to start 
        others => "0000000000000000"
    );

begin
    Data <= ROM_Mem(to_integer(unsigned(Add))) when CS = '1' else (others=>'Z');

end Behavioral;