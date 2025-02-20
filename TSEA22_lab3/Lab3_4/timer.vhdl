-- timer.vhdl
-- Tryckknapp (T0) "startknapp" startar nedräkningen av timern från 8.
-- Timern räknar sedan ned autonomt till 0 och stannar.
-- Utsignal "alarm" tänds när timern visar 0
-- Typically connect the following at the connector area of DigiMod
-- sclk <-- 1Hz

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity timer is
  port (clk        : in  std_logic; -- clk is 1 Hz
        reset      : in  std_logic; -- aktiv hög
        startknapp : in  std_logic; -- aktiv hög
        alarm      : out std_logic;
        seg        : out std_logic_vector(6 downto 0);
        dp         : out std_logic;
        an         : out std_logic_vector(3 downto 0)
       );
end entity;

architecture rtl of timer is
  -- signals etc

begin
end architecture;
