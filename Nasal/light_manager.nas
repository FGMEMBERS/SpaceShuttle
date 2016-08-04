# lighting manager for the Space Shuttle
# Thorsten Renk 2016

var light_manager = {

	current_theme: "CLEAR",
	red: 0.0,
	green: 0.0,
	blue: 0.0,
	srb_red: 0.0,
	srb_green: 0.0,
	srb_blue: 0.0,
	x: 0.0,
	etx: 0.0,
	y: 0.0, 
	z: 0.0,	
	radius: 0.0,
	ambience: 0.0,

	flicker: 0,
	flicker_strength: 0.025,
	runway: 0,

	red_tgt: 0.0,
	green_tgt: 0.0,
	blue_tgt: 0.0,
	srb_red_tgt: 0.0,
	srb_green_tgt: 0.0,
	srb_blue_tgt: 0.0,
	x_tgt: 0.0,
	etx_tgt: 0.0,
	y_tgt: 0.0, 
	z_tgt: 0.0,	
	radius_tgt: 0.0,
	ambience_tgt: 0.0,

	lat_to_m: 110952.0,
	lon_to_m: 0.0,
	coord_factor: 0.0,
	rpos: {},

	set_theme:  func (theme) {

	var light_intensity = getprop("/rendering/scene/diffuse/red");

	var dim = 1.0 - light_intensity;
	#print ("Current dim: ",dim);
	me.current_theme = theme;

	if (theme == "PAD")
		{
		me.red = 0.7 * dim;
		me.green = 0.7 * dim;
		me.blue= 0.7 * dim;
		me.srb_red = 0.0;
		me.srb_green = 0.0;
		me.srb_blue= 0.0;
		me.x = 0.0;
		me.etx = 0.0;
		me.y = 0.0;
		me.z = 10.0;
		me.radius = 24.0;
		me.ambience = 0.1;
		me.flicker_stop();
		me.apply();
		}
	else if (theme == "SRB")
		{
		me.red = 2.4 * dim;
		me.green = 2.2 * dim;
		me.blue= 1.4 * dim;
		me.srb_red = 2.4 * dim;
		me.srb_green = 2.2 * dim;
		me.srb_blue= 1.4 * dim;
		me.x = 10.0;
		me.etx = -10.0;
		me.y = 0.0;
		me.z = -4.0;
		me.radius = 30.0;
		me.ambience = 0.4;
		me.flicker_start();
		me.apply();
		}
	else if (theme == "SSME")
		{
		me.red_tgt = 0.5 * dim;
		me.green_tgt = 0.5 * dim;
		me.blue_tgt = 0.5 * dim;
		me.x_tgt = 17.0;
		me.etx_tgt = -30.0;
		me.y_tgt = 0.0;
		me.z_tgt = -4.0;
		me.radius_tgt = 10.0;
		me.radius = 40.0;
		me.ambience_tgt = 0.2;
		setprop("/lighting/effects/geo-srb-r", 50.0);	
		me.flicker_stop();
		me.srb_sep_transition(3.5, 0.0);
		}
	else if (theme == "OMS")
		{
		me.red = 0.72 * dim;
		me.green = 0.72 * dim;
		me.blue= 0.558 * dim;
		me.x = 18.5;
		me.y = 0.0;
		me.z = 2.0;
		me.radius = 10.0;
		me.ambience = 0.2;
		me.apply();
		}
	else if (theme = "RUNWAY")
		{
		me.red = 0.0;
		me.green = 0.0;
		me.blue= 0.0;
		me.srb_red = 0.0;
		me.srb_green = 0.0;
		me.srb_blue= 0.0;
		me.x = 0.0;
		me.etx = 0.0;
		me.y = 0.0;
		me.z = 0.0;
		me.radius = 0.0;
		me.ambience = 0.0;
		me.rwy_loop_start();
		}
	else if (theme = "CLEAR")
		{
		me.red = 0.0;
		me.green = 0.0;
		me.blue= 0.0;
		me.srb_red = 0.0;
		me.srb_green = 0.0;
		me.srb_blue= 0.0;
		me.x = 0.0;
		me.etx = 0.0;
		me.y = 0.0;
		me.z = 0.0;
		me.radius = 0.0;
		me.ambience = 0.0;
		me.flicker_stop();
		me.apply();
		}



	},

	
	srb_sep_transition: func (transit_time, time) {

		var dt =  getprop("/sim/time/delta-sec");
		time += dt;

		if (time > transit_time) {time = transit_time;}

		var rel_change = time/transit_time;

		setprop("/lighting/effects/geo-red", me.red + rel_change * (me.red_tgt - me.red));
		setprop("/lighting/effects/geo-green", me.green + rel_change * (me.green_tgt - me.green));
		setprop("/lighting/effects/geo-blue", me.blue + rel_change * (me.blue_tgt - me.blue));

		setprop("/lighting/effects/geo-x", me.x + rel_change * (me.x_tgt - me.x));
		setprop("/lighting/effects/geo-y", me.y + rel_change * (me.y_tgt - me.y));
		setprop("/lighting/effects/geo-z", me.z + rel_change * (me.z_tgt - me.z));
		setprop("/lighting/effects/geo-z1", -(me.z + rel_change * (me.z_tgt - me.z)));

		setprop("/lighting/effects/geo-et-x", me.etx + rel_change * (me.etx_tgt - me.etx));
		setprop("/lighting/effects/geo-et-y", me.y + rel_change * (me.y_tgt - me.y));
		setprop("/lighting/effects/geo-et-z", me.z + rel_change * (me.z_tgt - me.z));
		setprop("/lighting/effects/geo-et-z1", -(me.z + rel_change * (me.z_tgt - me.z)));

		setprop("/lighting/effects/geo-r", me.radius + rel_change * (me.radius_tgt - me.radius));
		setprop("/lighting/effects/geo-ambience", me.ambience + rel_change * (me.ambience_tgt - me.ambience));


		if (time == transit_time)
			{
			setprop("/lighting/effects/geo-red", me.red_tgt);
			setprop("/lighting/effects/geo-green", me.green_tgt);
			setprop("/lighting/effects/geo-blue", me.blue_tgt);

			setprop("/lighting/effects/geo-x", me.x_tgt );
			setprop("/lighting/effects/geo-y", me.y_tgt);
			setprop("/lighting/effects/geo-z", me.z_tgt);
			setprop("/lighting/effects/geo-z1", -me.z_tgt);

			setprop("/lighting/effects/geo-et-x", me.etx_tgt);
			setprop("/lighting/effects/geo-et-y", me.y_tgt);
			setprop("/lighting/effects/geo-et-z", me.z_tgt);
			setprop("/lighting/effects/geo-et-z1", -me.z_tgt);

			setprop("/lighting/effects/geo-r", me.radius_tgt);
			setprop("/lighting/effects/geo-ambience", me.ambience_tgt);

			me.red = me.red_tgt;
			me.green = me.green_tgt;
			me.blue = me.blue_tgt;

			me.x = me.x_tgt;
			me.y = me.y_tgt;
			me.z = me.z_tgt;

			me.etx = me.etx_tgt;
			me.radius = me.radius_tgt;
			me.ambience = me.ambience_tgt;

			return;
			}
		
	
		settimer (func me.srb_sep_transition(transit_time, time), 0.0);
	},


	apply: func {

		setprop("/lighting/effects/geo-red", me.red);
		setprop("/lighting/effects/geo-green", me.green);
		setprop("/lighting/effects/geo-blue", me.blue);
		setprop("/lighting/effects/geo-srb-red", me.srb_red);
		setprop("/lighting/effects/geo-srb-green", me.srb_green);
		setprop("/lighting/effects/geo-srb-blue", me.srb_blue);
		setprop("/lighting/effects/geo-x", me.x);
		setprop("/lighting/effects/geo-y", me.y);
		setprop("/lighting/effects/geo-z", me.z);
		setprop("/lighting/effects/geo-z1", -me.z);
		setprop("/lighting/effects/geo-et-x", me.etx);
		setprop("/lighting/effects/geo-et-y", me.y);
		setprop("/lighting/effects/geo-et-z", me.z);
		setprop("/lighting/effects/geo-et-z1", -me.z);
		setprop("/lighting/effects/geo-r", me.radius);	
		setprop("/lighting/effects/geo-srb-r", me.radius);	
		setprop("/lighting/effects/geo-ambience", me.ambience);	
	},

	flicker_start: func {

		me.flicker = 1;
		me.flicker_loop();

	},

	flicker_loop: func {

		if (me.flicker == 0) {return;}
		var rnd = me.radius * me.flicker_strength * (rand() - 0.5);
		setprop("/lighting/effects/geo-r", me.radius + rnd);	

		settimer(func me.flicker_loop(), 0.0);
	},

	flicker_stop: func {
		me.flicker = 0;

	},
	
	rwy_loop_start: func {

		if (SpaceShuttle.TAEM_guidance_available == 0) {return;}

		var light_intensity = getprop("/rendering/scene/diffuse/red");

		if (light_intensity > 0.2) {return;}

		setprop("/sim/rendering/als-secondary-lights/lightspot/size", 40.0);
		setprop("/sim/rendering/als-secondary-lights/lightspot/stretch", 30.0);
		setprop("/sim/rendering/als-secondary-lights/lightspot/dir", SpaceShuttle.TAEM_threshold.heading * math.pi/180.0);
		setprop("/sim/rendering/als-secondary-lights/num-lightspots", 1);

		setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-r", 0.6);
		setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-g", 0.6);
		setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-b", 0.6);


		setprop("/lighting/effects/geo-red", 1.5);
		setprop("/lighting/effects/geo-green", 1.5);
		setprop("/lighting/effects/geo-blue", 1.5);

		setprop("/lighting/effects/geo-r", 80.0);
		setprop("/lighting/effects/geo-x", 80.0);
		setprop("/lighting/effects/geo-y", 0.0);
		setprop("/lighting/effects/geo-z", 5.0);
		setprop("/lighting/effects/geo-z1", -5.0);
		setprop("/lighting/effects/geo-ambience", 0.5);

		me.rpos = geo.Coord.new();
		me.rpos.set_latlon(SpaceShuttle.TAEM_threshold.lat(), SpaceShuttle.TAEM_threshold.lon(), SpaceShuttle.TAEM_threshold.elevation * 0.3048);


		var lat = SpaceShuttle.TAEM_threshold.lat();
		var lon = SpaceShuttle.TAEM_threshold.lon();

		me.lon_to_m = math.cos(lat*math.pi/180.0) * me.lat_to_m;

		var heading = SpaceShuttle.TAEM_threshold.heading * math.pi/180.0;

		me.rpos.set_lat(lat + (330.0 * math.cos(heading)) / me.lat_to_m);
		me.rpos.set_lon(lon + (330.0 * math.sin(heading)) / me.lon_to_m);

		var site_string = getprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site");
		var runway_string = getprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway");

		me.coord_factor = me.coord_compensation(site_string, runway_string);
		#print("Compensation factor: ", me.coord_factor);

		# don't start the loop again if it is already running
		if (me.runway == 1) {return;}

		me.runway = 1;
		me.runway_loop();

	},

	runway_loop: func {

		if (me.runway == 0) {return;}

		var vpos = geo.viewer_position();
		var apos = geo.aircraft_position();
		var dist = apos.distance_to(SpaceShuttle.TAEM_threshold);

		var coord_comp = math.abs(me.rpos.lat() - vpos.lat()) * me.coord_factor;
		var coord_comp_v = (dist * dist) / (2.0 * 6371000.0); 

		var delta_x = (me.rpos.lat() - vpos.lat()) * me.lat_to_m;
		var delta_y = -(me.rpos.lon() - vpos.lon()) * me.lon_to_m + coord_comp;

		var delta_z = me.rpos.alt() - vpos.alt() + coord_comp_v;

		setprop("/sim/rendering/als-secondary-lights/lightspot/eyerel-x-m", delta_x);
		setprop("/sim/rendering/als-secondary-lights/lightspot/eyerel-y-m", delta_y);
		setprop("/sim/rendering/als-secondary-lights/lightspot/eyerel-z-m", delta_z);




		var light_fact = 1.0 - SpaceShuttle.smoothstep(250.0, 1200.0, dist);
		light_fact = light_fact * (1.0 - SpaceShuttle.smoothstep(0.0, 150.0, getprop("/position/altitude-agl-ft")));
		
		setprop("/lighting/effects/geo-x", 90.0 - 25.0 * light_fact);



		settimer(func me.runway_loop(), 0.0);
	},

		
	rwy_loop_stop: func {
	
		me.runway = 0;
	
	},

	coord_compensation: func (site_string, runway_string) {

	if (site_string == "Kennedy Space Center")
		{
		if (runway_string == "15") { return -200.0;}
		else {return 400.0;}		
		}
	else if (site_string == "Vandenberg Air Force Base")
		{
		if (runway_string == "12") {return -150.0;}
		else {return 450.0;}
		}
	return 0.0;

	},

};


var oms_light_check = func {


if ((light_manager.current_theme != "CLEAR") and (light_manager.current_theme != "OMS"))	
	{return;} 



var thrust_OMS1 = getprop("/engines/engine[5]/thrust_lb");
var thrust_OMS2 = getprop("/engines/engine[6]/thrust_lb");

if (((thrust_OMS1 > 0.0) or (thrust_OMS2 > 0.0)) and (light_manager.current_theme == "CLEAR"))
	{
	light_manager.set_theme("OMS");
	}
else if ((thrust_OMS1 == 0.0) and (thrust_OMS2 == 0.0) and (light_manager.current_theme == "OMS"))
	{
	light_manager.set_theme("CLEAR");
	}
}


#########################################################################################
# color adjustment for effect palette based on scene light available
#########################################################################################


var adjust_effect_colors = func {

var light_intensity = getprop("/rendering/scene/diffuse/red");

setprop("/lighting/effects/color-1", 0.1 * light_intensity);
setprop("/lighting/effects/color-2", 0.2 * light_intensity);
setprop("/lighting/effects/color-3", 0.3 * light_intensity);
setprop("/lighting/effects/color-4", 0.4 * light_intensity);
setprop("/lighting/effects/color-5", 0.5 * light_intensity);
setprop("/lighting/effects/color-6", 0.6 * light_intensity);
setprop("/lighting/effects/color-7", 0.7 * light_intensity);
setprop("/lighting/effects/color-8", 0.8 * light_intensity);
setprop("/lighting/effects/color-9", 0.9 * light_intensity);
setprop("/lighting/effects/color-10", light_intensity);


}

#########################################################################################
# cloud illumination
# this uses Advanced Weather lightning position info - don't use this elsewhere
# unless you exactly know what you're doing
#########################################################################################

var cloud_illumination = func {

var light_intensity = getprop("/rendering/scene/diffuse/red");

if (light_intensity > 0.3) {return;}

var alt = getprop("/position/altitude-ft");

var radius = 450.0;

if ((alt > 30000.0) and (alt < 50000.0))
	{
	radius = 550.0 - 550.0 * (alt -30000.0)/20000.0;
	}
else if (alt > 50000.0)
	{
	radius = 0;
	}

setprop("/environment/lightning/lightning-range", radius);



}


setlistener("/engines/engine[5]/thrust_lb", func {oms_light_check();},0,0);
setlistener("/engines/engine[6]/thrust_lb", func {oms_light_check();},0,0);


