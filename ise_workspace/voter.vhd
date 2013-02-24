library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity voter is
  Port ( data_input : in  STD_LOGIC_VECTOR (1 downto 0);
         clk : in  STD_LOGIC;
         reset : in  STD_LOGIC;
         data_output : out  STD_LOGIC;
         status_output : out STD_LOGIC);
end voter;

architecture Behavioral of voter is

  signal system_failure : STD_LOGIC;
  
  alias a : STD_LOGIC is data_input(0);
  alias b : STD_LOGIC is data_input(1);

begin

  status_output <= system_failure;

  process(clk)	
  begin
    if rising_edge(clk) then
      if reset = '1' then
        data_output <= '0';
        system_failure <= '0';
      else
        data_output <= a and b;
        if system_failure = '0' then 
          system_failure <= a xor b;
        end if;
      end if;
    end if;
  end process;
  
end Behavioral;
