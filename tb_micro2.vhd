library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.package_memorias.ALL;

entity tb_micro2 is
end entity;

architecture sim of tb_micro2 is

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

    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal re       : std_logic := '0';
    signal we       : std_logic;
    signal addr     : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal data_in  : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal data_out : std_logic_vector(DATA_WIDTH-1 downto 0);

    constant Tclk : time := 20 ms;

begin

    -- Instancia del sistema principal
    uut : micro2
        port map (
            clk      => clk,
            rst      => rst,
            re       => re,
            we       => we,
            addr     => addr,
            data_in  => data_in,
            data_out => data_out
        );

    -- Generación del reloj
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for Tclk/2;
            clk <= '1';
            wait for Tclk/2;
        end loop;
    end process;

    -- Señales de prueba
    stim_proc : process
    begin
        -- Reset inicial
        rst <= '1';
        re  <= '0';
        wait for 60 ms;

        -- Se libera el reset y se habilita la lectura
        rst <= '0';
        re  <= '1';

        -- Tiempo de simulación para observar el funcionamiento
        wait for 3500 ms;

        -- Segundo reset para comprobar reinicio
        rst <= '1';
        wait for 60 ms;
        rst <= '0';

        wait;
    end process;

end architecture;