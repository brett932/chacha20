library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity chacha20_two_round is
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
end chacha20_two_round;

architecture Behavioral of chacha20_two_round is
    component chacha20_quarter_round is
    port (
        clk : in std_logic;
        rst : in std_logic;
        hold : in std_logic;
        a_in, b_in, c_in, d_in : in unsigned(31 downto 0);
        a_out, b_out, c_out, d_out : out unsigned(31 downto 0)
    );
    end component chacha20_quarter_round;
    
    type qr_state_type is (a, b, c, d);
    type qr_state_array_type is array(qr_state_type) of unsigned (31 downto 0);
    type qr_array_type is array(7 downto 0,qr_state_type) of unsigned (31 downto 0);
    signal qr_in : qr_array_type;
    signal qr_out : qr_array_type;
    
    type type_context is array(15 downto 0) of unsigned (31 downto 0);
    signal ctx : type_context;
    signal round: integer;
begin
    GEN_QUARTER_ROUNDS:
    for i in 0 to 7 generate
        QR_X : chacha20_quarter_round port map
            (
                clk => clk,
                rst => rst,
                hold => hold,
                a_in => qr_in(i,a),
                b_in => qr_in(i,b),
                c_in => qr_in(i,c),
                d_in => qr_in(i,d),
                a_out => qr_out(i,a),
                b_out => qr_out(i,b),
                c_out => qr_out(i,c),
                d_out => qr_out(i,d)
            );
    end generate;
    
    
    qr_in(0, a) <= ctx_in_0;              --  0
    qr_in(1, a) <= ctx_in_1;              --  1
    qr_in(2, a) <= ctx_in_2;              --  2
    qr_in(3, a) <= ctx_in_3;              --  3
    qr_in(0, b) <= ctx_in_4;              --  4
    qr_in(1, b) <= ctx_in_5;              --  5
    qr_in(2, b) <= ctx_in_6;              --  6 
    qr_in(3, b) <= ctx_in_7;              --  7
    qr_in(0, c) <= ctx_in_8;              --  8
    qr_in(1, c) <= ctx_in_9;              --  9
    qr_in(2, c) <= ctx_in_10;             -- 10
    qr_in(3, c) <= ctx_in_11;             -- 11
    qr_in(0, d) <= ctx_in_12;             -- 12
    qr_in(1, d) <= ctx_in_13;             -- 13
    qr_in(2, d) <= ctx_in_14;             -- 14
    qr_in(3, d) <= ctx_in_15;             -- 15

    qr_in(4, a) <= qr_out(0, a);        --  0
    qr_in(5, a) <= qr_out(1, a);        --  1
    qr_in(6, a) <= qr_out(2, a);        --  2
    qr_in(7, a) <= qr_out(3, a);        --  3
    qr_in(7, b) <= qr_out(0, b);        --  4
    qr_in(4, b) <= qr_out(1, b);        --  5
    qr_in(5, b) <= qr_out(2, b);        --  6
    qr_in(6, b) <= qr_out(3, b);        --  7
    qr_in(6, c) <= qr_out(0, c);        --  8
    qr_in(7, c) <= qr_out(1, c);        --  9
    qr_in(4, c) <= qr_out(2, c);        -- 10
    qr_in(5, c) <= qr_out(3, c);        -- 11
    qr_in(5, d) <= qr_out(0, d);        -- 12
    qr_in(6, d) <= qr_out(1, d);        -- 13
    qr_in(7, d) <= qr_out(2, d);        -- 14
    qr_in(4, d) <= qr_out(3, d);        -- 15
                    
    ctx_out_0  <= qr_out(4, a);
    ctx_out_1  <= qr_out(5, a);
    ctx_out_2  <= qr_out(6, a);
    ctx_out_3  <= qr_out(7, a);
    ctx_out_4  <= qr_out(7, b);
    ctx_out_5  <= qr_out(4, b);
    ctx_out_6  <= qr_out(5, b);
    ctx_out_7  <= qr_out(6, b);
    ctx_out_8  <= qr_out(6, c);
    ctx_out_9  <= qr_out(7, c);
    ctx_out_10 <= qr_out(4, c);
    ctx_out_11 <= qr_out(5, c);
    ctx_out_12 <= qr_out(5, d);
    ctx_out_13 <= qr_out(6, d);
    ctx_out_14 <= qr_out(7, d);
    ctx_out_15 <= qr_out(4, d);

end Behavioral;
