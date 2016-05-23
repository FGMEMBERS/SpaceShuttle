
# orbital planning tools for the Space Shuttle
# Thorsten Renk 2015


############################################################
# gravitational constant
############################################################ 

var GM = 398759391386476.0; 

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

var omega = 2.0 * math.pi/period;
var tgt_omega = 2.0 * math.pi/tgt_period;

var alpha_rate = (omega - tgt_omega) * 180.0/math.pi;

print("alpha: ", alpha, " alpha_rate: ", alpha_rate);

# compute the Hohmann transfer orbit parameters

var hohmann_pars = compute_hohmann(semimajor, oTgt.radius);

var alpha_h = hohmann_pars[1] * 180.0/math.pi;
var tig = (alpha - alpha_h)/alpha_rate;

print("TIG in: ", tig, " seconds");


# write resulting parameters to OMS burn plan

setprop("/fdm/jsbsim/systems/ap/oms-plan/dvx", hohmann_pars[2]/0.3048);

var elapsed = getprop("/sim/time/elapsed-sec");
var MET = elapsed + getprop("/fdm/jsbsim/systems/timer/delta-MET");

setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-seconds", int(MET + tig)); 			
SpaceShuttle.set_oms_mnvr_timer();

# compute target position at TIG

var future_tgt_pos = oTgt.get_future_inertial_pos(tig);

# numerical state extrapolation to TIG

setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-flag", 0);
setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-candidate", (MET +tig));
state_extrapolate_current(tig);

orbital_tgt_t1_numerics();
}


var orbital_tgt_t1_numerics = func {


if (getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-flag") == 0)
	{
	print ("Computing TIG...");
	settimer (orbital_tgt_t1_numerics, 1.0);
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

var elapsed = getprop("/sim/time/elapsed-sec");
var MET = elapsed + getprop("/fdm/jsbsim/systems/timer/delta-MET");
var tig_test = getprop("/fdm/jsbsim/systems/ap/oms-plan/tig-candidate");

var time = tig_test - MET;
var tgt_pos = oTgt.get_future_inertial_pos(time);


var dx = state_tig_x[0] - tgt_pos[0];
var dy = state_tig_x[1] - tgt_pos[1];
var dz = state_tig_x[2] - tgt_pos[2];

var dist = math.sqrt(dx * dx + dy * dy + dz * dz);


print("Distance at TIG: ", dist);
}



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

print("Distance to target: ", dist/1000.0, " km");
print("Alt. difference: ", dalt/1000.0, " anomaly dist: ", path_dist/1000.0);
print("Lateral residual: ", resid/1000.0);


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

# GM is extracted from JSBSIm, Wikipedia gives rather 398600.44 km^2/s^-2, the reason is
# that JSBSim does not assume a Newtonian pointmass Earth

 
var dt = 0.05;
var n = 0;

while (time_sum < time_end) 
	{
	# gravity vector is along radius vector
	var G = [state_x[0], state_x[1], state_x[2]];

	#print(G[0], G[1], G[2]);
	var Gnorm = math.sqrt(math.pow(G[0],2.0) + math.pow(G[1],2.0) + math.pow(G[2],2.0));

	# gravitational acceleration
	var g = GM/(Gnorm* Gnorm);
	#print(g);

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

var state_extrapolate_finish = func (state_x, state_v) {

setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-x", state_x[0]);
setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-y", state_x[1]);
setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-z", state_x[2]);

setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-vx", state_v[0]);
setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-vy", state_v[1]);
setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-vz", state_v[2]);

# compute the orbital elements of the extrapolated vectors


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


setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-epsilon", epsilon);
setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-inclination-deg", inc * 180.0/math.pi);
setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-asc-node-long-deg", Omega * 180.0/math.pi);
setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-periapsis-arg-deg", parg * 180.0/math.pi);
setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-true-anomaly-deg", true_anomaly * 180.0/math.pi);
setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-arg-of-lat-deg", (true_anomaly + parg) * 180.0/math.pi);

setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-flag", 1);

var radius = getprop("/fdm/jsbsim/ic/sea-level-radius-ft") * 0.3048;
#print ("x: ", state_x[0], " y: ", state_x[1], " z: ", state_x[2]);
#print ("vx: ", state_v[0], " vy: ", state_v[1], " vz: ", state_v[2]);

}
