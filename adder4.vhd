library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder4 is		 		 --Listo para RK4 S=A+2B+2C+D
	port (	
	CLK,RST:in std_logic;
	A,B,C,D	: 	in std_logic_vector(31 downto 0);
	S	    : 	out std_logic_vector(31 downto 0)
		);
end adder4;	

architecture arch of adder4 is
signal w1b,w67108864b,w1c,w67108864c: signed(49 downto 0);
begin
	
    w1b 		<= resize(signed(B), w1b'length);
	w67108864b 	<= w1b(30 downto 0)&"0000000000000000000";
	w1c 		<= resize(signed(C), w1c'length);
	w67108864c 	<= w1c(30 downto 0)&"0000000000000000000";

	
	secuencial: process(RST,CLK)	
	begin  
		if RST ='0' then
			S<=(others =>'0');
		elsif (rising_edge(CLK)) then
			S<=std_logic_vector(signed(A)+signed (w67108864b(49 downto 18))+signed (w67108864c(49 downto 18))+signed(D));
		end if;
	end process;

end arch;