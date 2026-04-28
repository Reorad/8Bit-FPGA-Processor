
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TEST_TOP_LEVEL is
--  Port ( );
end TEST_TOP_LEVEL;

architecture Test of TEST_TOP_LEVEL is

    component CP_TOP_LEVEL is
    port( CLK : in STD_LOGIC;
          RST : in STD_LOGIC;
          -- Flags from ALU -- 
          Zero_Flag : in STD_LOGIC;
          Carry_Flag : in STD_LOGIC;
          -- Rotation -- 
          Rotation_flag : out STD_LOGIC;
          -- Mostly used for Debuging -- 
          Addres_out : out STD_LOGIC_VECTOR(15 downto 0);
          -- Signal for deciding using Constant or Register -- 
          Konstant : out STD_LOGIC;
          -- SIGNALS FOR ADD, SUB, MOV , JUMP , XOR , AND ... -- 
          ALU_OUT : out STD_LOGIC_VECTOR(2 downto 0)
          );
    end component;
    
    signal CLK, RST : STD_LOGIC;
    signal Address_out : STD_LOGIC_VECTOR(15 downto 0);
    signal ALU_OUT : STD_LOGIC_VECTOR(2 downto 0);
    signal Mux_B_decide : STD_LOGIC;
    signal Rotation_flag : STD_LOGIC;
    signal Z,C : STD_LOGIC;
    
begin

    UUT : CP_TOP_LEVEL port map(CLK,RST,Z,C,Rotation_flag,Address_out,Mux_B_decide,ALU_OUT);
    
    process
        begin
            
            RST<='1';
            wait for 10ns;
            RST<='0';
            wait for 10ns;
            wait;
    end process;
    
    process
        begin
            
            CLK<='1';
            wait for 5ns;
            CLK<='0';
            wait for 5ns;
            
    end process;

end Test;
