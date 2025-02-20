library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity kaskad_raknare is
    port (
        clk   : in  std_logic;                -- Klocksignal
        reset : in  std_logic;                -- Asynkront reset
        s1    : out std_logic_vector(3 downto 0); -- Sekunder (LSB)
        s2    : out std_logic_vector(3 downto 0); -- Sekunder (MSB)
        m     : out std_logic_vector(3 downto 0)  -- Minuter
    );
end kaskad_raknare;

architecture Behavioral of cascade_counter is
    -- Interna signaler för att lagra räknarvärden
    signal sec_ones : std_logic_vector(3 downto 0) := "0000"; -- LSB (0-9)
    signal sec_tens : std_logic_vector(3 downto 0) := "0000"; -- MSB (0-5)
    signal minutes  : std_logic_vector(3 downto 0) := "0000"; -- (0-9)
    -- Om man vill räkna minuter 0–59 ändrar man logiken så att 'minutes' går 0–5, 
    -- och lägger till ytterligare en siffra om man vill visa tvåsiffrigt antal minuter.

begin

    ----------------------------------------------------------------
    -- Process för att räkna sekunder och minuter
    ----------------------------------------------------------------
    process(clk, reset)
    begin
        if reset = '1' then
            sec_ones <= "0000";
            sec_tens <= "0000";
            minutes  <= "0000";
        elsif rising_edge(clk) then
            -- räkna upp sekunder (LSB)
            if sec_ones = "1001" then
                sec_ones <= "0000";
                -- räkna upp sekunder (MSB)
                if sec_tens = "0101" then
                    sec_tens <= "0000";
                    -- räkna upp minuter
                    if minutes = "1001" then
                        minutes <= "0000";
                    else
                        minutes <= minutes + 1;
                    end if;
                else
                    sec_tens <= sec_tens + 1;
                end if;
            else
                sec_ones <= sec_ones + 1;
            end if;
        end if;
    end process;
    ----------------------------------------------------------------
    -- Utsignaler
    ----------------------------------------------------------------
    s1 <= sec_ones;  -- minst signifikant sekunder
    s2 <= sec_tens;  -- mest signifikant sekunder
    m  <= minutes;   -- minuter

end architecture;

