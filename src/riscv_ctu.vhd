----------------------------------------------------------------------------------
-- Dev by: Rafael Basso
-- 
-- Create Date: 10.03.2022 
-- Module Name: riscv_ctu - control_unit 
-- Description: 
-- 
-- Dependencies: 
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.RV32Istd_p.all

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity riscv_ctu is
    Port(   rst : IN    STD_LOGIC;
            clk : IN    STD_LOGIC     
        );
end riscv_ctu;

architecture control_unit of riscv_ctu is

    type state is (idle, fetch);
    
    signal current_st, next_st  :   state   :=  idle;
    
begin

    ------------------------------------------------------------------------------
    --  DECODER   
    ------------------------------------------------------------------------------


    ------------------------------------------------------------------------------
    --  FSM   
    ------------------------------------------------------------------------------
    process(rst, clk)
    begin
        if(rst = '1') then
            current_st <= idle;
        elsif(rising_edge(clk)) then
            if(current_st = idle) then
                current_st <= fetch;
            else
                current_st <= next_st;
            end if;
        end if;
    end process;
    
    process(next_st)
    begin
    
    end process;
    
end control_unit;