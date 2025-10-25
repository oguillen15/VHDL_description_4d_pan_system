---------------------------------------------------------------
---Project: Ascending Counter 0 - n                         --- 
---															---
---Instruccions: Assign the inputs correctly.				---
---   Inputs: clk - according to FPGA Model, example 50 MHz	---
---           rst - put a botton/switch of FPGA 		   	--- 
---   Output: load- Gives a high state when the count       --- 
---                 reaches n                               ---
---------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is 
	generic(n: integer:= 11);	
	port (
	clk,rst	:in std_logic;	
	load	:out std_logic:='0');
end counter;		  								 

architecture arch of counter is
begin
	secuencial: process(rst,clk)
	variable count: integer:=0;
	begin
		if rst = '0' then
			count := 0;
		elsif (rising_edge(clk)) then					 
            if count = n then
				load <= '1';
               	count := 0;
            else
			   	load <= '0';
               	count := count + 1;	
            end if;
		end if;
	end process;
end arch;