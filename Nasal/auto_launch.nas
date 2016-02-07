# auto launch guidance for the Space Shuttle
# Thorsten Renk 2016


var auto_launch_stage = 0;
var auto_launch_timer = 0.0;
var aux_flag = 0;


var auto_launch_loop = func {


if (auto_launch_stage == 0)
	{
	# check for clear gantry, then initiate rotation to launch course
	
	if (getprop("/position/altitude-agl-ft") > 400.0)
		{
		auto_launch_stage = 1;
		setprop("/fdm/jsbsim/systems/ap/launch/stage", 1);
		aux_flag = 0;
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
		aux_flag = 0;
		}

	

	}
else if (auto_launch_stage == 2)
	{


	if ((auto_launch_timer > 20.0) and (auto_launch_timer < 42.0))
		{
		if (aux_flag == 0)
			{
			setprop("/controls/engines/engine[0]/throttle", 0.61);
			setprop("/controls/engines/engine[1]/throttle", 0.61);
			setprop("/controls/engines/engine[2]/throttle", 0.61);
			aux_flag = 1;
			}
		}
	else if (auto_launch_timer > 42.0)
		{
		if (aux_flag == 1)
			{
			setprop("/controls/engines/engine[0]/throttle", 1.0);
			setprop("/controls/engines/engine[1]/throttle", 1.0);
			setprop("/controls/engines/engine[2]/throttle", 1.0);
			aux_flag = 2;
			}
		}

	if ((getprop("/fdm/jsbsim/aero/qbar-psf") < 510.0) and (auto_launch_timer > 42.0))
		{
		if (aux_flag == 2)
			{
			setprop("/fdm/jsbsim/systems/ap/launch/pitch-target", 55.0);
			setprop("/fdm/jsbsim/systems/ap/launch/pitch-max-rate-norm", 0.12);
			aux_flag = 3;
			}
		}

	if (getprop("/controls/shuttle/SRB-static-model") == 0)
		{
		auto_launch_stage = 3;
		setprop("/fdm/jsbsim/systems/ap/launch/stage", 3);
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-target", -5.0);
		aux_flag = 0;
		}

	}
else if (auto_launch_stage == 3)
	{

	if ((getprop("/fdm/jsbsim/velocities/v-down-fps") > -300.0) and (aux_flag == 0))
		{
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-target", 18.0);
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-max-rate-norm", 0.1);
		aux_flag = 1;
		}
	else if ((getprop("/fdm/jsbsim/velocities/v-down-fps") > -100.0) and (aux_flag == 1))
		{
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-target", 15.0);
		aux_flag = 2;
		}
	else if ((getprop("/fdm/jsbsim/velocities/v-down-fps") >  20.0) and (aux_flag == 2))
		{
		auto_launch_stage = 4;
		setprop("/fdm/jsbsim/systems/ap/launch/stage", 4);
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-max-rate-norm", 0.05);
		setprop("/fdm/jsbsim/systems/ap/launch/hdot-target", 50.0);
		aux_flag = 0;
		}	
	
	}
else if (auto_launch_stage == 4)
	{

	# dynamically throttle back when we reach acceleration limit
	
	if (getprop("/fdm/jsbsim/accelerations/n-pilot-x-norm") > 2.85)
		{
		var current_throttle = getprop("/controls/engines/engine[0]/throttle");
		var new_throttle = current_throttle * 0.99;

		if (new_throttle < 0.61) {new_throttle = 0.61;}

		setprop("/controls/engines/engine[0]/throttle", new_throttle);
		setprop("/controls/engines/engine[1]/throttle", new_throttle);
		setprop("/controls/engines/engine[2]/throttle", new_throttle);

		}

	# change hdot target to 0 prior to MECO

	if ((aux_flag == 0) and (getprop("/fdm/jsbsim/velocities/mach") > 23.0))
		{
		setprop("/fdm/jsbsim/systems/ap/launch/hdot-target", 0.0);
		aux_flag = 1;
		} 

	# increase pitch maneuverability as centrifugal force builds up

	if ((aux_flag == 1) and (getprop("/fdm/jsbsim/systems/orbital/apoapsis-km") > -500.0))
		{
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-max-rate-norm", 0.15);
		aux_flag = 2;
		}


	# null all rates prior to MECO

	if ((aux_flag == 2) and (getprop("/fdm/jsbsim/systems/orbital/apoapsis-km") > 0.0))
		{
		setprop("/fdm/jsbsim/systems/ap/launch/stage", 5);
		aux_flag = 3;
		}



	# MECO if apoapsis target is met

	if (getprop("/fdm/jsbsim/systems/orbital/apoapsis-km") > getprop("/fdm/jsbsim/systems/ap/launch/apoapsis-target"))
		{

		setprop("/controls/engines/engine[0]/throttle", 0.0);
		setprop("/controls/engines/engine[1]/throttle", 0.0);
		setprop("/controls/engines/engine[2]/throttle", 0.0);

		print ("MECO - auto-launch guidance signing off!");
		print ("Thank you for flying with us!");
		return;
		}

	}


auto_launch_timer = auto_launch_timer + 0.1;

settimer(auto_launch_loop, 0.1);

}
