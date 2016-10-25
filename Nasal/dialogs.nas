# Nasal scripts for Space Shuttle dialogs
# Thorsten Renk 2015 - 2016


var description_string_soft = "Aerodynamical, structural and other limits are called out but not enforced, i.e. violating limits does not cause damage to the orbiter.";

var description_string_hard = "Warnings of the approach to aerodynamical and structural limits are called out, any violation of limits ends the simulation.";

var description_string_realistic = "Warnings as well as violations of aerodynamical and structural limits are called out, any violation may cause damage to orbiter systems. The damage is determined probabilistically and not necessarily reported. ";

var scenario_string_none = " ";

var scenario_string_single_engine_failure = "During ascent, a single main engine will fail. Dependent on payload, launch inclination and when the failure occurs, the Shuttle may no longer be able to reach orbit, requiring to follow an abort procedure.";

var scenario_string_single_engine_lockup = "During ascent, a condition occurs which makes one engine lock up, i.e. the engine can no longer be throttled. Anticipate to shut down the affected engine manually prior to MECO using the cutoff switches.";

var scenario_string_attitude = "The Shuttle GNC function has drifted off attitude to a degree that the star trackers no longer function - pitch, yaw and roll will all be off. Use a COAS procedure to fix inertial attitude and re-activate the star tracker.";

var scenario_string_rcs = "A thruster of the RCS system has failed. Use the RCS jet table management function to diagnose the fault and deselect the failed thruster and its counterpart to restore proper RCS functionality.";

var scenario_string_stuck_speedbrake = "During the final aerodynamical glide phase, the speedbrake gets stuck. Dependent on when and in what position this happens, TAEM needs to be modified and the aim point for the final approach changed. Deploy gear early to make use of its high drag.";

var scenario_string_hydraulic_failure = "Two of the three hydraulics systems are damaged and priority rate limiting is used to best allocate the remaining hydraulic force to the airfoils. Expect the orbiter to react more sluggish in agressive maneuvers.";

var scenario_string_tire_failure = "The right gear tire is damaged. Anticipate to use rudder upon touchdown to correct and use elevons to reduce load on the damaged gear during coast.";

var propellant_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/propellant/dialog","Aircraft/SpaceShuttle/Dialogs/propellant.xml");

var entry_guidance_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/entry_guidance/dialog","Aircraft/SpaceShuttle/Dialogs/entry_guidance.xml");

var autolaunch_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/autolaunch/dialog","Aircraft/SpaceShuttle/Dialogs/auto_launch.xml");


var limits_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/limits/dialog","Aircraft/SpaceShuttle/Dialogs/limits.xml");

var apu_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/apu/dialog","Aircraft/SpaceShuttle/Dialogs/apu.xml");

var atcs_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/atcs/dialog","Aircraft/SpaceShuttle/Dialogs/atcs.xml");

var rcs_oms_thermal_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/rcs_oms_thermal/dialog","Aircraft/SpaceShuttle/Dialogs/rcs_oms_thermal.xml");

var electrical_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/electrical/dialog","Aircraft/SpaceShuttle/Dialogs/electrical.xml");

var ku_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/ku/dialog","Aircraft/SpaceShuttle/Dialogs/ku_antenna.xml");

var mechanical_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/mechanical/dialog","Aircraft/SpaceShuttle/Dialogs/mechanical.xml");

var mps_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/mps/dialog","Aircraft/SpaceShuttle/Dialogs/mps.xml");

var options_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/options/dialog","Aircraft/SpaceShuttle/Dialogs/options.xml");

var rcs_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/rcs/dialog","Aircraft/SpaceShuttle/Dialogs/rcs.xml");

var rms_deploy_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/rms-deploy/dialog","Aircraft/SpaceShuttle/Dialogs/rms_deploy.xml");

var rms_pyro_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/rms-pyro/dialog","Aircraft/SpaceShuttle/Dialogs/rms_pyro.xml");

var pb_floodlight_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/pb-floodlight/dialog","Aircraft/SpaceShuttle/Dialogs/pb_floodlight.xml");

var rms_operation_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/rms-operation/dialog","Aircraft/SpaceShuttle/Dialogs/rms_operation.xml");

var pl_retention_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/payload-retention/dialog","Aircraft/SpaceShuttle/Dialogs/payload_retention.xml");

var flight_controls_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/flight_controls/dialog","Aircraft/SpaceShuttle/Dialogs/flight_controls.xml");

var dps_keyboard_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/dps_keyboard/dialog","Aircraft/SpaceShuttle/Dialogs/dps_keyboard.xml");

var idp_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/idp/dialog","Aircraft/SpaceShuttle/Dialogs/idp_settings.xml");


var temperature_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/temperature/dialog","Aircraft/SpaceShuttle/Dialogs/thermal_distribution.xml");

var propellant_fd_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/propellant_fd/dialog","Aircraft/SpaceShuttle/Dialogs/propellant_fill_drain.xml");

var cabin_lighting_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/cabin-lighting/dialog","Aircraft/SpaceShuttle/Dialogs/cabin_lighting.xml");

var earthview_flag = getprop("/sim/config/shuttle/rendering/use-earthview");
var earthview_transition_alt = getprop("/sim/config/shuttle/rendering/earthview-transition-alt-ft");

setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site", "Vandenberg Air Force Base");
setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "12");
setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value", "12");
setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value[1]", "30");
setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/entry-mode", "normal");
setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-lat",34.722);
setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-lon",-120.567);
setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-string", "inactive");
setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/EI-radius", 4100.0);

setprop("/sim/gui/dialogs/SpaceShuttle/limits/limit-mode", "realistic");
setprop("/sim/gui/dialogs/SpaceShuttle/limits/limit-mode-description", description_string_realistic);

setprop("/sim/gui/dialogs/SpaceShuttle/limits/failure-scenario", "none");
setprop("/sim/gui/dialogs/SpaceShuttle/limits/failure-scenario-description", " ");
setprop("/fdm/jsbsim/systems/failures/failure-scenario-ID", 0);

setprop("/sim/gui/dialogs/SpaceShuttle/ku-antenna/function", "COMM");
setprop("/sim/gui/dialogs/SpaceShuttle/ku-antenna/control", "GPC");

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
else if (scenario_string == "off attitude")
	{
	setprop("/sim/gui/dialogs/SpaceShuttle/limits/failure-scenario-description", scenario_string_attitude);
	setprop("/fdm/jsbsim/systems/failures/failure-scenario-ID", 20);
	}
else if (scenario_string = "RCS failure")
	{
	setprop("/sim/gui/dialogs/SpaceShuttle/limits/failure-scenario-description", scenario_string_rcs);
	setprop("/fdm/jsbsim/systems/failures/failure-scenario-ID", 21);
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


var update_runway_by_flag = func (flag) {

var site_string = getprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site");

if (site_string == "Kennedy Space Center")
	{
	if (flag == 0) {setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "15");}
	else {setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "33");}
	}
else if (site_string == "Vandenberg Air Force Base")
	{
	if (flag == 0) {setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "12");}
	else {setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "30");}
	}
else if (site_string == "Edwards Air Force Base")
	{
	if (flag == 0) {setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "06");}
	else {setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "24");}
	}
else if (site_string == "White Sands Space Harbor")
	{
	if (flag == 0) {setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "14");}
	else {setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "32");}
	}
else if (site_string == "Zaragoza Airport")
	{
	if (flag == 0) {setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "12");}
	else {setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "30");}
	}
else if (site_string == "RAF Fairford")
	{
	if (flag == 0) {setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "09");}
	else {setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "27");}
	}
else if (site_string == "Banjul International Airport")
	{
	if (flag == 0) {setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "14");}
	else {setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "32");}
	}
else if (site_string == "Moron Air Base")
	{
	if (flag == 0) {setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "02");}
	else {setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "20");}
	}
else if (site_string == "Le Tube")
	{
	if (flag == 0) {setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "15");}
	else {setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "33");}
	}
else if (site_string == "Bermuda")
	{
	if (flag == 0) {setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "12");}
	else {setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "30");}
	}
else if (site_string == "Easter Island")
	{
	if (flag == 0) {setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "10");}
	else {setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "28");}
	}
}

var update_runway = func {

#print("Hello!");

var site_string = getprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site");
var runway_string = getprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway");

if (site_string == "Kennedy Space Center")
	{
	if (runway_string == "15"){SpaceShuttle.landing_site.rwy_sel = 0;}
	else {SpaceShuttle.landing_site.rwy_sel = 1;}
	}
else if (site_string == "Vandenberg Air Force Base")
	{
	if (runway_string == "12"){SpaceShuttle.landing_site.rwy_sel = 0;}
	else {SpaceShuttle.landing_site.rwy_sel = 1;}
	}
else if (site_string == "Edwards Air Force Base")
	{
	if (runway_string == "06"){SpaceShuttle.landing_site.rwy_sel = 0;}
	else {SpaceShuttle.landing_site.rwy_sel = 1;}
	}
else if (site_string == "White Sands Space Harbor")
	{
	if (runway_string == "14"){SpaceShuttle.landing_site.rwy_sel = 0;}
	else {SpaceShuttle.landing_site.rwy_sel = 1;}
	}
else if (site_string == "Banjul International Airport")
	{
	if (runway_string == "14"){SpaceShuttle.landing_site.rwy_sel = 0;}
	else {SpaceShuttle.landing_site.rwy_sel = 1;}
	}
else if (site_string == "Moron Air Base")
	{
	if (runway_string == "02"){SpaceShuttle.landing_site.rwy_sel = 0;}
	else {SpaceShuttle.landing_site.rwy_sel = 1;}
	}
else if (site_string == "Le Tube")
	{
	if (runway_string == "15"){SpaceShuttle.landing_site.rwy_sel = 0;}
	else {SpaceShuttle.landing_site.rwy_sel = 1;}
	}
else if (site_string == "Zaragoza Airport")
	{
	if (runway_string == "12"){SpaceShuttle.landing_site.rwy_sel = 0;}
	else {SpaceShuttle.landing_site.rwy_sel = 1;}
	}
else if (site_string == "RAF Fairford")
	{
	if (runway_string == "09"){SpaceShuttle.landing_site.rwy_sel = 0;}
	else {SpaceShuttle.landing_site.rwy_sel = 1;}
	}
else if (site_string == "Bermuda")
	{
	if (runway_string == "12"){SpaceShuttle.landing_site.rwy_sel = 0;}
	else {SpaceShuttle.landing_site.rwy_sel = 1;}
	}
else if (site_string == "Easter Island")
	{
	if (runway_string == "10"){SpaceShuttle.landing_site.rwy_sel = 0;}
	else {SpaceShuttle.landing_site.rwy_sel = 1;}
	}
}


var update_site_by_index = func (index) {

if (index == 1)
	{
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site", "Kennedy Space Center");
	}
else if (index == 2)
	{
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site", "Vandenberg Air Force Base");
	}
else if (index == 3)
	{
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site", "Edwards Air Force Base");
	}
else if (index == 4)
	{
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site", "White Sands Space Harbor");
	}
else if (index == 5)
	{
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site", "Zaragoza Airport");
	}
else if (index == 6)
	{
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site", "RAF Fairford");
	}
else if (index == 7)
	{
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site", "Banjul International Airport");
	}
else if (index == 8)
	{
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site", "Moron Air Base");
	}
else if (index == 9)
	{
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site", "Le Tube");
	}
else if (index == 11)
	{
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site", "Bermuda");
	}
else if (index == 30)
	{
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site", "Easter Island");
	}

update_site();
}

var update_site = func {

#print("Hello!");

var site_string = getprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site");

var lat = 0.0;
var lon = 0.0;
var index = 0;
var rwy_pri = "";
var rwy_sec = "";
var tacan = "";

#setprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode",0);
#setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-string", "inactive");

if (site_string == "Kennedy Space Center")
	{
	lat = 28.615;
	lon = -80.695;
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "15");
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value", "15");
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value[1]", "33");
	index = 1;
	rwy_pri = "KSC15";
	rwy_sec = "KSC33";
	tacan = "059";
        gui.dialog_update("entry_guidance", "runway-selection");
	}
else if (site_string == "Vandenberg Air Force Base")
	{
	lat = 34.722;
	lon = -120.567;
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "12");
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value", "12");
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value[1]", "30");
	index = 2;
	rwy_pri = "VBG12";
	rwy_sec = "VBG30";
	tacan = "059";
        gui.dialog_update("entry_guidance", "runway-selection");
	}
else if (site_string == "Edwards Air Force Base")
	{
	lat = 34.096;
	lon = -117.884;
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "06");
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value", "06");
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value[1]", "24");
	index = 3;
	rwy_pri = "EDW06";
	rwy_sec = "EDW24";
	tacan = "111";
        gui.dialog_update("entry_guidance", "runway-selection");
	}
else if (site_string == "White Sands Space Harbor")
	{
	lat = 32.943;
	lon = -106.420;
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "14");
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value", "14");
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value[1]", "32");
	rwy_pri = "NOR14";
	rwy_sec = "NOR32";
        gui.dialog_update("entry_guidance", "runway-selection");
	index = 4;
	}
else if (site_string == "Zaragoza Airport")
	{
	lat = 41.666;
	lon = -1.042;
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "12");
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value", "12");
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value[1]", "30");
	rwy_pri = "ZZA12";
	rwy_sec = "ZZA30";
        gui.dialog_update("entry_guidance", "runway-selection");
	index = 5;
	}
else if (site_string == "RAF Fairford")
	{
	lat = 51.682;
	lon = -1.79;
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "09");
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value", "09");
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value[1]", "27");
	rwy_pri = "FFD09";
	rwy_sec = "FFD27";
	tacan = "081";
        gui.dialog_update("entry_guidance", "runway-selection");
	index = 6;
	}
else if (site_string == "Banjul International Airport")
	{
	lat = 13.337;
	lon = -16.652;
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "14");
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value", "14");
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value[1]", "32");
	rwy_pri = "BYD14";
	rwy_sec = "BYD32";
	tacan = "076";
        gui.dialog_update("entry_guidance", "runway-selection");
	index = 7;
	}
else if (site_string == "Moron Air Base")
	{
	lat = 37.178;
	lon = -5.614;
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "02");
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value", "02");
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value[1]", "20");
	rwy_pri = "MRN02";
	rwy_sec = "MRN20";
	tacan = "100";
        gui.dialog_update("entry_guidance", "runway-selection");
	index = 8;
	}
else if (site_string == "Le Tube")
	{
	lat = 43.52;
	lon = 4.92;
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "15");
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value", "15");
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value[1]", "33");
	rwy_pri = "FMI15";
	rwy_sec = "FMI33";
	tacan = "104";
        gui.dialog_update("entry_guidance", "runway-selection");
	index = 9;
	}
else if (site_string == "Bermuda")
	{
	lat = 32.363;
	lon = -64.67;
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "12");
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value", "12");
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value[1]", "30");
	rwy_pri = "BER12";
	rwy_sec = "BER30";
	tacan = "086";
        gui.dialog_update("entry_guidance", "runway-selection");
	index = 11;
	}
else if (site_string == "Easter Island")
	{
	lat = -27.165;
	lon = -109.415;
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", "10");
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value", "10");
	setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/available-runways/value[1]", "28");
	rwy_pri = "IPC10";
	rwy_sec = "IPC28";
        gui.dialog_update("entry_guidance", "runway-selection");
	index = 30;
	}

setprop("/fdm/jsbsim/systems/taem-guidance/approach-mode-string", "OVHD");

setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-lat", lat);
setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-lon", lon);
SpaceShuttle.landing_site.set_latlon(lat,lon);
SpaceShuttle.landing_site.index = index;
SpaceShuttle.landing_site.rwy_pri = rwy_pri;
SpaceShuttle.landing_site.rwy_sec = rwy_sec;
SpaceShuttle.landing_site.tacan = tacan;

}


var update_entry_mode = func {


var mode_string = getprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/entry-mode");

if (getprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode") == 0)
	{
	return;
	}

if (mode_string == "normal")
	{
	setprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode", 1);
	}
else if (mode_string == "TAL")
	{
	setprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode", 2);
	}
else if (mode_string == "RTLS")
	{
	#setprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode", 3);
	#setprop("/controls/shuttle/hud-mode",2);
	#setprop("/fdm/jsbsim/systems/dps/major-mode", 601);
	#setprop("/fdm/jsbsim/systems/dps/ops", 6);
	#SpaceShuttle.ops_transition_auto("p_dps_rtls");
	#SpaceShuttle.prtls_loop();
	SpaceShuttle.init_rtls();
	}

}

var update_MDU_speed = func {


var setting = getprop("/sim/config/shuttle/mdu-update-speed");

if (setting == 0)
	{SpaceShuttle.MDU_update_time = 0.2; SpaceShuttle.MDU_update_number = 1;}
else if (setting == 1)
	{SpaceShuttle.MDU_update_time = 0.1; SpaceShuttle.MDU_update_number = 1;}
else if (setting == 2)
	{SpaceShuttle.MDU_update_time = 0.05; SpaceShuttle.MDU_update_number = 1;}
else
	{SpaceShuttle.MDU_update_time = 0.0; SpaceShuttle.MDU_update_number = 2;}

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

var mode = getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto");

if (mode == 0) {return;}

var switch_condition = getprop("/fdm/jsbsim/systems/failures/payload-bay-switch-condition");

if (switch_condition < 1.0)
	{
	return;
	}



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


var update_rms_joint_selection = func {

var joint_string = getprop("/fdm/jsbsim/systems/rms/joint-selection-string");

var joint = 0;

if (joint_string == "SHOULDER YAW") {joint = 1;}
else if (joint_string == "SHOULDER PITCH") {joint = 2;}
else if (joint_string == "ELBOW PITCH") {joint = 3;}
else if (joint_string == "WRIST PITCH") {joint = 4;}
else if (joint_string == "WRIST YAW") {joint = 5;}
else if (joint_string == "WRIST ROLL") {joint = 6;}
else if (joint_string == "END EFF") {joint = 7;}

setprop("/fdm/jsbsim/systems/rms/joint-selection-mode", joint);

}


var update_rms_parameter_selection = func {

var parameter_string = getprop("/fdm/jsbsim/systems/rms/parameter-selection-string");

var par = 0;

if (parameter_string == "TEST") {par = 0;}
else if (parameter_string == "POSITION X/Y/Z") {par = 1;}
else if (parameter_string == "ATTITUDE P/Y/R") {par = 2;}
else if (parameter_string == "JOINT ANGLE") {par = 3;}

setprop("/fdm/jsbsim/systems/rms/parameter-selection-mode", par);

}


var update_rms_drive_selection = func {

var drive_string = getprop("/fdm/jsbsim/systems/rms/drive-selection-string");

var par = 0;
var seq_slot = 0;

if (drive_string == "SINGLE") {par = 1;}
else if (drive_string == "DIRECT") {par = 1;}
else if (drive_string == "ORB UNL X/Y/Z") {par = 2;}
else if (drive_string == "ORB UNL P/Y/R") {par = 3;}
else if (drive_string == "AUTO OPR CMD") {par = 4;}
else if (drive_string == "AUTO 1") {par = 5; seq_slot = 0;}
else if (drive_string == "AUTO 2") {par = 5; seq_slot = 1;}
else if (drive_string == "AUTO 3") {par = 5; seq_slot = 2;}
else if (drive_string == "AUTO 4") {par = 5; seq_slot = 3;}


#print ("Drive selection is now: ", par);

# switch over to the auto mode manager when needed

if (par == 4)
	{
	SpaceShuttle.pdrs_auto_seq_manager.opr_cmd_goto_point();
	return;
	}
else if (par == 5)
	{
	SpaceShuttle.pdrs_auto_seq_manager.start_sequence(seq_slot);
	return;
	}


setprop("/fdm/jsbsim/systems/rms/drive-selection-mode", par);

}


var update_rms_drive_selection_by_par = func (par) {

# par encodes both actual selections on dial and the fact that we have THC and RHC

var drive_string = "";
var drive_mode = 0;
var seq_slot = 0;

if (par == 0) {drive_string = "SINGLE"; drive_mode = 1;}
else if (par == 1) {drive_string = "DIRECT"; drive_mode = 1;}
else if (par == 2) {drive_string = "ORB UNL X/Y/Z";  drive_mode = 2;}
else if (par == 3) {drive_string = "ORB UNL P/Y/R"; drive_mode = 3;}
else if (par == 4) {drive_string = "AUTO OPR CMD"; drive_mode = 4;}
else if (par == 5) {drive_string = "AUTO 1"; drive_mode = 5;  seq_slot = 0;}
else if (par == 6) {drive_string = "AUTO 2"; drive_mode = 5;  seq_slot = 1;}
else if (par == 7) {drive_string = "AUTO 3"; drive_mode = 5;  seq_slot = 2;}
else if (par == 8) {drive_string = "AUTO 4"; drive_mode = 5;  seq_slot = 3;}


if (drive_mode == 4)
	{
	setprop("/fdm/jsbsim/systems/rms/drive-selection-string", drive_string);
	SpaceShuttle.pdrs_auto_seq_manager.opr_cmd_goto_point();
	return;
	}
else if (drive_mode == 5)
	{
	setprop("/fdm/jsbsim/systems/rms/drive-selection-string", drive_string);
	SpaceShuttle.pdrs_auto_seq_manager.start_sequence(seq_slot);
	return;
	}

setprop("/fdm/jsbsim/systems/rms/drive-selection-mode", drive_mode);
setprop("/fdm/jsbsim/systems/rms/drive-selection-string", drive_string);

}


var update_entry_guidance_target = func {


if (getprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode") == 1)
	{SpaceShuttle.compute_entry_guidance_target();}
}


var update_inclination = func {

# do not accept updates if guidance is running

if (getprop("/fdm/jsbsim/systems/ap/launch/autolaunch-master") == 1) {return;}

var raw = getprop("/sim/gui/dialogs/SpaceShuttle/auto_launch/inclination");
var lat = getprop("/position/latitude-deg");

var inc = lat + (90 - lat) * raw;

setprop("/fdm/jsbsim/systems/ap/launch/inclination-target", inc);

var la_raw =  math.asin(math.cos(inc * math.pi/180.0) / math.cos (lat * math.pi/180.0));

#print ("Raw: ", la_raw * 180/math.pi);

# approx correction due to Earth's rotation
var v_orbit = 7700; # 300 km orbit
var v_earth = 465;
var v_xe = v_orbit * math.sin(la_raw) - v_earth * math.cos(lat * math.pi/180.0);
var v_ye = v_orbit * math.cos(la_raw);

#print("vx: ", v_xe, "vy: ", v_ye);

var la_north = math.atan2(v_xe,v_ye);

la_north = 180.0/math.pi * la_north;

var la_south = 180.0 - la_north;

setprop("/sim/gui/dialogs/SpaceShuttle/auto_launch/azimuth-north", la_north);
setprop("/sim/gui/dialogs/SpaceShuttle/auto_launch/azimuth-south", la_south);

var direction = getprop("/sim/gui/dialogs/SpaceShuttle/auto_launch/select-north");

if (direction == 1)
	{
	var launch_azimuth = la_north;
	setprop("/fdm/jsbsim/systems/ap/launch/inc-acquire-sign", -1);
	}
else
	{
	var launch_azimuth = la_south;
	setprop("/fdm/jsbsim/systems/ap/launch/inc-acquire-sign", 1);
	}

setprop("/fdm/jsbsim/systems/ap/launch/launch-azimuth", launch_azimuth);

launch_azimuth = launch_azimuth * math.pi/180.0;

setprop("/fdm/jsbsim/systems/ap/launch/course-vector", -math.cos(launch_azimuth));
setprop("/fdm/jsbsim/systems/ap/launch/course-vector[1]", -math.sin(launch_azimuth) );
setprop("/fdm/jsbsim/systems/ap/launch/course-vector[2]", 0.0);


var apoapsis_target = getprop("/sim/gui/dialogs/SpaceShuttle/auto_launch/apoapsis-target-miles");
apoapsis_target = apoapsis_target * 1.852;

setprop("/fdm/jsbsim/systems/ap/launch/apoapsis-target", apoapsis_target);

}


setlistener("/sim/gui/dialogs/SpaceShuttle/auto_launch/apoapsis-target-miles", update_inclination);
setlistener("/sim/gui/dialogs/SpaceShuttle/auto_launch/inclination", update_inclination);
setlistener("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site", update_site);
setlistener("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", update_runway);
setlistener("/sim/gui/dialogs/SpaceShuttle/entry_guidance/entry-mode", update_entry_mode);
setlistener("/sim/config/shuttle/mdu-update-speed", update_MDU_speed);
setlistener("/sim/config/shuttle/ET-config", update_ET_config);
setlistener("/sim/config/shuttle/TC-config", update_TC_config);
setlistener("/sim/gui/dialogs/SpaceShuttle/limits/limit-mode", update_description);
setlistener("/sim/gui/dialogs/SpaceShuttle/limits/failure-scenario", update_scenario);
setlistener("/fdm/jsbsim/systems/mechanical/pb-door-auto-switch", pb_door_manager,0,0);
setlistener("/sim/config/shuttle/thermal-system-computation-speed", thermal_speed_manager,0,0);
setlistener("/sim/config/shuttle/rendering/use-earthview", update_earthview_manager,0,0);
setlistener("/sim/config/shuttle/rendering/earthview-transition-alt-ft", update_earthview_manager,0,0);
setlistener("/sim/gui/dialogs/SpaceShuttle/entry_guidance/EI-radius", update_entry_guidance_target ,0,0);


