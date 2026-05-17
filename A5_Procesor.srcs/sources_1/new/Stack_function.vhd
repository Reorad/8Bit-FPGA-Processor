
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Stack_function is
    port(
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        Is_return : in STD_LOGIC;
        Is_call : in STD_LOGIC;
        PC_in : in STD_LOGIC_VECTOR(7 downto 0); -- Adress of PC out -- 
        PC_out : out STD_LOGIC_VECTOR(7 downto 0);
        Ret_sig : out STD_LOGIC
        
    );
end Stack_function;

architecture Behavioral of Stack_function is
    signal SP : natural := 15;
    type Stack_mem is array (15 downto 0) of STD_LOGIC_VECTOR (7 downto 0);
    signal Function_call : Stack_mem := (others => (others =>'0'));
begin
  
    process(Is_return,SP,Function_call)
        begin
            if(SP<15 and Is_return ='1') then
                PC_out <= Function_call(SP + 1);
            else
                PC_out <= Function_call(SP);
            end if;
    end process;
    
    Ret_sig <= Is_return;
    
    -- if its a call next clk cycle in Stack the should save on current SP and increase SP -- 
    process(CLK,RST)
        begin   
            if(RST ='1') then
                SP <= 15;
            elsif ( rising_edge(clk)) then
                if(Is_call ='1') then
                    if(SP > 0 ) then
                        SP <= SP - 1;
                    end if;
                    Function_call(SP) <= (PC_in + 1);
                elsif (Is_return = '1') then 
                    if(SP < 15 ) then   
                        SP <= SP + 1;
                    end if;
                    
                end if;
            end if;
    end process;

end Behavioral;
