library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity transmitter is
    port(
       -- baudrate_out: in std_logic;
        clk  : in std_logic;
        data_in: in std_logic_vector(32 downto 0);
        valid: in std_logic;
        uart_tx: out std_logic);
end transmitter;

architecture rtl of transmitter is
    component baudrate is
        Port ( 
            clk_b: in std_logic;
            o_b  : out std_logic);
    end component;
    
    component sync is
        port (
            clk : in std_logic;
            rst : in std_logic;
            input : in std_logic;
            --internal : out std_logic;
            sync_input : out std_logic);
    end component;
    
    --signal word: std_logic_vector(7 downto 0);
    type state_type is (DATA_IS_VALID, START,
                         B0, B1, B2, B3, B4, B5, B6, B7,
                         B8, B9, B10, B11, B12, B13, B14,
                         B15, B16, B17, B18, B19, B20, B21,
                         B22, B23, B24, B25, B26, B27, B28,
                         B29, B30, B31,STOP, IDLE);
    signal state : state_type := IDLE;
    
    signal baudrate_out: std_logic;
    --signal valid_sync, rst, internal: std_logic;
begin
    --state <= IDLE;
    b: baudrate port map(clk_b=>clk, o_b=>baudrate_out);
    --s: sync port map(clk=>baudrate_out, input=>valid, sync_input=>valid_sync, rst=>rst, internal=>internal);
    main: process(clk)
    begin 
    --valid_sync <= '1';
    if(rising_edge(clk)) then
    case state is
        when IDLE => 
        uart_tx<= '1';
        if valid = '1' then
            state <= DATA_IS_VALID;
            --valid_sync <= '0';
            --word <= data_in;
        end if;
        when DATA_IS_VALID =>
        if baudrate_out = '1' then
            state <= START;
        end if;
        when START =>
        uart_tx<= '0';
        if baudrate_out = '1' then
            state <= B0;
        end if; 
        when B0 =>
        uart_tx<= data_in(0);
        if baudrate_out = '1' then
            state <= B1;
        end if;
        when B1 =>
        uart_tx<= data_in(1);
        if baudrate_out = '1' then
            state <= B2;
        end if;
        when B2 =>
        uart_tx<= data_in(2);
        if baudrate_out = '1' then
            state <= B3;
        end if;
        when B3 =>
        uart_tx<= data_in(3);
        if baudrate_out = '1' then
            state <= B4;
        end if; 
        when B4 =>
        uart_tx<= data_in(4);
        if baudrate_out = '1' then
            state <= B5;
        end if; 
        when B5 =>
        uart_tx<= data_in(5);
        if baudrate_out = '1' then
            state <= B6;
        end if; 
        when B6 =>
        uart_tx<= data_in(6);
        if baudrate_out = '1' then
            state <= B7;
        end if; 
        when B7 =>
             uart_tx<= data_in(7);
             if baudrate_out = '1' then
                 state <= B8;
             end if;
        
        when B8 =>
             uart_tx<= data_in(8);
             if baudrate_out = '1' then
                 state <= B9;
             end if;
        
        when B9 =>
             uart_tx<= data_in(9);
             if baudrate_out = '1' then
                 state <= B10;
             end if;
        
        when B10 =>
             uart_tx<= data_in(10);
             if baudrate_out = '1' then
                 state <= B11;
             end if;
        
        when B11 =>
             uart_tx<= data_in(11);
             if baudrate_out = '1' then
                 state <= B12;
             end if;
        
        when B12 =>
             uart_tx<= data_in(12);
             if baudrate_out = '1' then
                 state <= B13;
             end if;
        
        when B13 =>
             uart_tx<= data_in(13);
             if baudrate_out = '1' then
                 state <= B14;
             end if;
        
        when B14 =>
             uart_tx<= data_in(14);
             if baudrate_out = '1' then
                 state <= B15;
             end if;
        
        when B15 =>
             uart_tx<= data_in(15);
             if baudrate_out = '1' then
                 state <= B16;
             end if;
        
        when B16 =>
             uart_tx<= data_in(16);
             if baudrate_out = '1' then
                 state <= B17;
             end if;
        
        when B17 =>
             uart_tx<= data_in(17);
             if baudrate_out = '1' then
                 state <= B18;
             end if;
        
        when B18 =>
             uart_tx<= data_in(18);
             if baudrate_out = '1' then
                 state <= B19;
             end if;
        
        when B19 =>
             uart_tx<= data_in(19);
             if baudrate_out = '1' then
                 state <= B20;
             end if;
        
        when B20 =>
             uart_tx<= data_in(20);
             if baudrate_out = '1' then
                 state <= B21;
             end if;
        
        when B21 =>
             uart_tx<= data_in(21);
             if baudrate_out = '1' then
                 state <= B22;
             end if;
        
        when B22 =>
             uart_tx<= data_in(22);
             if baudrate_out = '1' then
                 state <= B23;
             end if;
        
        when B23 =>
             uart_tx<= data_in(23);
             if baudrate_out = '1' then
                 state <= B24;
             end if;
        
        when B24 =>
             uart_tx<= data_in(24);
             if baudrate_out = '1' then
                 state <= B25;
             end if;
        
        when B25 =>
             uart_tx<= data_in(25);
             if baudrate_out = '1' then
                 state <= B26;
             end if;
        
        when B26 =>
             uart_tx<= data_in(26);
             if baudrate_out = '1' then
                 state <= B27;
             end if;
        
        when B27 =>
             uart_tx<= data_in(27);
             if baudrate_out = '1' then
                 state <= B28;
             end if;
        
        when B28 =>
             uart_tx<= data_in(28);
             if baudrate_out = '1' then
                 state <= B29;
             end if;
        
        when B29 =>
             uart_tx<= data_in(29);
             if baudrate_out = '1' then
                 state <= B30;
             end if;
        
        when B30 =>
             uart_tx<= data_in(30);
             if baudrate_out = '1' then
                 state <= B31;
             end if;
        
        when B31 =>
             uart_tx<= data_in(31);
             if baudrate_out = '1' then
                 state <= STOP;
             end if; 
        when STOP =>
        uart_tx<= '1';
        if baudrate_out = '1' then
            state <= IDLE;
        end if; 
    end case;
    end if;
    end process;

end rtl;
