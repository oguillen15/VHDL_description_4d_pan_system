-----           rst - put a botton/switch of FPGA             --- 
----- 		  in1 - logic vector of n bits with sign        ---
-----   Output: out1- Gives the arithmetic multiplication of  --- 
-----                 in1*s in a logic vector                 ---
-----------------------------------------------------------------
--Library IEEE;
--Use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--
--Entity scm_2222 is
--	port (
--	clk, rst: in std_logic;	
--	X: in std_logic_vector(31 downto 0);
--	output: out std_logic_vector(31 downto 0)
--	);
--end scm_2222;
--
----MULTIPLICADOR h=0.2222
--
--Architecture arch of scm_2222 is 
---- 1. Creation of signals to use in the mapping
--	Signal  w1, w64, w65, w1040, w1039, w8320, w7281	: signed (46 downto 0);
--
--begin
---- 2. Adjust the size of the input in1 to 56 bits 
----    by applying the resize instruction					   
--	w1 <= resize(signed(X), w1'length);
---- 3. The shifts and sums of the signals are made 
----    to obtain the correct result.													  
----    The simbol "&" is used to concatenate 		
--    w64			<= w1(40 downto 0)&"000000";				               
--    w65			<= w1 + w64;                                                              
--	w1040	    <= w65(42 downto 0)&"0000";
--	w1039	   	<= w1040 - w1;  
--	w8320	    <= w65(39 downto 0)&"0000000";
--	w7281		<= w8320 - w1039;		   	 
--	
---- 4. Secuential part	
--	Process(clk, rst)
--	begin
--		if rst ='0'	then
--			output<=(others=>'0');
--		elsif (clk'event and clk='1') then
---- Select the output bits according to format used (1.e. 7.25)	
--			output<=std_logic_vector(w7281(46 downto 15));  	
--		end if;	
--	end process;
--end arch;					  


---           rst - put a botton/switch of FPGA             --- 
--- 		  in1 - logic vector of n bits with sign        ---
---   Output: out1- Gives the arithmetic multiplication of  --- 
---                 in1*s in a logic vector                 ---
---------------------------------------------------------------
Library IEEE;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity scm_2222 is
	port (
	clk, rst: in std_logic;	
	X: in std_logic_vector(31 downto 0);
	output: out std_logic_vector(31 downto 0)
	);
end scm_2222;

--MULTIPLICADOR h=0.2222

Architecture arch of scm_2222 is 
-- 1. Creation of signals to use in the mapping
	Signal  w1, w8, w7, w112, w113, w7168, w7281, w58248	: signed (49 downto 0);

begin
-- 2. Adjust the size of the input in1 to 56 bits 
--    by applying the resize instruction					   
	w1 <= resize(signed(X), w1'length);
-- 3. The shifts and sums of the signals are made 
--    to obtain the correct result.													  
--    The simbol "&" is used to concatenate 		
    w8			<= w1(46 downto 0)&"000";				               
    w7			<= w8 - w1;                                                              
	w112	    <= w7(45 downto 0)&"0000";
	w113	   	<= w1 + w112;  
	w7168	    <= w7(39 downto 0)&"0000000000";
	w7281 		<= w113 + w7168;
	w58248		<= w7281(46 downto 0)&"000";
	
-- 4. Secuential part	
	Process(clk, rst)
	begin
		if rst ='0'	then
			output<=(others=>'0');
		elsif (clk'event and clk='1') then
-- Select the output bits according to format used (1.e. 7.25)	
			output<=std_logic_vector(w58248(49 downto 18));  	
		end if;	
	end process;
end arch;