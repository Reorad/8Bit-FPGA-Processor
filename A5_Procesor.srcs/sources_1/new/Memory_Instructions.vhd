
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Memory_Instructions is
    port( Memorie_in_instruction : in STD_LOGIC_VECTOR(15 downto 0);
          JUMP_SIG : out STD_LOGIC; 
          ALU_Sel : out STD_LOGIC_VECTOR(2 downto 0);
          Address_JUMP : out STD_LOGIC_VECTOR(7 downto 0);
          Mux_B_decide : out STD_LOGIC;
          Memorie_debug_instuction : out STD_LOGIC_VECTOR (15 downto 0)
          );
end Memory_Instructions;

architecture Behavioral of Memory_Instructions is
    
    signal Op_Register_KK       : STD_LOGIC; 
    signal Operation_code_first : STD_LOGIC_VECTOR(3 downto 0);
    signal Type_conditional     : STD_LOGIC_VECTOR(2 downto 0);
    signal Flow_add             : STD_LOGIC_VECTOR(4 downto 0); 
    
begin

    Op_Register_KK <= Memorie_in_instruction(15);
    Operation_code_first <= Memorie_in_instruction(15 downto 12);
    Flow_add <= Memorie_in_instruction(15 downto 13) & Memorie_in_instruction(9 downto 8);
    Type_conditional <= Memorie_in_instruction(12 downto 10);
    Mux_B_decide <= Memorie_in_instruction(15);
    process (Memorie_in_instruction, Op_Register_KK, Operation_code_first, Flow_add)
    begin 
        
        JUMP_SIG <= '0';
        ALU_Sel <= (others => '0');
        Address_JUMP <= (others => '0');
        Memorie_debug_instuction <= Memorie_in_instruction;
        
      
        if (Op_Register_KK = '0') then
           
            ALU_Sel <= Memorie_in_instruction(14 downto 12); 
            
        else
            
            case Operation_code_first is
                
                when "1100" => 
                    ALU_Sel <= Memorie_in_instruction(2 downto 0);
                    
                when "1101" | "1010" | "1011" | "1110" | "1111" =>
                    Memorie_debug_instuction <= "0000000000001111";
                    
                when others =>
                   
                    case Flow_add is
                        when "10001" =>
                            JUMP_SIG     <= '1';
                            Address_JUMP <= Memorie_in_instruction(7 downto 0);
                        
                        when others =>
                            -- Dacă nu e jump-ul așteptat, asigurăm că semnalul stă pe 0
                            JUMP_SIG <= '0';
                    end case;
                    
            end case;
        end if;
    end process;
end Behavioral;