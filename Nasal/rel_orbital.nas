###########################################################################
# this file contains several techniques to maintain other objects in orbit
# 
# * shuttle-relative coordinate management (for EVA view)
# * independently computed simple ballistic FDM (for tank)
# (* analytic Kepler orbit)
###########################################################################


var etState = {};
var evaState = {};
var etCoord = {};
var etModel = {};

var eva_loop_flag = 0;
var tank_loop_flag = 0;
var delta_lon = 0.0;

var ft_to_m = 0.30480;
var m_to_ft = 1.0/ft_to_m;
var earth_rotation_deg_s = 0.0041666666666666;

var offset_vec = [];

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
	update: func (ax, ay, az, a_yaw, a_pitch, a_roll) {

		var dt = getprop("/sim/time/delta-sec");

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


	var ax = getprop("/fdm/jsbsim/fcs/rudder-pos-norm") * 0.1;
	var ay = getprop("/fdm/jsbsim/fcs/left-aileron-pos-norm") * 0.1;
	var az = getprop("/fdm/jsbsim/fcs/elevator-pos-norm") * 0.1;

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
	var ax = getprop("/fdm/jsbsim/fcs/elevator-pos-norm") * -0.5;
	var ay = getprop("/fdm/jsbsim/fcs/left-aileron-pos-norm") * 0.5;
	var az = getprop("/fdm/jsbsim/fcs/rudder-pos-norm") * 0.5;
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
# external tank control routines
###########################################################################


var place_model = func(path, lat, lon, alt, heading, pitch, roll) {



var m = props.globals.getNode("models", 1);
		for (var i = 0; 1; i += 1)
			if (m.getChild("model", i, 0) == nil)
				break;
var model = m.getChild("model", i, 1);



setprop("/controls/shuttle/et-ballistic/latitude-deg", lat);
setprop("/controls/shuttle/et-ballistic/longitude-deg", lon);
setprop("/controls/shuttle/et-ballistic/elevation-ft", alt);
setprop("/controls/shuttle/et-ballistic/heading-deg", heading);
setprop("/controls/shuttle/et-ballistic/pitch-deg", pitch);
setprop("/controls/shuttle/et-ballistic/roll-deg", roll);


var etmodel = props.globals.getNode("/controls/shuttle/et-ballistic", 1);
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




var init_tank = func {




var pitch = getprop("/orientation/pitch-deg");
var yaw =getprop("/orientation/heading-deg");
var roll = getprop("/orientation/roll-deg");

var lon = getprop("/position/longitude-deg");


etCoord = geo.aircraft_position() ;

print(etCoord.x(), " ", etCoord.y, " ", etCoord.z);


etState = stateVector.new (etCoord.x(),etCoord.y(),etCoord.z(),0,0,0,yaw, pitch - lon, roll);

etModel = place_model("Aircraft/SpaceShuttle/Models/external-tank-disconnected.xml", etCoord.lat(), etCoord.lon(), etCoord.alt() * m_to_ft, yaw,pitch,roll);

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
	control_to_rcs();
	}, 5.0);

settimer(func { 
		etState.vx = getprop("/fdm/jsbsim/velocities/eci-x-fps") * ft_to_m + vxoffset;
		etState.vy = getprop("/fdm/jsbsim/velocities/eci-y-fps") * ft_to_m + vyoffset;
		etState.vz = getprop("/fdm/jsbsim/velocities/eci-z-fps") * ft_to_m + vzoffset;
		tank_loop_flag = 1;
		update_tank(); },0);
}

var update_tank = func {

var shuttleCoord = geo.aircraft_position();
var dt = getprop("/sim/time/delta-sec");





delta_lon = delta_lon + dt * earth_rotation_deg_s * 1.004;

var G = [etState.x, etState.y, etState.z]; 
var Gnorm = math.sqrt(math.pow(G[0],2.0) + math.pow(G[1],2.0) + math.pow(G[2],2.0));
var g = getprop("/fdm/jsbsim/accelerations/gravity-ft_sec2") * 0.3048;
G[0] = -G[0]/Gnorm * g;
G[1] = -G[1]/Gnorm * g;
G[2] = -G[2]/Gnorm * g;

etState.update(G[0], G[1], G[2], 0.0,0.0,0.0);
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
		print(v_offset_vec[0], " ", v_offset_vec[1], " ", v_offset_vec[2]);

		offset_vec = offset1_vec;
		etState.vx = etState.vx - v_offset_vec[0];
		etState.vy = etState.vy - v_offset_vec[1];
		etState.vz = etState.vz - v_offset_vec[2];

		etCoord.set_xyz(shuttleCoord.x(), shuttleCoord.y(), shuttleCoord.z());
		etCoord.set_lon(etCoord.lon() + delta_lon);

		etState.x = etCoord.x();
		etState.y = etCoord.y();
		etState.z = etCoord.z();

		etCoord.set_lon(etCoord.lon() - delta_lon);
		}
	tank_loop_flag = tank_loop_flag + 1;


	}

var lon = getprop("/position/longitude-deg");
setprop("/controls/shuttle/et-ballistic/latitude-deg", etCoord.lat());
setprop("/controls/shuttle/et-ballistic/longitude-deg", etCoord.lon());
setprop("/controls/shuttle/et-ballistic/elevation-ft", etCoord.alt() * m_to_ft);
setprop("/controls/shuttle/et-ballistic/pitch-deg", etState.pitch + lon);

var dist = shuttleCoord.distance_to(etCoord);

if (dist > 5000.0) 
	{
	print ("ET simulation ends");
	etModel.remove();
	tank_loop_flag = 0;
	}

if (tank_loop_flag >0 ) {settimer(update_tank,0.0);}
}
