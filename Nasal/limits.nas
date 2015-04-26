# aerodynamical and structural limit management for the Space Shuttle

###########################################################################################
# limits are checked in distinct groups as the possible stresses on the orbiter vary quite 
# a bit - ascent, entry and landing
# reference for the limits is USA007587 - the Space Shuttle Crew Manual
# section 4: Operating Limitations and section 6: Emergency Procedures
###########################################################################################



# the warning flags are globals outside the loop so that warnings aren't repeated all the time
var qbar_warn = 0;
var droop_warn = 0;
var gear_extension_warn = 0;
var Nx_warn = 0;
var tailscrape_warn = 0;
var chute_warn = 0;
var vspeed_warn = 0;

# the limit simulation mode determines what we do when limits are violated

var limit_simulation_mode = 1;



var set_limit_mode = func {

limit_simulation_mode = getprop("/fdm/jsbsim/systems/failures/limit-simulation-mode");

}

setlistener("/fdm/jsbsim/systems/failures/limit-simulation-mode", set_limit_mode, 0,0);


#########################
# limits for ascent
#########################

var check_limits_ascent = func {

var fail_flag = 0;

# dynamical pressure needs to be smaller than 819 psf

var qbar = getprop("/fdm/jsbsim/aero/qbar-psf");

if ((qbar > 819.0) and (qbar_warn == 1))
	{
	setprop("/sim/messages/copilot", "Dynamical pressure exceeds limits!");
	fail_flag = 1;
	qbar_warn = 2;

	if (limit_simulation_mode == 1)
		{
		SpaceShuttle.orbiter_destroy();
		}

	}
else if ((qbar > 800.0) and (qbar_warn == 0))
	{
	setprop("/sim/messages/copilot", "Dynamical pressure approaching limit! Throttle down!");
	qbar_warn = 1;
	settimer(func {qbar_warn = 0;}, 10.0);
	}

# trajectory droop may not fall back below 265.000 ft to avoid excessive head loading on the tank

var v_inertial = getprop("/fdm/jsbsim/velocities/eci-velocity-mag-fps");
var altitude = getprop("/position/altitude-ft");

if (v_inertial > 12000.0)
	{
	if (altitude < 265000.0)
		{
		setprop("/sim/messages/copilot", "ET heat load exceeds limits!");
		fail_flag = 1;

		if (limit_simulation_mode == 1)
			{
			SpaceShuttle.orbiter_destroy();
			}
		}
	else if ((altitude < 300000.0) and(droop_warn == 0))
		{
		setprop("/sim/messages/copilot", "Dangerous heat load on ET - raise ascent trajectory!");
		droop_warn = 1;
		settimer(func {droop_warn = 0;}, 10.0);
		}

	}

# ascent safe acceleration limits are Nx = [0:3.11] g, Ny = [-0.18: 0.18] g, Nz = [-0.06:0.73] g 
# but they're translational accelerations - we check only Nx

var agl_altitude = getprop("/position/altitude-agl-ft");

var Nx = getprop("/fdm/jsbsim/accelerations/n-pilot-x-norm");

if (((Nx > 3.9) or (Nx < -0.5)) and (agl_altitude > 100)) 
	{
	setprop("/sim/messages/copilot", "Orbiter structural limits exceeded!");
	fail_flag = 1;
	
	if (limit_simulation_mode == 1)
		{
		SpaceShuttle.orbiter_destroy();
		}
	
	}
else if (((Nx > 3.19) or (Nx < -0.1)) and (Nx_warn == 0) and (agl_altitude > 100))
	{
	setprop("/sim/messages/copilot", "Acceleration exceeds safe limits! Throttle down!");
	Nx_warn = 1;
	settimer(func {Nx_warn = 0;}, 10.0);
	}


if (limit_simulation_mode ==2)
	{
	# we do a hard failure if a limit was overrun

	if (fail_flag == 1)
		{
		setprop("/fdm/jsbsim/simulation/terminate", 1);
		}	

	}


}


#################################
# limits for approach and landing
#################################




var check_limits_glide = func {

var fail_flag = 0;

# maximum gear extension speed is 312 KEAS

var keas = getprop("/velocities/equivalent-kt");

if ((getprop("/controls/gear/gear-down") == 1) and (keas > 312))
	{
	setprop("/sim/messages/copilot", "Gear extended above maximum speed!");
	fail_flag = 1;
	}
}

#################################
# limits for touchdown
#################################


var check_limits_touchdown = func {


var fail_flag = 0;

# tailscrape angle is 15 degrees

var pitch = getprop("/orientation/pitch-deg");
var pitch_rate = getprop("orientation/pitch-rate-degps");
var airspeed = getprop("/velocities/airspeed-kt");
var vspeed = getprop("/velocities/vertical-speed-fps");

if ((pitch > 15.0) and (tailscrape_warn == 1))
	{
	setprop("/sim/messages/copilot", "Tailscrape!");
	tailscrape_warn = 2;
	fail_flag = 1;
	}
else if ((pitch > 14.0) and (tailscrape_warn == 0))
	{
	setprop("/sim/messages/copilot", "Beware of tailscrape - nose down!");
	tailscrape_warn = 1;
	settimer(func {qbar_warn = 0;}, 10.0);
	}

# safe touchdown vertical speed is 6 to 9 fps


if (vspeed < -9.0) 
	{
	if (vspeed_warn == 0)
		{setprop("/sim/messages/copilot", "Vertical speed exceeds touchdown limits!");}
	vspeed_warn = 1;
	fail_flag = 1;
	#print("vspeed: ", vspeed);

	if (limit_simulation_mode == 1) {SpaceShuttle.fail_gear_on_touchdown(vspeed);}
	}

# derotation should not be faster than 2 deg/s


if ((pitch_rate < -2.0) and (getprop("/gear/gear[0]/wow") == 1))
	{
	setprop("/sim/messages/copilot", "Derotation exceeds nose wheel structural limits!");
	fail_flag = 1;
	}

# drag chute pin fails for airspeed > 230 kt upon deployment


if ((airspeed > 230.0) and (getprop("/controls/shuttle/parachute") >0 ) and (chute_warn == 0))
	{
	setprop("/sim/messages/copilot", "Above drag chute deployment speed!");
	fail_flag = 1;
	chute_warn = 1;
	
	if (limit_simulation_mode == 1) {SpaceShuttle.fail_chute_pin();}	
	
	}


if (limit_simulation_mode ==2)
	{
	# we do a hard failure if a limit was overrun

	if (fail_flag == 1)
		{
		setprop("/fdm/jsbsim/simulation/terminate", 1);
		}	

	}


}
