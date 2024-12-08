library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BlocoControle is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           Opcode : in  STD_LOGIC_VECTOR (2 downto 0);
           Clock : in  STD_LOGIC;
           Resetar_Carregar : in  STD_LOGIC;
           Y : out  STD_LOGIC_VECTOR (7 downto 0);
           Done : out  STD_LOGIC;
           Overflow : out  STD_LOGIC);
end BlocoControle;

architecture Behavioral of BlocoControle is
    signal A_reg, B_reg : STD_LOGIC_VECTOR (7 downto 0);
    signal Y_reg : STD_LOGIC_VECTOR (7 downto 0);
    signal Overflow_reg : STD_LOGIC;
    signal Done_reg : STD_LOGIC;
    signal EnL, EnA, EnS : STD_LOGIC;
    signal SelL : STD_LOGIC_VECTOR (1 downto 0);
    signal SelA : STD_LOGIC;
begin
    process (Clock, Resetar_Carregar)
    begin
        if rising_edge(Clock) then
            if Resetar_Carregar = '1' then
                A_reg <= A;
                B_reg <= B;
                Y_reg <= (others => '0');
                Overflow_reg <= '0';
                Done_reg <= '0';
            else
                case Opcode is
                    when "000" => -- AND
                        EnL <= '1';
                        SelL <= "00";
                        EnA <= '0';
                        EnS <= '0';
                    when "001" => -- OR
                        EnL <= '1';
                        SelL <= "01";
                        EnA <= '0';
                        EnS <= '0';
                    when "010" => -- XOR
                        EnL <= '1';
                        SelL <= "10";
                        EnA <= '0';
                        EnS <= '0';
                    when "011" => -- NOT A
                        EnL <= '1';
                        SelL <= "11";
                        EnA <= '0';
                        EnS <= '0';
                    when "100" => -- SOMA
                        EnL <= '0';
                        EnA <= '1';
                        SelA <= '0';
                        EnS <= '0';
                    when "101" => -- SUBTRAÇÃO
                        EnL <= '0';
                        EnA <= '1';
                        SelA <= '1';
                        EnS <= '0';
                    when "110" => -- DESLOCAMENTO À DIREITA
                        EnL <= '0';
                        EnA <= '0';
                        EnS <= '1';
                    when others =>
                        EnL <= '0';
                        EnA <= '0';
                        EnS <= '0';
                end case;
                
                if Done_reg = '0' then
                    if EnL = '1' then
                        BlocoLogico_inst: entity work.BlocoLogico
                        port map (A => A_reg, B => B_reg, Sel => SelL, En => EnL, Y => Y_reg);
                        Done_reg <= '1';
                    elsif EnA = '1' then
                        BlocoAritmetico_inst: entity work.BlocoAritmetico
                        port map (A => A_reg, B => B_reg, Sel => SelA, En => EnA, Y => Y_reg, Overflow => Overflow_reg);
                        Done_reg <= '1';
                    elsif EnS = '1' then
                        BlocoSequencial_inst: entity work.BlocoSequencial
                        port map (A => A_reg, B => B_reg, En => EnS, Clock => Clock, Y => Y_reg, Overflow => Overflow_reg);
                        Done_reg <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    Y <= Y_reg;
    Done <= Done_reg;
    Overflow <= Overflow_reg;
end Behavioral;
