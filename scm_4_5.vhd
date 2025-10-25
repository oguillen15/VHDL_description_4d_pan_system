-----           rst - put a botton/switch of FPGA             --- 
----- 		  in1 - logic vector of n bits with sign        ---
-----   Output: out1- Gives the arithmetic multiplication of  --- 
-----                 in1*s in a logic vector                 ---
-----------------------------------------------------------------
--Library IEEE;
--Use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--
--Entity scm_4_5 is
--	port (
--	clk, rst: in std_logic;	
--	X: in std_logic_vector(31 downto 0);
--	output: out std_logic_vector(31 downto 0)
--	);
--end scm_4_5;
--
----MULTIPLICADOR scm=4.5   16 bits de corrimiento
--
--Architecture arch of scm_4_5 is 
---- 1. Creation of signals to use in the mapping
--	Signal  w1, w8, w9, w147456	: signed (46 downto 0);
--
--begin
---- 2. Adjust the size of the input in1 to 56 bits 
----    by applying the resize instruction					   
--	w1 <= resize(signed(X), w1'length);
---- 3. The shifts and sums of the signals are made 
----    to obtain the correct result.													  
----    The simbol "&" is used to concatenate 		
--    w8			<= w1(43 downto 0)&"000";                                                           
--	w9			<= w1+w8;
--	w147456	 	<= w9(32 downto 0)&"00000000000000";   
--
---- 4. Secuential part	
--	Process(clk, rst)
--	begin
--		if rst ='0'	then
--			output<=(others=>'0');
--		elsif (clk'event and clk='1') then
---- Select the output bits according to format used (1.e. 7.25)	
--			output<=std_logic_vector(w147456(46 downto 15));  	
--		end if;	
--	end process;
--end arch;	  

--
---           rst - put a botton/switch of FPGA             --- 
--- 		  in1 - logic vector of n bits with sign        ---
---   Output: out1- Gives the arithmetic multiplication of  --- 
---                 in1*s in a logic vector                 ---
---------------------------------------------------------------
Library IEEE;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity scm_4_5 is
	port (
	clk, rst: in std_logic;	
	X: in std_logic_vector(31 downto 0);
	output: out std_logic_vector(31 downto 0)
	);
end scm_4_5;

--MULTIPLICADOR scm=4.5   16 bits de corrimiento

Architecture arch of scm_4_5 is 
-- 1. Creation of signals to use in the mapping
	Signal  w1, w8, w9, w1179648	: signed (49 downto 0);

begin
-- 2. Adjust the size of the input in1 to 56 bits 
--    by applying the resize instruction					   
	w1 <= resize(signed(X), w1'length);
-- 3. The shifts and sums of the signals are made 
--    to obtain the correct result.													  
--    The simbol "&" is used to concatenate 		
    w8			<= w1(46 downto 0)&"000";                                                           
	w9			<= w1+w8;
	w1179648	<= w9(32 downto 0)&"00000000000000000";   

-- 4. Secuential part	
	Process(clk, rst)
	begin
		if rst ='0'	then
			output<=(others=>'0');
		elsif (clk'event and clk='1') then
-- Select the output bits according to format used (1.e. 7.25)	
			output<=std_logic_vector(w1179648(49 downto 18));  	
		end if;	
	end process;
end arch;