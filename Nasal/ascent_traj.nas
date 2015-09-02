
var update_asc_loop_flag = 0;
var traj_display_flag = 1;

var traj_data = [];

var sym_shuttle_asc = {};
var trajectory = {};

var create_traj_display = func {

var window = canvas.Window.new([400,400],"dialog").set("title", "ASCENT TRAJ");


window.del = func()
{
  update_asc_loop_flag = 0;
  call(canvas.Window.del, [], me);
};



var ascentTrajCanvas = window.createCanvas().set("background", [0,0,0]);

#var ascentTrajCanvas= canvas.new({
#        "name": "STS PASS TRAJ",
#            "size": [400,400], 
#            "view": [400,400],                       
#            "mipmapping": 1     
#            });                          
                          
#ascentTrajCanvas.addPlacement({"node": "DisplayL2"});
#ascentTrajCanvas.setColorBackground(0,0,0, 0);

var root = ascentTrajCanvas.createGroup();



sym_shuttle_asc = ascentTrajCanvas.createGroup();
canvas.parsesvg(sym_shuttle_asc, "/Nasal/canvas/map/Images/boeingAirplane.svg");
sym_shuttle_asc.setScale(0.2);

fill_traj1_data();
trajectory = root.createChild("group");
plot_traj();

update_asc_loop_flag = 1;
ascent_traj_update();


}


var ascent_traj_update = func {

if (update_asc_loop_flag == 0 ) {return;}

var altitude = getprop("/position/altitude-ft");
var latitude = getprop("/position/latitude-deg");
var velocity = getprop("/fdm/jsbsim/velocities/eci-velocity-mag-fps");
var earth_rotation = 1420.0 * math.cos(latitude);

#print(velocity, " ", earth_rotation);

velocity = math.sqrt(math.abs(velocity * velocity - earth_rotation * earth_rotation));

# check transition to next display

if (traj_display_flag == 1)
	{
	if (getprop("/controls/shuttle/SRB-static-model") == 0) # we have separated the SRBs
		{
		fill_traj2_data();
		trajectory.removeAllChildren();
		plot_traj();
		traj_display_flag = 2;
		}
	}

var x = velocity_to_x(velocity, traj_display_flag);
var y = altitude_to_y(altitude, traj_display_flag);

sym_shuttle_asc.setTranslation(x,y);

settimer(ascent_traj_update, 1.0);
}


var velocity_to_x = func (velocity, display) {

if (display == 1)
	{
	return (velocity / 5000.0 * 0.8 + 0.1) * 400.0;
	}
else 
	{
	return ((velocity - 5000.0) / 21000.0 * 0.8 + 0.1) * 400.0;
	}
}

var altitude_to_y = func (altitude, display) {

if (display == 1)
	{
	return 400.0 - (altitude / 170000.0 * 0.6 + 0.2) * 400.0;
	}
else 	
	{
	return 400.0 - ((altitude - 140000.0) / 385000.0 * 0.6 + 0.2) * 400.0;
	}

}


var fill_traj1_data = func {

var point = [];

point = [0.0, 0.0];
append(traj_data, point);

point = [568.0, 3250.0];
append(traj_data, point);

point = [806.0, 6310.0];
append(traj_data, point);

point = [1004.0, 10400.0];
append(traj_data, point);

point = [1182.0, 15400.0];
append(traj_data, point);

point = [1432.0, 25800.0];
append(traj_data, point);

point = [1622.0, 34400.0];
append(traj_data, point);

point = [2041.0, 50600.0];
append(traj_data, point);

point = [2740.0, 75500.0];
append(traj_data, point);

point = [3404.0, 101000.0];
append(traj_data, point);

point = [4050, 130100.0];
append(traj_data, point);

point = [4654.0, 167800.0];
append(traj_data, point);



for (i=0; i< size(traj_data); i=i+1)
	{
	traj_data[i][0] = velocity_to_x(traj_data[i][0], 1);# (traj_data[i][0] / 5000.0 * 0.8 + 0.1) * 400.0;
	traj_data[i][1] = altitude_to_y(traj_data[i][1], 1); #400 - (traj_data[i][1] / 170000.0 * 0.6 + 0.2) * 400.0;
	}

}


var fill_traj2_data = func {

var point = [];
setsize(traj_data,0);


point = [4604.0, 152000.0];
append(traj_data, point);

point = [4866.0, 174000.0];
append(traj_data, point);

point = [5000.0, 206650.0];
append(traj_data, point);

point = [5170.0, 253800.0];
append(traj_data, point);

point = [5512.0, 319100.0];
append(traj_data, point);

point = [6000.0, 372500.0];
append(traj_data, point);

point = [8022.0, 455000.0];
append(traj_data, point);

point = [9072.0, 464700.0];
append(traj_data, point);

point = [12036.0, 455600.0];
append(traj_data, point);

point = [14050.0, 445700.0];
append(traj_data, point);

point = [16000.0, 442300.0];
append(traj_data, point);

point = [18045.0, 436500.0];
append(traj_data, point);

point = [20070.0, 434500.0];
append(traj_data, point);

point = [22000.0, 434400.0];
append(traj_data, point);

point = [24000.0, 433600.0];
append(traj_data, point);

point = [25800.0, 433500.0];
append(traj_data, point);


for (i=0; i< size(traj_data); i=i+1)
	{
	traj_data[i][0] = velocity_to_x(traj_data[i][0], 2);
	traj_data[i][1] = altitude_to_y(traj_data[i][1], 2); 
	}

}

var plot_traj = func {


var plot = trajectory.createChild("path", "data")
                                   .setStrokeLineWidth(2)
                                   .setColor(0.5,0.6,0.5)
                                   .moveTo(traj_data[0][0],traj_data[0][1]); 

		for (var i = 1; i< (size(traj_data)-1); i=i+1)
			{
			var set = traj_data[i+1];
			plot.lineTo(set[0], set[1]);	
			}

}
