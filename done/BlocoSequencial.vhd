library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- realiza operações de deslocamento de bits
entity BlocoSequencial is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0); --entrada A
           B : in  STD_LOGIC_VECTOR (7 downto 0); --entrada B
           En : in  STD_LOGIC; --ativa/desativa o bloco. Só executa se en = 1
           Clock : in  STD_LOGIC; --entrada do clock para sincronizar o processo
           Y : out  STD_LOGIC_VECTOR (7 downto 0);
           Overflow : out  STD_LOGIC);
end BlocoSequencial;

architecture Behavioral of BlocoSequencial is
    signal shift_count : integer range 0 to 8; --se shift > 8, então houve overflow
    signal temp_result : STD_LOGIC_VECTOR (7 downto 0); --usado para realizar o deslocamento
    signal overflow_signal : STD_LOGIC;
begin
    process (Clock)
    begin
        if rising_edge(Clock) then
            if En = '1' then
                --converte B para um valor inteiro para determinar a contagem de deslocamento
                shift_count <= to_integer(unsigned(B));

                temp_result <= A;

                if shift_count > 8 then
                    overflow_signal <= '1';
                else
                    overflow_signal <= '0';
                end if;

                -- Executa o deslocamento
                for i in 0 to 7 loop
                    if i < shift_count then
                        temp_result <= '0' & temp_result(7 downto 1);
                    end if;
                end loop;

                Y <= temp_result;
                Overflow <= overflow_signal;
            end if;
        end if;
    end process;
end Behavioral;
