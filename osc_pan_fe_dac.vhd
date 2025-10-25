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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity osc_pan_fe_dac is
    Port ( 	RST : in  STD_LOGIC;
           	CLK : in  STD_LOGIC;
			DRST: in std_logic;
			X   : out std_logic_vector(15 downto 0);
			EOW : out STD_LOGIC;
			DAC_SCLK: out STD_LOGIC;
			DAC_SYNC: out STD_LOGIC;
			DAC_DIN:  out STD_LOGIC;
			DAC_LDAC: out STD_LOGIC;
			DAC_RST:  out STD_LOGIC
			);
end osc_pan_fe_dac;

architecture Behavioral of osc_pan_fe_dac is  
--------------------------------------DAC
component	DAC7565  is
	 port(
		RST : in STD_LOGIC;
		CLK : in STD_LOGIC;
		WR : in STD_LOGIC;
		EOW : out STD_LOGIC;
		DRST : in STD_LOGIC;
		Ch0 : in STD_LOGIC_VECTOR(15 downto 0);
       	Ch1 : in STD_LOGIC_VECTOR(15 downto 0);
       	Ch2 : in STD_LOGIC_VECTOR(15 downto 0);
       	Ch3 : in STD_LOGIC_VECTOR(15 downto 0);
		DAC_SCLK : out STD_LOGIC;
		DAC_SYNC : out STD_LOGIC;
		DAC_DIN : out STD_LOGIC;
		DAC_LDAC : out STD_LOGIC;
		DAC_RST : out STD_LOGIC
	     );
end component; 
---------------------------------------Oscillator
component osc_pan_fe is 
	generic(n: integer:= 32);	
	port (	
	clk,rst: in std_logic; 						  
	xf,yf,zf,wf: out std_logic_vector(n-1 downto 0)
	);
end component;
---------------------------------------Constants		
constant 	K : std_logic_vector(12 downto 0) := "0000011111010";
constant 	zero: std_logic_vector(12 downto 0) := (others => '0');
---------------------------------------Signals
signal 		Xout, Yout, Zout, Wout		: std_logic_vector (31 downto 0);
signal      Xout16,Yout16,Zout16,Wout16	: std_logic_vector (15 downto 0);
signal 		Qi : std_logic_vector(12 downto 0);
signal 		Qii : std_logic_vector(15 downto 0);
signal 		WR,NRST : std_logic; 
---------------------------------------Mapping	
begin
  U1 : DAC7565 		port map(RST,CLK,WR,EOW,'0',Xout16,Yout16,Yout16,Zout16,DAC_SCLK,DAC_SYNC,DAC_DIN,DAC_LDAC,DAC_RST); 
  U2 : osc_pan	    port map(CLK,NRST,Xout,Yout,Zout,Wout);	
---------------------------------------Secuential part
Xout16<= Xout(31)&Xout(26 downto 12);
Yout16<= Yout(31)&Yout(26 downto 12);
Zout16<= Zout(31)&Zout(26 downto 12);  
Wout16<= Wout(31)&Wout(26 downto 12);
X <= Xout(31)&Xout(28 downto 14);	-- a Pin Planner its not neccesary for this part
  NRST <= not RST;	 
  
  	process(RST,CLK)
	begin					
		if RST = '1' then
			Qi <= (others => '0');
		elsif rising_edge(CLK) then
			if Qi = zero then
				WR <= '1';
				Qi <= K;
				Qii <= std_logic_vector(unsigned(Qii)+1);
			else
				Wr <= '0';
				Qi <= std_logic_vector(unsigned(Qi) - 1);
				Qii <= Qii;
			end if;
		end if;	
	end process;

end Behavioral;
