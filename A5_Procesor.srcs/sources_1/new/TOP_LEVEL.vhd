
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
          ALU_SEL : in STD_LOGIC_VECTOR(3 downto 0);
          O : out STD_LOGIC_VECTOR(7 downto 0);
          C_flag_future : out STD_LOGIC;
          Z_flag_future : out STD_LOGIC;
          WE : out STD_LOGIC;
          C_flag_past : in STD_LOGIC;
          Z_flag_past : in STD_LOGIC
          );
        
    end component;
    
    component CP_TOP_LEVEL is
    port( CLK : in STD_LOGIC;
          RST : in STD_LOGIC;
          -- Flags from ALU -- 
          Zero_Flag : in STD_LOGIC;
          Carry_Flag : in STD_LOGIC;
          -- Rotation -- 
          Rotation_flag : out STD_LOGIC;
          Write_enable : out STD_LOGIC;
          -- Mostly used for Debuging -- 
          Addres_out : out STD_LOGIC_VECTOR(15 downto 0);
          -- Signal for deciding using Constant or Register -- 
          Konstant : out STD_LOGIC;
          -- SIGNALS FOR ADD, SUB, MOV , JUMP , XOR , AND ... -- 
          ALU_OUT : out STD_LOGIC_VECTOR(2 downto 0)
          );
    end component;
    
    signal zero_flag_alu, carry_flag_alu : STD_LOGIC :='0';
    signal rotation_flag_PC : STD_LOGIC :='0';
    signal Konstant_from_PC : STD_LOGIC :='0';
    signal ALU_SEL_PC : STD_LOGIC_VECTOR(2 downto 0) :=(others=>'0');
    signal Write_PC_REG : STD_LOGIC :='0';
begin
    
    PC : CP_TOP_LEVEL port map(
        CLK => CLK,
        RST => RST,
        Zero_flag => zero_flag_alu,
        Carry_flag => carry_flag_alu, 
        Rotation_flag=> rotation_flag_PC,
        Addres_out => Adress_debug,
        Write_enable => Write_PC_REG, 
        Konstant => Konstant_from_PC,
        ALU_out => ALU_SEL_PC
    );
    
    
    

end Structural;
