library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity BlocoControle is
    Port  (A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           Opcode : in  STD_LOGIC_VECTOR (2 downto 0);
           Clock : in  STD_LOGIC;
           Resetar_Carregar : in  STD_LOGIC;
           Y : out  STD_LOGIC_VECTOR (7 downto 0);
           Done : out  STD_LOGIC;
           Overflow : out  STD_LOGIC);
end BlocoControle;

-- define a arquitetura do bloco de controle
architecture Behavioral of BlocoControle is
    signal A_reg, B_reg : STD_LOGIC_VECTOR (7 downto 0); -- representam o input A e o input B
    signal Y_logico, Y_aritmetico, Y_sequencial : STD_LOGIC_VECTOR (7 downto 0); --representam o resultado de cada bloco
    signal Overflow_aritmetico, Overflow_sequencial : STD_LOGIC; -- representam o overflow dos blocos aritmetico e sequencial
    signal Done_reg : STD_LOGIC; --registra o status da operação. 1 para realizado, 0 para não realizado.
    signal EnL, EnA, EnS : STD_LOGIC; --seletores para habilitar (1) ou desabilitar (0) um bloco (Lógico, Aritmetico, Sequencial)
    signal SelL : STD_LOGIC_VECTOR (1 downto 0); --seltor de operação dentro do bloco lógico
    signal SelA : STD_LOGIC; --seletor de operação dentro do bloco aritmético

    -- declara o compoente bloco lógico
    component BlocoLogico
        Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
               B : in  STD_LOGIC_VECTOR (7 downto 0);
               Sel : in  STD_LOGIC_VECTOR (1 downto 0);
               En : in  STD_LOGIC;
               Y : out  STD_LOGIC_VECTOR (7 downto 0));
    end component;

	 -- declara o componente bloco aritmetico
    component BlocoAritmetico
        Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
               B : in  STD_LOGIC_VECTOR (7 downto 0);
               Sel : in  STD_LOGIC;
               En : in  STD_LOGIC;
               Y : out  STD_LOGIC_VECTOR (7 downto 0);
               Overflow : out  STD_LOGIC);
    end component;

	 -- declara o componente bloco sequencial
    component BlocoSequencial
        Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
               B : in  STD_LOGIC_VECTOR (7 downto 0);
               En : in  STD_LOGIC;
               Clock : in  STD_LOGIC;
               Y : out  STD_LOGIC_VECTOR (7 downto 0);
               Overflow : out  STD_LOGIC);
    end component;

-- lógica de controle da ULA com base no OPCode, faz um switch case e seta valores para os sinais de controle
begin
    process (Clock, Resetar_Carregar)
    begin
        if rising_edge(Clock) then
            if Resetar_Carregar = '1' then
                A_reg <= A;
                B_reg <= B;
                Done_reg <= '0';
            else
                case Opcode is
                    when "000" => --And
                        EnL <= '1';
                        SelL <= "00";
                        EnA <= '0';
                        EnS <= '0';
                    when "001" => --Or
                        EnL <= '1';
                        SelL <= "01";
                        EnA <= '0';
                        EnS <= '0';
                    when "010" => --Xor
                        EnL <= '1';
                        SelL <= "10";
                        EnA <= '0';
                        EnS <= '0';
                    when "011" => --Nega A
                        EnL <= '1';
                        SelL <= "11";
                        EnA <= '0';
                        EnS <= '0';
                    when "100" => --Soma
                        EnL <= '0';
                        EnA <= '1';
                        SelA <= '0';
                        EnS <= '0';
                    when "101" => --Subtração
                        EnL <= '0';
                        EnA <= '1';
                        SelA <= '1';
                        EnS <= '0';
                    when "110" => --Shift a direita
                        EnL <= '0';
                        EnA <= '0';
                        EnS <= '1';
                    when others =>
                        EnL <= '0';
                        EnA <= '0';
                        EnS <= '0';
                end case;

                if Done_reg = '0' then
                    Done_reg <= '1';
                end if;
            end if;
        end if;
    end process;

    -- Instancia bloco logico
    BlocoLogico_inst: BlocoLogico
        port map (A => A_reg, B => B_reg, Sel => SelL, En => EnL, Y => Y_logico);

	 -- Instancia bloco aritmetico
    BlocoAritmetico_inst: BlocoAritmetico
        port map (A => A_reg, B => B_reg, Sel => SelA, En => EnA, Y => Y_aritmetico, Overflow => Overflow_aritmetico);

	 -- Instancia bloco sequencial
    BlocoSequencial_inst: BlocoSequencial
        port map (A => A_reg, B => B_reg, En => EnS, Clock => Clock, Y => Y_sequencial, Overflow => Overflow_sequencial);

    -- Multiplexador para selecionar a saída correta de acordo com o Opcode
    with Opcode select
        Y <= Y_logico when "000",
             Y_logico when "001",
             Y_logico when "010",
             Y_logico when "011",
             Y_aritmetico when "100",
             Y_aritmetico when "101",
             Y_sequencial when "110",
             (others => '0') when others;
				 
    Overflow <= Overflow_aritmetico or Overflow_sequencial;
    
	 Done <= Done_reg; --seta que a operação foi concluída
end Behavioral;
