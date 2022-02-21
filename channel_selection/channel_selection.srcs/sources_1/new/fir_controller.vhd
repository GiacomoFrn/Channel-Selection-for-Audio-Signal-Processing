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

    -- coeffs
    signal coeff_0 : integer:=81734;
    signal coeff_1 : integer:=214487;
    signal coeff_2 : integer:=-258562;
    signal coeff_3 : integer:=-1000790;
    signal coeff_4 : integer:=203355;
    signal coeff_5 : integer:=1532051;
    signal coeff_6 : integer:=203355;
    signal coeff_7 : integer:=-1000790;
    signal coeff_8 : integer:=-258562;
    signal coeff_9 : integer:=214487;
    signal coeff_10 : integer:=81734;   
    
    signal coeff: coeff_array:=( to_signed(coeff_0,24),
                                       to_signed(coeff_1,24),
                                       to_signed(coeff_2,24),
                                       to_signed(coeff_3,24),
                                       to_signed(coeff_4,24),
                                       to_signed(coeff_5,24),
                                       to_signed(coeff_6,24),
                                       to_signed(coeff_7,24),
                                       to_signed(coeff_8,24),
                                       to_signed(coeff_9,24),
                                       to_signed(coeff_10,24));
    
    
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
            o_data  : out std_logic_vector(DATA_WIDTH -1 downto 0)
        );
    end component;
    
    signal filtered_data: std_logic_vector(DATA_WIDTH-1 downto 0);

    signal m_axis_tvalid_int : std_logic;
    signal s_axis_tready_int : std_logic;

begin
    
   m_fir: fir_filter
                generic map(
                    N_TAPS => 11
                )
                port map(
                    i_clk => i_clk,
                    i_valid => s_axis_tvalid,
                    i_coeff => coeff,
                    i_data => s_axis_tdata,
                    o_data => filtered_data
                 );
 
   s_axis_tready_int <= m_axis_tready or not m_axis_tvalid_int;
   m_axis_tvalid <= m_axis_tvalid_int;
   s_axis_tready <= s_axis_tready_int;
   
   fir_controller: process(i_clk)
   begin
    if rising_edge(i_clk) then
        if s_axis_tvalid = '1' then
           m_axis_tvalid_int <= '1';
        elsif m_axis_tready = '1' then
           m_axis_tvalid_int <= '0';
        end if;
        
        if s_axis_tvalid = '1' and s_axis_tready_int = '1' then
           m_axis_tlast <= s_axis_tlast;
           m_axis_tdata <= filtered_data;   
        end if;
    end if;    
   end process;

end Behavioral;
