library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity voter_4bit is
  Port( 
    data_input : in STD_LOGIC_VECTOR(3 downto 0);
    clk : in STD_LOGIC;
    reset : in STD_LOGIC;
    data_output : out STD_LOGIC;
    status_output : out STD_LOGIC_VECTOR(2 downto 0));
end voter_4bit;

architecture Behavioral of voter_4bit is

  alias a : STD_LOGIC is data_input(0);
  alias b : STD_LOGIC is data_input(1);
  alias c : STD_LOGIC is data_input(2);
  alias d : STD_LOGIC is data_input(3);
  
  signal a_b_c_data_output : STD_LOGIC;
  signal a_b_d_data_output : STD_LOGIC;
  signal a_c_d_data_output : STD_LOGIC;
  signal b_c_d_data_output : STD_LOGIC;

  signal a_b_c_status_output : STD_LOGIC_vector(1 downto 0);
  signal a_b_d_status_output : std_logic_vector(1 downto 0);
  signal a_c_d_status_output : STD_LOGIC_vector(1 downto 0);
  signal b_c_d_status_output : STD_LOGIC_vector(1 downto 0);

  signal a_b_c_data_input : std_logic_vector(2 downto 0);
  signal a_b_d_data_input : std_logic_vector(2 downto 0);
  signal a_c_d_data_input : std_logic_vector(2 downto 0);
  signal b_c_d_data_input : std_logic_vector(2 downto 0);
  
  signal voter_3bit_status : std_logic_vector(7 downto 0);
  
  component voter_3bit
  Port(
    data_input : in STD_LOGIC_VECTOR(2 downto 0);
    clk : in STD_LOGIC;
    reset : in STD_LOGIC;
    data_output : out STD_LOGIC;
    status_output : out STD_LOGIC_VECTOR(1 downto 0)
   );
  end component;
begin

  a_b_c_data_input <= c & b & a;
  a_b_d_data_input <= d & b & a;
  a_c_d_data_input <= d & c & a;
  b_c_d_data_input <= d & c & b;
  
  a_b_c: voter_3bit port map(
    data_input => a_b_c_data_input,
    clk => clk,
    reset => reset,
    data_output => a_b_c_data_output,
    status_output => a_b_c_status_output
    );

  a_b_d: voter_3bit port map(
    data_input => a_b_d_data_input,
    clk => clk,
    reset => reset,
    data_output => a_b_d_data_output,
    status_output => a_b_d_status_output
    );

  a_c_d: voter_3bit port map(
    data_input => a_c_d_data_input,
    clk => clk,
    reset => reset,
    data_output => a_c_d_data_output,
    status_output => a_c_d_status_output
    );

  b_c_d: voter_3bit port map(
    data_input => b_c_d_data_input,
    clk => clk,
    reset => reset,
    data_output => b_c_d_data_output,
    status_output => b_c_d_status_output
    );

  voter_3bit_status <= b_c_d_status_output &
                       a_c_d_status_output &
                       a_b_d_status_output &
                       a_b_c_status_output;

  status_output <= "000" when voter_3bit_status = "00000000" else
                   "111" when voter_3bit_status = "11111111" else
                   "001" when
                   a_b_c_status_output = "00" or
                   a_b_d_status_output = "00" or
                   a_c_d_status_output = "00" or
                   b_c_d_status_output = "00" else
                   "010";

  data_output <= a_b_c_data_output when a_b_c_status_output(1) = '0' else
                 a_b_d_data_output when a_b_d_status_output(1) = '0' else
                 a_c_d_data_output when a_c_d_status_output(1) = '0' else
                 b_c_d_data_output when b_c_d_status_output(1) = '0' else
                 '-';

end Behavioral;

