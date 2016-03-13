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


        device.update_common_DPS();
    }
    
    
    
    return p_dps_strk;
}
