-- counter_top.vhdl
-- Tryckknapp "upp" räknar upp
-- Tryckknapp "ner" räknar ner
-- Räkning sker bara om en knapp är aktiv, och under-/överflöde hanteras.

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity counter is
  port (
    clk   : in  std_logic;
    reset : in  std_logic;
    upp   : in  std_logic;
    ner   : in  std_logic;
    seg   : out std_logic_vector(6 downto 0);
    dp    : out std_logic;
    an    : out std_logic_vector(3 downto 0));
end entity;

architecture arch of counter is
  -- Synkroniserade insignaler med debounce-filter
  signal upp_sync     : std_logic;
  signal ner_sync     : std_logic;
  signal count : unsigned(3 downto 0) := (others => '0'); -- Räknarens värde

  -- 7-segments avkodning, segment tänds med 0
  type rom is array (0 to 15) of std_logic_vector(6 downto 0);
  constant mem : rom := (
    "1000000", -- 0
    "1111001", -- 1
    "0100100", -- 2
    "0110000", -- 3
    "0011001", -- 4
    "0010010", -- 5
    "0000010", -- 6
    "1111000", -- 7
    "0000000", -- 8
    "0010000", -- 9
    "0001000", -- A
    "0000011", -- b
    "1000110", -- C
    "0100001", -- d
    "0000110", -- E
    "0001110"  -- F
  );

begin
  -- Synkronisera och debounce:a insignalerna
  process (clk)
  begin
    if rising_edge(clk) then
      upp_sync <= upp;
      ner_sync <= ner;
    end if;
  end process;

  -- Räknare med hantering av över- och underflöde
  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        count <= (others => '0');
      elsif upp_sync = '1' and ner_sync = '0' then
        count <= count + 1;
      elsif ner_sync = '1' and upp_sync = '0' then
        count <= count - 1;
      end if;
    end if;
  end process;

  -- Utsignaler
  seg <= mem(to_integer(count));
  dp  <= '1';  -- Ingen punkt
  an  <= "1110";  -- Välj sista siffran

end architecture;
