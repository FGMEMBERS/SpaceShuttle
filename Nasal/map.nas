

var sym_shuttle = {};
var sym_landing_site = {};
var graph = {};
var samples = [];
var history = [];
var track_prediction = [];

var update_loop_flag = 0;


var lat_to_m = 110952.0; # latitude degrees to meters
var m_to_lat = 9.01290648208234e-06; # meters to latitude degrees
var lon_to_m = 0.0; # needs to be calculated dynamically
var m_to_lon = 0.0; # we do this on startup


var delete_from_vector = func(vec, index) {

var n = index+1;

var vec_end = subvec(vec, n);

setsize(vec, n-1);
return vec~vec_end;	
}

var calc_geo = func(lat) {

lon_to_m  = math.cos(lat*math.pi/180.0) * lat_to_m;
m_to_lon = 1.0/lon_to_m;
}


var lat_to_y = func (lat) {

return 200.0 - lat /90. * 200.0;

}

var lon_to_x = func (lon) {

return 400.0 + lon /180. * 400.0;

}

var create_map = func {

var window = canvas.Window.new([800,400],"dialog").set("title", "Trajectory Map");

# we need to explicitly re-define this to get a handle to stop the update loop
# upon closing the window

window.del = func()
{
  #print("Cleaning up...\n");
  update_loop_flag = 0;
  call(canvas.Window.del, [], me);
};


var mapCanvas = window.createCanvas().set("background", canvas.style.getColor("bg_color"));

var root = mapCanvas.createGroup();


var path = "Aircraft/SpaceShuttle/Dialogs/MapOfEarth.png";
var child=root.createChild("image")
                                   .setFile( path )
                                   .setTranslation(0,0)
                                   .setSize(800,400);
sym_shuttle = mapCanvas.createGroup();
canvas.parsesvg(sym_shuttle, "/Nasal/canvas/map/Images/boeingAirplane.svg");
sym_shuttle.setScale(0.2);

sym_landing_site = mapCanvas.createGroup();
canvas.parsesvg(sym_landing_site, "/gui/dialogs/images/ndb_symbol.svg");
sym_landing_site.setScale(0.6);

graph = root.createChild("group");



update_loop_flag = 1;
map_update();


}


var map_update = func {

if (update_loop_flag == 0 ) {return;}

var lat = getprop("/position/latitude-deg");
var lon = getprop("/position/longitude-deg");

var x =  lon_to_x(lon);
var y =  lat_to_y(lat);


var heading = getprop("/orientation/heading-deg") * 3.1415/180.0;

sym_shuttle.setTranslation(x,y);
sym_shuttle.setRotation(heading);

x = lon_to_x(landing_site.lon()) - 10.0;
y = lat_to_y(landing_site.lat()) - 10.0;

sym_landing_site.setTranslation(x,y);


prediction_update();
plot_tracks();

settimer(map_update, 1.0);

}


var plot_tracks = func  {


graph.removeAllChildren();

var prograde_flag = 1; 

if (getprop("/fdm/jsbsim/velocities/v-east-fps") <0.0)
	{
	prograde_flag = -1;
	}




var plot = graph.createChild("path", "data")
                                   .setStrokeLineWidth(2)
                                   .setColor(0,0,1)
                                   .moveTo(history[0][0],history[0][1]); 

		

		for (var i = 1; i< (size(history)-1); i=i+1)
			{
			var set = history[i+1];
			if (prograde_flag * history[i+1][0] > prograde_flag * history[i][0])
				{
				plot.lineTo(set[0], set[1]);
				}
			else
				{
				plot.moveTo(set[0], set[1]);
				}
			}


var pred_plot = graph.createChild("path", "data")
                                   .setStrokeLineWidth(2)
                                   .setColor(1,0,0)
                                   .moveTo(track_prediction[0][0],track_prediction[0][1]); 

		

		for (var i = 0; i< (size(track_prediction)-1); i=i+1)
			{
			var set = track_prediction[i+1];
			if (prograde_flag * track_prediction[i+1][0] > prograde_flag * track_prediction[i][0])
				{
				pred_plot.lineTo(set[0], set[1]);
				}
			else
				{
				pred_plot.moveTo(set[0], set[1]);
				}
			}

}



var history_init = func {

var lat = getprop("/position/latitude-deg");
var lon = getprop("/position/longitude-deg");
var x =  lon_to_x(lon);
var y =  lat_to_y(lat);

for (var i = 0; i < 1000; i = i+1)
	{
	var set = [x,y];
	append(history,set);
	}
history_update();

}

var history_update = func {

history = delete_from_vector(history,0);

var lat = getprop("/position/latitude-deg");
var lon = getprop("/position/longitude-deg");
var x =  lon_to_x(lon);
var y =  lat_to_y(lat);

append(history, [x,y]);

settimer(history_update, 10.0);
}



var prediction_update = func {

setsize(track_prediction,0);

var earth_motion_degs = 0.00416666666;
var lat = getprop("/position/latitude-deg");
var lon = getprop("/position/longitude-deg");

calc_geo(lat);


var orbiter_motion_north_fps = getprop("/fdm/jsbsim/velocities/v-north-fps");

var orbital_speed_fps = getprop("/fdm/jsbsim/velocities/eci-velocity-mag-fps");
var orbital_period = getprop("/fdm/jsbsim/systems/orbital/orbital-period-s");


# check position of the ascending node

var rising_flag = 0.0;
if (orbiter_motion_north_fps > 0.0) {rising_flag = 1;}
else {rising_flag = -1.0};

# check whether the orbiter rises to apogee or descends to perigee

var upward_flag = 0.0;
if (getprop("/fdm/jsbsim/velocities/v-down-fps") < 0.0) {upward_flag = 1.0;}
else {upward_flag = -1.0;}

# check whether the orbiter is in a prograde or retrograde orbit

var prograde_flag = 0.0;
if (getprop("/fdm/jsbsim/velocities/v-east-fps") > 0.0) {prograde_flag = 1.0;}
else {prograde_flag = -1.0;}

#rising_flag = rising_flag * prograde_flag;

var inclination = getprop("/fdm/jsbsim/systems/orbital/inclination-deg");
var inclination_rad = inclination * math.pi/180.0; 

var sinphi = (lat/ inclination);

if (prograde_flag == -1)
	{sinphi = lat/(inclination-90);}

sinphi = math.min(sinphi, 1.0);
sinphi = math.max(sinphi,-1.0);

var phi = math.asin(sinphi);

if (rising_flag == -1) {phi = math.pi - phi;}



var lon_rising = lon - phi * 180.0/math.pi;
if (lon_rising < 0.0) {lon_rising = lon_rising + 360.0;}


var apoapsis = getprop("/fdm/jsbsim/systems/orbital/apoapsis-km");
var periapsis = getprop("/fdm/jsbsim/systems/orbital/periapsis-km");
var altitude = getprop("/position/altitude-ft") * 0.3048 * 0.001;

var theta = math.asin ((2.0 * altitude - (apoapsis + periapsis)) / (apoapsis - periapsis));




var dt =  120.0;
var offset = 0.0;

var increment = 2.0 * math.pi * dt/orbital_period;




for (var i = 0; i<40; i = i+1)
	{
	var arg = phi + i * increment;

	var pred_lat = math.asin(math.sin(arg) * math.sin(inclination_rad));
	var pred_lon = math.atan2(math.cos(inclination_rad) * math.sin(arg), math.cos(arg));
	
	pred_lat = pred_lat * 180.0/math.pi;
	pred_lon = pred_lon * 180.0/math.pi;

	pred_lon = pred_lon + lon_rising - earth_motion_degs * i * dt;

	if (i==0)	
		{
		offset = lon - pred_lon;
		}
	pred_lon = pred_lon + offset;

	if (pred_lon > 180) {pred_lon = pred_lon - 360;}
	if (pred_lon < -180) {pred_lon = pred_lon + 360.0;}

	var alt = 0.5 * (apoapsis + periapsis) + 0.5 * (apoapsis - periapsis) * math.sin(theta + i * increment);
	



	var x =  lon_to_x(pred_lon);
	var y =  lat_to_y(pred_lat);

	# do not write any values if predicted altitude is below ground

	#print(i, " ", i_alt);
	#print(x, " ", y);

	if (alt < 0.0) 
		{break;}

	append(track_prediction, [x,y]);


	}

}


history_init();

