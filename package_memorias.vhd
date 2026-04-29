library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package package_memorias is

    constant DATA_WIDTH : positive := 8;
    constant ADDR_WIDTH :	 positive := 4;
    constant MEM_DEPTH  : positive := 2**ADDR_WIDTH;

    type state_type is (
        S0, ---- Inicio / ROM + datos
        S1, ---- Leer ROM
        S2, ---- Escribir RAM
        S3, ---- Leer RAM
        S4 ---- Enviar la salida 
    );

    component rom_sync
        generic (
            DATA_WIDTH : positive := 8;
            ADDR_WIDTH : positive := 4
        );
        port (
            clk      : in  std_logic;
            addr     : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
            data_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;

    component ram_sincrona
        generic (
            DATA_WIDTH : positive := 8;
            ADDR_WIDTH : positive := 4;
            RDW_MODE   : string := "READ_FIRST"
        );
        port (
            clk      : in  std_logic;
            rd_en    : in  std_logic := '1';
            wr_en    : in  std_logic;
            addr     : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
            data_in  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
            data_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;

end package package_memorias;

package body package_memorias is
end package body package_memorias;