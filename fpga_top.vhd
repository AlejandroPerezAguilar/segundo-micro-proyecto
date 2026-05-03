library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.package_memorias.ALL;

entity fpga_top is
    port (
        CLOCK_50 : in  std_logic; 	-- Reloj de 50MHz de la fpga
        KEY      : in  std_logic;	-- Boton reset 

        HEX0     : out std_logic_vector(6 downto 0); 	-- Display unidades
        HEX1     : out std_logic_vector(6 downto 0);	-- Display decenas
        HEX2     : out std_logic_vector(6 downto 0)	-- Display centenas
    );
end entity;

architecture top of fpga_top is

component divisorfreq	-- Componente que divide la frecuencia del reloj 
port(
				clk :  in std_logic;
				freq_sel      : in std_logic_vector(1 downto 0);
				clk_out      : out std_logic 
);
	 end component;
    
component micro2			-- Sistema que controla la ROM y la RAM 
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
	 
component bcd7seg		-- Convierte un numero en BCD a  señales para display 7 segmentos 
port(
				bcd : in  std_logic_vector(3 downto 0);
            seg : out std_logic_vector(6 downto 0)
);
end component;

signal clk_lento: std_logic; 	-- Reloj lento generado por el divisor 
signal rst : std_logic;			-- Señal de reset interna 

signal data_out_s : std_logic_vector (DATA_WIDTH-1 downto 0);		-- Dato que sale de micro2

signal we_s : std_logic;
signal addr_s : std_logic_vector (ADDR_WIDTH-1 downto 0);
signal data_in_s :std_logic_vector (DATA_WIDTH-1 downto 0);

signal valor : integer; 		-- Valor entero equivalente al dato de salida 
signal c: integer;
signal d: integer;
signal u: integer;

-- Centenas, decenas y unidades 

begin

rst <= NOT key; 		-- Convierte el botón en reset activo en alto (porque el botón es activo en bajo)

div : divisorfreq
	port map (
			clk      => CLOCK_50,		-- Reloj original de la fpga 
			freq_sel => "01",				-- Selecciona la velocidad del reloj
			clk_out  => clk_lento		-- Reloj mas lento 
);

sistema : micro2
  port map (
            clk      => clk_lento,	-- Usa el reloj lento
            rst      => rst,			-- Señal de reset
            re       => '1',			-- Lectura activa 
            we       => we_s,			
            addr     => addr_s,
            data_in  => data_in_s,
            data_out => data_out_s	-- Dato que se meustra en display 
        );

valor <= to_integer(unsigned(data_out_s)); 	-- Convierte el dato binario a numero entero 
		  
c <= valor/100; 					-- Obtiene las centenas 
d <= (valor mod 100) /10;		-- Obtiene las decenas  
u <= valor mod 10;				-- Obtiene las unidades

disp0 : bcd7seg		-- Muestra las unidades
        port map (
            bcd => std_logic_vector(to_unsigned(u, 4)),		-- Convierte el número a BCD de 4 bits
            seg => HEX0
        );
disp1 : bcd7seg		-- Muestra las decenas
        port map (
            bcd => std_logic_vector(to_unsigned(d, 4)),		-- Convierte el número a BCD de 4 bits
            seg => HEX1
        );

    disp2 : bcd7seg	-- Muestra las centenas 
        port map (
            bcd => std_logic_vector(to_unsigned(c, 4)),		-- Convierte el número a BCD de 4 bits
            seg => HEX2
        );		  
end architecture top;