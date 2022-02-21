library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package fir_pkg is
        type coeff_array is array(natural range <>) of signed;
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fir_pkg.ALL;

entity fir_controller is
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
end fir_controller;

architecture Behavioral of fir_controller is
    -- LP band coeffs
	signal coeff_0_LP : integer:=50460;
    signal coeff_1_LP : integer:=117783;
    signal coeff_2_LP : integer:=301751;
    signal coeff_3_LP : integer:=545596;
    signal coeff_4_LP : integer:=752508;
    signal coeff_5_LP : integer:=833429;
    signal coeff_6_LP : integer:=752508;
    signal coeff_7_LP : integer:=545596;
    signal coeff_8_LP : integer:=301751;
    signal coeff_9_LP : integer:=117783;
    signal coeff_10_LP : integer:=50460;

    signal coeff_LP: coeff_array:=( to_signed(coeff_0_LP,24),
                                   to_signed(coeff_1_LP,24),
                                   to_signed(coeff_2_LP,24),
                                   to_signed(coeff_3_LP,24),
                                   to_signed(coeff_4_LP,24),
                                   to_signed(coeff_5_LP,24),
                                   to_signed(coeff_6_LP,24),
                                   to_signed(coeff_7_LP,24),
                                   to_signed(coeff_8_LP,24),
                                   to_signed(coeff_9_LP,24),
                                   to_signed(coeff_10_LP,24));

    -- HP band coeffs
    signal coeff_0_HP : integer:=81734;
    signal coeff_1_HP : integer:=214487;
    signal coeff_2_HP : integer:=-258562;
    signal coeff_3_HP : integer:=-1000790;
    signal coeff_4_HP : integer:=203355;
    signal coeff_5_HP : integer:=1532051;
    signal coeff_6_HP : integer:=203355;
    signal coeff_7_HP : integer:=-1000790;
    signal coeff_8_HP : integer:=-258562;
    signal coeff_9_HP : integer:=214487;
    signal coeff_10_HP : integer:=81734;   
    
    signal coeff_HP: coeff_array:=( to_signed(coeff_0_HP,24),
                                       to_signed(coeff_1_HP,24),
                                       to_signed(coeff_2_HP,24),
                                       to_signed(coeff_3_HP,24),
                                       to_signed(coeff_4_HP,24),
                                       to_signed(coeff_5_HP,24),
                                       to_signed(coeff_6_HP,24),
                                       to_signed(coeff_7_HP,24),
                                       to_signed(coeff_8_HP,24),
                                       to_signed(coeff_9_HP,24),
                                       to_signed(coeff_10_HP,24));
    
    
    component fir_filter is
        generic(
            N_TAPS     : integer:=12; -- number of data to store in memory to perform filter operation
            DATA_WIDTH : integer:=24; -- bit width of data
            COEFF_WIDTH: integer:=24; -- bit width of coeff
            SCALING    : integer:=22  -- scaling factor for coefficients -> should be coeff_width -2(signed) if coeff in (-1,1)
        );
        port (
            i_clk   : in  std_logic;
            i_valid : in  std_logic;
            i_coeff : in  coeff_array;
            i_data  : in  std_logic_vector(DATA_WIDTH -1 downto 0);
            o_data  : out signed(DATA_WIDTH -1 downto 0)
        );
    end component;
    
    signal filtered_data_LP, filtered_data_HP: signed(DATA_WIDTH-1 downto 0);

    signal m_axis_tvalid_int : std_logic;
    signal s_axis_tready_int : std_logic;

begin
    
   m_fir_LP: fir_filter
                generic map(
                       N_TAPS => 11
                   )
                port map(
                    i_clk => i_clk,
                    i_valid => s_axis_tvalid,
                    i_coeff => coeff_LP,
                    i_data => s_axis_tdata,
                    o_data => filtered_data_LP
                );
                
   m_fir_HP: fir_filter
                generic map(
                    N_TAPS => 11
                )
                port map(
                    i_clk => i_clk,
                    i_valid => s_axis_tvalid,
                    i_coeff => coeff_HP,
                    i_data => s_axis_tdata,
                    o_data => filtered_data_HP
                 );
 
   s_axis_tready_int <= m_axis_tready or not m_axis_tvalid_int;
   m_axis_tvalid <= m_axis_tvalid_int;
   s_axis_tready <= s_axis_tready_int;
   
   axis_fir: process(i_clk)
   variable amp_signal: signed(DATA_WIDTH-1 downto 0);
   variable sum_signal: signed(DATA_WIDTH downto 0);
   variable abs_signal: signed(DATA_WIDTH downto 0);
   begin
    if rising_edge(i_clk) then
        if s_axis_tvalid = '1' then
           m_axis_tvalid_int <= '1';
        elsif m_axis_tready = '1' then
           m_axis_tvalid_int <= '0';
        end if;
        
        if s_axis_tvalid = '1' and s_axis_tready_int = '1' then
           m_axis_tlast <= s_axis_tlast;
           -- increase intesity of HP of factor 2 with overflow check and decrase the LP one by the same factor
           abs_signal := abs(filtered_data_HP(DATA_WIDTH-1 downto 0)&'0');
           if(abs_signal(DATA_WIDTH-1)='1' and filtered_data_HP(DATA_WIDTH-1)='1') then
                amp_signal := (DATA_WIDTH-1 downto 0 => '1');
           elsif(abs_signal(DATA_WIDTH-1)='1') then
                amp_signal := '0'&(DATA_WIDTH-2 downto 0 => '1');
           else
                amp_signal := filtered_data_HP(DATA_WIDTH-2 downto 0)&'0';
           end if;
           if( hp='0' and lp='0') then
                sum_signal := (others => '0');
           elsif (hp='0') then
                sum_signal := resize((DATA_WIDTH downto DATA_WIDTH-1 => filtered_data_LP(DATA_WIDTH-1))&filtered_data_LP(DATA_WIDTH-1 downto 1),DATA_WIDTH+1);
           elsif(lp='0') then
                sum_signal := resize(amp_signal,DATA_WIDTH+1);
           else
                sum_signal := resize(amp_signal,DATA_WIDTH+1)+resize((DATA_WIDTH downto DATA_WIDTH-1 => filtered_data_LP(DATA_WIDTH-1))&filtered_data_LP(DATA_WIDTH-1 downto 1),DATA_WIDTH+1);         
           end if;
           m_axis_tdata <= std_logic_vector(sum_signal(DATA_WIDTH-1 downto 0));   
        end if;
    end if;    
   end process;

end Behavioral;
