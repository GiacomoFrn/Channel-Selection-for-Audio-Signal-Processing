library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library xil_defaultlib;
use IEEE.NUMERIC_STD.ALL;

entity top_vhdl is
    generic(
            RESET_POLARITY : std_logic := '0');
    port    (
             clk : in std_logic;
             reset : in std_logic;
             tx_mclk : out std_logic;
             tx_lrck : out std_logic;
             tx_sclk : out std_logic;
             tx_data : out std_logic;
             rx_mclk : out std_logic;
             rx_lrck : out std_logic;
             rx_sclk : out std_logic;
             rx_data : in std_logic);         
end top_vhdl;

architecture Behavioral of top_vhdl is

component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  axis_clk          : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;

component axis_i2s2 
port(
    axis_clk : in std_logic;
    axis_resetn : in std_logic;
    tx_axis_s_data : in std_logic_vector(31 downto 0);
    tx_axis_s_valid : in std_logic;
    tx_axis_s_ready : out std_logic;
    tx_axis_s_last : in std_logic;
    rx_axis_m_data : out std_logic_vector(31 downto 0);
    rx_axis_m_valid : out std_logic;
    rx_axis_m_ready : in std_logic;
    rx_axis_m_last : out std_logic;
    tx_mclk : out std_logic;
    tx_lrck : out std_logic;
    tx_sclk : out std_logic;
    tx_sdout : out std_logic;
    rx_mclk : out std_logic;
    rx_lrck : out std_logic;
    rx_sclk : out std_logic;
    rx_sdin : in std_logic);
end component;    

component fir_controller
    generic(
        DATA_WIDTH : integer:=24 -- bit width of data
    );
    port (
       i_clk    : in std_logic;
       hp : in std_logic;
       lp : in std_logic;
       
       s_axis_tdata  : in std_logic_vector(DATA_WIDTH-1 downto 0);
       s_axis_tlast  : in std_logic;
       s_axis_tvalid : in std_logic;
       s_axis_tready : out std_logic;
       
       m_axis_tdata  : out std_logic_vector(DATA_WIDTH-1 downto 0);
       m_axis_tlast  : out std_logic;
       m_axis_tvalid : out std_logic;
       m_axis_tready : in std_logic
    );
end component;

signal axis_clk : std_logic;
signal axis_tx_data : std_logic_vector(23 downto 0);
signal axis_tx_data32 : std_logic_vector(31 downto 0);
signal axis_tx_valid : std_logic;
signal axis_tx_ready : std_logic;
signal axis_tx_last : std_logic;
signal axis_rx_data : std_logic_vector(23 downto 0);
signal axis_rx_data32 : std_logic_vector(31 downto 0);
signal axis_rx_valid : std_logic;
signal axis_rx_ready : std_logic;
signal axis_rx_last : std_logic;
signal resetn : std_logic;

begin

resetn <= '0' when reset = RESET_POLARITY else
          '1';

m_clk : clk_wiz_0
   port map ( 
   axis_clk => axis_clk,
   clk_in1 => clk
 );

axis_tx_data32(23 downto 0) <= axis_tx_data;
axis_rx_data <= axis_rx_data32(23 downto 0);
 
m_i2s2 : axis_i2s2
    port map ( 
        axis_clk => axis_clk,
        axis_resetn => resetn,
        tx_axis_s_data => axis_tx_data32,
        tx_axis_s_valid => axis_tx_valid,
        tx_axis_s_ready => axis_tx_ready,
        tx_axis_s_last => axis_tx_last,
        rx_axis_m_data => axis_rx_data32,
        rx_axis_m_valid => axis_rx_valid,
        rx_axis_m_ready => axis_rx_ready,
        rx_axis_m_last => axis_rx_last,
        tx_mclk => tx_mclk,
        tx_lrck => tx_lrck,
        tx_sclk => tx_sclk,
        tx_sdout => tx_data,
        rx_mclk => rx_mclk,
        rx_lrck => rx_lrck,
        rx_sclk => rx_sclk,
        rx_sdin => rx_data
    );
    
m_fir : fir_controller
    port map (
        i_clk => axis_clk,
        s_axis_tdata => axis_rx_data,
        s_axis_tvalid => axis_rx_valid,
        s_axis_tready => axis_rx_ready,
        s_axis_tlast => axis_rx_last,
        m_axis_tdata => axis_tx_data,
        m_axis_tvalid => axis_tx_valid,
        m_axis_tready => axis_tx_ready,
        m_axis_tlast => axis_tx_last
    );
    
end Behavioral;
