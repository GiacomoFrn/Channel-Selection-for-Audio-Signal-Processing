library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library xil_defaultlib;

entity tb_top is

end tb_top;

architecture rtl of tb_top is

component top is
        generic(NUMBER_OF_SWITCHES : integer := 4;
                RESET_POLARITY : std_logic := '0');
        port    (clk : in std_logic;
                 sw : in std_logic_vector(NUMBER_OF_SWITCHES-1 downto 0);
                 reset : in std_logic;
                 tx_mclk : out std_logic;
                 tx_lrck : out std_logic;
                 tx_sclk : out std_logic;
                 tx_data : out std_logic;
                 rx_mclk : out std_logic;
                 rx_lrck : out std_logic;
                 rx_sclk : out std_logic;
                 rx_data : in std_logic); 
end component;

signal s_clk, s_reset, tx_mclk, tx_lrck, tx_sclk, tx_data,rx_mclk, rx_lrck, rx_sclk, rx_data: std_logic;
signal s_sw: std_logic_vector(4-1 downto 0);

begin

    uut: top port map(
                clk => s_clk, 
                sw  => s_sw,
                reset => s_reset,
                tx_mclk => tx_mclk,
                tx_lrck => tx_lrck,
                tx_sclk => tx_sclk,
                tx_data => tx_data,
                rx_mclk => rx_mclk,
                rx_lrck => rx_lrck,
                rx_sclk => rx_sclk,
                rx_data => rx_data);  
     
    p_reset :  process
    begin
      s_reset <= '1';  wait for 50 ns; 
      s_reset <= '0';  wait;
    end process;
             
    p_clk :  process
    begin
      s_clk <= '0'; wait for 5 ns; 
      s_clk <= '1'; wait for 5 ns;
    end process;
 
    p_data :  process
    begin
      rx_data <= '0'; wait for 7.5 ns; 
      rx_data <= '1'; wait for 7.5 ns;
    end process;

    p_sw :  process
    begin
      s_sw <= "0000"; wait for 100 ns; 
      s_sw <= "1111"; wait for 100 ns;
    end process;

end rtl;
