library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BlocoSequencial is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           En : in  STD_LOGIC;
           Clock : in  STD_LOGIC;
           Y : out  STD_LOGIC_VECTOR (7 downto 0);
           Overflow : out  STD_LOGIC);
end BlocoSequencial;

architecture Behavioral of BlocoSequencial is
    signal temp : STD_LOGIC_VECTOR (7 downto 0);
    signal shift_count : INTEGER := 0;
begin
    process (Clock, En)
    begin
        if rising_edge(Clock) then
            if En = '1' then
                shift_count <= CONV_INTEGER(B);
                if shift_count > 7 then
                    Overflow <= '1';
                else
                    temp <= A;
                    for i in 0 to shift_count - 1 loop
                        temp <= '0' & temp(7 downto 1);
                    end loop;
                    Y <= temp;
                    Overflow <= '0';
                end if;
            else
                Y <= (others => '0');
                Overflow <= '0';
            end if;
        end if;
    end process;
end Behavioral;
