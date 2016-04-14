# support for i-loaded mission parameters for the Space Shuttle
# Thorsten Renk 2016


var mission_init = func {

# launch targets


if (getprop("/mission/launch/section-defined"))
	{
	var tgt_inclination = getprop("/mission/launch/target-inclination");
	var tgt_apoapsis = getprop("/mission/launch/target-apoapsis-miles");
	var lat = getprop("/position/latitude-deg");

	# set the menu items - the listener calls the computation of launch azimuth

	if (getprop("/mission/launch/select-north"))
		{
		setprop("/sim/gui/dialogs/SpaceShuttle/auto_launch/select-north", 1);
		setprop("/sim/gui/dialogs/SpaceShuttle/auto_launch/select-south", 0);
		}
	else
		{
		setprop("/sim/gui/dialogs/SpaceShuttle/auto_launch/select-north", 0);
		setprop("/sim/gui/dialogs/SpaceShuttle/auto_launch/select-south", 1);
		}

	var raw = (tgt_inclination - lat)/(90.0 - lat);

	setprop("/sim/gui/dialogs/SpaceShuttle/auto_launch/inclination", raw);
	setprop("/sim/gui/dialogs/SpaceShuttle/auto_launch/apoapsis-target-miles", tgt_apoapsis);

	# auto-launch guidance and autopilot on

	setprop("/fdm/jsbsim/systems/ap/launch/autolaunch-master", 1);

	setprop("/fdm/jsbsim/systems/ap/css-pitch-control", 0);
	setprop("/fdm/jsbsim/systems/ap/automatic-pitch-control", 1);

	setprop("/fdm/jsbsim/systems/ap/css-roll-control", 0);
	setprop("/fdm/jsbsim/systems/ap/automatic-roll-control", 1);

	# i-load TAL site

	var tal_site_index = getprop("/mission/launch/tal-site-index");
	setprop("/fdm/jsbsim/systems/entry_guidance/tal-site-iloaded", tal_site_index);

	}

# configuration

if (getprop("/mission/configuration/section-defined"))
	{
	var et_config = getprop("/mission/configuration/external-tank");
	setprop("/sim/config/shuttle/ET-config", et_config);

	if (getprop("/mission/configuration/payload-explicit"))
		{
		var payload = getprop("/mission/configuration/payload");
		setprop("/sim/config/shuttle/PL-selection", payload);
		SpaceShuttle.update_payload_selection();
		}
	else
		{
		var payload_weight = getprop("/mission/configuration/payload-weight-lbs");
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[5]", payload_weight);
		}

	}
}


setlistener("/sim/signals/fdm-initialized", func { mission_init(); },0,0);
