

# coordinate transformation routines for the Space Shuttle
# Thorsten Renk 2015

var update_LVLH_to_ECI = func {

var shuttleWCoord = geo.aircraft_position() ;
var shuttleCoord = geo.Coord.new() ;

var x = getprop("/fdm/jsbsim/position/eci-x-ft") * 0.3048;
var y = getprop("/fdm/jsbsim/position/eci-y-ft") * 0.3048;
var z = getprop("/fdm/jsbsim/position/eci-z-ft") * 0.3048;

shuttleCoord.set_xyz(x,y,z);

var D_lon = shuttleWCoord.lon() - shuttleCoord.lon();

#print("D_lon: ", D_lon);
setprop("/fdm/jsbsim/systems/pointing/inertial/delta-lon-rad", -D_lon * math.pi/180.0);

}
