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
	Signal  w1, w256, w257, w2056, w2057, w64, w321, w16456, w16777: signed (51 downto 0);

begin
	
	--2. Ahora tenemos la variable w1 con los 56 bits 					   
	w1 <= resize(signed(X), w1'length);

	
	--3 Coemzamos a generar los corrimientos y sumas   
	-- El simbolo <<# indica corrimiento. # indica cuantos corrimeintos se realizan 
	
    w256 	<= w1(43 downto 0)&"00000000";				               
    w257 	<= w1 + w256;                                                              
	w2056 	<= w257(48 downto 0)&"000";
	w2057 	<= w1 + w2056;
	w64 	<= w1(45 downto 0)&"000000";   
	w321 	<= w257 + w64;	  
	w16456 	<= w2057(48 downto 0)&"000"; 
	w16777  <= w321 + w16456;
	
	
	--4. Parte secuencial del sistema
	
	Process(CLK, RST)
	begin
		if RST ='0'	then
			output<=(others=>'0');
		elsif (CLK'event  and CLK='1') then
			output<=std_logic_vector(w16777(51 downto 20));  -- Seleccionamos los bits de salida de acuerdo al 
															   -- formato utilizado (en este caso 12.20). Se realiza la conversión 
															   -- de signed a std_logic_vector
		end if;	
	end process;
end simple;