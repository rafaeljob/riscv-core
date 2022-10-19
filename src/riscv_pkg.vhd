--------------------------------------------------------------------------------
-- Title       : riscv_pkg
-- Project     : RISCV Core
--------------------------------------------------------------------------------
-- File        : riscv_pkg.vhd
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

library WORK;
    use WORK.riscv_tb_p.all;


library STD;
    use STD.textio.all;

package RV32std_p is

    type rom_t is array(integer range <>) of std_logic_vector;

	type instr_t is
    ( 
    	LUI, AUIPC, JAL, JALR, BEQ, BNE, BLT, BGE, BLTU, BGEU, LB, LH, LW, LBU, 
    	LHU, SB, SH, SW, ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI, 
    	ADD, SUB, SSLL, SLT, SLTU, XXOR, SSRL, SSRA, OOR, AAND, FENCE, ECALL, 
    	EBREAK, INVALID_INSTR
    );

--    ----------------------------------------------------------------------------
--    -- Stage : Instruction fetch
--    ----------------------------------------------------------------------------
--    type if_r is record
--
--    end record;
--
--    ----------------------------------------------------------------------------
--    -- Stage : Instruction decode and register file read
--    ----------------------------------------------------------------------------
--    type id_r is record
--
--    end record;
--
--    ----------------------------------------------------------------------------
--    -- Stage : Execute and address calculation
--    ----------------------------------------------------------------------------
--    type ex_r is record
--
--    end record;
--
--    ----------------------------------------------------------------------------
--    -- Stage : Memory access
--    ----------------------------------------------------------------------------
--    type ma_r is record
--
--    end record;
--
--    ----------------------------------------------------------------------------
--    -- Stage : Write back
--    ----------------------------------------------------------------------------
--    type wb_r is record
--
--    end record;

    ----------------------------------------------------------------------------
    -- Function Header
    ----------------------------------------------------------------------------

    -- Log on base 2 function
    --------------------------------------
    function log2(arg : in integer) return natural;

    impure function init_hrom(
        fpath : in string;
        rsize : in integer;
        dsize : in natural 
    ) return rom_t;


end package RV32std_p;

package body RV32std_p is

    ----------------------------------------------------------------------------
    -- Function Body
    ----------------------------------------------------------------------------

	-- Log on base 2 function
    --------------------------------------
	function log2(arg : in integer) return natural is
		variable var : integer := arg;
    	variable ret : integer := 0;
	begin
    	while(var > 1) loop
      		var := var / 2;
      		ret := ret + 1;
    	end loop;
    	return ret;
  	end function;

    impure function init_hrom(
        fpath : in string;
        rsize : in integer;
        dsize : in natural 
    ) return rom_t is
        file fptr           : text;
        variable fline      : line;
        variable fstatus    : file_open_status := MODE_ERROR;
        variable rom_content : rom_t(0 to rsize - 1)(dsize - 1  downto 0);
    begin
        file_open(fstatus, fptr, fpath, READ_MODE);

        assert fstatus = OPEN_OK
        report "###ERROR : Could not open file: " & fpath & LF
        severity error;

        for i in 0 to rsize - 1 loop
            readline(fptr, fline);
            hread(fline, rom_content(i));
        end loop;
        file_close(fptr);
 
        return rom_content;
    end function;
    

--    function rom_fill (
--        fpath : in string;
--        fsize : in integer;
--        dsize : in natural
--    ) return rom_t is
--        variable adata      : harray_t(0 to fsize-1)(dsize - 1 downto 0);
--        variable rom        : rom_t(0 to fsize-1)(dsize - 1 downto 0);
--    begin
--        hfile_read(fpath, adata);
--        for i in 0 to fsize - 1 loop
--            rom(i) := std_logic_vector(adata(i));   
--        end loop;
--        return rom;
--    end function rom_fill;

end package body RV32std_p;