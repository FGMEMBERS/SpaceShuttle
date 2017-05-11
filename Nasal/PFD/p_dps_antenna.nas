#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_antenna
# Description: the Antennta  page
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_dps_antenna = func(device)
{
    var p_dps_antenna = device.addPage("CRTAntenna", "p_dps_antenna");
    
    p_dps_antenna.group = device.svg.getElementById("p_dps_antenna");
    p_dps_antenna.group.setColor(dps_r, dps_g, dps_b);

    p_dps_antenna.stdn = device.svg.getElementById("p_dps_antenna_stdn");
    p_dps_antenna.mode = device.svg.getElementById("p_dps_antenna_mode");
    p_dps_antenna.ant_pm = device.svg.getElementById("p_dps_antenna_ant_pm");
    p_dps_antenna.ant_fm = device.svg.getElementById("p_dps_antenna_ant_fm");
    p_dps_antenna.gpc_ptg_ovrd = device.svg.getElementById("p_dps_antenna_gpc_ptg_ovrd");
    p_dps_antenna.gpc_ptg_ena = device.svg.getElementById("p_dps_antenna_gpc_ptg_ena");
    p_dps_antenna.gpc_ptg_inh = device.svg.getElementById("p_dps_antenna_gpc_ptg_inh");

    p_dps_antenna.el_act = device.svg.getElementById("p_dps_antenna_el_act");
    p_dps_antenna.az_act = device.svg.getElementById("p_dps_antenna_az_act");
    p_dps_antenna.el_cmd = device.svg.getElementById("p_dps_antenna_el_cmd");
    p_dps_antenna.az_cmd = device.svg.getElementById("p_dps_antenna_az_cmd");

    p_dps_antenna.lon1 = device.svg.getElementById("p_dps_antenna_lon1");
    p_dps_antenna.lon2 = device.svg.getElementById("p_dps_antenna_lon2");
    p_dps_antenna.lon3 = device.svg.getElementById("p_dps_antenna_lon3");
    p_dps_antenna.lon4 = device.svg.getElementById("p_dps_antenna_lon4");
    p_dps_antenna.lon5 = device.svg.getElementById("p_dps_antenna_lon5");
    p_dps_antenna.lon6 = device.svg.getElementById("p_dps_antenna_lon6");

    p_dps_antenna.view1 = device.svg.getElementById("p_dps_antenna_view1");
    p_dps_antenna.view2 = device.svg.getElementById("p_dps_antenna_view2");
    p_dps_antenna.view3 = device.svg.getElementById("p_dps_antenna_view3");
    p_dps_antenna.view4 = device.svg.getElementById("p_dps_antenna_view4");
    p_dps_antenna.view5 = device.svg.getElementById("p_dps_antenna_view5");
    p_dps_antenna.view6 = device.svg.getElementById("p_dps_antenna_view6");

    p_dps_antenna.view1.enableUpdate(); 
    p_dps_antenna.view2.enableUpdate();
    p_dps_antenna.view3.enableUpdate();
    p_dps_antenna.view4.enableUpdate();
    p_dps_antenna.view5.enableUpdate();
    p_dps_antenna.view6.enableUpdate();

    p_dps_antenna.tgt_a1 = device.svg.getElementById("p_dps_antenna_tgt_a1");
    p_dps_antenna.tgt_a2 = device.svg.getElementById("p_dps_antenna_tgt_a2");
    p_dps_antenna.tgt_a3 = device.svg.getElementById("p_dps_antenna_tgt_a3");
    p_dps_antenna.tgt_a4 = device.svg.getElementById("p_dps_antenna_tgt_a4");
    p_dps_antenna.tgt_a5 = device.svg.getElementById("p_dps_antenna_tgt_a5");
    p_dps_antenna.tgt_a6 = device.svg.getElementById("p_dps_antenna_tgt_a6");

    p_dps_antenna.tgt_a1.enableUpdate(); 
    p_dps_antenna.tgt_a2.enableUpdate(); 
    p_dps_antenna.tgt_a3.enableUpdate(); 
    p_dps_antenna.tgt_a4.enableUpdate(); 
    p_dps_antenna.tgt_a5.enableUpdate(); 
    p_dps_antenna.tgt_a6.enableUpdate(); 

    p_dps_antenna.tgt_b1 = device.svg.getElementById("p_dps_antenna_tgt_b1");
    p_dps_antenna.tgt_b2 = device.svg.getElementById("p_dps_antenna_tgt_b2");
    p_dps_antenna.tgt_b3 = device.svg.getElementById("p_dps_antenna_tgt_b3");
    p_dps_antenna.tgt_b4 = device.svg.getElementById("p_dps_antenna_tgt_b4");
    p_dps_antenna.tgt_b5 = device.svg.getElementById("p_dps_antenna_tgt_b5");
    p_dps_antenna.tgt_b6 = device.svg.getElementById("p_dps_antenna_tgt_b6");

    p_dps_antenna.tgt_b1.enableUpdate(); 
    p_dps_antenna.tgt_b2.enableUpdate(); 
    p_dps_antenna.tgt_b3.enableUpdate(); 
    p_dps_antenna.tgt_b4.enableUpdate(); 
    p_dps_antenna.tgt_b5.enableUpdate(); 
    p_dps_antenna.tgt_b6.enableUpdate(); 

    p_dps_antenna.gpck1 = device.svg.getElementById("p_dps_antenna_gpck1");
    p_dps_antenna.gpck2 = device.svg.getElementById("p_dps_antenna_gpck2");
    p_dps_antenna.gpck3 = device.svg.getElementById("p_dps_antenna_gpck3");
    p_dps_antenna.gpck4 = device.svg.getElementById("p_dps_antenna_gpck4");
    p_dps_antenna.gpck5 = device.svg.getElementById("p_dps_antenna_gpck5");
    p_dps_antenna.gpck6 = device.svg.getElementById("p_dps_antenna_gpck6");

    p_dps_antenna.gpck1.enableUpdate();
    p_dps_antenna.gpck2.enableUpdate();
    p_dps_antenna.gpck3.enableUpdate();
    p_dps_antenna.gpck4.enableUpdate();
    p_dps_antenna.gpck5.enableUpdate();
    p_dps_antenna.gpck6.enableUpdate();

    p_dps_antenna.gpcs1 = device.svg.getElementById("p_dps_antenna_gpcs1");
    p_dps_antenna.gpcs2 = device.svg.getElementById("p_dps_antenna_gpcs2");
    p_dps_antenna.gpcs3 = device.svg.getElementById("p_dps_antenna_gpcs3");
    p_dps_antenna.gpcs4 = device.svg.getElementById("p_dps_antenna_gpcs4");
    p_dps_antenna.gpcs5 = device.svg.getElementById("p_dps_antenna_gpcs5");
    p_dps_antenna.gpcs6 = device.svg.getElementById("p_dps_antenna_gpcs6");


    p_dps_antenna.tdrs_ku_a_pri = device.svg.getElementById("p_dps_antenna_tdrs_ku_a_pri");
    p_dps_antenna.tdrs_ku_b_pri = device.svg.getElementById("p_dps_antenna_tdrs_ku_b_pri");
    p_dps_antenna.tdrs_s_a_pri = device.svg.getElementById("p_dps_antenna_tdrs_s_a_pri");
    p_dps_antenna.tdrs_s_b_pri = device.svg.getElementById("p_dps_antenna_tdrs_s_b_pri");

    p_dps_antenna.tdrs_ku_a_pri.enableUpdate();
    p_dps_antenna.tdrs_ku_b_pri.enableUpdate();
    p_dps_antenna.tdrs_s_a_pri.enableUpdate();
    p_dps_antenna.tdrs_s_b_pri.enableUpdate();

    p_dps_antenna.rdr_rng_auto = device.svg.getElementById("p_dps_antenna_rdr_rng_auto");
    p_dps_antenna.rdr_rng_min = device.svg.getElementById("p_dps_antenna_rdr_rng_min");

    p_dps_antenna.tdrs_ku = device.svg.getElementById("p_dps_antenna_tdrs_ku");
    p_dps_antenna.pos_marker = device.svg.getElementById("p_dps_antenna_pos_marker");

    p_dps_antenna.tdrs_ku.enableUpdate();

    p_dps_antenna.ant_elec = device.svg.getElementById("p_dps_antenna_ant_elec");
    p_dps_antenna.ku_ss = device.svg.getElementById("p_dps_antenna_ku_ss");
    p_dps_antenna.s_ss = device.svg.getElementById("p_dps_antenna_s_ss");

    p_dps_antenna.ku_io_reset = device.svg.getElementById("p_dps_antenna_ku_io_reset");
    p_dps_antenna.ku_self_test = device.svg.getElementById("p_dps_antenna_ku_self_test");


    p_dps_antenna.ondisplay = func
    {

	p_dps_antenna.lon1.setText(sprintf("%3.0f", SpaceShuttle.com_TDRS_array[0].coord.lon() ));
	p_dps_antenna.lon2.setText(sprintf("%3.0f", SpaceShuttle.com_TDRS_array[1].coord.lon() ));
	p_dps_antenna.lon3.setText(sprintf("%3.0f", SpaceShuttle.com_TDRS_array[2].coord.lon() ));
	p_dps_antenna.lon4.setText(sprintf("%3.0f", SpaceShuttle.com_TDRS_array[3].coord.lon() ));
	p_dps_antenna.lon5.setText(sprintf("%3.0f", SpaceShuttle.com_TDRS_array[4].coord.lon() ));
	p_dps_antenna.lon6.setText(sprintf("%3.0f", SpaceShuttle.com_TDRS_array[5].coord.lon() ));

 	p_dps_antenna.gpcs1.setText("");
 	p_dps_antenna.gpcs2.setText("");
 	p_dps_antenna.gpcs3.setText("");
 	p_dps_antenna.gpcs4.setText("");
 	p_dps_antenna.gpcs5.setText("");
 	p_dps_antenna.gpcs6.setText("");

	p_dps_antenna.gpc_ptg_ena.setText("*");
	p_dps_antenna.gpc_ptg_inh.setText("");
	p_dps_antenna.gpc_ptg_ovrd.setText("");

	p_dps_antenna.ku_self_test.setText("");

	p_dps_antenna.rdr_rng_auto.setText("*");
	p_dps_antenna.rdr_rng_min.setText("");

	p_dps_antenna.ant_elec.setText("1");
 	p_dps_antenna.ku_ss.setText("2.23");

        device.DPS_menu_title.setText("ANTENNA");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = "2011/   /";
        device.DPS_menu_ops.setText(ops_string);
    
    }
    
    p_dps_antenna.update = func
    {

	p_dps_antenna.stdn.setText(SpaceShuttle.antenna_manager.station); 
	p_dps_antenna.mode.setText(SpaceShuttle.antenna_manager.mode); 

	p_dps_antenna.ant_pm.setText(SpaceShuttle.antenna_manager.quadrant); 
	p_dps_antenna.ant_fm.setText(SpaceShuttle.antenna_manager.hemisphere); 

	if (SpaceShuttle.antenna_manager.ku_operational == 1)
		{
		p_dps_antenna.el_act.setText(sprintf("%+2.1f", SpaceShuttle.antenna_manager.ku_elevation));
		p_dps_antenna.az_act.setText(sprintf("%+3.1f", SpaceShuttle.antenna_manager.ku_azimuth));
		p_dps_antenna.pos_marker.setVisible(1);
		}
	else
		{
		p_dps_antenna.el_act.setText("");
		p_dps_antenna.az_act.setText("");
		p_dps_antenna.pos_marker.setVisible(0);
		}
	

	p_dps_antenna.el_cmd.setText(sprintf("%+2.1f", SpaceShuttle.antenna_manager.ku_elevation_cmd));
	p_dps_antenna.az_cmd.setText(sprintf("%+3.1f", SpaceShuttle.antenna_manager.ku_azimuth_cmd));



	

	var azimuth = SpaceShuttle.antenna_manager.ku_azimuth + 180.0;
	if (azimuth > 360.0) {azimuth = azimuth - 360.0;}
	var marker_x = 140.0 + 0.72 * azimuth;
	var marker_y = 75.0  + 0.72 * (90.0-SpaceShuttle.antenna_manager.ku_elevation);

	p_dps_antenna.pos_marker.setTranslation(marker_x,marker_y);


	if (SpaceShuttle.antenna_manager.TDRS_view_array[0] == 1)
		{p_dps_antenna.view1.updateText("*");}
	else
		{p_dps_antenna.view1.updateText("");}

	if (SpaceShuttle.antenna_manager.TDRS_view_array[1] == 1)
		{p_dps_antenna.view2.updateText("*");}
	else
		{p_dps_antenna.view2.updateText("");}

	if (SpaceShuttle.antenna_manager.TDRS_view_array[2] == 1)
		{p_dps_antenna.view3.updateText("*");}
	else
		{p_dps_antenna.view3.updateText("");}

	if (SpaceShuttle.antenna_manager.TDRS_view_array[3] == 1)
		{p_dps_antenna.view4.updateText("*");}
	else
		{p_dps_antenna.view4.updateText("");}

	if (SpaceShuttle.antenna_manager.TDRS_view_array[4] == 1)
		{p_dps_antenna.view5.updateText("*");}
	else
		{p_dps_antenna.view5.updateText("");}

	if (SpaceShuttle.antenna_manager.TDRS_view_array[5] == 1)
		{p_dps_antenna.view6.updateText("*");}
	else
		{p_dps_antenna.view6.updateText("");}

	var string = "";
	if (SpaceShuttle.antenna_manager.TDRS_A == 1) {string = "*";}
	p_dps_antenna.tgt_a1.updateText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_A == 2) {string = "*";}
	p_dps_antenna.tgt_a2.updateText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_A == 3) {string = "*";}
	p_dps_antenna.tgt_a3.updateText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_A == 4) {string = "*";}
	p_dps_antenna.tgt_a4.updateText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_A == 5) {string = "*";}
	p_dps_antenna.tgt_a5.updateText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_A == 6) {string = "*";}
	p_dps_antenna.tgt_a6.updateText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_B == 1) {string = "*";}
	p_dps_antenna.tgt_b1.updateText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_B == 2) {string = "*";}
	p_dps_antenna.tgt_b2.updateText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_B == 3) {string = "*";}
	p_dps_antenna.tgt_b3.updateText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_B == 4) {string = "*";}
	p_dps_antenna.tgt_b4.updateText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_B == 5) {string = "*";}
	p_dps_antenna.tgt_b5.updateText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_B == 6) {string = "*";}
	p_dps_antenna.tgt_b6.updateText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_ku_primary == "A") {string = "*";}
 	p_dps_antenna.tdrs_ku_a_pri.updateText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_ku_primary == "B") {string = "*";}
 	p_dps_antenna.tdrs_ku_b_pri.updateText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_s_primary == "A") {string = "*";}
 	p_dps_antenna.tdrs_s_a_pri.updateText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_s_primary == "B") {string = "*";}
 	p_dps_antenna.tdrs_s_b_pri.updateText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_ku_track == 1) {string = "*";}
	p_dps_antenna.gpck1.updateText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_ku_track == 2) {string = "*";}
	p_dps_antenna.gpck2.updateText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_ku_track == 3) {string = "*";}
	p_dps_antenna.gpck3.updateText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_ku_track == 4) {string = "*";}
	p_dps_antenna.gpck4.updateText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_ku_track == 5) {string = "*";}
	p_dps_antenna.gpck5.updateText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_ku_track == 6) {string = "*";}
	p_dps_antenna.gpck6.updateText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_ku_tgt == 1) {string = "TGT";}
	p_dps_antenna.tdrs_ku.updateText(string);

	p_dps_antenna.s_ss.setText(sprintf("%1.2f", SpaceShuttle.antenna_manager.signal_strength_s));

	p_dps_antenna.ku_ss.setText(sprintf("%1.2f", SpaceShuttle.antenna_manager.ku_operational * 2.3));

	string = "*";
	if (SpaceShuttle.antenna_manager.gpc_io == 0) {string = "M";}
	p_dps_antenna.ku_io_reset.setText(string);

        device.update_common_DPS();
    }
    
    
    
    return p_dps_antenna;
}
