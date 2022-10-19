##############################################################################
#  Copyright (c) 2022
#  Authors: Rafael Basso
##############################################################################

#Constants
set LIB_PATH  "../lib/"
set LIB_NAME  "riscv"

source ../lib/tcl_utils.tcl
namespace import tcl::utils::*

##suppress messages
#compile_suppress 135,1236,1073
##run_suppress 8684,3479,3813,8009,3812

#Initialize Simulation
init -noheader

library_set riscv
library_clear riscv

##############################################################################
#  Package compilation
##############################################################################

package_add "../lib/" {
    txt_utils_pkg.vhd \
    tb_utils_pkg.vhd \
    riscv_tb_pkg.vhd
}

##############################################################################
#  Source compilation
##############################################################################

source_add "../src/" {
    riscv_pkg.vhd \
    riscv_rom.vhd \
    riscv_reg.vhd
}

##############################################################################
#  Testbench compilation
##############################################################################

testbench_add "../tb/" {
    riscv_rom_tb/riscv_rom_tb.vhd \
    riscv_reg_tb/riscv_reg_tb.vhd
}

##############################################################################
#  Compilation
##############################################################################

fcompile

##############################################################################
#  Testbench Run
##############################################################################

set DATA_PATH [file normalize "../tb/riscv_rom_tb/data/data_rom_32x256.txt"]
set PSCRIPT_PATH [file normalize "../tb/riscv_rom_tb/script"]
testbench_run "riscv_rom_tb" [list "-gFILE_PATH_g=$DATA_PATH" "-gMEM_SIZE_g=256" "-gDATA_WIDTH_g=32"] "python $PSCRIPT_PATH/pscript.py" ""

set DATA_PATH [file normalize "../tb/riscv_rom_tb/data/data_rom_64x256.txt"]
set PSCRIPT_PATH [file normalize "../tb/riscv_rom_tb/script"]
testbench_run "riscv_rom_tb" [list "-gFILE_PATH_g=$DATA_PATH" "-gMEM_SIZE_g=256" "-gDATA_WIDTH_g=64"] "python $PSCRIPT_PATH/pscript.py" ""

testbench_run "riscv_reg_tb" [list "-gDATA_WIDTH_g=32"] "" ""
