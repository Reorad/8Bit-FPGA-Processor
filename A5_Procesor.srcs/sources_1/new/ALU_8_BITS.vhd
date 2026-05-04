
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
          WE : out STD_LOGIC;
          C_flag_past : in STD_LOGIC;
          Z_flag_past : in STD_LOGIC
          );
        
end ALU_8_BITS;

architecture Behavioral of ALU_8_BITS is
signal temp: std_logic_vector (8 downto 0);
begin  
    process(ALU_SEL,A,B,C_flag_past,Z_flag_past)
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
                   temp <= A + B;
                   O <=temp (7 downto 0);               
                when "101" => -- ADD with C -- 
                    temp <= ('0' & A) + B + C_flag_past;
                   O <=temp (7 downto 0);
                   C_flag_future <= temp(8);    
                    when "110" => -- SUB --
                    O <= A - B;
                when "111" => -- Sub with C -- 
                    O <= A-B; 
                    if A < B then
                        C_flag_future <= '1';
                    end if;
                when others =>
                    O <= (others => 'Z');
           end case;
    end process;

end Behavioral;
