#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_strk
# Description: the CRT star tracker operations page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_strk = func(device)
{
    var p_dps_strk = device.addPage("CRTStrk", "p_dps_strk");

    p_dps_strk.group = device.svg.getElementById("p_dps_strk");
    p_dps_strk.group.setColor(dps_r, dps_g, dps_b);
    
    p_dps_strk.status_y_2 = device.svg.getElementById("p_dps_strk_status_y_2");
    p_dps_strk.status_z_2 = device.svg.getElementById("p_dps_strk_status_z_2");

    p_dps_strk.selftest_y = device.svg.getElementById("p_dps_strk_selftest_y");
    p_dps_strk.selftest_z = device.svg.getElementById("p_dps_strk_selftest_z");

    p_dps_strk.startrk_y = device.svg.getElementById("p_dps_strk_startrk_y");
    p_dps_strk.startrk_z = device.svg.getElementById("p_dps_strk_startrk_z");

    p_dps_strk.tgttrk_y = device.svg.getElementById("p_dps_strk_tgttrk_y");
    p_dps_strk.tgttrk_z = device.svg.getElementById("p_dps_strk_tgttrk_z");

    p_dps_strk.idle_y = device.svg.getElementById("p_dps_strk_idle_y");
    p_dps_strk.idle_z = device.svg.getElementById("p_dps_strk_idle_z");

    p_dps_strk.shutter_y = device.svg.getElementById("p_dps_strk_shutter_y");
    p_dps_strk.shutter_z = device.svg.getElementById("p_dps_strk_shutter_z");

    p_dps_strk.status_y = device.svg.getElementById("p_dps_strk_status_y");
    p_dps_strk.status_z = device.svg.getElementById("p_dps_strk_status_z");

    p_dps_strk.thold_y = device.svg.getElementById("p_dps_strk_thold_y");
    p_dps_strk.thold_z = device.svg.getElementById("p_dps_strk_thold_z");

    p_dps_strk.man_op_y = device.svg.getElementById("p_dps_strk_man_op_y");
    p_dps_strk.man_op_z = device.svg.getElementById("p_dps_strk_man_op_z");

    p_dps_strk.strk_dang_y = device.svg.getElementById("p_dps_strk_dang_y");
    p_dps_strk.strk_dang_z = device.svg.getElementById("p_dps_strk_dang_z");

    p_dps_strk.reqd_id_y = device.svg.getElementById("p_dps_strk_reqd_id_y");
    p_dps_strk.reqd_id_z = device.svg.getElementById("p_dps_strk_reqd_id_z");

    p_dps_strk.trk_id_y = device.svg.getElementById("p_dps_strk_trk_id_y");
    p_dps_strk.trk_id_z = device.svg.getElementById("p_dps_strk_trk_id_z");

    p_dps_strk.s_pres_y = device.svg.getElementById("p_dps_strk_s_pres_y");
    p_dps_strk.s_pres_z = device.svg.getElementById("p_dps_strk_s_pres_z");

    p_dps_strk.trk_id1 = device.svg.getElementById("p_dps_strk_trk_id1");
    p_dps_strk.trk_id2 = device.svg.getElementById("p_dps_strk_trk_id2");
    p_dps_strk.trk_id3 = device.svg.getElementById("p_dps_strk_trk_id3");

    p_dps_strk.trk_dmin1 = device.svg.getElementById("p_dps_strk_trk_dmin1");
    p_dps_strk.trk_dmin2 = device.svg.getElementById("p_dps_strk_trk_dmin2");
    p_dps_strk.trk_dmin3 = device.svg.getElementById("p_dps_strk_trk_dmin3");

    p_dps_strk.angdif1 = device.svg.getElementById("p_dps_strk_angdif1");
    p_dps_strk.angdif2 = device.svg.getElementById("p_dps_strk_angdif2");
    p_dps_strk.angdif3 = device.svg.getElementById("p_dps_strk_angdif3");

    p_dps_strk.angerr1 = device.svg.getElementById("p_dps_strk_angerr1");
    p_dps_strk.angerr2 = device.svg.getElementById("p_dps_strk_angerr2");
    p_dps_strk.angerr3 = device.svg.getElementById("p_dps_strk_angerr3");

    p_dps_strk.sel1 = device.svg.getElementById("p_dps_strk_sel1");
    p_dps_strk.sel2 = device.svg.getElementById("p_dps_strk_sel2");
    p_dps_strk.sel3 = device.svg.getElementById("p_dps_strk_sel3");

    p_dps_strk.reqd_id_coas = device.svg.getElementById("p_dps_strk_reqd_id_coas");
    p_dps_strk.ddeg_x = device.svg.getElementById("p_dps_strk_ddeg_x");
    p_dps_strk.ddeg_y = device.svg.getElementById("p_dps_strk_ddeg_y");

    p_dps_strk.cal_mode = device.svg.getElementById("p_dps_strk_cal_mode");
    p_dps_strk.sight_mode = device.svg.getElementById("p_dps_strk_sight_mode");
    p_dps_strk.des = device.svg.getElementById("p_dps_strk_des");

    p_dps_strk.pos_x = device.svg.getElementById("p_dps_strk_pos_x");
    p_dps_strk.pos_z = device.svg.getElementById("p_dps_strk_pos_z");

    p_dps_strk.dbias1 = device.svg.getElementById("p_dps_strk_dbias1");
    p_dps_strk.dbias2 = device.svg.getElementById("p_dps_strk_dbias2");

    p_dps_strk.ondisplay = func
    {
        device.DPS_menu_title.setText("S TRK/COAS CNTL");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/022/";
        device.DPS_menu_ops.setText(ops_string);

	# defaults for things which aren't implemented yet

	p_dps_strk.reqd_id_y.setText("0");
	p_dps_strk.reqd_id_z.setText("0");
	p_dps_strk.cal_mode.setText("");
    }
    
    p_dps_strk.update = func
    {
    
	var symbol = "";
	if (SpaceShuttle.star_tracker_array[0].mode == 0) {symbol = "*";}
	p_dps_strk.selftest_y.setText(symbol);

	symbol = "";
	if (SpaceShuttle.star_tracker_array[1].mode == 0) {symbol = "*";}
	p_dps_strk.selftest_z.setText(symbol);
    
	symbol = "";
	if (SpaceShuttle.star_tracker_array[0].mode == 1) {symbol = "*";}
	p_dps_strk.startrk_y.setText(symbol);

	symbol = "";
	if (SpaceShuttle.star_tracker_array[1].mode == 1) {symbol = "*";}
	p_dps_strk.startrk_z.setText(symbol);

	symbol = "";
	if (SpaceShuttle.star_tracker_array[0].mode == 2) {symbol = "*";}
	p_dps_strk.tgttrk_y.setText(symbol);

	symbol = "";
	if (SpaceShuttle.star_tracker_array[1].mode == 2) {symbol = "*";}
	p_dps_strk.tgttrk_z.setText(symbol);

	symbol = "";
	if (SpaceShuttle.star_tracker_array[0].mode == 4) {symbol = "*";}
	p_dps_strk.idle_y.setText(symbol);

	symbol = "";
	if (SpaceShuttle.star_tracker_array[1].mode == 4) {symbol = "*";}
	p_dps_strk.idle_z.setText(symbol);

	symbol = "";
	if (SpaceShuttle.star_tracker_array[0].manual == 1) {symbol = "*";}
	p_dps_strk.man_op_y.setText(symbol);

	symbol = "";
	if (SpaceShuttle.star_tracker_array[1].manual == 1) {symbol = "*";}
	p_dps_strk.man_op_z.setText(symbol);

	symbol = "";
	if (SpaceShuttle.star_tracker_array[0].star_in_view == 1) {symbol = "*";}
	p_dps_strk.s_pres_y.setText(symbol);

	symbol = "";
	if (SpaceShuttle.star_tracker_array[1].star_in_view == 1) {symbol = "*";}
	p_dps_strk.s_pres_z.setText(symbol);




	var text = SpaceShuttle.star_tracker_array[0].failure; 
	p_dps_strk.status_y_2.setText(text);

	text = SpaceShuttle.star_tracker_array[1].failure; 
	p_dps_strk.status_z_2.setText(text);

	text = SpaceShuttle.star_tracker_array[0].shutter;
    	p_dps_strk.shutter_y.setText(text);

	text = SpaceShuttle.star_tracker_array[1].shutter;
    	p_dps_strk.shutter_z.setText(text);

	text = SpaceShuttle.star_tracker_array[0].status;
	p_dps_strk.status_y.setText(text);

	text = SpaceShuttle.star_tracker_array[1].status;
	p_dps_strk.status_z.setText(text);

	p_dps_strk.thold_y.setText(sprintf("%d",SpaceShuttle.star_tracker_array[0].threshold) );
	p_dps_strk.thold_z.setText(sprintf("%d",SpaceShuttle.star_tracker_array[1].threshold) );

	var angular_error = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/angle-deg");

	p_dps_strk.strk_dang_y.setText(sprintf("%+1.2f", angular_error * 0.7));
	p_dps_strk.strk_dang_z.setText(sprintf("%+1.2f", angular_error * -0.4));

	var track_id = star_tracker_array[0].star_ID;
	var current_time = getprop("/sim/time/elapsed-sec");

	if (track_id == 0)
		{    
		p_dps_strk.trk_id_y.setText("");
		}
	else
		{
		p_dps_strk.trk_id_y.setText(sprintf("%d",track_id));
		}

	track_id = star_tracker_array[1].star_ID;
	if (track_id == 0)
		{    
		p_dps_strk.trk_id_z.setText("");
		}
	else
		{
		p_dps_strk.trk_id_z.setText(sprintf("%d",track_id));
		}

	# star table

	var minutes = 0;

	track_id = SpaceShuttle.star_table.track_ID[0];
	if (track_id == 0)
		{    
		p_dps_strk.trk_id1.setText("");
		p_dps_strk.trk_dmin1.setText("");
		p_dps_strk.angdif1.setText("");
		p_dps_strk.angerr1.setText("");
		p_dps_strk.sel1.setText("");
		}
	else
		{
		p_dps_strk.trk_id1.setText(sprintf("%d",track_id));
		minutes = int((current_time - SpaceShuttle.star_table.time_stamp[0])/60.);
		p_dps_strk.trk_dmin1.setText(sprintf("%d",minutes));
		p_dps_strk.angdif1.setText(sprintf("%3.1f",SpaceShuttle.star_table.ang_diff[0]));
		p_dps_strk.angerr1.setText(sprintf("%2.2f",SpaceShuttle.star_table.ang_err[0]));
		symbol = "";
		if (SpaceShuttle.star_table.sel[0] == 1) {symbol = "*";}
		p_dps_strk.sel1.setText(symbol);
		}

	track_id = SpaceShuttle.star_table.track_ID[1];
	if (track_id == 0)
		{    
		p_dps_strk.trk_id2.setText("");
		p_dps_strk.trk_dmin2.setText("");
		p_dps_strk.angdif2.setText("");
		p_dps_strk.angerr2.setText("");
		p_dps_strk.sel2.setText("");
		}
	else
		{
		p_dps_strk.trk_id2.setText(sprintf("%d",track_id));
		minutes = int((current_time - SpaceShuttle.star_table.time_stamp[1])/60.);
		p_dps_strk.trk_dmin2.setText(sprintf("%d",minutes));
		p_dps_strk.angdif2.setText(sprintf("%3.1f",SpaceShuttle.star_table.ang_diff[1]));
		p_dps_strk.angerr2.setText(sprintf("%2.2f",SpaceShuttle.star_table.ang_err[1]));
		symbol = "";
		if (SpaceShuttle.star_table.sel[1] == 1) {symbol = "*";}
		p_dps_strk.sel2.setText(symbol);
		}

	track_id = SpaceShuttle.star_table.track_ID[2];
	if (track_id == 0)
		{    
		p_dps_strk.trk_id3.setText("");
		p_dps_strk.trk_dmin3.setText("");
		p_dps_strk.angdif3.setText("");
		p_dps_strk.angerr3.setText("");
		p_dps_strk.sel3.setText("");
		}
	else
		{
		p_dps_strk.trk_id3.setText(sprintf("%d",track_id));
		minutes = int((current_time - SpaceShuttle.star_table.time_stamp[2])/60.);
		p_dps_strk.trk_dmin3.setText(sprintf("%d",minutes));
		p_dps_strk.angdif3.setText(sprintf("%3.1f",SpaceShuttle.star_table.ang_diff[2]));
		p_dps_strk.angerr3.setText(sprintf("%2.2f",SpaceShuttle.star_table.ang_err[2]));
		symbol = "";
		if (SpaceShuttle.star_table.sel[2] == 1) {symbol = "*";}
		p_dps_strk.sel3.setText(symbol);
		}

	# COAS

	var coas_star_id = SpaceShuttle.coas.reqd_id;

	if (coas_star_id == 0) {p_dps_strk.reqd_id_coas.setText("");}
	else {p_dps_strk.reqd_id_coas.setText(sprintf("%d", coas_star_id));}

	p_dps_strk.ddeg_x.setText(sprintf("%1.1f",SpaceShuttle.coas.Ddeg_x));
	p_dps_strk.ddeg_y.setText(sprintf("%1.1f",SpaceShuttle.coas.Ddeg_y));

	symbol = "";
	if (SpaceShuttle.coas.deselect == 1) {symbol = "*";}
	p_dps_strk.des.setText(symbol);

	symbol = "";
	if (SpaceShuttle.coas.pos == 0) {symbol = "*";}
	p_dps_strk.pos_x.setText(symbol);

	symbol = "";
	if (SpaceShuttle.coas.pos == 1) {symbol = "*";}
	p_dps_strk.pos_z.setText(symbol);

	symbol = "";
	if (SpaceShuttle.coas.sight_mode == 1) {symbol = "*";}
	p_dps_strk.sight_mode.setText(symbol);

	p_dps_strk.dbias1.setText(sprintf("%1.2f", coas.Dbias_x) );
	p_dps_strk.dbias2.setText(sprintf("%1.2f", coas.Dbias_y) );



        device.update_common_DPS();
    }
    
    
    
    return p_dps_strk;
}
