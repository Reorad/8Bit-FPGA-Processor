
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
          Rotation_flag : in STD_LOGIC;
          Rotation_code : in STD_LOGIC_VECTOR(3 downto 0);
          O : out STD_LOGIC_VECTOR(7 downto 0);
          C_flag_future : out STD_LOGIC;
          Z_flag_future : out STD_LOGIC;
          C_flag_past : in STD_LOGIC;
          Z_flag_past : in STD_LOGIC
          );
        end ALU_8_BITS;

architecture Behavioral of ALU_8_BITS is

    signal Type_roation : STD_LOGIC; -- Decides left or right
    signal Rotation_cods : STD_LOGIC_VECTOR(2 downto 0); -- rotation code simplified
begin  
    
    Type_roation <= Rotation_code(3);
    Rotation_cods <= Rotation_code(2 downto 0);
    
    process(ALU_SEL,A,B,C_flag_past,Z_flag_past)
        variable temp : STD_LOGIC_VECTOR(8 downto 0);
        variable temp_rot : STD_LOGIC_VECTOR(7 downto 0); -- rotation --
        begin
           temp := (others =>'0');
           C_flag_future <= '0';
           Z_flag_future <= '0';
           
           if(Rotation_flag ='0') then
           
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
               
           else
                if(Type_roation ='1') then -- right rotation
                    C_flag_future <= A(0);
                    case Rotation_cods is
                        when "110" => -- SR0 
                            temp_rot := '0' & A(7 downto 1);
                        when "111" => -- SR1 
                            temp_rot := '1' & A(7 downto 1);
                        when "010" => -- SRX 
                            temp_rot := A(7) & A(7 downto 1);
                        when "000" => --SRA 
                            temp_rot := C_flag_past & A(7 downto 1);
                        when "100" => -- RR
                            temp_rot := A(0) & A(7 downto 1);
                        when others =>
                            temp_rot :=  A;
                            
                        end case;
                    else 
                        C_flag_future <= A(7);
                        case Rotation_cods is
                            when "110" => -- SL0 
                                temp_rot := A(6 downto 0) & '0';
                            when "111" => -- SL1 
                                temp_rot := A(6 downto 0) & '1';
                            when "010" => -- SLX 
                                temp_rot := A(6 downto 0) & A(0);
                            when "000" => --SLA 
                                temp_rot :=  A(6 downto 0) & C_flag_past ;
                            when "100" => -- RL
                                temp_rot :=  A(6 downto 0) & A(7);
                            when others =>
                                temp_rot :=  A;
                         end case;
                
                    end if;
                temp := '0' & temp_rot;     
           end if;
           
           O <= temp(7 downto 0);
           
           if(temp(7 downto 0) = "00000000") then
                Z_flag_future <= '1';
           end if;
           
    end process;

end Behavioral;
