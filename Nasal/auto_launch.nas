# auto launch guidance for the Space Shuttle
# Thorsten Renk 2016


var auto_launch_stage = 0;
var auto_launch_timer = 0.0;
var aux_flag = 0;

var auto_launch_throttle_down = 18.0;
var auto_launch_throttle_up = 42.0;
var auto_launch_throttle_to = 0.0;

var auto_launch_traj_loft = 0.0;
var auto_launch_mps_climbout_bias = 0.0;
var auto_launch_srb_climbout_bias = 0.0;

var xtrack_refloc = geo.Coord.new();
xtrack_refloc.last_xtrack = 0.0;
xtrack_refloc.correction = 0.0;


xtrack_refloc.approach_speed = 0.0;
xtrack_refloc.last_app_speed = 0.0;
xtrack_refloc.buffer = 0.0;

var auto_launch_loop = func {

var shuttle_pos = geo.aircraft_position();

#var actual_course = SpaceShuttle.peg4_refloc.course_to(shuttle_pos);
#var dist = SpaceShuttle.peg4_refloc.distance_to(shuttle_pos);

var actual_course = SpaceShuttle.xtrack_refloc.course_to(shuttle_pos);
var dist = SpaceShuttle.xtrack_refloc.distance_to(shuttle_pos);

var launch_azimuth = getprop("/fdm/jsbsim/systems/ap/launch/launch-azimuth");

var xtrack = SpaceShuttle.sgeo_crosstrack(actual_course, launch_azimuth, dist)  * 0.0005399568;

# compute speed by a running average

xtrack_refloc.approach_speed = (xtrack_refloc.last_xtrack - xtrack)/ 0.1; # using loop time constant
xtrack_refloc.buffer = (xtrack_refloc.approach_speed + xtrack_refloc.last_app_speed)/2.0;
xtrack_refloc.last_app_speed = xtrack_refloc.approach_speed;
xtrack_refloc.approach_speed = xtrack_refloc.buffer;



xtrack_refloc.last_xtrack = xtrack;


setprop("/fdm/jsbsim/systems/ap/launch/cross-track", xtrack);
setprop("/fdm/jsbsim/systems/ap/launch/cross-track-approach-speed", xtrack_refloc.approach_speed);

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

	# enable throttling already during rotation to azimuth

	#print ("Auto launch timer: ", auto_launch_timer);

	if ((auto_launch_timer > auto_launch_throttle_down) and (auto_launch_timer < auto_launch_throttle_up))
		{
		if (aux_flag == 0)
			{
			if (getprop("/fdm/jsbsim/systems/ap/automatic-sb-control") == 1)
				{
				if (SpaceShuttle.failure_cmd.ssme1 == 1)
					{setprop("/controls/engines/engine[0]/throttle", auto_launch_throttle_to);}
				if (SpaceShuttle.failure_cmd.ssme2 == 1)
					{setprop("/controls/engines/engine[1]/throttle", auto_launch_throttle_to);}
				if (SpaceShuttle.failure_cmd.ssme3 == 1)
					{setprop("/controls/engines/engine[2]/throttle", auto_launch_throttle_to);}
				}
			aux_flag = 1;
			}
		# throttle up if we lose an engine

		if (getprop("/fdm/jsbsim/systems/mps/number-engines-operational") < 3.0) 
			{
			if (getprop("/fdm/jsbsim/systems/ap/automatic-sb-control") == 1)
				{
				if (SpaceShuttle.failure_cmd.ssme1 == 1)
					{setprop("/controls/engines/engine[0]/throttle", 1.0);}
				if (SpaceShuttle.failure_cmd.ssme2 == 1)
					{setprop("/controls/engines/engine[1]/throttle", 1.0);}
				if (SpaceShuttle.failure_cmd.ssme3 == 1)
					{setprop("/controls/engines/engine[2]/throttle", 1.0);}
				}
			}

		}
	else if (auto_launch_timer > auto_launch_throttle_up)
		{
		if (aux_flag == 1)
			{
		
			if (getprop("/fdm/jsbsim/systems/ap/automatic-sb-control") == 1)
				{
				if (SpaceShuttle.failure_cmd.ssme1 == 1)			
					{setprop("/controls/engines/engine[0]/throttle", 1.0);}
				if (SpaceShuttle.failure_cmd.ssme2 == 1)			
					{setprop("/controls/engines/engine[1]/throttle", 1.0);}
				if (SpaceShuttle.failure_cmd.ssme3 == 1)			
					{setprop("/controls/engines/engine[2]/throttle", 1.0);}
				}
			aux_flag = 2;
			}
		}


	# check for launch course reached, then initiate pitch down assuming we're high enough

	if (math.abs(getprop("/fdm/jsbsim/systems/ap/launch/stage1-course-error")) < 0.01) 
		{
		auto_launch_stage = 2;
		setprop("/fdm/jsbsim/systems/ap/launch/stage", 2);
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-target", 74.0);
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-max-rate-norm", 0.2);
		aux_flag = 0;
		}

	

	}
else if (auto_launch_stage == 2)
	{

	if ((auto_launch_timer > auto_launch_throttle_down) and (auto_launch_timer < auto_launch_throttle_up))
		{
		if (aux_flag == 0)
			{
			if (getprop("/fdm/jsbsim/systems/ap/automatic-sb-control") == 1)
				{
				if (SpaceShuttle.failure_cmd.ssme1 == 1)
					{setprop("/controls/engines/engine[0]/throttle", auto_launch_throttle_to);}
				if (SpaceShuttle.failure_cmd.ssme2 == 1)
					{setprop("/controls/engines/engine[1]/throttle", auto_launch_throttle_to);}
				if (SpaceShuttle.failure_cmd.ssme3 == 1)
					{setprop("/controls/engines/engine[2]/throttle", auto_launch_throttle_to);}
				}
			aux_flag = 1;
			}
		# throttle up if we lose an engine

		if (getprop("/fdm/jsbsim/systems/mps/number-engines-operational") < 3.0) 
			{
			if (getprop("/fdm/jsbsim/systems/ap/automatic-sb-control") == 1)
				{
				if (SpaceShuttle.failure_cmd.ssme1 == 1)
					{setprop("/controls/engines/engine[0]/throttle", 1.0);}
				if (SpaceShuttle.failure_cmd.ssme2 == 1)
					{setprop("/controls/engines/engine[1]/throttle", 1.0);}
				if (SpaceShuttle.failure_cmd.ssme3 == 1)
					{setprop("/controls/engines/engine[2]/throttle", 1.0);}
				}
			}

		}
	else if (auto_launch_timer > auto_launch_throttle_up)
		{
		if (aux_flag == 1)
			{
		
			if (getprop("/fdm/jsbsim/systems/ap/automatic-sb-control") == 1)
				{
				if (SpaceShuttle.failure_cmd.ssme1 == 1)			
					{setprop("/controls/engines/engine[0]/throttle", 1.0);}
				if (SpaceShuttle.failure_cmd.ssme2 == 1)			
					{setprop("/controls/engines/engine[1]/throttle", 1.0);}
				if (SpaceShuttle.failure_cmd.ssme3 == 1)			
					{setprop("/controls/engines/engine[2]/throttle", 1.0);}
				}
			aux_flag = 2;
			}
		}

	if ((getprop("/fdm/jsbsim/aero/qbar-psf") < 620.0) and (auto_launch_timer > auto_launch_throttle_up))
		{
		if (aux_flag == 2)
			{
			setprop("/fdm/jsbsim/systems/ap/launch/pitch-target", 45.0);
			setprop("/fdm/jsbsim/systems/ap/launch/pitch-max-rate-norm", 0.06);
			aux_flag = 3;
			}
		}

	if ((getprop("/fdm/jsbsim/aero/qbar-psf") < 510.0) and (auto_launch_timer > auto_launch_throttle_up))
		{
		if (aux_flag == 3)
			{
			setprop("/fdm/jsbsim/systems/ap/launch/pitch-target", 45.0 + auto_launch_srb_climbout_bias);
			setprop("/fdm/jsbsim/systems/ap/launch/pitch-max-rate-norm", 0.12);
			aux_flag = 4;
			}
		}

	if ((getprop("/controls/shuttle/SRB-static-model") == 0) and (getprop("/fdm/jsbsim/systems/failures/shuttle-destroyed") == 0))
		{
		auto_launch_stage = 3;
	
		meco_time.init(26000.0);	

		setprop("/fdm/jsbsim/systems/ap/launch/stage", 3);
		var payload_factor = getprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[5]") /53700.00;
		payload_factor =  payload_factor +  (getprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[1]") - 29250.0) / 26850.00;
		
		# OMS kit
		payload_factor = payload_factor + getprop("/fdm/jsbsim/propulsion/tank[27]/contents-lbs")/53700.0;
		payload_factor = payload_factor + getprop("/fdm/jsbsim/propulsion/tank[26]/contents-lbs")/53700.0;

		var throttle_factor = 10.0 * (getprop("/fdm/jsbsim/systems/throttle/throttle-factor") - 1.0);

		var lat = getprop("/position/latitude-deg") * math.pi/180.0;
		var heading = getprop("/orientation/heading-deg") * math.pi/180.0;
		var geo_factor = math.sin(heading) * math.cos(lat);


		var v_up_tgt = 920.0 + auto_launch_srb_climbout_bias * 8.0;

		var delta_vspeed = (v_up_tgt - 42.0 * payload_factor) + 0.3048 * getprop("/fdm/jsbsim/velocities/v-down-fps");

		var delta_alt = delta_vspeed * 895.0;
		var loft_factor = delta_alt / 7000.0;

		if (loft_factor > 5.0) {loft_factor = 5.0;}
		if (loft_factor < -2.0) {loft_factor = -2.0;}

		var pitch_target = 5.0 + 5.0 * payload_factor + 4.0 - 6.0 * geo_factor - 8.0 * throttle_factor + auto_launch_mps_climbout_bias + loft_factor;

		setprop("/fdm/jsbsim/systems/ap/launch/pitch-target", pitch_target);

		# fire an OMS assist burn if requested


		if (getprop("/fdm/jsbsim/systems/ap/launch/oms-assist-burn") == 1)
			{

			var oms_assist_time = getprop("/fdm/jsbsim/systems/ap/launch/oms-assist-duration-s");

			settimer ( func {

				setprop("/controls/engines/engine[5]/throttle", 1.0);
				setprop("/controls/engines/engine[6]/throttle", 1.0);

				}, 10.0 );
			

			settimer ( func {

 				if (getprop("/fdm/jsbsim/systems/oms/oms-dump-cmd") == 1) {return;}

				setprop("/controls/engines/engine[5]/throttle", 0.0);
				setprop("/controls/engines/engine[6]/throttle", 0.0);

				}, 10.0 + oms_assist_time );
			}


		aux_flag = 0;
		}

	}
else if (auto_launch_stage == 3)
	{

	var guidance = getprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode");

	if (guidance == 2) # TAL abort requires different guidance after SRB sep
		{
		print ("TAL abort declared, switching to TAL guidance...");
		auto_TAL_init();
		return;
		}

	meco_time.run();

	var alt = getprop("/position/altitude-ft");


	if (alt > 465000.0 + auto_launch_traj_loft) # we're getting too high and need to pitch down
		{
		var payload_factor = getprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[5]") /53700.00;
		payload_factor =  payload_factor +  (getprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[1]") - 29250.0) / 26850.00;
		# OMS kit
		payload_factor = payload_factor + getprop("/fdm/jsbsim/propulsion/tank[27]/contents-lbs")/53700.0;
		payload_factor = payload_factor + getprop("/fdm/jsbsim/propulsion/tank[26]/contents-lbs")/53700.0;

		var lat = getprop("/position/latitude-deg") * math.pi/180.0;
		var heading = getprop("/orientation/heading-deg") * math.pi/180.0;
		var geo_factor = math.sin(heading) * math.cos(lat);

		var pitch_target = 5.0 + 5.0 * payload_factor + 4.0 - 6.0 * geo_factor;

		var pitch_corr = (alt - 465000 - auto_launch_traj_loft)/1000.0;

		setprop("/fdm/jsbsim/systems/ap/launch/pitch-target", pitch_target - pitch_corr);
		aux_flag = 2;
		}


	if ((getprop("/fdm/jsbsim/velocities/v-down-fps") > -300.0) and (aux_flag == 0))
		{
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-target", 10.0);
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-max-rate-norm", 0.1);
		aux_flag = 1;
		}
	else if ((getprop("/fdm/jsbsim/velocities/v-down-fps") > -100.0) and (aux_flag == 1))
		{
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-target", 10.0);
		aux_flag = 2;
		}
	else if ((getprop("/fdm/jsbsim/velocities/v-down-fps") >  20.0) and (aux_flag == 2))
		{
		auto_launch_stage = 4;
		setprop("/fdm/jsbsim/systems/ap/launch/stage", 4);
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-max-rate-norm", 0.05);
		setprop("/fdm/jsbsim/systems/ap/launch/hdot-target", 50.0);
		droop_guidance.init();
		aux_flag = 0;
		}	
	
	}
else if (auto_launch_stage == 4)
	{

	# if we're off the trajectory too much, try to steer back to it

	var alt = getprop("/position/altitude-ft");
	var mach = getprop("/fdm/jsbsim/velocities/mach");

	droop_guidance.run (alt);
	meco_time.run();

	if ((alt < 420000.0 + auto_launch_traj_loft) and (mach < 23.0))
		{
		var hdot_tgt = 50.0 - (420000.0 - alt)/150.0;
		setprop("/fdm/jsbsim/systems/ap/launch/hdot-target", hdot_tgt);
		}
	else if ((alt > 470000.0 + auto_launch_traj_loft) and (mach < 23.0))
		{
		var hdot_tgt = 50.0 + (alt - 470000.0)/150.0;
		setprop("/fdm/jsbsim/systems/ap/launch/hdot-target", hdot_tgt);
		}


	# dynamically throttle back when we reach acceleration limit
	
	if (getprop("/fdm/jsbsim/accelerations/n-pilot-x-norm") > 2.85)
		{

		SpaceShuttle.meco_time.set_mode(1);

		# an engine can be in electric lockup, so we may need to look at more engines
		# to determine current throttle value

		var current_throttle = 1; 

		if (SpaceShuttle.failure_cmd.ssme1 == 1)
			{current_throttle = getprop("/controls/engines/engine[0]/throttle");}
		else if (SpaceShuttle.failure_cmd.ssme2 == 1)
			{current_throttle = getprop("/controls/engines/engine[1]/throttle");}
		else
			{current_throttle = getprop("/controls/engines/engine[2]/throttle");}

		var new_throttle = current_throttle * 0.99;

		#if (new_throttle < 0.61) {new_throttle = 0.61;}

		if (getprop("/fdm/jsbsim/systems/ap/automatic-sb-control") == 1)
			{
			if (SpaceShuttle.failure_cmd.ssme1 == 1)
				{setprop("/controls/engines/engine[0]/throttle", new_throttle);}
			if (SpaceShuttle.failure_cmd.ssme2 == 1)
				{setprop("/controls/engines/engine[1]/throttle", new_throttle);}
			if (SpaceShuttle.failure_cmd.ssme3 == 1)
				{setprop("/controls/engines/engine[2]/throttle", new_throttle);}
			}

		}


	# automatic roll to heads up attitude

	if ((aux_flag == 0) and (mach > 14.0))
		{
		if ((getprop("/fdm/jsbsim/systems/ap/launch/rthu-enable") == 1) and (getprop("/fdm/jsbsim/systems/fcs/control-mode") != 13))
			{
			var inc_acquire_sign = getprop("/fdm/jsbsim/systems/ap/launch/inc-acquire-sign");
			setprop("/fdm/jsbsim/systems/ap/launch/inc-acquire-sign", -inc_acquire_sign);

			setprop("/fdm/jsbsim/systems/ap/launch/pitch-max-rate-norm", 0.15);
			setprop("/fdm/jsbsim/systems/ap/launch/rthu-cmd", 1);
			}
		aux_flag = 1;
		}
	else if ((aux_flag == 1) and (getprop("/fdm/jsbsim/systems/ap/launch/stage4-rthu-in-in-progress") == 0))
		{
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-max-rate-norm", 0.05);
		aux_flag = 2;
		}


	# change hdot target to 0 prior to MECO

	if ((aux_flag == 2) and (mach > 23.0))
		{
		setprop("/fdm/jsbsim/systems/ap/launch/hdot-target", 0.0);
		aux_flag = 1;
		} 

	# increase pitch maneuverability as centrifugal force builds up

	if ((aux_flag == 3) and (getprop("/fdm/jsbsim/systems/orbital/periapsis-km") > -500.0))
		{
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-max-rate-norm", 0.15);
		aux_flag = 2;
		}


	# null all rates prior to MECO

	if ((aux_flag == 4) and (getprop("/fdm/jsbsim/systems/orbital/periapsis-km") > 0.0))
		{
		setprop("/fdm/jsbsim/systems/ap/launch/stage", 5);
		aux_flag = 5;
		}



	# MECO if apoapsis target is met

	if (getprop("/fdm/jsbsim/systems/orbital/apoapsis-km") > getprop("/fdm/jsbsim/systems/ap/launch/apoapsis-target"))
		{

		SpaceShuttle.meco_time.set_mode(2);

		if (getprop("/fdm/jsbsim/systems/ap/automatic-sb-control") == 1)
			{	
			if (SpaceShuttle.failure_cmd.ssme1 == 1)
				{setprop("/controls/engines/engine[0]/throttle", 0.0);}
			if (SpaceShuttle.failure_cmd.ssme2 == 1)
				{setprop("/controls/engines/engine[1]/throttle", 0.0);}
			if (SpaceShuttle.failure_cmd.ssme3 == 1)
				{setprop("/controls/engines/engine[2]/throttle", 0.0);}

	    		setprop("/fdm/jsbsim/systems/mps/engine[0]/run-cmd", 0);
    			setprop("/fdm/jsbsim/systems/mps/engine[1]/run-cmd", 0);
    			setprop("/fdm/jsbsim/systems/mps/engine[2]/run-cmd", 0);

			}

		setprop("/fdm/jsbsim/systems/ap/launch/regular-meco-condition",1);





		print ("MECO - auto-launch guidance signing off!");
		print ("Thank you for flying with us!");

		# use RCS to null residual rates, disengage launch AP

		settimer( func {
			setprop("/fdm/jsbsim/systems/fcs/control-mode",20);
			controls.centerFlightControls();

			setprop("/fdm/jsbsim/systems/ap/css-pitch-control", 1);
			setprop("/fdm/jsbsim/systems/ap/automatic-pitch-control", 0);    
			setprop("/fdm/jsbsim/systems/ap/css-roll-control", 1);
			setprop("/fdm/jsbsim/systems/ap/automatic-roll-control", 0);


			}, 2.0);
		
		# prepare ETsep and MM 104 transition

		settimer( func {
			setprop("/fdm/jsbsim/systems/dps/major-mode", 104);
			SpaceShuttle.dk_listen_major_mode_transition(104);
			SpaceShuttle.ops_transition_auto("p_dps_mnvr");
			}, 23.0);

		settimer( func {
			external_tank_separate();
			mission_auto_OMS1();

			}, 20.0);

		# start main orbital loop
		orbital_loop_init();

		SpaceShuttle.mission_post_meco();	

		return;
		}

	}


auto_launch_timer = auto_launch_timer + 0.1;


settimer(auto_launch_loop, 0.1);

}


var auto_TAL_init = func {

if (auto_launch_stage == 3)
	{
	# we need to pitch up more on the ballistic climb to get into a good trajectory

	var lat = getprop("/position/latitude-deg") * math.pi/180.0;
	var heading = getprop("/orientation/heading-deg") * math.pi/180.0;

	var payload_factor = getprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[5]") /53700.00;
	payload_factor =  payload_factor +  (getprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[1]") - 29250.0) / 26850.00;
	# OMS kit
	payload_factor = payload_factor + getprop("/fdm/jsbsim/propulsion/tank[27]/contents-lbs")/53700.0;
	payload_factor = payload_factor + getprop("/fdm/jsbsim/propulsion/tank[26]/contents-lbs")/53700.0;

	var geo_factor = math.sin(heading) * math.cos(lat);

	# during the ballistic ascent, pitch target depends on number of good engines
	# to allow 3 engine TAL

	var pitch_tgt = 35.0 + 12.0 * payload_factor + 12.0 - 15.0 * geo_factor;

	var num_engines = getprop("/fdm/jsbsim/systems/mps/number-engines-operational");
	if (num_engines == 3) 
		{pitch_tgt = 5.0 + 5.0 * payload_factor + 4.0 - 6.0 * geo_factor;}

	setprop("/fdm/jsbsim/systems/ap/launch/pitch-target",pitch_tgt) ;

	}

auto_TAL_loop();

}



var auto_TAL_loop = func {


var abort_mode = getprop("/fdm/jsbsim/systems/abort/abort-mode");

if (abort_mode > 4) # a contingency abort has been called
	{return;}

if (auto_launch_stage == 3)
	{

	var shuttle_pos = geo.aircraft_position();
	
	var course_tgt = shuttle_pos.course_to (SpaceShuttle.landing_site);
	setprop("/fdm/jsbsim/systems/ap/launch/course-target", course_tgt);


	# compute MECO target
	# ballistic impact range approx. range to site

	var a = getprop("/fdm/jsbsim/systems/orbital/semimajor-axis-length-ft");
	var epsilon = getprop("/fdm/jsbsim/systems/orbital/epsilon");
	var R = getprop("/position/sea-level-radius-ft");
	
	var A = -a*a * epsilon * epsilon;
	var B = -2.0 * a * a * a * epsilon;
	var C = a*a * (R*R - a*a );

	var x = 1.0/(2.0 * A) * (-B - math.sqrt(B*B - 4.0 * A * C)) + a * epsilon;
	
	var arg = x/R;

	var dist_ballistic = math.acos(arg) * R * 0.3048;
	var dist = shuttle_pos.distance_to (SpaceShuttle.landing_site);

	setprop("/fdm/jsbsim/systems/ap/launch/distance-ballistic-km", dist_ballistic/1000.0);
	setprop("/fdm/jsbsim/systems/ap/launch/distance-site-km", dist/1000.0);

	# during the ballistic ascent, pitch target depends on number of good engines
	# to allow 3 engine TAL

	var num_engines = getprop("/fdm/jsbsim/systems/mps/number-engines-operational");
	var pitch_tgt = 30.0;
	if (num_engines == 3) {pitch_tgt = 10.0;}

	var alt = getprop("//position/altitude-ft");

	if (alt > 480000.0)
		{
		var pitch_corr = (alt - 480000)/1000.0;
		pitch_tgt = pitch_tgt - pitch_corr;
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-target", pitch_tgt);
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-max-rate-norm", 0.15);
		aux_flag = 1;
		}


	if (((getprop("/fdm/jsbsim/velocities/v-down-fps") > -500.0) or (alt > 508530.0)) and (aux_flag == 0))
		{
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-target", pitch_tgt);
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-max-rate-norm", 0.1);
		aux_flag = 1;
		}
	else if ((getprop("/fdm/jsbsim/velocities/v-down-fps") >  120.0) and (aux_flag == 1))
		{
		auto_launch_stage = 4;
		setprop("/fdm/jsbsim/systems/ap/launch/stage", 4);
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-max-rate-norm", 0.1);
		setprop("/fdm/jsbsim/systems/ap/launch/hdot-target", 50.0);
		droop_guidance.init();
		aux_flag = 0;
		}	
	
	}
else if (auto_launch_stage == 4)
	{

	var shuttle_pos = geo.aircraft_position();
	
	var course_tgt = shuttle_pos.course_to (SpaceShuttle.landing_site);
	setprop("/fdm/jsbsim/systems/ap/launch/course-target", course_tgt);

	var alt = getprop("/position/altitude-ft");
	var mach = getprop("/fdm/jsbsim/velocities/mach");
	droop_guidance.run (alt);


	if ((alt < 420000.0) and (mach < 23.0))
		{
		var hdot_tgt = 50.0 - (420000.0 - alt)/150.0;
		setprop("/fdm/jsbsim/systems/ap/launch/hdot-target", hdot_tgt);
		}
	else if ((alt > 470000.0) and (mach < 23.0))
		{
		var hdot_tgt = 50.0 + (alt - 470000.0)/150.0;
		setprop("/fdm/jsbsim/systems/ap/launch/hdot-target", hdot_tgt);
		}

	
	# dynamically throttle back when we reach acceleration limit
	
	if (getprop("/fdm/jsbsim/accelerations/n-pilot-x-norm") > 2.85)
		{


		# an engine can be in electric lockup, so we may need to look at more engines
		# to determine current throttle value

		var current_throttle = 1; 

		if (SpaceShuttle.failure_cmd.ssme1 == 1)
			{current_throttle = getprop("/controls/engines/engine[0]/throttle");}
		else if (SpaceShuttle.failure_cmd.ssme2 == 1)
			{current_throttle = getprop("/controls/engines/engine[1]/throttle");}
		else
			{current_throttle = getprop("/controls/engines/engine[2]/throttle");}

		var new_throttle = current_throttle * 0.99;

		#if (new_throttle < 0.61) {new_throttle = 0.61;}

		if (getprop("/fdm/jsbsim/systems/ap/automatic-sb-control") == 1)
			{
			if (SpaceShuttle.failure_cmd.ssme1 == 1)
				{setprop("/controls/engines/engine[0]/throttle", new_throttle);}
			if (SpaceShuttle.failure_cmd.ssme2 == 1)
				{setprop("/controls/engines/engine[1]/throttle", new_throttle);}
			if (SpaceShuttle.failure_cmd.ssme3 == 1)
				{setprop("/controls/engines/engine[2]/throttle", new_throttle);}
			}

		}

	# we need to pitch up briskly, but then reduce sensitivity to avoid oscillations
	# insert a Mach cut in case the TAL init happens late and we never pitch up so much

	if ((aux_flag == 0) and ((mach > 10.0) or (getprop("/orientation/pitch-deg") > 40.0)))
		{
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-max-rate-norm", 0.05);
		aux_flag = 1;
		}

	# automatic roll to heads up attitude

	if ((aux_flag == 1) and (mach > 14.0))
		{
		#if (getprop("/fdm/jsbsim/systems/ap/launch/rthu-enable") == 1)
		if ((getprop("/fdm/jsbsim/systems/ap/launch/rthu-enable") == 1) and (getprop("/fdm/jsbsim/systems/fcs/control-mode") != 13))
			{
			setprop("/fdm/jsbsim/systems/ap/launch/pitch-max-rate-norm", 0.15);
			setprop("/fdm/jsbsim/systems/ap/launch/rthu-cmd", 1);
			}
		aux_flag = 2;
		}
	else if ((aux_flag == 2) and (getprop("/fdm/jsbsim/systems/ap/launch/stage4-rthu-in-in-progress") == 0))
		{
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-max-rate-norm", 0.05);
		aux_flag = 3;
		}


	# change hdot target to 0 prior to MECO

	if ((aux_flag == 3) and (mach > 23.0))
		{
		setprop("/fdm/jsbsim/systems/ap/launch/hdot-target", 0.0);
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-max-rate-norm", 0.03);
		aux_flag = 4;
		} 

	# compute MECO target
	# ballistic impact range approx. range to site

	var a = getprop("/fdm/jsbsim/systems/orbital/semimajor-axis-length-ft");
	var epsilon = getprop("/fdm/jsbsim/systems/orbital/epsilon");
	var R = getprop("/position/sea-level-radius-ft");
	
	var A = -a*a * epsilon * epsilon;
	var B = -2.0 * a * a * a * epsilon;
	var C = a*a * (R*R - a*a );

	var x = 1.0/(2.0 * A) * (-B - math.sqrt(B*B - 4.0 * A * C)) + a * epsilon;
	
	var arg = SpaceShuttle.clamp(x/R, 0.0, 1.0);

	var dist_ballistic = math.acos(arg) * R * 0.3048;
	var dist = shuttle_pos.distance_to (SpaceShuttle.landing_site);

	setprop("/fdm/jsbsim/systems/ap/launch/ballistic-distance-km", dist_ballistic/1000.0);

	# MECO if apoapsis target is met

	if (dist_ballistic >  (dist - 700000.0))
		{


		if (getprop("/fdm/jsbsim/systems/ap/automatic-sb-control") == 1)
			{	
			if (SpaceShuttle.failure_cmd.ssme1 == 1)
				{setprop("/controls/engines/engine[0]/throttle", 0.0);}
			if (SpaceShuttle.failure_cmd.ssme2 == 1)
				{setprop("/controls/engines/engine[1]/throttle", 0.0);}
			if (SpaceShuttle.failure_cmd.ssme3 == 1)
				{setprop("/controls/engines/engine[2]/throttle", 0.0);}

	    		setprop("/fdm/jsbsim/systems/mps/engine[0]/run-cmd", 0);
    			setprop("/fdm/jsbsim/systems/mps/engine[1]/run-cmd", 0);
    			setprop("/fdm/jsbsim/systems/mps/engine[2]/run-cmd", 0);

			}

		setprop("/fdm/jsbsim/systems/ap/launch/regular-meco-condition",1);
		print ("MECO - auto-TAL guidance signing off!");
		print ("Have a good entry and remember to close umbilical doors!");

		# use RCS to null residual rates and disengage launch AP

		settimer( func {
			setprop("/fdm/jsbsim/systems/fcs/control-mode",20);
			controls.centerFlightControls();

			setprop("/fdm/jsbsim/systems/ap/css-pitch-control", 1);
			setprop("/fdm/jsbsim/systems/ap/automatic-pitch-control", 0);    
			setprop("/fdm/jsbsim/systems/ap/css-roll-control", 1);
			setprop("/fdm/jsbsim/systems/ap/automatic-roll-control", 0);

			}, 2.0);

		# prepare ETsep and MM 104 transition

		settimer( external_tank_separate, 20.0);

		settimer( func {
			setprop("/fdm/jsbsim/systems/dps/major-mode", 104);
			SpaceShuttle.dk_listen_major_mode_transition(104);
			SpaceShuttle.ops_transition_auto("p_dps_mnvr");
			}, 23.0);

		# start main orbital loop
		orbital_loop_init();

		SpaceShuttle.mission_post_meco_TAL();	


		return;
		}
	}



auto_launch_timer = auto_launch_timer + 0.1;

settimer(auto_TAL_loop, 0.1);
}



var droop_guidance = {

	droop_alt: 0.0,
	R_sea: 6700000.0,
	pitch_tgt: 74.0,
	pitch_tgt_flown: 74.0,
	pitch_tgt_set: 0,
	active: 0,
	running_engine: -1,

	init: func {

		me.R_sea = getprop("/position/sea-level-radius-ft") * 0.3048;

		me.nd_ref_v_down =  props.globals.getNode("/fdm/jsbsim/velocities/v-down-fps", 1);
		me.nd_ref_v_inrtl = props.globals.getNode("/fdm/jsbsim/velocities/eci-velocity-mag-fps", 1);
		me.nd_ref_thrust1 = props.globals.getNode("/fdm/jsbsim/propulsion/engine[0]/thrust-lbs", 1);
		me.nd_ref_thrust2 = props.globals.getNode("/fdm/jsbsim/propulsion/engine[1]/thrust-lbs", 1);
		me.nd_ref_thrust3 = props.globals.getNode("/fdm/jsbsim/propulsion/engine[2]/thrust-lbs", 1);
		me.nd_ref_mass = props.globals.getNode("/fdm/jsbsim/inertia/weight-lbs", 1);

	},

	engage: func {
		me.active = 1;
		setprop("/fdm/jsbsim/systems/ap/launch/droop-guidance-active", 1);
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-max-rate-norm", 0.15);

		
	},

	disengage: func {
		me.active = 0;
		setprop("/fdm/jsbsim/systems/ap/launch/droop-guidance-active", 0);
		setprop("/fdm/jsbsim/systems/ap/launch/pitch-max-rate-norm", 0.05);
	},


	droop_trajectory : func (t, phi, y0, vy0, vx0, T, R, Delta) {

		var phi_rad = phi * math.pi/180.0;

		var cphi = math.cos(phi_rad);
		var sphi = math.sin(phi_rad);

		var A = 0.5 * (T * sphi - 9.41 + vx0*vx0/R);
		var B = 0.333 * (T/R * vx0 * cphi + 0.5 * Delta * sphi);
		var C = 0.08333 * (T*T/R * cphi * cphi + vx0/R * Delta * cphi);
		var D = 0.05 * (T * Delta / R * math.pow(cphi, 2.0));
		var E = 0.008333 * (Delta * Delta/R * cphi * cphi);

		return y0 + vy0 * t + A* math.pow(t, 2.0) + B * math.pow(t, 3.0) + C * math.pow(t, 4.0) + D * math.pow(t, 5.0) + E * math.pow(t, 6.0);
		},

	run : func (altitude) {

		if (me.pitch_tgt < 35.0) 
			{
			#if (me.active == 1) {me.disengage();}
			if (me.active == 0) 
				{
				#print ("Droop guidance signing off."); 
				return;
				}
			}

		#print ("Pitch tgt: ", me.pitch_tgt);

		if (me.droop_alt > 110000)
			{
			me.pitch_tgt = me.pitch_tgt - 1.0;
			if (me.pitch_tgt_set == 0)
				{
				me.pitch_tgt_flown = me.pitch_tgt;
				}
			}




		var y0 = altitude * 0.3048;
		var R = y0 + me.R_sea;


		var vy0 = -me.nd_ref_v_down.getValue() * 0.3048;
		var vx0 = me.nd_ref_v_inrtl.getValue() * 0.3048;

		var n_engines = getprop("/fdm/jsbsim/systems/mps/number-engines-operational");

		if (me.active == 1)
			{
			if (me.pitch_tgt_set == 0)
				{
				setprop("/fdm/jsbsim/systems/ap/launch/droop-pitch-target", me.pitch_tgt);
				me.pitch_tgt_flown = me.pitch_tgt;
				me.pitch_tgt_set = 1;
				}
		
			if (vy0 > 0.0) 
				{
				me.disengage();
				me.pitch_tgt = 0.0;
				}
			}

		else if (me.active == 0)
			{
			if (n_engines == 1)
				{			
				me.engage();
				}
			}



		var T = me.nd_ref_thrust1.getValue();
		T = T + me.nd_ref_thrust2.getValue();
		T = T + me.nd_ref_thrust3.getValue();

		var throttle_setting = T/(n_engines * 509002.0);

		var M = me.nd_ref_mass.getValue();

		T = T /M;
		T = T/n_engines;


		T = T * 9.81;
		T = T * 0.97;



		var Delta = M/(M - (1125.0 * throttle_setting)) - 1.0;
		Delta = Delta * 9.81;

		var alt_last = 1000000.0;
		var alt = 0.0;



		for (var i=0; i< 35; i=i+1)
			{
			alt = me.droop_trajectory (i * 15.0 + 15.0, me.pitch_tgt_flown, y0, vy0, vx0, T, R, Delta);
		
			if (alt > alt_last) 
				{

				me.droop_alt =  alt_last;
				return;
				}
			else if (alt < 0.0)
				{

				me.droop_alt =  0.0;
				return;
				}


			alt_last = alt;
			}
		me.droop_alt = alt;
		return;
		},


};

var meco_time = {

	
	time_to_meco: 0.0,
	inertial_target: 0.0,
	counter: 0,
	mode: 0,
	delta_met: 0,


	init: func (inertial_target) {

		me.nd_ref_v_inrtl = props.globals.getNode("/fdm/jsbsim/velocities/eci-velocity-mag-fps", 1);
		me.nd_ref_thrust1 = props.globals.getNode("/fdm/jsbsim/propulsion/engine[0]/thrust-lbs", 1);
		me.nd_ref_thrust2 = props.globals.getNode("/fdm/jsbsim/propulsion/engine[1]/thrust-lbs", 1);
		me.nd_ref_thrust3 = props.globals.getNode("/fdm/jsbsim/propulsion/engine[2]/thrust-lbs", 1);
		me.nd_ref_mass = props.globals.getNode("/fdm/jsbsim/inertia/weight-lbs", 1);

		me.inertial_target = inertial_target * 0.3048;

		me.delta_met = getprop("/fdm/jsbsim/systems/timer/delta-MET");

	},
	
	run: func {

		if (me.mode == 2) {return;}


		# don't need to execute in every guidance cycle
		if (me.counter == 5) 
			{me.counter = 0;}
		else
			{
			me.counter = me.counter + 1;
			return;
			}		
			
		var n_engines = getprop("/fdm/jsbsim/systems/mps/number-engines-operational");

		var T = me.nd_ref_thrust1.getValue();
		T = T + me.nd_ref_thrust2.getValue();
		T = T + me.nd_ref_thrust3.getValue();

		var throttle_setting = T/(n_engines * 509002.0);

		var M = me.nd_ref_mass.getValue();

		var a0 = T/M;
		a0 = a0 * 9.81;

		# to SI units
		M = M * 0.45359237;
		T = T * 4.44822161526;

		#print ("Current acceleration: ", a0/9.81, " g");
		#print ("Current mass:" , M, " kg");
		#print ("Current thrust:", T, " N");

		var mdot = 1313.5 * throttle_setting;

		var v0 = me.nd_ref_v_inrtl.getValue() * 0.3048;

		var t_3g = 0.0;
		var v_3g = v0;

		if (me.mode == 0)
			{
			t_3g = (29.43 * M - T) / (29.43 * mdot );
			v_3g = v0 + 4434.12 * math.ln(M/(M - mdot * t_3g));
			}

		#print ("Time to throttling: ", t_3g, " s");
		#print ("Inertial velocity at throttling: ", v_3g, " m/s");

		me.time_to_meco = t_3g + (me.inertial_target - v_3g) / 29.43;

		#print ("Time to MECO: ", me.time_to_meco, " s");

		

	},


	set_mode: func (mode) {

		me.mode = mode;

	},

	get_mode: func () {

		return me.mode;

	},

	get: func () {

		return me.time_to_meco + me.delta_met;
	},


};

