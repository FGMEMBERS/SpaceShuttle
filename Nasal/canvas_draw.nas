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

return shape_data;
}
