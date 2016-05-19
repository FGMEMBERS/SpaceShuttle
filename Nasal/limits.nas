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
var CBW_warn = 0;
var tailscrape_warn = 0;
var chute_warn = 0;
var vspeed_warn = 0;
var TPS_ET_warn = 0;
var TPS_warn = 0;
var avionics_bay_heat_warn = 0;
var apu_heat_warn = 0;

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

# wing bending moment coeff at max. qbar needs to be |CBW| < 0.18

var CBW = getprop("/fdm/jsbsim/systems/various/wing-bending-moment");


if ((math.abs(CBW) > 2458000.0) and (CBW_warn == 1))
	{
	setprop("/sim/messages/copilot", "Wing bending moment exceeds limits!");
	fail_flag = 1;
	CBW_warn = 2;

	if (limit_simulation_mode == 1)
		{
		SpaceShuttle.orbiter_destroy();
		}

	}
else if ((math.abs(CBW) > 2000000.0) and (CBW_warn == 0))
	{
	setprop("/sim/messages/copilot", "Wing bending moment approaches safety limits! Watch AoA!");
	CBW_warn = 1;
	settimer(func {CBW_warn = 0;}, 10.0);
	}




if (limit_simulation_mode ==2)
	{
	# we do a hard failure if a limit was overrun

	if (fail_flag == 1)
		{
		setprop("/fdm/jsbsim/simulation/terminate", 1);
		}	

	}


# check for pre-defined failures

SpaceShuttle.mission_predefined_failures();

}


#########################
# limits in orbit
#########################


var check_limits_orbit = func {


var fail_flag = 0;

# avionics bay temperature needs to be < 130 F (328 K)

var T = getprop("/fdm/jsbsim/systems/thermal-distribution/avionics-temperature-K");

if ((T > 335.0) and (avionics_bay_heat_warn == 1))
	{
	setprop("/sim/messages/copilot", "Total avionics failure!");
	fail_flag = 1;
	avionics_bay_heat_warn = 2;

	if (limit_simulation_mode == 1)
		{
		setprop("/fdm/jsbsim/simulation/terminate", 1);
		}

	}
else if ((T > 328.0) and (avionics_bay_heat_warn == 0))
	{
	setprop("/sim/messages/copilot", "Avionics bay overheating - check thermal management!");
	avionics_bay_heat_warn = 1;
	settimer(func {avionics_bay_heat_warn = 0;}, 60.0);
	}

	

# APU temperature needs to be < ~260 F (400 K)

var T1 = getprop("/fdm/jsbsim/systems/thermal-distribution/apu1-temperature-K");
var T2 = getprop("/fdm/jsbsim/systems/thermal-distribution/apu2-temperature-K");
var T3 = getprop("/fdm/jsbsim/systems/thermal-distribution/apu3-temperature-K");

var T = 0.0;

if (T1 > T2){T = T1;} 
else {T = T2;}

if (T3 > T) {T = T3;}


if ((T > 405.0) and (apu_heat_warn == 1))
	{
	setprop("/sim/messages/copilot", "APU damage!");
	fail_flag = 1;
	apu_heat_warn = 2;
	settimer( func {apu_heat_warn = 0;}, 20.0);

	if (limit_simulation_mode == 1)
		{
		if (T1 > 405.0)
			{setprop("/fdm/jsbsim/systems/failures/apu1-condition", 0.0);}
		if (T2 > 405.0)
			{setprop("/fdm/jsbsim/systems/failures/apu2-condition", 0.0);}
		if (T3 > 405.0)
			{setprop("/fdm/jsbsim/systems/failures/apu3-condition", 0.0);}
		}

	}
else if ((T > 400.0) and (apu_heat_warn == 0))
	{
	setprop("/sim/messages/copilot", "APU overheating - activate spray boilers!");
	apu_heat_warn = 1;
	settimer(func {apu_heat_warn = 0;}, 60.0);
	}


if (limit_simulation_mode ==2)
	{
	# we do a hard failure if a limit was overrun

	if (fail_flag == 1)
		{
		setprop("/fdm/jsbsim/simulation/terminate", 1);
		}	

	}

# check for pre-defined failures

SpaceShuttle.mission_predefined_failures();


}

#########################
# limits for entry
#########################

var check_limits_entry = func {

var fail_flag = 0;

# ET umbilical doors and payload bay door need to be closed

var T = getprop("/fdm/jsbsim/systems/thermal/nose-temperature-F");
var ET_door_state = getprop("/fdm/jsbsim/systems/mechanical/et-door-right-latch-pos") * getprop("/fdm/jsbsim/systems/mechanical/et-door-left-latch-pos");
var PB_door_state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-left-animation") * getprop("/fdm/jsbsim/systems/mechanical/pb-door-right-animation");

if ((T > 1000) and (ET_door_state == 0) and (PB_door_state ==0))
	{
	setprop("/sim/messages/copilot", "Thermal protection failure!");
	fail_flag = 1;
	TPS_ET_warn = 2;

	if (limit_simulation_mode == 1)
		{
		SpaceShuttle.orbiter_tps_fail();
		}	

	}




if ((T > 2900.0) and (TPS_warn == 1))
	{
	setprop("/sim/messages/copilot", "Thermal protection system failure!");
	fail_flag = 1;
	TPS_warn = 2;

	if (limit_simulation_mode == 1)
		{
		SpaceShuttle.orbiter_tps_fail();
		}

	}
else if ((T > 2800.0) and (TPS_warn == 0))
	{
	setprop("/sim/messages/copilot", "Heat shield temperature too high!");
	TPS_warn = 1;
	settimer(func {if (TPS_warn < 2) {TPS_warn = 0;}}, 10.0);
	}


# avionics bay temperature needs to be < 130 F (328 K)

var T_av = getprop("/fdm/jsbsim/systems/thermal-distribution/avionics-temperature-K");

if ((T_av > 335.0) and (avionics_bay_heat_warn == 1))
	{
	setprop("/sim/messages/copilot", "Total avionics failure!");
	fail_flag = 1;
	avionics_bay_heat_warn = 2;

	if (limit_simulation_mode == 1)
		{
		setprop("/fdm/jsbsim/simulation/terminate", 1);
		}

	}
else if ((T_av > 328.0) and (avionics_bay_heat_warn == 0))
	{
	setprop("/sim/messages/copilot", "Avionics bay overheating - check thermal management!");
	avionics_bay_heat_warn = 1;
	settimer(func {avionics_bay_heat_warn = 0;}, 60.0);
	}

# APU temperature needs to be < ~260 F (400 K)

var T1 = getprop("/fdm/jsbsim/systems/thermal-distribution/apu1-temperature-K");
var T2 = getprop("/fdm/jsbsim/systems/thermal-distribution/apu2-temperature-K");
var T3 = getprop("/fdm/jsbsim/systems/thermal-distribution/apu3-temperature-K");

var T_apu = 0.0;

if (T1 > T2){T_apu = T1;} 
else {T_apu = T2;}

if (T3 > T_apu) {T_apu = T3;}


if ((T_apu > 405.0) and (apu_heat_warn == 1))
	{
	setprop("/sim/messages/copilot", "APU damage!");
	fail_flag = 1;
	apu_heat_warn = 2;
	settimer( func {apu_heat_warn = 0;}, 20.0);

	if (limit_simulation_mode == 1)
		{
		if (T1 > 405.0)
			{setprop("/fdm/jsbsim/systems/failures/apu1-condition", 0.0);}
		if (T2 > 405.0)
			{setprop("/fdm/jsbsim/systems/failures/apu2-condition", 0.0);}
		if (T3 > 405.0)
			{setprop("/fdm/jsbsim/systems/failures/apu3-condition", 0.0);}
		}

	}
else if ((T_apu > 400.0) and (apu_heat_warn == 0))
	{
	setprop("/sim/messages/copilot", "APU overheating - activate spray boilers!");
	apu_heat_warn = 1;
	settimer(func {apu_heat_warn = 0;}, 60.0);
	}





if (limit_simulation_mode ==2)
	{
	# we do a hard failure if a limit was overrun

	if (fail_flag == 1)
		{
		setprop("/fdm/jsbsim/simulation/terminate", 1);
		}	

	}

# check for pre-defined failures

SpaceShuttle.mission_predefined_failures();
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


# avionics bay temperature needs to be < 130 F (328 K)

var T_av = getprop("/fdm/jsbsim/systems/thermal-distribution/avionics-temperature-K");

if ((T_av > 335.0) and (avionics_bay_heat_warn == 1))
	{
	setprop("/sim/messages/copilot", "Total avionics failure!");
	fail_flag = 1;
	avionics_bay_heat_warn = 2;

	if (limit_simulation_mode == 1)
		{
		setprop("/fdm/jsbsim/simulation/terminate", 1);
		}

	}
else if ((T_av > 328.0) and (avionics_bay_heat_warn == 0))
	{
	setprop("/sim/messages/copilot", "Avionics bay overheating - check thermal management!");
	avionics_bay_heat_warn = 1;
	settimer(func {avionics_bay_heat_warn = 0;}, 60.0);
	}

# APU temperature needs to be < ~260 F (400 K)

var T1 = getprop("/fdm/jsbsim/systems/thermal-distribution/apu1-temperature-K");
var T2 = getprop("/fdm/jsbsim/systems/thermal-distribution/apu2-temperature-K");
var T3 = getprop("/fdm/jsbsim/systems/thermal-distribution/apu3-temperature-K");

var T_apu = 0.0;

if (T1 > T2){T_apu = T1;} 
else {T_apu = T2;}

if (T3 > T_apu) {T_apu = T3;}


if ((T_apu > 405.0) and (apu_heat_warn == 1))
	{
	setprop("/sim/messages/copilot", "APU damage!");
	fail_flag = 1;
	apu_heat_warn = 2;
	settimer( func {apu_heat_warn = 0;}, 20.0);

	if (limit_simulation_mode == 1)
		{
		if (T1 > 405.0)
			{setprop("/fdm/jsbsim/systems/failures/apu1-condition", 0.0);}
		if (T2 > 405.0)
			{setprop("/fdm/jsbsim/systems/failures/apu2-condition", 0.0);}
		if (T3 > 405.0)
			{setprop("/fdm/jsbsim/systems/failures/apu3-condition", 0.0);}
		}

	}
else if ((T_apu > 400.0) and (apu_heat_warn == 0))
	{
	setprop("/sim/messages/copilot", "APU overheating - activate spray boilers!");
	apu_heat_warn = 1;
	settimer(func {apu_heat_warn = 0;}, 60.0);
	}


# qbar larger than a Mach-dependent limit will lead to actuator stall, stall itself is 
# implemented FDM-side
# during final approach we go close to qbar limit, but actuator stall isn't an issue
# hence we don't issue a warning

var qbar = getprop("/fdm/jsbsim/aero/qbar-psf");
var qbar_limit = getprop("/fdm/jsbsim/systems/various/qbar-limit-entry");
var mach = getprop("/velocities/mach");

if ((qbar > qbar_limit) and (qbar_warn == 0) and (mach > 1.0))
	{
	setprop("/sim/messages/copilot", "Dynamical pressure approaching limit! Pull up!");
	qbar_warn = 1;
	settimer(func {qbar_warn = 0;}, 10.0);
	}


if (limit_simulation_mode == 2)
	{
	# we do a hard failure if a limit was overrun

	if (fail_flag == 1)
		{
		setprop("/fdm/jsbsim/simulation/terminate", 1);
		}	

	}

# check for pre-defined failures

SpaceShuttle.mission_predefined_failures();


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
