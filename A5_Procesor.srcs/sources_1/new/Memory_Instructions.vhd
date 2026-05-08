library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Memory_Instructions is
    port( Memorie_in_instruction : in STD_LOGIC_VECTOR(15 downto 0);
          -- Flags to ALU --
          Rotation_code : out STD_LOGIC_VECTOR(3 downto 0);  
          Rotation_Signal : out STD_LOGIC;
          ALU_Sel : out STD_LOGIC_VECTOR(2 downto 0);
          -- Updating flags for register file / flags register --
          Update_carry_zero : out STD_LOGIC;
          Write_enable : out STD_LOGIC;
          -- Flow control JUMPS signal --
          JUMP_SIG : out STD_LOGIC;
          Address_JUMP : out STD_LOGIC_VECTOR(7 downto 0);
         -- Decides for constant  --
          Mux_B_decide : out STD_LOGIC;
          -- I/O signals --
          Decide_I_O_KK : out STD_LOGIC; -- bcus I dont want to connect the register file to decoder --
          Write_strobe_signal : out STD_LOGIC;
          Read_strobe_signal : out STD_LOGIC;
          
          -- Interupts flags --
          Interupt_flag_en : out STD_LOGIC;
          Interupt_flag_off : out STD_LOGIC;
          -- Flag from ALU  entering decoder -- 
          Zero_flag : in STD_LOGIC;
          Carry_flag : in STD_LOGIC;
          -- Debug -- 
          Memorie_debug_instuction : out STD_LOGIC_VECTOR (15 downto 0)
          );
end Memory_Instructions;

architecture Behavioral of Memory_Instructions is
    
    signal Op_Register_KK : STD_LOGIC; 
    signal Operation_code_first : STD_LOGIC_VECTOR(3 downto 0);
    signal Flow_add : STD_LOGIC_VECTOR(4 downto 0); 
    signal Conditional_type : STD_LOGIC;
    signal Conditions_flags : STD_LOGIC_VECTOR(1 downto 0);
    
begin
    -- Decides between working constat or registers --
    Op_Register_KK <= Memorie_in_instruction(15); 
    -- Operation code helps us as determening most of instructions --
    Operation_code_first <= Memorie_in_instruction(15 downto 12); 
    -- Flow add they are mostly determined by the first 3 bits and then 9-8 are specified for jump,etc-- 
    Flow_add <= Memorie_in_instruction(15 downto 13) & Memorie_in_instruction(9 downto 8);
    -- if jump coniditonal or not --
    Conditional_type <= Memorie_in_instruction(12);
    -- verifies carry, zero, not carry not zeroo -- 
    Conditions_flags <= Memorie_in_instruction(11 downto 10);
    -- Signal out to Mux that decides between constnat and register value --
    Mux_B_decide <= Memorie_in_instruction(15);
    
    -- COMBINATIONAL PART -- 
    -- since its easier to write in a process --
    process (Memorie_in_instruction, Op_Register_KK, Operation_code_first, Flow_add, Conditional_type, Conditions_flags, Zero_flag, Carry_flag)
    begin 
        -- setting all signal on default vallue --
            
        -- Jump signal shenanigans --
        JUMP_SIG <= '0';
        Address_JUMP <= (others => '0');
        
        -- TO ALU --
        ALU_Sel <= (others => '0');
        Rotation_Signal <='0';    
        Rotation_code <= (others => '0');
        -- Most instructions write back / modify flags --
        Write_enable <= '1'; 
        Update_carry_zero <= '1';
        Memorie_debug_instuction <= Memorie_in_instruction;
        
        -- Interupt flags --
        Interupt_flag_en <= '0';
        Interupt_flag_off <= '0';
        
        -- Input / Output signals that may be modified durring instruction --
        Write_strobe_signal <= '0' ;
        Read_strobe_signal <='0';
        Decide_I_O_KK <= '0';
                
        if (Op_Register_KK = '0') then
           
            ALU_Sel <= Memorie_in_instruction(14 downto 12); 
            if(Memorie_in_instruction(15 downto 12) = "0000") then
                Update_carry_zero <= '0';
            end if;
            
        else
            case Operation_code_first is
                
                when "1100" => 
                    ALU_Sel <= Memorie_in_instruction(2 downto 0);
                    -- this is the case in which we have a load operation -- 
                    -- Load doesnt modify flags should stay the same for register loading --
                    if(Memorie_in_instruction(3 downto 0) = "0000") then
                        Update_carry_zero <= '0';
                    end if;
                when "1101" =>  
                    Rotation_code<= Memorie_in_instruction(3 downto 0);
                    Rotation_Signal <= '1';
                when "1010" => -- Input constant  
                    Read_strobe_signal <= '1';
                    Decide_I_O_KK <='0';
                    Update_carry_zero <= '0';
                when "1011" => -- Input Sx, (Sy) 
                    Read_strobe_signal <= '1';
                    Decide_I_O_KK <='1';
                    Update_carry_zero <= '0';
                when "1110" => -- Output Sx, KK
                    Write_strobe_signal <= '1';
                    Decide_I_O_KK <='0';
                    Update_carry_zero <= '0';
                    Write_enable <= '0';
                when "1111" => -- Output Sx ,(Sy) 
                    Write_strobe_signal  <= '1';
                    Decide_I_O_KK <='1';
                    Update_carry_zero <= '0';
                    Write_enable <= '0';
                when others => -- Here will be JUMP , 
                    JUMP_SIG<='0'; 
                    Write_enable <='0'; 
                    Update_carry_zero<='0';
                    case Flow_add is
                        when "10001" =>
                            -- We consider jump 
                            Address_JUMP <= Memorie_in_instruction(7 downto 0); 
                            if( Conditional_type = '0') then -- Dont care abt condition --
                                JUMP_SIG<='1';    
                            else
                                case Conditions_flags is -- Care about condition -- 
                                        when "00" => -- Is zero
                                            if(Zero_flag = '1' ) then
                                               JUMP_SIG<='1'; 
                                            end if;
                                        when "01" => -- Not zero 
                                            if(Zero_flag = '0' ) then
                                               JUMP_SIG<='1';  
                                            end if;
                                         when "10" => -- IS Carry
                                            if(Carry_flag = '1' ) then
                                               JUMP_SIG<='1';  
                                            end if;
                                         when "11" => -- Not Carry 
                                            if(Carry_flag = '0' ) then
                                               JUMP_SIG<='1'; 
                                             end if;
                                          when others => -- nothing happends -- 
                                   end case; 
                                end if;
--                          when "10011" => -- Call --
                                
                            when others => -- Here will be interupts and other --
                                
                                case Memorie_in_instruction is
                                      when "1000000000110000"=> --  Interupt Enable -- 
                                            Interupt_flag_en <= '1';
                                            Write_enable <= '0';
                                            Update_carry_zero <= '0';
                                      when "1000000000010000" => -- Interupt disable -- 
                                            Interupt_flag_off <= '1';
                                            Write_enable <= '0';
                                            Update_carry_zero <= '0';
                                      when "1000000011110000" => -- Returni Enable-- 
                                            Write_enable <= '0';
                                            Update_carry_zero <= '0';
                                      
                                      when "1000000011010000" => -- Returni Disable
                                            Write_enable <= '0';
                                            Update_carry_zero <= '0';
                                      
                                      when others => -- DONE --
                                      
                                end case;
                    end case;                    
            end case;
        end if;
    end process;
end Behavioral;