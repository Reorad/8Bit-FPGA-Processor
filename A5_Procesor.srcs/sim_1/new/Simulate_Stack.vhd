----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/17/2026 01:08:50 AM
-- Design Name: 
-- Module Name: Simulate_Stack - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Simulate_Stack is
--  Port ( );
end Simulate_Stack;

    architecture Behavioral of Simulate_Stack is
    
    component Stack_function is
    port(
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        Is_return : in STD_LOGIC;
        Is_call : in STD_LOGIC;
        PC_in : in STD_LOGIC_VECTOR(7 downto 0); -- Adress of PC out -- 
        PC_out : out STD_LOGIC_VECTOR(7 downto 0)
        
    );
    end component;
    
    signal CLK, RST, Is_return, Is_call : STD_LOGIC;
    signal PC_in, PC_out : STD_LOGIC_VECTOR(7 downto 0);
    
begin
    
    UUT : Stack_function port map(
        CLK => CLK,
        RST => RST,
        Is_return => Is_return,
        Is_call => Is_call,
        PC_in => PC_in,
        PC_out => PC_out);
    
    process
        begin
           CLK<='1';
           wait for 5 ns;
           CLK <='0';
           wait for 5 ns;
    end process;
    
    process
        begin
            Is_return <='0';
            RST <='1';
            Is_call <='0';
            wait for 10ns;
            RST <= '0';
            PC_in <= "0000" &"1111";
            Is_call <='1';
            wait for 10ns;
            PC_in <= "0000" & "1000";
            wait for 10ns;
            Is_call <='1';
            PC_in <= x"F2";
            wait for 10ns;
            Is_call <= '0';
            Is_return <='1';
            wait for 20ns;
            Is_return <='0';
            wait for 10ns;
            wait ;
            
    end process;
        

end Behavioral;
