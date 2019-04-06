

# coordinate transformation routines and pointing guidance vectors 
# for the Space Shuttle orbital maneuvering
# Thorsten Renk 2015-2017

var tracking_loop_flag = 0;

var trackingCoord = geo.Coord.new() ;

##################################################
# general helper functions for scalar computations
##################################################

var clamp = func (x, a, b) {

if (x<a) {return a;}
else if (x > b) {return b;}
else {return x;}

}

var smoothstep = func (a,b,x) {

x = clamp((x - a)/(b - a), 0.0, 1.0); 

return x*x*(3.0 - 2.0*x);
}

##################################################
# general helper functions for vector computations
##################################################

var dot_product = func (v1, v2) {

return v1[0] * v2[0] + v1[1] * v2[1] + v1[2] * v2[2];
}

var dot_product_2d = func (v1, v2) {

return v1[0] * v2[0] + v1[1] * v2[1];
}

var scalar_product = func (s, v) {

var outvec = [0,0,0];

outvec[0] = s*v[0];
outvec[1] = s*v[1];
outvec[2] = s*v[2];

return outvec;
}

var add_vector = func (v1, v2) {

var outvec = [0,0,0];

outvec[0] = v1[0] + v2[0];
outvec[1] = v1[1] + v2[1];
outvec[2] = v1[2] + v2[2];

return outvec;
}

var subtract_vector = func (v1, v2) {

var outvec = [0,0,0];

outvec[0] = v1[0] - v2[0];
outvec[1] = v1[1] - v2[1];
outvec[2] = v1[2] - v2[2];

return outvec;
}


var norm = func (v) {

return math.sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);

}

var normalize = func (v) {

return scalar_product(1./norm(v), v);

}

var cross_product = func (v1, v2) {

var outvec = [0,0,0];

outvec[0] = v1[1] * v2[2] - v1[2] * v2[1];
outvec[1] = v1[2] * v2[0] - v1[0] * v2[2];
outvec[2] = v1[0] * v2[1] - v1[1] * v2[0];

return outvec;
}


var orthonormalize = func (v1, v2) {

var v1_norm = norm(v1);
var v2_norm = norm(v2);

var v1n = scalar_product(1./v1_norm, v1);
var v2n = scalar_product(1./v2_norm, v2);

var angle = dot_product(v1n, v2n);

var diff = scalar_product(-angle, v1n);

var outvec = add_vector(v2n, diff);

outvec = scalar_product(1.0/norm(outvec) , outvec);


return outvec;
}

var distance_between = func (v1, v2) {

var v3 = subtract_vector(v1, v2);

return norm(v3);

}


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


##################################################
# general helper functions spherical trigonometry
##################################################

var sgeo_ERAD = 6378138.12;		
var sgeo_D2R = 0.0174532;
var sgeo_R2D = 57.29578;


var sgeo_move_circle = func (course, dist, pos) {

course *= sgeo_D2R;
dist /= sgeo_ERAD;
		
if (dist < 0.0) 
	{
	dist = abs(dist);
	course = course - math.pi;		
	}

var lat1 = sgeo_D2R * pos.lat();
var lon1 = sgeo_D2R * pos.lon();

var lat2 =  math.asin(math.sin(lat1) * math.cos(dist) + math.cos(lat1) * math.sin(dist) * math.cos(course));

var lon2 = lon1 + math.atan2(math.sin(course) * math.sin(dist) * math.cos(lat1), math.cos(dist)- math.sin(lat1) * math.sin(lat2));


lat2 *= sgeo_R2D;
lon2 *= sgeo_R2D;

lon2 = geo.normdeg180(lon2);

pos.set_latlon(lat2, lon2);

}


var sgeo_forward_azimuth = func (pos1, pos2) {

var delta_lon = sgeo_D2R * (pos2.lon() - pos1.lon());

var lat1 = sgeo_D2R * pos1.lat();
var lat2 = sgeo_D2R * pos2.lat();

var bearing = math.atan2(math.sin(delta_lon) * math.cos(lat2), math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(delta_lon));

bearing *= sgeo_R2D;

return geo.normdeg(bearing);
}


var sgeo_crosstrack = func (course1, course2, dist) {

course1 *= sgeo_D2R;
course2 *= sgeo_D2R;

dist /= sgeo_ERAD;

return math.asin( math.sin(dist) * math.sin(course1 - course2)) * sgeo_ERAD;
} 





##################################################
# general helper functions for time
##################################################


var get_MET = func {

return getprop("/sim/time/elapsed-sec") + getprop("/fdm/jsbsim/systems/timer/delta-MET");
}

var seconds_to_stringMS = func (time) {

var seconds = math.mod(int(time), 60);
var minutes = int (time/60.0);

if (seconds<10) {seconds = "0"~seconds;}

return minutes~":"~seconds;
}


var seconds_to_stringHMS = func (time) {

var int_time = int(time);


var hours = int(int_time/3600);
int_time = int_time - hours * 3600;

if (hours < 10) {hours = "0"~hours;}

var minutes = int(int_time/60);
int_time = int_time - minutes * 60;

if (minutes < 10) {minutes = "0"~minutes;}

var seconds = int_time;
if (seconds < 10) {seconds = "0"~seconds;}


return hours~":"~minutes~":"~seconds;
}


var seconds_to_stringDHMS = func (time) {

var int_time = int(time);

var days = int(time / 86400);
int_time = int_time - days * 86400;

if (days < 10) {days = "00"~days;} else {days = "0"~days;}

var hours = int(int_time/3600);
int_time = int_time - hours * 3600;

if (hours < 10) {hours = "0"~hours;}

var minutes = int(int_time/60);
int_time = int_time - minutes * 60;

if (minutes < 10) {minutes = "0"~minutes;}

var seconds = int_time;
if (seconds < 10) {seconds = "0"~seconds;}


return days~"/"~hours~":"~minutes~":"~seconds;
}


var seconds_to_timer_string = func (time) {

var int_time = int(time);

var days = int(time / 86400);
int_time = int_time - days * 86400;

if (days < 10) {days = "0"~days;}

var hours = int(int_time/3600);
int_time = int_time - hours * 3600;

if (hours < 10) {hours = "0"~hours;}

var minutes = int(int_time/60);
int_time = int_time - minutes * 60;

if (minutes < 10) {minutes = "0"~minutes;}

var seconds = int_time;
if (seconds < 10) {seconds = "0"~seconds;}


return days~":"~hours~":"~minutes~":"~seconds;
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


# this should not be necessary, but the numerics bitches
var pitch = 0.0;
if (math.abs(vec[2]) > 0.001) {pitch = math.asin(vec[2]);}

var norm2 = math.sqrt(vec[0] * vec[0] + vec[1] * vec[1]);

var yaw_pos = 0.0;

if (norm2 > 0.0)
	{
	var arg = vec[0]/norm2;
	arg = clamp(arg, -1.0, 1.0);
	yaw_pos = math.acos(arg);
	}

var yaw = yaw_pos;

if (vec[1] < 0.0) {yaw = 2.0 * math.pi - yaw_pos;}

#print("p: ", pitch * 180/math.pi, " y: ", yaw * 180/math.pi);

return [pitch, yaw];

}

######################################
# general helper function to get a 
# pointing vector 
# given azimuth and elevation
######################################


var get_vec_az_el = func (azimuth, elevation) {

var az_rad = azimuth / 180.0 * math.pi;
var el_rad = elevation / 180.0 * math.pi;

var x = math.cos(az_rad) * math.cos(el_rad);
var y = math.sin(az_rad) * math.cos(el_rad);
var z = math.sin(el_rad);

return [x,y,z];
}


######################################
# geoid function - returns latitude
# dependent Earth radius
######################################

var geoid_radius = func (lat) {

var a =  6378.1370; # equatorial radius
var b =  6356.7523; # polar radius

var cl = math.cos(lat * math.pi/180.0); 
var sl = math.sin(lat * math.pi/180.0); 

return 1000.0 * math.sqrt((math.pow(a*a*cl,2.0) + math.pow(b*b*sl,2.0) )/(math.pow(a *cl,2.0) + math.pow(b*sl,2.0) ));
}

######################################
# pointing vector coordinate 
# transformation
######################################

var vtransform_body_inertial = func (vec) {

# body axis vectors in inertial coords

var body_x = [getprop("/fdm/jsbsim/systems/pointing/inertial/body-x[0]"), getprop("/fdm/jsbsim/systems/pointing/inertial/body-x[1]"), getprop("/fdm/jsbsim/systems/pointing/inertial/body-x[2]")];

var body_y = [getprop("/fdm/jsbsim/systems/pointing/inertial/body-y[0]"), getprop("/fdm/jsbsim/systems/pointing/inertial/body-y[1]"), getprop("/fdm/jsbsim/systems/pointing/inertial/body-y[2]")];

var body_z = [getprop("/fdm/jsbsim/systems/pointing/inertial/body-z[0]"), getprop("/fdm/jsbsim/systems/pointing/inertial/body-z[1]"), getprop("/fdm/jsbsim/systems/pointing/inertial/body-z[2]")];

var vec1 = scalar_product(vec[0], body_x);
var vec2 = scalar_product(vec[1], body_y);
var vec3 = scalar_product(vec[2], body_z);

var outvec = add_vector(vec1, vec2);
outvec = add_vector (outvec, vec3);

return outvec;

}


var vtransform_world_fixed_inertial = func (vec) {

# FG world coords to sidereal fixed inertial coordinates

var s_ang = getprop("/fdm/jsbsim/systems/pointing/sidereal/sidereal-angle-rad");

var tmp1 = math.cos(s_ang) * vec[0] - math.sin(s_ang) * vec[1];
var tmp2 = math.sin(s_ang) * vec[0] + math.cos(s_ang) * vec[1];

vec[0] = tmp1;
vec[1] = tmp2;

return vec;
}

var vtransform_fixed_inertial_world = func (vec) {

#  sidereal fixed inertial coordinates to FG world coordinates

var s_ang = getprop("/fdm/jsbsim/systems/pointing/sidereal/sidereal-angle-rad");

# however, we need the angle for the beginning of the current FG session where the inertial system is fixed

var s_ang_corr = 2.0 * math.pi * getprop("/sim/time/elapsed-sec")/ 86400.0;
s_ang = s_ang - s_ang_corr;

var tmp1 = math.cos(s_ang) * vec[0] + math.sin(s_ang) * vec[1];
var tmp2 = -math.sin(s_ang) * vec[0] + math.cos(s_ang) * vec[1];

vec[0] = tmp1;
vec[1] = tmp2;

return vec;
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

vec = [0.0, 1.0, 0.0];
inertial_vec = SpaceShuttle.orientTaitBryan (vec, yaw, pitch, roll);

setprop("/fdm/jsbsim/systems/ap/track/target-trd[0]", inertial_vec[0]);
setprop("/fdm/jsbsim/systems/ap/track/target-trd[1]", inertial_vec[1]);
setprop("/fdm/jsbsim/systems/ap/track/target-trd[2]", inertial_vec[2]);

}


###########################################
# creation of inertial attitude hold target
##########################################

var create_rot_mnvr_vector = func {

# the target vectors are the current inertial attitude angles


var pitch = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/pitch-deg");
var yaw = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/yaw-deg");
var roll = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/roll-deg");

var vec = [1.0, 0.0, 0.0];

var body_vec_selection = getprop("/fdm/jsbsim/systems/ap/track/body-vector-selection");

if (body_vec_selection == 2)
	{
	vec = [-1.0, 0.0, 0.0];
	}
else if (body_vec_selection == 3)
	{
	vec = [0.0, 0.0, -1.0];
	}

var inertial_vec = SpaceShuttle.orientTaitBryan (vec, yaw, pitch, roll);

setprop("/fdm/jsbsim/systems/ap/track/target-vector[0]", inertial_vec[0]);
setprop("/fdm/jsbsim/systems/ap/track/target-vector[1]", inertial_vec[1]);
setprop("/fdm/jsbsim/systems/ap/track/target-vector[2]", inertial_vec[2]);

vec = [0.0, 0.0, 1.0];

if (body_vec_selection == 3)
	{
	vec = [-1.0, 0.0, 0.0];
	}



inertial_vec = SpaceShuttle.orientTaitBryan (vec, yaw, pitch, roll);

setprop("/fdm/jsbsim/systems/ap/track/target-sec[0]", inertial_vec[0]);
setprop("/fdm/jsbsim/systems/ap/track/target-sec[1]", inertial_vec[1]);
setprop("/fdm/jsbsim/systems/ap/track/target-sec[2]", inertial_vec[2]);


vec = [0.0, 1.0, 0.0];


inertial_vec = SpaceShuttle.orientTaitBryan (vec, yaw, pitch, roll);

setprop("/fdm/jsbsim/systems/ap/track/target-trd[0]", inertial_vec[0]);
setprop("/fdm/jsbsim/systems/ap/track/target-trd[1]", inertial_vec[1]);
setprop("/fdm/jsbsim/systems/ap/track/target-trd[2]", inertial_vec[2]);
}


######################################
# tracking preparation calculations
######################################

var convert_ra_dec_vector = func (ra, dec) {

var ra_rad = (ra -6.704)/12.0 * math.pi;
var dec_rad = dec/180.0 * math.pi;

var x = math.cos(dec_rad) * math.cos(ra_rad);
var y = math.cos(dec_rad) * math.sin(ra_rad);
var z = math.sin(dec_rad);

#print("Fixed vector: ", x, " ", y, " ", z);

# this is a fixed inertial vector, so we rotate to a pointing vector in JSBSim inertial

var vec = [x,y,z];

vtransform_fixed_inertial_world(vec); 



#print("JSBSim vector: ", vec[0], " ", vec[1], " ", vec[2]);

return vec;

}



var create_trk_vector = func {


var target_id = getprop("/fdm/jsbsim/systems/ap/ops201/tgt-id");

if (target_id == 1) # we track an orbiting vehicle, make omicron point the celestial north pole
	{
	#if (SpaceShuttle.proximity_manager.iss_model == 0) {return;}
	
	settimer(func {tracking_loop_flag = 1; tracking_loop_otgt();}, 0.2);

	setprop("/fdm/jsbsim/systems/ap/track/target-sec[0]", 0);
	setprop("/fdm/jsbsim/systems/ap/track/target-sec[1]", 0);
	setprop("/fdm/jsbsim/systems/ap/track/target-sec[2]", 1);
	}

else if (target_id == 2) # we track the center of Earth, omicron zero point is celestial north pole
	{
	
	settimer(func {tracking_loop_flag = 1; tracking_loop_earth();}, 0.2);

	setprop("/fdm/jsbsim/systems/ap/track/target-sec[0]", 0);
	setprop("/fdm/jsbsim/systems/ap/track/target-sec[1]", 0);
	setprop("/fdm/jsbsim/systems/ap/track/target-sec[2]", 1);
	}
else if (target_id == 3) # we track an earth-relative target specified by items 11 to 13
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
else if (target_id == 4) # we track the Sun, omicron zero point is the celestial north pole
	{
	settimer(func {tracking_loop_flag = 1; tracking_loop_sun();}, 0.2);

	setprop("/fdm/jsbsim/systems/ap/track/target-sec[0]", 0);
	setprop("/fdm/jsbsim/systems/ap/track/target-sec[1]", 0);
	setprop("/fdm/jsbsim/systems/ap/track/target-sec[2]", 1);

	}

else if ((target_id == 5) or (target_id > 10)) # we track a celestial target with right ascension and declination given
	{
	var ra = getprop("/fdm/jsbsim/systems/ap/ops201/trk-ra");
	var dec = getprop("/fdm/jsbsim/systems/ap/ops201/trk-dec");

	var vec = convert_ra_dec_vector(ra, dec);

	setprop("/fdm/jsbsim/systems/ap/track/target-vector[0]", vec[0]);
	setprop("/fdm/jsbsim/systems/ap/track/target-vector[1]", vec[1]);
	setprop("/fdm/jsbsim/systems/ap/track/target-vector[2]", vec[2]);

	var vec2 = [0,0,1];

	vec2 = orthonormalize(vec, vec2);

	setprop("/fdm/jsbsim/systems/ap/track/target-sec[0]", vec2[0]);
	setprop("/fdm/jsbsim/systems/ap/track/target-sec[1]", vec2[1]);
	setprop("/fdm/jsbsim/systems/ap/track/target-sec[2]", vec2[2]);
	}


}


######################################
# loop to track an orbital target
######################################

var tracking_loop_otgt = func {

if (tracking_loop_flag == 0) {return;}
if (SpaceShuttle.proximity_manager.iss_model == 0) 
	{
	SpaceShuttle.proximity_manager.provide_tracking();
	}
else

	{
	SpaceShuttle.iss_manager.request_tracking();
	}

settimer(tracking_loop_otgt, 1.0);
}

######################################
# loop to track the center of Earth
######################################

var tracking_loop_earth = func {

if (tracking_loop_flag == 0) {return;}

#print("Tracking..");

var radial = [-getprop("/fdm/jsbsim/systems/pointing/inertial/radial[0]"), -getprop("/fdm/jsbsim/systems/pointing/inertial/radial[1]"), -getprop("/fdm/jsbsim/systems/pointing/inertial/radial[2]")];

radial = normalize(radial); 

setprop("/fdm/jsbsim/systems/ap/track/target-vector[0]", radial[0]);
setprop("/fdm/jsbsim/systems/ap/track/target-vector[1]", radial[1]);
setprop("/fdm/jsbsim/systems/ap/track/target-vector[2]", radial[2]);

var body_vec_selection = getprop("/fdm/jsbsim/systems/ap/track/body-vector-selection");

var ref_vector = [];

if (body_vec_selection == 1)
	{
	ref_vec = [0.0, 0.0, 1.0];
	}
else if (body_vec_selection == 2)
	{
	ref_vec = [0.0, 0.0, -1.0];
	}
else if (body_vec_selection == 3)
	{
	ref_vec = [0.0, 0.0, 1.0];
	}

var second = orthonormalize(radial, [0.0, 0.0, 1.0]);

setprop("/fdm/jsbsim/systems/ap/track/target-sec[0]", second[0]);
setprop("/fdm/jsbsim/systems/ap/track/target-sec[1]", second[1]);
setprop("/fdm/jsbsim/systems/ap/track/target-sec[2]", second[2]);

var third = cross_product(radial, second);

setprop("/fdm/jsbsim/systems/ap/track/target-trd[0]", third[0]);
setprop("/fdm/jsbsim/systems/ap/track/target-trd[1]", third[1]);
setprop("/fdm/jsbsim/systems/ap/track/target-trd[2]", third[2]);



settimer(tracking_loop_earth, 0.0);
}

######################################
# loop to track an Earth-relative target
######################################

var tracking_loop_earth_tgt = func {

if (tracking_loop_flag == 0) {return;}

#print("Tracking..");

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

track_vector[0] = track_vector[0]/track_norm;
track_vector[1] = track_vector[1]/track_norm;
track_vector[2] = track_vector[2]/track_norm;

setprop("/fdm/jsbsim/systems/ap/track/target-vector[0]", track_vector[0]);
setprop("/fdm/jsbsim/systems/ap/track/target-vector[1]", track_vector[1]);
setprop("/fdm/jsbsim/systems/ap/track/target-vector[2]", track_vector[2]);

settimer(tracking_loop_earth_tgt, 0.0);
}

######################################
# loop to track the sun
######################################

var tracking_loop_sun = func {

if (tracking_loop_flag == 0) {return;}

#print("Tracking..");

var track_vec = [getprop("/fdm/jsbsim/systems/pointing/inertial/sun[0]"), getprop("/fdm/jsbsim/systems/pointing/inertial/sun[1]"), getprop("/fdm/jsbsim/systems/pointing/inertial/sun[2]")];

setprop("/fdm/jsbsim/systems/ap/track/target-vector[0]", track_vec[0]);
setprop("/fdm/jsbsim/systems/ap/track/target-vector[1]", track_vec[1]);
setprop("/fdm/jsbsim/systems/ap/track/target-vector[2]", track_vec[2]);



var body_vec_selection = getprop("/fdm/jsbsim/systems/ap/track/body-vector-selection");

var ref_vector = [];

if (body_vec_selection == 1)
	{
	ref_vec = [0.0, 0.0, 1.0];
	}
else if (body_vec_selection == 2)
	{
	ref_vec = [0.0, 0.0, -1.0];
	}
else if (body_vec_selection == 3)
	{
	ref_vec = [0.0, 0.0, 1.0];
	}

var second = orthonormalize(track_vec, [0.0, 0.0, 1.0]);

setprop("/fdm/jsbsim/systems/ap/track/target-sec[0]", second[0]);
setprop("/fdm/jsbsim/systems/ap/track/target-sec[1]", second[1]);
setprop("/fdm/jsbsim/systems/ap/track/target-sec[2]", second[2]);

var third = cross_product(track_vec, second);

setprop("/fdm/jsbsim/systems/ap/track/target-trd[0]", third[0]);
setprop("/fdm/jsbsim/systems/ap/track/target-trd[1]", third[1]);
setprop("/fdm/jsbsim/systems/ap/track/target-trd[2]", third[2]);

settimer(tracking_loop_sun, 0.0);
}





###################
# some diagnostics


var check_tgt_vecs = func {


var t1 = [getprop("/fdm/jsbsim/systems/ap/track/target-vector[0]"), getprop("/fdm/jsbsim/systems/ap/track/target-vector[1]"), getprop("/fdm/jsbsim/systems/ap/track/target-vector[2]")];

var t2 = [getprop("/fdm/jsbsim/systems/ap/track/target-sec[0]"), getprop("/fdm/jsbsim/systems/ap/track/target-sec[1]"), getprop("/fdm/jsbsim/systems/ap/track/target-sec[2]")];

var t3 = [getprop("/fdm/jsbsim/systems/ap/track/target-trd[0]"), getprop("/fdm/jsbsim/systems/ap/track/target-trd[1]"), getprop("/fdm/jsbsim/systems/ap/track/target-trd[2]")];

print("T1: ", t1[0], " ", t1[1], " ", t1[2], " ", norm(t1));
print("T2: ", t2[0], " ", t2[1], " ", t2[2], " ", norm(t2));
print("T3: ", t3[0], " ", t3[1], " ", t3[2], " ", norm(t3));
print(" ");
print("angle T1 T2: ", dot_product(t1, t2));
print("angle T1 T3: ", dot_product(t1, t3));
print("angle T2 T3: ", dot_product(t2, t3));


}


