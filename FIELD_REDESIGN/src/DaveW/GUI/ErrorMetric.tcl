##
 #  ErrorMetric.tcl: Compute and visualize error between two vectors
 #
 #  Written by:
 #   David Weinstein
 #   Department of Computer Science
 #   University of Utah
 #   June 1999
 #
 #  Copyright (C) 1999 SCI Group
 #
 ##

catch {rename DaveW_FEM_ErrorMetric ""}

itcl_class DaveW_FEM_ErrorMetric {
    inherit Module
    constructor {config} {
        set name ErrorMetric
        set_defaults
    }
    method set_defaults {} {
        global $this-methodTCL
        set $this-methodTCL CCinv
        global iter
        set iter 1
	global ITERSBASE
	set ITERSBASE 100
	global NITERS
	set NITERS $ITERSBASE
	global ITERSGROW
	set ITERSGROW 50
	global $this-pTCL
	set $this-pTCL 1
    }
    method make_entry {w text v c} {
        frame $w
        label $w.l -text "$text"
        pack $w.l -side left
	global $v
        entry $w.e -textvariable $v
        bind $w.e <Return> $c
        pack $w.e -side right
    }
    method ui {} {
        set w .ui[modname]
        if {[winfo exists $w]} {
            raise $w
            return;
        }

        toplevel $w
        wm minsize $w 300 80
        frame $w.f
        pack $w.f -padx 2 -pady 2 -side top -expand yes
        
        global $this-methodTCL
        frame $w.top -relief groove -borderwidth 2
        make_labeled_radio $w.top.method "Error Metric" "" top \
                $this-methodTCL \
                {{"Correlation Coefficient" CC } \
                {"Inverse Correlation Coefficient" CCinv} \
                {"p Norm" RMS} \
                {"Relative RMS" RMSrel}}
	make_entry $w.top.e "p value:" $this-pTCL "$this-c needexecute"
        button $w.top.reset -text "Clear Graphs" -command "$this clear_graphs"
        pack $w.top.method $w.top.e $w.top.reset -side top
        frame $w.rms -relief groove -borderwidth 2
        blt::graph $w.rms.g -height 200 \
                -plotbackground #CCCCFF
        $w.rms.g element create RMS -data "1 0" -color black -symbol ""
        $w.rms.g yaxis configure -title "RMS Error" -logscale true
	global NITERS
        $w.rms.g xaxis configure -title "Iteration" -min 1 -max $NITERS
        pack $w.rms.g -side top -fill x
        frame $w.cc -relief groove -borderwidth 2
        blt::graph $w.cc.g -height 200 \
                -plotbackground #FFCCCC
        $w.cc.g element create 1-CC -data "1 0" -color black -symbol ""
        $w.cc.g yaxis configure -title "1 - Correlation Coeff" -logscale true
        $w.cc.g xaxis configure -title "Iteration" -min 1 -max $NITERS
        pack $w.cc.g -side top -fill x
        frame $w.data -relief groove -borderwidth 2
        blt::graph $w.data.g -height 200 \
                -plotbackground #CCFFCC
        $w.data.g element create A -data "1 0" -color red -symbol ""
        $w.data.g element create B -data "1 0" -color blue -symbol ""
        $w.data.g yaxis configure -title "Value" -min 0
        $w.data.g xaxis configure -title "Element" -min 1
        pack $w.data.g -side top -fill x
        pack $w.top $w.rms $w.cc $w.data -side top -fill x
    }   

    method append_graph {cc rms a b} {
        set w .ui[modname]
        if {![winfo exists $w]} {
            return
        }
        global iter
	global NITERS
	global ITERSGROW
        if {$iter == 1} {
            $w.rms.g element configure RMS -data "$iter $rms"
            $w.cc.g element configure 1-CC -data "$iter $cc"
        } else {
	    set x [$w.rms.g element cget RMS -xdata]
            set r [$w.rms.g element cget RMS -ydata]
            set c [$w.cc.g element cget 1-CC -ydata]
	    lappend x $iter
	    lappend r $rms
	    lappend c $cc
            $w.rms.g element configure RMS -xdata $x
            $w.rms.g element configure RMS -ydata $r
            $w.cc.g element configure 1-CC -xdata $x
            $w.cc.g element configure 1-CC -ydata $c
        }
        incr iter
	if {$iter > $NITERS} {
	    set NITERS [expr $NITERS + $ITERSGROW]
	    $w.rms.g xaxis configure -max $NITERS
	    $w.cc.g xaxis configure -max $NITERS
	}
        $w.data.g element configure A -data $a
        $w.data.g element configure B -data $b
    }

    method clear_graphs {} {
        set w .ui[modname]
        if {![winfo exists $w]} {
            return
        }
        global iter
        if {$iter == 1} {
            return
        }
        set iter 1
        $w.rms.g element configure RMS -data "1 0"
        $w.cc.g element configure 1-CC -data "1 0"
        $w.data.g element configure A -data "1 0"
        $w.data.g element configure B -data "1 0"
	global NITERS
	global ITERSBASE
	set NITERS $ITERSBASE
	$w.rms.g xaxis configure -max $NITERS
	$w.cc.g xaxis configure -max $NITERS
    }
}
