
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP_LEVEL is
    port(
          CLk : in STD_LOGIC;
          RST : in STD_LOGIC;
          Interupt_led : out STD_LOGIC;
          Interupt_sw : in STD_LOGIC;
          Operation_out : out STD_LOGIC_VECTOR(7 downto 0);
          Adress_debug : out STD_LOGIC_VECTOR(15 downto 0)
          );
end TOP_LEVEL;

architecture Structural of TOP_LEVEL is
    
    component REGISTER_File is                                                                                                                                                                                           
    port(
        Sx_add : in STD_LOGIC_VECTOR(3 downto 0);
        Sy_add : in STD_LOGIC_VECTOR(3 downto 0);
        CLK : in STD_LOGIC;
        Write_in : in STD_LOGIC;
        Operation_from_ALU : in STD_LOGIC_VECTOR(7 downto 0);
        RST : in STD_LOGIC;
        
        Sx_out : out STD_LOGIC_VECTOR(7 downto 0);
        Sy_out : out STD_LOGIC_VECTOR(7 downto 0)
    );
    end component;
    
    component ALU_8_BITS is
    port( A : in STD_LOGIC_VECTOR(7 downto 0);
          B : in STD_LOGIC_VECTOR(7 downto 0);
          ALU_SEL : in STD_LOGIC_VECTOR(2 downto 0);
          O : out STD_LOGIC_VECTOR(7 downto 0);
          C_flag_future : out STD_LOGIC;
          Z_flag_future : out STD_LOGIC;
          C_flag_past : in STD_LOGIC;
          Z_flag_past : in STD_LOGIC
          );
        
    end component;
    
    component Interupter is
    port(
    
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        Interupt_sw : in STD_LOGIC;
        Interupt_FLAG : in STD_LOGIC;
        Hold_all : out STD_LOGIC; -- will go to flags to ensure they dont change -- 
        Trigger_leg : out STD_LOGIC;
        Done : out STD_LOGIC
    );
    end component;
    
    component CP_TOP_LEVEL is
    port( CLK : in STD_LOGIC;
          RST : in STD_LOGIC;
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
    end component;
    
    component Constant_Decider is
    port( B : in STD_LOGIC_VECTOR(7 downto 0);
          KK : in STD_LOGIC_VECTOR(7 downto 0);
          MSB_DECIDE : in STD_LOGIC;
          O : OUT STD_LOGIC_VECTOR(7 downto 0)
          );
    end component;
    
    
    
    component Flags_Register is
    port(
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        Enable_int : in STD_LOGIC;
        Disable_int : in STD_LOGIC;
        Flag_C_ALU : in STD_LOGIC;
        Flag_Z_ALU : in STD_LOGIC;
        Update_carry_zero_PC : in STD_LOGIC;
        Z_flag : out STD_LOGIC;
        Interupt_triger : out STD_LOGIC;
        C_flag : out STD_LOGIC
        );
    end component;
    
    
    -- Interanl signals for PC top level -- 
    signal rotation_flag_PC : STD_LOGIC :='0';
    signal Konstant_from_PC : STD_LOGIC :='0';
    signal ALU_SEL_PC : STD_LOGIC_VECTOR(2 downto 0) :=(others=>'0');
    signal Write_PC_REG : STD_LOGIC :='0';
    signal Konstant_B : STD_LOGIC_VECTOR(7 downto 0) :=(others=>'0');
    signal Update_carry_zero_PC : STD_LOGIC := '0';
    signal Enable_interupt_PC : STD_LOGIC;
    signal Disable_interupt_PC : STD_LOGIC;
    -- Flags register signals -- 
    signal Carry_Flag : STD_LOGIC;
    signal Zero_Flag : STD_LOGIC;
    
    -- Mux decide konstant or B -- 
    signal B_final : STD_LOGIC_VECTOR(7 downto 0) :=(others =>'0');
    signal Add_KK : STD_LOGIC_VECTOR(7 downto 0) := (others=>'0');
    -- Internal signals for ALU -- 
    signal Output_ALU : STD_LOGIC_VECTOR(7 downto 0) := (others =>'0');
    signal Z_flag_output_ALU : STD_LOGIC :='0';
    signal C_flag_output_ALU : STD_LOGIC :='0';
    signal Write_enable : STD_LOGIC; -- this will be removed --     
    -- Interanl signals for Register file --
    signal Sx_index : STD_LOGIC_VECTOR(3 downto 0):=(others =>'0');
    signal Sy_index : STD_LOGIC_VECTOR(3 downto 0) :=(others=>'0');
    signal Address_aux : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
    
    signal A_operand : STD_LOGIC_VECTOR(7 downto 0) :=(others=>'0');
    signal B_operand : STD_LOGIC_VECTOR(7 downto 0) :=(others=>'0');
    
    -- Interupts singals -- 
    signal Hold_flags : STD_LOGIC :='0';
    signal Done : STD_LOGIC :='0';
    
    signal Interupt_from_flags : STD_LOGIC :='0';
    
    signal Update_carry_zero_final : STD_LOGIC :='0';
    signal Update_write_final : STD_LOGIC :='0';
    
begin
    -- Basically Update_flags decoder makes the update 
    -- OR variant two Done counting and Hold flags is on 0  
    Update_carry_zero_final <= Update_carry_zero_PC AND (NOT Hold_flags);
    Update_write_final <= Write_PC_REG AND (NOT Hold_flags);
    
    Interuptor : Interupter port map(
        CLK => CLK,
        Interupt_FLAG => Interupt_from_flags,
        RST => RST,
        Interupt_sw => Interupt_sw,
        Hold_all => Hold_flags, 
        Trigger_leg => Interupt_led,
        Done => Done
    );
    
    PC : CP_TOP_LEVEL port map(
        CLK => CLK,
        RST => RST,
        Hold_From_Interupter => Hold_flags,
        Interupt_flag_en => Enable_interupt_PC,
        Interupt_flag_off => Disable_interupt_PC,
        Zero_flag => Zero_flag,
        Carry_flag => Carry_flag, 
        Rotation_flag=> rotation_flag_PC,
        Addres_out => Address_aux,
        Write_enable => Write_PC_REG, 
        Konstant => Konstant_from_PC,
        ALU_out => ALU_SEL_PC,
        Update_carry_zero=> Update_carry_zero_PC
    );
    
    Adress_debug <= Address_aux;
    
    Sx_index <= Address_aux(11 downto 8);
    Sy_index <= Address_aux(7 downto 4);
    Konstant_B <= Address_aux(7 downto 0);
    
    Registers : REGISTER_File port map(
        Sx_add => Sx_index,
        Sy_add => Sy_index,
        Clk => CLK,
        RST => RST,
        Write_in => Update_write_final,
        Operation_from_ALU => Output_ALU,
        Sx_out => A_operand ,
        Sy_out => B_operand
    );
    
    Konstant : Constant_Decider port map(
        B => B_operand,
        KK => Konstant_B,
        MSB_DECIDE => Konstant_from_PC,
        O => B_final
    );
    
    ALU : ALU_8_BITS port map(
        A => A_operand,
        B => B_final,
        ALU_SEL => ALU_SEL_PC , 
        O => Output_ALU ,
        C_flag_future => C_flag_output_ALU,
        Z_flag_future => Z_flag_output_ALU,
        C_flag_past => Carry_Flag,
        Z_flag_past => Zero_Flag
    );
    
    Flag_register : Flags_Register port map(
        CLK => CLK,
        Enable_int  => Enable_interupt_PC,
        Disable_int => Disable_interupt_PC,
        RST => RST,
        Flag_C_ALU => C_flag_output_ALU, -- enter Carry -- 
        Flag_Z_ALU => Z_flag_output_ALU, -- enter Zero --
        Update_carry_zero_PC => Update_carry_zero_final,
        Interupt_triger =>Interupt_from_flags,
        Z_flag => Zero_Flag, -- exits Carry --
        C_flag => Carry_Flag -- exits Zero --
    );
    
    Operation_out<=Output_ALU;

end Structural;
