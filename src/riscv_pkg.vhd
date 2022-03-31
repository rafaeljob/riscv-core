----------------------------------------------------------------------------------
-- Dev by: Rafael Basso
-- 
-- Create Date: 10.03.2022 
-- Package Name: riscv_pkg 
-- Description: 
-- 
-- Dependencies: 
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package RV32Istd_p is

    type instruction_type is 
    ( LUI, AUIPC, JAL, JALR, BEA, BNE, BLT, BGE, BLTU, BGEU, LB, LH, LW, LBU, 
      LHU, SB, SH, SW, ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI, 
      ADD, SUB, SSLL, SLT, SLTU, XXOR, SSRL, xSRA, OOR, AAND, FENCE, ECALL, 
      EBREAK, INVALID_INST );
      
end package;
