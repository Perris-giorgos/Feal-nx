library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

Entity Post_process is 
	port (
		C: out std_logic_vector(63 downto 0);
		rd: out std_logic;
		clk: in std_logic;
		rst: in std_logic;
		enable: in std_logic;
		ackn: in std_logic);
end Post_process;

architecture state_machine of Post_process is
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

component Main_process is 
	port (
		L32: out std_logic_vector(31 downto 0);
		R32: out std_logic_vector(31 downto 0);
		rd: out std_logic;
		clk: in std_logic;
		rst: in std_logic;
		enable: in std_logic);
end component;

	signal K36: std_logic_vector(15 downto 0);
	signal K37: std_logic_vector(15 downto 0);
	signal K38: std_logic_vector(15 downto 0);
	signal K39: std_logic_vector(15 downto 0);
	---
	
	signal L32: std_logic_vector(31 downto 0);
	signal R32: std_logic_vector(31 downto 0);
	signal post_enable: std_logic;
	begin 
	  
	kk36: ram 
	     port map(clk, x"0000", "000000", "100100", '0', K36); 
	kk37: ram 
	     port map(clk, x"0000", "000000", "100101", '0', K37);
	kk38: ram
	     port map(clk, x"0000", "000000", "100110", '0', K38);
	kk39: ram
	     port map(clk, x"0000", "000000", "100111", '0', K39);         
	       
	       
	--pre-process
	pre1: Main_process port map(L32, R32, post_enable, clk, rst, enable);
	
		process (rst, clk)
		begin 
			if (rst='1') then 
				pr_state <= stay;
			elsif (clk'event and clk='1') then
				pr_state <= nx_state;
			end if;
		end process;
		
		process (pr_state, post_enable, ackn)
		variable L32_var: std_logic_vector(31 downto 0);
		variable R32_var: std_logic_vector(31 downto 0);
		variable C_var: std_logic_vector(63 downto 0):= "0000000000000000000000000000000000000000000000000000000000000000";
		variable rd_var: std_logic := '0';
		begin 
			case pr_state is
				when zero =>
					L32_var := L32 xor R32;
					nx_state <= one;
				when one =>
					L32_var := L32_var xor (K38 & K39);
					R32_var := R32 xor (K36 & K37);
					nx_state <= two;
				when two =>
					C_var := R32_var & L32_var;
					rd_var := '1';
					nx_state <= stay;
				when stay =>
					case post_enable is
						when '1' =>
							nx_state <= zero;
						when '0' =>
							nx_state <= stay;
					end case;
			end case;
		------ACKNOWLEDGE
		if ackn'event and ackn='1' then
			rd_var := '0';
		end if;
		
			C <= C_var;
			rd <= rd_var;
		end process;
end state_machine;
