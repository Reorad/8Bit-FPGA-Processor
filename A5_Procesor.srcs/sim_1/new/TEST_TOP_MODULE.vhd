
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Test_Top_level is
--  Port ( );
end Test_Top_level;

architecture Test of Test_Top_level is
component TOP_LEVEL is 
port(
          CLk : in STD_LOGIC;
          RST : in STD_LOGIC;
          Interupt_led : out STD_LOGIC;
          Interupt_sw : in STD_LOGIC;
          Input_sw : in STD_LOGIC_VECTOR(7 downto 0);
          Write_str : out STD_LOGIC; -- this could be used for FIFO reading -- 
          Read_str : out STD_LOGIC; -- this does into SSD driver -- 
          Operation_out : out STD_LOGIC_VECTOR(7 downto 0);
          Adress_debug : out STD_LOGIC_VECTOR(15 downto 0)
          );
    end component;
    
    signal CLK : STD_LOGIC :='0';
    signal RST : STD_LOGIC :='0';
    signal WRT_STRB : STD_LOGIC;
    signal RED_STRB : STD_LOGIC;
    signal Operation_out : STD_LOGIC_VECTOR(7 downto 0) :=(others=>'0');
    signal Adress_debug  : STD_LOGIC_VECTOR(15 downto 0) :=(others=>'0');
    signal Int_sw : STD_LOGIC :='0';
    signal Int_led : STD_LOGIC;
    signal INPUT_SW : STD_LOGIC_VECTOR(7 downto 0) :=(others =>'0');
begin

    UUT : TOP_LEVEL port map(
        CLK => CLK,
        RST => RST,
        Interupt_led => Int_led,
        Interupt_sw => Int_sw,
        Write_str => WRT_STRB ,
        Input_sw => INPUT_SW,
        Read_str => RED_STRB ,
        Operation_out => Operation_out,
        Adress_debug => Adress_debug    
    );
    
    process
        begin
            RST<='1';
            wait for 15ns;
            RST<='0';
            wait for 60ns; 
            Int_sw <='1';
            wait for 10ns; 
            Int_sw <='0';
            wait for 70ns;
            Int_sw <='1';
            wait for 10ns;
            Int_Sw <='0';
            
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
