library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity project is
port (
clock : in std_logic;
reset : in std_logic;
entry_sensor : in std_logic;
exit_sensor : in std_logic;
capacity : in unsigned(7 downto 0); -- Max capacity input
full_flag : out std_logic;
occupancy_count : out unsigned(7 downto 0)
);
end project;

architecture arch_project of project is

signal total_people : unsigned(7 downto 0) := (others => '0');
signal full_internal: std_logic := '0';

signal entry_in, exit_out : std_logic := '0';
signal in_edge, out_edge : std_logic;

begin

process(clock)
begin
if rising_edge(clock) then
if reset = '1' then
total_people <= (others => '0');
full_internal <= '0';
entry_in <= '0';
exit_out <= '0';
else
-- Edge detection
in_edge <= entry_sensor and not entry_in;
out_edge <= exit_sensor and not exit_out;

-- Update sensor memory
entry_in <= entry_sensor;
exit_out <= exit_sensor;

-- Entry/Exit Logic
if in_edge = '1' and out_edge = '1' then
-- Ignore simultaneous
null;
elsif in_edge = '1' then
if total_people < capacity then
total_people <= total_people + 1;
end if;
elsif out_edge = '1' then
if total_people > 0 then
total_people <= total_people - 1;
end if;
end if;

-- Full flag logic
if total_people >= capacity then
full_internal <= '1';
else
full_internal <= '0';
end if;
end if;
end if;
end process;

-- Outputs
full_flag <= full_internal;
occupancy_count <= total_people;

end arch_project;
	

