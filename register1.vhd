---------------------------------------------------------------
---Project: Shift Register of n bits				        --- 
---															---
---Instruccions: Assign the inputs correctly.				---
---   Inputs: clk - according to FPGA Model, example 50 MHz	---
---           rst - put a botton/switch of FPGA 		   	--- 
---            en - is the input that enable the register   --- 
--- 		    d - logic vectors of n bits                 ---
---   Output:   q - Gives d when en is enable               ---  
---------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity register1 is 		 
	generic(n       : integer := 32;
			initial : std_logic_vector := x"00147AE1");
	port ( 
	clk,rst,en	:in std_logic;		   
	d           :in std_logic_vector(n-1 downto 0);	 
	q           :out std_logic_vector(n-1 downto 0));
end register1;		 

architecture arch of register1 is 		
signal qi: std_logic_vector(n-1 downto 0);
begin
	q <= qi;
	process(clk,rst,en)	
	begin  				   
		if rst = '0' then
			qi <= initial;
		elsif (rising_edge(clk)) then 
		   	if en = '1'	then
			  	qi <= d;
		   	else
				qi <= qi;   
		   	end if;
		end if;
	end process;	 
end arch;