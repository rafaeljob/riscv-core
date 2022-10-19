--------------------------------------------------------------------------------
-- Title       : riscv_rom_tb
-- Project     : RISCV Core
--------------------------------------------------------------------------------
-- File        : riscv_rom_tb.vhd
-- Author      : Rafael Basso
--------------------------------------------------------------------------------
-- Copyright (c) 2022 
--------------------------------------------------------------------------------
-- Description: Testbench of a simple memory ROM 
--------------------------------------------------------------------------------

library IEEE;
    use IEEE.std_logic_1164.ALL ;
    use IEEE.std_logic_arith.ALL ;
    use IEEE.std_logic_unsigned.ALL;
    use IEEE.numeric_std.all;

library WORK;
    use WORK.txt_utils_p.all;
    use WORK.RV32std_p.all;

--------------------------------------------------------------------------------
-- Entity
--------------------------------------------------------------------------------

entity riscv_rom_tb is
    generic
    (
        FILE_PATH_g     : string    				:= "../tb/riscv_rom_tb/data/data_rom_32x256.txt";
        MEM_SIZE_g      : integer                   := 256;
        DATA_WIDTH_g    : natural range 8 to 64     := 32
    );
end riscv_rom_tb;

--------------------------------------------------------------------------------
-- Architecture
--------------------------------------------------------------------------------

architecture testbench of riscv_rom_tb is

    -- Signal
    --------------------------------------

    -- TB signals
    signal running	: boolean 		:= True;
    signal done 	: std_logic 	:= '0';
    signal vld      : std_logic     := '0';

    -- DUT signals
    signal clk_i 	: std_logic 	:= '0';
    signal en_i 	: std_logic 	:= '0';

    signal addr_i 	: std_logic_vector(log2(MEM_SIZE_g) - 1 downto 0) := (others => '0');
    signal data_o 	: std_logic_vector(DATA_WIDTH_g - 1 downto 0);

begin

    ----------------------------------------------------------------------------
    -- DUT
    ----------------------------------------------------------------------------

    u_dut : entity work.riscv_rom
    generic map
    (
        FILE_PATH_g     => FILE_PATH_g,
    	MEM_SIZE_g      => MEM_SIZE_g,
        DATA_WIDTH_g    => DATA_WIDTH_g
    )
    port map
    (
    	clk_i   => clk_i,
        en_i    => en_i,
        addr_i  => addr_i,
        data_o  => data_o
    );

    ----------------------------------------------------------------------------
    -- Process : Testbench Control *DO NOT EDIT*
    ----------------------------------------------------------------------------

    p_tb_ctrl : process
    begin
        wait until done = '1';
        running <= false;
        wait;
    end process;
    
    ----------------------------------------------------------------------------
    --  Process : Clocks *DO NOT EDIT*
    ----------------------------------------------------------------------------

    p_clk : process
        constant freq_c : real := real(100e6);
    begin
        while(running) loop
            wait for 0.5*(1 sec)/freq_c;
            clk_i <= not clk_i;
        end loop;
        wait;
    end process;

    ----------------------------------------------------------------------------
    -- Process : Stimuli
    ----------------------------------------------------------------------------

    p_stm : process
    begin
        wait until rising_edge(clk_i);
        wait until rising_edge(clk_i);
        wait until rising_edge(clk_i);
        en_i <= '1';

        for i in 0 to MEM_SIZE_g - 1 loop
            wait until rising_edge(clk_i);
            vld <= '1';
            addr_i <= addr_i + 1;
        end loop;

        wait until rising_edge(clk_i);
        en_i <= '0';
        vld <= '0';
        wait;
    end process;

    ----------------------------------------------------------------------------
    -- Process : Verification
    ----------------------------------------------------------------------------

    p_ver : process
    begin
        hcontent_verify(
            clk   => clk_i,
            vld   => vld,
            data  => data_o,
            dsize => DATA_WIDTH_g,
            fpath => FILE_PATH_g
        );
        done <= '1';
        wait;
    end process;
    
end testbench;