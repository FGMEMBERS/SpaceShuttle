
# line of sight checks for Shuttle Ku and S-band antennas to ground sites and TDRS network
# Thorsten Renk 2015


###############################################################################
# ground site handling for S-band antenna
###############################################################################

# the ground site definitions

var com_ground_site_array = [];

var ground_site = {
	new: func (coord, string) {
 	var g = { parents: [ground_site] };
	g.coord = coord;
	g.string = string;
	return g;
	},
};

# Canberra

var coord1 = geo.Coord.new();
coord1.set_latlon(-35.30, 149.12, 0.0);
var string1 = "CAN";
var ground_site1 = ground_site.new(coord1, string1);
append(com_ground_site_array, ground_site1);

# Diego Garcia

var coord2 = geo.Coord.new();
coord2.set_latlon(-7.31, 72.41, 0.0);
var string2 = "DGS";
var ground_site2 = ground_site.new(coord2, string2);
append(com_ground_site_array, ground_site2);

# Kaena point (Hawaii)

var coord3 = geo.Coord.new();
coord3.set_latlon(21.57, -158.28, 0.0);
var string3 = "HTS";
var ground_site3 = ground_site.new(coord3, string3);
append(com_ground_site_array, ground_site3);

# Meritt Island

var coord4 = geo.Coord.new();
coord4.set_latlon(28.35, -80.68, 0.0);
var string4 = "MIL";
var ground_site4 = ground_site.new(coord4, string4);
append(com_ground_site_array, ground_site4);

# Vandenberg

var coord5 = geo.Coord.new();
coord5.set_latlon(34.73, -120.56, 0.0);
var string5 = "VTS";
var ground_site5 = ground_site.new(coord5, string5);
append(com_ground_site_array, ground_site5);

# Colordo Springs

var coord6 = geo.Coord.new();
coord6.set_latlon(38.86, -104.76, 0.0);
var string6 = "CTS";
var ground_site6 = ground_site.new(coord6, string6);
append(com_ground_site_array, ground_site6);

# Goldstone

var coord7 = geo.Coord.new();
coord7.set_latlon(35.42, -116.89, 0.0);
var string7 = "GDX";
var ground_site7 = ground_site.new(coord7, string7);
append(com_ground_site_array, ground_site7);

# Johnson Space Center

var coord8 = geo.Coord.new();
coord8.set_latlon(29.56, -95.09, 0.0);
var string8 = "JSC";
var ground_site8 = ground_site.new(coord8, string8);
append(com_ground_site_array, ground_site8);

# New Hampshire

var coord9 = geo.Coord.new();
coord9.set_latlon(44.00, -71.50, 0.0);
var string9 = "NHS";
var ground_site9 = ground_site.new(coord9, string9);
append(com_ground_site_array, ground_site9);

# Wallops

var coord10 = geo.Coord.new();
coord10.set_latlon(37.93, -75.45, 0.0);
var string10 = "WLP";
var ground_site10 = ground_site.new(coord10, string10);
append(com_ground_site_array, ground_site10);

# Dryden

var coord11 = geo.Coord.new();
coord11.set_latlon(49.78, -92.83, 0.0);
var string11 = "DFR";
var ground_site11 = ground_site.new(coord11, string11);
append(com_ground_site_array, ground_site11);

# Guam

var coord12 = geo.Coord.new();
coord12.set_latlon(13.5, 144.8, 0.0);
var string12 = "GTS";
var ground_site12 = ground_site.new(coord12, string12);
append(com_ground_site_array, ground_site12);

# Madrid

var coord13 = geo.Coord.new();
coord13.set_latlon(40.4, -3.72, 0.0);
var string13 = "MAD";
var ground_site13 = ground_site.new(coord13, string13);
append(com_ground_site_array, ground_site13);

# Oakhanger

var coord14 = geo.Coord.new();
coord14.set_latlon(51.11, -0.90, 0.0);
var string14 = "OTS";
var ground_site14 = ground_site.new(coord14, string14);
append(com_ground_site_array, ground_site14);



var com_find_nearest_station = func {

var shuttle_pos = geo.aircraft_position();

var d = 10000000.0;
var index = -1;

for (var i = 0; i< size(com_ground_site_array); i=i+1) 
	{	
	var s = com_ground_site_array[i];
	var dist = shuttle_pos.direct_distance_to(s.coord);
	if (dist < d)
		{
		d = dist;
		index = i;
		}
	}

print(index, " ", com_ground_site_array[index].string);

return index;

}

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
