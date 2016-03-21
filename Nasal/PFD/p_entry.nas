#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_entry
# Description: the entry PFD page showing the vertical trajectory status
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_entry = func(device)
{
    var p_entry = device.addPage("Entry", "p_entry");

    p_entry.group = device.svg.getElementById("p_entry");
    p_entry.group.setColor(dps_r, dps_g, dps_b);
    
    p_entry.D_az = device.svg.getElementById("p_entry_D_az");
    p_entry.qbar = device.svg.getElementById("p_entry_qbar");
    p_entry.dref = device.svg.getElementById("p_entry_dref");
    p_entry.bias = device.svg.getElementById("p_entry_bias");
    
    
    
    
    p_entry.ondisplay = func
    {
        # called once whenever this page goes on display
    
        p_entry.bias.setText("+00");
        device.MEDS_menu_title.setText("       DPS MENU");

	# acquire the symbols we'd like to draw

	var data = SpaceShuttle.draw_triangle_down();
	
	 p_entry.marker1 = device.symbols.createChild("path", "m1")
        .setStrokeLineWidth(1)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(data[0][0], data[0][1]);

	p_entry.marker2 = device.symbols.createChild("path", "m2")
        .setStrokeLineWidth(1)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(data[0][0], data[0][1]);

	p_entry.marker3 = device.symbols.createChild("path", "m3")
        .setStrokeLineWidth(1)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(data[0][0], data[0][1]);

	p_entry.marker4 = device.symbols.createChild("path", "m4")
        .setStrokeLineWidth(1)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(data[0][0], data[0][1]);

	p_entry.marker5 = device.symbols.createChild("path", "m5")
        .setStrokeLineWidth(1)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(data[0][0], data[0][1]);

	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_entry.marker1.lineTo(set[0], set[1]);
		p_entry.marker2.lineTo(set[0], set[1]);
		p_entry.marker3.lineTo(set[0], set[1]);
		p_entry.marker4.lineTo(set[0], set[1]);
		p_entry.marker5.lineTo(set[0], set[1]);
		}

	setsize(data, 0);

	data = SpaceShuttle.draw_shuttle_side();
	 
	p_entry.shuttle_sym = device.symbols.createChild("path", "shuttle_sym")
        .setStrokeLineWidth(0.25)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(data[0][0], data[0][1]);

	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_entry.shuttle_sym.lineTo(set[0], set[1]);
		}

	p_entry.shuttle_sym.setScale(6.0);


	
	
    }
    
    p_entry.offdisplay = func
    {
        device.nom_traj_plot.removeAllChildren();
        device.p_ascent_shuttle_sym.setScale(0.0);
     
	
	device.symbols.removeAllChildren();
        device.set_DPS_off();
    }
    
    p_entry.update = func
    {
    
    
    
        device.update_common_DPS();
    
    
        device.nom_traj_plot.removeAllChildren();
    
        SpaceShuttle.ascent_traj_update_set();
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
    
        if  ((SpaceShuttle.traj_display_flag == 3) and (major_mode == 304))
    	{
            device.DPS_menu_title.setText("ENTRY TRAJ 1");
            device.DPS_menu_ops.setText("3041/     /");
    	}
        else if ((SpaceShuttle.traj_display_flag == 4) and (major_mode == 304))
    	{
            device.DPS_menu_title.setText("ENTRY TRAJ 2");
    	}
        else if ((SpaceShuttle.traj_display_flag == 5) and (major_mode == 304))
    	{
            device.DPS_menu_title.setText("ENTRY TRAJ 3");
    	}
        else if (( SpaceShuttle.traj_display_flag == 6) and (major_mode == 304))
    	{
            device.DPS_menu_title.setText("ENTRY TRAJ 4");
    	}
        else if ((SpaceShuttle.traj_display_flag == 7)and (major_mode == 304))
    	{
            device.DPS_menu_title.setText("ENTRY TRAJ 5");
    	}
    
    
    
        var plot = device.nom_traj_plot.createChild("path", "data")
        .setStrokeLineWidth(2)
        .setColor(dps_r, dps_g, dps_b)
        .moveTo(traj_data[0][0],traj_data[0][1]); 
    
        for (var i = 1; i< (size(traj_data)-1); i=i+1)
        {
            var set = traj_data[i+1];
            plot.lineTo(set[0], set[1]);	
        }
    
        var velocity = SpaceShuttle.ascent_traj_update_velocity();
        var altitude = getprop("/position/altitude-ft");
    
    
        var range = getprop("/fdm/jsbsim/systems/entry_guidance/remaining-distance-nm");
        var x = SpaceShuttle.parameter_to_x(range, SpaceShuttle.traj_display_flag);
        var y = SpaceShuttle.parameter_to_y(velocity, SpaceShuttle.traj_display_flag);
        #device.p_ascent_shuttle_sym.setTranslation(x,y);
	p_entry.shuttle_sym.setTranslation(x,y);

	x = SpaceShuttle.parameter_to_x(SpaceShuttle.trailer_set.entry[0][0], SpaceShuttle.traj_display_flag);
	y = SpaceShuttle.parameter_to_y(SpaceShuttle.trailer_set.entry[0][1], SpaceShuttle.traj_display_flag);
    	p_entry.marker1.setTranslation(x,y);

	x = SpaceShuttle.parameter_to_x(SpaceShuttle.trailer_set.entry[1][0], SpaceShuttle.traj_display_flag);
	y = SpaceShuttle.parameter_to_y(SpaceShuttle.trailer_set.entry[1][1], SpaceShuttle.traj_display_flag);
    	p_entry.marker2.setTranslation(x,y);

	x = SpaceShuttle.parameter_to_x(SpaceShuttle.trailer_set.entry[2][0], SpaceShuttle.traj_display_flag);
	y = SpaceShuttle.parameter_to_y(SpaceShuttle.trailer_set.entry[2][1], SpaceShuttle.traj_display_flag);
    	p_entry.marker3.setTranslation(x,y);

	x = SpaceShuttle.parameter_to_x(SpaceShuttle.trailer_set.entry[3][0], SpaceShuttle.traj_display_flag);
	y = SpaceShuttle.parameter_to_y(SpaceShuttle.trailer_set.entry[3][1], SpaceShuttle.traj_display_flag);
    	p_entry.marker4.setTranslation(x,y);

	x = SpaceShuttle.parameter_to_x(SpaceShuttle.trailer_set.entry[4][0], SpaceShuttle.traj_display_flag);
	y = SpaceShuttle.parameter_to_y(SpaceShuttle.trailer_set.entry[4][1], SpaceShuttle.traj_display_flag);
    	p_entry.marker5.setTranslation(x,y);
    
        p_entry.D_az.setText(sprintf("%3.0f",getprop("/fdm/jsbsim/systems/entry_guidance/delta-azimuth-deg")));
        p_entry.qbar.setText(sprintf("%3.1f",getprop("/fdm/jsbsim/aero/qbar-psf")));
        p_entry.dref.setText(sprintf("%3.1f",-32.18 * getprop("/accelerations/nlf")));
    
    };
    
    
    
    return p_entry;
}
