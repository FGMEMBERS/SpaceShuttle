
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
	else if ((abort_region == "GREEN") and (hdot > - 300.0))
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

	}
}
