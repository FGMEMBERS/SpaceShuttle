# RTLS guidance for the Space Shuttle


var prtls_loop = func {



var flyout_active = getprop("/fdm/jsbsim/systems/ap/rtls/flyout-active");
var powered_pitch_around = getprop("/fdm/jsbsim/systems/ap/rtls/powered-pitcharound-active");
var flyback_active = getprop("/fdm/jsbsim/systems/ap/rtls/flyback-active");
var powered_pitchdown_active = getprop("/fdm/jsbsim/systems/ap/rtls/powered-pitchdown-active");

var auto_throttle = getprop("/fdm/jsbsim/systems/ap/automatic-throttle-control");



if (flyout_active == 1)
	{

	var vspeed = getprop("/fdm/jsbsim/velocities/v-down-fps");
	var alt = getprop("/position/altitude-ft");
	
	# check altitude during flyout, reduce throttle if we get too high and are still climbing

	if (vspeed > 60.0)
		{
		if (auto_throttle == 1)
			{			
			setprop("/controls/engines/engine[0]/throttle", 1.0);
			setprop("/controls/engines/engine[1]/throttle", 1.0);
			setprop("/controls/engines/engine[2]/throttle", 1.0);
			}
		}

	else
		{

		if (alt > 500000.0)
			{
			if (auto_throttle == 1)
				{			
				setprop("/controls/engines/engine[0]/throttle", 0.65);
				setprop("/controls/engines/engine[1]/throttle", 0.65);
				setprop("/controls/engines/engine[2]/throttle", 0.65);
				}
			}
		else if (alt > 410000.0)
			{
			if (auto_throttle == 1)
				{
				setprop("/controls/engines/engine[0]/throttle", 0.75);
				setprop("/controls/engines/engine[1]/throttle", 0.75);
				setprop("/controls/engines/engine[2]/throttle", 0.75);
				}
			}
		}
	}

if (powered_pitch_around == 1)
	{
	if (auto_throttle == 1)
		{	
		setprop("/controls/engines/engine[0]/throttle", 1.0);
		setprop("/controls/engines/engine[1]/throttle", 1.0);
		setprop("/controls/engines/engine[2]/throttle", 1.0);
		}
	}


if (flyback_active == 1)  
	{

	
	# determine MECO 


	var fuel_percent = getprop("/fdm/jsbsim/propulsion/tank/pct-full");
	var site_rel_speed = getprop("/fdm/jsbsim/systems/entry_guidance/site-relative-velocity-fps");




	if ((fuel_percent < 10.0) and (site_rel_speed < -7000.0))
		{
		setprop("/sim/messages/copilot", "Pitchdown!");

		if (auto_throttle == 1)
			{	
			setprop("/controls/engines/engine[0]/throttle", 0.67);
			setprop("/controls/engines/engine[1]/throttle", 0.67);
			setprop("/controls/engines/engine[2]/throttle", 0.67);
			}
		setprop("/fdm/jsbsim/systems/ap/rtls/powered-pitchdown-active",1);
		}


	}

if (powered_pitchdown_active == 1)
	{	

	if (getprop("/fdm/jsbsim/systems/ap/rtls/powered-pitchdown-active") == 1)
		{

		var alpha = getprop("/fdm/jsbsim/aero/alpha-deg");
		print(alpha);
		print(math.abs (-2.0 - alpha));

		if (math.abs (-2.0 - alpha) < 0.5)
			{

			print("MECO in 2 seconds");
			settimer( func {
				setprop("/sim/messages/copilot", "MECO!");
				rtls_init_meco(); }, 2.0);

			return;

			}

		}

	

	

	}


settimer(prtls_loop, 0.2);

}

var rtls_init_meco = func {

setprop("/controls/engines/engine[0]/throttle", 0.0);
setprop("/controls/engines/engine[1]/throttle", 0.0);
setprop("/controls/engines/engine[2]/throttle", 0.0);



# activate DAP A to get rates nulled
setprop("/fdm/jsbsim/systems/fcs/control-mode",20);

settimer( external_tank_separate, 13.0);

settimer( rtls_transit_glide, 21.0);
}

var rtls_transit_glide = func {

# transition to MM 602

setprop("/fdm/jsbsim/systems/dps/major-mode", 602);
SpaceShuttle.ops_transition_auto("p_vert_sit");

# aerojet DAP on

setprop("/fdm/jsbsim/systems/fcs/control-mode",29);
setprop("/controls/shuttle/control-system-string", "Aerojet");

setprop("/sim/messages/copilot", "Pitch up for alpha recovery!");

# close umbilical door

SpaceShuttle.et_umbilical_door_close();

# do the fuel dump

setprop("/fdm/jsbsim/systems/mps/LO2-manifold-valve-status", 1);
setprop("/fdm/jsbsim/systems/propellant/LH2-inboard-status", 1);
setprop("/fdm/jsbsim/systems/propellant/LH2-outboard-status", 1);
		
SpaceShuttle.fuel_dump_start();

# hand over to manual controls

setprop("/fdm/jsbsim/systems/ap/automatic-pitch-control", 0);
setprop("/fdm/jsbsim/systems/ap/css-pitch-control", 1);
setprop("/fdm/jsbsim/systems/ap/automatic-roll-control", 0);
setprop("/fdm/jsbsim/systems/ap/css-roll-control", 1);
}
