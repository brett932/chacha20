library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity chacha20_pipeline is
    port (
        clk : in std_logic;
        reset: in std_logic;
        hold : in std_logic;
        input : in std_logic_vector(32*16-1 downto 0);
        output : out std_logic_vector(32*16-1 downto 0)
    );
end chacha20_pipeline;

architecture Behavioral of chacha20_pipeline is
    component chacha20_twenty_round is
    Port(
        clk : in std_logic;
        rst : in std_logic;
        hold : in std_logic;
        state_in : in unsigned(32*16 -1 downto 0);
        state_out: out unsigned(32*16 -1 downto 0)
    );
    end component chacha20_twenty_round;
    
    type t_ctx_shift is array(19 downto 0) of std_logic_vector(32*16-1 downto 0);
    signal ctx_shift : t_ctx_shift;
    signal counter : std_logic_vector(1 downto 0);
    
    signal state_in : unsigned(32*16 -1 downto 0);
    signal state_out: unsigned(32*16 -1 downto 0);
begin
    CORE:
    chacha20_twenty_round
    port map(
        clk => clk,
        rst => reset,
        hold => hold,
        state_in => state_in,
        state_out => state_out
    );
    state_in <= unsigned(input);
    --output(32*($1+1)-1 downto 32*$1) <= std_logic_vector(unsigned(ctx_shift(19)(32*($1+1)-1 downto 32*$1)) + state_out(32*($1+1)-1 downto 32*$1));
    output(32*(0+1)-1 downto 32*0) <= std_logic_vector(unsigned(ctx_shift(19)(32*(0+1)-1 downto 32*0)) + state_out(32*(0+1)-1 downto 32*0));
    output(32*(1+1)-1 downto 32*1) <= std_logic_vector(unsigned(ctx_shift(19)(32*(1+1)-1 downto 32*1)) + state_out(32*(1+1)-1 downto 32*1));
    output(32*(2+1)-1 downto 32*2) <= std_logic_vector(unsigned(ctx_shift(19)(32*(2+1)-1 downto 32*2)) + state_out(32*(2+1)-1 downto 32*2));
    output(32*(3+1)-1 downto 32*3) <= std_logic_vector(unsigned(ctx_shift(19)(32*(3+1)-1 downto 32*3)) + state_out(32*(3+1)-1 downto 32*3));
    output(32*(4+1)-1 downto 32*4) <= std_logic_vector(unsigned(ctx_shift(19)(32*(4+1)-1 downto 32*4)) + state_out(32*(4+1)-1 downto 32*4));
    output(32*(5+1)-1 downto 32*5) <= std_logic_vector(unsigned(ctx_shift(19)(32*(5+1)-1 downto 32*5)) + state_out(32*(5+1)-1 downto 32*5));
    output(32*(6+1)-1 downto 32*6) <= std_logic_vector(unsigned(ctx_shift(19)(32*(6+1)-1 downto 32*6)) + state_out(32*(6+1)-1 downto 32*6));
    output(32*(7+1)-1 downto 32*7) <= std_logic_vector(unsigned(ctx_shift(19)(32*(7+1)-1 downto 32*7)) + state_out(32*(7+1)-1 downto 32*7));
    output(32*(8+1)-1 downto 32*8) <= std_logic_vector(unsigned(ctx_shift(19)(32*(8+1)-1 downto 32*8)) + state_out(32*(8+1)-1 downto 32*8));
    output(32*(9+1)-1 downto 32*9) <= std_logic_vector(unsigned(ctx_shift(19)(32*(9+1)-1 downto 32*9)) + state_out(32*(9+1)-1 downto 32*9));
    output(32*(10+1)-1 downto 32*10) <= std_logic_vector(unsigned(ctx_shift(19)(32*(10+1)-1 downto 32*10)) + state_out(32*(10+1)-1 downto 32*10));
    output(32*(11+1)-1 downto 32*11) <= std_logic_vector(unsigned(ctx_shift(19)(32*(11+1)-1 downto 32*11)) + state_out(32*(11+1)-1 downto 32*11));
    output(32*(12+1)-1 downto 32*12) <= std_logic_vector(unsigned(ctx_shift(19)(32*(12+1)-1 downto 32*12)) + state_out(32*(12+1)-1 downto 32*12));
    output(32*(13+1)-1 downto 32*13) <= std_logic_vector(unsigned(ctx_shift(19)(32*(13+1)-1 downto 32*13)) + state_out(32*(13+1)-1 downto 32*13));
    output(32*(14+1)-1 downto 32*14) <= std_logic_vector(unsigned(ctx_shift(19)(32*(14+1)-1 downto 32*14)) + state_out(32*(14+1)-1 downto 32*14));
    output(32*(15+1)-1 downto 32*15) <= std_logic_vector(unsigned(ctx_shift(19)(32*(15+1)-1 downto 32*15)) + state_out(32*(15+1)-1 downto 32*15));
    
    
    COUNTER_PROC:
    process(clk, reset)
    begin
        if(clk'event and clk = '1') then
            if(reset = '1') then
                counter <= "00";
            elsif(hold = '0') then
                counter <= std_logic_vector(unsigned(counter) + 1);
            end if;
        end if;
    end process COUNTER_PROC;
    
    SHIFT_PROC:
    process(clk)
    begin
        if(clk'event and clk = '1') then
            if(counter = "00" and hold = '0') then
                ctx_shift(19 downto 1) <= ctx_shift(18 downto 0);
                ctx_shift(0) <= input;
            end if;
        end if;
    end process;
end Behavioral;
