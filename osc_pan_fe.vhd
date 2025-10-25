-------------------------------------------------------------------------------------
----      Project: New 4-D Hyperchaotic Pan System with Curve Equilibrium Point  ----
----                                                                             ----
----      Instructions: Assign the inputs and outputs	correctly.               ----
----         Inputs: clk - according to FPGA Model, example 50 MHz               ----
----                 rst - botton/switch of FPGA                                 ----
----         Outputs: xf, yf, zf and wf - Send to Digital-Analog Converter       ----
----                  to view in a oscilloscope                                  ----
----                                                                             ----
----      IMPORTANT: Assing the initial conditions for xi,yi and zi signals      ----
----                                                                             ----
-------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  

entity osc_pan_fe is 
	generic(n: integer:= 32);	
	port (	
	clk,rst: in std_logic; 						  
	xf,yf,zf,wf: out std_logic_vector(n-1 downto 0)
	);
end osc_pan_fe;	 

architecture oscillator of osc_pan_fe is    
-- Constants 
constant h	: std_logic_vector(n-1 downto 0):= x"00000A3D";	-- Step-size = 0.001 
-- Signals declaration (All are ussing to interconect the blocks)	   
signal xi			:std_logic_vector(n-1 downto 0):=x"0000CCCD";  
signal yi			:std_logic_vector(n-1 downto 0):=x"00013333";
signal zi			:std_logic_vector(n-1 downto 0):=x"0000CCCD"; 
signal wi			:std_logic_vector(n-1 downto 0):=x"00013333";
--Initial Conditions     
signal x,y,z,w  	    						:std_logic_vector(n-1 downto 0); 
signal kx1,ky1,kz1,kw1							:std_logic_vector(n-1 downto 0); 
signal funx,funy,funz,funw,funyt1,funyt2		:std_logic_vector(n-1 downto 0); 	
signal ax1,ax2,ay1,ay2,ay3,ay4,ay5,ay6,az3		:std_logic_vector(n-1 downto 0);	
signal az1,az2,aw1,aw2,aw3,aw4,aw5,aw6,aw7,aw8	:std_logic_vector(n-1 downto 0);	  
signal en										:std_logic:='0';
-- Mapping the chaotic system
begin		 
-- Form the equation for derivate of variable x
-- dx = a(y-x)	   
U01: entity work.substractor2(arch)	generic map(n) 	port map(clk,rst,yi,xi,ax1);
U02: entity work.scm_16(arch) 		           		port map(clk,rst,ax1,funx); 
--U03: entity work.scm_01(arch) 		           		port map(clk,rst,ax2,funx);    
U04: entity work.scm_h001(arch) 					port map(clk,rst,funx,kx1);
U05: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,xi,kx1,x);		  
-- Form the equation for derivate of variable y
-- dy = cx-xz+py+w	 		  													 
U06: entity work.scm_16(arch) 		            	port map(clk,rst,xi,ay1);	   
U07: entity work.multiplier2(arch)	generic map(n) 	port map(clk,rst,xi,zi,ay2); 
U09: entity work.substractor2(arch)	generic map(n) 	port map(clk,rst,ay1,ay2,ay4); 
U13: entity work.scm_h001(arch) 					port map(clk,rst,ay4,funyt1);	
U08: entity work.scm_3_8(arch) 		            	port map(clk,rst,yi,ay3);	
U10: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,ay3,wi,ay5);   
U37: entity work.scm_h001(arch) 					port map(clk,rst,ay5,funyt2);
U38: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,funyt1,funyt2,ky1); 	
U14: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,yi,ky1,y);	
-- Form the equation for derivate of variable z	
-- dz = xy-bz				
U15: entity work.multiplier2(arch) 	generic map(n) 	port map(clk,rst,xi,yi,az1);
U16: entity work.scm_4_5(arch) 		            	port map(clk,rst,zi,az2);		
U17: entity work.substractor2(arch)	generic map(n) 	port map(clk,rst,az1,az2,funz); 
--U18: entity work.scm_01(arch) 		           		port map(clk,rst,az3,funz); 
U19: entity work.scm_h001(arch) 		            port map(clk,rst,funz,kz1);
U20: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,zi,kz1,z);	
-- Form the equation for derivate of variable w	
-- dw = cx-x3/b +py +w			
U21: entity work.scm_2222(arch) 		           	port map(clk,rst,xi,aw1);  
U22: entity work.multiplier2(arch) 	generic map(n) 	port map(clk,rst,aw1,xi,aw2);  
U23: entity work.multiplier2(arch) 	generic map(n) 	port map(clk,rst,aw2,xi,aw3); 
U24: entity work.scm_16(arch) 		           		port map(clk,rst,xi,aw4); 
U25: entity work.substractor2(arch)	generic map(n) 	port map(clk,rst,aw4,aw3,aw5);  
U26: entity work.scm_3_8(arch) 		            	port map(clk,rst,yi,aw6);	
U27: entity work.adder2(arch) 		generic map(n) 	port map(clk,rst,aw5,aw6,aw7);
U28: entity work.adder2(arch) 		generic map(n) 	port map(clk,rst,aw7,wi,funw);
--U29: entity work.scm_01(arch) 		           		port map(clk,rst,aw8,funw); 
U30: entity work.scm_h001(arch) 		            	port map(clk,rst,funw,kw1);
U31: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,wi,kw1,w);		
-- Counter and registers part
U32: entity work.counter(arch) 		generic map(25) 	  		port map(clk,rst,en);
U33: entity work.register1(arch)	generic map(n,x"0000CCCD") 	port map(clk,rst,en,x,xi);	
U34: entity work.register1(arch)	generic map(n,x"00013333") 	port map(clk,rst,en,y,yi);
U35: entity work.register1(arch)	generic map(n,x"0000CCCD") 	port map(clk,rst,en,z,zi);	   
U36: entity work.register1(arch)	generic map(n,x"00013333") 	port map(clk,rst,en,w,wi);
-- Assign the outputs trough signals 
xf <= xi;
yf <= yi;
zf <= zi;
wf <= wi;
end oscillator;