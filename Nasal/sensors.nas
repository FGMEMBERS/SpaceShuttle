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
	s.mode = 1;
	s.failure = "";
	s.status = "";
	s.shutter = "OP";
	s.manual = 0;
	s.operational = 1;
	s.threshold = 3;
	return s;
	},

	set_mode: func (mode) {
	if (me.operational == 0) {return;}
	me.mode = mode;

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

	if ((me.mode == 2) and (getprop("/fdm/jsbsim/systems/rendezvous/rel-nav-enable") == 0))
		{
		me.status = "NO TARGET";
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
		{
		me.shutter = "CL";
		}
	else
		{
		me.shutter = "OP";
		}
	
	},
};


var star_tracker_y = star_tracker.new("-Y", [0, -1, 0]);
var star_tracker_z = star_tracker.new("-Z", [0, 0, 1]);

append(star_tracker_array, star_tracker_y);
append(star_tracker_array, star_tracker_z);

setlistener("/fdm/jsbsim/systems/failures/sensors/star-tracker-Y-condition", func (n) { star_tracker_array[0].fail(n.getValue());});
setlistener("/fdm/jsbsim/systems/failures/sensors/star-tracker-Z-condition", func (n) { star_tracker_array[1].fail(n.getValue());});
