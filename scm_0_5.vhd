---------------------------------------------------------------
---Project: Single Constant Multiplier sigma a = 2         --- 
---                                                         ---
---Instruccions: Assign the inputs correctly.               ---
---   Inputs: clk - according to FPGA Model, example 50 MHz ---
---           rst - put a botton/switch of FPGA             --- 
--- 		  in1 - logic vector of n bits with sign        ---
---   Output: out1- Gives the arithmetic multiplication of  --- 
---                 in1*s in a logic vector                 ---
---------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity scm_0_5 is
	port (
	clk,rst	: in std_logic;	
	in1		: in std_logic_vector(31 downto 0);
	out1	: out std_logic_vector(31 downto 0));
end scm_0_5;

architecture arch of scm_0_5 is 						 
-- 1. Creation of signals to use in the mapping
	Signal  w1, w131072 	: signed (49 downto 0);												  

begin	
-- 2. Adjust the size of the input in1 to 56 bits 
--    by applying the resize instruction
	w1 <= resize(signed(in1), w1'length);  

-- 3. The shifts and sums of the signals are made 
--    to obtain the correct result.
--    The simbol "&" is used to concatenate 		
    w131072 	<= w1(32 downto 0)&"00000000000000000";
	
-- 4. Secuential part	
	Process(clk, rst)
	begin
		if rst ='0'	then
			out1<=(others=>'0');
		elsif (clk'event and clk='1') then
-- Select the output bits according to format used (1.e. 7.25)			
			out1<=std_logic_vector(w131072(49 downto 18));  
		end if;											   
	end process;
end arch;