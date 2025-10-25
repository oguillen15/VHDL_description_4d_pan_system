Library IEEE;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity multiplicador_016 is
	port (
	CLK, RST: in std_logic;	
	X: in std_logic_vector(31 downto 0);
	output: out std_logic_vector(31 downto 0)
	);
end multiplicador_016;

--MULTIPLICADOR 1/6

Architecture simple of multiplicador_016 is 
	 --1. Creacion de las señales 
	-- Signal x_i: signed (27 downto 0);
	Signal  w1, w4, w5, w40, w41, w41984, w41943: signed (49 downto 0);

begin
	
	--2. Ahora tenemos la variable w1 con los 56 bits 					   
	w1 <= resize(signed(X), w1'length);

	
	--3 Coemzamos a generar los corrimientos y sumas   
	-- El simbolo <<# indica corrimiento. # indica cuantos corrimeintos se realizan 
	
    w4 		<= w1(47 downto 0)&"00";				               
    w5 		<= w1 + w4;                                                              
	w40 	<= w5(46 downto 0)&"000";
	w41 	<= w1 + w40;
	w41984 	<= w41(39 downto 0)&"0000000000";   
	w41943 	<= w41984 - w41;  		
	
	
	--4. Parte secuencial del sistema
	
	Process(CLK, RST)
	begin
		if RST ='0'	then
			output<=(others=>'0');
		elsif (CLK'event  and CLK='1') then
			output<=std_logic_vector(w41943(49 downto 18));  -- Seleccionamos los bits de salida de acuerdo al 
															   -- formato utilizado (en este caso 12.20). Se realiza la conversión 
															   -- de signed a std_logic_vector
		end if;	
	end process;
end simple;