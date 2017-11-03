# simulation of Space Shuttle sensor information which doesn't need to be 
# available at FDM rate
# Thorsten Renk 2016-2017


###############################################################################
# star tracker
###############################################################################

var star_tracker_array = [];

# star tracker mode codes: 0: self-test, 1: star track, 2: target track, 3: break, 4: idle

var star_tracker = {
	new: func (designation, pointing_vec) {
 	var s = { parents: [star_tracker] };
	s.designation = designation;
	s.pointing_vec = pointing_vec;	
	s.world_pointing_vec = [0.0, 0.0, 0.0];
	s.world_pointing_vec_last = [0.0, 0.0, 0.0];
	s.mode = 1;
	s.failure = "";
	s.status = "";
	s.shutter = "OP";
	s.manual = 0;
	s.operational = 1;
	s.threshold = 3;
	s.target = geo.Coord.new();
	s.target_available = 0;
	s.cycle = 0;
	s.star_in_view = 0;
	s.star_ID = 0;
	return s;
	},

	set_mode: func (mode) {
	if (me.operational == 0) {return;}
	me.mode = mode;
	if ((mode == 2) or (mode == 3) or (mode == 4)) {me.star_in_view = 0;}
	
	},

	fail: func (status) {
	if (status == 1.0)
		{
		me.operational = 1;
		me.failure = "";
		}
	else
		{
		me.operational = 0;
		me.failure = "BITE";
		}

	},

	set_target: func (tgt) {

	me.target = tgt;
	me.target_available = 1;

	},

	self_test: func {

		me.shutter = "CL";

		settimer( func {
			me.star_in_view = 1;
			me.failure = "BITE";
		}, 1.0);

		settimer( func {
			me.star_in_view = 0;
			me.failure = "";
			me.shutter = "OP";
			if (me.operational == 1)
				{me.status = "ST PASS";}
			else
				{me.status = "ST FAIL";}


		}, 12.0);

		settimer( func {

			me.set_mode(4);

		}, 20.0);





	},


	run: func () {

	if (me.operational == 0) {return;}

	if (me.mode == 0)  {return;}

	var rate_q = math.abs(getprop("/fdm/jsbsim/velocities/q-rad_sec") * 57.2957);
	var rate_p = math.abs(getprop("/fdm/jsbsim/velocities/p-rad_sec") * 57.2957);
	var rate_r = math.abs(getprop("/fdm/jsbsim/velocities/r-rad_sec") * 57.2957);

	me.status = "";

	# check whether attitude change rate is too high

	if ((rate_q > 0.1) or (rate_p > 0.1) or (rate_r > 0.1))
		{
		me.status = "HI RATE";
		me.star_in_view = 0;
		return;
		}
	# check whether REL NAV forwards targeting information if we request target tracking

	if ((me.mode == 2) and ((me.target_available == 0) or (getprop("/fdm/jsbsim/systems/rendezvous/rel-nav-enable") == 0)))
		{
		me.status = "NO TARGET";
		me.star_in_view = 0;
		return;
		}

	# check whether overall alignment is okay

	var angular_error = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/angle-deg");

	if (angular_error > 1.2)
		{
		me.status = "FALSE TRK";
		return;
		}

	# check shutter status

	# this is a hack, we should use pointing vector and geometry rather than designation
	# - but it's much faster to just fetch the appropriate vectors directly

	if (me.designation == "-Z") 
		{
		me.world_pointing_vec[0] = getprop("/fdm/jsbsim/systems/pointing/world/body-z[0]");
		me.world_pointing_vec[1] = getprop("/fdm/jsbsim/systems/pointing/world/body-z[1]");
		me.world_pointing_vec[2] = getprop("/fdm/jsbsim/systems/pointing/world/body-z[2]");
		}
	else if (me.designation == "-Y")
		{
		me.world_pointing_vec[0] = -getprop("/fdm/jsbsim/systems/pointing/world/body-y[0]");
		me.world_pointing_vec[1] = -getprop("/fdm/jsbsim/systems/pointing/world/body-y[1]");
		me.world_pointing_vec[2] = -getprop("/fdm/jsbsim/systems/pointing/world/body-y[2]");
		}

	var sun_vec = [getprop("/ephemeris/sun/local/x"), getprop("/ephemeris/sun/local/y"), getprop("/ephemeris/sun/local/z")];

	var sun_angle_to_tracker = SpaceShuttle.dot_product(me.world_pointing_vec, sun_vec);

	#print (sun_angle_to_tracker);

	if ((me.manual == 0) and (sun_angle_to_tracker > 0.93))
		{me.shutter = "CL"; return;}
	else
		{me.shutter = "OP";}

	
	# now simulate the operating modes, target tracking first
	# we know we have a valid target at this point because we checked before

	if (me.mode == 2)
		{
		var spos = geo.aircraft_position();
		
		var world_rel_vec = [me.target.x() - spos.x(), me.target.y() - spos.y(), me.target.z() - spos.z()];
		world_rel_vec = SpaceShuttle.normalize(world_rel_vec);
		var angle_to_tgt = SpaceShuttle.dot_product(me.world_pointing_vec, world_rel_vec);

		#print(angle_to_tgt);
		
		if (angle_to_tgt < 0.96)
			{
			me.status = "OUT FOV";
			return;
			}

		}
	else if (me.mode == 1) # star tracking
		{
		# we track every 30 seconds and check if FOV has changed
		# if so, we throw dice whether we see a star
		if (me.cycle == 30) {me.cycle = 0; return;}
		if (me.cycle > 0) {me.cycle = me.cycle+1; return;}	

		me.cycle = me.cycle +1;
		#print("Starting star tracking cycle...", me.cycle);

		var pointing_diff = SpaceShuttle.dot_product(me.world_pointing_vec, me.world_pointing_vec_last);
		me.world_pointing_vec_last[0] = me.world_pointing_vec[0];
		me.world_pointing_vec_last[1] = me.world_pointing_vec[1];
		me.world_pointing_vec_last[2] = me.world_pointing_vec[2];

		#print ("Pointing diff: ", pointing_diff);

		if (pointing_diff < 0.98)
			{
			#print ("Star tracker - new FOV");

			var p_star = 0.5;

			if (rand() < p_star)
				{
				me.star_in_view = 1;
				me.star_ID = int (10.0 + rand() * 100.0);

				star_table.insert(me.star_ID, me.pointing_vec);
				}
			else
				{
				me.star_in_view = 0;
				me.star_ID = 0;
				}
			
			}
		}

	
	},

	

};




var star_tracker_y = star_tracker.new("-Y", [0, -1, 0]);
var star_tracker_z = star_tracker.new("-Z", [0, 0, 1]);

append(star_tracker_array, star_tracker_y);
append(star_tracker_array, star_tracker_z);

setlistener("/fdm/jsbsim/systems/failures/navigation/star-tracker-Y-condition", func (n) { star_tracker_array[0].fail(n.getValue());});
setlistener("/fdm/jsbsim/systems/failures/navigation/star-tracker-Z-condition", func (n) { star_tracker_array[1].fail(n.getValue());});



var apply_star_tracker_filter = func {


# first check whether trackers are tracking

if ((star_tracker_array[0].mode != 1) and (star_tracker_array[1].mode !=1))
	{return;}

if ((star_tracker_array[0].operational != 1) and (star_tracker_array[1].operational !=1))
	{return;}

# then check whether we are in the cycle

if ((star_tracker_array[0].cycle == 1) or (star_tracker_array[1].cycle == 1))
	{

	var tracker_quality = 0.2;

	if (star_tracker_array[0].star_in_view == 1)
		{
		tracker_quality = 0.5 * tracker_quality;
		}
	if (star_tracker_array[1].star_in_view == 1)
		{
		tracker_quality = 0.5 * tracker_quality;
		}

	var current_error = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/angle-deg");
	SpaceShuttle.update_orb_sv(1000.0, 1000.0, tracker_quality * current_error);

	}
}


###############################################################################
# star table
###############################################################################


var star_table = {

	track_ID: [0, 0, 0],
	delta_min : [0.0, 0.0, 0.0],
	ang_diff: [0.0, 0.0, 0.0],
	pointing: [[0.0, 0.0, 0.0], [0.0,0.0,0.0], [0.0,0.0,0.0]],
	ang_err: [0.0, 0.0, 0.0],
	time_stamp: [0.0, 0.0, 0.0],
	sel: [0,0,0],
	init_flag: 0,
	num_selected: 0,
	num_total: 0,

	select: func (i) {

		if (me.num_total < i) {return;}
		
		var state = me.sel[i-1];
		if ((state == 0) and (me.num_selected < 2))
			{
			state = 1;
			me.num_selected = me.num_selected + 1;
			}
		else if (state == 1)
			{
			state = 0;
			me.num_selected = me.num_selected - 1;
			}
		else
			{
			return;
			}	


		me.sel[i-1] = state;
		#print (me.num_selected, " stars selected");	

		if (me.num_selected == 2)
			{
			imu_system.align_enable = 1;
			}		

	},
	

	insert: func (track_ID, pointing) {

		me.sel[0] = 0;
		me.sel[1] = 0;
		me.sel[2] = 0;

		me.num_selected = 0;
		imu_system.align_enable = 0;

		# convert pointing vec to inertial

		pointing = SpaceShuttle.vtransform_body_inertial(pointing);

		# first, copy 2 -> 3 and 1 -> 2, then overwrite 1	
	
		me.track_ID[2] = me.track_ID[1];
		me.track_ID[1] = me.track_ID[0];

		me.delta_min[2] = me.delta_min[1];
		me.delta_min[1] = me.delta_min[0];

		me.ang_diff[2] = me.ang_diff[1];
		me.ang_diff[1] = me.ang_diff[0];

		me.ang_err[2] = me.ang_err[1];
		me.ang_err[1] = me.ang_err[0];

		me.time_stamp[2] = me.time_stamp[1];
		me.time_stamp[1] = me.time_stamp[0];

		me.pointing[2][0] = me.pointing[1][0];
		me.pointing[1][0] = me.pointing[0][0];

		me.pointing[2][1] = me.pointing[1][1];
		me.pointing[1][1] = me.pointing[0][1];

		me.pointing[2][2] = me.pointing[1][2];
		me.pointing[1][2] = me.pointing[0][2];

		me.track_ID[0] = track_ID;
		me.pointing[0][0] = pointing[0];
		me.pointing[0][1] = pointing[1];
		me.pointing[0][2] = pointing[2];

		var elapsed = getprop("/sim/time/elapsed-sec");
		me.time_stamp[0] = elapsed;

		var angle = SpaceShuttle.dot_product(me.pointing[0], me.pointing[1]);
		angle = SpaceShuttle.clamp(angle, -1.0, 1.0);
		angle = math.acos(angle) * 180.0/math.pi;
		me.ang_diff[0] = angle;
		if (me.init_flag == 0)
			{me.ang_diff[0] = 0.0;}
		me.init_flag = 1;

		me.ang_err[0] =  getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/angle-deg");

		me.num_total = me.num_total + 1;
		if (me.num_total > 3) {me.num_total = 3;}


	},

	clear: func () {

		me.track_ID[0] = 0;
		me.track_ID[1] = 0;
		me.track_ID[2] = 0;
		me.sel[0] = 0;
		me.sel[1] = 0;
		me.sel[2] = 0;
		me.num_selected = 0;
		me.num_total = 0;
		me.init_flag = 0;
		imu_system.align_enable = 0;


	},
};




###############################################################################
# COAS
###############################################################################


var coas = {

	reqd_id: 0,
	star_index: 0,
	Ddeg_x: 0.0,
	Ddeg_y: 0.0,
	sight_mode : 0,
	cal_mode: 0,
	deselect: 0,
	pos: 0,
	Dbias_x: 0,
	Dbias_y: 0,
	n_marks : 0,
	mark_vec: [[0.0, 0.0, 0.0],[0.0,0.0,0.0]],
	mark_quality: [0.0, 0.0],
	loop_flag: 0,
	filter_quality: 1.0,
	filter_error: 0.0,

	set_id: func (value) {

	if (value == 0) {me.stop(); return;}
	if ((value > 20) or (value < 11)) {return;} # we can only enter IDs in the explicit table
	me.reqd_id = value;
	me.star_index = me.reqd_id - 11;

	if (me.loop_flag == 0)  {me.loop_flag =1; coas_loop(); print("Init loop");}
	
	},

	run: func () {

	var star_vec = coas_star_table[me.star_index].pointing_vec;


	# first we determine the angular difference to the -Z axis for the display
	var body_y = [getprop("/fdm/jsbsim/systems/pointing/world/body-y[0]"), getprop("/fdm/jsbsim/systems/pointing/world/body-y[1]"), getprop("/fdm/jsbsim/systems/pointing/world/body-y[2]")];
	body_y_fi = SpaceShuttle.vtransform_world_fixed_inertial(body_y);
	me.Ddeg_y = math.asin(SpaceShuttle.dot_product(body_y_fi, star_vec)) * 180.0/math.pi;

	var body_x = [getprop("/fdm/jsbsim/systems/pointing/world/body-x[0]"), getprop("/fdm/jsbsim/systems/pointing/world/body-x[1]"), getprop("/fdm/jsbsim/systems/pointing/world/body-x[2]")];
	body_x_fi = SpaceShuttle.vtransform_world_fixed_inertial(body_x);
	me.Ddeg_x = math.asin(SpaceShuttle.dot_product(body_x_fi, star_vec)) * 180.0/math.pi;

	},

	stop: func () {

	me.loop_flag = 0;
	print("COAS loop ends.");

	},


	accept: func () {
		if (me.n_marks == 0)
			{
			me.n_marks = 1;
			}
		else if (me.n_marks == 1)
			{
			var combined_quality = 	me.mark_quality[0]+ me.mark_quality[1];	

		
			var rel_angle = SpaceShuttle.dot_product(me.mark_vec[0], me.mark_vec[1]);
			rel_angle = math.acos(rel_angle) * 180.0/math.pi;
		
			print ("COAS: angle between marks: ", rel_angle);	
		
			combined_quality = combined_quality * 10.0/rel_angle;

			if (combined_quality > 5.0) {combined_quality = 5.0;}
			if (combined_quality < 0.1) {combined_quality = 0.1;}

			print ("COAS: combined quality: ", combined_quality);

			var current_error = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/angle-deg");
			me.filter_error = combined_quality;
			me.filter_quality = combined_quality/current_error;

			me.Dbias_x = current_error * ((1.0 - me.filter_quality) + me.filter_quality * 2.0 * (rand() - 0.5));
			me.Dbias_y = current_error * ((1.0 - me.filter_quality) + me.filter_quality * 2.0 * (rand() - 0.5));

			
			}

	},

	clear_table: func () {

		me.n_marks = 0;
		me.reqd_id = 0;
		me.star_index = 0;
		me.Dbias_x = 0;
		me.Dbias_y = 0;
		me.loop_flag = 0;

	},

	update_state: func () {
		
		#var current_error = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/angle-deg");
		#SpaceShuttle.update_orb_sv(1000.0, 1000.0, me.filter_quality * current_error);

		# call an IMU matrix alignment on all units

		imu_system.calib_error_pitch = 2.0 * (rand() - 0.5) * me.filter_error;
		imu_system.calib_error_yaw = 2.0 * (rand() - 0.5) * me.filter_error;
		imu_system.calib_error_roll = 2.0 * (rand() - 0.5) * me.filter_error;

		imu_system.imu[0].sel_for_alignment = 1;
		imu_system.imu[1].sel_for_alignment = 1;
		imu_system.imu[2].sel_for_alignment = 1;

		imu_system.matrix_align();
	
		imu_system.imu[0].sel_for_alignment = 0;
		imu_system.imu[1].sel_for_alignment = 0;
		imu_system.imu[2].sel_for_alignment = 0;

		imu_system.calib_error_pitch = 0.0;
		imu_system.calib_error_yaw = 0.0;
		imu_system.calib_error_roll = 0.0;

		me.clear_table();

	},

};


var coas_loop = func {

coas.run();

if (coas.loop_flag == 1) {settimer(coas_loop, 1.0);}

}

var coas_att_ref = func {




if (coas.pos == 0)
	{var att_vec = [getprop("/fdm/jsbsim/systems/pointing/world/body-x[0]"), getprop("/fdm/jsbsim/systems/pointing/world/body-x[1]"), getprop("/fdm/jsbsim/systems/pointing/world/body-x[2]")];}
else
	{
	var att_vec = [getprop("/fdm/jsbsim/systems/pointing/world/body-z[0]"), getprop("/fdm/jsbsim/systems/pointing/world/body-z[1]"), getprop("/fdm/jsbsim/systems/pointing/world/body-z[2]")];
	}



var s_ang = getprop("/fdm/jsbsim/systems/pointing/sidereal/sidereal-angle-rad");

var tmp1 = math.cos(s_ang) * att_vec[0] - math.sin(s_ang) * att_vec[1];
var tmp2 = math.sin(s_ang) * att_vec[0] + math.cos(s_ang) * att_vec[1];

att_vec[0] = tmp1;
att_vec[1] = tmp2;

print("COAS: ", att_vec[0], " ", att_vec[1], " ", att_vec[2]);

foreach (s; coas_star_table)
	{
	var diff_angle = SpaceShuttle.dot_product(att_vec, s.pointing_vec);

	if (diff_angle > 0.99)
		{
		print("COAS: Star ", s.designation, " found.");
		}

	if ((coas.reqd_id > 0) and(s.designation == coas_star_table[coas.star_index].designation))
			{
			diff_angle = math.acos(diff_angle) * 180.0/math.pi;
			print ("COAS mark, quality ", diff_angle);
			coas.mark_vec[coas.n_marks][0] = s.pointing_vec[0];
			coas.mark_vec[coas.n_marks][1] = s.pointing_vec[1];
			coas.mark_vec[coas.n_marks][2] = s.pointing_vec[2];
			coas.mark_quality[coas.n_marks] = diff_angle;
			}

	}

};



var coas_star_table = [];

var star_entry = {

new: func (designation, pointing_vec, ra, dec) {
 	var s = { parents: [star_entry] };
	s.designation = designation;
	s.pointing_vec = pointing_vec;	
	s.ra = ra;
	s.dec = dec;
	return s;
	},
};

var star1 = star_entry.new("Shedir", [-0.007, -0.5490, 0.8357], 0.666, 56.53);
append(coas_star_table, star1);

var star2 = star_entry.new("Mirphak", [0.4186, -0.4866, 0.7667], 3.4, 49.85);
append(coas_star_table, star2);

var star3 = star_entry.new("Mizar", [-0.0988, 0.56751, 0.8174], 13.383, 54.91);
append(coas_star_table, star3);

var star4 = star_entry.new("Arcturus", [-0.37197, 0.8687, 0.32703], 14.25, 19.16);
append(coas_star_table, star4);

var star5 = star_entry.new("Betelgeuse", [0.9703, -0.20406, 0.12928], 5.916, 7.4);
append(coas_star_table, star5);

var star6 = star_entry.new("Procyon", [0.96436, 0.24861, 0.090506], 7.65, 5.216);
append(coas_star_table, star6);
 
var star7 = star_entry.new("Spica", [-0.1825, 0.9632, -0.1968], 13.416, -11.15);
append(coas_star_table, star7);

var star8 = star_entry.new("Antares", [-0.7525, 0.4893, -0.44075], 16.483, -26.416);
append(coas_star_table, star8);

var star9 = star_entry.new("Canopus", [0.60404, -0.04409, -0.79573], 6.383, -52.683);
append(coas_star_table, star9);

var star10 = star_entry.new("Sirius", [0.9575, 0.0084, -0.2883], 6.75, -16.7);
append(coas_star_table, star10);


###############################################################################
# TACAN receivers
###############################################################################


var tacan_receiver = {


	new: func (index) {
	 	var t = { parents: [tacan_receiver] };
		t.index = index;
		t.offset_factor_range = 2.0 * (rand() - 0.5);	
		t.offset_factor_azimuth = 2.0 * (rand() - 0.5);
		t.offset_range = 0.3 * t.offset_factor_range;
		t.offset_azimuth = 2.5 * t.offset_factor_azimuth;
		t.operational = 0;
		t.deselected = 0;
		t.soft_failed = 0;
		t.dilemma = 0;
		t.channel = 7;
		return t;
		},

	update_status: func {

		var flag = 1;
	
		if (getprop("/fdm/jsbsim/systems/navigation/tacan", me.index, "operational") == 0)
			{flag = 0;}

		if (me.deselected == 1)
			{flag = 0;}

		if (me.soft_failed == 1)
			{flag = 0;}



		var value = me.index+1;
		var condition = getprop("/fdm/jsbsim/systems/failures/navigation/tacan-"~value~"-condition");

		if (condition > 0)
			{
			me.offset_range = 0.3 * me.offset_factor_range * condition;
			me.offset_azimuth = 2.5 * me.offset_factor_azimuth * condition;
			}
		
	
		me.operational = flag;

		},

	set_channel : func (channel) {

		me.channel = channel;

		},

	indicated_range: func (range) {

		var value = range + me.offset_range;
		if (value < 0.0) {value=0.0;}

		return value;

		},

	indicated_azimuth: func (azimuth) {
		
		return azimuth + me.offset_azimuth;

		},

	self_test: func {

		if ((me.offset_range < 0.5) and (me.offset_azimuth < 2.5))
			{return 1;}
		else
			{return 0;}	

		},

	get_status_string: func {

		if (me.soft_failed == 1) {return "↓";}
		else if (me.dilemma == 1) {return "?";}
		else if ((SpaceShuttle.TAEM_TACAN_available == 0) and (SpaceShuttle.TAEM_guidance_available == 0)) 
			{return "M";}
		else if ((me.operational == 0) and (me.deselected == 0))  {return "M";}
		else {return "";}

		},


};


var tacan_system = {

	num_operational_receivers : 0,
	dilemma: 0,



	init: func {

		me.receiver = [];
	
		for (var i=0; i< 3; i=i+1)
			{
			var t = tacan_receiver.new(i);
			append(me.receiver, t);
			}

	},


	redundancy_management: func {

		var n = 0;
		var az_threshold = 5.0;		

		for (var i = 0; i< 3; i=i+1)
			{
			me.receiver[i].update_status();

			if (me.receiver[i].operational == 1)
				{
				n=n+1;
				}
	
			}
		me.num_operational_receivers = n;

		#print("Found ", n, " operational units.");

		if (me.num_operational_receivers == 3) # pairwise comparison
			{

			var delta_az_12 = math.abs (me.receiver[0].offset_azimuth - me.receiver[1].offset_azimuth);
			var delta_az_13 = math.abs (me.receiver[0].offset_azimuth - me.receiver[2].offset_azimuth);
			var delta_az_23 = math.abs (me.receiver[1].offset_azimuth - me.receiver[2].offset_azimuth);


			#print("12: ", delta_az_12, " 13: ", delta_az_13, " 23: ", delta_az_23);

			if ((delta_az_12 > az_threshold) and (delta_az_13 > az_threshold))
				{
				if (delta_az_23 < az_threshold)
					{me.receiver[0].soft_failed = 1;}
				else
					{
					me.receiver[0].dilemma = 1;
					me.receiver[1].dilemma = 1;
					me.receiver[2].dilemma = 1;
					me.dilemma = 1;
					}
				}
			if ((delta_az_12 > az_threshold) and (delta_az_23 > az_threshold))
				{
				if (delta_az_13 < az_threshold)
					{me.receiver[1].soft_failed = 1;}
				else
					{
					me.receiver[0].dilemma = 1;
					me.receiver[1].dilemma = 1;
					me.receiver[2].dilemma = 1;
					me.dilemma = 1;
					}
				}
			if ((delta_az_23 > az_threshold) and (delta_az_13 > az_threshold))
				{
				if (delta_az_12 < az_threshold)
					{me.receiver[2].soft_failed = 1;}
				else
					{
					me.receiver[0].dilemma = 1;
					me.receiver[1].dilemma = 1;
					me.receiver[2].dilemma = 1;
					me.dilemma = 1;
					}
				}
			}

		else if (me.num_operational_receivers == 2) # pairwise comparison
			{
			var index1 = -1;
			var index2 = -1;

			for (var i = 0; i<3; i=i+1)
				{
				if ((me.receiver[i].operational == 1) and (index1 == -1))
					{
					index1 = i;
					}
				else if (me.receiver[i].operational == 1)
					{
					index2 = i;
					}
				}

			var delta_az = math.abs (me.receiver[index1].offset_azimuth - me.receiver[index2].offset_azimuth);


				if (delta_az > az_threshold)
					{
					me.receiver[index1].dilemma = 1;
					me.receiver[index2].dilemma = 1;
					me.dilemma = 1;
					}

			}

		else if (me.num_operational_receivers == 1) # a single receiver can't be in dilemma
			{
				for (var i=0; i<3; i=i+1)
					{
					me.receiver[i].dilemma = 0;
					me.dilemma = 0;
					}

			}

	},

	acc_dist : func (dist) {

		if (me.num_operational_receivers == 0) {return 5000.0;}

		var tacan_acc_dist  = 0.002 * dist;
		if (tacan_acc_dist < 185.0) {tacan_acc_dist = 185.0;}

		return tacan_acc_dist;

	},

	acc_az : func (dist) {

		if (me.num_operational_receivers == 0) {return 5000.0;}

		var tacan_acc_az =  0.0085 * dist;


		return tacan_acc_az;
	},

	
	offset_az : func {

		if (me.num_operational_receivers == 0) {return 0.0;}

		var offset_az = 0.0;

		for (var i = 0; i < 3; i=i+1)
			{
			offset_az = offset_az + me.receiver[i].offset_azimuth * me.receiver[i].operational;
			}

		return offset_az / me.num_operational_receivers;

	},

	offset_range: func {

		if (me.num_operational_receivers == 0) {return 0.0;}

		var offset_range = 0.0;

		for (var i = 0; i < 3; i=i+1)
			{
			offset_range = offset_range + me.receiver[i].offset_range * me.receiver[i].operational;
			}

		return offset_range/ me.num_operational_receivers;
		
	},


};

tacan_system.init();

setlistener("/fdm/jsbsim/systems/failures/navigation/tacan-1-condition", func () { tacan_system.receiver[0].update_status();});
setlistener("/fdm/jsbsim/systems/failures/navigation/tacan-2-condition", func () { tacan_system.receiver[1].update_status();});
setlistener("/fdm/jsbsim/systems/failures/navigation/tacan-3-condition", func () { tacan_system.receiver[2].update_status();});


###############################################################################
# MLS receivers
###############################################################################

var mls_receiver = {


	new: func (index) {
	 	var m = { parents: [mls_receiver] };
		m.index = index;
		m.channel = 7;
		return m;
		},

	set_channel: func (channel) {

		me.channel = channel;

		},
		
};

var mls_system = {

	num_operational_receivers : 0,
	dilemma: 0,


	init: func {

		me.receiver = [];
	
		for (var i=0; i< 3; i=i+1)
			{
			var m = mls_receiver.new(i);
			append(me.receiver, m);
			}

	},
};


mls_system.init();


###############################################################################
# IMU system
###############################################################################

var imu_unit = {

	new: func (index) {
		var i = {parents: [imu_unit] };
		
		i.index = index;
		i.operational = 1;
		i.drift_rate = 0.000066; # 0.24 deg/h
		i.damage_drift = 0.0;
		i.thermal_drift = 0.0;
		i.mode = "OPER";
		i.temperature = 150.0;
		i.temp_string = "OK";
		i.pitch_error = 0.0;
		i.yaw_error = 0.0;
		i.roll_error = 0.0;
		i.acc_error_x = 0.0;
		i.acc_error_y = 0.0;
		i.acc_error_z = 0.0;
		i.status_string = "";
		i.deselected = 0;
		i.condition = 1.0;
		i.powered = 1;
		i.sel_for_alignment = 0;
		i.delta_roll = 0.0;
		i.delta_pitch = 0.0;
		i.delta_yaw = 0.0;
		i.dilemma = 0;
		i.soft_failed = 0;

		return i;
	},


	switch_mode: func (mode) {
		me.mode = mode;

		if (me.mode == "STBY")
			{
			me.operational = 0;
			setprop("/fdm/jsbsim/systems/navigation/imu"~(me.index+1)~"-power-demand-kW", 0.05);
			}	
		else if ((me.powered == 1) and (me.condition > 0.0))
			{
			me.operational = 1;
			setprop("/fdm/jsbsim/systems/navigation/imu"~(me.index+1)~"-power-demand-kW", 0.22);
			}	


	},


	switch_power: func (power) {

		me.powered = power;

		if (me.powered == 0)
			{	
			me.operational = 0;
			me.status_string = "OFF";
			setprop("/fdm/jsbsim/systems/navigation/imu"~(me.index+1)~"-power-demand-kW", 0.0);
			}


	},

	drift: func {

		var drift = me.drift_rate + me.damage_drift + me.thermal_drift;			

		me.pitch_error = me.pitch_error +  drift * 2.0 * (rand() - 0.5);
		me.yaw_error = me.yaw_error +  drift * 2.0 * (rand() - 0.5);
		me.roll_error = me.roll_error +  drift * 2.0 * (rand() - 0.5);

	},

	update_status : func {

		me.condition  = getprop("/fdm/jsbsim/systems/failures/navigation/imu-"~(me.index+1)~"-condition");

		if (me.condition == 0)
			{	
			me.operational = 0;
			me.status_string = "BITE";
			}
		else 
			{
			me.damage_drift = (1.0 - me.condition) * 0.0025;
			}

	},

	thermal_evolution: func {


		var num_fans = getprop("/fdm/jsbsim/systems/eclss/avbay/num-imu-fans-operational");

		me.temperature = me.temperature - math.sqrt(num_fans);
		
		if (me.powered == 1)
			{
			if (me.mode == "OPER")
				{me.temperature = me.temperature + 1.0;}
			else
				{me.temperature = me.temperature + 0.5;}
			}

		if (me.temperature < 141.0)
			{
			me.temperature = 141.0;
			}
		else if (me.temperature > 180.0)
			{
			me.temperature = 180.0;
			}

		if (me.temperature > 156.5)
			{
			me.temp_string = "HI";
			me.thermal_drift = 0.0001 * (me.temperature - 156.5); 
			}
		else if (me.temperature == 141.0)
			{
			me.temp_string = "LO";
			me.thermal_drift = 0.0;
			}
		else
			{
			me.temp_string = "OK";
			me.thermal_drift = 0.0;
			}
	

	},


	get_status_symbol : func {

		if ((me.powered == 0) or (me.condition == 0)) 
			{
			return "M";
			}
		else if (me.deselected == 1)
			{
			return "↓";
			}
		else if (me.dilemma == 1)
			{
			return "?";
			}
		else 
			{
			return " ";
			}

	},

};




var imu_system = {

	num_units : 3,
	num_cand : 3,
	first_functional: 0,
	alignment_method: 0, # 0: star tracker 1: IMU/IMU 2: matrix
	reference_imu: 0,
	current_error_pitch: 0.0,
	current_error_yaw: 0.0,
	current_error_roll: 0.0,
	calib_error_pitch: 0.0,
	calib_error_yaw: 0.0,
	calib_error_roll: 0.0,
	deselect_threshold_3: 0.4,
	deselect_threshold_2: 0.8,
	attitude_source: 1,
	align_enable: 0,
	align_in_progress: 0,
	perfect_navigation: 0,
	

	counter: 0,
	

	init: func {

		me.imu = [];
		for (var i = 0; i< me.num_units; i=i+1)
			{
			var iu = imu_unit.new(i);
			append(me.imu, iu);
			}

	},

	imu_drift: func {

		if (me.perfect_navigation == 1) {return;}

		for (var i = 0; i< me.num_units; i=i+1)
			{
			me.imu[i].drift();
			}

	},
	

	update_deltas: func {

		for (var i = 0; i < me.num_units; i=i+1)
			{
			if (me.imu[i].operational == 1)
				{
				if (me.alignment_method == 1)
					{
					me.imu[i].delta_pitch = me.imu[me.reference_imu-1].pitch_error - me.imu[i].pitch_error;
					me.imu[i].delta_yaw = me.imu[me.reference_imu-1].yaw_error - me.imu[i].yaw_error;
					me.imu[i].delta_roll = me.imu[me.reference_imu-1].roll_error - me.imu[i].roll_error;
					}
				else
					{
					me.imu[i].delta_pitch = me.calib_error_pitch - me.imu[i].pitch_error;
					me.imu[i].delta_yaw = me.calib_error_yaw - me.imu[i].yaw_error;
					me.imu[i].delta_roll = me.calib_error_roll - me.imu[i].roll_error;
					}
				}
			}


	},

	
	star_align: func {

		var terminate_flag = 0;
		var num_processed = 0;

		for (var i = 0; i < me.num_units; i=i+1)
			{

			if ((me.imu[i].operational == 1) and (me.imu[i].sel_for_alignment))
				{
				num_processed = num_processed + 1;
				
				var current_error = me.calib_error_pitch - me.imu[i].pitch_error;

				if (current_error > 0.007)
					{
					me.imu[i].pitch_error = me.imu[i].pitch_error + 0.007;
					}
				else if (current_error < -0.007)
					{
					me.imu[i].pitch_error = me.imu[i].pitch_error - 0.007;
					}
				else
					{
					me.imu[i].pitch_error = me.calib_error_pitch;
					terminate_flag = terminate_flag + 1;
					}

				current_error = me.calib_error_yaw - me.imu[i].yaw_error;

				if (current_error > 0.007)
					{
					me.imu[i].yaw_error = me.imu[i].yaw_error + 0.007;
					}
				else if (current_error < -0.007)
					{
					me.imu[i].yaw_error = me.imu[i].yaw_error - 0.007;
					}
				else
					{
					me.imu[i].yaw_error = me.calib_error_yaw;
					terminate_flag = terminate_flag + 1;
					}

				current_error = me.calib_error_roll - me.imu[i].roll_error;


				if (current_error > 0.007)
					{
					me.imu[i].roll_error = me.imu[i].roll_error + 0.007;
					}
				else if (current_error < -0.007)
					{
					me.imu[i].roll_error = me.imu[i].roll_error - 0.007;
					}
				else
					{
					me.imu[i].roll_error = me.calib_error_roll;
					terminate_flag = terminate_flag + 1;
					}

				}
			}


		if (terminate_flag == (num_processed * 3))
			{
			me.align_in_progress = 0;
			print ("IMU alignment finished");
			star_table.clear();
			}

		me.update_deltas();


			

	},

	imu_imu_align: func {

		var terminate_flag = 0;
		var num_processed = 0;

		for (var i = 0; i < me.num_units; i=i+1)
			{

			if ((me.imu[i].operational == 1) and (me.imu[i].sel_for_alignment))
				{
				num_processed = num_processed + 1;
				
				var current_error = me.imu[me.reference_imu-1].pitch_error - me.imu[i].pitch_error;

				if (current_error > 1.2)
					{
					me.imu[i].pitch_error = me.imu[i].pitch_error + 1.2;
					}
				else if (current_error < -1.2)
					{
					me.imu[i].pitch_error = me.imu[i].pitch_error - 1.2;
					}
				else if (current_error > 0.007)
					{
					me.imu[i].pitch_error = me.imu[i].pitch_error + 0.007;
					}
				else if (current_error < -0.007)
					{
					me.imu[i].pitch_error = me.imu[i].pitch_error - 0.007;
					}
				else
					{
					me.imu[i].pitch_error = me.imu[me.reference_imu-1].pitch_error;
					terminate_flag = terminate_flag + 1;
					}

				current_error = me.imu[me.reference_imu-1].yaw_error - me.imu[i].yaw_error;

				if (current_error > 1.2)
					{
					me.imu[i].yaw_error = me.imu[i].yaw_error + 1.2;
					}
				else if (current_error < -1.2)
					{
					me.imu[i].yaw_error = me.imu[i].yaw_error - 1.2;
					}
				else if (current_error > 0.007)
					{
					me.imu[i].yaw_error = me.imu[i].yaw_error + 0.007;
					}
				else if (current_error < -0.007)
					{
					me.imu[i].yaw_error = me.imu[i].yaw_error - 0.007;
					}
				else
					{
					me.imu[i].yaw_error = me.imu[me.reference_imu-1].yaw_error;
					terminate_flag = terminate_flag + 1;
					}

				current_error = me.imu[me.reference_imu-1].roll_error - me.imu[i].roll_error;

				if (current_error > 1.2)
					{
					me.imu[i].roll_error = me.imu[i].roll_error + 1.2;
					}
				else if (current_error < -1.2)
					{
					me.imu[i].roll_error = me.imu[i].roll_error - 1.2;
					}
				else if (current_error > 0.007)
					{
					me.imu[i].roll_error = me.imu[i].roll_error + 0.007;
					}
				else if (current_error < -0.007)
					{
					me.imu[i].roll_error = me.imu[i].roll_error - 0.007;
					}
				else
					{
					me.imu[i].roll_error = me.imu[me.reference_imu-1].roll_error;
					terminate_flag = terminate_flag + 1;
					}

				}
			}


		if (terminate_flag == (num_processed * 3))
			{
			me.align_in_progress = 0;
			print ("IMU alignment finished");
			}

		me.update_deltas();


			

	},


	matrix_align: func {


		for (var i = 0; i < me.num_units; i=i+1)
			{

			if ((me.imu[i].operational == 1) and (me.imu[i].sel_for_alignment))
				{

				me.imu[i].pitch_error = me.calib_error_pitch;
				me.imu[i].yaw_error = me.calib_error_yaw;
				me.imu[i].roll_error = me.calib_error_roll;
				}
			}


		me.align_in_progress = 0;
		print ("IMU alignment finished");
			

		me.update_deltas();


	},

	candidate_selection: func {
		me.num_cand = 0;
		me.first_functional = -1;
		for (var i = 0; i< me.num_units; i=i+1)
			{
			if ((me.imu[i].operational == 1) and (me.imu[i].deselected == 0))
				{
				me.num_cand = me.num_cand + 1;
				if (me.first_functional == -1)
					{me.first_functional = i;}
				}
			}
		if (me.num_cand == 1)
			{
			for (var i = 0; i< me.num_units; i=i+1)
				{
				me.imu[i].dilemma = 0;
				}
			}

	},

	
	redundancy_management_lowlevel: func (data) {

		if (me.num_cand == 3) #mid-value selection
			{
			var diff = [];

			append(diff,SpaceShuttle.norm(SpaceShuttle.subtract_vector(data[0], data[1])));
			append(diff,SpaceShuttle.norm(SpaceShuttle.subtract_vector(data[0], data[2])));
			append(diff,SpaceShuttle.norm(SpaceShuttle.subtract_vector(data[1], data[2])));

			#append(diff, math.abs(data[0] - data[1]));
			#append(diff, math.abs(data[0] - data[2]));
			#append(diff, math.abs(data[1] - data[2]));

			if ((diff[0] > me.deselect_threshold_3) and (diff[1] > me.deselect_threshold_3))
				{
				me.imu[0].deselected = 1;
				me.imu[0].soft_failed = 1;
				}
			else if ((diff[0] > me.deselect_threshold_3) and (diff[2] > me.deselect_threshold_3))
				{
				me.imu[1].deselected = 1;
				me.imu[1].soft_failed = 1;
				}
			else if ((diff[1] > me.deselect_threshold_3) and (diff[2] > me.deselect_threshold_3))
				{
				me.imu[2].deselected = 1;
				me.imu[2].soft_failed = 1;
				}



			if ((diff[0] > diff[1]) and (diff[0] > diff[2]))
				{
				me.attitude_source = 2;
				}
			else if ((diff[1] > diff[0]) and (diff[1] > diff[2]))
				{
				me.attitude_source = 1;
				}
			else 
				{
				me.attitude_source = 0;
				}

			}
		else if (me.num_cand == 2)
			{
			#var diff = math.abs(data[0] - data[1]);
			var diff = SpaceShuttle.norm(SpaceShuttle.subtract_vector(data[0], data[1]));

			if (diff > me.deselect_threshold_2)
				{
				for (var i = 0; i< me.num_units; i=i+1)
					{
					if ((me.imu[i].deselected == 0) and (me.imu[i].operational == 1))
						{me.imu[i].dilemma = 1;}
					}
				
				}

			me.attitude_source = me.first_functional;
			}
		else if (me.num_cand == 1)
			{
			me.attitude_source = me.first_functional;
			}
		else
			{
			me.attitude_source = 0;
			}

	},

	redundancy_management: func {


		var error_vec = [];

		for (var i = 0; i< me.num_units; i=i+1)
			{
			if ((me.imu[i].deselected == 0) and (me.imu[i].operational == 1))
			{
			append(error_vec, [me.imu[i].pitch_error, me.imu[i].yaw_error, me.imu[i].roll_error]);	
			}
			}
		me.redundancy_management_lowlevel(error_vec);

		#print ("Attitude source: ", me.attitude_source);
			

		
	},

	update_temperatures: func {

		for (var i = 0; i< me.num_units; i=i+1)
			{
			me.imu[i].thermal_evolution();
			}
		#print ("IMU temperatures: ", me.imu[0].temperature, " ", me.imu[1].temperature, " ", me.imu[2].temperature);
	

	},

	update_sv_errors: func {

		var pe = me.imu[me.attitude_source].pitch_error;
		setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/pitch-deg", pe );

		var ye = me.imu[me.attitude_source].yaw_error;
		setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/yaw-deg", ye );

		var re = me.imu[me.attitude_source].roll_error;
		setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/roll-deg", re );

		setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/angle-deg", 0.333* (math.abs(pe) + math.abs(ye) + math.abs(re)));

	},



	run: func {

		me.counter = me.counter + 1;

		if (me.counter == 10)
			{
			me.update_temperatures();
			}

		else if (me.counter == 20)
			{	
			me.imu_drift();
			}
		else if (me.counter == 30)
			{
			me.candidate_selection();
			me.redundancy_management();
			}
		else if (me.counter == 40)
			{
			me.update_sv_errors();
			}
		else if (me.counter == 60) 
			{
			me.counter = 0;
			me.update_deltas();
			}
 		
		me.imu_drift();			


		if (me.align_in_progress == 1)
			{
			if (me.alignment_method == 0)
				{
				me.star_align();
				}
			else if (me.alignment_method == 1)
				{
				me.imu_imu_align();
				}
			else if (me.alignment_method == 2)
				{
				me.matrix_align();
				}
			}

	},

	list: func {

		print("IMU 1 errors");
		print("Pitch: ", me.imu[0].pitch_error);
		print("Yaw: ", me.imu[0].yaw_error);
		print("Roll: ", me.imu[0].roll_error);

		print("IMU 2 errors");
		print("Pitch: ", me.imu[1].pitch_error);
		print("Yaw: ", me.imu[1].yaw_error);
		print("Roll: ", me.imu[1].roll_error);

		print("IMU 3 errors");
		print("Pitch: ", me.imu[2].pitch_error);
		print("Yaw: ", me.imu[2].yaw_error);
		print("Roll: ", me.imu[2].roll_error);

		print("");
		print("Attitude source: ", me.attitude_source + 1);

		print("");
		print("Des: ", me.imu[0].deselected, " ", me.imu[1].deselected, " ", me.imu[2].deselected);
		

	},


};

imu_system.init();

setlistener("/fdm/jsbsim/systems/failures/navigation/imu-1-condition", func () { imu_system.imu[0].update_status();});
setlistener("/fdm/jsbsim/systems/failures/navigation/imu-2-condition", func () { imu_system.imu[1].update_status();});
setlistener("/fdm/jsbsim/systems/failures/navigation/imu-3-condition", func () { imu_system.imu[2].update_status();});

###############################################################################
# Air data system
###############################################################################


var adta_unit = {

	new: func (index, p_index) {
	 	var a = { parents: [adta_unit] };
		a.index = index;
		a.p_index = p_index;
		a.offset = 1.0 + 0.01 * (rand() -0.5);
		a.p_alt = 1.0;
		a.p_mach = 1.0;
		a.p_aoa = 1.0;
		a.fom = 1.0;
		a.probe_deployed = 0;
		a.pressure_fail = 0;
		a.operational = 1;
		a.condition = 1.0;
		a.deselected = 0;
		a.dilemma = 0;
		a.soft_failed = 0;
		return a;
		},

	update_pressure_deviation: func (p_fact) {

		if (p_fact == 0) 
			{
			me.pressure_fail = 1;
			return;
			}
		me.p_alt = -math.ln(p_fact) * 28000.0;
		me.p_mach = 1.0/math.sqrt(p_fact);
		me.p_aoa = p_fact; 
		me.pressure_fail = 0;
		},

	update_status: func {

		var flag = 1;

		if (me.p_index == 0)
			{
			if (getprop("/fdm/jsbsim/systems/navigation/air-data-left-deployed") == 0)
				{flag = 0; me.probe_deployed = 0;}
			else
				{me.probe_deployed = 1;}
			}
		else
			{
			if (getprop("/fdm/jsbsim/systems/navigation/air-data-right-deployed") == 0)
				{flag = 0; me.probe_deployed = 0;}
			else
				{me.probe_deployed = 1;}
			}

		var iref = me.index + 1;

		me.condition = getprop("/fdm/jsbsim/systems/failures/navigation/adta-"~iref~"-condition");

		if (me.condition == 0) {flag = 0;}

		me.operational = flag;

		me.fom = (1.0 + ((me.offset - 1.0) * me.condition)) * me.p_aoa;


	},
	
	
	indicated_alt: func (alt) {


		return alt * (1.0 + (me.offset-1.0)  * me.condition) + me.p_alt;

		},
	indicated_aoa: func (aoa) {

		return aoa * me.p_aoa * (1.0 + ((me.offset-1.0)  * me.condition));
		
		},

	indicated_mach: func (mach) {

		return mach * me.p_mach * (1.0 + ((me.offset - 1.0)  * me.condition));

		},	

	status_string : func {

		if (me.probe_deployed == 1)
			{
			if (me.condition == 0) {return "M";}
			else if (me.pressure_fail == 1) {return "M";}
			else if (me.soft_failed == 1) {return "↓";}
			else if (me.dilemma == 1) {return "?";}
			else {return "";}
			}
		else
			{
			return "";
			}
		},

};


var probe_unit = {
	new: func (index) {
	 	var p = { parents: [probe_unit] };
		p.index = index;
		p.offset_pressure = 1.0;
		return p;
		},

};

var air_data_system = {

	num_usable_units : 0,
	num_usable_units_left: 0,
	num_usable_units_right: 0,
	num_good_units : 0,
	num_good_units_right: 0,
	num_good_units_left: 0,  

	init: func {
		me.adta = [];
		me.probe = [];
		
		var p = 0;	

		for (var i=0; i< 4; i=i+1)
			{ 
			var a = adta_unit.new(i, p);
			p = p+1;
			if (p==2) {p=0;}
			append(me.adta, a);
			}

		for (var i=0; i< 2; i=i+1)
			{
			var pu = probe_unit.new(i);
			append(me.probe, pu);
			}

	},

	
	update_adta_status : func {
		for (var i=0; i< 4; i=i+1)
			{ 
			me.adta[i].update_status();
			}

	},
	

	apply_probe_damage : func (p_index, fact) {

		for (var i=0; i<4; i=i+1)
			{
			if (me.adta[i].p_index == p_index)
				{
				me.adta[i].update_pressure_deviation(fact);
				}
			}
		

	},  


	update: func {

		if (getprop("/fdm/jsbsim/systems/navigation/air-data-available") == 0)
			{return;}

		var n = 0;
		var n_left = 0;
		var n_right = 0;

		var nn = 0;
		var nn_left = 0;
		var nn_right = 0;

		for (var i=0; i<4; i=i+1)
			{
			me.adta[i].update_status();
			if (me.adta[i].operational == 1) 
				{
				n = n+1;

				if ((me.adta[i].soft_failed == 0) and (me.adta[i].deselected == 0))
					{nn = nn + 1;}

				if (me.adta[i].p_index == 0)
					{
					n_left = n_left + 1;
					if ((me.adta[i].soft_failed == 0) and (me.adta[i].deselected == 0))	
						{nn_left = nn_left + 1;}
					}
				else
					{
					n_right = n_right + 1;
					if ((me.adta[i].soft_failed == 0) and (me.adta[i].deselected == 0))	
						{nn_right = nn_right + 1;}
					}
				}			
			}

		me.num_usable_units = n;
		me.num_usable_units_left = n_left;
		me.num_usable_units_right = n_right;

		me.num_good_units = nn;
		me.num_good_units_left = nn_left;
		me.num_good_units_right = nn_right;

		me.redundancy_management();
	},

	declare_dilemma: func {

		for (var i=0; i<4; i=i+1)
			{
			me.adta[i].dilemma = 1;
			}
		setprop("/fdm/jsbsim/systems/cws/air-data", 1);

	},

	lift_dilemma: func {

		for (var i=0; i<4; i=i+1)
			{
			me.adta[i].dilemma = 0;
			}
		setprop("/fdm/jsbsim/systems/cws/air-data", 0);

	},

	redundancy_management: func {

		#print ("Left: ", me.num_good_units_left, " Right: ", me.num_good_units_right);

		var test_left = 0;

		if (me.num_good_units_left == 2)
			{		
			if (math.abs(me.adta[0].fom - me.adta[2].fom) < 0.01)		
				{test_left = 1;}
			}
		else if (me.num_good_units_left == 1)
			{
			test_left = 1;
			}

		var test_right = 0;

		if (me.num_good_units_right == 2)
			{
			if (math.abs(me.adta[1].fom - me.adta[3].fom) < 0.01)		
				{test_right = 1;}
			}
		else if (me.num_good_units_right == 1)
			{
			test_right = 1;
			}

		var test_side_side = 0;

		var cand_left = 0.0;

		if (me.num_good_units_left == 2)
			{cand_left = 0.5 * (me.adta[0].fom + me.adta[2].fom);}
		else if (me.num_good_units_left == 1)
			{
			
			if ((me.adta[0].operational == 1) and (me.adta[0].soft_failed == 0) and (me.adta[0].deselected == 0))
				{
				cand_left = me.adta[0].fom;
				}
			else
				{
				cand_left = me.adta[2].fom;
				}
			}

		var cand_right = 0.0;

		if (me.num_good_units_right == 2)
			{cand_right = 0.5 * (me.adta[1].fom + me.adta[3].fom);}
		else if (me.num_good_units_right == 1)
			{
			
			if ((me.adta[1].operational == 1) and (me.adta[1].soft_failed == 0) and (me.adta[1].deselected == 0))
				{
				cand_right = me.adta[1].fom;
				}
			else
				{
				cand_right = me.adta[3].fom;
				}
			}

		if (math.abs(cand_left - cand_right) < 0.01)
			{
			test_side_side = 1;
			}	
		

	#var string_left = "pass";
	#if (test_left == 0) {string_left = "fail";}

	#var string_right = "pass";
	#if (test_right == 0) {string_right = "fail";}

	#var string_side = "pass";
	#if (test_side_side == 0) {string_side= "fail";}

	#print("Left: ", string_left, " Right: ", string_right, " Side-side: ", string_side);

		if ((test_left == 1) and (test_right == 1) and (test_side_side == 1))	
			{
			me.lift_dilemma();
			}
		else if ((test_left == 1) and (test_right == 1) and (test_side_side == 0))
			{
			me.declare_dilemma();
			}
		else if (me.num_good_units == 0)
			{
			me.declare_dilemma();
			}
		else if (me.num_good_units == 1)
			{
			me.lift_dilemma();
			}
		else if ((me.num_good_units_left == 0) and (test_right == 0))
			{
			me.declare_dilemma();
			}
		else if ((me.num_good_units_left == 0) and (test_right == 1))
			{
			me.lift_dilemma();
			}
		else if ((me.num_good_units_right == 0) and (test_left == 0))
			{
			me.declare_dilemma();
			}
		else if ((me.num_good_units_right == 0) and (test_left == 1))
			{
			me.lift_dilemma();
			}
		else if ((test_right == 0) and (test_left == 1) and (test_side_side == 0))
			{
			if (me.num_good_units_right == 1)
				{me.declare_dilemma();}
			else
				{
				if (math.abs( me.adta[1].fom - cand_left) < 0.01)
					{
					me.adta[3].soft_failed = 1;
					}
				else
					{
					me.adta[1].soft_failed = 1;
					}
				}

			}
		else if ((test_left == 0) and (test_right == 1) and (test_side_side == 0))
			{
			if (me.num_good_units_left == 1)
				{me.declare_dilemma();}
			else
				{
				if (math.abs( me.adta[0].fom - cand_right) < 0.01)
					{
					me.adta[2].soft_failed = 1;
					}
				else
					{
					me.adta[0].soft_failed = 1;
					}
				}

			}

	},


};

air_data_system.init();
air_data_system.update_adta_status();

setlistener("/fdm/jsbsim/systems/failures/navigation/air-data-pressure-left-condition", func (n) { air_data_system.apply_probe_damage(0, n.getValue());});
setlistener("/fdm/jsbsim/systems/failures/navigation/air-data-pressure-right-condition", func (n)  { air_data_system.apply_probe_damage(1, n.getValue());});
