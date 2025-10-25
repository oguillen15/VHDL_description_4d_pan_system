---           rst - put a botton/switch of FPGA             --- 
--- 		  in1 - logic vector of n bits with sign        ---
---   Output: out1- Gives the arithmetic multiplication of  --- 
---                 in1*s in a logic vector                 ---
---------------------------------------------------------------
Library IEEE;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity scm_3_8 is
	port (
	clk, rst: in std_logic;	
	X: in std_logic_vector(31 downto 0);
	output: out std_logic_vector(31 downto 0)
	);
end scm_3_8;

--MULTIPLICADOR scm=3.8   18 bits de corrimiento

Architecture arch of scm_3_8 is 
-- 1. Creation of signals to use in the mapping
	Signal  w1, w65536, w65537, w262144, w327681, w4096, w331777, w256, w332033, w16, w332049, w1328196, w996147	: signed (49 downto 0);

begin
-- 2. Adjust the size of the input in1 to 56 bits 
--    by applying the resize instruction					   
	w1 <= resize(signed(X), w1'length);
-- 3. The shifts and sums of the signals are made 
--    to obtain the correct result.													  
--    The simbol "&" is used to concatenate 		
    w65536		<= w1(33 downto 0)&"0000000000000000";                                                           
	w65537		<= w1+w65536;
	w262144	    <= w1(31 downto 0)&"000000000000000000";   
	w327681 	<= w65537 + w262144;
	w4096	 	<= w1(37 downto 0)&"000000000000";  	
	w331777 	<= w327681 + w4096;
	w256 		<= w1(41 downto 0)&"00000000";	 
	w332033 	<= w331777 + w256;
	w16			<= w1(45 downto 0)&"0000";
	w332049 	<= w332033 + w16;
	w1328196	<= w332049(47 downto 0)&"00"; 
	w996147 	<= w1328196 - w332049;
	
-- 4. Secuential part	
	Process(clk, rst)
	begin
		if rst ='0'	then
			output<=(others=>'0');
		elsif (clk'event and clk='1') then
-- Select the output bits according to format used (1.e. 7.25)	
			output<=std_logic_vector(w996147(49 downto 18));  	
		end if;	
	end process;
end arch;