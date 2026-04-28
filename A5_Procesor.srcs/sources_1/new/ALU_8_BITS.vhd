
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;


entity ALU_8_BITS is
    port( A : in STD_LOGIC_VECTOR(7 downto 0);
          B : in STD_LOGIC_VECTOR(7 downto 0);
          ALU_SEL : in STD_LOGIC_VECTOR(3 downto 0);
          O : out STD_LOGIC_VECTOR(7 downto 0);
          C_flag_future : out STD_LOGIC;
          Z_flag_future : out STD_LOGIC;
          WE : out STD_LOGIC;
          C_flag_past : in STD_LOGIC;
          Z_flag_past : in STD_LOGIC
          );
        
end ALU_8_BITS;

architecture Behavioral of ALU_8_BITS is

begin  
    process(ALU_SEL)
        begin
           case ALU_SEL is 
                when "000" => -- LOAD --
                    O <= B;
                when "001" => -- AND -- 
                    O <= A AND B;
                when "010" => -- OR -- 
                    O <= A OR B;
                when "011" => -- XOR -- 
                    O <= A XOR B;
                when "100" => -- ADD -- 
                    
                when "101" => -- ADD with C -- 
                
                when "110" => -- SUB --
                
                when "111" => -- Sub with C -- 
                
                when others =>
                    O <= (others => 'Z');
           end case;
    end process;

end Behavioral;
