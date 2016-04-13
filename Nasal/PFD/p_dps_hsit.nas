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
    p_dps_hsit.gps_fom = device.svg.getElementById("p_dps_hsit_gps_fom");
    p_dps_hsit.gps_ra = device.svg.getElementById("p_dps_hsit_gps_ra");


    p_dps_hsit.pri_rwy_sel = device.svg.getElementById("p_dps_hsit_pri_rwy_sel");
    p_dps_hsit.sec_rwy_sel = device.svg.getElementById("p_dps_hsit_sec_rwy_sel");

    p_dps_hsit.nav_Dx = device.svg.getElementById("p_dps_hsit_nav_Dx");
    p_dps_hsit.nav_Dy = device.svg.getElementById("p_dps_hsit_nav_Dy");
    p_dps_hsit.nav_Dz = device.svg.getElementById("p_dps_hsit_nav_Dz");
    p_dps_hsit.nav_Dxdot = device.svg.getElementById("p_dps_hsit_nav_Dxdot");
    p_dps_hsit.nav_Dydot = device.svg.getElementById("p_dps_hsit_nav_Dydot");
    p_dps_hsit.nav_Dzdot = device.svg.getElementById("p_dps_hsit_nav_Dzdot");
    p_dps_hsit.Dt = device.svg.getElementById("p_dps_hsit_Dt");


    p_dps_hsit.tac_az_ratio = device.svg.getElementById("p_dps_hsit_tac_az_ratio");
    p_dps_hsit.tac_az_resid = device.svg.getElementById("p_dps_hsit_tac_az_resid");
    p_dps_hsit.tac_az_aut = device.svg.getElementById("p_dps_hsit_tac_az_aut");
    p_dps_hsit.tac_az_inh = device.svg.getElementById("p_dps_hsit_tac_az_inh");
    p_dps_hsit.tac_az_for = device.svg.getElementById("p_dps_hsit_tac_az_for");

    p_dps_hsit.tac_rng_resid = device.svg.getElementById("p_dps_hsit_tac_rng_resid");
    p_dps_hsit.tac_rng_ratio = device.svg.getElementById("p_dps_hsit_tac_rng_ratio");

    p_dps_hsit.dragh_resid = device.svg.getElementById("p_dps_hsit_dragh_resid");
    p_dps_hsit.dragh_ratio = device.svg.getElementById("p_dps_hsit_dragh_ratio");

    p_dps_hsit.gps_resid = device.svg.getElementById("p_dps_hsit_gps_resid");
    p_dps_hsit.gps_ratio = device.svg.getElementById("p_dps_hsit_gps_ratio");

    p_dps_hsit.adtah_resid = device.svg.getElementById("p_dps_hsit_adtah_resid");
    p_dps_hsit.adtah_ratio = device.svg.getElementById("p_dps_hsit_adtah_ratio");

    p_dps_hsit.gps_aut = device.svg.getElementById("p_dps_hsit_gps_aut");
    p_dps_hsit.gps_inh = device.svg.getElementById("p_dps_hsit_gps_inh");
    p_dps_hsit.gps_for = device.svg.getElementById("p_dps_hsit_gps_for");

    p_dps_hsit.abs = device.svg.getElementById("p_dps_hsit_abs");
    p_dps_hsit.delta = device.svg.getElementById("p_dps_hsit_delta");

    p_dps_hsit.tac_az_tac1 = device.svg.getElementById("p_dps_hsit_tac_az_tac1");
    p_dps_hsit.tac_az_tac2 = device.svg.getElementById("p_dps_hsit_tac_az_tac2");
    p_dps_hsit.tac_az_tac3 = device.svg.getElementById("p_dps_hsit_tac_az_tac3");

    p_dps_hsit.tac_rng_tac1 = device.svg.getElementById("p_dps_hsit_tac_rng_tac1");
    p_dps_hsit.tac_rng_tac2 = device.svg.getElementById("p_dps_hsit_tac_rng_tac2");
    p_dps_hsit.tac_rng_tac3 = device.svg.getElementById("p_dps_hsit_tac_rng_tac3");

    p_dps_hsit.tac1_des = device.svg.getElementById("p_dps_hsit_tac1_des");
    p_dps_hsit.tac2_des = device.svg.getElementById("p_dps_hsit_tac2_des");
    p_dps_hsit.tac3_des = device.svg.getElementById("p_dps_hsit_tac3_des");
    
    p_dps_hsit.tac = device.svg.getElementById("p_dps_hsit_tac");
    p_dps_hsit.tac1 = device.svg.getElementById("p_dps_hsit_tac1");
    p_dps_hsit.tac2 = device.svg.getElementById("p_dps_hsit_tac2");
    p_dps_hsit.tac3 = device.svg.getElementById("p_dps_hsit_tac3");


    p_dps_hsit.statlabel = device.svg.getElementById("p_dps_hsit_statlabel");

    p_dps_hsit.adtah_aut = device.svg.getElementById("p_dps_hsit_adtah_aut");
    p_dps_hsit.adtah_inh = device.svg.getElementById("p_dps_hsit_adtah_inh");
    p_dps_hsit.adtah_for = device.svg.getElementById("p_dps_hsit_adtah_for");

    p_dps_hsit.dragh_aut = device.svg.getElementById("p_dps_hsit_dragh_aut");
    p_dps_hsit.dragh_inh = device.svg.getElementById("p_dps_hsit_dragh_inh");
    p_dps_hsit.dragh_for = device.svg.getElementById("p_dps_hsit_dragh_for");

    p_dps_hsit.adta_aut = device.svg.getElementById("p_dps_hsit_adta_aut");
    p_dps_hsit.adta_inh = device.svg.getElementById("p_dps_hsit_adta_inh");
    p_dps_hsit.adta_for = device.svg.getElementById("p_dps_hsit_adta_for");

    p_dps_hsit.aif1 = device.svg.getElementById("p_dps_hsit_aif1");
    p_dps_hsit.aif2 = device.svg.getElementById("p_dps_hsit_aif2");
    p_dps_hsit.aif3 = device.svg.getElementById("p_dps_hsit_aif3");

    p_dps_hsit.gps_s_rn = device.svg.getElementById("p_dps_hsit_gps_s_rn");
    p_dps_hsit.gps_az = device.svg.getElementById("p_dps_hsit_gps_az");
    p_dps_hsit.gps_h = device.svg.getElementById("p_dps_hsit_gps_h");



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
	p_dps_hsit.Dt.setText("+00:00");
	p_dps_hsit.statlabel.setText("");
	p_dps_hsit.adtah_aut.setText("");
	p_dps_hsit.adtah_inh.setText("*");
	p_dps_hsit.adtah_for.setText("");
	p_dps_hsit.dragh_aut.setText("");
	p_dps_hsit.dragh_inh.setText("*");
	p_dps_hsit.dragh_for.setText("");
	p_dps_hsit.adta_aut.setText("");
	p_dps_hsit.adta_inh.setText("*");
	p_dps_hsit.adta_for.setText("");
	p_dps_hsit.aif1.setText("");
	p_dps_hsit.aif2.setText("*");
	p_dps_hsit.aif3.setText("");
	p_dps_hsit.gps_fom.setText("4");
	p_dps_hsit.gps_ra.setText("");

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
        .setColor(0.8, 0.8, 0.4)
	.moveTo(data[0][0], data[0][1]);

	 p_dps_hsit.pred2 = device.symbols.createChild("path", "pred2")
        .setStrokeLineWidth(1)
        .setColor(0.8, 0.8, 0.4)
	.moveTo(data[0][0], data[0][1]);

	 p_dps_hsit.pred3 = device.symbols.createChild("path", "pred3")
        .setStrokeLineWidth(1)
        .setColor(0.8, 0.8, 0.4)
	.moveTo(data[0][0], data[0][1]);


	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_dps_hsit.touchdown.lineTo(set[0], set[1]);
		p_dps_hsit.pred1.lineTo(set[0], set[1]);
		p_dps_hsit.pred2.lineTo(set[0], set[1]);
		p_dps_hsit.pred3.lineTo(set[0], set[1]);
		}

 	p_dps_hsit.aimpoint = device.symbols.createChild("path", "aimpoint")
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
      
	if ((ops == 1) and (guidance_mode == 0))
		{
		var tal_iloaded = getprop("/fdm/jsbsim/systems/entry_guidance/tal-site-iloaded");
		p_dps_hsit.tal_site.setText(sprintf("%2d",tal_iloaded));
		p_dps_hsit.tal_label.setText("40 TAL  SITE");
		}
	else 
		{
		p_dps_hsit.tal_label.setText("");
		p_dps_hsit.tal_site.setText("");
		}


	if ((guidance_mode == 1) or (guidance_mode == 0))
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
	var field_altitude = 0.0;
	if (SpaceShuttle.TAEM_guidance_available == 1)
		{
		if (SpaceShuttle.TAEM_WP_1.turn_direction == "left"){string = "L";}
		else {string = "R";}
		field_altitude = SpaceShuttle.TAEM_threshold.elevation;
		}


	p_dps_hsit.gn_dir.setText(string);
	p_dps_hsit.hsi_dir.setText(string);

	p_dps_hsit.pri_rwy.setText(SpaceShuttle.landing_site.rwy_pri);
	p_dps_hsit.sec_rwy.setText(SpaceShuttle.landing_site.rwy_sec);

	var tacan_disp_mode = getprop("/fdm/jsbsim/systems/taem-guidance/tacan-abs");

	string = "";
	if (tacan_disp_mode == 1) {string = "*";}
	p_dps_hsit.abs.setText(string);

	string = "";
	if (tacan_disp_mode == 0) {string = "*";}
	p_dps_hsit.delta.setText(string);

	string = "";
	var tacan1_des = getprop("/fdm/jsbsim/systems/taem-guidance/tacan1-des");
	if (tacan1_des == 1){string = "*";}
	p_dps_hsit.tac1_des.setText(string);

	string = "";
	var tacan2_des = getprop("/fdm/jsbsim/systems/taem-guidance/tacan2-des");
	if (tacan2_des == 1){string = "*";}
	p_dps_hsit.tac2_des.setText(string);

	string = "";
	var tacan3_des = getprop("/fdm/jsbsim/systems/taem-guidance/tacan3-des");
	if (tacan3_des == 1){string = "*";}
	p_dps_hsit.tac3_des.setText(string);
	
	string = "";
	if (SpaceShuttle.landing_site.rwy_sel == 0){string = "*";}
	p_dps_hsit.pri_rwy_sel.setText(string);

	string = "";
	if (SpaceShuttle.landing_site.rwy_sel == 1){string = "*";}
	p_dps_hsit.sec_rwy_sel.setText(string);

	var error_pos_m = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/pos-m");
	var error_ang_deg = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/angle-deg");	

	var tacan_quality_ang = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-tacan/quality-ang");
	var tacan_quality_pos = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-tacan/quality-pos");

	var adta_quality_pos = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-adta/quality-pos");
	var drag_h_quality_pos = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-drag-h/quality-pos");
	var gps_quality_pos = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-gps/quality-pos");

	var tacan_resid_pos = error_pos_m * tacan_quality_pos / 0.3048;
	var tacan_resid_ang = error_ang_deg * tacan_quality_ang;

	var adta_resid_pos = error_pos_m * adta_quality_pos / 0.3048;
	var drag_h_resid_pos = error_pos_m * drag_h_quality_pos / 0.3048;
	var gps_resid_pos = error_pos_m * gps_quality_pos / 0.3048;

	p_dps_hsit.adtah_resid.setText(sprintf("%5.0f", adta_resid_pos));
	p_dps_hsit.adtah_ratio.setText(sprintf("%2.1f", adta_quality_pos));

	p_dps_hsit.dragh_resid.setText(sprintf("%5.0f", drag_h_resid_pos));
	p_dps_hsit.dragh_ratio.setText(sprintf("%2.1f", drag_h_quality_pos));

	p_dps_hsit.gps_resid.setText(sprintf("%5.0f", gps_resid_pos));
	p_dps_hsit.gps_ratio.setText(sprintf("%2.1f", gps_quality_pos));

	p_dps_hsit.tac.setText(SpaceShuttle.landing_site.tacan);
	p_dps_hsit.tac1.setText(SpaceShuttle.landing_site.tacan);
	p_dps_hsit.tac2.setText(SpaceShuttle.landing_site.tacan);
	p_dps_hsit.tac3.setText(SpaceShuttle.landing_site.tacan);

	if (SpaceShuttle.TAEM_guidance_available == 1)
		{
		p_dps_hsit.tac_az_ratio.setText(sprintf("%2.1f", tacan_quality_ang));
		p_dps_hsit.tac_rng_ratio.setText(sprintf("%2.1f", tacan_quality_pos));

		p_dps_hsit.tac_az_resid.setText(sprintf("%2.2f", tacan_resid_ang));
		p_dps_hsit.tac_rng_resid.setText(sprintf("%2.2f", tacan_resid_pos));

		var course = getprop("/fdm/jsbsim/systems/taem-guidance/course");
		var heading = getprop("/orientation/heading-deg");
		var range = getprop("/fdm/jsbsim/systems/taem-guidance/distance-to-runway-nm");

		var course_disp = course;
		if (tacan_disp_mode == 0) {course_disp = course - heading;}
		
		if (tacan1_des == 0)
			{
			p_dps_hsit.tac_az_tac1.setText(sprintf("%+3.2f", course_disp));
			p_dps_hsit.tac_rng_tac1.setText(sprintf("%+3.2f", range));
			}
		else
			{
			p_dps_hsit.tac_az_tac1.setText("");
			p_dps_hsit.tac_rng_tac1.setText("");
			}

		if (tacan2_des == 0)
			{
			p_dps_hsit.tac_az_tac2.setText(sprintf("%+3.2f", course_disp));
			p_dps_hsit.tac_rng_tac2.setText(sprintf("%+3.2f", range));
			}
		else
			{
			p_dps_hsit.tac_az_tac2.setText("");
			p_dps_hsit.tac_rng_tac2.setText("");
			}

		if (tacan3_des == 0)
			{
			p_dps_hsit.tac_az_tac3.setText(sprintf("%+3.2f", course_disp));
			p_dps_hsit.tac_rng_tac3.setText(sprintf("%+3.2f", range));
			}
		else
			{
			p_dps_hsit.tac_az_tac3.setText("");
			p_dps_hsit.tac_rng_tac3.setText("");
			}
	
		var altitude_above_site = (getprop("/position/altitude-ft") - field_altitude)/1000.0;

  		p_dps_hsit.gps_s_rn.setText(sprintf("%+3.2f",range));
    		p_dps_hsit.gps_az.setText(sprintf("%+3.2f", course_disp));
		p_dps_hsit.gps_h.setText(sprintf("%3.1f", altitude_above_site));


		
		}

	else
		{
		p_dps_hsit.tac_az_ratio.setText("");
		p_dps_hsit.tac_rng_ratio.setText("");
		p_dps_hsit.tac_az_resid.setText("");
		p_dps_hsit.tac_rng_resid.setText("");
		p_dps_hsit.tac_az_tac1.setText("");
		p_dps_hsit.tac_az_tac2.setText("");
		p_dps_hsit.tac_az_tac3.setText("");
		p_dps_hsit.tac_rng_tac1.setText("");
		p_dps_hsit.tac_rng_tac2.setText("");
		p_dps_hsit.tac_rng_tac3.setText("");

  		p_dps_hsit.gps_s_rn.setText("");
    		p_dps_hsit.gps_az.setText("");
		p_dps_hsit.gps_h.setText("");

		}

	



	p_dps_hsit.nav_Dx.setText(sprintf("%+4.2f", getprop("/fdm/jsbsim/systems/taem-guidance/Dx")));
	p_dps_hsit.nav_Dy.setText(sprintf("%+4.2f", getprop("/fdm/jsbsim/systems/taem-guidance/Dy")));
	p_dps_hsit.nav_Dz.setText(sprintf("%+4.2f", getprop("/fdm/jsbsim/systems/taem-guidance/Dz")));

	p_dps_hsit.nav_Dxdot.setText(sprintf("%+3.1f", getprop("/fdm/jsbsim/systems/taem-guidance/Dxdot")));
	p_dps_hsit.nav_Dydot.setText(sprintf("%+3.1f", getprop("/fdm/jsbsim/systems/taem-guidance/Dydot")));
	p_dps_hsit.nav_Dzdot.setText(sprintf("%+3.1f", getprop("/fdm/jsbsim/systems/taem-guidance/Dzdot")));



	if (SpaceShuttle.TAEM_guidance_available == 1)
	{


	# create the graphical portion of the display
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
