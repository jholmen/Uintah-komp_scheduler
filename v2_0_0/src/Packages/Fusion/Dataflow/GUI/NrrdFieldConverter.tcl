#
#  The contents of this file are subject to the University of Utah Public
#  License (the "License"); you may not use this file except in compliance
#  with the License.
#  
#  Software distributed under the License is distributed on an "AS IS"
#  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
#  License for the specific language governing rights and limitations under
#  the License.
#  
#  The Original Source Code is SCIRun, released March 12, 2001.
#  
#  The Original Source Code was developed by the University of Utah.
#  Portions created by UNIVERSITY are Copyright (C) 2001, 1994 
#  University of Utah. All Rights Reserved.
#

# GUI for NrrdFieldConverter module
# by Allen R. Sanderson
# May 2003

# This GUI interface is for selecting a file name via the makeOpenFilebox
# and other reading functions.

catch {rename Fusion_Fields_NrrdFieldConverter ""}

itcl_class Fusion_Fields_NrrdFieldConverter {
    inherit Module
    constructor {config} {
        set name NrrdFieldConverter
        set_defaults
    }

    method set_defaults {} {

	global $this-datasets
	set $this-datasets ""

	global $this-nomesh
	set $this-nomesh 0
    }

    method ui {} {
	global env

        set w .ui[modname]
        if {[winfo exists $w]} {
            raise $w
            return
        }

#	if {[winfo exists $w]} {
#	    set child [lindex [winfo children $w] 0]
#
#	    # $w withdrawn by $child's procedures
#	    raise $child
#	    return;
#	}

	# When building the UI prevent the selection from taking place
	# since it is not valid.

	toplevel $w

	global $this-nomesh

	frame $w.mesh
	label $w.mesh.label -text "No Mesh - regular topology and geometry" \
	    -width 40 -anchor w -just left
	checkbutton $w.mesh.button -variable $this-nomesh
	
	pack $w.mesh.button $w.mesh.label -side left

	pack $w.mesh -side top


	frame $w.grid
	label $w.grid.l -text "Inputs: (Execute to show list)" -width 30 -just left

	pack $w.grid.l  -side left
	pack $w.grid -side top

	frame $w.datasets
	
	global $this-datasets
	set_names [set $this-datasets]

	pack $w.datasets -side top -pady 10

	frame $w.misc
	button $w.misc.execute -text "Execute" -command "$this-c needexecute"
	button $w.misc.close -text Close -command "destroy $w"
	pack $w.misc.execute $w.misc.close -side left -padx 25

	pack $w.misc -side bottom -pady 10
    }

    method set_names {datasets} {

	global $this-datasets
	set $this-datasets $datasets

        set w .ui[modname]

	if [ expr [winfo exists $w] ] {

	    for {set i 0} {$i < 10} {incr i 1} {
		if [ expr [winfo exists $w.datasets.$i] ] {
		    pack forget $w.datasets.$i
		}
	    }
	    set i 0

	    foreach dataset $datasets {

		if [ expr [winfo exists $w.datasets.$i] ] {
		    $w.datasets.$i configure -text $dataset
		} else {
		    set len [expr [string length $dataset] + 5 ]
		    label $w.datasets.$i -text $dataset -width $len \
			-anchor w -just left
		}

		pack $w.datasets.$i -side top

		incr i 1
	    }
	}
    }
}
