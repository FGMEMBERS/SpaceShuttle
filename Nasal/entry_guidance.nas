# entry guidance computer for the Space Shuttle

var landing_site = geo.Coord.new();
var v_aero_last = 0.0;
var v_aero = 0.0;


# this is Vandenberg  we update later upon selection

landing_site.set_latlon(34.722, -120.567);


var update_entry_guidance =  func {

var pos = geo.aircraft_position();

var course = pos.course_to(landing_site);
var distance = pos.distance_to(landing_site);

distance = distance/ 1853.0;

setprop("/fdm/jsbsim/systems/entry_guidance/target-azimuth-deg", course);
setprop("/fdm/jsbsim/systems/entry_guidance/remaining-distance-nm", distance);

v_aero = getprop("/fdm/jsbsim/systems/entry_guidance/ground-relative-velocity-fps");

var a_aero = (v_aero_last - v_aero) * 0.3048 / 9.81;

setprop("/fdm/jsbsim/systems/entry_guidance/current-deceleration-g", a_aero);

v_aero_last = v_aero;

}


var compute_entry_guidance_target = func {

var pos = geo.aircraft_position();

var distance = pos.distance_to(landing_site)/ 1853.0;
var course = pos.course_to(landing_site);


var flag = 0;

if ((distance < 3000.0) or (distance > 6000.0))
	{
	flag = 1;
	}
if (abs(course - getprop("/fdm/jsbsim/systems/entry_guidance/groundtrack-course-deg")) > 20.0)
	{
	flag = 1;
	}
if (flag == 1)
	{
	setprop("/sim/messages/copilot", "No de-orbit solution to site.");
	return;
	}


setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-dist", distance);
setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-string", "active");
setprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode",1);


}
