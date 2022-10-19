################################################################################
## Title       : Pre Script
## Project     : RISCV Core
################################################################################
## File        : pscript.py
## Author      : Rafael Basso
################################################################################
## Copyright (c) 2022 
################################################################################
## Description: Script that generates random data in HEX format
################################################################################

import os
import numpy as np

################################################################################
## Folder generation
################################################################################

DATA_PATH = os.path.dirname(os.path.abspath(__file__)) + "/../data"

try:
    os.mkdir(DATA_PATH)
except FileExistsError:
    pass

################################################################################
## Data generation
################################################################################

MEM_SIZE   = 256
DATA_WIDTH = 64
FMT_TXT    = "%i" % (DATA_WIDTH / 4)

vmax = np.power(2, DATA_WIDTH - 1, dtype='uint64') + (np.power(2, DATA_WIDTH - 1, dtype='uint64') - 1)

data = np.random.randint(low=0, high=vmax,size=(MEM_SIZE), dtype='uint64')

################################################################################
## Text file generation
################################################################################

np.savetxt(DATA_PATH + "/data_rom_" + str(DATA_WIDTH) + "x" + str(MEM_SIZE) + ".txt",
           data,
           fmt="%0"+ FMT_TXT + "X")