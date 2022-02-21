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

entity fir_filter is
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
end fir_filter;

architecture Behavioral of fir_filter is

    type t_data_pipe is array (0 to N_TAPS-1) of signed(DATA_WIDTH -1 downto 0); 
    type t_mult is array (0 to N_TAPS-1) of signed(COEFF_WIDTH+DATA_WIDTH-1 downto 0);    -- size[n*m] = size[m]*size[n]
    type t_add_0 is array (0 to N_TAPS/2 -1) of signed(COEFF_WIDTH+DATA_WIDTH downto 0);  -- size[n+m] = size[m]+size[n]+1
                           
    signal s_data    : t_data_pipe:= (others => (others => '0'));                    -- container for data
    signal s_mult    : t_mult:= (others => (others => '0'));                         -- container for coeff*data 
    signal s_add_0   : t_add_0:= (others => (others => '0'));                        -- container for first sum ( sum all pairs ) 
    signal s_add_1   : signed(COEFF_WIDTH+DATA_WIDTH+1 downto 0):= (others => '0');  -- container for second sum
    
begin
p_input : process (i_clk)
    begin
        if(rising_edge(i_clk) and i_valid = '1') then -- insert new sample at the beginning, shift the others
           s_data <= signed(i_data)&s_data(0 to s_data'length-2);
        end if;
   end process p_input;
   
   p_mult : process (i_clk) -- multiply data with the coefficients
   begin
        if(rising_edge(i_clk)) then 
            for k in 0 to N_TAPS-1 loop
                s_mult(k) <= s_data(k) * i_coeff(k); -- size bin casting is automatic
            end loop;
        end if;
   end process p_mult;
   
   p_add_0 : process (i_clk) -- sum - step 1 --why?
   begin
        if(rising_edge(i_clk)) then
            for k in 0 to N_TAPS/2-1 loop
                s_add_0(k) <= resize(s_mult(2*k), COEFF_WIDTH+DATA_WIDTH+1) + resize(s_mult(2*k+1), COEFF_WIDTH+DATA_WIDTH+1);
            end loop;
        end if;
   end process p_add_0;
   
   p_add_1 : process (i_clk) -- sum - step 2 
   variable tmp: signed(COEFF_WIDTH+DATA_WIDTH+1 downto 0):= (others => '0');
   begin
        tmp := (others => '0');
        if(rising_edge(i_clk)) then 
            for k in 0 to N_TAPS/2-1 loop
                tmp := tmp + resize(s_add_0(k), COEFF_WIDTH+DATA_WIDTH+2);
            end loop;
            if(N_TAPS mod 2 /= 0) then -- odd
                tmp := tmp + resize(s_mult(N_TAPS-1), COEFF_WIDTH+DATA_WIDTH+2);
            end if;
            s_add_1 <= tmp;
        end if;
   end process p_add_1;
   
   p_output : process (i_clk) -- compute output
   begin
        if(rising_edge(i_clk)) then 
            o_data <= std_logic_vector(s_add_1(DATA_WIDTH-1+SCALING downto SCALING)); -- recal sign extension in signed type
        end if;
   end process p_output;
   
end Behavioral;
