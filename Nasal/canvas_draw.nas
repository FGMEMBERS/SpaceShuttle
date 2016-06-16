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

var draw_tmarker_left = func {

var shape_data = [];

var point = [0, 0];
append(shape_data, point);

point = [8.0, -6.9];
append(shape_data, point);

point = [8.0, 6.9];
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

var draw_tmarker_up = func {

var shape_data = [];

var point = [0, 0];
append(shape_data, point);

point = [-6.9, 8.0];
append(shape_data, point);

point = [6.9, 8.0];
append(shape_data, point);

point = [0, 0];
append(shape_data, point);

return shape_data;
}

var draw_rect = func (width, height) {

var shape_data = [];

var point = [-width * 0.5, -height*0.5,0];
append(shape_data, point);

point = [-width * 0.5, -height * 0.5, 0];
append(shape_data, point);

point = [-width * 0.5, height * 0.5, 1];
append(shape_data, point);

point = [width * 0.5, height * 0.5, 1];
append(shape_data, point);

point = [width * 0.5, -height * 0.5, 1];
append(shape_data, point);

point = [-width * 0.5, -height * 0.5, 1];
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

return shape_data;
}

var draw_circle = func (radius, resolution) {

var shape_data = [];

for (var i=0; i< resolution; i=i+1)
	{
	var angle = i * 2.0 * math.pi / (resolution-1);

	var x = radius * math.sin(angle);	
	var y = radius * math.cos(angle);

	append(shape_data, [x,y,1]); 

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

return shape_data;
}

#####################################################
# draw a compass
#####################################################

var draw_compass_scale = func (radius, n_major, major_size, n_minor, minor_size) {

var n_total = n_major * n_minor;

var shape_data = [];

var dangle = 360.0/n_total * math.pi/180.0;
var minor_count = 0;

for (var i = 0; i< n_total; i=i+1)
	{
	var angle = i * dangle;
	var size = minor_size;
	if (minor_count ==0) {size = major_size;}

	var x = radius * math.sin(angle);
	var y = radius * math.cos(angle);

	var point = [x,y,0];
	append(shape_data, point);
 
	x*=size;
	y*=size;

	var point = [x,y,1];
	append(shape_data, point);
	minor_count = minor_count+1;
	if (minor_count == n_minor) {minor_count = 0;}

	}

return shape_data;
}

#####################################################
# draw ladders
#####################################################

var draw_ladder = func (length, n_major, major_size, n_minor, minor_size, primary_direction, secondary_direction, style) {

# primary direction 0: horizontal 1: vertical


# draw ladder body

var shape_data = [];

if (style==1)
	{

	if (primary_direction == 0)
		{
		point = [-0.5 * length, 0.0, 0];
		append(shape_data, point);

		point = [-0.5* length, 0.0, 0];
		append(shape_data, point);

		point = [0.5* length, 0.0, 1];
		append(shape_data, point);
		}
	else
		{
		point = [0.0,-0.5 * length, 0];
		append(shape_data, point);

		point = [0.0,-0.5* length, 0];
		append(shape_data, point);

		point = [0.0,0.5* length, 1];
		append(shape_data, point);
	}
}

var n_total = (n_major-1) * (n_minor+1) + 1;
var dl = length/(n_total-1);

# draw ladder rungs

var x = 0;
var y = 0;
var minor_count = 0;

for (var i=0; i< n_total; i=i+1)
	{
	x = -0.5 * length + i * dl;
	y = 0.0;

	if (primary_direction == 0)
		{append(shape_data, [x,y,0]);}
	else
		{append(shape_data, [y,x,0]);}

	var size = minor_size;
	if (minor_count ==0) {size = major_size;}
	if (secondary_direction ==1) {size = -size;}

	y = length * size;

	if (primary_direction == 0)
		{append(shape_data, [x,y,1]);}
	else
		{append(shape_data, [y,x,1]);}

	minor_count = minor_count+1;
	if (minor_count == (n_minor+1)) {minor_count = 0;}

	}

return shape_data;
}


#####################################################
# draw tapes
#####################################################



##############################################################
# draw an ADI sphere in 3d space for the PFD, then project it
##############################################################

var projection_vecs = func (pitch, yaw, roll) {

var xvec = [1.0, 0.0, 0.0];
var yvec = [0.0, 1.0, 0.0];
var zvec = [0.0, 0.0, 1.0];

var view_vec = SpaceShuttle.orientTaitBryan( xvec, yaw, pitch, roll);
var x_proj = SpaceShuttle.orientTaitBryan( yvec, yaw, pitch, roll);
var y_proj = SpaceShuttle.orientTaitBryan( zvec, yaw, pitch, roll);

return [view_vec, x_proj, y_proj];
}

var projection = func (point_coords, view_vec, x_proj, y_proj) {

var projected_point = [0.0, 0.0, 0.0];

projected_point[0] = SpaceShuttle.dot_product(point_coords, x_proj);
projected_point[1] = SpaceShuttle.dot_product(point_coords, y_proj);

var hemisphere = SpaceShuttle.dot_product(point_coords, view_vec);

if (hemisphere < -0.2)
	{projected_point[2] = -1;}
else if (hemisphere < 0.0)
	{projected_point[2] = 0;}
else
	{projected_point[2] = 1;}

return projected_point;

}

var circle_clipping = func (projected_point, radius) {

var length = math.sqrt(projected_point[0] * projected_point[0] + projected_point[1] * projected_point[1]);

if (length > 1.2 * radius)
	{
	projected_point[2] = -1;
	}
else if (length > radius)
	{
	projected_point[2] = 0;
	}
return projected_point;

}


var label_coords_sphere = func(lat, lon, p_vecs) {

var lon_rad = (90-lon) * math.pi/180.0;
var lat_rad = -lat * math.pi/180.0;

var x = math.sin(lon_rad) * math.cos(lat_rad);
var y = math.cos(lon_rad) * math.cos(lat_rad);
var z = math.sin(lat_rad);

var projected_point = projection ([x,y,z], p_vecs[0], p_vecs[1], p_vecs[2]);
projected_point = circle_clipping(projected_point, 0.65);

projected_point[0] *=95.0;
projected_point[1] *=95.0;

#print("Point:", projected_point[0], " ", projected_point[1], " ", projected_point[2]);

return projected_point;
}


var draw_meridian = func (lon, npoints, pitch, yaw, roll) {

var dlat = 180.0 / (npoints-1);
var lon_rad = lon * math.pi/180.0;

var p_vecs = projection_vecs (pitch, yaw, roll);

var shape_data = [];

for (var i = 0; i < npoints; i=i+1)
	{
	var lat_rad = -90.0 + i * dlat * math.pi/90.0;
	
	var x = math.sin(lon_rad) * math.cos(lat_rad);
	var y = math.cos(lon_rad) * math.cos(lat_rad);
	var z = math.sin(lat_rad);	

	var projected_point = projection ([x,y,z], p_vecs[0], p_vecs[1], p_vecs[2]);
	projected_point = circle_clipping(projected_point, 0.75);

	projected_point[0] *=95.0;
	projected_point[1] *=95.0;

	if (projected_point[2] > -1)
		{append(shape_data, projected_point);}
	}

return shape_data;

}

var draw_coord_circle = func (lat, npoints, pitch, yaw, roll) {

var dlon = 360.0 / (npoints-1);
var lat_rad = lat * math.pi/180.0;

var p_vecs = projection_vecs (pitch, yaw, roll);

var shape_data = [];

for (var i = 0; i < npoints; i=i+1)
	{
	var lon_rad = 360.0 + i * dlon * math.pi/180.0;
	
	var x = math.sin(lon_rad) * math.cos(lat_rad);
	var y = math.cos(lon_rad) * math.cos(lat_rad);
	var z = math.sin(lat_rad);	

	var projected_point = projection ([x,y,z], p_vecs[0], p_vecs[1], p_vecs[2]);
	projected_point = circle_clipping(projected_point, 0.75);

	projected_point[0] *=95.0;
	projected_point[1] *=95.0;

	if (projected_point[2] > -1)
		{append(shape_data, projected_point);}

	}

return shape_data;

}

#####################################################
# placement of compass text labels
#####################################################

var compass_label_pos = func (radius, angle) {

var x = radius * math.sin(angle * math.pi/180.0);
var y = radius * math.cos(angle * math.pi/180.0);

#print(x, " ", y);

return [x,y];

}
 


