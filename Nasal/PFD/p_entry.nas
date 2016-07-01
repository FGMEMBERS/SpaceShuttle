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
    p_entry.hdot_bias = device.svg.getElementById("p_entry_hdot_bias");    
    p_entry.hdot_ref = device.svg.getElementById("p_entry_hdot_ref");    
    p_entry.ny = device.svg.getElementById("p_entry_ny");   
    p_entry.ny_trim = device.svg.getElementById("p_entry_ny_trim");
    p_entry.ail_trim = device.svg.getElementById("p_entry_ail_trim");     
    p_entry.rud_trim = device.svg.getElementById("p_entry_rud_trim"); 
    p_entry.low_energy = device.svg.getElementById("p_entry_low_energy");
    p_entry.loe_label_bright = device.svg.getElementById("p_entry_loe_label_bright");
                       

    p_entry.alabel1 = device.svg.getElementById("p_entry_alabel1");
    p_entry.alabel2 = device.svg.getElementById("p_entry_alabel2");
    p_entry.alabel3 = device.svg.getElementById("p_entry_alabel3");
    p_entry.alabel4 = device.svg.getElementById("p_entry_alabel4");
    p_entry.alabel5 = device.svg.getElementById("p_entry_alabel5");
    p_entry.alabel6 = device.svg.getElementById("p_entry_alabel6");

    p_entry.ondisplay = func
    {
        # called once whenever this page goes on display
    
        p_entry.bias.setText("+00");
        device.MEDS_menu_title.setText("       DPS MENU");

	# draw defaults

	p_entry.ny_trim.setText("0.000");
	p_entry.ail_trim.setText("0.0");
	p_entry.rud_trim.setText("0.0");
	p_entry.loe_label_bright.setVisible(0);

	# acquire the symbols we'd like to draw

	var data = SpaceShuttle.draw_triangle_down();
	
	 p_entry.marker1 = device.symbols.createChild("path", "m1")
        .setStrokeLineWidth(1)
        .setColor(0.8, 0.8, 0.4)
	.moveTo(data[0][0], data[0][1]);

	p_entry.marker2 = device.symbols.createChild("path", "m2")
        .setStrokeLineWidth(1)
        .setColor(0.8, 0.8, 0.4)
	.moveTo(data[0][0], data[0][1]);

	p_entry.marker3 = device.symbols.createChild("path", "m3")
        .setStrokeLineWidth(1)
        .setColor(0.8, 0.8, 0.4)
	.moveTo(data[0][0], data[0][1]);

	p_entry.marker4 = device.symbols.createChild("path", "m4")
        .setStrokeLineWidth(1)
        .setColor(0.8, 0.8, 0.4)
	.moveTo(data[0][0], data[0][1]);

	p_entry.marker5 = device.symbols.createChild("path", "m5")
        .setStrokeLineWidth(1)
        .setColor(0.8, 0.8, 0.4)
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
        .setColor(0.8, 0.8, 0.4)
	.moveTo(data[0][0], data[0][1]);

	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_entry.shuttle_sym.lineTo(set[0], set[1]);
		}

	p_entry.shuttle_sym.setScale(6.0);

	setsize(data,0);

	data = SpaceShuttle.draw_tmarker_right();
	p_entry.alpha = device.symbols.createChild("path", "alpha")
        .setStrokeLineWidth(1.0)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(data[0][0], data[0][1]);

	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_entry.alpha.lineTo(set[0], set[1]);
		}

	setsize(data,0);

	data = SpaceShuttle.draw_arrowmarker_right();
	p_entry.alpha_nom = device.symbols.createChild("path", "alpha_nom")
        .setStrokeLineWidth(1.0)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(data[0][0], data[0][1]);

	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_entry.alpha_nom.lineTo(set[0], set[1]);
		}


	setsize(data,0);

	data = SpaceShuttle.draw_tmarker_down();
	p_entry.phug = device.symbols.createChild("path")
        .setStrokeLineWidth(1.0)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(data[0][0], data[0][1]);

	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_entry.phug.lineTo(set[0], set[1]);
		}


	
	
    }
    
    p_entry.offdisplay = func
    {
        device.nom_traj_plot.removeAllChildren();
	
	device.symbols.removeAllChildren();
        device.set_DPS_off();
    }
    
    p_entry.update = func
    {
    
    
    
        device.update_common_DPS();
    
    
        device.nom_traj_plot.removeAllChildren();
    
        SpaceShuttle.ascent_traj_update_set();
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
	var alpha_max = 50.0;
	var alpha_min = 25.0;
    
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
	    p_entry.alabel1.setText("45");
	    p_entry.alabel2.setText("40");
	    p_entry.alabel3.setText("35");
	    p_entry.alabel4.setText("30");
	    p_entry.alabel5.setText("25");
	    p_entry.alabel6.setText("20");
	    alpha_max = 45.0;
	    alpha_min = 20.0;
    	}
        else if (( SpaceShuttle.traj_display_flag == 6) and (major_mode == 304))
    	{
            device.DPS_menu_title.setText("ENTRY TRAJ 4");
	    p_entry.alabel1.setText("45");
	    p_entry.alabel2.setText("40");
	    p_entry.alabel3.setText("35");
	    p_entry.alabel4.setText("30");
	    p_entry.alabel5.setText("25");
	    p_entry.alabel6.setText("20");
	    alpha_max = 45.0;
	    alpha_min = 20.0;
    	}
        else if ((SpaceShuttle.traj_display_flag == 7)and (major_mode == 304))
    	{
            device.DPS_menu_title.setText("ENTRY TRAJ 5");
	    p_entry.alabel1.setText("30");
	    p_entry.alabel2.setText("25");
	    p_entry.alabel3.setText("20");
	    p_entry.alabel4.setText("15");
	    p_entry.alabel5.setText("10");
	    p_entry.alabel6.setText(" 5");
	    alpha_max = 30.0;
	    alpha_min = 5.0;
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
    
	var alpha_act = getprop("/fdm/jsbsim/aero/alpha-deg");
	var alpha_nom = getprop("/fdm/jsbsim/systems/entry_guidance/nominal-alpha-deg");
	#var alpha_nom = getprop("/fdm/jsbsim/systems/ap/entry/drag-target-alpha-rad") * 180.0/math.pi;

	alpha_act = SpaceShuttle.clamp(alpha_act, alpha_min, alpha_max);
	alpha_nom = SpaceShuttle.clamp(alpha_nom, alpha_min, alpha_max);

	var alpha_fract = (alpha_act - alpha_min)/(alpha_max - alpha_min);
	var alpha_nom_fract = (alpha_nom - alpha_min)/(alpha_max - alpha_min);

	p_entry.alpha.setTranslation(48.0, 360.0 - 270 * alpha_fract);
	p_entry.alpha_nom.setTranslation(38.0, 360.0 - 270 * alpha_nom_fract);

	var roll = getprop("/orientation/roll-deg");
	var roll_error = getprop("/fdm/jsbsim/systems/ap/entry/bank-angle-target-deg") - roll;
	roll_error = SpaceShuttle.clamp(roll_error, -15.0, 15.0);	

	p_entry.phug.setTranslation(170.0 + 4.0 * roll_error, 80.0);
    
        var range = getprop("/fdm/jsbsim/systems/entry_guidance/remaining-distance-nm");
	range = range - 20.0; # bias to get better match to TAEM
        var x = SpaceShuttle.parameter_to_x(range, SpaceShuttle.traj_display_flag);
        var y = SpaceShuttle.parameter_to_y(velocity, SpaceShuttle.traj_display_flag);
	p_entry.shuttle_sym.setTranslation(x,y);

	x = SpaceShuttle.parameter_to_x(SpaceShuttle.trailer_set.entry[0][0] -20.0, SpaceShuttle.traj_display_flag);
	y = SpaceShuttle.parameter_to_y(SpaceShuttle.trailer_set.entry[0][1], SpaceShuttle.traj_display_flag);
    	p_entry.marker1.setTranslation(x,y);

	x = SpaceShuttle.parameter_to_x(SpaceShuttle.trailer_set.entry[1][0] -20.0, SpaceShuttle.traj_display_flag);
	y = SpaceShuttle.parameter_to_y(SpaceShuttle.trailer_set.entry[1][1], SpaceShuttle.traj_display_flag);
    	p_entry.marker2.setTranslation(x,y);

	x = SpaceShuttle.parameter_to_x(SpaceShuttle.trailer_set.entry[2][0] -20.0, SpaceShuttle.traj_display_flag);
	y = SpaceShuttle.parameter_to_y(SpaceShuttle.trailer_set.entry[2][1], SpaceShuttle.traj_display_flag);
    	p_entry.marker3.setTranslation(x,y);

	x = SpaceShuttle.parameter_to_x(SpaceShuttle.trailer_set.entry[3][0] -20.0, SpaceShuttle.traj_display_flag);
	y = SpaceShuttle.parameter_to_y(SpaceShuttle.trailer_set.entry[3][1], SpaceShuttle.traj_display_flag);
    	p_entry.marker4.setTranslation(x,y);

	x = SpaceShuttle.parameter_to_x(SpaceShuttle.trailer_set.entry[4][0] -20.0, SpaceShuttle.traj_display_flag);
	y = SpaceShuttle.parameter_to_y(SpaceShuttle.trailer_set.entry[4][1], SpaceShuttle.traj_display_flag);
    	p_entry.marker5.setTranslation(x,y);
    
        p_entry.D_az.setText(sprintf("%3.0f",getprop("/fdm/jsbsim/systems/entry_guidance/delta-azimuth-deg")));
        p_entry.qbar.setText(sprintf("%3.1f",getprop("/fdm/jsbsim/aero/qbar-psf")));
        p_entry.dref.setText(sprintf("%3.1f",-32.18 * getprop("/accelerations/nlf")));
    
	var vspeed_target = getprop("/fdm/jsbsim/systems/ap/entry/vspeed-target-fps");

	var vspeed_ref = 230.0;
	var vspeed_bias = vspeed_target - vspeed_ref;

	p_entry.hdot_bias.setText(sprintf("%+3.0f", vspeed_bias));
	p_entry.hdot_ref.setText(sprintf("%+3.0f", vspeed_ref));
	p_entry.ny.setText(sprintf("%1.3f", getprop("/fdm/jsbsim/accelerations/Ny")));

	var low_energy = getprop("/fdm/jsbsim/systems/ap/entry/low-energy-logic");

	if (low_energy == 0) 
		{
		p_entry.low_energy.setText("INH");
		p_entry.loe_label_bright.setVisible(0);
		}
	else 
		{
		p_entry.low_energy.setText("ENA");
		p_entry.loe_label_bright.setVisible(1);
		}

    };
    
    
    
    return p_entry;
}
