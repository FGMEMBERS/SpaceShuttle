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
	
		

		me.yaw_rate = me.yaw_rate + a_yaw * dt;
		me.pitch_rate = me.pitch_rate + a_pitch * dt;
		me.roll_rate = me.roll_rate + a_roll * dt;

		me.yaw = me.yaw + me.yaw_rate * dt;
		me.pitch = me.pitch + me.pitch_rate * dt;
		me.roll = me.roll + me.roll_rate * dt;
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
setprop("/controls/shuttle/"~objString~"/pitch-deg", objState.pitch + lon);
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

var current_mode = getprop("/fdm/jsbsim/systems/fcs/control-mode");
setprop("/fdm/jsbsim/systems/fcs/control-mode",26);
setprop("/controls/flight/elevator", 1);


settimer( func{
	controls.centerFlightControls();
	SpaceShuttle.control_to_rcs();
	}, 5.0);



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

kuState.pitch_rate = 2.5;
kuState.yaw_rate = 0.5;


kuModel = place_model("ku-ballistic", "Aircraft/SpaceShuttle/Models/PayloadBay/ku-antenna-disconnected.xml", kuCoord.lat(), kuCoord.lon(), kuCoord.alt() * m_to_ft, yaw,pitch,roll);

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
# ISS simulation control routines
###########################################################################


### init ISS in the distance ###

var init_iss = func  {


var pitch = getprop("/orientation/pitch-deg");
var yaw = getprop("/orientation/heading-deg");
var roll = getprop("/orientation/roll-deg");


issCoord = geo.aircraft_position() ;

issCoord.set_lon (issCoord.lon() + 0.001);

issState = stateVector.new (issCoord.x(),issCoord.y(),issCoord.z(),0,0,0, 90.0, 0.0 , 0.0);

var model_path = "Aircraft/SpaceShuttle/Models/ISS/ISS_free.xml";

issModel = place_model("ISS", model_path, issCoord.lat(), issCoord.lon(), issCoord.alt() * m_to_ft, yaw,pitch,roll);

setprop("/controls/shuttle/ISS/groundtrack-orig-deg", 90.0);


var lat = getprop("/position/latitude-deg") * math.pi/180.0;
var lon = getprop("/position/longitude-deg") * math.pi/180.0;
var dt = getprop("/sim/time/delta-sec");

var vxoffset = 3.5 * math.cos(lon) * math.pow(dt/0.05,3.0);
var vyoffset = 3.5 * math.sin(lon) * math.pow(dt/0.05,3.0);
var vzoffset = 0.0;



settimer(func { 
		issState.vx = getprop("/fdm/jsbsim/velocities/eci-x-fps") * ft_to_m + vxoffset;
		issState.vy = getprop("/fdm/jsbsim/velocities/eci-y-fps") * ft_to_m + vyoffset;
		issState.vz = getprop("/fdm/jsbsim/velocities/eci-z-fps") * ft_to_m + vzoffset;
		iss_loop_flag = 1;
		update_iss(0.0 , 0.0, 0.0, 0.0, 0.0, 1); },0);
}


### init ISS undocking from the Shuttle ###

var undock_iss = func  {

if (getprop("/controls/shuttle/ISS/docking-flag") == 0)
	{return;}

setprop("/controls/shuttle/ISS/docking-flag", 0);
setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[6]", 0.0);
setprop("/fdm/jsbsim/systems/ap/orbital-dap-inertial", 1);
setprop("/fdm/jsbsim/systems/ap/orbital-dap-auto", 0);
setprop("/fdm/jsbsim/systems/ap/orbital-dap-lvlh", 0);
setprop("/fdm/jsbsim/systems/ap/orbital-dap-free", 0);
SpaceShuttle.switch_orbital_dap(1);

# prevent immediate triggering of the docking condition
setprop("/controls/shuttle/ISS/docking-veto", 1);
settimer (func { setprop("/controls/shuttle/ISS/docking-veto", 0);}, 10.0);

var pitch = getprop("/orientation/pitch-deg");
var yaw = getprop("/orientation/heading-deg");
var roll = getprop("/orientation/roll-deg");
var lon_deg = getprop("/position/longitude-deg");

issCoord = geo.aircraft_position();

# correct for docking collar position

var shuttleWorldX = [getprop("/fdm/jsbsim/systems/pointing/world/body-x"), getprop("/fdm/jsbsim/systems/pointing/world/body-x[1]"), getprop("/fdm/jsbsim/systems/pointing/world/body-x[2]")];

var shuttleWorldZ = [getprop("/fdm/jsbsim/systems/pointing/world/body-z"), getprop("/fdm/jsbsim/systems/pointing/world/body-z[1]"), getprop("/fdm/jsbsim/systems/pointing/world/body-z[2]")];

var shuttleLVLHZ = [-getprop("/fdm/jsbsim/systems/pointing/lvlh/body-z"), -getprop("/fdm/jsbsim/systems/pointing/lvlh/body-z[1]"), -getprop("/fdm/jsbsim/systems/pointing/lvlh/body-z[2]")];

var dockingCollarOffset = SpaceShuttle.add_vector(SpaceShuttle.scalar_product(8.1, shuttleWorldX), SpaceShuttle.scalar_product(-1.0, shuttleWorldZ));

issCoord.set_x( issCoord.x() - dockingCollarOffset[0]); 
issCoord.set_y( issCoord.y() - dockingCollarOffset[1]); 
issCoord.set_z( issCoord.z() - dockingCollarOffset[2]); 

issState = stateVector.new (issCoord.x(),issCoord.y(),issCoord.z(),0,0,0, yaw, pitch - lon_deg , roll);

var model_path = "Aircraft/SpaceShuttle/Models/ISS/ISS_free.xml";

issModel = place_model("ISS", model_path, issCoord.lat(), issCoord.lon(), issCoord.alt() * m_to_ft, yaw,pitch -lon_deg,roll);



var lat = getprop("/position/latitude-deg") * math.pi/180.0;
var lon = lon_deg * math.pi/180.0;
var dt = getprop("/sim/time/delta-sec");

var vxoffset = 3.5 * math.cos(lon) * math.pow(dt/0.05,3.0);
var vyoffset = 3.5 * math.sin(lon) * math.pow(dt/0.05,3.0);
var vzoffset = 0.0;


# now we push the the orbiter away 

var current_mode = getprop("/fdm/jsbsim/systems/fcs/control-mode");
setprop("/fdm/jsbsim/systems/fcs/control-mode",28);
setprop("/controls/flight/elevator", -1.0);


settimer( func{
	controls.centerFlightControls();
	SpaceShuttle.control_to_rcs();
	}, 3.0);


settimer(func { 
		issState.vx = getprop("/fdm/jsbsim/velocities/eci-x-fps") * ft_to_m + vxoffset;
		issState.vy = getprop("/fdm/jsbsim/velocities/eci-y-fps") * ft_to_m + vyoffset;
		issState.vz = getprop("/fdm/jsbsim/velocities/eci-z-fps") * ft_to_m + vzoffset;
		iss_loop_flag = 1;
		update_iss(0.0 , 0.0, 0.0, 0.0, 0.0, 2); },0);
}


### manage ISS in undocked state ###

var update_iss = func (delta_lon, d_last, d_disp_last, y_last, y_disp_last, placement_flag) {

var shuttleCoord = geo.aircraft_position();
var dt = getprop("/sim/time/delta-sec");


delta_lon = delta_lon + dt * earth_rotation_deg_s * 1.004;

var F = get_force (issState, shuttleCoord);

issState.update(F[0], F[1], F[2], 0.0,0.0,0.0);
issCoord.set_xyz(issState.x, issState.y, issState.z);
issCoord.set_lon(issCoord.lon() - delta_lon);

if (iss_loop_flag < 3)
	{
	if (iss_loop_flag ==1)
		{
		offset_vec_iss = [issCoord.x()-shuttleCoord.x(), issCoord.y()-shuttleCoord.y(),issCoord.z()-shuttleCoord.z()];
		}
	if (iss_loop_flag == 2)
		{
		var offset1_vec = [issCoord.x()-shuttleCoord.x(), issCoord.y()-shuttleCoord.y(),issCoord.z()-shuttleCoord.z()];
		var v_offset_vec = [(offset1_vec[0] - offset_vec_iss[0]) / dt, (offset1_vec[1] - offset_vec_iss[1]) / dt, (offset1_vec[2] - offset_vec_iss[2]) / dt];
		


		issState = compute_state_correction  (issState, issCoord, shuttleCoord, v_offset_vec, delta_lon);
		if (placement_flag == 1)
			{
			var iss_placement = geo.Coord.new();
			iss_placement.set_xyz (issState.x, issState.y, issState.z);
			iss_placement.set_lon (iss_placement.lon() + 0.005);
			issState.x = iss_placement.x();
			issState.y = iss_placement.y();
			issState.z = iss_placement.z();
			}
		else if (placement_flag == 2)
			{
			var iss_placement = geo.Coord.new();
			iss_placement.set_xyz (issState.x, issState.y, issState.z);

			var shuttleWorldX = [getprop("/fdm/jsbsim/systems/pointing/world/body-x"), getprop("/fdm/jsbsim/systems/pointing/world/body-x[1]"), getprop("/fdm/jsbsim/systems/pointing/world/body-x[2]")];

			var shuttleWorldZ = [getprop("/fdm/jsbsim/systems/pointing/world/body-z"), getprop("/fdm/jsbsim/systems/pointing/world/body-z[1]"), getprop("/fdm/jsbsim/systems/pointing/world/body-z[2]")];

			var shuttleLVLHZ = [-getprop("/fdm/jsbsim/systems/pointing/lvlh/body-z"), -getprop("/fdm/jsbsim/systems/pointing/lvlh/body-z[1]"), -getprop("/fdm/jsbsim/systems/pointing/lvlh/body-z[2]")];

			var dockingCollarOffset = SpaceShuttle.add_vector(SpaceShuttle.scalar_product(-8.1, shuttleWorldX), SpaceShuttle.scalar_product(1.0, shuttleWorldZ));

			iss_placement.set_x( iss_placement.x() - dockingCollarOffset[0]); 
			iss_placement.set_y( iss_placement.y() - dockingCollarOffset[1]); 
			iss_placement.set_z( iss_placement.z() - dockingCollarOffset[2]); 

			issState.x = iss_placement.x();
			issState.y = iss_placement.y();
			issState.z = iss_placement.z();
			}
		}
	iss_loop_flag = iss_loop_flag + 1;

	}


set_coords("ISS", issCoord, issState);

# we have to do the antenna tracking here rather than in the antenna manager, because
# the antenna manager might run outside a frame, in which case the coordinate is displaced
# leading to odd tracking angles for the antenna


if (SpaceShuttle.antenna_manager.function == "RDR PASSIVE") 
		{
		SpaceShuttle.antenna_manager.set_rr_target(issCoord);
			if ((SpaceShuttle.antenna_manager.rr_target_available == 1) and (SpaceShuttle.antenna_manager.rvdz_data == 1))
				{
				ku_antenna_track_target(issCoord);
				}		
		}
if (SpaceShuttle.star_tracker_array[0].mode == 2)
	{
	SpaceShuttle.star_tracker_array[0].set_target(issCoord);
	}

if (SpaceShuttle.star_tracker_array[1].mode == 2)
{
	SpaceShuttle.star_tracker_array[1].set_target(issCoord);
	}



# check docking conditions
# we need to do this for the docking collar, so we need its position in FG world
# coordinates
# we also need LVLH coordinates for the Y vector and theta
# since FG manages attitude in LVLH pitch, yaw and roll
# (basically this is a mess)

var shuttleWorldX = [getprop("/fdm/jsbsim/systems/pointing/world/body-x"), getprop("/fdm/jsbsim/systems/pointing/world/body-x[1]"), getprop("/fdm/jsbsim/systems/pointing/world/body-x[2]")];

var shuttleWorldZ = [getprop("/fdm/jsbsim/systems/pointing/world/body-z"), getprop("/fdm/jsbsim/systems/pointing/world/body-z[1]"), getprop("/fdm/jsbsim/systems/pointing/world/body-z[2]")];

var shuttleLVLHZ = [-getprop("/fdm/jsbsim/systems/pointing/lvlh/body-z"), -getprop("/fdm/jsbsim/systems/pointing/lvlh/body-z[1]"), -getprop("/fdm/jsbsim/systems/pointing/lvlh/body-z[2]")];

var dockingCollarOffset = SpaceShuttle.add_vector(SpaceShuttle.scalar_product(8.1, shuttleWorldX), SpaceShuttle.scalar_product(-1.0, shuttleWorldZ));

shuttleCoord.set_x (shuttleCoord.x() + dockingCollarOffset[0]);
shuttleCoord.set_y (shuttleCoord.y() + dockingCollarOffset[1]);
shuttleCoord.set_z (shuttleCoord.z() + dockingCollarOffset[2]);

var dist = shuttleCoord.distance_to(issCoord);
var ddot = (dist - d_last)/dt;
d_last = dist;

setprop("/fdm/jsbsim/systems/rendezvous/target/distance-m", dist);
setprop("/fdm/jsbsim/systems/rendezvous/target/ddot-m_s", ddot);

var iss_roll = getprop("/controls/shuttle/ISS/roll-deg");
var iss_pitch = getprop("/controls/shuttle/ISS/pitch-deg");
var iss_yaw = getprop("/controls/shuttle/ISS/heading-deg");

var y_vec = orientTaitBryan([0.0, 0.0,-1.0], iss_yaw, iss_pitch, iss_roll);

var lat_to_m = 110952.0;
var lon_to_m  = math.cos(issCoord.lat()*math.pi/180.0) * lat_to_m;

var x_lvlh = (issCoord.lon() - shuttleCoord.lon()) * lon_to_m;
var y_lvlh = (issCoord.lat() - shuttleCoord.lat()) * lat_to_m;
var z_lvlh = (issCoord.alt() - shuttleCoord.alt());

var rel_vec = [x_lvlh, y_lvlh, z_lvlh];


var y = -SpaceShuttle.dot_product(y_vec, rel_vec);
var ydot = (y - y_last)/dt;
y_last = y;
var theta = 180.0/math.pi * math.acos(SpaceShuttle.dot_product(y_vec, shuttleLVLHZ));

setprop("/fdm/jsbsim/systems/rendezvous/target/Y-m",y);
setprop("/fdm/jsbsim/systems/rendezvous/target/Ydot-m_s",ydot);
setprop("/fdm/jsbsim/systems/rendezvous/target/theta",theta);




if (dist > 5000.0) 
	{
	print ("ISS explicit simulation ends");
	issModel.remove();
	iss_loop_flag = 0;
	}

if (dist < 0.4)
	{
	
	if ((getprop("/controls/shuttle/ISS/docking-veto") == 0) and (theta < 15.0))
		{
		setprop("/sim/messages/copilot", "Successful ISS docking!");

		setprop("/controls/shuttle/ISS/docking-flag", 1);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[6]", 924740.0);
		controls.centerFlightControls();
		setprop("/fdm/jsbsim/systems/ap/orbital-dap-inertial", 0);
		setprop("/fdm/jsbsim/systems/ap/orbital-dap-auto", 0);
		setprop("/fdm/jsbsim/systems/ap/orbital-dap-lvlh", 0);
		setprop("/fdm/jsbsim/systems/ap/orbital-dap-free", 1);
		SpaceShuttle.switch_orbital_dap(4);
		issModel.remove();
		iss_loop_flag = 0;

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

	}



# in addition to the real docking parameters (which we have to use to evaluate docking)
# we have to generate the displayed ones repeating the computation with the
# ISS coordinates plus errors

issCoord = SpaceShuttle.blur_tgt_coord(issCoord);
dist = shuttleCoord.distance_to(issCoord);
ddot = (dist - d_disp_last)/dt;
d_disp_last = dist;

setprop("/fdm/jsbsim/systems/rendezvous/target/distance-prop-m", dist);
setprop("/fdm/jsbsim/systems/rendezvous/target/ddot-prop-m_s", ddot);

x_lvlh = (issCoord.lon() - shuttleCoord.lon()) * lon_to_m;
y_lvlh = (issCoord.lat() - shuttleCoord.lat()) * lat_to_m;
z_lvlh = (issCoord.alt() - shuttleCoord.alt());

rel_vec = [x_lvlh, y_lvlh, z_lvlh];

y = -SpaceShuttle.dot_product(y_vec, rel_vec);
ydot = (y - y_disp_last)/dt;
y_disp_last = y;
theta = 180.0/math.pi * math.acos(SpaceShuttle.dot_product(y_vec, shuttleLVLHZ));

setprop("/fdm/jsbsim/systems/rendezvous/target/Y-prop-m",y);
setprop("/fdm/jsbsim/systems/rendezvous/target/Ydot-prop-m_s",ydot);
setprop("/fdm/jsbsim/systems/rendezvous/target/theta-prop",theta);


if (iss_loop_flag >0 ) {settimer(func {update_iss(delta_lon, d_last, d_disp_last, y_last, y_disp_last, placement_flag); },0.0);}
}




