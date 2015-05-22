
# stage management for the Space Shuttle



var launch_loop_flag = 0;
var slowdown_loop_flag = 0;
var SRB_message_flag = 0;
var MECO_message_flag = 0;
var launch_message_flag = 0;
var SRB_burn_timer = 0.0;
var deorbit_stage_flag = 0;

aircraft.HUD.cycle_color();


#########################################################################################
# The launch loop takes care of ingition sequence, FDM changes due to SRB and external tank separation
# and provides various callouts and warnings during ascent. It ends with MECO where it hands over to the
# orbital loop
#########################################################################################

var launch_loop_start = func{

if (getprop("/engines/engine[0]/thrust_lb") == 0.0) {return;}	
if (launch_loop_flag ==1) {return;} 

setprop("/sim/messages/copilot", "Main engine ignition!");

setprop("/controls/engines/engine[0]/ignited-hud","x");
setprop("/controls/engines/engine[1]/ignited-hud","x");
setprop("/controls/engines/engine[2]/ignited-hud","x");

settimer(SRB_ignite, 3.0);
settimer(gear_up, 5.0);	
	
launch_loop_flag = 1;



launch_loop();

}



var launch_loop = func{

if (launch_message_flag == 5) {return;}

var SRB_fuel = getprop("/consumables/fuel/tank[1]/level-norm");
var external_tank_fuel = getprop("/consumables/fuel/tank[0]/level-norm");

var t_elapsed = getprop("/sim/time/elapsed-sec") - SRB_burn_timer + 6.0;

var periapsis = getprop("/fdm/jsbsim/systems/orbital/periapsis-indicated-km");

var thrust_engine1 = getprop("/engines/engine[0]/thrust_lb");
var thrust_engine2 = getprop("/engines/engine[1]/thrust_lb");
var thrust_engine3 = getprop("/engines/engine[2]/thrust_lb");



if ((SRB_fuel < 0.1) and (SRB_message_flag == 0))
	{SRB_warn(); SRB_message_flag = 1;}

if ((SRB_fuel < 0.01) and (SRB_message_flag == 1))
	{SRB_separate(); SRB_message_flag = 2;}

if ((t_elapsed > 34.0) and (launch_message_flag ==0) and (SRB_burn_timer >0.0))
	{
	setprop("/sim/messages/copilot", "t+34 s: throttle down!");
	launch_message_flag = 1;
	}

if ((t_elapsed > 54.0) and (launch_message_flag ==1))
	{
	setprop("/sim/messages/copilot", "t+54 s: throttle up!");
	launch_message_flag =2;
	}

if ((external_tank_fuel < 0.05) and (MECO_message_flag == 0))
	{MECO_warn(); MECO_message_flag = 1;}


if ((external_tank_fuel == 0.0) and (MECO_message_flag == 1))
	{external_tank_separate(); MECO_message_flag = 2; return;}


if ((periapsis > 0.0) and (launch_message_flag ==2))
	{orbit_warn(); launch_message_flag = 3;}


if (thrust_engine1 > 0.0)
	{
	setprop("/controls/engines/engine[0]/ignited-hud","x");
	}
else
	{
	setprop("/controls/engines/engine[0]/ignited-hud"," ");
	}

if (thrust_engine2 > 0.0)
	{
	setprop("/controls/engines/engine[1]/ignited-hud","x");
	}
else
	{
	setprop("/controls/engines/engine[1]/ignited-hud"," ");
	}
if (thrust_engine3 > 0.0)
	{
	setprop("/controls/engines/engine[2]/ignited-hud","x");
	}
else
	{
	setprop("/controls/engines/engine[2]/ignited-hud"," ");
	}

	
settimer(launch_loop, 1.0);
}


var SRB_ignite = func {

setprop("/sim/messages/copilot", "SRB ignition!");
setprop("/controls/engines/engine[3]/throttle", 1.0);
setprop("/controls/engines/engine[4]/throttle", 1.0);
setprop("/sim/model/effects/launch-smoke",1);

setprop("/controls/engines/engine[3]/ignited-hud","x");
setprop("/controls/engines/engine[4]/ignited-hud","x");

settimer(launch_smoke_off,1.5);

SRB_burn_timer = getprop("/sim/time/elapsed-sec");
}


var gear_up = func {

# we can't initialize with gear up on the ground without confusing JSBSim, but we can retract it automagically

setprop("/controls/gear/gear-down",0);

# also retract the SRB contact points

setprop("/fdm/jsbsim/contact/unit[3]/z-position",0.0);
setprop("/fdm/jsbsim/contact/unit[4]/z-position",0.0);
setprop("/fdm/jsbsim/contact/unit[5]/z-position",0.0);


}

var launch_smoke_off = func {

setprop("/sim/model/effects/launch-smoke",0);

}

var SRB_warn = func {

setprop("/sim/messages/copilot", "Prepare for SRB separation!");

}

var MECO_warn = func {

setprop("/sim/messages/copilot", "Prepare for MECO!");

}

var orbit_warn = func {

setprop("/sim/messages/copilot", "Reduce throttle and prepare  orbital insertion!");

}

var SRB_separate = func {

setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[3]", 0.0);
setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[4]", 0.0);

setprop("/controls/engines/engine[3]/status-hud", "X");
setprop("/controls/engines/engine[4]/status-hud", "X");

setprop("/controls/engines/engine[3]/ignited-hud", " ");
setprop("/controls/engines/engine[4]/ignited-hud", " ");

setprop("/sim/messages/copilot", "SRB separation!");
setprop("/sim/messages/copilot", "Burn time was "~(int(getprop("/sim/time/elapsed-sec") - SRB_burn_timer))~" seconds.");

}


var external_tank_separate = func {

if (SRB_message_flag < 2)
	{	
	setprop("/sim/messages/copilot", "Can't separate tank while SRBs are connected!");
	return;
	}

setprop("/consumables/fuel/tank[0]/level-norm",0.0);

setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[1]", 0.0);
setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[2]", 0.0);

setprop("/sim/messages/copilot", "External tank separation!");

# and set throttle to zero

setprop("/controls/engines/engine[0]/throttle", 0.0);
setprop("/controls/engines/engine[1]/throttle", 0.0);
setprop("/controls/engines/engine[2]/throttle", 0.0);

setprop("/controls/engines/engine[0]/status-hud", "X");
setprop("/controls/engines/engine[1]/status-hud", "X");
setprop("/controls/engines/engine[2]/status-hud", "X");

setprop("/controls/engines/engine[0]/ignited-hud", " ");
setprop("/controls/engines/engine[1]/ignited-hud", " ");
setprop("/controls/engines/engine[2]/ignited-hud", " ");

launch_message_flag = 5;

settimer(control_to_rcs, 2.0);
settimer(orbital_loop,2.0);
}

var control_to_rcs = func {

var stage = getprop("/sim/presets/stage");

if ((stage == 3) or (stage ==4)){return;}

# transfer controls to RCS

setprop("/fdm/jsbsim/systems/fcs/control-mode",1);
setprop("/sim/messages/copilot", "Control switched to RCS.");
setprop("/controls/shuttle/control-system-string", "RCS rotation");

# transfer thrust control to OMS

setprop("/sim/input/selected/engine[0]",0);
setprop("/sim/input/selected/engine[1]",0);
setprop("/sim/input/selected/engine[2]",0);

setprop("/sim/input/selected/engine[5]",1);
setprop("/sim/input/selected/engine[6]",1);

}



#########################################################################################
# The orbital loop watches for events in orbit - currently it handles the HUD symbology of
# OMS engine ignition and de-orbit
#########################################################################################

var orbital_loop = func {


var thrust_OMS1 = getprop("/engines/engine[5]/thrust_lb");
var thrust_OMS2 = getprop("/engines/engine[6]/thrust_lb");

if (thrust_OMS1 > 0.0)
	{
	setprop("/controls/engines/engine[5]/ignited-hud","x");
	}
else
	{
	setprop("/controls/engines/engine[5]/ignited-hud"," ");
	}

if (thrust_OMS2 > 0.0)
	{
	setprop("/controls/engines/engine[6]/ignited-hud","x");
	}
else
	{
	setprop("/controls/engines/engine[6]/ignited-hud"," ");
	}

var alt = getprop("/position/altitude-ft");

if (alt < 400000.0)
	{

	var periapsis = getprop("/fdm/jsbsim/systems/orbital/periapsis-indicated-km");
	
	if (periapsis < 80.0)
		{
		setprop("/sim/messages/copilot", "Entry Interface reached.");
		setprop("/controls/shuttle/hud-mode",2);
		deorbit_loop();
		return;
		}
	
	}

settimer(orbital_loop, 1.0);
}





var switch_control_mode = func {

var current_mode = getprop("/fdm/jsbsim/systems/fcs/control-mode");

if (current_mode == 1) 
	{
	setprop("/fdm/jsbsim/systems/fcs/control-mode",2);
	setprop("/controls/shuttle/control-system-string", "RCS translation");
	}
else if (current_mode ==2)
	{
	setprop("/fdm/jsbsim/systems/fcs/control-mode",1);
	setprop("/controls/shuttle/control-system-string", "RCS rotation");
	}
	
}


###########################################################################
# the deorbit loop primarily checks when to transfer control authority from
# RCS to the airfoils
###########################################################################


var deorbit_loop = func {



var qbar = getprop("/fdm/jsbsim/aero/qbar-psf");

if ((qbar > 10.0) and (deorbit_stage_flag == 0))
	{
	setprop("/fdm/jsbsim/systems/fcs/control-mode",3);
	setprop("/controls/shuttle/control-system-string", "RCS / Aero");
	setprop("/fdm/jsbsim/systems/fcs/rcs-roll-mode", 0);
	setprop("/sim/messages/copilot", "Roll control to aero.");
	deorbit_stage_flag = 1;
	}

if ((qbar > 20.0) and   (deorbit_stage_flag == 1))
	{
	setprop("/fdm/jsbsim/systems/fcs/rcs-pitch-mode", 0);
	setprop("/sim/messages/copilot", "Pitch control to aero.");
	deorbit_stage_flag = 2;
	}

if ((getprop("/fdm/jsbsim/velocities/mach") < 3.5) and (deorbit_stage_flag == 2))
	{
	setprop("/fdm/jsbsim/systems/fcs/rcs-yaw-mode", 0);
	setprop("/fdm/jsbsim/systems/fcs/control-mode",4);	
	setprop("/sim/messages/copilot", "Yaw control to aero.");
	setprop("/controls/shuttle/control-system-string", "Aerodynamical");
	deorbit_stage_flag = 3;
	}

if ((getprop("/position/altitude-ft") < 85000.0) and (deorbit_stage_flag == 3))
	{
	setprop("/sim/messages/copilot", "TAEM interface reached.");
	setprop("/controls/shuttle/hud-mode",3);
	return;
	}

settimer(deorbit_loop,1.0);
}


var show_gear_state = func {

var gear_state = getprop("/controls/gear/gear-down");

if (gear_state == 0)
	{setprop("/controls/shuttle/gear-string", "up");}
else if (gear_state == 1)
	{setprop("/controls/shuttle/gear-string", "down");}

}

var show_speedbrake_state = func {

var speedbrake_state = getprop("/controls/flight/speedbrake");

if (speedbrake_state == 0)
	{setprop("/controls/shuttle/speedbrake-string", "in");}
else if (speedbrake_state == 1)
	{setprop("/controls/shuttle/speedbrake-string", "out");}

}



var deploy_chute = func {

var wheels_down = getprop("/fdm/jsbsim/gear/wow");

if (wheels_down==0)	
	{
	setprop("/sim/messages/copilot", "Chute can only be deployed after touchdown!");
	return;
	}

var current_state = getprop("/controls/shuttle/parachute");

if (current_state == 0)
	{
	setprop("/controls/shuttle/parachute",1);
	}
if (current_state == 1)
	{
	setprop("/controls/shuttle/parachute",2);
	}
setprop("/controls/shuttle/drag-chute-string", "deployed");

}

#########################################################
# the slowdown loop checks for wheels stop
#########################################################

var slowdown_loop_start = func {

if ((getprop("/gear/gear[1]/wow") == 0) or (slowdown_loop_flag ==1)) {return;}

setprop("/sim/messages/copilot", "Touchdown!");
slowdown_loop_flag = 1;
settimer(slowdown_loop, 5.0);
}

var slowdown_loop = func {

if (getprop("/gear/gear[1]/rollspeed-ms") < 0.1)
	{
	setprop("/sim/messages/copilot", "Wheels stop!");
	return;
	}


settimer(slowdown_loop,1.0);
}


var log_loop= func {

print(getprop("/position/altitude-ft"));
settimer(log_loop,0.0);
}


##############################################################################
# the set_speed function initializes the shuttle to proper orbital/suborbital
# velocity and at the right locations for TAEM and final based on the selected
# mission stage
#############################################################################

var set_speed = func {



if (getprop("/sim/presets/stage") == 1) 
	{
	# nothing is ever simple - we need to consider the rotation of Earth

	var latitude = getprop("/position/latitude-deg") * 3.1415/180.0;
	var heading = getprop("/orientation/heading-deg") * 3.1415/180.0;

	var rotation_boost = 1579.0 * math.cos(latitude) * math.sin(heading);
	setprop("/velocities/uBody-fps", 26100.0 - rotation_boost);
	}

if (getprop("/sim/presets/stage") == 2) 
	{

	var latitude = getprop("/position/latitude-deg") * 3.1415/180.0;
	var heading = getprop("/orientation/heading-deg") * 3.1415/180.0;

	var rotation_boost = 1579.0 * math.cos(latitude) * math.sin(heading);
	setprop("/velocities/uBody-fps", 25100.0 - rotation_boost);
	setprop("/velocities/wBody-fps", 200.0);
	deorbit_loop();
	}

if (getprop("/sim/presets/stage") == 3) 
	{
	# gliding speed is about Mach 2.5 at 83.000 ft

	var lat_to_m = 110952.0; 
	var lon_to_m  = math.cos(getprop("/position/latitude-deg")*math.pi/180.0) * lat_to_m;
	var m_to_lon = 1.0/lon_to_m;
	var m_to_lat = 1.0/lat_to_m;

	var heading = getprop("/orientation/heading-deg");
	var place_dir = heading + 180.0;
	if (place_dir > 360.0) {place_dir = place_dir-360.0;}
	place_dir = place_dir * math.pi/180.0;

	var place_dist = 108000.0; # 60 miles downrange
	var place_x = place_dist * math.sin(place_dir);
	var place_y = place_dist * math.cos(place_dir);

	var place_lat = getprop("/position/latitude-deg") + m_to_lat * place_y;
	var place_lon = getprop("/position/longitude-deg") + m_to_lon * place_x;

	#print (place_lat, " ",place_lon);

	setprop("/position/latitude-deg", place_lat); 
	setprop("/position/longitude-deg", place_lon); 

	setprop("/velocities/uBody-fps",2500.0);
	}

if (getprop("/sim/presets/stage") == 4) 
	{
	# gliding speed is 350 kt at 10.000 ft 8 miles from runway

	var lat_to_m = 110952.0; 
	var lon_to_m  = math.cos(getprop("/position/latitude-deg")*math.pi/180.0) * lat_to_m;
	var m_to_lon = 1.0/lon_to_m;
	var m_to_lat = 1.0/lat_to_m;

	var heading = getprop("/orientation/heading-deg");
	var place_dir = heading + 180.0;
	if (place_dir > 360.0) {place_dir = place_dir-360.0;}
	place_dir = place_dir * math.pi/180.0;

	var place_dist = 15000.0; # 11 miles downrange
	var place_x = place_dist * math.sin(place_dir);
	var place_y = place_dist * math.cos(place_dir);

	var place_lat = getprop("/position/latitude-deg") + m_to_lat * place_y;
	var place_lon = getprop("/position/longitude-deg") + m_to_lon * place_x;

	#print (place_lat, " ",place_lon);

	setprop("/position/latitude-deg", place_lat); 
	setprop("/position/longitude-deg", place_lon); 

	setprop("/velocities/uBody-fps",600.0);
	setprop("/velocities/wBody-fps", 60.0);
	}


}

# register a few listeners to events which need HUD changes or callouts

setlistener("/engines/engine[0]/thrust_lb", func {launch_loop_start();},0,0);
setlistener("/gear/gear[1]/wow", func {slowdown_loop_start();},0,0);
setlistener("/controls/gear/gear-down", func {show_gear_state();},0,0);
setlistener("/controls/flight/speedbrake", func {show_speedbrake_state();},0,0);

# determine the initial state of the craft based on selected mission stage

if (getprop("/position/altitude-ft") > 350000.0) # we start in orbit
	{
	SRB_message_flag = 2;
	settimer(set_speed, 0.5);
	SRB_separate();
	gear_up();
	external_tank_separate();
	setprop("/consumables/fuel/tank[0]/level-norm",0.0);
	setprop("/consumables/fuel/tank[1]/level-norm",0.0);
	setprop("/consumables/fuel/tank[2]/level-norm",0.0);
	}

if (getprop("/sim/presets/stage") == 3) # we start with the TAEM
	{
	SRB_message_flag = 2;
	settimer(set_speed, 0.5);
	SRB_separate();
	gear_up();
	external_tank_separate();
	setprop("/consumables/fuel/tank[0]/level-norm",0.0);
	setprop("/consumables/fuel/tank[1]/level-norm",0.0);
	setprop("/consumables/fuel/tank[2]/level-norm",0.0);
	setprop("/consumables/fuel/tank[3]/level-norm",0.0);
	setprop("/consumables/fuel/tank[4]/level-norm",0.0);
	setprop("/consumables/fuel/tank[5]/level-norm",0.0);

	# transfer controls to aero

	setprop("/fdm/jsbsim/systems/fcs/control-mode",4);
	setprop("/sim/messages/copilot", "Control switched to aero.");
	setprop("/controls/shuttle/control-system-string", "Aerodynamical");
	setprop("/controls/shuttle/hud-mode",3);
	}



if (getprop("/sim/presets/stage") == 4) # we start with the final approach
	{
	SRB_message_flag = 2;
	settimer(set_speed, 0.5);
	SRB_separate();
	gear_up();
	external_tank_separate();
	setprop("/consumables/fuel/tank[0]/level-norm",0.0);
	setprop("/consumables/fuel/tank[1]/level-norm",0.0);
	setprop("/consumables/fuel/tank[2]/level-norm",0.0);
	setprop("/consumables/fuel/tank[3]/level-norm",0.0);
	setprop("/consumables/fuel/tank[4]/level-norm",0.0);
	setprop("/consumables/fuel/tank[5]/level-norm",0.0);

	# transfer controls to aero

	setprop("/fdm/jsbsim/systems/fcs/control-mode",3);
	setprop("/sim/messages/copilot", "Control switched to aero.");
	setprop("/controls/shuttle/control-system-string", "Aerodynamical");
	setprop("/controls/shuttle/hud-mode",3);
	}
