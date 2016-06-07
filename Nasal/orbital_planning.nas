
# orbital planning tools for the Space Shuttle
# Thorsten Renk 2015 - 2016

# note that the orbital computations here are all done in metric units
# and need to be converted to imperial units for display purposes


############################################################
# gravitational constant
############################################################ 

# GM is extracted from JSBSim, Wikipedia gives rather 398600.44 km^2/s^-2, the reason is
# that JSBSim does not assume a Newtonian pointmass Earth
# what we do is an approximation still...

var GM = 398759391386476.0; 
#var GM =  398600441800000.0;

############################################################
# reference constants
############################################################ 

# calculations take a finite time, we need to store the point where
# we started them, or we'll incur errors

var target_reference_anomaly = 0.0;
var target_reference_time = 0.0;



############################################################
# prediction of apoapsis and periapsis for PEG 7 burn target
############################################################

var compute_apses = func (r, v) {

var mu = getprop("/fdm/jsbsim/systems/orbital/gm");

# first we determine the eccentricity vector

var epsilon = [0,0,0];

var norm_r = math.sqrt(SpaceShuttle.dot_product(r,r));

var term1 = SpaceShuttle.scalar_product( SpaceShuttle.dot_product(v,v)/mu, r);
var term2 = SpaceShuttle.scalar_product (-SpaceShuttle.dot_product(r,v)/mu, v);
var term3 = SpaceShuttle.scalar_product(-1./norm_r, r);

var epsilon = SpaceShuttle.add_vector(term1, term2);
epsilon = SpaceShuttle.add_vector(epsilon, term3);

# the eccentricity is the norm of the vector

var e = math.sqrt(SpaceShuttle.dot_product(epsilon,epsilon));

var a = mu/(2*mu/norm_r - SpaceShuttle.dot_product(v,v));

var apoapsis = a * (1+e);
var periapsis = a * (1-e);

return [periapsis, apoapsis];
}

############################################################
# prediction of time to next apsis
############################################################

# as of now, this is a simple formula assuming a near-circular orbit

var time_to_apsis = func {

var angle_to_periapsis = getprop("/fdm/jsbsim/systems/orbital/angle-to-periapsis-rad");
var vspeed = getprop("/velocities/vertical-speed-fps");
var orbital_period = getprop("/fdm/jsbsim/systems/orbital/orbital-period-s");

var apsis_type = 1;

var angle = angle_to_periapsis;

if (vspeed > 0.0) # we're heading to the apoapsis
	{
	angle = math.pi - angle;
	apsis_type = 2;
	}

return [apsis_type, angle/(2.0 * math.pi) * orbital_period]; 
}

############################################################
# prediction of node crossing time
############################################################

var time_to_node = func (L2) {

var L1 = [getprop("/fdm/jsbsim/systems/orbital/plane-x"), getprop("/fdm/jsbsim/systems/orbital/plane-y"), getprop("/fdm/jsbsim/systems/orbital/plane-z")];


L1 = SpaceShuttle.normalize(L1);

var pointing_vec_1 = SpaceShuttle.cross_product(L1, L2);
var pointing_vec_2 = SpaceShuttle.scalar_product(-1.0, pointing_vec_1);

pointing_vec_1 = SpaceShuttle.normalize(pointing_vec_1);
pointing_vec_2 = SpaceShuttle.normalize(pointing_vec_2);

var x = getprop("/fdm/jsbsim/position/eci-x-ft");
var y = getprop("/fdm/jsbsim/position/eci-y-ft");
var z = getprop("/fdm/jsbsim/position/eci-z-ft");
var radial = [x, y, z];
radial = SpaceShuttle.normalize(radial);

var vx = getprop("/fdm/jsbsim/velocities/eci-x-fps");
var vy = getprop("/fdm/jsbsim/velocities/eci-y-fps");
var vz = getprop("/fdm/jsbsim/velocities/eci-z-fps");
var prograde = [vx, vy, vz];
prograde = SpaceShuttle.normalize(prograde);

#print("L1: ", L1[0], " ", L1[1], " ", L1[2]);
#print("L2: ", L2[0], " ", L2[1], " ", L2[2]);
#print("R : ", radial[0], " ", radial[1], " ", radial[2]);
#print("P1: ", pointing_vec_1[0], " ", pointing_vec_1[1], " ", pointing_vec_1[2]);
#print("P2: ", pointing_vec_2[0], " ", pointing_vec_2[1], " ", pointing_vec_2[2]);

var P1dotV = SpaceShuttle.dot_product(pointing_vec_1, prograde);
var PdotR = 0.0;

if (P1dotV > 0.0) 
	{PdotR = SpaceShuttle.dot_product(pointing_vec_1, radial);} 
else 	
	{PdotR = SpaceShuttle.dot_product(pointing_vec_2, radial);} 

#if (P1dotV > 0.0) {print ("Using P1");} else {print("Using P2");}

var ang = math.acos(PdotR);

var orbital_period = getprop("/fdm/jsbsim/systems/orbital/orbital-period-s");
var time = ang/(2.0 * math.pi) * orbital_period;

#print("Ang: ", ang, " Time: ",time );



}


############################################################
# computation of Hohmann transfer orbit parameters
############################################################

var compute_hohmann = func (r1, r2) {

var t_H = math.pi * math.sqrt(math.pow(r1+r2,3.0)/(8.0 * GM));
var omega_2 = math.sqrt(GM/math.pow(r2,3.0));
var alpha = math.pi - omega_2 * t_H;

var dv1 = math.sqrt(GM/r1) * (math.sqrt((2.0*r2)/(r1+r2)) - 1.0 );
var dv2 = math.sqrt(GM/r2) * (1.0 - math.sqrt((2.0 * r1 )/(r1+r2)));

print("Hohmann transfer orbit computer:");
print("Transfer time: ", t_H, " angular alignment: ", alpha);
print("Dv1: ", dv1, " Dv2: ", dv2);

return [t_H, alpha, dv1, dv2];
}


############################################################
# orbital targeting
############################################################

var orbital_tgt_compute_t1 = func {

var tgt_id = getprop("/fdm/jsbsim/systems/navigation/orbital-tgt/tgt-id");

if (tgt_id > SpaceShuttle.n_orbital_targets) {return;}
if (tgt_id == 0) {return;}


# first, check whether we are in a circular orbit

var semimajor = getprop("/fdm/jsbsim/systems/orbital/semimajor-axis-length-ft") * 0.3048;
var epsilon = getprop("/fdm/jsbsim/systems/orbital/epsilon");

var r_max = semimajor * (1.0+epsilon);
var r_min = semimajor * (1.0-epsilon);

if ((r_max - r_min) > 5000.0)
	{
	print("Circularize orbit before calling rendezvous navigation!");
	return;
	}

# now get the angular distance between target and shuttle

var tgt_aol = oTgt.anomaly;
var aol = getprop("/fdm/jsbsim/systems/orbital/argument-of-latitude-deg");


var alpha = tgt_aol - aol;

# get the approach rate

var tgt_period = oTgt.period;
var period = getprop("/fdm/jsbsim/systems/orbital/orbital-period-s");

var tgt_omega = 2.0 * math.pi/tgt_period;
var omega = 2.0 * math.pi/period;

var alpha_rate = (omega - tgt_omega) * 180.0/math.pi;

#print("alpha: ", alpha, " alpha_rate: ", alpha_rate);

# compute the Hohmann transfer orbit parameters

var hohmann_pars = compute_hohmann(semimajor, oTgt.radius);
var alpha_h = hohmann_pars[1] * 180.0/math.pi;
var tig = (alpha - alpha_h)/alpha_rate;

setprop("/fdm/jsbsim/systems/ap/orbit-tgt/alpha-hohmann-deg", alpha_h);
setprop("/fdm/jsbsim/systems/ap/orbit-tgt/tig-hohmann-s", tig);

#print("TIG in: ", tig, " seconds");


# write resulting parameters to OMS burn plan

setprop("/fdm/jsbsim/systems/ap/oms-plan/dvx", hohmann_pars[2]/0.3048);
setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-dvx", hohmann_pars[2]/0.3048);
setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dvx", hohmann_pars[3]/0.3048);

#var elapsed = getprop("/sim/time/elapsed-sec");
#var MET = elapsed + getprop("/fdm/jsbsim/systems/timer/delta-MET");

#setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-seconds", int(MET + tig)); 			
#SpaceShuttle.set_oms_mnvr_timer();


# refine via a numerical state extrapolation to TIG 1

target_reference_anomaly = oTgt.anomaly;
target_reference_time = getprop("/sim/time/elapsed-sec");

setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-flag", 0);
setprop("/fdm/jsbsim/systems/ap/orbit-tgt/computation-t1",1);
state_extrapolate_current_to_condition(2.0 * tig, 0, alpha_h);

orbital_tgt_t1_numerics();
}


var orbital_tgt_t1_numerics = func {


if (getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-flag") == 0)
	{
	print ("Computing TIG 1...");
	settimer (orbital_tgt_t1_numerics, 1.0);
	return;
	}

setprop("/fdm/jsbsim/systems/ap/orbit-tgt/computation-t1",0);

var state_tig_x = [0,0,0];
var state_tig_v = [0,0,0];

state_tig_x[0] = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-x");
state_tig_x[1] = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-y");
state_tig_x[2] = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-z");

state_tig_v[0] = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-vx");
state_tig_v[1] = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-vy");
state_tig_v[2] = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-vz");

var elapsed = getprop("/sim/time/elapsed-sec");
var MET = elapsed + getprop("/fdm/jsbsim/systems/timer/delta-MET");
var time = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-time");
var time_offset = getprop("/sim/time/elapsed-sec") - target_reference_time;

#print("Calculation duration: ", time_offset, " s");
var tgt_pos = oTgt.get_future_inertial_pos(time - time_offset);

# get set of basis vectors

var prograde = [state_tig_v[0], state_tig_v[1], state_tig_v[2]];
prograde = SpaceShuttle.normalize(prograde);
var radial = [state_tig_x[0], state_tig_x[1], state_tig_x[2]];
radial = SpaceShuttle.normalize(radial);
radial = SpaceShuttle.orthonormalize(prograde, radial);
var normal = SpaceShuttle.cross_product(prograde, radial);

# get a set of distance vectors along the base vectors

var dvec = SpaceShuttle.subtract_vector(tgt_pos, state_tig_x);

var d_prograde = SpaceShuttle.dot_product(dvec,prograde);
var d_radial = SpaceShuttle.dot_product(dvec,radial);
var d_normal = SpaceShuttle.dot_product(dvec,normal);

# get target velocity

var tgt_pos1 = oTgt.get_future_inertial_pos(time - time_offset + 1.0);
var tgt_v = SpaceShuttle.subtract_vector(tgt_pos1, tgt_pos);

#print("tgt_v: ", tgt_v[0], " ", tgt_v[1], " ", tgt_v[2]);
#print("shuttle_v: ", state_tig_v[0], " ", state_tig_v[1], " ", state_tig_v[2]);
#print("radial: ", radial[0], " ", radial[1], " ", radial[2]);

var dv_vec = SpaceShuttle.subtract_vector(tgt_v, state_tig_v);

#print("dv_vec: ", dv_vec[0], " ", dv_vec[1], " ", dv_vec[2]);

var v_prograde = SpaceShuttle.dot_product(dv_vec, prograde);
var v_radial = SpaceShuttle.dot_product(dv_vec, radial);
var v_normal = SpaceShuttle.dot_product(dv_vec, normal);

# write delta's into the targeting plan

# tig starts earlier since we have an extended burn duration and not an impulse approximation

var tig_t1 = int(MET + time - time_offset - 15.0);
setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-seconds", tig_t1); 
SpaceShuttle.set_oms_mnvr_timer();

#print((MET + time - time_offset), " ", state_tig_x[0], " ", state_tig_x[1], " ", state_tig_x[2]);


setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-tig-s", tig_t1); 
setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-tig-string", SpaceShuttle.seconds_to_stringDHMS(tig_t1));

setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-dx", (d_prograde)/1000.0 / 0.3048);
setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-dy", (d_normal)/1000.0 / 0.3048);
setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-dz", (d_radial)/1000.0 / 0.3048);

setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-dxdot", (v_prograde) / 0.3048);
setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-dydot", (v_normal) / 0.3048);
setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-dzdot", (v_radial) / 0.3048);

var dist = SpaceShuttle.distance_between(state_tig_x, tgt_pos);

print("Distance at TIG 1 [km]: ", dist/1000.0);

var alpha_error = d_prograde/(2.0 * math.pi * SpaceShuttle.norm(state_tig_x)) * 360.0;

print("Angular dist at TIG 1: ", alpha_error);


# numerical state extrapolation to TIG 2

var dvx = getprop("/fdm/jsbsim/systems/ap/oms-plan/dvx") * 0.3048;
state_tig_v = add_peg7_target(state_tig_x, state_tig_v, [dvx, 0, 0]);

setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-flag", 0);



# target apoapsis - require to reach within 5 km of target alt because we may cross periapsis first
var tgt_alt = SpaceShuttle.norm(tgt_pos);
state_extrapolate_to_condition (state_tig_x, state_tig_v, time, time+3000.0, 3, tgt_alt - 5000.0, 0.0, 0.0);

orbital_tgt_t2_numerics();

}


var orbital_tgt_t2_numerics = func {



if (getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-flag") == 0)
	{
	print ("Computing TIG 2...");
	settimer (orbital_tgt_t2_numerics, 1.0);
	return;
	}

var state_tig_x = [0,0,0];
var state_tig_v = [0,0,0];

state_tig_x[0] = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-x");
state_tig_x[1] = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-y");
state_tig_x[2] = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-z");

state_tig_v[0] = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-vx");
state_tig_v[1] = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-vy");
state_tig_v[2] = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-vz");

var time = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-time");
var time_offset = getprop("/sim/time/elapsed-sec") - target_reference_time;
var tgt_pos = oTgt.get_future_inertial_pos(time - time_offset);

var elapsed = getprop("/sim/time/elapsed-sec");
var MET = elapsed + getprop("/fdm/jsbsim/systems/timer/delta-MET");
setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-tig-s", int(MET + time-time_offset)); 
setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-tig-string", SpaceShuttle.seconds_to_stringDHMS(int(MET + time-time_offset)));

# get set of basis vectors

var prograde = [state_tig_v[0], state_tig_v[1], state_tig_v[2]];
prograde = SpaceShuttle.normalize(prograde);
var radial = [state_tig_x[0], state_tig_x[1], state_tig_x[2]];
radial = SpaceShuttle.normalize(radial);
radial = SpaceShuttle.orthonormalize(prograde, radial);
var normal = SpaceShuttle.cross_product(prograde, radial);

# get a set of distance vectors along the base vectors

var dvec = SpaceShuttle.subtract_vector(tgt_pos, state_tig_x);

var d_prograde = SpaceShuttle.dot_product(dvec,prograde);
var d_radial = SpaceShuttle.dot_product(dvec,radial);
var d_normal = SpaceShuttle.dot_product(dvec,normal);

# get target velocity

var tgt_pos1 = oTgt.get_future_inertial_pos(time - time_offset + 1.0);
var tgt_v = SpaceShuttle.subtract_vector(tgt_pos1, tgt_pos);

#print("tgt_v: ", tgt_v[0], " ", tgt_v[1], " ", tgt_v[2]);
#print("shuttle_v: ", state_tig_v[0], " ", state_tig_v[1], " ", state_tig_v[2]);

var dv_vec = SpaceShuttle.subtract_vector(tgt_v, state_tig_v);

var v_prograde = SpaceShuttle.dot_product(dv_vec, prograde);
var v_radial = SpaceShuttle.dot_product(dv_vec, radial);
var v_normal = SpaceShuttle.dot_product(dv_vec, normal);

setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dx", (d_prograde)/1000.0 / 0.3048);
setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dy", (d_normal)/1000.0 / 0.3048);
setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dz", (d_radial)/1000.0 / 0.3048);

var dist = SpaceShuttle.distance_between(state_tig_x, tgt_pos);

print("Distance at TIG 2 [km]: ", dist/1000.0);

var alpha_error = d_prograde/(2.0 * math.pi * SpaceShuttle.norm(state_tig_x)) * 360.0;

var dalt = SpaceShuttle.norm(tgt_pos) - SpaceShuttle.norm(state_tig_x);

print("Angular dist at TIG 2: ", alpha_error);
print("Altitude difference at TIG 2: ", dalt/1000.0);

# iteration code, doesn't work properly yet

#if (0==1)
if (math.abs(alpha_error) > 0.1)
	{
	if ((getprop("/sim/time/elapsed-sec") - target_reference_time) > 60.0)
		{
		print("No convergence in 60 seconds - exiting");
		return;
		}

	print (" ");
	print ("Iterating TIG 1");
	var alpha_h = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/alpha-hohmann-deg");
	var tig_h = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/tig-hohmann-s");

 

	# get current angular distance

 	var alpha_current = angle_to_tgt();
	var new_alpha_tgt = alpha_h -  alpha_error;	
	
	print("Current alpha: ", alpha_current, " new alpha: ", new_alpha_tgt);

	if (alpha_current  < new_alpha_tgt)
		{
		print("TIG 1 solution in the past - exiting");
		}

	#print ("alpha_H: ",alpha_h, " alpha_error: ", alpha_error);
	#print("Current tgt AOL: ", oTgt.anomaly, " Shuttle: ", getprop("/fdm/jsbsim/systems/orbital/argument-of-latitude-deg"));


	target_reference_anomaly = oTgt.anomaly;
	target_reference_time = getprop("/sim/time/elapsed-sec");
	setprop("/fdm/jsbsim/systems/ap/orbit-tgt/computation-t1",1);
	setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-flag", 0);
	state_extrapolate_current_to_condition(2.0 * tig_h, 0, new_alpha_tgt);


	orbital_tgt_t1_numerics();
	return;
	}

# accept the solution and write the deltas into targeting plan

var tgt_pos1 = oTgt.get_future_inertial_pos(time - time_offset + 1.0);
var tgt_v = SpaceShuttle.subtract_vector(tgt_pos1, tgt_pos);

setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dvx", (tgt_v[0] - state_tig_v[0]) / 0.3048);
setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dvy", (tgt_v[1] - state_tig_v[1]) / 0.3048);
setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dvz", (tgt_v[2] - state_tig_v[2]) / 0.3048);

setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dx", (tgt_pos[0] - state_tig_x[0])/1000.0 / 0.3048);
setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dy", (tgt_pos[1] - state_tig_x[1])/1000.0 / 0.3048);
setprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dz", (tgt_pos[2] - state_tig_x[2])/1000.0 / 0.3048);

}


############################################################
# various distance measures to the target
############################################################

var distance_to_tgt = func {

var x = getprop("/fdm/jsbsim/position/eci-x-ft") * 0.3048;
var y = getprop("/fdm/jsbsim/position/eci-y-ft") * 0.3048;
var z = getprop("/fdm/jsbsim/position/eci-z-ft") * 0.3048;

var tgt_pos = oTgt.get_inertial_pos();

var dx = x - tgt_pos[0];
var dy = y - tgt_pos[1];
var dz = z - tgt_pos[2];

var alt = math.sqrt(x*x + y*y + z*z);
var alt_tgt = math.sqrt(tgt_pos[0]*tgt_pos[0] + tgt_pos[1]*tgt_pos[1] + tgt_pos[2]*tgt_pos[2]);
var dalt = alt_tgt - alt;

var dist = math.sqrt(dx * dx + dy * dy + dz * dz);

var tgt_aol = oTgt.anomaly;
var aol = getprop("/fdm/jsbsim/systems/orbital/argument-of-latitude-deg");
var path_dist = (tgt_aol - aol) * math.pi/180.0 * alt;

var resid = dist * dist - path_dist * path_dist - dalt * dalt;

if (resid > 0.) {resid = math.sqrt(resid);} else {resid =0.0;}


var vx = getprop("/fdm/jsbsim/velocities/eci-x-fps") * 0.3048;
var vy = getprop("/fdm/jsbsim/velocities/eci-y-fps") * 0.3048;
var vz = getprop("/fdm/jsbsim/velocities/eci-z-fps") * 0.3048;
var prograde = [vx, vy, vz];
prograde = SpaceShuttle.normalize(prograde);
var radial = [x,y,z];
radial = SpaceShuttle.normalize(radial);
radial = SpaceShuttle.orthonormalize(prograde, radial);

var normal = SpaceShuttle.cross_product(prograde, radial);

var dvec = [dx, dy, dz];

var dist_prograde = -SpaceShuttle.dot_product(dvec, prograde);
var dist_radial = -SpaceShuttle.dot_product(dvec, radial);
var dist_normal = SpaceShuttle.dot_product(dvec, normal);

var prograde_angle = dist_prograde/(2.0 * math.pi * alt) * 360.0;

print("Distance to target: ", dist/1000.0, " km");
print("Angle to target: ", tgt_aol - aol, " deg ", "Prograde angle: ", prograde_angle);
print("Alt. difference: ", dalt/1000.0, " anomaly dist: ", path_dist/1000.0);
print("Lateral residual: ", resid/1000.0);
print("Prograde: ", dist_prograde/1000.0);
print("Radial: ", dist_radial/1000.0);
print("Normal: ", dist_normal/1000.0);


}

var angle_to_tgt = func {

var x = getprop("/fdm/jsbsim/position/eci-x-ft") * 0.3048;
var y = getprop("/fdm/jsbsim/position/eci-y-ft") * 0.3048;
var z = getprop("/fdm/jsbsim/position/eci-z-ft") * 0.3048;

var tgt_pos = oTgt.get_inertial_pos();

var dx = x - tgt_pos[0];
var dy = y - tgt_pos[1];
var dz = z - tgt_pos[2];

var alt = math.sqrt(x*x + y*y + z*z);

var vx = getprop("/fdm/jsbsim/velocities/eci-x-fps") * 0.3048;
var vy = getprop("/fdm/jsbsim/velocities/eci-y-fps") * 0.3048;
var vz = getprop("/fdm/jsbsim/velocities/eci-z-fps") * 0.3048;

var prograde = [vx, vy, vz];
prograde = SpaceShuttle.normalize(prograde);
var radial = [x,y,z];
radial = SpaceShuttle.normalize(radial);
radial = SpaceShuttle.orthonormalize(prograde, radial);

var normal = SpaceShuttle.cross_product(prograde, radial);

var dvec = [dx, dy, dz];

var dist_prograde = -SpaceShuttle.dot_product(dvec, prograde);

return  dist_prograde/(2.0 * math.pi * alt) * 360.0;


}


############################################################
# numerical extrapolation of state vector
############################################################


var state_extrapolate_current = func (time) {

var x = [getprop("/fdm/jsbsim/position/eci-x-ft") * 0.3048, getprop("/fdm/jsbsim/position/eci-y-ft") * 0.3048, getprop("/fdm/jsbsim/position/eci-z-ft") * 0.3048];

var v = [getprop("/fdm/jsbsim/velocities/eci-x-fps") * 0.3048, getprop("/fdm/jsbsim/velocities/eci-y-fps") * 0.3048, getprop("/fdm/jsbsim/velocities/eci-z-fps") * 0.3048];



state_extrapolate(x, v, 0.0, time);

}

 

var state_extrapolate = func (state_x, state_v, time_sum, time_end) {

var dt = 0.05;
var n = 0;

while (time_sum < time_end) 
	{
	# gravity vector is along radius vector
	var G = [state_x[0], state_x[1], state_x[2]];
	var Gnorm = math.sqrt(math.pow(G[0],2.0) + math.pow(G[1],2.0) + math.pow(G[2],2.0));

	# gravitational acceleration
	var g = GM/(Gnorm* Gnorm);

	G[0] = -G[0]/Gnorm * g;
	G[1] = -G[1]/Gnorm * g;
	G[2] = -G[2]/Gnorm * g;

	# right now, gravity is the only force, but we can extend here
	var acc = [0,0,0];

	acc[0] = G[0];
	acc[1] = G[1];
	acc[2] = G[2];

	# update position
	state_x[0] = state_x[0] + state_v[0] * dt + 0.5 * acc[0] * dt * dt;
	state_x[1] = state_x[1] + state_v[1] * dt + 0.5 * acc[1] * dt * dt;
	state_x[2] = state_x[2] + state_v[2] * dt + 0.5 * acc[2] * dt * dt;

	# update velocity

	state_v[0] = state_v[0] + acc[0] * dt;
	state_v[1] = state_v[1] + acc[1] * dt;
	state_v[2] = state_v[2] + acc[2] * dt;

	#if (n == 100)
	#	{print(state_x[0], " ", state_x[1]);
	#	n = 0;		
	#	}


	n=n+1;
	time_sum += dt;
	if ((time_sum > time_end) or (n > 1000)) {break;}
	}

	
if (time_sum > time_end)
	{
	state_extrapolate_finish(state_x, state_v);
	return;
	}
else
	{
	settimer ( func{state_extrapolate(state_x, state_v, time_sum, time_end); }, 0.0 );
	}

#print (n, " iterations.");

#print ("x: ", state_x[0], " y: ", state_x[1], " z: ", state_x[2]);
#print ("vx: ", state_v[0], " vy: ", state_v[1], " vz: ", state_v[2]);

}


################################################################
# numerical extrapolation of state vector to a certain condition
################################################################

var state_extrapolate_current_to_condition = func (time, condition_flag, condition_value) {

target_reference_anomaly = oTgt.anomaly;
target_reference_time = getprop("/sim/time/elapsed-sec");

var x = [getprop("/fdm/jsbsim/position/eci-x-ft") * 0.3048, getprop("/fdm/jsbsim/position/eci-y-ft") * 0.3048, getprop("/fdm/jsbsim/position/eci-z-ft") * 0.3048];

var v = [getprop("/fdm/jsbsim/velocities/eci-x-fps") * 0.3048, getprop("/fdm/jsbsim/velocities/eci-y-fps") * 0.3048, getprop("/fdm/jsbsim/velocities/eci-z-fps") * 0.3048];



state_extrapolate_to_condition(x, v, 0.0, time, condition_flag, condition_value, 0.0, 0.0);

}

var state_extrapolate_to_condition = func (state_x, state_v, time_sum, time_end, condition_id, condition_value, par_last, par_llast) {

var dt = 0.05;
var n = 0;
var n1 = 0;

var condition_flag = 0;

while (time_sum < time_end) 
	{
	# gravity vector is along radius vector
	var G = [state_x[0], state_x[1], state_x[2]];
	var Gnorm = math.sqrt(math.pow(G[0],2.0) + math.pow(G[1],2.0) + math.pow(G[2],2.0));

	# gravitational acceleration
	var g = GM/(Gnorm* Gnorm);

	G[0] = -G[0]/Gnorm * g;
	G[1] = -G[1]/Gnorm * g;
	G[2] = -G[2]/Gnorm * g;

	var pos_norm = SpaceShuttle.normalize(state_x);

	var sin_lat = pos_norm[2];
	var cos_lat = math.sqrt(1.0 - sin_lat * sin_lat);
	var sin_lon = pos_norm[1];
	var cos_lon = pos_norm[0];

	
	var A_mag = 0.0243 * sin_lat * cos_lat;
	var A = [A_mag * cos_lon * sin_lat, A_mag * sin_lon * sin_lat, -A_mag * cos_lat];


	# point mass gravity plus corrections
	var acc = [0,0,0];

	acc[0] = G[0] + A[0];
	acc[1] = G[1] + A[1];
	acc[2] = G[2] + A[2];

	# update position
	state_x[0] = state_x[0] + state_v[0] * dt + 0.5 * acc[0] * dt * dt;
	state_x[1] = state_x[1] + state_v[1] * dt + 0.5 * acc[1] * dt * dt;
	state_x[2] = state_x[2] + state_v[2] * dt + 0.5 * acc[2] * dt * dt;

	# update velocity

	state_v[0] = state_v[0] + acc[0] * dt;
	state_v[1] = state_v[1] + acc[1] * dt;
	state_v[2] = state_v[2] + acc[2] * dt;


	n=n+1;
	n1 = n1 + 1;
	time_sum += dt;

	if ((time_sum > time_end) or (n > 1000)) {break;}

	# check condition every 100 iterations or 5 seconds

	if (n1 == 100)
		{
		var MET = getprop("/sim/time/elapsed-sec") + getprop("/fdm/jsbsim/systems/timer/delta-MET");
		var t_offset = getprop("/sim/time/elapsed-sec") - target_reference_time;
		#print(time_sum - t_offset + MET, " ", state_x[0], " ", state_x[1], " ", state_x[2]);
		n1 = 0;

		if (condition_id == 0) # alpha value relative to a target
			{
			#var elements = get_orbital_elements(state_x, state_v);
			#var aol = (elements[4] + elements[5]) * 180.0/math.pi;
			#var target_aol = target_reference_anomaly + time_sum/oTgt.period * 360.0;
			
			#var alpha = target_aol - aol;
			#if (alpha < 0.0) {alpha = alpha + 360.0;}
			#if (alpha > 360.0) {alpha = alpha - 360.0;}

		
			var prograde = [state_v[0], state_v[1], state_v[2]];
			prograde = SpaceShuttle.normalize(prograde);
			var radial = [state_x[0],state_x[1],state_x[2]];
			radial = SpaceShuttle.normalize(radial);
			radial = SpaceShuttle.orthonormalize(prograde, radial);

			var normal = SpaceShuttle.cross_product(prograde, radial);

			var time_offset = getprop("/sim/time/elapsed-sec") - target_reference_time;
			var tgt_pos = oTgt.get_future_inertial_pos(time_sum - time_offset);

			var dx = state_x[0] - tgt_pos[0];
			var dy = state_x[1] - tgt_pos[1];
			var dz = state_x[2] - tgt_pos[2];
			var dvec = [dx, dy, dz];

			var dist_prograde = -SpaceShuttle.dot_product(dvec, prograde);
	
			var alt = SpaceShuttle.norm(state_x);
			var alpha = dist_prograde/(2.0 * math.pi * alt) * 360.0;

	

			if (alpha < condition_value) 
				{
				condition_flag = 1; 
				print("alpha:", alpha, " tgt_alpha: ", condition_value); 
				}

			}
		else if (condition_id == 1) # closest distance
			{

			var time_offset = getprop("/sim/time/elapsed-sec") - target_reference_time;
			var tgt_inertial_pos = oTgt.get_future_inertial_pos(time_sum - time_offset);

			var dist = SpaceShuttle.distance_between(state_x, tgt_inertial_pos);

			# diagnostics...
			var elements = get_orbital_elements(state_x, state_v);
			var aol = (elements[4] + elements[5]) * 180.0/math.pi;
			var target_aol = target_reference_anomaly + time_sum/oTgt.period * 360.0;
			var alpha = target_aol - aol;
			if (alpha < 0.0) {alpha = alpha + 360.0;}
			if (alpha > 360.0) {alpha = alpha - 360.0;}
			var tgt_alt = SpaceShuttle.norm(tgt_inertial_pos);
			var alt = SpaceShuttle.norm(state_x);
			var path_dist = alpha * alt /180.0 * math.pi;
			var dalt = tgt_alt - alt;
			
			var resid = dist * dist - path_dist * path_dist - dalt * dalt;	
			if (resid > 0.0) {resid = math.sqrt(resid);} else {resid = 0.0;}



			#print("Distance to target: ", dist/1000.0, " km");
			#print("Alpha: ", alpha);
			#print("Alt. difference: ", dalt/1000.0, " anomaly dist: ", path_dist/1000.0);
			#print("Lateral residual: ", resid/1000.0);

			if ((dist > par_last)  and (dist < condition_value) and (dist > par_llast + 2.0))
				{
				condition_flag = 1; 
				print("Closest distance:", dist/1000.0, " km"); 
				}
			if (dist < par_last) {par_llast = dist;}
			par_last = dist;

			}
		else if (condition_id == 2) # closest altitude difference
			{
			var time_offset = getprop("/sim/time/elapsed-sec") - target_reference_time;
			var tgt_inertial_pos = oTgt.get_future_inertial_pos(time_sum - time_offset);

			var tgt_alt = SpaceShuttle.norm(tgt_inertial_pos);
			var alt = SpaceShuttle.norm(state_x);

			var dist = math.abs(tgt_alt - alt);
			#print (dist);

			# diagnostics...
			var elements = get_orbital_elements(state_x, state_v);
			var aol = (elements[4] + elements[5]) * 180.0/math.pi;
			var target_aol = target_reference_anomaly + time_sum/oTgt.period * 360.0;
			var alpha = target_aol - aol;
			if (alpha < 0.0) {alpha = alpha + 360.0;}
			if (alpha > 360.0) {alpha = alpha - 360.0;}
			var path_dist = alpha * alt /180.0 * math.pi;
			var dist1 = SpaceShuttle.distance_between(state_x, tgt_inertial_pos);
			var resid = dist1 * dist1 - path_dist * path_dist - dist * dist;	
			if (resid > 0.0) {resid = math.sqrt(resid);} else {resid = 0.0;}



			#print("Distance to target: ", dist1/1000.0, " km");
			#print("Alpha: ", alpha);
			#print("Alt. difference: ", dist/1000.0, " anomaly dist: ", path_dist/1000.0);
			#print("Lateral residual: ", resid/1000.0);
			
			if ((dist > par_last) and (dist < condition_value))
				{
				condition_flag = 1; 
				print("Closest altitude distance:", dist/1000.0, " km"); 
				}
			par_last = dist;

			}

		else if (condition_id == 3) # to apoapsis
			{
			var alt = SpaceShuttle.norm(state_x);

			if ((alt < par_last) and (alt > condition_value))
				{
				condition_flag = 1; 
				print("Apoapsis at: ", alt/1000.0, " km"); 
				}
			par_last = alt;
			

			}
			

		}

	if (condition_flag == 1) {break;}

	}

	
if ((time_sum > time_end) or (condition_flag == 1))
	{
	setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-time", time_sum);
	print("Finished, time is: ", time_sum);
	state_extrapolate_finish(state_x, state_v);
	return;
	}
else
	{
	settimer ( func{state_extrapolate_to_condition(state_x, state_v, time_sum, time_end, condition_id, condition_value, par_last, par_llast); }, 0.0 );
	}


}



var state_extrapolate_finish = func (state_x, state_v) {

setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-x", state_x[0]);
setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-y", state_x[1]);
setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-z", state_x[2]);

setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-vx", state_v[0]);
setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-vy", state_v[1]);
setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-vz", state_v[2]);

# compute the orbital elements of the extrapolated vectors

var elements = get_orbital_elements(state_x, state_v);

var aol = elements[5]+elements[4];
if (aol > 2.0 * math.pi) {aol = aol - 2.0 * math.pi;}

setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-epsilon", elements[1]);
setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-inclination-deg", elements[2] * 180.0/math.pi);
setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-asc-node-long-deg", elements[3] * 180.0/math.pi);
setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-periapsis-arg-deg", elements[4] * 180.0/math.pi);
setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-true-anomaly-deg", elements[5] * 180.0/math.pi);
setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-arg-of-lat-deg", aol * 180.0/math.pi);

setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-flag", 1);

var radius = getprop("/fdm/jsbsim/ic/sea-level-radius-ft") * 0.3048;
#print ("x: ", state_x[0], " y: ", state_x[1], " z: ", state_x[2]);
#print ("vx: ", state_v[0], " vy: ", state_v[1], " vz: ", state_v[2]);

}

############################################################
# add a PEG 7 target to the state vector
############################################################

var add_peg7_target = func (state_x, state_v, dv) {

# construct prograde/radial/normal coordinate system for this state vector

var prograde = [state_v[0], state_v[1], state_v[2]];
var radial = [state_x[0], state_x[1], state_x[2]];

prograde = SpaceShuttle.normalize(prograde);
radial = SpaceShuttle.normalize(radial);
radial = SpaceShuttle.orthonormalize(prograde, radial);

var normal = SpaceShuttle.cross_product(prograde, radial);

# now get the inertial velocity change components for the burn taget

var tgt = [0,0,0];

tgt[0] = dv[0] * prograde[0] + dv[1] * normal[0] + dv[2] * radial[0];
tgt[1] = dv[0] * prograde[1] + dv[1] * normal[1] + dv[2] * radial[1];
tgt[2] = dv[0] * prograde[2] + dv[1] * normal[2] + dv[2] * radial[2];



# add the burn target velocity components to the state vector
#var dv = scalar_product(oms_burn_target.dvtot, [tgt0, tgt1, tgt2]);

state_v = add_vector(state_v, tgt);


return state_v;
}

############################################################
# compute orbital elements from state vector
############################################################

var test_orbital_elements = func {

var x = [getprop("/fdm/jsbsim/position/eci-x-ft") * 0.3048, getprop("/fdm/jsbsim/position/eci-y-ft") * 0.3048, getprop("/fdm/jsbsim/position/eci-z-ft") * 0.3048];

var v = [getprop("/fdm/jsbsim/velocities/eci-x-fps") * 0.3048, getprop("/fdm/jsbsim/velocities/eci-y-fps") * 0.3048, getprop("/fdm/jsbsim/velocities/eci-z-fps") * 0.3048];

var elements = get_orbital_elements(x, v);

print("Semimajor axis [km]: ", elements[0]/1000.0);
print("Eccentricity: ", elements[1]);
print("Inclination [deg]: ", elements[2] * 180.0/math.pi);
print("Asc. node [deg]: " , elements[3] * 180.0/math.pi);
print("Periapsis arg [deg]: ", elements[4] * 180.0/math.pi);
print("True anomaly [deg]: ", elements[5] * 180.0/math.pi);
}

var get_orbital_elements = func (state_x, state_v) {

var specific_energy = 0.5 * SpaceShuttle.dot_product(state_v, state_v) - GM/SpaceShuttle.norm(state_x);
var semimajor = - GM/(2.0 * specific_energy);

var r_dot_v = SpaceShuttle.dot_product(state_x, state_v);
var h = SpaceShuttle.cross_product(state_x, state_v);
var h_norm = SpaceShuttle.norm(h);

var epsilon_vec = SpaceShuttle.scalar_product(1.0/GM, SpaceShuttle.cross_product(state_v, h));
epsilon_vec = SpaceShuttle.subtract_vector(epsilon_vec,SpaceShuttle.normalize(state_x));
var epsilon = SpaceShuttle.norm(epsilon_vec);

var inc = math.acos(h[2]/h_norm);

var n_vec = [-h[1], h[0], 0.0];
var n_norm = SpaceShuttle.norm(n_vec);

var Omega = math.acos(n_vec[0]/n_norm);
if (n_vec[1] < 0.0) {Omega = 2.0 * math.pi - Omega;}

var parg = math.acos(SpaceShuttle.dot_product(SpaceShuttle.normalize(n_vec), SpaceShuttle.normalize(epsilon_vec)));
if (epsilon_vec[2] < 0.0) {parg = 2.0 * math.pi - parg;}

var true_anomaly = math.acos(SpaceShuttle.dot_product(SpaceShuttle.normalize(epsilon_vec), SpaceShuttle.normalize(state_x)));

if (r_dot_v < 0.0) {true_anomaly = 2.0 * math.pi - true_anomaly;}

return [semimajor, epsilon, inc, Omega, parg, true_anomaly];

}
