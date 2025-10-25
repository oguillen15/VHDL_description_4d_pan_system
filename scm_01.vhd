---           rst - put a botton/switch of FPGA             --- 
--- 		  in1 - logic vector of n bits with sign        ---
---   Output: out1- Gives the arithmetic multiplication of  --- 
---                 in1*s in a logic vector                 ---
---------------------------------------------------------------
Library IEEE;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity scm_01 is
	port (
	clk, rst: in std_logic;	
	X: in std_logic_vector(31 downto 0);
	output: out std_logic_vector(31 downto 0)
	);
end scm_01;

--MULTIPLICADOR h=0.1

Architecture arch of scm_01 is 
-- 1. Creation of signals to use in the mapping
	Signal  w1, w256, w257, w1028, w771, w12336, w13107, w26214	: signed (49 downto 0);

begin
-- 2. Adjust the size of the input in1 to 56 bits 
--    by applying the resize instruction					   
	w1 <= resize(signed(X), w1'length);
-- 3. The shifts and sums of the signals are made 
--    to obtain the correct result.													  
--    The simbol "&" is used to concatenate 		
    w256		<= w1(41 downto 0)&"00000000";				               
    w257		<= w1 + w256;                                                              
	w1028		<= w257(47 downto 0)&"00";
	w771 		<= w1028 - w257;	   
	w12336 		<= w771(45 downto 0)&"0000";
	w13107 		<= w771 + w12336; 
	w26214 		<= w13107(48 downto 0)&'0';	  
	
-- 4. Secuential part	
	Process(clk, rst)
	begin
		if rst ='0'	then
			output<=(others=>'0');
		elsif (clk'event and clk='1') then
-- Select the output bits according to format used (1.e. 7.25)	
			output<=std_logic_vector(w26214(49 downto 18));  	
		end if;	
	end process;
end arch;