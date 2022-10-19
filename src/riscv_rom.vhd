--------------------------------------------------------------------------------
-- Title       : riscv_rom
-- Project     : RISCV Core
--------------------------------------------------------------------------------
-- File        : riscv_rom.vhd
-- Author      : Rafael Basso
--------------------------------------------------------------------------------
-- Copyright (c) 2022 
--------------------------------------------------------------------------------
-- Description: Design of a simple memory ROM initialized by the content of a
-- text file.
--------------------------------------------------------------------------------

library IEEE;
    use IEEE.std_logic_1164.ALL ;
    use IEEE.std_logic_arith.ALL ;
    use IEEE.std_logic_unsigned.ALL;
    use IEEE.numeric_std.all;

library WORK;
    --use WORK.riscv_tb_p.all;
    use WORK.RV32std_p.all;

--------------------------------------------------------------------------------
-- Entity
--------------------------------------------------------------------------------

entity riscv_rom is
    generic
    (
        FILE_PATH_g     : string                    := "../tb/riscv_rom_tb/data/data_rom_32x256.txt";
        MEM_SIZE_g      : integer                   := 256;
        DATA_WIDTH_g    : natural range 8 to 64     := 32
    );
    port
    (
        clk_i   : in    std_logic;
        en_i    : in    std_logic;
        addr_i  : in    std_logic_vector(log2(MEM_SIZE_g) - 1 downto 0);
        data_o  : out   std_logic_vector(DATA_WIDTH_g - 1  downto 0)
    );
    
end riscv_rom;

--------------------------------------------------------------------------------
-- Architecture
--------------------------------------------------------------------------------

architecture behavioral of riscv_rom is

    -- Constant
    --------------------------------------
    constant rom_c : rom_t(0 to MEM_SIZE_g - 1)(DATA_WIDTH_g - 1  downto 0) := init_hrom(FILE_PATH_g, MEM_SIZE_g, DATA_WIDTH_g);

begin

    process(clk_i, en_i)
    begin
        if(rising_edge(clk_i)) then
            if(en_i = '1') then
                data_o <= rom_c(conv_integer(addr_i));
            else
                data_o <= (others => 'Z');
            end if;
        end if;
    end process;
    
end behavioral;