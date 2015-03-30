
# stage management for the Space Shuttle



var launch_loop_flag = 0;
var SRB_message_flag = 0;
var MECO_message_flag = 0;
var launch_message_flag = 0;
var SRB_burn_timer = 0.0;

aircraft.HUD.cycle_color();

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

if ((SRB_fuel < 0.1) and (SRB_message_flag == 0))
	{SRB_warn(); SRB_message_flag = 1;}

if ((SRB_fuel == 0.0) and (SRB_message_flag == 1))
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
	
settimer(launch_loop, 1.0);
}

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

settimer(orbital_loop, 1.0);
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

var set_launch_pos = func {

print("Setting launch pos.");
var current_alt = getprop("/position/altitude-ft") - getprop("/position/altitude-agl-ft");
setprop("/orientation/pitch-deg",90.0);
setprop("/position/altitude-ft",current_alt +54.0);
#setprop("/fdm/jsbsim/forces/hold-down", 1);

}

var log_loop= func {

print(getprop("/position/altitude-ft"));
settimer(log_loop,0.0);
}

var set_speed = func {

setprop("/velocities/uBody-fps", 27400.0);
}

setlistener("/engines/engine[0]/thrust_lb", func {launch_loop_start();});

#log_loop();

#settimer(set_launch_pos, 0.5);

if (getprop("/position/altitude-ft") > 450000.0) # we start in orbit
	{
	SRB_message_flag = 2;
	settimer(set_speed, 0.5);
	SRB_separate();
	external_tank_separate();
	setprop("/consumables/fuel/tank[0]/level-norm",0.0);
	setprop("/consumables/fuel/tank[1]/level-norm",0.0);
	setprop("/consumables/fuel/tank[2]/level-norm",0.0);
	}
