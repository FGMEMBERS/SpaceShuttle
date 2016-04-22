# high level caution and warning system routines for the Space Shuttle
# Thorsten Renk 2015

var inspection_group  = 0;

var cws_message_array = [];
var cws_message_array_long = ["","","","","","","","","","","","","","",""];

var cws_last_message_acknowledge = 0;

# the message hash stores the information what faults have already been announced

var cws_msg_hash = {
f1f : 0, f1l : 0, f1u : 0, f1d : 0, f2f : 0, f2r : 0, f2u : 0, f2d : 0, f3f : 0, f3l : 0, f3u : 0, f3d : 0, f4r : 0, f4d : 0, f5r : 0, f5l : 0,
l1a : 0, l1l : 0, l1u : 0, l2u: 0, l2l : 0, l2d : 0, l3l : 0, l3a : 0, l3d : 0, l4u : 0, l4l : 0, l4d : 0, l5d : 0, l5l : 0,
r1a : 0, r1r : 0, r1u : 0, r2u: 0, r2r : 0, r2d : 0, r3r : 0, r3a : 0, r3d : 0, r4u : 0, r4r : 0, r4d : 0, r5d : 0, r5r : 0,
fhep : 0, fpop : 0, fleak : 0, lhep: 0, lpop: 0, lleak: 0, rhep: 0, rpop: 0, rleak: 0,
omslg : 0, omsrg : 0, omslqty : 0, omsrqty : 0, omslpc : 0, omsrpc : 0, omsltkp: 0, omsrtkp: 0,
acvolt : 0,
};


var cws_inspect = func {

if (inspection_group == 0) 
	{cws_inspect_fwd_rcs_thrusters();}


if (inspection_group == 1) 
	{cws_inspect_left_rcs_thrusters();}

if (inspection_group == 1) 
	{cws_inspect_right_rcs_thrusters();}

if (inspection_group == 3)
	{cws_inspect_oms();}

if (inspection_group == 4)
	{cws_inspect_fc_electric();}


inspection_group = inspection_group + 1;
if (inspection_group == 10) {inspection_group = 0;}
}


#################################################
# CWS checks of forward RCS
#################################################

var cws_inspect_fwd_rcs_thrusters = func {

# FWD manifold 1

var f1f = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-F1F-condition");
var f1l = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-F1L-condition");
var f1u = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-F1U-condition");
var f1d = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-F1D-condition");

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
else if (f1f + f1l + f1u + f1d > 4.0) # we have a manifold 1 fail on condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-f1", 2);

	if ((f1f > 1.0) and (cws_msg_hash.f1f == 0))
		{
		create_fault_message("    F RCS F JET", 1, 2);
		cws_msg_hash.f1f = 1;
		}
	if ((f1l > 1.0) and (cws_msg_hash.f1l == 0))
		{
		create_fault_message("    F RCS L JET", 1, 2);
		cws_msg_hash.f1l = 1;
		}
	if ((f1u > 1.0) and (cws_msg_hash.f1u == 0))
		{
		create_fault_message("    F RCS U JET", 1, 2);
		cws_msg_hash.f1u = 1;
		}
	if ((f1d > 1.0) and (cws_msg_hash.f1d == 0))
		{
		create_fault_message("    F RCS D JET", 1, 2);
		cws_msg_hash.f1d = 1;
		}

	}


# FWD manifold 2

var f2f = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-F2F-condition");
var f2r = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-F2R-condition");
var f2u = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-F2U-condition");
var f2d = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-F2D-condition");

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

var f3f = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-F3F-condition");
var f3l = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-F3L-condition");
var f3u = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-F3U-condition");
var f3d = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-F3D-condition");

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

var f4r = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-F4R-condition");
var f4d = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-F4D-condition");


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

var f5r = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-F5R-condition");
var f5l = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-F5L-condition");


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


if ((fhep1 < 500.0) or (fhep2 < 500.0)) # helium pressure problem
	{
		if (cws_msg_hash.fhep == 0)
		{
		create_fault_message("    F HE P     ", 1, 2);
		cws_msg_hash.fhep = 1;
		}
	
	}

# propellant and oxidizer pressure

var fpp = getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-fwd-rcs-blowdown-psia");
var fop = getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-fwd-rcs-blowdown-psia");

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
# CWS checks of left RCS
#################################################

var cws_inspect_left_rcs_thrusters = func {

# LEFT manifold 1

var l1a = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-L1A-condition");
var l1l = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-L1L-condition");
var l1u = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-L1U-condition");


if (l1a + l1l + l1u < 3.0) # we have a manifold 1 fail off condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-l1", 1);

	if ((l1a < 1.0) and (cws_msg_hash.l1a == 0))
		{
		create_fault_message("    L RCS A JET", 1, 2);
		cws_msg_hash.l1a = 1;
		}
	if ((l1l < 1.0) and (cws_msg_hash.l1l == 0))
		{
		create_fault_message("    L RCS L JET", 1, 2);
		cws_msg_hash.l1l = 1;
		}
	if ((l1u < 1.0) and (cws_msg_hash.l1u == 0))
		{
		create_fault_message("    L RCS U JET", 1, 2);
		cws_msg_hash.l1u = 1;
		}
	}

# LEFT manifold 2

var l2u = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-L2U-condition");
var l2l = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-L2L-condition");
var l2d = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-L2D-condition");


if (l2u + l2l + l2d < 3.0) # we have a manifold 2 fail off condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-l2", 1);

	if ((l2u < 1.0) and (cws_msg_hash.l2u == 0))
		{
		create_fault_message("    L RCS U JET", 1, 2);
		cws_msg_hash.l2u = 1;
		}
	if ((l2l < 1.0) and (cws_msg_hash.l2l == 0))
		{
		create_fault_message("    L RCS L JET", 1, 2);
		cws_msg_hash.l2l = 1;
		}
	if ((l2d < 1.0) and (cws_msg_hash.l2d == 0))
		{
		create_fault_message("    L RCS D JET", 1, 2);
		cws_msg_hash.l2d = 1;
		}
	}

# LEFT manifold 3

var l3l = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-L3L-condition");
var l3a = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-L3A-condition");
var l3d = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-L3D-condition");


if (l3l + l3a + l3d < 3.0) # we have a manifold 3 fail off condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-l3", 1);

	if ((l3l < 1.0) and (cws_msg_hash.l3l == 0))
		{
		create_fault_message("    L RCS L JET", 1, 2);
		cws_msg_hash.l3l = 1;
		}
	if ((l3a < 1.0) and (cws_msg_hash.l3a == 0))
		{
		create_fault_message("    L RCS A JET", 1, 2);
		cws_msg_hash.l3a = 1;
		}
	if ((l3d < 1.0) and (cws_msg_hash.l3d == 0))
		{
		create_fault_message("    L RCS D JET", 1, 2);
		cws_msg_hash.l3d = 1;
		}
	}

# LEFT manifold 4

var l4u = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-L4U-condition");
var l4l = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-L4L-condition");
var l4d = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-L4D-condition");


if (l4u + l4l + l4d < 3.0) # we have a manifold 4 fail off condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-l4", 1);

	if ((l4u < 1.0) and (cws_msg_hash.l4u == 0))
		{
		create_fault_message("    L RCS U JET", 1, 2);
		cws_msg_hash.l4u = 1;
		}
	if ((l4l < 1.0) and (cws_msg_hash.l4l == 0))
		{
		create_fault_message("    L RCS L JET", 1, 2);
		cws_msg_hash.l4l = 1;
		}
	if ((l4d < 1.0) and (cws_msg_hash.l4d == 0))
		{
		create_fault_message("    L RCS D JET", 1, 2);
		cws_msg_hash.l4d = 1;
		}
	}

# LEFT manifold 5

var l5d = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-L5D-condition");
var l5l = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-L5L-condition");



if (l5d + l5l < 2.0) # we have a manifold 5 fail off condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-l5", 1);

	if ((l5d < 1.0) and (cws_msg_hash.l5d == 0))
		{
		create_fault_message("    L RCS D JET", 1, 2);
		cws_msg_hash.l5d = 1;
		}
	if ((l5l < 1.0) and (cws_msg_hash.l5l == 0))
		{
		create_fault_message("    L RCS L JET", 1, 2);
		cws_msg_hash.l5l = 1;
		}
	}


# Helium pressure

var lhep1 = getprop("/fdm/jsbsim/systems/rcs-hardware/helium-left-rcs-pressure-1-psia");
var lhep2 = getprop("/fdm/jsbsim/systems/rcs-hardware/helium-left-rcs-pressure-2-psia");


if ((lhep1 < 500.0) or (lhep2 < 500.0)) # helium pressure problem
	{
		if (cws_msg_hash.lhep == 0)
		{
		create_fault_message("    L HE P     ", 1, 2);
		cws_msg_hash.lhep = 1;
		}
	
	}

# propellant and oxidizer pressure

var lpp = getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-left-rcs-blowdown-psia");
var lop = getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-left-rcs-blowdown-psia");

if ((lpp < 200.0) or (lpp > 312.0) or (lop < 200.0) or (lop > 312.0))
	{
		if (cws_msg_hash.lpop == 0)
		{
		create_fault_message("    L RCS TK P ", 1, 2);
		cws_msg_hash.lpop = 1;
		}
	
	}

# leak detection

var loxidizer = getprop("/consumables/fuel/tank[8]/level-lbs")/1477.0;
var lpropellant = getprop("/consumables/fuel/tank[9]/level-lbs")/928.0;

if (math.abs(loxidizer - lpropellant) > 0.095) # we have a leak
	{
		if (cws_msg_hash.lleak == 0)
		{
		create_fault_message("    L RCS LEAK ", 1, 2);
		cws_msg_hash.lleak = 1;
		}
	}


		

}  		



#################################################
# CWS checks of right RCS
#################################################

var cws_inspect_right_rcs_thrusters = func {

# RIGHT manifold 1

var r1a = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-R1A-condition");
var r1r = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-R1R-condition");
var r1u = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-R1U-condition");


if (r1a + r1r + r1u < 3.0) # we have a manifold 1 fail off condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-r1", 1);

	if ((r1a < 1.0) and (cws_msg_hash.r1a == 0))
		{
		create_fault_message("    R RCS A JET", 1, 2);
		cws_msg_hash.r1a = 1;
		}
	if ((r1r < 1.0) and (cws_msg_hash.r1r == 0))
		{
		create_fault_message("    R RCS R JET", 1, 2);
		cws_msg_hash.r1r = 1;
		}
	if ((r1u < 1.0) and (cws_msg_hash.r1u == 0))
		{
		create_fault_message("    R RCS U JET", 1, 2);
		cws_msg_hash.r1u = 1;
		}
	}

# RIGHT manifold 2

var r2u = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-R2U-condition");
var r2r = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-R2R-condition");
var r2d = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-R2D-condition");


if (r2u + r2r + r2d < 3.0) # we have a manifold 2 fail off condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-r2", 1);

	if ((r2u < 1.0) and (cws_msg_hash.r2u == 0))
		{
		create_fault_message("    R RCS U JET", 1, 2);
		cws_msg_hash.r2u = 1;
		}
	if ((r2r < 1.0) and (cws_msg_hash.r2r == 0))
		{
		create_fault_message("    R RCS R JET", 1, 2);
		cws_msg_hash.r2r = 1;
		}
	if ((r2d < 1.0) and (cws_msg_hash.r2d == 0))
		{
		create_fault_message("    R RCS D JET", 1, 2);
		cws_msg_hash.r2d = 1;
		}
	}

# RIGHT manifold 3

var r3r = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-R3R-condition");
var r3a = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-R3A-condition");
var r3d = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-R3D-condition");


if (r3r + r3a + r3d < 3.0) # we have a manifold 3 fail off condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-r3", 1);

	if ((r3r < 1.0) and (cws_msg_hash.r3r == 0))
		{
		create_fault_message("    R RCS R JET", 1, 2);
		cws_msg_hash.r3r = 1;
		}
	if ((r3a < 1.0) and (cws_msg_hash.r3a == 0))
		{
		create_fault_message("    R RCS A JET", 1, 2);
		cws_msg_hash.r3a = 1;
		}
	if ((r3d < 1.0) and (cws_msg_hash.r3d == 0))
		{
		create_fault_message("    R RCS D JET", 1, 2);
		cws_msg_hash.r3d = 1;
		}
	}

# RIGHT manifold 4

var r4u = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-R4U-condition");
var r4r = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-R4R-condition");
var r4d = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-R4D-condition");


if (r4u + r4r + r4d < 3.0) # we have a manifold 4 fail off condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-r4", 1);

	if ((r4u < 1.0) and (cws_msg_hash.r4u == 0))
		{
		create_fault_message("    R RCS U JET", 1, 2);
		cws_msg_hash.r4u = 1;
		}
	if ((r4r < 1.0) and (cws_msg_hash.r4r == 0))
		{
		create_fault_message("    R RCS R JET", 1, 2);
		cws_msg_hash.r4r = 1;
		}
	if ((r4d < 1.0) and (cws_msg_hash.r4d == 0))
		{
		create_fault_message("    R RCS D JET", 1, 2);
		cws_msg_hash.r4d = 1;
		}
	}

# RIGHT manifold 5

var r5d = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-R5D-condition");
var r5r = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-R5R-condition");



if (r5d + r5r < 2.0) # we have a manifold 5 fail off condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-r5", 1);

	if ((r5d < 1.0) and (cws_msg_hash.r5d == 0))
		{
		create_fault_message("    R RCS D JET", 1, 2);
		cws_msg_hash.r5d = 1;
		}
	if ((r5r < 1.0) and (cws_msg_hash.r5r == 0))
		{
		create_fault_message("    R RCS R JET", 1, 2);
		cws_msg_hash.r5r = 1;
		}
	}

		
# Helium pressure

var rhep1 = getprop("/fdm/jsbsim/systems/rcs-hardware/helium-right-rcs-pressure-1-psia");
var rhep2 = getprop("/fdm/jsbsim/systems/rcs-hardware/helium-right-rcs-pressure-2-psia");


if ((rhep1 < 500.0) or (rhep2 < 500.0)) # helium pressure problem
	{
		if (cws_msg_hash.rhep == 0)
		{
		create_fault_message("    R HE P     ", 1, 2);
		cws_msg_hash.rhep = 1;
		}
	
	}

# propellant and oxidizer pressure

var rpp = getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-right-rcs-blowdown-psia");
var rop = getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-right-rcs-blowdown-psia");

if ((rpp < 200.0) or (rpp > 312.0) or (rop < 200.0) or (rop > 312.0))
	{
		if (cws_msg_hash.rpop == 0)
		{
		create_fault_message("    R RCS TK P ", 1, 2);
		cws_msg_hash.rpop = 1;
		}
	
	}

# leak detection

var roxidizer = getprop("/consumables/fuel/tank[10]/level-lbs")/1477.0;
var rpropellant = getprop("/consumables/fuel/tank[11]/level-lbs")/928.0;

if (math.abs(roxidizer - rpropellant) > 0.095) # we have a leak
	{
		if (cws_msg_hash.rleak == 0)
		{
		create_fault_message("    R RCS LEAK ", 1, 2);
		cws_msg_hash.rleak = 1;
		}
	}


}  		




#################################################
# CWS checks of OMS
#################################################

var cws_inspect_oms = func {


var left_engine_throttle = getprop("/fdm/jsbsim/fcs/throttle-cmd-norm[5]");
var right_engine_throttle = getprop("/fdm/jsbsim/fcs/throttle-cmd-norm[6]");

var left_engine_on = 0;
var right_engine_on = 0;

if (left_engine_throttle > 0.8) {left_engine_on = 1;}
if (right_engine_throttle > 0.8) {right_engine_on = 1;}

# OMS gimbal

var gimbal_left_pri = getprop("/fdm/jsbsim/systems/oms-hardware/gimbal-left-pri-selected");
var gimbal_left_sec = getprop("/fdm/jsbsim/systems/oms-hardware/gimbal-left-sec-selected");
var gimbal_right_pri = getprop("/fdm/jsbsim/systems/oms-hardware/gimbal-right-pri-selected");
var gimbal_right_sec = getprop("/fdm/jsbsim/systems/oms-hardware/gimbal-right-sec-selected");

var gimbal_check = getprop("/fdm/jsbsim/systems/oms-hardware/gimbal-chk-cmd");

#gimbal-left-pri-selected

if (gimbal_left_pri == 1)
	{var omslg = getprop("/fdm/jsbsim/systems/failures/oms-left-pri-gimbal-condition");}
else
	{var omslg = getprop("/fdm/jsbsim/systems/failures/oms-left-sec-gimbal-condition");}

if (gimbal_right_pri == 1)
	{var omsrg = getprop("/fdm/jsbsim/systems/failures/oms-right-pri-gimbal-condition");}
else
	{var omsrg = getprop("/fdm/jsbsim/systems/failures/oms-right-sec-gimbal-condition");}

if ((omslg < 0.8) and ((left_engine_on == 1) or (gimbal_check == 1)))
	{
		if (cws_msg_hash.omslg == 0)
		{
		create_fault_message("    L OMS GMBL ", 1, 2);
		cws_msg_hash.omslg = 1;
		}
	}

if ((omsrg < 0.8) and ((right_engine_on == 1)or (gimbal_check == 1)))
	{
		if (cws_msg_hash.omsrg == 0)
		{
		create_fault_message("    R OMS GMBL ", 1, 2);
		cws_msg_hash.omsrg = 1;
		}
	}


# inspect remaining OMS fuel quantity



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

# OMS chamber pressure

var left_oms_pc = getprop("/fdm/jsbsim/systems/oms-hardware/chamber-left-pc-percent");
var right_oms_pc = getprop("/fdm/jsbsim/systems/oms-hardware/chamber-right-pc-percent");

if ((left_oms_pc < 80.0) and (left_engine_on == 1))
	{
		if (cws_msg_hash.omslpc == 0)
		{
		create_fault_message("    L OMS PC   ", 1, 2);
		cws_msg_hash.omslpc = 1;
		}
	}

if ((right_oms_pc < 80.0) and (right_engine_on == 1))
	{
		if (cws_msg_hash.omsrpc == 0)
		{
		create_fault_message("    R OMS PC   ", 1, 2);
		cws_msg_hash.omsrpc = 1;
		}
	}

# OMS tank pressures

var left_oms_N2_p = getprop("/fdm/jsbsim/systems/oms-hardware/n2-left-oms-pressure-psia");
var left_oms_N2_reg_p = getprop("/fdm/jsbsim/systems/oms-hardware/n2-left-reg-pressure-psia");
var left_oms_He_p = getprop("/fdm/jsbsim/systems/oms-hardware/helium-left-oms-pressure-sh-psia");
var left_oms_tank_p = getprop("/fdm/jsbsim/systems/oms-hardware/tanks-left-oms-blowdown-psia");


var right_oms_N2_p = getprop("/fdm/jsbsim/systems/oms-hardware/n2-right-oms-pressure-psia");
var right_oms_N2_reg_p = getprop("/fdm/jsbsim/systems/oms-hardware/n2-right-reg-pressure-psia");
var right_oms_He_p = getprop("/fdm/jsbsim/systems/oms-hardware/helium-right-oms-pressure-sh-psia");
var right_oms_tank_p = getprop("/fdm/jsbsim/systems/oms-hardware/tanks-right-oms-blowdown-psia");

if ((left_oms_N2_p < 1200.0) or (left_oms_N2_reg_p < 299.0) or (left_oms_N2_reg_p > 434) or (left_oms_He_p < 1500.0) or (left_oms_tank_p > 288.0) or (left_oms_tank_p < 234.0))
	{
		if (cws_msg_hash.omsltkp == 0)
		{
		create_fault_message("    L OMS TK P ", 1, 2);
		cws_msg_hash.omsltkp = 1;
		}
	}

if ((right_oms_N2_p < 1200.0) or (right_oms_N2_reg_p < 299.0) or (right_oms_N2_reg_p > 434) or (right_oms_He_p < 1500.0) or (right_oms_tank_p > 288.0) or (right_oms_tank_p < 234.0))
	{
		if (cws_msg_hash.omsrtkp == 0)
		{
		create_fault_message("    R OMS TK P ", 1, 2);
		cws_msg_hash.omsrtkp = 1;
		}
	}

}



#################################################
# CWS checks of fuel cell and electric systems
#################################################

var cws_inspect_fc_electric = func {

var init_phase = getprop("/fdm/jsbsim/systems/electrical/init-electrical-on");

if (init_phase > 0.0) {init_phase = 1.0;} else {init_phase = 0.0;}

var voltage_ac1 = getprop("/fdm/jsbsim/systems/electrical/ac/voltage");
var voltage_ac2 = getprop("/fdm/jsbsim/systems/electrical/ac[1]/voltage");
var voltage_ac3 = getprop("/fdm/jsbsim/systems/electrical/ac[2]/voltage");

if (((voltage_ac1 < 115.0) or (voltage_ac2 < 115.0) or (voltage_ac3 < 115.0)) and (init_phase == 0.0))
	{
		if (cws_msg_hash.acvolt == 0)
		{
		create_fault_message("S67 AC VOLTS   ", 1, 2);
		cws_msg_hash.acvolt = 1;
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
