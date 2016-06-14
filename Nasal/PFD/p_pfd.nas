#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_pfd
# Description: PFD page
#      Author: Thorsten Renk, 2015
#---------------------------------------

var pfd_segment_draw = func (data, plot) {

	if (size(data) < 2) {return;}

	plot.moveTo(data[0][0],data[0][1]); 

        for (var i = 1; i< (size(data)-1); i=i+1)
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

	}

    
    p_pfd.offdisplay = func
    {
	device.symbols.removeAllChildren();
	device.HSI.removeAllChildren();
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

	var coords = SpaceShuttle.label_coords_sphere(15.0, 0.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "0", 0.0, coords);

	coords = SpaceShuttle.label_coords_sphere(15.0, 30.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "3", 0.0, coords);

	coords = SpaceShuttle.label_coords_sphere(15.0, 60.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "6", 0.0, coords);

	coords = SpaceShuttle.label_coords_sphere(15.0, 90.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "9", 0.0, coords);

	coords = SpaceShuttle.label_coords_sphere(15.0, 120.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "12", 0.0, coords);

	coords = SpaceShuttle.label_coords_sphere(15.0, 150.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "15", 0.0, coords);

	coords = SpaceShuttle.label_coords_sphere(15.0, 180.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "18", 0.0, coords);

	coords = SpaceShuttle.label_coords_sphere(15.0, 210.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "21", 0.0, coords);

	coords = SpaceShuttle.label_coords_sphere(15.0, 240.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "24", 0.0, coords);

	coords = SpaceShuttle.label_coords_sphere(15.0, 270.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "27", 0.0, coords);

	coords = SpaceShuttle.label_coords_sphere(15.0, 300.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "30", 0.0, coords);

	coords = SpaceShuttle.label_coords_sphere(15.0, 330.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "33", 0.0, coords);

	coords = SpaceShuttle.label_coords_sphere(-15.0, 0.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "0", 0.0, coords);

	coords = SpaceShuttle.label_coords_sphere(-15.0, 30.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "3", 0.0, coords);

	coords = SpaceShuttle.label_coords_sphere(-15.0, 60.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "6", 0.0, coords);

	coords = SpaceShuttle.label_coords_sphere(-15.0, 90.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "9", 0.0, coords);

	coords = SpaceShuttle.label_coords_sphere(-15.0, 120.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "12", 0.0, coords);

	coords = SpaceShuttle.label_coords_sphere(-15.0, 150.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "15", 0.0, coords);

	coords = SpaceShuttle.label_coords_sphere(-15.0, 180.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "18", 0.0, coords);

	coords = SpaceShuttle.label_coords_sphere(-15.0, 210.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "21", 0.0, coords);

	coords = SpaceShuttle.label_coords_sphere(-15.0, 240.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "24", 0.0, coords);

	coords = SpaceShuttle.label_coords_sphere(-15.0, 270.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "27", 0.0, coords);

	coords = SpaceShuttle.label_coords_sphere(-15.0, 300.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "30", 0.0, coords);

	coords = SpaceShuttle.label_coords_sphere(-15.0, 330.0, p_vecs);
	write_sphere_label(device.nom_traj_plot, "33", 0.0, coords);

	device.nom_traj_plot.setTranslation (255, 175);

	device.HSI.setRotation(-yaw * math.pi/180.0);
	device.HSI.setTranslation (255, 425);
    
       
        p_pfd.beta.setText(sprintf("%5.1f",getprop("fdm/jsbsim/aero/beta-deg")));
        p_pfd.keas.setText(sprintf("%5.0f",getprop("velocities/airspeed-kt")));
    };
    
    return p_pfd;
}
