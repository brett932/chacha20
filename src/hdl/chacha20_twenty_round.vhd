library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity chacha20_twenty_round is
Port(
    clk : in std_logic;
    rst : in std_logic;
    hold : in std_logic;
    state_in : in unsigned(32*16 -1 downto 0);
    state_out: out unsigned(32*16 -1 downto 0)
);
end chacha20_twenty_round ;

architecture Behavioral of chacha20_twenty_round  is
    component chacha20_two_round is
    Port(
        clk : in std_logic;
        rst : in std_logic;
        hold : in std_logic;
        ctx_in_0 : in unsigned(31 downto 0);
        ctx_in_1 : in unsigned(31 downto 0);
        ctx_in_2 : in unsigned(31 downto 0);
        ctx_in_3 : in unsigned(31 downto 0);
        ctx_in_4 : in unsigned(31 downto 0);
        ctx_in_5 : in unsigned(31 downto 0);
        ctx_in_6 : in unsigned(31 downto 0);
        ctx_in_7 : in unsigned(31 downto 0);
        ctx_in_8 : in unsigned(31 downto 0);
        ctx_in_9 : in unsigned(31 downto 0);
        ctx_in_10 : in unsigned(31 downto 0);
        ctx_in_11 : in unsigned(31 downto 0);
        ctx_in_12 : in unsigned(31 downto 0);
        ctx_in_13 : in unsigned(31 downto 0);
        ctx_in_14 : in unsigned(31 downto 0);
        ctx_in_15 : in unsigned(31 downto 0);
        ctx_out_0 : out unsigned(31 downto 0);
        ctx_out_1 : out unsigned(31 downto 0);
        ctx_out_2 : out unsigned(31 downto 0);
        ctx_out_3 : out unsigned(31 downto 0);
        ctx_out_4 : out unsigned(31 downto 0);
        ctx_out_5 : out unsigned(31 downto 0);
        ctx_out_6 : out unsigned(31 downto 0);
        ctx_out_7 : out unsigned(31 downto 0);
        ctx_out_8 : out unsigned(31 downto 0);
        ctx_out_9 : out unsigned(31 downto 0);
        ctx_out_10 : out unsigned(31 downto 0);
        ctx_out_11 : out unsigned(31 downto 0);
        ctx_out_12 : out unsigned(31 downto 0);
        ctx_out_13 : out unsigned(31 downto 0);
        ctx_out_14 : out unsigned(31 downto 0);
        ctx_out_15 : out unsigned(31 downto 0)  
    );
    end component chacha20_two_round;
    signal counter: integer range 0 to 9;
    type t_ctx is array(9 downto 0, 15 downto 0) of unsigned(31 downto 0);
    signal ctx : t_ctx;
begin
    GEN_chacha_two_round:
    for i in 0 to 9 generate
        FIRST_ROUND: if i=0 generate
            U0 : chacha20_two_round
            port map(
                clk => clk,
                rst => rst,
                hold => hold,
                ctx_in_0 => state_in(32*(0+1)-1 downto 32*0),
                ctx_in_1 => state_in(32*(1+1)-1 downto 32*1),
                ctx_in_2 => state_in(32*(2+1)-1 downto 32*2),
                ctx_in_3 => state_in(32*(3+1)-1 downto 32*3),
                ctx_in_4 => state_in(32*(4+1)-1 downto 32*4),
                ctx_in_5 => state_in(32*(5+1)-1 downto 32*5),
                ctx_in_6 => state_in(32*(6+1)-1 downto 32*6),
                ctx_in_7 => state_in(32*(7+1)-1 downto 32*7),
                ctx_in_8 => state_in(32*(8+1)-1 downto 32*8),
                ctx_in_9 => state_in(32*(9+1)-1 downto 32*9),
                ctx_in_10 => state_in(32*(10+1)-1 downto 32*10),
                ctx_in_11 => state_in(32*(11+1)-1 downto 32*11),
                ctx_in_12 => state_in(32*(12+1)-1 downto 32*12),
                ctx_in_13 => state_in(32*(13+1)-1 downto 32*13),
                ctx_in_14 => state_in(32*(14+1)-1 downto 32*14),
                ctx_in_15 => state_in(32*(15+1)-1 downto 32*15),
                ctx_out_0 => ctx(i, 0),
                ctx_out_1 => ctx(i, 1),
                ctx_out_2 => ctx(i, 2),
                ctx_out_3 => ctx(i, 3),
                ctx_out_4 => ctx(i, 4),
                ctx_out_5 => ctx(i, 5),
                ctx_out_6 => ctx(i, 6),
                ctx_out_7 => ctx(i, 7),
                ctx_out_8 => ctx(i, 8),
                ctx_out_9 => ctx(i, 9),
                ctx_out_10 => ctx(i, 10),
                ctx_out_11 => ctx(i, 11),
                ctx_out_12 => ctx(i, 12),
                ctx_out_13 => ctx(i, 13),
                ctx_out_14 => ctx(i, 14),
                ctx_out_15 => ctx(i, 15)
                
            );
        end generate FIRST_ROUND;
        
        MIDDLE_ROUNDS: if i>0 and i<9 generate
            Ux : chacha20_two_round
            port map(
                clk => clk,
                rst => rst,
                hold => hold,
                ctx_in_0 => ctx(i-1, 0),
                ctx_in_1 => ctx(i-1, 1),
                ctx_in_2 => ctx(i-1, 2),
                ctx_in_3 => ctx(i-1, 3),
                ctx_in_4 => ctx(i-1, 4),
                ctx_in_5 => ctx(i-1, 5),
                ctx_in_6 => ctx(i-1, 6),
                ctx_in_7 => ctx(i-1, 7),
                ctx_in_8 => ctx(i-1, 8),
                ctx_in_9 => ctx(i-1, 9),
                ctx_in_10 => ctx(i-1, 10),
                ctx_in_11 => ctx(i-1, 11),
                ctx_in_12 => ctx(i-1, 12),
                ctx_in_13 => ctx(i-1, 13),
                ctx_in_14 => ctx(i-1, 14),
                ctx_in_15 => ctx(i-1, 15),
                ctx_out_0 => ctx(i, 0),
                ctx_out_1 => ctx(i, 1),
                ctx_out_2 => ctx(i, 2),
                ctx_out_3 => ctx(i, 3),
                ctx_out_4 => ctx(i, 4),
                ctx_out_5 => ctx(i, 5),
                ctx_out_6 => ctx(i, 6),
                ctx_out_7 => ctx(i, 7),
                ctx_out_8 => ctx(i, 8),
                ctx_out_9 => ctx(i, 9),
                ctx_out_10 => ctx(i, 10),
                ctx_out_11 => ctx(i, 11),
                ctx_out_12 => ctx(i, 12),
                ctx_out_13 => ctx(i, 13),
                ctx_out_14 => ctx(i, 14),
                ctx_out_15 => ctx(i, 15)
            );
        end generate MIDDLE_ROUNDS;
        
        FINAL_ROUND: if i = 9 generate
            U9 : chacha20_two_round
            port map(
                clk => clk,
                rst => rst,
                hold => hold,
                ctx_in_0 => ctx(i-1, 0),
                ctx_in_1 => ctx(i-1, 1),
                ctx_in_2 => ctx(i-1, 2),
                ctx_in_3 => ctx(i-1, 3),
                ctx_in_4 => ctx(i-1, 4),
                ctx_in_5 => ctx(i-1, 5),
                ctx_in_6 => ctx(i-1, 6),
                ctx_in_7 => ctx(i-1, 7),
                ctx_in_8 => ctx(i-1, 8),
                ctx_in_9 => ctx(i-1, 9),
                ctx_in_10 => ctx(i-1, 10),
                ctx_in_11 => ctx(i-1, 11),
                ctx_in_12 => ctx(i-1, 12),
                ctx_in_13 => ctx(i-1, 13),
                ctx_in_14 => ctx(i-1, 14),
                ctx_in_15 => ctx(i-1, 15),
                ctx_out_0 => state_out(32*(0+1)-1 downto 32*0),
                ctx_out_1 => state_out(32*(1+1)-1 downto 32*1),
                ctx_out_2 => state_out(32*(2+1)-1 downto 32*2),
                ctx_out_3 => state_out(32*(3+1)-1 downto 32*3),
                ctx_out_4 => state_out(32*(4+1)-1 downto 32*4),
                ctx_out_5 => state_out(32*(5+1)-1 downto 32*5),
                ctx_out_6 => state_out(32*(6+1)-1 downto 32*6),
                ctx_out_7 => state_out(32*(7+1)-1 downto 32*7),
                ctx_out_8 => state_out(32*(8+1)-1 downto 32*8),
                ctx_out_9 => state_out(32*(9+1)-1 downto 32*9),
                ctx_out_10 => state_out(32*(10+1)-1 downto 32*10),
                ctx_out_11 => state_out(32*(11+1)-1 downto 32*11),
                ctx_out_12 => state_out(32*(12+1)-1 downto 32*12),
                ctx_out_13 => state_out(32*(13+1)-1 downto 32*13),
                ctx_out_14 => state_out(32*(14+1)-1 downto 32*14),
                ctx_out_15 => state_out(32*(15+1)-1 downto 32*15)
            );
        end generate FINAL_ROUND;
    end generate GEN_chacha_two_round;
end Behavioral;

