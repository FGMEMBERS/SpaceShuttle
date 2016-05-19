# simulation of Space Shuttle sensor information which doesn't need to be 
# available at FDM rate
# Thorsten Renk 2016


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


	run: func () {

	if (me.operational == 0) {return;}

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

setlistener("/fdm/jsbsim/systems/failures/sensors/star-tracker-Y-condition", func (n) { star_tracker_array[0].fail(n.getValue());});
setlistener("/fdm/jsbsim/systems/failures/sensors/star-tracker-Z-condition", func (n) { star_tracker_array[1].fail(n.getValue());});



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


	insert: func (track_ID, pointing) {

		me.sel[0] = 0;
		me.sel[1] = 0;
		me.sel[2] = 0;

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


	},

	clear: func () {

		me.track_ID[0] = 0;
		me.track_ID[1] = 0;
		me.track_ID[2] = 0;
		me.init_flag = 0;


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

	set_id: func (value) {

	if (value == 0) {me.stop(); return;}
	if ((value > 17) or (value < 11)) {return;} # we can only enter IDs in the explicit table
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
		
		var current_error = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/angle-deg");
		SpaceShuttle.update_orb_sv(1000.0, 1000.0, me.filter_quality * current_error);
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

new: func (designation, pointing_vec) {
 	var s = { parents: [star_entry] };
	s.designation = designation;
	s.pointing_vec = pointing_vec;	
	return s;
	},
};

var star1 = star_entry.new("Shedir", [-0.007, -0.5490, 0.8357]);
append(coas_star_table, star1);

var star2 = star_entry.new("Mirphak", [0.4186, -0.4866, 0.7667]);
append(coas_star_table, star2);

var star3 = star_entry.new("Mizar", [-0.0988, 0.56751, 0.8174]);
append(coas_star_table, star3);

var star4 = star_entry.new("Arcturus", [-0.37197, 0.8687, 0.32703]);
append(coas_star_table, star4);

var star5 = star_entry.new("Betelgeuse", [0.9703, -0.20406, 0.12928]);
append(coas_star_table, star5);

var star6 = star_entry.new("Procyon", [0.9575, 0.0084, -0.2883]);
append(coas_star_table, star6);
 
var star7 = star_entry.new("Spica", [-0.1825, 0.9632, -0.1968]);
append(coas_star_table, star7);



