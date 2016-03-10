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
	s.mode = 1;
	s.failure = "";
	s.status = "";
	s.shutter = "OP";
	s.operational = 1;
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

	if ((rate_q > 0.1) or (rate_p > 0.1) or (rate_r > 0.1))
		{
		me.status = "HI RATE";
		return;
		}
	
	},
};


var star_tracker_y = star_tracker.new("-Y", [0, -1, 0]);
var star_tracker_z = star_tracker.new("-Z", [0, 0, 1]);

append(star_tracker_array, star_tracker_y);
append(star_tracker_array, star_tracker_z);

setlistener("/fdm/jsbsim/systems/failures/sensors/star-tracker-Y-condition", func (n) { star_tracker_array[0].fail(n.getValue());});
setlistener("/fdm/jsbsim/systems/failures/sensors/star-tracker-Z-condition", func (n) { star_tracker_array[1].fail(n.getValue());});
