LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY reg_bank IS
    PORT(   clk, rst, regw  :   IN  STD_LOGIC;
            rs1, rs2, rd    :   IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
            wdata           :   IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            rdata1, rdata2  :   OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END reg_bank;

ARCHITECTURE reg_bank_arc OF reg_bank IS
    TYPE bank IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reg  :   bank;
    SIGNAL wen  :   STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    g_bank: FOR i IN 0 TO 31 GENERATE
        wen(i) <= '1' WHEN rd = i AND regw = '1' ELSE '0';
        generic_reg: ENTITY work.reg
            GENERIC MAP(rst_value   =>  (others => '0'))
            PORT MAP(   clk         =>  clk,
                        rst         =>  rst,
                        en          =>  wen(i),
                        d           =>  wdata,
                        q           =>  reg(i));
    END GENERATE g_bank;
    rdata1  <= reg(CONV_INTEGER(rs1));
    rdata2  <= reg(CONV_INTEGER(rs2));
END reg_bank_arc;