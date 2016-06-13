#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_pfd
# Description: PFD page
#      Author: Thorsten Renk, 2015
#---------------------------------------

var pfd_segment_draw = func (data, plot) {

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
    p_pfd.group.setColor(dps_r, dps_g, dps_b);

    p_pfd.keas = device.svg.getElementById("p_pfd_keas");
    p_pfd.beta = device.svg.getElementById("p_pfd_beta");
    
    p_pfd.ondisplay = func
    {
        device.set_DPS_off();
        device.dps_page_flag = 0;
        device.MEDS_menu_title.setText("FLIGHT INSTRUMENT MENU");
    }
    
    
    p_pfd.update = func
    {

        device.nom_traj_plot.removeAllChildren();

	var pitch = getprop("/orientation/pitch-deg");
	var yaw = getprop("/orientation/heading-deg");
	var roll = getprop("/orientation/roll-deg");

	var data = SpaceShuttle.draw_meridian(0.0, 30, pitch, yaw, roll );

	var plot = device.nom_traj_plot.createChild("path", "data")
        .setStrokeLineWidth(2)
        .setColor(dps_r,dps_g,dps_b)
        .moveTo(data[0][0],data[0][1]); 
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(30.0, 30, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(60.0, 30, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(90.0, 30, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(120.0, 30, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(150.0, 30, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(180.0, 30, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(270.0, 30, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(300.0, 30, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_meridian(330.0, 30, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_coord_circle(0.0, 30, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_coord_circle(30.0, 30, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_coord_circle(-30.0, 30, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_coord_circle(60.0, 15, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_coord_circle(-60.0, 15, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_coord_circle(85.0, 15, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	data = SpaceShuttle.draw_coord_circle(-85.0, 15, pitch, yaw, roll );
	pfd_segment_draw(data, plot);

	plot.setTranslation (265, 265);
    
       
        p_pfd.beta.setText(sprintf("%5.1f",getprop("fdm/jsbsim/aero/beta-deg")));
        p_pfd.keas.setText(sprintf("%5.0f",getprop("velocities/airspeed-kt")));
    };
    
    return p_pfd;
}
