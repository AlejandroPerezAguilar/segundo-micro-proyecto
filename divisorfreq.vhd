library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 

entity divisorfreq is 
    port(
        clk      : in  std_logic; -- Reloj de la FPGA
        freq_sel : in  std_logic_vector(1 downto 0); -- Selector de frecuencia
        clk_out  : out std_logic -- Reloj de salida dividido
    );
end entity divisorfreq;

architecture ll of divisorfreq is --Inicio de la arquitectura de la entidad divisorfreq

    -- Señales internas

    signal cuenta   : integer := 0; -- Contador de ciclos del reloj principal
    signal divisor  : integer := 25000000; -- Valor máximo para dividir la frecuencia
    signal clk_aux  : std_logic := '0'; -- Señal auxiliar del reloj dividido

begin

    -- Selección del divisor según freq_sel

    divisor <= 25000000 when freq_sel = "00" else -- Frecuencia más baja (1 Hz)
               12500000 when freq_sel = "01" else -- Frecuencia un poco mayor (2 Hz)
               6250000 when freq_sel = "10" else -- Frecuencia aún mayor (4 Hz)
               3125000;  -- Frecuencia más alta (8 Hz)

    -- Proceso del divisor de frecuencia

    process(clk)
    begin
        if rising_edge(clk) then
            if cuenta >= divisor then -- Si el contador llega al divisor
                cuenta  <= 0; -- Reinicia la cuenta
                clk_aux <= not clk_aux; -- Cambia el estado de la salida
            else
                cuenta <= cuenta + 1; -- Sigue contando
            end if;
        end if;
    end process; --Finalización del process

    -- Salida del reloj dividido

    clk_out <= clk_aux; -- La salida toma el valor de clk_aux

end architecture ll; --Finalización de la arquitectura