###########################################################################
# this file contains several techniques to maintain other objects in orbit
# 
# * shuttle-relative coordinate management (for EVA view)
# * independently computed simple ballistic FDM (for tank and jettisoned Ku-band antenna)
# (* analytic Kepler orbit)
###########################################################################


var evaState = {};

var etState = {};
var etCoord = {};
var etModel = {};

var kuState = {};
var kuCoord = {};
var kuModel = {};

var payloadState = {};
var payloadCoord = {};
var payloadModel = {};

var rmsState = {};
var rmsCoord = {};
var rmsModel = {};

var issState = {};
var issCoord = {};
var issModel = {};
var issInitialState = [0,0,0,0,0,0];

var eva_loop_flag = 0;
var tank_loop_flag = 0;
var ku_loop_flag = 0;
var payload_loop_flag = 0;
var rms_loop_flag = 0;
var iss_loop_flag = 0;

var ft_to_m = 0.30480;
var m_to_ft = 1.0/ft_to_m;
var earth_rotation_deg_s = 0.0041666666666666;

var offset_vec = [];
var offset_vec_ku = [];
var offset_vec_payload = [];
var offset_vec_rms = [];
var offset_vec_iss = [];

###########################################################################
# basic state vector management for imposed external accelerations
###########################################################################

var stateVector = {
	new: func(x,y,z,vx,vy,vz,yaw,pitch,roll) {
	        var s = { parents: [stateVector] };
	       	s.x = x;
		s.y = y;
		s.z = z;
		s.vx = vx;
		s.vy = vy;
		s.vz = vz;
		s.yaw = yaw;
		s.pitch = pitch;
		s.roll = roll;
		s.yaw_rate = 0.0;
		s.pitch_rate = 0.0;
		s.roll_rate = 0.0;
		s.lvlh_flag = 0;
		return s;
	},
	update: func (ax, ay, az, a_yaw, a_pitch, a_roll, dt = nil) {

		if (dt == nil)
			{
			#var speedup = getprop("/sim/speed-up");
			dt = getprop("/sim/time/delta-sec");# * speedup;
			}

		me.x = me.x + me.vx * dt + 0.5 * ax * dt * dt;
		me.y = me.y + me.vy * dt + 0.5 * ay * dt * dt;
		me.z = me.z + me.vz * dt + 0.5 * az * dt * dt;

		me.vx = me.vx + ax * dt;
		me.vy = me.vy + ay * dt;
		me.vz = me.vz + az * dt;
	
		var croll = math.cos(me.roll * math.pi/180.0);
		var sroll = math.sin(me.roll * math.pi/180.0);
		var cpitch = math.cos(me.pitch * math.pi/180.0);
		var spitch = math.sin(me.pitch * math.pi/180.0);

		me.yaw_rate = me.yaw_rate + a_yaw * dt;
		me.pitch_rate = me.pitch_rate + a_pitch * dt;
		me.roll_rate = me.roll_rate + a_roll * dt;

		me.yaw = me.yaw + me.yaw_rate * dt * croll - me.pitch_rate * dt *  sroll;
		me.pitch = me.pitch + me.pitch_rate * dt * croll + me.yaw_rate * dt * sroll;
		me.roll = me.roll + me.roll_rate * dt - me.yaw_rate * dt * spitch * croll + me.pitch_rate * dt * spitch * sroll ;

		#print(me.pitch, " ", me.yaw, " ", me.roll);

		#print(a_yaw, " ", me.yaw_rate, " ", me.yaw);
	},
	
  
};

#####################################################################################
# this function provides the effect of three concatenated rotations in the Tait-Bryan 
# convention (better known as yaw, pitch and roll) on a given vector
# i.e. transforms from body coords to world
####################################################################################

var orientTaitBryan = func (v, h, p, r) {

var heading_rad = h * math.pi/180.0;
var pitch_rad = p * math.pi/180.0;
var roll_rad = r * math.pi/180.0;

var c1 = math.cos(heading_rad);
var s1 = math.sin(heading_rad);

var c2 = math.cos(pitch_rad);
var s2 = math.sin(pitch_rad);

var c3 = math.cos(roll_rad);
var s3 = math.sin(roll_rad);

var x = v[0];
var y = v[1];
var z = v[2];

var x1 = x * (c1 * c2) + y * (c1 * s2 * s3 - c3 * s1) + z * (-s1 * s3 - c1 * c3 * s2);
var y1 = x * (c2 * s1) + y * (c1 * c3 + s1 * s2 * s3) + z * (-c3 * s1 * s2 + c1 * s3);
var z1 = x * s2 + y * (-c2 * s3) + z * c2 * c3;

var out = [];

append(out, x1);
append(out, y1);
append(out, z1);

return out;
}

var orientTaitBryanPassive = func (v, h, p, r) {

var heading_rad = h * math.pi/180.0;
var pitch_rad = p * math.pi/180.0;
var roll_rad = r * math.pi/180.0;

var c1 = math.cos(heading_rad);
var s1 = math.sin(heading_rad);

var c2 = math.cos(pitch_rad);
var s2 = math.sin(pitch_rad);

var c3 = math.cos(roll_rad);
var s3 = math.sin(roll_rad);

var x = v[0];
var y = v[1];
var z = v[2];

var x1 = x * (c1 * c2) + y * (c2 * s1) + z * s2;
var y1 = x * (c1 * s2 * s3 - c3 * s1) + y * (c1 * c3 + s1 * s2 * s3) + z * (-c2 * s3);
var z1 = x * (-s1 * s3 - c1 * c3 * s2) + y * (-c3 * s1 * s2 + c1 * s3) + z * c2 * c3;




var out = [];

append(out, x1);
append(out, y1);
append(out, z1);

return out;
}


###########################################################################
# EVA control routines
###########################################################################

var toggle_EVA = func {

if (getprop("/sim/current-view/name") != "EVA")
	{
	return;
	}

var control = getprop("/fdm/jsbsim/systems/fcs/control-mode");

if ((control != 50) and (control != 51))
	{
	# make sure the orbiter is not rotating
	
	var pitch_rate = getprop("/fdm/jsbsim/velocities/q-rad_sec");
	var roll_rate = getprop("/fdm/jsbsim/velocities/p-rad_sec");
	var yaw_rate = getprop("/fdm/jsbsim/velocities/r-rad_sec");

	if ((math.abs(pitch_rate) < 0.000174) and (math.abs(roll_rate) < 0.000174) and (math.abs(yaw_rate) < 0.000174)) 
		{
		start_EVA();
		}
	else
		{
		setprop("/sim/messages/copilot", "Null orbiter rotation rates before spacewalk!");
		return;
		}
	}

else
	{

	stop_EVA();

	}


}


var start_EVA = func {

setprop("/fdm/jsbsim/systems/fcs/control-mode", 50);
setprop("/controls/shuttle/control-system-string", "MMU");
setprop("/sim/messages/copilot", "Starting spacewalk...");

evaState = stateVector.new(-7.5,0.0,-3.5,0.0,0.0,0.0,180.0,0.0,0.0);
eva_loop_flag = 1;

EVA_loop();

}

var stop_EVA = func {

var airlock_proximity = 0;

if ((math.abs(evaState.x +7.5) < 1.0) and (math.abs(evaState.y) < 1.0) and (math.abs(evaState.z +3.5)< 1.0)) 
	{
	airlock_proximity = 1;
	}

if (airlock_proximity == 0)
	{
	setprop("/sim/messages/copilot", "You need to get back to the airlock.");
	}

if (airlock_proximity == 1)

	{	
	eva_loop_flag = 0;
	setprop("/sim/messages/copilot", "Entering airlock...");
	setprop("/fdm/jsbsim/systems/fcs/control-mode", 1);
	setprop("/controls/shuttle/control-system-string", "RCS rotation");
	controls.centerFlightControls();
	settimer(reset_view,0.5);
	}	
}

var reset_view = func {

	setprop("/sim/current-view/x-offset-m",0.0);
	setprop("/sim/current-view/y-offset-m",-3.5);
	setprop("/sim/current-view/z-offset-m",-7.5);
	setprop("/sim/current-view/pitch-offset-deg", 0.0);
	setprop("/sim/current-view/yaw-offset-deg", 180.0);
	setprop("/sim/current-view/roll-offset-deg", 0.0);
	setprop("/sim/view[100]/config/heading-offset-deg",180.0);
	setprop("/sim/view[100]/config/pitch-offset-deg", 0.0);
	setprop("/sim/view[100]/config/roll-offset-deg", 0.0);
}

var EVA_loop = func {

var mode = getprop("/fdm/jsbsim/systems/fcs/control-mode");

if (mode == 50)
	{


	var ax = getprop("/fdm/jsbsim/fcs/rudder-cmd-norm") * 0.1;
	var ay = getprop("/fdm/jsbsim/fcs/aileron-cmd-norm") * 0.1;
	var az = getprop("/fdm/jsbsim/fcs/elevator-cmd-norm") * 0.1;

	var x = [1.0, 0.0, 0.0];
	var ex = orientTaitBryan(x, evaState.yaw, -evaState.pitch, evaState.roll);
	var y = [0.0, 1.0, 0.0];
	var ey = orientTaitBryan(y, evaState.yaw, -evaState.pitch, evaState.roll);
	var z = [0.0, 0.0, 1.0];
	var ez = orientTaitBryan(z, evaState.yaw, -evaState.pitch, evaState.roll);

	var Ax = ax * ex[0] + ay * ey[0] + az * ez[0];
	var Ay = ax * ex[1] + ay * ey[1] + az * ez[1];
	var Az = ax * ex[2] + ay * ey[2] + az * ez[2];

	#print("ex: ", ex[0], " ", ex[1], " ", ex[2]);
	#print("ey: ", ey[0], " ", ey[1], " ", ey[2]);
	#print("ez: ", ez[0], " ", ez[1], " ", ez[2]);
	#print("a: ", ax, " ", ay, " ", az);
	#print("A: ", Ax, " ", Ay, " ", Az);

	evaState.update(Ax,Ay,Az,0.0,0.0,0.0);	
	}
else if (mode == 51)
	{
	var ax = getprop("/fdm/jsbsim/fcs/elevator-cmd-norm") * -0.5;
	var ay = getprop("/fdm/jsbsim/fcs/aileron-cmd-norm") * 0.5;
	var az = getprop("/fdm/jsbsim/fcs/rudder-cmd-norm") * 0.5;
	evaState.update(0.0,0.0,0.0,az,ax,ay);	
	}



# vexingly enough, view axes definitions don't agree with plane coordinate axes

setprop("/sim/current-view/y-offset-m", evaState.z);
setprop("/sim/current-view/x-offset-m", evaState.y);
setprop("/sim/current-view/z-offset-m", evaState.x);

setprop("/sim/view[100]/config/heading-offset-deg", evaState.yaw);
setprop("/sim/view[100]/config/pitch-offset-deg", evaState.pitch);
setprop("/sim/view[100]/config/roll-offset-deg", evaState.roll);

setprop("/sim/current-view/heading-offset-deg", evaState.yaw);
setprop("/sim/current-view/pitch-offset-deg", evaState.pitch);
setprop("/sim/current-view/roll-offset-deg", evaState.roll);

#print(evaState.yaw, " ", evaState.pitch, " ", evaState.roll);


if (eva_loop_flag == 1) {settimer(EVA_loop, 0.0);}

}


###########################################################################
# generic functions used by co-orbiting object routines
###########################################################################

var get_force = func (objState, shuttleCoord) {


var G = [objState.x, objState.y, objState.z]; 
var Gnorm = math.sqrt(math.pow(G[0],2.0) + math.pow(G[1],2.0) + math.pow(G[2],2.0));
var g = getprop("/fdm/jsbsim/accelerations/gravity-ft_sec2") * 0.3048 * 1.00015;
var hnorm = SpaceShuttle.norm([shuttleCoord.x(), shuttleCoord.y(), shuttleCoord.z()]);

#g *=  (1.0/math.pow(hnorm,2.0)) /  (1.0/math.pow(Gnorm,2.0));

#var hdiff = hnorm - Gnorm;
#var corr = (hdiff / 600.) * 0.0025;
#print ("hdiff: ", hdiff, "corr: ", corr);
#g += corr;

G[0] = -G[0]/Gnorm * g;
G[1] = -G[1]/Gnorm * g;
G[2] = -G[2]/Gnorm * g;


# compensating acceleration to dampen the drift error by coordinate trafo
# this might actually be non-spherical gravity of JSBSim

var sin_lat = math.sin(shuttleCoord.lat() * 3.1415/180.0);
var cos_lat = math.cos(shuttleCoord.lat() * 3.1515/180.0);
var sin_lon = math.sin(shuttleCoord.lon() * 3.1415/180.0);
var cos_lon = math.cos(shuttleCoord.lon() * 3.1515/180.0);

A_mag = 0.0243 * sin_lat * cos_lat;



var A = [A_mag * cos_lon * sin_lat, A_mag * sin_lon * sin_lat, -A_mag * cos_lat];

var F = [G[0] + A[0], G[1] + A[1], G[2] + A[2]];

return F;
}


var set_coords = func (objString, objCoord, objState) {

var lon = getprop("/position/longitude-deg");
var groundtrack = getprop("/fdm/jsbsim/systems/entry_guidance/groundtrack-course-deg");
var groundtrack_orig = getprop("/controls/shuttle/"~objString~"/groundtrack-orig-deg");

var yaw_correction = groundtrack - groundtrack_orig;



setprop("/controls/shuttle/"~objString~"/latitude-deg", objCoord.lat());
setprop("/controls/shuttle/"~objString~"/longitude-deg", objCoord.lon());
setprop("/controls/shuttle/"~objString~"/elevation-ft", objCoord.alt() * m_to_ft);
setprop("/controls/shuttle/"~objString~"/pitch-deg", objState.pitch + lon * (1-objState.lvlh_flag));
setprop("/controls/shuttle/"~objString~"/heading-deg", objState.yaw + yaw_correction);

}


var compute_state_correction = func (objState, objCoord, shuttleCoord, v_offset_vec, delta_lon) {

objState.vx = objState.vx - v_offset_vec[0];
objState.vy = objState.vy - v_offset_vec[1];
objState.vz = objState.vz - v_offset_vec[2];

objCoord.set_xyz(shuttleCoord.x(), shuttleCoord.y(), shuttleCoord.z());
objCoord.set_lon(objCoord.lon() + delta_lon);

objState.x = objCoord.x();
objState.y = objCoord.y();
objState.z = objCoord.z();

return objState;
}





var place_model = func(string, path, lat, lon, alt, heading, pitch, roll) {



var m = props.globals.getNode("models", 1);
		for (var i = 0; 1; i += 1)
			if (m.getChild("model", i, 0) == nil)
				break;
var model = m.getChild("model", i, 1);



setprop("/controls/shuttle/"~string~"/latitude-deg", lat);
setprop("/controls/shuttle/"~string~"/longitude-deg", lon);
setprop("/controls/shuttle/"~string~"/elevation-ft", alt);
setprop("/controls/shuttle/"~string~"/heading-deg", heading);
setprop("/controls/shuttle/"~string~"/pitch-deg", pitch);
setprop("/controls/shuttle/"~string~"/roll-deg", roll);

var groundtrack = getprop("/fdm/jsbsim/systems/entry_guidance/groundtrack-course-deg");
setprop("/controls/shuttle/"~string~"/groundtrack-orig-deg", groundtrack);


var etmodel = props.globals.getNode("/controls/shuttle/"~string, 1);
var latN = etmodel.getNode("latitude-deg",1);
var lonN = etmodel.getNode("longitude-deg",1);
var altN = etmodel.getNode("elevation-ft",1);
var headN = etmodel.getNode("heading-deg",1);
var pitchN = etmodel.getNode("pitch-deg",1);
var rollN = etmodel.getNode("roll-deg",1);



model.getNode("path", 1).setValue(path);
model.getNode("latitude-deg-prop", 1).setValue(latN.getPath());
model.getNode("longitude-deg-prop", 1).setValue(lonN.getPath());
model.getNode("elevation-ft-prop", 1).setValue(altN.getPath());
model.getNode("heading-deg-prop", 1).setValue(headN.getPath());
model.getNode("pitch-deg-prop", 1).setValue(pitchN.getPath());
model.getNode("roll-deg-prop", 1).setValue(rollN.getPath());
model.getNode("load", 1).remove();


return model;
}


###########################################################################
# external tank control routines
###########################################################################

var init_tank = func {


var pitch = getprop("/orientation/pitch-deg");
var yaw =getprop("/orientation/heading-deg");
var roll = getprop("/orientation/roll-deg");

var lon = getprop("/position/longitude-deg");


etCoord = geo.aircraft_position() ;

print(etCoord.x(), " ", etCoord.y, " ", etCoord.z);


etState = stateVector.new (etCoord.x(),etCoord.y(),etCoord.z(),0,0,0,yaw, pitch - lon, roll);

etModel = place_model("et-ballistic", "Aircraft/SpaceShuttle/Models/external-tank-disconnected.xml", etCoord.lat(), etCoord.lon(), etCoord.alt() * m_to_ft, yaw,pitch,roll);

# seems we need small offsets in velocity to get a small separation velocity
# this looks odd but the error we need to correct is actually a function
# of the framerate, so we need to include dt here
# what we do is to pre-empt the correction here and during the first two frames compute
# it explicitly so that the tank is always at rest when the shuttle pushes off

var lat = getprop("/position/latitude-deg") * math.pi/180.0;
var lon = getprop("/position/longitude-deg") * math.pi/180.0;
var dt = getprop("/sim/time/delta-sec");

var vxoffset = 3.5 * math.cos(lon) * math.pow(dt/0.05,3.0);
var vyoffset = 3.5 * math.sin(lon) * math.pow(dt/0.05,3.0);
var vzoffset = 0.0;


# now we always push the the orbiter away from the tank

#var current_mode = getprop("/fdm/jsbsim/systems/fcs/control-mode");
setprop("/fdm/jsbsim/systems/fcs/control-mode",26);
setprop("/controls/flight/elevator", 1);

# a TAL targets a higher separation burn
var sep_burn_time = 5.0;

if (getprop("/fdm/jsbsim/systems/abort/abort-mode") == 2)
	{sep_burn_time = 10.0;}

settimer( func{
	controls.centerFlightControls();
	SpaceShuttle.control_to_rcs();
	}, sep_burn_time);



settimer(func { 
		etState.vx = getprop("/fdm/jsbsim/velocities/eci-x-fps") * ft_to_m + vxoffset;
		etState.vy = getprop("/fdm/jsbsim/velocities/eci-y-fps") * ft_to_m + vyoffset;
		etState.vz = getprop("/fdm/jsbsim/velocities/eci-z-fps") * ft_to_m + vzoffset;
		tank_loop_flag = 1;
		update_tank(0.0); },0);

}

var update_tank = func (delta_lon) {

var shuttleCoord = geo.aircraft_position();
var dt = getprop("/sim/time/delta-sec");# * getprop("/sim/speed-up");


delta_lon = delta_lon + dt * earth_rotation_deg_s * 1.004;

var F = get_force (etState, shuttleCoord);
etState.update(F[0], F[1], F[2], 0.0,0.0,0.0);
etCoord.set_xyz(etState.x, etState.y, etState.z);
etCoord.set_lon(etCoord.lon() - delta_lon);


if (tank_loop_flag < 3)
	{
	if (tank_loop_flag ==1)
		{
		offset_vec = [etCoord.x()-shuttleCoord.x(), etCoord.y()-shuttleCoord.y(),etCoord.z()-shuttleCoord.z()];
		}
	if (tank_loop_flag == 2)
		{
		var offset1_vec = [etCoord.x()-shuttleCoord.x(), etCoord.y()-shuttleCoord.y(),etCoord.z()-shuttleCoord.z()];
		var v_offset_vec = [(offset1_vec[0] - offset_vec[0]) / dt, (offset1_vec[1] - offset_vec[1]) / dt, (offset1_vec[2] - offset_vec[2]) / dt];
		#print(v_offset_vec[0], " ", v_offset_vec[1], " ", v_offset_vec[2]);


		etState = compute_state_correction  (etState, etCoord, shuttleCoord, v_offset_vec, delta_lon);


		#etCoord.set_lon(etCoord.lon() - delta_lon);
		}
	tank_loop_flag = tank_loop_flag + 1;


	}

set_coords("et-ballistic", etCoord, etState);

var dist = shuttleCoord.distance_to(etCoord);
if (dist > 5000.0) 
	{
	print ("ET simulation ends");
	etModel.remove();
	tank_loop_flag = 0;
	}

if (tank_loop_flag >0 ) {settimer(func{ update_tank(delta_lon);} ,0.0);}
}





var logging_loop = func (index)  {

var shuttleCoord = geo.aircraft_position();

var my_offset_vec = [etCoord.x()-shuttleCoord.x(), etCoord.y()-shuttleCoord.y(),etCoord.z()-shuttleCoord.z()];

print (index, " ", my_offset_vec[0], " ", my_offset_vec[1], " ", my_offset_vec[2]);

index = index + 1;

settimer (func{logging_loop(index);}, 1.0);

}



###########################################################################
# Ku-antenna control routines
###########################################################################


var init_ku = func  {


var pitch = getprop("/orientation/pitch-deg");
var yaw = getprop("/orientation/heading-deg");
var roll = getprop("/orientation/roll-deg");

var lon = getprop("/position/longitude-deg");


kuCoord = geo.aircraft_position() ;

print(kuCoord.x(), " ", kuCoord.y, " ", kuCoord.z);

# copy current alpha and beta angles of the antenna

var deploy = getprop("/fdm/jsbsim/systems/mechanical/ku-antenna-pos");
setprop("/controls/shuttle/ku-ballistic/ku-antenna-pos", deploy);

var alpha = getprop("/controls/shuttle/ku-antenna-alpha-deg");
setprop("/controls/shuttle/ku-ballistic/ku-antenna-alpha-deg", alpha);

var beta = getprop("/controls/shuttle/ku-antenna-beta-deg");
setprop("/controls/shuttle/ku-ballistic/ku-antenna-beta-deg", beta);


kuState = stateVector.new (kuCoord.x(),kuCoord.y(),kuCoord.z(),0,0,0,yaw, pitch - lon, roll);

kuState.pitch_rate = 0.2;
kuState.yaw_rate = 0.1;


kuModel = place_model("ku-ballistic", "Aircraft/SpaceShuttle/Models/PayloadBay/KU-Antenna/ku-antenna-disconnected.xml", kuCoord.lat(), kuCoord.lon(), kuCoord.alt() * m_to_ft, yaw,pitch,roll);

# seems we need small offsets in velocity to get a small separation velocity
# this looks odd but the error we need to correct is actually a function
# of the framerate, so we need to include dt here
# what we do is to pre-empt the correction here and during the first two frames compute
# it explicitly so that the tank is always at rest when the shuttle pushes off

var lat = getprop("/position/latitude-deg") * math.pi/180.0;
var lon = getprop("/position/longitude-deg") * math.pi/180.0;
var dt = getprop("/sim/time/delta-sec");

var vxoffset = 3.5 * math.cos(lon) * math.pow(dt/0.05,3.0);
var vyoffset = 3.5 * math.sin(lon) * math.pow(dt/0.05,3.0);
var vzoffset = 0.0;



settimer(func { 
		kuState.vx = getprop("/fdm/jsbsim/velocities/eci-x-fps") * ft_to_m + vxoffset;
		kuState.vy = getprop("/fdm/jsbsim/velocities/eci-y-fps") * ft_to_m + vyoffset;
		kuState.vz = getprop("/fdm/jsbsim/velocities/eci-z-fps") * ft_to_m + vzoffset;
		ku_loop_flag = 1;
		update_ku(0.0); },0);
}

var update_ku = func (delta_lon) {

var shuttleCoord = geo.aircraft_position();
var dt = getprop("/sim/time/delta-sec");# * getprop("/sim/speed-up");


delta_lon = delta_lon + dt * earth_rotation_deg_s * 1.004;


var F = get_force (kuState, shuttleCoord);


kuState.update(F[0], F[1], F[2], 0.0,0.0,0.0);
kuCoord.set_xyz(kuState.x, kuState.y, kuState.z);
kuCoord.set_lon(kuCoord.lon() - delta_lon);

if (ku_loop_flag < 3)
	{
	if (ku_loop_flag ==1)
		{
		offset_vec_ku = [kuCoord.x()-shuttleCoord.x(), kuCoord.y()-shuttleCoord.y(),kuCoord.z()-shuttleCoord.z()];
		}
	if (ku_loop_flag == 2)
		{
		var offset1_vec = [kuCoord.x()-shuttleCoord.x(), kuCoord.y()-shuttleCoord.y(),kuCoord.z()-shuttleCoord.z()];
		var v_offset_vec = [(offset1_vec[0] - offset_vec_ku[0]) / dt, (offset1_vec[1] - offset_vec_ku[1]) / dt, (offset1_vec[2] - offset_vec_ku[2]) / dt];
		#print(v_offset_vec[0], " ", v_offset_vec[1], " ", v_offset_vec[2]);

		#offset_vec_ku = offset1_vec;


		kuState = compute_state_correction  (kuState, kuCoord, shuttleCoord, v_offset_vec, delta_lon);

	
		#kuCoord.set_lon(kuCoord.lon() - delta_lon);
		}
	ku_loop_flag = ku_loop_flag + 1;


	}

set_coords("ku-ballistic", kuCoord, kuState);


var dist = shuttleCoord.distance_to(kuCoord);
if (dist > 1000.0) 
	{
	print ("Ku-antenna simulation ends");
	kuModel.remove();
	ku_loop_flag = 0;
	}



if (ku_loop_flag >0 ) {settimer(func {update_ku(delta_lon); },0.0);}
}


###########################################################################
# payload control routines
###########################################################################


var init_payload = func  {


var pitch = getprop("/orientation/pitch-deg");
var yaw = getprop("/orientation/heading-deg");
var roll = getprop("/orientation/roll-deg");

var lon = getprop("/position/longitude-deg");


payloadCoord = geo.aircraft_position() ;


# copy current animation state of the payload

var pitch1 = getprop("/fdm/jsbsim/systems/rms/sum-wrist-pitch-deg");
setprop("/controls/shuttle/payload-ballistic/payload-pitch-deg", pitch1);

var yaw1 = getprop("/fdm/jsbsim/systems/rms/sum-wrist-yaw-deg");
setprop("/controls/shuttle/payload-ballistic/payload-yaw-deg", yaw1);

var roll1 = getprop("/fdm/jsbsim/systems/rms/ang-wrist-roll-deg");
setprop("/controls/shuttle/payload-ballistic/payload-roll-deg", roll1);

var x = getprop("/fdm/jsbsim/systems/rms/effector-x");
setprop("/controls/shuttle/payload-ballistic/payload-x", x);

var y = getprop("/fdm/jsbsim/systems/rms/effector-y");
setprop("/controls/shuttle/payload-ballistic/payload-y", y);

var z = getprop("/fdm/jsbsim/systems/rms/effector-z");
setprop("/controls/shuttle/payload-ballistic/payload-z", z);


payloadState = stateVector.new (payloadCoord.x(),payloadCoord.y(),payloadCoord.z(),0,0,0,yaw, pitch - lon, roll);


var model_path = getprop("/sim/config/shuttle/PL-model-path");

payloadModel = place_model("payload-ballistic", model_path, payloadCoord.lat(), payloadCoord.lon(), payloadCoord.alt() * m_to_ft, yaw,pitch,roll);

# seems we need small offsets in velocity to get a small separation velocity
# this looks odd but the error we need to correct is actually a function
# of the framerate, so we need to include dt here
# what we do is to pre-empt the correction here and during the first two frames compute
# it explicitly so that the tank is always at rest when the shuttle pushes off

var lat = getprop("/position/latitude-deg") * math.pi/180.0;
var lon = getprop("/position/longitude-deg") * math.pi/180.0;
var dt = getprop("/sim/time/delta-sec");

var vxoffset = 3.5 * math.cos(lon) * math.pow(dt/0.05,3.0);
var vyoffset = 3.5 * math.sin(lon) * math.pow(dt/0.05,3.0);
var vzoffset = 0.0;



settimer(func { 
		payloadState.vx = getprop("/fdm/jsbsim/velocities/eci-x-fps") * ft_to_m + vxoffset;
		payloadState.vy = getprop("/fdm/jsbsim/velocities/eci-y-fps") * ft_to_m + vyoffset;
		payloadState.vz = getprop("/fdm/jsbsim/velocities/eci-z-fps") * ft_to_m + vzoffset;
		payload_loop_flag = 1;
		update_payload(0.0); },0);
}

var update_payload = func (delta_lon) {

var shuttleCoord = geo.aircraft_position();
var dt = getprop("/sim/time/delta-sec");# * getprop("/sim/speed-up");


delta_lon = delta_lon + dt * earth_rotation_deg_s * 1.004;

var F = get_force (payloadState, shuttleCoord);

payloadState.update(F[0], F[1], F[2], 0.0,0.0,0.0);
payloadCoord.set_xyz(payloadState.x, payloadState.y, payloadState.z);
payloadCoord.set_lon(payloadCoord.lon() - delta_lon);

if (payload_loop_flag < 3)
	{
	if (payload_loop_flag ==1)
		{
		offset_vec_payload = [payloadCoord.x()-shuttleCoord.x(), payloadCoord.y()-shuttleCoord.y(),payloadCoord.z()-shuttleCoord.z()];
		}
	if (payload_loop_flag == 2)
		{
		var offset1_vec = [payloadCoord.x()-shuttleCoord.x(), payloadCoord.y()-shuttleCoord.y(),payloadCoord.z()-shuttleCoord.z()];
		var v_offset_vec = [(offset1_vec[0] - offset_vec_payload[0]) / dt, (offset1_vec[1] - offset_vec_payload[1]) / dt, (offset1_vec[2] - offset_vec_payload[2]) / dt];
		#print(v_offset_vec[0], " ", v_offset_vec[1], " ", v_offset_vec[2]);

		#offset_vec_payload = offset1_vec;

		payloadState = compute_state_correction  (payloadState, payloadCoord, shuttleCoord, v_offset_vec, delta_lon);

		#payloadCoord.set_lon(payloadCoord.lon() - delta_lon);
		}
	payload_loop_flag = payload_loop_flag + 1;


	}


set_coords("payload-ballistic", payloadCoord, payloadState);


var dist = shuttleCoord.distance_to(payloadCoord);

#print(dist);

if (dist > 5000.0) 
	{
	print ("Payload simulation ends");
	payloadModel.remove();
	payload_loop_flag = 0;
	}



if (payload_loop_flag >0 ) {settimer(func {update_payload(delta_lon); },0.0);}
}


###########################################################################
# jettisoned rms arm control routines
###########################################################################


var init_rms = func  {


var pitch = getprop("/orientation/pitch-deg");
var yaw = getprop("/orientation/heading-deg");
var roll = getprop("/orientation/roll-deg");

var lon = getprop("/position/longitude-deg");


rmsCoord = geo.aircraft_position() ;


# copy current animation state of the arm

var shoulder_pitch = getprop("/fdm/jsbsim/systems/rms/ang-shoulder-pitch-deg");
setprop("/controls/shuttle/rms-ballistic/ang-shoulder-pitch-deg", shoulder_pitch);

var shoulder_yaw = getprop("/fdm/jsbsim/systems/rms/ang-shoulder-yaw-deg");
setprop("/controls/shuttle/rms-ballistic/ang-shoulder-yaw-deg", shoulder_yaw);

var elbow_pitch = getprop("/fdm/jsbsim/systems/rms/ang-ellbow-pitch-deg");
setprop("/controls/shuttle/rms-ballistic/ang-ellbow-pitch-deg", elbow_pitch);

var wrist_pitch = getprop("/fdm/jsbsim/systems/rms/ang-wrist-pitch-deg");
setprop("/controls/shuttle/rms-ballistic/ang-wrist-pitch-deg", wrist_pitch);

var wrist_yaw = getprop("/fdm/jsbsim/systems/rms/ang-wrist-yaw-deg");
setprop("/controls/shuttle/rms-ballistic/ang-wrist-yaw-deg", wrist_yaw);

var wrist_roll = getprop("/fdm/jsbsim/systems/rms/ang-wrist-roll-deg");
setprop("/controls/shuttle/rms-ballistic/ang-wrist-roll-deg", wrist_roll);

rmsState = stateVector.new (rmsCoord.x(),rmsCoord.y(),rmsCoord.z(),0,0,0,yaw, pitch - lon, roll);

rmsModel = place_model("rms-ballistic", "Aircraft/SpaceShuttle/Models/PayloadBay/rmsArm-disconnected.xml", rmsCoord.lat(), rmsCoord.lon(), rmsCoord.alt() * m_to_ft, yaw,pitch,roll);

var lat = getprop("/position/latitude-deg") * math.pi/180.0;
var lon = getprop("/position/longitude-deg") * math.pi/180.0;
var dt = getprop("/sim/time/delta-sec");

var vxoffset = 3.5 * math.cos(lon) * math.pow(dt/0.05,3.0);
var vyoffset = 3.5 * math.sin(lon) * math.pow(dt/0.05,3.0);
var vzoffset = 0.0;



settimer(func { 
		rmsState.vx = getprop("/fdm/jsbsim/velocities/eci-x-fps") * ft_to_m + vxoffset;
		rmsState.vy = getprop("/fdm/jsbsim/velocities/eci-y-fps") * ft_to_m + vyoffset;
		rmsState.vz = getprop("/fdm/jsbsim/velocities/eci-z-fps") * ft_to_m + vzoffset;
		rms_loop_flag = 1;
		update_rms(0.0); },0);
}


var update_rms = func (delta_lon) {

var shuttleCoord = geo.aircraft_position();
var dt = getprop("/sim/time/delta-sec");# * getprop("/sim/speed-up");


delta_lon = delta_lon + dt * earth_rotation_deg_s * 1.004;

var F = get_force (rmsState, shuttleCoord);

rmsState.update(F[0], F[1], F[2], 0.0,0.0,0.0);
rmsCoord.set_xyz(rmsState.x, rmsState.y, rmsState.z);
rmsCoord.set_lon(rmsCoord.lon() - delta_lon);

if (rms_loop_flag < 3)
	{
	if (rms_loop_flag ==1)
		{
		offset_vec_rms = [rmsCoord.x()-shuttleCoord.x(), rmsCoord.y()-shuttleCoord.y(),rmsCoord.z()-shuttleCoord.z()];
		}
	if (rms_loop_flag == 2)
		{
		var offset1_vec = [rmsCoord.x()-shuttleCoord.x(), rmsCoord.y()-shuttleCoord.y(),rmsCoord.z()-shuttleCoord.z()];
		var v_offset_vec = [(offset1_vec[0] - offset_vec_rms[0]) / dt, (offset1_vec[1] - offset_vec_rms[1]) / dt, (offset1_vec[2] - offset_vec_rms[2]) / dt];

		rmsState = compute_state_correction  (rmsState, rmsCoord, shuttleCoord, v_offset_vec, delta_lon);

		}
	rms_loop_flag = rms_loop_flag + 1;


	}


set_coords("rms-ballistic", rmsCoord, rmsState);


var dist = shuttleCoord.distance_to(rmsCoord);

#print(dist);

if (dist > 5000.0) 
	{
	print ("RMS simulation ends");
	rmsModel.remove();
	rms_loop_flag = 0;
	}



if (rms_loop_flag >0 ) {settimer(func {update_rms(delta_lon); },0.0);}
}





###########################################################################
# class to manage ISS as numerical simulation at close range
#
###########################################################################

var iss_manager = {


	state: {},
	coord: {},
	shuttleCoord: {},
	dockingCollarCoord: {},	
	refCoord: {},
	issModel: {},
	issInitialState: [0,0,0,0,0,0],
	offset_vec: [0,0,0],

	bearing: 0.0,
	distance: 0.0,
	hdistance: 0.0,
	prox_x: 0.0,
	prox_y: 0.0,
	prox_z: 0.0,
	prox_vx: 0.0,
	prox_vy: 0.0,
	prox_vz: 0.0,
	prox_x_last: 0.0,
	prox_y_last: 0.0,
	prox_z_last: 0.0,
	distance_last: 0.0,
	rdot: 0.0,

	dt: 0.0,	
	delta_lon: 0.0,

	docking_collar_dist: 0.0,
	docking_collar_dist_last: 0.0,
	dcbearing: 0.0,
	dchdistance: 0.0,
	dcprox_x: 0.0,
	dcprox_y: 0.0,
	dcprox_z: 0.0,
	ddot: 0.0,
	y: 0.0, 
	y_last: 0.0,
	ydot: 0.0,
	theta: 0.0,

	crash_force_z: 0.0,

	loop_flag: 0,
	placement_flag: 0,
	sensor_flag: 0,
	proximity_request: 0,
	tracking_request: 0,


	init : func (prox_x, prox_y, prox_z, dvx, dvy, dvz)  {


		me.coord = geo.aircraft_position() ;
		me.coord.set_alt( me.coord.alt() - prox_z);

		var course = getprop("/fdm/jsbsim/velocities/course-deg");
		me.coord.apply_course_distance(course, prox_x);

		if (prox_y > 0) {course = course + 90.0;}
		else {course = course - 90.0;}
		me.coord.apply_course_distance(course, math.abs(prox_y));

		me.state = stateVector.new (me.coord.x(),me.coord.y(),me.coord.z(),0,0,0,  0.0, 0.0 , 0.0);
		me.state.lvlh_flag = 1;

		me.issInitialState = [prox_x, prox_y, prox_z, dvx, dvy, dvz];

		var model_path = "Aircraft/SpaceShuttle/Models/ISS/ISS_free.xml";

		me.issModel = place_model("ISS", model_path, me.coord.lat(), me.coord.lon(), me.coord.alt() * m_to_ft, course,0.0,0.0);


		var test_coord = geo.aircraft_position();
		print ("Distance at placement: ", test_coord.direct_distance_to(me.coord));

		var lat = getprop("/position/latitude-deg") * math.pi/180.0;
		var lon = getprop("/position/longitude-deg") * math.pi/180.0;
		var dt = getprop("/sim/time/delta-sec");

		var vxoffset = 3.5 * math.cos(lon) * math.pow(dt/0.05,3.0);
		var vyoffset = 3.5 * math.sin(lon) * math.pow(dt/0.05,3.0);
		var vzoffset = 0.0;


		me.delta_lon = 0.0;

		settimer(func { 
				me.state.vx = getprop("/fdm/jsbsim/velocities/eci-x-fps") * ft_to_m + vxoffset;
				me.state.vy = getprop("/fdm/jsbsim/velocities/eci-y-fps") * ft_to_m + vyoffset;
				me.state.vz = getprop("/fdm/jsbsim/velocities/eci-z-fps") * ft_to_m + vzoffset;
				me.loop_flag = 1;
				me.placement_flag = 1;
				me.update(); },0);
	},


	update: func () {

		me.shuttleCoord = geo.aircraft_position();
		me.dt = getprop("/sim/time/delta-sec");


		me.delta_lon = me.delta_lon + me.dt * earth_rotation_deg_s * 1.0039;

		var F = get_force (me.state, me.shuttleCoord);

		me.state.update(F[0], F[1], F[2], 0.0,0.0,0.0);
		me.coord.set_xyz(me.state.x, me.state.y, me.state.z);
		me.coord.set_lon(me.coord.lon() - me.delta_lon);


		if (me.loop_flag < 3)
			{
			me.manage_initial_placement();
			}

		set_coords("ISS", me.coord, me.state);

		me.compute_proximity();
		me.set_sensor_tracking();
		me.compute_relative_coordinates();

		if (me.proximity_request == 1) {me.provide_proximity();}
		if (me.sensor_flag == 1) {me.compute_sensor_data();}
		if (me.tracking_request == 1) {me.provide_tracking();}




		if (me.distance > 1.2 * SpaceShuttle.orbital_target_lod)  {me.unload();}
		if (me.docking_collar_dist < 3.0) {me.check_crash();}
			else {me.unset_crash();	}	
		if (me.docking_collar_dist < 0.4) {me.dock();}


		if (me.loop_flag >0 ) 
			{
			settimer(func {me.update(); },0.0);
			}



	},

	compute_proximity: func {

		if (me.distance > 10.0)
			{
			me.refCoord = geo.Coord.new(me.shuttleCoord);
			}
		else
			{
			me.compute_docking_collar();
			me.refCoord = geo.Coord.new(me.dockingCollarCoord);
			}

		me.bearing = me.refCoord.course_to(me.coord);
		me.hdistance = me.refCoord.distance_to(me.coord);
		me.distance = me.refCoord.direct_distance_to(me.coord);
		me.prox_z = me.refCoord.alt() - me.coord.alt();
		var ground_course = getprop("/fdm/jsbsim/velocities/course-deg");
		me.prox_x = me.hdistance * math.cos((me.bearing - ground_course) * math.pi/180.0);
		me.prox_y = me.hdistance * math.sin((me.bearing - ground_course) * math.pi/180.0);

		me.prox_vx = (me.prox_x - me.prox_x_last)/me.dt;
		me.prox_vy = (me.prox_y - me.prox_y_last)/me.dt;
		me.prox_vz = (me.prox_z - me.prox_z_last)/me.dt;

		me.rdot = (me.distance - me.distance_last)/me.dt;

		me.prox_x_last = me.prox_x;
		me.prox_y_last = me.prox_y;
		me.prox_z_last = me.prox_z;

		me.distance_last = me.distance;


	},	

	list_proximity: func {

		print ("ISS proximity coordinates: ");
		print ("x: ", me.prox_x);
		print ("y: ", me.prox_y);
		print ("z: ", me.prox_z);
		print ("r: ", me.distance);

	},

	list_proximity_v: func {

		print ("ISS proximity velocities: ");
		print ("vx: ", me.prox_vx);
		print ("vy: ", me.prox_vy);
		print ("vz: ", me.prox_vz);
		print ("vr: ", me.rdot);

	},

	provide_proximity: func {

		if (me.distance > 10.0)
			{
			SpaceShuttle.proximity_manager.target_prox_x = me.prox_x;
			SpaceShuttle.proximity_manager.target_prox_y = me.prox_y;
			SpaceShuttle.proximity_manager.target_prox_z = me.prox_z;
			}
		else	
			{
			SpaceShuttle.proximity_manager.target_prox_x = me.dcprox_x;
			SpaceShuttle.proximity_manager.target_prox_y = me.dcprox_y;
			SpaceShuttle.proximity_manager.target_prox_z = me.dcprox_z;
			}

		SpaceShuttle.proximity_manager.target_prox_vx = me.prox_vx;
		SpaceShuttle.proximity_manager.target_prox_vy = me.prox_vy;
		SpaceShuttle.proximity_manager.target_prox_vz = me.prox_vz;

		me.proximity_request = 0;

	},

	request_proximity: func {
		
		me.proximity_request = 1;

	},

	
	provide_tracking: func {

		# provides tracking vectors for UNIV PTG


		var shuttle_pos_inertial = geo.Coord.new(me.shuttleCoord);
		var tgt_pos_inertial = geo.Coord.new(me.coord);

		# go to inertial coordinates

		var angle = -getprop("/fdm/jsbsim/systems/pointing/inertial/ecf-to-eci-rad-alt") * 180.0/math.pi;


		shuttle_pos_inertial.set_lon(shuttle_pos_inertial.lon() - angle);
		tgt_pos_inertial.set_lon(tgt_pos_inertial.lon() - angle);

		# pointing vector  in inertial coordinates

		var shuttle_inertial = shuttle_pos_inertial.xyz();
		var tgt_inertial = tgt_pos_inertial.xyz();

		var pointer = SpaceShuttle.normalize(SpaceShuttle.subtract_vector(tgt_inertial, shuttle_inertial));


		setprop("/fdm/jsbsim/systems/ap/track/target-vector[0]", pointer[0]);
		setprop("/fdm/jsbsim/systems/ap/track/target-vector[1]", pointer[1]);
		setprop("/fdm/jsbsim/systems/ap/track/target-vector[2]", pointer[2]);

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

		var second = SpaceShuttle.orthonormalize(pointer, [0.0, 0.0, 1.0]);

		setprop("/fdm/jsbsim/systems/ap/track/target-sec[0]", second[0]);
		setprop("/fdm/jsbsim/systems/ap/track/target-sec[1]", second[1]);
		setprop("/fdm/jsbsim/systems/ap/track/target-sec[2]", second[2]);

		var third = SpaceShuttle.cross_product(pointer, second);

		setprop("/fdm/jsbsim/systems/ap/track/target-trd[0]", third[0]);
		setprop("/fdm/jsbsim/systems/ap/track/target-trd[1]", third[1]);
		setprop("/fdm/jsbsim/systems/ap/track/target-trd[2]", third[2]);


		me.tracking_request = 0;

	},


	request_tracking: func {

		me.tracking_request = 1;

	},

	
	set_sensor_tracking: func {


		if (SpaceShuttle.antenna_manager.function == "RDR PASSIVE") 
			{



			SpaceShuttle.antenna_manager.set_rr_target(me.coord);
			if ((SpaceShuttle.antenna_manager.rr_target_available == 1) and (SpaceShuttle.antenna_manager.rvdz_data == 1))
				{
				SpaceShuttle.antenna_manager.ku_antenna_track_target(me.coord, me.shuttleCoord);
				}		
			}
		if (SpaceShuttle.star_tracker_array[0].mode == 2)
			{
			SpaceShuttle.star_tracker_array[0].set_target(me.coord);
			}

		if (SpaceShuttle.star_tracker_array[1].mode == 2)
			{
			SpaceShuttle.star_tracker_array[1].set_target(me.coord);
			}

	},

	compute_tracking: func {


	},

	compute_docking_collar: func {


		var shuttleWorldX = [getprop("/fdm/jsbsim/systems/pointing/world/body-x"), getprop("/fdm/jsbsim/systems/pointing/world/body-x[1]"), getprop("/fdm/jsbsim/systems/pointing/world/body-x[2]")];

		var shuttleWorldZ = [getprop("/fdm/jsbsim/systems/pointing/world/body-z"), getprop("/fdm/jsbsim/systems/pointing/world/body-z[1]"), getprop("/fdm/jsbsim/systems/pointing/world/body-z[2]")];


		var dockingCollarOffset = SpaceShuttle.add_vector(SpaceShuttle.scalar_product(8.1, shuttleWorldX), SpaceShuttle.scalar_product(-1.0, shuttleWorldZ));

		me.dockingCollarCoord = geo.Coord.new(me.shuttleCoord);

		me.dockingCollarCoord.set_xyz (me.shuttleCoord.x() + dockingCollarOffset[0],me.shuttleCoord.y() + dockingCollarOffset[1],me.shuttleCoord.z() + dockingCollarOffset[2]);

	},


	compute_relative_coordinates: func {




		var shuttleLVLHZ = [-getprop("/fdm/jsbsim/systems/pointing/lvlh/body-z"), -getprop("/fdm/jsbsim/systems/pointing/lvlh/body-z[1]"), -getprop("/fdm/jsbsim/systems/pointing/lvlh/body-z[2]")];

		me.compute_docking_collar();


		me.docking_collar_dist = me.dockingCollarCoord.direct_distance_to(me.coord);
		me.ddot = (me.docking_collar_dist - me.docking_collar_dist_last)/me.dt;
		me.docking_collar_dist_last = me.docking_collar_dist;

		me.dcbearing = me.dockingCollarCoord.course_to(me.coord);
		me.dchdistance = me.dockingCollarCoord.distance_to(me.coord);
		me.dcprox_z = me.dockingCollarCoord.alt() - me.coord.alt();
		var ground_course = getprop("/fdm/jsbsim/velocities/course-deg");
		me.dcprox_x = me.dchdistance * math.cos((me.dcbearing - ground_course) * math.pi/180.0);
		me.dcprox_y = me.dchdistance * math.sin((me.dcbearing - ground_course) * math.pi/180.0);


		setprop("/fdm/jsbsim/systems/rendezvous/target/distance-m", me.docking_collar_dist);
		setprop("/fdm/jsbsim/systems/rendezvous/target/ddot-m_s", me.ddot);

		var iss_roll = getprop("/controls/shuttle/ISS/roll-deg");
		var iss_pitch = getprop("/controls/shuttle/ISS/pitch-deg");
		var iss_yaw = getprop("/controls/shuttle/ISS/heading-deg");

		var y_vec = orientTaitBryan([0.0, 0.0,-1.0], iss_yaw, iss_pitch, iss_roll);

		var lat_to_m = 110952.0;
		var lon_to_m  = math.cos(me.coord.lat()*math.pi/180.0) * lat_to_m;

		var x_lvlh = (me.coord.lon() - me.dockingCollarCoord.lon()) * lon_to_m;
		var y_lvlh = (me.coord.lat() - me.dockingCollarCoord.lat()) * lat_to_m;
		var z_lvlh = (me.coord.alt() - me.dockingCollarCoord.alt());

		var rel_vec = [x_lvlh, y_lvlh, z_lvlh];


		me.y = -SpaceShuttle.dot_product(y_vec, rel_vec);
		me.ydot = (me.y - me.y_last)/me.dt;
		me.y_last = me.y;
		me.theta = 180.0/math.pi * math.acos(SpaceShuttle.dot_product(y_vec, shuttleLVLHZ));

		setprop("/fdm/jsbsim/systems/rendezvous/target/Y-m",me.y);
		setprop("/fdm/jsbsim/systems/rendezvous/target/Ydot-m_s",me.ydot);
		setprop("/fdm/jsbsim/systems/rendezvous/target/theta",me.theta);


		setprop("/fdm/jsbsim/systems/rendezvous/target/distance-prop-m", me.docking_collar_dist);
		setprop("/fdm/jsbsim/systems/rendezvous/target/ddot-prop-m_s", me.ddot);
		setprop("/fdm/jsbsim/systems/rendezvous/target/Y-prop-m",me.y);
		setprop("/fdm/jsbsim/systems/rendezvous/target/Ydot-prop-m_s",me.ydot);
		setprop("/fdm/jsbsim/systems/rendezvous/target/theta-prop",me.theta);
	},


	check_crash: func {


		if (me.y < 0.0)
			{
			me.crash_force_z = -me.y * 10000.0;
			}
		else 
			{
			me.crash_force_z = 0.0;
			}
		setprop("/fdm/jsbsim/systems/docking/crash-force-z", me.crash_force_z);		


	},

	unset_crash: func {

		if (me.crash_force_z == 0.0) {return;}
		else
			{
			me.crash_force_z = 0.0;
			setprop("/fdm/jsbsim/systems/docking/crash-force-z", 0.0);	
			}

	},


	unload: func {

		print ("ISS explicit simulation ends");
		me.issModel.remove();
		me.loop_flag = 0;
		proximity_manager.iss_model = 0;
	},


	manage_initial_placement: func {

		if (me.loop_flag ==1)
			{
			me.offset_vec = [me.coord.x()-me.shuttleCoord.x(), me.coord.y()-me.shuttleCoord.y(),me.coord.z()-me.shuttleCoord.z()];
			}
		if (me.loop_flag == 2)
			{
			var offset1_vec = [me.coord.x()-me.shuttleCoord.x(), me.coord.y()-me.shuttleCoord.y(),me.coord.z()-me.shuttleCoord.z()];
			var v_offset_vec = [(offset1_vec[0] - me.offset_vec[0]) / me.dt, (offset1_vec[1] - me.offset_vec[1]) / me.dt, (offset1_vec[2] - me.offset_vec[2]) / me.dt];
		


			me.state = compute_state_correction  (me.state, me.coord, me.shuttleCoord, v_offset_vec, me.delta_lon);
			if (me.placement_flag == 1)
				{
				var iss_placement = geo.Coord.new();
				iss_placement.set_xyz (me.state.x, me.state.y, me.state.z);

				var prox_x = me.issInitialState[0];
				var prox_y = me.issInitialState[1];
				var prox_z = me.issInitialState[2];	

				print ("Coordinate differences proximity:");
				print (prox_x, " ", prox_y, " ", prox_z);		

				print ("ISS alt2 before: ", iss_placement.alt(), " prox_z: ", prox_z); 
			
				iss_placement.set_alt( me.coord.alt() - prox_z);

				var course = getprop("/fdm/jsbsim/velocities/course-deg");
				iss_placement.apply_course_distance(course, prox_x);

				if (prox_y > 0) {course = course + 90.0;}
				else {course = course - 90.0;}
				iss_placement.apply_course_distance(course, math.abs(prox_y));
			
				print ("ISS alt2 aft: ", iss_placement.alt()); 


				me.state.x = iss_placement.x();
				me.state.y = iss_placement.y();
				me.state.z = iss_placement.z();


				me.state.vx+= me.issInitialState[3];
				me.state.vy+= me.issInitialState[4];
				me.state.vz+= me.issInitialState[5];

				# need a distance-dependent down

				var norm_tmp = math.sqrt(me.state.x * me.state.x + me.state.y * me.state.y + me.state.z * me.state.z);
				var down = [-me.state.x/norm_tmp, -me.state.y/norm_tmp, -me.state.z/norm_tmp];

				var hdist = prox_x; #math.sqrt(prox_x * prox_x + prox_z * prox_z);


				me.state.vx += down[0]*6.0 * hdist/5000.0 * 0.96;
				me.state.vy += down[1]*6.0 * hdist/5000.0 * 0.96;
				me.state.vz += down[2]*6.0 * hdist/5000.0 * 0.96;


				}
			else if (me.placement_flag == 2)
				{
				var iss_placement = geo.Coord.new();
				iss_placement.set_xyz (me.state.x, me.state.y, me.state.z);

				var shuttleWorldX = [getprop("/fdm/jsbsim/systems/pointing/world/body-x"), getprop("/fdm/jsbsim/systems/pointing/world/body-x[1]"), getprop("/fdm/jsbsim/systems/pointing/world/body-x[2]")];

				var shuttleWorldZ = [getprop("/fdm/jsbsim/systems/pointing/world/body-z"), getprop("/fdm/jsbsim/systems/pointing/world/body-z[1]"), getprop("/fdm/jsbsim/systems/pointing/world/body-z[2]")];

				var shuttleLVLHZ = [-getprop("/fdm/jsbsim/systems/pointing/lvlh/body-z"), -getprop("/fdm/jsbsim/systems/pointing/lvlh/body-z[1]"), -getprop("/fdm/jsbsim/systems/pointing/lvlh/body-z[2]")];

				var dockingCollarOffset = SpaceShuttle.add_vector(SpaceShuttle.scalar_product(-8.1, shuttleWorldX), SpaceShuttle.scalar_product(1.0, shuttleWorldZ));

				iss_placement.set_x( iss_placement.x() - dockingCollarOffset[0]); 
				iss_placement.set_y( iss_placement.y() - dockingCollarOffset[1]); 
				iss_placement.set_z( iss_placement.z() - dockingCollarOffset[2]); 

				me.state.x = iss_placement.x();
				me.state.y = iss_placement.y();
				me.state.z = iss_placement.z();
				}
				}
		me.loop_flag = me.loop_flag + 1;
			




		},


	dock: func {


		if ((getprop("/controls/shuttle/ISS/docking-veto") == 0) and (me.theta < 15.0))
			{
			setprop("/sim/messages/copilot", "Successful ISS docking!");

			setprop("/controls/shuttle/ISS/docking-flag", 1);
			setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[6]", 924740.0);
			controls.centerFlightControls();

			me.prox_x = 0.0;
			me.prox_y = 0.0;
			me.prox_z = 0.0;
		
			me.prox_vx = 0.0;
			me.prox_vy = 0.0;
			me.prox_vz = 0.0;

			me.distance = 0.0;
			me.distance_last = 0.0;

			me.delta_lon  = 0.0;

			SpaceShuttle.orbital_dap_manager.control_select("FREE");
			me.issModel.remove();
			me.loop_flag = 0;

			var iss_roll = getprop("/controls/shuttle/ISS/roll-deg");
			var iss_pitch = getprop("/controls/shuttle/ISS/pitch-deg");
			var iss_yaw = getprop("/controls/shuttle/ISS/heading-deg");

			var x1_vec = orientTaitBryan([1.0, 0.0,0.0], iss_yaw, iss_pitch, iss_roll);
			var x2_vec = orientTaitBryan([0.0, 1.0, 0.0], iss_yaw, iss_pitch, iss_roll);

			var shuttleLVLHX = [getprop("/fdm/jsbsim/systems/pointing/lvlh/body-x"), getprop("/fdm/jsbsim/systems/pointing/lvlh/body-x[1]"), getprop("/fdm/jsbsim/systems/pointing/lvlh/body-x[2]")];

			var shuttleLVLHY = [getprop("/fdm/jsbsim/systems/pointing/lvlh/body-y"), getprop("/fdm/jsbsim/systems/pointing/lvlh/body-y[1]"), getprop("/fdm/jsbsim/systems/pointing/lvlh/body-y[2]")];

			var omega = 180/math.pi * math.acos(SpaceShuttle.dot_product(shuttleLVLHX, x1_vec));
		
			if (SpaceShuttle.dot_product(shuttleLVLHY, x2_vec) < 0.0)
				{
				omega = - omega;
				}
			setprop("/controls/shuttle/ISS/rel-heading-deg", -omega); 
			}


		},

	undock: func {



		setprop("/controls/shuttle/ISS/docking-flag", 0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[6]", 0.0);
		
		SpaceShuttle.orbital_dap_manager.control_select("INRTL");

		# prevent immediate triggering of the docking condition
		setprop("/controls/shuttle/ISS/docking-veto", 1);
		settimer (func { setprop("/controls/shuttle/ISS/docking-veto", 0);}, 10.0);

		var pitch = getprop("/orientation/pitch-deg");
		var yaw = getprop("/orientation/heading-deg");
		var roll = getprop("/orientation/roll-deg");
		var lon_deg = getprop("/position/longitude-deg");

		me.delta_lon  = 0.0;
		me.coord = geo.aircraft_position();

		# correct for docking collar position

		var shuttleWorldX = [getprop("/fdm/jsbsim/systems/pointing/world/body-x"), getprop("/fdm/jsbsim/systems/pointing/world/body-x[1]"), getprop("/fdm/jsbsim/systems/pointing/world/body-x[2]")];

		var shuttleWorldZ = [getprop("/fdm/jsbsim/systems/pointing/world/body-z"), getprop("/fdm/jsbsim/systems/pointing/world/body-z[1]"), getprop("/fdm/jsbsim/systems/pointing/world/body-z[2]")];

		var shuttleLVLHZ = [-getprop("/fdm/jsbsim/systems/pointing/lvlh/body-z"), -getprop("/fdm/jsbsim/systems/pointing/lvlh/body-z[1]"), -getprop("/fdm/jsbsim/systems/pointing/lvlh/body-z[2]")];

		var dockingCollarOffset = SpaceShuttle.add_vector(SpaceShuttle.scalar_product(8.1, shuttleWorldX), SpaceShuttle.scalar_product(-1.0, shuttleWorldZ));

		me.coord.set_x( me.coord.x() - dockingCollarOffset[0]); 
		me.coord.set_y( me.coord.y() - dockingCollarOffset[1]); 
		me.coord.set_z( me.coord.z() - dockingCollarOffset[2]); 

		me.state = stateVector.new (me.coord.x(),me.coord.y(),me.coord.z(),0,0,0, yaw, pitch - lon_deg , roll);



		var model_path = "Aircraft/SpaceShuttle/Models/ISS/ISS_free.xml";

		me.issModel = place_model("ISS", model_path, me.coord.lat(), me.coord.lon(), me.coord.alt() * m_to_ft, yaw,pitch -lon_deg,roll);

		var test_coord = geo.aircraft_position();
		print ("Distance at placement: ", test_coord.direct_distance_to(me.coord));



		var lat = getprop("/position/latitude-deg") * math.pi/180.0;
		var lon = lon_deg * math.pi/180.0;
		var dt = getprop("/sim/time/delta-sec");

		var vxoffset = 3.5 * math.cos(lon) * math.pow(dt/0.05,3.0);
		var vyoffset = 3.5 * math.sin(lon) * math.pow(dt/0.05,3.0);
		var vzoffset = 0.0;

		SpaceShuttle.proximity_manager.iss_model = 1;


		# now we push the the orbiter away 

		setprop("/fdm/jsbsim/systems/fcs/control-mode",28);
		setprop("/controls/flight/elevator", -1.0);


		settimer( func{
			controls.centerFlightControls();
			SpaceShuttle.control_to_rcs();
			}, 3.0);


		settimer(func { 
				me.state.vx = getprop("/fdm/jsbsim/velocities/eci-x-fps") * ft_to_m + vxoffset;
				me.state.vy = getprop("/fdm/jsbsim/velocities/eci-y-fps") * ft_to_m + vyoffset;
				me.state.vz = getprop("/fdm/jsbsim/velocities/eci-z-fps") * ft_to_m + vzoffset;
				me.placement_flag = 2;
				me.loop_flag = 1;
				me.update(); },0);

		},






};


var undock_iss = func  {


if (getprop("/controls/shuttle/ISS/docking-flag") == 0)
	{return;}

iss_manager.undock();
}


###########################################################################
# class to manage the handover between orbital object as coordinate positions
# and numerical simulations
# as well as sensor readings 
###########################################################################



var proximity_manager = {

	shuttle_pos: [0.0, 0.0, 0.0],
	shuttle_vel: [0.0, 0.0, 0.0],
	delta_v: [0.0, 0.0, 0.0],
	tgt_pos: [0.0, 0.0, 0.0],
	tgt_vel: [0.0, 0.0, 0.0],
	distance: 0.0,
	distance_last: 0.0,
	distance_prop: 0.0,
	distance_error: 0.0,
	distance_filtered: 0.0,
	distance_error_filtered: 0.0,
	distance_cand: 0.0,
	distance_error_cand: 0.0,
	distance_sensed: 0.0,

	timestamp: -0.1,
	time: 0.0,
	ddot: 0.0,
	ddot_last: 0.0,
	ddot_strikes: 0,
	iss_model: 0,

	target_prox_x: 0.0,
	target_prox_y: 0.0,
	target_prox_z: 0.0,

	target_prox_vx: 0.0,
	target_prox_vy: 0.0,
	target_prox_vz: 0.0,
	
	tpnorm: [0.0, 0.0, 0.0],
	pnorm: [0.0, 0.0, 0.0],
	vnorm: [0.0, 0.0, 0.0],
	tvnorm: [0.0, 0.0, 0.0],
	nnorm: [0.0, 0.0, 0.0],
	tnnorm: [0.0, 0.0, 0.0],

	perfect_navigation: 0,

	error_x: 0.0,
	error_y: 0.0,
	error_z: 0.0,

	error_amp_x: 0.0,
	error_amp_y: 0.0,
	error_amp_z: 0.0,

	error_x_filtered: 0.0,
	error_y_filtered: 0.0,
	error_z_filtered: 0.0,

	error_x_cand: 0.0,
	error_y_cand: 0.0,
	error_z_cand: 0.0,

	update_x: 0.0,
	update_y: 0.0,
	update_z: 0.0,
	update_rdot: 0.0,

	error_d_factor: 0.0,
	error_d_rr: 0.0,
	error_rdot: 0.0,
	error_rdot_cand: 0.0,
	error_rdot_filtered: 0.0,

	angle_sensor_selection: 0,
	sv_selection: 0,
	rel_nav_enable: 0,

	rng_ratio: 0.0,
	rng_resid: 0.0,
	rng_aut: 0,
	rng_inh: 1,
	rng_for: 0,

	rdot_ratio: 0.0,
	rdot_resid: 0.0,
	rdot_aut: 0,
	rdot_inh: 1,
	rdot_for: 0,

	y_ratio: 0.0,
	y_resid: 0.0,
	y_aut: 0,
	y_inh: 1,
	y_for: 0,

	z_ratio: 0.0,
	z_resid: 0.0,

	gps_p_ratio: 0.0,
	gps_p_resid: 0.0,
	gps_v_ratio: 0.0,
	gps_v_resid: 0.0,
	gps_aut: 0,
	gps_inh: 1,
	gps_for: 0,

	rr_data_good: 0,
	ang_data_good: 0,

	
	r: 0.0,
	rt: 0.0,
	v: 0.0,
	vt: 0.0,

	history_available: 0,
	history_counter: 0,
	history_reset: 0,
	prox_history: [],
	plot_scale: 500,


	node_crossing_time: 0,
	node_crossing_time_string: "",
	node_crossing_time_string_short: "",
	node_crossing_burn_time: 0,
	node_crossing_burn_time_string: "",	
	node_crossing_burn_time_string_short: "",	
	node_crossing_counter: 0,
	node_crossing_check_veto: 0,	
	node_crossing_dy: 0,

	shuttleCoord: {},
	tgtCoord: {},


	init: func {


   		me.nd_ref_true_anomaly = props.globals.getNode("/fdm/jsbsim/systems/orbital/true-anomaly-rad", 1);
   		me.nd_ref_orbital_period = props.globals.getNode("/fdm/jsbsim/systems/orbital/orbital-period-s", 1);
		me.nd_ref_trafo_angle = props.globals.getNode("/fdm/jsbsim/systems/pointing/inertial/ecf-to-eci-rad-alt", 1);

		me.error_init();

	},


	check_distance: func {

		if (SpaceShuttle.n_orbital_targets == 0) {return;} 

		me.shuttle_pos[0] = getprop("/fdm/jsbsim/position/eci-x-ft") * 0.3048;
		me.shuttle_pos[1] = getprop("/fdm/jsbsim/position/eci-y-ft") * 0.3048;
		me.shuttle_pos[2] = getprop("/fdm/jsbsim/position/eci-z-ft") * 0.3048;

		me.tgt_pos = SpaceShuttle.oTgt.get_inertial_pos();


		var difference = SpaceShuttle.subtract_vector(me.shuttle_pos, me.tgt_pos);

		me.distance = SpaceShuttle.norm(difference);

		
		#print ("Distance to ISS: ", me.distance);



		var met = SpaceShuttle.get_MET();
		if ((met > me.node_crossing_time) and (me.node_crossing_check_veto == 0))
			{
			me.node_crossing_check_veto = 1;
			me.force_node_check();
			settimer (func {me.node_crossing_check_veto = 0;}, 10.0);
			}


		if (getprop("/controls/shuttle/ISS/docking-flag") == 1)
			{
			me.iss_model = 1;
			}


		if ((me.distance <  SpaceShuttle.orbital_target_lod) or (me.iss_model == 1))
			{
			#me.do_history();
			me.history_available = 0;
			}
		else if (me.distance < 100000.0)
			{
			me.do_history();
			me.set_sensor_tracking();
			me.history_available = 1;
			me.plot_scale = 100;
			}
		else if (me.distance < 500000.0)
			{
			me.do_history();
			me.history_available = 1;
			me.plot_scale = 500;
			}
		else
			{
			me.plot_scale = 500;
			me.history_available = 0;
			}

		if (me.history_reset == 1)
			{
			me.compute_proximity();
			#print ("Resetting history!");
			
			setsize(me.prox_history, 0);
			for (var i = 0; i< 60; i=i+1)
				{
				append(me.prox_history, [me.target_prox_x, me.target_prox_z]);
				}
			me.history_reset = 0;
		
			}


		if ((me.distance <  SpaceShuttle.orbital_target_lod) and (me.iss_model == 0)) 
			{
			me.compute_proximity();
			me.compute_vdiff();
			
			SpaceShuttle.iss_manager.init(me.target_prox_x, me.target_prox_y, me.target_prox_z, me.delta_v[0],me.delta_v[1],me.delta_v[2]);
			me.iss_model = 1;
			print ("Placing ISS model!");
			}
		else if (me.iss_model == 1)
			{
			SpaceShuttle.iss_manager.request_proximity();
			me.distance = math.sqrt(math.pow(me.target_prox_x,2.0) + math.pow(me.target_prox_y,2.0) + math.pow(me.target_prox_z,2.0));

			# propagated distance and error
			me.distance_prop = math.sqrt(math.pow((me.target_prox_x + me.error_x),2.0) + math.pow((me.target_prox_y + me.error_y),2.0) + math.pow((me.target_prox_z + me.error_z),2.0));
			me.distance_error = me.distance_prop - me.distance;

			# filtered distance candidate and error
			me.distance_cand = math.sqrt(math.pow((me.target_prox_x + me.error_x_cand),2.0) + math.pow((me.target_prox_y + me.error_y_cand),2.0) + math.pow((me.target_prox_z + me.error_z_cand),2.0));
			me.distance_error_cand = me.distance_cand - me.distance;

			me.distance_filtered = math.sqrt(math.pow((me.target_prox_x + me.error_x_filtered),2.0) + math.pow((me.target_prox_y + me.error_y_filtered),2.0) + math.pow((me.target_prox_z + me.error_z_filtered),2.0));
			me.distance_error_filtered = me.distance_filtered - me.distance;

			me.distance_sensed = me.distance + me.error_d_rr;



			if (me.distance < 20.0) 
				{me.plot_scale = 0.01;} 
			else {me.plot_scale = 10;}
			}

		# compute ddot from the distance measure we've used, either to coordinate pos or full 3d model

		me.time = getprop("/sim/time/elapsed-sec");
		me.ddot = (me.distance - me.distance_last)/ (me.time - me.timestamp);

		# filter out jitter
		if ((math.abs(me.ddot_last - me.ddot) > 50.0) and (me.ddot_strikes < 3))
			{
			me.ddot = me.ddot_last;	
			me.ddot_strikes += 1;
			}		
		else
			{
			me.ddot_last = me.ddot;
			me.ddot_strikes = 0;
			}

		me.timestamp = me.time;
		me.distance_last = me.distance;

		me.check_node();

		if (me.rel_nav_enable == 1)
			{
			me.error_propagate();
			me.error_filter();
			}


	},

	do_history: func {

		if ((me.history_counter == 0) and (me.history_available == 0))
			{

			me.compute_proximity();
			#print ("History init!");

			# propagated distance
			me.distance_prop = math.sqrt(math.pow((me.target_prox_x + me.error_x),2.0) + math.pow((me.target_prox_y + me.error_y),2.0) + math.pow((me.target_prox_z + me.error_z),2.0));
			me.distance_error = me.distance_prop - me.distance;

			# filtered distance candidate and error
			me.distance_cand = math.sqrt(math.pow((me.target_prox_x + me.error_x_cand),2.0) + math.pow((me.target_prox_y + me.error_y_cand),2.0) + math.pow((me.target_prox_z + me.error_z_cand),2.0));
			me.distance_error_cand = me.distance_cand - me.distance;

			me.distance_filtered = math.sqrt(math.pow((me.target_prox_x + me.error_x_filtered),2.0) + math.pow((me.target_prox_y + me.error_y_filtered),2.0) + math.pow((me.target_prox_z + me.error_z_filtered),2.0));
			me.distance_error_filtered = me.distance_filtered - me.distance;

			me.distance_sensed = me.distance + me.error_d_rr;

			setsize(me.prox_history, 0);
			for (var i = 0; i< 60; i=i+1)
				{
				append(me.prox_history, [me.target_prox_x, me.target_prox_z]);
				}
			me.history_available = 1;
			}
		else if ((me.history_counter == 0) and (me.history_available == 1))
			{
			me.compute_proximity();

			# propagated distance

			me.distance_prop = math.sqrt(math.pow((me.target_prox_x + me.error_x),2.0) + math.pow((me.target_prox_y + me.error_y),2.0) + math.pow((me.target_prox_z + me.error_z),2.0));
			me.distance_error = me.distance_prop - me.distance;

			# filtered distance candidate and error
			me.distance_cand = math.sqrt(math.pow((me.target_prox_x + me.error_x_cand),2.0) + math.pow((me.target_prox_y + me.error_y_cand),2.0) + math.pow((me.target_prox_z + me.error_z_cand),2.0));
			me.distance_error_cand = me.distance_cand - me.distance;

			me.distance_filtered = math.sqrt(math.pow((me.target_prox_x + me.error_x_filtered),2.0) + math.pow((me.target_prox_y + me.error_y_filtered),2.0) + math.pow((me.target_prox_z + me.error_z_filtered),2.0));
			me.distance_error_filtered = me.distance_filtered - me.distance;

			me.distance_sensed = me.distance + me.error_d_rr;

			#print ("x: ", me.target_prox_x, " y:", me.target_prox_z);
			me.prox_history = SpaceShuttle.delete_from_vector(me.prox_history,0);
			append(me.prox_history, [me.target_prox_x, me.target_prox_z]);
			}

		var h_interval = 60;
		if (me.plot_scale == 500)
			{
			h_interval = 180.0;
			}


		me.history_counter +=1;
		if (me.history_counter > (h_interval-1) ) {me.history_counter = 0;}

	},


	check_node: func {

		if (SpaceShuttle.lambert_manager.pa_ready == 1)
			{

			me.node_crossing_time = SpaceShuttle.lambert_manager.pa_time;
			me.node_crossing_burn_time = SpaceShuttle.lambert_manager.pa_tig;

			me.node_crossing_time_string = SpaceShuttle.seconds_to_stringDHMS(me.node_crossing_time);
			me.node_crossing_burn_time_string = SpaceShuttle.seconds_to_stringDHMS(me.node_crossing_burn_time);
			
			me.node_crossing_time_string_short = substr(me.node_crossing_time_string, 4);
			me.node_crossing_burn_time_string_short = substr(me.node_crossing_burn_time_string, 4);
			
			me.node_crossing_dy = SpaceShuttle.lambert_manager.pa_dvy;

			SpaceShuttle.lambert_manager.pa_ready = 0;
			}


		if (me.node_crossing_counter == 0)
			{
			SpaceShuttle.lambert_manager.pa_search_init();
			}
		
		me.node_crossing_counter +=1;
		if (me.node_crossing_counter == 300)
			{
			me.node_crossing_counter = 0;
			}

	},

	force_node_check: func {

			me.node_crossing_counter = 0;

	},

	compute_proximity: func {

		me.shuttle_vel[0] = getprop("/fdm/jsbsim/velocities/eci-x-fps") * 0.3048;
		me.shuttle_vel[1] = getprop("/fdm/jsbsim/velocities/eci-y-fps") * 0.3048;
		me.shuttle_vel[2] = getprop("/fdm/jsbsim/velocities/eci-z-fps") * 0.3048;

		me.v = SpaceShuttle.norm(me.shuttle_vel);
		me.vnorm[0] = me.shuttle_vel[0] / me.v;
		me.vnorm[1] = me.shuttle_vel[1] / me.v;
		me.vnorm[2] = me.shuttle_vel[2] / me.v;

		me.r = SpaceShuttle.norm(me.shuttle_pos);
		me.pnorm[0] = me.shuttle_pos[0]/me.r;
		me.pnorm[1] = me.shuttle_pos[1]/me.r;
		me.pnorm[2] = me.shuttle_pos[2]/me.r;
		
		me.nnorm = SpaceShuttle.cross_product(me.pnorm, me.vnorm);

		me.rt = SpaceShuttle.norm(me.tgt_pos);
		me.tpnorm[0] = me.tgt_pos[0]/me.rt;
		me.tpnorm[1] = me.tgt_pos[1]/me.rt;
		me.tpnorm[2] = me.tgt_pos[2]/me.rt;

		me.tgt_vel = SpaceShuttle.oTgt.get_inertial_speed();

		me.vt = SpaceShuttle.norm(me.tgt_vel);
		me.tvnorm[0] = me.tgt_vel[0]/me.vt;
		me.tvnorm[1] = me.tgt_vel[1]/me.vt;
		me.tvnorm[2] = me.tgt_vel[2]/me.vt;

		me.tnnorm = SpaceShuttle.cross_product(me.tpnorm, me.tvnorm);


		var ang_xt = 0.5 * math.pi - math.acos(SpaceShuttle.dot_product(me.tpnorm, me.nnorm));
		var delta_ang = math.acos(SpaceShuttle.dot_product(me.pnorm, me.tpnorm));
	
		var ang = math.acos(math.cos(delta_ang) / math.cos(ang_xt));
		var sign = 1.0;
		
		if (((me.tgt_pos[0] - me.shuttle_pos[0]) * me.vnorm[0] + (me.tgt_pos[1] - me.shuttle_pos[1]) * me.vnorm[1] + (me.tgt_pos[2] - me.shuttle_pos[2]) * me.vnorm[2]) < 0.0)
			{
			sign = -1.0;
			}

		me.target_prox_x = sign * ang * me.r;
		me.target_prox_y = -ang_xt * me.r;
		me.target_prox_z = me.r - me.rt;

		me.tgt_vel = SpaceShuttle.oTgt.get_inertial_speed();


		me.target_prox_vx = me.tgt_vel[0] * me.tvnorm[0] - me.shuttle_vel[0] * me.vnorm[0];
		me.target_prox_vx += me.tgt_vel[1] * me.tvnorm[1] - me.shuttle_vel[1] * me.vnorm[1];
		me.target_prox_vx += me.tgt_vel[2] * me.tvnorm[2] - me.shuttle_vel[2] * me.vnorm[2];

		me.target_prox_vy = me.tgt_vel[0] * me.nnorm[0] - me.shuttle_vel[0] * me.nnorm[0];
		me.target_prox_vy += me.tgt_vel[1] * me.nnorm[1] - me.shuttle_vel[1] * me.nnorm[1];
		me.target_prox_vy += me.tgt_vel[2] * me.nnorm[2] - me.shuttle_vel[2] * me.nnorm[2];

		me.target_prox_vz = me.tgt_vel[0] * me.tpnorm[0] - me.shuttle_vel[0] * me.pnorm[0];
		me.target_prox_vz += me.tgt_vel[1] * me.tpnorm[1] - me.shuttle_vel[1] * me.pnorm[1];
		me.target_prox_vz += me.tgt_vel[2] * me.tpnorm[2] - me.shuttle_vel[2] * me.pnorm[2];



	},

	list_proximity: func {


		print ("Position:");
		print ("x: ", me.target_prox_x);
		print ("y: ", me.target_prox_y);
		print ("z: ", me.target_prox_z);
		print ("");
		print ("Velocity:");
		print ("vx: ", me.target_prox_vx);
		print ("vy: ", me.target_prox_vy);
		print ("vz: ", me.target_prox_vz);

	},


	set_sensor_tracking: func {

	
		if ((SpaceShuttle.antenna_manager.function == "RDR PASSIVE") or (SpaceShuttle.star_tracker_array[0].mode == 2) or (SpaceShuttle.star_tracker_array[1].mode == 2))
			{

			me.tgtCoord = geo.Coord.new();
			me.tgtCoord.set_xyz(me.tgt_pos[0], me.tgt_pos[1], me.tgt_pos[2]);

			me.shuttleCoord = geo.Coord.new();
			me.shuttleCoord.set_xyz(me.shuttle_pos[0], me.shuttle_pos[1], me.shuttle_pos[2]);

			var angle = me.nd_ref_trafo_angle.getValue() * 180.0/math.pi;
			#var angle = getprop("/fdm/jsbsim/systems/pointing/inertial/ecf-to-eci-rad-alt") * 180.0/math.pi;
			
			# transform from inertial to world			

			me.shuttleCoord.set_lon(me.shuttleCoord.lon() - angle);
			me.tgtCoord.set_lon(me.tgtCoord.lon() - angle);

			#var test_coord = geo.aircraft_position();

			#var bearing = me.shuttleCoord.course_to(me.tgtCoord);
			#print ("Bearing", bearing);

			#print ("Shuttle: ");
			#print (me.shuttleCoord.x(), " ", me.shuttleCoord.y(), " ", me.shuttleCoord.z());
			#print ("Direct:  ");
			#print (test_coord.x(), " ", test_coord.y(), " ", test_coord.z());
			}		


		if (SpaceShuttle.antenna_manager.function == "RDR PASSIVE") 
			{
			

			SpaceShuttle.antenna_manager.set_rr_target(me.tgtCoord);
			if ((SpaceShuttle.antenna_manager.rr_target_available == 1) and (SpaceShuttle.antenna_manager.rvdz_data == 1))
				{
				SpaceShuttle.antenna_manager.ku_antenna_track_target(me.tgtCoord, me.shuttleCoord);
				}		
			}
		if (SpaceShuttle.star_tracker_array[0].mode == 2)
			{
			SpaceShuttle.star_tracker_array[0].set_target(me.tgtCoord);
			}

		if (SpaceShuttle.star_tracker_array[1].mode == 2)
			{
			SpaceShuttle.star_tracker_array[1].set_target(me.tgtCoord);
			}

	},



	compute_vdiff : func {

		me.delta_v = [0,0,0];


		me.list_proximity();
		
		me.delta_v[0] = me.target_prox_vx * me.tvnorm[0] + me.target_prox_vy * me.tnnorm[0]  + me.target_prox_vz * me.tpnorm[0];
		me.delta_v[1] = me.target_prox_vy * me.tvnorm[1] + me.target_prox_vy * me.tnnorm[1]  + me.target_prox_vz * me.tpnorm[1];
		me.delta_v[2] = me.target_prox_vx * me.tvnorm[2] + me.target_prox_vy * me.tnnorm[2]  + me.target_prox_vz * me.tpnorm[2];



		print ("Velocity differences proximity: ");
		print (me.target_prox_vx, " ", me.target_prox_vy, " ", me.target_prox_vz);
		print ("Velocity differences inertial: ");
		print (me.delta_v[0], " ", me.delta_v[1], " ", me.delta_v[2]);


		#me.shuttle_vel[0] = getprop("/fdm/jsbsim/velocities/eci-x-fps") * 0.3048;
		#me.shuttle_vel[1] = getprop("/fdm/jsbsim/velocities/eci-y-fps") * 0.3048;
		#me.shuttle_vel[2] = getprop("/fdm/jsbsim/velocities/eci-z-fps") * 0.3048;

		#me.tgt_vel = SpaceShuttle.oTgt.get_inertial_speed();

		#me.delta_v[0] = me.tgt_vel[0] - me.shuttle_vel[0];
		#me.delta_v[1] = me.tgt_vel[1] - me.shuttle_vel[1];
		#me.delta_v[2] = me.tgt_vel[2] - me.shuttle_vel[2];

		#print ("Velocity differences direct: ");
		#print (me.delta_v[0], " ", me.delta_v[1], " ", me.delta_v[2]);
		
		
	},


	provide_tracking: func {

		# provides tracking vectors for UNIV PTG



		# pointing vector  in inertial coordinates

		var shuttle_inertial = [me.shuttle_pos[0], me.shuttle_pos[1], me.shuttle_pos[2]];
		var tgt_inertial = [me.tgt_pos[0], me.tgt_pos[1], me.tgt_pos[2]];

		var pointer = SpaceShuttle.normalize(SpaceShuttle.subtract_vector(tgt_inertial, shuttle_inertial));
		
		setprop("/fdm/jsbsim/systems/ap/track/target-vector[0]", pointer[0]);
		setprop("/fdm/jsbsim/systems/ap/track/target-vector[1]", pointer[1]);
		setprop("/fdm/jsbsim/systems/ap/track/target-vector[2]", pointer[2]);

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

		var second = SpaceShuttle.orthonormalize(pointer, [0.0, 0.0, 1.0]);

		setprop("/fdm/jsbsim/systems/ap/track/target-sec[0]", second[0]);
		setprop("/fdm/jsbsim/systems/ap/track/target-sec[1]", second[1]);
		setprop("/fdm/jsbsim/systems/ap/track/target-sec[2]", second[2]);

		var third = SpaceShuttle.cross_product(pointer, second);

		setprop("/fdm/jsbsim/systems/ap/track/target-trd[0]", third[0]);
		setprop("/fdm/jsbsim/systems/ap/track/target-trd[1]", third[1]);
		setprop("/fdm/jsbsim/systems/ap/track/target-trd[2]", third[2]);


	},



	error_init: func {

		me.perfect_navigation = 1 - getprop("/fdm/jsbsim/systems/navigation/state-vector/use-realistic-sv");

		me.error_amp_x = (rand() - 0.5) * 500.0;
		me.error_amp_y = (rand() - 0.5) * 500.0;
		me.error_amp_z = (rand() - 0.5) * 500.0;

		me.error_phase_xz = rand() * 2.0 * math.pi;
		me.error_phase_y = rand() * 2.0 * math.pi;

		var true_anomaly_rad = getprop("/fdm/jsbsim/systems/orbital/true-anomaly-rad");

		me.error_x = math.sin(true_anomaly_rad + me.error_phase_xz) * me.error_amp_x * (1-me.perfect_navigation);
		me.error_z = math.cos(true_anomaly_rad + me.error_phase_xz) * me.error_amp_z * (1-me.perfect_navigation);
		me.error_y = math.sin(true_anomaly_rad + me.error_phase_y) * me.error_amp_y * (1-me.perfect_navigation);

		me.error_x_filtered = me.error_x;
		me.error_y_filtered = me.error_y;
		me.error_z_filtered = me.error_z;

		me.error_x_cand = me.error_x;
		me.error_y_cand = me.error_y;
		me.error_z_cand = me.error_z;

		me.error_d_factor = (rand() - 0.5) * 0.02;

	},

	error_propagate: func {

		#var true_anomaly_rad = getprop("/fdm/jsbsim/systems/orbital/true-anomaly-rad");
		#var period = getprop("/fdm/jsbsim/systems/orbital/orbital-period-s");

		var true_anomaly_rad = me.nd_ref_true_anomaly.getValue();
		var period = me.nd_ref_orbital_period.getValue();

		me.error_x = math.sin(true_anomaly_rad + me.error_phase_xz) * me.error_amp_x * (1-me.perfect_navigation);
		me.error_z = math.cos(true_anomaly_rad + me.error_phase_xz) * me.error_amp_z * (1-me.perfect_navigation);
		me.error_y = math.sin(true_anomaly_rad + me.error_phase_y) * me.error_amp_y * (1-me.perfect_navigation);

		me.error_d_rr = me.distance * me.error_d_factor * (1-me.perfect_navigation);

		me.error_rdot = -math.cos(true_anomaly_rad + me.error_phase_xz) * me.error_amp_x * (1-me.perfect_navigation) * 2.0 * math.pi/period;

	},

	error_filter: func {


		me.ang_data_good = 0;
		me.rr_data_good = 1;
		if (SpaceShuttle.antenna_manager.tgt_acquired == 0) {me.rr_data_good = 0;}
		else if (me.distance > 46000.0) {me.rr_data_good = 0;}
		else if (SpaceShuttle.antenna_manager.function == "COMM") {me.rr_data_good = 0;}
		
		#print ("RR working flag: ", me.rr_data_good);


		if (me.angle_sensor_selection == 0) # star tracker
			{
			
			if ((SpaceShuttle.star_tracker_array[0].target_acquired == 1) or  (SpaceShuttle.star_tracker_array[1].target_acquired == 1))
			
				{			
				var ang_res = me.distance * 0.00029; 
				
				me.ang_data_good = 1;

				
				if (me.error_y > ang_res)
					{
					me.error_y_cand = ang_res;
					}
				else if (me.error_y < -ang_res)
					{
					me.error_y_cand = -ang_res;
					}
				else
					{
					me.error_y_cand = me.error_y;
					}

				if (me.error_z > ang_res)
					{
					me.error_z_cand = ang_res;
					}
				else if (me.error_z < -ang_res)
					{
					me.error_z_cand = -ang_res;
					}
				else
					{
					me.error_z_cand = me.error_z;
					}

				#print ("Star tracker tracking target!");	
				#print ("Ang res: ", ang_res);
				#print ("Y:", me.error_y, " ", me.error_y_cand);	
				#print ("Z:", me.error_z, " ", me.error_z_cand);	
				}				
	
			}
		else if (me.angle_sensor_selection == 1) # radar ranger
			{
			if (me.rr_data_good == 1)
				{

				me.ang_data_good = 1;
				var ang_res = me.distance * 0.0053; 

				if (me.error_y > ang_res)
					{
					me.error_y_cand = ang_res;
					}
				else if (me.error_y < -ang_res)
					{
					me.error_y_cand = -ang_res;
					}
				else
					{
					me.error_y_cand = me.error_y;
					}

				if (me.error_z > ang_res)
					{
					me.error_z_cand = ang_res;
					}
				else if (me.error_z < -ang_res)
					{
					me.error_z_cand = -ang_res;
					}
				else 
					{
					me.error_z_cand = me.error_z;
					}

				#print ("RR tracking target!");	
				#print ("Ang res: ", ang_res);
				#print ("Distance: ", me.distance);
				#print ("Y:", me.error_y, " ", me.error_y_cand);	
				#print ("Z:", me.error_z, " ", me.error_z_cand);
			

				}


			}

		if (me.rr_data_good == 1)
			{
			var dist_resolution = me.distance * 0.01;
			if (dist_resolution < 25.0) {dist_resolution = 25.0;}

			var rate_resolution = 0.6 * 0.3048;
	
			if (me.error_x > dist_resolution)
				{
				me.error_x_cand = dist_resolution;
				}
			else if (me.error_x < -dist_resolution)
				{
				me.error_x_cand = -dist_resolution;
				}
			else 
				{
				me.error_x_cand = me.error_x;
				}

			if (me.error_rdot > rate_resolution)
				{
				me.error_rdot_cand = rate_resolution;
				}
			else if (me.error_rdot < -rate_resolution)
				{
				me.error_rdot_cand = -rate_resolution;
				}
			else 
				{
				me.error_rdot_cand = me.error_rdot;
				}


				#print ("Dist res: ", dist_resolution);
				#print ("X:", me.error_x, " ", me.error_x_cand);
				#print ("rdot: ", me.error_rdot, " ", me.error_rdot_cand);
			}


		me.rng_resid = math.abs(me.distance_prop - me.distance_cand)/0.3048/1000.;
		me.rng_ratio = me.rng_resid / (me.distance/0.3048/1000. * 0.1);

		me.rdot_resid = math.abs(me.error_rdot - me.error_rdot_cand)/0.3048;
		me.rdot_ratio = me.rdot_resid/(me.distance/6000.0 * 0.05);

		me.y_resid = math.abs(me.error_y - me.error_y_cand)/ me.distance * 180.0/math.pi;
		me.y_ratio = me.y_resid/1.0;

		me.z_resid = math.abs(me.error_z - me.error_z_cand)/ me.distance * 180.0/math.pi;
		me.z_ratio = me.z_resid/1.0;

		me.gps_p_resid = math.abs(me.distance_prop - me.distance)/0.3048/1000.;
		me.gps_p_ratio = me.gps_p_resid/ (me.distance * 0.1);

		me.gps_v_resid = 0.01;
		me.gps_v_ratio = me.rdot_resid/0.05;

		if (me.rng_aut == 1)
			{
			if (me.rng_ratio < 1.0)
				{
				me.update_x = math.abs(me.error_x_filtered - me.error_x_cand);
				me.error_x_filtered = me.error_x_cand;
				}
			}
		else if (me.rng_for == 1)
			{
			me.update_x = math.abs(me.error_x_filtered - me.error_x_cand);
			me.error_x_filtered = me.error_x_cand;
			settimer( func {me.rng_for = 0; me.rng_aut = 1;}, 2.0);
			}
		else
			{
			me.error_x_filtered = me.error_x;
			}

		if (me.y_aut == 1)
			{
			if (me.y_ratio < 1.0)
				{
				me.update_y = math.abs(me.error_y_filtered - me.error_y_cand);
				me.update_z = math.abs(me.error_z_filtered - me.error_z_cand);
				me.error_y_filtered = me.error_y_cand;
				me.error_z_filtered = me.error_z_cand;
				}

			}
		else if (me.y_for == 1)
			{
			me.update_y = math.abs(me.error_y_filtered - me.error_y_cand);
			me.update_z = math.abs(me.error_z_filtered - me.error_z_cand);
			me.error_y_filtered = me.error_y_cand;
			me.error_z_filtered = me.error_z_cand;
			settimer( func {me.y_for = 0; me.y_aut = 1;}, 2.0);
			}
		else
			{
			me.error_y_filtered = me.error_y;
			me.error_z_filtered = me.error_z;
			}

		if (me.rdot_aut == 1)
			{
			if (me.rdot_ratio < 1.0)
				{
				me.update_rdot = math.abs(me.error_rdot_filtered - me.error_rdot_cand);
				me.error_rdot_filtered = me.error_rdot_cand;
				}

			}
		else if (me.rdot_for == 1)
			{
			me.error_rdot_filtered = me.error_rdot_cand;
			settimer( func {me.rdot_for = 0; me.rdot_aut = 1;}, 2.0);
			}
		else
			{
			me.error_rdot_filtered = me.error_rdot;
			}

		#print ("Filtering: ");
		#print ("x:", me.error_x, " ", me.error_x_cand, " ", me.error_x_filtered);	
		#print ("Y:", me.error_y, " ", me.error_y_cand, " ", me.error_y_filtered);	
		#print ("Z:", me.error_z, " ", me.error_z_cand, " ", me.error_z_filtered);
		#print ("RNG data: ", me.rr_data_good, " ANG data: ", me.ang_data_good);


	},

	transfer_fltr_to_prop: func {

		var true_anomaly_rad = me.nd_ref_true_anomaly.getValue();

		var sin_arg_xz =  math.sin(true_anomaly_rad + me.error_phase_xz);
		if (sin_arg_xz == 0.0) {sin_arg_xz = 0.001;}

		var sin_arg_y =  math.sin(true_anomaly_rad + me.error_phase_y);
		if (sin_arg_y == 0.0) {sin_arg_y = 0.001;}	

		me.error_amp_x = me.error_x_filtered / sin_arg_xz;
		me.error_amp_y = me.error_y_filtered / sin_arg_y;
		me.error_amp_z = me.error_z_filtered / sin_arg_xz;

	},




};

proximity_manager.init();



