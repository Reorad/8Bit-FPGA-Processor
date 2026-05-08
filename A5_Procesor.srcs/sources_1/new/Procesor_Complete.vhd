
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Procesor_Complete is
    port( CLK : in STD_LOGIC;
          CLK_Fast : in STD_LOGIC;
          RST : in STD_LOGIC;
          -- Input switches --
          Input_switches : in STD_LOGIC_VECTOR(15 downto 0);
          -- Interupt switches --
          Interupt_switch : in STD_LOGIC;
          Interupt_led : out STD_LOGIC;
          -- Read would go for a FIFO component but we dont have one --
          Read_str_T : out STD_LOGIC;
          -- Goes to output component -- 
          Write_str_T : out STD_LOGIC;
          -- Disable anodes -- 
          Disable_anode : out STD_LOGIC;
          -- Data out is basicllay for output --
          Data_out : out STD_LOGIC_VECTOR(7 downto 0);
          Data_out_digits : out STD_LOGIC_VECTOR(11 downto 0);
          PC_out : out STD_LOGIC_VECTOR(7 downto 0)
        );
end Procesor_Complete;

architecture Behavioral of Procesor_Complete is
    
    component Input_Component is
    port(Sx : in STD_LOGIC_VECTOR(7 downto 0); -- Register shit --
         KK : in STD_LOGIC_VECTOR(7 downto 0);
         Decider : in STD_LOGIC; 
         Switches : in STD_LOGIC_VECTOR(15 downto 0); -- Switches user puts from board --
         Switches_data_out : out STD_LOGIC_VECTOR(7 downto 0) -- Data comming out --
         );
    end component;
    
    component Output_Component is
    port( Write_strobe : in STD_LOGIC;
          CLK : in STD_LOGIC;
          RST : in STD_LOGIC;
          Interupt_led : in STD_LOGIC;
          Data_from_procesor : in STD_LOGIC_VECTOR(7 downto 0);
          Data_to_7seg : out STD_LOGIC_VECTOR(11 downto 0);
          Disable_anode : out STD_LOGIC
          );
    end component;
    
    component Procesor_Top_level is
    port(
          CLk : in STD_LOGIC;
          RST : in STD_LOGIC;
          Interupt_led : out STD_LOGIC;
          Interupt_sw : in STD_LOGIC;
          Write_str : out STD_LOGIC; -- this could be used for FIFO reading -- 
          Input_sw : in STD_LOGIC_VECTOR(7 downto 0);
          Read_str : out STD_LOGIC; -- this does into SSD driver -- 
          Konstant_I_O : out STD_LOGIC; -- for deciding what to use for port id -- 
          Regx_out : out STD_LOGIC_VECTOR(7 downto 0); -- goes for output / input --
          Operation_out : out STD_LOGIC_VECTOR(7 downto 0); -- mostly debug --
          Adress_debug : out STD_LOGIC_VECTOR(15 downto 0); -- mostly debug -- 
          PC_Out_Debug : out STD_LOGIC_VECTOR(7 downto 0)
          );
    end component;
    signal Write_stb_aux : STD_LOGIC;
    signal Read_stb_aux : STD_LOGIC;
    signal Led_interupt_aux : STD_LOGIC :='0';
    signal Final_switches_Inp : STD_LOGIC_VECTOR(7 downto 0) :=(others=>'0');
    signal Register_SX : STD_LOGIC_VECTOR(7 downto 0);
    signal ALU_adress_debug :  STD_LOGIC_VECTOR(7 downto 0);
    signal Adress_debug :  STD_LOGIC_VECTOR(15 downto 0);
    signal Konstant_I_O_from_dec: STD_LOGIC;
    signal Anode_disable_signal : STD_LOGIC := '0';
    
begin
    
    Input : Input_Component port map(
        Sx => Register_SX,
        KK => Adress_debug(7 downto 0),
        Decider => Konstant_I_O_from_dec,
        Switches => Input_switches,
        Switches_data_out => Final_switches_Inp  
    );
    
    Data_out<=Register_SX;
    
    Procesor : Procesor_Top_level port map(
            CLK => CLK,
            RST => RST, 
            Interupt_led => Led_interupt_aux,
            Interupt_sw => Interupt_switch,
            Input_sw => Final_switches_Inp,
            Write_str => Write_stb_aux,
            Read_str => Read_stb_aux,
            Konstant_I_O => Konstant_I_O_from_dec,
            Regx_out => Register_SX, 
            Operation_out => ALU_adress_debug,
            Adress_debug =>Adress_debug,
            PC_Out_Debug => PC_out
            );
        
    Interupt_led<=Led_interupt_aux;    
    Write_str_T <= Write_stb_aux;
    Read_str_T <= Read_stb_aux;
    Disable_anode <= Anode_disable_signal;
    
    Output : Output_Component port map(
        CLK => CLK_Fast,
        RST => RST,
        Interupt_led => Led_interupt_aux,
        Data_from_procesor => Register_SX,
        Data_to_7seg => Data_out_digits,
        Disable_anode => Anode_disable_signal,
        Write_strobe => Write_stb_aux
    );
    
    
end Behavioral;