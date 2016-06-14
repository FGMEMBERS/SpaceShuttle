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

	var data = SpaceShuttle.draw_compass_scale(67.5,12, 1.1, 6, 1.05);
	pfd_segment_draw(data, plot_compass_upper);

	data = SpaceShuttle.draw_circle(67.5, 30);
	pfd_segment_draw(data, plot_compass_upper);

	data = SpaceShuttle.draw_circle(90.0, 30);
	pfd_segment_draw(data, plot_compass_upper);

	plot_compass_upper.setTranslation (255, 175);

	# lower HSI compass rose

	device.symbols.set("clip", "rect(0px, 512px, 460px, 0px)");

	var plot_compass_lower = device.symbols.createChild("path", "data")
        .setStrokeLineWidth(1)
        .setColor(1,1,1);

	data = SpaceShuttle.draw_circle(90.0, 30);
	pfd_segment_draw(data, plot_compass_lower);

	data = SpaceShuttle.draw_compass_scale(90.0,8, 1.05, 1, 1.0);
	pfd_segment_draw(data, plot_compass_lower);
	plot_compass_lower.setTranslation (255, 425);


	# inner lower HSI compass rose

	var plot_inner_compass_lower = device.symbols.createChild("path", "data")
        .setStrokeLineWidth(1)
	.setColorFill(0.5, 0.5, 0.5)
        .setColor(1,1,1);

	data = SpaceShuttle.draw_circle(80.0, 30);
	pfd_segment_draw(data, plot_inner_compass_lower);

	data = SpaceShuttle.draw_compass_scale(80,36, 0.9, 2, 0.95);
	pfd_segment_draw(data, plot_inner_compass_lower);

	data = SpaceShuttle.draw_circle(55.0, 30);
	pfd_segment_draw(data, plot_inner_compass_lower);

	plot_inner_compass_lower.setTranslation (255, 425);

    }
    
    p_pfd.offdisplay = func
    {
	device.symbols.removeAllChildren();
	device.nom_traj_plot.removeAllChildren();
    }
    
    p_pfd.update = func
    {

        device.nom_traj_plot.removeAllChildren();

	var pitch = getprop("/orientation/pitch-deg");
	var yaw = getprop("/orientation/heading-deg");
	var roll = getprop("/orientation/roll-deg");

	var meridian_res = 90;
	var circle_res = 90;

	var data = SpaceShuttle.draw_meridian(0.0, 30, pitch, yaw, roll );

	var plot = device.nom_traj_plot.createChild("path", "data")
        .setStrokeLineWidth(2)
        .setColor(1,1,1);
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(30.0, meridian_res, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(60.0, meridian_res, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(90.0, meridian_res, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(120.0, meridian_res, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(150.0, meridian_res, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(180.0, meridian_res, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(270.0, meridian_res, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(300.0, meridian_res, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(330.0, meridian_res, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_coord_circle(0.0, circle_res, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_coord_circle(30.0, circle_res, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_coord_circle(-30.0, circle_res, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_coord_circle(60.0, circle_res, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_coord_circle(-60.0, circle_res, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_coord_circle(85.0, circle_res, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_coord_circle(-85.0, circle_res, pitch, yaw, roll );
	pfd_segment_draw(data, plot);



	plot.setTranslation (255, 175);
    
       
        p_pfd.beta.setText(sprintf("%5.1f",getprop("fdm/jsbsim/aero/beta-deg")));
        p_pfd.keas.setText(sprintf("%5.0f",getprop("velocities/airspeed-kt")));
    };
    
    return p_pfd;
}
