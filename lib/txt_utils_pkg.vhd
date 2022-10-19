--------------------------------------------------------------------------------
-- Title       : txt_utils_pkg.vhd
-- Project     : RISCV Core
--------------------------------------------------------------------------------
-- File        : txt_utils_pkg.vhd
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

--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------

package txt_utils_p is

	----------------------------------------------------------------------------
	-- 
	----------------------------------------------------------------------------
    type std_array_t is array (integer range <>) of std_logic_vector; 
	type int_array_t is array (integer range <>) of integer;

	----------------------------------------------------------------------------
	--	Read procedures 
	----------------------------------------------------------------------------

	procedure ifile_read(
		signal fpath : in string;
		signal fsize : in string;
		signal rdata : out int_array_t
	);

--	procedure hfile_read(
--		signal fpath : in string;
--		signal fsize : in string;
--		signal rdata : out int_array_t
--	);
--
--	procedure ofile_read(
--		signal fpath : in string;
--		signal fsize : in string;
--		signal rdata : out int_array_t
--	);
--
--	procedure bfile_read(
--		signal fpath : in string;
--		signal fsize : in string;
--		signal rdata : out int_array_t
--	);

--	procedure icontent_verify(
--		
--	);

	----------------------------------------------------------------------------
	--	Verification procedures 
	----------------------------------------------------------------------------

	-- HEX content verification
	procedure hcontent_verify(
		signal clk   : in std_logic;
		signal vld   : in std_logic;
		signal data  : in std_logic_vector;
		fpath 		 : in string;
		dsize 		 : in natural
	);

--	procedure ocontent_verify(
--		
--	);
--
--	procedure bcontent_verify(
--		
--	);
	
end package txt_utils_p;

package body txt_utils_p is

	----------------------------------------------------------------------------
	--	Read procedures 
	----------------------------------------------------------------------------

	procedure ifile_read(
		signal fpath : in string;
		signal fsize : in string;
		signal rdata : out int_array_t
	) is
		file fptr            : text;
        variable fline       : line;
        variable fstatus     : file_open_status := MODE_ERROR;
        variable data 	     : integer;
        variable i 			 : integer := 0;
	begin
		file_open(fstatus, fptr, fpath, READ_MODE);

		assert fstatus = OPEN_OK
        report "###ERROR : Could not open file: " & fpath & LF
        severity error;

        while(endfile(fptr)) loop
        	readline(fptr, fline);
            read(fline, data);
            rdata(i) <= data;
            i := i + 1;
        end loop;
		file_close(fptr);

	end procedure ifile_read;

	----------------------------------------------------------------------------
	--	Verification procedures 
	----------------------------------------------------------------------------

	procedure hcontent_verify(
		signal clk   : in std_logic;
		signal vld   : in std_logic;
		signal data  : in std_logic_vector;
		fpath        : in string;
		dsize        : in natural
	) is
		file fptr            : text;
        variable fline       : line;
        variable fstatus     : file_open_status := MODE_ERROR;
        variable rdata 	     : std_logic_vector(dsize - 1 downto 0);

        variable nline 		 : integer := 0;
	begin
		file_open(fstatus, fptr, fpath, READ_MODE);

		assert fstatus = OPEN_OK
        report "###ERROR : Could not open file: " & fpath & LF
        severity error;

        while(not endfile(fptr)) loop
        	wait until rising_edge(clk) and vld = '1';
        		readline(fptr, fline);
            	hread(fline, rdata);

            	assert data = rdata
        		report "###ERROR : Wrong sample on file " & fpath & LF & 
        			"   Line : " & to_string(nline) & LF &
        			"    Expected : " & "0x" & to_hex_string(rdata) & LF &
        			"    Received : " & "0x" & to_hex_string(data)  & LF 
        		severity error;

        		nline := nline + 1;
        end loop;
		file_close(fptr);

	end procedure hcontent_verify;

end package body txt_utils_p;