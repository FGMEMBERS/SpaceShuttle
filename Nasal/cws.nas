# high level caution and warning system routines for the Space Shuttle
# Thorsten Renk 2015

var inspection_group  = 0;

var cws_message_array = [];
var cws_message_array_long = ["","","","","","","","","","","","","","",""];

var cws_last_message_acknowledge = 0;

# the message hash stores the information what faults have already been announced

var cws_msg_hash = {
f1f : 0, f1l : 0, f1u : 0, f1d : 0, f2f : 0, f2r : 0, f2u : 0, f2d : 0, f3f : 0, f3l : 0, f3u : 0, f3d : 0, f4r : 0, f4d : 0, f5r : 0, f5l : 0,
fhep : 0, fpop : 0, fleak : 0,
omslg : 0, omsrg : 0, omslqty : 0, omsrqty : 0,
};

var cws_inspect = func {

if (inspection_group == 0) 
	{cws_inspect_fwd_rcs_thrusters();}

if (inspection_group == 3)
	{cws_inspect_oms();}


inspection_group = inspection_group + 1;
if (inspection_group == 10) {inspection_group = 0;}
}


#################################################
# CWS checks of forward RCS
#################################################

var cws_inspect_fwd_rcs_thrusters = func {

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
		create_fault_message("    F RCS F JET", 1, 2);
		cws_msg_hash.f1f = 1;
		}
	if ((f1l < 1.0) and (cws_msg_hash.f1l == 0))
		{
		create_fault_message("    F RCS L JET", 1, 2);
		cws_msg_hash.f1l = 1;
		}
	if ((f1u < 1.0) and (cws_msg_hash.f1u == 0))
		{
		create_fault_message("    F RCS U JET", 1, 2);
		cws_msg_hash.f1u = 1;
		}
	if ((f1d < 1.0) and (cws_msg_hash.f1d == 0))
		{
		create_fault_message("    F RCS D JET", 1, 2);
		cws_msg_hash.f1d = 1;
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

	if ((f2f < 1.0) and (cws_msg_hash.f2f == 0))
		{
		create_fault_message("    F RCS F JET", 1, 2);
		cws_msg_hash.f2f = 1;
		}
	if ((f2r < 1.0) and (cws_msg_hash.f2r == 0))
		{
		create_fault_message("    F RCS R JET", 1, 2);
		cws_msg_hash.f2r = 1;
		}
	if ((f2u < 1.0) and (cws_msg_hash.f2u == 0))
		{
		create_fault_message("    F RCS U JET", 1, 2);
		cws_msg_hash.f2u = 1;
		}
	if ((f2d < 1.0) and (cws_msg_hash.f2d == 0))
		{
		create_fault_message("    F RCS D JET", 1, 2);
		cws_msg_hash.f2d = 1;
		}
	}

# FWD manifold 3

var f3f = getprop("/fdm/jsbsim/systems/failures/rcs-F3F-condition");
var f3l = getprop("/fdm/jsbsim/systems/failures/rcs-F3L-condition");
var f3u = getprop("/fdm/jsbsim/systems/failures/rcs-F3U-condition");
var f3d = getprop("/fdm/jsbsim/systems/failures/rcs-F3D-condition");

if (f3f + f3l + f3u + f3d < 4.0) # we have a manifold 3 fail off condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-f3", 1);

	if ((f3f < 1.0) and (cws_msg_hash.f3f == 0))
		{
		create_fault_message("    F RCS F JET", 1, 2);
		cws_msg_hash.f3f = 1;
		}
	if ((f3l < 1.0) and (cws_msg_hash.f3l == 0))
		{
		create_fault_message("    F RCS L JET", 1, 2);
		cws_msg_hash.f3l = 1;
		}
	if ((f3u < 1.0) and (cws_msg_hash.f3u == 0))
		{
		create_fault_message("    F RCS U JET", 1, 2);
		cws_msg_hash.f3u = 1;
		}
	if ((f3d < 1.0) and (cws_msg_hash.f3d == 0))
		{
		create_fault_message("    F RCS D JET", 1, 2);
		cws_msg_hash.f3d = 1;
		}
	}

# FWD manifold 4

var f4r = getprop("/fdm/jsbsim/systems/failures/rcs-F4R-condition");
var f4d = getprop("/fdm/jsbsim/systems/failures/rcs-F4D-condition");


if (f4r + f4d < 2.0) # we have a manifold 4 fail off condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-f4", 1);

	if ((f4r < 1.0) and (cws_msg_hash.f4r == 0))
		{
		create_fault_message("    F RCS R JET", 1, 2);
		cws_msg_hash.f4r = 1;
		}
	if ((f4d < 1.0) and (cws_msg_hash.f4d == 0))
		{
		create_fault_message("    F RCS D JET", 1, 2);
		cws_msg_hash.f4d = 1;
		}
	}

# FWD manifold 5

var f5r = getprop("/fdm/jsbsim/systems/failures/rcs-F5R-condition");
var f5l = getprop("/fdm/jsbsim/systems/failures/rcs-F5L-condition");


if (f5r + f5l < 2.0) # we have a manifold 5 fail off condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-f5", 1);

	if ((f5r < 1.0) and (cws_msg_hash.f5r == 0))
		{
		create_fault_message("    F RCS R JET", 1, 2);
		cws_msg_hash.f5r = 1;
		}
	if ((f5l < 1.0) and (cws_msg_hash.f5l == 0))
		{
		create_fault_message("    F RCS L JET", 1, 2);
		cws_msg_hash.f5l = 1;
		}
	}


# Helium pressure

var fhep1 = getprop("/fdm/jsbsim/systems/rcs-hardware/helium-fwd-rcs-pressure-1-psia");
var fhep2 = getprop("/fdm/jsbsim/systems/rcs-hardware/helium-fwd-rcs-pressure-2-psia");

# fixme - the pressure model of the helium tanks needs to improved, it is always higher than tank pressure

if ((fhep1 < 270.0) or (fhep2 < 270.0)) # helium pressure problem
	{
		if (cws_msg_hash.fhep == 0)
		{
		create_fault_message("    F HE P     ", 1, 2);
		cws_msg_hash.fhep = 1;
		}
	
	}

# propellant and oxidizer pressure

var fpp = getprop("/fdm/jsbsim/systems/rcs-hardware/fuel-fwd-rcs-pressure-psia");
var fop = getprop("/fdm/jsbsim/systems/rcs-hardware/oxidizer-fwd-rcs-pressure-psia");

if ((fpp < 200.0) or (fpp > 312.0) or (fop < 200.0) or (fop > 312.0))
	{
		if (cws_msg_hash.fpop == 0)
		{
		create_fault_message("    F RCS TK P ", 1, 2);
		cws_msg_hash.fpop = 1;
		}
	
	}

# leak detection

var foxidizer = getprop("/consumables/fuel/tank[12]/level-lbs")/1477.0;
var fpropellant = getprop("/consumables/fuel/tank[13]/level-lbs")/928.0;

if (math.abs(foxidizer - fpropellant) > 0.095) # we have a leak
	{
		if (cws_msg_hash.fleak == 0)
		{
		create_fault_message("    F RCS LEAK ", 1, 2);
		cws_msg_hash.fleak = 1;
		}
	}

}

#################################################
# CWS checks of OMS
#################################################

var cws_inspect_oms = func {

var omslg = getprop("/fdm/jsbsim/systems/failures/oms1-gimbal-condition");
var omsrg = getprop("/fdm/jsbsim/systems/failures/oms2-gimbal-condition");

if (omslg < 0.8)
	{
		if (cws_msg_hash.omslg == 0)
		{
		create_fault_message("    L OMS GMBL ", 1, 2);
		cws_msg_hash.omslg = 1;
		}
	}

if (omsrg < 0.8)
	{
		if (cws_msg_hash.omsrg == 0)
		{
		create_fault_message("    R OMS GMBL ", 1, 2);
		cws_msg_hash.omsrg = 1;
		}
	}


var omsloqty =  getprop("/consumables/fuel/tank[4]/level-lbs")/7773.0;
var omslpqty =  getprop("/consumables/fuel/tank[5]/level-lbs")/4718.0;

var omsroqty =  getprop("/consumables/fuel/tank[6]/level-lbs")/7773.0;
var omsrpqty =  getprop("/consumables/fuel/tank[7]/level-lbs")/4718.0;

if ((omsloqty < 0.05) or (omslpqty < 0.05))
	{
		if (cws_msg_hash.omslqty == 0)
		{
		create_fault_message("    L OMS QTY  ", 1, 3);
		cws_msg_hash.omslqty = 1;
		}
	}

if ((omsroqty < 0.05) or (omsrpqty < 0.05))
	{
		if (cws_msg_hash.omsrqty == 0)
		{
		create_fault_message("    R OMS QTY  ", 1, 3);
		cws_msg_hash.omsrqty = 1;
		}
	}

}



var insert_fault_message_long = func (message) {

# shift all messages in the array such that zero becomes available

for (var i = 0; i<14; i=i+1)
	{
	cws_message_array_long[14-i] = cws_message_array_long[13-i];
	}
cws_message_array_long[0] = message;


}


var create_fault_message = func (sys_string, gpc_id, class) {

var time_string = getprop("/sim/time/gmt-string");

var backup_marker = " ";
if (class == 2) {backup_marker = "*";}

var msg_string = sys_string~"     "~" "~backup_marker~" "~gpc_id~" "~time_string;
var msg_string_long = sys_string~"     "~"    "~backup_marker~"      "~gpc_id~" 000/"~time_string;

insert_fault_message_long(msg_string_long);
append(cws_message_array, msg_string);

setprop("/fdm/jsbsim/systems/dps/error-string", msg_string);
cws_last_message_acknowledge = 1;

}
