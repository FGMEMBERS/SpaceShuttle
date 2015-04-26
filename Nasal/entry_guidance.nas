# entry guidance computer for the Space Shuttle

var landing_site = geo.Coord.new();
var v_aero_last = 0.0;
var v_aero = 0.0;


# this is Vandenberg for testing purposes, we update later

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
