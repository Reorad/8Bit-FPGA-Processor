
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Input_Component is
    port(Sx : in STD_LOGIC_VECTOR(7 downto 0); -- Register shit --
         KK : in STD_LOGIC_VECTOR(7 downto 0);
         Decider : in STD_LOGIC; 
         Switches : in STD_LOGIC_VECTOR(15 downto 0); -- Switches user puts from board --
         Switches_data_out : out STD_LOGIC_VECTOR(7 downto 0) -- Data comming out --
         );
end Input_Component;


architecture Behavioral of Input_Component is
    signal NUMB_CONV : integer := 0;
    signal Input_port : STD_LOGIC_VECTOR(7 downto 0) :=(others=>'0'); 
begin
    
    -- For deciding about the value of input port --
    process(Sx, KK, Decider) 
        begin
           if(Decider ='1') then
              Input_port <= Sx;
           else
              Input_port <= KK;  
           end if; 
    end process;

    NUMB_CONV <= to_integer(unsigned(Input_port));
    
    process(Input_port,Switches)
        begin
            if(NUMB_CONV <= 127 ) then
                Switches_data_out <= Switches(7 downto 0);
            else
                Switches_data_out <= Switches(15 downto 8);
            end if;
    end process;
end Behavioral;
