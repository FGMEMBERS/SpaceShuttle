# TAEM guidance functionality for the Space Shuttle
# Thorsten Renk 2015

var TAEM_WP_1 = geo.Coord.new();
var TAEM_WP_2 = geo.Coord.new();
var TAEM_AP = geo.Coord.new();
var TAEM_threshold = geo.Coord.new();
var TAEM_HAC_center = geo.Coord.new();
var TAEM_rwy_nl = geo.Coord.new();
var TAEM_rwy_nr = geo.Coord.new();
var TAEM_rwy_fl = geo.Coord.new();
var TAEM_rwy_fr = geo.Coord.new();
var TAEM_guidance_available = 0;
var TAEM_TACAN_available = 0;
var TAEM_guidance_phase = 0;
var TAEM_guidance_string = "";
var TAEM_loop_running = 0;

TAEM_threshold.MLS_available = 0;

var HUD_data_set = {

	vangle_aim: 0,
	hangle_aim: 0,
	vangle_threshold: 0,
	hangle_threshold: 0,
	vangle_guidance: 0,
	vangle_nr: 0,
	hangle_nr: 0,
	vangle_nl: 0,
	hangle_nl: 0,
	vangle_fr: 0,
	hangle_fr: 0,
	vangle_fl: 0,
	hangle_fl: 0,
	MLS_acquired: 0,
};


var area_nav_set = {

	TACAN_locked: 0,
	MLS_locked: 0,
	MLS_processing: 0,
	air_data_available: 0,
	gps_available: 0,
	source: 0,

	TACAN_aut: 0,
	TACAN_inh: 1,
	TACAN_for: 0,

	air_data_h_aut: 0,
	air_data_h_inh: 1,
	air_data_h_for: 0,

	air_data_gc_aut: 0,
	air_data_gc_inh: 1,
	air_data_gc_for: 0,

	drag_h_aut: 1,
	drag_h_inh: 0,
	drag_h_for: 0,

	gps_aut: 0,
	gps_inh: 1,
	gps_for: 0,

	gps_gc_aut: 0,
	gps_gc_inh: 1,
	gps_gc_for: 0,

	accuracy_lat : 0.1,
	accuracy_lon: 0.1,
	accuracy_alt: 15000.0,

	acc_x: 5000.0,
	acc_y: 5000.0,
	acc_z: 5000.0,

	offset_x: 0.0,
	offset_y: 0.0,
	offset_z: 0.0,

	offset_lat: 0.0,
	offset_lon: 0.0,
	
	baro_alt_m: 0.0,

	tacan_acc_dist: 0,
	tacan_acc_az: 0,

	tacan_offset_dist: 0,
	tacan_offset_az: 0,
	tacan_offset_az_deg: 0,

	dist_m: 0,

	m_to_lat: 1.0/110952.0,
	m_to_lon: 1.0/110952.0,

	nav_bearing_tacan: 0,
	nav_dist_tacan: 0,

	tac_resid_range: 0.0,
	tac_resid_bearing: 0.0,
	tac_ratio_range: 0.0,
	tac_ratio_bearing: 0.0,

	adta_resid_h: 0.0,
	adta_ratio_h: 0.0,

	drag_h_resid: 0.0,
	drag_h_ratio: 0.0,

	gps_resid: 0.0,
	gps_ratio: 0.0,

	drag_h_atm_model : 0,
	drag_h_offset: 	0.0,

	gps_update_cycle_count: 0,

	init: func {
		me.true_pos = geo.aircraft_position();
		me.nav_pos = state_vector_position();
		
		var acc_factor = 1.0;	

		if (me.true_pos.lat() > 55.0)
			{
			if (me.drag_h_atm_model == 0) {acc_factor = 1.3;}
			else if (me.drag_h_atm_model == 2) {acc_factor = 1.2;}
			}
		else if (me.true_pos.lat() < -55.0)
			{
			if (me.drag_h_atm_model == 0) {acc_factor = 1.3;}
			else if (me.drag_h_atm_model == 1) {acc_factor = 1.2;}
			}
		else
			{
			if (me.drag_h_atm_model == 1) {acc_factor = 1.2;}
			else if (me.drag_h_atm_model == 2){acc_factor = 1.2;}
			}
	

		me.drag_h_offset = acc_factor * 800.0 * (rand() - 0.5);
		#print("Init area nav, drag alt offset is: ", me.drag_h_offset);
	},


	update_entry: func {

		me.update_pos();
		me.update_signals();

		if (me.TACAN_locked == 1) 
			{
			if (TAEM_TACAN_available == 0)
				{set_TAEM_TACAN();}
			else
				{me.update_nav();}
			}

		if (me.air_data_available == 1)
			{
			me.compute_baro_alt_error();
			}
		me.compute_drag_alt_error();
		me.update_sv_by_gps();
	
		SpaceShuttle.air_data_system.update();
	},

	update_taem: func {

		me.update_pos();
		me.update_signals();
		me.update_nav();

		if ((me.MLS_locked == 1) and (me.TACAN_for == 0))
			{
			me.compute_MLS_error_set();
			}
		else if ((me.TACAN_locked == 1) and (me.TACAN_inh == 0))
			{
			me.compute_tacan_error_set();
			}	

		if (me.air_data_available == 1)
			{
			me.compute_baro_alt_error();
			}
		me.compute_drag_alt_error();	
		me.update_sv_by_gps();

		SpaceShuttle.air_data_system.update();
		
	},

	update_pos: func {
		me.m_to_lon = 1.0/(math.cos(getprop("/position/latitude-deg")*math.pi/180.0) * 110952.0);
		me.true_pos = geo.aircraft_position();
		me.nav_pos = state_vector_position();
		

	},

	update_nav: func {

		if ((TAEM_guidance_available == 1) or (TAEM_TACAN_available == 1))
			{
			me.nav_bearing_tacan = me.nav_pos.course_to(TAEM_threshold);
			me.nav_dist_tacan = me.nav_pos.distance_to(TAEM_threshold);

			me.tac_bearing_tacan = me.true_pos.course_to(TAEM_threshold) + me.tacan_offset_az_deg;
			me.tac_dist_tacan = me.true_pos.distance_to(TAEM_threshold) + me.tacan_offset_dist * 1853.0;


			me.tac_resid_range = (me.tac_dist_tacan - me.nav_dist_tacan)/1853.0;
			me.tac_resid_bearing = (me.tac_bearing_tacan - me.nav_bearing_tacan);

			me.tac_ratio_range = math.abs(me.tac_resid_range)/0.5;
			me.tac_ratio_bearing = math.abs(me.tac_resid_bearing)/2.5;

			me.gps_resid = me.true_pos.direct_distance_to(me.nav_pos)/1853.0;
			me.gps_ratio = me.gps_resid/0.2;

			SpaceShuttle.tacan_system.redundancy_management();
			}

		if (me.air_data_available == 1)
			{

			me.baro_alt_m = getprop("/instrumentation/altimeter/indicated-altitude-ft") * 0.3048;
			me.adta_resid_h = (me.baro_alt_m - me.nav_pos.alt())/0.3058;
			me.adta_ratio_h = 0.5 * math.abs(me.adta_resid_h)/(me.nav_pos.alt() * 0.016404);
			}
	},

	update_sv_by_gps: func {

		if (me.gps_aut == 0)  {return;}

		if (me.gps_update_cycle_count < 40)
			{
			me.gps_update_cycle_count = me.gps_update_cycle_count + 1;
			return;
			}
		else
			{
			me.gps_update_cycle_count = 0;
			#print("State vector written by GPS");
			SpaceShuttle.GPS_to_prop();
			}


	},

	update_signals: func {

		me.dist_m = 0;	
		if (TAEM_guidance_available == 1)
			{
			me.dist_m = me.true_pos.distance_to(TAEM_threshold);
			}
		else if (SpaceShuttle.entry_guidance_available == 1)
			{
			me.dist_m = getprop("/fdm/jsbsim/systems/entry_guidance/remaining-distance-nm") * 1853.0;
			}
		else 
			{
			me.dist_m = 1000000.0;
			}



		var dist_norm = me.dist_m/741200.0;

		#print ("Range: ", me.dist_m, " norm: ", dist_norm);
		#print ("LOS alt: ", 48000.0 * dist_norm * dist_norm);
		
		if ((me.dist_m < 741200.0) and (me.true_pos.alt() > 48000.0 * dist_norm * dist_norm)) # TACAN range
			{
			
			if (getprop("/fdm/jsbsim/systems/navigation/tacan-available") == 1)
				{
				if (me.TACAN_locked == 0) {print("TACAN signal acquired");}	
				me.TACAN_locked = 1;
				}
			else
				{
				if (me.TACAN_locked == 1) {print("TACAN signal lost");}	
				me.TACAN_locked = 0;
				TAEM_TACAN_available = 0;
				}
			}
		else 
			{
			if (me.TACAN_locked == 1) {print("TACAN signal lost");}	
			me.TACAN_locked = 0;
			TAEM_TACAN_available = 0;
			}



		if ((TAEM_threshold.MLS_available == 1) and (me.dist_m < 37060.0) and (me.true_pos.alt() < 0.5 * me.dist_m)) # MLS range
			{

			
			var heading = getprop("/orientation/heading-deg");
			var delta_az = math.abs(heading - TAEM_threshold.heading);

			var channel_match = 0;

			for (var i=0; i<3; i=i+1)
				{
				if (SpaceShuttle.mls_system.receiver[i].channel == TAEM_threshold.MLS_channel)
					{
					channel_match = 1;
					}
				}


			if ((delta_az < 55.0) and (channel_match == 1))
				{
				if (getprop("/fdm/jsbsim/systems/navigation/mls-available") == 1)
					{
					if (me.MLS_locked == 0) {print("MLS signal acquired");}	
					me.MLS_locked = 1;
					}
				else
					{
					if (me.MLS_locked == 1) {print("MLS signal lost");}	
					me.MLS_locked = 0;
					}
				}
			else	
				{
				if (me.MLS_locked == 1) {print("MLS signal lost");}	
				me.MLS_locked = 0;
				}
			}
			
		else
			{
			if (me.MLS_locked == 1) {print("MLS signal lost");}	
			me.MLS_locked = 0;
			}

		if (getprop("/fdm/jsbsim/systems/navigation/air-data-available") == 1)
			{
			me.air_data_available = 1;
			}
		else
			{
			me.air_data_available = 0;
			}

		if (getprop("/fdm/jsbsim/systems/navigation/gps-available") == 1)
			{
			me.gps_available = 1;
			}	
		else
			{
			me.gps_available = 0;
			}
		

	},


	compute_tacan_error_set : func {


		me.tacan_acc_dist = SpaceShuttle.tacan_system.acc_dist(me.dist_m);
		me.tacan_offset_dist = SpaceShuttle.tacan_system.offset_range();

		me.tacan_acc_az = SpaceShuttle.tacan_system.acc_az(me.dist_m);
		me.tacan_offset_az_deg = SpaceShuttle.tacan_system.offset_az();
		me.tacan_offset_az = me.tacan_offset_az_deg * me.dist_m * math.pi/180.0;

		var bearing_rad = me.true_pos.course_to(TAEM_threshold) * math.pi/180.0;

		var cb = math.cos(bearing_rad);
		var sb = math.sin(bearing_rad);

		var cabs = math.abs(cb);
		var sabs = math.abs(sb);

		if ((me.TACAN_for == 1) or ((me.TACAN_aut == 1) and (me.tac_ratio_range < 1.0) and (me.tac_ratio_bearing < 1.0)))
			{
			me.acc_x = cabs * me.tacan_acc_dist + sabs * me.tacan_acc_az;
			me.acc_y = sabs * me.tacan_acc_dist + cabs * me.tacan_acc_az;

			me.offset_x = cb * me.tacan_offset_dist - sb *  me.tacan_offset_az;
			me.offset_y = sb * me.tacan_offset_dist + cb *  me.tacan_offset_az;

			me.accuracy_lat = me.acc_x * me.m_to_lat;
			me.accuracy_lon = me.acc_y * me.m_to_lon;

			me.offset_lat = me.offset_x * me.m_to_lat;	
			me.offset_lon = me.offset_y * me.m_to_lon;
			}
		else
			{
			me.acc_x = 5000.0;
			me.acc_y = 5000.0;
			me.offset_x = 0.0;
			me.offset_y = 0.0;
			me.offset_lat = 0.0;
			me.offset_lon = 0.0;

			me.accuracy_lat = me.acc_x * me.m_to_lat;
			me.accuracy_lon = me.acc_y * me.m_to_lon;
			
			}

	},

	compute_MLS_error_set : func {

		# according to SCOM, typical errors are 5 ft alt, 21 ft downtrack and 17 ft crosstrack

		me.accuracy_x = 20.0 * 0.3058;
		me.accuracy_y = 20.0 * 0.3058;
		me.accuracy_z = 5.0 * 0.3058;

		me.accuracy_lat = 20.0 * 0.3058 * me.m_to_lat;
		me.accuracy_lon = 20.0 * 0.3085 * me.m_to_lon;
		me.accuracy_alt = 5.0 * 0.3085 ;
		me.acc_z = 5.0;
		me.offset_z = 0.0;
		me.offset_x = 0.0;
		me.offset_y = 0.0;
		me.offset_lat = 0.0;
		me.offset_lon = 0.0;

		me.MLS_processing = 1;



	},

	compute_baro_alt_error : func {

		# FAA allows an 80 ft tolerance at 10.000 ft in barometric altitude
		# so assume the error margin is some 50 ft every 10.000 ft
		
		# in addition we have an offset of the QNH is entered wrong



		if ((me.air_data_h_for == 1) or ((me.air_data_h_aut == 1) and (me.adta_ratio_h < 1.0)))
			{
			me.offset_z = me.baro_alt_m - me.true_pos.alt();
			me.acc_z = me.true_pos.alt() * 0.005;
			}

		else
			{
			me.offset_z = 0.0;
			me.acc_z = 5000.0;
			}

		


	},

	compute_drag_alt_error: func {

		me.drag_h_resid = (me.true_pos.alt() + me.drag_h_offset - me.nav_pos.alt())/0.3058;
		me.drag_h_ratio = math.abs(me.drag_h_resid / 1640.0);

	},


};



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


# helper function to get simulated state vector position rather than 
# true aircraft position

var state_vector_position = func {
	var lat = getprop("/fdm/jsbsim/systems/navigation/state-vector/latitude-deg");
	var lon = getprop("/fdm/jsbsim/systems/navigation/state-vector/longitude-deg");
	var alt = getprop("/fdm/jsbsim/systems/navigation/state-vector/altitude-ft") * 0.3048;
	return geo.Coord.new().set_latlon(lat, lon, alt);
}


# we pick up TACAN from ~400 miles out, at that time we have no TAEM guidance but would like
# to be able to display something, so we create a 'lite' guidance target

var set_TAEM_TACAN = func {

if (TAEM_TACAN_available == 1) {return;}

# first check whether we have a valid runway / site specified

var site_string = getprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site");
var runway_string = getprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway");

set_TAEM_threshold(site_string, runway_string);

if (TAEM_threshold.lat() == 0.0)
	{return;}

print("Site TACAN data available");

TAEM_TACAN_available = 1;

}


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
	#setprop("/sim/messages/copilot", "No TAEM guidance to site possible.");
	SpaceShuttle.callout.make("No TAEM guidance to site possible.", "help");
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

var aim_point_string = getprop("/fdm/jsbsim/systems/approach-guidance/aim-point-string");

var ap_distance = 3000.0;

if (aim_point_string = "CLSE")
	{
	ap_distance = ap_distance - 1000.0 * 0.3048;
	}


var runway_dir_vec = [math.sin(TAEM_threshold.heading * math.pi/180.0), math.cos(TAEM_threshold.heading * math.pi/180.0)];


#print (TAEM_threshold.heading, " ", runway_dir_vec[0], " ", runway_dir_vec[1]);

TAEM_WP_2.set_latlon(TAEM_threshold.lat() - m_to_lat * runway_dir_vec[1] * ep_distance,  TAEM_threshold.lon() - m_to_lon *runway_dir_vec[0] * ep_distance);
TAEM_WP_2.set_alt(ep_altitude);

# store the aim point

TAEM_AP.set_latlon(TAEM_threshold.lat() - m_to_lat * runway_dir_vec[1] * ap_distance,  TAEM_threshold.lon() - m_to_lon *runway_dir_vec[0] * ap_distance);
TAEM_AP.set_alt(TAEM_threshold.alt());


# construct the edges of the HUD virtual runway

TAEM_rwy_nl.set_latlon(TAEM_threshold.lat(), TAEM_threshold.lon(), TAEM_threshold.alt());
TAEM_rwy_nl.apply_course_distance( (TAEM_threshold.heading - 180.0), 200.0); 
TAEM_rwy_nl.apply_course_distance( (TAEM_threshold.heading - 90.0), 50.0); 

TAEM_rwy_nr.set_latlon(TAEM_threshold.lat(), TAEM_threshold.lon(), TAEM_threshold.alt());
TAEM_rwy_nr.apply_course_distance( (TAEM_threshold.heading - 180.0), 200.0); 
TAEM_rwy_nr.apply_course_distance( (TAEM_threshold.heading + 90.0), 50.0); 

TAEM_rwy_fl.set_latlon(TAEM_threshold.lat(), TAEM_threshold.lon(), TAEM_threshold.alt());
TAEM_rwy_fl.apply_course_distance( TAEM_threshold.heading, TAEM_threshold.rwy_length); 
TAEM_rwy_fl.apply_course_distance( (TAEM_threshold.heading - 90.0), 50.0);

TAEM_rwy_fr.set_latlon(TAEM_threshold.lat(), TAEM_threshold.lon(), TAEM_threshold.alt());
TAEM_rwy_fr.apply_course_distance( TAEM_threshold.heading, TAEM_threshold.rwy_length); 
TAEM_rwy_fr.apply_course_distance( (TAEM_threshold.heading + 90.0), 50.0);

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


# now figure out what direction to turn onto the HAC

var test_vec = [runway_perp_vec[1], -runway_perp_vec[0]];



var turn_direction = "right";

if (SpaceShuttle.dot_product_2d(runway_dir_vec, test_vec) > 0.0)
	{
	turn_direction = "left";
	}



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

#var pos = geo.aircraft_position();

var pos = state_vector_position();

TAEM_predictor_set.update();

if (TAEM_guidance_available == 0)
	{
	TAEM_loop_running = 0;
	return;
	} 

update_HUD_symbology(pos);

#area_nav_set.update_signals();


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
			#setprop("/sim/messages/copilot", "Turn "~turn_direction~" into HAC!");
			SpaceShuttle.callout.make("Turn "~turn_direction~" into HAC!", "help");
			TAEM_guidance_phase = 2;
	
			if (turn_direction == "right")
				{setprop("/fdm/jsbsim/systems/ap/taem/set-bank-target", 15.0);}
			else
				{setprop("/fdm/jsbsim/systems/ap/taem/set-bank-target", -15.0);}
			TAEM_guidance_string = "HDG";
			setprop("/fdm/jsbsim/systems/ap/taem/hac-turn-init", 1);
			}

	}
else if (stage == 1) # turn around HAC
	{

	TAEM_guidance_string = "HDG";
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
		#setprop("/sim/messages/copilot", "Take CSS and turn into final!");
		SpaceShuttle.callout.make("Take CSS and turn into final!", "help");
		setprop("/fdm/jsbsim/systems/ap/taem/set-bank-target", 0.0);
		setprop("/fdm/jsbsim/systems/ap/taem/hac-turn-init", 0);
		setprop("/fdm/jsbsim/systems/ap/taem/s-turn-init", 0);
		setprop("/fdm/jsbsim/systems/ap/taem/al-init", 1);

		TAEM_guidance_string = "PREFNL";
		approach_guidance_loop();

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


# TAEM energy management - speedbrake and S-Turns #################################################

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
	TAEM_guidance_string = "S-TURN";
	if (getprop("/fdm/jsbsim/systems/ap/taem/s-turn-init") == 1) # we are in a turn
		{
		var delta_az = getprop("/fdm/jsbsim/systems/taem-guidance/delta-azimuth-deg");
		if (delta_az > 30.0)		
			{
			if (getprop("/fdm/jsbsim/systems/ap/taem/set-bank-target") == -30.0)
				{
				#setprop("/sim/messages/copilot", "S-turn reversal!");
				SpaceShuttle.callout.make("S-turn reversal!", "info");
				}

			setprop("/fdm/jsbsim/systems/ap/taem/set-bank-target", 30.0);

			}
		else if (delta_az < -30.0)
			{
			if (getprop("/fdm/jsbsim/systems/ap/taem/set-bank-target") == 30.0)
				{
				#setprop("/sim/messages/copilot", "S-turn reversal!");
				SpaceShuttle.callout.make("S-turn reversal!", "info");
				}
			setprop("/fdm/jsbsim/systems/ap/taem/set-bank-target", -30.0);
			}

		}
	else
		{
		setprop("/fdm/jsbsim/systems/ap/taem/set-bank-target", 30.0);
		#setprop("/sim/messages/copilot", "Initiating S-turn to deplete energy!");
		SpaceShuttle.callout.make("Initiating S-turn to deplete energy!", "info");
		setprop("/fdm/jsbsim/systems/ap/taem/s-turn-init",1);
	
		}	

	}
else # no S-turn
	{
	if (TAEM_guidance_phase == 1)
		{TAEM_guidance_string = "ACQ";}
	else
		{TAEM_guidance_string = "HDG";}
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

# smart flare guidance ##################################################################

var smart_flare  = func (alt_agl, airspeed, vspeed) {

var alt_m = alt_agl * 0.3048;
var vspeed_m = vspeed * 0.3048;
var hspeed_m = math.sqrt(math.pow(airspeed * 0.514, 2.0) - math.pow(vspeed_m, 2.0));

var alt_tgt_m = 150.0 * 0.3048;
var alpha = getprop ("fdm/jsbsim/aero/alpha-deg");
var angle = -getprop("/orientation/pitch-deg") + alpha;
var angle_tgt = 1.5;
var angle_rad = angle * math.pi/180.0;
var angle_tgt_rad = angle_tgt * math.pi/180.0; 


var t = (alt_m - alt_tgt_m) / (0.5 *  hspeed_m * (angle_rad + angle_tgt_rad ));
var a = (angle - angle_tgt) / t;

return a;

}


# the  approach guidance loop ###########################################################


var approach_guidance_loop = func {

#var pos = geo.aircraft_position();

var pos = state_vector_position();

var dist = pos.distance_to(TAEM_threshold);
var course = pos.course_to(TAEM_threshold);
var heading = getprop("/orientation/heading-deg");

var alt_agl = getprop("/position/altitude-agl-ft");
var vspeed = getprop("/fdm/jsbsim/velocities/v-down-fps");
var airspeed = getprop("/fdm/jsbsim/velocities/ve-kts");

update_HUD_symbology(pos);

if (TAEM_guidance_phase == 3) 
	{
	if ((math.abs (course-heading) < 10.0) and (math.abs(HUD_data_set.vangle_aim - 17.0) < 10.0))
		{
		# we acquired glideslope
		HUD_data_set.MLS_acquired = 1;
		TAEM_guidance_phase = 4;
		TAEM_guidance_string = "OGS";
		}
	}

if (TAEM_guidance_phase == 4)
	{
	
	var GLSD = (HUD_data_set.vangle_aim - 17.0);
	HUD_data_set.vangle_guidance = 17.0 + 1.5 * GLSD;

	# auto-SB control


	sb_max = 0.0;

	if (airspeed > 310.0) {sb_max = 1.0;}
	else if (airspeed > 300.0) {sb_max = 0.8;}
	else if (airspeed > 290.0) {sb_max = 0.6;}
	else if (airspeed > 285.0) {sb_max = 0.4;}
	else if (airspeed > 280.0) {sb_max = 0.2;}

	if (alt_agl < 3000.0) 
		{
		var sb_mode = getprop("/fdm/jsbsim/systems/approach-guidance/speedbrake-mode-string");

		if (sb_mode == "NOM") {sb_max = 0.4;}
		else if (sb_mode == "SHORT") {sb_max = 0.6;}
		else if (sb_mode == "ELS") {sb_max = 0.8;}


		}

	if (getprop("/fdm/jsbsim/systems/ap/automatic-sb-control") == 1)	
		{
		var sb_state = getprop("/controls/shuttle/speedbrake");

		if (sb_state > sb_max) {SpaceShuttle.decrease_speedbrake(); }
		else if (sb_state < sb_max) {SpaceShuttle.increase_speedbrake();}
		
		}
	

	if (alt_agl < 2000.0)
		{
		# we initiate pre-flare
		TAEM_guidance_phase = 5;
		TAEM_guidance_string = "FLARE";
		}
	}

if (TAEM_guidance_phase == 5)
	{

	# use smart pull-up guidance

	var pull_up_speed = smart_flare (alt_agl, airspeed, vspeed);
	var dt = getprop("/sim/time/delta-sec");


	HUD_data_set.vangle_guidance = HUD_data_set.vangle_guidance - pull_up_speed * dt;
	if (HUD_data_set.vangle_guidance < 1.5)
		{HUD_data_set.vangle_guidance = 1.5;}

	if (vspeed < 15.0)
		{
		# transit to inner glideslope
		TAEM_guidance_phase = 6;
		TAEM_guidance_string = "IGS";
		}

	if (alt_agl < 50.0)
		{
		TAEM_guidance_phase = 7;
		TAEM_guidance_string = "FNLFL";
		HUD_data_set.vangle_guidance = 0.1;
		}

	}


if (TAEM_guidance_phase == 6) 
	{
	var dt = getprop("/sim/time/delta-sec");
	HUD_data_set.vangle_guidance = HUD_data_set.vangle_guidance - 1.5 * dt;
	if (HUD_data_set.vangle_guidance < 1.5)
		{HUD_data_set.vangle_guidance = 1.5;}
	

	if (alt_agl < 50.0)
		{
		TAEM_guidance_phase = 7;
		TAEM_guidance_string = "FNLFL";
		HUD_data_set.vangle_guidance = 0.1;
		}


	}

if (airspeed < 170.0) 
	{
	print ("Approach guidance signing off!");
	return;
	}

settimer( approach_guidance_loop, 0.0);

}



# virtual rwy symbology for the HUD #######################################################

var update_HUD_symbology = func (pos) {


var vdist = pos.alt() - TAEM_threshold.alt();
var heading = getprop("/orientation/heading-deg");


# aim point and touchdown point

var dist = pos.distance_to(TAEM_threshold);
var course = pos.course_to(TAEM_threshold);
var vAngle_rad = math.atan2(vdist, dist);

var aim_dist = pos.distance_to(TAEM_AP);
var aim_course= pos.course_to(TAEM_AP);
var vAimAngle_rad = math.atan2(vdist, aim_dist);

HUD_data_set.vangle_aim = vAimAngle_rad * 180.0/math.pi;
HUD_data_set.hangle_aim = (aim_course - heading);

HUD_data_set.vangle_threshold = math.atan2(vdist, dist) * 180.0/math.pi;
HUD_data_set.hangle_threshold = (course - heading);

# virtual runway edges

var nr_dist = pos.distance_to(TAEM_rwy_nr);
var nr_course = pos.course_to(TAEM_rwy_nr);

HUD_data_set.vangle_nr = math.atan2(vdist, nr_dist) * 180.0/math.pi;
HUD_data_set.hangle_nr = (nr_course - heading);


var nl_dist = pos.distance_to(TAEM_rwy_nl);
var nl_course = pos.course_to(TAEM_rwy_nl);

HUD_data_set.vangle_nl = math.atan2(vdist, nl_dist) * 180.0/math.pi;
HUD_data_set.hangle_nl = (nl_course - heading);

var fr_dist = pos.distance_to(TAEM_rwy_fr);
var fr_course = pos.course_to(TAEM_rwy_fr);

HUD_data_set.vangle_fr = math.atan2(vdist, fr_dist) * 180.0/math.pi;
HUD_data_set.hangle_fr = (fr_course - heading);


var fl_dist = pos.distance_to(TAEM_rwy_fl);
var fl_course = pos.course_to(TAEM_rwy_fl);

HUD_data_set.vangle_fl = math.atan2(vdist, fl_dist) * 180.0/math.pi;
HUD_data_set.hangle_fl = (fl_course - heading);

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
		TAEM_threshold.MLS_channel = 8;
		}
	else if (runway_string == "33")
		{
		TAEM_threshold.set_latlon(28.5985,-80.6836);
		TAEM_threshold.heading = 330.0;
		TAEM_threshold.elevation = 0.0;
		TAEM_threshold.MLS_channel = 6;
		}
	TAEM_threshold.rwy_length = 4572.0;
	TAEM_threshold.MLS_available = 1;
	}
else if (site_string == "Vandenberg Air Force Base")
	{
	if (runway_string == "12")
		{
		TAEM_threshold.set_latlon(34.7502,-120.5991);
		TAEM_threshold.heading = 136.5;
		TAEM_threshold.elevation = 362.0;
		TAEM_threshold.MLS_channel = 8;
		}
	else if (runway_string == "30")
		{
		TAEM_threshold.set_latlon(34.7242,-120.5692);
		TAEM_threshold.heading = 316.5;
		TAEM_threshold.elevation = 362.0;
		TAEM_threshold.MLS_channel = 6;
		}
	TAEM_threshold.rwy_length = 4572.0;
	TAEM_threshold.MLS_available = 1;
	}
else if (site_string == "Edwards Air Force Base")
	{
	if (runway_string == "06")
		{
		TAEM_threshold.set_latlon(34.9498,-117.8608);
		TAEM_threshold.heading = 64.5;
		TAEM_threshold.elevation = 2280.0;
		TAEM_threshold.MLS_channel = 6;
		}
	else if (runway_string == "24")
		{
		TAEM_threshold.set_latlon(34.9655,-117.8200);
		TAEM_threshold.heading = 244.5;
		TAEM_threshold.elevation = 2280.0;
		TAEM_threshold.MLS_channel = 8;
		}
	TAEM_threshold.rwy_length = 4572.0;
	TAEM_threshold.MLS_available = 1;
	}
else if (site_string == "White Sands Space Harbour")
	{
	if (runway_string == "14")
		{
		TAEM_threshold.set_latlon(32.9754,-106.3313);
		TAEM_threshold.heading = 142.0;
		TAEM_threshold.elevation = 4450.0;
		TAEM_threshold.MLS_channel = 6;
		}
	else if (runway_string == "32")
		{
		TAEM_threshold.set_latlon(32.8815,-106.2477);
		TAEM_threshold.heading = 322.0;
		TAEM_threshold.elevation = 4450.0;
		TAEM_threshold.MLS_channel = 6;
		}
	TAEM_threshold.MLS_available = 1;
	TAEM_threshold.rwy_length = 4572.0;
	TAEM_threshold.MLS_available = 0;
	}
else if (site_string == "Zaragoza Airport")
	{
	if (runway_string == "12")
		{
		TAEM_threshold.set_latlon(41.6783,-1.0781);
		TAEM_threshold.heading = 120.0;
		TAEM_threshold.elevation = 834.0;
		TAEM_threshold.MLS_channel = -1;
		}
	else if (runway_string == "30")
		{
		TAEM_threshold.set_latlon(41.6647,-1.0466);
		TAEM_threshold.heading = 300.0;
		TAEM_threshold.elevation = 866.0;
		TAEM_threshold.MLS_channel = 6;
		}
	TAEM_threshold.rwy_length = 3718.0;
	TAEM_threshold.MLS_available = 1;
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
	TAEM_threshold.rwy_length = 3045.0;
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
	TAEM_threshold.rwy_length = 3600.0;
	}
else if (site_string == "Moron Air Base")
	{
	if (runway_string == "02")
		{
		TAEM_threshold.set_latlon(37.1633,-5.6212);
		TAEM_threshold.heading = 20.0;
		TAEM_threshold.elevation = 300.0;
		TAEM_threshold.MLS_channel = -1;
		}
	else if (runway_string == "20")
		{
		TAEM_threshold.set_latlon(37.1863,-5.6106);
		TAEM_threshold.heading = 200.0;
		TAEM_threshold.elevation = 280.0;
		TAEM_threshold.MLS_channel = 6;
		}
	TAEM_threshold.rwy_length = 3597.0;
	TAEM_threshold.MLS_available = 1;
	}
else if (site_string == "Le Tube")
	{
	if (runway_string == "15")
		{
		TAEM_threshold.set_latlon(43.5341, 4.9158);
		TAEM_threshold.heading = 152.0;
		TAEM_threshold.elevation = 80.0;
		TAEM_threshold.MLS_channel = -1;
		}
	else if (runway_string == "33")
		{
		TAEM_threshold.set_latlon(43.5104, 4.9327);
		TAEM_threshold.heading = 332.0;
		TAEM_threshold.elevation = 80.0;
		TAEM_threshold.MLS_channel = 6;
		}
	TAEM_threshold.rwy_length = 5000.0;
	TAEM_threshold.MLS_available = 1;
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
	TAEM_threshold.rwy_length = 2947.0;
	}
else if (site_string == "Halifax")
	{
	if (runway_string == "05")
		{
		TAEM_threshold.set_latlon(44.8712,-63.5224);
		TAEM_threshold.heading = 35.0;
		TAEM_threshold.elevation = 460.0;
		}
	else if (runway_string == "23")
		{
		TAEM_threshold.set_latlon(44.88645,-63.5074);
		TAEM_threshold.heading = 215.0;
		TAEM_threshold.elevation = 460.0;
		}
	TAEM_threshold.rwy_length = 3200.0;
	}
else if (site_string == "Wilmington")
	{
	if (runway_string == "06")
		{
		TAEM_threshold.set_latlon(34.263878,-77.90763);
		TAEM_threshold.heading = 48.5;
		TAEM_threshold.elevation = 25.0;
		}
	else if (runway_string == "24")
		{
		TAEM_threshold.set_latlon(34.274647,-77.89300);
		TAEM_threshold.heading = 228.5;
		TAEM_threshold.elevation = 25.0;
		}
	TAEM_threshold.rwy_length = 2440.0;
	}
else if (site_string == "Atlantic City")
	{
	if (runway_string == "13")
		{
		TAEM_threshold.set_latlon(39.463004,-74.587947);
		TAEM_threshold.heading = 118.0;
		TAEM_threshold.elevation = 60.0;
		}
	else if (runway_string == "31")
		{
		TAEM_threshold.set_latlon(39.452876,-74.563379);
		TAEM_threshold.heading = 298.0;
		TAEM_threshold.elevation = 60.0;
		}
	TAEM_threshold.rwy_length = 3048.0;
	}
else if (site_string == "Myrtle Beach")
	{
	if (runway_string == "18")
		{
		TAEM_threshold.set_latlon(33.68989,-78.9308498);
		TAEM_threshold.heading = 169.0;
		TAEM_threshold.elevation = 30.0;
		}
	else if (runway_string == "36")
		{
		TAEM_threshold.set_latlon(33.669623,-78.9258308);
		TAEM_threshold.heading = 349.0;
		TAEM_threshold.elevation = 30.0;
		}
	TAEM_threshold.rwy_length = 2897.0;
	}
else if (site_string == "Gander")
	{
	if (runway_string == "03")
		{
		TAEM_threshold.set_latlon(48.922472, -54.567853);
		TAEM_threshold.heading = 11.0;
		TAEM_threshold.elevation = 420.0;
		}
	else if (runway_string == "21")
		{
		TAEM_threshold.set_latlon(48.946827, -54.560682);
		TAEM_threshold.heading = 191.0;
		TAEM_threshold.elevation = 450.0;
		}
	TAEM_threshold.rwy_length = 3109.0;
	}
else if (site_string == "Pease")
	{
	if (runway_string == "16")
		{
		TAEM_threshold.set_latlon(43.0870822, -70.83065635);
		TAEM_threshold.heading = 149.0;
		TAEM_threshold.elevation = 100.0;
		}
	else if (runway_string == "34")
		{
		TAEM_threshold.set_latlon(43.0671732, -70.814452883);
		TAEM_threshold.heading = 329.0;
		TAEM_threshold.elevation = 70.0;
		}
	TAEM_threshold.rwy_length = 3451.0;
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
	TAEM_threshold.rwy_length = 3318.0;
	}
else if (site_string == "Diego Garcia")
	{
	if (runway_string == "13")
		{
		TAEM_threshold.set_latlon(-7.30548,72.39848);
		TAEM_threshold.heading = 121.5;
		TAEM_threshold.elevation = 5.0;
		}
	else if (runway_string == "31")
		{
		TAEM_threshold.set_latlon(-7.320205,72.42238);
		TAEM_threshold.heading = 301.5;
		TAEM_threshold.elevation = 10.0;
		}
	TAEM_threshold.rwy_length = 3659.0;
	}
else if (site_string == "Honolulu")
	{
	if (runway_string == "08")
		{
		TAEM_threshold.set_latlon(21.3068015,-157.942542);
		TAEM_threshold.heading = 90;
		TAEM_threshold.elevation = 0.0;
		}
	else if (runway_string == "26")
		{
		TAEM_threshold.set_latlon(21.3067945,-157.914083);
		TAEM_threshold.heading = 270.0;
		TAEM_threshold.elevation = 0.0;
		}
	TAEM_threshold.rwy_length = 3753.0;
	}
else if (site_string == "Keflavik")
	{
	if (runway_string == "10")
		{
		TAEM_threshold.set_latlon(63.985050, -22.648608);
		TAEM_threshold.heading = 90;
		TAEM_threshold.elevation = 110.0;
		}
	else if (runway_string == "28")
		{
		TAEM_threshold.set_latlon(63.9850472, -22.5986417);
		TAEM_threshold.heading = 270.0;
		TAEM_threshold.elevation = 175.0;
		}
	TAEM_threshold.rwy_length = 3753.0;
	}
else if (site_string == "Andersen Air Force Base")
	{
	if (runway_string == "06")
		{
		TAEM_threshold.set_latlon(13.5765189, 144.91921413);
		TAEM_threshold.heading = 66.0;
		TAEM_threshold.elevation = 540.0;
		}
	else if (runway_string == "24")
		{
		TAEM_threshold.set_latlon(13.58715568, 144.9434987);
		TAEM_threshold.heading = 246.0;
		TAEM_threshold.elevation = 590.0;
		}
	TAEM_threshold.rwy_length = 3409.0;
	}

else
	{
	#setprop("/sim/messages/copilot", "No TAEM guidance data to site available.");
	SpaceShuttle.callout.make("No TAEM guidance data to site available.", "help");
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
