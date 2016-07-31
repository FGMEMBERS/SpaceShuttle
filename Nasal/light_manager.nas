# lighting manager for the Space Shuttle
# Thorsten Renk 2016

var light_manager = {

	red: 0.0,
	green: 0.0,
	blue: 0.0,
	x: 0.0,
	etx: 0.0,
	y: 0.0, 
	z: 0.0,	
	radius: 0.0,
	ambience: 0.0,
	flicker: 0,

	red_tgt: 0.0,
	green_tgt: 0.0,
	blue_tgt: 0.0,
	x_tgt: 0.0,
	y_tgt: 0.0, 
	z_tgt: 0.0,	
	radius_tgt: 0.0,
	ambience_tgt: 0.0,

	set_theme:  func (theme) {

	var light_intensity = getprop("/rendering/scene/diffuse/red");

	var dim = 1.0 - light_intensity;
	#print ("Current dim: ",dim);

	if (theme == "PAD")
		{
		me.red = 0.7 * dim;
		me.green = 0.7 * dim;
		me.blue= 0.7 * dim;
		me.x = 0.0;
		me.etx = 0.0;
		me.y = 0.0;
		me.z = 10.0;
		me.radius = 24.0;
		me.ambience = 0.1;
		me.flicker_stop();
		}
	else if (theme == "SRB")
		{
		me.red = 2.4 * dim;
		me.green = 2.2 * dim;
		me.blue= 1.4 * dim;
		me.x = 10.0;
		me.etx = -10.0;
		me.y = 0.0;
		me.z = -4.0;
		me.radius = 30.0;
		me.ambience = 0.4;
		me.flicker_start();
		}
	else if (theme == "SSME")
		{
		me.red = 0.5 * dim;
		me.green = 0.5 * dim;
		me.blue= 0.5 * dim;
		me.x = 17.0;
		me.etx = -30.0;
		me.y = 0.0;
		me.z = -4.0;
		me.radius = 10.0;
		me.ambience = 0.2;
		me.flicker_stop();
		}
	else if (theme = "CLEAR")
		{
		me.red = 0.0;
		me.green = 0.0;
		me.blue= 0.0;
		me.x = 0.0;
		me.etx = 0.0;
		me.y = 0.0;
		me.z = 0.0;
		me.radius = 0.0;
		me.ambience = 0.0;
		me.flicker_stop();
		}

	me.apply();

	},

	apply: func {

		setprop("/lighting/effects/geo-red", me.red);
		setprop("/lighting/effects/geo-green", me.green);
		setprop("/lighting/effects/geo-blue", me.blue);
		setprop("/lighting/effects/geo-x", me.x);
		setprop("/lighting/effects/geo-y", me.y);
		setprop("/lighting/effects/geo-z", me.z);
		setprop("/lighting/effects/geo-z1", -me.z);
		setprop("/lighting/effects/geo-et-x", me.etx);
		setprop("/lighting/effects/geo-et-y", me.y);
		setprop("/lighting/effects/geo-et-z", me.z);
		setprop("/lighting/effects/geo-et-z1", -me.z);
		setprop("/lighting/effects/geo-r", me.radius);	
		setprop("/lighting/effects/geo-ambience", me.ambience);	
	},

	flicker_start: func {

		me.flicker = 1;
		me.flicker_loop();

	},

	flicker_loop: func {

		if (me.flicker == 0) {return;}
		var rnd = me.radius * 0.025 * (rand() - 0.5);
		setprop("/lighting/effects/geo-r", me.radius + rnd);	

		settimer(func me.flicker_loop(), 0.0);
	},

	flicker_stop: func {
		me.flicker = 0;

	},
	

};



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
