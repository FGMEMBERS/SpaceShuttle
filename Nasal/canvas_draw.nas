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


var draw_bearing_pointer_up = func {

var shape_data = [];

var point = [0, 0, 0];
append(shape_data, point);

point = [-8, 14.0, 1];
append(shape_data, point);

point = [-3.0, 14.0, 1];
append(shape_data, point);

point = [0.0, 20.0, 1];
append(shape_data, point);

point = [3.0, 14.0, 1];
append(shape_data, point);

point = [8, 14.0, 1];
append(shape_data, point);

point = [0, 0, 1];
append(shape_data, point);

return shape_data;
}

var draw_runway_pointer_up = func {

var shape_data = [];

var point = [0, 0, 0];
append(shape_data, point);

point = [-5, 7.0, 1];
append(shape_data, point);

point = [-3.0, 14.0, 1];
append(shape_data, point);

point = [3.0, 14.0, 1];
append(shape_data, point);

point = [5, 7.0, 1];
append(shape_data, point);

point = [0, 0, 1];
append(shape_data, point);

return shape_data;
}


var draw_course_arrow = func {

var shape_data = [];

var point = [0, 0, 0];
append(shape_data, point);

point = [1, 0, 1];
append(shape_data, point);

point = [5, 30, 1];
append(shape_data, point);

point = [15, 40, 1];
append(shape_data, point);

point = [14, 44, 1];
append(shape_data, point);

point = [5, 36, 1];
append(shape_data, point);

point = [0, 45, 1];
append(shape_data, point);

point = [-5, 36, 1];
append(shape_data, point);

point = [-14, 44, 1];
append(shape_data, point);

point = [-15, 40, 1];
append(shape_data, point);

point = [-5, 30, 1];
append(shape_data, point);

point = [-1, 0, 1];
append(shape_data, point);

point = [0, 0, 1];
append(shape_data, point);

point = [0, 45, 1];
append(shape_data, point);

return shape_data;

}


var draw_cdi_center = func {

var shape_data = [];

var point = [0, 0, 0];
append(shape_data, point);

point = [-3, 14.0, 1];
append(shape_data, point);

point = [-8.0, 16.0, 1];
append(shape_data, point);

point = [0.0, 24.0, 1];
append(shape_data, point);

point = [8.0, 16.0, 1];
append(shape_data, point);

point = [3, 14.0, 1];
append(shape_data, point);

point = [0, 0, 1];
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

var point = [0, 0, 0];
append(shape_data, point);

point = [-4.5, 3.0, 1];
append(shape_data, point);

point = [-4.5, 1.5, 1];
append(shape_data, point);

point = [-24.0, 1.5, 1];
append(shape_data, point);

point = [-24.0, -1.5, 1];
append(shape_data, point);

point = [-4.5, -1.5, 1];
append(shape_data, point);

point = [-4.5, -3.0, 1];
append(shape_data, point);

point = [0.0, 0.0, 1];
append(shape_data, point);

return shape_data;
}

var draw_slim_arrow_down = func {

var shape_data = [];

var point = [-0.8, 0, 0];
append(shape_data, point);

var point = [-0.8, 19.5, 1];
append(shape_data, point);

var point = [-3.0, 19.5, 1];
append(shape_data, point);

var point = [0.0, 34.0, 1];
append(shape_data, point);

var point = [3.0, 19.5, 1];
append(shape_data, point);

var point = [0.8, 19.5, 1];
append(shape_data, point);

var point = [0.8, 0, 1];
append(shape_data, point);

var point = [-0.8, 0, 1];
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

var draw_arc = func (radius, resolution, ang1, ang2) {

var shape_data = [];


var d_ang = (math.pi/180.0 * (ang2 - ang1))/(resolution-1);

for (var i=0; i< resolution; i=i+1)
	{
	var angle = ang1 * math.pi/180.0 + i * d_ang;

	var x = radius * math.sin(angle);	
	var y = -radius * math.cos(angle);

	append(shape_data, [x,y,1]); 

	}
return shape_data;
}


var draw_comb = func (radius, n_ticks, tick_size, ang1, ang2, direction) {

var shape_data = [];

var size = radius * tick_size;

var displacement = [];

if (direction == 0)
	{displacement = [size, 0];}
else if (direction == 1)
	{displacement = [0, size];}
else if (direction == 2)
	{displacement = [-size, 0];}
else if (direction == 3)
	{displacement = [0, -size];}

var d_ang = (math.pi/180.0 * (ang2 - ang1))/(n_ticks-1);



for (var i=0; i< n_ticks; i=i+1)
	{
	var angle = ang1 * math.pi/180.0 + i * d_ang;

	var x = radius * math.sin(angle);	
	var y = -radius * math.cos(angle);

	append(shape_data, [x,y,0]); 

	x = x + displacement[0];
	y = y + displacement[1];

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
# draw tics on an arc
#####################################################

var draw_arc_scale = func (radius, n_major, major_size, n_minor, minor_size, ang1, ang2) {

var n_total = n_major * (n_minor + 1);

var shape_data = [];

var d_ang = (math.pi/180.0 * (ang2 - ang1))/(n_total-1);


var minor_count = 0;

for (var i = 0; i< n_total; i=i+1)
	{
	var angle = ang1 * math.pi/180.0 + i * d_ang;
	var size = minor_size;
	if (minor_count ==0) {size = major_size;}

	var x = radius * math.sin(angle);	
	var y = -radius * math.cos(angle);

	var point = [x,y,0];
	append(shape_data, point);
 
	x*=size;
	y*=size;

	var point = [x,y,1];
	append(shape_data, point);
	minor_count = minor_count+1;
	if (minor_count == (n_minor +1)) {minor_count = 0;}

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


var circle_clipping_hard = func (projected_point, radius) {

var length = math.sqrt(projected_point[0] * projected_point[0] + projected_point[1] * projected_point[1]);

if (length >  radius)
	{
	projected_point[2] = -1;
	}
return projected_point;
}


var center_resolution_culling = func (array, radius) {

var out_array = [];
var counter = 0;

for (var i=0; i< size(array); i=i+1)
	{
	var point = array[i];
	var length = math.sqrt(point[0] * point[0] + point[1] * point[1]);

	if ((length > 0.95 * radius) or (counter == 0))
		{
		append(out_array, point);
		}
	}
return out_array;

}


var draw_adi_bg = func (pitch, yaw, roll) {

var shape_data = [];

var p_vecs = SpaceShuttle.projection_vecs(-pitch, yaw, 0.0);

shape_data = draw_coord_circle(0.0, 90, p_vecs);

var n = size(shape_data);

if (pitch < -47.5)
	{
	shape_data = draw_circle(0.75 * 95.0, 30);
	return shape_data;
	}
else if (pitch > 47.5)
	{
	# object not visible, we return a dummy structure which doesn't draw
	append(shape_data,[0,0,0]);
	append(shape_data,[1,0,0]);
	append(shape_data,[2,0,0]);

	return shape_data;
	}


var x_min = 1000.0;
var x_max = - 1000.0;
var i_min = -1;
var i_max = -1;

for (var i=0; i< n; i=i+1)
	{
	if ((shape_data[i][0] < x_min) and (shape_data[i][2] == 1)) {x_min = shape_data[i][0]; i_min = i;}
	if ((shape_data[i][0] > x_max) and (shape_data[i][2] == 1)) {x_max = shape_data[i][0]; i_max = i;}
	}



var ang1 = math.atan2(shape_data[i_max][0], -shape_data[i_max][1]) * 180.0/math.pi;
var ang2 = math.atan2(shape_data[i_min][0], -shape_data[i_min][1]) * 180.0/math.pi;

if (ang2 < 0.0) {ang2 = ang2 + 360.0;}

var arc_data = draw_arc(0.75 * 95.0, 30, ang1, ang2);

var final_data = [];

for (var i=i_min; i>-1; i=i-1)
	{
	if (shape_data[i][2] == 1)
		{append(final_data, shape_data[i]);}
	}
for (var i=(n-1); i>i_min; i=i-1)
	{
	if (shape_data[i][2] == 1)
		{append(final_data, shape_data[i]);}
	}

for (var i=0; i< size(arc_data); i=i+1)
	{
	append(final_data, arc_data[i]);
	}

var roll_rad = roll * math.pi/180.0;

for (var i=0; i<size(final_data); i=i+1)
	{
	var x = math.cos(roll_rad) * final_data[i][0] + math.sin(roll_rad) * final_data[i][1];	
	var y = -math.sin(roll_rad) * final_data[i][0] + math.cos(roll_rad) * final_data[i][1];	
	
	final_data[i][0] = x;
	final_data[i][1] = y;
	}


return final_data;

}

var label_coords_sphere = func(lat, lon, p_vecs, pitch, yaw) {

var lon_rad = (90-lon) * math.pi/180.0;
var lat_rad = -lat * math.pi/180.0;

var x = math.sin(lon_rad) * math.cos(lat_rad);
var y = math.cos(lon_rad) * math.cos(lat_rad);
var z = math.sin(lat_rad);

var projected_point = projection ([x,y,z], p_vecs[0], p_vecs[1], p_vecs[2]);
projected_point = circle_clipping(projected_point, 0.65);

projected_point[0] *=95.0;
projected_point[1] *=95.0;

var slant = -math.sin(lat_rad) * math.sin(lon_rad - (90-yaw) * math.pi/180.0);

append(projected_point, slant);

#print("Point:", projected_point[0], " ", projected_point[1], " ", projected_point[2]);

return projected_point;
}


var draw_meridian = func (lon, npoints, p_vecs) {

var dlat = 170.0 / (npoints-1);
var lon_rad = lon * math.pi/180.0;

#var p_vecs = projection_vecs (pitch, yaw, roll);

var shape_data = [];

for (var i = 0; i < npoints; i=i+1)
	{
	var lat_rad = (-85.0 + i * dlat) * math.pi/180.0;
	
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

shape_data = center_resolution_culling(shape_data, 95.0);

return shape_data;

}

var draw_meridian_ladder = func (lon, nticks, p_vecs) {

var npoints = 6 * nticks;

var dlat = 180.0 / (npoints-1);
var dlon = 2.0 * math.pi/180.0;
var lon_rad = lon * math.pi/180.0;


var shape_data = [];

for (var i = 0; i < npoints; i=i+1)
	{
	var lat_rad = (-90.0 + i * dlat) * math.pi/180.0;
	
	var x = math.sin(lon_rad - dlon) * math.cos(lat_rad);
	var y = math.cos(lon_rad - dlon) * math.cos(lat_rad);
	var z = math.sin(lat_rad);	

	var projected_point = projection ([x,y,z], p_vecs[0], p_vecs[1], p_vecs[2]);
	projected_point = circle_clipping(projected_point, 0.75);

	projected_point[0] *=95.0;
	projected_point[1] *=95.0;

	if (math.abs(lat_rad) > 75.0 * math.pi/180.0)
		{projected_point[2] = -1;}

	if (projected_point[2] > -1)
		{
		projected_point[2] = 0;
		append(shape_data, projected_point);
		}
	

	x = math.sin(lon_rad + dlon) * math.cos(lat_rad);
	y = math.cos(lon_rad + dlon) * math.cos(lat_rad);
	z = math.sin(lat_rad);	

	projected_point = projection ([x,y,z], p_vecs[0], p_vecs[1], p_vecs[2]);
	projected_point = circle_clipping_hard(projected_point, 0.75);

	projected_point[0] *=95.0;
	projected_point[1] *=95.0;

	if (math.abs(lat_rad) > 75.0 * math.pi/180.0)
		{projected_point[2] = -1;}

	if (projected_point[2] > -1)
		{append(shape_data, projected_point);}
	}	

return shape_data;

}



var draw_circle_ladder = func (lat, nticks, p_vecs) {

var npoints = 6 * nticks;

var dlon = 360.0 / (npoints-1);
var dlat = 2.0 * math.pi/180.0;
var lat_rad = lat * math.pi/180.0;


var shape_data = [];

for (var i = 0; i < npoints; i=i+1)
	{
	var lon_rad = i * dlon * math.pi/180.0;
	
	var x = math.sin(lon_rad) * math.cos(lat_rad - dlat);
	var y = math.cos(lon_rad ) * math.cos(lat_rad - dlat);
	var z = math.sin(lat_rad - dlat);	

	var projected_point = projection ([x,y,z], p_vecs[0], p_vecs[1], p_vecs[2]);
	projected_point = circle_clipping_hard(projected_point, 0.75);

	projected_point[0] *=95.0;
	projected_point[1] *=95.0;

	if (math.abs(lat_rad) > 75.0 * math.pi/180.0)
		{projected_point[2] = -1;}

	if (projected_point[2] > -1)
		{
		projected_point[2] = 0;
		append(shape_data, projected_point);
		}
	

	x = math.sin(lon_rad) * math.cos(lat_rad + dlat);
	y = math.cos(lon_rad) * math.cos(lat_rad + dlat);
	z = math.sin(lat_rad + dlat);	

	projected_point = projection ([x,y,z], p_vecs[0], p_vecs[1], p_vecs[2]);
	projected_point = circle_clipping(projected_point, 0.75);

	projected_point[0] *=95.0;
	projected_point[1] *=95.0;

	if (math.abs(lat_rad) > 75.0 * math.pi/180.0)
		{projected_point[2] = -1;}

	if (projected_point[2] > -1)
		{append(shape_data, projected_point);}
	}	

return shape_data;

}




var draw_coord_circle = func (lat, npoints, p_vecs) {

var dlon = 360.0 / (npoints-1);
var lat_rad = lat * math.pi/180.0;

#var p_vecs = projection_vecs (pitch, yaw, roll);

var shape_data = [];

for (var i = 0; i < npoints; i=i+1)
	{
	var lon_rad = (i * dlon) * math.pi/180.0;
	
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

shape_data = center_resolution_culling(shape_data, 95.0);

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
 


