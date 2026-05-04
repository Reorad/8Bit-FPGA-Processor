library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU_8_BITS_tb is
-- Testbenches have no ports
end ALU_8_BITS_tb;

architecture sim of ALU_8_BITS_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    component ALU_8_BITS
        port( A : in STD_LOGIC_VECTOR(7 downto 0);
              B : in STD_LOGIC_VECTOR(7 downto 0);
              ALU_SEL : in STD_LOGIC_VECTOR(2 downto 0);
              O : out STD_LOGIC_VECTOR(7 downto 0);
              C_flag_future : out STD_LOGIC;
              Z_flag_future : out STD_LOGIC;
              WE : out STD_LOGIC;
              C_flag_past : in STD_LOGIC;
              Z_flag_past : in STD_LOGIC
            );
    end component;

    -- Inputs
    signal A_tb : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal B_tb : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal SEL_tb : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal C_past_tb : STD_LOGIC := '0';
    signal Z_past_tb : STD_LOGIC := '0';

    -- Outputs
    signal O_tb : STD_LOGIC_VECTOR(7 downto 0);
    signal C_fut_tb : STD_LOGIC;
    signal Z_fut_tb : STD_LOGIC;
    signal WE_tb : STD_LOGIC;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: ALU_8_BITS port map (
          A => A_tb,
          B => B_tb,
          ALU_SEL => SEL_tb,
          O => O_tb,
          C_flag_future => C_fut_tb,
          Z_flag_future => Z_fut_tb,
          WE => WE_tb,
          C_flag_past => C_past_tb,
          Z_flag_past => Z_past_tb
        );

    -- Stimulus process
    stim_proc: process
    begin		
        -- Test Case 1: LOAD B ("000")
        A_tb <= x"AA"; B_tb <= x"05"; SEL_tb <= "000";
        wait for 20 ns;
        
        -- Test Case 2: AND ("001")
        A_tb <= x"FF"; B_tb <= x"0F"; SEL_tb <= "010";
        wait for 20 ns;

        -- Test Case 3: ADD ("100")
        A_tb <= x"10"; B_tb <= x"20"; SEL_tb <= "100";
        wait for 20 ns;

        -- Test Case 4: SUB where A < B (Check C_flag)
        A_tb <= x"01"; B_tb <= x"05"; SEL_tb <= "111";
        wait for 20 ns;

        -- End simulation
        wait;
    end process;

end sim;