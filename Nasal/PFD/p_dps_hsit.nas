#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_hsit
# Description: the horizontal situation DPS page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_hsit = func(device)
{
    var p_dps_hsit = device.addPage("CRTHsit", "p_dps_hsit");

    p_dps_hsit.group = device.svg.getElementById("p_dps_hsit");
    p_dps_hsit.group.setColor(dps_r, dps_g, dps_b);
    
    p_dps_hsit.altm = device.svg.getElementById("p_dps_hsit_altm");  
    p_dps_hsit.pti = device.svg.getElementById("p_dps_hsit_pti"); 
    p_dps_hsit.pti_index_1 = device.svg.getElementById("p_dps_hsit_pti_index_1"); 
    p_dps_hsit.pti_index_2 = device.svg.getElementById("p_dps_hsit_pti_index_2");     	

    p_dps_hsit.tal_label = device.svg.getElementById("p_dps_hsit_label8");  
    p_dps_hsit.tal_site = device.svg.getElementById("p_dps_hsit_tal_site");  

    p_dps_hsit.landing_label = device.svg.getElementById("p_dps_hsit_label9");
    p_dps_hsit.landing_site = device.svg.getElementById("p_dps_hsit_landing_site");    

    p_dps_hsit.gn_approach = device.svg.getElementById("p_dps_hsit_gn_approach");
    p_dps_hsit.entry_point = device.svg.getElementById("p_dps_hsit_entry_point");
    p_dps_hsit.aim = device.svg.getElementById("p_dps_hsit_aim");
    p_dps_hsit.sb = device.svg.getElementById("p_dps_hsit_sb");
    p_dps_hsit.pri_rwy = device.svg.getElementById("p_dps_hsit_pri_rwy");
    p_dps_hsit.sec_rwy = device.svg.getElementById("p_dps_hsit_sec_rwy");
    p_dps_hsit.gn_dir = device.svg.getElementById("p_dps_hsit_gn_dir");
    p_dps_hsit.hsi_dir = device.svg.getElementById("p_dps_hsit_hsi_dir");


    p_dps_hsit.nav_Dx = device.svg.getElementById("p_dps_hsit_nav_Dx");
    p_dps_hsit.nav_Dy = device.svg.getElementById("p_dps_hsit_nav_Dy");
    p_dps_hsit.nav_Dz = device.svg.getElementById("p_dps_hsit_nav_Dz");
    p_dps_hsit.nav_Dxdot = device.svg.getElementById("p_dps_hsit_nav_Dxdot");
    p_dps_hsit.nav_Dydot = device.svg.getElementById("p_dps_hsit_nav_Dydot");
    p_dps_hsit.nav_Dzdot = device.svg.getElementById("p_dps_hsit_nav_Dzdot");

    p_dps_hsit.tac_az_ratio = device.svg.getElementById("p_dps_hsit_tac_az_ratio");
    p_dps_hsit.tac_az_aut = device.svg.getElementById("p_dps_hsit_tac_az_aut");
    p_dps_hsit.tac_az_inh = device.svg.getElementById("p_dps_hsit_tac_az_inh");
    p_dps_hsit.tac_az_for = device.svg.getElementById("p_dps_hsit_tac_az_for");

    p_dps_hsit.gps_aut = device.svg.getElementById("p_dps_hsit_gps_aut");
    p_dps_hsit.gps_inh = device.svg.getElementById("p_dps_hsit_gps_inh");
    p_dps_hsit.gps_for = device.svg.getElementById("p_dps_hsit_gps_for");




    
    p_dps_hsit.ondisplay = func
    {
        device.DPS_menu_title.setText("HORIZ SIT");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/050/";
        device.DPS_menu_ops.setText(ops_string);

		
	# set defaults for functions which are not yet implemented

	p_dps_hsit.pti.setText("INH");
	p_dps_hsit.pti_index_1.setText("");
	p_dps_hsit.pti_index_2.setText("");
	p_dps_hsit.aim.setText("NOM");
	p_dps_hsit.sb.setText("NOM");
	p_dps_hsit.tac_az_aut.setText("");
	p_dps_hsit.tac_az_inh.setText("*");
	p_dps_hsit.tac_az_for.setText("");
	p_dps_hsit.gps_aut.setText("*");
	p_dps_hsit.gps_inh.setText("");
	p_dps_hsit.gps_for.setText("");

	# generate the symbols for the graphical part of the display

	var data = SpaceShuttle.draw_circle(24, 20);
	
	 p_dps_hsit.hac = device.symbols.createChild("path", "hac")
        .setStrokeLineWidth(1)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(data[0][0], data[0][1]);

 	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_dps_hsit.hac.lineTo(set[0], set[1]);
		}

	setsize(data,0);

	data = SpaceShuttle.draw_circle(3, 10);

	 p_dps_hsit.touchdown = device.symbols.createChild("path", "touchdown")
        .setStrokeLineWidth(1)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(data[0][0], data[0][1]);

	 p_dps_hsit.pred1 = device.symbols.createChild("path", "pred1")
        .setStrokeLineWidth(1)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(data[0][0], data[0][1]);

	 p_dps_hsit.pred2 = device.symbols.createChild("path", "pred2")
        .setStrokeLineWidth(1)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(data[0][0], data[0][1]);

	 p_dps_hsit.pred3 = device.symbols.createChild("path", "pred3")
        .setStrokeLineWidth(1)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(data[0][0], data[0][1]);


	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_dps_hsit.touchdown.lineTo(set[0], set[1]);
		p_dps_hsit.pred1.lineTo(set[0], set[1]);
		p_dps_hsit.pred2.lineTo(set[0], set[1]);
		p_dps_hsit.pred3.lineTo(set[0], set[1]);
		}

 	p_dps_hsit.aim = device.symbols.createChild("path", "aim")
        .setStrokeLineWidth(1)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(0,0);

	data = SpaceShuttle.draw_shuttle_top();

	 p_dps_hsit.shuttle_marker = device.symbols.createChild("path", "shuttle")
        .setStrokeLineWidth(0.25)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(data[0][0], data[0][1]);

	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_dps_hsit.shuttle_marker.lineTo(set[0], set[1]);
		}
	p_dps_hsit.shuttle_marker.setScale (5.0);
	p_dps_hsit.shuttle_marker.setTranslation (265, 265);

    }

    p_dps_hsit.offdisplay = func 
    {
    device.symbols.removeAllChildren();
    device.nom_traj_plot.removeAllChildren();
    }
    
    p_dps_hsit.update = func
    {
    

	var ops = getprop("/fdm/jsbsim/systems/dps/ops");
	var guidance_mode = getprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode");

	p_dps_hsit.altm.setText(sprintf("%2.2f", getprop("/instrumentation/altimeter/setting-inhg") ));
      
	if ((ops == 1) and (guidance_mode == 1))
		{
		p_dps_hsit.tal_site.setText(sprintf("%2d",SpaceShuttle.landing_site.index));
		p_dps_hsit.tal_label.setText("40 TAL  SITE");
		}
	else 
		{
		p_dps_hsit.tal_label.setText("");
		p_dps_hsit.tal_site.setText("");
		}


	if (guidance_mode == 1)
		{p_dps_hsit.landing_label.setText("41 LAND SITE");}
	else if (guidance_mode == 2)
		{p_dps_hsit.landing_label.setText("41 TAL  SITE");}
	else if (guidance_mode == 3)
		{p_dps_hsit.landing_label.setText("41 RTLS SITE");}
	else
		{p_dps_hsit.landing_label.setText("41 LAND SITE");}
	
	p_dps_hsit.landing_site.setText(sprintf("%2d",SpaceShuttle.landing_site.index));

	var string = getprop("/fdm/jsbsim/systems/taem-guidance/approach-mode-string");
	p_dps_hsit.gn_approach.setText(string);

	string = getprop("/fdm/jsbsim/systems/taem-guidance/entry-point-string");
	p_dps_hsit.entry_point.setText(string);

	string = "";
	var rwy_sel = "";
	if (SpaceShuttle.TAEM_guidance_available == 1)
		{
		if (SpaceShuttle.TAEM_WP_1.turn_direction == "left"){string = "L";}
		else {string = "R";}

		}
	p_dps_hsit.gn_dir.setText(string);
	p_dps_hsit.hsi_dir.setText(string);

	p_dps_hsit.pri_rwy.setText(SpaceShuttle.landing_site.rwy_pri);
	p_dps_hsit.sec_rwy.setText(SpaceShuttle.landing_site.rwy_sec);

	p_dps_hsit.tac_az_ratio.setText(sprintf("%2.1f", getprop("/fdm/jsbsim/systems/navigation/state-vector/error-tacan/quality-ang")));

	p_dps_hsit.nav_Dx.setText(sprintf("%+4.2f", getprop("/fdm/jsbsim/systems/taem-guidance/Dx")));
	p_dps_hsit.nav_Dy.setText(sprintf("%+4.2f", getprop("/fdm/jsbsim/systems/taem-guidance/Dy")));
	p_dps_hsit.nav_Dz.setText(sprintf("%+4.2f", getprop("/fdm/jsbsim/systems/taem-guidance/Dz")));

	p_dps_hsit.nav_Dxdot.setText(sprintf("%+3.1f", getprop("/fdm/jsbsim/systems/taem-guidance/Dxdot")));
	p_dps_hsit.nav_Dydot.setText(sprintf("%+3.1f", getprop("/fdm/jsbsim/systems/taem-guidance/Dydot")));
	p_dps_hsit.nav_Dzdot.setText(sprintf("%+3.1f", getprop("/fdm/jsbsim/systems/taem-guidance/Dzdot")));

	# create the graphical portion of the display

	if (SpaceShuttle.TAEM_guidance_available == 1)
	{


	# the graphical portion is a 230 x 140 sheet at 150-380:90-230 
	var pos = geo.aircraft_position();

	var dist = pos.distance_to(SpaceShuttle.TAEM_HAC_center);
	var rel_angle = math.pi / 180.0 * (pos.course_to(SpaceShuttle.TAEM_HAC_center) - getprop("/orientation/heading-deg"));

	var x = SpaceShuttle.get_hsit_x(dist, rel_angle);
	var y = SpaceShuttle.get_hsit_y(dist, rel_angle);

	p_dps_hsit.hac.setTranslation (x,y);

	dist = pos.distance_to(SpaceShuttle.TAEM_threshold);
	rel_angle = math.pi / 180.0 * (pos.course_to(SpaceShuttle.TAEM_threshold) - getprop("/orientation/heading-deg"));


	x = SpaceShuttle.get_hsit_x(dist, rel_angle);
	y = SpaceShuttle.get_hsit_y(dist, rel_angle);

	p_dps_hsit.touchdown.setTranslation (x,y);

	device.nom_traj_plot.removeAllChildren();
 	var plot = device.nom_traj_plot.createChild("path", "data")
        .setStrokeLineWidth(1)
        .setColor(dps_r,dps_g,dps_b)
        .moveTo(x,y);

	dist = pos.distance_to(SpaceShuttle.TAEM_WP_2);
	rel_angle = math.pi / 180.0 * (pos.course_to(SpaceShuttle.TAEM_WP_2) - getprop("/orientation/heading-deg"));

	x = SpaceShuttle.get_hsit_x(dist, rel_angle);
	y = SpaceShuttle.get_hsit_y(dist, rel_angle);
	
	plot.lineTo(x,y);

	x = SpaceShuttle.get_hsit_x(SpaceShuttle.TAEM_predictor_set.entry[0][0], SpaceShuttle.TAEM_predictor_set.entry[0][1]);
	y = SpaceShuttle.get_hsit_y(SpaceShuttle.TAEM_predictor_set.entry[0][0], SpaceShuttle.TAEM_predictor_set.entry[0][1]);

	p_dps_hsit.pred1.setTranslation (x,y);

	x = SpaceShuttle.get_hsit_x(SpaceShuttle.TAEM_predictor_set.entry[1][0], SpaceShuttle.TAEM_predictor_set.entry[1][1]);
	y = SpaceShuttle.get_hsit_y(SpaceShuttle.TAEM_predictor_set.entry[1][0], SpaceShuttle.TAEM_predictor_set.entry[1][1]);

	p_dps_hsit.pred2.setTranslation (x,y);

	x = SpaceShuttle.get_hsit_x(SpaceShuttle.TAEM_predictor_set.entry[2][0], SpaceShuttle.TAEM_predictor_set.entry[2][1]);
	y = SpaceShuttle.get_hsit_y(SpaceShuttle.TAEM_predictor_set.entry[2][0], SpaceShuttle.TAEM_predictor_set.entry[2][1]);

	p_dps_hsit.pred3.setTranslation (x,y);


	}




    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_hsit;
}
