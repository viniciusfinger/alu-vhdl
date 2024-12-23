library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- realiza soma e subtração entre dois vetores de 8 bits
entity BlocoAritmetico is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0); --entrada A
           B : in  STD_LOGIC_VECTOR (7 downto 0); --entrada B
           Sel : in  STD_LOGIC; --representa a operação a ser realizada. 0 = soma, 1 = subtração
           En : in  STD_LOGIC; --ativa/desativa o bloco. Só executa se en = 1
           Y : out  STD_LOGIC_VECTOR (7 downto 0);
           Overflow : out  STD_LOGIC);
end BlocoAritmetico;

architecture Behavioral of BlocoAritmetico is
    signal B_comp : STD_LOGIC_VECTOR (7 downto 0);
    signal temp_sum : STD_LOGIC_VECTOR (8 downto 0);
begin
    process (A, B, Sel, En)
    begin
        if En = '1' then
            if Sel = '0' then --realiza soma
                temp_sum <= ('0' & A) + ('0' & B);
                Y <= temp_sum(7 downto 0);
                Overflow <= temp_sum(8);
            else --realiza subtração
                B_comp <= not B + "00000001";
                temp_sum <= ('0' & A) + ('0' & B_comp);
                Y <= temp_sum(7 downto 0);
                Overflow <= temp_sum(8);
            end if;
        else
            Y <= (others => '0');
            Overflow <= '0';
        end if;
    end process;
end Behavioral;
