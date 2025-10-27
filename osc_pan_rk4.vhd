-------------------------------------------------------------------------------------
----      Project: New 4-D Hyperchaotic Pan System with Curve Equilibrium Point  ----
----               solved with 4th order Runge-Kutta                             ----
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

entity osc_pan_rk4 is 
	generic(n: integer:= 32);	
	port (	
	clk,rst: in std_logic; 						  
	xf,yf,zf,wf: out std_logic_vector(n-1 downto 0)
	);
end osc_pan_rk4;	 

architecture oscillator of osc_pan_rk4 is    
-- Constants 
constant h	: std_logic_vector(n-1 downto 0):= x"00000419";	-- Step-size = 0.001  
-- Signals declaration (All are ussing to interconect the blocks)	   
signal xi,xi2,xi3,xi4	:std_logic_vector(n-1 downto 0):=x"0000CCCD";  
signal yi,yi2,yi3,yi4	:std_logic_vector(n-1 downto 0):=x"00013333";
signal zi,zi2,zi3,zi4	:std_logic_vector(n-1 downto 0):=x"0000CCCD"; 
signal wi,wi2,wi3,wi4	:std_logic_vector(n-1 downto 0):=x"00013333";
--Initial Conditions     
signal x,y,z,w  	    														:std_logic_vector(n-1 downto 0); 
signal kx1,ky1,kz1,kw1,kx2,ky2,kz2,kw2,kx3,ky3,kz3,kw3,kx4,ky4,kz4,kw4			:std_logic_vector(n-1 downto 0); 
signal funx1,funy1,funz1,funw1,funx2,funy2,funz2,funw2							:std_logic_vector(n-1 downto 0); 
signal funx3,funy3,funz3,funw3,funx4,funy4,funz4,funw4							:std_logic_vector(n-1 downto 0);
signal ax1,ax2,ax12,ax32,ax13,ax14												:std_logic_vector(n-1 downto 0);
signal ay1,ay2,ay3,ay4,ay5,ay6,ay62,ay12,ay22,ay32,ay42,ay52					:std_logic_vector(n-1 downto 0);
signal ay13,ay23,ay33,ay43,ay53,ay14,ay24,ay34,ay44,ay54						:std_logic_vector(n-1 downto 0);
signal az1,az2,az3,az12,az22,az32,az13,az23,az14,az24							:std_logic_vector(n-1 downto 0);	
signal aw1,aw2,aw3,aw4,aw5,aw6,aw7,aw8,aw12,aw22,aw32,aw42,aw52,aw62,aw72,aw82	:std_logic_vector(n-1 downto 0);
signal aw13,aw23,aw33,aw43,aw53,aw63,aw73,aw14,aw24,aw34,aw44,aw54,aw64,aw74	:std_logic_vector(n-1 downto 0);
signal en																		:std_logic:='0';	 
signal sum4x_mul016x,sum4y_mul016y,sum4z_mul016z,sum4w_mul016w					:std_logic_vector(n-1 downto 0);
signal mul016x_sum4,mul016y_sum5,mul016z_sum6,mul016w_sum7						:std_logic_vector(n-1 downto 0);	
-- Mapping the chaotic system
begin		 
-- Form the equation for derivate of variable x
-- dx = 	   
U01: entity work.substractor2(arch)	generic map(n) 	port map(clk,rst,yi,xi,ax1);
U02: entity work.scm_16(arch) 		           		port map(clk,rst,ax1,funx1); 	
U03: entity work.scm_h001(arch) 					port map(clk,rst,funx1,kx1);
	
U04: entity work.scm_0_5(arch) 		           		port map(clk,rst,kx1,ax2); 	
U05: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,xi,ax2,xi2);		
	
U06: entity work.substractor2(arch)	generic map(n) 	port map(clk,rst,yi2,xi2,ax12);
U07: entity work.scm_16(arch) 		           		port map(clk,rst,ax12,funx2);  
U08: entity work.scm_h001(arch) 						port map(clk,rst,funx2,kx2);

U09: entity work.scm_0_5(arch) 						port map(clk,rst,kx2,ax32);  
U10: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,xi,ax32,xi3); 

U11: entity work.substractor2(arch)	generic map(n) 	port map(clk,rst,yi3,xi3,ax13);
U12: entity work.scm_16(arch) 		           		port map(clk,rst,ax13,funx3); 	
U13: entity work.scm_h001(arch) 						port map(clk,rst,funx3,kx3);

U14: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,xi,kx3,xi4); 
	
U15: entity work.substractor2(arch)	generic map(n) 	port map(clk,rst,yi4,xi4,ax14);
U16: entity work.scm_16(arch) 		           		port map(clk,rst,ax14,funx4);  
U17: entity work.scm_h001(arch) 						port map(clk,rst,funx4,kx4);	

-- Form the equation for derivate of variable y
--	 		  
U18: entity work.scm_16(arch) 		            	port map(clk,rst,xi,ay1);	   
U19: entity work.multiplier2(arch)	generic map(n) 	port map(clk,rst,xi,zi,ay2); 	
U20: entity work.scm_3_8(arch) 		            	port map(clk,rst,yi,ay3);	
U21: entity work.substractor2(arch)	generic map(n) 	port map(clk,rst,ay1,ay2,ay4); 
U22: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,ay3,ay4,ay5); 
U23: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,ay5,wi,funy1);	
U24: entity work.scm_h001(arch) 						port map(clk,rst,funy1,ky1);	
	
U25: entity work.scm_0_5(arch) 		           		port map(clk,rst,ky1,ay6); 	
U26: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,yi,ay6,yi2);	

U27: entity work.scm_16(arch) 		            	port map(clk,rst,xi2,ay12);	   
U28: entity work.multiplier2(arch)	generic map(n) 	port map(clk,rst,xi2,zi2,ay22); 	
U29: entity work.scm_3_8(arch) 		            	port map(clk,rst,yi2,ay32);	
U30: entity work.substractor2(arch)	generic map(n) 	port map(clk,rst,ay12,ay22,ay42); 
U31: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,ay32,ay42,ay52); 
U32: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,ay52,wi2,funy2);	
U33: entity work.scm_h001(arch) 						port map(clk,rst,funy2,ky2);	
	
U34: entity work.scm_0_5(arch) 		           		port map(clk,rst,ky2,ay62); 	
U35: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,yi,ay62,yi3);

U36: entity work.scm_16(arch) 		            	port map(clk,rst,xi3,ay13);	   
U37: entity work.multiplier2(arch)	generic map(n) 	port map(clk,rst,xi3,zi3,ay23); 	
U38: entity work.scm_3_8(arch) 		            	port map(clk,rst,yi3,ay33);	
U39: entity work.substractor2(arch)	generic map(n) 	port map(clk,rst,ay13,ay23,ay43); 
U40: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,ay33,ay43,ay53); 
U41: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,ay53,wi3,funy3);  
U42: entity work.scm_h001(arch) 						port map(clk,rst,funy3,ky3);	
																			   	
U43: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,yi,ky3,yi4);  

U44: entity work.scm_16(arch) 		            	port map(clk,rst,xi4,ay14);	   
U45: entity work.multiplier2(arch)	generic map(n) 	port map(clk,rst,xi4,zi4,ay24); 	
U46: entity work.scm_3_8(arch) 		            	port map(clk,rst,yi4,ay34);	
U47: entity work.substractor2(arch)	generic map(n) 	port map(clk,rst,ay14,ay24,ay44); 
U48: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,ay34,ay44,ay54);
U49: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,ay54,wi4,funy4);
U50: entity work.scm_h001(arch) 						port map(clk,rst,funy4,ky4);
-- Form the equation for derivate of variable z	
-- dz = 					
U51: entity work.multiplier2(arch) 	generic map(n) 	port map(clk,rst,xi,yi,az1);
U52: entity work.scm_4_5(arch) 		            	port map(clk,rst,zi,az2);		
U53: entity work.substractor2(arch)	generic map(n) 	port map(clk,rst,az1,az2,funz1);
U54: entity work.scm_h001(arch) 		            	port map(clk,rst,funz1,kz1);
	
U55: entity work.scm_0_5(arch) 		           		port map(clk,rst,kz1,az3); 	
U56: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,zi,az3,zi2);	

U57: entity work.multiplier2(arch) 	generic map(n) 	port map(clk,rst,xi2,yi2,az12);
U58: entity work.scm_4_5(arch) 		            	port map(clk,rst,zi2,az22);		
U59: entity work.substractor2(arch)	generic map(n) 	port map(clk,rst,az12,az22,funz2);
U60: entity work.scm_h001(arch) 		            	port map(clk,rst,funz2,kz2);
	
U61: entity work.scm_0_5(arch) 		           		port map(clk,rst,kz2,az32); 	
U62: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,zi,az32,zi3);
	
U63: entity work.multiplier2(arch) 	generic map(n) 	port map(clk,rst,xi3,yi3,az13);
U64: entity work.scm_4_5(arch) 		            	port map(clk,rst,zi3,az23);		
U65: entity work.substractor2(arch)	generic map(n) 	port map(clk,rst,az13,az23,funz3);	
U66: entity work.scm_h001(arch) 		            	port map(clk,rst,funz3,kz3);
																				  	
U67: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,zi,kz3,zi4); 
	
U68: entity work.multiplier2(arch) 	generic map(n) 	port map(clk,rst,xi4,yi4,az14);
U69: entity work.scm_4_5(arch) 		            	port map(clk,rst,zi4,az24);		
U70: entity work.substractor2(arch)	generic map(n) 	port map(clk,rst,az14,az24,funz4); 
U71: entity work.scm_h001(arch) 		            	port map(clk,rst,funz4,kz4);
-- Form the equation for derivate of variable w	
-- dw = 					
U72: entity work.scm_2222(arch) 		           	port map(clk,rst,xi,aw1);  
U73: entity work.multiplier2(arch) 	generic map(n) 	port map(clk,rst,aw1,xi,aw2);  
U74: entity work.multiplier2(arch) 	generic map(n) 	port map(clk,rst,aw2,xi,aw3); 
U75: entity work.scm_16(arch) 		           		port map(clk,rst,xi,aw4); 
U76: entity work.substractor2(arch)	generic map(n) 	port map(clk,rst,aw4,aw3,aw5);  
U77: entity work.scm_3_8(arch) 		            	port map(clk,rst,yi,aw6);	
U78: entity work.adder2(arch) 		generic map(n) 	port map(clk,rst,aw5,aw6,aw7);
U79: entity work.adder2(arch) 		generic map(n) 	port map(clk,rst,aw7,wi,funw1);  
U80: entity work.scm_h001(arch) 		            	port map(clk,rst,funw1,kw1);

U81: entity work.scm_0_5(arch) 		           		port map(clk,rst,kw1,aw8); 	
U82: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,wi,aw8,wi2);	

U83: entity work.scm_2222(arch) 		           	port map(clk,rst,xi2,aw12);  
U84: entity work.multiplier2(arch) 	generic map(n) 	port map(clk,rst,aw12,xi2,aw22);  
U85: entity work.multiplier2(arch) 	generic map(n) 	port map(clk,rst,aw22,xi2,aw32); 
U86: entity work.scm_16(arch) 		           		port map(clk,rst,xi2,aw42); 
U87: entity work.substractor2(arch)	generic map(n) 	port map(clk,rst,aw42,aw32,aw52);  
U88: entity work.scm_3_8(arch) 		            	port map(clk,rst,yi2,aw62);	
U89: entity work.adder2(arch) 		generic map(n) 	port map(clk,rst,aw52,aw62,aw72);
U90: entity work.adder2(arch) 		generic map(n) 	port map(clk,rst,aw72,wi2,funw2);
U91: entity work.scm_h001(arch) 		            	port map(clk,rst,funw2,kw2);

U92: entity work.scm_0_5(arch) 		           		port map(clk,rst,kw2,aw82); 	
U93: entity work.adder2(arch)		generic map(n) 	port map(clk,rst,wi,aw82,wi3); 
	
U94: entity work.scm_2222(arch) 		           	port map(clk,rst,xi3,aw13);  
U95: entity work.multiplier2(arch) 	generic map(n) 	port map(clk,rst,aw13,xi3,aw23);  
U96: entity work.multiplier2(arch) 	generic map(n) 	port map(clk,rst,aw23,xi3,aw33); 
U97: entity work.scm_16(arch) 		           		port map(clk,rst,xi3,aw43); 
U98: entity work.substractor2(arch)	generic map(n) 	port map(clk,rst,aw43,aw33,aw53);  
U99: entity work.scm_3_8(arch) 		            	port map(clk,rst,yi3,aw63);	
U100:entity work.adder2(arch) 		generic map(n) 	port map(clk,rst,aw53,aw63,aw73);
U101:entity work.adder2(arch) 		generic map(n) 	port map(clk,rst,aw73,wi3,funw3);
U102:entity work.scm_h001(arch) 		            	port map(clk,rst,funw3,kw3);
																				   
U104:entity work.adder2(arch)		generic map(n) 	port map(clk,rst,wi,kw3,wi4);  
	
U105:entity work.scm_2222(arch) 		           	port map(clk,rst,xi4,aw14);  
U106:entity work.multiplier2(arch) 	generic map(n) 	port map(clk,rst,aw14,xi4,aw24);  
U107:entity work.multiplier2(arch) 	generic map(n) 	port map(clk,rst,aw24,xi4,aw34); 
U108:entity work.scm_16(arch) 		           		port map(clk,rst,xi4,aw44); 
U109:entity work.substractor2(arch)	generic map(n) 	port map(clk,rst,aw44,aw34,aw54);  
U110:entity work.scm_3_8(arch) 		            	port map(clk,rst,yi4,aw64);	
U111:entity work.adder2(arch) 		generic map(n) 	port map(clk,rst,aw54,aw64,aw74);
U112:entity work.adder2(arch) 		generic map(n) 	port map(clk,rst,aw74,wi4,funw4); 
U113:entity work.scm_h001(arch) 		            	port map(clk,rst,funw4,kw4);   
	
---RK4 integration
U114:entity work.adder4(arch)								port map(clk,rst,kx1,kx2,kx3,kx4,sum4x_mul016x);
U115:entity work.multiplicador_016(simple)					port map(clk,rst,sum4x_mul016x,mul016x_sum4);
U116:entity work.adder2(arch)				generic map(n) 	port map(clk,rst,xi,mul016x_sum4,x);

U117:entity work.adder4(arch)								port map(clk,rst,ky1,ky2,ky3,ky4,sum4y_mul016y);
U118:entity work.scm1_016(simple)					port map(clk,rst,sum4y_mul016y,mul016y_sum5);
U119:entity work.adder2(arch)				generic map(n) 	port map(clk,rst,yi,mul016y_sum5,y);

U120:entity work.adder4(arch)								port map(clk,rst,kz1,kz2,kz3,kz4,sum4z_mul016z);
U121:entity work.scm1_016(simple)					port map(clk,rst,sum4z_mul016z,mul016z_sum6);
U122:entity work.adder2(arch)				generic map(n) 	port map(clk,rst,zi,mul016z_sum6,z);	 

U123:entity work.adder4(arch)								port map(clk,rst,kw1,kw2,kw3,kw4,sum4w_mul016w);
U124:entity work.scm1_016(simple)					port map(clk,rst,sum4w_mul016w,mul016w_sum7);
U125:entity work.adder2(arch)				generic map(n) 	port map(clk,rst,wi,mul016w_sum7,w);	
	
	
-- Counter and registers part
U126:entity work.counter(arch) 		generic map(60) 	  		port map(clk,rst,en);
U127:entity work.register1(arch)	generic map(n,x"0000CCCD") 	port map(clk,rst,en,x,xi);	
U128:entity work.register1(arch)	generic map(n,x"00013333") 	port map(clk,rst,en,y,yi);
U129:entity work.register1(arch)	generic map(n,x"0000CCCD") 	port map(clk,rst,en,z,zi);	   
U130:entity work.register1(arch)	generic map(n,x"00013333") 	port map(clk,rst,en,w,wi);
-- Assign the outputs trough signals 
xf <= xi;
yf <= yi;
zf <= zi;
wf <= wi;

end oscillator;
