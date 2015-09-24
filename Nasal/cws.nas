# high level caution and warning system routines for the Space Shuttle
# Thorsten Renk 2015

var inspection_group  = 0;

var cws_message_array = ["","","","","","","","","","","","","","",""];
var cws_message_array_long = ["","","","","","","","","","","","","","",""];

# the message hash stores the information what faults have already been announced

var cws_msg_hash = {
f1f : 0,
f1l : 0,
f1u : 0,
f1d : 0,
};

var cws_inspect = func {

if (inspection_group == 0) 
	{cws_inspect_rcs_thrusters();}


inspection_group = inspection_group + 1;
if (inspection_group == 10) {inspection_group = 0;}
}


var cws_inspect_rcs_thrusters = func {

# FWD manifold 1

var f1f = getprop("/fdm/jsbsim/systems/failures/rcs-F1F-condition");
var f1l = getprop("/fdm/jsbsim/systems/failures/rcs-F1L-condition");
var f1u = getprop("/fdm/jsbsim/systems/failures/rcs-F1U-condition");
var f1d = getprop("/fdm/jsbsim/systems/failures/rcs-F1D-condition");

if (f1f + f1l + f1u + f1d < 4.0) # we have a manifold 1 fail off condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-f1", 1);

	if ((f1f < 1.0) and (cws_msg_hash.f1f == 0))
		{
		create_fault_message("S23 F RCS F JET", 1);
		cws_msg_hash.f1f = 1;
		}
	}

# FWD manifold 2

var f2f = getprop("/fdm/jsbsim/systems/failures/rcs-F2F-condition");
var f2r = getprop("/fdm/jsbsim/systems/failures/rcs-F2R-condition");
var f2u = getprop("/fdm/jsbsim/systems/failures/rcs-F2U-condition");
var f2d = getprop("/fdm/jsbsim/systems/failures/rcs-F2D-condition");

if (f2f + f2r + f2u + f2d < 4.0) # we have a manifold 2 fail off condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-f2", 1);
	}

# FWD manifold 3

var f3f = getprop("/fdm/jsbsim/systems/failures/rcs-F3F-condition");
var f3l = getprop("/fdm/jsbsim/systems/failures/rcs-F3L-condition");
var f3u = getprop("/fdm/jsbsim/systems/failures/rcs-F3U-condition");
var f3d = getprop("/fdm/jsbsim/systems/failures/rcs-F3D-condition");

if (f3f + f3l + f3u + f3d < 4.0) # we have a manifold 3 fail off condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-f3", 1);
	}

# FWD manifold 4

var f4r = getprop("/fdm/jsbsim/systems/failures/rcs-F4R-condition");
var f4d = getprop("/fdm/jsbsim/systems/failures/rcs-F4D-condition");


if (f4r + f4d < 2.0) # we have a manifold 4 fail off condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-f4", 1);
	}

# FWD manifold 5

var f5r = getprop("/fdm/jsbsim/systems/failures/rcs-F5R-condition");
var f5l = getprop("/fdm/jsbsim/systems/failures/rcs-F5L-condition");


if (f5r + f5l < 2.0) # we have a manifold 5 fail off condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-f5", 1);
	}




}


var create_fault_message = func (sys_string, gpc_id) {

var time_string = getprop("/sim/time/gmt-string");

var msg_string = sys_string~"     "~"    "~"*      "~gpc_id~"     "~time_string;

cws_message_array[0] = msg_string;

setprop("/fdm/jsbsim/systems/dps/error-string", msg_string);
#S23 F RCS F JET     
#S88 EVAP OUT T      1   *      4     19:45:01

}
