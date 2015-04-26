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

#########################
# limits for ascent
#########################

var check_limits_ascent = func {

var fail_flag = 0;

# dynamical pressure needs to be smaller than 819 psf

var qbar = getprop("/fdm/jsbsim/aero/qbar-psf");

if (qbar > 819.0)
	{
	setprop("/sim/messages/copilot", "Dynamical pressure exceeds limits!");
	fail_flag = 1;
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
	}
else if (((Nx > 3.19) or (Nx < -0.1)) and (Nx_warn == 0) and (agl_altitude > 100))
	{
	setprop("/sim/messages/copilot", "Acceleration exceeds safe limits! Throttle down!");
	Nx_warn = 1;
	settimer(func {Nx_warn = 0;}, 10.0);
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

