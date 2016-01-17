
# orbital planning tools for the Space Shuttle
# Thorsten Renk 2015


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
# extrapolation of state vector
############################################################


var state_extrapolate_test = func (time) {

var x = [getprop("/fdm/jsbsim/position/eci-x-ft") * 0.3048, getprop("/fdm/jsbsim/position/eci-y-ft") * 0.3048, getprop("/fdm/jsbsim/position/eci-z-ft") * 0.3048];

var v = [getprop("/fdm/jsbsim/velocities/eci-x-fps") * 0.3048, getprop("/fdm/jsbsim/velocities/eci-y-fps") * 0.3048, getprop("/fdm/jsbsim/velocities/eci-z-fps") * 0.3048];



state_extrapolate(x, v, 0.0, time);

}

 

var state_extrapolate = func (state_x, state_v, time_sum, time_end) {

# GM is extracted from JSBSIm, Wikipedia gives rather 398600.44 km^2/s^-2, the reason is
# that JSBSim does not assume a Newtonian pointmass Earth

var GM = 398759391386476.0; 

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

setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-flag", 1);

var radius = getprop("/fdm/jsbsim/ic/sea-level-radius-ft") * 0.3048;
print ("x: ", state_x[0] - radius, " y: ", state_x[1]- radius, " z: ", state_x[2]);
print ("vx: ", state_v[0], " vy: ", state_v[1], " vz: ", state_v[2]);

}
