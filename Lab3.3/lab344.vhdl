library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer is
    Port (
        clk    : in  std_logic;  
        reset  : in  std_logic;  
        start  : in  std_logic;  
        seg    : out std_logic_vector(6 downto 0);
        dp     : out std_logic;
        an     : out std_logic_vector(3 downto 0);
        led    : out std_logic   
    );
end timer;

architecture Behavioral of timer is

signal start_sync : std_logic = '0';

begin

    -- Synchronize and debounce the start signal
    process(clk)
    begin
        if rising_edge(clk) then
            start_sync <= start;
        end if;
    end process;

    -- Countdown process
    process(clk, reset)
    begin
        if reset = '1' then
            count_reg <= (others => '0');
        elsif rising_edge(clk) then
            if start_sync = '1' and count_reg = 0 then
                count_reg <= to_unsigned(8, 4);
            elsif count_reg > 0 then
                count_reg <= count_reg - 1;
        end if;
    end process;

    -- LED control
    led <= '1' when count_reg = 0 else '0';

    -- 7-segment display control
    with count_reg select
        seg <= "1000000" when 0,  
               "1111001" when 1,  
               "0100100" when 2,  
               "0110000" when 3,  
               "0011001" when 4,  
               "0010010" when 5,  
               "0000010" when 6,  
               "1111000" when 7,  
               "0000000" when 8,  
               "0010000" when 9,  
               "1111111" when others;
    dp  <= '1';  -- No decimal point
    an  <= "1110";  -- Select the last digit

end Behavioral;