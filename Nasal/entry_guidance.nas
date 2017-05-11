# entry guidance computer for the Space Shuttle

var landing_site = geo.Coord.new();
landing_site.index = 0;
landing_site.rwy_pri = "";
landing_site.rwy_sec = "";
landing_site.tacan = "";
landing_site.rwy_sel = 0;

var entry_guidance_available = 0;

var entry_interface = geo.Coord.new();
var distance_last = 0.0;

var radius_set = [];

var trailer_set = {

	entry: [[0,0], [0,0], [0,0], [0,0], [0,0]],
	timer: 0,
	time_limit: 30,
	
	update: func (distance) {

	if (me.timer == 0)
		{
		me.timer = me.timer + 1;
		me.create_entry(distance);
		}
	else
		{me.timer = me.timer + 1;}
	if (me.timer == me.time_limit) {me.timer = 0;}


	},

	create_entry: func (distance) {

	var velocity = getprop("/fdm/jsbsim/velocities/eci-velocity-mag-fps");	

	me.entry[4][0] = me.entry[3][0];
	me.entry[4][1] = me.entry[3][1];

	me.entry[3][0] = me.entry[2][0];
	me.entry[3][1] = me.entry[2][1];

	me.entry[2][0] = me.entry[1][0];
	me.entry[2][1] = me.entry[1][1];

	me.entry[1][0] = me.entry[0][0];
	me.entry[1][1] = me.entry[0][1];

	me.entry[0][0] = distance;
	me.entry[0][1] = velocity;
	},

};

# this is Vandenberg  we update later upon selection

landing_site.set_latlon(34.722, -120.567);


var update_entry_guidance =  func {

var pos = geo.aircraft_position();
var mm = getprop("/fdm/jsbsim/systems/dps/major-mode");

var course = pos.course_to(landing_site);
var v_eci = getprop("/fdm/jsbsim/velocities/eci-velocity-mag-fps");
var distance = pos.distance_to(landing_site);

var v_rel_fps = (distance - distance_last) /0.3048;
setprop("/fdm/jsbsim/systems/entry_guidance/vrel-fps", v_rel_fps);
if (v_rel_fps > 0.0)
	{
	setprop("/fdm/jsbsim/systems/entry_guidance/vrel-sign", 1);
	}
else
	{
	setprop("/fdm/jsbsim/systems/entry_guidance/vrel-sign", -1);
	}

distance_last = distance;

distance = distance/ 1853.0;


setprop("/fdm/jsbsim/systems/entry_guidance/target-azimuth-deg", course);
setprop("/fdm/jsbsim/systems/entry_guidance/remaining-distance-nm", distance);


if (mm == 304)
	{
	var v_error = SpaceShuttle.get_entry_drag_deviation(v_eci, distance);
	setprop("/fdm/jsbsim/systems/entry_guidance/v-error-fps", v_error);

	trailer_set.update(distance);
	roll_reversal_management();

	# cease banking and alpha management in the transition to TAEM

	if (distance < 95.0)
		{
		if (getprop("/fdm/jsbsim/systems/ap/entry/taem-transit-init") ==0)
			{
			print("Preparing transition to TAEM guidance!");
			setprop("/fdm/jsbsim/systems/ap/entry/taem-transit-init",1);
			}
		}
	}
}


# manage roll reversals #################################################

var roll_reversal_management = func {

var current_bank = getprop("/orientation/roll-deg");
var roll_direction = getprop("/fdm/jsbsim/systems/ap/entry/roll-sign");

# if a roll reversal is on, we need to check whether to end it

if (getprop("/fdm/jsbsim/systems/ap/entry/roll-reversal-init") == 1)
	{
	var commanded_bank = getprop("/fdm/jsbsim/systems/ap/entry/reversal-bank-angle-target-deg");

	if (math.abs(current_bank - commanded_bank) < 5.0)
		{

		roll_direction = - roll_direction;
		setprop("/fdm/jsbsim/systems/ap/entry/roll-sign", roll_direction);
		setprop("/fdm/jsbsim/systems/ap/entry/roll-reversal-init", 0);
		print("Ending roll reversal!");
		return;
		}

	}


var delta_az = getprop("/fdm/jsbsim/systems/entry_guidance/delta-azimuth-deg");
if (math.abs(delta_az) < 10.0) {return;}

var drag_bank = getprop("/fdm/jsbsim/systems/ap/entry/drag-bank-angle-target-deg");

if (getprop("/fdm/jsbsim/systems/ap/entry/roll-reversal-init") == 0)
{
if (((delta_az > 10.0) and (roll_direction == 1)) or ((delta_az < -10.0) and (roll_direction == -1)))
	{
	setprop("/fdm/jsbsim/systems/ap/entry/reversal-bank-angle-target-deg", -current_bank);
	print("Initiating roll reversal!");
	setprop("/fdm/jsbsim/systems/ap/entry/roll-reversal-init", 1);
	}
}


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
	SpaceShuttle.init_rtls();
	}

entry_guidance_available = 1;

# usually we would compute a TAEM guidance target at TAEM interface, but if the Shuttle is
# initialized at TAEM interface, no target is selected yet, so if distance to site is
# within TAEM range, we compute it now

if ((distance < 100.0) and (mode_string != "RTLS")){SpaceShuttle.compute_TAEM_guidance_targets();}


}



