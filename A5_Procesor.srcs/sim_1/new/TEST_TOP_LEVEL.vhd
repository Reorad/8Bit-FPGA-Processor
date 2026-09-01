
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TEST_PC_TOP_LEVEL is
--  Port ( );
end TEST_PC_TOP_LEVEL;

architecture Test of TEST_PC_TOP_LEVEL is

    component CP_TOP_LEVEL is
    port( CLK : in STD_LOGIC;
          RST : in STD_LOGIC;
          -- Interupts logic
          Hold_From_Interupter : in STD_LOGIC; 
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
          Addres_out : out STD_LOGIC_VECTOR(15 downto 0);
          PC_Out_Debug : out STD_LOGIC_VECTOR(7 downto 0);
          -- Signal for deciding using Constant or Register -- 
          Konstant : out STD_LOGIC;
          Konstant_I_O : out STD_LOGIC;
          -- Input/Output signals --
          Write_str : out STD_LOGIC;
          Read_str : out STD_LOGIC;
          -- SIGNALS FOR ADD, SUB, MOV , JUMP , XOR , AND ... -- 
          ALU_OUT : out STD_LOGIC_VECTOR(2 downto 0)
          );
    end component;
    
    -- Semnale declarate EXACT cu aceleasi nume ca porturile
    -- Intrarile sunt initializate cu '0' pentru a evita starea 'U' in simulare
    signal CLK : STD_LOGIC := '0';
    signal RST : STD_LOGIC := '0';
    signal Hold_From_Interupter : STD_LOGIC := '0';
    signal Zero_Flag : STD_LOGIC := '0';
    signal Carry_Flag : STD_LOGIC := '0';
    
    -- Iesirile nu au nevoie de initializare in testbench
    signal Rotation_flag_out : STD_LOGIC;
    signal Rotation_code_out : STD_LOGIC_VECTOR(3 downto 0);
    signal Interupt_flag_en : STD_LOGIC;
    signal Interupt_flag_off : STD_LOGIC;
    signal Update_carry_zero : STD_LOGIC;
    signal Write_enable : STD_LOGIC;
    signal Addres_out : STD_LOGIC_VECTOR(15 downto 0);
    signal PC_Out_Debug : STD_LOGIC_VECTOR(7 downto 0);
    signal Konstant : STD_LOGIC;
    signal Konstant_I_O : STD_LOGIC;
    signal Write_str : STD_LOGIC;
    signal Read_str : STD_LOGIC;
    signal ALU_OUT : STD_LOGIC_VECTOR(2 downto 0);

begin

    -- Instantierea Unit Under Test (UUT)
    uut: CP_TOP_LEVEL 
    port map (
        CLK                  => CLK,
        RST                  => RST,
        Hold_From_Interupter => Hold_From_Interupter,
        Zero_Flag            => Zero_Flag,
        Carry_Flag           => Carry_Flag,
        Rotation_flag_out    => Rotation_flag_out,
        Rotation_code_out    => Rotation_code_out,
        Interupt_flag_en     => Interupt_flag_en,
        Interupt_flag_off    => Interupt_flag_off,
        Update_carry_zero    => Update_carry_zero,
        Write_enable         => Write_enable,
        Addres_out           => Addres_out,
        PC_Out_Debug         => PC_Out_Debug,
        Konstant             => Konstant,
        Konstant_I_O         => Konstant_I_O,
        Write_str            => Write_str,
        Read_str             => Read_str,
        ALU_OUT              => ALU_OUT
    );

    -- Proces pentru Reset
    process
    begin
        RST <= '1';
        wait for 10 ns;
        RST <= '0';
        wait; -- Asteapta la infinit dupa ce opreste resetul
    end process;
    
    -- Proces pentru generarea Ceasului (Perioada = 10 ns -> Frecventa = 100 MHz)
    process
    begin
        CLK <= '1';
        wait for 5 ns;
        CLK <= '0';
        wait for 5 ns;
    end process;

    

end Test;