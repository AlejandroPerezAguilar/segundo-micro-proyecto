library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_sync is
  generic (
    DATA_WIDTH : positive := 8; 		-- Numero de bits de cada dato almacenado
    ADDR_WIDTH : positive := 4 		-- Numero de bits que define el tamaño de la memoria 
  );
  port (
    clk      : in  std_logic; 		-- Reloj del sistema 
    addr     : in  std_logic_vector(ADDR_WIDTH-1 downto 0); -- Direccion de memoria a leer
    data_out : out std_logic_vector(DATA_WIDTH-1 downto 0) -- Dato leido de la ROM
  );
end entity;

architecture rtl of rom_sync is
  type rom_type is array (0 to 2**ADDR_WIDTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0); -- Define el tamaño de la memoria y el tamaño de cada dato
  constant mem : rom_type := (
    0 => x"AA" 		--	170 decimal
	 , 1 => x"55" 		--	85 decimal
	 , 2 => x"F0", 	--	240 decimal
	 3 => x"0F", 		--	15 decimal
    4 => x"FF",		--	255 decimal 
	 5 => x"00",		--	0 decimal 
    others => (others => '0') 	--	las posiciones no definidas se hacen 0
  );
  signal q_reg : std_logic_vector(DATA_WIDTH-1 downto 0); 	-- La señal guarda temporalmente el dato leido de la ROM
  signal addr_i: integer range 0 to 2**ADDR_WIDTH-1; 			-- Señal entera que representa la dirección de la memoria 

  attribute romstyle : string;
  attribute romstyle of mem : constant is "M9K"; -- Hace que la ROM se implemente en la memoria interna del FPGA
begin
  addr_i <= to_integer(unsigned(addr)); 	-- Convierte la direccion de binario a entero para acceder a la ROM

  process(clk)
  begin
    if rising_edge(clk) then
      q_reg <= mem(addr_i); 	-- Lee el dato de la ROM en la dirección indicada y lo guarda en el registro
    end if;
  end process;

  data_out <= q_reg;		--	Asigna el daato leido a la salida
end architecture;
