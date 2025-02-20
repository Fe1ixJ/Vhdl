-- comb_lock.vhdl
-- x1 styrs av vÃ¤nster skjutomkopplare S1
-- x0 styrs av hÃ¶ger skjutomkopplare S0
-- Typically connect the following at the connector area of DigiMod
-- sclk <-- 32kHz

library ieee;
  use ieee.std_logic_1164.all;

entity comb_lock is
  port (clk   : in  std_logic; -- "fast enough"
        reset : in  std_logic; -- active high
        x1    : in  std_logic; -- x1 is left
        x0    : in  std_logic; -- x0 is right
        u     : out std_logic
       );
end entity;

architecture rtl of comb_lock is
  -- signals etc

-- Synkroniserade insignaler med debounce-filter
  signal x1_sync      : std_logic := '0';
  signal x0_sync      : std_logic := '0';

  -- Räknarens tillstånd
  signal q0, q1 : std_logic := '0';

begin
  -- Synkronisera och debounce:a insignalerna
  process (clk)
  begin
   if rising_edge(clk) then
      x1_sync <= x1;
      x0_sync <= x0;
    end if;
  end process;

  -- Räknare med hantering av över- och underflöde
  process (clk, reset)
  begin
    if reset = '1' then
      q0 <= '0';
      q1 <= '0';
    elsif rising_edge(clk) then
      q0 <= (not x1_sync and not x0_sync) or (q1 and q0) or (q1 and x1_sync and x0_sync);
      q1 <= (x0_sync and q1) or (q1 and q0 and x1_sync) or (q0 and x0_sync and not x1_sync);
    end if;
  end process;

  -- Utsignal
  u <= q1 and q0;


end architecture;
