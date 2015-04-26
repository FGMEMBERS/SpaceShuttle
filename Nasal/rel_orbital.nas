var etState = {};
var evaState = {};
#var dummy_handler = {};

var eva_loop_flag = 0;

#view.manager.register("EVA", dummy_handler);

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

		me.vx = me.vx + ax * dt;
		me.vy = me.vy + ay * dt;
		me.vz = me.vz + az * dt;
	
		me.x = me.x + me.vx * dt;
		me.y = me.y + me.vy * dt;
		me.z = me.z + me.vz * dt;

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

var toggle_EVA = func {

if (getprop("/sim/current-view/name") != "EVA")
	{
	return;
	}

var control = getprop("/fdm/jsbsim/systems/fcs/control-mode");

if ((control != 50) and (control != 51))
	{start_EVA();}

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
	setprop("/sim/view[101]/config/heading-offset-deg",180.0);
	setprop("/sim/view[101]/config/pitch-offset-deg", 0.0);
	setprop("/sim/view[101]/config/roll-offset-deg", 0.0);
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

setprop("/sim/view[101]/config/heading-offset-deg", evaState.yaw);
setprop("/sim/view[101]/config/pitch-offset-deg", evaState.pitch);
setprop("/sim/view[101]/config/roll-offset-deg", evaState.roll);

setprop("/sim/current-view/heading-offset-deg", evaState.yaw);
setprop("/sim/current-view/pitch-offset-deg", evaState.pitch);
setprop("/sim/current-view/roll-offset-deg", evaState.roll);

#print(evaState.yaw, " ", evaState.pitch, " ", evaState.roll);


if (eva_loop_flag == 1) {settimer(EVA_loop, 0.0);}

}


var init_tank = func {

var pitch = getprop("/orientation/pitch-deg");
var yaw =getprop("/orientation/heading-deg");
var roll = getprop("/orientation/roll-deg");

etState = stateVector.new (0,0.0,0,0.0,0.0,0.0,yaw, pitch, roll);


setprop("/controls/shuttle/orbital/tank-pitch-deg", 0.0);
setprop("/controls/shuttle/orbital/tank-yaw-deg", 0.0);
setprop("/controls/shuttle/orbital/tank-roll-deg", 0.0);

#print (etState.pitch);

#settimer(update_tank,2.0);

update_tank();
}

var update_tank = func {

#print("Hello");

var pitch = getprop("/orientation/pitch-deg");
var yaw = getprop("/orientation/heading-deg");
var roll = getprop("/orientation/roll-deg");

setprop("/controls/shuttle/orbital/tank-pitch-deg", pitch - etState.pitch );
setprop("/controls/shuttle/orbital/tank-yaw-deg", yaw- etState.yaw);
setprop("/controls/shuttle/orbital/tank-roll-deg", roll - etState.roll);

var accx = -getprop("/fdm/jsbsim/accelerations/a-pilot-x-ft_sec2") * 0.3048;
var accy = getprop("/fdm/jsbsim/accelerations/a-pilot-y-ft_sec2") * 0.3048;
var accz = getprop("/fdm/jsbsim/accelerations/a-pilot-z-ft_sec2") * 0.3048;

etState.update(accx,accy,accz,0.0,0.0,0.0);

setprop("/controls/shuttle/orbital/tank-x-m", etState.x);
setprop("/controls/shuttle/orbital/tank-y-m", etState.y);
setprop("/controls/shuttle/orbital/tank-z-m", etState.z);

settimer(update_tank,0.0);
}
