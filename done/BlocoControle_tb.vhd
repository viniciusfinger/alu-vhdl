library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BlocoControle_tb is
end BlocoControle_tb;

architecture Behavioral of BlocoControle_tb is

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

    signal A : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal B : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal Opcode : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
    signal Clock : STD_LOGIC := '0';
    signal Resetar_Carregar : STD_LOGIC := '0';
    signal Y : STD_LOGIC_VECTOR (7 downto 0);
    signal Done : STD_LOGIC;
    signal Overflow : STD_LOGIC;

    constant Clock_period : time := 10 ns;

begin

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

    Clock_process : process
    begin
        Clock <= '0';
        wait for Clock_period / 2;
        Clock <= '1';
        wait for Clock_period / 2;
    end process;

    stim_proc: process
    begin
        --inicializa os valores
        A <= "00000000";
        B <= "00000000";
        Opcode <= "000";
        Resetar_Carregar <= '0';
        wait for 100 ns;

        --teste 1: And
        A <= "10101010";
        B <= "11001100";
        Opcode <= "000";
        Resetar_Carregar <= '1';
        wait for Clock_period;
        Resetar_Carregar <= '0';
        wait for 50 ns;

        --teste 2: Or
        A <= "10101010";
        B <= "11001100";
        Opcode <= "001";
        Resetar_Carregar <= '1';
        wait for Clock_period;
        Resetar_Carregar <= '0';
        wait for 50 ns;

        --teste 3: Xor
        A <= "10101010";
        B <= "11001100";
        Opcode <= "010";
        Resetar_Carregar <= '1';
        wait for Clock_period;
        Resetar_Carregar <= '0';
        wait for 50 ns;

        --teste 4: Not A
        A <= "10101010";
        Opcode <= "011";
        Resetar_Carregar <= '1';
        wait for Clock_period;
        Resetar_Carregar <= '0';
        wait for 50 ns;

        --teste 5: Adição
        A <= "00001111";
        B <= "00000001";
        Opcode <= "100";
        Resetar_Carregar <= '1';
        wait for Clock_period;
        Resetar_Carregar <= '0';
        wait for 50 ns;

        --teste 6: Subtração
        A <= "00001111";
        B <= "00000001";
        Opcode <= "101";
        Resetar_Carregar <= '1';
        wait for Clock_period;
        Resetar_Carregar <= '0';
        wait for 50 ns;

        --teste 7: Shift a direita
        A <= "10101010";
        B <= "00000010";
        Opcode <= "110";
        Resetar_Carregar <= '1';
        wait for Clock_period;
        Resetar_Carregar <= '0';
        wait for 50 ns;

        wait;
    end process;

end Behavioral;
