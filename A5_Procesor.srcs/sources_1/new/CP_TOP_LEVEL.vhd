
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;


entity CP_TOP_LEVEL is
    port( CLK : in STD_LOGIC;
          RST : in STD_LOGIC;
          -- Interupts logic
          Hold_From_Interupter : in STD_LOGIC;
          -- Flags from ALU -- 
          Zero_Flag : in STD_LOGIC;
          Carry_Flag : in STD_LOGIC;
          -- Rotation -- 
          Rotation_flag : out STD_LOGIC;
          Interupt_flag_en : out STD_LOGIC;
          Interupt_flag_off : out STD_LOGIC;
          Write_enable : out STD_LOGIC;
          -- Mostly used for Debuging -- 
          Addres_out : out STD_LOGIC_VECTOR(15 downto 0);
          -- Signal for deciding using Constant or Register -- 
          Konstant : out STD_LOGIC;
          -- SIGNALS FOR ADD, SUB, MOV , JUMP , XOR , AND ... -- 
          ALU_OUT : out STD_LOGIC_VECTOR(2 downto 0);
          Update_carry_zero : out STD_LOGIC
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
          JUMP_SIG : out STD_LOGIC; 
          ALU_Sel : out STD_LOGIC_VECTOR(2 downto 0);
          Address_JUMP : out STD_LOGIC_VECTOR(7 downto 0);
          Mux_B_decide : out STD_LOGIC;
          Rotation_Signal : out STD_LOGIC;
          Write_enable : out STD_LOGIC;
          Update_carry_zero : out STD_LOGIC;
          Interupt_flag_en : out STD_LOGIC;
          Interupt_flag_off : out STD_LOGIC;
          Zero_flag : in STD_LOGIC;
          Carry_flag : in STD_LOGIC;
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
                    JUMP_SIG => JUMP_FROM_DECODER,
                    ALU_Sel  => ALU_OUT,
                    Mux_B_decide => Konstant,
                    Rotation_Signal => Rotation_flag,
                    Zero_flag => Zero_Flag,
                    Write_enable =>  Write_enable, 
                    Carry_Flag => Carry_Flag, 
                    Interupt_flag_en => Interupt_flag_en,
                    Interupt_flag_off => Interupt_flag_off, 
                    Update_carry_zero => Update_carry_zero, 
                    Address_JUMP => JUMP_ADDRESS_FROM_DECODER,
                    Memorie_debug_instuction => Addres_out
                    );
       

end Structural;
