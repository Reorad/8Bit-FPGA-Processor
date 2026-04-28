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
        0 => "0000000000001111", -- just check ROTATION 
        1 => "0001000000000000", -- AND so 001
        2 => "0010000000000000", -- SUB so 010
        3 => "1000000100000000", -- jump back to start 
        others => "0000000000000000"
    );

begin
    Data <= ROM_Mem(to_integer(unsigned(Add))) when CS = '1' else (others=>'Z');

end Behavioral;