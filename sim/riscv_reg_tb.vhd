LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY reg_tb IS
END reg_tb;

ARCHITECTURE reg_tb_arc OF reg_tb IS
    CONSTANT zero       :   STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL clk, rst, en :   STD_LOGIC;
    SIGNAL d, q         :   STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    duv: ENTITY work.reg
    GENERIC MAP(rst_value => zero)
    PORT MAP(   clk =>  clk,
                rst =>  rst,
                en  =>  en,
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
    enable_variation:PROCESS
    BEGIN
        en <= '1';
        WAIT FOR 340ns;
        en <= '0';
        WAIT FOR 470ns;
    END PROCESS;
END reg_tb_arc;