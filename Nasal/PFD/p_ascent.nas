#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_ascent
# Description: the ascent PFD page showing the vertical trajectory status
#      Author: Thorsten Renk, 2015-2017
#---------------------------------------

var PFD_addpage_p_ascent = func(device)
{
    var p_ascent = device.addPage("Ascent", "p_ascent");
    
    #
    #
    # Ascent page update
    # var p_ascent_view = device.svg.getElementById("ascent_view");
    SpaceShuttle.fill_traj1_data();

    
    p_ascent.group = device.svg.getElementById("p_ascent");
    p_ascent.group.setColor(dps_r, dps_g, dps_b);

    p_ascent.throttle = device.svg.getElementById("p_ascent_throttle");
    p_ascent.throttle_text = device.svg.getElementById("p_ascent_throttle_txt");

    p_ascent.throttle.enableUpdate();
    p_ascent.throttle_text.enableUpdate();
    
    p_ascent.prplt = device.svg.getElementById("p_ascent_prplt");
    p_ascent.prplt_text = device.svg.getElementById("p_ascent_prplt_txt");

    p_ascent.prplt.enableUpdate();
    p_ascent.prplt_text.enableUpdate();

    p_ascent.vco  = device.svg.getElementById("p_ascent_vco");
    p_ascent.vcoscale_co = device.svg.getElementById("p_ascent_vcoscale_co");
    p_ascent.vcoscale_labelco = device.svg.getElementById("p_ascent_vcoscale_labelco");

    p_ascent.serc = device.svg.getElementById("p_ascent_serc");
    p_ascent.serc_on = device.svg.getElementById("p_ascent_serc_on");

    p_ascent.serc.enableUpdate();
    p_ascent.serc_on.enableUpdate();

    p_ascent.yaw_steer = device.svg.getElementById("p_ascent_yaw_steer");
    p_ascent.abort = device.svg.getElementById("p_ascent_abort");
    p_ascent.arm = device.svg.getElementById("p_ascent_arm");

    p_ascent.abort_region = device.svg.getElementById("p_ascent_2EO_abort_region");
    p_ascent.abort_region_3eo = device.svg.getElementById("p_ascent_3EO_abort_region");

    p_ascent.yaw_steer.enableUpdate();
    p_ascent.abort.enableUpdate();
    p_ascent.arm.enableUpdate();

    p_ascent.abort_region.enableUpdate();
    p_ascent.abort_region_3eo.enableUpdate();
	
    p_ascent.engine1_fail_vi = device.svg.getElementById("p_ascent_engine1_fail_vi");
    p_ascent.engine2_fail_vi = device.svg.getElementById("p_ascent_engine2_fail_vi");

    p_ascent.engine1_fail_vi.enableUpdate();
    p_ascent.engine2_fail_vi.enableUpdate();


    p_ascent.droop_txt = device.svg.getElementById("p_ascent_droop_txt");
    p_ascent.droop_alt = device.svg.getElementById("p_ascent_droop_alt");
    p_ascent.droop_engaged = device.svg.getElementById("p_ascent_droop_engaged");

    p_ascent.droop_txt.enableUpdate();
    p_ascent.droop_alt.enableUpdate();
    p_ascent.droop_engaged.enableUpdate();

    p_ascent.droop_engaged.setColor(0.8, 0.8, 0.4);

    p_ascent.tmeco_txt = device.svg.getElementById("p_ascent_tmeco_txt");
    p_ascent.tmeco = device.svg.getElementById("p_ascent_tmeco");

    p_ascent.tmeco_txt.enableUpdate();
    p_ascent.tmeco.enableUpdate();

    p_ascent.pass = device.svg.getElementById("p_ascent_pass");
    p_ascent.bfs = device.svg.getElementById("p_ascent_bfs");

    p_ascent.bfs_throttle = device.svg.getElementById("p_ascent_bfs_throttle");
    p_ascent.bfs_throttle_alt = device.svg.getElementById("p_ascent_bfs_throttle_alt");
    p_ascent.bfs_roll_error = device.svg.getElementById("p_ascent_bfs_roll_error");
    p_ascent.bfs_pitch_error = device.svg.getElementById("p_ascent_bfs_pitch_error");
    p_ascent.bfs_yaw_error = device.svg.getElementById("p_ascent_bfs_yaw_error");

    p_ascent.bfs_throttle.enableUpdate();
    p_ascent.bfs_throttle_alt.enableUpdate();

    p_ascent.bfs_pc = device.svg.getElementById("p_ascent_bfs_pc");
    p_ascent.bfs_sep_inh = device.svg.getElementById("p_ascent_bfs_sep_inh");

    p_ascent.bfs_keas = device.svg.getElementById("p_ascent_bfs_keas");
    p_ascent.bfs_stage2 = device.svg.getElementById("p_ascent_bfs_stage2");

    p_ascent.bfs_errors = device.svg.getElementById("p_ascent_bfs_errors");

    p_ascent.bfs_label1 = device.svg.getElementById("p_ascent_bfs_label1");
    p_ascent.bfs_label1a = device.svg.getElementById("p_ascent_bfs_label1a");

    p_ascent.bfs_label1.enableUpdate();
    p_ascent.bfs_label1a.enableUpdate();

    p_ascent.blink = 0;


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


	data = SpaceShuttle.draw_tmarker_left();
	p_ascent.bfs_keas_marker = device.symbols.createChild("path", "keas_marker")
        .setStrokeLineWidth(2)
        .setColor(0.8, 0.8, 0.4)
	.moveTo(data[0][0], data[0][1]);

	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_ascent.bfs_keas_marker.lineTo(set[0], set[1]);
		}

	p_ascent.bfs_keas_marker.setTranslation(78.0 + 0.0 * 400.0 ,92.0);

	p_ascent.bfs_g_marker = device.symbols.createChild("path", "g_marker")
        .setStrokeLineWidth(2)
        .setColor(0.8, 0.8, 0.4)
	.moveTo(data[0][0], data[0][1]);

	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_ascent.bfs_g_marker.lineTo(set[0], set[1]);
		}

	p_ascent.bfs_g_marker.setVisible(0);

	p_ascent.engine1_fail_vi.updateText("");
	p_ascent.engine2_fail_vi.updateText("");

    	p_ascent.bfs_label1.updateText("T");
    	p_ascent.bfs_label1a.updateText("");

	p_ascent.bfs_pc.setText("");
	p_ascent.bfs_sep_inh.setText("");

	p_ascent.major_func = SpaceShuttle.idp_array[device.port_selected-1].get_major_function();

	# switch BFS elements on and PASS elements off if we run BFS

	if (p_ascent.major_func == 4)
		{

		p_ascent.pass.setVisible(0);
		p_ascent.bfs_keas_marker.setVisible(1);
		p_ascent.bfs.setVisible(1);
		}
	else
		{
		p_ascent.pass.setVisible(1);
		p_ascent.bfs_keas_marker.setVisible(0);
		p_ascent.bfs.setVisible(0);
		}


    	p_ascent.droop_txt.updateText("");
    	p_ascent.droop_alt.updateText("");
    	p_ascent.droop_engaged.updateText("");

    	p_ascent.tmeco_txt.updateText("");
    	p_ascent.tmeco.updateText("");

    }
    
    p_ascent.offdisplay = func
    {
        device.nom_traj_plot.removeAllChildren();
    	device.symbols.removeAllChildren();
    
        device.set_DPS_off();
    }
    
    p_ascent.update = func
    {
    
        device.update_common_DPS();
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
	if (p_ascent.major_func == 4)
		{
		major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-bfs");
		}    

        if (SpaceShuttle.traj_display_flag < 3)
    	{
            var throttle = getprop("/fdm/jsbsim/fcs/throttle-pos-norm");
	    if (throttle == 0 ){throttle = getprop("/fdm/jsbsim/fcs/throttle-pos-norm[1]");}
	    if (throttle == 0 ){throttle = getprop("/fdm/jsbsim/fcs/throttle-pos-norm[2]");}
            if (throttle < 0.61) {throttle = 0.0;} else {throttle = throttle * 100.0;}
            p_ascent.throttle.updateText(sprintf("%3.0f",throttle));
            p_ascent.throttle_text.updateText(sprintf("THROT"));

	    if (major_mode == 103)
		{
	    	p_ascent.bfs_throttle_alt.updateText(sprintf("%3.0f",throttle));
		}
	    else
		{
	    	p_ascent.bfs_throttle.updateText(sprintf("%3.0f",throttle));
		}
    	}
        else
    	{
            p_ascent.throttle.updateText(sprintf(""));
            p_ascent.throttle_text.updateText(sprintf(""));
    	}
    
	if (getprop("/fdm/jsbsim/systems/abort/enable-yaw-steer") == 1)
		{p_ascent.yaw_steer.updateText("ENA");}
	else	
		{p_ascent.yaw_steer.updateText("INH");}

	p_ascent.abort_region.updateText(getprop("/fdm/jsbsim/systems/abort/contingency-abort-region"));
	p_ascent.abort_region_3eo.updateText(getprop("/fdm/jsbsim/systems/abort/contingency-abort-region-3eo"));	

	if ((major_mode == 102) or (major_mode == 103))
		{	
		p_ascent.engine1_fail_vi.updateText(getprop("/fdm/jsbsim/systems/abort/engine-fail-string"));
		p_ascent.engine2_fail_vi.updateText(getprop("/fdm/jsbsim/systems/abort/engine2-fail-string"));
		}

	if (getprop("/fdm/jsbsim/systems/abort/arm-contingency") == 1)
		{p_ascent.arm.updateText("*");}
	else
		{p_ascent.arm.updateText("");}

	var abort_mode = getprop("/fdm/jsbsim/systems/abort/abort-mode");

	if ((abort_mode > 4) and (abort_mode < 10))
		{
		p_ascent.abort.updateText("*");
		p_ascent.abort_region.setColor(0.8, 0.8, 0.4);
		}
	else if (abort_mode > 9)
		{
		p_ascent.abort_region_3eo.setColor(0.8, 0.8, 0.4);
		p_ascent.abort.updateText("");
		}
	else
		{p_ascent.abort.updateText("");}

	var arm_serc = getprop("/fdm/jsbsim/systems/abort/arm-serc");
	var control_mode = getprop("/fdm/jsbsim/systems/fcs/control-mode");

	if ((arm_serc == 1) or (control_mode == 13))
		{
		p_ascent.serc.updateText("*");
		}
	else
		{
		p_ascent.serc.updateText("");
		}


	if (control_mode == 13)
    		{
    		p_ascent.serc_on.updateText("ON");
		}
	else
		{
    		p_ascent.serc_on.updateText("");
		}


	
        if (major_mode == 103)
    	{
            p_ascent.prplt.updateText(sprintf("%3.0f",100.0* getprop("/consumables/fuel/tank/level-norm")));
            p_ascent.prplt_text.updateText(sprintf("PRPLT"));
	    p_ascent.vco.setVisible(1);
	    p_ascent.vco_marker.setVisible(1);
	    p_ascent.vcoscale_co.setVisible(1);
	    p_ascent.vcoscale_labelco.setVisible(1);

	    p_ascent.tmeco_txt.updateText("TMECO");
	    var tmeco = getprop("/sim/time/elapsed-sec");
	    tmeco = tmeco + SpaceShuttle.meco_time.get();

	    if (SpaceShuttle.meco_time.get_mode() < 2)
	    	{p_ascent.tmeco.updateText(seconds_to_stringMS(tmeco));}





	    if (SpaceShuttle.droop_guidance.active == 1)
		{
    	    	p_ascent.droop_engaged.updateText("DROOP ENGAGED");
	        if (SpaceShuttle.droop_guidance.droop_alt > 80772.0)
			{    	

			p_ascent.droop_txt.updateText("DROOP ALT");
    	        	p_ascent.droop_alt.updateText(sprintf("%d", int(SpaceShuttle.droop_guidance.droop_alt * 0.003280) ));
			p_ascent.droop_txt.setColor(dps_r,dps_g,dps_b);   
			p_ascent.droop_alt.setColor(dps_r,dps_g,dps_b);   
			}
		else
			{
			p_ascent.droop_txt.setColor(0.8, 0.8, 0.4);   
			p_ascent.droop_alt.setColor(0.8, 0.8, 0.4);             
			if (p_ascent.blink == 0)
				{
				p_ascent.droop_txt.updateText("DROOP ALT");
    	        		p_ascent.droop_alt.updateText(sprintf("%d", int(SpaceShuttle.droop_guidance.droop_alt * 0.003280) ));
				p_ascent.blink = 1;
				}
			else
				{
				p_ascent.droop_txt.updateText("");
    	        		p_ascent.droop_alt.updateText("");
				p_ascent.blink = 0;
				}
			}
		}
	    else
		{
    	    	p_ascent.droop_engaged.updateText("");
    	        p_ascent.droop_txt.updateText("DROOP ALT");
    	    	p_ascent.droop_alt.updateText(sprintf("%d", int(SpaceShuttle.droop_guidance.droop_alt * 0.003280) ));
		}

    	}
        else 	
    	{
            p_ascent.prplt.updateText(sprintf(""));
            p_ascent.prplt_text.updateText(sprintf(""));
   	    p_ascent.droop_txt.updateText("");
    	    p_ascent.droop_alt.updateText("");
    	    p_ascent.droop_engaged.updateText("");

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
    
    
	var downshift = 0.0;
	var rightshift = 0.0;
	if (major_mode == 103) 
		{
		downshift = 80.0;
		if (p_ascent.major_func == 4) {rightshift = 10.0;}
		}
    
        var plot = device.nom_traj_plot.createChild("path", "data")
        .setStrokeLineWidth(2)
        .setColor(dps_r,dps_g,dps_b)
	.setTranslation(rightshift,downshift)
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
    	
	p_ascent.shuttle_marker.setTranslation(x + rightshift,y + downshift);

	velocity = SpaceShuttle.ascent_predictors[0][0];
	altitude = SpaceShuttle.ascent_predictors[0][1];

	x = SpaceShuttle.parameter_to_x(velocity, SpaceShuttle.traj_display_flag);
	y = SpaceShuttle.parameter_to_y(altitude, SpaceShuttle.traj_display_flag);

	p_ascent.pred1.setTranslation(x + rightshift,y + downshift);

	velocity = SpaceShuttle.ascent_predictors[1][0];
	altitude = SpaceShuttle.ascent_predictors[1][1];

	x = SpaceShuttle.parameter_to_x(velocity, SpaceShuttle.traj_display_flag);
	y = SpaceShuttle.parameter_to_y(altitude, SpaceShuttle.traj_display_flag);

	p_ascent.pred2.setTranslation(x + rightshift,y + downshift);


	if (p_ascent.major_func == 4) # we drive BFS specific items
		{

		var pitch_error = 0.0;
		var roll_error = 0.0;
		var yaw_error = 0.0;

		var launch_stage = getprop("/fdm/jsbsim/systems/ap/launch/stage");
		
		if (getprop("/fdm/jsbsim/systems/dps/bfs-in-control") == 0)
		{
			if ((launch_stage > 0) and (launch_stage < 5) and (altitude > 500.0)) # we have launch guidance
				{
				if (launch_stage == 1)
					{
					roll_error = -math.asin(getprop("/fdm/jsbsim/systems/ap/launch/stage1-course-error")) * 180.0/math.pi;
					}

				else if ((launch_stage > 1) and (launch_stage < 5))
					{
					pitch_error = getprop("/fdm/jsbsim/systems/ap/launch/stage"~launch_stage~"-pitch-error");
					yaw_error = getprop("/fdm/jsbsim/systems/ap/launch/stage"~launch_stage~"-yaw-error");
					roll_error = getprop("/fdm/jsbsim/systems/ap/launch/stage"~launch_stage~"-roll-error");
					}
				}
			p_ascent.bfs_roll_error.setText(sprintf("%3.0f", roll_error));
			p_ascent.bfs_pitch_error.setText(sprintf("%3.0f", pitch_error));
			p_ascent.bfs_yaw_error.setText(sprintf("%3.0f", yaw_error));
		}
		else
		{
			p_ascent.bfs_errors.setVisible(0);
		}


		if ((major_mode == 102) or (major_mode == 101)) 
			{
			p_ascent.bfs_stage2.setVisible(0);

			if  (getprop("/fdm/jsbsim/propulsion/srb-pc50-discrete") == 1)
				{p_ascent.bfs_pc.setText("PC < 50");}

			var keas_frac = getprop("/fdm/jsbsim/velocities/ve-kts")/100.0;
			p_ascent.bfs_keas_marker.setTranslation(62.0,341.0 - 43.0 * keas_frac);



			}
		else
			{
			p_ascent.bfs_pc.setVisible(0);
			p_ascent.bfs_keas.setVisible(0);
			p_ascent.bfs_stage2.setVisible(1);
			p_ascent.bfs_g_marker.setVisible(1);

		    	p_ascent.bfs_label1.updateText("H");
		    	p_ascent.bfs_label1a.updateText(".");

			var vspeed = -getprop("/fdm/jsbsim/velocities/v-down-fps");

			p_ascent.bfs_throttle.updateText(sprintf("%3.0f",vspeed));

			var x = getprop("/test/x");
			var y = getprop("/test/y");
			
			var dhdot_frac = 0.0;

			if (launch_stage == 4)
				{
				dhdot_frac = getprop("/fdm/jsbsim/systems/ap/launch/stage4-hdot-error")/200.0;
				dhdot_frac = SpaceShuttle.clamp(dhdot_frac, -1.0, 1.0);
				}

			p_ascent.bfs_keas_marker.setTranslation(60,236 + 130.0 * dhdot_frac);

			var g_frac = getprop("/fdm/jsbsim/accelerations/a-pilot-ft_sec2") * 0.03108095;
			g_frac = SpaceShuttle.clamp(g_frac, 2.0, 3.5) - 2.0;

			p_ascent.bfs_g_marker.setTranslation(330,394 - 100.0 * g_frac);
			}
		}

    
    
    };
    
    
    
    
    return p_ascent;
}
