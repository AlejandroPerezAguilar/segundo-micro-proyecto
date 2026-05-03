library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_sincrona is
  generic (
    DATA_WIDTH : positive := 8; 				-- Define el tamaño de cada dato de la RAm
    ADDR_WIDTH : positive := 4;				-- Define el tamaño de la direccion de memoria
    RDW_MODE   : string   := "READ_FIRST" -- "READ_FIRST" | "WRITE_FIRST" | "NO_CHANGE"
  );
  port (
    clk      : in  std_logic; 				-- Reloj del sistema 
    rd_en    : in  std_logic := '1'; 		-- Habilita la lectura de la RAM
    wr_en    : in  std_logic;					-- Habilita la escritura de la RAM
    addr     : in  std_logic_vector(ADDR_WIDTH-1 downto 0); -- Direccion de memoria a usar 
    data_in  : in  std_logic_vector(DATA_WIDTH-1 downto 0); -- Dato que se va a escribir en la RAM
    data_out : out std_logic_vector(DATA_WIDTH-1 downto 0)  -- Dato leido desde la RAM
  );
end entity;

architecture rtl of ram_sincrona is
  type ram_type is array (0 to 2**ADDR_WIDTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0); -- Define el tamaño de la memoria y el tamaño de cada dato
  signal mem      : ram_type; -- Señal que representa la RAM
  signal q_reg    : std_logic_vector(DATA_WIDTH-1 downto 0); -- Señal donde se guarda el dato leido
  signal addr_i   : integer range 0 to 2**ADDR_WIDTH-1; -- Señal entera que representa la direccion de la memoria 

  attribute ramstyle : string;
  attribute ramstyle of mem : signal is "M9K"; -- Hace que la ROM se implemente en la memoria interna del FPGA
begin
  addr_i <= to_integer(unsigned(addr)); -- Convierte la direccion de binario a entero 

  process(clk)
  begin
    if rising_edge(clk) then
      if wr_en = '1' then 			-- Si la escritura esta habilitada 
        mem(addr_i) <= data_in; 	-- Guarda data_in en la posición indicada por addr_i 

        if RDW_MODE = "WRITE_FIRST" then -- Si se escribe y se quiere mostrar el dato nuevo
          q_reg <= data_in; 		-- La salida toma el dato que se esta escribiendo 
			 
        elsif RDW_MODE = "READ_FIRST" then -- Si se escribe y se quiere mostrar el dato anterior
          q_reg <= mem(addr_i); -- La salida muestra el dato que estaba antes en esa dirección

        else
          null; -- NO_CHANGE
        end if;
      else
        if rd_en = '1' then 		-- Si no se escribe y la lectura esta habilitada
          q_reg <= mem(addr_i);  -- Lee la posicion indicada y guarda el dato en q_reg
        end if;
      end if;
    end if;
  end process;

  data_out <= q_reg; -- Envía el dato leído a la salida
end architecture;
