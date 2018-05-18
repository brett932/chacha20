
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity chacha20_quarter_round is
port (
    clk : in std_logic;
    rst : in std_logic;
    hold : in std_logic;
    a_in, b_in, c_in, d_in : in unsigned(31 downto 0);
    a_out, b_out, c_out, d_out : out unsigned(31 downto 0)
);
end chacha20_quarter_round;

architecture Behavioral of chacha20_quarter_round is
    signal a, b, c, d: unsigned(31 downto 0);
    signal i: integer;
begin

process(clk)
begin
    if(clk'event and clk = '1') then
        if(rst = '1') then
            i <= 0;
            a <= (others => '0');
        elsif(hold = '0') then
            if(i = 3) then
                i <= 0;
            else
                i <= i + 1;
            end if;
            
            case i is 
                when 0 =>
                    a <= a_in + b_in;
                    d <= (d_in xor (a_in + b_in)) rol 16;
                when 1 =>
                    c <= c_in + d;
                    b <= (b_in xor (c_in + d)) rol 12;
                when 2 =>
                    a <= a + b;
                    d <= (d xor (a + b)) rol 8;
                when 3 =>
                    a_out <= a;
                    c_out <= c + d;
                    b_out <= (b xor (c + d)) rol 7;
                    d_out <= d;
                when others=>
            end case;
        end if;
    end if;
end process;

end Behavioral;
