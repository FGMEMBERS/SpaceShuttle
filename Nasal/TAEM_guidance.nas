# TAEM guidance functionality for the Space Shuttle
# Thorsten Renk 2015

var TAEM_WP_1 = geo.Coord.new();
var TAEM_WP_2 = geo.Coord.new();
var TAEM_threshold = geo.Coord.new();
var TAEM_HAC_center = geo.Coord.new();
var TAEM_guidance_available = 0;
var TAEM_guidance_phase = 0;
var TAEM_loop_running = 0;

var final_approach_reserve = 4.0;



var TAEM_predictor_set = {

	entry: [[0.0, 0.0], [0.0,0.0], [0.0,0.0]],
	x: 0.0,
	y: 0.0,
	angle: 0.0,
	
	update: func {

	var groundspeed = getprop("/velocities/groundspeed-kt") * 0.51444;
	var rate = getprop("/orientation/yaw-rate-degps");	

	me.x = 0;
	me.y = 0;
	me.angle = 0;

	me.evolve(groundspeed, rate);

	me.entry[0][0] = math.sqrt(me.x * me.x + me.y * me.y);
	me.entry[0][1] = math.asin(me.x/me.entry[0][0]);	
	
	me.evolve(groundspeed, rate);

	me.entry[1][0] = math.sqrt(me.x * me.x + me.y * me.y);
	me.entry[1][1] = math.asin(me.x/me.entry[1][0]);

	me.evolve(groundspeed, rate);

	me.entry[2][0] = math.sqrt(me.x * me.x + me.y * me.y);
	me.entry[2][1] = math.asin(me.x/me.entry[2][0]);




	},

	evolve: func (groundspeed, rate) {

	for (var i=0; i < 20; i=i+1)
		{
		me.x = me.x + math.sin(me.angle * math.pi/180.0) * groundspeed;
		me.y = me.y + math.cos(me.angle * math.pi/180.0) * groundspeed;
		me.angle = me.angle + rate;
		}

	},

};


var compute_TAEM_guidance_targets = func {

TAEM_guidance_available = 0;
TAEM_guidance_phase = 0;

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
setprop("/fdm/jsbsim/systems/ap/taem/auto-taem-master",1);


var entry_point_string = getprop("/fdm/jsbsim/systems/taem-guidance/entry-point-string");

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
TAEM_HAC_center.radius = hac_radius;

# WP-1 is the tangent on the HAC which leads, after the turn, to a tangent pointing at the runway

var wp1_vec = [-approach_vec[1], approach_vec[0]];
var wp1_dot_rwy = SpaceShuttle.dot_product_2d(wp1_vec, runway_dir_vec);



if ((wp1_dot_rwy < 0.0) and (approach_mode == "OVHD"))
	{wp1_vec = [-wp1_vec[0], -wp1_vec[1]];}
if ((wp1_dot_rwy > 0.0) and (approach_mode == "STRT"))
	{wp1_vec = [-wp1_vec[0], -wp1_vec[1]];}

# the aim point is at 1.2 HAC radius because we spiral inward

TAEM_WP_1.set_latlon(TAEM_HAC_center.lat() + m_to_lat * wp1_vec[1] * hac_radius * 1.2, TAEM_HAC_center.lon() + m_to_lon * wp1_vec[0] * hac_radius * 1.2);

# now, determine how much we have to turn and store the info


var turn_degrees = math.abs(approach_dir - TAEM_threshold.heading);

if ((turn_degrees < 180.0) and (approach_mode == "OVHD"))
	{
	turn_degrees = 360.0 - turn_degrees;
	}

print("Turn degrees: ", turn_degrees);

TAEM_WP_1.turn_deg = turn_degrees;
TAEM_WP_1.approach_dir = approach_dir;
TAEM_WP_1.distance_to_runway_m = 2.0 * math.pi * turn_degrees/360.0 * 1.3 * hac_radius + final_approach_reserve * 1853.0;
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

if (turn_direction == "right")
	{setprop("/fdm/jsbsim/systems/ap/taem/set-bank-target", 15.0);}
else
	{setprop("/fdm/jsbsim/systems/ap/taem/set-bank-target", -15.0);}

TAEM_guidance_phase = 1;

# tell gliding RTLS AP that we're done with alpha transition

setprop("/fdm/jsbsim/systems/ap/grtls/taem-transition-init", 1);

# tell light manager to switch runway lights on

SpaceShuttle.light_manager.set_theme("RUNWAY");


if (TAEM_loop_running == 0)
	{TAEM_guidance_loop(0, 0.0);}
}


# the central TAEM guidance loop #########################################################


var TAEM_guidance_loop = func (stage, radius_error_last) {

TAEM_loop_running = 1;

var pos = geo.aircraft_position();

TAEM_predictor_set.update();

if (TAEM_guidance_available == 0)
	{
	TAEM_loop_running = 0;
	return;
	} 


if (stage == 0) # glide to WP 1
	{
	var course = pos.course_to(TAEM_WP_1);
		
	setprop("/fdm/jsbsim/systems/taem-guidance/course", course);

	var heading = getprop("/orientation/heading-deg");

	var delta_az = course - heading;
	if (delta_az > 180.0) {delta_az = delta_az - 360.0;}
	if (delta_az < -180.0) {delta_az = delta_az + 360.0;}

	setprop("/fdm/jsbsim/systems/taem-guidance/delta-azimuth-deg", delta_az);
	
	var dist = pos.distance_to(TAEM_WP_1) / 1853.0;
	var dist_to_go = dist + TAEM_WP_1.distance_to_runway_m/1853.0;
	setprop("/fdm/jsbsim/systems/taem-guidance/distance-to-runway-nm", dist_to_go);

	var glideslope_deviation = SpaceShuttle.get_glideslope_deviation(pos.alt()/0.3048, dist_to_go);
	setprop("/fdm/jsbsim/systems/taem-guidance/glideslope-deviation-ft", glideslope_deviation);

	TAEM_energy_management();

	if (dist < 1.0) {
			print("Waypoint 1 reached!"); 	stage = stage + 1;
			var turn_direction = TAEM_WP_1.turn_direction;
			setprop("/sim/messages/copilot", "Turn "~turn_direction~" into HAC!");
			TAEM_guidance_phase = 2;
	
			if (turn_direction == "right")
				{setprop("/fdm/jsbsim/systems/ap/taem/set-bank-target", 15.0);}
			else
				{setprop("/fdm/jsbsim/systems/ap/taem/set-bank-target", -15.0);}

			setprop("/fdm/jsbsim/systems/ap/taem/hac-turn-init", 1);
			}

	}
else if (stage == 1) # turn around HAC
	{

	var distance_to_runway = getprop("/fdm/jsbsim/systems/taem-guidance/distance-to-runway-nm");
	var groundspeed_kt = getprop("/velocities/groundspeed-kt");
	distance_to_runway = distance_to_runway - 0.2 * groundspeed_kt / 3600.0;

	setprop("/fdm/jsbsim/systems/taem-guidance/distance-to-runway-nm", distance_to_runway);

	var glideslope_deviation = SpaceShuttle.get_glideslope_deviation(pos.alt()/0.3048, distance_to_runway);
	setprop("/fdm/jsbsim/systems/taem-guidance/glideslope-deviation-ft", glideslope_deviation);

	var radius_error = TAEM_HAC_center.radius - pos.distance_to(TAEM_HAC_center);
	var rdot = (radius_error - radius_error_last)/0.2;
	if (radius_error_last == -1.0) {rdot = 0.0;}
	radius_error_last  = radius_error;
	

	setprop("/fdm/jsbsim/systems/taem-guidance/radial-error-nm", radius_error/ 1853.);
	setprop("/fdm/jsbsim/systems/taem-guidance/rdot-fps", rdot / 0.3048);

	TAEM_energy_management();

	var heading = getprop("/orientation/heading-deg");
	var delta_az = TAEM_threshold.heading - heading;
	var alt = getprop("/position/altitude-ft");

	if (delta_az > 180.0) {delta_az = delta_az - 360.0;}
	if (delta_az < -180.0) {delta_az = delta_az + 360.0;}
	

	if ((distance_to_runway < 7.0) or ((math.abs(delta_az) < 5.0) and (alt < 20000.0)))
		{
		TAEM_guidance_phase = 3;
		print("TAEM guidance finished.");
		setprop("/sim/messages/copilot", "Take CSS and turn into final!");
		setprop("/fdm/jsbsim/systems/ap/taem/set-bank-target", 0.0);
		setprop("/fdm/jsbsim/systems/ap/taem/hac-turn-init", 0);
		setprop("/fdm/jsbsim/systems/ap/taem/s-turn-init", 0);
		setprop("/fdm/jsbsim/systems/ap/taem/al-init", 1);

		settimer( func {
		
		setprop("/fdm/jsbsim/systems/ap/automatic-pitch-control", 0);
		setprop("/fdm/jsbsim/systems/ap/css-pitch-control", 1);
		setprop("/fdm/jsbsim/systems/ap/automatic-roll-control", 0);
		setprop("/fdm/jsbsim/systems/ap/css-roll-control", 1);

		}, 5.0);


		stage = 2;
		}
	}
else if (stage == 2)
	{
	var dist = pos.distance_to(TAEM_threshold) / 1853.0;
	setprop("/fdm/jsbsim/systems/taem-guidance/distance-to-runway-nm", dist);
	if (dist < 0.2) {return;}
	}


settimer( func {TAEM_guidance_loop(stage, radius_error_last); }, 0.2);

}


# TAEM energy management - SB and S-Turns #################################################

var TAEM_energy_management = func {

# no TAEM energy management during powered RTLS

if (getprop("/fdm/jsbsim/systems/dps/major-mode") == 601)
	{
	return;
	}

var alt = getprop("/position/altitude-ft") * 0.3048;
var gsld = getprop("/fdm/jsbsim/systems/taem-guidance/glideslope-deviation-ft") * 0.3048;
var nominal_alt = gsld + alt;

var speed_kts = getprop("/fdm/jsbsim/velocities/ve-kts");

var speed = speed_kts * 1853.0 / 3600.0;
var nominal_speed = 240.0 * 1853.0 / 3600.0;
var sd = 240.0 - speed_kts;

var g = 9.81;

var E_act = g * alt + speed * speed;
var E_nom = g * nominal_alt + nominal_speed * nominal_speed;

var E_ratio = E_act/E_nom;

var dH_equiv_ft = (E_act - E_nom)/g / 0.3048;

setprop("/fdm/jsbsim/systems/taem-guidance/energy-ratio", E_ratio);
setprop("/fdm/jsbsim/systems/taem-guidance/dH-equiv-ft", dH_equiv_ft);

# S-turns if lots of energy is to be depleted

if ((dH_equiv_ft > 10000.0) and (TAEM_guidance_phase == 1))
	{
	if (getprop("/fdm/jsbsim/systems/ap/taem/s-turn-init") == 1) # we are in a turn
		{
		var delta_az = getprop("/fdm/jsbsim/systems/taem-guidance/delta-azimuth-deg");
		if (delta_az > 30.0)		
			{
			if (getprop("/fdm/jsbsim/systems/ap/taem/set-bank-target") == -30.0)
				{
				setprop("/sim/messages/copilot", "S-turn reversal!");
				}

			setprop("/fdm/jsbsim/systems/ap/taem/set-bank-target", 30.0);

			}
		else if (delta_az < -30.0)
			{
			if (getprop("/fdm/jsbsim/systems/ap/taem/set-bank-target") == 30.0)
				{
				setprop("/sim/messages/copilot", "S-turn reversal!");
				}
			setprop("/fdm/jsbsim/systems/ap/taem/set-bank-target", -30.0);
			}

		}
	else
		{
		setprop("/fdm/jsbsim/systems/ap/taem/set-bank-target", 30.0);
		setprop("/sim/messages/copilot", "Initiating S-turn to deplete energy!");
		setprop("/fdm/jsbsim/systems/ap/taem/s-turn-init",1);
	
		}	

	}
else # no S-turn
	{
	setprop("/fdm/jsbsim/systems/ap/taem/s-turn-init",0);
	}


# auto-SB

var sb_max = 0.0;

if (sd < -30.0)
	{sb_max = 1.0;}
else if (sd < -24.0)
	{sb_max = 0.8;}
else if (sd < -15.0)
	{sb_max = 0.6;}
else if (sd < -10.0)
	{sb_max = 0.4;}
else if (sd < -5.0)
	{sb_max = 0.2;}

if (getprop("/fdm/jsbsim/systems/ap/taem/hac-turn-init") == 1)
	{
	if (sb_max > 0.0) {sb_max = sb_max - 0.2;}
	}

if (dH_equiv_ft < 0.0) # we're short on energy and never use SB
	{
	sb_max = 0.0;
	}


if (getprop("/fdm/jsbsim/systems/ap/automatic-sb-control") == 1)	
	{
	var sb_state = getprop("/controls/shuttle/speedbrake");

	if (sb_state > sb_max) {SpaceShuttle.decrease_speedbrake();}
	else if (sb_state < sb_max) {SpaceShuttle.increase_speedbrake();}
	}

}

# set threshold for TAEM guidance #########################################################

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
		TAEM_threshold.elevation = 362.0;
		}
	else if (runway_string == "30")
		{
		TAEM_threshold.set_latlon(34.7242,-120.5692);
		TAEM_threshold.heading = 316.5;
		TAEM_threshold.elevation = 362.0;
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
else if (site_string == "White Sands Space Harbour")
	{
	if (runway_string == "14")
		{
		TAEM_threshold.set_latlon(32.9754,-106.3313);
		TAEM_threshold.heading = 142.0;
		TAEM_threshold.elevation = 4450.0;
		}
	else if (runway_string == "32")
		{
		TAEM_threshold.set_latlon(32.8815,-106.2477);
		TAEM_threshold.heading = 322.0;
		TAEM_threshold.elevation = 4450.0;
		}
	}
else if (site_string == "Zaragoza Airport")
	{
	if (runway_string == "12")
		{
		TAEM_threshold.set_latlon(41.6783,-1.0781);
		TAEM_threshold.heading = 120.0;
		TAEM_threshold.elevation = 834.0;
		}
	else if (runway_string == "30")
		{
		TAEM_threshold.set_latlon(41.6647,-1.0466);
		TAEM_threshold.heading = 300.0;
		TAEM_threshold.elevation = 866.0;
		}
	}
else if (site_string == "RAF Fairford")
	{
	if (runway_string == "09")
		{
		TAEM_threshold.set_latlon(51.6831,-1.8049);
		TAEM_threshold.heading = 87.0;
		TAEM_threshold.elevation = 316.0;
		}
	else if (runway_string == "27")
		{
		TAEM_threshold.set_latlon(51.6838,-1.7723);
		TAEM_threshold.heading = 267.0;
		TAEM_threshold.elevation = 256.0;
		}
	}
else if (site_string == "Banjul International Airport")
	{
	if (runway_string == "32")
		{
		TAEM_threshold.set_latlon(13.3301,-16.6428);
		TAEM_threshold.heading = 311.0;
		TAEM_threshold.elevation = 102.0;
		}
	else if (runway_string == "14")
		{
		TAEM_threshold.set_latlon(13.3451,-16.6608);
		TAEM_threshold.heading = 131.0;
		TAEM_threshold.elevation = 102.0;
		}
	}
else if (site_string == "Moron Air Base")
	{
	if (runway_string == "02")
		{
		TAEM_threshold.set_latlon(37.1633,-5.6212);
		TAEM_threshold.heading = 20.0;
		TAEM_threshold.elevation = 300.0;
		}
	else if (runway_string == "20")
		{
		TAEM_threshold.set_latlon(37.1863,-5.6106);
		TAEM_threshold.heading = 200.0;
		TAEM_threshold.elevation = 280.0;
		}
	}
else if (site_string == "Le Tube")
	{
	if (runway_string == "15")
		{
		TAEM_threshold.set_latlon(43.5341, 4.9158);
		TAEM_threshold.heading = 152.0;
		TAEM_threshold.elevation = 80.0;
		}
	else if (runway_string == "33")
		{
		TAEM_threshold.set_latlon(43.5104, 4.9327);
		TAEM_threshold.heading = 332.0;
		TAEM_threshold.elevation = 80.0;
		}
	}
else if (site_string == "Bermuda")
	{
	if (runway_string == "12")
		{
		TAEM_threshold.set_latlon(32.3659,-64.6899);
		TAEM_threshold.heading = 102.0;
		TAEM_threshold.elevation = 25.0;
		}
	else if (runway_string == "30")
		{
		TAEM_threshold.set_latlon(32.3619,-64.6667);
		TAEM_threshold.heading = 282.0;
		TAEM_threshold.elevation = 25.0;
		}
	}
else if (site_string == "Easter Island")
	{
	if (runway_string == "10")
		{
		TAEM_threshold.set_latlon(-27.1592,-109.4337);
		TAEM_threshold.heading = 117.0;
		TAEM_threshold.elevation = 163.0;
		}
	else if (runway_string == "28")
		{
		TAEM_threshold.set_latlon(-27.1707,-109.4088);
		TAEM_threshold.heading = 297.0;
		TAEM_threshold.elevation = 224.0;
		}
	}

else
	{
	setprop("/sim/messages/copilot", "No TAEM guidance data to site available.");
	TAEM_threshold.set_lat(0.0);
	TAEM_threshold.set_lon(0.0);
	}

}


var get_hsit_x = func (dist, rel_angle) {

var dist_x = math.sin(rel_angle) * dist;
return x = 265 + dist_x / 240.0;


}

var get_hsit_y = func (dist, rel_angle) {

var dist_y = math.cos (rel_angle) * dist;
return 265 - dist_y / 240.0;

}
