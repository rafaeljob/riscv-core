LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mem_data_reg IS
PORT(   clk, rst    :    IN	STD_LOGIC;
        d           :	IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
        q           :	OUT	STD_LOGIC_VECTOR(31 DOWNTO 0));
END ENTITY mem_data_reg;

ARCHITECTURE mem_data_reg_arc OF mem_data_reg IS
BEGIN
    reg: ENTITY work.reg
    PORT MAP(   clk =>  clk,
                rst =>  rst,
                en  =>  '1',
                d   =>  d,
                q   =>  q);
END mem_data_reg_arc;
