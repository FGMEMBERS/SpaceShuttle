# auto launch guidance for the Space Shuttle
# Thorsten Renk 2016


var auto_launch_stage = 0;
var auto_launch_timer = 0.0;


var auto_launch_loop = func {


if (auto_launch_stage == 0)
	{
	# check for clear gantry, then initiate rotation to launch course
	
	if (getprop("/position/altitude-agl-ft") > 400.0)
		{
		auto_launch_stage = 1;
		setprop("/fdm/jsbsim/systems/ap/launch/stage", 1);
		}
	}
else if (auto_launch_stage == 1)
	{
	# check for launch course reached, then initiate pitch down

	if (math.abs(getprop("/fdm/jsbsim/systems/ap/launch/stage1-course-error")) < 0.01)
		{
		auto_launch_stage = 2;
		setprop("/fdm/jsbsim/systems/ap/launch/stage", 2);
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-target", 78.0);
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-max-rate-norm", 0.2);
		}

	

	}
else if (auto_launch_stage == 2)
	{


	if ((auto_launch_timer > 25.0) and (auto_launch_timer < 54.0))
		{
		setprop("/controls/engines/engine[0]/throttle", 0.61);
		setprop("/controls/engines/engine[1]/throttle", 0.61);
		setprop("/controls/engines/engine[2]/throttle", 0.61);
		}
	else if (auto_launch_timer > 48.0)
		{
		setprop("/controls/engines/engine[0]/throttle", 1.0);
		setprop("/controls/engines/engine[1]/throttle", 1.0);
		setprop("/controls/engines/engine[2]/throttle", 1.0);
		}

	if ((getprop("/fdm/jsbsim/aero/qbar-psf") < 550.0) and (auto_launch_timer > 48.0))
		{
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-target", 55.0);
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-max-rate-norm", 0.14);
		}

	
	
	}
else if (auto_launch_stage == 3)
	{

		print("Autolaunch signing off...");
		return;
	}


auto_launch_timer = auto_launch_timer + 0.1;

settimer(auto_launch_loop, 0.1);

}
