LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY reg_bank_tb IS
END reg_bank_tb;

ARCHITECTURE reg_bank_tb_arc OF reg_bank_tb IS
    SIGNAL clk, rst, regw           :   STD_LOGIC   :=  '0';
    SIGNAL rs1, rs2, rd             :   STD_LOGIC_VECTOR(4 DOWNTO 0) := (others => '0');
    SIGNAL wdata, rdata1, rdata2    :   STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
BEGIN
    duv: ENTITY work.reg_bank
    PORT MAP(   clk     =>  clk,
                rst     =>  rst,
                regw    =>  regw,
                rs1     =>  rs1,
                rs2     =>  rs2,
                rd      =>  rd,
                wdata   =>  wdata,
                rdata1  =>  rdata1,
                rdata2  =>  rdata2);
    --TEST STARTS
    clk <= NOT clk AFTER 5ns; --100MHz
    first_round:PROCESS
    BEGIN
        rst <= '1';
        WAIT FOR 20ns;
        rst <= '0';
        --Accesses all the registers
        rs2 <= rs2 + '1';
        WAIT FOR 10ns;
        FOR i IN 0 TO 30 LOOP
            rs1 <= rs1 + "10";
            rs2 <= rs2 + "10";
            WAIT FOR 10ns;
        END LOOP;
        rs1 <= (OTHERS => '0');
        rs2 <= (OTHERS => '0');
        --Writes in all registers
        regw <= '1';
        wdata <= (OTHERS => '1');
        WAIT FOR 10ns;
        FOR i IN 0 TO 30 LOOP
            rd <= rd + '1';
            --Check if regw really works
            IF i = 15 OR i = 16 THEN
                regw <= '0';
            ELSE
                regw <= '1';
            END IF;
            wdata <= wdata - '1';
            WAIT FOR 10ns;
        END LOOP;
        wdata <= (OTHERS => '0');
        regw <= '0';
        --Accesses all the registers
        rs2 <= rs2 + '1';
        WAIT FOR 10ns;
        FOR i IN 0 TO 30 LOOP
            rs1 <= rs1 + "10";
            rs2 <= rs2 + "10";
            WAIT FOR 10ns;
        END LOOP;
        rs1 <= (OTHERS => '0');
        rs2 <= (OTHERS => '0');
        --Tests write and access in the same cycle
        WAIT FOR 10ns;
        rs1 <= "00010";
        rd <= "00010";
        regw <= '1';
        wdata <= x"00000008";
        WAIT FOR 10ns;
        regw <= '0';
        --Tests reset
        WAIT FOR 10ns;
        rs1 <= (OTHERS => '0');
        rst <= '1';
        WAIT FOR 10ns;
        rst <= '0';
        rs2 <= rs2 + '1';
        WAIT FOR 10ns;
        FOR i IN 0 TO 30 LOOP
            rs1 <= rs1 + "10";
            rs2 <= rs2 + "10";
            WAIT FOR 10ns;
        END LOOP;
        rs1 <= (OTHERS => '0');
        rs2 <= (OTHERS => '0');
    END PROCESS;
END ARCHITECTURE;