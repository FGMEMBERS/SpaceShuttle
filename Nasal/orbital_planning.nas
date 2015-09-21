
# orbital planning tools for the Space Shuttle
# Thorsten Renk 2015

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
