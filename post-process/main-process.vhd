library IEEE;
 use IEEE.STD_LOGIC_1164.ALL; 
 use ieee.numeric_std.all ;
 use ieee.std_logic_unsigned.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

Entity Main_process is 
	port (
		L32: out std_logic_vector(31 downto 0);
		R32: out std_logic_vector(31 downto 0);
		rd: out std_logic;
		clk: in std_logic;
		rst: in std_logic;
		enable: in std_logic);
end Main_process;

architecture state_machine of Main_process is
	type state is (zero, one, iter1, iter2, stay);
	signal pr_state, nx_state: state;
	
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

	component Pre_process is 
	port (
		P: in std_logic_vector(63 downto 0);
		L0: out std_logic_vector(31 downto 0);
		R0: out std_logic_vector(31 downto 0);
		rd: out std_logic;
		clk: in std_logic;
		rst: in std_logic;
		enable: in std_logic);
	end component;

	
	
signal L0: std_logic_vector(31 downto 0);
signal R0: std_logic_vector(31 downto 0);	
signal K: std_logic_vector(15 downto 0);
signal K0: std_logic_vector(15 downto 0);
signal count: std_logic_vector(5 downto 0):= "000000";
signal main_enable: std_logic;

signal fs: std_logic_vector(31 downto 0);
signal f0: std_logic_vector(7 downto 0);
signal f1: std_logic_vector(7 downto 0);
signal f2: std_logic_vector(7 downto 0);
signal f3: std_logic_vector(7 downto 0);
	begin 
	
	kk0: ram 
	     port map(clk, x"0000", "000000", "000000", '0', K0);	 
	
	kk: ram 
	     port map(clk, x"0000", "000000", count, '0', K);
		 
	pre1: Pre_process port map(x"0000000000000000", L0, R0, main_enable, clk, rst, enable);
		 
	  process (rst, clk)
		begin 
			if (rst='1') then 
				pr_state <= stay;
			elsif (clk'event and clk='1') then
				pr_state <= nx_state;
			end if;
		end process;
		
		process (pr_state, main_enable)
		variable Ln_var: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
		variable Rn_var: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
		variable rd_var: std_logic := '0';
		variable Rn_1_var: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
		variable Ln_1_var: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
		variable f: unsigned(31 downto 0):= "00000000000000000000000000000000";
		variable count_var: std_logic_vector(5 downto 0):= "000000";
		variable help: unsigned(7 downto 0);
		variable help1: unsigned(7 downto 0);
		begin 
			case pr_state is
				when zero =>
				----------------------------------- E D W     G I N E T A I      T O     L A T H O S!!!!!!!!!!!!!!
					rd_var := '0';
					f(23 downto 16) := unsigned(R0(23 downto 16) xor K0(15 downto 8)); --f1
					f(15 downto 8) := unsigned(R0(15 downto 8) xor K0(7 downto 0)); --f2
					f(23 downto 16) := f(23 downto 16) xor unsigned(R0(31 downto 24)); --f1
					f(15 downto 8) := f(15 downto 8) xor unsigned(R0(7 downto 0)); --f2
					help1 := f(23 downto 16) + f(15 downto 8) + 1; --f1
					help(7) := help1(5);
					help(6) := help1(4);
					help(5) := help1(3);
					help(4) := help1(2);
					help(3) := help1(1);
					help(2) := help1(0);
					help(1) := help1(7);
					help(0) := help1(6);
					f(23 downto 16) := help(7 downto 0);
					help1 := f(15 downto 8) + f(23 downto 16); --f2
					help(7) := help1(5);
					help(6) := help1(4);
					help(5) := help1(3);
					help(4) := help1(2);
					help(3) := help1(1);
					help(2) := help1(0);
					help(1) := help1(7);
					help(0) := help1(6);
					f(15 downto 8) := help(7 downto 0);
					help1 := unsigned(R0(31 downto 24)) + f(23 downto 16); --f0
					help(7) := help1(5);
					help(6) := help1(4);
					help(5) := help1(3);
					help(4) := help1(2);
					help(3) := help1(1);
					help(2) := help1(0);
					help(1) := help1(7);
					help(0) := help1(6);
					f(31 downto 24) := help(7 downto 0);
					help1 := unsigned(R0(7 downto 0)) + f(15 downto 8) + 1; --f3
					help(7) := help1(5);
					help(6) := help1(4);
					help(5) := help1(3);
					help(4) := help1(2);
					help(3) := help1(1);
					help(2) := help1(0);
					help(1) := help1(7);
					help(0) := help1(6);
					f(7 downto 0) := help(7 downto 0);
					
					count_var := count_var+1;
					nx_state <= one;
				when one =>
					Ln_var := R0;
					Rn_var := L0 xor std_logic_vector(f);
					Rn_1_var := Rn_var;
					Ln_1_var := Ln_var;
					nx_state <= iter1;
					
					---
				when iter1 =>
					f(23 downto 16) := unsigned(Rn_1_var(23 downto 16) xor K(15 downto 8)); --f1
					f(15 downto 8) := unsigned(Rn_1_var(15 downto 8) xor K(7 downto 0)); --f2
					f(23 downto 16) := f(23 downto 16) xor unsigned(Rn_1_var(31 downto 24)); --f1
					f(15 downto 8) := f(15 downto 8) xor unsigned(Rn_1_var(7 downto 0)); --f2
					help1 := f(23 downto 16) + f(15 downto 8) + 1; --f1
					help(7) := help1(5);
					help(6) := help1(4);
					help(5) := help1(3);
					help(4) := help1(2);
					help(3) := help1(1);
					help(2) := help1(0);
					help(1) := help1(7);
					help(0) := help1(6);
					f(23 downto 16) := help(7 downto 0);
					help1 := f(15 downto 8) + f(23 downto 16); --f2
					help(7) := help1(5);
					help(6) := help1(4);
					help(5) := help1(3);
					help(4) := help1(2);
					help(3) := help1(1);
					help(2) := help1(0);
					help(1) := help1(7);
					help(0) := help1(6);
					f(15 downto 8) := help(7 downto 0);
					help1 := unsigned(Rn_1_var(31 downto 24)) + f(23 downto 16); --f0
					help(7) := help1(5);
					help(6) := help1(4);
					help(5) := help1(3);
					help(4) := help1(2);
					help(3) := help1(1);
					help(2) := help1(0);
					help(1) := help1(7);
					help(0) := help1(6);
					f(31 downto 24) := help(7 downto 0);
					help1 := unsigned(Rn_1_var(7 downto 0)) + f(15 downto 8) + 1; --f3
					help(7) := help1(5);
					help(6) := help1(4);
					help(5) := help1(3);
					help(4) := help1(2);
					help(3) := help1(1);
					help(2) := help1(0);
					help(1) := help1(7);
					help(0) := help1(6);
					f(7 downto 0) := help(7 downto 0);
					
					count_var := count_var+1;
					nx_state <= iter2;
				
				when iter2 =>
					Ln_var := Rn_1_var;
					Rn_var := Ln_1_var xor std_logic_vector(f);
					Rn_1_var := Rn_var;
					Ln_1_var := Ln_var;
					if count_var < "100000" then
						nx_state <= iter1;
					else
						rd_var := '1';
						nx_state <= stay;
					end if;
					
				when stay =>
					count_var := "000000";
					rd_var := '0';
					if main_enable'event and main_enable='1' then
						nx_state <= zero;
					else
						nx_state <= stay;
					end if;
			end case;
			L32<= Ln_var;
			R32 <= Rn_var;
			rd <= rd_var;
			count <= count_var;
			fs <= std_logic_vector(f);
			f0 <= std_logic_vector(f(31 downto 24));
			f1 <= std_logic_vector(f(23 downto 16));
			f2 <= std_logic_vector(f(15 downto 8));
			f3 <= std_logic_vector(f(7 downto 0));
		end process;
end state_machine;
