

# coordinate transformation routines for the Space Shuttle
# Thorsten Renk 2015

var tracking_loop_flag = 0;

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

}

var tracking_loop_earth = func {

if (tracking_loop_flag == 0) {return;}

print("Tracking..");

setprop("/fdm/jsbsim/systems/ap/track/target-vector[0]", -getprop("/fdm/jsbsim/systems/pointing/inertial/radial[0]"));
setprop("/fdm/jsbsim/systems/ap/track/target-vector[1]", -getprop("/fdm/jsbsim/systems/pointing/inertial/radial[1]"));
setprop("/fdm/jsbsim/systems/ap/track/target-vector[2]", -getprop("/fdm/jsbsim/systems/pointing/inertial/radial[2]"));


settimer(tracking_loop_earth, 0.0);
}
