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
				setprop("/controls/engines/engine[0]/throttle", 0.0);
				setprop("/controls/engines/engine[1]/throttle", 0.0);
				setprop("/controls/engines/engine[2]/throttle", 0.0);
				}
			}
		else if (alt > 410000.0)
			{
			if (auto_throttle == 1)
				{
				setprop("/controls/engines/engine[0]/throttle", 0.4);
				setprop("/controls/engines/engine[1]/throttle", 0.4);
				setprop("/controls/engines/engine[2]/throttle", 0.4);
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

	var site_distance = getprop("/fdm/jsbsim/systems/entry_guidance/remaining-distance-nm");

	var meco_speed_bias = 0.0;

	if (site_rel_speed > 5800)
		{
		# determine at what distance we should be for a good solution

		var tgt_site_distance = 0.017285 * site_rel_speed + 412.4;

		var dist_error = tgt_site_distance - site_distance;

		meco_speed_bias = dist_error * -20.0;
		meco_speed_bias = SpaceShuttle.clamp(meco_speed_bias, -300.0, 300.0);

		}


	if ((fuel_percent < 10.0) and (site_rel_speed < -6800.0 + meco_speed_bias))
		{
		setprop("/sim/messages/copilot", "Pitchdown!");

		if (auto_throttle == 1)
			{	
			setprop("/controls/engines/engine[0]/throttle", 0.0);
			setprop("/controls/engines/engine[1]/throttle", 0.0);
			setprop("/controls/engines/engine[2]/throttle", 0.0);
			}
		setprop("/fdm/jsbsim/systems/ap/rtls/powered-pitchdown-active",1);
		}


	}

if (powered_pitchdown_active == 1)
	{	

	if (getprop("/fdm/jsbsim/systems/ap/rtls/powered-pitchdown-active") == 1)
		{

		var alpha = getprop("/fdm/jsbsim/aero/alpha-deg");

		if (math.abs (-2.0 - alpha) < 1.0)
			{

			#print("MECO in 2 seconds");
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

setprop("/fdm/jsbsim/systems/mps/engine[0]/run-cmd", 0);
setprop("/fdm/jsbsim/systems/mps/engine[1]/run-cmd", 0);
setprop("/fdm/jsbsim/systems/mps/engine[2]/run-cmd", 0);



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

setprop("/sim/messages/copilot", "Pitch to alpha recovery!");

# close umbilical door

SpaceShuttle.et_umbilical_door_close();

# do the MPS fuel dump

setprop("/fdm/jsbsim/systems/mps/LO2-manifold-valve-status", 1);
setprop("/fdm/jsbsim/systems/propellant/LH2-inboard-status", 1);
setprop("/fdm/jsbsim/systems/propellant/LH2-outboard-status", 1);
		
SpaceShuttle.fuel_dump_start();

#print("Starting GRTLS loop...");
grtls_loop();
}

var grtls_loop = func {


var alpha_transition = getprop("/fdm/jsbsim/systems/ap/grtls/alpha-transition-active");
var speedbrake_state = getprop("/controls/shuttle/speedbrake");


# determine Nz target just before Nz hold when acceleration = 1 g


if ((getprop("/fdm/jsbsim/accelerations/Nz") > 1.0) and (getprop("/fdm/jsbsim/systems/ap/grtls/Nz-tgt") == 0))
	{
		var hdot = getprop("/fdm/jsbsim/velocities/v-down-fps");
		var Nz_target = hdot/1000.0 + 0.65;
		setprop("/fdm/jsbsim/systems/ap/grtls/Nz-tgt", Nz_target);

	}


# open SB to 80% at alpha transition

if (alpha_transition == 1)
	{
	#print ("Alpha transition initiated!");
	if ((speedbrake_state < 0.8) and (getprop("/fdm/jsbsim/systems/ap/automatic-sb-control") == 1))
		{
		for (var i=0; i<4; i=i+1) 
			{SpaceShuttle.increase_speedbrake();}

		}
	}

# exit loop at TAEM init

var taem_init = getprop("/fdm/jsbsim/systems/ap/grtls/taem-transition-init");

if (taem_init == 1) # transition to MM 603
	{
	setprop("/fdm/jsbsim/systems/dps/major-mode", 603);
	SpaceShuttle.ops_transition_auto("p_vert_sit");
	return;
	}	


settimer(grtls_loop, 0.2);
}
