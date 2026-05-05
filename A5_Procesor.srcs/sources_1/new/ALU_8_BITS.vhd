
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;


entity ALU_8_BITS is
    port( A : in STD_LOGIC_VECTOR(7 downto 0);
          B : in STD_LOGIC_VECTOR(7 downto 0);
          ALU_SEL : in STD_LOGIC_VECTOR(2 downto 0);
          O : out STD_LOGIC_VECTOR(7 downto 0);
          C_flag_future : out STD_LOGIC;
          Z_flag_future : out STD_LOGIC;
          C_flag_past : in STD_LOGIC;
          Z_flag_past : in STD_LOGIC
          );
        end ALU_8_BITS;

architecture Behavioral of ALU_8_BITS is

begin  
    process(ALU_SEL,A,B,C_flag_past,Z_flag_past)
        variable temp : STD_LOGIC_VECTOR(8 downto 0);
        begin
           temp := (others =>'0');
           C_flag_future <= '0';
           Z_flag_future <= '0';
           case ALU_SEL is 
                when "000" => -- LOAD --
                    temp := '0' & B;
                when "001" => -- AND -- 
                    temp := '0' & (A AND B);
                when "010" => -- OR -- 
                    temp := '0' & ( A OR B ) ;
                when "011" => -- XOR -- 
                    temp := '0' & (A XOR B);
                when "100" => -- ADD -- 
                   temp := ('0'& A) + ('0' & B);
                   C_flag_future <= temp(8);               
                when "101" => -- ADD with C -- 
                   temp := ('0' & A) + ('0' & B) + ("00000000" & C_flag_past);
                   C_flag_future <= temp(8);    
                    when "110" => -- SUB --
                    temp := ('0' & A ) - ('0' & B) ;
                    C_flag_future <= temp(8);
                when "111" => -- Sub with C -- 
                    temp := ('0' & A) - ('0' & B) - ("00000000" & C_flag_past) ; 
                    C_flag_future <= temp(8);
                when others =>
                    O <= (others => 'Z');
           end case;
           
           O <= temp(7 downto 0);
           
           if(temp(7 downto 0) = "00000000") then
                Z_flag_future <= '1';
           end if;
           
    end process;

end Behavioral;
