##############################################################################
#  Copyright (c) 2022
#  Authors: Rafael Basso
##############################################################################

#Load dependencies
source ../lib/tcl_utils.tcl
namespace import tcl::utils::*

#Configure
source ./compile.tcl

# run
testbench_exec
#puts "------------------------------"
#puts "-- Check"
#puts "------------------------------"

#run_check_errors "###ERROR###"