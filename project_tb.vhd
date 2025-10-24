library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity project_tb is
end project_tb;

architecture behavior of project_tb is

-- Component declaration
component project is
port (
clock : in std_logic;
reset : in std_logic;
entry_sensor : in std_logic;
exit_sensor : in std_logic;
capacity : in unsigned(7 downto 0);
full_flag : out std_logic;
occupancy_count : out unsigned(7 downto 0)
);
end component;

-- Signals to connect to UUT
signal clock : std_logic := '0';
signal reset : std_logic := '0';
signal entry_sensor : std_logic := '0';
signal exit_sensor : std_logic := '0';
signal capacity : unsigned(7 downto 0) := to_unsigned(5, 8); -- Set max to 5
signal full_flag : std_logic;
signal occupancy_count : unsigned(7 downto 0);

-- Clock period
constant clk_period : time := 10 ns;

begin

-- Instantiate Unit Under Test (UUT)
uut: project port map (
clock => clock,
reset => reset,
entry_sensor => entry_sensor,
exit_sensor => exit_sensor,
capacity => capacity,
full_flag => full_flag,
occupancy_count => occupancy_count
);

-- Clock process
clk_process : process
begin
while now < 500 ns loop
clock <= '0';
wait for clk_period/2;
clock <= '1';
wait for clk_period/2;
end loop;
wait;
end process;

-- Stimulus process
stim_proc: process
begin
-- Initial reset
reset <= '1';
wait for 2 * clk_period;
reset <= '0';

-- CASE 1: Entry #1 (occupancy = 1)
entry_sensor <= '1'; wait for clk_period;
entry_sensor <= '0'; wait for clk_period;

-- CASE 2: Entry #2 (occupancy = 2)
entry_sensor <= '1'; wait for clk_period;
entry_sensor <= '0'; wait for clk_period;

-- CASE 3: Simultaneous entry & exit (should be ignored, occupancy = 2)
entry_sensor <= '1'; exit_sensor <= '1'; wait for clk_period;
entry_sensor <= '0'; exit_sensor <= '0'; wait for clk_period;

-- CASE 4: Exit #1 (occupancy = 2 → 1)
exit_sensor <= '1'; wait for clk_period;
exit_sensor <= '0'; wait for clk_period;

-- CASE 5: Exit #2 (occupancy = 1 → 0)
exit_sensor <= '1'; wait for clk_period;
exit_sensor <= '0'; wait for clk_period;

-- CASE 6: Exit when occupancy = 0 (should be ignored, flag stays 0)
exit_sensor <= '1'; wait for clk_period;
exit_sensor <= '0'; wait for clk_period;

-- CASE 7: Long entry pulse (should count only once)
entry_sensor <= '1'; wait for 3 * clk_period;
entry_sensor <= '0'; wait for clk_period;

-- CASE 8: Rapid toggling (only 1 rising edge counts)
entry_sensor <= '1'; wait for clk_period / 4;
entry_sensor <= '0'; wait for clk_period / 4;
entry_sensor <= '1'; wait for clk_period / 4;
entry_sensor <= '0'; wait for clk_period;
-- Only 1 edge should be counted here

-- CASE 9: Fill to capacity (total = 5)
entry_sensor <= '1'; wait for clk_period; entry_sensor <= '0'; wait for clk_period;
entry_sensor <= '1'; wait for clk_period; entry_sensor <= '0'; wait for clk_period;
entry_sensor <= '1'; wait for clk_period; entry_sensor <= '0'; wait for clk_period;

-- CASE 10: Entry when full (should be ignored, occupancy = 5)
entry_sensor <= '1'; wait for clk_period;
entry_sensor <= '0'; wait for clk_period;

-- CASE 11: Exit from full (occupancy = 5 → 4), flag clears
exit_sensor <= '1'; wait for clk_period;
exit_sensor <= '0'; wait for clk_period;

-- CASE 12: Entry after space opens (occupancy = 4 → 5), flag should rise again
entry_sensor <= '1'; wait for clk_period;
entry_sensor <= '0'; wait for clk_period;

-- CASE 13: Simultaneous entry & exit again (ignored)
entry_sensor <= '1'; exit_sensor <= '1'; wait for clk_period;
entry_sensor <= '0'; exit_sensor <= '0'; wait for clk_period;

-- CASE 14: Mid-test reset — everything should clear
reset <= '1'; wait for clk_period;
reset <= '0'; wait for clk_period;

-- CASE 15: Capacity set to 255 — test large range (no flag should trigger)
capacity <= to_unsigned(255, 8);

-- Entry loop to 10 (way below 255, full_flag should stay 0)
for i in 1 to 10 loop
entry_sensor <= '1'; wait for clk_period;
entry_sensor <= '0'; wait for clk_period;
end loop;

-- Final wait for viewing signals
wait for 10 * clk_period;
wait;
end process;
	
end behavior;	

