#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_rtls
# Description: the RTLS TRAJ 2
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_rtls = func(device)
{
    var p_dps_rtls = device.addPage("CRTRTLS", "p_dps_rtls");

    p_dps_rtls.group = device.svg.getElementById("p_dps_rtls");
    p_dps_rtls.group.setColor(dps_r, dps_g, dps_b);

    p_dps_rtls.throttle = device.svg.getElementById("p_dps_rtls_throttle");
    p_dps_rtls.throttle_text = device.svg.getElementById("p_dps_rtls_throttle_txt");
    
    p_dps_rtls.prplt = device.svg.getElementById("p_dps_rtls_prplt");
    p_dps_rtls.prplt_text = device.svg.getElementById("p_dps_rtls_prplt_txt");

    p_dps_rtls.vco  = device.svg.getElementById("p_dps_rtls_vco");
    p_dps_rtls.vcoscale_co = device.svg.getElementById("p_dps_rtls_vcoscale_co");
    p_dps_rtls.vcoscale_labelco = device.svg.getElementById("p_dps_rtls_vcoscale_labelco");   

    p_dps_rtls.serc = device.svg.getElementById("p_dps_rtls_serc");
    p_dps_rtls.serc_on = device.svg.getElementById("p_dps_rtls_serc_on");
    
    p_dps_rtls.ondisplay = func
    {


	# generate the symbols for the graphical part of the display

	var data = SpaceShuttle.draw_triangle_up();
	
	 p_dps_rtls.shuttle_marker = device.symbols.createChild("path", "shuttle_marker")
        .setStrokeLineWidth(2)
        .setColor(0.8, 0.8, 0.4)
	.moveTo(data[0][0], data[0][1]);

 	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_dps_rtls.shuttle_marker.lineTo(set[0], set[1]);
		}

	setsize(data,0);

	data = SpaceShuttle.draw_circle(3, 10);

	p_dps_rtls.pred1 = device.symbols.createChild("path", "pred1")
        .setStrokeLineWidth(1)
        .setColor(0.8, 0.8, 0.4)
	.moveTo(data[0][0], data[0][1]);

	 p_dps_rtls.pred2 = device.symbols.createChild("path", "pred2")
        .setStrokeLineWidth(1)
        .setColor(0.8, 0.8, 0.4)
	.moveTo(data[0][0], data[0][1]);



	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_dps_rtls.pred1.lineTo(set[0], set[1]);
		p_dps_rtls.pred2.lineTo(set[0], set[1]);
		}

        p_dps_rtls.prplt_text.setText(sprintf("PRPLT"));
        p_dps_rtls.throttle_text.setText(sprintf("THROT"));	


        SpaceShuttle.rtls_traj_update_set();


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
        .setStrokeLineWidth(2)
        .setColor(dps_r, dps_g, dps_b)
        .moveTo(limit1_data[0][0],limit1_data[0][1]); 
    
        for (var i = 1; i< (size(limit1_data)-1); i=i+1)
        {
            var set = limit1_data[i+1];
            plot_limit1.lineTo(set[0], set[1]);	
        }
    
        var plot_limit2 = device.limit2_traj_plot.createChild("path", "data")
        .setStrokeLineWidth(2)
        .setColor(dps_r,dps_g,dps_b)
        .moveTo(limit2_data[0][0],limit2_data[0][1]); 
    
        for (var i = 1; i< (size(limit2_data)-1); i=i+1)
        {
            var set = limit2_data[i+1];
            plot_limit2.lineTo(set[0], set[1]);	
        }


	setsize(data,0);

	var set = [SpaceShuttle.parameter_to_x(0.0, 10), SpaceShuttle.parameter_to_y(200000, 10)];
	append(data, set);
	set = [SpaceShuttle.parameter_to_x(0.0, 10), SpaceShuttle.parameter_to_y(450000, 10)];
	append(data, set);

	 p_dps_rtls.zero_line = device.symbols.createChild("path", "zline")
        .setStrokeLineWidth(2)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(data[0][0], data[0][1])
	.lineTo(data[1][0], data[1][1]);

	p_dps_rtls.zero_line_text = device.symbols.createChild("text")
      	.setText("0")
        .setColor(dps_r, dps_g, dps_b)
	.setFontSize(14)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
        .setTranslation(data[0][0], data[0][1] + 18.0);




        device.DPS_menu_title.setText("RTLS TRAJ 2");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/   /";
        device.DPS_menu_ops.setText(ops_string);
    }


    p_dps_rtls.offdisplay = func
    {

        device.nom_traj_plot.removeAllChildren();
  	device.limit1_traj_plot.removeAllChildren();
        device.limit2_traj_plot.removeAllChildren();
	device.symbols.removeAllChildren();

    }
    
    p_dps_rtls.update = func
    {
    
 	var throttle = getprop("/fdm/jsbsim/fcs/throttle-pos-norm");
	if (throttle == 0 ){throttle = getprop("/fdm/jsbsim/fcs/throttle-pos-norm[1]");}
	if (throttle == 0 ){throttle = getprop("/fdm/jsbsim/fcs/throttle-pos-norm[2]");}
        if (throttle < 0.61) {throttle = 0.0;} else {throttle = throttle * 100.0;}
        p_dps_rtls.throttle.setText(sprintf("%3.0f",throttle));

	p_dps_rtls.prplt.setText(sprintf("%3.0f",100.0* getprop("/consumables/fuel/tank/level-norm")));


	var control_mode = getprop("/fdm/jsbsim/systems/fcs/control-mode");

	if (control_mode == 13)
    		{
		p_dps_rtls.serc.setText("*");
    		p_dps_rtls.serc_on.setText("ON");
		}
	else
		{
		p_dps_rtls.serc.setText("");
    		p_dps_rtls.serc_on.setText("");
		}

        var velocity = getprop("/fdm/jsbsim/systems/entry_guidance/vrel-fps");
        var altitude = getprop("/position/altitude-ft");

	

        var x = SpaceShuttle.parameter_to_x(velocity, 10);
        var y = SpaceShuttle.parameter_to_y(altitude, 10);
    	
	p_dps_rtls.shuttle_marker.setTranslation(x,y);


	var velocity1 = SpaceShuttle.ascent_predictors[0][2] + velocity;
	altitude = SpaceShuttle.ascent_predictors[0][1];

	x = SpaceShuttle.parameter_to_x(velocity1, 10);
	y = SpaceShuttle.parameter_to_y(altitude, 10);

	p_dps_rtls.pred1.setTranslation(x,y);

	velocity1 = SpaceShuttle.ascent_predictors[1][2] + velocity;
	altitude = SpaceShuttle.ascent_predictors[1][1];

	x = SpaceShuttle.parameter_to_x(velocity1, 10);
	y = SpaceShuttle.parameter_to_y(altitude, 10);

	p_dps_rtls.pred2   .setTranslation(x,y); 

        device.update_common_DPS();
    }
    
    
    
    return p_dps_rtls;
}
