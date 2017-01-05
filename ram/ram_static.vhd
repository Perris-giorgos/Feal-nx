library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 

entity daul_port_ram is 
generic (data_width : natural := 16; 
addr_width : natural := 40); 
port ( clk_in : in std_logic;
clk_out : in std_logic;
we : in std_logic;
addr_in : in std_logic_vector( addr_width - 1 downto 0);
addr_out : in std_logic_vector( addr_width - 1 downto 0);
data_in : in std_logic_vector( data_width - 1 downto 0);
data_out : out std_logic_vector( data_width - 1 downto 0)
); 
end daul_port_ram; 

architecture daul_port_ram_arch of daul_port_ram is 

type mem_type is array (2** addr_width downto 0) of std_logic_vector( data_width - 1 downto 0) ;
signal mem : mem_type ;

begin 

mem_write : process (clk_in) 
begin 
if clk_in'event and clk_in = '1' then 
if (we = '1') then 
mem( conv_integer( addr_in)) <= data_in ; 
end if ; 
end if ; 
end process mem_write ; 

mem_read : process (clk_out) 
begin 
if clk_out'event and clk_out = '1' then 
data_out <= mem( conv_integer( addr_out)) ; 
end if ; 
end process mem_read;

end daul_port_ram_arch;