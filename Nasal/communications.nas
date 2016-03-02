
# line of sight checks for Shuttle Ku and S-band antennas to ground sites and TDRS network
# Thorsten Renk 2015


###############################################################################
# ground site handling for S-band antenna
###############################################################################

# the ground site definitions

var com_ground_site_array = [];

var ground_site = {
	new: func (coord, string, mode) {
 	var g = { parents: [ground_site] };
	g.coord = coord;
	g.string = string;
	g.mode = mode;
	return g;
	},
};

# Canberra

var coord1 = geo.Coord.new();
coord1.set_latlon(-35.30, 149.12, 0.0);
var ground_site1 = ground_site.new(coord1, "CAN", "STDN");
append(com_ground_site_array, ground_site1);

# Diego Garcia

var coord2 = geo.Coord.new();
coord2.set_latlon(-7.31, 72.41, 0.0);
var ground_site2 = ground_site.new(coord2, "DGS", "SGLS");
append(com_ground_site_array, ground_site2);

# Kaena point (Hawaii)

var coord3 = geo.Coord.new();
coord3.set_latlon(21.57, -158.28, 0.0);
var ground_site3 = ground_site.new(coord3, "HTS", "SGLS");
append(com_ground_site_array, ground_site3);

# Meritt Island

var coord4 = geo.Coord.new();
coord4.set_latlon(28.35, -80.68, 0.0);
var ground_site4 = ground_site.new(coord4, "MIL", "STDN");
append(com_ground_site_array, ground_site4);

# Vandenberg

var coord5 = geo.Coord.new();
coord5.set_latlon(34.73, -120.56, 0.0);
var ground_site5 = ground_site.new(coord5, "VTS", "SGLS");
append(com_ground_site_array, ground_site5);

# Colordo Springs

var coord6 = geo.Coord.new();
coord6.set_latlon(38.86, -104.76, 0.0);
var ground_site6 = ground_site.new(coord6, "CTS", "SGLS");
append(com_ground_site_array, ground_site6);

# Goldstone

var coord7 = geo.Coord.new();
coord7.set_latlon(35.42, -116.89, 0.0);
var ground_site7 = ground_site.new(coord7, "GDX", "STDN");
append(com_ground_site_array, ground_site7);

# Johnson Space Center

var coord8 = geo.Coord.new();
coord8.set_latlon(29.56, -95.09, 0.0);
var ground_site8 = ground_site.new(coord8, "JSC", "STDN");
append(com_ground_site_array, ground_site8);

# New Hampshire

var coord9 = geo.Coord.new();
coord9.set_latlon(44.00, -71.50, 0.0);
var ground_site9 = ground_site.new(coord9, "NHS", "SGLS");
append(com_ground_site_array, ground_site9);

# Wallops

var coord10 = geo.Coord.new();
coord10.set_latlon(37.93, -75.45, 0.0);
var ground_site10 = ground_site.new(coord10, "WLP", "STDN");
append(com_ground_site_array, ground_site10);

# Dryden

var coord11 = geo.Coord.new();
coord11.set_latlon(49.78, -92.83, 0.0);
var ground_site11 = ground_site.new(coord11, "DFR", "STDN");
append(com_ground_site_array, ground_site11);

# Guam

var coord12 = geo.Coord.new();
coord12.set_latlon(13.5, 144.8, 0.0);
var ground_site12 = ground_site.new(coord12, "GTS", "SGLS");
append(com_ground_site_array, ground_site12);

# Madrid

var coord13 = geo.Coord.new();
coord13.set_latlon(40.4, -3.72, 0.0);
var ground_site13 = ground_site.new(coord13, "MAD", "STDN");
append(com_ground_site_array, ground_site13);

# Oakhanger

var coord14 = geo.Coord.new();
coord14.set_latlon(51.11, -0.90, 0.0);
var ground_site14 = ground_site.new(coord14, "OTS", "SGLS");
append(com_ground_site_array, ground_site14);

# find the closest ground station ########################################

var com_find_nearest_station = func (mode) {

var compare_string = "SGLS";

if ((mode == "S-HI") or (mode == "S-LO"))
	{compare_string = "STDN";}

var shuttle_pos = geo.aircraft_position();

var d = 10000000.0;
var index = -1;

for (var i = 0; i< size(com_ground_site_array); i=i+1) 
	{	
	var s = com_ground_site_array[i];
	if (s.mode == compare_string)
		{
		var dist = shuttle_pos.direct_distance_to(s.coord);
	 	if (dist < d) 
			{
			d = dist;
			index = i;
			}
		}
	}

#print(index, " ", com_ground_site_array[index].string, " ", com_ground_site_array[index].mode);

return index;

}

# check line of sight to ground station ########################################

var com_check_LOS_to_station = func (index) {

var shuttle_pos = geo.aircraft_position();

var radius = getprop("/fdm/jsbsim/ic/sea-level-radius-ft") * 0.3048; 
var alt = shuttle_pos.alt();

var local_horizon = math.sqrt(2.0 * radius * alt  + alt * alt) ;

var dist = shuttle_pos.direct_distance_to(com_ground_site_array[index].coord);

if (dist < local_horizon)
	{return 1;}
else
	{return 0;}

}


# determine which quadrant antenna is used ########################################

var com_get_S_quadrant = func (index) {

var shuttle_pos = geo.aircraft_position();
var ground_pos = com_ground_site_array[index].coord;

# body axis upward pointing vector in FG world coords

var body_z = [getprop("/fdm/jsbsim/systems/pointing/world/body-z[0]"), getprop("/fdm/jsbsim/systems/pointing/world/body-z[1]"), getprop("/fdm/jsbsim/systems/pointing/world/body-z[1]")];

# body axis right pointing vector in FG world coords

var body_y = [getprop("/fdm/jsbsim/systems/pointing/world/body-y[0]"), getprop("/fdm/jsbsim/systems/pointing/world/body-y[1]"), getprop("/fdm/jsbsim/systems/pointing/world/body-y[1]")];

# body axis forward pointing vector in FG world coords

var body_x = [getprop("/fdm/jsbsim/systems/pointing/world/body-x[0]"), getprop("/fdm/jsbsim/systems/pointing/world/body-x[1]"), getprop("/fdm/jsbsim/systems/pointing/world/body-x[1]")];

# pointing vector towards station

var shuttle_world = shuttle_pos.xyz();
var ground_world = ground_pos.xyz();

var pointer = SpaceShuttle.normalize(SpaceShuttle.subtract_vector(ground_world, shuttle_world));

var string = "";

if (SpaceShuttle.dot_product(body_z, pointer) > 0.0)
	{string = string~"U";}
else
	{string = string~"L";}

if (SpaceShuttle.dot_product(body_y, pointer) > 0.0)
	{string = string~"R";}
else
	{string = string~"L";}

string = string~" ";

if (SpaceShuttle.dot_product(body_x, pointer) > 0.0)
	{string = string~"F";}
else
	{string = string~"A";}

return string;
}


var com_get_S_hemisphere = func  {

var up = getprop("/fdm/jsbsim/systems/pointing/lvlh/body-z[2]");

if (up >0) {var string = "LO";}
else {var string = "HI";}

return string;
}

###############################################################################
# TDRS network
###############################################################################


# the TDRS positions

var com_TDRS_array = [];

var satellite = {
	new: func (coord) {
 	var s = { parents: [satellite] };
	s.coord = coord;
	return s;
	},
};

var tdrs_pos1 = geo.Coord.new();
tdrs_pos1.set_latlon(0.0, 91.0, 36000000.0);
var tdrs1 = satellite.new(tdrs_pos1);
append(com_TDRS_array, tdrs1);

var tdrs_pos2 = geo.Coord.new();
tdrs_pos2.set_latlon(0.0, 95.0, 36000000.0);
var tdrs2 = satellite.new(tdrs_pos2);
append(com_TDRS_array, tdrs2);

var tdrs_pos3 = geo.Coord.new();
tdrs_pos3.set_latlon(0.0, -12.0, 36000000.0);
var tdrs3 = satellite.new(tdrs_pos3);
append(com_TDRS_array, tdrs3);

var tdrs_pos4 = geo.Coord.new();
tdrs_pos4.set_latlon(0.0, -41.0, 36000000.0);
var tdrs4 = satellite.new(tdrs_pos4);
append(com_TDRS_array, tdrs4);

var tdrs_pos5 = geo.Coord.new();
tdrs_pos5.set_latlon(0.0, -46.0, 36000000.0);
var tdrs5 = satellite.new(tdrs_pos5);
append(com_TDRS_array, tdrs5);

var tdrs_pos6 = geo.Coord.new();
tdrs_pos6.set_latlon(0.0, -174.0, 36000000.0);
var tdrs6 = satellite.new(tdrs_pos6);
append(com_TDRS_array, tdrs6);

var tdrs_pos7 = geo.Coord.new();
tdrs_pos7.set_latlon(0.0, 169.0, 36000000.0);
var tdrs7 = satellite.new(tdrs_pos7);
append(com_TDRS_array, tdrs7);


# check line of sight to satellite ########################################

var com_check_LOS_to_TDRS = func (index) {

var shuttle_pos = geo.aircraft_position();

var radius = getprop("/fdm/jsbsim/ic/sea-level-radius-ft") * 0.3048; 
var alt = shuttle_pos.alt();

var delta_phi = 180.0 / math.pi * math.acos(radius/(radius + alt));

#print (delta_phi);

var delta_lon = math.abs(shuttle_pos.lon() - com_TDRS_array[index].coord.lon());

#print (delta_lon);

if (delta_lon < 90.0 + delta_phi)
	{return 1;}
else
	{return 0;}

}

var com_get_TDRS_azimuth_elevation = func (index) {


var tdrs_pos = com_TDRS_array[index].coord;

return com_get_pointing_azimuth_elevation(tdrs_pos);
}


var com_get_pointing_azimuth_elevation  = func (coord) {

var shuttle_pos = geo.aircraft_position();

# body axis upward pointing vector in FG world coords

var body_z = [getprop("/fdm/jsbsim/systems/pointing/world/body-z[0]"), getprop("/fdm/jsbsim/systems/pointing/world/body-z[1]"), getprop("/fdm/jsbsim/systems/pointing/world/body-z[1]")];

# body axis right pointing vector in FG world coords

var body_y = [getprop("/fdm/jsbsim/systems/pointing/world/body-y[0]"), getprop("/fdm/jsbsim/systems/pointing/world/body-y[1]"), getprop("/fdm/jsbsim/systems/pointing/world/body-y[1]")];

# body axis forward pointing vector in FG world coords

var body_x = [getprop("/fdm/jsbsim/systems/pointing/world/body-x[0]"), getprop("/fdm/jsbsim/systems/pointing/world/body-x[1]"), getprop("/fdm/jsbsim/systems/pointing/world/body-x[1]")];

# pointing vector  in world coordinates

var shuttle_world = shuttle_pos.xyz();
var tgt_world = coord.xyz();

var pointer = SpaceShuttle.normalize(SpaceShuttle.subtract_vector(tgt_world, shuttle_world));

# get the components of the pointing vector in body coordinates

var pointer_bx = SpaceShuttle.dot_product(body_x, pointer);
var pointer_by = SpaceShuttle.dot_product(body_y, pointer);
var pointer_bz = SpaceShuttle.dot_product(body_z, pointer);

var pointer_body = [pointer_bx, pointer_by, pointer_bz];
var angles = SpaceShuttle.get_pitch_yaw(pointer_body);

angles[0] = angles[0] * 180.0/math.pi;
angles[1] = angles[1] * 180.0/math.pi;

return angles;


}

