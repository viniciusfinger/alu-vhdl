library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BlocoAritmetico is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           Sel : in  STD_LOGIC;
           En : in  STD_LOGIC;
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
            if Sel = '0' then -- Soma
                temp_sum <= ('0' & A) + ('0' & B);
                Y <= temp_sum(7 downto 0);
                Overflow <= temp_sum(8);
            else -- Subtração
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
