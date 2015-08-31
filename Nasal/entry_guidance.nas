# entry guidance computer for the Space Shuttle

var landing_site = geo.Coord.new();
var entry_interface = geo.Coord.new();
var v_aero_last = 0.0;
var v_aero = 0.0;

var radius_set = [];


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


var create_radius_set = func {

var base = geo.Coord.new();
var dist = 4100.0 * 1853.0;
var point = [];

base.set_xyz(landing_site.x(), landing_site.y(), landing_site.z());
base.apply_course_distance(330.0, dist);
point = [SpaceShuttle.lon_to_x(base.lon()), SpaceShuttle.lat_to_y(base.lat())];
append(radius_set, point);
#print(point[0], " ", point[1]);

base.set_xyz(landing_site.x(), landing_site.y(), landing_site.z());
base.apply_course_distance(310.0, dist);
point = [SpaceShuttle.lon_to_x(base.lon()), SpaceShuttle.lat_to_y(base.lat())];
append(radius_set, point);
#print(point[0], " ", point[1]);

base.set_xyz(landing_site.x(), landing_site.y(), landing_site.z());
base.apply_course_distance(290.0, dist);
point = [SpaceShuttle.lon_to_x(base.lon()), SpaceShuttle.lat_to_y(base.lat())];
append(radius_set, point);
#print(point[0], " ", point[1]);

base.set_xyz(landing_site.x(), landing_site.y(), landing_site.z());
base.apply_course_distance(270.0, dist);
point = [SpaceShuttle.lon_to_x(base.lon()), SpaceShuttle.lat_to_y(base.lat())];
append(radius_set, point);
#print(point[0], " ", point[1]);

base.set_xyz(landing_site.x(), landing_site.y(), landing_site.z());
base.apply_course_distance(250.0, dist);
point = [SpaceShuttle.lon_to_x(base.lon()), SpaceShuttle.lat_to_y(base.lat())];
append(radius_set, point);
#print(point[0], " ", point[1]);

base.set_xyz(landing_site.x(), landing_site.y(), landing_site.z());
base.apply_course_distance(230.0, dist);
point = [SpaceShuttle.lon_to_x(base.lon()), SpaceShuttle.lat_to_y(base.lat())];
append(radius_set, point);
#print(point[0], " ", point[1]);

base.set_xyz(landing_site.x(), landing_site.y(), landing_site.z());
base.apply_course_distance(210.0, dist);
point = [SpaceShuttle.lon_to_x(base.lon()), SpaceShuttle.lat_to_y(base.lat())];
append(radius_set, point);
#print(point[0], " ", point[1]);

base.set_xyz(landing_site.x(), landing_site.y(), landing_site.z());
base.apply_course_distance(190.0, dist);
point = [SpaceShuttle.lon_to_x(base.lon()), SpaceShuttle.lat_to_y(base.lat())];
append(radius_set, point);
#print(point[0], " ", point[1]);
}

var compute_entry_guidance_target = func {

var pos = geo.aircraft_position();

var distance = pos.distance_to(landing_site)/ 1853.0;
var course = pos.course_to(landing_site);


var flag = 0;

#if ((distance < 2000.0) or (distance > 6000.0))
#	{flag = 1;}
#if (abs(course - getprop("/fdm/jsbsim/systems/entry_guidance/groundtrack-course-deg")) > 20.0)
#	{flag = 1;}

if (flag == 1)
	{
	setprop("/sim/messages/copilot", "No de-orbit solution to site.");
	return;
	}

# now we compute the desired entry interface
# make that 4100 miles to site

setsize(radius_set, 0);
create_radius_set();

setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-dist", distance);
setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-string", "active");
setprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode",1);


}
