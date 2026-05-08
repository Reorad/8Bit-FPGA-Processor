
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;


entity CP_TOP_LEVEL is
    port( CLK : in STD_LOGIC;
          RST : in STD_LOGIC;
          -- Interupts logic
          Hold_From_Interupter : in STD_LOGIC; -- From Interuptor its hold all signall -- 
          -- Flags from ALU -- entering the Memory instructions --
          Zero_Flag : in STD_LOGIC;
          Carry_Flag : in STD_LOGIC;
          -- Rotation -- 
          Rotation_flag_out : out STD_LOGIC;
          Rotation_code_out : out STD_LOGIC_VECTOR(3 downto 0);
          -- Interupt flags -- 
          Interupt_flag_en : out STD_LOGIC;
          Interupt_flag_off : out STD_LOGIC;
          -- write into register / flag  
          Update_carry_zero : out STD_LOGIC;
          Write_enable : out STD_LOGIC;
          -- Mostly used for Debuging -- 
          Addres_out : out STD_LOGIC_VECTOR(15 downto 0);
          -- Signal for deciding using Constant or Register -- 
          Konstant : out STD_LOGIC;
          Konstant_I_O : out STD_LOGIC;
          -- Input/Output signals --
          Write_str : out STD_LOGIC;
          Read_str : out STD_LOGIC;
          -- SIGNALS FOR ADD, SUB, MOV , JUMP , XOR , AND ... -- 
          ALU_OUT : out STD_LOGIC_VECTOR(2 downto 0)
          );
end CP_TOP_LEVEL;

architecture Structural of CP_TOP_LEVEL is
    
    component CP_Register is
    port(   
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        -- Interupt signals -- 
        PC_HOLD : in STD_LOGIC;
        COME_MEM_INS : in STD_LOGIC;
        COME_INS_ADD : in STD_LOGIC_VECTOR(7 downto 0);
        
        PC_OUT : out STD_LOGIC_VECTOR(7 downto 0)
    );
    end component;
    
   component rom is
    Generic (ADD_SIZE  : natural := 8;
             DATA_SIZE : natural := 16);
    Port ( Add  : in STD_LOGIC_VECTOR (ADD_SIZE-1 downto 0);
           CS   : in STD_LOGIC;
           Data : out STD_LOGIC_VECTOR (DATA_SIZE-1 downto 0));
    end component; 
    
    
    
    component Memory_Instructions is
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
    end component;
    
    
    -- signals from ALU -- 
    
    signal JUMP_FROM_DECODER : STD_LOGIC := '0';
    signal JUMP_ADDRESS_FROM_DECODER : STD_LOGIC_VECTOR(7 downto 0) :=(others =>'0');
    signal PC_INDEX_TO_ROM : STD_LOGIC_VECTOR(7 downto 0) :=(others=>'0');
    signal ROM_INSTRUCTION_ADD_DECODER : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
    signal Address_out_aux : STD_LOGIC_VECTOR(15 downto 0) :=(others=>'0');
    
begin
    
        PC : CP_Register port map(
                CLK=>CLK,
                RESET => RST,
                PC_HOLD => Hold_From_Interupter, 
                COME_MEM_INS => JUMP_FROM_DECODER,
                COME_INS_ADD => JUMP_ADDRESS_FROM_DECODER,
                PC_OUT => PC_INDEX_TO_ROM
                );
            
    ROM_Instruction_saved : rom 
                generic map(
                    ADD_SIZE => 8,
                    DATA_SIZE => 16
                )
                port map(
                    Add => PC_INDEX_TO_ROM , 
                    CS => '1',
                    Data => ROM_INSTRUCTION_ADD_DECODER
                    );
                
     DECODER_DATA : Memory_Instructions port map(
                    Memorie_in_instruction => ROM_INSTRUCTION_ADD_DECODER,
                    Rotation_code => Rotation_code_out,
                    Rotation_Signal => Rotation_flag_out,
                    ALU_Sel => ALU_OUT,
                    Update_carry_zero => Update_carry_zero,
                    Write_enable => Write_enable, 
                    JUMP_SIG => JUMP_FROM_DECODER, 
                    Address_JUMP => JUMP_ADDRESS_FROM_DECODER, 
                    Mux_B_decide => Konstant,
                    Decide_I_O_KK => Konstant_I_O, 
                    Write_strobe_signal => Write_str, 
                    Read_strobe_signal => Read_str,
                    Interupt_flag_en =>  Interupt_flag_en,
                    Interupt_flag_off => Interupt_flag_off,
                    Zero_flag =>  Zero_Flag,
                    Carry_flag => Carry_Flag, 
                    Memorie_debug_instuction => Addres_out
                    );
       

end Structural;
