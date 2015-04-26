

var sym_shuttle = {};
var sym_landing_site = {};
var graph = {};
var samples = [];
var history = [];

var update_loop_flag = 0;


var delete_from_vector = func(vec, index) {

var n = index+1;

var vec_end = subvec(vec, n);

setsize(vec, n-1);
return vec~vec_end;
	
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



var plot = graph.createChild("path", "data")
                                   .setStrokeLineWidth(2)
                                   .setColor(0,0,1)
                                   .moveTo(history[0][0],history[0][1]); 

		

		for (var i = 1; i< (size(history)-1); i=i+1)
			{
			var set = history[i+1];
			if (history[i+1][0] > history[i][0])
				{
				plot.lineTo(set[0], set[1]);
				}
			else
				{
				plot.moveTo(set[0], set[1]);
				}
			}


settimer(map_update, 1.0);

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


history_init();
