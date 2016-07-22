
# contingency-abort relevant high level routines for the Space Shuttle
# Thorsten Renk 2016

var contingency_abort_region_2eo = func {


var abort_mode = getprop("/fdm/jsbsim/systems/abort/abort-mode");
var contingency_arm = getprop("/fdm/jsbsim/systems/abort/arm-contingency");

if ((abort_mode > 4) or (contingency_arm == 1))# we are on a contingency abort, don't update
	{
	return;
	}

var SRB_status = getprop("/controls/shuttle/SRB-static-model");
var hdot = getprop("/fdm/jsbsim/velocities/v-down-fps");
var abort_region = getprop("/fdm/jsbsim/systems/abort/contingency-abort-region");
var guidance_mode = getprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode");
var hdot_limit = getprop("/fdm/jsbsim/systems/abort/contingency-hdot-fps");

if (guidance_mode == 3) # we're on RTLS
	{
	var site_rel_velocity = getprop("/fdm/jsbsim/systems/entry_guidance/site-relative-velocity-fps");
	var eas = getprop("/velocities/equivalent-kt");


	if ((abort_region == "BLUE") and (hdot > -1450) and (SRB_status == 0))
		{setprop("/fdm/jsbsim/systems/abort/contingency-abort-region", "YELLOW");}
	else if ((abort_region == "YELLOW") and (site_rel_velocity < 300))
		{setprop("/fdm/jsbsim/systems/abort/contingency-abort-region", "ORANGE");}
	else if ((abort_region == "ORANGE") and (eas > 20))
		{setprop("/fdm/jsbsim/systems/abort/contingency-abort-region", "GREEN");}
	else if ((abort_region == "GREEN") and (hdot < -100.0))
		{setprop("/fdm/jsbsim/systems/abort/contingency-abort-region", "RED");}

	}
else # we're on TAL or nominal uphill
	{
	if ((abort_region == "BLUE") and (hdot > -hdot_limit) and (SRB_status == 0))
		{setprop("/fdm/jsbsim/systems/abort/contingency-abort-region", "GREEN");}
	else if ((abort_region == "GREEN") and (hdot > 0.0))
		{setprop("/fdm/jsbsim/systems/abort/contingency-abort-region", "");}
	}


}

var contingency_abort_init = func {

var abort_region = getprop("/fdm/jsbsim/systems/abort/contingency-abort-region");
var num_engines = getprop("/fdm/jsbsim/systems/mps/number-engines-operational");
var arm = getprop("/fdm/jsbsim/systems/abort/arm-contingency");

num_engines = 1;

if ((num_engines > 1) or (abort_region == "") or (arm == 0))
	{
	print ("No contingency abort situation!");
	return;
	}

if (abort_region == "BLUE") 
	{
	setprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode",3);
	setprop("/fdm/jsbsim/systems/abort/abort-mode", 5);
	setprop("/controls/shuttle/hud-mode",2);
	setprop("/fdm/jsbsim/systems/dps/major-mode", 601);
	setprop("/fdm/jsbsim/systems/dps/ops", 6);
	SpaceShuttle.ops_transition_auto("p_dps_rtls");

	# initialize OMS/RCS interconnected dump

	setprop("/fdm/jsbsim/systems/oms/oms-dump-interconnect-cmd",1);
	setprop("/fdm/jsbsim/systems/oms/oms-dump-arm-cmd",1);
	setprop("/fdm/jsbsim/systems/oms/oms-dump-cmd", 0);
	SpaceShuttle.toggle_oms_fuel_dump();

	contingency_blue_loop();
	}
else if (abort_region == "GREEN")
	{
	setprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode",3);
	setprop("/fdm/jsbsim/systems/abort/abort-mode", 6);
	setprop("/controls/shuttle/hud-mode",2);
	setprop("/fdm/jsbsim/systems/dps/major-mode", 601);
	setprop("/fdm/jsbsim/systems/dps/ops", 6);
	SpaceShuttle.ops_transition_auto("p_dps_rtls");

	# initialize OMS/RCS interconnected dump

	setprop("/fdm/jsbsim/systems/oms/oms-dump-interconnect-cmd",1);
	setprop("/fdm/jsbsim/systems/oms/oms-dump-arm-cmd",1);
	setprop("/fdm/jsbsim/systems/oms/oms-dump-cmd", 0);
	SpaceShuttle.toggle_oms_fuel_dump();

	contingency_green_loop();
	}
}

# contingency BLUE ###################

var contingency_blue_loop = func {

var vspeed = getprop("/fdm/jsbsim/velocities/v-down-fps");

if (vspeed > 0.0)
	{
	setprop("/fdm/jsbsim/systems/ap/contingency/init-etsep-active", 1);
	setprop("/fdm/jsbsim/systems/ap/contingency/etsep-mode", 4);
	}

var alpha_error = math.abs(getprop("/fdm/jsbsim/aero/alpha-deg")+ 3.0);

if ((vspeed > 0.0) and (alpha_error < 2.0))
	{
	cblue_init_meco();
	return;
	}


settimer (contingency_blue_loop, 0.2);
}



var cblue_init_meco = func {

setprop("/controls/engines/engine[0]/throttle", 0.0);
setprop("/controls/engines/engine[1]/throttle", 0.0);
setprop("/controls/engines/engine[2]/throttle", 0.0);

setprop("/fdm/jsbsim/systems/fcs/control-mode",20);

settimer( force_external_tank_separate, 1.0);

settimer( SpaceShuttle.rtls_transit_glide, 8.0);
}

# contingency GREEN ###################

var contingency_green_loop = func {

# monitor KEAS for MECO preparation

var keas = getprop("/velocities/equivalent-kt");

if (keas > 3.0) # end yaw steering
	{
	setprop("/fdm/jsbsim/systems/abort/yaw-steer-target", 0.0);
	}

var meco_flag = 0;

if (keas > 10.0) # command pitch down 
	{
	setprop("/fdm/jsbsim/systems/ap/contingency/init-etsep-active", 1);
	setprop("/fdm/jsbsim/systems/ap/contingency/etsep-mode", 3);
	meco_flag = 1;
	}

# command MECO when rate target is met


if (meco_flag == 1)
	{
	var pitch_rate = getprop("/fdm/jsbsim/velocities/q-rad_sec") * 57.2957;

	if (math.abs(pitch_rate + 3.0) < 1.0)
		{
		cgreen_init_meco();
		return;
		}

	}


settimer (contingency_green_loop, 0.2);
}

var cgreen_init_meco = func {

setprop("/controls/engines/engine[0]/throttle", 0.0);
setprop("/controls/engines/engine[1]/throttle", 0.0);
setprop("/controls/engines/engine[2]/throttle", 0.0);

setprop("/fdm/jsbsim/systems/fcs/control-mode",20);

settimer( force_external_tank_separate, 1.0);

settimer( SpaceShuttle.rtls_transit_glide, 8.0);
}
