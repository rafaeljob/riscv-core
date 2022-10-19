--------------------------------------------------------------------------------
-- Title       : riscv_reg
-- Project     : RISCV Core
--------------------------------------------------------------------------------
-- File        : riscv_reg.vhd
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
    use WORK.riscv_tb_p.all;
    use WORK.RV32std_p.all;

--------------------------------------------------------------------------------
-- Entity
--------------------------------------------------------------------------------

entity riscv_reg is
    generic
    (
        DATA_WIDTH_g    : natural range 8 to 64     := 32
    );
    port
    (
        clk_i    : in    std_logic;
        rst_i    : in    std_logic;
        wr_i     : in    std_logic;
        raddr1_i : in    std_logic_vector(4 downto 0);
        raddr2_i : in    std_logic_vector(4 downto 0);

        waddr_i  : in    std_logic_vector(4 downto 0);
        wdata_i  : in    std_logic_vector(DATA_WIDTH_g - 1  downto 0);

        rdata1_o : out   std_logic_vector(DATA_WIDTH_g - 1  downto 0);
        rdata2_o : out   std_logic_vector(DATA_WIDTH_g - 1  downto 0)
    );
    
end riscv_reg;

--------------------------------------------------------------------------------
-- Architecture
--------------------------------------------------------------------------------

architecture behavioral of riscv_reg is

    -- Type
    --------------------------------------
    type regfile is array(0 to 31) of std_logic_vector(DATA_WIDTH_g - 1  downto 0);

    -- Constant
    --------------------------------------

    -- Signal
    --------------------------------------
    signal reg : regfile;
    signal wen : std_logic_vector(31 downto 0);
begin


    g_reg : for i in 0 to 31 generate

        wen(i) <= '1' when i /= 0 and waddr_i = i and wr_i = '1' else '0';
        ------------------------------------------------------------------------
        -- Reg 0
        ------------------------------------------------------------------------
        g_regx : if(i = 0) generate
            reg(i) <= (others => '0');
        ------------------------------------------------------------------------
        -- Reg 1 to 31
        ------------------------------------------------------------------------
        else generate
            process(clk_i, wen, rst_i)
            begin
                if(rising_edge(clk_i)) then
                    if(rst_i = '1') then
                        reg(i) <= (others => '0');
                    else
                        if(wen(i) = '1') then
                            reg(i) <= wdata_i;
                        end if;
                    end if;
                end if;
            end process;
        end generate g_regx;

    end generate;

    rdata1_o  <= reg(conv_integer(raddr1_i));
    rdata2_o  <= reg(conv_integer(raddr2_i));
    
end behavioral;