# orbital targeting for the Space Shuttle
# Thorsten Renk 2017-2019

# class doing numerical PEG-4 and rendezvous fits


# note that the orbital computations here are all done in metric units
# and need to be converted to imperial units for display purposes


var targeting_manager = {

	# state vector

	pos: [0.0,0.0,0.0],
	pnorm: [0.0,0.0,0.0],
	pos_stored: [0.0,0.0,0.0],
	r: 0.0,
	r_adj: 0.0,
	
	vel: [0.0,0.0,0.0],
	vnorm: [0.0,0.0,0.0],
	vel_stored: [0.0,0.0,0.0],
	v: 0.0,	

	rnorm: [0.0,0.0,0.0],
	nnorm: [0.0,0.0,0.0],

	grav: [0.0,0.0,0.0],
	acc: [0.0,0.0,0.0],

	dt: 0.02,	
	t: 0.0,	
	t_offset: 0.0,
	t_stored: 0.0,

	# burn parameters

	dvx: 0.0,
	dvy: 0.0,
	dvz: 0.0,
	dvtot: 0.0,
	dvcurr: 0.0,
	fvx: 0.0,
	fvy: 0.0,
	fvz: 0.0,
	tig: 0.0,
	burn_acc: 0.0,

	# PEG-4 parameters

	peg4_H: 0.0,
	peg4_H_act: 0.0,
	peg4_thetaT: 0.0,
	peg4_thetaT_act: 0.0,
	peg4_c1: 0.0,
	peg4_c2: 0.0,
	peg4_hspeed_act: 0.0,
	peg4_vspeed_act: 0.0,
	peg4_fit_converged: 0,
	peg4_fit_iterations: 0,
	peg4_fit_strategy: -1,

	peg4_fit_gain_prograde: 0.0,
	peg4_fit_gain_radial: 0.0,
	peg4_last_inc_prograde: 0.0,
	peg4_last_inc_radial: 0.0,
	peg4_fit_prograde_limit: 0.0,
	peg4_fit_radial_limit: 0.0,

	peg4_fit_radius_last: 0.0,

	peg4_set: 0,
	peg4_initialized: 0,

	# Launch site for OPS 1 reference

	ls_unit_x: 1.0,
	ls_unit_y: 0.0,
	ls_unit_z: 0.0,

	ls_unit_vx: 0.0,
	ls_unit_vy: 1.0,
	ls_unit_vz: 0.0,

	# Rendezvous target state vector

	target_pos: [0.0, 0.0, 0.0],
	target_vel: [0.0, 0.0, 0.0],
	target_offset: [0.0, 0.0, 0.0],
	tpnorm: [0.0, 0.0, 0.0],
	rt: 0.0,

	target_prox_x: 0.0,
	target_prox_y: 0.0,
	target_prox_z: 0.0,

	target_prox_vx: 0.0,
	target_prox_vy: 0.0,
	target_prox_vz: 0.0,

	target_ref_x: 0.0,
	target_ref_y: 0.0,
	target_ref_z: 0.0,

	target_ref_vx: 0.0,
	target_ref_vy: 0.0,
	target_ref_vz: 0.0,


	# Lambert fit parameters

	tig2: 0.0,
	dvx2: 0.0,
	dvy2: 0.0,
	dvz2: 0.0,
	tig2_real: 0.0,

	lambert_set: 0,
	lambert_fit_converged: 0,
	lambert_initialized: 0,
	lambert_fit_iterations: 0,
	lambert_transfer_angle: 0.0,
	lambert_cw_flag: 0.0,


	# condition search parameters

	search_set: 0,
	search_type: 0,
	search_check_every: 100,
	search_counter: 0,
	search_y_last: 0,


	# analytical orbital elements

	semimajor: 0.0,
	eccentricity: 0.0,
	inclination: 0.0,
	lon_asc_node: 0.0,
	periapsis_arg: 0.0,
	true_anomaly: 0.0,



	# constants
	GM: 398600441800000.0,
	J2:  1.755e25,
	R_eq: 6378136.60,
	R_polar: 6356751.90,
	rad_to_deg: 57.29578,
	deg_to_rad: 0.0174532,
	earth_rotation_speed: 0.0041780741323598,

	# modeling parameters

	gravity_model: 1,
	fit_verbose: 0,
	burn_verbose: 0,
	site_verbose: 0,
	
	# internal state parameters
	
	hypothetical_mode: 0,
	burn_on : 0,
	burn_finished: 0,
	evolution_finished: 0,
	max_evolution_time: 8000.0,
	running: 0,
	ops: 3,
	

	
	norm: func (v) {
		return math.sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);
	},

	normalize: func (v) {

		var vnorm = me.norm(v);

		v[0] /= vnorm;
		v[1] /= vnorm;
		v[2] /= vnorm;

		return v;

	},


	capture_current: func {

		me.pos[0] = getprop("/fdm/jsbsim/position/eci-x-ft") * 0.3048;
		me.pos[1] = getprop("/fdm/jsbsim/position/eci-y-ft") * 0.3048;
		me.pos[2] = getprop("/fdm/jsbsim/position/eci-z-ft") * 0.3048;

		me.vel[0] = getprop("/fdm/jsbsim/velocities/eci-x-fps") * 0.3048;
		me.vel[1] = getprop("/fdm/jsbsim/velocities/eci-y-fps") * 0.3048;
		me.vel[2] = getprop("/fdm/jsbsim/velocities/eci-z-fps") * 0.3048;

		me.compute_geometry();

		me.t_offset = getprop("/sim/time/elapsed-sec");
		me.t = 0.0;

		me.list_statevec();

	},


	set_peg7: func (dvx, dvy, dvz, tig) {

		me.dvx = dvx;
		me.dvy = dvy;
		me.dvz = dvz;
		me.dvtot = math.sqrt(dvx * dvx + dvy * dvy + dvz * dvz);
		me.fvx = me.dvx / me.dvtot;
		me.fvy = me.dvy / me.dvtot;
		me.fvz = me.dvz / me.dvtot;
		me.tig = tig;


	},


	set_peg4: func (H, thetaT, c1, c2, tig) {

		me.peg4_thetaT = thetaT;
		me.peg4_H = H;
		me.peg4_c1 = c1;
		me.peg4_c2 = c2;

		me.peg4_set = 1;

		me.tig = tig;

		print ("PEG-4 parameters: ");
		print ("H: ", me.peg4_H, " thetaT: ", me.peg4_thetaT);
		print ("c1: ", me.peg4_c1, " c2: ", me.peg4_c2);

	},

	set_lambert: func (tig1, tig2, offset_x, offset_y, offset_z) {

		me.tig = tig1;
		me.tig2 = tig2;
		me.target_offset[0] = offset_x;
		me.target_offset[1] = offset_y;
		me.target_offset[2] = offset_z;

		me.lambert_set = 1;

	},
	

	set_target_state: func (x, y, z, vx, vy, vz) {

		me.target_pos[0] = x;
		me.target_pos[1] = y;
		me.target_pos[2] = z;

		me.target_vel[0] = vx;
		me.target_vel[1] = vy;
		me.target_vel[2] = vz;

	},

	# this is a break of encapsulation as it requires to access the target API directly, yet good for performance

	advance_target: func {

		var tgt_pos = SpaceShuttle.oTgt.get_inertial_pos_at_time(me.t_offset + me.t);
		var tgt_vel = SpaceShuttle.oTgt.get_inertial_speed_at_time(me.t_offset + me.t);

		me.set_target_state(tgt_pos[0], tgt_pos[1], tgt_pos[2], tgt_vel[0], tgt_vel[1], tgt_vel[2]);

	},

	set_proximity_reference: func (x, y, z, vx, vy, vz) {

		me.target_ref_x = x;
		me.target_ref_y = y;
		me.target_ref_z = z;

		me.target_ref_vx = vx;
		me.target_ref_vy = vy;
		me.target_ref_vz = vz;
	

	},

	mark_proximity_reference: func {


		me.target_ref_x = me.target_prox_x;
		me.target_ref_y = me.target_prox_y;
		me.target_ref_z = me.target_prox_z;

		me.target_ref_vx = me.target_prox_vx;
		me.target_ref_vy = me.target_prox_vy;
		me.target_ref_vz = me.target_prox_vz;

	},
	


	set_acceleration: func (acc) {

		me.burn_acc = acc;
	},

	set_evolution_time: func (time) {
		
		me.max_evolution_time = time;

	},


	set_ops: func (ops) {

		if ((ops == 1) or (ops == 3))
			{
			me.ops = ops;
			}
		else
			{
			print ("Invalid OPS");
			return;
			}
	},


	set_launch_site: func (met, lat, lon) {


	
		var lon_at_launch = lon - met * me.earth_rotation_speed;
		me.ls_unit_x = math.cos (lat * me.deg_to_rad) * math.cos(lon_at_launch * me.deg_to_rad);
		me.ls_unit_y = math.cos (lat * me.deg_to_rad) * math.sin(lon_at_launch * me.deg_to_rad);
		me.ls_unit_z = math.sin(lat * me.deg_to_rad);

		var unit_east = [-me.ls_unit_y, me.ls_unit_x, 0.0];	
		unit_east = me.normalize(unit_east);
		
		var unit_north = [0,0,0];
		unit_north[0] = me.ls_unit_y * unit_east[2] - me.ls_unit_z * unit_east[1];
		unit_north[1] = me.ls_unit_z * unit_east[0] - me.ls_unit_x * unit_east[2];
		unit_north[2] = me.ls_unit_x * unit_east[1] - me.ls_unit_y * unit_east[0];



		var current_pos = geo.aircraft_position();
		var ls_pos = geo.Coord.new();
		ls_pos.set_latlon(lat, lon);

		var course = ls_pos.course_to(current_pos);

		var v_east = math.sin(course * me.deg_to_rad);
		var v_north = math.cos(course * me.deg_to_rad);

		me.ls_unit_vx = unit_east[0] * v_east + unit_north[0] * v_north;
		me.ls_unit_vy = unit_east[1] * v_east + unit_north[1] * v_north;
		me.ls_unit_vz = unit_east[2] * v_east + unit_north[2] * v_north;	

		if (me.site_verbose == 1)
			{
			print ("Setting launch site to ", lat, " ", lon);
			print ("Course: ", course);
			print ("Pos: ", me.ls_unit_x, " ", me.ls_unit_y, " ", me.ls_unit_z);
			print ("Vel: ", me.ls_unit_vx, " ", me.ls_unit_vy, " ", me.ls_unit_vz);
			print ("Unit north: ", unit_north[0], " ", unit_north[1], " " , unit_north[2]);
			print ("Unit east: ", unit_east[0], " ", unit_east[1], " " , unit_east[2]);
			}

	},



	get_latitude_rad: func () {
		return math.asin(me.pos[2]/me.r);
	},

	get_latitude: func {
		return me.get_latitude_rad() * me.rad_to_deg; 
		
	},


	get_longitude: func {
		
		var angle = math.atan2(me.pos[1], me.pos[0]) * me.rad_to_deg;
		angle-= me.earth_rotation_speed * (me.t + me.t_offset);

		while(angle < -180.0)
			{angle += 360.0;}
		return angle;

	},

	earth_radius: func (lat_rad) {
		var cl = math.cos(lat_rad);
		var sl = math.sin(lat_rad);

		return math.sqrt((math.pow(me.R_eq * me.R_eq * cl,2.0) + math.pow(me.R_polar * me.R_polar * sl, 2.0)) /  (math.pow(me.R_eq * cl, 2.0) + math.pow(me.R_polar * sl, 2.0)));
		
	},

	get_alt_agl: func {

		
		return me.r - me.earth_radius(me.get_latitude_rad());

	},

	



	check_signflip: func (arg, lastarg) {

		if ((arg > 0.0) and (lastarg < 0.0))
			{return 1;}
		else if ((arg < 0.0) and (lastarg > 0.0))		
			{return 1;}
		else
			{return 0;}
	},

	clamp: func (arg, limit) {

		if (arg > limit) 
			{arg = limit;}
		else if (arg < -limit)
			{arg = -limit;}
		return arg;
	},






	check_search_condition: func {


		if (me.search_type == 1) # node intersection with orbital target
			{
			me.advance_target();

			me.compute_geometry();
			me.compute_proximity();
			#me.list_proximity();
			
			if (math.abs(me.search_y_last) > 0.0) 
				{
				var value = me.check_signflip (me.target_prox_y, me.search_y_last);
				me.search_y_last = me.target_prox_y;

				#print ("Signflip check: ", (1 - value));

				return (1 - value);
				}
			else
				{
				me.search_y_last = me.target_prox_y;
				return 1;
				}
			}

	},


	
	check_condition: func {

		# evolution runs while condition is true, so the apsis/intersection event
		# needs to return false
		# we always continue while a burn is in progress to avoid spurious apses



		if (me.burn_on == 1) 
			{return 1;}

		if (me.lambert_set == 1)
			{
			if (me.t > me.tig2)
				{return 0;}
			}

		if (me.search_set == 1)
			{	
			if (me.search_counter == me.search_check_every)			
				{
				me.search_counter = 0;
				return me.check_search_condition();
				}
			else
				{
				me.search_counter += 1;
				return 1;
				}

			}
		


		if (me.peg4_fit_strategy == 0)
			{
			if (me.get_alt_agl() < me.peg4_H)
				{
				#print ("Condition altitude fail, time is ", me.t);
				return 0;
				}
			else
				{
				return 1;
				}

			}
		else if (me.peg4_fit_strategy == 1)
			{
			if (me.get_alt_agl() > me.peg4_H)
				{
				return 0;
				}
			else
				{
				return 1;
				}

			}
		else if (me.peg4_fit_strategy == 2)
			{
			if (me.r > me.peg4_fit_radius_last)
				{
				me.peg4_fit_radius_last = 1e20;
				return 0;
				}
			else
				{
				me.peg4_fit_radius_last = me.r;
				return 1;
				}

			}
		else if (me.peg4_fit_strategy == 3)
			{

			#print (me.t, " ", me.get_alt_agl());

			if (me.r < me.peg4_fit_radius_last)
				{
				#print ("Higher apsis candidate, time ", me.t);
				
				me.compute_elements();
				if (math.abs(me.r - ((1.0 - me.eccentricity) * me.semimajor)) > 5000.0)
					{
					me.peg4_fit_radius_last = 0.0;
					return 0;
					}
				else
					{
					me.peg4_fit_radius_last = 0.0;
					return 1;
					}
				}
			else
				{
				me.peg4_fit_radius_last = me.r;
				return 1;
				}

			}
		else if (me.peg4_fit_strategy == 4)
			{

			var pvec_stored_norm = [me.ls_unit_x, me.ls_unit_y, me.ls_unit_z];
			var vvec_stored_norm = [me.ls_unit_vx, me.ls_unit_vy, me.ls_unit_vz];

			var peg4_thetaT_current = math.acos(SpaceShuttle.dot_product(pvec_stored_norm, me.pnorm)) * me.rad_to_deg;


			if (SpaceShuttle.dot_product(me.pnorm, vvec_stored_norm) < 0.0) 
				{
				peg4_thetaT_current = 360.0 - peg4_thetaT_current;
				}
			#print (peg4_thetaT_current, " ", me.peg4_thetaT);
		#print (me.t, " ", me.get_alt_agl()/1852.);

			if (peg4_thetaT_current > me.peg4_thetaT)
				{
				return 0;
				}	
			else
				{
				return 1;
				}			


			}
	

		else
			{

			if (me.get_alt_agl() < 121919.0)
				{
				return 0;
				}
			else
				{
				return 1;
				}

			}


	},



	compute_peg4: func {


		var pvec_stored_norm = [me.pos_stored[0], me.pos_stored[1], me.pos_stored[2]];
		var pvnorm = me.norm(pvec_stored_norm);


		pvec_stored_norm[0] /= pvnorm;
		pvec_stored_norm[1] /= pvnorm;
		pvec_stored_norm[2] /= pvnorm;

		var vvec_stored_norm = [me.vel_stored[0], me.vel_stored[1], me.vel_stored[2]];
		var vvnorm = me.norm(vvec_stored_norm);

		vvec_stored_norm[0] /= vvnorm;
		vvec_stored_norm[1] /= vvnorm;
		vvec_stored_norm[2] /= vvnorm;

		if (me.ops == 1) # use landing site instead
			{
			pvec_stored_norm = [me.ls_unit_x, me.ls_unit_y, me.ls_unit_z];
			vvec_stored_norm = [me.ls_unit_vx, me.ls_unit_vy, me.ls_unit_vz];

			#print("site: ", me.ls_unit_x, " ", me.ls_unit_y, " ", me.ls_unit_z);
			}


		me.peg4_thetaT_act = math.acos(SpaceShuttle.dot_product(pvec_stored_norm, me.pnorm)) * me.rad_to_deg;

		if (SpaceShuttle.dot_product(me.pnorm, vvec_stored_norm) < 0.0) 
			{
			me.peg4_thetaT_act = 360.0 - me.peg4_thetaT_act;
			}

		me.peg4_H_act = me.get_alt_agl();
		me.peg4_vspeed_act = SpaceShuttle.dot_product(me.pnorm, me.vel);

		var velocity = [0.0, 0.0, 0.0];

		velocity[0] = me.vel[0] - me.peg4_vspeed_act * me.pnorm[0];
		velocity[1] = me.vel[1] - me.peg4_vspeed_act * me.pnorm[1];
		velocity[2] = me.vel[2] - me.peg4_vspeed_act * me.pnorm[2];

		me.peg4_hspeed_act = me.norm(velocity);

	},

	peg4_guess_initial: func {

		me.peg4_fit_gain_prograde = 0.003;
		me.peg4_fit_gain_radial = 3.0;
		me.peg4_last_inc_prograde = 0.0;
		me.peg4_last_inc_radial	= 0.0;
		me.peg4_fit_prograde_limit = 40.0;
		me.peg4_fit_radial_limit = 10.0;	


		var altitude = me.get_alt_agl();

		print ("altitude: ", altitude, " H: ", me.peg4_H);

		if ((altitude > me.peg4_H + 15000.0) and (me.peg4_c1 > 0.0))
			{me.peg4_fit_strategy = 0;} # intersection low
		else if ((altitude < me.peg4_H - 15000.0) and (me.peg4_c1 < 0.0))
			{me.peg4_fit_strategy = 1;} # intersection high
		else if ((altitude > me.peg4_H + 15000.0) and (me.peg4_c1 == 0.0))
			{me.peg4_fit_strategy = 2;} # apsis low
		else if ((altitude < me.peg4_H - 15000.0) and (me.peg4_c1 == 0.0))
			{me.peg4_fit_strategy = 3;} # apsis high
		else
			{me.peg4_fit_strategy = 4;} # circularization


		print ("Using fit strategy ", me.peg4_fit_strategy);

		var dx = 0.0;
		var dy = 0.0;
		var dz = 0.0;
	
		if (me.peg4_fit_strategy < 4)
			{
			dx = (me.peg4_H - altitude)/2500.0;
			}
		else if (me.peg4_fit_strategy == 4)
			{
			me.compute_peg4();
			dx = math.sqrt(me.GM/me.r) - me.peg4_hspeed_act;
			dz = -0.73 * me.peg4_vspeed_act;
			}

		me.set_peg7(dx, dy, dz, me.tig);

		if (me.fit_verbose == 1)
			{
			print ("PEG-4 Initial guess: ");
			print ("Dx: ", me.dvx, " Dy: ", me.dvy, " Dz: ", me.dvz);
			}

		me.peg4_initialized = 1;

	},


	peg4_improve: func {


		var vspeed_error = (me.peg4_c2 * me.peg4_hspeed_act + me.peg4_c1) - me.peg4_vspeed_act;
		var H_error = me.peg4_H - me.peg4_H_act;
		var thetaT_error = me.peg4_thetaT - me.peg4_thetaT_act;

		var H_accept_factor = 1.0;
		var thetaT_accept_factor = 1.0;
		var vspeed_accept_factor = 1.0;

		if ((me.peg4_fit_strategy == 2) or (me.peg4_fit_strategy == 3))
			{
			H_accept_factor = 5.0;
			thetaT_accept_factor = 2.0;
			}
		else if (me.peg4_fit_strategy == 4)
			{
			H_accept_factor = 20.0;
			vspeed_accept_factor = 5.0;
			}

		if ((math.abs(vspeed_error) < 1.0 * vspeed_accept_factor) and (math.abs(H_error) < 50.0 * H_accept_factor) and (math.abs(thetaT_error) < 0.5 * thetaT_accept_factor))
			{
			print ("Fit converged.");
			me.peg4_fit_converged = 1;
			}
		else	
			{


			if (me.peg4_fit_strategy == 0)
				{
				#print ("In fit: vspeed_error: ", vspeed_error, " thetaT_error: ", thetaT_error);
				#print ("Dvx before: ", me.dvx, " Dvz before: ", me.dvz);

				me.dvx += 0.2 * vspeed_error;
				me.dvz += 3.0 * thetaT_error;

				#print ("Dvx after: ", me.dvx, " Dvz after: ", me.dvz);
				}
			else if (me.peg4_fit_strategy == 1)
				{
				me.dvx += 0.2 * vspeed_error;
				me.dvz -= 3.0 * thetaT_error;
				}
			else if (me.peg4_fit_strategy == 2)
				{
				var increment = me.peg4_fit_gain_prograde * H_error;
				if (me.check_signflip (increment, me.peg4_last_inc_prograde) == 1)
					{
					me.peg4_fit_prograde_limit *= 0.5;
					}
				increment = me.clamp(increment, me.peg4_fit_prograde_limit);
				me.peg4_last_inc_prograde = increment;
				me.dvx += increment;
				
				increment = me.peg4_fit_gain_radial * thetaT_error;
				if (me.check_signflip(increment, me.peg4_last_inc_radial) == 1)
					{
					me.peg4_fit_radial_limit *= 0.5;
					me.peg4_fit_gain_radial *= 1.5;
					}
				increment = me.clamp(increment, me.peg4_fit_radial_limit);
				me.peg4_fit_last_inc_radial = increment;
				me.dvz += increment;

				}
			else if (me.peg4_fit_strategy == 3)
				{
				var increment = me.peg4_fit_gain_prograde * H_error;
				if (me.check_signflip (increment, me.peg4_last_inc_prograde) == 1)
					{
					me.peg4_fit_prograde_limit *= 0.5;
					}
				increment = me.clamp(increment, me.peg4_fit_prograde_limit);
				me.peg4_last_inc_prograde = increment;
				me.dvx += increment;
				
				increment = me.peg4_fit_gain_radial * thetaT_error;
				if (me.check_signflip(increment, me.peg4_last_inc_radial) == 1)
					{
					me.peg4_fit_radial_limit *= 0.5;
					me.peg4_fit_gain_radial *= 1.5;
					}
				increment = me.clamp(increment, me.peg4_fit_radial_limit);
				me.peg4_fit_last_inc_radial = increment;
				me.dvz -= increment;

				}

			else if (me.peg4_fit_strategy == 4)
				{
				var increment = me.peg4_fit_gain_prograde * H_error;
				if (me.check_signflip (increment, me.peg4_last_inc_prograde) == 1)
					{
					me.peg4_fit_prograde_limit *= 0.5;
					}
				increment = me.clamp(increment, me.peg4_fit_prograde_limit);
				me.peg4_last_inc_prograde = increment;
				me.dvx += increment;
				
				increment = me.peg4_fit_gain_radial * vspeed_error;
				if (me.check_signflip(increment, me.peg4_last_inc_radial) == 1)
					{
					me.peg4_fit_radial_limit *= 0.5;
					me.peg4_fit_gain_radial *= 1.5;
					}
				increment = me.clamp(increment, me.peg4_fit_radial_limit);
				me.peg4_fit_last_inc_radial = increment;
				me.dvz -= increment;

				}


				me.dvtot = math.sqrt(me.dvx * me.dvx + me.dvy * me.dvy + me.dvz * me.dvz);
				me.fvx = me.dvx / me.dvtot;
				me.fvy = me.dvy / me.dvtot;
				me.fvz = me.dvz / me.dvtot;


			if (me.fit_verbose == 1)
				{
				print ("Fit unconverged, in iteration ", me.peg4_fit_iterations, " current errors:");
				print ("vspeed: ", vspeed_error);
				print ("H: ", H_error);
				print ("thetaT: ", thetaT_error);


				print ("New burn parameters: ");
				print ("Dx: ", me.dvx, " Dy: ", me.dvy, " Dz: ", me.dvz);
				}
				me.peg4_fit_iterations += 1;




			}





	},


	lambert_guess_initial: func {

		me.compute_elements();
		me.compute_proximity();
		me.list_proximity();

		var orbital_period = 2.0 * math.pi * math.sqrt(math.pow(me.semimajor,3.0)/me.GM);
		me.lambert_transfer_angle = 2.0 * math.pi * (me.tig2 - me.tig)/orbital_period;


		var x_error = me.target_prox_x - me.target_offset[0];
		var y_error = me.target_prox_y - me.target_offset[1];
		var z_error = me.target_prox_z - me.target_offset[2];


		var dx = - z_error / 2500.0;
		var dy = 0.0;
		var dz = x_error / 4000.0; 

		me.set_peg7(dx, dy, dz, me.tig);

		if (me.fit_verbose == 1)
			{
			print ("Lambert transfer angle is: ", me.lambert_transfer_angle * 180.0/math.pi, " degrees.");
	
			print ("Lambert burn 1 initial guess: ");
			print ("Dx: ", me.dvx, " Dy: ", me.dvy, " Dz: ", me.dvz);
			}


		me.lambert_initialized = 1;

	},


	cw_guess_initial: func {


		me.compute_geometry();
		me.compute_proximity();
		me.compute_proximity_v();
		me.list_proximity();


		var x_error = me.target_prox_x - me.target_offset[0];
		var y_error = me.target_prox_y - me.target_offset[1];
		var z_error = me.target_prox_z - me.target_offset[2];

		var delta_t = me.tig2 - me.tig;

		var dx = (me.target_offset[0] - me.target_ref_x)/ delta_t - me.target_ref_vx;
		var dy = (me.target_offset[1] - me.target_ref_y)/ delta_t - me.target_ref_vy;
		var dz = (me.target_offset[2] - me.target_ref_z)/ delta_t - me.target_ref_vz;

		dx = -dx;

		me.set_peg7(dx, dy, dz, me.tig);

		if (me.fit_verbose == 1)
			{
	
			print ("CW burn 1 initial guess: ");
			print ("Dx: ", me.dvx, " Dy: ", me.dvy, " Dz: ", me.dvz);
			}


		me.lambert_initialized = 1;

	},


	lambert_improve: func () {

		me.compute_proximity();
		me.list_proximity();

		var x_error = me.target_prox_x - me.target_offset[0];
		var y_error = me.target_prox_y - me.target_offset[1];
		var z_error = me.target_prox_z - me.target_offset[2];

		if ((me.lambert_transfer_angle > 0.95 * math.pi) and (me.lambert_transfer_angle < 1.05 * math.pi))
			{
			y_error = 0.0;
			}
		
		var error_margin = 50.0;
		if (me.lambert_fit_iterations > 20) {error_margin = 100.0;}
		else if (me.lambert_fit_iterations > 40) {error_margin = 200.0;}


		if ((math.abs(x_error) < error_margin) and (math.abs(y_error) < error_margin) and (math.abs(z_error) <error_margin))
			{
			print ("Fit converged.");
			me.lambert_fit_converged = 1;
			
			me.compute_proximity_v();

			me.dvx2 = me.target_prox_vx;
			me.dvy2 = me.target_prox_vy;
			me.dvz2 = me.target_prox_vz;

			var vtot = math.sqrt(math.pow(me.dvx2, 2.0) + math.pow(me.dvy2, 2.0) + math.pow(me.dvz2,2.0));
			var tshift  = 0.5 * vtot/me.burn_acc;

			me.tig2_real = me.tig2 - tshift;
			}

		else
			{

			var y_gain = 0.0012;
			if (math.abs(y_error) > 0.0) {y_gain *= 1.0/math.sin(me.lambert_transfer_angle);}
			me.dvx -= z_error / 6000.0;
			me.dvy -= y_gain * y_error;
			me.dvz -= x_error/4000.0; 

			me.dvtot = math.sqrt(me.dvx * me.dvx + me.dvy * me.dvy + me.dvz * me.dvz);
			me.fvx = me.dvx / me.dvtot;
			me.fvy = me.dvy / me.dvtot;
			me.fvz = me.dvz / me.dvtot;

			if (me.fit_verbose == 1)
				{
				print ("Fit unconverged, in iteration ", me.lambert_fit_iterations, " current errors:");
				print ("x: ", x_error);
				print ("y: ", y_error);
				print ("z: ", z_error);

				print ("New burn parameters: ");
				print ("Dx: ", me.dvx, " Dy: ", me.dvy, " Dz: ", me.dvz);
				}
			me.lambert_fit_iterations += 1;

			}


	},


	cw_improve: func () {

		me.compute_geometry();
		me.compute_proximity();
		me.list_proximity();

		var x_error = me.target_prox_x - me.target_offset[0];
		var y_error = me.target_prox_y - me.target_offset[1];
		var z_error = me.target_prox_z - me.target_offset[2];



		if ((math.abs(x_error) < 5.0) and (math.abs(y_error) < 5.0) and (math.abs(z_error) < 5.0))
			{
			print ("Fit converged.");
			me.lambert_fit_converged = 1;
			
			me.compute_proximity_v();

			me.dvx2 = me.target_prox_vx;
			me.dvy2 = me.target_prox_vy;
			me.dvz2 = me.target_prox_vz;

			var vtot = math.sqrt(math.pow(me.dvx2, 2.0) + math.pow(me.dvy2, 2.0) + math.pow(me.dvz2,2.0));
			var tshift  = 0.5 * vtot/me.burn_acc;

			me.tig2_real = me.tig2 - tshift;
			}

		else
			{

			var delta_t = (me.tig2 - me.tig);

			var gain = 1.0;
			if (me.lambert_fit_iterations > 25) {gain = 0.5;}

			me.dvx += x_error * gain * 0.2/ delta_t - z_error * gain * 0.05/delta_t;
			me.dvy -= y_error * 0.2/ delta_t;
			me.dvz -= z_error * gain * 0.4 / delta_t + x_error * gain * 0.1/delta_t;

			me.dvtot = math.sqrt(me.dvx * me.dvx + me.dvy * me.dvy + me.dvz * me.dvz);
			me.fvx = me.dvx / me.dvtot;
			me.fvy = me.dvy / me.dvtot;
			me.fvz = me.dvz / me.dvtot;

			if (me.fit_verbose == 1)
				{
				print ("Fit unconverged, in iteration ", me.lambert_fit_iterations, " current errors:");
				print ("x: ", x_error);
				print ("y: ", y_error);
				print ("z: ", z_error);

				print ("New burn parameters: ");
				print ("Dx: ", me.dvx, " Dy: ", me.dvy, " Dz: ", me.dvz);
				}
			me.lambert_fit_iterations += 1;

			}


	},


	reset_state: func {

		#print ("Inside reset:");

		#print ("pos before: ", me.pos[0], " " , me.pos[1], " ", me.pos[2]);
		
		me.pos[0] = me.pos_stored[0];
		me.pos[1] = me.pos_stored[1];
		me.pos[2] = me.pos_stored[2];

		#print ("pos after: ", me.pos[0], " " , me.pos[1], " ", me.pos[2]);

		me.vel[0] = me.vel_stored[0];
		me.vel[1] = me.vel_stored[1];
		me.vel[2] = me.vel_stored[2];

		me.compute_geometry();

		me.t = me.t_stored;

		me.dvcurr = 0.0;

		me.burn_on = 0;
		me.burn_finished = 0;
		me.peg4_fit_radius_last = 0.0;

		#me.peg4_fit_strategy = -1;


	},


	compute_elements: func {

		var specific_energy = 0.5 * SpaceShuttle.dot_product(me.vel, me.vel) - me.GM/me.norm(me.pos);
		me.semimajor = - me.GM/(2.0 * specific_energy);

		var r_dot_v = SpaceShuttle.dot_product(me.pos, me.vel);
		var h = SpaceShuttle.cross_product(me.pos, me.vel);
		var h_norm = me.norm(h);

		var epsilon_vec = SpaceShuttle.scalar_product(1.0/me.GM, SpaceShuttle.cross_product(me.vel, h));
		epsilon_vec = SpaceShuttle.subtract_vector(epsilon_vec,me.pnorm);
		me.eccentricity = me.norm(epsilon_vec);

		me.inclination = math.acos(h[2]/h_norm);

		var n_vec = [-h[1], h[0], 0.0];

		me.lon_asc_node = math.acos(n_vec[0]/me.norm(n_vec));
		if (n_vec[1] < 0.0) {me.lon_asc_node = 2.0 * math.pi - me.lon_asc_node;}

		me.periapsis_arg = math.acos(SpaceShuttle.dot_product(me.normalize(n_vec), me.normalize(epsilon_vec)));
		if (epsilon_vec[2] < 0.0) {me.periapsis_arg = 2.0 * math.pi - me.periapsis_arg;}

		me.true_anomaly = math.acos(SpaceShuttle.dot_product(me.normalize(epsilon_vec), me.pnorm));

		if (r_dot_v < 0.0) {me.true_anomaly = 2.0 * math.pi - me.true_anomaly;}

		me.inclination *= me.rad_to_deg;
		me.inclination = geo.normdeg(me.inclination);
		
		me.lon_asc_node *= me.rad_to_deg;
		me.lon_asc_node = geo.normdeg180(me.lon_asc_node);
	
		me.periapsis_arg *= me.rad_to_deg;
		me.periapsis_arg = geo.normdeg(me.periapsis_arg);

		me.true_anomaly *= me.rad_to_deg;
		me.true_anomaly = geo.normdeg(me.true_anomaly);

	},

	compute_proximity: func {



		me.nnorm = SpaceShuttle.normalize(SpaceShuttle.cross_product(me.pnorm, me.vnorm));
		me.rt = me.norm(me.target_pos);
		me.tpnorm[0] = me.target_pos[0]/me.rt;
		me.tpnorm[1] = me.target_pos[1]/me.rt;
		me.tpnorm[2] = me.target_pos[2]/me.rt;

		#print ("Pnorm deltas: ");
		#print ("x: ", me.pnorm[0] - me.tpnorm[0]);
		#print ("y: ", me.pnorm[1] - me.tpnorm[1]);
		#print ("z: ", me.pnorm[2] - me.tpnorm[2]);

		var ang_xt = 0.5 * math.pi - math.acos(SpaceShuttle.dot_product(me.tpnorm, me.nnorm));
		var delta_ang = math.acos(SpaceShuttle.dot_product(me.pnorm, me.tpnorm));

		#print ("Ang XT: ", ang_xt, " delta ang: ", delta_ang);
	
		var ang = math.acos(math.cos(delta_ang) / math.cos(ang_xt));
		var sign = 1.0;
		
		if (((me.target_pos[0] - me.pos[0]) * me.vnorm[0] + (me.target_pos[1] - me.pos[1]) * me.vnorm[1] + (me.target_pos[2] - me.pos[2]) * me.vnorm[2]) < 0.0)
			{
			sign = -1.0;
			}

		me.target_prox_x = sign * ang * me.r;
		me.target_prox_y = ang_xt * me.r;
		me.target_prox_z = me.r - me.rt;


	},

	compute_proximity_v: func {


		#print ("TGT vel[0]: ", me.target_vel[0], " "vel[0]: ", me.vel[0], " vnorm[0]: ", me.vnorm[0]);

		me.target_prox_vx = (me.target_vel[0] - me.vel[0]) * me.vnorm[0];
		me.target_prox_vx += (me.target_vel[1] - me.vel[1]) * me.vnorm[1];
		me.target_prox_vx += (me.target_vel[2] - me.vel[2]) * me.vnorm[2];

		me.nnorm = SpaceShuttle.cross_product(me.pnorm, me.vnorm);

		me.target_prox_vy = (me.target_vel[0] - me.vel[0]) * me.nnorm[0];
		me.target_prox_vy += (me.target_vel[1] - me.vel[1]) * me.nnorm[1];
		me.target_prox_vy += (me.target_vel[2] - me.vel[2]) * me.nnorm[2];

		me.rt = me.norm(me.target_pos);
		me.tpnorm[0] = me.target_pos[0]/me.rt;
		me.tpnorm[1] = me.target_pos[1]/me.rt;
		me.tpnorm[2] = me.target_pos[2]/me.rt;

		# in a curvilinear coordinate system, this is a non-local quantity

		me.target_prox_vz = me.target_vel[0] * me.tpnorm[0] - me.vel[0] * me.pnorm[0];
		me.target_prox_vz += me.target_vel[1] * me.tpnorm[1] - me.vel[1] * me.pnorm[1];
		me.target_prox_vz += me.target_vel[2] * me.tpnorm[2] - me.vel[2] * me.pnorm[2];


		# finally we need to add in the geometrical effect of orbiting lower at the same inertial speed

		var v = SpaceShuttle.norm([me.target_vel[0], me.target_vel[1], me.target_vel[2]]);
		var prox_vx_geo = v * (1.0 - me.rt / (me.rt + me.target_prox_z));

		me.target_prox_vx += prox_vx_geo;
		#me.target_prox_vz += prox_vx_geo/6.1;
	},



	compute_geometry: func{

		me.r = me.norm(me.pos);
		me.v = me.norm(me.vel);

		me.pnorm[0] = me.pos[0]/me.r;
		me.pnorm[1] = me.pos[1]/me.r;
		me.pnorm[2] = me.pos[2]/me.r;

		me.vnorm[0] = me.vel[0]/me.v;
		me.vnorm[1] = me.vel[1]/me.v;
		me.vnorm[2] = me.vel[2]/me.v;

	},

	compute_gravity: func {
		
		# spherical
		var g = -me.GM/(me.r * me.r);
		me.grav[0] = g * me.pnorm[0];
		me.grav[1] = g * me.pnorm[1];
		me.grav[2] = g * me.pnorm[2];

		# J2 harmonics

		
		var r7 = math.pow(me.r, 7.0);
		me.grav[0] += me.J2 * me.pos[0]/r7 * (6.0 * me.pos[2] * me.pos[2] - 1.5 * (me.pos[0] * me.pos[0] + me.pos[1] * me.pos[1]));
		me.grav[1] += me.J2 * me.pos[1]/r7 * (6.0 * me.pos[2] * me.pos[2] - 1.5 * (me.pos[0] * me.pos[0] + me.pos[1] * me.pos[1]));
		me.grav[2] += me.J2 * me.pos[2]/r7 * (3.0 * me.pos[2] * me.pos[2] - 4.5 * (me.pos[0] * me.pos[0] + me.pos[1] * me.pos[1]));
	},

	check_burn: func {
		
		if ((me.burn_on == 1) or (me.burn_finished == 1)) {return;}
		
		if (me.t > me.tig)
			{
			me.burn_on = 1;

			if (me.hypothetical_mode == 0)
				{

				#print ("**** Storing burn point position ***");

				me.hypothetical_mode = 1;
				me.pos_stored[0] = me.pos[0];
				me.pos_stored[1] = me.pos[1];
				me.pos_stored[2] = me.pos[2];

				me.vel_stored[0] = me.vel[0];
				me.vel_stored[1] = me.vel[1];
				me.vel_stored[2] = me.vel[2];

				me.t_stored = me.t; 
				}

			if ((me.peg4_initialized == 0) and (me.peg4_set == 1)) {me.peg4_guess_initial();}

			if (me.burn_verbose == 1)
				{print ("Burn ignition, time is now ", me.t);}

			}

	},


	compute_burn: func {
		
		if (me.burn_on == 0) {return;}

		me.rnorm = SpaceShuttle.orthonormalize(me.vnorm, me.pnorm);
		me.nnorm = SpaceShuttle.cross_product(me.vnorm, me.rnorm);

		me.acc[0] = me.burn_acc * me.vnorm[0] * me.fvx;
		me.acc[1] = me.burn_acc * me.vnorm[1] * me.fvx;
		me.acc[2] = me.burn_acc * me.vnorm[2] * me.fvx;

		me.acc[0] += me.burn_acc * me.rnorm[0] * me.fvz;
		me.acc[1] += me.burn_acc * me.rnorm[1] * me.fvz;
		me.acc[2] += me.burn_acc * me.rnorm[2] * me.fvz;

		me.acc[0] += me.burn_acc * me.nnorm[0] * me.fvy;
		me.acc[1] += me.burn_acc * me.nnorm[1] * me.fvy;
		me.acc[2] += me.burn_acc * me.nnorm[2] * me.fvy;

		me.dvtot = me.dvtot - me.burn_acc * me.dt;
		me.dvcurr += me.burn_acc * me.dt;
		
		if (me.dvtot < 0.0) 
			{
			me.burn_finished = 1;
			if (me.burn_verbose == 1)
				{
				print ("Burn ends, time is now: ", me.t);
				print ("Delta v tot: ", me.dvcurr);
				}
			me.burn_on = 0;

			me.acc[0] = 0.0;
			me.acc[1] = 0.0;
			me.acc[2] = 0.0;
			}

		
	},

	do_timestep: func {



		me.compute_geometry();
		me.compute_gravity();
		me.check_burn();
		me.compute_burn();

		# effect of gravity 

		me.vel[0] += me.grav[0] * me.dt;
		me.vel[1] += me.grav[1] * me.dt;
		me.vel[2] += me.grav[2] * me.dt;

		# effect of burns

		me.vel[0] += me.acc[0] * me.dt;
		me.vel[1] += me.acc[1] * me.dt;
		me.vel[2] += me.acc[2] * me.dt;

		# position and time update

		me.pos[0] += me.vel[0] * me.dt;
		me.pos[1] += me.vel[1] * me.dt;
		me.pos[2] += me.vel[2] * me.dt;



		me.t += me.dt;		

	},


	evolve: func (t) {

		#var counter = 0;

		while ((me.t < t) and (me.check_condition() == 1))
			{
			me.do_timestep();

			#if (counter == 0)
			#	{print (SpaceShuttle.norm(me.pos) - me.R_eq);}
			
			#counter += 1;
			#if (counter == 100) {counter = 0;}


			}

			print ("t: ", t, " me.t ", me.t);
			print ("condition: ", me.check_condition());

		if ((me.t > t) and (me.fit_verbose == 1)) {print ("Evolution time overrun!");}
		me.evaluate_evolution();
		
			
	},


	evaluate_evolution: func {


		if (me.lambert_set == 1)
			{
			if (me.lambert_initialized == 0)
				{
				print ("Lambert dry run done!");
				print ("T is now: ", me.t);
				me.compute_proximity();
				if (me.lambert_cw_flag == 0)
					{me.lambert_guess_initial();}
				else
					{me.cw_guess_initial(); }
				me.reset_state();
				me.evolve(me.max_evolution_time);
				return;
				}
			else if (me.lambert_initialized == 1)
				{
				me.compute_proximity();
				if (me.lambert_cw_flag == 0)
					{me.lambert_improve();}
				else
					{me.cw_improve();}

				}
			}


		else if (me.peg4_set == 1)
			{
			me.compute_peg4();
			me.peg4_improve();
			}


		if ( (me.evolution_finished == 0) and (((me.peg4_set == 1) and (me.peg4_fit_converged == 1)) or ((me.lambert_set == 1) and (me.lambert_fit_converged == 1))) or ((me.peg4_set == 0) and (me.lambert_set == 0)))
			{
			me.evolution_finished = 1;
			print ("Evolution ends!");
			me.list_peg7();

			if (me.lambert_fit_converged == 1)
				{
				me.list_lambert2();
				}
			}

		else 
			{
			if ((me.peg4_fit_iterations > 30) or (me.lambert_fit_iterations > 50))
				{
				var num_iterations = math.max (me.peg4_fit_iterations, me.lambert_fit_iterations);

				print("Fit remains unconverged after ", num_iterations, " iterations - aborting");

				if (me.lambert_fit_iterations > 50) # solution might be okay still, compute Tig2
					{
					print("Computing tentative TIG 2 parameters anyway.");
					me.compute_proximity_v();

					me.dvx2 = me.target_prox_vx;
					me.dvy2 = me.target_prox_vy;
					me.dvz2 = me.target_prox_vz;

					var vtot = math.sqrt(math.pow(me.dvx2, 2.0) + math.pow(me.dvy2, 2.0) + math.pow(me.dvz2,2.0));
					var tshift  = 0.5 * vtot/me.burn_acc;

					me.tig2_real = me.tig2 - tshift;
					}

				me.evolution_finished = 1;
				}
			else
				{
				me.reset_state();
				#print ("Resetting, time is now: ", me.t);
				me.evolve(me.max_evolution_time);
				}
			}


		#me.list_peg4();
		#me.list_statevec();

	},


	parameter_reset: func {

		me.peg4_fit_converged = 0;
		me.peg4_fit_iterations = 0;
		me.peg4_fit_strategy = -1;
		me.peg4_set = 0;
		me.peg4_initialized = 0;
		me.lambert_set = 0;
		me.lambert_initialized = 0;
		me.lambert_fit_iterations = 0;
		me.lambert_fit_converged = 0;
		me.lambert_cw_flag = 0;
		me.search_set = 0;
		me.search_type = 0;
		me.search_counter = 0;
		me.search_check_every = 100;
		me.search_y_last = 0;
		me.hypothetical_mode = 0;
		me.max_evolution_time = 8000.0;

		
		me.evolution_finished = 0;

		me.running = 0;
	
		me.burn_on = 0;
		me.burn_finished = 0;
		
		me.acc[0] = 0;
		me.acc[1] = 0;
		me.acc[2] = 0;

		me.dvx = 0.0;
		me.dvy = 0.0;
		me.dvz = 0.0;
		me.dvtot = 0.0;
	
		me.t = 0.0;

		me.set_peg7(0.0, 0.0,0.0, 12000.0);


	},

	start: func {
		
		if (me.running == 1) {return;}

		me.running = 1;

		print ("Starting targeting routines");
		thread.newthread ( func {me.evolve(me.max_evolution_time);});

		#me.evolve(me.max_evolution_time);
	},
	

	holding_loop: func {

		if (me.evolution_finished == 0) 
			{settimer (func {me.holding_loop(); }, 1.0);}

		else
			{

			me.list_statevec();

			}
	},

	list_statevec: func {
			print ("Current state vector: ");
			print ("x: ", me.pos[0]/0.3048, " y: ", me.pos[1]/0.3048, " z: ", me.pos[2]/0.3048);
			print ("vx: ", me.vel[0]/0.3048, " vy: ", me.vel[1]/0.3048, " vz: ", me.vel[2]/0.3048);
			print ("t: ", me.t);
			print ("Current position: ");
			print ("lat: ", me.get_latitude(), " lon: ", me.get_longitude());
			print ("");
	},


	list_peg4: func {
			print ("Targeted PEG-4 parameters: ");
			print ("thetaT: ", me.peg4_thetaT, " H: ", me.peg4_H);
			print ("c1: ", me.peg4_c1, " c2: ", me.peg4_c2);
			print ("");
			print ("Current PEG-4 parameters: ");
			print ("thetaT: ", me.peg4_thetaT_act, " H: ", me.peg4_H_act);
			print ("vspeed: ", me.peg4_vspeed_act, " hspeed: ", me.peg4_hspeed_act);
			print ("");

	},

	list_peg7: func {
			print ("PEG-7 burn parameters: ");
			print ("DX: ", me.dvx, " DY: ", me.dvy, " DZ: ", me.dvz);
			print ("Ignition time: ", me.tig);
			print ("");

	},

	list_lambert2: func {
			print ("Lambert2 PEG-7 burn parameters: ");
			print ("DX: ", me.dvx2, " DY: ", me.dvy2, " DZ: ", me.dvz2);
			print ("Ignition time: ", me.tig2_real);
			print ("");

	},

	list_elements: func {

			print ("Orbital elements: ");
			print ("Semimajor axis [km]:  ", me.semimajor/1000.0);
			print ("Eccentricity:         ", me.eccentricity);
			print ("Inclination [deg]:    ", me.inclination);
			print ("Lon. asc. node [deg]: ", me.lon_asc_node);
			print ("Arg. of PA [deg]:     ", me.periapsis_arg);
			print ("True anomaly:         ", me.true_anomaly);
			print ("");
	
	},

	list_proximity: func {

			print ("Proximity coordinates:");
			print ("x: ", me.target_prox_x);
			print ("y: ", me.target_prox_y);
			print ("z: ", me.target_prox_z);
			print ("");

	},

	list_proximity_v: func {

			print ("Proximity velocities:");
			print ("vx: ", me.target_prox_vx);
			print ("vy: ", me.target_prox_vy);
			print ("vz: ", me.target_prox_vz);
			print ("");

	},



	test_suite: func {

		me.pos[0] = 2986801.3;
		me.pos[1] = 77297.27;
		me.pos[2] = -5964502;

		me.vel[0] = -40.08346;
		me.vel[1] = 7729.3816;
		me.vel[2] = 80.048704;

		me.parameter_reset();


		me.set_target_state( -2824427.3,  -2248618.3, 5629994 , 1146.6913, -7261.9162, -2326.473);



		me.compute_geometry();

		me.t_offset = 0.0;
		me.t = 0.0;
	
		me.set_acceleration(0.51);

		me.fit_verbose = 1;
		#me.burn_verbose = 1;
		me.ops = 1;


		me.compute_elements();
		me.list_elements();

		#me.set_peg4(334.0 * 1852.0, 350.0, 0.0, 0.0, 3000.0);
		#me.set_peg7(-279.9 * 0.3048, 0.0, 3.23 * 0.3048, 874.0);
		me.set_lambert(100.0, 3000.0, 0.0, 0.0, 0.0);

		#me.set_launch_site(540.0, 28.973, -26.483);

		me.holding_loop();
		me.evolve(me.max_evolution_time);
		#me.evolve(2810);
		#me.list_statevec();
		#thread.newthread ( func {me.evolve(me.max_evolution_time);});

	},

};
