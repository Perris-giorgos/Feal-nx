library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

Entity Pre_process is 
	port (
		P: in std_logic_vector(63 downto 0);
		L0: out std_logic_vector(31 downto 0);
		R0: out std_logic_vector(31 downto 0);
		rd: out std_logic;
		clk: in std_logic;
		rst: in std_logic;
		enable: in std_logic);
end Pre_process;

architecture state_machine of Pre_process is
	type state is (zero, one, two, stay);
	signal pr_state, nx_state: state;
	
	--RAM
	component ram IS
	GENERIC
	(
		ADDRESS_WIDTH	: integer := 6;
		DATA_WIDTH	: integer := 16
	);
	PORT
	(
		clk			: IN  std_logic;
		data			: IN  std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
		write_address			: IN  std_logic_vector(ADDRESS_WIDTH - 1 DOWNTO 0);
		read_address			: IN  std_logic_vector(ADDRESS_WIDTH - 1 DOWNTO 0);
		we			: IN  std_logic;
		q			: OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0)
	);
END component;
	
signal K32: std_logic_vector(15 downto 0);
signal K33: std_logic_vector(15 downto 0);
signal K34: std_logic_vector(15 downto 0);
signal K35: std_logic_vector(15 downto 0);
	
	begin 
	  
	kk32: ram 
	     port map(clk, x"0000", "000000", "100000", '0', K32); 
	kk33: ram 
	     port map(clk, x"0000", "000000", "100001", '0', K33);
	kk34: ram
	     port map(clk, x"0000", "000000", "100010", '0', K34);
	kk35: ram
	     port map(clk, x"0000", "000000", "100011", '0', K35);           
	  process (rst, clk)
		begin 
			if (rst='1') then 
				pr_state <= stay;
			elsif (clk'event and clk='1') then
				pr_state <= nx_state;
			end if;
		end process;
		
		process (pr_state, enable)
		variable L0_var: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
		variable R0_var: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
		variable rd_var: std_logic := '0';
		begin 
			case pr_state is
				when zero =>
					L0_var := P(63 downto 32);
					R0_var := P(31 downto 0);
					nx_state <= one;
				when one =>
					L0_var := L0_var xor (K32 & K33);
					R0_var := R0_var xor (K34 & K35);
					nx_state <= two;
				when two =>
					R0_var := R0_var xor L0_var;
					L0 <= L0_var;
					R0 <= R0_var;
					rd_var := '1';
					nx_state <= stay;
				when stay =>
					rd_var := '0';
					if enable'event and enable='1' then
						nx_state <= zero;
					else
						nx_state <= stay;
					end if;
			end case;
		
			L0 <= L0_var;
			R0 <= R0_var;
			rd <= rd_var;
		end process;
end state_machine;