----------------------------------------------------------------------------------
-- Company: Polytech Montpellier
-- Engineer: Seven Lemonnier
-- 
-- Create Date: 10.03.2022 11:05:43
-- Design Name: Package
-- Module Name: riscv_pkg - Behavioral
-- Project Name: RISC-V Core
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package inst_set is 

    type base_inst_set is 
    
        ( LUI, AUIPC, JAL, JALR, BEQ, BNE, BLT, BGE, BLTU, BGEU, LB, LH, LW, LBU, LHU, SB, SH, SW, ADDI,
         SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI, ADD, SUB, SSLL, SLT, SLTU, XXOR, SSRL, SSRA, OOR, AAND, -- (S)SLL, (X)XOR, (S)SRL, (S)SRA, (O)OR, (A)AND
         ECALL, EBREAK);
         
end inst_set;
