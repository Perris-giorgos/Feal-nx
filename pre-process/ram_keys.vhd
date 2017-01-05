LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ram IS
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
END ram;

ARCHITECTURE rtl OF ram IS
	TYPE RAM IS ARRAY(0 TO 2 ** ADDRESS_WIDTH - 1) OF std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
	SIGNAL ram_block : RAM := (x"7519", x"71f9", x"84e9", x"4886", x"88e5", x"523b", x"4ea4", x"7ade", x"fe40", x"5e76", x"9819", x"eeac", x"1bd4", x"2455", x"dca0", x"653b", x"3e32", x"4652", x"1cc1", x"34df", x"778b", x"771d", x"d324", x"8410", x"1ca8", x"bc64", x"a0db", x"bdd2", x"1f5f", x"8f1c", x"6b81", x"b560", x"196a", x"9ab1", x"e015", x"8190", x"9f72", x"6643", x"ad32", x"683a", (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'));
	  
BEGIN
	PROCESS (clk)
	BEGIN  
		IF (clk'event AND clk = '1') THEN
			IF (we = '1') THEN
			    ram_block(to_integer(unsigned(write_address))) <= data;
			END IF;

			q <= ram_block(to_integer(unsigned(read_address)));
		END IF;
	END PROCESS;
END rtl;
