library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Full_adder is
    port(A: in STD_LOGIC_Vector (7 downto 0);
        B: in STD_LOGIC_Vector (7 downto 0);
        Cin: in STD_LOGIC;
        Cout: out STD_LOGIC;
        Sum: out STD_LOGIC; )
end Full_adder;

architecture of Full_adder is
    signal temp: STD_logic_vector (8 downto 0);
begin
    temp <= A + B;
    cout <= temp(8) ;
    Sum <= temp( 7 downto 0);
