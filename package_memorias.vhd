library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package package_memorias is 	-- Inicio del paquete donde se declaran constantes, tipos y componentes

    constant DATA_WIDTH : positive := 8; 		-- Define el tamaño de los datos: 8 bits
    constant ADDR_WIDTH :	 positive := 4;	-- Define el tamaño de la direccion: 4 bits
    constant MEM_DEPTH  : positive := 2**ADDR_WIDTH; -- Calcula la cantidad de posiciones de memoria

    type state_type is (
        S0, ---- Inicio / ROM + datos
        S1, ---- Leer ROM
        S2, ---- Escribir RAM
        S3, ---- Leer RAM
        S4 ---- Enviar la salida 
    );

    component rom_sync 	-- Declaracion del componente ROM para usarlo en otros modulos 
        generic ( 		-- Parametros configurables de la ROM
            DATA_WIDTH : positive := 8; -- Tamaño de cada dato de la ROM 
            ADDR_WIDTH : positive := 4 -- Parámetros configurables de la ROM
        );
        port (
            clk      : in  std_logic; -- Reloj de la ROM
            addr     : in  std_logic_vector(ADDR_WIDTH-1 downto 0); 	-- Direccion que indica que posicion de la ROM se lee 
            data_out : out std_logic_vector(DATA_WIDTH-1 downto 0) 	-- Dato leido desde la ROM
        );
    end component; --Fin del componente ROM 

    component ram_sincrona -- Declaracion del componente RAM para usarlo en otros modulos 
        generic (				--parametros configurables de la RAM 
            DATA_WIDTH : positive := 8;  	-- Tamaño de cada dato de la RAM
            ADDR_WIDTH : positive := 4;	-- Tamaño de la direccion de la RAM
            RDW_MODE   : string := "READ_FIRST" -- Lectura/escritura cuando ocurren en el mismo ciclo 
        );
        port (
            clk      : in  std_logic;			-- Reloj de la RAM
            rd_en    : in  std_logic := '1'; -- Habilita la lectura de la RAM
            wr_en    : in  std_logic;			-- Habilita la escritura de la RAM
            addr     : in  std_logic_vector(ADDR_WIDTH-1 downto 0); 	-- Direccion donde se lee o se escribe 
            data_in  : in  std_logic_vector(DATA_WIDTH-1 downto 0); 	-- Dato que se escribe en la RAM 
            data_out : out std_logic_vector(DATA_WIDTH-1 downto 0)	-- Dato leido desde la RAM
        );
    end component; -- Fin del componente RAM 	

end package package_memorias; -- Fin del paquete 

package body package_memorias is
				-- El package body queda vacio porque no hay funciones ni procedimientos que desarrollar 
end package body package_memorias;