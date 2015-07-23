# payload management for the Space Shuttle

var rms_grab_payload = func {

# get the position and orientation of the effector tip

var effector_x = getprop("/fdm/jsbsim/systems/rms/effector-x");
var effector_y = getprop("/fdm/jsbsim/systems/rms/effector-y");
var effector_z = getprop("/fdm/jsbsim/systems/rms/effector-z");


var effector_yaw = getprop("/fdm/jsbsim/systems/rms/sum-wrist-yaw-deg");
var effector_pitch = getprop("/fdm/jsbsim/systems/rms/sum-wrist-pitch-deg");
var effector_roll = getprop("/fdm/jsbsim/systems/rms/ang-wrist-roll-deg");

# get the payload position

var payload_x = getprop("/fdm/jsbsim/systems/rms/payload-attach-x");
var payload_y = getprop("/fdm/jsbsim/systems/rms/payload-attach-y");
var payload_z = getprop("/fdm/jsbsim/systems/rms/payload-attach-z");

# require agreement in position

var flag = 1;

if (math.abs(effector_x - payload_x) > 0.15) {flag = 0;}
if (math.abs(effector_y - payload_y) > 0.15) {flag = 0;}
if (math.abs(effector_z - payload_z) > 0.15) {flag = 0;}

#print ("x difference: ", math.abs(effector_x - payload_x));
#print ("y difference: ", math.abs(effector_y - payload_y));
#print ("z difference: ", math.abs(effector_z - payload_z));

if (math.abs(effector_yaw ) > 10.0) {flag = 0;}
if (math.abs(effector_pitch ) > 10.0) {flag = 0;}

#print ("yaw: ", math.abs(effector_yaw ));
#print ("pitch: ", math.abs(effector_yaw ));

if (flag == 0)
	{
	setprop("/sim/messages/copilot", "Failed to grab payload!");
	return;
	}
else
	{
	setprop("/sim/messages/copilot", "Payload successfully attached!");
	setprop("/fdm/jsbsim/systems/rms/effector-attached", 1);
	}


}


var rms_release_payload = func {


	setprop("/sim/messages/copilot", "Payload released!");
	setprop("/fdm/jsbsim/systems/rms/effector-attached", 2);
	SpaceShuttle.init_payload();
}
