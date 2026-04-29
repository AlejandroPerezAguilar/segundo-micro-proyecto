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
port()
				clk : std_logic;
				freq_sel      : std_logic_vector(1 downto 0);
				clk_out      : std_logic ;
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