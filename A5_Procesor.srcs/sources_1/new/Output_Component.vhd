

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Output_Component is
    port( CLK : in STD_LOGIC;
          RST : in STD_LOGIC;
          Write_strobe : in STD_LOGIC;
          Read_strobe : in STD_LOGIC;
          Interupt_led : in STD_LOGIC;
          Data_from_procesor : in STD_LOGIC_VECTOR(7 downto 0);
          Data_to_7seg : out STD_LOGIC_VECTOR(11 downto 0);
          Disable_anode : out STD_LOGIC
          );
end Output_Component;

architecture Behavioral of Output_Component is
    
    component Controler_FSM_Data_print is
    port( CLK : in STD_LOGIC;
          RST : in STD_LOGIC;
          Read_strobe : in STD_LOGIC;
          Write_strobe : in STD_LOGIC;
          Interupt_strobe : in STD_LOGIC;
          Data_from_print : in STD_LOGIC_VECTOR(11 downto 0);
          Dont_print : out STD_LOGIC;
          Data_out : out STD_LOGIC_VECTOR(11 downto 0) 
         );
    end component;

    component BCD_conv is
    port( Data_in : in STD_LOGIC_VECTOR(7 downto 0);
          First_digit : out STD_LOGIC_VECTOR(3 downto 0);
          Second_digit : out STD_LOGIC_VECTOR(3 downto 0);
          Last_digit : out STD_LOGIC_VECTOR(3 downto 0)
          );
    end component;
    
    signal first_digit_a, second_digit_a, third_digit_a : STD_LOGIC_vECTOR(3 downto 0) := (others =>'0');
    signal Data_out_aux : STD_LOGIC_VECTOR(11 downto 0) :=(others =>'0');
    
begin
    
    Buffer_digits : Controler_FSM_Data_print port map(
        RST => RST,
        CLK => CLK,
        Write_strobe => Write_strobe,
        Read_strobe => Read_strobe,
        Interupt_strobe => Interupt_led,
        Data_from_print => Data_out_aux,
        Dont_print => Disable_anode,
        Data_out => Data_to_7seg    
    );
    
    Data_out_aux <= first_digit_a & second_digit_a & third_digit_a;
    
    Convertor_digits : BCD_conv port map(
        Data_in => Data_from_procesor,
        First_digit => first_digit_a,
        Second_digit => second_digit_a,
        Last_digit => third_digit_a
    );
    
end Behavioral;
