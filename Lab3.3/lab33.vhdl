library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity code_lock is
  port (
    clk      : in  std_logic;
    reset    : in  std_logic;
    x1_in    : in  std_logic;
    x0_in    : in  std_logic;
    u        : out std_logic
  );
end entity;

architecture arch of codelock is
  -- Synkroniserade insignaler med debounce-filter
  signal x1_sync      : std_logic := '0';
  signal x0_sync      : std_logic := '0';
  signal x1_sync_old  : std_logic := '0';
  signal x0_sync_old  : std_logic := '0';
  signal x1           : std_logic := '0';
  signal x0           : std_logic := '0';

  -- Räknarens tillstånd
  signal q0, q1 : std_logic := '0';

begin
  -- Synkronisera och debounce:a insignalerna
  process (clk)
  begin
    if rising_edge(clk) then
      x1_sync <= x1_in;
      x1_sync_old <= x1_sync;
      
      x0_sync <= x0_in;
      x0_sync_old <= x0_sync;
    end if;
  end process;

  -- Kantdetektering
  process (clk)
  begin
    if rising_edge(clk) then
      x1 <= x1_sync and not x1_sync_old;
      x0 <= x0_sync and not x0_sync_old;
    end if;
  end process;

  -- Räknare med hantering av över- och underflöde
  process (clk, reset)
  begin
    if reset = '1' then
      q0 <= '0';
      q1 <= '0';
    elsif rising_edge(clk) then
      q0 <= (not x1 and not x0) or (q1 and q0) or (q1 and x1 and x0);
      q1 <= (x0 and q1) or (q1 and q0 and x1) or (q0 and x0 and not x1);
    end if;
  end process;

  -- Utsignal
  u <= q1 and q0;

end architecture;