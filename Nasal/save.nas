# write the Shuttle state to auto-saved properties
# and resume from those
# Thorsten Renk 2016

var save_state = func {


var lat = getprop("/position/latitude-deg");
setprop("/save/latitude-deg", lat);

var lon = getprop("/position/longitude-deg");
setprop("/save/longitude-deg", lon);

var alt = getprop("/position/altitude-ft");
setprop("/save/altitude-ft", alt);

var heading = getprop("/orientation/heading-deg");
setprop("/save/heading-deg", heading);

var pitch = getprop("/orientation/pitch-deg");
setprop("/save/pitch-deg", pitch);

var roll = getprop("/orientation/roll-deg");
setprop("/save/roll-deg", roll);

var uBody = getprop("/velocities/uBody-fps");
setprop("/save/uBody-fps", uBody);

var vBody = getprop("/velocities/vBody-fps");
setprop("/save/vBody-fps", vBody);

var wBody = getprop("/velocities/wBody-fps");
setprop("/save/wBody-fps", wBody);

var tank1 = getprop("/consumables/fuel/tank[0]/level-lbs");
setprop("/save/tank1-level-lbs", tank1);

var tank2 = getprop("/consumables/fuel/tank[1]/level-lbs");
setprop("/save/tank2-level-lbs", tank2);

var tank3 = getprop("/consumables/fuel/tank[2]/level-lbs");
setprop("/save/tank3-level-lbs", tank3);

var tank4 = getprop("/consumables/fuel/tank[3]/level-lbs");
setprop("/save/tank4-level-lbs", tank4);

var tank5 = getprop("/consumables/fuel/tank[4]/level-lbs");
setprop("/save/tank5-level-lbs", tank5);

var tank6 = getprop("/consumables/fuel/tank[5]/level-lbs");
setprop("/save/tank6-level-lbs", tank6);

var tank7 = getprop("/consumables/fuel/tank[6]/level-lbs");
setprop("/save/tank7-level-lbs", tank7);

var tank8 = getprop("/consumables/fuel/tank[7]/level-lbs");
setprop("/save/tank8-level-lbs", tank8);

var tank9 = getprop("/consumables/fuel/tank[8]/level-lbs");
setprop("/save/tank9-level-lbs", tank9);

var tank10 = getprop("/consumables/fuel/tank[9]/level-lbs");
setprop("/save/tank10-level-lbs", tank10);

var tank11 = getprop("/consumables/fuel/tank[10]/level-lbs");
setprop("/save/tank11-level-lbs", tank11);

var tank12 = getprop("/consumables/fuel/tank[11]/level-lbs");
setprop("/save/tank12-level-lbs", tank12);

var tank13 = getprop("/consumables/fuel/tank[12]/level-lbs");
setprop("/save/tank13-level-lbs", tank13);

var tank14 = getprop("/consumables/fuel/tank[13]/level-lbs");
setprop("/save/tank14-level-lbs", tank14);

var tank15 = getprop("/consumables/fuel/tank[14]/level-lbs");
setprop("/save/tank15-level-lbs", tank15);

var tank16 = getprop("/consumables/fuel/tank[15]/level-lbs");
setprop("/save/tank16-level-lbs", tank16);

var tank17 = getprop("/consumables/fuel/tank[16]/level-lbs");
setprop("/save/tank17-level-lbs", tank17);

var tank18 = getprop("/consumables/fuel/tank[17]/level-lbs");
setprop("/save/tank18-level-lbs", tank18);

var tank19 = getprop("/consumables/fuel/tank[18]/level-lbs");
setprop("/save/tank19-level-lbs", tank19);

var throttle0 = getprop("/controls/engines/engine[0]/throttle");
setprop("/save/throttle[0]", throttle0);

var throttle1 = getprop("/controls/engines/engine[1]/throttle");
setprop("/save/throttle[1]", throttle1);

var throttle2 = getprop("/controls/engines/engine[2]/throttle");
setprop("/save/throttle[2]", throttle2);

var elapsed = getprop("/sim/time/elapsed-sec");
var MET = elapsed + getprop("/fdm/jsbsim/systems/timer/delta-MET");

setprop("/save/MET", MET);

var state = 0;

if (getprop("/controls/shuttle/SRB-static-model") == 0)
	{
	state = 1;
	}
if (getprop("/controls/shuttle/ET-static-model") == 0)
	{
	state = 2;
	}
if ((getprop("/fdm/jsbsim/systems/mechanical/pb-door-left-pos") == 1.0) and (getprop("/fdm/jsbsim/systems/mechanical/pb-door-right-pos") == 1.0))
	{
	state = 3;
	}
if (getprop("/fdm/jsbsim/systems/mechanical/ku-antenna-pos") == 1)
	{
	state = 4;
	}

setprop("/save/state", state);

var umbilical_state = 0;

if ((getprop("/fdm/jsbsim/systems/mechanical/et-door-right-pos") == 1) and (getprop("/fdm/jsbsim/systems/mechanical/et-door-left-pos") == 1))
	{
	umbilical_state = 1;
	}

setprop("/save/umbilical-state", umbilical_state);

var radiator_state = 0;

if (getprop("/fdm/jsbsim/systems/atcs/rad-heat-dump-capacity") > 0.0)
	{
	radiator_state = 1;
	}

setprop("/save/radiator-state", radiator_state);


var control_mode = getprop("/fdm/jsbsim/systems/fcs/control-mode");
var control_string = getprop("/controls/shuttle/control-system-string");

var orbital_dap_sel = 0;

if (getprop("/fdm/jsbsim/systems/ap/orbital-dap-auto") == 1)
	{orbital_dap_sel = 1;}
else if (getprop("/fdm/jsbsim/systems/ap/orbital-dap-lvlh") == 1)
	{orbital_dap_sel = 2;}
else if (getprop("/fdm/jsbsim/systems/ap/orbital-dap-free") == 1)
	{orbital_dap_sel = 3;}

setprop("/save/control-mode", control_mode);
setprop("/save/orbital-dap-sel", orbital_dap_sel);

var css_pitch = getprop("/fdm/jsbsim/systems/ap/css-pitch-control");
var css_roll = getprop("/fdm/jsbsim/systems/ap/css-roll-control");

setprop("/save/css-pitch", css_pitch);
setprop("/save/css-roll", css_roll);

var ops = getprop("/fdm/jsbsim/systems/dps/ops");
var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
var major_mode_sm = getprop("/fdm/jsbsim/systems/dps/major-mode-sm");
var guidance_mode = getprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode");
var landing_site = getprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site");
var runway = getprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway");

setprop("/save/ops", ops);
setprop("/save/major-mode", major_mode);
setprop("/save/major-mode-sm", major_mode_sm);
setprop("/save/control-string", control_string);
setprop("/save/guidance-mode", guidance_mode);
setprop("/save/landing-site", landing_site);
setprop("/save/runway", runway);


var auto_launch = getprop("/fdm/jsbsim/systems/ap/launch/autolaunch-master");
setprop("/save/auto-launch", auto_launch);

var auto_launch_stage = getprop("/fdm/jsbsim/systems/ap/launch/stage");
setprop("/save/auto-launch-stage", auto_launch_stage);

# thermal distribution

var n = size (SpaceShuttle.thermal_array);

for (var i =0; i< n; i=i+1 )
	{
	var T = SpaceShuttle.thermal_array[i].temperature;
	setprop("/save/temperature["~i~"]",T);
	
	}

# the scenario description

var timestring = getprop("/sim/time/real/year");
timestring = timestring~ "-"~getprop("/sim/time/real/month");
timestring = timestring~ "-"~getprop("/sim/time/real/day");
timestring = timestring~ "-"~getprop("/sim/time/real/hour");

var minute = getprop("/sim/time/real/minute");
if (minute < 10) {minute = "0"~minute;}
timestring = timestring~ ":"~minute;

var description = getprop("/sim/gui/dialogs/SpaceShuttle/save/description");

setprop("/save/description", description);
setprop("/save/timestring", timestring);



# now try to save it to a specified file

#var filename = "save1.xml";



var filename = getprop("/sim/gui/dialogs/SpaceShuttle/save/filename");
var path = getprop("/sim/fg-home") ~ "/aircraft-data/SpaceShuttleSave/"~filename;

var nodeSave = props.globals.getNode("/save", 0);
io.write_properties(path, nodeSave); 

print("Current state written to ", filename, " !");

}


var read_state_from_file = func (filename) {

var path = getprop("/sim/fg-home") ~ "/aircraft-data/SpaceShuttleSave/"~filename;
var readNode = props.globals.getNode("/save", 0);

io.read_properties(path, readNode);



}

var resume_state = func {


var lat = getprop("/save/latitude-deg");
setprop("/position/latitude-deg", lat);

var lon = getprop("/save/longitude-deg");
setprop("/position/longitude-deg", lon);

var alt = getprop("/save/altitude-ft");
setprop("/position/altitude-ft", alt);

var heading = getprop("/save/heading-deg");
setprop("/orientation/heading-deg", heading);

var pitch = getprop("/save/pitch-deg");
setprop("/orientation/pitch-deg", pitch);

var roll = getprop("/save/roll-deg");
setprop("/orientation/roll-deg", roll);

var uBody = getprop("/save/uBody-fps");
setprop("/velocities/uBody-fps", uBody);

var vBody = getprop("/save/vBody-fps");
setprop("/velocities/vBody-fps", vBody);

var wBody = getprop("/save/wBody-fps");
setprop("/velocities/wBody-fps", wBody);

var tank1 = getprop("/save/tank1-level-lbs");
setprop("/consumables/fuel/tank[0]/level-lbs", tank1);

var tank2 = getprop("/save/tank2-level-lbs");
setprop("/consumables/fuel/tank[1]/level-lbs", tank2);

var tank3 = getprop("/save/tank3-level-lbs");
setprop("/consumables/fuel/tank[2]/level-lbs", tank3);

var tank4 = getprop("/save/tank4-level-lbs");
setprop("/consumables/fuel/tank[3]/level-lbs", tank4);

var tank5 = getprop("/save/tank5-level-lbs");
setprop("/consumables/fuel/tank[4]/level-lbs", tank5);

var tank6 = getprop("/save/tank6-level-lbs");
setprop("/consumables/fuel/tank[5]/level-lbs", tank6);

var tank7 = getprop("/save/tank7-level-lbs");
setprop("/consumables/fuel/tank[6]/level-lbs", tank7);

var tank8 = getprop("/save/tank8-level-lbs");
setprop("/consumables/fuel/tank[7]/level-lbs", tank8);

var tank9 = getprop("/save/tank9-level-lbs");
setprop("/consumables/fuel/tank[8]/level-lbs", tank9);

var tank10 = getprop("/save/tank10-level-lbs");
setprop("/consumables/fuel/tank[9]/level-lbs", tank10);

var tank11 = getprop("/save/tank11-level-lbs");
setprop("/consumables/fuel/tank[10]/level-lbs", tank11);

var tank12 = getprop("/save/tank12-level-lbs");
setprop("/consumables/fuel/tank[11]/level-lbs", tank12);

var tank13 = getprop("/save/tank13-level-lbs");
setprop("/consumables/fuel/tank[12]/level-lbs", tank13);

var tank14 = getprop("/save/tank14-level-lbs");
setprop("/consumables/fuel/tank[13]/level-lbs", tank14);

var tank15 = getprop("/save/tank15-level-lbs");
setprop("/consumables/fuel/tank[14]/level-lbs", tank15);

var tank16 = getprop("/save/tank16-level-lbs");
setprop("/consumables/fuel/tank[15]/level-lbs", tank16);

var tank17 = getprop("/save/tank17-level-lbs");
setprop("/consumables/fuel/tank[16]/level-lbs", tank17);

var tank18 = getprop("/save/tank18-level-lbs");
setprop("/consumables/fuel/tank[17]/level-lbs", tank18);

var tank19 = getprop("/save/tank19-level-lbs");
setprop("/consumables/fuel/tank[18]/level-lbs", tank19);


var throttle0 = getprop("/save/throttle[0]");
setprop("/controls/engines/engine[0]/throttle", throttle0);

var throttle1 = getprop("/save/throttle[1]");
setprop("/controls/engines/engine[1]/throttle", throttle1);

var throttle2 = getprop("/save/throttle[2]");
setprop("/controls/engines/engine[2]/throttle", throttle2);


var elapsed = getprop("/sim/time/elapsed-sec");
var MET = getprop("/save/MET");

var delta_MET = MET - elapsed;
setprop("/fdm/jsbsim/systems/timer/delta-MET", delta_MET);

SpaceShuttle.gear_up();

var state = getprop("/save/state");

if (state > 0)
	{
	print("Separating SRBs");
	SpaceShuttle.SRB_separate_silent();
	setprop("/controls/shuttle/SRB-attach", 0);
	setprop("/ai/models/ballistic[0]/controls/slave-to-ac",0);
	setprop("/ai/models/ballistic[1]/controls/slave-to-ac",0);
	}
if (state > 1)
	{
	print("Separating ET");
	SpaceShuttle.external_tank_separate_silent();
	}
if (state > 2)
	{
	SpaceShuttle.pb_door_open();
	}
if (state > 3)
	{
	SpaceShuttle.ku_antenna_deploy();
	}




if (getprop("/save/umbilical-state") == 1)
	{
	SpaceShuttle.et_umbilical_door_close();
	}

if (getprop("/save/radiator-state") == 1)
	{
	SpaceShuttle.radiator_activate();
	}

var control_mode = getprop("/save/control-mode");
var orbital_dap_sel = getprop("/save/orbital-dap-sel");

setprop("/fdm/jsbsim/systems/fcs/control-mode", control_mode);

if (orbital_dap_sel == 0)
	{
	setprop("/fdm/jsbsim/systems/ap/orbital-dap-inertial", 1);
	setprop("/fdm/jsbsim/systems/ap/orbital-dap-auto", 0);
	setprop("/fdm/jsbsim/systems/ap/orbital-dap-lvlh", 0);
	setprop("/fdm/jsbsim/systems/ap/orbital-dap-free", 0);
	}
else if (orbital_dap_sel == 1)
	{
	setprop("/fdm/jsbsim/systems/ap/orbital-dap-inertial", 0);
	setprop("/fdm/jsbsim/systems/ap/orbital-dap-auto", 1);
	setprop("/fdm/jsbsim/systems/ap/orbital-dap-lvlh", 0);
	setprop("/fdm/jsbsim/systems/ap/orbital-dap-free", 0);
	}
else if (orbital_dap_sel == 2)
	{
	setprop("/fdm/jsbsim/systems/ap/orbital-dap-inertial", 0);
	setprop("/fdm/jsbsim/systems/ap/orbital-dap-auto", 0);
	setprop("/fdm/jsbsim/systems/ap/orbital-dap-lvlh", 1);
	setprop("/fdm/jsbsim/systems/ap/orbital-dap-free", 0);
	}
else if (orbital_dap_sel == 3)
	{
	setprop("/fdm/jsbsim/systems/ap/orbital-dap-inertial", 0);
	setprop("/fdm/jsbsim/systems/ap/orbital-dap-auto", 0);
	setprop("/fdm/jsbsim/systems/ap/orbital-dap-lvlh", 0);
	setprop("/fdm/jsbsim/systems/ap/orbital-dap-free", 1);
	}

var control_string = getprop("/save/control-string");

setprop("/controls/shuttle/control-system-string", control_string);


var css_pitch = getprop("/save/css-pitch");
var css_roll = getprop("/save/css-roll");

if (css_pitch == 1)
	{
	setprop("/fdm/jsbsim/systems/ap/css-pitch-control", 1);
	setprop("/fdm/jsbsim/systems/ap/automatic-pitch-control",0);
	}
else
	{
	setprop("/fdm/jsbsim/systems/ap/css-pitch-control", 0);
	setprop("/fdm/jsbsim/systems/ap/automatic-pitch-control",1);
	}

if (css_roll == 1)
	{
	setprop("/fdm/jsbsim/systems/ap/css-roll-control", 1);
	setprop("/fdm/jsbsim/systems/ap/automatic-roll-control",0);
	}
else
	{
	setprop("/fdm/jsbsim/systems/ap/css-roll-control", 0);
	setprop("/fdm/jsbsim/systems/ap/automatic-roll-control",1);
	}



var ops = getprop("/save/ops");
var major_mode = getprop("/save/major-mode");
var major_mode_sm = getprop("/save/major-mode-sm");

setprop("/fdm/jsbsim/systems/dps/ops", ops);
setprop("/fdm/jsbsim/systems/dps/major-mode", major_mode);
setprop("/fdm/jsbsim/systems/dps/major-mode-sm", major_mode_sm);

var auto_launch = getprop("/save/auto-launch");
setprop("/fdm/jsbsim/systems/ap/launch/autolaunch-master", auto_launch);

var auto_launch_laststage = getprop("//save/auto-launch-stage");
setprop("/fdm/jsbsim/systems/ap/launch/stage", auto_launch_laststage);


if (auto_launch == 1)
	{
	SpaceShuttle.auto_launch_stage = auto_launch_laststage;
	SpaceShuttle.auto_launch_loop();
	}


var guidance_mode = getprop("/save/guidance-mode");
var landing_site = getprop("/save/landing-site");
var runway = getprop("/save/runway");

setprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode", guidance_mode);

setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site", landing_site);
SpaceShuttle.update_site();

setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", runway);
SpaceShuttle.update_runway();

if (major_mode == 101)
		{SpaceShuttle.ops_transition_auto("p_ascent");}
else if (major_mode == 102)
		{SpaceShuttle.ops_transition_auto("p_ascent");}
else if (major_mode == 103)
		{SpaceShuttle.ops_transition_auto("p_ascent");}
else if (major_mode == 104) 
		{SpaceShuttle.ops_transition_auto("p_dps_mnvr");}
else if (major_mode == 105)
		{SpaceShuttle.ops_transition_auto("p_dps_mnvr");}
else if (major_mode == 106) 
		{SpaceShuttle.ops_transition_auto("p_dps_mnvr");}
else if (major_mode == 201)
		{SpaceShuttle.ops_transition_auto("p_dps_univ_ptg");}
else if (major_mode == 202)
		{SpaceShuttle.ops_transition_auto("p_dps_mnvr");}
else if (major_mode == 301)
		{SpaceShuttle.ops_transition_auto("p_dps_mnvr");}
else if (major_mode == 302)
		{SpaceShuttle.ops_transition_auto("p_dps_mnvr");}
else if (major_mode == 304) 
		{SpaceShuttle.ops_transition_auto("p_dps_mnvr");}
else if (major_mode == 304)
		{
		SpaceShuttle.traj_display_flag = 3;
		SpaceShuttle.fill_entry1_data();
		SpaceShuttle.ops_transition_auto("p_entry");
		}
else if (major_mode == 305)
		{
		SpaceShuttle.traj_display_flag = 8;
		SpaceShuttle.ops_transition_auto("p_vert_sit");
		SpaceShuttle.compute_TAEM_guidance_targets();
		}
else if (major_mode == 601)
		{
		setprop("/controls/shuttle/hud-mode",2);
		SpaceShuttle.ops_transition_auto("p_dps_rtls");
		SpaceShuttle.prtls_loop();
		}
else if (major_mode == 602)
		{
		SpaceShuttle.traj_display_flag = 8;
		setprop("/controls/shuttle/hud-mode",2);
		SpaceShuttle.ops_transition_auto("p_vert_sit");
		SpaceShuttle.grtls_loop();
		}
else if (major_mode == 603)
		{
		SpaceShuttle.traj_display_flag = 8;
		setprop("/controls/shuttle/hud-mode",2);
		SpaceShuttle.ops_transition_auto("p_vert_sit");
		SpaceShuttle.compute_TAEM_guidance_targets();
		}

# thermal distribution

var n = size (SpaceShuttle.thermal_array);

for (var i =0; i< n; i=i+1 )
	{
	var T = getprop("/save/temperature["~i~"]");
	SpaceShuttle.thermal_array[i].temperature = T;
	var C_heat = SpaceShuttle.thermal_array[i].mass * SpaceShuttle.thermal_array[i].heat_capacity;
	SpaceShuttle.thermal_array[i].thermal_energy = T * C_heat;
	}

# automatically switch Earthview on if the user has this selected

if ((SpaceShuttle.earthview_flag == 1) and (earthview.earthview_running_flag == 0))
	{
	var alt = getprop("/position/altitude-ft");
	if (alt > SpaceShuttle.earthview_transition_alt)
		{
		if (getprop("/sim/gui/dialogs/metar/mode/local-weather") == 1)
			{local_weather.clear_all();}
		earthview.start();
		}

	}

# remove any light manager info 

SpaceShuttle.light_manager.set_theme("CLEAR");

print("State resumed!");
}
