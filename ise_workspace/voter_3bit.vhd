library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity voter_3bit is
  Port( 
    data_input : in STD_LOGIC_VECTOR(2 downto 0);
    clk : in STD_LOGIC;
    reset : in STD_LOGIC;
    data_output : out STD_LOGIC;
    status_output : out STD_LOGIC_VECTOR(1 downto 0));
end voter_3bit;

architecture Behavioral of voter_3bit is

  alias a : STD_LOGIC is data_input(0);
  alias b : STD_LOGIC is data_input(1);
  alias c : STD_LOGIC is data_input(2);

  signal a_b_data_output : STD_LOGIC;
  signal a_c_data_output : STD_LOGIC;
  signal b_c_data_output : STD_LOGIC;

  signal a_b_status_output : STD_LOGIC;
  signal a_c_status_output : STD_LOGIC;
  signal b_c_status_output : STD_LOGIC;

  signal a_b_data_input : std_logic_vector(1 downto 0);
  signal a_c_data_input : std_logic_vector(1 downto 0);
  signal b_c_data_input : std_logic_vector(1 downto 0);

  signal voter_2bit_status : std_logic_vector(2 downto 0);
  
  component voter Port(
    data_input : in  STD_LOGIC_VECTOR(1 downto 0);
    clk : in STD_LOGIC;
    reset : in  STD_LOGIC;
    data_output : out  STD_LOGIC;
    status_output : out STD_LOGIC
    );
  end component;

begin

  a_b_data_input <= b & a;
  a_c_data_input <= c & a;
  b_c_data_input <= c & b;

  a_b: voter port map(
    data_input => a_b_data_input,
    clk => clk,
    reset => reset,
    data_output => a_b_data_output,
    status_output => a_b_status_output
    );

  a_c: voter port map(
    data_input => a_c_data_input,
    clk => clk,
    reset => reset,
    data_output => a_c_data_output,
    status_output => a_c_status_output
    );

  b_c: voter port map(
    data_input => b_c_data_input,
    clk => clk,
    reset => reset,
    data_output => b_c_data_output,
    status_output => b_c_status_output
    );

  voter_2bit_status <= b_c_status_output & a_c_status_output & a_b_status_output;

  with voter_2bit_status
  select status_output <=
    "00" when "000",
    "11" when "111",
    "01" when others;

  data_output <= a_b_data_output when a_b_status_output = '0' else
                 a_c_data_output when a_c_status_output = '0' else
                 b_c_data_output when b_c_status_output = '0' else
                 '-';
  
end Behavioral;


