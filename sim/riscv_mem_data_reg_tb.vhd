LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY mem_data_reg_tb IS
END mem_data_reg_tb;

ARCHITECTURE mem_data_reg_tb_arc OF mem_data_reg_tb IS
    SIGNAL clk, rst :   STD_LOGIC;
    SIGNAL d, q     :   STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    duv: ENTITY work.mem_data_reg
    PORT MAP(   clk =>  clk,
                rst =>  rst,
                d   =>  d,
                q   =>  q);
    clock_variation:PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR 5ns;
        clk <= '1';
        WAIT FOR 5ns;
    END PROCESS;
    reset_variation:PROCESS
    BEGIN
        rst <= '1';
        WAIT FOR 20ns;
        rst <= '0';
        WAIT FOR 340ns;
    END PROCESS;
    data_variation:PROCESS
        VARIABLE i  :   INTEGER RANGE 0 TO 30 := 0;
    BEGIN
        d <= (OTHERS => '0');
        WAIT FOR 30ns;
        FOR i IN 0 TO 30 LOOP
            d <= d + '1';
            WAIT FOR 10ns;
        END LOOP;
    END PROCESS;
END mem_data_reg_tb_arc;