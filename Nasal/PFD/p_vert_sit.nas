#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_vert_sit
# Description: the vertical situation PFD page showing the TAEM guidance
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_vert_sit = func(device)
{
    var p_vert_sit = device.addPage("VertSit", "p_vert_sit");

    p_vert_sit.group = device.svg.getElementById("p_vert_sit");
    p_vert_sit.group.setColor(dps_r, dps_g, dps_b);
    
    p_vert_sit.speedbrake = device.svg.getElementById("p_vert_sit_speedbrake");
    p_vert_sit.speedbrake_cmd = device.svg.getElementById("p_vert_sit_speedbrake_cmd");
    p_vert_sit.tgt_Nz = device.svg.getElementById("p_vert_sit_tgt_Nz");
    p_vert_sit.tgt_Nz_label = device.svg.getElementById("p_vert_sit_tgt_Nz_label");
    p_vert_sit.Nz_label = device.svg.getElementById("p_vert_sit_Nz_label");

    p_vert_sit.bailout = device.svg.getElementById("p_vert_sit_bailout");    
    p_vert_sit.ecal = device.svg.getElementById("p_vert_sit_ecal");    

    p_vert_sit.blink = 0;

    p_vert_sit.ondisplay = func
    {


        SpaceShuttle.fill_vert_sit1_nom_data();
        SpaceShuttle.fill_vert_sit1_SB_data();
        SpaceShuttle.fill_vert_sit1_maxLD_data();
        SpaceShuttle.traj_display_flag = 8;
        device.MEDS_menu_title.setText(sprintf("%s","       DPS MENU"));
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
        device.DPS_menu_ops.setText(sprintf("%s", major_mode~"1/     /"));
        device.DPS_menu_title.setText(sprintf("%s","VERT SIT 1"));

	p_vert_sit.bailout.setVisible(0);


	if ((major_mode == 602) or (major_mode == 603))
		{
		p_vert_sit.tgt_Nz.setVisible(1);
		p_vert_sit.tgt_Nz_label.setVisible(1);
		p_vert_sit.ecal.setVisible(1);
		}    
	else
		{
		p_vert_sit.tgt_Nz.setVisible(0);
		p_vert_sit.tgt_Nz_label.setVisible(0);
		p_vert_sit.ecal.setVisible(0);
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
    
        var plot_limit1 = device.limit1_traj_plot.createChild("path", "data")
        .setStrokeLineWidth(1)
        .setColor(dps_r, dps_g, dps_b)
        .moveTo(limit1_data[0][0],limit1_data[0][1]); 
    
        for (var i = 1; i< (size(limit1_data)-1); i=i+1)
        {
            var set = limit1_data[i+1];
            plot_limit1.lineTo(set[0], set[1]);	
        }
    
        var plot_limit2 = device.limit2_traj_plot.createChild("path", "data")
        .setStrokeLineWidth(1)
        .setColor(dps_r,dps_g,dps_b)
        .moveTo(limit2_data[0][0],limit2_data[0][1]); 
    
        for (var i = 1; i< (size(limit2_data)-1); i=i+1)
        {
            var set = limit2_data[i+1];
            plot_limit2.lineTo(set[0], set[1]);	
        }


	var data = SpaceShuttle.draw_shuttle_side();
	 
	p_vert_sit.shuttle_sym = device.symbols.createChild("path", "shuttle_sym")
        .setStrokeLineWidth(0.25)
        .setColor(0.8, 0.8, 0.4)
	.moveTo(data[0][0], data[0][1]);

	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_vert_sit.shuttle_sym.lineTo(set[0], set[1]);
		}

	p_vert_sit.shuttle_sym.setScale(6.0);

	data = SpaceShuttle.draw_tmarker_right();
	p_vert_sit.theta = device.symbols.createChild("path", "theta")
        .setStrokeLineWidth(1.0)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(data[0][0], data[0][1]);

	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_vert_sit.theta.lineTo(set[0], set[1]);
		}

	data = SpaceShuttle.draw_tmarker_left();
	p_vert_sit.energy = device.symbols.createChild("path", "energy")
        .setStrokeLineWidth(1.0)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(data[0][0], data[0][1]);

	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_vert_sit.energy.lineTo(set[0], set[1]);
		}

	var alpha_trajectories = device.symbols.createChild("group");

	data = [[0.0, 0.0], [180.0,-35.0] ]; 
	p_vert_sit.alpha_nom = device.symbols.createChild("path")
        .setStrokeLineWidth(1.0)
        .setColor(dps_r, dps_g, dps_b)
	.setTranslation(30, 160)
	.moveTo(data[0][0], data[0][1])
	.lineTo(data[1][0], data[1][1]);

	data = [[0.0, 35.0], [30.0, 20.0], [180.0,-5.0] ]; 
	p_vert_sit.alpha_min = device.symbols.createChild("path")
        .setStrokeLineWidth(1.0)
        .setColor(dps_r, dps_g, dps_b)
	.setTranslation(30, 160)
	.moveTo(data[0][0], data[0][1])
	.lineTo(data[1][0], data[1][1])
	.lineTo(data[2][0], data[2][1]);

	#alpha_trajectories.setTranslation(20, 160);
	
	if ((major_mode == 602) or (major_mode == 603))
		{
		alpha_trajectories.setVisible(1);
		}
	else
		{
		alpha_trajectories.setVisible(0);
		}

    
    }
    
    p_vert_sit.offdisplay = func
    {
        device.nom_traj_plot.removeAllChildren();
        device.limit1_traj_plot.removeAllChildren();
        device.limit2_traj_plot.removeAllChildren();
	device.symbols.removeAllChildren();
        device.set_DPS_off();
    }
    
    p_vert_sit.update = func
    {
    
        device.update_common_DPS();
    
    
    
    
    
        if (SpaceShuttle.TAEM_guidance_available == 1)
    	{
            var altitude = getprop("/position/altitude-ft") - SpaceShuttle.TAEM_threshold.elevation;
            var range = getprop("/fdm/jsbsim/systems/taem-guidance/distance-to-runway-nm");
            var x = SpaceShuttle.parameter_to_x(range, SpaceShuttle.traj_display_flag);
            var y = SpaceShuttle.parameter_to_y(altitude, SpaceShuttle.traj_display_flag);
    	
            if (range < 20.0) {device.selectPage(device.p_vert_sit2);}

	    var vspeed = getprop("/velocities/vertical-speed-fps");
	    var mach = getprop("/velocities/mach");
	    if (mach< 0.5) {mach = 0.5;}	
	    var rot = vspeed * 0.005 /mach;
	    rot = SpaceShuttle.clamp(rot, -1.57, 1.57);
	    p_vert_sit.shuttle_sym.setRotation(rot);
   
            p_vert_sit.shuttle_sym.setTranslation(x,y);

    	}
	else if (getprop("/fdm/jsbsim/systems/ap/grtls/alpha-transition-active") == 1)
	{
	    var alpha = getprop("/fdm/jsbsim/aero/alpha-deg");
	    var mach = getprop("/velocities/mach");
	    

	    var x = 30.0 + 180 * (mach - 1.5)/4.5;	
	    var y = 160 - 25 * (alpha - 9.0)/14.0; 
	    p_vert_sit.shuttle_sym.setRotation(0.0);
            p_vert_sit.shuttle_sym.setTranslation(x,y);


	}

	    var pitch = getprop("/orientation/pitch-deg");
	    var yp = 254.0 - (pitch -5.0) * 5.6;
	    p_vert_sit.theta.setTranslation(467,yp);

	    var dE = getprop("/fdm/jsbsim/systems/taem-guidance/dH-equiv-ft");

	    dE = SpaceShuttle.clamp(dE, -20000.0, 20000.0);		

	    var yde = 254.0 - dE/10000.0 * 28.;
	    p_vert_sit.energy.setTranslation(467,yde);
    
        p_vert_sit.speedbrake.setText(sprintf("%3.0f", 100.0 * getprop("/fdm/jsbsim/fcs/speedbrake-pos-norm")));
        p_vert_sit.speedbrake_cmd.setText(sprintf("%3.0f", 100.0 * getprop("/fdm/jsbsim/systems/fcs/speedbrake-cmd-norm")));



	# Nz holding phase
	if (getprop("/fdm/jsbsim/systems/ap/grtls/Nz-hold-active") == 1)
		{p_vert_sit.Nz_label.setVisible(1);}
	else
		{p_vert_sit.Nz_label.setVisible(0);}
    
	
	# Nz predictor
	
	if (getprop("/fdm/jsbsim/systems/dps/ops") == 6)
		{
		p_vert_sit.tgt_Nz.setText(sprintf("%+1.1f", getprop("/fdm/jsbsim/systems/ap/grtls/Nz-tgt")));

		}

	# bailout	

	var bailout_arm = getprop("/fdm/jsbsim/systems/abort/arm-bailout");
	var bailout_active = getprop("/fdm/jsbsim/systems/ap/auto-bailout-active");

	if (bailout_active == 1)
		{
		p_vert_sit.bailout.setVisible(1);
		p_vert_sit.bailout.setColor(0.8, 0.8, 0.4);
		}
	else if (bailout_arm == 1)
		{
		if (p_vert_sit.blink == 1)
			{
			p_vert_sit.bailout.setVisible(1);
			p_vert_sit.blink = 0;
			}
		else
			{
			p_vert_sit.bailout.setVisible(0);
			p_vert_sit.blink = 1;
			}
		}



    
    };

return p_vert_sit;
}
    

var PFD_addpage_p_vert_sit2 = func(device)
{    

    
    var p_vert_sit2 = device.addPage("VertSit2", "p_vert_sit2");
    
    p_vert_sit2.speedbrake = device.svg.getElementById("p_vert_sit2_speedbrake");
    p_vert_sit2.group = device.svg.getElementById("p_vert_sit2");
    p_vert_sit2.group.setColor(dps_r, dps_g, dps_b);

    p_vert_sit2.speedbrake_cmd = device.svg.getElementById("p_vert_sit2_speedbrake_cmd");
    p_vert_sit2.tgt_Nz = device.svg.getElementById("p_vert_sit2_tgt_Nz");
    p_vert_sit2.tgt_Nz_label = device.svg.getElementById("p_vert_sit2_tgt_Nz_label");
    p_vert_sit2.al_label = device.svg.getElementById("p_vert_sit2_al_label");

    p_vert_sit2.bailout = device.svg.getElementById("p_vert_sit2_bailout");

    p_vert_sit2.blink = 0;
    
    
    p_vert_sit2.ondisplay = func
    {
        SpaceShuttle.fill_vert_sit2_nom_data();
        SpaceShuttle.fill_vert_sit2_SB_data();
        SpaceShuttle.fill_vert_sit2_maxLD_data();
        SpaceShuttle.traj_display_flag = 9;
        device.MEDS_menu_title.setText("       DPS MENU");
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
        device.DPS_menu_ops.setText(major_mode~"1/     /");
        device.DPS_menu_title.setText("VERT SIT 2");

	p_vert_sit2.bailout.setVisible(0);
	p_vert_sit2.bailout.setColor(0.8, 0.8, 0.4);

	if ((major_mode == 602) or (major_mode == 603))
		{
		p_vert_sit2.tgt_Nz.setVisible(1);
		p_vert_sit2.tgt_Nz_label.setVisible(1);
		}    
	else
		{
		p_vert_sit2.tgt_Nz.setVisible(0);
		p_vert_sit2.tgt_Nz_label.setVisible(0);
		}

	p_vert_sit2.tgt_Nz.setText(sprintf("%+1.1f", getprop("/fdm/jsbsim/systems/ap/grtls/Nz-tgt")));
    
    
        var plot = device.nom_traj_plot.createChild("path", "data")
        .setStrokeLineWidth(2)
        .setColor(dps_r, dps_g, dps_b)
        .moveTo(traj_data[0][0],traj_data[0][1]); 
    
        for (var i = 1; i< (size(traj_data)-1); i=i+1)
        {
            var set = traj_data[i+1];
            plot.lineTo(set[0], set[1]);	
        }
    
        var plot_limit1 = device.limit1_traj_plot.createChild("path", "data")
        .setStrokeLineWidth(1)
        .setColor(dps_r, dps_g, dps_b)
        .moveTo(limit1_data[0][0],limit1_data[0][1]); 
    
        for (var i = 1; i< (size(limit1_data)-1); i=i+1)
        {
            var set = limit1_data[i+1];
            plot_limit1.lineTo(set[0], set[1]);	
        }
    
        var plot_limit2 = device.limit2_traj_plot.createChild("path", "data")
        .setStrokeLineWidth(1)
        .setColor(dps_r, dps_g, dps_b)
        .moveTo(limit2_data[0][0],limit2_data[0][1]); 
    
        for (var i = 1; i< (size(limit2_data)-1); i=i+1)
        {
            var set = limit2_data[i+1];
            plot_limit2.lineTo(set[0], set[1]);	
        }

	var data = SpaceShuttle.draw_shuttle_side();
	 
	p_vert_sit2.shuttle_sym = device.symbols.createChild("path", "shuttle_sym")
        .setStrokeLineWidth(0.25)
        .setColor(0.8, 0.8, 0.4)
	.moveTo(data[0][0], data[0][1]);

	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_vert_sit2.shuttle_sym.lineTo(set[0], set[1]);
		}

	p_vert_sit2.shuttle_sym.setScale(6.0);

	data = SpaceShuttle.draw_tmarker_right();
	p_vert_sit2.theta = device.symbols.createChild("path", "theta")
        .setStrokeLineWidth(1.0)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(data[0][0], data[0][1]);

	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_vert_sit2.theta.lineTo(set[0], set[1]);
		}

	data = SpaceShuttle.draw_tmarker_left();
	p_vert_sit2.energy = device.symbols.createChild("path", "energy")
        .setStrokeLineWidth(1.0)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(data[0][0], data[0][1]);

	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_vert_sit2.energy.lineTo(set[0], set[1]);
		}

    
    }
    
    p_vert_sit2.offdisplay = func
    {
        device.nom_traj_plot.removeAllChildren();
        device.limit1_traj_plot.removeAllChildren();
        device.limit2_traj_plot.removeAllChildren();
	device.symbols.removeAllChildren();
        #device.p_ascent_shuttle_sym.setScale(0.0);
        device.set_DPS_off();
    }
    
    p_vert_sit2.update = func
    {
    
        device.update_common_DPS();
    
    
    
        if (SpaceShuttle.TAEM_guidance_available == 1)
    	{
            var altitude = getprop("/position/altitude-ft") - SpaceShuttle.TAEM_threshold.elevation;
            var range = getprop("/fdm/jsbsim/systems/taem-guidance/distance-to-runway-nm");
            var x = SpaceShuttle.parameter_to_x(range, SpaceShuttle.traj_display_flag);
            var y = SpaceShuttle.parameter_to_y(altitude, SpaceShuttle.traj_display_flag);
    	
            var vspeed = getprop("/velocities/vertical-speed-fps");
	    var mach = getprop("/velocities/mach");
	    if (mach< 0.5) {mach = 0.5;}	
	    var rot = vspeed * 0.005 /mach * 0.6;
	    rot = SpaceShuttle.clamp(rot, -1.57, 1.57);
	    p_vert_sit2.shuttle_sym.setRotation(rot);
	    p_vert_sit2.shuttle_sym.setTranslation(x,y);

    	}

	    var pitch = getprop("/orientation/pitch-deg");
	    var yp = 254.0 - (pitch -5.0) * 5.6;
	    p_vert_sit2.theta.setTranslation(467,yp);

	    var dE = getprop("/fdm/jsbsim/systems/taem-guidance/dH-equiv-ft");

	    dE = SpaceShuttle.clamp(dE, -20000.0, 20000.0);		

	    var yde = 254.0 - dE/10000.0 * 28.;
	    p_vert_sit2.energy.setTranslation(467,yde);
    
            p_vert_sit2.speedbrake.setText(sprintf("%3.0f", 100.0 * getprop("/fdm/jsbsim/fcs/speedbrake-pos-norm")));
            p_vert_sit2.speedbrake_cmd.setText(sprintf("%3.0f", 100.0 * getprop("/fdm/jsbsim/systems/fcs/speedbrake-cmd-norm")));

	    if (getprop("/fdm/jsbsim/systems/ap/taem/al-init") == 1)
		{
		if (p_vert_sit2.blink == 0)	
			{
			p_vert_sit2.al_label.setVisible(1);
			p_vert_sit2.blink = 1;
			}
		else
			{
			p_vert_sit2.al_label.setVisible(0);
			p_vert_sit2.blink = 0;
			}
		}
	    else
		{
		p_vert_sit2.al_label.setVisible(0);
		}

	# bailout	

	var bailout_arm = getprop("/fdm/jsbsim/systems/abort/arm-bailout");
	var bailout_active = getprop("/fdm/jsbsim/systems/ap/auto-bailout-active");

	if (bailout_active == 1)
		{
		p_vert_sit2.bailout.setVisible(1);
		p_vert_sit2.bailout.setColor(0.8, 0.8, 0.4);
		}
	else if (bailout_arm == 1)
		{
		if (p_vert_sit2.blink == 1)
			{
			p_vert_sit2.bailout.setVisible(1);
			p_vert_sit2.blink = 0;
			}
		else
			{
			p_vert_sit2.bailout.setVisible(0);
			p_vert_sit2.blink = 1;
			}
		}
		
    
    
    };
    
    
    
    return p_vert_sit2;
}
