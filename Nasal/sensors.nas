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
		return;
		}
	# check whether REL NAV forwards targeting information if we request target tracking

	if ((me.mode == 2) and ((me.target_available == 0) or (getprop("/fdm/jsbsim/systems/rendezvous/rel-nav-enable") == 0)))
		{
		me.status = "NO TARGET";
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

		if (pointing_diff < 0.96)
			{
			#print ("Star tracker - new FOV");

			var p_star = 0.3;

			if (rand() < p_star)
				{
				me.star_in_view = 1;
				me.star_ID = int (10.0 + rand() * 100.0);
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
