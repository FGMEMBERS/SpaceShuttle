# generation of shapes for canvas drawing
# Thorsten Renk 2016


var draw_triangle_down = func {

var shape_data = [];

var point = [0, 5.0];
append(shape_data, point);

point = [6.9, -3.0];
append(shape_data, point);

point = [-6.9, -3.0];
append(shape_data, point);

point = [0, 5.0];
append(shape_data, point);

return shape_data;
}


var draw_triangle_up = func {

var shape_data = [];

var point = [0, -5.0];
append(shape_data, point);

point = [6.9, 3.0];
append(shape_data, point);

point = [-6.9, 3.0];
append(shape_data, point);

point = [0, -5.0];
append(shape_data, point);

return shape_data;
}

var draw_tmarker_right = func {

var shape_data = [];

var point = [0, 0];
append(shape_data, point);

point = [-8.0, -6.9];
append(shape_data, point);

point = [-8.0, 6.9];
append(shape_data, point);

point = [0, 0];
append(shape_data, point);

return shape_data;

}

var draw_tmarker_down = func {

var shape_data = [];

var point = [0, 0];
append(shape_data, point);

point = [-6.9, -8.0];
append(shape_data, point);

point = [6.9, -8.0];
append(shape_data, point);

point = [0, 0];
append(shape_data, point);

return shape_data;

}

var draw_arrowmarker_right = func {

var shape_data = [];

var point = [0, 0];
append(shape_data, point);

point = [-4.5, 3.0];
append(shape_data, point);

point = [-4.5, 1.5];
append(shape_data, point);

point = [-24.0, 1.5];
append(shape_data, point);

point = [-24.0, -1.5];
append(shape_data, point);

point = [-4.5, -1.5];
append(shape_data, point);

point = [-4.5, -3.0];
append(shape_data, point);

point = [0.0, 0.0];
append(shape_data, point);

return shape_data;

}


var draw_shuttle_side = func {

var shape_data = [];

var point = [-2.0, 0.5];
append(shape_data, point);

point = [-2.0, 0.25];
append(shape_data, point);

point = [-1.0, -0.5];
append(shape_data, point);

point = [1.0, -0.5];
append(shape_data, point);

point = [1.5, -1.5];
append(shape_data, point);

point = [1.5, -0.5];
append(shape_data, point);

point = [2.0, 0.0];
append(shape_data, point);

point = [1.5, 0.5];
append(shape_data, point);

point = [-2.0, 0.5];
append(shape_data, point);
}

var draw_circle = func (radius, resolution) {

var shape_data = [];

for (var i=0; i< resolution; i=i+1)
	{
	var angle = i * 2.0 * math.pi / (resolution-1);

	var x = radius * math.sin(angle);	
	var y = radius * math.cos(angle);

	append(shape_data, [x,y]); 

	}
return shape_data;
}


var draw_shuttle_top = func {

var shape_data = [];

var point = [0.0, 1.25];
append(shape_data, point);

point = [-0.25, 1.0];
append(shape_data, point);

point = [-1.5, 1.0];
append(shape_data, point);

point = [-1.5, 0.8];
append(shape_data, point);

point = [-0.75, 0.0];
append(shape_data, point);

point = [-0.15, -2.0];
append(shape_data, point);

point = [0.0, -2.1];
append(shape_data, point);

point = [0.15, -2.0];
append(shape_data, point);

point = [0.75, 0.0];
append(shape_data, point);

point = [1.5, 0.8];
append(shape_data, point);

point = [1.5, 1.0];
append(shape_data, point);

point = [0.25, 1.0];
append(shape_data, point);

point = [0.0, 1.25];
append(shape_data, point);

}
