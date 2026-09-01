----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/08/2026 08:13:39 PM
-- Design Name: 
-- Module Name: Simulate_processor_complete - Behavioral
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

entity Simulate_processor_complete is
--  Port ( );
end Simulate_processor_complete;

architecture Behavioral of Simulate_processor_complete is
    
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
    
    signal CLK : STD_LOGIC;
    signal CLK_Fast : STD_LOGIC;
    signal RST : STD_LOGIC;
    signal Input_switches : STD_LOGIC_VECTOR(15 downto 0);
    signal Interupt_switch : STD_LOGIC;
    signal Interupt_Led : STD_LOGIC;
    signal Read_str_T : STD_LOGIC;
    signal Write_str_T : STD_LOGIC;
    signal Data_out : STD_LOGIC_VECTOR(7 downto 0);
    signal Data_out_digits : STD_LOGIC_VECTOR(11 downto 0);
    signal Disable_anode : STD_LOGIC;
    signal PC_out : STD_LOGIC_VECTOR(7 downto 0);

    
begin
    
    UUT : Procesor_Complete port map(
        CLK => CLK,
        CLK_fast => CLK_Fast,
        RST => RST,
        Input_switches => Input_switches,
        Interupt_switch => Interupt_switch,
        Interupt_Led => Interupt_Led,
        Read_str_T => Read_str_T,
        Write_str_T => Write_str_T,
        Disable_anode => Disable_anode,
        Data_out => Data_out,
        Data_out_digits => Data_out_digits,
        PC_out => PC_out
        );
        
        process
        begin
            Input_switches <= "0000" & "0000" & "0000" & "1010"; 
            RST<='1';
            wait for 15ns;
            RST<='0';
            wait for 20ns;
            Interupt_switch <='1';
            wait for 10 ns;
            Interupt_switch <='0';
            
            wait;
        end process;
        
        
        process
        begin
            CLK_fast <='1';
            CLK<='1';
            wait for 5ns;
            CLK_fast <='0';
            CLK<='0';
            wait for 5ns;
            
        end process;
        
        
end Behavioral;
