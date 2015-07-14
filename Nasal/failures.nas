### failure management for the Space Shuttle
### Thorsten Renk 2015

# high-level failure management for the Space Shuttle
# (low level failures are processed by JSBSim in failures.xml)
# we simulate failures due to limit violations as well as failure scenarios without a particular cause



# the failure hash stores information about components which refuse to acknowledge a command

var failure_cmd = {
	speedbrake:1,
	ssme1: 1,
	ssme2: 1,
	ssme3: 1
	};




##############################################
#### failures caused by limit violations #####
##############################################


#### explosion of the orbiter on ascent, nothing remains functional

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

#### breakup of the orbiter on atmospheric entry

var orbiter_tps_fail = func {



# destroy aerodynamics

setprop("/fdm/jsbsim/systems/failures/airfoils-pitch-condition", 0.0);
setprop("/fdm/jsbsim/systems/failures/airfoils-roll-condition", 0.0);
setprop("/fdm/jsbsim/systems/failures/airfoils-yaw-condition", 0.0);

# destroy RCS

setprop("/fdm/jsbsim/systems/fcs/rcs-roll-mode", 0);
setprop("/fdm/jsbsim/systems/fcs/pitch-roll-mode", 0);
setprop("/fdm/jsbsim/systems/fcs/yaw-roll-mode", 0);

setprop("/fdm/jsbsim/systems/failures/rcs-pod1-left-condition", 0.0);
setprop("/fdm/jsbsim/systems/failures/rcs-pod2-right-condition", 0.0);

setprop("/fdm/jsbsim/systems/failures/rcs-pod1-up-condition", 0.0);
setprop("/fdm/jsbsim/systems/failures/rcs-pod2-up-condition", 0.0);

setprop("/fdm/jsbsim/systems/failures/rcs-pod1-down-condition", 0.0);
setprop("/fdm/jsbsim/systems/failures/rcs-pod2-down-condition", 0.0);

setprop("/fdm/jsbsim/systems/failures/aero-structure-condition", 0.05);


}


#### drag chute pin breaks during deceleration

var fail_chute_pin = func {

setprop("/fdm/jsbsim/systems/failures/drag-chute-condition", 0.0);

}


#### tire and gear failure

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

##########################################
#### user-selected failure scenarios #####
##########################################

# ID 1-10 refer to ascent
# ID 11-20 refer to in-orbit failures
# ID 21-30 refer to entry failures
# ID 31-40 refer to aerodynamical phase failure scenarios




var failure_time_ssme = [10000.0, 10000.0, 10000.0];


var apply_failure_scenario = func{

var scenario_ID = getprop("/fdm/jsbsim/systems/failures/failure-scenario-ID");

if (scenario_ID == 0)
	{
	failure_time_ssme = [10000.0, 10000.0, 10000.0];
	failure_cmd.speedbrake = 1;
	}
else if (scenario_ID == 1)
	{
	init_one_engine_failure();
	}
else if (scenario_ID == 2)
	{
	init_one_engine_failure();
	}
else if (scenario_ID == 31)
	{
	failure_cmd.speedbrake = 0.3;
	var rn = rand();
	if (rn > 0.5) 
		{
		setprop("/controls/shuttle/speedbrake", 0.8);
		setprop("/controls/shuttle/speedbrake-string","80%");
		}
	

	}
else if (scenario_ID == 32)
	{
	setprop("/fdm/jsbsim/systems/failures/tire-right-condition", 0.0);
	}
else if (scenario_ID == 33)
	{
	setprop("/fdm/jsbsim/systems/failures/apu1-condition", 0.0);
	setprop("/fdm/jsbsim/systems/failures/hyd2-pump-condition", 0.0);
	}

}

var init_one_engine_failure = func{

failure_time_ssme = [10000.0, 10000.0, 10000.0];

var engine_number = int(rand() * 2.99);

failure_time_ssme[engine_number] = rand() * 500.0;

for (var i =0; i<3; i=i+1)
	{
	print(failure_time_ssme[i]);
	}

}







