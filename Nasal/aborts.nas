
# abort initiation calls for the Space Shuttle
# Thorsten Renk 2016

# available abort modes are

# 1: RTLS
# 2: TAL
# 3: ATO
# 4: AOA

# 5: Contingency BLUE
# 6: Continegncy GREEN

# batch calls for RTLS abort ###############################################

var init_rtls = func {


if (getprop("/fdm/jsbsim/systems/dps/ops") == 1)
	{
	setprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode",3);
	setprop("/fdm/jsbsim/systems/abort/abort-mode", 1);
	setprop("/controls/shuttle/hud-mode",2);
	setprop("/fdm/jsbsim/systems/dps/major-mode", 601);
	setprop("/fdm/jsbsim/systems/dps/ops", 6);
	SpaceShuttle.ops_transition_auto("p_dps_rtls");
	SpaceShuttle.prtls_loop();
	}

}

# batch call for ATO abort ##################################################

var init_ato = func {

if (getprop("/fdm/jsbsim/systems/dps/ops") == 1)
	{

	setprop("/fdm/jsbsim/systems/abort/abort-mode", 3);

	var vcont = getprop("/mission/abort/ato-v-mssn-cntn");
	var vlin = getprop("/mission/abort/ato-v-lin");
	var vzero = getprop("/mission/abort/ato-v-zero");

	var vi = getprop("/fdm/jsbsim/velocities/eci-velocity-mag-fps");

	# check whether we abandon inclination target

	if (vi < vcont)
		{
		var current_inc = getprop("/fdm/jsbsim/systems/orbital/inclination-deg");
		setprop("/fdm/jsbsim/systems/ap/launch/inclination-target", current_inc);
		}
	
	# determine OMS dump fraction

	var oms_dump_fraction = 1;

	if ((vi > vlin) and (vi < vzero))
		{	
		oms_dump_fraction = 1.0 - ((vi-vlin) / (vzero - vlin));
		if (oms_dump_fraction < 0.05) {oms_dump_fraction = 0.05;}
		}
	else if (vi > vzero)
		{
		oms_dump_fraction = 0.0;
		}

	# program dump without interconnect

	setprop("/fdm/jsbsim/systems/oms/oms-dump-qty", int(100 * oms_dump_fraction));
	setprop("/fdm/jsbsim/systems/oms/oms-dump-interconnect-cmd", 0);
	setprop("/fdm/jsbsim/systems/oms/oms-dump-arm-cmd", 1);
	setprop("/fdm/jsbsim/systems/oms/oms-dump-cmd", 0);
	SpaceShuttle.toggle_oms_fuel_dump();

	}


}
