library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity chacha20_axi_v1_0 is
	generic (
		-- Users to add parameters here
        BRAM_ADDR_WIDTH         : integer   := 32;
        BRAM_DATA_WIDTH         : integer   := 32;
        BRAM_SIZE               : integer   := 16*1024;
		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 6
	);
	port (
		-- Users to add ports here
        bram_addr: out std_logic_vector(BRAM_ADDR_WIDTH-1 downto 0);
        bram_clk: out std_logic;
        bram_wrdata: out std_logic_vector(BRAM_DATA_WIDTH-1 downto 0);
        bram_rddata: in std_logic_vector(BRAM_DATA_WIDTH-1 downto 0);
        bram_en: out std_logic;
        bram_rst: out std_logic;
        bram_we: out std_logic_vector((BRAM_DATA_WIDTH/8) -1 downto 0);
        
        Interrupt: out std_logic;
        
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end chacha20_axi_v1_0;

architecture arch_imp of chacha20_axi_v1_0 is

	-- component declaration
	component chacha20_axi_v1_0_S00_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 6
		);
		port (
		key             : out std_logic_vector(255 downto 0);
        nonce           : out std_logic_vector(95 downto 0);
        block_start     : out std_logic_vector(31 downto 0);
        num_blocks      : out std_logic_vector(31 downto 0);
        ctl             : out std_logic_vector(31 downto 0);
        status          : in  std_logic_vector(31 downto 0);
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component chacha20_axi_v1_0_S00_AXI;
	
	component chacha20_pipeline is
        port (
            clk : in std_logic;
            reset: in std_logic;
            hold : in std_logic;
            input : in std_logic_vector(32*16-1 downto 0);
            output : out std_logic_vector(32*16-1 downto 0)
        );
    end component chacha20_pipeline;
    
    
    
    
    subtype std_logic_vector_32 is std_logic_vector(31 downto 0);
    function SLICE_N (
            D : std_logic_vector(511 downto 0); 
            N : integer range 15 downto 0)
            return std_logic_vector_32 is
    begin
        return D(32*(N+1)-1 downto 32*N);
    end SLICE_N;   
    
    attribute mark_debug : string;
    attribute keep : string;
    
    
    signal key_in : std_logic_vector(255 downto 0);
    signal nonce_in : std_logic_vector(95 downto 0);
    signal block_start : std_logic_vector(31 downto 0);
    signal num_blocks : std_logic_vector(31 downto 0);
    signal ctl : std_logic_vector(31 downto 0);
    attribute mark_debug of ctl : signal is "true";
    signal status : std_logic_vector(31 downto 0);
    attribute mark_debug of status : signal is "true";
    type t_state is (idle, init, wait_80, run, done);
    signal state : t_state; 
    attribute mark_debug of state : signal is "true";
    signal block_counter : std_logic_vector(31 downto 0);
    attribute mark_debug of block_counter : signal is "true";
    signal block_current : std_logic_vector(31 downto 0);
    attribute mark_debug of block_current : signal is "true";
    signal block_end    : std_logic_vector(31 downto 0);
    attribute mark_debug of block_end : signal is "true";
    
    
    
    signal ccp_rst: std_logic;
    signal ccp_hold: std_logic;
    signal ccp_in: std_logic_vector(511 downto 0);
    attribute mark_debug of ccp_in : signal is "true";
    signal ccp_out: std_logic_vector(511 downto 0);
    attribute mark_debug of ccp_out : signal is "true";
    
    
    signal pipeline_feed_counter : integer range 3 downto 0;
    attribute mark_debug of pipeline_feed_counter : signal is "true";
    signal pipeline_delay_counter: integer;
    signal word_counter : integer range 15 downto 0;
    attribute mark_debug of word_counter : signal is "true";
    signal hold: std_logic;
    attribute mark_debug of hold : signal is "true";
    
    signal addr: std_logic_vector(31 downto 0);
    
    signal lower_full: std_logic;
    signal upper_full: std_logic;
    signal wait_for_empty_buffer : std_logic;
    signal wait_for_block_write : std_logic;
    signal int : std_logic;
    attribute mark_debug of int : signal is "true";
    
    constant STATUS_IDLE            : integer := 0;
    constant STATUS_LOWER_FULL      : integer := 1;
    constant STATUS_UPPER_FULL      : integer := 2;
    constant STATUS_DONE            : integer := 3;
    constant CTL_RST                : integer := 0;
    constant CTL_UPPER_CLR          : integer := 1;
    constant CTL_LOWER_CLR          : integer := 2;
    constant CTL_TRIG               : integer := 3;
    
    constant C0 : std_logic_vector(31 downto 0) := x"61707865";
    constant C1 : std_logic_vector(31 downto 0) := x"3320646e";
    constant C2 : std_logic_vector(31 downto 0) := x"79622d32";
    constant C3 : std_logic_vector(31 downto 0) := x"6b206574";    
begin

-- Instantiation of Axi Bus Interface S00_AXI
    chacha20_axi_v1_0_S00_AXI_inst : chacha20_axi_v1_0_S00_AXI
        generic map (
            C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
            C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
        )
        port map (
            key => key_in,
            nonce => nonce_in,
            block_start => block_start,
            num_blocks => num_blocks,
            ctl => ctl,
            status => status,
            S_AXI_ACLK	=> s00_axi_aclk,
            S_AXI_ARESETN	=> s00_axi_aresetn,
            S_AXI_AWADDR	=> s00_axi_awaddr,
            S_AXI_AWPROT	=> s00_axi_awprot,
            S_AXI_AWVALID	=> s00_axi_awvalid,
            S_AXI_AWREADY	=> s00_axi_awready,
            S_AXI_WDATA	=> s00_axi_wdata,
            S_AXI_WSTRB	=> s00_axi_wstrb,
            S_AXI_WVALID	=> s00_axi_wvalid,
            S_AXI_WREADY	=> s00_axi_wready,
            S_AXI_BRESP	=> s00_axi_bresp,
            S_AXI_BVALID	=> s00_axi_bvalid,
            S_AXI_BREADY	=> s00_axi_bready,
            S_AXI_ARADDR	=> s00_axi_araddr,
            S_AXI_ARPROT	=> s00_axi_arprot,
            S_AXI_ARVALID	=> s00_axi_arvalid,
            S_AXI_ARREADY	=> s00_axi_arready,
            S_AXI_RDATA	=> s00_axi_rdata,
            S_AXI_RRESP	=> s00_axi_rresp,
            S_AXI_RVALID	=> s00_axi_rvalid,
            S_AXI_RREADY	=> s00_axi_rready
        );
    ccp: chacha20_pipeline
        port map(
            clk => s00_axi_aclk,
            reset => ccp_rst,
            hold => ccp_hold,
            input => ccp_in,
            output => ccp_out
        );

  
	-- Add user logic here
	Interrupt <= int;
	bram_we <= ((BRAM_DATA_WIDTH/8) -1 downto 0 => '1');
	bram_addr <= addr;
	bram_clk <= s00_axi_aclk;
	bram_rst <= not s00_axi_aresetn;
	
	
	ccp_in(31 downto 0) <= C0;
    ccp_in(63 downto 32) <= C1;
    ccp_in(95 downto 64) <= C2;
    ccp_in(127 downto 96) <= C3;
	ccp_in(415 downto 384) <= block_counter;
	
	wait_for_empty_buffer <= lower_full and upper_full;
	
    proc_state : process begin
    if(s00_axi_aclk'event and s00_axi_aclk = '1') then
        if(s00_axi_aresetn = '0' or ctl(CTL_RST) = '1') then
            state <= idle;
        else
            case state is
                when idle =>
                    if(ctl(CTL_TRIG) = '1') then
                        state <= init;
                    end if;
                when init =>
                    state <= wait_80;
                    ccp_in(383 downto 128) <= key_in;
                    ccp_in(511 downto 416) <= nonce_in;
                    pipeline_delay_counter <= 0;
                when wait_80 =>
                    if(pipeline_delay_counter = 80) then
                        state <= run;
                    else
                        pipeline_delay_counter <= pipeline_delay_counter + 1;
                    end if;
                when run =>
                    if(block_current = block_end) then
                        state <= done;
                    end if;
                when done =>
            end case;
        end if;
    end if;    
    end process proc_state;
    
    proc_status : process begin
    if(s00_axi_aclk'event and s00_axi_aclk = '1') then
        if( state = idle) then
            status(STATUS_IDLE) <= '1';
        else
            status(STATUS_IDLE) <= '0';
        end if;
        status(STATUS_LOWER_FULL) <= lower_full;
        status(STATUS_UPPER_FULL) <= upper_full;
        if(state = done) then
            status(STATUS_DONE) <= '1';
        else
            status(STATUS_DONE) <= '0';
        end if;
    end if;
    end process;
    
    proc_interrupt : process begin
    if(s00_axi_aclk'event and s00_axi_aclk = '1') then
        case state is
            when run =>
                int <= lower_full or upper_full;
            when done =>
                int <= '1';
            when others =>
                int <= '0';
        end case;
    end if;
    end process proc_interrupt; 
    
    proc_lower_full : process begin
    if(s00_axi_aclk'event and s00_axi_aclk = '1') then
        case state is
            when init =>
                lower_full <= '0';
            when run =>
                if(addr = std_logic_vector(to_unsigned(BRAM_SIZE/2 -1, BRAM_ADDR_WIDTH))) then
                    lower_full <= '1';
                elsif (ctl(CTL_LOWER_CLR) = '1') then
                    lower_full <= '0';
                end if;
            when others =>
        end case;
    end if;
    end process proc_lower_full;
    
    proc_upper_full : process begin
    if(s00_axi_aclk'event and s00_axi_aclk = '1') then
        case state is
            when init =>
                upper_full <= '0';
            when run =>
                if(addr = std_logic_vector(to_unsigned(BRAM_SIZE -1, BRAM_ADDR_WIDTH))) then
                    upper_full <= '1';
                elsif (ctl(CTL_UPPER_CLR) = '1') then
                    upper_full <= '0';
                end if;
            when others =>
        end case;
    end if;
    end process proc_upper_full;
    
    proc_block_write : process(s00_axi_aclk, state) begin
    if(s00_axi_aclk'event and s00_axi_aclk = '1') then
        case state is
            when idle =>
                bram_en <= '0';
            when init =>
                wait_for_block_write <= '0';
                block_current <= block_start;
                block_end <= std_logic_vector(unsigned(block_start) + unsigned(num_blocks));
            when run =>
                if( wait_for_empty_buffer = '0' and block_current /= block_end) then
                    bram_en <= '1';
                    if(addr = std_logic_vector(to_unsigned(BRAM_SIZE-1, BRAM_ADDR_WIDTH))) then
                        addr <= ( others => '0');
                    else
                        addr <= std_logic_vector(unsigned(addr) + 1 );
                    end if;
                    bram_wrdata <= SLICE_N(ccp_out, word_counter);
                    if(word_counter = 15) then
                        wait_for_block_write <= '0';
                        word_counter <= 0;
                        block_current <= std_logic_vector(unsigned(block_current) + 1);
                    else
                        wait_for_block_write <= '1';
                        word_counter <= word_counter + 1;
                    end if;
                else
                    bram_en <= '0';
                end if;
            when others =>
        end case;
    end if;   
    end process proc_block_write;
    
    proc_pipeline_feed_counter : process begin
    if(s00_axi_aclk'event and s00_axi_aclk = '1') then
        case state is
            when init => 
                pipeline_feed_counter <= 0;
            when wait_80 =>
                pipeline_feed_counter <= pipeline_feed_counter + 1 ;
            when run =>
                if(pipeline_feed_counter = 3) then
                    if(wait_for_empty_buffer = '0' and wait_for_block_write = '0') then
                        pipeline_feed_counter <= 0;
                    end if;
                else
                    pipeline_feed_counter <= pipeline_feed_counter + 1 ;
                end if;
            when others =>
        end case;
    end if;
    end process proc_pipeline_feed_counter;
    
    proc_pipeline_block_counter : process begin
    if(s00_axi_aclk'event and s00_axi_aclk = '1') then
        case state is
            when init =>
                block_counter <= block_start;
            when run =>
                if(pipeline_feed_counter = 3 and wait_for_empty_buffer = '0' and wait_for_block_write = '0') then
                    block_counter <= std_logic_vector(unsigned(block_counter) + 1);
                end if;
            when others =>
        end case;
    end if;
    end process proc_pipeline_block_counter;
    
    proc_pipeline_ccp_reset : process begin
    if(s00_axi_aclk'event and s00_axi_aclk = '1') then
        if (state = idle) then
            ccp_rst <= '1';
        else
            ccp_rst <= '0';
        end if;
    end if;
    end process proc_pipeline_ccp_reset;
    
    proc_pipeline_ccp_hold : process begin
    if(s00_axi_aclk'event and s00_axi_aclk = '1') then
        case state is
            when init => ccp_hold <= '1';
            when wait_80 => ccp_hold <= '0';
            when run =>
                if(pipeline_feed_counter = 3 ) then
                    case (wait_for_empty_buffer = '1' or wait_for_block_write = '1') is
                        when true =>    ccp_hold <= '1';
                        when false =>   ccp_hold <= '0';
                    end case;
                end if;
            when others =>
                ccp_hold <= '1';
        end case;
    end if;
    end process proc_pipeline_ccp_hold;
	-- User logic ends

end arch_imp;
