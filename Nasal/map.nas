

var sym_shuttle = {};
var sym_landing_site = {};
var sym_EI = {};
var sym_oTgt = {};

var graph = {};
var ecal_graph = {};
var radius = {};
var samples = [];
var history = [];
var ecal_history = [];
var tgt_history = [];
var track_prediction = [];
var EI_location = [];
var EI_flag = 0;

var update_loop_flag = 0;


var sym_shuttle_ecal = {};
var sym_landing_site_ecal = {};

var lat_to_m = 110952.0; # latitude degrees to meters
var m_to_lat = 9.01290648208234e-06; # meters to latitude degrees
var lon_to_m = 0.0; # needs to be calculated dynamically
var m_to_lon = 0.0; # we do this on startup
var GMkm = 398600.0 ;

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



var data = SpaceShuttle.draw_shuttle_top();

	 sym_shuttle_plot = sym_shuttle.createChild("path", "shuttle")
        .setStrokeLineWidth(0.25)
        .setColor(0.0, 0.0, 0.0)
	.moveTo(data[0][0], data[0][1]);

	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		sym_shuttle_plot.lineTo(set[0], set[1]);
		}
sym_shuttle.setScale(5.0);

setsize(data,0);


sym_landing_site = mapCanvas.createGroup();
canvas.parsesvg(sym_landing_site, "/gui/dialogs/images/ndb_symbol.svg");
sym_landing_site.setScale(0.6);

sym_EI = mapCanvas.createGroup();
canvas.parsesvg(sym_EI, "/Nasal/canvas/map/Airbus/Images/airbus_vor.svg");
sym_EI.setScale(0.0);
EI_location = [0,0];

sym_oTgt = mapCanvas.createGroup();

data = SpaceShuttle.draw_circle(3, 10);

sym_oTgt_marker = sym_oTgt.createChild("path", "marker")
        .setStrokeLineWidth(1)
        .setColor(0.0, 0.0, 0.0)
	.moveTo(data[0][0], data[0][1]);

 for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		sym_oTgt_marker.lineTo(set[0], set[1]);
		}


sym_oTgt_label = sym_oTgt.createChild("text")
      	.setText(SpaceShuttle.oTgt.label)
        .setColor(0.0, 0.0, 0.0)
	.setFontSize(14)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom");

sym_oTgt.setVisible(0);

graph = root.createChild("group");
radius = root.createChild("group");



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


if (SpaceShuttle.n_orbital_targets > 0)
	{
	sym_oTgt.setVisible(1);
	var lla = SpaceShuttle.oTgt.get_latlonalt();
	x = lon_to_x(lla[1]);
	y = lat_to_y(lla[0]);
	sym_oTgt.setTranslation(x,y);

	}

var EIpos = EI_update();

x=EIpos[0]-23;
y=EIpos[1]-23;

if (x<0) {x=0;}
if (y<0) {y=0;}

sym_EI.setTranslation(x, y);

if (EI_flag == 1)
	{
	sym_EI.setScale(1.0);
	}
else 
	{
	sym_EI.setScale(0.0);
	}

x = lon_to_x(landing_site.lon()) - 15.0;
y = lat_to_y(landing_site.lat()) - 15.0;

sym_landing_site.setTranslation(x,y);



prediction_update();
plot_tracks();

radius.removeAllChildren();
if (getprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode") > 0)
	{
	plot_radius();
	}

settimer(map_update, 1.0);

}


var plot_radius = func  {

if (size(SpaceShuttle.radius_set) < 2) {return;}

var plot = radius.createChild("path", "data")
                                   .setStrokeLineWidth(2)
                                   .setColor(1,0,0.6,0.6)
                                   .moveTo(SpaceShuttle.radius_set[0][0],SpaceShuttle.radius_set[0][1]); 

		for (var i = 1; i< (size(SpaceShuttle.radius_set)-1); i=i+1)
			{
			var set = SpaceShuttle.radius_set[i+1];
			if (SpaceShuttle.radius_set[i+1][0] > SpaceShuttle.radius_set[i][0])
				{
				plot.lineTo(set[0], set[1]);
				}
			else
				{
				plot.moveTo(set[0], set[1]);
				}
			}

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

if (SpaceShuttle.n_orbital_targets > 0)
	{
	var tplot = graph.createChild("path", "data")
                                   .setStrokeLineWidth(1)
                                   .setColor(0,0,1)
                                   .moveTo(tgt_history[0][0],tgt_history[0][1]); 

		

		for (var i = 1; i< (size(tgt_history)-1); i=i+1)
			{
			var set = tgt_history[i+1];
			if (prograde_flag * tgt_history[i+1][0] > prograde_flag * tgt_history[i][0])
				{
				plot.lineTo(set[0], set[1]);
				}
			else
				{
				plot.moveTo(set[0], set[1]);
				}
			}


	}


var pred_plot = graph.createChild("path", "data")
                                   .setStrokeLineWidth(2)
                                   .setColor(1,0,0)
                                   .moveTo(track_prediction[0][0],track_prediction[0][1]); 

		

		var guidance_mode = getprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode");
		var draw_flag = 0;
		

		for (var i = 0; i< (size(track_prediction)-1); i=i+1)
			{
			var set = track_prediction[i+1];
			if (prograde_flag * track_prediction[i+1][0] > prograde_flag * track_prediction[i][0])
				{
				if ((guidance_mode == 0) or (guidance_mode ==1))
					{
					pred_plot.lineTo(set[0], set[1]);
					}
				else if ((guidance_mode == 2) and (set[2] < 0))
					{
					if (draw_flag == 0)
						{
						pred_plot.lineTo(set[0], set[1]);
						draw_flag = 1;
						}
					else
						{
						pred_plot.moveTo(set[0], set[1]);
						draw_flag = 0;
						}
					}
				else
					{
					pred_plot.lineTo(set[0], set[1]);
					}
					
				
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

var x1 = ecal_lon_to_x (lon);
var y1 = ecal_lat_to_y (lat);

for (var i = 0; i < 350; i = i+1)
	{
	var set = [x,y];
	append(history,set);

	}

for (var i = 0; i< 150; i=i+1)
	{
	var set1 = [x1, y1];
	append(ecal_history, set1);
	}

history_update();
ecal_history_update();

}


var tgt_history_init = func {


var lla = SpaceShuttle.oTgt.get_latlonalt();
var lat = lla[0];
var lon = lla[1];
var x =  lon_to_x(lon);
var y =  lat_to_y(lat);

for (var i = 0; i < 250; i = i+1)
	{
	var set = [x,y];
	append(tgt_history,set);
	}


}

var history_update = func {

history = delete_from_vector(history,0);


var lat = getprop("/position/latitude-deg");
var lon = getprop("/position/longitude-deg");
var x =  lon_to_x(lon);
var y =  lat_to_y(lat);

append(history, [x,y]);

if (SpaceShuttle.n_orbital_targets > 0)
	{
	tgt_history = delete_from_vector(tgt_history,0);

	var lla = SpaceShuttle.oTgt.get_latlonalt();
	lat = lla[0];
	lon = lla[1];
	x =  lon_to_x(lon);
	y =  lat_to_y(lat);

	append(tgt_history, [x,y]);
	}

settimer(history_update, 30.0);
}

var ecal_history_update = func {

var mm = getprop("/fdm/jsbsim/systems/dps/major-mode");

#print ("MM: ", mm);

if ((mm == 101) or (mm == 102) or (mm == 103) or (mm == 601) or (mm == 602))
	{
	ecal_history = delete_from_vector(ecal_history,0);

	var lat = getprop("/position/latitude-deg");
	var lon = getprop("/position/longitude-deg");



	var x = ecal_lon_to_x (lon);
	var y = ecal_lat_to_y (lat);

	append(ecal_history, [x, y]);

	#print ("Loop running");
	}
else
	{
	return;
	}

settimer(ecal_history_update, 10.0);
}


var EI_update = func {

var periapsis = getprop("/fdm/jsbsim/systems/orbital/periapsis-km");

if (periapsis > 121.0) {EI_flag = 0; return [0.0,0.0];}

var apoapsis = getprop("/fdm/jsbsim/systems/orbital/apoapsis-km");

if (apoapsis < 121.0) {EI_flag = 0; return [0.0, 0.0];}

var shuttleWCoord = geo.aircraft_position() ;
var shuttleCoord = geo.Coord.new() ;

#print(shuttleCoord.x(), " ",shuttleCoord.y(), " ", shuttleCoord.z());

var x = getprop("/fdm/jsbsim/position/eci-x-ft") * 0.3048;
var y = getprop("/fdm/jsbsim/position/eci-y-ft") * 0.3048;
var z = getprop("/fdm/jsbsim/position/eci-z-ft") * 0.3048;

shuttleCoord.set_xyz(x,y,z);

var D_lon = shuttleWCoord.lon() - shuttleCoord.lon();


var vxoffset = 0.0; #3.5 * math.cos(shuttleCoord.lon() * 3.1415/180.0);
var vyoffset = 0.0; #3.5 * math.sin(shuttleCoord.lon() * 3.1415/180.0);
var vzoffset = 0.0;

var shuttleState = SpaceShuttle.stateVector.new (shuttleCoord.x(),shuttleCoord.y(),shuttleCoord.z(),0,0,0,0,0,0);
shuttleState.vx = getprop("/fdm/jsbsim/velocities/eci-x-fps") * ft_to_m + vxoffset;
shuttleState.vy = getprop("/fdm/jsbsim/velocities/eci-y-fps") * ft_to_m + vyoffset;
shuttleState.vz = getprop("/fdm/jsbsim/velocities/eci-z-fps") * ft_to_m + vzoffset;

var dt = 2.0;
var delta_lon = 0.0;

#print(getprop("/sim/time/elapsed-sec"), " ", getprop("/position/altitude-ft") * 0.3048 * 0.001); 

var altitude = shuttleCoord.alt() * 0.3048 * 0.001;

for (i=0; i < 1000.0; i=i+1)
	{

	var G = [shuttleState.x, shuttleState.y, shuttleState.z]; 
	var Gnorm = math.sqrt(math.pow(G[0],2.0) + math.pow(G[1],2.0) + math.pow(G[2],2.0));
	var R = Gnorm;

	var g = GMkm/math.pow(R/1000.0, 2.0) * 1000.0 * 0.999;
	#print ("g: ", g);

	G[0] = -G[0]/Gnorm * g;
	G[1] = -G[1]/Gnorm * g;
	G[2] = -G[2]/Gnorm * g;

	shuttleState.update(G[0], G[1], G[2], 0.0,0.0,0.0, dt);

	# now compensate for the numerical error of a large time resolution
	var O = [shuttleState.x, shuttleState.y, shuttleState.z];
	var vmag = math.sqrt(math.pow(shuttleState.vx,2.0) + math.pow(shuttleState.vy,2.0) + math.pow(shuttleState.vz,2.0));
	var d = vmag * dt;
	O[0] = O[0] * d*d/(2.0*R*R); 
	O[1] = O[1] * d*d/(2.0*R*R); 
	O[2] = O[2] * d*d/(2.0*R*R); 

	shuttleState.x = shuttleState.x - O[0];
	shuttleState.y = shuttleState.y - O[1];
	shuttleState.z = shuttleState.z - O[2];

	#delta_lon = delta_lon + dt * SpaceShuttle.earth_rotation_deg_s * 1.004;
	shuttleCoord.set_xyz(shuttleState.x, shuttleState.y, shuttleState.z);
	#shuttleCoord.set_lon(shuttleCoord.lon() - delta_lon);

	#print(i, " ",shuttleCoord.alt() * 0.001 );
	

	if (shuttleCoord.alt() * 0.001 < 121.0)
		{
		EI_flag = 1;
		#print(shuttleCoord.lon(), " ", shuttleWCoord.lon(), " ", D_lon);
		return [lon_to_x(shuttleCoord.lon() + D_lon) , lat_to_y(shuttleCoord.lat())];
		} 
	}

print ("No EI solution found!");

return [0.0,0.0];

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

var arg = (2.0 * altitude - (apoapsis + periapsis)) / (apoapsis - periapsis);
if (arg > 1.0) {arg = 1.0;}
if (arg < -1.0) {arg = -1.0;}

var theta = math.asin (arg);




var dt =  120.0;
var offset = 0.0;

var increment = 2.0 * math.pi * dt/orbital_period;


EI_flag = 0;

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
	# except when we're flying a TAL and need to know the extrapolated trajectory

	var guidance_mode = getprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode");
	var guidance_flag = 1;

	if (guidance_mode == 2) {guidance_flag = 0;}

	if ((alt < 0.0) and (guidance_flag == 1))
		{break;}
	else if ((pred_lon > lon + 120.0) and (guidance_flag == 0))
		{break;}

	append(track_prediction, [x,y, alt]);


	}

}


settimer(history_init,1.0);

##############################################################
# map of ECAL sites
##############################################################

var ecal_update_loop_flag = 0;


var ecal_lat_to_y = func (lat) {


return 512.0 -  (lat - 22.0) /33.0 * 512.0 + 10.0;

}

var ecal_lon_to_x = func (lon) {

return (lon + 83.0)/33.4 * 512 + 25.0;

}


var create_ecal_map = func {

var window = canvas.Window.new([512,512],"dialog").set("title", "ECAL Site Map");

# we need to explicitly re-define this to get a handle to stop the update loop
# upon closing the window

window.del = func()
{
  #print("Cleaning up...\n");
  ecal_update_loop_flag = 0;
  call(canvas.Window.del, [], me);
};


var mapCanvas = window.createCanvas().set("background", canvas.style.getColor("bg_color"));

var root = mapCanvas.createGroup();


var path = "Aircraft/SpaceShuttle/Dialogs/ECAL_Sites.png";
var child=root.createChild("image")
                                   .setFile( path )
                                   .setTranslation(0,0)
                                   .setSize(512,512);
sym_shuttle_ecal = mapCanvas.createGroup();


sym_landing_site_ecal = mapCanvas.createGroup();
canvas.parsesvg(sym_landing_site_ecal, "/gui/dialogs/images/ndb_symbol.svg");
sym_landing_site_ecal.setScale(0.6);
sym_landing_site_ecal.setColor(1,0,0);

ecal_graph = root.createChild("group");


var data = SpaceShuttle.draw_shuttle_top();

	 sym_shuttle_plot = sym_shuttle_ecal.createChild("path", "shuttle")
        .setStrokeLineWidth(0.25)
        .setColor(1.0, 1.0, 1.0)
	.moveTo(data[0][0], data[0][1]);

	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		sym_shuttle_plot.lineTo(set[0], set[1]);
		}
sym_shuttle_ecal.setScale(5.0);

ecal_update_loop_flag = 1;
ecal_map_update();

}

var ecal_map_update = func {

if (ecal_update_loop_flag == 0) {return;}

var ops = getprop("/fdm/jsbsim/systems/dps/ops");

if ((ops == 2) or (ops == 3)) {return;}

var lat = getprop("/position/latitude-deg");
var lon = getprop("/position/longitude-deg");


var x =  ecal_lon_to_x(lon);
var y =  ecal_lat_to_y(lat);


var heading = getprop("/orientation/heading-deg") * 3.1415/180.0;

#print (x,y);

sym_shuttle_ecal.setTranslation(x,y);
sym_shuttle_ecal.setRotation(heading);


x = ecal_lon_to_x(landing_site.lon()) - 15.0;
y = ecal_lat_to_y(landing_site.lat()) - 15.0;

sym_landing_site_ecal.setTranslation(x,y);

ecal_graph.removeAllChildren();



var plot = ecal_graph.createChild("path", "data")
                                   .setStrokeLineWidth(2)
                                   .setColor(1,0,0)
                                   .moveTo(ecal_history[0][0],ecal_history[0][1]); 

		
for (var i = 1; i< (size(ecal_history)-1); i=i+1)
	{
	var set = ecal_history[i+1];
	plot.lineTo(set[0], set[1]);
				
	}


settimer (ecal_map_update, 1.0);

}
