##############################################################################
#  Copyright (c) 2022
#  Authors: Rafael Basso
##############################################################################

namespace eval tcl::utils {

    variable LIBRARY
    variable LPACKAGE
    variable LSOURCE
    variable LTESTBENCH

    variable LRUN

    proc init {args} \
    {
        if {$args != "-noheader"} {
            header_print   
        }
        info_print "Initializing environment"
    }
    namespace export init

    proc library_set {lib} \
    {
        variable LIBRARY

        info_print "Setting library name to $lib"
        set LIBRARY $lib
    }
    namespace export library_set

    proc library_clear {lib} \
    {
        info_print "Cleaning library $lib"

        vlib $lib
        vdel -all -lib $lib
        vlib $lib

        list_empty
    }
    namespace export library_clear

    proc list_empty {} \
    {
        variable LPACKAGE
        variable LSOURCE
        variable LTESTBENCH
        variable LRUN

        set LPACKAGE {}
        set LSOURCE {}
        set LTESTBENCH {}
        set LRUN {}
    }

    ##############################################################################
    #  File add proc
    ##############################################################################

    proc package_add {path pkgs} \
    {
        variable LPACKAGE

        set rpath [file normalize $path]
        info_print "Adding packages from $rpath"

        foreach pkg $pkgs {
            set rpkg [file normalize [concat $path/$pkg]]
            if {![catch {set found [glob $rpkg] }]} {
                lappend LPACKAGE $rpkg
            } else {
                warning_print "Could not find $rpkg"
                warning_print "The previous file will be ignored"
            }
        }
    }
    namespace export package_add

    proc source_add {path srcs} \
    {
        variable LSOURCE

        set rpath [file normalize $path]
        info_print "Adding sources from $rpath"

        foreach src $srcs {
            set rsrc [file normalize [concat $path/$src]]
            if {![catch {set found [glob $rsrc] }]} {
                lappend LSOURCE $rsrc
            } else {
                warning_print "Could not find $rsrc"
                warning_print "The previous file will be ignored"
            }
        }
    }
    namespace export source_add

    proc testbench_add {path tbs} \
    {
        variable LTESTBENCH

        set rpath [file normalize $path]
        info_print "Adding testbenches from $rpath"

        foreach tb $tbs {
            set rtb [file normalize [concat $path/$tb]]
            if {![catch {set found [glob $rtb] }]} {
                lappend LTESTBENCH $rtb
            } else {
                warning_print "Could not find $rtb"
                warning_print "The previous file will be ignored"
            }
        }
    }
    namespace export testbench_add

    ##############################################################################
    #  Compile proc
    ##############################################################################

    proc fcompile {args} \
    {
        package_compile
        source_compile
        testbench_compile
    }
    namespace export fcompile


    proc package_compile {} \
    {
        variable LIBRARY
        variable LPACKAGE

        foreach pkg $LPACKAGE {
            info_print "Compiling $pkg"
            #set args "-work $LIBRARY $vFlags -suppress $CompileSuppress $fileOptions -quiet $path"
            set args "-work $LIBRARY -2008 -quiet $pkg"
            vcom {*}$args
        }
    }

    proc source_compile {args} \
    {
        variable LIBRARY
        variable LSOURCE

        foreach src $LSOURCE {
            info_print "Compiling $src"
            #puts "$src"
            #set args "-work $LIBRARY $vFlags -suppress $CompileSuppress $fileOptions -quiet $path"
            set args "-work $LIBRARY -2008 -quiet $src"
            vcom {*}$args
        }
    }
    namespace export source_compile

    proc testbench_compile {args} \
    {
        variable LIBRARY
        variable LTESTBENCH

        foreach tb $LTESTBENCH {
            info_print "Compiling $tb"
            #puts "$src"
            #set args "-work $LIBRARY $vFlags -suppress $CompileSuppress $fileOptions -quiet $path"
            set args "-work $LIBRARY -2008 -quiet $tb"
            vcom {*}$args
        }
    }
    namespace export testbench_compile

    ##############################################################################
    #  Testbench run procs
    ##############################################################################

    proc testbench_run {tb {tbargs} pcmd {pargs}} \
    {
        variable LRUN
        variable ctb [dict create]

        dict set ctb tb_name $tb
        dict set ctb tb_args $tbargs
        dict set ctb pscript_cmd $pcmd
        dict set ctb pscript_args $pargs

        # if skip : TO DO
        #dict set ctb SKIP "None"
        lappend LRUN $ctb
        info_print "Setting $tb"
    }
    namespace export testbench_run

    proc testbench_exec {} \
    {
        variable LIBRARY
        variable LRUN
        info_print "Starting simulation"
        foreach run $LRUN {
            set name [dict get $run tb_name]
            set args [dict get $run tb_args]

            set cmd "vsim -quiet -t 1ps -msgmode both $LIBRARY.$name $args"

            set pcmd  [dict get $run pscript_cmd]
            set pargs [dict get $run pscript_args]

            if {$pcmd != ""} {
                run_print "Running prescript ($name)"
                exec {*}$pcmd $pargs
            }

            run_print "Lauching simulation ($name)"
            eval $cmd
            run -all
            quit -sim
        }
    }
    namespace export testbench_exec

    ##############################################################################
    #  Print proc
    ##############################################################################

    proc header_print {} \
    {
        puts "===================================================================================="
        puts "=            ______  _____  _          _   _   ______  _   _      _____            ="
        puts "=           /_   _/ /  __/ | |        | | | | /_   _/ |_| | |    / ___/            ="
        puts "=             | |  /  /__  | |___     | |_| |   | |   | | | |___ \\__  \\            ="
        puts "=             |_|  \\____/  |____/     |_____|   |_|   |_| |____/ /____/            ="
        puts "=                                                                                  ="
        puts "===================================================================================="
        puts "=  Copyright (c) 2022                                                              ="
        puts "=  Author: Rafael Basso                                                            ="
        puts "====================================================================================" 
    }

    proc info_print {msg} \
    {
        #puts -nonewline "\033\[01;31m"
        puts -nonewline ">> INFO: "
        #puts -nonewline "\033\[0m"
        puts "$msg"
    }

    proc warning_print {msg} \
    {
        #puts -nonewline "\033\[01;31m"
        puts -nonewline ">> WARNING: "
        #puts -nonewline "\033\[0m"
        puts "$msg"
    }

    proc exec_print {msg} \
    {
        #puts -nonewline "\033\[01;31m"
        puts -nonewline ">> EXEC: "
        #puts -nonewline "\033\[0m"
        puts "$msg"
    }

    proc run_print {msg} \
    {
        puts "===================================================================================="
        puts "=  $msg"
        puts "===================================================================================="
    }
}

