---------------------------------------------------------------
---Project: Adder of two inputs of n bits					--- 
---															---
---Instruccions: Assign the inputs correctly.				---
---   Inputs: clk - according to FPGA Model, example 50 MHz	---
---           rst - put a botton/switch of FPGA 		   	--- 
--- 		  a,b - logic vectors of n bits with sign	   	---
---   Output: out1- Gives the arithmetic sum of a+b in a   	--- 
---    			    logic vector						   	---
---------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity adder2 is
	generic(n: integer:= 32);
	port (	
	clk,rst	:in std_logic;
	a,b		:in std_logic_vector(n-1 downto 0);
	out1	:out std_logic_vector(n-1 downto 0));
end adder2;	

Architecture arch of adder2 is  
begin
	secuential: process(rst,clk)	
	begin  
		if rst = '0' then
			out1 <= (others => '0');
		elsif (rising_edge(clk)) then
			out1 <= std_logic_vector(signed(a)+signed(b));
		end if;
	end process;
end arch;