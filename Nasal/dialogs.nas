# Nasal scripts for Space Shuttle dialogs
# Thorsten Renk 2015


var description_string_soft = "Aerodynamical, structural and other limits are called out but not enforced, i.e. violating limits does not cause damage to the orbiter.";

var description_string_hard = "Warnings of the approach to aerodynamical and structural limits are called out, any violation of limits ends the simulation.";

var description_string_realistic = "Warnings as well as violations of aerodynamical and structural limits are called out, any violation may cause damage to orbiter systems. The damage is determined probabilistically and not necessarily reported. ";

var scenario_string_none = " ";

var scenario_string_single_engine_failure = "During ascent, a single main engine will fail. Dependent on payload, launch inclination and when the failure occurs, the Shuttle may no longer be able to reach orbit, requiring to follow an abort procedure.";

var scenario_string_single_engine_lockup = "During ascent, a condition occurs which makes one engine lock up, i.e. the engine can no longer be throttled. Anticipate to shut down the affected engine manually prior to MECO using the cutoff switches.";

var scenario_string_stuck_speedbrake = "During the final aerodynamical glide phase, the speedbrake gets stuck. Dependent on when and in what position this happens, TAEM needs to be modified and the aim point for the final approach changed. Deploy gear early to make use of its high drag.";

var scenario_string_hydraulic_failure = "Two of the three hydraulics systems are damaged and priority rate limiting is used to best allocate the remaining hydraulic force to the airfoils. Expect the orbiter to react more sluggish in agressive maneuvers.";

var scenario_string_tire_failure = "The right gear tire is damaged. Anticipate to use rudder upon touchdown to correct and use elevons to reduce load on the damaged gear during coast.";

var propellant_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/propellant/dialog","Aircraft/SpaceShuttle/Dialogs/propellant.xml");

var entry_guidance_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/entry_guidance/dialog","Aircraft/SpaceShuttle/Dialogs/entry_guidance.xml");

var limits_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/limits/dialog","Aircraft/SpaceShuttle/Dialogs/limits.xml");

var apu_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/apu/dialog","Aircraft/SpaceShuttle/Dialogs/apu.xml");

var atcs_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/atcs/dialog","Aircraft/SpaceShuttle/Dialogs/atcs.xml");

var rcs_oms_thermal_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/rcs_oms_thermal/dialog","Aircraft/SpaceShuttle/Dialogs/rcs_oms_thermal.xml");

var electrical_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/electrical/dialog","Aircraft/SpaceShuttle/Dialogs/electrical.xml");

var mechanical_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/mechanicall/dialog","Aircraft/SpaceShuttle/Dialogs/mechanical.xml");

var mps_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/mps/dialog","Aircraft/SpaceShuttle/Dialogs/mps.xml");

var options_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/options/dialog","Aircraft/SpaceShuttle/Dialogs/options.xml");

var rcs_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/rcs/dialog","Aircraft/SpaceShuttle/Dialogs/rcs.xml");

var temperature_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/temperature/dialog","Aircraft/SpaceShuttle/Dialogs/thermal_distribution.xml");

var propellant_fd_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/propellant_fd/dialog","Aircraft/SpaceShuttle/Dialogs/propellant_fill_drain.xml");

var earthview_flag = getprop("/sim/config/shuttle/rendering/use-earthview");
var earthview_transition_alt = getprop("/sim/config/shuttle/rendering/earthview-transition-alt-ft");

setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site", "Vandenberg Air Force Base");
setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-lat",34.722);
setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-lon",-120.567);
setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-string", "inactive");

setprop("/sim/gui/dialogs/SpaceShuttle/limits/limit-mode", "realistic");
setprop("/sim/gui/dialogs/SpaceShuttle/limits/limit-mode-description", description_string_realistic);

setprop("/sim/gui/dialogs/SpaceShuttle/limits/failure-scenario", "none");
setprop("/sim/gui/dialogs/SpaceShuttle/limits/failure-scenario-description", " ");
setprop("/fdm/jsbsim/systems/failures/failure-scenario-ID", 0);

gui.menuBind("fuel-and-payload", "SpaceShuttle.propellant_dlg.open()");
gui.menuEnable("fuel-and-payload", 1);



var update_description = func {

var mode_string = getprop("/sim/gui/dialogs/SpaceShuttle/limits/limit-mode");

if (mode_string == "soft")
	{
	setprop("/sim/gui/dialogs/SpaceShuttle/limits/limit-mode-description", description_string_soft);
	setprop("/fdm/jsbsim/systems/failures/limit-simulation-mode", 0);
	}
else if (mode_string == "realistic")
	{
	setprop("/sim/gui/dialogs/SpaceShuttle/limits/limit-mode-description", description_string_realistic);
	setprop("/fdm/jsbsim/systems/failures/limit-simulation-mode", 1);
	}
if (mode_string == "hard")
	{
	setprop("/sim/gui/dialogs/SpaceShuttle/limits/limit-mode-description", description_string_hard);
	setprop("/fdm/jsbsim/systems/failures/limit-simulation-mode", 2);
	}

}


var update_scenario = func {

var scenario_string = getprop("/sim/gui/dialogs/SpaceShuttle/limits/failure-scenario");

if (scenario_string == "none")
	{
	setprop("/sim/gui/dialogs/SpaceShuttle/limits/failure-scenario-description", scenario_string_none);
	setprop("/fdm/jsbsim/systems/failures/failure-scenario-ID", 0);
	}
else if (scenario_string == "ascent single engine failure")
	{
	setprop("/sim/gui/dialogs/SpaceShuttle/limits/failure-scenario-description", scenario_string_single_engine_failure);
	setprop("/fdm/jsbsim/systems/failures/failure-scenario-ID", 1);
	}
else if (scenario_string == "ascent single engine lockup")
	{
	setprop("/sim/gui/dialogs/SpaceShuttle/limits/failure-scenario-description", scenario_string_single_engine_lockup);
	setprop("/fdm/jsbsim/systems/failures/failure-scenario-ID", 2);
	}
else if (scenario_string == "stuck speedbrake")
	{
	setprop("/sim/gui/dialogs/SpaceShuttle/limits/failure-scenario-description", scenario_string_stuck_speedbrake);
	setprop("/fdm/jsbsim/systems/failures/failure-scenario-ID", 31);
	}
else if (scenario_string == "burst tire")
	{
	setprop("/sim/gui/dialogs/SpaceShuttle/limits/failure-scenario-description", scenario_string_tire_failure);
	setprop("/fdm/jsbsim/systems/failures/failure-scenario-ID", 32);
	}
else if (scenario_string == "hydraulic failure")
	{
	setprop("/sim/gui/dialogs/SpaceShuttle/limits/failure-scenario-description", scenario_string_hydraulic_failure);
	setprop("/fdm/jsbsim/systems/failures/failure-scenario-ID", 33);
	}

}

var update_site = func {

#print("Hello!");

var site_string = getprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site");

var lat = 0.0;
var lon = 0.0;

setprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode",0);
setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-string", "inactive");

if (site_string == "Kennedy Space Center")
	{
	lat = 28.615;
	lon = -80.695;
	}
else if (site_string == "Vandenberg Air Force Base")
	{
	lat = 34.722;
	lon = -120.567;
	}
else if (site_string == "Edwards Air Force Base")
	{
	lat = 34.096;
	lon = -117.884;
	}
else if (site_string == "White Sands Space Harbor")
	{
	lat = 32.943;
	lon = -106.420;
	}
else if (site_string == "Zaragoza Airport")
	{
	lat = 41.666;
	lon = -1.042;
	}
else if (site_string == "RAF Fairford")
	{
	lat = 51.682;
	lon = -1.79;
	}
else if (site_string == "Banjul International Airport")
	{
	lat = 13.337;
	lon = -16.652;
	}


setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-lat", lat);
setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-lon", lon);
SpaceShuttle.landing_site.set_latlon(lat,lon);

}

var update_ET_config = func{

var ET_string = getprop("/sim/config/shuttle/ET-config");

# do nothing if we don't have an ET connected, otherwise we'll add weight

var tank_status = getprop("/controls/shuttle/ET-static-model");

if (tank_status == 0) {return;}

if (ET_string == "super lightweight")
	{
	setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[1]", 29250.0);
	setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[2]", 29250.0);
	}

else if (ET_string == "lightweight")
	{
	setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[1]", 33000.0);
	setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[2]", 33000.0);
	}
else if (ET_string == "standard weight")
	{
	setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[1]", 38500.0);
	setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[2]", 38500.0);
	}

}

var update_TC_config = func {

var TC_string = getprop("/sim/config/shuttle/TC-config");


var flag = 1;

if (getprop("/controls/shuttle/ET-static-model") == 1)
	{flag = 0;}

if (getprop("/position/altitude-ft") > 40000.0)
	{flag = 0;}

if (flag == 0)
	{return;}

if (TC_string == "none")
	{
	setprop("/sim/config/shuttle/approach-and-landing-test-config", 0);
	}
else if (TC_string == "use tailcone")
	{
	setprop("/sim/config/shuttle/approach-and-landing-test-config", 1);
	}



}


var pb_door_manager = func {

var cmd = getprop("/fdm/jsbsim/systems/mechanical/pb-door-auto-switch");

if (cmd == -1)
	{
	SpaceShuttle.payload_bay_door_close_auto(0);
	}
else if (cmd == 1)
	{
	SpaceShuttle.payload_bay_door_open_auto(0);
	}

}


var thermal_speed_manager = func {

var cmd = getprop("/sim/config/shuttle/thermal-system-computation-speed");

if (cmd == 0)
	{
	setprop("/fdm/jsbsim/systems/thermal-distribution/computation-timestep-s", 10.0);
	}
else if (cmd == 1)
	{
	setprop("/fdm/jsbsim/systems/thermal-distribution/computation-timestep-s", 1.0);
	}
else if (cmd == 2)
	{
	setprop("/fdm/jsbsim/systems/thermal-distribution/computation-timestep-s", 0.1);
	}

}

var update_earthview_manager = func {

earthview_flag = getprop("/sim/config/shuttle/rendering/use-earthview");
earthview_transition_alt = getprop("/sim/config/shuttle/rendering/earthview-transition-alt-ft");

}

setlistener("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site", update_site);
setlistener("/sim/config/shuttle/ET-config", update_ET_config);
setlistener("/sim/config/shuttle/TC-config", update_TC_config);
setlistener("/sim/gui/dialogs/SpaceShuttle/limits/limit-mode", update_description);
setlistener("/sim/gui/dialogs/SpaceShuttle/limits/failure-scenario", update_scenario);
setlistener("/fdm/jsbsim/systems/mechanical/pb-door-auto-switch", pb_door_manager,0,0);
setlistener("/sim/config/shuttle/thermal-system-computation-speed", thermal_speed_manager,0,0);
setlistener("/sim/config/shuttle/rendering/use-earthview", update_earthview_manager,0,0);
setlistener("/sim/config/shuttle/rendering/earthview-transition-alt-ft", update_earthview_manager,0,0);
