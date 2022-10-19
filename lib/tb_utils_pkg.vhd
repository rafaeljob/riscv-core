--------------------------------------------------------------------------------
-- Title       : tb_utils_pkg
-- Project     : RISCV Core
--------------------------------------------------------------------------------
-- File        : tb_utils_pkg.vhd
-- Author      : Rafael Basso
--------------------------------------------------------------------------------
-- Copyright (c) 2022 
--------------------------------------------------------------------------------
-- Description: 
--------------------------------------------------------------------------------
library IEEE;
    use IEEE.std_logic_1164.ALL ;
    use IEEE.std_logic_arith.ALL ;
    use IEEE.std_logic_unsigned.ALL;
    use IEEE.numeric_std.all;

library STD;
    use STD.textio.all;

package tb_utils_p is

    procedure idata_compare(
        data1 : in std_logic_vector;
        data2 : in integer
    );
	
end package tb_utils_p;

package body tb_utils_p is

    ----------------------------------------------------------------------------
    -- Procedure Body
    ----------------------------------------------------------------------------

    procedure idata_compare(
        data1 : in std_logic_vector;
        data2 : in integer
    ) is
    begin
        assert data1 = std_logic_vector(to_unsigned(data2, data1'length))
        report "###ERROR : Wrong sample on data" & LF &
               "    Expected : " & "0x" & to_hex_string(std_logic_vector(to_unsigned(data2, data1'length))) & LF &
               "    Received : " & "0x" & to_hex_string(data1)  & LF
        severity error;
    end procedure;

end package body tb_utils_p;