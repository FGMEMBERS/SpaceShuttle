# TAEM guidance functionality for the Space Shuttle
# Thorsten Renk 2015

var TAEM_WP_1 = geo.Coord.new();
var TAEM_WP_2 = geo.Coord.new();
var TAEM_threshold = geo.Coord.new();
var TAEM_HAC_center = geo.Coord.new();
var TAEM_guidance_available = 0;

var final_approach_reserve = 7.0;




var compute_TAEM_guidance_targets = func {

TAEM_guidance_available = 0;


var lat_to_m = 110952.0; 
var lon_to_m  = math.cos(getprop("/position/latitude-deg")*math.pi/180.0) * lat_to_m;
var m_to_lon = 1.0/lon_to_m;
var m_to_lat = 1.0/lat_to_m;

# first check whether we have a valid runway / site specified

var site_string = getprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site");
var runway_string = getprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway");


set_TAEM_threshold(site_string, runway_string);

if (TAEM_threshold.lat() == 0.0)
	{return;}

print("TAEM site data available");

var pos = geo.aircraft_position();

if (pos.distance_to(TAEM_threshold) > 200000.0)
	{
	setprop("/sim/messages/copilot", "No TAEM guidance to site possible.");
	return;
	}

# if the threshold is defined and within range, we can construct a valid solution

print("TAEM guidance available");
TAEM_guidance_available = 1;

var entry_point_string = getprop("/fdm/jsbsim/systems/taem-guidance/entry_point_string");

var ep_distance = 7.0 * 1853.0;
var ep_altitude = 12000.0 * 0.3048;

if (entry_point_string == "MEP") 
	{
	ep_distance = 4.0 * 1853.0;
	ep_altitude = 6000.0 * 0.3048;
	}



var runway_dir_vec = [math.sin(TAEM_threshold.heading * math.pi/180.0), math.cos(TAEM_threshold.heading * math.pi/180.0)];


#print (TAEM_threshold.heading, " ", runway_dir_vec[0], " ", runway_dir_vec[1]);

TAEM_WP_2.set_latlon(TAEM_threshold.lat() - m_to_lat * runway_dir_vec[1] * ep_distance,  TAEM_threshold.lon() - m_to_lon *runway_dir_vec[0] * ep_distance);
TAEM_WP_2.set_alt(ep_altitude);


# now construct the center of the HAC

var approach_dir = pos.course_to(TAEM_WP_2);
var approach_vec = [math.sin(approach_dir * math.pi/180.0), math.cos(approach_dir * math.pi/180.0)];

#print (approach_dir, " ", approach_vec[0], " ", approach_vec[1]);

var runway_perp_vec = [math.sin((TAEM_threshold.heading + 90) * math.pi/180.0), math.cos((TAEM_threshold.heading + 90) * math.pi/180.0)];

var approach_dot_rwyperp = SpaceShuttle.dot_product_2d(approach_vec, runway_perp_vec);
var approach_mode = getprop("/fdm/jsbsim/systems/taem-guidance/approach-mode-string");

if ((approach_mode == "OVHD") and (approach_dot_rwyperp < 0.0)) # we need to flip direction
	{
	runway_perp_vec = [-runway_perp_vec[0], -runway_perp_vec[1]];
	}
if ((approach_mode == "STRT") and (approach_dot_rwyperp > 0.0)) # we need to flip direction
	{
	runway_perp_vec = [-runway_perp_vec[0], -runway_perp_vec[1]];
	}

var hac_radius = 5600.0;

if (entry_point_string == "MEP") 
	{
	hac_radius = hac_radius * 0.5;
	}

#print(runway_perp_vec[0], " ", runway_perp_vec[1]);

TAEM_HAC_center.set_latlon(TAEM_WP_2.lat() + m_to_lat * runway_perp_vec[1] * hac_radius, TAEM_WP_2.lon() + m_to_lon * runway_perp_vec[0] * hac_radius);

# WP-1 is the tangent on the HAC which leads, after the turn, to a tangent pointing at the runway

var wp1_vec = [-approach_vec[1], approach_vec[0]];
var wp1_dot_rwy = SpaceShuttle.dot_product_2d(wp1_vec, runway_dir_vec);



if ((wp1_dot_rwy < 0.0) and (approach_mode == "OVHD"))
	{wp1_vec = [-wp1_vec[0], -wp1_vec[1]];}
if ((wp1_dot_rwy > 0.0) and (approach_mode == "STRT"))
	{wp1_vec = [-wp1_vec[0], -wp1_vec[1]];}

TAEM_WP_1.set_latlon(TAEM_HAC_center.lat() + m_to_lat * wp1_vec[1] * hac_radius * 1.3, TAEM_HAC_center.lon() + m_to_lon * wp1_vec[0] * hac_radius * 1.3);

# now, determine how much we have to turn and store the info


var turn_degrees = math.abs(approach_dir - TAEM_threshold.heading);

if ((turn_degrees < 180.0) and (approach_mode == "OVHD"))
	{
	turn_degrees = 360.0 - turn_degrees;
	}

print("Turn degrees: ", turn_degrees);

TAEM_WP_1.turn_deg = turn_degrees;
TAEM_WP_1.approach_dir = approach_dir;
TAEM_WP_1.distance_to_runway_m = 2.0 * math.pi * turn_degrees/360.0 * 1.2 * hac_radius + final_approach_reserve * 1853.0;
TAEM_WP_1.hac_radius = hac_radius;

#print("Distance to WP1: ", pos.distance_to(TAEM_WP_1));

# now figure out what direction to turn onto the HAC

var test_vec = [runway_perp_vec[1], -runway_perp_vec[0]];

#print("Test vec: ",test_vec[0], " ", test_vec[1]);
#print("Runway vec: ",runway_dir_vec[0], " ", runway_dir_vec[1]);
#print("Product: ", SpaceShuttle.dot_product_2d(runway_dir_vec, test_vec));

var turn_direction = "right";

if (SpaceShuttle.dot_product_2d(runway_dir_vec, test_vec) > 0.0)
	{
	turn_direction = "left";
	}


#print("Turn ", turn_direction);
#print("Turn degrees: ", turn_degrees, " extra distance: ", TAEM_WP_1.distance_to_runway_m / 1853.0 );

TAEM_WP_1.turn_direction = turn_direction;

TAEM_guidance_loop(0);
}


var TAEM_guidance_loop = func (stage) {


var pos = geo.aircraft_position();

if (TAEM_guidance_available == 0)
	{
	return;
	} 

if (stage == 0)
	{
	setprop("/fdm/jsbsim/systems/taem-guidance/course", pos.course_to(TAEM_WP_1));
	var dist = pos.distance_to(TAEM_WP_1) / 1853.0;
	setprop("/fdm/jsbsim/systems/taem-guidance/distance-to-runway-nm", dist + TAEM_WP_1.distance_to_runway_m/1853.0);
	if (dist < 1.0) {
			print("Waypoint 1 reached!"); 	stage = stage + 1;
			setprop("/sim/messages/copilot", "Turn "~TAEM_WP_1.turn_direction~" into HAC!");
			}

	}
else if (stage == 1)
	{

	var distance_to_runway = getprop("/fdm/jsbsim/systems/taem-guidance/distance-to-runway-nm");
	var airspeed_kt = getprop("/velocities/airspeed-kt");
	distance_to_runway = distance_to_runway - 0.2 * airspeed_kt / 3600.0;

	setprop("/fdm/jsbsim/systems/taem-guidance/distance-to-runway-nm", distance_to_runway);

	if (distance_to_runway < 7.0)
		{
		print("TAEM guidance finished.");
		stage = 2;
		}
	}
else if (stage == 2)
	{
	var dist = pos.distance_to(TAEM_threshold) / 1853.0;
	setprop("/fdm/jsbsim/systems/taem-guidance/distance-to-runway-nm", dist);
	if (dist < 0.2) {return;}
	}


settimer( func {TAEM_guidance_loop(stage); }, 0.2);

}

var set_TAEM_threshold = func (site_string, runway_string) {


if (site_string == "Kennedy Space Center")
	{
	if (runway_string == "15")
		{
		TAEM_threshold.set_latlon(28.6315, -80.7052);
		TAEM_threshold.heading = 150.0;	
		TAEM_threshold.elevation = 0.0;
		}
	else if (runway_string == "33")
		{
		TAEM_threshold.set_latlon(28.5985,-80.6836);
		TAEM_threshold.heading = 330.0;
		TAEM_threshold.elevation = 0.0;
		}
	}
else if (site_string == "Vandenberg Air Force Base")
	{
	if (runway_string == "12")
		{
		TAEM_threshold.set_latlon(34.7502,-120.5991);
		TAEM_threshold.heading = 136.5;
		TAEM_threshold.elevation = 240.0;
		}
	else if (runway_string == "30")
		{
		TAEM_threshold.set_latlon(34.7242,-120.5692);
		TAEM_threshold.heading = 316.5;
		TAEM_threshold.elevation = 240.0;
		}
	}
else if (site_string == "Edwards Air Force Base")
	{
	if (runway_string == "06")
		{
		TAEM_threshold.set_latlon(34.9498,-117.8608);
		TAEM_threshold.heading = 64.5;
		TAEM_threshold.elevation = 2280.0;
		}
	else if (runway_string == "24")
		{
		TAEM_threshold.set_latlon(34.9655,-117.8200);
		TAEM_threshold.heading = 244.5;
		TAEM_threshold.elevation = 2280.0;
		}
	}

else
	{
	setprop("/sim/messages/copilot", "No TAEM guidance data to site available.");
	TAEM_threshold.set_lat(0.0);
	TAEM_threshold.set_lon(0.0);
	}

}
