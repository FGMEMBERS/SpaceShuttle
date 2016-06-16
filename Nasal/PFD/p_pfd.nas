#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_pfd
# Description: PFD page
#      Author: Thorsten Renk, 2015
#---------------------------------------




var pfd_segment_draw = func (data, plot) {

	if (size(data) < 2) {return;}

	plot.moveTo(data[0][0],data[0][1]); 

        for (var i = 0; i< (size(data)-1); i=i+1)
        {
            var set = data[i+1];
	    if (set[2] == 1)
            	{plot.lineTo(set[0], set[1]);}
	    else
		{plot.moveTo(set[0], set[1]);}	
        }


}

var place_compass_label = func (group, text, angle, radius, flag, xoffset, yoffset) {

	var placement = SpaceShuttle.compass_label_pos(radius, angle);

	var text = group.createChild("text")
      	.setText(text)
        .setColor(1,1,1)
	.setFontSize(14)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setRotation(angle * math.pi/180.0 * flag)
	.setTranslation(placement[0] + xoffset,-placement[1] + yoffset);


}

var write_sphere_label = func (group, text, angle, coords) {


if (coords[2] ==1)
	{

	var text = group.createChild("text")
      	.setText(text)
        .setColor(1,1,1)
	.setFontSize(12)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setRotation(angle)
	.setTranslation(coords[0], coords[1]);
	}

}

var write_tape_label = func (group, text, coords) {


if (coords[2] ==1)
	{
	var text = group.createChild("text")
      	.setText(text)
        .setColor(0,0,0)
	.setFontSize(14)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setRotation(0.0)
	.setTranslation(coords[0], coords[1]);
	}

}


var PFD_addpage_p_pfd = func(device)
{
    var p_pfd = device.addPage("PFD", "p_pfd");
    
    #
    #
    # device page update
    p_pfd.group = device.svg.getElementById("p_pfd");
    p_pfd.group.setColor(1, 1, 1);

    p_pfd.keas = device.svg.getElementById("p_pfd_keas");
    p_pfd.beta = device.svg.getElementById("p_pfd_beta");

    
    p_pfd.ondisplay = func
    {
        device.set_DPS_off();
        device.dps_page_flag = 0;
        device.MEDS_menu_title.setText("FLIGHT INSTRUMENT MENU");

	# draw the fixed elements

	# ADI ################################################

	# upper compass rose

	var plot_compass_upper = device.symbols.createChild("path", "data")
        .setStrokeLineWidth(1)
        .setColor(1,1,1);

	var data = SpaceShuttle.draw_compass_scale(71.25,12, 1.1, 6, 1.05);
	pfd_segment_draw(data, plot_compass_upper);

	data = SpaceShuttle.draw_circle(71.25, 30);
	pfd_segment_draw(data, plot_compass_upper);

	data = SpaceShuttle.draw_circle(95.0, 30);
	pfd_segment_draw(data, plot_compass_upper);

	plot_compass_upper.setTranslation (255, 175);

	place_compass_label(device.symbols, "0", 0.0, 85.0, 0,255,180);
	place_compass_label(device.symbols, "33", 30.0, 85.0, 0,255,180);
	place_compass_label(device.symbols, "30", 60.0, 85.0, 0,255,180);
	place_compass_label(device.symbols, "27", 90.0, 85.0, 0,255,180);
	place_compass_label(device.symbols, "24", 120.0, 85.0, 0,255,180);
	place_compass_label(device.symbols, "21", 150.0, 85.0, 0,255,180);
	place_compass_label(device.symbols, "18", 180.0, 85.0, 0,255,180);
	place_compass_label(device.symbols, "15", 210.0, 85.0, 0,255,180);
	place_compass_label(device.symbols, "12", 240.0, 85.0, 0,255,180);
	place_compass_label(device.symbols, "9", 270.0, 85.0, 0,255,180);
	place_compass_label(device.symbols, "6", 300.0, 85.0, 0,255,180);
	place_compass_label(device.symbols, "3", 330.0, 85.0, 0,255,180);

	# nose position indicator

	data = [[0.0, -26.0, 0], [0.0, -26.0, 1], [0.0, 26.0,1], [-28.0,0.0,0],[-23.0,0.0,1],[23.0,0.0,0],[28.0,0.0,1], [-10,0,0], [-8.6, 5.0, 1], [-5.0, 8.6, 1], [0.0,10.0,1],[5.0,8.6,1],[8.6,5.0,1],[10.0,0.0,1]];
	var plot_cross_thick = device.symbols.createChild("path", "cross_thick")
        .setStrokeLineWidth(2)
        .setColor(0.4, 0.9, 0.7);
	pfd_segment_draw(data, plot_cross_thick);
	plot_cross_thick.setTranslation (255, 175);

	data = [[-23.0, 0.0, 0], [-23.0, 0.0, 1], [23.0,0.0,1]];
	var plot_cross_thin = device.symbols.createChild("path", "cross_thin")
        .setStrokeLineWidth(1)
        .setColor(0.4, 0.9, 0.7);
	pfd_segment_draw(data, plot_cross_thin);
	plot_cross_thin.setTranslation (255, 175);

	# ADI rate indicators ################################################

	# ADI rate ladders

	data = SpaceShuttle.draw_ladder (130, 3, 0.07, 4, 0.04, 0, 0 , 1);
	var plot_ADI_rate_roll = device.symbols.createChild("path", "ADI_rate_roll")
        .setStrokeLineWidth(1)
        .setColor(1, 1, 1);
	pfd_segment_draw(data, plot_ADI_rate_roll);
	plot_ADI_rate_roll.setTranslation(255, 70);

	data = SpaceShuttle.draw_ladder (130, 3, 0.07, 4, 0.04, 0, 1, 1);
	var plot_ADI_rate_yaw = device.symbols.createChild("path", "ADI_rate_yaw")
        .setStrokeLineWidth(1)
        .setColor(1, 1, 1);
	pfd_segment_draw(data, plot_ADI_rate_yaw);
	plot_ADI_rate_yaw.setTranslation(255, 280);

	data = SpaceShuttle.draw_ladder (130, 3, 0.07, 4, 0.04, 1, 1, 1);
	var plot_ADI_rate_pitch = device.symbols.createChild("path", "ADI_rate_pitch")
        .setStrokeLineWidth(1)
        .setColor(1, 1, 1);
	pfd_segment_draw(data, plot_ADI_rate_pitch);
	plot_ADI_rate_pitch.setTranslation(360, 175);

	# ADI rate needles

	data = SpaceShuttle.draw_tmarker_down();
	p_pfd.adi_roll_rate_needle = device.symbols.createChild("path", "ADI_roll_rate_needle")
        .setStrokeLineWidth(1)
        .setColor(0.4, 0.9, 0.7)
	.setColorFill(0.4, 0.9, 0.7)
	.moveTo(data[0][0], data[0][1]);
	for (var i = 0; (i< size(data)-1); i=i+1) 
		{p_pfd.adi_roll_rate_needle.lineTo(data[i+1][0], data[i+1][1]);}

	data = SpaceShuttle.draw_tmarker_left();
	p_pfd.adi_pitch_rate_needle = device.symbols.createChild("path", "ADI_pitch_rate_needle")
        .setStrokeLineWidth(1)
        .setColor(0.4, 0.9, 0.7)
	.setColorFill(0.4, 0.9, 0.7)
	.moveTo(data[0][0], data[0][1]);
	for (var i = 0; (i< size(data)-1); i=i+1) 
		{p_pfd.adi_pitch_rate_needle.lineTo(data[i+1][0], data[i+1][1]);}

	data = SpaceShuttle.draw_tmarker_up();
	p_pfd.adi_yaw_rate_needle = device.symbols.createChild("path", "ADI_yaw_rate_needle")
        .setStrokeLineWidth(1)
        .setColor(0.4, 0.9, 0.7)
	.setColorFill(0.4, 0.9, 0.7)
	.moveTo(data[0][0], data[0][1]);
	for (var i = 0; (i< size(data)-1); i=i+1) 
		{p_pfd.adi_yaw_rate_needle.lineTo(data[i+1][0], data[i+1][1]);}
	

	# HSI ################################################

	# lower HSI compass rose

	device.symbols.set("clip", "rect(0px, 512px, 460px, 0px)");
	device.HSI.set("clip", "rect(0px, 512px, 460px, 0px)");

	var plot_compass_lower = device.symbols.createChild("path", "data")
        .setStrokeLineWidth(1)
        .setColor(1,1,1);

	data = SpaceShuttle.draw_circle(95.0, 30);
	pfd_segment_draw(data, plot_compass_lower);

	data = SpaceShuttle.draw_compass_scale(95.0,8, 1.05, 1, 1.0);
	pfd_segment_draw(data, plot_compass_lower);
	plot_compass_lower.setTranslation (255, 425);


	# inner lower HSI compass rose 


	var plot_inner_compass_lower = device.HSI.createChild("path", "data")
        .setStrokeLineWidth(1)
	.setColorFill(0.5, 0.5, 0.5)
        .setColor(1,1,1);

	data = SpaceShuttle.draw_circle(84.0, 30);
	pfd_segment_draw(data, plot_inner_compass_lower);

	data = SpaceShuttle.draw_compass_scale(84,36, 0.9, 2, 0.95);
	pfd_segment_draw(data, plot_inner_compass_lower);

	data = SpaceShuttle.draw_circle(58.0, 30);
	pfd_segment_draw(data, plot_inner_compass_lower);

	place_compass_label(device.HSI, "N", 0.0, 63.0, 1,0,0);
	place_compass_label(device.HSI, "E", 90.0, 63.0, 1,0,0);
	place_compass_label(device.HSI, "S", 180.0, 63.0, 1,0,0);
	place_compass_label(device.HSI, "W", 270.0, 63.0, 1,0,0);
	place_compass_label(device.HSI, "3", 30.0, 63.0, 1,0,0);
	place_compass_label(device.HSI, "6", 60.0, 63.0, 1,0,0);
	place_compass_label(device.HSI, "12", 120.0, 63.0, 1,0,0);
	place_compass_label(device.HSI, "15", 150.0, 63.0, 1,0,0);
	place_compass_label(device.HSI, "21", 210.0, 63.0, 1,0,0);
	place_compass_label(device.HSI, "24", 240.0, 63.0, 1,0,0);    
	place_compass_label(device.HSI, "30", 300.0, 63.0, 1,0,0);
	place_compass_label(device.HSI, "33", 330.0, 63.0, 1,0,0);

	# KEAS tape ################################################



	# frame
	var plot_keas_tape = device.keas.createChild("path", "data")
        .setStrokeLineWidth(1)
        .setColor(1,1,1);
	data= SpaceShuttle.draw_rect(45, 190);
	pfd_segment_draw(data, plot_keas_tape);
	plot_keas_tape.setTranslation (70, 200);

	# inner tape

	p_pfd.keas_tape = device.keas.createChild("group");
	p_pfd.keas_tape.set("clip", "rect(105px, 92.5px, 295px, 47.5px)");

	p_pfd.keas_tape_background = p_pfd.keas_tape.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(1, 1, 1)
        .setColor(1,1,1);
	var data1 = SpaceShuttle.draw_rect(43, 10800);
	pfd_segment_draw(data1, p_pfd.keas_tape_background);

	p_pfd.keas_tape_ladder = p_pfd.keas_tape.createChild("path")
        .setStrokeLineWidth(1)
        .setColor(0,0,0);	
	data1 = SpaceShuttle.draw_ladder(10800, 280, 0.002592, 0, 0, 1, 1, 0);
	pfd_segment_draw(data1, p_pfd.keas_tape_ladder);
	p_pfd.keas_tape_ladder.setTranslation(-10,0);

	p_pfd.keas_tape.labels = p_pfd.keas_tape.createChild("group");
	draw_mach_labels(p_pfd.keas_tape.labels);

	# display box

	p_pfd.keas_display_box = device.keas.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(0, 0, 0)
        .setColor(1,1,1);
	data1= SpaceShuttle.draw_rect(48, 20);
	pfd_segment_draw(data1, p_pfd.keas_display_box);
	p_pfd.keas_display_box.setTranslation (70, 200);

	p_pfd.keas_display_text = device.keas.createChild("text")
	.setText("0.0")
        .setColor(1,1,1)
	.setFontSize(14)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setTranslation(70,205)
	.setRotation(0.0);




	
	

	# alpha tape ################################################

	var plot_alpha_tape = device.alpha.createChild("path", "data")
        .setStrokeLineWidth(1)
        .setColor(1,1,1);
	pfd_segment_draw(data, plot_alpha_tape);
	plot_alpha_tape.setTranslation (120, 200);

	# H tape

	var plot_H_tape = device.H.createChild("path", "data")
        .setStrokeLineWidth(1)
        .setColor(1,1,1);
	pfd_segment_draw(data, plot_H_tape);
	plot_H_tape.setTranslation (400, 200);

	# Hdot tape

	var plot_Hdot_tape = device.Hdot.createChild("path", "data")
        .setStrokeLineWidth(1)
        .setColor(1,1,1);
	pfd_segment_draw(data, plot_Hdot_tape);
	plot_Hdot_tape.setTranslation (450, 200);


	}

    
    p_pfd.offdisplay = func
    {
	device.symbols.removeAllChildren();
	device.HSI.removeAllChildren();
	device.H.removeAllChildren();
	device.Hdot.removeAllChildren();
	device.alpha.removeAllChildren();
	device.keas.removeAllChildren();
	device.nom_traj_plot.removeAllChildren();
	device.nom_traj_plot.setTranslation(0,0);
    }
    
    p_pfd.update = func
    {

        device.nom_traj_plot.removeAllChildren();

	var pitch = getprop("/orientation/pitch-deg");
	var yaw = getprop("/orientation/heading-deg");
	var roll = getprop("/orientation/roll-deg");

	var meridian_res = 90;
	var circle_res = 90;

	var data = SpaceShuttle.draw_meridian(0.0, 30, -pitch, yaw, -roll );

	var plot = device.nom_traj_plot.createChild("path", "data")
        .setStrokeLineWidth(1)
        .setColor(1,1,1);
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(30.0, meridian_res, -pitch, yaw, -roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(60.0, meridian_res, -pitch, yaw, -roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(90.0, meridian_res, -pitch, yaw, -roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(120.0, meridian_res, -pitch, yaw, -roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(150.0, meridian_res, -pitch, yaw, -roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(180.0, meridian_res, -pitch, yaw, -roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(270.0, meridian_res, -pitch, yaw, -roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(300.0, meridian_res, -pitch, yaw, -roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(330.0, meridian_res, -pitch, yaw, -roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_coord_circle(0.0, circle_res, -pitch, yaw, -roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_coord_circle(30.0, circle_res, -pitch, yaw, -roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_coord_circle(-30.0, circle_res, -pitch, yaw, -roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_coord_circle(60.0, circle_res, -pitch, yaw, -roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_coord_circle(-60.0, circle_res, -pitch, yaw, -roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_coord_circle(85.0, circle_res, -pitch, yaw, -roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_coord_circle(-85.0, circle_res, -pitch, yaw, -roll );
	pfd_segment_draw(data, plot);

	# projection vecs for labels
	var p_vecs = SpaceShuttle.projection_vecs(-pitch, yaw, -roll);

	draw_sphere_labels(device.nom_traj_plot, p_vecs, roll);
	
	# ADI rate needles

	var roll_rate = getprop("/fdm/jsbsim/velocities/p-rad_sec") * 57.2957;
	roll_rate = SpaceShuttle.clamp(roll_rate, -5.0, 5.0);
	p_pfd.adi_roll_rate_needle.setTranslation(255 + 13.0 * roll_rate, 70);

	var pitch_rate = getprop("/fdm/jsbsim/velocities/q-rad_sec") * 57.2957;
	pitch_rate = SpaceShuttle.clamp(pitch_rate, -5.0, 5.0);
	p_pfd.adi_pitch_rate_needle.setTranslation(360, 175 - 13.0 * pitch_rate);

	var yaw_rate = getprop("/fdm/jsbsim/velocities/r-rad_sec") * 57.2957;
	yaw_rate = SpaceShuttle.clamp(yaw_rate, -5.0, 5.0);
	p_pfd.adi_yaw_rate_needle.setTranslation(255+13.0 * yaw_rate, 280.0);

	device.nom_traj_plot.setTranslation (255, 175);

	device.HSI.setRotation(-yaw * math.pi/180.0);
	device.HSI.setTranslation (255, 425);
    
	# KEAS /Mach tape

	var mach = getprop("/fdm/jsbsim/velocities/mach");
	p_pfd.keas_tape.setTranslation (70, 200 - 5400 + 381.0 * mach);       
	p_pfd.keas_display_text.setText(sprintf("%2.1f",mach));


        p_pfd.beta.setText(sprintf("%1.1f",getprop("/fdm/jsbsim/aero/beta-deg")));
        p_pfd.keas.setText(sprintf("%3.0f",getprop("/velocities/equivalent-kt")));
    };
    
    return p_pfd;
}




# batch functions for label drawing

var label_from_degree = func (angle, flag) {

if (angle == 0.0) 
	{
	if (flag == 1) {return "N";}
	else {return "0";}
	}
else if (angle == 30.0)
	{return "3";}
else if (angle == 60.0)
	{return "6";}
else if (angle == 90.0)
	{
	if (flag == 1) {return "E";}	
	else	{return "9";}
	}
else if (angle == 120.0)
	{return "12";}
else if (angle == 15.0)
	{return "15";}
else if (angle == 180.0)
	{
	if (flag == 1) {return "S";}
	else {return "18";}
	}
else if (angle == 210.0)
	{return "21";}
else if (angle == 240.0)
	{return "24";}
else if (angle == 270.0)
	{	
	if (flag == 1) {return "W";}
	else {return "27";}
	}
else if (angle == 300.0)
	{return "30";}
else if (angle == 330.0)
	{return "33";}
else return "";
}


var draw_sphere_labels = func (group, p_vecs, roll) {

var coords = [];
var label = "";
var lon = 0;


var lat = 15;
for (var i=0; i< 12; i=i+1)
	{
	lon = 30.0 * i;
	label = label_from_degree(lon, 0);
	coords = SpaceShuttle.label_coords_sphere(lat, lon, p_vecs);
	write_sphere_label(group, label, -roll * math.pi/180.0, coords);
	}

var lat = 45;
for (var i=0; i< 12; i=i+1)
	{
	lon = 30.0 * i;
	label = label_from_degree(lon, 0);
	coords = SpaceShuttle.label_coords_sphere(lat, lon, p_vecs);
	write_sphere_label(group, label, -roll * math.pi/180.0, coords);
	}

var lat = -15;
for (var i=0; i< 12; i=i+1)
	{
	lon = 30.0 * i;
	label = label_from_degree(lon, 0);
	coords = SpaceShuttle.label_coords_sphere(lat, lon, p_vecs);
	write_sphere_label(group, label, -roll * math.pi/180.0, coords);
	}

var lat = -45;
for (var i=0; i< 12; i=i+1)
	{
	lon = 30.0 * i;
	label = label_from_degree(lon, 0);
	coords = SpaceShuttle.label_coords_sphere(lat, lon, p_vecs);
	write_sphere_label(group, label, -roll * math.pi/180.0, coords);
	}

}

var draw_mach_labels = func (group)
{

for (var i=0; i< 140; i=i+1)
	{
	var y = 5385 - i * 76.0;
	var coords = [0.0, y, 1];

	var label = sprintf("%2.1f", 0.2 * i);

	write_tape_label(group, label, coords);
	}

}


