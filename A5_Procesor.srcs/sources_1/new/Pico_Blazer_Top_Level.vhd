
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Pico_Blazer_Top_Level is
    port(
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        Interupt_sw : in STD_LOGIC;
        Input_switches : in STD_LOGIC_VECTOR(15 downto 0);
        BTN_Step : in STD_LOGIC; -- The manual button for clocking the processor
        -- 7 bit Segment --
        Anodes : out STD_LOGIC_VECTOR(3 downto 0);
        Cathodes : out STD_LOGIC_VECTOR(7 downto 0);
        Interupt_led : out STD_LOGIC;
        PC_out : out STD_LOGIC_VECTOR(7 downto 0) -- Debug PC
    );
end Pico_Blazer_Top_Level;

architecture Behavioral of Pico_Blazer_Top_Level is
    
    component Procesor_Complete is
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
    end component;
    
    component SSD_Driver is
    port(  CLK : in STD_LOGIC;
           Data_from_procesor : in STD_LOGIC_VECTOR(11 downto 0);
           RST : in STD_LOGIC;
           Disable_anodes : in STD_LOGIC;
           Anodes : out STD_LOGIC_VECTOR(3 downto 0);
           Cathodes : out STD_LOGIC_VECTOR(7 downto 0)
           );
    end component;
    
    component MPG is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : out STD_LOGIC);
    end component;
    
    signal BTN_Output : STD_LOGIC;
    
    -- Internal signals from PC --
    signal Read_stb : STD_LOGIC;
    signal Write_stb : STD_LOGIC;
    signal Disable_anode_signal : STD_LOGIC; 
    signal Data_out_aux : STD_LOGIC_VECTOR(7 downto 0); -- pretty much only if I ever wanna debug prop not --
    signal Data_out_digits_7seg : STD_LOGIC_VECTOR(11 downto 0); -- this goes into SSD driver --
begin
    
    Processor_Advance_button : MPG port map(
        btn => BTN_Step,
        clk => CLK,
        en => BTN_Output );
    
    Pico_Blazeee : Procesor_Complete port map(
        CLK => BTN_Output,
        CLK_Fast => CLK,
        RST => RST,
        Input_switches => Input_switches,
        Interupt_switch => Interupt_sw, 
        Interupt_led => Interupt_led,
        Read_str_T => Read_stb,
        Write_str_T => Write_stb,
        Disable_anode => Disable_anode_signal,
        Data_out =>Data_out_aux,
        Data_out_digits => Data_out_digits_7seg,
        PC_out => PC_out
    );
    
    Segmed7print : SSD_Driver port map(
        CLK => CLK,
        Data_from_procesor => Data_out_digits_7seg,
        RST => RST,
        Disable_anodes =>  Disable_anode_signal,
        Anodes => Anodes,
        Cathodes => Cathodes
    );
        
        

end Behavioral;
