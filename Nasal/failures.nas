# high-level failure management for the Space Shuttle

# (low level failures are processed by JSBSim in failures.xml)


# explosion of the orbiter on ascent, nothing remains functional

var orbiter_destroy = func {

# kill main engines

setprop("/fdm/jsbsim/systems/failures/ssme1-condition", 0.0);
setprop("/fdm/jsbsim/systems/failures/ssme2-condition", 0.0);
setprop("/fdm/jsbsim/systems/failures/ssme3-condition", 0.0);

# disconnect the SRBs

SpaceShuttle.SRB_separate();

# remove the tank

SpaceShuttle.external_tank_separate_silent();

# destroy aerodynamics

setprop("/fdm/jsbsim/systems/failures/airfoils-pitch-condition", 0.0);
setprop("/fdm/jsbsim/systems/failures/airfoils-roll-condition", 0.0);
setprop("/fdm/jsbsim/systems/failures/airfoils-yaw-condition", 0.0);

setprop("/fdm/jsbsim/systems/failures/aero-structure-condition", 0.05);


}

var fail_chute_pin = func {

setprop("/fdm/jsbsim/systems/failures/drag-chute-condition", 0.0);

}


var fail_gear_on_touchdown = func (vspeed) {

var vertical_overspeed = math.max(1.0,-vspeed / 9.0) -1.0;
var horizontal_overspeed = math.max(1.0, getprop("/velocities/groundspeed-kt")/ 225.0) - 1.0;


var tire_blow_probability = math.min(1.0, vertical_overspeed/0.2 + horizontal_overspeed/0.2);

var strut_breakage_probability = math.min(1.0, vertical_overspeed/0.3);

if (getprop("/gear/gear[0]/wow") == 1)
	{
	if (rand() < strut_breakage_probability)
		{
		setprop("/fdm/jsbsim/systems/failures/gearstrut-nose-condition", 0.0);
		setprop("/fdm/jsbsim/systems/failures/tire-nose-condition", 0.0);
		}
	if (rand() < tire_blow_probability)
		{
		setprop("/fdm/jsbsim/systems/failures/tire-nose-condition", 0.0);
		}
	}

if (getprop("/gear/gear[1]/wow") == 1)
	{
	if (rand() < strut_breakage_probability)
		{
		setprop("/fdm/jsbsim/systems/failures/gearstrut-left-condition", 0.0);
		setprop("/fdm/jsbsim/systems/failures/tire-left-condition", 0.0);
		}
	if (rand() < tire_blow_probability)
		{
		setprop("/fdm/jsbsim/systems/failures/tire-left-condition", 0.0);
		}
	}

if (getprop("/gear/gear[2]/wow") == 1)
	{
	if (rand() < strut_breakage_probability)
		{
		setprop("/fdm/jsbsim/systems/failures/gearstrut-right-condition", 0.0);
		setprop("/fdm/jsbsim/systems/failures/tire-right-condition", 0.0);
		}
	if (rand() < tire_blow_probability)
		{
		setprop("/fdm/jsbsim/systems/failures/tire-right-condition", 0.0);
		}
	}




}



