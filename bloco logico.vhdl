library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BlocoLogico is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           Sel : in  STD_LOGIC_VECTOR (1 downto 0);
           En : in  STD_LOGIC;
           Y : out  STD_LOGIC_VECTOR (7 downto 0));
end BlocoLogico;

architecture Behavioral of BlocoLogico is
begin
    process (A, B, Sel, En)
    begin
        if En = '1' then
            case Sel is
                when "00" =>
                    Y <= A and B;
                when "01" =>
                    Y <= A or B;
                when "10" =>
                    Y <= A xor B;
                when "11" =>
                    Y <= not A;
                when others =>
                    Y <= (others => '0');
            end case;
        else
            Y <= (others => '0');
        end if;
    end process;
end Behavioral;
