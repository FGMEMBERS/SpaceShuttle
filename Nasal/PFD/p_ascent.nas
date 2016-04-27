#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_ascent
# Description: the ascent PFD page showing the vertical trajectory status
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_ascent = func(device)
{
    var p_ascent = device.addPage("Ascent", "p_ascent");
    
    #
    #
    # Ascent page update
    # var p_ascent_view = device.svg.getElementById("ascent_view");
    SpaceShuttle.fill_traj1_data();
    var p_ascent_time = 0;
    var p_ascent_next_update = 0;
    
    
    #device.p_ascent_shuttle_sym = device._canvas.createGroup();
    #canvas.parsesvg( device.p_ascent_shuttle_sym, "/Nasal/canvas/map/Images/boeingAirplane.svg");
    #device.p_ascent_shuttle_sym.setScale(0.3);
    #device.p_ascent_shuttle_sym.setColor(dps_r, dps_g, dps_b);
    
    p_ascent.group = device.svg.getElementById("p_ascent");
    p_ascent.group.setColor(dps_r, dps_g, dps_b);

    p_ascent.throttle = device.svg.getElementById("p_ascent_throttle");
    p_ascent.throttle_text = device.svg.getElementById("p_ascent_throttle_txt");
    
    p_ascent.prplt = device.svg.getElementById("p_ascent_prplt");
    p_ascent.prplt_text = device.svg.getElementById("p_ascent_prplt_txt");

    p_ascent.vco  = device.svg.getElementById("p_ascent_vco");
    p_ascent.vcoscale_co = device.svg.getElementById("p_ascent_vcoscale_co");
    p_ascent.vcoscale_labelco = device.svg.getElementById("p_ascent_vcoscale_labelco");

    p_ascent.serc = device.svg.getElementById("p_ascent_serc");
    p_ascent.serc_on = device.svg.getElementById("p_ascent_serc_on");

    p_ascent.ondisplay = func
    {
        # called once whenever this page goes on display/
         #device.p_ascent_shuttle_sym.setScale(0.3);
        device.MEDS_menu_title.setText(sprintf("%s","       DPS MENU"));

	# generate the symbols for the graphical part of the display

	var data = SpaceShuttle.draw_triangle_up();
	
	 p_ascent.shuttle_marker = device.symbols.createChild("path", "shuttle_marker")
        .setStrokeLineWidth(2)
        .setColor(0.8, 0.8, 0.4)
	.moveTo(data[0][0], data[0][1]);

 	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_ascent.shuttle_marker.lineTo(set[0], set[1]);
		}

	setsize(data,0);

	data = SpaceShuttle.draw_circle(3, 10);

	p_ascent.pred1 = device.symbols.createChild("path", "pred1")
        .setStrokeLineWidth(1)
        .setColor(0.8, 0.8, 0.4)
	.moveTo(data[0][0], data[0][1]);

	 p_ascent.pred2 = device.symbols.createChild("path", "pred2")
        .setStrokeLineWidth(1)
        .setColor(0.8, 0.8, 0.4)
	.moveTo(data[0][0], data[0][1]);

	p_ascent.pred2.setVisible(0);


	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_ascent.pred1.lineTo(set[0], set[1]);
		p_ascent.pred2.lineTo(set[0], set[1]);
		}

	setsize(data,0);

	data = SpaceShuttle.draw_tmarker_down();

	p_ascent.vco_marker = device.symbols.createChild("path", "vco_marker")
        .setStrokeLineWidth(1)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(data[0][0], data[0][1]);

	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_ascent.vco_marker.lineTo(set[0], set[1]);
		}

	p_ascent.vco_marker.setTranslation(78.0 + 0.0 * 400.0 ,92.0);
	
	var co_shift = (25850.0-25000.0)/1000.0;
	p_ascent.vcoscale_co.setTranslation( co_shift * 400.0, 0.0);
    	p_ascent.vcoscale_labelco.setTranslation( co_shift * 400.0, 0.0);

	p_ascent.vco.setVisible(0);
	p_ascent.vco_marker.setVisible(0);

    }
    
    p_ascent.offdisplay = func
    {
        device.nom_traj_plot.removeAllChildren();
    	device.symbols.removeAllChildren();
        #device.p_ascent_shuttle_sym.setScale(0.0);
    
        device.set_DPS_off();
    }
    
    p_ascent.update = func
    {
    
        device.update_common_DPS();
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        if (SpaceShuttle.traj_display_flag < 3)
    	{
            var throttle = getprop("/fdm/jsbsim/fcs/throttle-pos-norm");
	    if (throttle == 0 ){throttle = getprop("/fdm/jsbsim/fcs/throttle-pos-norm[1]");}
	    if (throttle == 0 ){throttle = getprop("/fdm/jsbsim/fcs/throttle-pos-norm[2]");}
            if (throttle < 0.61) {throttle = 0.0;} else {throttle = throttle * 100.0;}
            p_ascent.throttle.setText(sprintf("%3.0f",throttle));
            p_ascent.throttle_text.setText(sprintf("THROT"));
    	}
        else
    	{
            p_ascent.throttle.setText(sprintf(""));
            p_ascent.throttle_text.setText(sprintf(""));
    	}
    

	var control_mode = getprop("/fdm/jsbsim/systems/fcs/control-mode");

	if (control_mode == 13)
    		{
		p_ascent.serc.setText("*");
    		p_ascent.serc_on.setText("ON");
		}
	else
		{
		p_ascent.serc.setText("");
    		p_ascent.serc_on.setText("");
		}
	
        if (major_mode == 103)
    	{
            p_ascent.prplt.setText(sprintf("%3.0f",100.0* getprop("/consumables/fuel/tank/level-norm")));
            p_ascent.prplt_text.setText(sprintf("PRPLT"));
	    p_ascent.vco.setVisible(1);
	    p_ascent.vco_marker.setVisible(1);
	    p_ascent.vcoscale_co.setVisible(1);
	    p_ascent.vcoscale_labelco.setVisible(1);

    	}
        else 	
    	{
            p_ascent.prplt.setText(sprintf(""));
            p_ascent.prplt_text.setText(sprintf(""));
    	}
    
        device.nom_traj_plot.removeAllChildren();
    
        SpaceShuttle.ascent_traj_update_set();
    
    
    
        if (SpaceShuttle.traj_display_flag == 1)
    	{
            if (major_mode == 101)
    		{device.DPS_menu_title.setText("LAUNCH TRAJ");}
            else
    		{device.DPS_menu_title.setText("ASCENT TRAJ 1");}
    
    		device.DPS_menu_ops.setText( major_mode~"1/     /");
    	}
        else if ( major_mode == 103)
    	{

	    var guidance_mode = getprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode");
		
	    if (guidance_mode == 2)
		{
            	device.DPS_menu_title.setText("TAL TRAJ 2");
		}
	    else
		{
            	device.DPS_menu_title.setText("ASCENT TRAJ 2");
		}
            device.DPS_menu_ops.setText("1031/     /");
	    p_ascent.pred2.setVisible(1);
    	}
    
    
    
        var plot = device.nom_traj_plot.createChild("path", "data")
        .setStrokeLineWidth(2)
        .setColor(dps_r,dps_g,dps_b)
        .moveTo(traj_data[0][0],traj_data[0][1]); 
    
        for (var i = 1; i< (size(traj_data)-1); i=i+1)
        {
            var set = traj_data[i+1];
            plot.lineTo(set[0], set[1]);	
        }
    
        var velocity = SpaceShuttle.ascent_traj_update_velocity();
        var altitude = getprop("/position/altitude-ft");
        
	var vfrac = (velocity - 25000.0)/1000.0;
	if (vfrac < 0) {vfrac = 0.0;}

	p_ascent.vco_marker.setTranslation(78.0 + vfrac * 400.0 ,92.0);

        var x = SpaceShuttle.parameter_to_x(velocity, SpaceShuttle.traj_display_flag);
        var y = SpaceShuttle.parameter_to_y(altitude, SpaceShuttle.traj_display_flag);
    	
	p_ascent.shuttle_marker.setTranslation(x,y);

	velocity = SpaceShuttle.ascent_predictors[0][0];
	altitude = SpaceShuttle.ascent_predictors[0][1];

	x = SpaceShuttle.parameter_to_x(velocity, SpaceShuttle.traj_display_flag);
	y = SpaceShuttle.parameter_to_y(altitude, SpaceShuttle.traj_display_flag);

	p_ascent.pred1.setTranslation(x,y);

	velocity = SpaceShuttle.ascent_predictors[1][0];
	altitude = SpaceShuttle.ascent_predictors[1][1];

	x = SpaceShuttle.parameter_to_x(velocity, SpaceShuttle.traj_display_flag);
	y = SpaceShuttle.parameter_to_y(altitude, SpaceShuttle.traj_display_flag);

	p_ascent.pred2.setTranslation(x,y);
        #device.p_ascent_shuttle_sym.setTranslation(x,y);
    
    
    };
    
    
    
    
    return p_ascent;
}
