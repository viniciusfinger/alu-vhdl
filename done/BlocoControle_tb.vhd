library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BlocoControle_tb is
end BlocoControle_tb;

architecture Behavioral of BlocoControle_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    component BlocoControle
        Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
               B : in  STD_LOGIC_VECTOR (7 downto 0);
               Opcode : in  STD_LOGIC_VECTOR (2 downto 0);
               Clock : in  STD_LOGIC;
               Resetar_Carregar : in  STD_LOGIC;
               Y : out  STD_LOGIC_VECTOR (7 downto 0);
               Done : out  STD_LOGIC;
               Overflow : out  STD_LOGIC);
    end component;

    -- Signals for testbench
    signal A : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal B : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal Opcode : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
    signal Clock : STD_LOGIC := '0';
    signal Resetar_Carregar : STD_LOGIC := '0';
    signal Y : STD_LOGIC_VECTOR (7 downto 0);
    signal Done : STD_LOGIC;
    signal Overflow : STD_LOGIC;

    -- Clock period definition
    constant Clock_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: BlocoControle
        Port map (
            A => A,
            B => B,
            Opcode => Opcode,
            Clock => Clock,
            Resetar_Carregar => Resetar_Carregar,
            Y => Y,
            Done => Done,
            Overflow => Overflow
        );

    -- Clock process definitions
    Clock_process : process
    begin
        Clock <= '0';
        wait for Clock_period / 2;
        Clock <= '1';
        wait for Clock_period / 2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize Inputs
        A <= "00000000";
        B <= "00000000";
        Opcode <= "000";
        Resetar_Carregar <= '0';
        wait for 100 ns;

        -- Test 1: AND Operation
        A <= "10101010";
        B <= "11001100";
        Opcode <= "000";
        Resetar_Carregar <= '1';
        wait for Clock_period;
        Resetar_Carregar <= '0';
        wait for 50 ns;

        -- Test 2: OR Operation
        A <= "10101010";
        B <= "11001100";
        Opcode <= "001";
        Resetar_Carregar <= '1';
        wait for Clock_period;
        Resetar_Carregar <= '0';
        wait for 50 ns;

        -- Test 3: XOR Operation
        A <= "10101010";
        B <= "11001100";
        Opcode <= "010";
        Resetar_Carregar <= '1';
        wait for Clock_period;
        Resetar_Carregar <= '0';
        wait for 50 ns;

        -- Test 4: NOT A Operation
        A <= "10101010";
        Opcode <= "011";
        Resetar_Carregar <= '1';
        wait for Clock_period;
        Resetar_Carregar <= '0';
        wait for 50 ns;

        -- Test 5: ADD Operation
        A <= "00001111";
        B <= "00000001";
        Opcode <= "100";
        Resetar_Carregar <= '1';
        wait for Clock_period;
        Resetar_Carregar <= '0';
        wait for 50 ns;

        -- Test 6: SUB Operation
        A <= "00001111";
        B <= "00000001";
        Opcode <= "101";
        Resetar_Carregar <= '1';
        wait for Clock_period;
        Resetar_Carregar <= '0';
        wait for 50 ns;

        -- Test 7: Shift Right Operation
        A <= "10101010";
        B <= "00000010";
        Opcode <= "110";
        Resetar_Carregar <= '1';
        wait for Clock_period;
        Resetar_Carregar <= '0';
        wait for 50 ns;

        -- End simulation
        wait;
    end process;

end Behavioral;
