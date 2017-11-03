

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

print("Fixed vector: ", x, " ", y, " ", z);

# this is a fixed inertial vector, so we rotate to a pointing vector in JSBSim inertial

var vec = [x,y,z];

vtransform_fixed_inertial_world(vec); 



print("JSBSim vector: ", vec[0], " ", vec[1], " ", vec[2]);

return vec;

}



var create_trk_vector = func {


var target_id = getprop("/fdm/jsbsim/systems/ap/ops201/tgt-id");

if (target_id == 2) # we track the center of Earth, omicron zero point is celestial north pole
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
# OMS burn preparation computations
######################################

var oms_burn_target = {tig: 0.0, apoapsis:0.0, periapsis: 0.0, rei: 0.0, mark: 0};

var create_oms_burn_vector = func {

var dvx = getprop("/fdm/jsbsim/systems/ap/oms-plan/dvx");
var dvy = getprop("/fdm/jsbsim/systems/ap/oms-plan/dvy");
var dvz = getprop("/fdm/jsbsim/systems/ap/oms-plan/dvz");



var dvtot = math.sqrt(dvx*dvx + dvy*dvy + dvz * dvz);

var weight_lb = getprop("/fdm/jsbsim/systems/ap/oms-plan/weight");

if (getprop("/fdm/jsbsim/systems/navigation/state-vector/use-realistic-sv") == 0)
	{weight_lb = getprop("/fdm/jsbsim/inertia/weight-lbs");}

var burn_mode = getprop("/fdm/jsbsim/systems/ap/oms-plan/burn-mode");

var thrust_lb = 12174.0;


if ((burn_mode == 2) or (burn_mode == 3))
	{
	thrust_lb = 0.5 * thrust_lb;
	}
else if (burn_mode == 4)
	{
	thrust_lb = 3480.0;
	}

var acceleration = thrust_lb/weight_lb;

var burn_time_s = dvtot/(acceleration * 32.17405);
burn_time_s *= 0.99; # better to err on the short side

var seconds = math.mod(int(burn_time_s), 60);
var minutes = int (burn_time_s/60.0);

if (seconds<10) {seconds = "0"~seconds;}

var burn_time_string = minutes~":"~seconds;


setprop("/fdm/jsbsim/systems/ap/oms-plan/dvtot", dvtot);
setprop("/fdm/jsbsim/systems/ap/oms-plan/tgo-string", burn_time_string);
setprop("/fdm/jsbsim/systems/ap/oms-plan/tgo-s", int(burn_time_s));

var tx = dvx/dvtot;
var ty = dvy/dvtot;
var tz = dvz/dvtot;

oms_burn_target.tx = tx;
oms_burn_target.ty = ty;
oms_burn_target.tz = tz;
oms_burn_target.dvtot = dvtot;


var MET = getprop("/sim/time/elapsed-sec") + getprop("/fdm/jsbsim/systems/timer/delta-MET");
var tig = getprop("/fdm/jsbsim/systems/ap/oms-plan/tig");

oms_burn_target.tig = tig;

if (tig > MET) # the burn is in the future, need to extrapolate state vector
	{
	setprop("/fdm/jsbsim/systems/ap/oms-plan/apoapsis-nm", 0.0);
	setprop("/fdm/jsbsim/systems/ap/oms-plan/periapsis-nm", 0.0);
	oms_burn_target.time_to_burn = tig - MET;
	oms_future_burn_start(tig - MET);
	return;
	}


settimer(func {tracking_loop_flag = 1; oms_burn_loop(tx, ty, tz, dvtot);}, 0.2);


}


var oms_future_burn_start = func (time) {

var x = getprop("/fdm/jsbsim/position/eci-x-ft") * 0.3048;
var y = getprop("/fdm/jsbsim/position/eci-y-ft") * 0.3048;
var z = getprop("/fdm/jsbsim/position/eci-z-ft") * 0.3048;

var vx = getprop("/fdm/jsbsim/velocities/eci-x-fps") * 0.3048;
var vy = getprop("/fdm/jsbsim/velocities/eci-y-fps") * 0.3048;
var vz = getprop("/fdm/jsbsim/velocities/eci-z-fps") * 0.3048;

var state_x = [x,y,z];
var state_v = [vx, vy, vz];

setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-flag", 0);

SpaceShuttle.state_extrapolate (state_x, state_v, 0.0, time);


oms_future_burn_hold();
}

# need to wait till we have the trajectory predicted

var oms_future_burn_hold = func {

var flag = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-flag");

print("Computing trajectory prediction...");

if (flag == 1)
	{
	oms_future_burn_finished();
	return;
	}

settimer(oms_future_burn_hold, 1.0);
}


var oms_future_burn_finished = func {

# retrieve the state vector at ignition time

var x = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-x")/0.3048;
var y = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-y")/0.3048;
var z = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-z")/0.3048;

var vx = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-vx")/0.3048;
var vy = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-vy")/0.3048;
var vz = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-vz")/0.3048;

var r = [x,y,z];
var v = [vx, vy, vz];


#print("Extrapolated state pos: ", x, " ", y, " ", z); 
#print("Extrapolated state vel: ", vx, " ", vy, " ", vz); 

# construct prograde/radial/normal coordinate system for this state vector


var prograde = [vx, vy, vz];
var radial = [x, y, z];

prograde = normalize(prograde);
radial = normalize(radial);

radial = orthonormalize(prograde, radial);

var normal = cross_product (prograde, radial);



# now get the inertial velocity change components for the burn taget

var tgt0 = oms_burn_target.tx * prograde[0] + oms_burn_target.ty * normal[0] + oms_burn_target.tz * radial[0];
var tgt1 = oms_burn_target.tx * prograde[1] + oms_burn_target.ty * normal[1] + oms_burn_target.tz * radial[1];
var tgt2 = oms_burn_target.tx * prograde[2] + oms_burn_target.ty * normal[2] + oms_burn_target.tz * radial[2];

#print("Target:");
#print(tgt0, " ", tgt1, " ", tgt2);

# add the burn target velocity components to the state vector


var dv = scalar_product(oms_burn_target.dvtot, [tgt0, tgt1, tgt2]);

v = add_vector(v, dv);

# compute apoapsis and periapsis

var apses = SpaceShuttle.compute_apses(r,v);
var sea_level_radius_ft = getprop("/fdm/jsbsim/ic/sea-level-radius-ft");

var periapsis_nm = (apses[0] - sea_level_radius_ft)/ 6076.11548556;
var apoapsis_nm = (apses[1] - sea_level_radius_ft)/ 6076.11548556;

print("TA: ", apoapsis_nm, "TP: ", periapsis_nm); 

oms_burn_target.apoapsis = apoapsis_nm;
oms_burn_target.periapsis = periapsis_nm;

var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");

if ((major_mode == 301) or (major_mode == 302) or (major_mode == 303))
	{
	#print("Extrapolated state reduced vel: ", v[0], " ", v[1], " ", v[2]); 
	var rei = SpaceShuttle.get_rei(r,v);

	# correct REI for empirics and time to interface

	var rei_correction = 375.0 + 3.6556 * periapsis_nm;
	rei_correction = rei_correction - oms_burn_target.time_to_burn * norm([vx,vy,vz]) * 0.000164578833693;
	# also Earth rotates while we coast, this is very naive

	var lat = getprop("/position/latitude-deg");
	var rot_correction =  math.cos(math.pi * lat/180.0) * 465.0 * oms_burn_target.time_to_burn * 0.000539956803456;

	oms_burn_target.rei = rei + rei_correction + rot_correction;
	}

# start the tracking loop to maneuver into burn attitude

settimer(func {tracking_loop_flag = 1; oms_burn_loop(oms_burn_target.tx, oms_burn_target.ty, oms_burn_target.tz, oms_burn_target.dvtot);}, 0.2); 
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

######################################
# loop to track the OMS burn attitude
######################################

var oms_burn_loop  = func (tx, ty, tz, dvtot) {

if (tracking_loop_flag == 0) {return;}

#print("Tracking..");

var prograde = [getprop("/fdm/jsbsim/systems/pointing/inertial/prograde[0]"),getprop("/fdm/jsbsim/systems/pointing/inertial/prograde[1]"), getprop("/fdm/jsbsim/systems/pointing/inertial/prograde[2]")];

var radial = [getprop("/fdm/jsbsim/systems/pointing/inertial/radial[0]"),getprop("/fdm/jsbsim/systems/pointing/inertial/radial[1]"), getprop("/fdm/jsbsim/systems/pointing/inertial/radial[2]")];

var radial_up = radial;


# prograde and radial don't really form an ON system for eccentric orbits, so we correct that
# we need exact prograde orientation so we tilt the radial base vector for pointing

prograde = normalize(prograde);
radial = orthonormalize(prograde, radial);

var normal = cross_product (prograde, radial);

# vtgt is used to predict the apses, so it uses a pure LVLH system

var vtgt0 = tx * prograde[0] + ty * normal[0] + tz * radial[0];
var vtgt1 = tx * prograde[1] + ty * normal[1] + tz * radial[1];
var vtgt2 = tx * prograde[2] + ty * normal[2] + tz * radial[2];

# the orientation however has to be done taking the 11.4 deg
# thrust axis offset of the OMS into account

# first we need pitch, yaw and roll of the thrust axis

var py = get_pitch_yaw ([tx, ty, tz]);
var tv_roll = getprop("/fdm/jsbsim/systems/ap/oms-plan/tv-roll");
var tv_pitch = py[0] * sgeo_R2D;
var tv_yaw = py[1] * sgeo_R2D;

# then we correct for the 11.4 deg offset - in heads-up attitude that is upward pitch

var tv_pitch = tv_pitch + 11.4 * math.cos(tv_roll * sgeo_D2R);
var tv_yaw = tv_yaw + 11.4 * math.sin(tv_roll * sgeo_D2R);

#print("TV PYR: ",tv_pitch, " ", tv_yaw , " ", tv_roll);

# now we construct the components of the body axis pointing vector

var tv_pointing_body = SpaceShuttle.orientTaitBryan([1,0,0], tv_yaw , tv_pitch, tv_roll);

#print("TV pointing body: ", tv_pointing_body[0], " ", tv_pointing_body[1], " ", tv_pointing_body[2]);
#print("Norm: ", norm(tv_pointing_body));


var tv_secondary_body = SpaceShuttle.orientTaitBryan([0,1,0], tv_yaw , tv_pitch, tv_roll );

# multiplying the components with the inertial system results in the pointing vector

var prograde_rot = scalar_product(tv_pointing_body[0], prograde);
prograde_rot = add_vector(prograde_rot, scalar_product(tv_pointing_body[1], normal) );
prograde_rot = add_vector(prograde_rot, scalar_product(tv_pointing_body[2], radial) );

var normal_rot = scalar_product(tv_secondary_body[0], prograde);
normal_rot = add_vector(normal_rot, scalar_product(tv_secondary_body[1], normal) );
normal_rot = add_vector(normal_rot, scalar_product(tv_secondary_body[2], radial) );

prograde = prograde_rot;
normal = normal_rot;
radial = cross_product (prograde, normal);




setprop("/fdm/jsbsim/systems/ap/track/target-vector[0]", prograde[0]);
setprop("/fdm/jsbsim/systems/ap/track/target-vector[1]", prograde[1]);
setprop("/fdm/jsbsim/systems/ap/track/target-vector[2]", prograde[2]);

setprop("/fdm/jsbsim/systems/ap/track/target-sec[0]", -radial[0]);
setprop("/fdm/jsbsim/systems/ap/track/target-sec[1]", -radial[1]);
setprop("/fdm/jsbsim/systems/ap/track/target-sec[2]", -radial[2]);

setprop("/fdm/jsbsim/systems/ap/track/target-trd[0]", normal[0]);
setprop("/fdm/jsbsim/systems/ap/track/target-trd[1]", normal[1]);
setprop("/fdm/jsbsim/systems/ap/track/target-trd[2]", normal[2]);


# now we compute apoapsis and periapsis if the burn were right now

if (getprop("/fdm/jsbsim/systems/ap/oms-plan/oms-ignited") == 0) # we update the apoapsis and periapsis prediction
	{
	if (getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-flag") == 0)
		{

		var r = [getprop("/fdm/jsbsim/position/eci-x-ft"), getprop("/fdm/jsbsim/position/eci-y-ft"), getprop("/fdm/jsbsim/position/eci-z-ft")];

		var v = [getprop("/fdm/jsbsim/velocities/eci-x-fps"), getprop("/fdm/jsbsim/velocities/eci-y-fps"), getprop("/fdm/jsbsim/velocities/eci-z-fps")];
	

		var dv = scalar_product(dvtot, [vtgt0, vtgt1, vtgt2]);

		v = add_vector(v, dv);

		var apses = SpaceShuttle.compute_apses(r,v);
		var sea_level_radius_ft = getprop("/fdm/jsbsim/ic/sea-level-radius-ft");

		var periapsis_nm = (apses[0] - sea_level_radius_ft)/ 6076.11548556;
		var apoapsis_nm = (apses[1] - sea_level_radius_ft)/ 6076.11548556;

		var ops = getprop("/fdm/jsbsim/systems/dps/ops");

		if (ops == 3)
			{
			var rei = SpaceShuttle.get_rei(r,v);
			# correct REI for empirics
		
			var rei_correction = 375.0 + 3.6556 * periapsis_nm;
			setprop("/fdm/jsbsim/systems/ap/oms-plan/rei-nm", rei + rei_correction);
			}

		
		setprop("/fdm/jsbsim/systems/ap/oms-plan/apoapsis-nm", apoapsis_nm);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/periapsis-nm", periapsis_nm);
		}
	else # we use the pre-computed apoapsis and periapsis
		{
		setprop("/fdm/jsbsim/systems/ap/oms-plan/apoapsis-nm", oms_burn_target.apoapsis);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/periapsis-nm", oms_burn_target.periapsis);

		var ops = getprop("/fdm/jsbsim/systems/dps/ops");

		if (ops == 3)
			{
			setprop("/fdm/jsbsim/systems/ap/oms-plan/rei-nm", oms_burn_target.rei);
			}
		}
	}

settimer(func {oms_burn_loop(tx, ty, tz, dvtot);}, 0.0);
}


var oms_burn_start = func (time) {


var MET = getprop("/sim/time/elapsed-sec") + getprop("/fdm/jsbsim/systems/timer/delta-MET");
var tig = oms_burn_target.tig; 

# some log output

var x = getprop("/fdm/jsbsim/position/eci-x-ft") * 0.3048;
var y = getprop("/fdm/jsbsim/position/eci-y-ft") * 0.3048;
var z = getprop("/fdm/jsbsim/position/eci-z-ft") * 0.3048;

#print (MET, " ", x, " ", y, " ", z);


if (tig - MET < 0.0) # if we're at or past ignition time, we go
	{
	var burn_mode = getprop("/fdm/jsbsim/systems/ap/oms-plan/burn-mode");

	if (burn_mode == 1)
		{
		# DAP to OMS TVC
		setprop("/fdm/jsbsim/systems/fcs/control-mode", 11);

		# throttles to full
		setprop("/controls/engines/engine[5]/throttle", 1.0);
		setprop("/controls/engines/engine[6]/throttle", 1.0);

		setprop("/fdm/jsbsim/systems/ap/oms-plan/oms-ignited", 1);

		}
	else if (burn_mode == 2)
		{
		# DAP to OMS TVC with wraparound
		setprop("/fdm/jsbsim/systems/fcs/control-mode", 12);

		# throttle left to full
		setprop("/controls/engines/engine[5]/throttle", 1.0);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/oms-ignited", 1);
		}
	else if (burn_mode == 3)
		{
		# DAP to OMS TVC with wraparound
		setprop("/fdm/jsbsim/systems/fcs/control-mode", 12);

		# throttle right to full
		setprop("/controls/engines/engine[6]/throttle", 1.0);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/oms-ignited", 1);
		}
	else if (burn_mode == 4)
		{
		# RCS TRANS ATT HLD
		setprop("/fdm/jsbsim/systems/fcs/control-mode", 26);

		# throttle to full
		setprop("/controls/flight/rudder", 1);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/oms-ignited", 1);
		}
	# start the burn


	oms_burn_target.mark = getprop("/sim/time/elapsed-sec");
	oms_burn_target.tgo = time;
		
	oms_burn(time);
		
	}
else # we delay
	{
	settimer(func{ oms_burn_start (time);}, 1.0);
	}

}

var oms_burn_stop = func  {

# back to DAP A
setprop("/fdm/jsbsim/systems/fcs/control-mode", 20);

# obsolete burn plan
setprop("/fdm/jsbsim/systems/ap/oms-plan/burn-plan-available", 0);

# obsolete burn attitude holding
setprop("/fdm/jsbsim/systems/ap/oms-mnvr-flag", 0);

# throttles to off
setprop("/controls/engines/engine[5]/throttle", 0.0);
setprop("/controls/engines/engine[6]/throttle", 0.0);

oms_burn_target.mar = 0.0;


# null burn targets

setprop("/fdm/jsbsim/systems/ap/oms-plan/dvx", 0);
setprop("/fdm/jsbsim/systems/ap/oms-plan/dvy", 0);
setprop("/fdm/jsbsim/systems/ap/oms-plan/dvz", 0);
setprop("/fdm/jsbsim/systems/ap/oms-plan/dvtot", 0);
setprop("/fdm/jsbsim/systems/ap/oms-plan/tgo-string", "0:00");
setprop("/fdm/jsbsim/systems/ap/oms-plan/tgo-s", 0);

setprop("/fdm/jsbsim/systems/ap/oms-plan/oms-ignited", 0);

setprop("/fdm/jsbsim/systems/pointing/inertial/attitude/tgt-roll-deg", 0.0);
setprop("/fdm/jsbsim/systems/pointing/inertial/attitude/tgt-pitch-deg", 0.0);
setprop("/fdm/jsbsim/systems/pointing/inertial/attitude/tgt-yaw-deg", 0.0);

setprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-x", 0.0);
setprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-y", 0.0);
setprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-z", 0.0);

setprop("/fdm/jsbsim/systems/ap/oms-plan/exec-cmd", 0);


# remove N2 for purging

var nstarts_left = getprop("/fdm/jsbsim/systems/oms-hardware/n2-left-nstarts");
var nstarts_right = getprop("/fdm/jsbsim/systems/oms-hardware/n2-right-nstarts");

var burn_mode = getprop("/fdm/jsbsim/systems/ap/oms-plan/burn-mode");

if (burn_mode == 1)
	{
	nstarts_left = nstarts_left - 1;
	nstarts_right = nstarts_right -1;
	}
else if (burn_mode == 2)
	{
	nstarts_left = nstarts_left - 1;
	}
else if (burn_mode == 3)
	{
	nstarts_right = nstarts_right - 1;
	}
else if (burn_mode == 4)
	{
	setprop("/controls/flight/rudder", 0);
	}

if (nstarts_left < 0) {nstarts_left = 0;}
if (nstarts_right < 0) {nstarts_right = 0;}

settimer( func {

setprop("/fdm/jsbsim/systems/oms-hardware/n2-left-nstarts", nstarts_left);
setprop("/fdm/jsbsim/systems/oms-hardware/n2-right-nstarts", nstarts_right);

}, 1.0);

tracking_loop_flag = 0;
}

var oms_burn = func (time) {

if (time < 0.5) {oms_burn_stop(); return;}


# the 1 second timer is too inaccurate, thus we need a framerate-independent timer
var t_remaining = oms_burn_target.tgo - int(getprop("/sim/time/elapsed-sec") - oms_burn_target.mark);


setprop("/fdm/jsbsim/systems/ap/oms-plan/tgo-string", seconds_to_stringMS(t_remaining));
print("OMS burn for ", t_remaining, " seconds");

if (t_remaining < 0.5)  {oms_burn_stop(); return;}


var acc_x = getprop("/fdm/jsbsim/systems/navigation/acceleration-x");
var acc_y = getprop("/fdm/jsbsim/systems/navigation/acceleration-y");
var acc_z = getprop("/fdm/jsbsim/systems/navigation/acceleration-z");

setprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-x", getprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-x") + acc_x);
setprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-y", getprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-y") + acc_y);
setprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-z", getprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-z") + acc_z);

settimer(func {oms_burn(time - 1);}, 1.0);
}


######################################
# approximate AOA and ATO OMS targets
######################################


var compute_oms_abort_tgt = func (tgt_id) {


# tgt_id  1 is an immediate burn to raise apoapsis to 105 miles
# from there we can either circularize (3) or do a steep (4) or shallow (5) de-orbit burn

var apoapsis_miles = getprop("/fdm/jsbsim/systems/orbital/apoapsis-km")/1.853;
var periapsis_miles = getprop("/fdm/jsbsim/systems/orbital/periapsis-km")/1.853;
var current_alt_miles = getprop("/position/altitude-ft")  * 0.00016449001618;

var delta_v = 0.0;

if (tgt_id == 1)
	{

	if (apoapsis_miles > 105.0)
		{
		delta_v = 0.0;
		}
	else 	
		{

		var apoapsis_diff = math.abs(current_alt_miles - apoapsis_miles);
		var periapsis_diff = math.abs(current_alt_miles - periapsis_miles);

		var at_periapsis = 1;
		if (apoapsis_diff < periapsis_diff) {at_periapsis = 0;}

		print("At periapsis: ", at_periapsis);
		print ("Ap: ", apoapsis_miles, " P: ", periapsis_miles, "Cur: ", current_alt_miles);

		if (at_periapsis == 1) # need to raise apoapsis
			{
			var delta_alt = 105.0 - apoapsis_miles;
			delta_v = 1.5 * delta_alt;

			}
		else # need to raise periapsis
			{
			delta_alt = 105.0 - periapsis_miles;
			delta_v = 1.5 * delta_alt;
			}
		}

	}

else if (tgt_id == 3)
	{

        var tta = SpaceShuttle.time_to_apsis();

	print("TTA: ",tta[0], " ", tta[1]);

	if (tta[0] == 2) # we're going to apoapsis
		{

		# set TIG to 2 minutes prior to apsis
		var MET = getprop("/sim/time/elapsed-sec") + getprop("/fdm/jsbsim/systems/timer/delta-MET");
		setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-seconds", MET + tta[1]-120.0);
		SpaceShuttle.set_oms_mnvr_timer();

		var periapsis_tgt = 105.0;


		var delta_alt = periapsis_tgt - periapsis_miles;

		delta_v = 1.5 * delta_alt;
		}
	}
else if ((tgt_id == 4) or (tgt_id == 5)) # we need to do the de-orbit burn opposite to site
	{

	var lon = getprop("/position/longitude-deg");
	var tgt_lon = landing_site.lon() - 160.0;
	var delta_lon = tgt_lon - lon;
	if (lon < 0.0) {lon = lon + 360;}
	if (tgt_lon < 0.0) {tgt_lon = tgt_lon + 360.0;}

	print("Current lon: ", lon, " target lon: ", tgt_lon);
	print("Delta_lon_before: ", delta_lon);
	if (delta_lon < 0.0) {delta_lon = delta_lon + 360.0;} 
	if (delta_lon > 360.0) {delta_lon = delta_lon - 360.0;}

	print("Delta_lon: ", delta_lon);

	var orbital_period = getprop("/fdm/jsbsim/systems/orbital/orbital-period-s");
	var ttb = delta_lon/360.0 * orbital_period;

	# set TIG to 2 minutes prior to 180 degree point
	var MET = getprop("/sim/time/elapsed-sec") + getprop("/fdm/jsbsim/systems/timer/delta-MET");
	setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-seconds", MET + ttb-120.0);
	SpaceShuttle.set_oms_mnvr_timer();

	if (tgt_id == 4) {periapsis_tgt = 25.0;}
	else if (tgt_id == 5) {periapsis_tgt = 50.0;}

	var delta_alt_corr = 0.0;
        var tta = SpaceShuttle.time_to_apsis();
	if (tta[0] == 2) # to apoapsis
		{
		if (ttb < tta[1]) # we burn before reaching apoapsis
			{
			var fraction = ttb/(0.5 * orbital_period);
			delta_alt_corr = (1.0 - fraction) * (apoapsis_miles - periapsis_miles);
			}
		else # we burn on the way to periapsis
			{
			var fraction = (ttb - tta[1])/(0.5 * orbital_period);
			delta_alt_corr = fraction * (apoapsis_miles - periapsis_miles);
			}
		}
	else
		{
		if (ttb < tta[1]) # we burn before reaching periapsis
			{
			var fraction = ttb/(0.5 * orbital_period);
			delta_alt_corr = fraction * (apoapsis_miles - periapsis_miles);
			}
		else # we burn on the way to apoapsis
			{
			var fraction = (ttb - tta[1])/(0.5 * orbital_period);
			delta_alt_corr = (1.0 - fraction) * (apoapsis_miles - periapsis_miles);
			}
		}
	print ("Fraction: ", fraction);
	print ("Delta alt correction: ", delta_alt_corr);

	var delta_alt = periapsis_tgt - periapsis_miles - delta_alt_corr;
	delta_v = 1.5 * delta_alt;

	}
	

setprop("/fdm/jsbsim/systems/ap/oms-plan/dvx",delta_v);
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


