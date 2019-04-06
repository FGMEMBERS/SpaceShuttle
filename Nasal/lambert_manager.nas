# logic to manage Lambert and CW targeting 
# for Space Shuttle orbital maneuvering
# Thorsten Renk 2019



######################################
# Lambert targeting preparation
######################################

var lambert_manager = {

	target_t1_x: 0.0,
	target_t1_y: 0.0,
	target_t1_z: 0.0,
	
	target_t1_vx: 0.0,
	target_t1_vy: 0.0,
	target_t1_vz: 0.0,

	target_t2_x: 0.0,
	target_t2_y: 0.0,
	target_t2_z: 0.0,
	
	target_t2_vx: 0.0,
	target_t2_vy: 0.0,
	target_t2_vz: 0.0,

	target_initial_x: 0.0,
	target_initial_y: 0.0,
	target_initial_z: 0.0,

	target_initial_vx: 0.0,
	target_initial_vy: 0.0,
	target_initial_vz: 0.0,

	chaser_t1_x: 0.0,
	chaser_t1_y: 0.0,
	chaser_t1_z: 0.0,

	chaser_t1_vx: 0.0,
	chaser_t1_vy: 0.0,
	chaser_t1_vz: 0.0,

	chaser_initial_x: 0.0,
	chaser_initial_y: 0.0,
	chaser_initial_z: 0.0,

	chaser_initial_vx: 0.0,
	chaser_initial_vy: 0.0,
	chaser_initial_vz: 0.0,

	initial_prox_x: 0.0,
	initial_prox_y: 0.0,
	initial_prox_z: 0.0,

	offset_x: 0.0,
	offset_y: 0.0,
	offset_z: 0.0,

	valid_t1: 0,
	valid_t2: 0,

	delta_t: 0.0,

	t1_in_progress: 0,
	t2_in_progress: 0,

	lock: 0,

	pa_ready: 0,
	pa_time: 0,
	pa_tig: 0,
	pa_dvy: 0.0,

	t_initial: 0.0,

	cw_flag: 0,

	compute_to_t1: func {


		if (me.lock == 1) {print ("Lambert manager: Another computation is in progress!"); return;}
		me.lock = 1;
		me.cw_flag = 0;

		print ("Lambert targeting to TIG 1 started...");
		var met = SpaceShuttle.get_MET();
		var tig1 = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-tig");

		var delta_t = tig1 - met;

		if (delta_t < 0.0) 
			{
			print ("Ignition time is in the past.");
			me.lock = 0;
			return;
			}

		var elapsed_future = getprop("/sim/time/elapsed-sec") + delta_t;

		var tgt_pos1 = SpaceShuttle.oTgt.get_inertial_pos_at_time(elapsed_future);
		me.target_t1_x = tgt_pos1[0];
		me.target_t1_y = tgt_pos1[1];
		me.target_t1_z = tgt_pos1[2];

		var tgt_vel1 = SpaceShuttle.oTgt.get_inertial_speed_at_time(elapsed_future);
		me.target_t1_vx = tgt_vel1[0];
		me.target_t1_vy = tgt_vel1[1];
		me.target_t1_vz = tgt_vel1[2];

		#var tmp_pos = SpaceShuttle.oTgt.get_inertial_pos();

		SpaceShuttle.targeting_manager.parameter_reset();
		SpaceShuttle.targeting_manager.capture_current();
	
		

		SpaceShuttle.targeting_manager.set_acceleration(0.51);
		SpaceShuttle.targeting_manager.max_evolution_time = delta_t;
		
		#SpaceShuttle.targeting_manager.set_target_state(tmp_pos[0], tmp_pos[1], tmp_pos[2], me.target_t1_vx, me.target_t1_vy, me.target_t1_vz);

		#SpaceShuttle.targeting_manager.compute_geometry();
		#SpaceShuttle.targeting_manager.compute_proximity();
		#SpaceShuttle.targeting_manager.list_proximity();

		SpaceShuttle.targeting_manager.set_target_state(me.target_t1_x, me.target_t1_y, me.target_t1_z, me.target_t1_vx, me.target_t1_vy, me.target_t1_vz);


		print ("Setting target velocities to ");
		print ("Target T1 vx: ", me.target_t1_vx);
		print ("Target T1 vy: ", me.target_t1_vy);
		print ("Target T1 vz: ", me.target_t1_vz);

		SpaceShuttle.targeting_manager.start();

		me.t1_in_progress = 1;
		me.t1_holding_loop();

	},

	t1_holding_loop: func {

		if (SpaceShuttle.targeting_manager.evolution_finished == 0) 
			{settimer ( func {me.t1_holding_loop();}, 1.0);}
		else
			{
			me.t1_finished();
			}
	},

	t1_finished: func {

		SpaceShuttle.targeting_manager.compute_proximity();
		SpaceShuttle.targeting_manager.compute_proximity_v();

		SpaceShuttle.targeting_manager.list_proximity();
		SpaceShuttle.targeting_manager.list_proximity_v();

		me.chaser_t1_x = SpaceShuttle.targeting_manager.pos[0];
		me.chaser_t1_y = SpaceShuttle.targeting_manager.pos[1];
		me.chaser_t1_z = SpaceShuttle.targeting_manager.pos[2];

		me.chaser_t1_vx = SpaceShuttle.targeting_manager.vel[0];
		me.chaser_t1_vy = SpaceShuttle.targeting_manager.vel[1];
		me.chaser_t1_vz = SpaceShuttle.targeting_manager.vel[2];
	
		setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-dx", SpaceShuttle.targeting_manager.target_prox_x/0.3048/1000.0);
		setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-dy", SpaceShuttle.targeting_manager.target_prox_y/0.3048/1000.0);
		setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-dz", SpaceShuttle.targeting_manager.target_prox_z/0.3048/1000.0);

		setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-dxdot", SpaceShuttle.targeting_manager.target_prox_vx/0.3048);
		setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-dydot", SpaceShuttle.targeting_manager.target_prox_vy/0.3048);
		setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-dzdot", SpaceShuttle.targeting_manager.target_prox_vz/0.3048);

		#SpaceShuttle.targeting_manager.list_proximity();

		me.valid_t1 = 1;

		me.compute_to_t2();
		
	},

	compute_to_t2: func {

		if (me.valid_t1 == 0)
			{
			print ("Compute T1 first!");
			me.lock = 0;
			return;
			}

		var tig1 = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-tig");
		var tig2 = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-tig");
		var delta_t = tig2 - tig1;

		var met = SpaceShuttle.get_MET();
		var delta_t2 = tig2 - met;

		var elapsed_future = getprop("/sim/time/elapsed-sec") + delta_t2;

		var tgt_pos1 = SpaceShuttle.oTgt.get_inertial_pos_at_time(elapsed_future);
		me.target_t2_x = tgt_pos1[0];
		me.target_t2_y = tgt_pos1[1];
		me.target_t2_z = tgt_pos1[2];

		var tgt_vel1 = SpaceShuttle.oTgt.get_inertial_speed_at_time(elapsed_future);
		me.target_t2_vx = tgt_vel1[0];
		me.target_t2_vy = tgt_vel1[1];
		me.target_t2_vz = tgt_vel1[2];

		if (delta_t < 0.0) 
			{
			print ("T2 Ignition time is before T1.");
			me.lock = 0;
			return;
			}

		me.offset_x = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dx") * 1000.0 * 0.3048;
		me.offset_y = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dy") * 1000.0 * 0.3048;
		me.offset_z = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dz") * 1000.0 * 0.3048;

		SpaceShuttle.targeting_manager.parameter_reset();
		SpaceShuttle.targeting_manager.set_lambert(0.0, tig2-tig1, me.offset_x, me.offset_y, me.offset_z);


		SpaceShuttle.targeting_manager.set_target_state(me.target_t2_x, me.target_t2_y, me.target_t2_z, me.target_t2_vx, me.target_t2_vy, me.target_t2_vz);


		SpaceShuttle.targeting_manager.start();

		me.t2_holding_loop();

	},

	t2_holding_loop: func {

		if (SpaceShuttle.targeting_manager.evolution_finished == 0) 
			{settimer ( func {me.t2_holding_loop();}, 1.0);}
		else
			{
			me.t2_finished();
			}
	},

	t2_finished: func {

		me.t1_in_progress = 0;
		
		SpaceShuttle.targeting_manager.compute_proximity();
		SpaceShuttle.targeting_manager.compute_proximity_v();
		SpaceShuttle.targeting_manager.list_proximity();

		setprop("/fdm/jsbsim/systems/ap/oms-plan/dvx", SpaceShuttle.targeting_manager.dvx/0.3048);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/dvy", SpaceShuttle.targeting_manager.dvy/0.3048);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/dvz", SpaceShuttle.targeting_manager.dvz/0.3048);

		setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dvx", SpaceShuttle.targeting_manager.dvx2);
		setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dvy", SpaceShuttle.targeting_manager.dvy2);
		setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dvz", SpaceShuttle.targeting_manager.dvz2);

		var match = math.abs(SpaceShuttle.targeting_manager.target_prox_x - me.offset_x)/0.3048;

		if (math.abs(SpaceShuttle.targeting_manager.target_prox_y - me.offset_y)/0.3048 > match)
			{
			match = math.abs(SpaceShuttle.targeting_manager.target_prox_y - me.offset_y)/0.3048;
			}

		if (math.abs(SpaceShuttle.targeting_manager.target_prox_z - me.offset_z)/0.3048 > match)
			{
			match = math.abs(SpaceShuttle.targeting_manager.target_prox_z - me.offset_z)/0.3048;
			}


		setprop("/fdm/jsbsim/systems/ap/orbit-tgt/pred-match-ft", match);


		setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-days", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-tig-d"));
		setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-hours", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-tig-h"));
		setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-minutes", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-tig-m"));
		setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-seconds", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-tig-s"));
		#setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-string", tig1_string);

		SpaceShuttle.set_oms_mnvr_timer();

		me.lock = 0;
	},


	show_t2: func {

		if (me.cw_flag == 0)
			{
			if (SpaceShuttle.proximity_manager.iss_model == 0)
				{
				setprop("/fdm/jsbsim/systems/ap/oms-plan/dvx", SpaceShuttle.targeting_manager.dvx2/0.3048);
				setprop("/fdm/jsbsim/systems/ap/oms-plan/dvy", -SpaceShuttle.targeting_manager.dvy2/0.3048);
				setprop("/fdm/jsbsim/systems/ap/oms-plan/dvz", SpaceShuttle.targeting_manager.dvz2/0.3048);
				}
			else
				{
				me.lcw_target_to_t2();
				return;
				}
			}	
		else
			{
			setprop("/fdm/jsbsim/systems/ap/oms-plan/dvx", SpaceShuttle.targeting_manager.dvx2/0.3048);
			setprop("/fdm/jsbsim/systems/ap/oms-plan/dvy", SpaceShuttle.targeting_manager.dvy2/0.3048);
			setprop("/fdm/jsbsim/systems/ap/oms-plan/dvz", SpaceShuttle.targeting_manager.dvz2/0.3048);
			}
		
		var tig2_s = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-tig");

		tig2_s -= (SpaceShuttle.targeting_manager.tig2 - SpaceShuttle.targeting_manager.tig2_real);
		var tig2_d = int(tig2_s / 86400.0);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-days", tig2_d);
		tig2_s -= tig2_d * 86400.0;

		var tig2_h = int (tig2_s / 3600.0);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-hours", tig2_h);
		tig2_s -= tig2_h * 3600.0;

		var tig2_m = int (tig2_s / 60.0);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-minutes", tig2_m);

		tig2_s -= tig2_m * 60.0;
		setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-seconds", tig2_s);

		SpaceShuttle.set_oms_mnvr_timer();

		me.t2_in_progress = 0;

		setprop("/fdm/jsbsim/systems/ap/orbit-tgt/pred-match-ft", 0.0);



	},

	
	cw_capture_current: func {

		# we need a consistent same-frame snapshot of both chaser and target inertial pos
		# so the best way to do that is to utilize relative coordinates

		me.chaser_initial_x = getprop("/fdm/jsbsim/position/eci-x-ft") * 0.3048;
		me.chaser_initial_y = getprop("/fdm/jsbsim/position/eci-y-ft") * 0.3048;
		me.chaser_initial_z = getprop("/fdm/jsbsim/position/eci-z-ft") * 0.3048;

		me.chaser_initial_vx = getprop("/fdm/jsbsim/velocities/eci-x-fps") * 0.3048;
		me.chaser_initial_vy = getprop("/fdm/jsbsim/velocities/eci-y-fps") * 0.3048;
		me.chaser_initial_vz = getprop("/fdm/jsbsim/velocities/eci-z-fps") * 0.3048;

		var prox_x = SpaceShuttle.proximity_manager.target_prox_x;
		var prox_y = SpaceShuttle.proximity_manager.target_prox_y;
		var prox_z = SpaceShuttle.proximity_manager.target_prox_z;

		var prox_vx = SpaceShuttle.proximity_manager.target_prox_vx;
		var prox_vy = SpaceShuttle.proximity_manager.target_prox_vy;
		var prox_vz = SpaceShuttle.proximity_manager.target_prox_vz;

		print ("Prox x: ", prox_x);
		print ("Prox y: ", prox_y);
		print ("Prox z: ", prox_z);

		print ("Prox vx: ", prox_vx);
		print ("Prox vy: ", prox_vy);
		print ("Prox vz: ", prox_vz);

		me.initial_prox_x = prox_x;
		me.initial_prox_y = prox_y;
		me.initial_prox_z = prox_z;


		# some empirical corrections

		prox_x += 125.0;

		# z correction based on virtual force

		var prox_z_geo = ( -1.06166e-06* prox_z +  0.000321216 ) * me.delta_t * me.delta_t;
		prox_z += prox_z_geo;
		#print ("z_geo: ", prox_z_geo);

		me.t_initial = SpaceShuttle.get_MET();

		var coord = geo.Coord.new();
		coord.set_xyz(me.chaser_initial_x, me.chaser_initial_y, me.chaser_initial_z);
		coord.set_alt( coord.alt() - prox_z);

		#var course = getprop("/fdm/jsbsim/velocities/course-deg");

		var v_east = getprop("/fdm/jsbsim/velocities/v-east-fps");
		var v_north = getprop("/fdm/jsbsim/velocities/v-north-fps");
		var lat   = getprop("/position/latitude-deg") * math.pi/180.0;

		v_east += 465.1/0.3048 * math.cos(lat);

		var course_alt = math.atan2(v_east, v_north) * 180.0/math.pi;


		coord.apply_course_distance(course_alt, prox_x * 6378138.12  / (coord.alt() + 6378138.12));

		if (prox_y > 0) {course_alt = course_alt - 90.0;}
		else {course_alt = course_alt + 90.0;}
		coord.apply_course_distance(course_alt, math.abs(prox_y) * 6378138.12  / (coord.alt() + 6378138.12));


		me.target_initial_x = coord.x();
		me.target_initial_y = coord.y();
		me.target_initial_z = coord.z();


		me.target_initial_vx = me.chaser_initial_vx;
		me.target_initial_vy = me.chaser_initial_vy;
		me.target_initial_vz = me.chaser_initial_vz;

		var v_norm = SpaceShuttle.normalize([me.target_initial_vx, me.target_initial_vy, me.target_initial_vz]);
		var r_norm = SpaceShuttle.normalize([me.target_initial_x, me.target_initial_y, me.target_initial_z]);
		var n_norm = SpaceShuttle.normalize(SpaceShuttle.cross_product(r_norm, v_norm));
		
		var v = SpaceShuttle.norm([me.target_initial_vx, me.target_initial_vy, me.target_initial_vz]);
		var r = SpaceShuttle.norm([me.target_initial_x, me.target_initial_y, me.target_initial_z]);

		# now we're only interested in the v difference that is not simple geometry	

		var prox_vx_geo = v * (1.0 - r / (r + prox_z));

		print ("vx_geo: ", prox_vx_geo);
		prox_vx = prox_vx - prox_vx_geo;



		me.target_initial_vx += (v_norm[0] * prox_vx + n_norm[0] * prox_vy - r_norm[0] * prox_vz); 
		me.target_initial_vy += (v_norm[1] * prox_vx + n_norm[1] * prox_vy - r_norm[1] * prox_vz); 
		me.target_initial_vz += (v_norm[2] * prox_vx + n_norm[2] * prox_vy - r_norm[2] * prox_vz); 
	
		# approx effect of Earth curvature
		me.target_initial_vx += -r_norm[0] * prox_x/1000.0 * 1.153;
		me.target_initial_vy += -r_norm[1] * prox_x/1000.0 * 1.153;
		me.target_initial_vz += -r_norm[2] * prox_x/1000.0 * 1.153;



	},


	cw_target_to_t1: func {

		if (me.lock == 1) {print ("Lambert manager: Another computation is in progress!"); return;}
		me.lock = 1;
		me.cw_flag = 1;


		if (me.t1_in_progress == 1)
			{
			print ("CW targeting already in progress...");
			return;
			}

		print ("CW target to TIG 1 started...");
		var met = SpaceShuttle.get_MET();
		var tig1 = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-tig");
		#me.test_time1 = time1;
		#me.test_time2 = time2;
		
		#tig1 = met + me.test_time1;

		# time to t1
		var delta_t = tig1 - met;

		# total perdiction horizon
		var tig2 = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-tig");
		me.delta_t = tig2 - met;

		if (delta_t < 0.0) 
			{
			print ("Ignition time is in the past.");
			me.lock = 0;
			return;
			}

		#print ("Target Delta T is : ", delta_t);

		SpaceShuttle.targeting_manager.parameter_reset();

		me.cw_capture_current();
	
		SpaceShuttle.targeting_manager.pos[0] = me.target_initial_x;
		SpaceShuttle.targeting_manager.pos[1] = me.target_initial_y;
		SpaceShuttle.targeting_manager.pos[2] = me.target_initial_z;
	
		SpaceShuttle.targeting_manager.vel[0] = me.target_initial_vx;
		SpaceShuttle.targeting_manager.vel[1] = me.target_initial_vy;
		SpaceShuttle.targeting_manager.vel[2] = me.target_initial_vz;

		SpaceShuttle.targeting_manager.compute_geometry();

		SpaceShuttle.targeting_manager.t_offset = getprop("/sim/time/elapsed-sec");
		SpaceShuttle.targeting_manager.t = 0.0;

		#SpaceShuttle.targeting_manager.list_statevec();
	

		SpaceShuttle.targeting_manager.set_acceleration(0.51);
		SpaceShuttle.targeting_manager.max_evolution_time = delta_t;
		

		SpaceShuttle.targeting_manager.start();



		me.t1_in_progress = 1;
		me.cw_target_to_t1_holding_loop();

	},

	cw_target_to_t1_holding_loop: func {

		if (SpaceShuttle.targeting_manager.evolution_finished == 0) 
			{settimer ( func {me.cw_target_to_t1_holding_loop();}, 1.0);}
		else
			{
			me.cw_target_to_t1_finished();
			}
	},

	cw_target_to_t1_finished: func {



		me.target_t1_x = SpaceShuttle.targeting_manager.pos[0];
		me.target_t1_y = SpaceShuttle.targeting_manager.pos[1];
		me.target_t1_z = SpaceShuttle.targeting_manager.pos[2];	

		me.target_t1_vx = SpaceShuttle.targeting_manager.vel[0];
		me.target_t1_vy = SpaceShuttle.targeting_manager.vel[1];
		me.target_t1_vz = SpaceShuttle.targeting_manager.vel[2];

		me.cw_target_to_t2();

	},


	cw_target_to_t2: func {

		print ("CW target to TIG 2 started...");

		var tig1 = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-tig");
		var tig2 = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-tig");
		var delta_t = tig2 - tig1;

		#delta_t = me.test_time2;
		#delta_t = 100.0;

		SpaceShuttle.targeting_manager.parameter_reset();
		SpaceShuttle.targeting_manager.max_evolution_time = delta_t;
		SpaceShuttle.targeting_manager.start();

		me.cw_target_to_t2_holding_loop();
		

	},


	cw_target_to_t2_holding_loop: func {

		if (SpaceShuttle.targeting_manager.evolution_finished == 0) 
			{settimer ( func {me.cw_target_to_t2_holding_loop();}, 1.0);}
		else
			{
			me.cw_target_to_t2_finished();
			}
	},


	cw_target_to_t2_finished: func {


		me.target_t2_x = SpaceShuttle.targeting_manager.pos[0];
		me.target_t2_y = SpaceShuttle.targeting_manager.pos[1];
		me.target_t2_z = SpaceShuttle.targeting_manager.pos[2];	

		me.target_t2_vx = SpaceShuttle.targeting_manager.vel[0];
		me.target_t2_vy = SpaceShuttle.targeting_manager.vel[1];
		me.target_t2_vz = SpaceShuttle.targeting_manager.vel[2];


		SpaceShuttle.targeting_manager.set_target_state(me.target_t2_x, me.target_t2_y, me.target_t2_z, me.target_t2_vx, me.target_t2_vy, me.target_t2_vz);			


		me.cw_chaser_to_t1();
		

	},
	

	cw_chaser_to_t1: func {

		print ("CW chaser to TIG 1 started...");

		SpaceShuttle.targeting_manager.parameter_reset();

		var met = me.t_initial;
		var tig1 = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-tig");
		#tig1 = met + me.test_time1;
		#tig1 = met + 1.0;

		var delta_t = tig1 - met;

		#print ("Chaser Delta T is : ", delta_t);

		SpaceShuttle.targeting_manager.pos[0] = me.chaser_initial_x;
		SpaceShuttle.targeting_manager.pos[1] = me.chaser_initial_y;
		SpaceShuttle.targeting_manager.pos[2] = me.chaser_initial_z;
	
		SpaceShuttle.targeting_manager.vel[0] = me.chaser_initial_vx;
		SpaceShuttle.targeting_manager.vel[1] = me.chaser_initial_vy;
		SpaceShuttle.targeting_manager.vel[2] = me.chaser_initial_vz;

		SpaceShuttle.targeting_manager.compute_geometry();
		SpaceShuttle.targeting_manager.t = 0.0;

		SpaceShuttle.targeting_manager.set_target_state(me.target_t1_x, me.target_t1_y, me.target_t1_z, me.target_t1_vx, me.target_t1_vy, me.target_t1_vz);

	
		SpaceShuttle.targeting_manager.set_acceleration(0.51);
		SpaceShuttle.targeting_manager.max_evolution_time = delta_t;
		

		SpaceShuttle.targeting_manager.start();

		me.cw_chaser_to_t1_holding_loop();
			

	},

	cw_chaser_to_t1_holding_loop: func {

		if (SpaceShuttle.targeting_manager.evolution_finished == 0) 
			{settimer ( func {me.cw_chaser_to_t1_holding_loop();}, 1.0);}
		else
			{
			me.cw_chaser_to_t1_finished();
			}
	},

	cw_chaser_to_t1_finished: func {



		SpaceShuttle.targeting_manager.compute_geometry();
		SpaceShuttle.targeting_manager.compute_proximity();
		SpaceShuttle.targeting_manager.compute_proximity_v();
		SpaceShuttle.targeting_manager.list_proximity();
		SpaceShuttle.targeting_manager.list_proximity_v();

		# diagnostics
		#me.lock = 0;
		#me.t1_in_progress = 0;
		#return;

		SpaceShuttle.targeting_manager.mark_proximity_reference();

		me.cw_compute_to_t2();



	},


	cw_compute_to_t2: func {

		print ("CW targeting started...");

		var tig1 = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-tig");
		var tig2 = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-tig");
		var delta_t = tig2 - tig1;

		#delta_t = me.test_time2;

		SpaceShuttle.targeting_manager.parameter_reset();
		SpaceShuttle.targeting_manager.max_evolution_time = delta_t;
		print ("Delta T set to ", delta_t);


		me.offset_x = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dx") * 1000.0 * 0.3048;
		me.offset_y = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dy") * 1000.0 * 0.3048;
		me.offset_z = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dz") * 1000.0 * 0.3048;

		SpaceShuttle.targeting_manager.set_lambert(0.0, delta_t, me.offset_x, me.offset_y, me.offset_z);
		SpaceShuttle.targeting_manager.set_target_state(me.target_t2_x, me.target_t2_y, me.target_t2_z, me.target_t2_vx, me.target_t2_vy, me.target_t2_vz);

		SpaceShuttle.targeting_manager.lambert_cw_flag = 1;
		SpaceShuttle.targeting_manager.fit_verbose = 1;

		SpaceShuttle.targeting_manager.start();

		me.cw_compute_to_t2_holding_loop();

	},

	cw_compute_to_t2_holding_loop: func {

		if (SpaceShuttle.targeting_manager.evolution_finished == 0) 
			{settimer ( func {me.cw_compute_to_t2_holding_loop();}, 1.0);}
		else
			{
			me.cw_compute_to_t2_finished();
			}
	},

	cw_compute_to_t2_finished: func {

		SpaceShuttle.targeting_manager.compute_proximity();
		SpaceShuttle.targeting_manager.compute_proximity_v();
		SpaceShuttle.targeting_manager.list_proximity();
		SpaceShuttle.targeting_manager.list_proximity_v();

		me.t1_in_progress = 0;


		# correct geometrical v 
		var vx_offset = 0.0;
		var vz_offset = 0.0;

		var v = SpaceShuttle.norm([me.target_initial_vx, me.target_initial_vy, me.target_initial_vz]);
		var r = SpaceShuttle.norm([me.target_initial_x, me.target_initial_y, me.target_initial_z]);

		var prox_vx_geo = v * (1.0 - r / (r + me.initial_prox_z));

		#print ("vx_geo: ", prox_vx_geo);
		vx_offset = vx_offset - prox_vx_geo;

		print ("vx_offset: ", vx_offset);
		SpaceShuttle.targeting_manager.dvx2 += vx_offset;

		# correct pseudo-force v

		var prox_vz_geo = 0.64 * (0.3 + (me.initial_prox_z *  -2.34167e-6  -0.000175) * me.delta_t);
		print ("vz_geo: ", prox_vz_geo);
		vz_offset = vz_offset - prox_vz_geo;

		SpaceShuttle.targeting_manager.dvz2 += vz_offset;

		setprop("/fdm/jsbsim/systems/ap/oms-plan/dvx", SpaceShuttle.targeting_manager.dvx/0.3048);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/dvy", -SpaceShuttle.targeting_manager.dvy/0.3048);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/dvz", SpaceShuttle.targeting_manager.dvz/0.3048);

		setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dvx", SpaceShuttle.targeting_manager.dvx2);
		setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dvy", -SpaceShuttle.targeting_manager.dvy2);
		setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dvz", SpaceShuttle.targeting_manager.dvz2);

		var match = math.abs(SpaceShuttle.targeting_manager.target_prox_x - me.offset_x)/0.3048;

		if (math.abs(SpaceShuttle.targeting_manager.target_prox_y - me.offset_y)/0.3048 > match)
			{
			match = math.abs(SpaceShuttle.targeting_manager.target_prox_y - me.offset_y)/0.3048;
			}

		if (math.abs(SpaceShuttle.targeting_manager.target_prox_z - me.offset_z)/0.3048 > match)
			{
			match = math.abs(SpaceShuttle.targeting_manager.target_prox_z - me.offset_z)/0.3048;
			}


		setprop("/fdm/jsbsim/systems/ap/orbit-tgt/pred-match-ft", match);


		setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-days", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-tig-d"));
		setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-hours", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-tig-h"));
		setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-minutes", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-tig-m"));
		setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-seconds", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-tig-s"));
		#setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-string", tig1_string);

		SpaceShuttle.set_oms_mnvr_timer();

		me.lock = 0;
		

	},


	lcw_target_to_t2: func () {

		if (me.lock == 1) {print ("Lambert manager: Another computation is in progress!"); return;}
		me.lock = 1;



		if (me.t1_in_progress == 1)
			{
			print ("CW targeting already in progress...");
			return;
			}

		print ("CW target to TIG 2 started...");
		var met = SpaceShuttle.get_MET();
		var tig2 = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-tig");

		var delta_t = tig2 - met;

		if (delta_t < 0.0) 
			{
			print ("Ignition time is in the past.");
			me.lock = 0;
			return;
			}

		#print ("Target Delta T is : ", delta_t);

		SpaceShuttle.targeting_manager.parameter_reset();

		me.cw_capture_current();
	
		SpaceShuttle.targeting_manager.pos[0] = me.target_initial_x;
		SpaceShuttle.targeting_manager.pos[1] = me.target_initial_y;
		SpaceShuttle.targeting_manager.pos[2] = me.target_initial_z;
	
		SpaceShuttle.targeting_manager.vel[0] = me.target_initial_vx;
		SpaceShuttle.targeting_manager.vel[1] = me.target_initial_vy;
		SpaceShuttle.targeting_manager.vel[2] = me.target_initial_vz;


		SpaceShuttle.targeting_manager.compute_geometry();

		SpaceShuttle.targeting_manager.t_offset = getprop("/sim/time/elapsed-sec");
		SpaceShuttle.targeting_manager.t = 0.0;


		SpaceShuttle.targeting_manager.set_acceleration(0.51);
		SpaceShuttle.targeting_manager.max_evolution_time = delta_t;
		

		SpaceShuttle.targeting_manager.start();


		me.t2_in_progress = 1;
		me.lcw_target_to_t2_holding_loop();

	},

	lcw_target_to_t2_holding_loop: func {

		if (SpaceShuttle.targeting_manager.evolution_finished == 0) 
			{settimer ( func {me.lcw_target_to_t2_holding_loop();}, 1.0);}
		else
			{
			me.lcw_target_to_t2_finished();
			}
	},


	lcw_target_to_t2_finished: func {


		me.target_t2_x = SpaceShuttle.targeting_manager.pos[0];
		me.target_t2_y = SpaceShuttle.targeting_manager.pos[1];
		me.target_t2_z = SpaceShuttle.targeting_manager.pos[2];	

		me.target_t2_vx = SpaceShuttle.targeting_manager.vel[0];
		me.target_t2_vy = SpaceShuttle.targeting_manager.vel[1];
		me.target_t2_vz = SpaceShuttle.targeting_manager.vel[2];


		SpaceShuttle.targeting_manager.set_target_state(me.target_t2_x, me.target_t2_y, me.target_t2_z, me.target_t2_vx, me.target_t2_vy, me.target_t2_vz);			


		me.lcw_chaser_to_t2();
		

	},

	lcw_chaser_to_t2: func {

		print ("CW chaser to TIG 2 started...");

		SpaceShuttle.targeting_manager.parameter_reset();

		var met = me.t_initial;
		var tig2 = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-tig");


		var delta_t = tig2 - met;

		#print ("Chaser Delta T is : ", delta_t);

		SpaceShuttle.targeting_manager.pos[0] = me.chaser_initial_x;
		SpaceShuttle.targeting_manager.pos[1] = me.chaser_initial_y;
		SpaceShuttle.targeting_manager.pos[2] = me.chaser_initial_z;
	
		SpaceShuttle.targeting_manager.vel[0] = me.chaser_initial_vx;
		SpaceShuttle.targeting_manager.vel[1] = me.chaser_initial_vy;
		SpaceShuttle.targeting_manager.vel[2] = me.chaser_initial_vz;

		SpaceShuttle.targeting_manager.compute_geometry();
		SpaceShuttle.targeting_manager.t = 0.0;

		# diagnostics
		SpaceShuttle.targeting_manager.set_target_state(me.target_initial_x, me.target_initial_y, me.target_initial_z, me.target_initial_vx, me.target_initial_vy, me.target_initial_vz);

		SpaceShuttle.targeting_manager.compute_proximity();
		SpaceShuttle.targeting_manager.compute_proximity_v();
		SpaceShuttle.targeting_manager.list_proximity();
		SpaceShuttle.targeting_manager.list_proximity_v();

		SpaceShuttle.targeting_manager.mark_proximity_reference();


		SpaceShuttle.targeting_manager.set_target_state(me.target_t2_x, me.target_t2_y, me.target_t2_z, me.target_t2_vx, me.target_t2_vy, me.target_t2_vz);

	
		SpaceShuttle.targeting_manager.set_acceleration(0.51);
		SpaceShuttle.targeting_manager.max_evolution_time = delta_t;
		

		SpaceShuttle.targeting_manager.start();

		me.lcw_chaser_to_t2_holding_loop();
			

	},

	lcw_chaser_to_t2_holding_loop: func {

		if (SpaceShuttle.targeting_manager.evolution_finished == 0) 
			{settimer ( func {me.lcw_chaser_to_t2_holding_loop();}, 1.0);}
		else
			{
			me.lcw_chaser_to_t2_finished();
			}
	},

	lcw_chaser_to_t2_finished: func {

		SpaceShuttle.targeting_manager.compute_proximity();
		SpaceShuttle.targeting_manager.compute_proximity_v();
		SpaceShuttle.targeting_manager.list_proximity();
		SpaceShuttle.targeting_manager.list_proximity_v();

		me.t2_in_progress = 0;

		# empirically derived post-processing

		var vz_offset = 0.23;
		var vx_offset = -SpaceShuttle.targeting_manager.target_prox_z * 0.001;
		vx_offset -= 0.15;
		vx_offset -= SpaceShuttle.targeting_manager.target_ref_z * 0.001;


		var v = SpaceShuttle.norm([me.target_initial_vx, me.target_initial_vy, me.target_initial_vz]);
		var r = SpaceShuttle.norm([me.target_initial_x, me.target_initial_y, me.target_initial_z]);

		# correct geometrical v

		var prox_vx_geo = v * (1.0 - r / (r + me.initial_prox_z));

		#print ("vx_geo: ", prox_vx_geo);
		vx_offset = vx_offset - prox_vx_geo;

		# correct vz force effect

		var met = me.t_initial;
		var tig2 = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-tig");

		var delta_t = tig2 - met;

		var prox_vz_geo = 0.3 + (me.initial_prox_z *  -2.34167e-6  -0.000175) * delta_t;
		#print ("vz_geo: ", prox_vz_geo);
		vz_offset = vz_offset - prox_vz_geo;

		setprop("/fdm/jsbsim/systems/ap/oms-plan/dvx", (SpaceShuttle.targeting_manager.target_prox_vx + vx_offset)/0.3048);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/dvy", SpaceShuttle.targeting_manager.target_prox_vy/0.3048);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/dvz", (SpaceShuttle.targeting_manager.target_prox_vz + vz_offset)/0.3048);

		var match = math.abs(SpaceShuttle.targeting_manager.target_prox_x - me.offset_x)/0.3048;

		if (math.abs(SpaceShuttle.targeting_manager.target_prox_y - me.offset_y)/0.3048 > match)
			{
			match = math.abs(SpaceShuttle.targeting_manager.target_prox_y - me.offset_y)/0.3048;
			}

		if (math.abs(SpaceShuttle.targeting_manager.target_prox_z - me.offset_z)/0.3048 > match)
			{
			match = math.abs(SpaceShuttle.targeting_manager.target_prox_z - me.offset_z)/0.3048;
			}


		setprop("/fdm/jsbsim/systems/ap/orbit-tgt/pred-match-ft", match);


		setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-days", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-tig-d"));
		setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-hours", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-tig-h"));
		setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-minutes", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-tig-m"));
		setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-seconds", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-tig-s"));

		SpaceShuttle.set_oms_mnvr_timer();

		me.lock = 0;
		

	},



	pa_search_init: func {


		if (me.lock == 1) {print ("Lambert manager: Another computation is in progress!"); return;}
		me.lock = 1;

		me.pa_ready = 0;

		me.t_initial = SpaceShuttle.get_MET();

		SpaceShuttle.targeting_manager.parameter_reset();
		SpaceShuttle.targeting_manager.capture_current();

		SpaceShuttle.targeting_manager.set_acceleration(0.51);
		SpaceShuttle.targeting_manager.max_evolution_time = 6000.0;
		
		SpaceShuttle.targeting_manager.search_set = 1;
		SpaceShuttle.targeting_manager.search_type = 1;

		SpaceShuttle.targeting_manager.start();

		me.pa_search_holding_loop();


	},

	pa_search_holding_loop: func {


		if (SpaceShuttle.targeting_manager.evolution_finished == 0) 
			{settimer ( func {me.pa_search_holding_loop();}, 1.0);}
		else
			{
			me.pa_search_finished();
			}
	},

	pa_search_finished: func {


		SpaceShuttle.targeting_manager.compute_geometry();
		SpaceShuttle.targeting_manager.compute_proximity();
		SpaceShuttle.targeting_manager.compute_proximity_v();
		#SpaceShuttle.targeting_manager.list_proximity();
		#SpaceShuttle.targeting_manager.list_proximity_v();
		
		var vy = SpaceShuttle.targeting_manager.target_prox_vy;
		var tshift  = 0.35 * math.abs(vy)/0.51;

		me.pa_time = SpaceShuttle.targeting_manager.t + me.t_initial;
		me.pa_tig = SpaceShuttle.targeting_manager.t + me.t_initial - tshift;
		me.pa_dvy = -vy/0.3048;		


		#var node_met_string = SpaceShuttle.seconds_to_stringDHMS(me.pa_tig);
		#node_met_string = substr(node_met_string, 4);


		#print ("Next node crossing: ", node_met_string);
		#print ("Dvy: ", -vy / 0.3048);



		me.lock = 0;
		me.pa_ready = 1;

	},

	

};
