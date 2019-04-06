# high level caution and warning system routines for the Space Shuttle
# Thorsten Renk 2015

var inspection_group  = 0;

var cws_message_array = [];

var cws_message_array_long = ["","","","","","","","","","","","","","",""];

var cws_last_message_acknowledge = 0;
var meds_last_message_acknowledge = 0;

# the message hash stores the information what faults have already been announced

var cws_msg_hash = {
f1f : 0, f1l : 0, f1u : 0, f1d : 0, f2f : 0, f2r : 0, f2u : 0, f2d : 0, f3f : 0, f3l : 0, f3u : 0, f3d : 0, f4r : 0, f4d : 0, f5r : 0, f5l : 0,
l1a : 0, l1l : 0, l1u : 0, l2u: 0, l2l : 0, l2d : 0, l3l : 0, l3a : 0, l3d : 0, l4u : 0, l4l : 0, l4d : 0, l5d : 0, l5l : 0,
r1a : 0, r1r : 0, r1u : 0, r2u: 0, r2r : 0, r2d : 0, r3r : 0, r3a : 0, r3d : 0, r4u : 0, r4r : 0, r4d : 0, r5d : 0, r5r : 0,
fhep : 0, fpop : 0, fleak : 0, lhep: 0, lpop: 0, lleak: 0, rhep: 0, rpop: 0, rleak: 0,
omslg : 0, omsrg : 0, omslqty : 0, omsrqty : 0, omslpc : 0, omsrpc : 0, omsltkp: 0, omsrtkp: 0,
acvolt : 0,
rm_fail_tac: 0, rm_dlm_tac: 0, nav_edit_tac: 0, probes: 0, nav_edit_alt: 0, rm_fail_adta: 0, rm_dlma_adta: 0,
rm_fail_imu: 0, rm_dlma_imu: 0,
ssme_fail_l: 0, ssme_fail_c: 0, ssme_fail_r: 0, mps_hyd_l: 0, mps_hyd_c: 0, mps_hyd_r: 0,
mps_elec_l: 0, mps_elec_c: 0, mps_elec_r: 0, et_sep_inh: 0,

no_y_jet_switchover: 0,
};


var meds_msg_hash = {
io : [0,0,0,0,0,0,0,0,0,0,0],
port_change: [0,0,0,0,0,0,0,0,0,0,0],
poll: [0,0,0,0],
};

var cws_inspect = func {

if (inspection_group == 0) 
	{cws_inspect_fwd_rcs_thrusters();}


if (inspection_group == 1) 
	{cws_inspect_left_rcs_thrusters();}

if (inspection_group == 2) 
	{cws_inspect_right_rcs_thrusters();}

if (inspection_group == 3)
	{cws_inspect_oms();}

if (inspection_group == 4)
	{cws_inspect_fc_electric();}

if (inspection_group == 5)
	{meds_inspect();}

if (inspection_group == 6)
	{cws_inspect_nav();}

if (inspection_group == 8)
	{SpaceShuttle.master_alarm_mngr.inspect();}


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
		create_fault_message("G23 F RCS F JET ", 1, 2);
		cws_msg_hash.f1f = 1;
		}
	if ((f1l < 1.0) and (cws_msg_hash.f1l == 0))
		{
		create_fault_message("G23 F RCS L JET ", 1, 2);
		cws_msg_hash.f1l = 1;
		}
	if ((f1u < 1.0) and (cws_msg_hash.f1u == 0))
		{
		create_fault_message("G23 F RCS U JET ", 1, 2);
		cws_msg_hash.f1u = 1;
		}
	if ((f1d < 1.0) and (cws_msg_hash.f1d == 0))
		{
		create_fault_message("G23 F RCS D JET ", 1, 2);
		cws_msg_hash.f1d = 1;
		}
	}
else if (f1f + f1l + f1u + f1d > 4.0) # we have a manifold 1 fail on condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-f1", 2);

	if ((f1f > 1.0) and (cws_msg_hash.f1f == 0))
		{
		create_fault_message("G23 F RCS F JET ", 1, 2);
		cws_msg_hash.f1f = 1;
		}
	if ((f1l > 1.0) and (cws_msg_hash.f1l == 0))
		{
		create_fault_message("G23 F RCS L JET ", 1, 2);
		cws_msg_hash.f1l = 1;
		}
	if ((f1u > 1.0) and (cws_msg_hash.f1u == 0))
		{
		create_fault_message("G23 F RCS U JET ", 1, 2);
		cws_msg_hash.f1u = 1;
		}
	if ((f1d > 1.0) and (cws_msg_hash.f1d == 0))
		{
		create_fault_message("G23 F RCS D JET ", 1, 2);
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
		create_fault_message("G23 F RCS F JET ", 1, 2);
		cws_msg_hash.f2f = 1;
		}
	if ((f2r < 1.0) and (cws_msg_hash.f2r == 0))
		{
		create_fault_message("G23 F RCS R JET ", 1, 2);
		cws_msg_hash.f2r = 1;
		}
	if ((f2u < 1.0) and (cws_msg_hash.f2u == 0))
		{
		create_fault_message("G23 F RCS U JET ", 1, 2);
		cws_msg_hash.f2u = 1;
		}
	if ((f2d < 1.0) and (cws_msg_hash.f2d == 0))
		{
		create_fault_message("G23 F RCS D JET ", 1, 2);
		cws_msg_hash.f2d = 1;
		}
	}
else if (f2f + f2r + f2u + f2d > 4.0) # we have a manifold 2 fail on condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-f2", 2);

	if ((f2f > 1.0) and (cws_msg_hash.f2f == 0))
		{
		create_fault_message("G23 F RCS F JET ", 1, 2);
		cws_msg_hash.f2f = 1;
		}
	if ((f2r > 1.0) and (cws_msg_hash.f2r == 0))
		{
		create_fault_message("G23 F RCS R JET ", 1, 2);
		cws_msg_hash.f2r = 1;
		}
	if ((f2u > 1.0) and (cws_msg_hash.f2u == 0))
		{
		create_fault_message("G23 F RCS U JET ", 1, 2);
		cws_msg_hash.f2u = 1;
		}
	if ((f2d > 1.0) and (cws_msg_hash.f2d == 0))
		{
		create_fault_message("G23 F RCS D JET ", 1, 2);
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
		create_fault_message("G23 F RCS F JET ", 1, 2);
		cws_msg_hash.f3f = 1;
		}
	if ((f3l < 1.0) and (cws_msg_hash.f3l == 0))
		{
		create_fault_message("G23 F RCS L JET ", 1, 2);
		cws_msg_hash.f3l = 1;
		}
	if ((f3u < 1.0) and (cws_msg_hash.f3u == 0))
		{
		create_fault_message("G23 F RCS U JET ", 1, 2);
		cws_msg_hash.f3u = 1;
		}
	if ((f3d < 1.0) and (cws_msg_hash.f3d == 0))
		{
		create_fault_message("G23 F RCS D JET ", 1, 2);
		cws_msg_hash.f3d = 1;
		}
	}
else if (f3f + f3l + f3u + f3d > 4.0) # we have a manifold 3 fail on condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-f3", 2);

	if ((f3f > 1.0) and (cws_msg_hash.f3f == 0))
		{
		create_fault_message("G23 F RCS F JET ", 1, 2);
		cws_msg_hash.f3f = 1;
		}
	if ((f3l > 1.0) and (cws_msg_hash.f3l == 0))
		{
		create_fault_message("G23 F RCS L JET ", 1, 2);
		cws_msg_hash.f3l = 1;
		}
	if ((f3u > 1.0) and (cws_msg_hash.f3u == 0))
		{
		create_fault_message("G23 F RCS U JET ", 1, 2);
		cws_msg_hash.f3u = 1;
		}
	if ((f3d > 1.0) and (cws_msg_hash.f3d == 0))
		{
		create_fault_message("G23 F RCS D JET ", 1, 2);
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
		create_fault_message("G23 F RCS R JET ", 1, 2);
		cws_msg_hash.f4r = 1;
		}
	if ((f4d < 1.0) and (cws_msg_hash.f4d == 0))
		{
		create_fault_message("G23 F RCS D JET ", 1, 2);
		cws_msg_hash.f4d = 1;
		}
	}
else if (f4r + f4d > 2.0) # we have a manifold 4 fail on condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-f4", 2);

	if ((f4r > 1.0) and (cws_msg_hash.f4r == 0))
		{
		create_fault_message("G23 F RCS R JET ", 1, 2);
		cws_msg_hash.f4r = 1;
		}
	if ((f4d > 1.0) and (cws_msg_hash.f4d == 0))
		{
		create_fault_message("G23 F RCS D JET ", 1, 2);
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
		create_fault_message("G23 F RCS R JET ", 1, 2);
		cws_msg_hash.f5r = 1;
		}
	if ((f5l < 1.0) and (cws_msg_hash.f5l == 0))
		{
		create_fault_message("G23 F RCS L JET ", 1, 2);
		cws_msg_hash.f5l = 1;
		}
	}
else if (f5r + f5l > 2.0) # we have a manifold 5 fail on condition
	{
	setprop("/fdm/jsbsim/systems/cws/jet-fail-f5", 2);

	if ((f5r > 1.0) and (cws_msg_hash.f5r == 0))
		{
		create_fault_message("G23 F RCS R JET ", 1, 2);
		cws_msg_hash.f5r = 1;
		}
	if ((f5l > 1.0) and (cws_msg_hash.f5l == 0))
		{
		create_fault_message("G23 F RCS L JET ", 1, 2);
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
		create_fault_message("    F HE P      ", 1, 2);
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
		create_fault_message("    F RCS TK P  ", 1, 2);
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
		create_fault_message("    F RCS LEAK  ", 1, 2);
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
		create_fault_message("G23 L RCS A JET ", 1, 2);
		cws_msg_hash.l1a = 1;
		}
	if ((l1l < 1.0) and (cws_msg_hash.l1l == 0))
		{
		create_fault_message("G23 L RCS L JET ", 1, 2);
		cws_msg_hash.l1l = 1;
		}
	if ((l1u < 1.0) and (cws_msg_hash.l1u == 0))
		{
		create_fault_message("G23 L RCS U JET ", 1, 2);
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
		create_fault_message("G23 L RCS U JET ", 1, 2);
		cws_msg_hash.l2u = 1;
		}
	if ((l2l < 1.0) and (cws_msg_hash.l2l == 0))
		{
		create_fault_message("G23 L RCS L JET ", 1, 2);
		cws_msg_hash.l2l = 1;
		}
	if ((l2d < 1.0) and (cws_msg_hash.l2d == 0))
		{
		create_fault_message("G23 L RCS D JET ", 1, 2);
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
		create_fault_message("G23 L RCS L JET ", 1, 2);
		cws_msg_hash.l3l = 1;
		}
	if ((l3a < 1.0) and (cws_msg_hash.l3a == 0))
		{
		create_fault_message("G23 L RCS A JET ", 1, 2);
		cws_msg_hash.l3a = 1;
		}
	if ((l3d < 1.0) and (cws_msg_hash.l3d == 0))
		{
		create_fault_message("G23 L RCS D JET ", 1, 2);
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
		create_fault_message("G23 L RCS U JET ", 1, 2);
		cws_msg_hash.l4u = 1;
		}
	if ((l4l < 1.0) and (cws_msg_hash.l4l == 0))
		{
		create_fault_message("G23 L RCS L JET ", 1, 2);
		cws_msg_hash.l4l = 1;
		}
	if ((l4d < 1.0) and (cws_msg_hash.l4d == 0))
		{
		create_fault_message("G23 L RCS D JET ", 1, 2);
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
		create_fault_message("G23 L RCS D JET ", 1, 2);
		cws_msg_hash.l5d = 1;
		}
	if ((l5l < 1.0) and (cws_msg_hash.l5l == 0))
		{
		create_fault_message("G23 L RCS L JET ", 1, 2);
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
		create_fault_message("    L HE P      ", 1, 2);
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
		create_fault_message("    L RCS TK P  ", 1, 2);
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
		create_fault_message("    L RCS LEAK  ", 1, 2);
		cws_msg_hash.lleak = 1;
		}
	}


# automatic switch to NO Y JET in case of multiple yaw jet failures

if ((l1l + l2l + l3l + l4l) < 2.0)
	{
	if (cws_msg_hash.no_y_jet_switchover == 0)
		{
		var ops = getprop("/fdm/jsbsim/systems/dps/ops");
		var qbar = getprop("/fdm/jsbsim/aero/qbar-psf");
		var switch = getprop("/fdm/jsbsim/systems/fcs/entry-mode-switch");
		var mach = getprop("/fdm/jsbsim/velocities/mach");

		if ((ops ==3) and (qbar > 10.0) and (switch == 0) and (mach > 3.5))		
			{
			setprop("/fdm/jsbsim/systems/fcs/rcs-yaw-mode", 0);
			setprop("/fdm/jsbsim/systems/fcs/no-y-jet", 1);
			print("Switching entry mode to NO Y JET"); 
			cws_msg_hash.no_y_jet_switchover = 1;
			}
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
		create_fault_message("G23 R RCS A JET ", 1, 2);
		cws_msg_hash.r1a = 1;
		}
	if ((r1r < 1.0) and (cws_msg_hash.r1r == 0))
		{
		create_fault_message("G23 R RCS R JET ", 1, 2);
		cws_msg_hash.r1r = 1;
		}
	if ((r1u < 1.0) and (cws_msg_hash.r1u == 0))
		{
		create_fault_message("G23 R RCS U JET ", 1, 2);
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
		create_fault_message("G23 R RCS U JET ", 1, 2);
		cws_msg_hash.r2u = 1;
		}
	if ((r2r < 1.0) and (cws_msg_hash.r2r == 0))
		{
		create_fault_message("G23 R RCS R JET ", 1, 2);
		cws_msg_hash.r2r = 1;
		}
	if ((r2d < 1.0) and (cws_msg_hash.r2d == 0))
		{
		create_fault_message("G23 R RCS D JET ", 1, 2);
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
		create_fault_message("G23 R RCS R JET ", 1, 2);
		cws_msg_hash.r3r = 1;
		}
	if ((r3a < 1.0) and (cws_msg_hash.r3a == 0))
		{
		create_fault_message("G23 R RCS A JET ", 1, 2);
		cws_msg_hash.r3a = 1;
		}
	if ((r3d < 1.0) and (cws_msg_hash.r3d == 0))
		{
		create_fault_message("G23 R RCS D JET ", 1, 2);
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
		create_fault_message("G23 R RCS U JET ", 1, 2);
		cws_msg_hash.r4u = 1;
		}
	if ((r4r < 1.0) and (cws_msg_hash.r4r == 0))
		{
		create_fault_message("G23 R RCS R JET ", 1, 2);
		cws_msg_hash.r4r = 1;
		}
	if ((r4d < 1.0) and (cws_msg_hash.r4d == 0))
		{
		create_fault_message("G23 R RCS D JET ", 1, 2);
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
		create_fault_message("G23 R RCS D JET ", 1, 2);
		cws_msg_hash.r5d = 1;
		}
	if ((r5r < 1.0) and (cws_msg_hash.r5r == 0))
		{
		create_fault_message("G23 R RCS R JET ", 1, 2);
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
		create_fault_message("    R HE P      ", 1, 2);
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
		create_fault_message("    R RCS TK P  ", 1, 2);
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
		create_fault_message("    R RCS LEAK  ", 1, 2);
		cws_msg_hash.rleak = 1;
		}
	}


# automatic switch to NO Y JET in case of multiple yaw jet failures

if ((r1r + r2r + r3r + r4r) < 2.0)
	{
	if (cws_msg_hash.no_y_jet_switchover == 0)
		{
		var ops = getprop("/fdm/jsbsim/systems/dps/ops");
		var qbar = getprop("/fdm/jsbsim/aero/qbar-psf");
		var switch = getprop("/fdm/jsbsim/systems/fcs/entry-mode-switch");
		var mach = getprop("/fdm/jsbsim/velocities/mach");

		if ((ops ==3) and (qbar > 10.0) and (switch == 0) and (mach > 3.5))		
			{
			setprop("/fdm/jsbsim/systems/fcs/rcs-yaw-mode", 0);
			setprop("/fdm/jsbsim/systems/fcs/no-y-jet", 1);
			print("Switching entry mode to NO Y JET"); 
			cws_msg_hash.no_y_jet_switchover = 1;
			}
		}

	}


}  		




#################################################
# CWS checks of OMS
#################################################

var cws_inspect_oms = func {

var mm =  getprop("/fdm/jsbsim/systems/dps/major-mode");

if ((mm == 304) or (mm == 305)) {return;}

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
	{var omslg = getprop("/fdm/jsbsim/systems/failures/oms/oms-left-pri-gimbal-condition");}
else
	{var omslg = getprop("/fdm/jsbsim/systems/failures/oms/oms-left-sec-gimbal-condition");}

if (gimbal_right_pri == 1)
	{var omsrg = getprop("/fdm/jsbsim/systems/failures/oms/oms-right-pri-gimbal-condition");}
else
	{var omsrg = getprop("/fdm/jsbsim/systems/failures/oms/oms-right-sec-gimbal-condition");}

if ((omslg < 0.8) and ((left_engine_on == 1) or (gimbal_check == 1)))
	{
		if (cws_msg_hash.omslg == 0)
		{
		create_fault_message("    L OMS GMBL  ", 1, 2);
		cws_msg_hash.omslg = 1;
		}
	}

if ((omsrg < 0.8) and ((right_engine_on == 1)or (gimbal_check == 1)))
	{
		if (cws_msg_hash.omsrg == 0)
		{
		create_fault_message("    R OMS GMBL  ", 1, 2);
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
		create_fault_message("    L OMS QTY   ", 1, 3);
		cws_msg_hash.omslqty = 1;
		}
	}

if ((omsroqty < 0.05) or (omsrpqty < 0.05))
	{
		if (cws_msg_hash.omsrqty == 0)
		{
		create_fault_message("    R OMS QTY   ", 1, 3);
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
		create_fault_message("    L OMS PC    ", 1, 2);
		cws_msg_hash.omslpc = 1;
		}
	}

if ((right_oms_pc < 80.0) and (right_engine_on == 1))
	{
		if (cws_msg_hash.omsrpc == 0)
		{
		create_fault_message("    R OMS PC    ", 1, 2);
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
		create_fault_message("    L OMS TK P  ", 1, 2);
		cws_msg_hash.omsltkp = 1;
		}
	}

if ((right_oms_N2_p < 1200.0) or (right_oms_N2_reg_p < 299.0) or (right_oms_N2_reg_p > 434) or (right_oms_He_p < 1500.0) or (right_oms_tank_p > 288.0) or (right_oms_tank_p < 234.0))
	{
		if (cws_msg_hash.omsrtkp == 0)
		{
		create_fault_message("    R OMS TK P  ", 1, 2);
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
		create_fault_message("S67 AC VOLTS    ", 1, 2);
		cws_msg_hash.acvolt = 1;
		}
	}

}



#################################################
# CWS checks of navigation
#################################################

var cws_inspect_nav = func {


if ((SpaceShuttle.imu_system.imu[0].soft_failed == 1) or (SpaceShuttle.imu_system.imu[1].soft_failed == 1) or (SpaceShuttle.imu_system.imu[2].soft_failed == 1))
	{
	if (cws_msg_hash.rm_fail_imu == 0)
		{
		var string = "G51";
		if (getprop("/fdm/jsbsim/systems/dps/ops") == 2)
			{
			string = "G21";
			}

		create_fault_message(string~" RM FAIL IMU ", 1, 2);	
		cws_msg_hash.rm_fail_imu = 1;
		}
	}

if ((SpaceShuttle.imu_system.imu[0].dilemma == 1) or (SpaceShuttle.imu_system.imu[1].dilemma == 1) or (SpaceShuttle.imu_system.imu[2].dilemma == 1))
	{
	if (cws_msg_hash.rm_dlma_imu == 0)
		{
		var string = "G51";
		if (getprop("/fdm/jsbsim/systems/dps/ops") == 2)
			{
			string = "G21";
			}

		create_fault_message(string~" RM DLMA IMU ", 1, 2);	
		cws_msg_hash.rm_dlma_imu = 1;

		SpaceShuttle.orbital_dap_manager.load_dap("IMU_FAIL");
		}
	}


var mm =  getprop("/fdm/jsbsim/systems/dps/major-mode");

if ((mm != 304) and (mm != 305) and (mm != 602) and (mm != 603)) {return;}

if (SpaceShuttle.tacan_system.dilemma == 1)
	{
	if (cws_msg_hash.rm_dlm_tac == 0)
		{
		create_fault_message("G50 RM DLMA TAC ", 1, 2);	
		cws_msg_hash.rm_dlm_tac = 1;
		}
	}

if ((SpaceShuttle.tacan_system.receiver[0].soft_failed == 1) or (SpaceShuttle.tacan_system.receiver[1].soft_failed == 1) or (SpaceShuttle.tacan_system.receiver[2].soft_failed == 1))
	{
	if (cws_msg_hash.rm_fail_tac == 0)
		{
		create_fault_message("G50 RM FAIL TAC ", 1, 2);	
		cws_msg_hash.rm_fail_tac = 1;
		}
	}


if ((getprop("/position/altitude-ft") < 130000.0) and (SpaceShuttle.area_nav_set.TACAN_inh == 1))
	{
	if (cws_msg_hash.nav_edit_tac == 0)
		{
		create_fault_message("G50 NAV EDIT TAC", 1, 1);	
		cws_msg_hash.nav_edit_tac = 1;

		}

	}


var mach = getprop("/velocities/mach");

if ((mach < 2.5) and (getprop("/fdm/jsbsim/systems/navigation/air-data-left-pos-kin") == 1.0) and (getprop("/fdm/jsbsim/systems/navigation/air-data-left-pos") < 1))
	{
	if (cws_msg_hash.probes == 0)
		{
		create_fault_message("    PROBES      ", 1, 2);	
		cws_msg_hash.probes = 1;	
		}
	}

if ((mach < 2.5) and (getprop("/fdm/jsbsim/systems/navigation/air-data-right-pos-kin") == 1.0) and (getprop("/fdm/jsbsim/systems/navigation/air-data-right-pos") < 1))
	{
	if (cws_msg_hash.probes == 0)
		{
		create_fault_message("    PROBES      ", 1, 2);	
		cws_msg_hash.probes = 1;	
		}
	}

if ((mach < 2.5) and (SpaceShuttle.area_nav_set.air_data_h_inh == 1))
	{
	if (cws_msg_hash.nav_edit_alt == 0)
		{
		create_fault_message("G50 NAV EDIT ALT", 1, 1);	
		cws_msg_hash.nav_edit_alt = 1;	
		}

	}

if ((SpaceShuttle.air_data_system.adta[0].soft_failed == 1) or (SpaceShuttle.air_data_system.adta[1].soft_failed == 1) or (SpaceShuttle.air_data_system.adta[2].soft_failed == 1) or (SpaceShuttle.air_data_system.adta[3].soft_failed == 1))
	{
	if (cws_msg_hash.rm_fail_adta == 0)
		{
		create_fault_message("G51 RM FAIL ADTA", 1, 2);	
		cws_msg_hash.rm_fail_adta = 1;
		}
	}

if ((SpaceShuttle.air_data_system.adta[0].dilemma == 1) or (SpaceShuttle.air_data_system.adta[1].dilemma == 1) or (SpaceShuttle.air_data_system.adta[2].dilemma == 1) or (SpaceShuttle.air_data_system.adta[3].dilemma == 1))
	{
	if (cws_msg_hash.rm_dlma_adta == 0)
		{
		create_fault_message("G51 RM DLMA ADTA", 1, 2);	
		cws_msg_hash.rm_dlma_adta = 1;
		}
	}





}



#################################################
# CWS checks of MPS
#################################################

var cws_inspect_mps = func {

if (getprop("/fdm/jsbsim/systems/mps/engine/electric-lockup") == 1)
	{
	if (cws_msg_hash.mps_elec_l == 0)
		{
		create_fault_message("    MPS ELEC L  ", 1, 2);	
		cws_msg_hash.mps_elec_l = 1;
		}
	}

if (getprop("/fdm/jsbsim/systems/mps/engine[1]/electric-lockup") == 1)
	{
	if (cws_msg_hash.mps_elec_r == 0)
		{
		create_fault_message("    MPS ELEC R  ", 1, 2);	
		cws_msg_hash.mps_elec_r = 1;
		}
	}

if (getprop("/fdm/jsbsim/systems/mps/engine[2]/electric-lockup") == 1)
	{
	if (cws_msg_hash.mps_elec_c == 0)
		{
		create_fault_message("    MPS ELEC C  ", 1, 2);	
		cws_msg_hash.mps_elec_c = 1;
		}
	}

if (getprop("/fdm/jsbsim/systems/mps/engine/hydraulic-power") == 0)
	{
	if (cws_msg_hash.mps_hyd_l == 0)
		{
		create_fault_message("    MPS HYD L   ", 1, 2);	
		cws_msg_hash.mps_hyd_l = 1;
		}
	}

if (getprop("/fdm/jsbsim/systems/mps/engine[1]/hydraulic-power") == 0)
	{
	if (cws_msg_hash.mps_hyd_r == 0)
		{
		create_fault_message("    MPS HYD R   ", 1, 2);	
		cws_msg_hash.mps_hyd_r = 1;
		}
	}

if (getprop("/fdm/jsbsim/systems/mps/engine[2]/hydraulic-power") == 0)
	{
	if (cws_msg_hash.mps_hyd_c == 0)
		{
		create_fault_message("    MPS HYD C   ", 1, 2);	
		cws_msg_hash.mps_hyd_c = 1;
		}
	}


# don't notify engine shutdown after regular MECO or if we don't know MECO

if (getprop("/fdm/jsbsim/systems/ap/launch/regular-meco-condition") == 1) {return;}

if (getprop("/fdm/jsbsim/systems/mps/engine/engine-operational") == 0)
	{
	if (cws_msg_hash.ssme_fail_l == 0)
		{
		create_fault_message("    SSME FAIL L ", 1, 2);	
		cws_msg_hash.ssme_fail_l = 1;
		}

	}

if (getprop("/fdm/jsbsim/systems/mps/engine[1]/engine-operational") == 0)
	{
	if (cws_msg_hash.ssme_fail_r == 0)
		{
		create_fault_message("    SSME FAIL R ", 1, 2);	
		cws_msg_hash.ssme_fail_r = 1;
		}

	}

if (getprop("/fdm/jsbsim/systems/mps/engine[2]/engine-operational") == 0)
	{
	if (cws_msg_hash.ssme_fail_c == 0)
		{
		create_fault_message("    SSME FAIL C ", 1, 2);	
		cws_msg_hash.ssme_fail_c = 1;
		}

	}


}


#################################################
# MEDS inspection
#################################################

var meds_inspect = func {

for (var i=0; i< size(SpaceShuttle.MDU_array); i=i+1)
	{
	var mdu = SpaceShuttle.MDU_array[i];

	var idp_index = mdu.PFD.port_selected - 1;

	if ((mdu.operational == 0) and (meds_msg_hash.io[i] == 0))
		{
		meds_msg_hash.io[i] = 1;
		var message = create_meds_message("I/O ERROR           ", mdu.designation);

		SpaceShuttle.idp_array[idp_index].current_fault_string = message;
		#print (message);	

		insert_meds_message(message, idp_index);
		}

	if ((mdu.PFD.polling_status == 0) and (meds_msg_hash.poll[idp_index] == 0))
		{
		meds_msg_hash.poll[idp_index] = 1;

		var message = create_meds_message("POLL FAIL           ", "IDP"~(idp_index+1));

		SpaceShuttle.idp_array[idp_index].current_fault_string = message;

		insert_meds_message(message, idp_index);

		}


	if ((mdu.PFD.auto_reconf_flag == 1) and (meds_msg_hash.port_change[i] == 0))
		{
		meds_msg_hash.port_change[i] = 1;
		var message = create_meds_message("PORT CHANGE         ", mdu.designation);

		mdu.PFD.auto_reconf_flag = 0;

		SpaceShuttle.idp_array[idp_index].current_fault_string = message;

		insert_meds_message(message, idp_index);

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


var insert_meds_message = func (message, idp_index) {


for (var i = 0; i<14; i=i+1)
	{
	SpaceShuttle.idp_array[idp_index].fault_array[14-i] = SpaceShuttle.idp_array[idp_index].fault_array[13-i];
	}
SpaceShuttle.idp_array[idp_index].fault_array[0] = message;

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
setprop("/fdm/jsbsim/systems/cws/sm-alert-on", 1);
cws_last_message_acknowledge = 1;

}


var create_meds_message = func (text, origin) {

var time_string = getprop("/sim/time/gmt-string");

meds_last_message_acknowledge = 1;

return (origin~" "~text~"          "~time_string);

}


#################################################
# I/O reset
#################################################

# (this re-triggers search for 'fixable' faults)

var io_reset = func {

cws_msg_hash.acvolt = 0;
cws_msg_hash.rm_fail_tac = 0;
cws_msg_hash.rm_dlm_tac = 0;
cws_msg_hash.nav_edit_tac = 0;
cws_msg_hash.nav_edit_alt = 0;
cws_msg_hash.rm_fail_adta = 0;
cws_msg_hash.rm_dlma_adta = 0;
cws_msg_hash.rm_fail_imu = 0;
cws_msg_hash.rm_dlma_imu = 0;

}


var io_reset_bfs = func {

setprop("/fdm/jsbsim/systems/dps/bfs/bfs-transient-error", 0);

if (SpaceShuttle.bfs_in_control == 1)
	{
	setprop("/fdm/jsbsim/systems/dps/bfs/bfc-light-status",1);
	}
else
	{
	setprop("/fdm/jsbsim/systems/dps/bfs/bfc-light-status",0);
	}

}


#################################################
# BFS/PASS discrepancies
#################################################


var compare_bfs_pass = func {

if (SpaceShuttle.bfs_in_control == 1) {return;}

var error_pitch = getprop("/fdm/jsbsim/systems/navigation/state-vector/pass/error-pitch");
var error_roll = getprop("/fdm/jsbsim/systems/navigation/state-vector/pass/error-roll");
var error_yaw = getprop("/fdm/jsbsim/systems/navigation/state-vector/pass/error-yaw");
var transient_error = 0;

if (SpaceShuttle.dps_simulation_detail_level == 1)
	{transient_error = getprop("/fdm/jsbsim/systems/dps/bfs/bfs-transient-error");}

if ((math.abs(error_pitch) > 0.0) or (math.abs(error_roll) > 0.0) or (math.abs(error_yaw) > 0.0) or (transient_error == 1))
	{
	SpaceShuttle.toggle_property("/fdm/jsbsim/systems/dps/bfs/bfc-light-status");
	}
}


#################################################
# Master Alarm
#################################################


var master_alarm_mngr = {

	# 0: no issue 1: light and alarm on 2: light on, alarm tone ended

	left_oms_flag: 0,
	right_oms_flag: 0,
	kit_oms_flag: 0,
	oms_tvc_flag: 0,
	fwd_rcs_flag: 0,
	left_rcs_flag: 0,
	right_rcs_flag: 0,
	fc_stack_temp_flag: 0,
	fc_pump_flag: 0,
	fc_reac_flag: 0,
	main_bus_undervolt_flag: 0,
	ac_voltage_flag: 0,
	h2o_loop_flag: 0,
	freon_loop_flag: 0,
	cabin_atm_flag: 0,
	avbay_cabin_air_flag: 0,
	hyd_press_flag: 0,
	apu_overspeed_flag: 0,
	apu_underspeed_flag: 0,
	apu_temp_flag: 0,	
	mps_flag: 0,
	depressurize_flag: 0,
	smoke_flag: 0,


	mode: 0, # -1: ASCENT 0: NORM 1: ACK


	init: func {
		
		me.nd_ref_left_oms = props.globals.getNode("/fdm/jsbsim/systems/cws/left-oms", 1);
		me.nd_ref_right_oms = props.globals.getNode("/fdm/jsbsim/systems/cws/right-oms", 1);
		me.nd_ref_kit_oms = props.globals.getNode("/fdm/jsbsim/systems/cws/kit-oms", 1);
		me.nd_ref_oms_tvc = props.globals.getNode("/fdm/jsbsim/systems/cws/oms-tvc", 1);
		me.nd_ref_fwd_rcs = props.globals.getNode("/fdm/jsbsim/systems/cws/fwd-rcs", 1);
		me.nd_ref_left_rcs = props.globals.getNode("/fdm/jsbsim/systems/cws/left-rcs", 1);
		me.nd_ref_right_rcs = props.globals.getNode("/fdm/jsbsim/systems/cws/right-rcs", 1);
		me.nd_ref_fuel_cell_stack_temp = props.globals.getNode("/fdm/jsbsim/systems/cws/fuel-cell-stack-temp", 1);
		me.nd_ref_fuel_cell_pump = props.globals.getNode("/fdm/jsbsim/systems/cws/fuel-cell-pump", 1);
		me.nd_ref_fuel_cell_reac = props.globals.getNode("/fdm/jsbsim/systems/cws/fuel-cell-reac", 1);
		me.nd_ref_main_bus_undervolt = props.globals.getNode("/fdm/jsbsim/systems/cws/main-bus-undervolt", 1);
		me.nd_ref_ac_voltage = props.globals.getNode("/fdm/jsbsim/systems/cws/ac-voltage", 1);
		me.nd_ref_h2o_loop = props.globals.getNode("/fdm/jsbsim/systems/cws/h2o-loop", 1);
		me.nd_ref_freon_loop = props.globals.getNode("/fdm/jsbsim/systems/cws/freon-loop", 1);
		me.nd_ref_cabin_atm = props.globals.getNode("/fdm/jsbsim/systems/cws/cabin-atm", 1);
		me.nd_ref_avbay_cabin_air = props.globals.getNode("/fdm/jsbsim/systems/cws/avbay-cabin-air", 1);
		me.nd_ref_hyd_press = props.globals.getNode("/fdm/jsbsim/systems/cws/hyd-press", 1);
		me.nd_ref_apu_overspeed = props.globals.getNode("/fdm/jsbsim/systems/cws/apu-overspeed", 1);
		me.nd_ref_apu_underspeed = props.globals.getNode("/fdm/jsbsim/systems/cws/apu-underspeed", 1);
		me.nd_ref_apu_temp = props.globals.getNode("/fdm/jsbsim/systems/cws/apu-temp", 1);
		me.nd_ref_mps = props.globals.getNode("/fdm/jsbsim/systems/cws/mps", 1);
		me.nd_ref_depressurize = props.globals.getNode("/fdm/jsbsim/systems/cws/emergency-depressurization", 1);
		},


	inspect: func {


		var flag = 0;

		# left OMS
		if (me.nd_ref_left_oms.getValue() == 1) 
			{
			if (me.left_oms_flag == 0)
				{
				me.set_class2_alarm();
				me.left_oms_flag = 1;
				}
			}
		else
			{
			me.left_oms_flag = 0;
			}

		# right OMS
		if (me.nd_ref_right_oms.getValue() == 1) 
			{
			if (me.right_oms_flag == 0)
				{
				me.set_class2_alarm();
				me.right_oms_flag = 1;
				}
			}
		else
			{
			me.right_oms_flag = 0;
			}

		#  OMS KIT
		if (me.nd_ref_kit_oms.getValue() == 1) 
			{
			if (me.kit_oms_flag == 0)
				{
				me.set_class2_alarm();
				me.kit_oms_flag = 1;
				}
			}
		else
			{
			me.kit_oms_flag = 0;
			}

		# OMS TVC
		if (me.nd_ref_oms_tvc.getValue() == 1) 
			{
			if (me.oms_tvc_flag == 0)
				{
				me.set_class2_alarm();
				me.oms_tvc_flag = 1;
				}
			}
		else
			{
			me.oms_tvc_flag = 0;
			}

		# FWD RCS

		if (me.nd_ref_fwd_rcs.getValue() == 1) 
			{
			if (me.fwd_rcs_flag == 0)
				{
				me.set_class2_alarm();
				me.fwd_rcs_flag = 1;
				}
			}
		else
			{
			me.fwd_rcs_flag = 0;
			}

		# LEFT RCS

		if (me.nd_ref_left_rcs.getValue() == 1) 
			{
			if (me.left_rcs_flag == 0)
				{
				me.set_class2_alarm();
				me.left_rcs_flag = 1;
				}
			}
		else
			{
			me.left_rcs_flag = 0;
			}

		# RIGHT RCS

		if (me.nd_ref_right_rcs.getValue() == 1) 
			{
			if (me.right_rcs_flag == 0)
				{
				me.set_class2_alarm();
				me.right_rcs_flag = 1;
				}
			}
		else
			{
			me.right_rcs_flag = 0;
			}

		# FUEL CELL STACK TEMP

		if (me.nd_ref_fuel_cell_stack_temp.getValue() == 1) 
			{
			if (me.fc_stack_temp_flag == 0)
				{
				me.set_class2_alarm();
				me.fc_stack_temp_flag = 1;
				}
			}
		else
			{
			me.fc_stack_temp_flag = 0;
			}

		# FUEL CELL PUMP

		if (me.nd_ref_fuel_cell_pump.getValue() == 1) 
			{
			if (me.fc_pump_flag == 0)
				{
				me.set_class2_alarm();
				me.fc_pump_flag = 1;
				}
			}
		else
			{
			me.fc_pump_flag = 0;
			}

		# FUEL CELL REACTANT

		if (me.nd_ref_fuel_cell_reac.getValue() == 1) 
			{
			if (me.fc_reac_flag == 0)
				{
				me.set_class2_alarm();
				me.fc_reac_flag = 1;
				}
			}
		else
			{
			me.fc_reac_flag = 0;
			}

		# MAIN BUS UNDERVOLT

		if (me.nd_ref_main_bus_undervolt.getValue() == 1) 
			{
			if (me.main_bus_undervolt_flag == 0)
				{
				me.set_class2_alarm();
				me.main_bus_undervolt_flag = 1;
				}
			}
		else
			{
			me.main_bus_undervolt_flag = 0;
			}

		# AC VOLTAGE

		if (me.nd_ref_ac_voltage.getValue() == 1) 
			{
			if (me.ac_voltage_flag == 0)
				{
				me.set_class2_alarm();
				me.ac_voltage_flag = 1;
				}
			}
		else
			{
			me.ac_voltage_flag = 0;
			}

		# H2O LOOP

		if (me.nd_ref_h2o_loop.getValue() == 1) 
			{
			if (me.h2o_loop_flag == 0)
				{
				me.set_class2_alarm();
				me.h2o_loop_flag = 1;
				}
			}
		else
			{
			me.h2o_loop_flag = 0;
			}

		# FREON LOOP

		if (me.nd_ref_freon_loop.getValue() == 1) 
			{
			if (me.freon_loop_flag == 0)
				{
				me.set_class2_alarm();
				me.freon_loop_flag = 1;
				}
			}
		else
			{
			me.freon_loop_flag = 0;
			}

		# CABIN ATM

		if (me.nd_ref_cabin_atm.getValue() == 1) 
			{
			if (me.cabin_atm_flag == 0)
				{
				me.set_class2_alarm();
				me.cabin_atm_flag = 1;
				}
			}
		else
			{
			me.cabin_atm_flag = 0;
			}

		# AVBAY CABIN AIR

		if (me.nd_ref_avbay_cabin_air.getValue() == 1) 
			{
			if (me.avbay_cabin_air_flag == 0)
				{
				me.set_class2_alarm();
				me.avbay_cabin_air_flag = 1;
				}
			}
		else
			{
			me.avbay_cabin_air_flag = 0;
			}

		# HYD PRESS

		if (me.nd_ref_hyd_press.getValue() == 1) 
			{
			if (me.hyd_press_flag == 0)
				{
				#me.set_class2_alarm();
				me.hyd_press_flag = 1;
				}
			}
		else
			{
			me.hyd_press_flag = 0;
			}

		# APU OVERSPEED

		if (me.nd_ref_apu_overspeed.getValue() == 1) 
			{
			if (me.apu_overspeed_flag == 0)
				{
				me.set_class2_alarm();
				me.apu_overspeed_flag = 1;
				}
			}
		else
			{
			me.apu_overspeed_flag = 0;
			}

		# APU UNDERSPEED

		if (me.nd_ref_apu_underspeed.getValue() == 1) 
			{
			if (me.apu_underspeed_flag == 0)
				{
				me.set_class2_alarm();
				me.apu_underspeed_flag = 1;
				}
			}
		else
			{
			me.apu_underspeed_flag = 0;
			}

		# APU TEMP

		if (me.nd_ref_apu_temp.getValue() == 1) 
			{
			if (me.apu_temp_flag == 0)
				{
				me.set_class2_alarm();
				me.apu_temp_flag = 1;
				}
			}
		else
			{
			me.apu_temp_flag = 0;
			}

		# MPS

		if (me.nd_ref_mps.getValue() == 1) 
			{
			if (me.mps_flag == 0)
				{
				me.set_class2_alarm();
				me.mps_flag = 1;
				}
			}
		else
			{
			me.mps_flag = 0;
			}

		# EMERGENCY DEPRESSURIZATION

		if (me.nd_ref_depressurize.getValue() == 1) 
			{
			if (me.depressurize_flag == 0)
				{
				me.set_class1_alarm();
				me.depressurize_flag = 1;
				}
			}
		else
			{
			me.depressurize_flag = 0;
			}


		# SMOKE DETECTION

		if (SpaceShuttle.fire_sim.smoke_avbay1 > 2.0)
			{	
			if (me.smoke_flag == 0)
				{
				me.set_fire_alarm("avbay1");
				me.smoke_flag = 1;
				}

			}
		else if (SpaceShuttle.fire_sim.smoke_avbay2 > 2.0)
			{	
			if (me.smoke_flag == 0)
				{
				me.set_fire_alarm("avbay2");
				me.smoke_flag = 1;
				}

			}
		if (SpaceShuttle.fire_sim.smoke_avbay3 > 2.0)
			{	
			if (me.smoke_flag == 0)
				{
				me.set_fire_alarm("avbay3");
				me.smoke_flag = 1;
				}

			}







	},


	set_fire_alarm: func (location) {


		var cb_avbay_1A2B = getprop("/fdm/jsbsim/systems/circuit-breakers/smoke-detn-bay-1A2B");
		var cb_avbay_1B3A = getprop("/fdm/jsbsim/systems/circuit-breakers/smoke-detn-bay-1B3A");
		var cb_avbay_2A3B = getprop("/fdm/jsbsim/systems/circuit-breakers/smoke-detn-bay-2A3B");



		if (location == "avbay1")
			{
			if ((cb_avbay_1A2B == 0) and (cb_avbay_1B3A == 0)) {return;}
			}
		else if (location == "avbay2")
			{
			if ((cb_avbay_1A2B == 0) and (cb_avbay_2A3B == 0)) {return;}
			}
		else if (location == "avbay3")
			{
			if ((cb_avbay_1B3A == 0) and (cb_avbay_2A3B == 0)) {return;}
			}


		if (me.mode > -1)
			{setprop("/fdm/jsbsim/systems/cws/master-alarm-cdr-on", 1);}
		setprop("/fdm/jsbsim/systems/cws/master-alarm-plt-on", 1);
		setprop("/fdm/jsbsim/systems/cws/master-alarm-aft-on", 1);

		setprop("/fdm/jsbsim/systems/cws/fire-alarm-sound-on", 1);

		if (location == "avbay1")
			{
			if (cb_avbay_1A2B == 1)
				{
				setprop("/fdm/jsbsim/systems/fire-suppression/sd-avbay1-light-l",1);
				}
			if (cb_avbay_1B3A == 1)
				{
				setprop("/fdm/jsbsim/systems/fire-suppression/sd-avbay1-light-r",1);
				}
			}

		else if (location == "avbay2")
			{
			if (cb_avbay_2A3B == 1)
				{
				setprop("/fdm/jsbsim/systems/fire-suppression/sd-avbay2-light-l",1);	
				}
			if (cb_avbay_1A2B == 1)
				{
				setprop("/fdm/jsbsim/systems/fire-suppression/sd-avbay2-light-r",1);
				}
			}
		else if (location == "avbay3")
			{
			if (cb_avbay_1B3A == 1)
				{
				setprop("/fdm/jsbsim/systems/fire-suppression/sd-avbay3-light-l",1);
				}
			if (cb_avbay_2A3B == 1)
				{
				setprop("/fdm/jsbsim/systems/fire-suppression/sd-avbay3-light-r",1);
				}
			}

	},


	set_class1_alarm: func {


		if (me.mode > -1)
			{setprop("/fdm/jsbsim/systems/cws/master-alarm-cdr-on", 1);}
		setprop("/fdm/jsbsim/systems/cws/master-alarm-plt-on", 1);
		setprop("/fdm/jsbsim/systems/cws/master-alarm-aft-on", 1);

		setprop("/fdm/jsbsim/systems/cws/class-1-sound-on", 1);

	},

	set_class2_alarm: func {

		if (me.mode > -1)
			{setprop("/fdm/jsbsim/systems/cws/master-alarm-cdr-on", 1);}
		setprop("/fdm/jsbsim/systems/cws/master-alarm-plt-on", 1);
		setprop("/fdm/jsbsim/systems/cws/master-alarm-aft-on", 1);

		setprop("/fdm/jsbsim/systems/cws/class-2-sound-on", 1);

	},


	set_mode: func (mode) {

		me.mode = mode;

		if (me.mode == -1)
			{
			setprop("/fdm/jsbsim/systems/cws/master-alarm-cdr-on", 0);
			}

	},

	unset_alarm: func {

		setprop("/fdm/jsbsim/systems/cws/class-1-sound-on", 0);
		setprop("/fdm/jsbsim/systems/cws/class-2-sound-on", 0);
		setprop("/fdm/jsbsim/systems/cws/fire-alarm-sound-on", 0);
		setprop("/fdm/jsbsim/systems/cws/master-alarm-cdr-on", 0);
		setprop("/fdm/jsbsim/systems/cws/master-alarm-plt-on", 0);
		setprop("/fdm/jsbsim/systems/cws/master-alarm-aft-on", 0);

		if (me.left_oms_flag == 1) {me.left_oms_flag = 2;}
		if (me.right_oms_flag == 1) {me.right_oms_flag = 2;}
		if (me.kit_oms_flag == 1) {me.kit_oms_flag = 2;}
		if (me.oms_tvc_flag == 1) {me.oms_tvc_flag = 2;}
		if (me.fwd_rcs_flag == 1) {me.fwd_rcs_flag = 2;}
		if (me.left_rcs_flag == 1) {me.left_rcs_flag = 2;}
		if (me.right_rcs_flag == 1) {me.right_rcs_flag = 2;}
		if (me.fc_stack_temp_flag == 1) {me.fc_stack_temp_flag = 2;}
		if (me.fc_pump_flag == 1) {me.fc_pump_flag = 2;}
		if (me.fc_reac_flag == 1) {me.fc_reac_flag = 2;}
		if (me.main_bus_undervolt_flag == 1) {me.main_bus_undervolt_flag = 2;}
		if (me.ac_voltage_flag == 1) {me.ac_voltage_flag = 2;}
		if (me.h2o_loop_flag == 1) {me.h2o_loop_flag = 2;}
		if (me.freon_loop_flag == 1) {me.freon_loop_flag = 2;}
		if (me.cabin_atm_flag == 1) {me.cabin_atm_flag = 2;}
		if (me.avbay_cabin_air_flag == 1) {me.avbay_cabin_air_flag = 2;}
		if (me.hyd_press_flag == 1) {me.hyd_press_flag = 2;}
		if (me.apu_overspeed_flag == 1) {me.apu_overspeed_flag = 2;}
		if (me.apu_underspeed_flag == 1) {me.apu_underspeed_flag = 2;}
		if (me.apu_temp_flag == 1) {me.apu_temp_flag = 2;}
		if (me.mps_flag == 1) {me.mps_flag = 2;}
		if (me.depressurize_flag == 1) {me.depressurize_flag = 2;}

	},

	unlock_smoke_detection: func {

		print ("Resetting smoke detector");

		me.smoke_flag = 0;
		setprop("/fdm/jsbsim/systems/fire-suppression/sd-avbay1-light-l",0);	
		setprop("/fdm/jsbsim/systems/fire-suppression/sd-avbay1-light-r",0);	

		setprop("/fdm/jsbsim/systems/fire-suppression/sd-avbay2-light-l",0);	
		setprop("/fdm/jsbsim/systems/fire-suppression/sd-avbay2-light-r",0);

		setprop("/fdm/jsbsim/systems/fire-suppression/sd-avbay3-light-l",0);	
		setprop("/fdm/jsbsim/systems/fire-suppression/sd-avbay3-light-r",0);		
	},
	

};

master_alarm_mngr.init();
