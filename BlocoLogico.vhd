library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--realiza operações lógicas entre dois vetores de 8 bits
entity BlocoLogico is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0); --entrada A
           B : in  STD_LOGIC_VECTOR (7 downto 0); --entrada B 
           Sel : in  STD_LOGIC_VECTOR (1 downto 0); --representa a operação 
           En : in  STD_LOGIC; --ativa/desativa o bloco Só executa se en = 1
           Y : out  STD_LOGIC_VECTOR (7 downto 0));
end BlocoLogico;

architecture Behavioral of BlocoLogico is
begin
    process (A, B, Sel, En)
    begin
        if En = '1' then
            case Sel is
                when "00" => --operação and
                    Y <= A and B;
                when "01" => --operação or
                    Y <= A or B;
                when "10" => --operação xor
                    Y <= A xor B;
                when "11" => --operação not
                    Y <= not A;
                when others =>
                    Y <= (others => '0');
            end case;
        else
            Y <= (others => '0');
        end if;
    end process;
end Behavioral;
