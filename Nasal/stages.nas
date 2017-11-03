
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
var abort_region_flag = 0;



#aircraft.HUD.cycle_color();

settimer(func {setprop("/fdm/jsbsim/systems/electrical/init-electrical-on", 0.0);}, 30.0);


var ignition = func {

# the key command is overloaded, if the Shuttle is connected to the carrier aircraft
# this initiates the pitchdown sequence, otherwise if the Shuttle is in pre-launch mode
# it ignites the engines

if (getprop("/fdm/jsbsim/systems/carrier/connected") == 1)
	{
	SpaceShuttle.carrier_aircraft.carrier_pitch_target = -2.0;
	}
	
else if (getprop("/sim/config/shuttle/prelaunch-flag") == 1)
	{
	
	setprop("/controls/shuttle/spark-flag", 1);

	settimer( func {setprop("/controls/shuttle/spark-flag", 0);} , 2.5);


	settimer (pre_ignition, 2.0);

	settimer (full_ignition, 5.8);
	}

}

# pre-ignition governs the flame appearance during engine ramp-up

var pre_ignition = func {

# first engine

setprop("/fdm/jsbsim/systems/various/ssme-ignition-density-target", 0.1);
setprop("/fdm/jsbsim/systems/various/ssme-noise-strength-target", 0.5);


setprop("/fdm/jsbsim/systems/various/ssme-flame-r-base-target", 1.0);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-base-target", 0.4);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-base-target", 0.2);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-high-target", 1.0);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-high-target", 0.4);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-high-target", 0.2);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-low-target", 0.8);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-low-target", 0.25);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-low-target", 0.2);

# second engine

settimer(func {

setprop("/fdm/jsbsim/systems/various/ssme-ignition-density-target2", 0.1);
setprop("/fdm/jsbsim/systems/various/ssme-noise-strength-target2", 0.5);


setprop("/fdm/jsbsim/systems/various/ssme-flame-r-base-target2", 1.0);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-base-target2", 0.4);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-base-target2", 0.2);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-high-target2", 1.0);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-high-target2", 0.4);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-high-target2", 0.2);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-low-target2", 0.8);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-low-target2", 0.25);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-low-target2", 0.2);

}, 0.4);

# third engine

settimer(func {

setprop("/fdm/jsbsim/systems/various/ssme-ignition-density-target1", 0.1);
setprop("/fdm/jsbsim/systems/various/ssme-noise-strength-target1", 0.5);


setprop("/fdm/jsbsim/systems/various/ssme-flame-r-base-target1", 1.0);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-base-target1", 0.4);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-base-target1", 0.2);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-high-target1", 1.0);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-high-target1", 0.4);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-high-target1", 0.2);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-low-target1", 0.8);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-low-target1", 0.25);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-low-target1", 0.2);

}, 0.8);


# density rampup

settimer (func {setprop("/fdm/jsbsim/systems/various/ssme-ignition-density-target", 0.5);}, 0.5);
settimer (func {setprop("/fdm/jsbsim/systems/various/ssme-ignition-density-target2", 0.5);}, 0.9);
settimer (func {setprop("/fdm/jsbsim/systems/various/ssme-ignition-density-target1", 0.5);}, 1.3);


# first engine final

settimer(func {

setprop("/fdm/jsbsim/systems/various/ssme-ignition-density-target", 0.1);
setprop("/fdm/jsbsim/systems/various/ssme-flame-base-density-target", 2.0);
setprop("/fdm/jsbsim/systems/various/ssme-noise-strength-target", 0.15);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-base-target", 0.9);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-base-target", 1.0);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-base-target", 1.0);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-high-target", 0.7);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-high-target", 0.7);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-high-target", 1.0);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-low-target", 0.6);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-low-target", 0.4);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-low-target", 0.4);

}, 2.0);

# second engine final

settimer(func {

setprop("/fdm/jsbsim/systems/various/ssme-ignition-density-target2", 0.1);
setprop("/fdm/jsbsim/systems/various/ssme-flame-base-density-target2", 2.0);
setprop("/fdm/jsbsim/systems/various/ssme-noise-strength-target2", 0.15);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-base-target2", 0.9);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-base-target2", 1.0);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-base-target2", 1.0);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-high-target2", 0.7);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-high-target2", 0.7);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-high-target2", 1.0);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-low-target2", 0.6);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-low-target2", 0.4);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-low-target2", 0.4);

}, 2.4);

# third engine final

settimer(func {

setprop("/fdm/jsbsim/systems/various/ssme-ignition-density-target1", 0.1);
setprop("/fdm/jsbsim/systems/various/ssme-flame-base-density-target1", 2.0);
setprop("/fdm/jsbsim/systems/various/ssme-noise-strength-target1", 0.15);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-base-target1", 0.9);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-base-target1", 1.0);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-base-target1", 1.0);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-high-target1", 0.7);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-high-target1", 0.7);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-high-target1", 1.0);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-low-target1", 0.6);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-low-target1", 0.4);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-low-target1", 0.4);

}, 2.8);

#settimer (reset_flame, 8.0);

}


var reset_flame = func {

setprop("/fdm/jsbsim/systems/various/ssme-ignition-density-target", 0.0);
setprop("/fdm/jsbsim/systems/various/ssme-flame-base-density-target", 0.0);
setprop("/fdm/jsbsim/systems/various/ssme-noise-strength-target", 0.7);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-base-target", 1.0);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-base-target", 0.4);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-base-target", 0.2);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-high-target", 1.0);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-high-target", 0.4);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-high-target", 0.2);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-low-target", 0.8);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-low-target", 0.25);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-low-target", 0.2);

setprop("/fdm/jsbsim/systems/various/ssme-ignition-density-target1", 0.0);
setprop("/fdm/jsbsim/systems/various/ssme-flame-base-density-target1", 0.0);
setprop("/fdm/jsbsim/systems/various/ssme-noise-strength-target1", 0.7);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-base-target1", 1.0);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-base-target1", 0.4);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-base-target1", 0.2);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-high-target1", 1.0);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-high-target1", 0.4);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-high-target1", 0.2);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-low-target1", 0.8);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-low-target1", 0.25);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-low-target1", 0.2);

setprop("/fdm/jsbsim/systems/various/ssme-ignition-density-target2", 0.0);
setprop("/fdm/jsbsim/systems/various/ssme-flame-base-density-target2", 0.0);
setprop("/fdm/jsbsim/systems/various/ssme-noise-strength-target2", 0.7);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-base-target2", 1.0);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-base-target2", 0.4);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-base-target2", 0.2);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-high-target2", 1.0);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-high-target2", 0.4);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-high-target2", 0.2);

setprop("/fdm/jsbsim/systems/various/ssme-flame-r-low-target2", 0.8);
setprop("/fdm/jsbsim/systems/various/ssme-flame-g-low-target2", 0.25);
setprop("/fdm/jsbsim/systems/various/ssme-flame-b-low-target2", 0.2);


}







# full ignition does the FDM-relevant tasks for engine ignition

var full_ignition = func{
    launch_loop_flag = 0;

    setprop("/sim/config/shuttle/prelaunch-flag", 0);


    setprop("/fdm/jsbsim/systems/mps/engine[0]/run-cmd", 1);
    setprop("/fdm/jsbsim/systems/mps/engine[1]/run-cmd", 1);
    setprop("/fdm/jsbsim/systems/mps/engine[2]/run-cmd", 1);

    setprop("/controls/engines/engine[0]/throttle", 1.0);
    setprop("/controls/engines/engine[1]/throttle", 1.0);
    setprop("/controls/engines/engine[2]/throttle", 1.0);


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

SpaceShuttle.callout.make("Main engine ignition!", "info");


setprop("/controls/engines/engine[0]/ignited-hud","x");
setprop("/controls/engines/engine[1]/ignited-hud","x");
setprop("/controls/engines/engine[2]/ignited-hud","x");

# fill the feed lines
setprop("/consumables/fuel/tank[17]/level-lbs", 600.0);
setprop("/consumables/fuel/tank[18]/level-lbs",4800.0);

# if we trigger this function without SRB attached, we are resuming a powered flight state
# and do not zero MET or call SRB ignition

if (getprop("/controls/shuttle/SRB-attach") == 1) 
	{
	# init the SRB burn timer - will be overwritten later
	SRB_burn_timer = getprop("/sim/time/elapsed-sec");

	settimer(SRB_ignite, 1.0);

	# zero MET at engine ignition

	var elapsed = getprop("/sim/time/elapsed-sec");
	setprop("/fdm/jsbsim/systems/timer/delta-MET", -elapsed);
	}

settimer(gear_up, 5.0);
	
launch_loop_flag = 1;




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

if (SRB_fuel < 0.04)
	{
	setprop("/fdm/jsbsim/propulsion/srb-pc50-discrete", 1);
	}

if ((SRB_fuel < 0.01) and (SRB_message_flag == 1))
	{SRB_separate(); SRB_message_flag = 2;}

if ((t_elapsed > 34.0) and (launch_message_flag ==0) and (SRB_burn_timer >0.0))
	{
	SpaceShuttle.callout.make("t+34 s: throttle down!", "help");
	launch_message_flag = 1;
	}

if ((t_elapsed > 54.0) and (launch_message_flag ==1))
	{
	SpaceShuttle.callout.make("t+54 s: throttle up!", "help");
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
			SpaceShuttle.callout.make("Engine "~(i+1)~" flameout!", "failure");
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


var engine_fail_time = getprop("/fdm/jsbsim/systems/abort/engine-fail-time");

var regular_meco = getprop("/fdm/jsbsim/systems/ap/launch/regular-meco-condition");

if (thrust_engine1 > 0.0)
	{
	setprop("/controls/engines/engine[0]/ignited-hud","x");
	}
else
	{
	setprop("/controls/engines/engine[0]/ignited-hud"," ");
	if ((engine_fail_time < 0.0) and (regular_meco == 0))
		{
		setprop("/fdm/jsbsim/systems/abort/engine-fail-time", t_elapsed);
		var vi = getprop("/fdm/jsbsim/velocities/eci-velocity-mag-fps");
		setprop("/fdm/jsbsim/systems/abort/engine-fail-string", "1ST EO VI "~int(vi));
		}
	}

if (thrust_engine2 > 0.0)
	{
	setprop("/controls/engines/engine[1]/ignited-hud","x");
	}
else
	{
	setprop("/controls/engines/engine[1]/ignited-hud"," ");
	if ((engine_fail_time < 0.0) and (regular_meco == 0))
		{
		setprop("/fdm/jsbsim/systems/abort/engine-fail-time", t_elapsed);
		var vi = getprop("/fdm/jsbsim/velocities/eci-velocity-mag-fps");
		setprop("/fdm/jsbsim/systems/abort/engine-fail-string", "1ST EO VI "~int(vi));
		}
	}
if (thrust_engine3 > 0.0)
	{
	setprop("/controls/engines/engine[2]/ignited-hud","x");
	}
else
	{
	setprop("/controls/engines/engine[2]/ignited-hud"," ");
	if ((engine_fail_time < 0.0) and (regular_meco == 0))
		{
		setprop("/fdm/jsbsim/systems/abort/engine-fail-time", t_elapsed);
		var vi = getprop("/fdm/jsbsim/velocities/eci-velocity-mag-fps");
		setprop("/fdm/jsbsim/systems/abort/engine-fail-string", "1ST EO VI "~int(vi));
		}
	}


var n_eng_operational = getprop("/fdm/jsbsim/systems/mps/number-engines-operational");
var engine2_fail_time = getprop("/fdm/jsbsim/systems/abort/engine2-fail-time");

if ((n_eng_operational < 2) and (engine2_fail_time < 0.0))
	{
	setprop("/fdm/jsbsim/systems/abort/engine2-fail-time", t_elapsed);
	var vi = getprop("/fdm/jsbsim/velocities/eci-velocity-mag-fps");
	setprop("/fdm/jsbsim/systems/abort/engine2-fail-string", "2ND EO VI "~int(vi));
	
	# switch SERC on if we have SRBs disconnected

	if (SRB_message_flag == 2)
		{
		setprop("/fdm/jsbsim/systems/fcs/control-mode",13);
		setprop("/controls/shuttle/control-system-string", "SERC");
		}
	}

if ((n_eng_operational == 0) and (regular_meco == 0))
	{
	SpaceShuttle.contingency_abort_init_3eo();
	launch_loop_flag = 0;
	orbital_loop_init();
	}


if ((thrust_engine1 == 0.0) and (thrust_engine2 == 0.0) and (thrust_engine3 == 0.0))
	{
	SpaceShuttle.light_manager.set_theme("CLEAR");


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

# automatically switch Earthview on

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
	


settimer(SpaceShuttle.adjust_effect_colors, 0.2);
settimer(SpaceShuttle.cloud_illumination, 0.2);
settimer(SpaceShuttle.update_ascent_predictors, 0.4);
settimer(SpaceShuttle.update_timers, 0.4);
settimer(SpaceShuttle.compare_bfs_pass, 0.5);
settimer(SpaceShuttle.contingency_abort_region_2eo, 0.6);
settimer(SpaceShuttle.contingency_abort_region_3eo, 0.7);
settimer(SpaceShuttle.cws_inspect, 0.8);
settimer(SpaceShuttle.cws_inspect_mps, 0.5);







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

var hyd_pressurized = getprop("/fdm/jsbsim/systems/apu/number-systems-pressurized");

if ((thrust1 > 400000.0) and (thrust2 > 400000.0) and (thrust3 > 400000.0) and (hyd_pressurized == 3)) # we're go
	{
	#setprop("/sim/messages/copilot", "SRB ignition!");
	SpaceShuttle.callout.make("SRB ignition!", "info");
	setprop("/controls/engines/engine[3]/throttle", 1.0);
	setprop("/controls/engines/engine[4]/throttle", 1.0);
	setprop("/sim/model/effects/launch-smoke",1);

	setprop("/controls/engines/engine[3]/ignited-hud","x");
	setprop("/controls/engines/engine[4]/ignited-hud","x");

	settimer(launch_smoke_off,1.5);

	SRB_burn_timer = getprop("/sim/time/elapsed-sec");

	# make an automatic transtion to MM 102
	setprop("/fdm/jsbsim/systems/dps/major-mode", 102);	
	setprop("/fdm/jsbsim/systems/dps/major-mode-bfs", 102);	

	# reset engine fail timer to init

	setprop("/fdm/jsbsim/systems/abort/engine-fail-time", -1.0);
	setprop("/fdm/jsbsim/systems/abort/engine-fail-string", "");
	
	# set SRB flame light effect

	SpaceShuttle.light_manager.set_theme("SRB");
	setprop("/environment/lightning/flash", 2);
	setprop("/local-weather/lightning/model-index", -1);


	# store launch site information for PEG-4 in case we don't launch from KSC

	SpaceShuttle.peg4_refloc.set_latlon(getprop("/position/latitude-deg"), getprop("/position/longitude-deg"));

	# if we have liftoff, switch autolaunch on if configured
	# notify CWS that we have guidance and want to message every engine shutdown prior to MECO
	
	if (getprop("/fdm/jsbsim/systems/ap/launch/autolaunch-master") == 1)
		{
		SpaceShuttle.auto_launch_loop();
   		setprop("/fdm/jsbsim/systems/ap/launch/regular-meco-condition",0);
		}

	# if we have shaking, start script

	if (getprop("/sim/config/shuttle/srb-shake") == 1)
		{
		srb_view_shake_loop();
		}



	}
else
	{
	SpaceShuttle.callout.make("Launchpad abort!", "failure");
	#setprop("/sim/messages/copilot", "Launchpad abort!");
	setprop("/controls/engines/engine[0]/throttle", 0.0);
	setprop("/controls/engines/engine[1]/throttle", 0.0);
	setprop("/controls/engines/engine[2]/throttle", 0.0);
   	setprop("/fdm/jsbsim/systems/mps/engine[0]/run-cmd", 0);
   	setprop("/fdm/jsbsim/systems/mps/engine[1]/run-cmd", 0);
    	setprop("/fdm/jsbsim/systems/mps/engine[2]/run-cmd", 0);
	setprop("/controls/engines/engine[0]/ignited-hud"," ");
	setprop("/controls/engines/engine[1]/ignited-hud"," ");
	setprop("/controls/engines/engine[2]/ignited-hud"," ");
	launch_loop_flag = 0;
	}

}


var srb_view_shake_loop = func {

var view = getprop("/sim/current-view/name");

if (SRB_message_flag == 2) 
	{
	return;
	}

if (view == "Cockpit View")
	{
	setprop("/sim/current-view/x-offset-m", -0.6 + 0.006 * (rand() - 0.5));
	setprop("/sim/current-view/y-offset-m", -0.17 + 0.006 * (rand() - 0.5));
	setprop("/sim/current-view/z-offset-m", -11.6 + 0.006 * (rand() - 0.5));
	}
else if (view == "Pilot")
	{
	setprop("/sim/current-view/x-offset-m", 0.7 + 0.006 * (rand() - 0.5));
	setprop("/sim/current-view/y-offset-m", -0.13 + 0.006 * (rand() - 0.5));
	setprop("/sim/current-view/z-offset-m", -11.7 + 0.006 * (rand() - 0.5));
	}

settimer(srb_view_shake_loop, 0.0);

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

SpaceShuttle.callout.make("Prepare for SRB separation!", "help");
#setprop("/sim/messages/copilot", "Prepare for SRB separation!");

}

var MECO_warn = func {

if (getprop("/fdm/jsbsim/systems/dps/ops") == 1)
	{
	#setprop("/sim/messages/copilot", "Prepare for MECO!");
	SpaceShuttle.callout.make("Prepare for MECO!", "help");
	}

}

var orbit_warn = func {

#setprop("/sim/messages/copilot", "Reduce throttle and prepare  orbital insertion!");
SpaceShuttle.callout.make("Reduce throttle and prepare  orbital insertion!", "help");
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


setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[3]", 0.0);
setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[4]", 0.0);



setprop("/controls/engines/engine[3]/status-hud", "X");
setprop("/controls/engines/engine[4]/status-hud", "X");

setprop("/controls/engines/engine[3]/ignited-hud", " ");
setprop("/controls/engines/engine[4]/ignited-hud", " ");



#setprop("/sim/messages/copilot", "SRB separation!");
SpaceShuttle.callout.make("SRB separation!", "info");

# end lighting

SpaceShuttle.light_manager.set_theme("SSME");
setprop("/environment/lightning/flash", 0);

# make an automatic transtion to MM 103
setprop("/fdm/jsbsim/systems/dps/major-mode", 103);
setprop("/fdm/jsbsim/systems/dps/major-mode-bfs", 103);	

# switch SERC on if we have just one engine at this point

var n_eng_operational = getprop("/fdm/jsbsim/systems/mps/number-engines-operational");
var arm_serc = getprop("/fdm/jsbsim/systems/abort/arm-serc");



if ((n_eng_operational < 2) or (arm_serc == 1))
	{
	setprop("/fdm/jsbsim/systems/fcs/control-mode",13);
	setprop("/controls/shuttle/control-system-string", "SERC");
	setprop("/fdm/jsbsim/systems/abort/arm-serc",0);
	}

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

# start main orbital loop
#orbital_loop_init();

}

####################################################################################
# Explicit external tank separation using a Nasal controlled submodel
####################################################################################

var external_tank_separate = func {


# the key is overloaded with disconnecting from the carrier aircraft

if (getprop("/fdm/jsbsim/systems/carrier/connected") == 1)
	{
	SpaceShuttle.carrier_aircraft.disconnect();
	}


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
	#setprop("/sim/messages/copilot", "Unsafe attitude for ET separation, reduce rotation rates.");	
	SpaceShuttle.callout.make("Unsafe attitude for ET separation, reduce rotation rates.", "help");
	SpaceShuttle.create_fault_message("    ET SEP INH  ", 1, 2);	
	return;
	}

force_external_tank_separate();

}

var force_external_tank_separate = func {

# the command is overloaded with disconnecting from the carrier aircraft

if (getprop("/fdm/jsbsim/systems/carrier/connected") == 1)
	{
	SpaceShuttle.carrier_aircraft.disconnect();
	}


if (SRB_message_flag < 2)
	{	
	SpaceShuttle.callout.make("Can't separate tank while SRBs are connected!", "help");
	#setprop("/sim/messages/copilot", "Can't separate tank while SRBs are connected!");
	return;
	}

setprop("/controls/shuttle/et-separation", 1);

# we can drop the tank only once
if (getprop("/controls/shuttle/ET-static-model") == 0) {return;}

setprop("/consumables/fuel/tank[0]/level-norm",0.0);

setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[1]", 0.0);
setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[2]", 0.0);

#setprop("/sim/messages/copilot", "External tank separation!");
SpaceShuttle.callout.make("External tank separation!", "info");

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

# start main orbital loop
orbital_loop_init();

}

var control_to_rcs = func {

var stage = getprop("/sim/presets/stage");

if ((stage == 3) or (stage ==4) or (stage == 5)){return;}

# transfer controls to RCS

if (stage == 6)
	{
	SpaceShuttle.orbital_dap_manager.load_dap("ORBIT");
	}
else
	{
	SpaceShuttle.orbital_dap_manager.load_dap("TRANSITION");
	}
#setprop("/sim/messages/copilot", "Control switched to RCS.");
SpaceShuttle.callout.make("Control switched to RCS.", "info");


# transfer thrust control to OMS - this is not realistic but kept for testing purposes

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

var orbital_loop_running = 0;

var orbital_loop_init = func {

if (orbital_loop_running == 1) {return;}
else
	{
	orbital_loop_running = 1;
	orbital_loop();
	}

}


var orbital_loop = func {


#print ("Orbital loop running!");

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

#print ("Alt is now: ", alt);

if (alt < 400000.0)
	{



	var periapsis = getprop("/fdm/jsbsim/systems/orbital/periapsis-indicated-km");
	
	#print ("Checking EI - periapsis is now:", periapsis);	

	if (periapsis < 100.0)
		{
		#setprop("/sim/messages/copilot", "Entry Interface reached.");
		SpaceShuttle.callout.make("Entry Interface reached.", "info");
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
settimer(SpaceShuttle.compare_bfs_pass, 0.7);

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




var current_mode = getprop("/fdm/jsbsim/systems/fcs/control-mode");


if (current_mode ==0)
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
	#setprop("/sim/messages/copilot", "MMU rotation");
	SpaceShuttle.callout.make("MMU rotation", "essential");
	}
else if (current_mode == 51)
	{
	setprop("/fdm/jsbsim/systems/fcs/control-mode",50);
	#setprop("/sim/messages/copilot", "MMU translation");
	SpaceShuttle.callout.make("MMU translation", "essential");
	}
else
	{
	SpaceShuttle.orbital_dap_manager.toggle_input_device();
	}

	
}






###########################################################################
# the deorbit loop primarily checks when to transfer control authority from
# RCS to the airfoils
###########################################################################


var deorbit_loop = func {

#print("Deorbit loop running...");

var qbar = getprop("/fdm/jsbsim/aero/qbar-psf");

if ((qbar > 10.0) and (deorbit_stage_flag == 0))
	{
	#setprop("/fdm/jsbsim/systems/fcs/control-mode",3);
	if (getprop("/fdm/jsbsim/systems/fcs/control-mode") == 24)
		{setprop("/controls/shuttle/control-system-string", "RCS / Aero");}
	setprop("/fdm/jsbsim/systems/fcs/rcs-roll-mode", 0);
	SpaceShuttle.callout.make("Roll control to aero.", "info");
	#setprop("/sim/messages/copilot", "Roll control to aero.");
	deorbit_stage_flag = 1;
	}

if ((qbar > 40.0) and   (deorbit_stage_flag == 1))
	{
	setprop("/fdm/jsbsim/systems/fcs/rcs-pitch-mode", 0);
	SpaceShuttle.callout.make("Pitch control to aero.", "info");
	#setprop("/sim/messages/copilot", "Pitch control to aero.");
	deorbit_stage_flag = 2;
	}

if ((getprop("/fdm/jsbsim/velocities/mach") < 3.5) and (deorbit_stage_flag == 2))
	{
	setprop("/fdm/jsbsim/systems/fcs/rcs-yaw-mode", 0);
	setprop("/fdm/jsbsim/systems/fcs/no-y-jet", 0);
	if (getprop("/fdm/jsbsim/systems/fcs/control-mode") == 24)
		{
		setprop("/fdm/jsbsim/systems/fcs/control-mode",4);	
		setprop("/controls/shuttle/control-system-string", "Aerodynamical");
		}
	#setprop("/sim/messages/copilot", "Yaw control to aero.");
	SpaceShuttle.callout.make("Yaw control to aero.", "info");
	deorbit_stage_flag = 3;
	}

# if temperature > 2000 F, switch light manager on - it will just ignore command if already on and
# exit once T < 2000 F by itself

if (getprop("/fdm/jsbsim/systems/thermal/nose-temperature-F") > 2000.0)
	{
	SpaceShuttle.light_manager.set_theme("ENTRY");
	}

# open vent doors as soon as vrel < 2400 fps is sensed

if (getprop("/fdm/jsbsim/velocities/vtrue-fps") < 2400.0)
	{
	setprop("/fdm/jsbsim/systems/mechanical/vdoor-cmd", 1);
	}

# in the late entry phase, check whether we pick up TACAN signals

SpaceShuttle.area_nav_set.update_entry();




# determine whether we have reached TAEM interface
# we may reach it under guidance, then it's best driven by distance
# or during a contingency abort, then by altitude/ speed
# in general this is a tricky decision

var Nz_hold = getprop("/fdm/jsbsim/systems/ap/grtls/Nz-hold-active");

if (((getprop("/position/altitude-ft") < 85000.0) or (getprop("/fdm/jsbsim/velocities/mach") <2.5)) and (deorbit_stage_flag == 3) and (Nz_hold == 0) )
	{
	#setprop("/sim/messages/copilot", "TAEM interface reached.");
	SpaceShuttle.callout.make("TAEM interface reached.", "info");
	setprop("/controls/shuttle/hud-mode",3);

	if (getprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode") > 0)
		{
		SpaceShuttle.compute_TAEM_guidance_targets();
		}

	if (SpaceShuttle.TAEM_guidance_available == 0)
		{
		#setprop("/sim/messages/copilot", "No TAEM guidance available, take CSS!");
		SpaceShuttle.callout.make("No TAEM guidance available, take CSS!", "help");
		setprop("/fdm/jsbsim/systems/ap/automatic-pitch-control", 0);
		setprop("/fdm/jsbsim/systems/ap/css-pitch-control", 1);
		setprop("/fdm/jsbsim/systems/ap/automatic-roll-control", 0);
		setprop("/fdm/jsbsim/systems/ap/css-roll-control", 1);
		}
	else
		{
		if (getprop("/fdm/jsbsim/systems/dps/major-mode") == 602)
			{
			setprop("/fdm/jsbsim/systems/dps/major-mode", 603);
			SpaceShuttle.ops_transition_auto("p_vert_sit");
			}
		}

	glide_loop();
	return;
	}

# switch to TAEM guidance 80 miles to site if we're under entry guidance
# we never do this for a contingency abort

if (getprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode") >0)
	{
	SpaceShuttle.update_entry_guidance();

	var d_remain = getprop("/fdm/jsbsim/systems/entry_guidance/remaining-distance-nm");
	var abort_mode = getprop("/fdm/jsbsim/systems/abort/abort-mode");


	if ((d_remain < 80.0) and (abort_mode < 5) and (Nz_hold == 0))
		{
		SpaceShuttle.compute_TAEM_guidance_targets();
		glide_loop();

		#setprop("/sim/messages/copilot", "TAEM interface reached.");
		SpaceShuttle.callout.make("TAEM interface reached.", "info");
		setprop("/controls/shuttle/hud-mode",3);

		# transit to MM 305 if we're not flying RTLS, otherwise the RTLS loop
		# handles the transition

		if (getprop("/fdm/jsbsim/systems/dps/major-mode") == 304)
			{
			setprop("/fdm/jsbsim/systems/dps/major-mode", 305);
			SpaceShuttle.dk_listen_major_mode_transition(305);
			SpaceShuttle.ops_transition_auto("p_vert_sit");
			}

		return;
		}



	}

SpaceShuttle.check_limits_entry();

settimer(SpaceShuttle.update_sv_errors_entry, 0.1);
settimer(SpaceShuttle.update_timers, 0.4);
settimer(SpaceShuttle.compare_bfs_pass, 0.5);

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

# print (getprop("/fdm/jsbsim/systems/thermal/nose-temperature-K"));

settimer(SpaceShuttle.adjust_effect_colors, 0.2);
settimer(SpaceShuttle.cws_inspect, 0.3);

settimer(deorbit_loop,1.0);
}


###########################################################################
# the glide loop watches limits during descent
###########################################################################

var gear_arm_message_flag = 0;

var glide_loop = func {

#print ("Glide loop running...");

SpaceShuttle.update_entry_guidance();

var d_remain = getprop("/fdm/jsbsim/systems/entry_guidance/remaining-distance-nm");

if ((d_remain < 90.0) and (SpaceShuttle.TAEM_guidance_available == 0))
	{
	SpaceShuttle.compute_TAEM_guidance_targets();
	}


var alt = getprop("/position/altitude-agl-ft");

if ((alt < 2100.0) and (gear_arm_message_flag == 0))
	{
	#setprop("/sim/messages/copilot", "2000 ft - arm gear!");
	SpaceShuttle.callout.make("2000 ft - arm gear!", "help");
	gear_arm_message_flag = 1;
	}

# open vent doors as soon as vrel < 2400 fps is sensed

if (getprop("/fdm/jsbsim/velocities/vtrue-fps") < 2400.0)
	{
	setprop("/fdm/jsbsim/systems/mechanical/vdoor-cmd", 1);
	}

SpaceShuttle.check_limits_glide();

# check whether we need to end Earthview

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


# check for TACAN or MLS signals

SpaceShuttle.area_nav_set.update_taem();

# update the state vector error set

settimer(SpaceShuttle.update_sv_errors_entry, 0.1);

# run CWS checks

settimer(SpaceShuttle.cws_inspect, 0.2);
settimer(SpaceShuttle.update_timers, 0.4);
settimer(SpaceShuttle.compare_bfs_pass, 0.5);

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

var speedbrake_state = getprop("/fdm/jsbsim/systems/fcs/speedbrake-cmd-norm");

speedbrake_state = speedbrake_state+ 0.2;
if (speedbrake_state > 1.0) {speedbrake_state = 1.0;}

setprop("/fdm/jsbsim/systems/fcs/speedbrake-cmd-norm", speedbrake_state);

if (rand() > SpaceShuttle.failure_cmd.speedbrake)
	{
	SpaceShuttle.failure_cmd.speedbrake = 0;
	return;
	}



setprop("/controls/shuttle/speedbrake", speedbrake_state);

if (speedbrake_state == 1.0) {speedbrake_string = "out";}
else {speedbrake_string = int(speedbrake_state * 100.0)~"%";}

setprop("/controls/shuttle/speedbrake-string", speedbrake_string);
}

var decrease_speedbrake = func {

var speedbrake_state = getprop("/fdm/jsbsim/systems/fcs/speedbrake-cmd-norm");

speedbrake_state = speedbrake_state - 0.2;
if (speedbrake_state < 0.0) {speedbrake_state = 0.0;}

setprop("/fdm/jsbsim/systems/fcs/speedbrake-cmd-norm", speedbrake_state);

if (rand() > SpaceShuttle.failure_cmd.speedbrake)
	{
	SpaceShuttle.failure_cmd.speedbrake = 0;
	return;
	}



setprop("/controls/shuttle/speedbrake", speedbrake_state);

if (speedbrake_state == 0.0) {speedbrake_string = "in";}
else {speedbrake_string = int(speedbrake_state * 100.0)~"%";}

setprop("/controls/shuttle/speedbrake-string", speedbrake_string);
}

# gear retraction message

var gear_up_message = func {

#setprop("/sim/messages/copilot", "The gear can only be retracted by the ground crew!");
SpaceShuttle.callout.make("The gear can only be retracted by the ground crew!", "help");
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

var state = getprop("/fdm/jsbsim/systems/landing/landing-gear-arm-cmd");
var deploy = getprop("/fdm/jsbsim/gear/gear-pos-norm");

if (state == 0)
	{
	setprop("/fdm/jsbsim/systems/landing/landing-gear-arm-cmd", 1);
	setprop("/controls/shuttle/gear-string", "armed");
	}
else if (deploy == 0)
	{
	setprop("/fdm/jsbsim/systems/landing/landing-gear-arm-cmd", 0);
	setprop("/controls/shuttle/gear-string", "up");
	}
}


var gear_down = func {

var arm = getprop("/fdm/jsbsim/systems/landing/landing-gear-arm-cmd");
var state = getprop("/controls/gear/gear-down-cmd");

if ((arm == 1) and (state == 1))
	{
	setprop("/controls/gear/gear-down", 1);
	}

}



# HUD declutter

var declutter = func {

var dclt = getprop("/fdm/jsbsim/systems/hud/declutter-level");
dclt = dclt + 1;
if (dclt > 3) {dclt = 0;}
setprop("//fdm/jsbsim/systems/hud/declutter-level", dclt);

}


# cutoff switches for SSME

var ssme_cutoff = func (n) {
#print ("Engine ", n, " cutoff command received!");

setprop("/fdm/jsbsim/systems/mps/engine["~n~"]/run-cmd", 0);



}

# lockup - engine can no longer be throttled

var ssme_lockup = func (n) {

    # if we resume the state, we need to disable the check to prevent
    # immediate lockup
    # init-hydraulics on will be set for 10 seconds during which no lockup will register

    if (getprop("/fdm/jsbsim/systems/apu/init-hydraulics-on") == 1)
	{
	return;
	}

    print ("SSME lockup ", n);

    var number = 0;

    if (n==0) {number = 2; SpaceShuttle.failure_cmd.ssme1 = 0;}
    if (n==1) {number = 3; SpaceShuttle.failure_cmd.ssme2 = 0;}
    if (n==2) {number = 1; SpaceShuttle.failure_cmd.ssme3 = 0;}

    if (lockup_message_flag == 0)
        {
        #setprop("/sim/messages/copilot", "Lockup of engine "~number~"!");
	SpaceShuttle.callout.make("Lockup of engine "~number~"!", "failure");
        lockup_message_flag =1;
        }
    setprop("/sim/input/selected/engine["~n~"]",0);
}

# drag chute management - deployment and jettison animation


var arm_drag_chute = func {

    var state = getprop("/controls/shuttle/drag-chute-arm");
    
    if (state == 0) {state = 1;}
    else {state = 0;}

    setprop("/controls/shuttle/drag-chute-arm", state);
}

var jettison_drag_chute = func {

    # don't jettison undeployed chute
    if (getprop("/controls/shuttle/drag-chute-deploy-timer") == 0) {return;}

    # don't jettison jettisoned chute

    if (getprop("/controls/shuttle/drag-chute-jettison") == 1) {return;}

    setprop("/controls/shuttle/drag-chute-jettison", 1);
    setprop("/controls/shuttle/drag-chute-string", "jettisoned");
    drag_chute_jettison_animation(0.0);
}

var deploy_chute = func {

    var wheels_down = 0;
    if (getprop("/fdm/jsbsim/gear/unit[1]/WOW") and getprop("/fdm/jsbsim/gear/unit[2]/WOW")) {
        wheels_down = 1;
    }
    if (wheels_down==0) {
        #setprop("/sim/messages/copilot", "Chute can only be deployed after touchdown!");
	SpaceShuttle.callout.make("Chute can only be deployed after touchdown!", "help");
        return;
    }

    var chute_armed = getprop("/controls/shuttle/drag-chute-arm");
    if (chute_armed == 0) {
        #setprop("/sim/messages/copilot", "Chute can only be deployed if armed!");
	SpaceShuttle.callout.make("Chute can only be deployed if armed!", "help");
            return;
    }

    var current_state = getprop("/controls/shuttle/parachute");
    if (current_state == 0) {
            setprop("/controls/shuttle/parachute",1);
            setprop("/controls/shuttle/drag-chute-deploy", 1);
            SpaceShuttle.check_limits_touchdown();
            if (getprop("/fdm/jsbsim/systems/failures/drag-chute-condition") == 0.0) {
                setprop("/controls/shuttle/drag-chute-jettison", 1);
		drag_chute_jettison_animation(0.0);
            }
    }

    # automatically open chute to full after 3.5 seconds

    settimer( open_chute_full, 3.5);


    setprop("/controls/shuttle/drag-chute-string", "deployed");
}


var open_chute_full = func {

	if (getprop("/controls/shuttle/drag-chute-jettison") == 0)
		{
        	setprop("/controls/shuttle/parachute",2);
		}

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
    var state = getprop("/controls/shuttle/drag-chute-deploy");
    if (state == 1)
    	{chute_deploy_timer.start();}
});




var drag_chute_jettison_animation = func (time) {

var dt = getprop("/sim/time/delta-sec");
time = time + dt;

# horizontal motion

var x = 0.0;

if (time > 2.0)
	{x = -16.0 + 20.0 * time;}
else
	{x = 2.0 * time + 5.0 * time * time;}


setprop("/controls/shuttle/drag-chute-dist",x);

# vertical motion

var y = 0.0;
if (time > 5.0)
	{
	y = -2.5 + 0.6 * (time-5.0) * (time-5.0);
	}
else 	
	{
	y = -0.2 * time;
	}
if (y > 12.5) {y=12.5;}

setprop("/controls/shuttle/drag-chute-down",y);

# fold

var f = 0.5 * time;
if (f> 1.0) {f = 1.0;}
if (time > 9.5)
	{f = 0.25 + 1.5 + (time-9.5);}
if (time > 6.0)
	{
 	f = f -0.3* (time-7.0); 
	if (f<0.1) {f=0.1;}
	}
setprop("/controls/shuttle/drag-chute-fold", f);

# rotate

var r = (time - 2.0) * 18.0;
if (r>90.0) {r=90.0;}
if (r<0.0) {r=0.0;}
setprop("/controls/shuttle/drag-chute-slant", r);

# bend

var b = 0;
if (time > 7.5)
	{b = 0;}
else if (time >6.0)
	{b = 0.75 - 0.5 * (time - 6.0);} 
else if (time > 4.5) 
	{b = (time - 4.5) * 0.5;}
else {b=0;}	

setprop("/controls/shuttle/drag-chute-bend", b);

if (time > 10.0) 
	{
	print("Exiting...");
	settimer (func { setprop("/controls/shuttle/drag-chute-deploy-timer", 0); }, 0.5);
	return;
	}

setprop("/test/timer", time);

settimer( func{ drag_chute_jettison_animation (time); }, 0);

}


# BFS takeover button

var bfs_takeover = func {

var bfs_gpc = SpaceShuttle.nbat.what_gpc_provides("BFS");

if (bfs_gpc == -1) # we don't run BFS
	{return;}

if (SpaceShuttle.gpc_array[bfs_gpc -1].output_switch < 1) # BFS GPC is not in backup and can't output
	{return;}


# slave the selected IDPs to BFS

var crt_select = getprop("/fdm/jsbsim/systems/dps/bfs/crt-select-switch");



var idp_index_A = 2;
var idp_index_B = 0;

if (crt_select == 1)
	{
	idp_index_A = 1;
	idp_index_B = 2;
	}
else if (crt_select == 2)
	{
	idp_index_A = 0;
	idp_index_B = 1;
	}


SpaceShuttle.idp_array[idp_index_A].set_function(4);
SpaceShuttle.idp_array[idp_index_B].set_function(4);



SpaceShuttle.nbat.crt[idp_index_A] = bfs_gpc;
SpaceShuttle.nbat.crt[idp_index_B] = bfs_gpc;

SpaceShuttle.nbat.apply_crt();

SpaceShuttle.page_select (idp_index_A, "p_dps");
SpaceShuttle.page_select (idp_index_B, "p_dps");

# mode the non-BFS GPCs into software-controlled standby

foreach (g; SpaceShuttle.gpc_array)
	{
	if (g.major_function != "BFS")
		{
		g.set_mode(1);
		}
	}


# let BFS assume control of the Shuttle

setprop("/fdm/jsbsim/systems/dps/bfs-in-control", 1);
SpaceShuttle.bfs_in_control = 1;

setprop("/fdm/jsbsim/systems/dps/bfs/bfc-light-status",1);

print ("Backup flight system in control!");

SpaceShuttle.gpc_manager.to_bfs();

# if we're in OPS 1, lock DAP to AUTO, else into MAN

if (getprop("/fdm/jsbsim/systems/dps/ops") == 1)
	{
	setprop("/fdm/jsbsim/systems/ap/automatic-pitch-control", 1);
	setprop("/fdm/jsbsim/systems/ap/css-pitch-control", 0);
	setprop("/fdm/jsbsim/systems/ap/automatic-roll-control", 1);
	setprop("/fdm/jsbsim/systems/ap/css-roll-control", 0);
	}
else
	{
	setprop("/fdm/jsbsim/systems/ap/automatic-pitch-control", 0);
	setprop("/fdm/jsbsim/systems/ap/css-pitch-control", 1);
	setprop("/fdm/jsbsim/systems/ap/automatic-roll-control", 0);
	setprop("/fdm/jsbsim/systems/ap/css-roll-control", 1);
	}


}


# BFS CRT switch

var bfs_crt = func (state) {

if (SpaceShuttle.bfs_in_control == 1) {return;}


var bfs_gpc = SpaceShuttle.nbat.what_gpc_provides("BFS");
var crt_select = getprop("/fdm/jsbsim/systems/dps/bfs/crt-select-switch");

var idp_index = 2;

if (crt_select == 1)
	{idp_index = 1;}
else if (crt_select == 2)
	{idp_index = 0;}

# print (state, " ", idp_index, " ", crt_select);

if (state == 1)
	{

	if (bfs_gpc == -1) {return;}

	SpaceShuttle.idp_array[idp_index].set_function(4);
	SpaceShuttle.nbat.crt[idp_index] = bfs_gpc;
	SpaceShuttle.nbat.apply_crt();
	SpaceShuttle.page_select (idp_index, "p_dps");
	}


else 	
	{
	SpaceShuttle.idp_array[idp_index].set_function(1);
	SpaceShuttle.nbat.crt[idp_index] = idp_index+1;
	SpaceShuttle.nbat.apply_crt();
	SpaceShuttle.page_select (idp_index, "p_dps");
	}


}



# BFS disengage

var bfs_disengage = func {

# both PASS and BFS need to be in MM 301

if (SpaceShuttle.dps_simulation_detail_level == 1)
	{

	var mm_pass = getprop("/fdm/jsbsim/systems/dps/major-mode");
	var mm_bfs = getprop("/fdm/jsbsim/systems/dps/major-mode-bfs");

	if (mm_pass != 301) {return;}
	if (mm_bfs != 301) {return;}

	}



# let PASS assume control of the Shuttle

setprop("/fdm/jsbsim/systems/dps/bfs-in-control", 0);
SpaceShuttle.bfs_in_control = 0;

setprop("/fdm/jsbsim/systems/dps/bfs/bfc-light-status",0);
setprop("/fdm/jsbsim/systems/dps/bfs/bfs-transient-error", 1);

print ("Primary avionics system software in control!");

# register the correct data bus output state

foreach (g; SpaceShuttle.gpc_array)
	{
	g.adjust_output();
	}

# switch all MDUs back to PASS, then query the BFS switch pos

SpaceShuttle.nbat.crt[0] = SpaceShuttle.nbat.g3_crt[0];
SpaceShuttle.nbat.crt[1] = SpaceShuttle.nbat.g3_crt[1];
SpaceShuttle.nbat.crt[2] = SpaceShuttle.nbat.g3_crt[2];
SpaceShuttle.nbat.crt[3] = SpaceShuttle.nbat.g3_crt[3];
SpaceShuttle.nbat.apply_crt();

SpaceShuttle.idp_array[0].set_function(getprop("/fdm/jsbsim/systems/dps/idp-function-switch[0]"));
SpaceShuttle.idp_array[1].set_function(getprop("/fdm/jsbsim/systems/dps/idp-function-switch[1]"));
SpaceShuttle.idp_array[2].set_function(getprop("/fdm/jsbsim/systems/dps/idp-function-switch[2]"));
SpaceShuttle.idp_array[3].set_function(getprop("/fdm/jsbsim/systems/dps/idp-function-switch[3]"));

bfs_crt(getprop("/fdm/jsbsim/systems/dps/bfs/display-switch"));

}




#########################################################
# the slowdown loop checks for wheels stop
#########################################################

var slowdown_loop_start = func {

if ((getprop("/gear/gear[1]/wow") == 0) or (slowdown_loop_flag ==1)) {return;}

SpaceShuttle.callout.make("Touchdown!", "info");
slowdown_loop_flag = 1;
slowdown_loop();

if (SpaceShuttle.approach.trainer_active == 1)
	{
	SpaceShuttle.approach.mark_touchdown();
	}

setprop("/controls/shuttle/speedbrake", 1);
setprop("/fdm/jsbsim/systems/fcs/speedbrake-cmd-norm", 1);
setprop("/controls/shuttle/speedbrake-string", "out");


}

var slowdown_loop = func {

if ((getprop("/gear/gear[0]/wow") == 1) and (WONG_message_flag == 0))
	{
	#setprop("/sim/messages/copilot", "Weight on nose gear.");
	SpaceShuttle.callout.make("Weight on nose gear.", "real");
	WONG_message_flag = 1;
	}

if ((getprop("/gear/gear[1]/rollspeed-ms") < 0.1) and (getprop("/velocities/groundspeed-kt") < 10.0))
	{
	if (SpaceShuttle.approach.trainer_active == 1)
		{
		SpaceShuttle.approach.mark_stop();
		controls.centerFlightControls();
		SpaceShuttle.touchdown_dlg.open();
		}

	#setprop("/sim/messages/copilot", "Wheels stop!");
	SpaceShuttle.callout.make("Wheels stop!", "real");
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


var hydraulic_circulation_on = func {

# hydraulic circulation pumps to GPC

setprop("/fdm/jsbsim/systems/apu/apu/hyd-circ-pump-cmd", 0);
setprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-circ-pump-cmd", 0);
setprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-circ-pump-cmd", 0);

setprop("/fdm/jsbsim/systems/apu/apu/hyd-circ-pump-cmd-dlg", 1);
setprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-circ-pump-cmd-dlg", 1);
setprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-circ-pump-cmd-dlg", 1);

}


var thermal_control_on = func {

# OMS heaters on

setprop("/fdm/jsbsim/systems/oms-hardware/heater-left-A-status", 1);
setprop("/fdm/jsbsim/systems/oms-hardware/heater-right-A-status", 1);

# RCS heaters

setprop("/fdm/jsbsim/systems/rcs-hardware/heater-left-B-status", 1);
setprop("/fdm/jsbsim/systems/rcs-hardware/heater-right-B-status", 1);
setprop("/fdm/jsbsim/systems/rcs-hardware/heater-fwd-A-status", 1);
setprop("/fdm/jsbsim/systems/rcs-hardware/heater-fwd-status", 1);

# Crossfeed heaters

setprop("/fdm/jsbsim/systems/oms-hardware/heater-crossfeed-A-status", 1);

# Jet heaters

setprop("/fdm/jsbsim/systems/rcs-hardware/heater-pod-1-status", 1);
setprop("/fdm/jsbsim/systems/rcs-hardware/heater-pod-2-status", 1);
setprop("/fdm/jsbsim/systems/rcs-hardware/heater-pod-3-status", 1);
setprop("/fdm/jsbsim/systems/rcs-hardware/heater-pod-4-status", 1);
setprop("/fdm/jsbsim/systems/rcs-hardware/heater-pod-5-status", 1);


setprop("/fdm/jsbsim/systems/rcs-hardware/heater-fwd-1-status", 1);
setprop("/fdm/jsbsim/systems/rcs-hardware/heater-fwd-2-status", 1);
setprop("/fdm/jsbsim/systems/rcs-hardware/heater-fwd-3-status", 1);
setprop("/fdm/jsbsim/systems/rcs-hardware/heater-fwd-4-status", 1);
setprop("/fdm/jsbsim/systems/rcs-hardware/heater-fwd-5-status", 1);
}

var engine_controllers_off = func {

setprop("/fdm/jsbsim/systems/mps/engine/controller-A-power-switch-status", 0);
setprop("/fdm/jsbsim/systems/mps/engine/controller-B-power-switch-status", 0);

setprop("/fdm/jsbsim/systems/mps/engine[1]/controller-A-power-switch-status", 0);
setprop("/fdm/jsbsim/systems/mps/engine[1]/controller-B-power-switch-status", 0);

setprop("/fdm/jsbsim/systems/mps/engine[2]/controller-A-power-switch-status", 0);
setprop("/fdm/jsbsim/systems/mps/engine[2]/controller-B-power-switch-status", 0);

setprop("/fdm/jsbsim/systems/apu/apu[0]/tvc-isolation-valve-status", 0);
setprop("/fdm/jsbsim/systems/apu/apu[1]/tvc-isolation-valve-status", 0);
setprop("/fdm/jsbsim/systems/apu/apu[2]/tvc-isolation-valve-status", 0);
}


var area_nav_on = func {



setprop("/fdm/jsbsim/systems/navigation/tacan-sys1-switch", 3);
setprop("/fdm/jsbsim/systems/navigation/tacan-sys2-switch", 3);
setprop("/fdm/jsbsim/systems/navigation/tacan-sys3-switch", 3);

setprop("/fdm/jsbsim/systems/navigation/mls-sys1-switch", 1);
setprop("/fdm/jsbsim/systems/navigation/mls-sys2-switch", 1);
setprop("/fdm/jsbsim/systems/navigation/mls-sys3-switch", 1);

setprop("/fdm/jsbsim/systems/navigation/radar-altimeter-1-power", 1);
setprop("/fdm/jsbsim/systems/navigation/radar-altimeter-2-power", 1);
}

var air_data_on = func {

setprop("/fdm/jsbsim/systems/navigation/air-data-deploy-left-switch", 1);
setprop("/fdm/jsbsim/systems/navigation/air-data-deploy-right-switch", 1);

settimer( func {SpaceShuttle.air_data_system.update_adta_status();} , 16.0);

}

var star_tracker_active = func {

setprop("/fdm/jsbsim/systems/mechanical/star-tracker-sys1-switch", 1);

setprop("/fdm/jsbsim/systems/mechanical/star-tracker-y-switch", 1);
setprop("/fdm/jsbsim/systems/mechanical/star-tracker-z-switch", 1);

}

var hud_covers_off = func {

setprop("/controls/shuttle/Hud-cover-cmd-show", 0);
setprop("/controls/shuttle/Hud-cover-plt-show", 0);

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
	setprop("/orientation/heading-deg", getprop("/sim/presets/heading-deg"));
	setprop("/orientation/roll-deg", 0.0);
	setprop("/velocities/uBody-fps", 0.0);
	setprop("/velocities/vBody-fps", 0.0);
	setprop("/velocities/wBody-fps", 0.0);
	#hydraulics_on();

	# area nav is on during launch
	area_nav_on();
	
	settimer( func SpaceShuttle.light_manager.set_theme("PAD"), 5.0);

	}


if (stage == 1) 
	{
	# nothing is ever simple - we need to consider the rotation of Earth

	var latitude = getprop("/position/latitude-deg") * 3.1415/180.0;
	var heading = getprop("/orientation/heading-deg") * 3.1415/180.0;

	var rotation_boost = 1579.0 * math.cos(latitude) * math.sin(heading);
	setprop("/velocities/uBody-fps", 26100.0 - rotation_boost);

	SpaceShuttle.fill_traj2_data();

	# start main orbital loop
	orbital_loop();

	# adjust mission time
	setprop("/fdm/jsbsim/systems/timer/delta-MET", 520);

	# area nav is on during launch
	area_nav_on();

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

	# adjust mission time
	setprop("/fdm/jsbsim/systems/timer/delta-MET", 700000);

	hydraulics_on();
	et_umbilical_door_close();
	thermal_control_on();
	engine_controllers_off();
	hud_covers_off();

	
	SpaceShuttle.traj_display_flag = 3;
	SpaceShuttle.fill_entry1_data();
	settimer( func {
			setprop("/fdm/jsbsim/systems/fcs/control-mode",29);
			setprop("/controls/shuttle/control-system-string", "Aerojet");
			}, 2.0);
	SpaceShuttle.area_nav_set.init();

	deorbit_loop();	

	}

if (stage == 3) 
	{
	# gliding speed is about Mach 2.5 at 83.000 ft

	var lat_to_m = 110952.0; 
	var lon_to_m  = math.cos(getprop("/position/latitude-deg")*math.pi/180.0) * lat_to_m;
	var m_to_lon = 1.0/lon_to_m;
	var m_to_lat = 1.0/lat_to_m;

	var heading = getprop("/orientation/heading-deg");

	if (getprop("/sim/presets/TAEM-approach-course-deg") != nil)	
		{
		heading = getprop("/sim/presets/TAEM-approach-course-deg");
		setprop("/orientation/heading-deg", heading);
		}

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

	#MEDS_CDR1.PFD.selectPage(MEDS_CDR1.PFD.p_dps_hsit);
	#MEDS_CDR1.PFD.dps_page_flag = 1;
	#settimer(func {SpaceShuttle.idp_array[2].set_spec(50);}, 1.0);
	#MEDS_CDR2.PFD.selectPage(MEDS_CDR2.PFD.p_dps);
	#MEDS_CDR2.PFD.dps_page_flag = 1;
	#MEDS_CRT1.PFD.selectPage(MEDS_CRT1.PFD.p_meds_apu);
	#MEDS_CRT1.PFD.dps_page_flag = 0;
	#MEDS_MFD1.PFD.selectPage(MEDS_MFD1.PFD.p_meds_spi);
	#MEDS_MFD1.PFD.dps_page_flag = 0;
	#MEDS_CRT3.PFD.selectPage(MEDS_CRT3.PFD.p_dps);
	#MEDS_CRT3.PFD.dps_page_flag = 1;
	#MEDS_CRT2.PFD.selectPage(MEDS_CRT2.PFD.p_meds_spi);
	#MEDS_CRT2.PFD.dps_page_flag = 0;
	#MEDS_MFD2.PFD.selectPage(MEDS_MFD2.PFD.p_meds_apu);
	#MEDS_MFD2.PFD.dps_page_flag = 0;
	#MEDS_PLT1.PFD.selectPage(MEDS_PLT1.PFD.p_dps);
	#MEDS_PLT1.PFD.dps_page_flag = 1;
	#MEDS_PLT2.PFD.selectPage(MEDS_PLT2.PFD.p_dps_hsit);
	#MEDS_PLT2.dps_page_flag = 1;

	engine_controllers_off();
	area_nav_on();
	air_data_on();
	hud_covers_off();
	
	# suppress TACAN incorporation message
	SpaceShuttle.cws_msg_hash.nav_edit_tac = 1;
	SpaceShuttle.cws_msg_hash.nav_edit_alt = 1;

	# adjust mission time
	setprop("/fdm/jsbsim/systems/timer/delta-MET", 701800);

	# start main control loop
	glide_loop();	

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

	# suppress TACAN incorporation message
	SpaceShuttle.cws_msg_hash.nav_edit_tac = 1;
	SpaceShuttle.cws_msg_hash.nav_edit_alt = 1;

	# if we recognze the airport, we can start guidance
	
	var airport = getprop("/sim/presets/airport-id");


	if (airport == "KTTS")
		{
		SpaceShuttle.update_site_by_index(1);
		if (abs(heading - 150.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for KTTS loaded");
		}
	else if (airport == "KVBG")
		{
		SpaceShuttle.update_site_by_index(2);
		if (abs(heading - 150.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for KVBG loaded");
		}
	else if (airport == "TXKF")
		{
		SpaceShuttle.update_site_by_index(11);
		if (abs(heading - 120.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for TXKF loaded");

		}
	else if (airport == "LFMI")
		{
		SpaceShuttle.update_site_by_index(9);
		if (abs(heading - 150.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for LFMI loaded");

		}
	else if (airport == "GBYD")
		{
		SpaceShuttle.update_site_by_index(7);
		if (abs(heading - 140.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for GBYD loaded");

		}
	else if (airport == "LEZG")
		{
		SpaceShuttle.update_site_by_index(5);
		if (abs(heading - 120.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for LEZG loaded");

		}
	else if (airport == "EGVA")
		{
		SpaceShuttle.update_site_by_index(6);
		if (abs(heading - 90.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for EGVA loaded");

		}
	else if (airport == "LEMO")
		{
		SpaceShuttle.update_site_by_index(8);
		if (abs(heading - 20.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for LEMO loaded");

		}
	else if (airport == "CYHZ")
		{
		SpaceShuttle.update_site_by_index(12);
		if (abs(heading - 50.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for CYHZ loaded");

		}
	else if (airport == "KILM")
		{
		SpaceShuttle.update_site_by_index(13);
		if (abs(heading - 50.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for KILM loaded");

		}
	else if (airport == "KACY")
		{
		SpaceShuttle.update_site_by_index(14);
		if (abs(heading - 130.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for KACY loaded");
		}
	else if (airport == "KMYR")
		{
		SpaceShuttle.update_site_by_index(15);
		if (abs(heading - 180.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for KMYR loaded");
		}
	else if (airport == "KPSM")
		{
		SpaceShuttle.update_site_by_index(17);
		if (abs(heading - 150.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for KPSM loaded");
		}
	else if (airport == "CYQX")
		{
		SpaceShuttle.update_site_by_index(16);
		#print ("Heading: ", heading);
		if (abs(heading - 10.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for CYQX loaded");
		}
	else if (airport == "SCIP")
		{
		SpaceShuttle.update_site_by_index(30);
		if (abs(heading - 100.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for SCIP loaded");

		}
	else if (airport == "FJDG")
		{
		SpaceShuttle.update_site_by_index(32);
		if (abs(heading - 120.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for FJDG loaded");

		}
	else if (airport == "PHNL")
		{
		SpaceShuttle.update_site_by_index(33);
		if (abs(heading - 80.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for PHNL loaded");
		}
	else if (airport == "BIKF")
		{
		SpaceShuttle.update_site_by_index(34);
		if (abs(heading - 90.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for BIKF loaded");
		}
	else if (airport == "PGUA")
		{
		SpaceShuttle.update_site_by_index(35);
		if (abs(heading - 60.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for PGUA loaded");
		}
	else if (airport == "KEDW")
		{
		SpaceShuttle.update_site_by_index(3);
		SpaceShuttle.update_runway_by_flag(1);
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for KEDW loaded");
		}
		


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

	engine_controllers_off();
	area_nav_on();	
	air_data_on();
	hud_covers_off();

	# adjust mission time
	setprop("/fdm/jsbsim/systems/timer/delta-MET", 702000);
	
	# set approach trainer on
	SpaceShuttle.approach.trainer_active = 1;


	# start main control loop
	glide_loop();
	
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

	var place_dist = 35000.0; 
	var place_x = place_dist * math.sin(place_dir);
	var place_y = place_dist * math.cos(place_dir);

	var place_lat = getprop("/position/latitude-deg") + m_to_lat * place_y;
	var place_lon = getprop("/position/longitude-deg") + m_to_lon * place_x;

	#print (place_lat, " ",place_lon);

	setprop("/position/latitude-deg", place_lat); 
	setprop("/position/longitude-deg", place_lon); 
	setprop("/position/altitude-ft", 36000.0);

	setprop("/orientation/roll-deg", 0);
	setprop("/velocities/uBody-fps",900.0);
	setprop("/velocities/wBody-fps", 60.0);

	# suppress TACAN incorporation message
	SpaceShuttle.cws_msg_hash.nav_edit_tac = 1;
	SpaceShuttle.cws_msg_hash.nav_edit_alt = 1;

	engine_controllers_off();
	area_nav_on();	
	air_data_on();
	hud_covers_off();


	# start main control loop
	glide_loop();

	# init on carrier
	if (getprop("/sim/config/shuttle/on-carrier-init") == 1)
		{settimer(func {SpaceShuttle.carrier_aircraft.init();}, 2.0);}
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

	hydraulic_circulation_on();
	radiator_activate();
	thermal_control_on();
	engine_controllers_off();	
	star_tracker_active();

	setprop("/fdm/jsbsim/systems/electrical/hud/cmd-pwr-switch", 0);
	setprop("/fdm/jsbsim/systems/electrical/hud/plt-pwr-switch", 0);

	# adjust mission time
	setprop("/fdm/jsbsim/systems/timer/delta-MET", 200000);

	# start main control loop
	orbital_loop();

	}

# initialize the DPS hardware

SpaceShuttle.init_gpcs(stage);
SpaceShuttle.init_idps();
SpaceShuttle.init_keyboards();

# switch long term component simulation on
SpaceShuttle.condition_manager.start();


SpaceShuttle.nbat.select_ops(getprop("/fdm/jsbsim/systems/dps/ops"));
SpaceShuttle.nbat.init();

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
	settimer(control_to_rcs, 1.0);

	# open PBD
	pb_door_open();

	# deploy Ku-antenna
	ku_antenna_deploy();
	


	}
