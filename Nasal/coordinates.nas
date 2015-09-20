

# coordinate transformation routines for the Space Shuttle
# Thorsten Renk 2015

var tracking_loop_flag = 0;

var trackingCoord = geo.Coord.new() ;


var timeObj = {
	new: func(day, hour, min, sec) {
	        var t = { parents: [timeObj] };
		t.day = day;
		t.hour = hour;
		t.min = min;
		t.sec = sec;
	        return t;
	},
	#subtract: func(t2) {
	#	var t.sec = t.sec - t2.sec;
	#	if (t.sec < 0) {t.sec = 60 - t.sec; t.min = t.min -1;}	
	#},
};


var update_LVLH_to_ECI = func {

var shuttleWCoord = geo.aircraft_position() ;
var shuttleCoord = geo.Coord.new() ;

var x = getprop("/fdm/jsbsim/position/eci-x-ft") * 0.3048;
var y = getprop("/fdm/jsbsim/position/eci-y-ft") * 0.3048;
var z = getprop("/fdm/jsbsim/position/eci-z-ft") * 0.3048;

shuttleCoord.set_xyz(x,y,z);

var D_lon = shuttleWCoord.lon() - shuttleCoord.lon();

#print("D_lon: ", D_lon);
setprop("/fdm/jsbsim/systems/pointing/inertial/delta-lon-rad", -D_lon * math.pi/180.0);

}

######################################
# general helper function to get pitch 
# and yaw given a vector
######################################


var get_pitch_yaw = func (vec) {

var norm = math.sqrt(vec[0] * vec[0] + vec[1] * vec[1] + vec[2]* vec[2]);

vec[0] = vec[0]/norm;
vec[1] = vec[1]/norm;
vec[2] = vec[2]/norm;

var pitch = math.asin(vec[2]);

var norm2 = math.sqrt(vec[0] * vec[0] + vec[1] * vec[1]);
var yaw_pos = math.acos(vec[0]/norm2);

var yaw = yaw_pos;

if (vec[1] < 0.0) {yaw = math.pi - yaw_pos;}

#print("p: ", pitch * 180/math.pi, "y: ", yaw * 180/math.pi);

return [pitch, yaw];

}

######################################
# creation of an inertial maneuver target
######################################

var create_mnvr_vector = func {


var pitch = getprop("/fdm/jsbsim/systems/ap/ops201/mnvr-pitch");
var yaw = getprop("/fdm/jsbsim/systems/ap/ops201/mnvr-yaw");
var roll = getprop("/fdm/jsbsim/systems/ap/ops201/mnvr-roll");

var vec = [1.0, 0.0, 0.0];
var inertial_vec = SpaceShuttle.orientTaitBryan (vec, yaw, pitch, roll);

setprop("/fdm/jsbsim/systems/ap/track/target-vector[0]", inertial_vec[0]);
setprop("/fdm/jsbsim/systems/ap/track/target-vector[1]", inertial_vec[1]);
setprop("/fdm/jsbsim/systems/ap/track/target-vector[2]", inertial_vec[2]);

vec = [0.0, 0.0, 1.0];
inertial_vec = SpaceShuttle.orientTaitBryan (vec, yaw, pitch, roll);

setprop("/fdm/jsbsim/systems/ap/track/target-sec[0]", inertial_vec[0]);
setprop("/fdm/jsbsim/systems/ap/track/target-sec[1]", inertial_vec[1]);
setprop("/fdm/jsbsim/systems/ap/track/target-sec[2]", inertial_vec[2]);


}

######################################
# tracking preparation calculations
######################################

var create_trk_vector = func {

var lat = getprop("/fdm/jsbsim/systems/ap/ops201/trk-lat");
var lon = getprop("/fdm/jsbsim/systems/ap/ops201/trk-lon");
var alt = getprop("/fdm/jsbsim/systems/ap/ops201/trk-alt");

var target_id = getprop("/fdm/jsbsim/systems/ap/ops201/tgt-id");

if (target_id == 2) # we track the center of Earth, omicron zero point is celestial north pole
	{
	
	settimer(func {tracking_loop_flag = 1; tracking_loop_earth();}, 0.2);

	setprop("/fdm/jsbsim/systems/ap/track/target-sec[0]", 0);
	setprop("/fdm/jsbsim/systems/ap/track/target-sec[1]", 0);
	setprop("/fdm/jsbsim/systems/ap/track/target-sec[2]", 1);
	}
if (target_id == 3) # we track an earth-relative target specified by items 11 to 13
	{
	var lat =  getprop("/fdm/jsbsim/systems/ap/ops201/trk-lat");
 	var lon =  getprop("/fdm/jsbsim/systems/ap/ops201/trk-lon");
	var alt =  getprop("/fdm/jsbsim/systems/ap/ops201/trk-alt");

	trackingCoord.set_latlon(lat, lon, alt * 0.3048);
	
	settimer(func {tracking_loop_flag = 1; tracking_loop_earth_tgt();}, 0.2);

	setprop("/fdm/jsbsim/systems/ap/track/target-sec[0]", 0);
	setprop("/fdm/jsbsim/systems/ap/track/target-sec[1]", 0);
	setprop("/fdm/jsbsim/systems/ap/track/target-sec[2]", 1);
	}
if (target_id == 4) # we track the Sun, omicron zero point is the celestial north pole
	{
	settimer(func {tracking_loop_flag = 1; tracking_loop_sun();}, 0.2);

	setprop("/fdm/jsbsim/systems/ap/track/target-sec[0]", 0);
	setprop("/fdm/jsbsim/systems/ap/track/target-sec[1]", 0);
	setprop("/fdm/jsbsim/systems/ap/track/target-sec[2]", 1);

	}

}

######################################
# OMS burn preparation computations
######################################

var create_oms_burn_vector = func {

var dvx = getprop("/fdm/jsbsim/systems/ap/oms-plan/dvx");
var dvy = getprop("/fdm/jsbsim/systems/ap/oms-plan/dvy");
var dvz = getprop("/fdm/jsbsim/systems/ap/oms-plan/dvz");



var dvtot = math.sqrt(dvx*dvx + dvy*dvy + dvz * dvz);

var weight_lb = getprop("/fdm/jsbsim/systems/ap/oms-plan/weight");

# need to change that as soon as we can do single engine burns
var thrust_lb = 12000.0;

var acceleration = thrust_lb/weight_lb;

var burn_time_s = dvtot/(acceleration * 32.17405);


var seconds = math.mod(int(burn_time_s), 60);
var minutes = int (burn_time_s/60.0);

#print(burn_time_s);
#print(minutes, " ", seconds);

var burn_time_string = minutes~":"~seconds;


setprop("/fdm/jsbsim/systems/ap/oms-plan/dvtot", dvtot);
setprop("/fdm/jsbsim/systems/ap/oms-plan/tgo-string", burn_time_string);

var tx = dvx/dvtot;
var ty = dvy/dvtot;
var tz = dvz/dvtot;

settimer(func {tracking_loop_flag = 1; oms_burn_loop(tx, ty, tz);}, 0.2);


}

######################################
# loop to track the center of Earth
######################################

var tracking_loop_earth = func {

if (tracking_loop_flag == 0) {return;}

print("Tracking..");

setprop("/fdm/jsbsim/systems/ap/track/target-vector[0]", -getprop("/fdm/jsbsim/systems/pointing/inertial/radial[0]"));
setprop("/fdm/jsbsim/systems/ap/track/target-vector[1]", -getprop("/fdm/jsbsim/systems/pointing/inertial/radial[1]"));
setprop("/fdm/jsbsim/systems/ap/track/target-vector[2]", -getprop("/fdm/jsbsim/systems/pointing/inertial/radial[2]"));


settimer(tracking_loop_earth, 0.0);
}

######################################
# loop to track an Earth-relative target
######################################

var tracking_loop_earth_tgt = func {

if (tracking_loop_flag == 0) {return;}

print("Tracking..");

# move the tracking coords to the inertial system

var shuttleWCoord = geo.aircraft_position() ;
var shuttleCoord = geo.Coord.new() ;

var x = getprop("/fdm/jsbsim/position/eci-x-ft") * 0.3048;
var y = getprop("/fdm/jsbsim/position/eci-y-ft") * 0.3048;
var z = getprop("/fdm/jsbsim/position/eci-z-ft") * 0.3048;

shuttleCoord.set_xyz(x,y,z);

var D_lon = shuttleWCoord.lon() - shuttleCoord.lon();

var trackCoord_tmp = geo.Coord.new();
trackCoord_tmp.set_xyz(trackingCoord.x(), trackingCoord.y(), trackingCoord.z());

trackCoord_tmp.set_lon(trackCoord_tmp.lon() + D_lon);

# the tracking vector is now a normalized coordinate difference

var track_x = trackCoord_tmp.x();
var track_y = trackCoord_tmp.y();
var track_z = trackCoord_tmp.z();

var track_vector = [track_x - x, track_y - y, track_z - z ];

track_norm = math.sqrt(track_vector[0] * track_vector[0] + track_vector[1] * track_vector[1] + track_vector[2] * track_vector[2]);

setprop("/fdm/jsbsim/systems/ap/track/target-vector[0]", track_vector[0]/track_norm);
setprop("/fdm/jsbsim/systems/ap/track/target-vector[1]", track_vector[1]/track_norm );
setprop("/fdm/jsbsim/systems/ap/track/target-vector[2]", track_vector[2]/track_norm );

settimer(tracking_loop_earth_tgt, 0.0);
}

######################################
# loop to track the sun
######################################

var tracking_loop_sun = func {

if (tracking_loop_flag == 0) {return;}

print("Tracking..");

setprop("/fdm/jsbsim/systems/ap/track/target-vector[0]", getprop("/fdm/jsbsim/systems/pointing/inertial/sun[0]"));
setprop("/fdm/jsbsim/systems/ap/track/target-vector[1]", getprop("/fdm/jsbsim/systems/pointing/inertial/sun[1]"));
setprop("/fdm/jsbsim/systems/ap/track/target-vector[2]", getprop("/fdm/jsbsim/systems/pointing/inertial/sun[2]"));


settimer(tracking_loop_sun, 0.0);
}

######################################
# loop to track the OMS burn attitude
######################################

var oms_burn_loop  = func (tx, ty, tz) {

if (tracking_loop_flag == 0) {return;}

print("Tracking..");

var prograde = [getprop("/fdm/jsbsim/systems/pointing/inertial/prograde[0]"),getprop("/fdm/jsbsim/systems/pointing/inertial/prograde[1]"), getprop("/fdm/jsbsim/systems/pointing/inertial/prograde[2]")];

var radial = [getprop("/fdm/jsbsim/systems/pointing/inertial/radial[0]"),getprop("/fdm/jsbsim/systems/pointing/inertial/radial[1]"), getprop("/fdm/jsbsim/systems/pointing/inertial/radial[2]")];

#var normal = [getprop("/fdm/jsbsim/systems/pointing/inertial/normal[0]"),getprop("/fdm/jsbsim/systems/pointing/inertial/normal[1]"), getprop("/fdm/jsbsim/systems/pointing/inertial/normal[2]")];

# prograde and radial don't really form an ON system for eccentric orbits, so we correct that
# we need exact prograde orientation so we tilt the radial base vector for pointing

var corr_angle = prograde[0] * radial[0] + prograde[1] * radial[1] + prograde[2] * radial[2];
#print("Cos_angle before: ", corr_angle);

radial[0] = radial[0] - prograde[0] * corr_angle;
radial[1] = radial[1] - prograde[1] * corr_angle;
radial[2] = radial[2] - prograde[2] * corr_angle;

var radial_norm = math.sqrt(radial[0] * radial[0] + radial[1] * radial[1] + radial[2] * radial[2]);
radial[0] = radial[0]/radial_norm;
radial[1] = radial[1]/radial_norm;
radial[2] = radial[2]/radial_norm;

#var corr_angle = prograde[0] * radial[0] + prograde[1] * radial[1] + prograde[2] * radial[2];
#print("Cos_angle after: ", corr_angle);

var normal = [0,0,0];

normal[0] = prograde[1] * radial[2] - prograde[2] * radial[1];
normal[1] = prograde[2] * radial[0] - prograde[0] * radial[2];
normal[2] = prograde[0] * radial[1] - prograde[1] * radial[0];

var tgt0 = tx * prograde[0] + ty * normal[0] + tz * radial[0];
var tgt1 = tx * prograde[1] + ty * normal[1] + tz * radial[1];
var tgt2 = tx * prograde[2] + ty * normal[2] + tz * radial[2];

setprop("/fdm/jsbsim/systems/ap/track/target-vector[0]", tgt0);
setprop("/fdm/jsbsim/systems/ap/track/target-vector[1]", tgt1);
setprop("/fdm/jsbsim/systems/ap/track/target-vector[2]", tgt2);

var orientation = get_pitch_yaw([tgt0, tgt1, tgt2]);

var sec = SpaceShuttle.orientTaitBryan([-radial[0], -radial[1], -radial[2]], orientation[1], orientation[0],0.0);

setprop("/fdm/jsbsim/systems/ap/track/target-sec[0]", sec[0]);
setprop("/fdm/jsbsim/systems/ap/track/target-sec[1]", sec[1]);
setprop("/fdm/jsbsim/systems/ap/track/target-sec[2]", sec[2]);

settimer(func {oms_burn_loop(tx, ty, tz, 0.0);}, 0.0);
}
