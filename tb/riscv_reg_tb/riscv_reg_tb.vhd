--------------------------------------------------------------------------------
-- Title       : riscv_reg_tb
-- Project     : RISCV Core
--------------------------------------------------------------------------------
-- File        : riscv_reg_tb.vhd
-- Author      : Rafael Basso
--------------------------------------------------------------------------------
-- Copyright (c) 2022 
--------------------------------------------------------------------------------
-- Description: Testbench of a regfile 
--------------------------------------------------------------------------------

library IEEE;
    use IEEE.std_logic_1164.ALL ;
    use IEEE.std_logic_arith.ALL ;
    use IEEE.std_logic_unsigned.ALL;
    use IEEE.numeric_std.all;

library WORK;
    use WORK.txt_utils_p.all;
    use WORK.tb_utils_p.all;
    use WORK.RV32std_p.all;

--------------------------------------------------------------------------------
-- Entity
--------------------------------------------------------------------------------

entity riscv_reg_tb is
    generic
    (
        FILE_PATH_g     : string    				:= "../tb/riscv_reg_tb/data/data_rom_32x256.txt";
        DATA_WIDTH_g    : natural range 8 to 64     := 32
    );
end riscv_reg_tb;

--------------------------------------------------------------------------------
-- Architecture
--------------------------------------------------------------------------------

architecture testbench of riscv_reg_tb is

    -- Signal
    --------------------------------------

    -- TB signals
    signal running	: boolean 		:= True;
    signal done 	: std_logic 	:= '0';
    signal vld      : std_logic     := '0';

    -- DUT signals
    signal clk_i    : std_logic     := '0';
    signal rst_i    : std_logic     := '1';

    signal wr_i     : std_logic                                     := '0';
    signal waddr_i  : std_logic_vector(4 downto 0)                  := (others => '0');
    signal wdata_i  : std_logic_vector(DATA_WIDTH_g - 1  downto 0)  := (others => '0');

    signal raddr1_i : std_logic_vector(4 downto 0)                  := (others => '0');
    signal raddr2_i : std_logic_vector(4 downto 0)                  := (others => '0');

    signal rdata1_o : std_logic_vector(DATA_WIDTH_g - 1  downto 0);
    signal rdata2_o : std_logic_vector(DATA_WIDTH_g - 1  downto 0);

begin

    ----------------------------------------------------------------------------
    -- DUT
    ----------------------------------------------------------------------------

    u_dut : entity work.riscv_reg
    generic map
    (
        DATA_WIDTH_g    => DATA_WIDTH_g
    )
    port map
    (
        clk_i    => clk_i,
        rst_i    => rst_i,
        wr_i     => wr_i,
        raddr1_i => raddr1_i,
        raddr2_i => raddr2_i,

        waddr_i  => waddr_i,
        wdata_i  => wdata_i,

        rdata1_o => rdata1_o,
        rdata2_o => rdata2_o
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
    --  Process : Clock *DO NOT EDIT*
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
    --  Process : Reset *DO NOT EDIT*
    ----------------------------------------------------------------------------

    p_rst : process
    begin
        wait for 1 us;
        wait until rising_edge(clk_i);
        rst_i <= '0';
        wait;
    end process;

    ----------------------------------------------------------------------------
    -- Process : Stimuli
    ----------------------------------------------------------------------------

    p_stm : process
    begin
        wait until falling_edge(rst_i);
        for i in 0 to 31 loop
            wait until rising_edge(clk_i);
            waddr_i <= std_logic_vector(to_unsigned(i, waddr_i'length));
            wdata_i <= std_logic_vector(to_unsigned(i+1, wdata_i'length));
            wr_i <= '1';

            wait until rising_edge(clk_i);
            wr_i <= '0';
        end loop;
        wait;
    end process;

    ----------------------------------------------------------------------------
    -- Process : Verification
    ----------------------------------------------------------------------------

    p_ver : process
    begin
        for i in 0 to 31 loop
            wait until falling_edge(wr_i);
            raddr1_i <= std_logic_vector(to_unsigned(i, raddr1_i'length));
            raddr2_i <= std_logic_vector(to_unsigned(i, raddr2_i'length));

            wait until rising_edge(clk_i);
            if(i = 0) then
                idata_compare(rdata1_o, i);
                idata_compare(rdata2_o, i);
            else
                idata_compare(rdata1_o, i+1);
                idata_compare(rdata2_o, i+1);
            end if;
        end loop;
        done <= '1';
        wait;
    end process;
    
end testbench;