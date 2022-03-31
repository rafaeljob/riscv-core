LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY reg IS
	GENERIC(rst_value	:	STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0'));
	PORT(	clk, rst, en:	IN	STD_LOGIC;
    		d			:	IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
    		q			:	OUT	STD_LOGIC_VECTOR(31 DOWNTO 0));
END ENTITY reg;

ARCHITECTURE reg_arc OF reg IS
BEGIN
	latches:PROCESS(clk, rst)
    BEGIN
    	IF rst = '1' THEN
        	q <= rst_value;
        ELSIF rising_edge(clk) THEN
            IF en = '1' THEN
        	   q <= d;
        	END IF;
        END IF;
    END PROCESS;
END reg_arc;
