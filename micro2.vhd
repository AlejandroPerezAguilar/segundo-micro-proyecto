library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.package_memorias.ALL;

entity micro2 is
    port (
        clk      : in  std_logic; -- Reloj del sistema 
        rst      : in  std_logic; -- Reset del sistema 
        re       : in  std_logic; -- Habilita la lectura de la RAM
        we       : out std_logic; -- Escritura hacia la RAM 
        addr     : out std_logic_vector(ADDR_WIDTH-1 downto 0); 	-- Direccion actual de la memoria 
        data_in  : out std_logic_vector(DATA_WIDTH-1 downto 0); 	-- Dato que se escribe en la RAM
        data_out : out std_logic_vector(DATA_WIDTH-1 downto 0)		-- Dato leido de la RAM 
    );
end entity;

architecture gg of micro2 is

    signal state_reg, state_next : state_type;
		-- state_reg: estado actual
		-- state_next: siguiente estado

    signal addr_reg  : unsigned(ADDR_WIDTH-1 downto 0) := (others => '0'); -- Guarda la direccion actual de memoria

    signal rom_data  : std_logic_vector(DATA_WIDTH-1 downto 0); 	-- Dato leido de la ROM
    signal ram_din   : std_logic_vector(DATA_WIDTH-1 downto 0); 	-- Dato que se escribe en la RAM
    signal ram_dout  : std_logic_vector(DATA_WIDTH-1 downto 0);	-- Dato leido de la RAM 

    signal wr_en_s   : std_logic := '0';	-- Control de escritura en RAM
    signal rd_en_s   : std_logic := '0';	-- Control de lectura en RAM	

begin

    u_rom : rom_sync
        generic map (
            DATA_WIDTH => DATA_WIDTH,
            ADDR_WIDTH => ADDR_WIDTH
        )
        port map (
            clk      => clk,
            addr     => std_logic_vector(addr_reg), -- Convierte 	la direccion a std_logic_vector para la ROM 
            data_out => rom_data		-- Guarda el dato leido de la ROM 
        );

    u_ram : ram_sincrona
        generic map (
            DATA_WIDTH => DATA_WIDTH, 
            ADDR_WIDTH => ADDR_WIDTH,
            RDW_MODE   => "READ_FIRST"
        )
        port map (
            clk      => clk,
            rd_en    => rd_en_s,		-- Control de lectura
            wr_en    => wr_en_s,		-- Control de escritura
            addr     => std_logic_vector(addr_reg),
            data_in  => ram_din,		-- Dato que entra a la RAM
            data_out => ram_dout		-- Dato que sale de la RAM 
        );

    -- Registro de estados
    process(clk, rst)
    begin
        if rst = '1' then
            state_reg <= S0;		-- Vuelve al estado inicial 
            addr_reg  <= (others => '0');		-- Reinicia la direccion 
            ram_din   <= (others => '0');		-- Limpia datos

        elsif rising_edge(clk) then
            state_reg <= state_next;		-- Actualiza al siguiente estado 

            if state_reg = S2 then
                ram_din <= rom_data;
            end if;

            if state_reg = S4 then
                if addr_reg = to_unsigned(MEM_DEPTH-1, ADDR_WIDTH) then
                    addr_reg <= (others => '0');
                else
                    addr_reg <= addr_reg + 1;
                end if;
            end if;
        end if;
    end process;

    -- Lógica de siguiente estado
    process(state_reg, re, addr_reg)
    begin
        state_next <= state_reg;

        case state_reg is

            when S0 =>
                state_next <= S1;

            when S1 =>
                state_next <= S2;

            when S2 =>
                state_next <= S3;

            when S3 =>
                if re = '1' then
                    state_next <= S4;
                else
                    state_next <= S3;
                end if;

            when S4 =>
                if addr_reg = to_unsigned(MEM_DEPTH-1, ADDR_WIDTH) then
                    state_next <= S0;
                else
                    state_next <= S1;
                end if;

        end case;
    end process;

    -- Lógica de salida tipo Moore
    process(state_reg, re)
    begin
        wr_en_s <= '0';
        rd_en_s <= '0';

        case state_reg is

            when S0 =>
                wr_en_s <= '0';
                rd_en_s <= '0';

            when S1 =>
                wr_en_s <= '0';
                rd_en_s <= '0';

            when S2 =>
                wr_en_s <= '1';
                rd_en_s <= '0';

            when S3 =>
                wr_en_s <= '0';
                rd_en_s <= re;

            when S4 =>
                wr_en_s <= '0';
                rd_en_s <= re;

        end case;
    end process;

    we       <= wr_en_s;
    addr     <= std_logic_vector(addr_reg);
    data_in  <= ram_din;
    data_out <= ram_dout;

end architecture;