-----------------------------------------------------------------
-----Project: Single Constant Multiplier  h =  0.001            --- 
-----                                                         ---
-----Instruccions: Assign the inputs correctly.               ---
-----   Inputs: clk - according to FPGA Model, example 50 MHz ---
-----           rst - put a botton/switch of FPGA             --- 
----- 		  in1 - logic vector of n bits with sign        ---
-----   Output: out1- Gives the arithmetic multiplication of  --- 
-----                 in1*s in a logic vector                 ---
-----------------------------------------------------------------
--Library IEEE;
--Use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--
--Entity scm_h001 is
--	port (
--	clk, rst: in std_logic;	
--	X: in std_logic_vector(31 downto 0);
--	output: out std_logic_vector(31 downto 0)
--	);
--end scm_h001;
--
----MULTIPLICADOR h=0.001
--
--Architecture arch of scm_h001 is 
---- 1. Creation of signals to use in the mapping
--	Signal  w1, w32	: signed (46 downto 0);
--
--begin
---- 2. Adjust the size of the input in1 to 56 bits 
----    by applying the resize instruction					   
--	w1 <= resize(signed(X), w1'length);
---- 3. The shifts and sums of the signals are made 
----    to obtain the correct result.													  
----    The simbol "&" is used to concatenate 		
--    w32			<= w1(41 downto 0)&"00000";		                                                       
--	
--		   
--
---- 4. Secuential part	
--	Process(clk, rst)
--	begin
--		if rst ='0'	then
--			output<=(others=>'0');
--		elsif (clk'event and clk='1') then
---- Select the output bits according to format used (1.e. 7.25)	
--			output<=std_logic_vector(w32(46 downto 15));  	
--		end if;	
--	end process;
--end arch;		

---------------------------------------------------------------
---Project: Single Constant Multiplier  h =  0.001            --- 
---                                                         ---
---Instruccions: Assign the inputs correctly.               ---
---   Inputs: clk - according to FPGA Model, example 50 MHz ---
---           rst - put a botton/switch of FPGA             --- 
--- 		  in1 - logic vector of n bits with sign        ---
---   Output: out1- Gives the arithmetic multiplication of  --- 
---                 in1*s in a logic vector                 ---
---------------------------------------------------------------
Library IEEE;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity scm_h001 is
	port (
	clk, rst: in std_logic;	
	X: in std_logic_vector(31 downto 0);
	output: out std_logic_vector(31 downto 0)
	);
end scm_h001;

--MULTIPLICADOR h=0.001

Architecture arch of scm_h001 is 
-- 1. Creation of signals to use in the mapping
	Signal  w1, w32, w33, w132, w131, w262	: signed (49 downto 0);

begin
-- 2. Adjust the size of the input in1 to 56 bits 
--    by applying the resize instruction					   
	w1 <= resize(signed(X), w1'length);
-- 3. The shifts and sums of the signals are made 
--    to obtain the correct result.													  
--    The simbol "&" is used to concatenate 		
    w32			<= w1(44 downto 0)&"00000";		                                                       
	w33 		<= w1 + w32;
	w132		<= w33(47 downto 0)&"00";		   
    w131 		<= w132 - w1; 
	w262		<= w131(48 downto 0)&'0';	
	
-- 4. Secuential part	
	Process(clk, rst)
	begin
		if rst ='0'	then
			output<=(others=>'0');
		elsif (clk'event and clk='1') then
-- Select the output bits according to format used (1.e. 7.25)	
			output<=std_logic_vector(w262(49 downto 18));  	
		end if;	
	end process;
end arch;