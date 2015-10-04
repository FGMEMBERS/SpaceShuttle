# entry guidance computer for the Space Shuttle

var landing_site = geo.Coord.new();
var entry_interface = geo.Coord.new();
var v_aero_last = 0.0;
var v_aero = 0.0;
var distance_last = 0.0;

var radius_set = [];


# this is Vandenberg  we update later upon selection

landing_site.set_latlon(34.722, -120.567);


var update_entry_guidance =  func {

var pos = geo.aircraft_position();

var course = pos.course_to(landing_site);
var distance = pos.distance_to(landing_site);

var v_rel_fps = (distance - distance_last) /0.3048;
setprop("/fdm/jsbsim/systems/entry_guidance/vrel-fps", v_rel_fps);
distance_last = distance;

distance = distance/ 1853.0;

setprop("/fdm/jsbsim/systems/entry_guidance/target-azimuth-deg", course);
setprop("/fdm/jsbsim/systems/entry_guidance/remaining-distance-nm", distance);

v_aero = getprop("/fdm/jsbsim/systems/entry_guidance/ground-relative-velocity-fps");

var a_aero = (v_aero_last - v_aero) * 0.3048 / 9.81;

setprop("/fdm/jsbsim/systems/entry_guidance/current-deceleration-g", a_aero);

v_aero_last = v_aero;

}


var create_radius_set = func {

var base = geo.Coord.new();
var dist = getprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/EI-radius") * 1853.0;
var point = [];

var npoints = 20;

var course = 330;
var step = (course -180.0)/(npoints-1);

for (var i = 0; i< npoints; i=i+1)
	{
	base.set_xyz(landing_site.x(), landing_site.y(), landing_site.z());
	base.apply_course_distance(course - i*step, dist);
	point = [SpaceShuttle.lon_to_x(base.lon()), SpaceShuttle.lat_to_y(base.lat())];
	append(radius_set, point);
	}


}

var compute_entry_guidance_target = func {

var pos = geo.aircraft_position();

var distance = pos.distance_to(landing_site)/ 1853.0;
var course = pos.course_to(landing_site);

setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-dist", 0.0);


# now we compute the desired entry interface
# make that 4100 miles to site

setsize(radius_set, 0);
create_radius_set();

setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-dist", distance);
setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-string", "active");


var mode_string = getprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/entry-mode");

if (mode_string == "normal")
	{
	setprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode",1);
	}
else if (mode_string == "TAL")
	{
	setprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode",2);
	}
else if (mode_string == "RTLS")
	{
	setprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode",3);
	setprop("/controls/shuttle/hud-mode",2);
	}

# usually we would compute a TAEM guidance target at TAEM interface, but if the Shuttle is
# initialized at TAEM interface, no target is selected yet, so if distance to site is
# within TAEM range, we compute it now

if (distance < 100.0) {SpaceShuttle.compute_TAEM_guidance_targets();}


}
