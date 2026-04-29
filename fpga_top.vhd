library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.package_memorias.ALL;

entity fpga_top is
    port (
        CLOCK_50 : in  std_logic;
        KEY      : in  std_logic;

        HEX0     : out std_logic_vector(6 downto 0);
        HEX1     : out std_logic_vector(6 downto 0);
        HEX2     : out std_logic_vector(6 downto 0)
    );
end entity;

architecture top of fpga_top is

component divisorfreq
port(
				clk :  in std_logic;
				freq_sel      : in std_logic_vector(1 downto 0);
				clk_out      : out std_logic 
);
	 end component;
    
component micro2
port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            re       : in  std_logic;
            we       : out std_logic;
            addr     : out std_logic_vector(ADDR_WIDTH-1 downto 0);
            data_in  : out std_logic_vector(DATA_WIDTH-1 downto 0);
            data_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;	
	 
component bcd7seg
port(
				bcd : in  std_logic_vector(3 downto 0);
            seg : out std_logic_vector(6 downto 0)
);
end component;

signal clk_lento: std_logic;
signal rst : std_logic;

signal data_out_s : std_logic_vector (DATA_WIDTH-1 downto 0);

signal we_s : std_logic;
signal addr_s : std_logic_vector (ADDR_WIDTH-1 downto 0);
signal data_in_s :std_logic_vector (DATA_WIDTH-1 downto 0);

signal valor : integer;
signal c: integer;
signal d: integer;
signal u: integer;

begin

rst <= NOT key;

div : divisorfreq
	port map (
			clk      => CLOCK_50,
			freq_sel => "10",
			clk_out  => clk_lento
);

sistema : micro2
  port map (
            clk      => clk_lento,
            rst      => rst,
            re       => '1',
            we       => we_s,
            addr     => addr_s,
            data_in  => data_in_s,
            data_out => data_out_s
        );

valor <= to_integer(unsigned(data_out_s));
		  
c <= valor/100;
d <= (valor mod 100) /10;
u <= valor mod 10;

disp0 : bcd7seg
        port map (
            bcd => std_logic_vector(to_unsigned(u, 4)),
            seg => HEX0
        );
disp1 : bcd7seg
        port map (
            bcd => std_logic_vector(to_unsigned(d, 4)),
            seg => HEX1
        );

    disp2 : bcd7seg
        port map (
            bcd => std_logic_vector(to_unsigned(c, 4)),
            seg => HEX2
        );		  
end architecture top;