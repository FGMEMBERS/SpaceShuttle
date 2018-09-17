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

setprop("/fdm/jsbsim/systems/failures/mps/ssme1-condition", 0.0);
setprop("/fdm/jsbsim/systems/failures/mps/ssme2-condition", 0.0);
setprop("/fdm/jsbsim/systems/failures/mps/ssme3-condition", 0.0);

# disconnect the SRBs

SpaceShuttle.SRB_separate_force();

# remove the tank

SpaceShuttle.external_tank_separate_silent();

# animate the explosion

et_explosion_effect();

# destroy aerodynamics

setprop("/fdm/jsbsim/systems/failures/airfoils-pitch-condition", 0.0);
setprop("/fdm/jsbsim/systems/failures/airfoils-roll-condition", 0.0);
setprop("/fdm/jsbsim/systems/failures/airfoils-yaw-condition", 0.0);

setprop("/fdm/jsbsim/systems/failures/aero-structure-condition", 0.05);


# disconnect power

setprop("/fdm/jsbsim/systems/failures/electrical/fc1-condition", 0.0);
setprop("/fdm/jsbsim/systems/failures/electrical/fc2-condition", 0.0);
setprop("/fdm/jsbsim/systems/failures/electrical/fc3-condition", 0.0);

# destroy shuttle, cockpit only

setprop("/fdm/jsbsim/systems/failures/shuttle-destroyed", 1);

}


var et_explosion_effect = func {

setprop("/sim/model/effects/explosion-flame",1);
settimer(func{setprop("/sim/model/effects/explosion-flame",0);}, 0.2);
setprop("/sim/model/effects/explosion-smoke",1);
settimer(func{setprop("/sim/model/effects/explosion-smoke",0);}, 2.0);
}

#### breakup of the orbiter on atmospheric entry

var orbiter_tps_fail = func {

setprop("/sim/model/effects/entry-debris", 1);
setprop("/fdm/jsbsim/systems/various/debris-separation-target", 1);
setprop("/fdm/jsbsim/systems/failures/shuttle-destroyed", 1);

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

# disconnect power

setprop("/fdm/jsbsim/systems/failures/electrical/fc1-condition", 0.0);
setprop("/fdm/jsbsim/systems/failures/electrical/fc2-condition", 0.0);
setprop("/fdm/jsbsim/systems/failures/electrical/fc3-condition", 0.0);

}



#### airframe breakage for overstressed wing

var orbiter_wing_fail = func {


# destroy aerodynamics

setprop("/fdm/jsbsim/systems/failures/airfoils-pitch-condition", 0.0);
setprop("/fdm/jsbsim/systems/failures/airfoils-roll-condition", 0.0);

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

setprop("/fdm/jsbsim/systems/failures/aero-structure-condition", 0.2);

setprop("/fdm/jsbsim/systems/failures/shuttle-damaged", 1);

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
		setprop("/fdm/jsbsim/systems/failures/gear/gearstrut-nose-condition", 0.0);
		setprop("/fdm/jsbsim/systems/failures/gear/tire-nose-left-condition", 0.0);
		setprop("/fdm/jsbsim/systems/failures/gear/tire-nose-right-condition", 0.0);
		}
	if (rand() < tire_blow_probability)
		{
		setprop("/fdm/jsbsim/systems/failures/gear/tire-nose-left-condition", 0.0);
		setprop("/fdm/jsbsim/systems/failures/gear/tire-nose-right-condition", 0.0);
		}
	}

if (getprop("/gear/gear[1]/wow") == 1)
	{
	if (rand() < strut_breakage_probability)
		{
		setprop("/fdm/jsbsim/systems/failures/gear/gearstrut-left-condition", 0.0);
		setprop("/fdm/jsbsim/systems/failures/gear/tire-left-ob-condition", 0.0);
		setprop("/fdm/jsbsim/systems/failures/gear/tire-left-ib-condition", 0.0);
		}
	if (rand() < tire_blow_probability)
		{
		setprop("/fdm/jsbsim/systems/failures/gear/tire-left-ib-condition", 0.0);
		setprop("/fdm/jsbsim/systems/failures/gear/tire-left-ob-condition", 0.0);
		}
	}

if (getprop("/gear/gear[2]/wow") == 1)
	{
	if (rand() < strut_breakage_probability)
		{
		setprop("/fdm/jsbsim/systems/failures/gear/gearstrut-right-condition", 0.0);
		setprop("/fdm/jsbsim/systems/failures/gear/tire-right-ib-condition", 0.0);
		setprop("/fdm/jsbsim/systems/failures/gear/tire-right-ob-condition", 0.0);
		}
	if (rand() < tire_blow_probability)
		{
		setprop("/fdm/jsbsim/systems/failures/gear/tire-right-ib-condition", 0.0);
		setprop("/fdm/jsbsim/systems/failures/gear/tire-right-ob-condition", 0.0);
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

#print("Applying failure scenario");

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
else if (scenario_ID == 3)
	{
	init_pass_failure();
	}
else if (scenario_ID == 20)
	{
	init_alignment_error();
	}
else if (scenario_ID == 21)
	{
	init_rcs_failure();
	}
else if (scenario_ID == 22)
	{
	init_electrical_failure();
	}
else if (scenario_ID == 23)
	{
	init_propellant_leak();
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
	var rn = rand();
	if (rn < 0.166)
		{setprop("/fdm/jsbsim/systems/failures/gear/tire-nose-left-condition", 0.0);}
	else if (rn < 0.33)
		{setprop("/fdm/jsbsim/systems/failures/gear/tire-nose-right-condition", 0.0);}
	else if (rn < 0.5)
		{setprop("/fdm/jsbsim/systems/failures/gear/tire-right-ib-condition", 0.0);}
	else if (rn < 0.66)
		{setprop("/fdm/jsbsim/systems/failures/gear/tire-right-ob-condition", 0.0);}
	else if (rn < 0.83)
		{setprop("/fdm/jsbsim/systems/failures/gear/tire-left-ib-condition", 0.0);}
	else 
		{setprop("/fdm/jsbsim/systems/failures/gear/tire-left-ob-condition", 0.0);}

	}
else if (scenario_ID == 33)
	{
	setprop("/fdm/jsbsim/systems/failures/apu1-condition", 0.0);
	setprop("/fdm/jsbsim/systems/failures/hyd2-pump-condition", 0.0);
	}
else if (scenario_ID == 34)
	{
	init_position_error(2500.0);
	}
else if (scenario_ID == 35)
	{
	init_position_error(5000.0);
	
	setprop("/fdm/jsbsim/systems/failures/navigation/gps-condition", 0);

	var rn = rand();

	if (rn < 0.2)
		{
		setprop("/fdm/jsbsim/systems/failures/navigation/tacan-1-condition", 1.0 + 5.0 * rand());
		setprop("/fdm/jsbsim/systems/failures/navigation/tacan-3-condition", 0.0);
		setprop("/fdm/jsbsim/systems/failures/navigation/adta-3-condition", 0.8);
		setprop("/fdm/jsbsim/systems/failures/navigation/imu-2-condition", 0.3);
		}
	else if (rn < 0.4)
		{
		setprop("/fdm/jsbsim/systems/failures/navigation/tacan-1-condition", 0.0);
		setprop("/fdm/jsbsim/systems/failures/navigation/tacan-2-condition", 0.0);
		setprop("/fdm/jsbsim/systems/failures/navigation/tacan-1-condition", 4.0 + rand() * 4.0);
		}
	else if (rn < 0.6)
		{
		setprop("/fdm/jsbsim/systems/failures/navigation/adta-1-condition", 0.8);
		setprop("/fdm/jsbsim/systems/failures/navigation/adta-3-condition", 0.9);
		setprop("/fdm/jsbsim/systems/failures/navigation/adta-4-condition", 0.7 + rand() * 0.3);
		}
	else if (rn < 0.8)
		{
		setprop("/fdm/jsbsim/systems/failures/navigation/tacan-1-condition", 0.0);
		setprop("/fdm/jsbsim/systems/failures/navigation/tacan-2-condition", 0.0);
		setprop("/fdm/jsbsim/systems/failures/navigation/tacan-3-condition", 0.0);
		setprop("/fdm/jsbsim/systems/failures/navigation/adta-1-condition", 0.0);
		setprop("/fdm/jsbsim/systems/failures/navigation/adta-3-condition", 0.0);
		setprop("/fdm/jsbsim/systems/failures/navigation/imu-2-condition", 0.0);
		setprop("/fdm/jsbsim/systems/failures/navigation/imu-1-condition", 0.1);
		}
	else 
		{
		setprop("/fdm/jsbsim/systems/failures/navigation/tacan-1-condition", 4.0 + rand() * 4.0);
		setprop("/fdm/jsbsim/systems/failures/navigation/tacan-2-condition", 2.0 + rand() * 6.0);
		setprop("/fdm/jsbsim/systems/failures/navigation/tacan-3-condition", 1.0 + rand() * 8.0);
		setprop("/fdm/jsbsim/systems/failures/navigation/imu-3-condition", 0.5);

		if (rand() > 0.5)	
			{
			setprop("/fdm/jsbsim/systems/failures/navigation/air-data-probe-left-condition", 0.8);
			}
		else
			{
			setprop("/fdm/jsbsim/systems/failures/navigation/air-data-pressure-right-condition", 0.8);
			}		
		}
	}

setprop("/sim/gui/dialogs/SpaceShuttle/limits/failure-scenario", "none");
SpaceShuttle.update_scenario();



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



var init_alignment_error = func {


#setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/pitch-deg", 10.0 * (rand() - 0.5));
#setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/yaw-deg", 10.0 * (rand() - 0.5));
#setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/roll-deg", 10.0 * (rand() - 0.5));

var rn = rand();

if (rn < 0.3)
	{
	for (var i = 0; i< SpaceShuttle.imu_system.num_units; i=i+1)
		{
		SpaceShuttle.imu_system.imu[i].pitch_error = 4.0 * (rand() - 0.5);
		SpaceShuttle.imu_system.imu[i].yaw_error = 4.0 * (rand() - 0.5);
		SpaceShuttle.imu_system.imu[i].roll_error = 4.0 * (rand() - 0.5);
		}
	}
else if (rn < 0.6)
	{
		var i = 0;
		if (rand() < 0.3) {i=1;}
		else {i=2;}

		SpaceShuttle.imu_system.imu[i].pitch_error = 4.0 * (rand() - 0.5);
		SpaceShuttle.imu_system.imu[i].yaw_error = 4.0 * (rand() - 0.5);
		SpaceShuttle.imu_system.imu[i].roll_error = 4.0 * (rand() - 0.5);
	}
else
	{
	for (var i = 0; i< SpaceShuttle.imu_system.num_units; i=i+1)
		{
		SpaceShuttle.imu_system.imu[i].pitch_error = 0.8 * (rand() - 0.5);
		SpaceShuttle.imu_system.imu[i].yaw_error = 0.8 * (rand() - 0.5);
		SpaceShuttle.imu_system.imu[i].roll_error = 0.8 * (rand() - 0.5);
		}
	}


}

var init_position_error = func (scale) {

setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/x-m", scale * (rand() - 0.5));
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/y-m", scale * (rand() - 0.5));
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/z-m", scale * (rand() - 0.5));



}

var init_rcs_failure = func {

#print ("Failing jet");

var rn_loc = rand();
var rn_type = rand();
var rn_thruster = rand();

var fail_arg = 0;
if (rn_type > 0.5) {fail_arg = 2;} 

if (rn_loc > 0.66)
	{
	if (rn_thruster > 0.8)
		{setprop("/fdm/jsbsim/systems/failures/rcs/rcs-F3L-condition", fail_arg);}	
	else if (rn_thruster > 0.6)
		{setprop("/fdm/jsbsim/systems/failures/rcs/rcs-F4D-condition", fail_arg);}
	else if (rn_thruster > 0.4)
		{setprop("/fdm/jsbsim/systems/failures/rcs/rcs-F1U-condition", fail_arg);}
	else if (rn_thruster > 0.2)
		{setprop("/fdm/jsbsim/systems/failures/rcs/rcs-F2R-condition", fail_arg);}	
	else 	
		{setprop("/fdm/jsbsim/systems/failures/rcs/rcs-F2F-condition", fail_arg);}	
	}
else if (rn_loc > 0.36)
	{
	if (rn_thruster > 0.8)
		{setprop("/fdm/jsbsim/systems/failures/rcs/rcs-L1A-condition", fail_arg);}	
	else if (rn_thruster > 0.6)
		{setprop("/fdm/jsbsim/systems/failures/rcs/rcs-L4L-condition", fail_arg);}
	else if (rn_thruster > 0.4)
		{setprop("/fdm/jsbsim/systems/failures/rcs/rcs-L2U-condition", fail_arg);}
	else if (rn_thruster > 0.2)
		{setprop("/fdm/jsbsim/systems/failures/rcs/rcs-L3D-condition", fail_arg);}	
	else 	
		{setprop("/fdm/jsbsim/systems/failures/rcs/rcs-L1L-condition", fail_arg);}	
	}
else 
	{
	if (rn_thruster > 0.8)
		{setprop("/fdm/jsbsim/systems/failures/rcs/rcs-R4R-condition", fail_arg);}	
	else if (rn_thruster > 0.6)
		{setprop("/fdm/jsbsim/systems/failures/rcs/rcs-R2D-condition", fail_arg);}
	else if (rn_thruster > 0.4)
		{setprop("/fdm/jsbsim/systems/failures/rcs/rcs-R1R-condition", fail_arg);}
	else if (rn_thruster > 0.2)
		{setprop("/fdm/jsbsim/systems/failures/rcs/rcs-R3A-condition", fail_arg);}	
	else 	
		{setprop("/fdm/jsbsim/systems/failures/rcs/rcs-R1U-condition", fail_arg);}	
	}


}

var init_electrical_failure = func {

var rn_loc = rand();
var rn_unit = rand();
var rn_severity = rand();

if (rn_severity < 0.5) {rn_severity = 0.0;} else {rn_severity = 2.0 * (rn_severity - 0.5);}

var unit = 0;
if (rn_unit > 0.66) {unit = 2;}
else if (rn_unit > 0.33) {unit = 1;}

if (rn_loc > 0.66) # fuel cell
	{
	if (unit == 0)
		{setprop("/fdm/jsbsim/systems/failures/electrical/fc1-condition", rn_severity);}
	else if (unit == 1)
		{setprop("/fdm/jsbsim/systems/failures/electrical/fc2-condition", rn_severity);}
	else
		{setprop("/fdm/jsbsim/systems/failures/electrical/fc3-condition", rn_severity);}
	}
else if (rn_loc > 0.33) # main bus
	{
	if (unit == 0)
		{setprop("/fdm/jsbsim/systems/failures/electrical/main-A-condition", rn_severity);}
	else if (unit == 1)
		{setprop("/fdm/jsbsim/systems/failures/electrical/main-B-condition", rn_severity);}
	else
		{setprop("/fdm/jsbsim/systems/failures/electrical/main-C-condition", rn_severity);}
	}
else # AC bus
	{
	if (unit == 0)
		{setprop("/fdm/jsbsim/systems/failures/electrical/ac1-condition", rn_severity);}
	else if (unit == 1)
		{setprop("/fdm/jsbsim/systems/failures/electrical/ac2-condition", rn_severity);}
	else
		{setprop("/fdm/jsbsim/systems/failures/electrical/ac3-condition", rn_severity);}
	}

}


var init_propellant_leak = func {

var rn_loc = rand();
var rn_point = rand();
var rn_flow = rand() * -1.0;

if (rn_loc > 0.8) # fwd RCS
	{
	if (rn_point > 0.8)
		{
		SpaceShuttle.leakage_manager.add_leak("RCS-fwd-fuel-manifold-12", rn_flow);
		}	
	else if (rn_point > 0.6)
		{
		SpaceShuttle.leakage_manager.add_leak("RCS-fwd-fuel-manifold-4", rn_flow);
		}	
	else if (rn_point > 0.4)
		{
		SpaceShuttle.leakage_manager.add_leak("RCS-fwd-fuel-tank", rn_flow);
		}
	else if (rn_point > 0.2)
		{
		SpaceShuttle.leakage_manager.add_leak("RCS-fwd-oxidizer-manifold-345", rn_flow);
		}
	else
		{
		SpaceShuttle.leakage_manager.add_leak("RCS-fwd-oxidizer-manifold-1", rn_flow);
		}

	}
else if (rn_loc > 0.4)
	{
	if (rn_point > 0.8)
		{
		SpaceShuttle.leakage_manager.add_leak("OMS-left-fuel-manifold", rn_flow);
		}	
	else if (rn_point > 0.6)
		{
		SpaceShuttle.leakage_manager.add_leak("OMS-left-oxidizer-manifold", rn_flow);
		}	
	else if (rn_point > 0.4)
		{
		SpaceShuttle.leakage_manager.add_leak("RCS-left-fuel-manifold-12", rn_flow);
		}
	else if (rn_point > 0.2)
		{
		SpaceShuttle.leakage_manager.add_leak("RCS-left-oxidizer-manifold-345", rn_flow);
		}
	else
		{
		SpaceShuttle.leakage_manager.add_leak("RCS-left-oxidizer-manifold-4", rn_flow);
		}
	}
else
	{
	if (rn_point > 0.8)
		{
		SpaceShuttle.leakage_manager.add_leak("OMS-right-fuel-manifold", rn_flow);
		}	
	else if (rn_point > 0.6)
		{
		SpaceShuttle.leakage_manager.add_leak("OMS-right-oxidizer-tank", rn_flow);
		}	
	else if (rn_point > 0.4)
		{
		SpaceShuttle.leakage_manager.add_leak("RCS-right-fuel-manifold-345", rn_flow);
		}
	else if (rn_point > 0.2)
		{
		SpaceShuttle.leakage_manager.add_leak("RCS-right-oxidizer-manifold-1", rn_flow);
		}
	else
		{
		SpaceShuttle.leakage_manager.add_leak("RCS-right-oxidizer-manifold-5", rn_flow);
		}
	}


}


var init_pass_failure = func {

var rn = rand();

var scale = 0.0;

if (rn < 0.3) {scale = 5.0;}
else if (rn < 0.7) {scale = 15.0;}
else {scale = 60.0;}


setprop("/fdm/jsbsim/systems/dps/pass/error-pitch", (2.0 * rand() - 0.5) * scale);
setprop("/fdm/jsbsim/systems/dps/pass/error-yaw", (2.0 * rand() - 0.5) * scale);
setprop("/fdm/jsbsim/systems/dps/pass/error-roll", (2.0 * rand() - 0.5) * scale);

}

