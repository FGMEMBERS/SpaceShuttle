# state vector management for the Space Shuttle
# Thorsten Renk 2016

# the modeling of state vector error evolution is done in Nasal, the resulting state vectors need to be
# available at FDM rate and are computed in JSBSim


# drift function for state vector errors
# fundamentally state vectors drift because the propagation model isn't perfect and because
# IMU acceleration sensing isn't perfect - thus over time velocity errors and resulting
# position errors creep in

var update_sv_errors = func {

var v_error_rate = 0.001; # 0.1 mm/s^2
var ang_error_rate = 0.001; # 0.001 deg/s
var gps_pos_accuracy = 70.0;


# do nothing if we don't model state vector error drift

if (getprop("/fdm/jsbsim/systems/navigation/state-vector/use-realistic-sv") == 0)
	{return;}


# update the vehicle propagated velocity errors assuming random drift

var vxe = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/vx-m_s");
var vye = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/vy-m_s");
var vze = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/vz-m_s");

vxe = vxe + v_error_rate * 2.0 * (rand() - 0.5);
vye = vye + v_error_rate * 2.0 * (rand() - 0.5);
vze = vze + v_error_rate * 2.0 * (rand() - 0.5);

setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/vx-m_s", vxe);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/vy-m_s", vye);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/vz-m_s", vze);

var ve = SpaceShuttle.norm([vxe, vye, vze]); 

setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/v-m_s", ve);

# update the propagated position errors created by the velocity errors
# timestep is a second

var xe = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/x-m");
var ye = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/y-m");
var ze = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/z-m");

xe = xe + vxe;
ye = ye + vye;
ze = ze + vze;

# clamp to GPS accuracy 

xe = SpaceShuttle.clamp(xe, -gps_pos_accuracy, gps_pos_accuracy);
ye = SpaceShuttle.clamp(ye, -gps_pos_accuracy, gps_pos_accuracy);
ze = SpaceShuttle.clamp(ze, -gps_pos_accuracy, gps_pos_accuracy);

setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/x-m", xe);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/y-m", ye);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/z-m", ze);

var pos_e = SpaceShuttle.norm([xe, ye, ze]);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/pos-m", pos_e);

# drift of pitch, yaw and roll errors

var pe = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/pitch-deg");
var ye = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/yaw-deg");
var re = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/roll-deg");

pe = pe + ang_error_rate * 2.0 * (rand() - 0.5);
ye = ye + ang_error_rate * 2.0 * (rand() - 0.5);
re = re + ang_error_rate * 2.0 * (rand() - 0.5);

setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/pitch-deg", pe);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/yaw-deg", ye);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/roll-deg", re);

setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/angle-deg", 0.333* (pe + ye + re));

# if we have rendezvous navigation on, we also need to update target and combined errors

if (getprop("/fdm/jsbsim/systems/rendezvous/rel-nav-enable") == 1)
	{
	var vxet = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-tgt/vx-m_s");
	var vyet = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-tgt/vy-m_s");
	var vzet = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-tgt/vz-m_s");

	vxet = vxet + v_error_rate * 2.0 * (rand() - 0.5);
	vyet = vyet + v_error_rate * 2.0 * (rand() - 0.5);
	vzet = vzet + v_error_rate * 2.0 * (rand() - 0.5);

	setprop("/fdm/jsbsim/systems/navigation/state-vector/error-tgt/vx-m_s", vxet);
	setprop("/fdm/jsbsim/systems/navigation/state-vector/error-tgt/vy-m_s", vyet);
	setprop("/fdm/jsbsim/systems/navigation/state-vector/error-tgt/vz-m_s", vzet);

	var xet = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-tgt/x-m");
	var yet = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-tgt/y-m");
	var zet = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-tgt/z-m");

	xet = xet + vxet;
	yet = yet + vyet;
	zet = zet + vzet;

	setprop("/fdm/jsbsim/systems/navigation/state-vector/error-tgt/x-m", xet);
	setprop("/fdm/jsbsim/systems/navigation/state-vector/error-tgt/y-m", yet);
	setprop("/fdm/jsbsim/systems/navigation/state-vector/error-tgt/z-m", zet);

	var vxec = vxet + vxe;
	var vyec = vyet + vye;
	var vzec = vzet + vze;

	setprop("/fdm/jsbsim/systems/navigation/state-vector/error-rndz/vx-m_s", vxec);
	setprop("/fdm/jsbsim/systems/navigation/state-vector/error-rndz/vy-m_s", vyec);
	setprop("/fdm/jsbsim/systems/navigation/state-vector/error-rndz/vz-m_s", vzec);

	var vec = SpaceShuttle.norm([vxec, vyec, vzec]);

	setprop("/fdm/jsbsim/systems/navigation/state-vector/error-rndz/v-m_s", vec);

	var xec = xe + xet;
	var yec = ye + yet;
	var zec = ze + zet;
	
	setprop("/fdm/jsbsim/systems/navigation/state-vector/error-rndz/x-m", xec);
	setprop("/fdm/jsbsim/systems/navigation/state-vector/error-rndz/y-m", yec);
	setprop("/fdm/jsbsim/systems/navigation/state-vector/error-rndz/z-m", zec);

	var pos_ec = SpaceShuttle.norm([xec, yec, zec]);
	setprop("/fdm/jsbsim/systems/navigation/state-vector/error-rndz/pos-m", pos_ec);
	
	}
}


# when we have a filter, we have constraints for the state vector
# we model the filter as providing accuracies which we apply to the errors

# a filter can be applied to orbiter or target state vector
# or to the relative state vector, in which case it preserves absolute errors

var filter_to_orb_sv  = func (accuracy_pos, accuracy_v, accuracy_ang) {

var current_acc_pos = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/pos-m");

var xe = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/x-m");
var ye = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/y-m");
var ze = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/z-m");

var correction = accuracy_pos/current_acc_pos;
correction = SpaceShuttle.clamp(correction, 0.0, 1.0);

setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/x-m", xe*correction);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/y-m", ye*correction);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/z-m", ze*correction);

setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/pos-m", correction * current_acc_pos);

var current_acc_v = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/v-m_s");

var vxe = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/vx-m_s");
var vye = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/vy-m_s");
var vze = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/vz-m_s");

var correction_v = accuracy_v/current_acc_v;
correction_v = SpaceShuttle.clamp(correction_v, 0.0, 1.0);

setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/vx-m_s", vxe*correction_v);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/vy-m_s", vye*correction_v);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/vz-m_s", vze*correction_v);

setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/v-m_s", correction_v * current_acc_v);
}



# helper function to blur a coord hash with the current coord errors

var blur_tgt_coord  = func (coord) {

var xec = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-rndz/x-m");
var yec = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-rndz/y-m");
var zec = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-rndz/z-m");

coord.set_x (coord.x() + xec);
coord.set_y (coord.y() + yec);
coord.set_z (coord.z() + zec);

return coord;
}


# init function to clear all errors (perfect navigation)

var perfect_nav_on = func {

setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/vx-m_s", 0.0);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/vy-m_s", 0.0);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/vz-m_s", 0.0);

setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/v-m_s", 0.0);

setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/x-m", 0.0);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/y-m", 0.0);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/z-m", 0.0);

setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/pos-m", 0.0);

setprop("/fdm/jsbsim/systems/navigation/state-vector/error-tgt/vx-m_s", 0.0);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-tgt/vy-m_s", 0.0);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-tgt/vz-m_s", 0.0);

setprop("/fdm/jsbsim/systems/navigation/state-vector/error-tgt/v-m_s", 0.0);

setprop("/fdm/jsbsim/systems/navigation/state-vector/error-tgt/x-m", 0.0);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-tgt/y-m", 0.0);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-tgt/z-m", 0.0);

setprop("/fdm/jsbsim/systems/navigation/state-vector/error-tgt/pos-m", 0.0);

setprop("/fdm/jsbsim/systems/navigation/state-vector/error-rndz/vx-m_s", 0.0);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-rndz/vy-m_s", 0.0);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-rndz/vz-m_s", 0.0);

setprop("/fdm/jsbsim/systems/navigation/state-vector/error-rndz/v-m_s", 0.0);

setprop("/fdm/jsbsim/systems/navigation/state-vector/error-rndz/x-m", 0.0);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-rndz/y-m", 0.0);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-rndz/z-m", 0.0);

setprop("/fdm/jsbsim/systems/navigation/state-vector/error-rndz/pos-m", 0.0);

setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/pitch-deg", 0.0);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/yaw-deg", 0.0);
setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/rol-deg", 0.0);
}


var manage_nav_handling = func {

var handling = getprop("/fdm/jsbsim/systems/navigation/state-vector/use-realistic-sv");

if (handling == 0)
	{
	perfect_nav_on();
	print("Switching to perfect navigation state...");
	}
}

setlistener("/fdm/jsbsim/systems/navigation/state-vector/use-realistic-sv", func {manage_nav_handling();}, 0,0);
