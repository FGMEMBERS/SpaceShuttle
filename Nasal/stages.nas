
# stage management for the Space Shuttle
# Thorsten Renk 2015



var launch_loop_flag = 0;
var slowdown_loop_flag = 0;
var SRB_message_flag = 0;
var MECO_message_flag = 0;
var launch_message_flag = 0;
var WONG_message_flag =0;
var lockup_message_flag = 0;
var SRB_burn_timer = 0.0;
var deorbit_stage_flag = 0;



aircraft.HUD.cycle_color();

settimer(func {setprop("/fdm/jsbsim/systems/electrical/init-electrical-on", 0.0);}, 30.0);

var ignition = func{
    launch_loop_flag = 0;
    setprop("/controls/engines/engine[0]/throttle", 1.0);
    setprop("/controls/engines/engine[1]/throttle", 1.0);
    setprop("/controls/engines/engine[2]/throttle", 1.0);
    setprop("/engines/engine[0]/thrust_lb", 400000.0);
    setprop("/engines/engine[1]/thrust_lb", 400000.0);
    setprop("/engines/engine[2]/thrust_lb", 400000.0);
    launch_loop_start();
}

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

# init the SRB burn timer - will be overwritten later
SRB_burn_timer = getprop("/sim/time/elapsed-sec");

# fill the feed lines
setprop("/consumables/fuel/tank[17]/level-lbs", 600.0);
setprop("/consumables/fuel/tank[18]/level-lbs",4800.0);

settimer(SRB_ignite, 3.0);
settimer(gear_up, 5.0);
	
launch_loop_flag = 1;


# zero MET at engine ignition

var elapsed = getprop("/sim/time/elapsed-sec");
setprop("/fdm/jsbsim/systems/timer/delta-MET", -elapsed);

launch_loop();

}



var launch_loop = func{

if (launch_loop_flag == 0) {return;}

if (launch_message_flag == 5) {return;}

var SRB_fuel = getprop("/consumables/fuel/tank[1]/level-norm");
var external_tank_fuel = getprop("/consumables/fuel/tank[0]/level-norm");

var t_elapsed = getprop("/sim/time/elapsed-sec") - SRB_burn_timer + 6.0;

var periapsis = getprop("/fdm/jsbsim/systems/orbital/periapsis-km");

var thrust_engine1 = getprop("/engines/engine[0]/thrust_lb");
var thrust_engine2 = getprop("/engines/engine[1]/thrust_lb");
var thrust_engine3 = getprop("/engines/engine[2]/thrust_lb");

var SRB_separation_button_pressed = getprop("/controls/shuttle/srb-separation");

if (SRB_separation_button_pressed and SRB_message_flag < 2)
    {
    SRB_separate();
    SRB_message_flag = 2;
    setprop("/fdm/jsbsim/systems/ap/css-pitch-control", 1);
    setprop("/fdm/jsbsim/systems/ap/automatic-pitch-control", 0);    
    setprop("/fdm/jsbsim/systems/ap/css-roll-control", 1);
    setprop("/fdm/jsbsim/systems/ap/automatic-roll-control", 0);
    }

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



for (var i = 0; i < 3; i=i+1)
	{
	if (t_elapsed > SpaceShuttle.failure_time_ssme[i])
		{
		var scenario_ID = getprop("/fdm/jsbsim/systems/failures/failure-scenario-ID");
		if (scenario_ID == 1)
			{		
			SpaceShuttle.failure_time_ssme[i] = 10000.0;
			setprop("/fdm/jsbsim/systems/failures/ssme"~(i+1)~"-condition", 0.0);
			setprop("/sim/messages/copilot", "Engine "~(i+1)~" flameout!");
			}
		else if (scenario_ID == 2)
			{
			SpaceShuttle.failure_time_ssme[i] = 10000.0;
			var rn = rand();
			if (rn < 0.2)
				{
				setprop("/fdm/jsbsim/systems/failures/hyd"~(i+1)~"-pump-condition", 0.0);
				}
			else if (rn < 0.5)
				{
				setprop("/fdm/jsbsim/systems/failures/apu"~(i+1)~"-condition", 0.0);
				}
			else if (rn < 0.7)
				{
				setprop("/fdm/jsbsim/systems/apu/apu["~i~"]/apu-rpm-rnd", 0.7);
				}
			else
				{
				setprop("/fdm/jsbsim/systems/mps/engine["~i~"]/electric-lockup", 1);
				}

			}
		}
	}

if ((external_tank_fuel < 0.05) and (MECO_message_flag == 0))
	{MECO_warn(); MECO_message_flag = 1;}


if ((external_tank_fuel == 0.0) and (MECO_message_flag == 1))
	{external_tank_separate(); MECO_message_flag = 2; return;}


if ((periapsis > -200.0) and (launch_message_flag ==2))
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

var lockup_eng1 = getprop("/fdm/jsbsim/systems/mps/engine/lockup");
var lockup_eng2 = getprop("/fdm/jsbsim/systems/mps/engine[1]/lockup");
var lockup_eng3 = getprop("/fdm/jsbsim/systems/mps/engine[2]/lockup");

if ((lockup_eng1 == 1) and (SpaceShuttle.failure_cmd.ssme1 == 1))
	{ssme_lockup(0);}
if ((lockup_eng2 == 1) and (SpaceShuttle.failure_cmd.ssme2 == 1))
	{ssme_lockup(1);}
if ((lockup_eng3 == 1) and (SpaceShuttle.failure_cmd.ssme3 == 1))
	{ssme_lockup(2);}


# make sure we display OMS symbology in case of a fuel dump

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

# in case of an RTLS, we want to update entry guidance

if (getprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode") ==3)
	{SpaceShuttle.update_entry_guidance();}

SpaceShuttle.check_limits_ascent();


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
	
settimer(SpaceShuttle.update_ascent_predictors, 0.4);


settimer(SpaceShuttle.adjust_effect_colors, 0.2);




# some log output
#print(t_elapsed, " ", getprop("/position/altitude-ft"), " ", getprop("/fdm/jsbsim/velocities/ned-velocity-mag-fps"));
#print(t_elapsed, " ", getprop("/fdm/jsbsim/systems/entry_guidance/vrel-fps"), " ", getprop("/position/altitude-ft"));

settimer(launch_loop, 1.0);
}


var SRB_ignite = func {

# check whether all three main engines are on full thrust

var thrust1 = getprop("/engines/engine[0]/thrust_lb");
var thrust2 = getprop("/engines/engine[1]/thrust_lb");
var thrust3 = getprop("/engines/engine[2]/thrust_lb");

if ((thrust1 > 400000.0) and (thrust2 > 400000.0) and (thrust3 > 400000.0)) # we're go
	{
	setprop("/sim/messages/copilot", "SRB ignition!");
	setprop("/controls/engines/engine[3]/throttle", 1.0);
	setprop("/controls/engines/engine[4]/throttle", 1.0);
	setprop("/sim/model/effects/launch-smoke",1);

	setprop("/controls/engines/engine[3]/ignited-hud","x");
	setprop("/controls/engines/engine[4]/ignited-hud","x");

	settimer(launch_smoke_off,1.5);

	SRB_burn_timer = getprop("/sim/time/elapsed-sec");

	# make an automatic transtion to MM 102
	setprop("/fdm/jsbsim/systems/dps/major-mode", 102);	

	# if we have liftoff, switch autolaunch on if configured
	
	if (getprop("/fdm/jsbsim/systems/ap/launch/autolaunch-master") == 1)
		{
		SpaceShuttle.auto_launch_loop();
		}

	}
else
	{
	setprop("/sim/messages/copilot", "Launchpad abort!");
	setprop("/controls/engines/engine[0]/throttle", 0.0);
	setprop("/controls/engines/engine[1]/throttle", 0.0);
	setprop("/controls/engines/engine[2]/throttle", 0.0);
	setprop("/controls/engines/engine[0]/ignited-hud"," ");
	setprop("/controls/engines/engine[1]/ignited-hud"," ");
	setprop("/controls/engines/engine[2]/ignited-hud"," ");
	launch_loop_flag = 0;
	}

}


var gear_up = func {

var stage = getprop("/sim/presets/stage");

if ((launch_loop_flag == 0) and (stage ==0)) {return;}

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

####################################################################################
# Silent version of SRB separation
# this is used for start in later mission stages - doesn't use the simulation of the
# SRB separation dynamics, just removes the weight and fuel
####################################################################################


var SRB_separate_silent = func {

setprop("/controls/shuttle/SRB-static-model", 0);
setprop("/controls/shuttle/SRB-sound-veto", 1);


setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[3]", 0.0);
setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[4]", 0.0);

setprop("/consumables/fuel/tank[1]/level-norm",0.0);
setprop("/consumables/fuel/tank[2]/level-norm",0.0);

setprop("/controls/engines/engine[3]/status-hud", "X");
setprop("/controls/engines/engine[4]/status-hud", "X");

setprop("/controls/engines/engine[3]/ignited-hud", " ");
setprop("/controls/engines/engine[4]/ignited-hud", " ");
}

# this function is used to simulate the actual SRB separation dynamics driven by the separation motors
# which are implemented as external force acting on previously slaved and then released submodels


####################################################################################
# Explicit model for SRB separation using ballistic submodel dynamics
####################################################################################

var SRB_separate = func {

setprop("/controls/shuttle/SRB-static-model", 0);
#setprop("/controls/shuttle/SRB-sound-veto", 1);
settimer(func{setprop("/controls/shuttle/SRB-sound-veto", 1);}, 5.0);


setprop("/ai/models/ballistic[0]/controls/slave-to-ac",0);
setprop("/ai/models/ballistic[1]/controls/slave-to-ac",0);

var hdg_deg = getprop("/ai/models/ballistic[0]/orientation/hdg-deg");
var pitch_rad = getprop("/ai/models/ballistic[0]/orientation/pitch-deg") * math.pi/180.0;
var roll_rad = getprop("/ai/models/ballistic[0]/orientation/roll-deg") * math.pi/180.0;

# now we have pitch, yaw and roll and need to convert it to heading and elevation

# force in +-y direction

#var alpha_rad = math.asin(math.sin(roll_rad) * math.cos(pitch_rad));
#var beta_rad = math.asin(math.cos(roll_rad)/math.cos(alpha_rad));
#alpha_deg = alpha_rad * 180.0/math.pi;
#beta_deg = beta_rad * 180.0/math.pi;
#var beta1_deg = beta_deg + hdg_deg;
#var beta2_deg = beta1_deg + 180.0;

#############################
# force in (+-y,z) direction

var alpha1_rad = math.asin(0.707 * math.cos(pitch_rad) * (math.sin(roll_rad) - math.cos(roll_rad)));
var alpha2_rad = math.asin(0.707 * math.cos(pitch_rad) * (math.sin(roll_rad) - math.cos(roll_rad)));

var beta1_rad = math.asin(0.707 * (math.sin(roll_rad) + math.cos(roll_rad)) / math.cos(alpha1_rad));
var beta2_rad = math.asin(0.707 * (math.sin(roll_rad) - math.cos(roll_rad)) / math.cos(alpha2_rad));

var alpha1_deg =alpha1_rad * 180.0/math.pi;
var alpha2_deg =alpha2_rad * 180.0/math.pi;

alpha1_deg = -alpha1_deg;
alpha2_deg = -alpha2_deg;

var beta1_deg = beta1_rad * 180.0/math.pi + hdg_deg + 180.0;
var beta2_deg = beta2_rad * 180.0/math.pi + hdg_deg + 180.0;

#######################
# force in z-direction

#var alpha_rad = math.asin(-math.cos(roll_rad) * math.cos(pitch_rad));
#var beta_rad = math.asin(math.sin(roll_rad)/math.cos(alpha_rad));

#var alpha_deg = alpha_rad * 180.0/math.pi;
#var beta_deg = beta_rad * 180.0/math.pi + hdg_deg;
#alpha_deg = - alpha_deg;
#beta_deg = beta_deg + 180.0;

var force_mag_var = 0.8 + 0.4 * rand();
var alpha_var = -10.0 + 20.0 * rand();
var beta_var =  -10.0 + 20.0 * rand();

setprop("/controls/shuttle/forces/srb1/force-lb", 448000.0 * force_mag_var);
setprop("/controls/shuttle/forces/srb1/force-azimuth-deg", beta1_deg + beta_var);
setprop("/controls/shuttle/forces/srb1/force-elevation-deg", alpha1_deg + alpha_var);

force_mag_var = 0.8 + 0.4 * rand();
alpha_var =  -10.0 + 20.0 * rand();
beta_var =  -10.0 + 20.0 * rand();

setprop("/controls/shuttle/forces/srb2/force-lb", 448000.0 * force_mag_var);
setprop("/controls/shuttle/forces/srb2/force-azimuth-deg",  beta2_deg + beta_var);
setprop("/controls/shuttle/forces/srb2/force-elevation-deg", alpha2_deg + alpha_var);

setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[3]", 0.0);
setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[4]", 0.0);



setprop("/controls/engines/engine[3]/status-hud", "X");
setprop("/controls/engines/engine[4]/status-hud", "X");

setprop("/controls/engines/engine[3]/ignited-hud", " ");
setprop("/controls/engines/engine[4]/ignited-hud", " ");



setprop("/sim/messages/copilot", "SRB separation!");
setprop("/sim/messages/copilot", "Burn time was "~(int(getprop("/sim/time/elapsed-sec") - SRB_burn_timer))~" seconds.");

# make an automatic transtion to MM 103
setprop("/fdm/jsbsim/systems/dps/major-mode", 103);

settimer(SRB_separation_motor_off, 1.2);

}


####################################################################################
# Explicit model for SRB separation using ballistic submodel dynamics during explosion
####################################################################################

var SRB_separate_force = func {

setprop("/controls/shuttle/SRB-static-model", 0);
setprop("/controls/shuttle/SRB-sound-veto", 1);


setprop("/ai/models/ballistic[0]/controls/slave-to-ac",0);
setprop("/ai/models/ballistic[1]/controls/slave-to-ac",0);

var hdg_deg = getprop("/ai/models/ballistic[0]/orientation/hdg-deg");
var pitch_rad = getprop("/ai/models/ballistic[0]/orientation/pitch-deg") * math.pi/180.0;
var roll_rad = getprop("/ai/models/ballistic[0]/orientation/roll-deg") * math.pi/180.0;



#############################
# force in (+-y,z) direction

var alpha1_rad = math.asin(0.707 * math.cos(pitch_rad) * (math.sin(roll_rad) - math.cos(roll_rad)));
var alpha2_rad = math.asin(0.707 * math.cos(pitch_rad) * (math.sin(roll_rad) - math.cos(roll_rad)));

var beta1_rad = math.asin(0.707 * (math.sin(roll_rad) + math.cos(roll_rad)) / math.cos(alpha1_rad));
var beta2_rad = math.asin(0.707 * (math.sin(roll_rad) - math.cos(roll_rad)) / math.cos(alpha2_rad));

var alpha1_deg =alpha1_rad * 180.0/math.pi;
var alpha2_deg =alpha2_rad * 180.0/math.pi;

alpha1_deg = -alpha1_deg;
alpha2_deg = -alpha2_deg;

var beta1_deg = beta1_rad * 180.0/math.pi + hdg_deg + 180.0;
var beta2_deg = beta2_rad * 180.0/math.pi + hdg_deg + 180.0;

#######################
# force in z-direction

#var alpha_rad = math.asin(-math.cos(roll_rad) * math.cos(pitch_rad));
#var beta_rad = math.asin(math.sin(roll_rad)/math.cos(alpha_rad));

#var alpha_deg = alpha_rad * 180.0/math.pi;
#var beta_deg = beta_rad * 180.0/math.pi + hdg_deg;
#alpha_deg = - alpha_deg;
#beta_deg = beta_deg + 180.0;

var force_mag_var = 5.0 + 5.0 * rand();
var alpha_var = -50.0 + 100.0 * rand();
var beta_var =  -50.0 + 100.0 * rand();

setprop("/controls/shuttle/forces/srb1/force-lb", 448000.0 * force_mag_var);
setprop("/controls/shuttle/forces/srb1/force-azimuth-deg", beta1_deg + beta_var);
setprop("/controls/shuttle/forces/srb1/force-elevation-deg", alpha1_deg + alpha_var);

force_mag_var = 5.0 + 5.0 * rand();
alpha_var =  -50.0 + 100.0 * rand();
beta_var =  -50.0 + 100.0 * rand();

setprop("/controls/shuttle/forces/srb2/force-lb", 448000.0 * force_mag_var);
setprop("/controls/shuttle/forces/srb2/force-azimuth-deg",  beta2_deg + beta_var);
setprop("/controls/shuttle/forces/srb2/force-elevation-deg", alpha2_deg + alpha_var);

setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[3]", 0.0);
setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[4]", 0.0);



setprop("/controls/engines/engine[3]/status-hud", "X");
setprop("/controls/engines/engine[4]/status-hud", "X");

setprop("/controls/engines/engine[3]/ignited-hud", " ");
setprop("/controls/engines/engine[4]/ignited-hud", " ");

settimer(SRB_separation_motor_off, 1.2);

}




var SRB_separation_motor_off = func {

setprop("/controls/shuttle/forces/srb1/force-lb", 1.0);
setprop("/controls/shuttle/forces/srb2/force-lb", 1.0);

settimer(SRB_separation_motor_flame_off, 2.0);
}

var SRB_separation_motor_flame_off = func {

setprop("/controls/shuttle/forces/srb1/force-lb", 0.0);
setprop("/controls/shuttle/forces/srb2/force-lb", 0.0);

}


####################################################################################
# Silent version of external tank separation, just does the job
####################################################################################

var external_tank_separate_silent = func {

setprop("/controls/shuttle/ET-static-model", 0);
setprop("/controls/shuttle/ET-sound-veto", 1);


setprop("/consumables/fuel/tank[0]/level-norm",0.0);

setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[1]", 0.0);
setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[2]", 0.0);

# and set throttles to zero

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

#SpaceShuttle.init_tank();
#settimer(control_to_rcs, 2.0);

# make sure the vertical trajectory display switches to entry
SpaceShuttle.traj_display_flag = 3;

settimer(orbital_loop,2.0);


}

####################################################################################
# Explicit external tank separation using a Nasal controlled submodel
####################################################################################

var external_tank_separate = func {

# we can drop the tank only once
if (getprop("/controls/shuttle/ET-static-model") == 0) {return;}

# make sure the orbiter is not rotating
	
var pitch_rate = getprop("/fdm/jsbsim/velocities/q-rad_sec");
var roll_rate = getprop("/fdm/jsbsim/velocities/p-rad_sec");
var yaw_rate = getprop("/fdm/jsbsim/velocities/r-rad_sec");

# safe rates for ET separation are
# roll rate < 1.25 deg/s
# pitch rate <0.5 deg/s
# yaw rate < 0.5 deg/s

#print("Checking limits!");

if ((math.abs(pitch_rate) > 0.013089) or (math.abs(roll_rate) > 0.02181 ) or (math.abs(yaw_rate) > 0.013089)) 
	{
	setprop("/sim/messages/copilot", "Unsafe attitude for ET separation, reduce rotation rates.");	
	return;
	}

force_external_tank_separate();

}

var force_external_tank_separate = func {

if (SRB_message_flag < 2)
	{	
	setprop("/sim/messages/copilot", "Can't separate tank while SRBs are connected!");
	return;
	}

setprop("/controls/shuttle/et-separation", 1);

# we can drop the tank only once
if (getprop("/controls/shuttle/ET-static-model") == 0) {return;}

setprop("/consumables/fuel/tank[0]/level-norm",0.0);

setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[1]", 0.0);
setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[2]", 0.0);

setprop("/sim/messages/copilot", "External tank separation!");

setprop("/controls/shuttle/ET-static-model", 0);
settimer(func{setprop("/controls/shuttle/ET-sound-veto", 1);}, 5.0);


# release the Nasal-computed ballistic model

SpaceShuttle.init_tank();

setprop("/controls/shuttle/etsep-in-progress", 1);
settimer(func {setprop("/controls/shuttle/etsep-in-progress", 0);}, 5.0);

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

# make sure the vertical trajectory display switches to entry
SpaceShuttle.traj_display_flag = 3;

#settimer(control_to_rcs, 2.0);
settimer(orbital_loop,2.0);
}

var control_to_rcs = func {

var stage = getprop("/sim/presets/stage");

if ((stage == 3) or (stage ==4)){return;}

# transfer controls to RCS

setprop("/fdm/jsbsim/systems/fcs/control-mode",20);
setprop("/sim/messages/copilot", "Control switched to RCS.");
setprop("/controls/shuttle/control-system-string", "RCS ROT DAP-A");
setprop("/fdm/jsbsim/systems/ap/orbital-dap-inertial", 1);
setprop("/fdm/jsbsim/systems/ap/orbital-dap-auto", 0);
setprop("/fdm/jsbsim/systems/ap/orbital-dap-lvlh", 0);
setprop("/fdm/jsbsim/systems/ap/orbital-dap-free", 0);

# transfer thrust control to OMS

setprop("/sim/input/selected/engine[0]",0);
setprop("/sim/input/selected/engine[1]",0);
setprop("/sim/input/selected/engine[2]",0);

setprop("/sim/input/selected/engine[5]",1);
setprop("/sim/input/selected/engine[6]",1);

}


####################################################################################
# Ku-band antenna separation
####################################################################################

var manage_ku_jettison = func {


var state = getprop("/fdm/jsbsim/systems/mechanical/ku-antenna-attached");

if (state == 1) {return;}



SpaceShuttle.init_ku();

}



####################################################################################
# RMS arm separation
####################################################################################

var manage_rms_jettison = func {

var state = getprop("/fdm/jsbsim/systems/rms/rms-arm-attached");

if (state == 1) {return;}

SpaceShuttle.init_rms();

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
	
	if (periapsis < 100.0)
		{
		setprop("/sim/messages/copilot", "Entry Interface reached.");
		setprop("/controls/shuttle/hud-mode",2);
		deorbit_loop();
		return;
		}
	
	}

if (getprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode") >0)
	{SpaceShuttle.update_entry_guidance();}

SpaceShuttle.check_limits_orbit();
SpaceShuttle.cws_inspect();

SpaceShuttle.antenna_manager.run();

SpaceShuttle.update_timers();

settimer(SpaceShuttle.adjust_effect_colors, 0.2);

settimer(SpaceShuttle.update_sv_errors, 0.4);
settimer(SpaceShuttle.update_sensors, 0.5);

#print(getprop("/fdm/jsbsim/position/eci-x-ft") * 0.3048, " ", getprop("/fdm/jsbsim/position/eci-y-ft") * 0.3048);

settimer(orbital_loop, 1.0);
}




var switch_major_control_mode = func {

var current_mode = getprop("/fdm/jsbsim/systems/fcs/control-mode");

if ((current_mode == 0) or (current_mode == 10))
	{
	setprop("/fdm/jsbsim/systems/fcs/control-mode",20);
	setprop("/controls/shuttle/control-system-string", "RCS ROT DAP-A");
	setprop("/fdm/jsbsim/systems/ap/orbital-dap-inertial", 1);
	setprop("/fdm/jsbsim/systems/ap/orbital-dap-auto", 0);
	setprop("/fdm/jsbsim/systems/ap/orbital-dap-lvlh", 0);
	setprop("/fdm/jsbsim/systems/ap/orbital-dap-free", 0);

	}
else if ((current_mode ==1) or (current_mode ==2) or (current_mode == 11) or (current_mode==20) or (current_mode == 21) or (current_mode==22) or (current_mode ==23) or (current_mode == 25) or (current_mode==26) or (current_mode ==27) or (current_mode ==28))
	{
	setprop("/fdm/jsbsim/systems/fcs/control-mode",29);
	setprop("/controls/shuttle/control-system-string", "Aerojet");
	}
else if ((current_mode == 24) or (current_mode == 3))
	{
	setprop("/fdm/jsbsim/systems/fcs/control-mode",4);	
	setprop("/controls/shuttle/control-system-string", "Aerodynamical");
	}
else if ((current_mode == 4) or (current_mode == 29))
	{
	setprop("/fdm/jsbsim/systems/fcs/control-mode",10);
	setprop("/controls/shuttle/control-system-string", "Thrust Vectoring");	
	}
	
}


var switch_control_mode = func {


var orbital_dap_inertial = getprop("/fdm/jsbsim/systems/ap/orbital-dap-inertial");
var orbital_dap_free = getprop("/fdm/jsbsim/systems/ap/orbital-dap-free");
var orbital_dap_lvlh = getprop("/fdm/jsbsim/systems/ap/orbital-dap-lvlh");
var orbital_dap_auto = getprop("/fdm/jsbsim/systems/ap/orbital-dap-auto");

var current_mode = getprop("/fdm/jsbsim/systems/fcs/control-mode");


if ((current_mode == 1)  or (current_mode == 22) or (current_mode == 23))
	{
	setprop("/fdm/jsbsim/systems/fcs/control-mode",2);
	setprop("/controls/shuttle/control-system-string", "RCS translation");
	}
else if ((current_mode == 20) or (current_mode == 21)  or (current_mode ==25) or (current_mode == 30))
	{
	if ((orbital_dap_inertial == 1) or (orbital_dap_lvlh == 1))
		{
		setprop("/fdm/jsbsim/systems/fcs/control-mode",26);
		setprop("/controls/shuttle/control-system-string", "RCS TRANS ATT HLD");
		}	
	}
else if ((current_mode ==2) or (current_mode == 26) or (current_mode == 27) or (current_mode ==28))
	{
	setprop("/fdm/jsbsim/systems/fcs/control-mode",11);
	setprop("/controls/shuttle/control-system-string", "OMS TVC");
	}
else if (current_mode == 11)
	{
	if ((orbital_dap_inertial == 1) or (orbital_dap_lvlh == 1))
		{
		setprop("/fdm/jsbsim/systems/fcs/control-mode",20);
		setprop("/controls/shuttle/control-system-string", "RCS ROT DAP-A");
		}
	else 
		{
		setprop("/fdm/jsbsim/systems/fcs/control-mode",1);
		if (getprop("/fdm/jsbsim/systems/fcs/rcs-use-pulse") == 0)
		{
		setprop("/controls/shuttle/control-system-string", "RCS rotation");
		}
	else
		{
		setprop("/controls/shuttle/control-system-string", "RCS ROT PLS");
		}
		}

	}
else if (current_mode ==0)
	{
	setprop("/fdm/jsbsim/systems/fcs/control-mode",10);
	setprop("/controls/shuttle/control-system-string", "Thrust Vectoring");	
	}
else if (current_mode ==10)
	{
	setprop("/fdm/jsbsim/systems/fcs/control-mode",0);
	setprop("/controls/shuttle/control-system-string", "Thrust Vectoring (gimbal)");	
	}
else if ((current_mode ==24) or (current_mode == 4))
	{
	setprop("/fdm/jsbsim/systems/fcs/control-mode",29);
	setprop("/controls/shuttle/control-system-string", "Aerojet");	
	}
else if (current_mode == 29)
	{
	# where aerojet switches back to depends on Mach number
	var mach = getprop("/fdm/jsbsim/velocities/mach");

	if (mach > 3.5)
		{
		setprop("/fdm/jsbsim/systems/fcs/control-mode",24);
		setprop("/controls/shuttle/control-system-string", "RCS ROT ENTRY");
		}
	else 	
		{
		setprop("/fdm/jsbsim/systems/fcs/control-mode",4);
		setprop("/controls/shuttle/control-system-string", "Aerodynamical");
		}
	
	}
else if (current_mode ==24)
	{
	setprop("/fdm/jsbsim/systems/fcs/control-mode",29);
	setprop("/controls/shuttle/control-system-string", "Aerojet");	
	}
else if (current_mode == 50)
	{
	setprop("/fdm/jsbsim/systems/fcs/control-mode",51);
	setprop("/sim/messages/copilot", "MMU rotation");
	}
else if (current_mode == 51)
	{
	setprop("/fdm/jsbsim/systems/fcs/control-mode",50);
	setprop("/sim/messages/copilot", "MMU translation");
	}

	
}


var switch_detailed_control_mode = func {

var current_mode = getprop("/fdm/jsbsim/systems/fcs/control-mode");


var orbital_dap_inertial = getprop("/fdm/jsbsim/systems/ap/orbital-dap-inertial");
var orbital_dap_free = getprop("/fdm/jsbsim/systems/ap/orbital-dap-free");
var orbital_dap_lvlh = getprop("/fdm/jsbsim/systems/ap/orbital-dap-lvlh");
var orbital_dap_auto = getprop("/fdm/jsbsim/systems/ap/orbital-dap-auto");


# sort the modes according to which orbital DAP we're in

if (orbital_dap_auto == 1) # labels are different
	{
	if (current_mode == 20) # DAP A
		{
		setprop("/fdm/jsbsim/systems/fcs/control-mode",21);
		setprop("/controls/shuttle/control-system-string", "RCS ROT DAP-B AUTO");
		}
	if (current_mode == 21) # DAP B
		{
		setprop("/fdm/jsbsim/systems/fcs/control-mode",25);
		setprop("/controls/shuttle/control-system-string", "RCS DAP-A VERNIER AUTO");
		}
	else if (current_mode == 25) # Vernier A
		{
		setprop("/fdm/jsbsim/systems/fcs/control-mode",30);
		setprop("/controls/shuttle/control-system-string", "RCS DAP-B VERNIER AUTO");
		}
	else if (current_mode == 30) # Vernier B
		{
		setprop("/fdm/jsbsim/systems/fcs/control-mode",20);
		setprop("/controls/shuttle/control-system-string", "RCS ROT DAP-A AUTO");
		}

	}

if ((orbital_dap_inertial == 1) or (orbital_dap_lvlh == 1))
	{
	# rotational mode assignment

	if (current_mode == 20) # DAP A
		{
		setprop("/fdm/jsbsim/systems/fcs/control-mode",21);
		setprop("/controls/shuttle/control-system-string", "RCS ROT DAP-B");
		}
	if (current_mode == 21) # DAP B
		{
		setprop("/fdm/jsbsim/systems/fcs/control-mode",25);
		setprop("/controls/shuttle/control-system-string", "RCS DAP-A VERNIER");
		}
	else if (current_mode == 25) # Vernier A
		{
		setprop("/fdm/jsbsim/systems/fcs/control-mode",30);
		setprop("/controls/shuttle/control-system-string", "RCS DAP-B VERNIER");
		}
	else if (current_mode == 30) # Vernier B
		{
		setprop("/fdm/jsbsim/systems/fcs/control-mode",20);
		setprop("/controls/shuttle/control-system-string", "RCS ROT DAP-A");
		}

	# translational mode assignment

	if (current_mode == 26) # TRANS ATT HOLD
		{
		setprop("/fdm/jsbsim/systems/fcs/control-mode",28);
		setprop("/controls/shuttle/control-system-string", "RCS TRANS LOW-Z ATT HLD");
		}
	else if (current_mode == 28) # low Z
		{
		setprop("/fdm/jsbsim/systems/fcs/control-mode",26);
		setprop("/controls/shuttle/control-system-string", "RCS TRANS ATT HLD");
		}
	

	}

if (orbital_dap_free == 1)
	{
	# rotational mode assignment

	if (current_mode == 1) # ROT
		{
		setprop("/fdm/jsbsim/systems/fcs/control-mode",22);
		setprop("/controls/shuttle/control-system-string", "RCS ROT TAIL ONLY");
		}
	else if (current_mode == 22) # TAIL ONLY
		{
		setprop("/fdm/jsbsim/systems/fcs/control-mode",23);
		setprop("/controls/shuttle/control-system-string", "RCS ROT NOSE ONLY");
		}
	else if (current_mode == 23)
		{
		setprop("/fdm/jsbsim/systems/fcs/control-mode",1);
		if (getprop("/fdm/jsbsim/systems/fcs/rcs-use-pulse") == 0)
		{
		setprop("/controls/shuttle/control-system-string", "RCS rotation");
		}
	else
		{
		setprop("/controls/shuttle/control-system-string", "RCS ROT PLS");
		}
		}

		# translational mode assignment

	if (current_mode == 2) # translation
		{
		setprop("/fdm/jsbsim/systems/fcs/control-mode",27);
		setprop("/controls/shuttle/control-system-string", "RCS TRANS LOW-Z");
		}
	else if (current_mode == 27) # low Z
		{
		setprop("/fdm/jsbsim/systems/fcs/control-mode",2);
		setprop("/controls/shuttle/control-system-string", "RCS translation");
		}
		

	}

}



var switch_orbital_dap = func (mode)  {

var current_mode = getprop("/fdm/jsbsim/systems/fcs/control-mode");

# AUTO always needs to switch OMS TVC off

if ((current_mode == 11) and (mode == 1))
	{
	setprop("/fdm/jsbsim/systems/fcs/control-mode",20);
	setprop("/controls/shuttle/control-system-string", "RCS ROT DAP-A AUTO");
	return;
	}


# make sure we don't switch the DAP accidentially when not in orbit

if ((current_mode == 0) or (current_mode == 10) or (current_mode == 11) or (current_mode == 29) or (current_mode == 3) or (current_mode == 4))
	{
	return;
	}

if (mode == 1) # AUTO
	{
	setprop("/fdm/jsbsim/systems/fcs/control-mode",20);
	setprop("/controls/shuttle/control-system-string", "RCS ROT DAP-A AUTO");
	}
else if (mode == 2) # INTRL
	{
	setprop("/fdm/jsbsim/systems/fcs/control-mode",20);
	setprop("/controls/shuttle/control-system-string", "RCS ROT DAP-A");	
	}
else if (mode == 3) # LVLH
	{
	setprop("/fdm/jsbsim/systems/fcs/control-mode",20);
	setprop("/controls/shuttle/control-system-string", "RCS ROT DAP-A");
	}
else if (mode == 4) # FREE
	{
	setprop("/fdm/jsbsim/systems/fcs/control-mode",1);
	if (getprop("/fdm/jsbsim/systems/fcs/rcs-use-pulse") == 0)
		{
		setprop("/controls/shuttle/control-system-string", "RCS rotation");
		}
	else
		{
		setprop("/controls/shuttle/control-system-string", "RCS ROT PLS");
		}
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
	#setprop("/fdm/jsbsim/systems/fcs/control-mode",3);
	if (getprop("/fdm/jsbsim/systems/fcs/control-mode") == 24)
		{setprop("/controls/shuttle/control-system-string", "RCS / Aero");}
	setprop("/fdm/jsbsim/systems/fcs/rcs-roll-mode", 0);
	setprop("/sim/messages/copilot", "Roll control to aero.");
	deorbit_stage_flag = 1;
	}

if ((qbar > 40.0) and   (deorbit_stage_flag == 1))
	{
	setprop("/fdm/jsbsim/systems/fcs/rcs-pitch-mode", 0);
	setprop("/sim/messages/copilot", "Pitch control to aero.");
	deorbit_stage_flag = 2;
	}

if ((getprop("/fdm/jsbsim/velocities/mach") < 3.5) and (deorbit_stage_flag == 2))
	{
	setprop("/fdm/jsbsim/systems/fcs/rcs-yaw-mode", 0);
	if (getprop("/fdm/jsbsim/systems/fcs/control-mode") == 24)
		{
		setprop("/fdm/jsbsim/systems/fcs/control-mode",4);	
		setprop("/controls/shuttle/control-system-string", "Aerodynamical");
		}
	setprop("/sim/messages/copilot", "Yaw control to aero.");
	deorbit_stage_flag = 3;
	}

# open vent doors as soon as vrel < 2400 fps is sensed

if (getprop("/fdm/jsbsim/velocities/vtrue-fps") < 2400.0)
	{
	setprop("/fdm/jsbsim/systems/mechanical/vdoor-cmd", 1);
	}

if (((getprop("/position/altitude-ft") < 85000.0) or (getprop("/fdm/jsbsim/velocities/mach") <2.5)) and (deorbit_stage_flag == 3))
	{
	setprop("/sim/messages/copilot", "TAEM interface reached.");
	setprop("/controls/shuttle/hud-mode",3);

	if (getprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode") > 0)
		{
		SpaceShuttle.compute_TAEM_guidance_targets();
		}

	glide_loop();
	return;
	}


if (getprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode") >0)
	{SpaceShuttle.update_entry_guidance();}

SpaceShuttle.check_limits_entry();


if ((SpaceShuttle.earthview_flag == 1) and (earthview.earthview_running_flag == 1))
	{
	var alt = getprop("/position/altitude-ft");
	if (alt < SpaceShuttle.earthview_transition_alt)
		{
		earthview.stop();

		if (getprop("/sim/gui/dialogs/metar/mode/local-weather") == 1)
			{local_weather.set_tile();}
		}

	}



# some log output
# print(getprop("/sim/time/elapsed-sec"), " ", getprop("/position/altitude-ft"), " ", getprop("/fdm/jsbsim/velocities/eci-velocity-mag-fps"), " ", getprop("/fdm/jsbsim/position/distance-from-start-mag-mt"), " ", getprop("/fdm/jsbsim/velocities/v-down-fps"));

settimer(SpaceShuttle.adjust_effect_colors, 0.2);

settimer(deorbit_loop,1.0);
}


###########################################################################
# the glide loop watches limits during descent
###########################################################################

var gear_arm_message_flag = 0;

var glide_loop = func {


SpaceShuttle.update_entry_guidance();


var alt = getprop("/position/altitude-agl-ft");

if ((alt < 2100.0) and (gear_arm_message_flag == 0))
	{
	setprop("/sim/messages/copilot", "2000 ft - arm gear!");
	gear_arm_message_flag = 1;
	}

# open vent doors as soon as vrel < 2400 fps is sensed

if (getprop("/fdm/jsbsim/velocities/vtrue-fps") < 2400.0)
	{
	setprop("/fdm/jsbsim/systems/mechanical/vdoor-cmd", 1);
	}

SpaceShuttle.check_limits_glide();

# some log output
# print(getprop("/sim/time/elapsed-sec"), " ", getprop("/position/altitude-ft"), " ",  getprop("/fdm/jsbsim/position/distance-from-start-mag-mt"), " ", getprop("/velocities/equivalent-kt"), " ", getprop("/fdm/jsbsim/aero/qbar-psf"));

settimer(glide_loop,1.0);
}


###########################################################################
# helper functions for control state management
###########################################################################

var show_gear_state = func {

var gear_state = getprop("/fdm/jsbsim/gear/gear-pos-norm");

if (gear_state == 0)
	{setprop("/controls/shuttle/gear-string", "up");}
else if (gear_state == 1)
	{setprop("/controls/shuttle/gear-string", "down");}
else {setprop("/controls/shuttle/gear-string", "transit");}

}

var show_speedbrake_state = func {

var speedbrake_state = getprop("/controls/flight/speedbrake");

if (speedbrake_state == 0)
	{setprop("/controls/shuttle/speedbrake-string", "in");}
else if (speedbrake_state == 1)
	{setprop("/controls/shuttle/speedbrake-string", "out");}

}

var increase_speedbrake = func {

var speedbrake_state = getprop("/controls/shuttle/speedbrake");

if (rand() > SpaceShuttle.failure_cmd.speedbrake)
	{
	SpaceShuttle.failure_cmd.speedbrake = 0;
	return;
	}

speedbrake_state = speedbrake_state+ 0.2;
if (speedbrake_state > 1.0) {speedbrake_state = 1.0;}

setprop("/controls/shuttle/speedbrake", speedbrake_state);

if (speedbrake_state == 1.0) {speedbrake_string = "out";}
else {speedbrake_string = int(speedbrake_state * 100.0)~"%";}

setprop("/controls/shuttle/speedbrake-string", speedbrake_string);
}

var decrease_speedbrake = func {

if (rand() > SpaceShuttle.failure_cmd.speedbrake)
	{
	SpaceShuttle.failure_cmd.speedbrake = 0;
	return;
	}

var speedbrake_state = getprop("/controls/shuttle/speedbrake");

speedbrake_state = speedbrake_state - 0.2;
if (speedbrake_state < 0.0) {speedbrake_state = 0.0;}

setprop("/controls/shuttle/speedbrake", speedbrake_state);

if (speedbrake_state == 0.0) {speedbrake_string = "in";}
else {speedbrake_string = int(speedbrake_state * 100.0)~"%";}

setprop("/controls/shuttle/speedbrake-string", speedbrake_string);
}

# gear retraction message

var gear_up_message = func {

setprop("/sim/messages/copilot", "The gear can only be retracted by the ground crew!");
}


# control of the body flap

var bodyflap_down = func {

var bodyflap_state = getprop("/controls/shuttle/bodyflap-pos-rad");

if (bodyflap_state == -0.315) {bodyflap_state = -0.25;}
else if (bodyflap_state == -0.25) {bodyflap_state = 0.0;}
else if (bodyflap_state == 0.0) {bodyflap_state = 0.25;}
else if (bodyflap_state == 0.25) {bodyflap_state = 0.315;}


setprop("/controls/shuttle/bodyflap-pos-rad", bodyflap_state);
}

var bodyflap_up = func {

var bodyflap_state = getprop("/controls/shuttle/bodyflap-pos-rad");

if (bodyflap_state == -0.25) {bodyflap_state = -0.315;}
else if (bodyflap_state == 0.0) {bodyflap_state = -0.25;}
else if (bodyflap_state == 0.25) {bodyflap_state = 0.0;}
else if (bodyflap_state == 0.315) {bodyflap_state = 0.25;}

setprop("/controls/shuttle/bodyflap-pos-rad", bodyflap_state);
}


# forward RCS fuel dump

var toggle_fwd_fuel_dump = func {

var state = getprop("/fdm/jsbsim/systems/rcs/fwd-dump-cmd");

if (state == 0) {state=1;}
else {state = 0;}

setprop("/fdm/jsbsim/systems/rcs/fwd-dump-cmd", state);
}


# OMS fuel dump

var toggle_oms_fuel_dump = func {

var state = getprop("/fdm/jsbsim/systems/oms/oms-dump-cmd");

if (state == 0) {state=1;}
else {state = 0;}

setprop("/fdm/jsbsim/systems/oms/oms-dump-cmd", state);

setprop("/controls/engines/engine[5]/throttle", state);
setprop("/controls/engines/engine[6]/throttle", state);

setprop("/fdm/jsbsim/systems/oms/oms-rcs-dump-cmd", 0);

var interconnect_state = getprop("/fdm/jsbsim/systems/oms/oms-dump-interconnect-cmd");

if ((state == 1) and (interconnect_state == 1))
	{
	settimer(set_oms_rcs_crossfeed, 3.0);
	settimer( func{ setprop("/fdm/jsbsim/systems/oms/oms-rcs-dump-cmd", 1);}, 3.5);
	}

if (state == 1) {SpaceShuttle.oms_fuel_dump_loop_init();}

}


var set_oms_rcs_crossfeed = func {

# close the RCS tank isolation valves

setprop("/fdm/jsbsim/systems/rcs-hardware/tank-left-rcs-valve-12-status", 0);
setprop("/fdm/jsbsim/systems/rcs-hardware/tank-left-rcs-valve-345A-status", 0);
setprop("/fdm/jsbsim/systems/rcs-hardware/tank-left-rcs-valve-345B-status", 0);

setprop("/fdm/jsbsim/systems/rcs-hardware/tank-right-rcs-valve-12-status", 0);
setprop("/fdm/jsbsim/systems/rcs-hardware/tank-right-rcs-valve-345A-status", 0);
setprop("/fdm/jsbsim/systems/rcs-hardware/tank-right-rcs-valve-345B-status", 0);

# open the OMS crossfeed valves

setprop("/fdm/jsbsim/systems/oms-hardware/crossfeed-left-oms-valve-A-status", 1);
setprop("/fdm/jsbsim/systems/oms-hardware/crossfeed-left-oms-valve-B-status", 1);

setprop("/fdm/jsbsim/systems/oms-hardware/crossfeed-right-oms-valve-A-status", 1);
setprop("/fdm/jsbsim/systems/oms-hardware/crossfeed-right-oms-valve-B-status", 1);

# open the RCS crossfeed valves

setprop("/fdm/jsbsim/systems/rcs-hardware/crossfeed-left-rcs-valve-12-status", 1);
setprop("/fdm/jsbsim/systems/rcs-hardware/crossfeed-left-rcs-valve-345-status", 1);

setprop("/fdm/jsbsim/systems/rcs-hardware/crossfeed-right-rcs-valve-12-status", 1);
setprop("/fdm/jsbsim/systems/rcs-hardware/crossfeed-right-rcs-valve-345-status", 1);

settimer( func {setprop("/fdm/jsbsim/systems/oms/oms-dump-interconnect-complete", 1);}, 4.0);
}


var unset_oms_rcs_crossfeed = func {

# close the OMS crossfeed valves

setprop("/fdm/jsbsim/systems/oms-hardware/crossfeed-left-oms-valve-A-status", 0);
setprop("/fdm/jsbsim/systems/oms-hardware/crossfeed-left-oms-valve-B-status", 0);

setprop("/fdm/jsbsim/systems/oms-hardware/crossfeed-right-oms-valve-A-status", 0);
setprop("/fdm/jsbsim/systems/oms-hardware/crossfeed-right-oms-valve-B-status", 0);

# close the RCS crossfeed valves

setprop("/fdm/jsbsim/systems/rcs-hardware/crossfeed-left-rcs-valve-12-status", 0);
setprop("/fdm/jsbsim/systems/rcs-hardware/crossfeed-left-rcs-valve-345-status", 0);

setprop("/fdm/jsbsim/systems/rcs-hardware/crossfeed-right-rcs-valve-12-status", 0);
setprop("/fdm/jsbsim/systems/rcs-hardware/crossfeed-right-rcs-valve-345-status", 0);

# open the RCS tank isolation valves

setprop("/fdm/jsbsim/systems/rcs-hardware/tank-left-rcs-valve-12-status", 1);
setprop("/fdm/jsbsim/systems/rcs-hardware/tank-left-rcs-valve-345A-status", 1);
setprop("/fdm/jsbsim/systems/rcs-hardware/tank-left-rcs-valve-345B-status", 1);

setprop("/fdm/jsbsim/systems/rcs-hardware/tank-right-rcs-valve-12-status", 1);
setprop("/fdm/jsbsim/systems/rcs-hardware/tank-right-rcs-valve-345A-status", 1);
setprop("/fdm/jsbsim/systems/rcs-hardware/tank-right-rcs-valve-345B-status", 1);



settimer( func {setprop("/fdm/jsbsim/systems/oms/oms-dump-interconnect-complete", 0);}, 4.0);
}

# landing gear arm

var arm_gear = func {

setprop("/fdm/jsbsim/systems/landing/landing-gear-arm-cmd", 1);
setprop("/controls/shuttle/gear-string", "armed");

}

# cutoff switches for SSME

var ssme_cutoff = func (n) {
#print ("Engine ", n, " cutoff command received!");

setprop("/fdm/jsbsim/systems/mps/engine["~n~"]/run-cmd", 0);

}

# lockup - engine can no longer be throttled

var ssme_lockup = func (n) {

    print ("SSME lockup ", n);

    var number = 0;

    if (n==0) {number = 2; SpaceShuttle.failure_cmd.ssme1 = 0;}
    if (n==1) {number = 3; SpaceShuttle.failure_cmd.ssme2 = 0;}
    if (n==2) {number = 1; SpaceShuttle.failure_cmd.ssme3 = 0;}

    if (lockup_message_flag == 0)
        {
        setprop("/sim/messages/copilot", "Lockup of engine "~number~"!");
        lockup_message_flag =1;
        }
    setprop("/sim/input/selected/engine["~n~"]",0);
}

var arm_drag_chute = func {
    setprop("/controls/shuttle/drag-chute-arm", 1);
}

var jettison_drag_chute = func {
    setprop("/controls/shuttle/drag-chute-jettison", 1);
}

var deploy_chute = func {

    var wheels_down = 0;
    if (getprop("/fdm/jsbsim/gear/unit[1]/WOW") and getprop("/fdm/jsbsim/gear/unit[2]/WOW")) {
        wheels_down = 1;
    }
    if (wheels_down==0) {
        setprop("/sim/messages/copilot", "Chute can only be deployed after touchdown!");
        return;
    }

    var chute_armed = getprop("/controls/shuttle/drag-chute-arm");
    if (chute_armed == 0) {
        setprop("/sim/messages/copilot", "Chute can only be deployed if armed!");
            return;
    }

    var current_state = getprop("/controls/shuttle/parachute");
    if (current_state == 0) {
            setprop("/controls/shuttle/parachute",1);
            setprop("/controls/shuttle/drag-chute-deploy", 1);
            SpaceShuttle.check_limits_touchdown();
            if (getprop("/fdm/jsbsim/systems/failures/drag-chute-condition") == 0.0) {
                setprop("/controls/shuttle/drag-chute-jettison", 1);
            }
    }

    if (current_state == 1){
        setprop("/controls/shuttle/parachute",2);
    }

    setprop("/controls/shuttle/drag-chute-string", "deployed");
}

var chuteDeployTime = 0;
var chute_deploy_animation = func {

    chuteDeployTime=chuteDeployTime+1;
    setprop("/controls/shuttle/drag-chute-deploy-timer", chuteDeployTime);

    if (chuteDeployTime > 7 or chuteDeployTime == 0){
        chute_deploy_timer.stop();
    }
};

var chute_deploy_timer = maketimer(1, chute_deploy_animation);
setlistener("/controls/shuttle/drag-chute-deploy", func {
    chute_deploy_timer.start();
});

setlistener("/controls/shuttle/drag-chute-jettison", func {
    chute_deploy_timer.stop();
    setprop("/controls/shuttle/drag-chute-deploy-timer", 0);
    chuteDeployTime = 0;
});


#########################################################
# the slowdown loop checks for wheels stop
#########################################################

var slowdown_loop_start = func {

if ((getprop("/gear/gear[1]/wow") == 0) or (slowdown_loop_flag ==1)) {return;}

setprop("/sim/messages/copilot", "Touchdown!");
slowdown_loop_flag = 1;
slowdown_loop();

setprop("/controls/shuttle/speedbrake", 1);
setprop("/controls/shuttle/speedbrake-string", "out");


}

var slowdown_loop = func {

if ((getprop("/gear/gear[0]/wow") == 1) and (WONG_message_flag == 0))
	{
	setprop("/sim/messages/copilot", "Weight on nose gear.");
	WONG_message_flag = 1;
	}

if ((getprop("/gear/gear[1]/rollspeed-ms") < 0.1) and (getprop("/velocities/groundspeed-kt") < 10.0))
	{
	setprop("/sim/messages/copilot", "Wheels stop!");
	return;
	}

SpaceShuttle.check_limits_touchdown();


settimer(slowdown_loop,1.0);
}


var log_loop= func {

print(getprop("/position/altitude-ft"));
settimer(log_loop,0.0);
}


var geotest= func {
var pos1 = geo.Coord.new();
pos1.set_latlon(45.0,-100.0,1000.0);

var pos2 = geo.Coord.new();
pos2.set_latlon(45.0,20.0,1000.0);

var d = pos1.distance_to(pos2);

var course = pos1.course_to(pos2);
print ("Distance: ", d, "Course: ", course);

}


#############################################################
# helper functions to set systems to a mission-specific state
#############################################################

# if we start in certain mission parts, we need to have hydraulics on

var hydraulics_on = func {

setprop("/fdm/jsbsim/systems/apu/init-hydraulics-on", 1);
settimer( func {setprop("/fdm/jsbsim/systems/apu/init-hydraulics-on", 0);}, 10.0);

setprop("/fdm/jsbsim/systems/apu/apu/apu-controller-power", 1);
setprop("/fdm/jsbsim/systems/apu/apu/fuel-valve-status", 1);
settimer( func { setprop("/fdm/jsbsim/systems/apu/apu/apu-operate", 1);}, 0.1);
settimer( func {setprop("/fdm/jsbsim/systems/apu/apu/hyd-pump-pressure-select", 1);}, 0.2);

setprop("/fdm/jsbsim/systems/apu/apu[1]/apu-controller-power", 1);
setprop("/fdm/jsbsim/systems/apu/apu[1]/fuel-valve-status", 1);
settimer( func { setprop("/fdm/jsbsim/systems/apu/apu[1]/apu-operate", 1);}, 0.1);
settimer( func {setprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-pump-pressure-select", 1);}, 0.2);

setprop("/fdm/jsbsim/systems/apu/apu[2]/apu-controller-power", 1);
setprop("/fdm/jsbsim/systems/apu/apu[2]/fuel-valve-status", 1);
settimer( func { setprop("/fdm/jsbsim/systems/apu/apu[2]/apu-operate", 1);}, 0.1);
settimer( func {setprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-pump-pressure-select", 1);}, 0.2);

setprop("/fdm/jsbsim/systems/apu/apu/boiler-N2-valve-status", 1);
setprop("/fdm/jsbsim/systems/apu/apu/boiler-power-status", 1);

setprop("/fdm/jsbsim/systems/apu/apu[1]/boiler-N2-valve-status", 1);
setprop("/fdm/jsbsim/systems/apu/apu[1]/boiler-power-status", 1);

setprop("/fdm/jsbsim/systems/apu/apu[2]/boiler-N2-valve-status", 1);
setprop("/fdm/jsbsim/systems/apu/apu[2]/boiler-power-status", 1);

}


var et_umbilical_door_close = func {


setprop("/fdm/jsbsim/systems/mechanical/et-door-cl-latch-cmd", 0);

setprop("/fdm/jsbsim/systems/mechanical/et-door-left-cmd", 1);
setprop("/fdm/jsbsim/systems/mechanical/et-door-right-cmd", 1);

setprop("/fdm/jsbsim/systems/mechanical/et-door-left-latch-cmd", 1);
setprop("/fdm/jsbsim/systems/mechanical/et-door-right-latch-cmd", 1);

}


var ku_antenna_deploy = func {

setprop("/fdm/jsbsim/systems/mechanical/ku-antenna-elec-cb", 1);
setprop("/fdm/jsbsim/systems/mechanical/ku-antenna-heater-cb", 1);
setprop("/fdm/jsbsim/systems/mechanical/ku-antenna-cable-heater-cb", 1);
setprop("/fdm/jsbsim/systems/mechanical/ku-antenna-sig-proc-cb", 1);

setprop("/fdm/jsbsim/systems/mechanical/ku-antenna-deploy-switch", 1);


}

var pb_door_open = func {

setprop("/fdm/jsbsim/systems/mechanical/pb-door-sys1-enable", 1);
setprop("/fdm/jsbsim/systems/mechanical/pb-door-init-open", 1);
setprop("/fdm/jsbsim/systems/mechanical/pb-door-auto-switch",1);
settimer( func{ SpaceShuttle.payload_bay_door_open_auto(0); }, 1.0);

settimer( func {setprop("/fdm/jsbsim/systems/mechanical/pb-door-init-open", 0);}, 200.0); 
}

var radiator_activate = func {

setprop("/fdm/jsbsim/systems/atcs/flow-bypass-1-status", 0);
setprop("/fdm/jsbsim/systems/atcs/flow-bypass-2-status", 0);
setprop("/fdm/jsbsim/systems/atcs/rad-controller-1-status", 1);
setprop("/fdm/jsbsim/systems/atcs/rad-controller-2-status", 1);
setprop("/fdm/jsbsim/systems/atcs/fes-controller-A-status", 0);
setprop("/fdm/jsbsim/systems/atcs/fes-controller-B-status", 0);
setprop("/fdm/jsbsim/systems/atcs/fes-controller-sec-status", 0);
setprop("/fdm/jsbsim/systems/atcs/fes-hi-load-status", 0);
}


##############################################################################
# the set_speed function initializes the shuttle to proper orbital/suborbital
# velocity and at the right locations for TAEM and final based on the selected
# mission stage
#############################################################################

var set_speed = func {


var stage = getprop("/sim/presets/stage");

if (stage == 0)
	{
	var alt = getprop("/position/altitude-ft");
	var terrain_alt = getprop("/position/altitude-agl-ft");

	var place_alt = (alt - terrain_alt) + 90.0; #214

	#SpaceShuttle.place_pad(place_alt - 170.0);

	#print("place alt: ", place_alt);

	var pad_offset = 100.0;
	setprop("/position/altitude-ft", place_alt + pad_offset);
	setprop("/position/latitude-deg", getprop("/sim/presets/latitude-deg"));
	setprop("/position/longitude-deg", getprop("/sim/presets/longitude-deg"));
	setprop("/orientation/pitch-deg", 90.0);
	#hydraulics_on();

	}


if (stage == 1) 
	{
	# nothing is ever simple - we need to consider the rotation of Earth

	var latitude = getprop("/position/latitude-deg") * 3.1415/180.0;
	var heading = getprop("/orientation/heading-deg") * 3.1415/180.0;

	var rotation_boost = 1579.0 * math.cos(latitude) * math.sin(heading);
	setprop("/velocities/uBody-fps", 26100.0 - rotation_boost);


	# test de-orbit parameters
	#setprop("/position/altitude-ft", 850000.0);
	#setprop("/velocities/uBody-fps", 25400.0 - rotation_boost);
	#setprop("/velocities/uBody-fps", 25200.0 - rotation_boost);
	#setprop("/velocities/wBody-fps", 180.0);

	# test de-orbit burn
	#setprop("/position/altitude-ft", 1050000.0);
	#setprop("/velocities/uBody-fps", 25300.0 - rotation_boost);
	#setprop("/velocities/wBody-fps", 175.0);
	}

if (stage == 2) 
	{

	var latitude = getprop("/position/latitude-deg") * 3.1415/180.0;
	var heading = getprop("/orientation/heading-deg") * 3.1415/180.0;

	var rotation_boost = 1579.0 * math.cos(latitude) * math.sin(heading);
	#setprop("/velocities/uBody-fps", 25100.0 - rotation_boost);
	#setprop("/velocities/wBody-fps", 200.0);

	#setprop("/velocities/uBody-fps", 25500.0 - rotation_boost);
	setprop("/velocities/wBody-fps", 300.0);
	setprop("/velocities/uBody-fps", 25000.0 - rotation_boost);

	hydraulics_on();
	et_umbilical_door_close();
	SpaceShuttle.traj_display_flag = 3;
	SpaceShuttle.fill_entry1_data();
	settimer( func {
			setprop("/fdm/jsbsim/systems/fcs/control-mode",29);
			setprop("/controls/shuttle/control-system-string", "Aerojet");
			}, 2.0);
	#deorbit_loop();	

	}

if (stage == 3) 
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

	setprop("/velocities/uBody-fps",2400.0);

	# arrange the displays to be set

	MEDS_CDR1.PFD.selectPage(MEDS_CDR1.PFD.p_dps_hsit);
	MEDS_CDR1.PFD.dps_page_flag = 1;
	MEDS_CDR2.PFD.selectPage(MEDS_CDR2.PFD.p_dps);
	MEDS_CDR2.PFD.dps_page_flag = 1;
	MEDS_CRT1.PFD.selectPage(MEDS_CRT1.PFD.p_meds_apu);
	MEDS_CRT1.PFD.dps_page_flag = 0;
	MEDS_MFD1.PFD.selectPage(MEDS_MFD1.PFD.p_meds_spi);
	MEDS_MFD1.PFD.dps_page_flag = 0;
	MEDS_CRT3.PFD.selectPage(MEDS_CRT3.PFD.p_dps);
	MEDS_CRT3.PFD.dps_page_flag = 1;
	MEDS_CRT2.PFD.selectPage(MEDS_CRT2.PFD.p_meds_spi);
	MEDS_CRT2.PFD.dps_page_flag = 0;
	MEDS_MFD2.PFD.selectPage(MEDS_MFD2.PFD.p_meds_apu);
	MEDS_MFD2.PFD.dps_page_flag = 0;
	MEDS_PLT1.PFD.selectPage(MEDS_PLT1.PFD.p_dps);
	MEDS_PLT1.PFD.dps_page_flag = 1;
	MEDS_PLT2.PFD.selectPage(MEDS_PLT2.PFD.p_dps_hsit);
	MEDS_PLT2.dps_page_flag = 1;

	#setprop("/fdm/jsbsim/systems/dps/spec", 50);
	}

if (stage == 4) 
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
	#var place_dist = 450000.0; # 240 miles downrange
	var place_x = place_dist * math.sin(place_dir);
	var place_y = place_dist * math.cos(place_dir);

	var place_lat = getprop("/position/latitude-deg") + m_to_lat * place_y;
	var place_lon = getprop("/position/longitude-deg") + m_to_lon * place_x;
	var place_alt_correct = getprop("/position/altitude-ft") - getprop("/position/altitude-agl-ft");

	#print (place_lat, " ",place_lon);

	setprop("/position/latitude-deg", place_lat); 
	setprop("/position/longitude-deg", place_lon); 
	setprop("/position/altitude-ft", 11000 + place_alt_correct);

	setprop("/velocities/uBody-fps",600.0);
	setprop("/velocities/wBody-fps", 60.0);

	# starting point for a RTLS glide	

	#setprop("/position/altitude-ft", 220000.0);

	#setprop("/velocities/uBody-fps", 8000.0);
	#setprop("/velocities/wBody-fps", -900.0);
	

	
	}

if (stage == 5) 
	{
	var lat_to_m = 110952.0; 
	var lon_to_m  = math.cos(getprop("/position/latitude-deg")*math.pi/180.0) * lat_to_m;
	var m_to_lon = 1.0/lon_to_m;
	var m_to_lat = 1.0/lat_to_m;

	var heading = getprop("/orientation/heading-deg");
	var place_dir = heading + 180.0;
	if (place_dir > 360.0) {place_dir = place_dir-360.0;}
	place_dir = place_dir * math.pi/180.0;

	var place_dist = 25000.0; 
	var place_x = place_dist * math.sin(place_dir);
	var place_y = place_dist * math.cos(place_dir);

	var place_lat = getprop("/position/latitude-deg") + m_to_lat * place_y;
	var place_lon = getprop("/position/longitude-deg") + m_to_lon * place_x;

	#print (place_lat, " ",place_lon);

	#setprop("/position/latitude-deg", place_lat); 
	#setprop("/position/longitude-deg", place_lon); 

	setprop("/velocities/uBody-fps",900.0);
	setprop("/velocities/wBody-fps", 60.0);
	}

if (stage == 6) 
	{
	# nothing is ever simple - we need to consider the rotation of Earth

	var latitude = getprop("/position/latitude-deg") * 3.1415/180.0;
	var heading = getprop("/orientation/heading-deg") * 3.1415/180.0;

	var rotation_boost = 1579.0 * math.cos(latitude) * math.sin(heading);

	setprop("/position/altitude-ft", 1050000.0);
	setprop("/velocities/uBody-fps", 25300.0 - rotation_boost);
	setprop("/velocities/wBody-fps", 175.0);
	}

# initialize the DPS hardware

SpaceShuttle.init_gpcs(stage);
SpaceShuttle.init_idps();
SpaceShuttle.init_keyboards();


}

# register a few listeners to events which need HUD changes or callouts

setlistener("/engines/engine[0]/thrust_lb", func {launch_loop_start();},0,0);
setlistener("/gear/gear[1]/wow", func {slowdown_loop_start();},0,0);
setlistener("/gear/gear[0]/wow", func {check_limits_touchdown();},0,0);
setlistener("/gear/gear[1]/wow", func {check_limits_touchdown();},0,0);
setlistener("/gear/gear[2]/wow", func {check_limits_touchdown();},0,0);
setlistener("/fdm/jsbsim/gear/gear-pos-norm", func {show_gear_state();},0,0);
setlistener("/fdm/jsbsim/systems/mechanical/ku-antenna-jett-switch", func {settimer(manage_ku_jettison,0);}, 0,0);


# listeners for RMS jettison - we need to listen to the trigger switches rather than the JSBSim attach property

setlistener("/fdm/jsbsim/systems/rms/rms-port-jett-shl-switch", func {settimer(manage_rms_jettison,0);}, 0,0);
setlistener("/fdm/jsbsim/systems/rms/rms-port-jett-fwd-switch", func {settimer(manage_rms_jettison,0);}, 0,0);
setlistener("/fdm/jsbsim/systems/rms/rms-port-jett-mid-switch", func {settimer(manage_rms_jettison,0);}, 0,0);
setlistener("/fdm/jsbsim/systems/rms/rms-port-jett-aft-switch", func {settimer(manage_rms_jettison,0);}, 0,0);



var set_pad = func {

SpaceShuttle.compute_launchpad();

}


if (getprop("/sim/presets/stage") ==0)
	{

	# we need to set this with a delay because the name space doesn't seem to be ready immediately
	settimer(set_pad, 0.2);

	settimer(set_speed, 0.5);


# since the SRBs  are implemented as slaved ballistic submodels, we need to trigger their
# attachment - this apparently does not work if the parameter is simply set at startup
# (nothing is ever easy) so we need to do it with a delay

	settimer( func {setprop("/controls/shuttle/SRB-attach", 1);}, 1.0);	
	}


# determine the initial state of the craft based on selected mission stage

if (getprop("/position/altitude-ft") > 350000.0) # we start in orbit
	{
	SRB_message_flag = 2;
	settimer(set_speed, 0.5);
	SRB_separate_silent();
	gear_up();
	if ((getprop("/sim/presets/stage") == 2) or (getprop("/sim/presets/stage") == 6))
		 {external_tank_separate_silent();}
	else
		{
		setprop("/consumables/fuel/tank[17]/level-lbs", 600.0);
		setprop("/consumables/fuel/tank[18]/level-lbs",4800.0);
		}
	setprop("/consumables/fuel/tank[0]/level-norm",0.0);
	setprop("/consumables/fuel/tank[1]/level-norm",0.0);
	setprop("/consumables/fuel/tank[2]/level-norm",0.0);
	}

if (getprop("/sim/presets/stage") == 2) # we start with entry
	{
	setprop("/consumables/fuel/tank[0]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[1]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[2]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[3]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[4]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[5]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[6]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[7]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[8]/level-lbs",945.7);
	setprop("/consumables/fuel/tank[9]/level-lbs",606.8);
	setprop("/consumables/fuel/tank[10]/level-lbs",945.7);
	setprop("/consumables/fuel/tank[11]/level-lbs",606.8);
	setprop("/consumables/fuel/tank[12]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[13]/level-lbs",0.0);

	setprop("/fdm/jsbsim/systems/mechanical/vdoor-cmd", 0);


	}

if (getprop("/sim/presets/stage") == 3) # we start with the TAEM
	{
	SRB_message_flag = 2;
	settimer(set_speed, 0.5);
	SRB_separate_silent();
	gear_up();
	external_tank_separate_silent();
	setprop("/consumables/fuel/tank[0]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[1]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[2]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[3]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[4]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[5]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[6]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[7]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[8]/level-lbs",147.7);
	setprop("/consumables/fuel/tank[9]/level-lbs",92.8);
	setprop("/consumables/fuel/tank[10]/level-lbs",147.7);
	setprop("/consumables/fuel/tank[11]/level-lbs",92.8);
	setprop("/consumables/fuel/tank[12]/level-lbs",147.7);
	setprop("/consumables/fuel/tank[13]/level-lbs",92.8);

	setprop("/fdm/jsbsim/systems/mechanical/vdoor-cmd", 0);

	hydraulics_on();
	et_umbilical_door_close();

	# transfer controls to aero

	setprop("/fdm/jsbsim/systems/fcs/control-mode",29);
	setprop("/controls/shuttle/control-system-string", "Aerojet");
	setprop("/controls/shuttle/hud-mode",3);
	}



if (getprop("/sim/presets/stage") == 4) # we start with the final approach
	{
	SRB_message_flag = 2;
	settimer(set_speed, 0.5);
	SRB_separate_silent();
	gear_up();
	external_tank_separate_silent();
	setprop("/consumables/fuel/tank[0]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[1]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[2]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[3]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[4]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[5]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[6]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[7]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[8]/level-lbs",147.7);
	setprop("/consumables/fuel/tank[9]/level-lbs",92.8);
	setprop("/consumables/fuel/tank[10]/level-lbs",147.7);
	setprop("/consumables/fuel/tank[11]/level-lbs",92.8);
	setprop("/consumables/fuel/tank[12]/level-lbs",147.7);
	setprop("/consumables/fuel/tank[13]/level-lbs",92.8);

	hydraulics_on();
	et_umbilical_door_close();

	# transfer controls to aero

	setprop("/fdm/jsbsim/systems/fcs/control-mode",29);
	setprop("/controls/shuttle/control-system-string", "Aerojet");
	setprop("/controls/shuttle/hud-mode",3);
	}

if (getprop("/sim/presets/stage") == 5) # we start in a gliding test
	{
	SRB_message_flag = 2;
	settimer(set_speed, 0.5);
	SRB_separate_silent();
	gear_up();
	external_tank_separate_silent();
	setprop("/consumables/fuel/tank[0]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[1]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[2]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[3]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[4]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[5]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[6]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[7]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[8]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[9]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[10]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[11]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[12]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[13]/level-lbs",0.0);

	hydraulics_on();
	et_umbilical_door_close();

	# transfer controls to aero

	setprop("/fdm/jsbsim/systems/fcs/control-mode",29);
	setprop("/controls/shuttle/control-system-string", "Aerojet");
	setprop("/controls/shuttle/hud-mode",3);
	}

if (getprop("/sim/presets/stage") == 6) # we're in high orbit
	{
	setprop("/consumables/fuel/tank[0]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[1]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[2]/level-lbs",0.0);
	setprop("/consumables/fuel/tank[3]/level-lbs",0.0);

	et_umbilical_door_close();
	settimer(SpaceShuttle.init_iss, 5.0);

	setprop("/fdm/jsbsim/systems/mechanical/vdoor-cmd", 0);

	# transfer controls to RCS
	control_to_rcs();

	# open PBD
	pb_door_open();

	# deploy Ku-antenna
	ku_antenna_deploy();
	


	}
