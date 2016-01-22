#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_antenna
# Description: the Antennta  page
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_dps_antenna = func(device)
{
    var p_dps_antenna = device.addPage("CRTAntenna", "p_dps_antenna");
    
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

    p_dps_antenna.tgt_a1 = device.svg.getElementById("p_dps_antenna_tgt_a1");
    p_dps_antenna.tgt_a2 = device.svg.getElementById("p_dps_antenna_tgt_a2");
    p_dps_antenna.tgt_a3 = device.svg.getElementById("p_dps_antenna_tgt_a3");
    p_dps_antenna.tgt_a4 = device.svg.getElementById("p_dps_antenna_tgt_a4");
    p_dps_antenna.tgt_a5 = device.svg.getElementById("p_dps_antenna_tgt_a5");
    p_dps_antenna.tgt_a6 = device.svg.getElementById("p_dps_antenna_tgt_a6");

    p_dps_antenna.tgt_b1 = device.svg.getElementById("p_dps_antenna_tgt_b1");
    p_dps_antenna.tgt_b2 = device.svg.getElementById("p_dps_antenna_tgt_b2");
    p_dps_antenna.tgt_b3 = device.svg.getElementById("p_dps_antenna_tgt_b3");
    p_dps_antenna.tgt_b4 = device.svg.getElementById("p_dps_antenna_tgt_b4");
    p_dps_antenna.tgt_b5 = device.svg.getElementById("p_dps_antenna_tgt_b5");
    p_dps_antenna.tgt_b6 = device.svg.getElementById("p_dps_antenna_tgt_b6");

    p_dps_antenna.gpck1 = device.svg.getElementById("p_dps_antenna_gpck1");
    p_dps_antenna.gpck2 = device.svg.getElementById("p_dps_antenna_gpck2");
    p_dps_antenna.gpck3 = device.svg.getElementById("p_dps_antenna_gpck3");
    p_dps_antenna.gpck4 = device.svg.getElementById("p_dps_antenna_gpck4");
    p_dps_antenna.gpck5 = device.svg.getElementById("p_dps_antenna_gpck5");
    p_dps_antenna.gpck6 = device.svg.getElementById("p_dps_antenna_gpck6");

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

    p_dps_antenna.rdr_rng_auto = device.svg.getElementById("p_dps_antenna_rdr_rng_auto");
    p_dps_antenna.rdr_rng_min = device.svg.getElementById("p_dps_antenna_rdr_rng_min");

    p_dps_antenna.tdrs_ku = device.svg.getElementById("p_dps_antenna_tdrs_ku");


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

	p_dps_antenna.rdr_rng_auto.setText("*");
	p_dps_antenna.rdr_rng_min.setText("");

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

	p_dps_antenna.el_act.setText(sprintf("%+2.1f", getprop("/controls/shuttle/ku-antenna-beta-deg")));
	p_dps_antenna.az_act.setText(sprintf("%+3.1f", getprop("/controls/shuttle/ku-antenna-alpha-deg")));

	p_dps_antenna.el_cmd.setText(sprintf("%+2.1f", getprop("/controls/shuttle/ku-antenna-beta-deg-cmd")));
	p_dps_antenna.az_cmd.setText(sprintf("%+3.1f", getprop("/controls/shuttle/ku-antenna-alpha-deg-cmd")));

	if (SpaceShuttle.antenna_manager.TDRS_view_array[0] == 1)
		{p_dps_antenna.view1.setText("*");}
	else
		{p_dps_antenna.view1.setText("");}

	if (SpaceShuttle.antenna_manager.TDRS_view_array[1] == 1)
		{p_dps_antenna.view2.setText("*");}
	else
		{p_dps_antenna.view2.setText("");}

	if (SpaceShuttle.antenna_manager.TDRS_view_array[2] == 1)
		{p_dps_antenna.view3.setText("*");}
	else
		{p_dps_antenna.view3.setText("");}

	if (SpaceShuttle.antenna_manager.TDRS_view_array[3] == 1)
		{p_dps_antenna.view4.setText("*");}
	else
		{p_dps_antenna.view4.setText("");}

	if (SpaceShuttle.antenna_manager.TDRS_view_array[4] == 1)
		{p_dps_antenna.view5.setText("*");}
	else
		{p_dps_antenna.view5.setText("");}

	if (SpaceShuttle.antenna_manager.TDRS_view_array[5] == 1)
		{p_dps_antenna.view6.setText("*");}
	else
		{p_dps_antenna.view6.setText("");}

	var string = "";
	if (SpaceShuttle.antenna_manager.TDRS_A == 1) {string = "*";}
	p_dps_antenna.tgt_a1.setText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_A == 2) {string = "*";}
	p_dps_antenna.tgt_a2.setText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_A == 3) {string = "*";}
	p_dps_antenna.tgt_a3.setText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_A == 4) {string = "*";}
	p_dps_antenna.tgt_a4.setText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_A == 5) {string = "*";}
	p_dps_antenna.tgt_a5.setText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_A == 6) {string = "*";}
	p_dps_antenna.tgt_a6.setText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_B == 1) {string = "*";}
	p_dps_antenna.tgt_b1.setText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_B == 2) {string = "*";}
	p_dps_antenna.tgt_b2.setText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_B == 3) {string = "*";}
	p_dps_antenna.tgt_b3.setText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_B == 4) {string = "*";}
	p_dps_antenna.tgt_b4.setText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_B == 5) {string = "*";}
	p_dps_antenna.tgt_b5.setText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_B == 6) {string = "*";}
	p_dps_antenna.tgt_b6.setText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_ku_primary == "A") {string = "*";}
 	p_dps_antenna.tdrs_ku_a_pri.setText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_ku_primary == "B") {string = "*";}
 	p_dps_antenna.tdrs_ku_b_pri.setText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_s_primary == "A") {string = "*";}
 	p_dps_antenna.tdrs_s_a_pri.setText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_s_primary == "B") {string = "*";}
 	p_dps_antenna.tdrs_s_b_pri.setText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_ku_track == 1) {string = "*";}
	p_dps_antenna.gpck1.setText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_ku_track == 2) {string = "*";}
	p_dps_antenna.gpck2.setText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_ku_track == 3) {string = "*";}
	p_dps_antenna.gpck3.setText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_ku_track == 4) {string = "*";}
	p_dps_antenna.gpck4.setText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_ku_track == 5) {string = "*";}
	p_dps_antenna.gpck5.setText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_ku_track == 6) {string = "*";}
	p_dps_antenna.gpck6.setText(string);

	string = "";
	if (SpaceShuttle.antenna_manager.TDRS_ku_tgt == 1) {string = "TGT";}
	p_dps_antenna.tdrs_ku.setText(string);

        device.update_common_DPS();
    }
    
    
    
    return p_dps_antenna;
}
