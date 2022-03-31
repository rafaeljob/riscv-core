----------------------------------------------------------------------------------
-- Company: Polytech Montpellier
-- Engineer: Seven Lemonnier
-- 
-- Create Date: 10.03.2022 11:05:43
-- Design Name: ALU
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
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.inst_set.all;

entity ALU is 
        port( A, B : in std_logic_vector(31 downto 0);
              Y : out std_logic_vector(31 downto 0);
              OP : in base_inst_set
            );
end ALU;

architecture ALU of ALU is 
    signal menorU, menorS : std_logic;
begin

    menorU <= '1' when A < B else '0';
    menorS <= '1' when ieee.std_logic_signed."<"(A, B) else '0';
    
    Y <=
        A  +  B                           when op = ADD       or op = ADDI         else 
        A  -  B                           when op = SUB                            else
        A and B                           when op = AAND      or op = ANDI         else
        A or  B                           when op = OOR       or op = ORI          else
        A xor B                           when op = XXOR      or op = XORI         else
        B(15 downto 0) & x"0000"          when op = LUI                            else
        (0=>menorU, others=>'0')          when op = SLTU      or op = SLTIU        else
        (0=>menorS, others=>'0')          when op = SLT       or op = SLTI         else
        A(31 downto 28) & B(27 downto 0)  when op = JAL                            else
        A                                 when op = JALR                           else
        to_StdLogicVector(to_bitvector(A) sll  CONV_INTEGER(B(10 downto 6)))   when  op = SSLL   else 
        to_StdLogicVector(to_bitvector(B) sll  CONV_INTEGER(A(5 downto 0)))    when  op = SLLI   else 
        to_StdLogicVector(to_bitvector(A) sra  CONV_INTEGER(B(10 downto 6)))   when  op = SSRA   else 
        to_StdLogicVector(to_bitvector(B) sra  CONV_INTEGER(A(5 downto 0)))    when  op = SRAI   else 
        to_StdLogicVector(to_bitvector(A) srl  CONV_INTEGER(B(10 downto 6)))   when  op = SSRL   else 
        to_StdLogicVector(to_bitvector(B) srl  CONV_INTEGER(A(5 downto 0)))    when  op = SRLI   else 
        A + B;    -- default for AUIPC, BEQ, BNE, BLT, BGE, BLTU; BGEU, LB, LH,LW, LBU, LHU, SB, SH, SW
       
        
end ALU;