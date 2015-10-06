
var update_vtraj_loop_flag = 0;
var traj_display_flag = 1;

var vertical_display_size = 512;
var horizontal_display_size = 512;

var traj_data = [];
var limit1_data = [];
var limit2_data = [];

var sym_shuttle_asc = {};
var trajectory = {};




var create_traj_display = func {

var window = canvas.Window.new([horizontal_display_size,vertical_display_size],"dialog").set("title", "Vertical Trajectory");


window.del = func()
{
  update_vtraj_loop_flag = 0;
  call(canvas.Window.del, [], me);
};



var ascentTrajCanvas = window.createCanvas().set("background", [0,0,0]);
                          


var root = ascentTrajCanvas.createGroup();



sym_shuttle_asc = ascentTrajCanvas.createGroup();
canvas.parsesvg(sym_shuttle_asc, "/Nasal/canvas/map/Images/boeingAirplane.svg");
sym_shuttle_asc.setScale(0.2);

if (traj_display_flag == 1)
	{ fill_traj1_data();}
else if (traj_display_flag == 3)
	{ fill_entry1_data();}



trajectory = root.createChild("group");
plot_traj (trajectory);

update_vtraj_loop_flag = 1;
ascent_traj_update();


}


var ascent_traj_update = func {

if (update_vtraj_loop_flag == 0 ) {return;}

ascent_traj_process (trajectory, sym_shuttle_asc);

settimer(ascent_traj_update, 1.0);
}




var ascent_traj_update_set = func {

var velocity = getprop("/fdm/jsbsim/velocities/eci-velocity-mag-fps");

if (traj_display_flag == 1)
	{
	if (getprop("/controls/shuttle/SRB-static-model") == 0) # we have separated the SRBs
		{
		fill_traj2_data();
		traj_display_flag = 2;
		}
	}
if (traj_display_flag == 2)
	{
	if (getprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode") > 0) # we're preparing for de-orbit
		{
		fill_entry1_data();
		traj_display_flag = 3;
		}

	}
if (traj_display_flag == 3)
	{
	if (velocity < 18500.0)
		{
		fill_entry2_data();
		traj_display_flag = 4;
		}
	}

if (traj_display_flag == 4)
	{
	if (velocity < 15800.0)
		{
		fill_entry3_data();
		traj_display_flag = 5;
		}
	}

if (traj_display_flag == 5)
	{
	if (velocity < 12000.0)
		{
		fill_entry4_data();
		traj_display_flag = 6;
		}
	}

if (traj_display_flag == 6)
	{
	if (velocity < 5500.0)
		{
		fill_entry5_data();
		traj_display_flag = 7;
		}
	}

var range = getprop("/fdm/jsbsim/systems/taem-guidance/distance-to-runway-nm");


if (traj_display_flag == 8) 
	{
	if ((range > 0.0) and (range <20.0))
		{
		fill_vert_sit2_nom_data();
		fill_vert_sit2_SB_data();
		fill_vert_sit2_maxLD_data();
		traj_display_flag = 9;
		}
	}

}

var ascent_traj_update_velocity = func {

var latitude = getprop("/position/latitude-deg");
var velocity = getprop("/fdm/jsbsim/velocities/eci-velocity-mag-fps");
var earth_rotation = 1420.0 * math.cos(latitude);
#var range = getprop("/fdm/jsbsim/systems/entry_guidance/remaining-distance-nm");

#print(velocity, " ", earth_rotation);

# the TRAJ 1 display shows relative rather than inertial velocity
if (traj_display_flag == 1)
	{velocity = math.sqrt(math.abs(velocity * velocity - earth_rotation * earth_rotation));}

return velocity;

}



var ascent_traj_process = func  (traj, sym_shuttle_asc) {

var altitude = getprop("/position/altitude-ft");
var latitude = getprop("/position/latitude-deg");
var velocity = getprop("/fdm/jsbsim/velocities/eci-velocity-mag-fps");
var earth_rotation = 1420.0 * math.cos(latitude);
var range = getprop("/fdm/jsbsim/systems/entry_guidance/remaining-distance-nm");

#print(velocity, " ", earth_rotation);

# the TRAJ 1 display shows relative rather than inertial velocity
if (traj_display_flag == 1)
	{velocity = math.sqrt(math.abs(velocity * velocity - earth_rotation * earth_rotation));}

# check transition to next display

if (traj_display_flag == 1)
	{
	if (getprop("/controls/shuttle/SRB-static-model") == 0) # we have separated the SRBs
		{
		fill_traj2_data();
		# window.set("title", "ASCENT TRAJ 2");
		traj.removeAllChildren();
		plot_traj (traj);
		traj_display_flag = 2;
		}
	}
if (traj_display_flag == 2)
	{
	if (getprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode") > 0) # we're preparing for de-orbit
		{
		fill_entry1_data();
		traj.removeAllChildren();
		plot_traj (traj);
		traj_display_flag = 3;
		}

	}
if (traj_display_flag == 3)
	{
	if (velocity < 18500.0)
		{
		fill_entry2_data();
		traj.removeAllChildren();
		plot_traj (traj);
		traj_display_flag = 4;
		}
	}

if (traj_display_flag == 4)
	{
	if (velocity < 15800.0)
		{
		fill_entry3_data();
		traj.removeAllChildren();
		plot_traj (traj);
		traj_display_flag = 5;
		}
	}

if (traj_display_flag == 5)
	{
	if (velocity < 12000.0)
		{
		fill_entry4_data();
		traj.removeAllChildren();
		plot_traj (traj);
		traj_display_flag = 6;
		}
	}

if (traj_display_flag == 6)
	{
	if (velocity < 5500.0)
		{
		fill_entry5_data();
		traj.removeAllChildren();
		plot_traj (traj);
		traj_display_flag = 7;
		}
	}

var x = 0;
var y = 0;

if ((traj_display_flag ==1 ) or (traj_display_flag ==2))
	{
	x = parameter_to_x(velocity, traj_display_flag);
	y = parameter_to_y(altitude, traj_display_flag);
	}
else 
	{
	x = parameter_to_x(range, traj_display_flag);
	y = parameter_to_y(velocity, traj_display_flag);
	}

sym_shuttle_asc.setTranslation(x,y);

}


# converter functions for trajectory data into the display format

var parameter_to_x = func (par, display) {

if (display == 1)
	{
	return (par / 5000.0 * 0.8 + 0.1) * 512.0;
	}
else if (display == 2)
	{
	return ((par - 5000.0) / 21000.0 * 0.8 + 0.1) * 512.0;
	}
else if (display == 3)
	{
	return ((par - 700.0)/1400.0 * 0.8 + 0.1) * 512.0;
	}
else if (display == 4)
	{
	return ((par -400.0)/400.0 * 0.8 + 0.1) * 512.0;
	}
else if (display == 5)
	{
	return ((par -200.0)/450.0 * 0.8 + 0.1) * 512.0;
	}
else if (display == 6)
	{
	return ((par -80.0)/220.0 * 0.8 + 0.1) * 512.0;
	}
else if (display == 7)
	{
	return ((par -55.0)/45.0 * 0.8 + 0.1) * 512.0;
	}
else if (display == 8)
	{
	return ((par -10.0)/80.0 * 0.68 + 0.1) * 512.0;
	}
else if (display == 9)
	{
	return ((par -5.0)/20.0 * 0.68 + 0.1) * 512.0;
	}
}

var parameter_to_y = func (par, display) {

if (display == 1)
	{
	return 512.0 - (par / 170000.0 * 0.6 + 0.2) * 512.0;
	}
else if (display == 2)
	{
	return 512.0 - ((par - 140000.0) / 385000.0 * 0.6 + 0.2) * 512.0;
	}
else if (display == 3)
	{
	return 512.0 - ((par - 18500.0) / 7500.0 * 0.6 + 0.2) * 512.0;
	}
else if (display == 4)
	{
	return 512.0 - ((par - 15800.0) / 2700.0 * 0.6 + 0.2) * 512.0;
	}
else if (display == 5)
	{
	return 512.0 - ((par - 10000.0) / 5800.0 * 0.6 + 0.2) * 512.0;
	}
else if (display == 6)
	{
	return 512.0 - ((par - 5500.0) / 4500.0 * 0.6 + 0.2) * 512.0;
	}
else if (display == 7)
	{
	return 512.0 - ((par - 4000.0) / 1500.0 * 0.6 + 0.2) * 512.0;
	}
else if (display == 8)
	{
	return 512.0 - ((par - 30000.0) / 55000.0 * 0.52 + 0.2) * 512.0;
	}
else if (display == 9)
	{
	return 512.0 - ((par - 8000.0) / 22000.0 * 0.52 + 0.2) * 512.0;
	}
}


# trajectory data points, obtained from test flights - in reality, these would be mission-specific and 
# they may change in the future

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
	traj_data[i][0] = parameter_to_x(traj_data[i][0], 1);
	traj_data[i][1] = parameter_to_y(traj_data[i][1], 1); 
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
	traj_data[i][0] = parameter_to_x(traj_data[i][0], 2);
	traj_data[i][1] = parameter_to_y(traj_data[i][1], 2); 
	}

}


var fill_entry1_data = func {

var point = [];
setsize(traj_data,0);

#point = [2500.5817, 25537.67];
#append(traj_data, point);

#point= [2300.0462, 25513.095];
#append(traj_data, point);

point= [2001.9825, 25373.167];
append(traj_data, point);

point= [1802.8649, 25177.418];
append(traj_data, point);

point= [1600.1037, 24887.478];
append(traj_data, point);

point= [1500.904, 24667.815];
append(traj_data, point);

point= [1202.5228, 23447.14];
append(traj_data, point);

point= [1000.2354, 21936.996];
append(traj_data, point);

point= [900.1702, 20971.771];
append(traj_data, point);

point= [802.0128, 19833.938];
append(traj_data, point);

point = [715.8945, 18647.557];
append(traj_data, point);






for (i=0; i< size(traj_data); i=i+1)
	{
	traj_data[i][0] = parameter_to_x(traj_data[i][0], 3);
	traj_data[i][1] = parameter_to_y(traj_data[i][1], 3); 
	}

}


var fill_entry2_data = func {

var point = [];
setsize(traj_data,0);

point= [701.0564, 18423.439];
append(traj_data, point);

point= [616.4637, 17006.038];
append(traj_data, point);

point = [600.5114, 16720.136];
append(traj_data, point);

point = [590.0595, 16530.562];
append(traj_data, point);

point = [572.1183, 16200.074];
append(traj_data, point);

point = [559.6342, 15965.385];
append(traj_data, point);

point = [549.8, 15777.81];
append(traj_data, point);




for (i=0; i< size(traj_data); i=i+1)
	{
	traj_data[i][0] = parameter_to_x(traj_data[i][0], 4);
	traj_data[i][1] = parameter_to_y(traj_data[i][1], 4); 
	}

}


var fill_entry3_data = func {

var point = [];
setsize(traj_data,0);

point = [530.5237, 15403.162];
append(traj_data, point);

point = [511.8237, 15030.253];
append(traj_data, point);

point = [502.671, 14844.008];
append(traj_data, point);

point = [480.4199, 14380.543];
append(traj_data, point);

point = [463.2644, 14011.991];
append(traj_data, point);

point = [450.7754, 13732.593];
append(traj_data, point);

point = [440.6204, 13496.858];
append(traj_data, point);

point = [430.6965, 13261.451];
append(traj_data, point);

point = [421.0654, 13028.604];
append(traj_data, point);

point = [409.7185, 12756.536];
append(traj_data, point);

point = [400.4949, 12546.256];
append(traj_data, point);

point = [389.5475, 12303.911];
append(traj_data, point);

point = [371.7162, 11908.302];
append(traj_data, point);

point = [356.1252, 11569.916];
append(traj_data, point);

point = [340.9517, 11243.812];
append(traj_data, point);

point = [321.3778, 10821.382];
append(traj_data, point);

point = [301.0546, 10389.273];
append(traj_data, point);

point = [283.0393, 10007.103];
append(traj_data, point);

for (i=0; i< size(traj_data); i=i+1)
	{
	traj_data[i][0] = parameter_to_x(traj_data[i][0], 5);
	traj_data[i][1] = parameter_to_y(traj_data[i][1], 5); 
	}

}


var fill_entry4_data = func {

var point = [];
setsize(traj_data,0);

point = [281.5675, 9975.9317];
append(traj_data, point);

point = [261.5295, 9551.0586];
append(traj_data, point);

point = [241.1797, 9113.4238];
append(traj_data, point);

point = [221.7611, 8690.9079];
append(traj_data, point);

point = [201.2034, 8208.7248];
append(traj_data, point);

point = [180.9763, 7726.5068];
append(traj_data, point);

point = [160.3208, 7207.121];
append(traj_data, point);

point = [140.7475, 6674.7528];
append(traj_data, point);

point = [120.4003, 6053.7832];
append(traj_data, point);

point = [100.5856, 5620.6671];
append(traj_data, point);

point = [95.6635, 5513.766];
append(traj_data, point);

for (i=0; i< size(traj_data); i=i+1)
	{
	traj_data[i][0] = parameter_to_x(traj_data[i][0], 6);
	traj_data[i][1] = parameter_to_y(traj_data[i][1], 6); 
	}

}


var fill_entry5_data = func {

var point = [];
setsize(traj_data,0);


point = [95.6635, 5513.766];
append(traj_data, point);

point= [90.8323, 5406.4754];
append(traj_data, point);

point=[80.9173, 5164.8333];
append(traj_data, point);

point= [70.5462, 4777.7644];
append(traj_data, point);

point=[60.527, 4342.2923];
append(traj_data, point);

for (i=0; i< size(traj_data); i=i+1)
	{
	traj_data[i][0] = parameter_to_x(traj_data[i][0], 7);
	traj_data[i][1] = parameter_to_y(traj_data[i][1], 7); 
	}

}


var fill_vert_sit1_nom_data = func {

var point = [];
setsize(traj_data,0);



point = [71.0, 72600.0];
append(traj_data, point);

point = [51.0, 59000.0];
append(traj_data, point);


point = [41.0, 49000.0];
append(traj_data, point);

point = [31.0, 39000.0];
append(traj_data, point);

point = [21.0, 30000.0];
append(traj_data, point);



for (i=0; i< size(traj_data); i=i+1)
	{
	traj_data[i][0] = parameter_to_x(traj_data[i][0], 8);
	traj_data[i][1] = parameter_to_y(traj_data[i][1], 8); 
	}

}


var fill_vert_sit1_SB_data = func {

var point = [];
setsize(limit1_data,0);

point = [86.0, 87000.0];
append(limit1_data, point);

point = [66.0, 83000.0];
append(limit1_data, point);

point = [46.0, 69000.0];
append(limit1_data, point);

point = [26.0, 49000.0];
append(limit1_data, point);

point = [16.0, 34000.0];
append(limit1_data, point);

for (i=0; i< size(limit1_data); i=i+1)
	{
	limit1_data[i][0] = parameter_to_x(limit1_data[i][0], 8);
	limit1_data[i][1] = parameter_to_y(limit1_data[i][1], 8); 
	}

}

var fill_vert_sit1_maxLD_data = func {

var point = [];
setsize(limit2_data,0);


point = [89.0, 80000.0];
append(limit2_data, point);

point = [70.0, 68000.0];
append(limit2_data, point);

point = [48.0, 50000.0];
append(limit2_data, point);

point = [35.0, 40000.0];
append(limit2_data, point);

point = [25.0, 30000.0];
append(limit2_data, point);

for (i=0; i< size(limit2_data); i=i+1)
	{
	limit2_data[i][0] = parameter_to_x(limit2_data[i][0], 8);
	limit2_data[i][1] = parameter_to_y(limit2_data[i][1], 8); 
	}

}


var fill_vert_sit2_nom_data = func {

var point = [];
setsize(traj_data,0);


point = [21.0, 30000.0];
append(traj_data, point);

point = [15.0, 21400.0];
append(traj_data, point);

point = [10.0, 14400.0];
append(traj_data, point);

point = [5.0, 8000.0];
append(traj_data, point);

for (i=0; i< size(traj_data); i=i+1)
	{
	traj_data[i][0] = parameter_to_x(traj_data[i][0], 9);
	traj_data[i][1] = parameter_to_y(traj_data[i][1], 9); 
	}

}


var fill_vert_sit2_SB_data = func {

var point = [];
setsize(limit1_data,0);

point = [15.0, 30000.0];
append(limit1_data, point);

point = [10.0, 19300.0];
append(limit1_data, point);

point = [5.0, 9200.0];
append(limit1_data, point);


for (i=0; i< size(limit1_data); i=i+1)
	{
	limit1_data[i][0] = parameter_to_x(limit1_data[i][0], 9);
	limit1_data[i][1] = parameter_to_y(limit1_data[i][1], 9); 
	}

}

var fill_vert_sit2_maxLD_data = func {

var point = [];
setsize(limit2_data,0);


point = [25.3, 30000.0];
append(limit2_data, point);

point = [20.0, 24300.0];
append(limit2_data, point);

point = [15.0, 18000.0];
append(limit2_data, point);

point = [10.0, 12000.0];
append(limit2_data, point);

point = [5.6, 8000.0];
append(limit2_data, point);

for (i=0; i< size(limit2_data); i=i+1)
	{
	limit2_data[i][0] = parameter_to_x(limit2_data[i][0], 9);
	limit2_data[i][1] = parameter_to_y(limit2_data[i][1], 9); 
	}

}

var plot_traj = func (trajectory) {


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
