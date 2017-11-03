#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_univ_ptg
# Description: the universal pointing page
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_dps_univ_ptg = func(device)
{
    var p_dps_univ_ptg = device.addPage("CRTUnivPtg", "p_dps_univ_ptg");

    p_dps_univ_ptg.group = device.svg.getElementById("p_dps_univ_ptg");
    p_dps_univ_ptg.group.setColor(dps_r, dps_g, dps_b);
    
    p_dps_univ_ptg.cur_roll = device.svg.getElementById("p_dps_univ_ptg_cur_roll");
    p_dps_univ_ptg.cur_pitch = device.svg.getElementById("p_dps_univ_ptg_cur_pitch");
    p_dps_univ_ptg.cur_yaw = device.svg.getElementById("p_dps_univ_ptg_cur_yaw");
    
    p_dps_univ_ptg.rate_roll = device.svg.getElementById("p_dps_univ_ptg_rate_roll");
    p_dps_univ_ptg.rate_pitch = device.svg.getElementById("p_dps_univ_ptg_rate_pitch");
    p_dps_univ_ptg.rate_yaw = device.svg.getElementById("p_dps_univ_ptg_rate_yaw");
    
    p_dps_univ_ptg.tgt_roll = device.svg.getElementById("p_dps_univ_ptg_reqd_roll");
    p_dps_univ_ptg.tgt_pitch = device.svg.getElementById("p_dps_univ_ptg_reqd_pitch");
    p_dps_univ_ptg.tgt_yaw = device.svg.getElementById("p_dps_univ_ptg_reqd_yaw");
    
    p_dps_univ_ptg.err_roll = device.svg.getElementById("p_dps_univ_ptg_err_roll");
    p_dps_univ_ptg.err_pitch = device.svg.getElementById("p_dps_univ_ptg_err_pitch");
    p_dps_univ_ptg.err_yaw = device.svg.getElementById("p_dps_univ_ptg_err_yaw");
    
    p_dps_univ_ptg.sel_maneuver = device.svg.getElementById("p_dps_univ_ptg_text6");
    p_dps_univ_ptg.sel_track = device.svg.getElementById("p_dps_univ_ptg_text12");
    p_dps_univ_ptg.sel_rot = device.svg.getElementById("p_dps_univ_ptg_text15");
    
    p_dps_univ_ptg.sel_maneuver.enableUpdate();
    p_dps_univ_ptg.sel_track.enableUpdate();
    p_dps_univ_ptg.sel_rot.enableUpdate();

    p_dps_univ_ptg.body_vector = device.svg.getElementById("p_dps_univ_ptg_body_vect");
    p_dps_univ_ptg.body_vector.enableUpdate();
    
    p_dps_univ_ptg.mo_roll = device.svg.getElementById("p_dps_univ_ptg_mo_roll");
    p_dps_univ_ptg.mo_pitch = device.svg.getElementById("p_dps_univ_ptg_mo_pitch");
    p_dps_univ_ptg.mo_yaw = device.svg.getElementById("p_dps_univ_ptg_mo_yaw");

    p_dps_univ_ptg.mo_roll.enableUpdate();
    p_dps_univ_ptg.mo_pitch.enableUpdate();
    p_dps_univ_ptg.mo_yaw.enableUpdate();
    
    p_dps_univ_ptg.tgt_id = device.svg.getElementById("p_dps_univ_ptg_tgt_id");
    p_dps_univ_ptg.ra = device.svg.getElementById("p_dps_univ_ptg_ra");
    p_dps_univ_ptg.dec = device.svg.getElementById("p_dps_univ_ptg_dec");
    p_dps_univ_ptg.lat = device.svg.getElementById("p_dps_univ_ptg_lat");
    p_dps_univ_ptg.lon = device.svg.getElementById("p_dps_univ_ptg_lon");
    p_dps_univ_ptg.alt = device.svg.getElementById("p_dps_univ_ptg_alt");
    p_dps_univ_ptg.om = device.svg.getElementById("p_dps_univ_ptg_om");

    p_dps_univ_ptg.tgt_id.enableUpdate();
    p_dps_univ_ptg.ra.enableUpdate();
    p_dps_univ_ptg.dec.enableUpdate();
    p_dps_univ_ptg.lat.enableUpdate();
    p_dps_univ_ptg.lon.enableUpdate();
    p_dps_univ_ptg.alt.enableUpdate();
    p_dps_univ_ptg.om.enableUpdate();
    
    p_dps_univ_ptg.start_time = device.svg.getElementById("p_dps_univ_ptg_start_time");
    p_dps_univ_ptg.cmpl_time = device.svg.getElementById("p_dps_univ_ptg_mnvr_cpl_time");
    
    p_dps_univ_ptg.mon_axis = device.svg.getElementById("p_dps_univ_ptg_mon_axis");
    p_dps_univ_ptg.err_tot = device.svg.getElementById("p_dps_univ_ptg_err_tot");
    p_dps_univ_ptg.err_dap = device.svg.getElementById("p_dps_univ_ptg_err_dap");

    p_dps_univ_ptg.mon_axis.enableUpdate();
    p_dps_univ_ptg.err_tot.enableUpdate();
    p_dps_univ_ptg.err_dap.enableUpdate();

    p_dps_univ_ptg.p = device.svg.getElementById("p_dps_univ_ptg_p");
    p_dps_univ_ptg.y = device.svg.getElementById("p_dps_univ_ptg_y");

    p_dps_univ_ptg.duration = device.svg.getElementById("p_dps_univ_ptg_duration");

    p_dps_univ_ptg.blink = 0;
    p_dps_univ_ptg.blink_ra_dec = 0;
    p_dps_univ_ptg.blink_lat_lon = 0;

    
    p_dps_univ_ptg.ondisplay = func
    {
        device.DPS_menu_title.setText("UNIV PTG");
        device.DPS_menu_ops.setText("2011/    /");
        device.MEDS_menu_title.setText("       DPS MENU");
    
    
        p_dps_univ_ptg.cmpl_time.setText("00:00:00");

	# blank options which aren't implemented yet

	p_dps_univ_ptg.p.setText("");
	p_dps_univ_ptg.y.setText("");
	p_dps_univ_ptg.duration.setText("0:00:00.00");

    }
    
    p_dps_univ_ptg.update = func
    {
        
        device.update_common_DPS();
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");

	var mon_axis = getprop("/fdm/jsbsim/systems/ap/ops201/mon-axis");

	var string = " 1  +X";
	if (mon_axis == 2) {string = " 2  -X";}

	p_dps_univ_ptg.mon_axis.updateText(string);

	var err_option = getprop("/fdm/jsbsim/systems/ap/ops201/error-option");

	if (err_option == 0)
		{
    		p_dps_univ_ptg.err_tot.updateText("*");
    		p_dps_univ_ptg.err_dap.updateText("");
		}
	else if (err_option == 1)
		{
    		p_dps_univ_ptg.err_tot.updateText("");
    		p_dps_univ_ptg.err_dap.updateText("*");
		}
    
        var cur_roll = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/roll-deg");
        var cur_pitch = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/pitch-deg");
        var cur_yaw = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/yaw-deg");
    
	cur_roll = mon_axis_trafo(mon_axis, 2, cur_roll);
	cur_pitch = mon_axis_trafo(mon_axis, 0, cur_pitch);
	cur_yaw = mon_axis_trafo(mon_axis, 1, cur_yaw);
    
        p_dps_univ_ptg.cur_roll.setText(sprintf("%+3.2f",cur_roll));
        p_dps_univ_ptg.cur_pitch.setText(sprintf("%+3.2f",cur_pitch));
        p_dps_univ_ptg.cur_yaw.setText(sprintf("%+3.2f",cur_yaw));
    
        var up_mnvr_flag= getprop("/fdm/jsbsim/systems/ap/up-mnvr-flag");
        var up_fut_mnvr_flag = getprop("/fdm/jsbsim/systems/ap/ops201/mnvr-future-flag");
    
        var tgt_roll = cur_roll;
        var tgt_pitch = cur_pitch;
        var tgt_yaw = cur_yaw;
    
        var body_vector_sel = int(getprop("/fdm/jsbsim/systems/ap/track/body-vector-selection"));
        var omicron = getprop("/fdm/jsbsim/systems/ap/track/trk-om");
    
        if ((up_mnvr_flag == 1) or (up_mnvr_flag == 2))
    	{	
            tgt_roll = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/tgt-roll-deg");
            tgt_pitch = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/tgt-pitch-deg");
            tgt_yaw = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/tgt-yaw-deg");
            if (up_mnvr_flag == 2)
    		{
                tgt_roll = tgt_roll + omicron;
    		}
            if (body_vector_sel == 2)
    		{
                tgt_roll = tgt_roll + 180.0;
                tgt_pitch = - tgt_pitch;
                tgt_yaw = tgt_yaw + 180.0;
    		}
            if (body_vector_sel == 3)
    		{
                tgt_roll = tgt_roll + 180.0;
                tgt_pitch =  tgt_pitch + 90.0;
    		}
            if (tgt_yaw > 360.0) {tgt_yaw = tgt_yaw - 360.0;}
            if (tgt_pitch > 90.0) {tgt_pitch = 180.0 - tgt_pitch;} 
    	}
    
	tgt_roll = mon_axis_trafo(mon_axis, 2, tgt_roll);
	tgt_pitch = mon_axis_trafo(mon_axis, 0, tgt_pitch);
	tgt_yaw = mon_axis_trafo(mon_axis, 1, tgt_yaw);

        p_dps_univ_ptg.tgt_roll.setText(sprintf("%+3.2f",tgt_roll));
        p_dps_univ_ptg.tgt_pitch.setText(sprintf("%+3.2f",tgt_pitch));
        p_dps_univ_ptg.tgt_yaw.setText(sprintf("%+3.2f",tgt_yaw));
    
	var rate_roll = 57.297* getprop("/fdm/jsbsim/velocities/p-rad_sec");
	var rate_pitch = 57.297* getprop("/fdm/jsbsim/velocities/q-rad_sec");
	var rate_yaw = 57.297 * getprop("/fdm/jsbsim/velocities/r-rad_sec");

	rate_roll = mon_axis_rate_trafo(mon_axis, 2, rate_roll);
	rate_pitch = mon_axis_rate_trafo(mon_axis, 0, rate_pitch);
	rate_yaw = mon_axis_rate_trafo(mon_axis, 1, rate_yaw);

        p_dps_univ_ptg.rate_roll.setText(sprintf("%+3.2f",rate_roll));
        p_dps_univ_ptg.rate_pitch.setText(sprintf("%+3.2f", rate_pitch ));
        p_dps_univ_ptg.rate_yaw.setText(sprintf("%+3.2f", rate_yaw));
    
        var err_roll = 0.0;
        var err_pitch = 0.0;
        var err_yaw = 0.0;
    
        if (((up_mnvr_flag == 1) or (up_mnvr_flag == 2) or (up_mnvr_flag == 3)) and (err_option == 0))
    	{	
            err_roll = tgt_roll - cur_roll;
            if (err_roll > 180.0) {err_roll = err_roll - 360.0;}
            if (err_roll < -180.0) {err_roll = err_roll + 360.0;}
            err_pitch = tgt_pitch - cur_pitch;
            err_yaw = tgt_yaw - cur_yaw;
    	}

	if (err_option == 1) # DAP errors
		{
		err_pitch = getprop("/fdm/jsbsim/systems/rcs/pitch-rate-error") * 57.297;
		err_yaw = getprop("/fdm/jsbsim/systems/rcs/yaw-rate-error") * 57.297;
		err_roll = getprop("/fdm/jsbsim/systems/rcs/roll-rate-error") * 57.297;
		}

	err_roll = mon_axis_trafo(mon_axis, 2, err_roll);
	err_pitch = mon_axis_trafo(mon_axis, 0, err_pitch);
	err_yaw = mon_axis_trafo(mon_axis, 1, err_yaw);
    
        p_dps_univ_ptg.err_roll.setText(sprintf("%+3.2f", err_roll));
        p_dps_univ_ptg.err_pitch.setText(sprintf("%+3.2f", err_pitch));
        p_dps_univ_ptg.err_yaw.setText(sprintf("%+3.2f", err_yaw));
    
    
    
        if (up_mnvr_flag == 0)
    	{
            p_dps_univ_ptg.sel_maneuver.updateText( "18");
            p_dps_univ_ptg.sel_track.updateText( "19");
            p_dps_univ_ptg.sel_rot.updateText( "20");
    	}	
        else if (up_mnvr_flag == 1)
    	{
            p_dps_univ_ptg.sel_maneuver.updateText( "18 *");
            p_dps_univ_ptg.sel_track.updateText( "19");
            p_dps_univ_ptg.sel_rot.updateText( "20");
    	}
        else if (up_mnvr_flag == 2)
    	{
            p_dps_univ_ptg.sel_maneuver.updateText( "18");
            p_dps_univ_ptg.sel_track.updateText( "19 *");
            p_dps_univ_ptg.sel_rot.updateText( "20");
    	}
        else if (up_mnvr_flag == 3)
    	{
            p_dps_univ_ptg.sel_maneuver.updateText( "18");
            p_dps_univ_ptg.sel_track.updateText( "19");
            p_dps_univ_ptg.sel_rot.updateText( "20 *");
    	}
    
        if (up_fut_mnvr_flag == 1)
    	{
            p_dps_univ_ptg.sel_maneuver.updateText( "18     *");
            p_dps_univ_ptg.sel_track.updateText( "19");
            p_dps_univ_ptg.sel_rot.updateText( "20");
    	}
        else if (up_fut_mnvr_flag == 2)
    	{
            p_dps_univ_ptg.sel_maneuver.updateText( "18");
            p_dps_univ_ptg.sel_track.updateText( "19     *");
            p_dps_univ_ptg.sel_rot.updateText( "20");
    	}
        else if (up_fut_mnvr_flag == 3)
    	{
            p_dps_univ_ptg.sel_maneuver.updateText( "18");
            p_dps_univ_ptg.sel_track.updateText( "19");
            p_dps_univ_ptg.sel_rot.updateText( "20     *");
    	}
    
        p_dps_univ_ptg.mo_roll.updateText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/mnvr-roll")));
        p_dps_univ_ptg.mo_pitch.updateText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/mnvr-pitch")));
        p_dps_univ_ptg.mo_yaw.updateText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/mnvr-yaw")));
    
        p_dps_univ_ptg.body_vector.updateText(sprintf("%d", body_vector_sel));
    

        p_dps_univ_ptg.tgt_id.updateText(sprintf("%d", int(getprop("/fdm/jsbsim/systems/ap/ops201/tgt-id"))));
        p_dps_univ_ptg.ra.updateText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/trk-ra")));
        p_dps_univ_ptg.dec.updateText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/trk-dec")));
        p_dps_univ_ptg.lat.updateText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/trk-lat")));
        p_dps_univ_ptg.lon.updateText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/trk-lon")));
        p_dps_univ_ptg.alt.updateText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/trk-alt")));
        p_dps_univ_ptg.om.updateText(sprintf("%3.2f", omicron));
    
	p_dps_univ_ptg.blink_ra_dec = getprop("/fdm/jsbsim/systems/ap/ops201/flash-ra-dec");
	p_dps_univ_ptg.blink_lat_lon = getprop("/fdm/jsbsim/systems/ap/ops201/flash-lat-lon");

	if (p_dps_univ_ptg.blink_ra_dec == 1)
		{
	 	if (p_dps_univ_ptg.blink == 0)
			{
			p_dps_univ_ptg.ra.setVisible(1);
			p_dps_univ_ptg.dec.setVisible(1);
			p_dps_univ_ptg.blink = 1;
			}
		else
			{
			p_dps_univ_ptg.ra.setVisible(0);
			p_dps_univ_ptg.dec.setVisible(0);
			p_dps_univ_ptg.blink = 0;
			}
		}
	else
		{
		p_dps_univ_ptg.ra.setVisible(1);
		p_dps_univ_ptg.dec.setVisible(1);
		}

	if (p_dps_univ_ptg.blink_lat_lon == 1)
		{
	 	if (p_dps_univ_ptg.blink == 0)
			{
			p_dps_univ_ptg.lat.setVisible(1);
			p_dps_univ_ptg.lon.setVisible(1);
			p_dps_univ_ptg.alt.setVisible(1);
			p_dps_univ_ptg.blink = 1;
			}
		else
			{
			p_dps_univ_ptg.lat.setVisible(0);
			p_dps_univ_ptg.lon.setVisible(0);
			p_dps_univ_ptg.alt.setVisible(0);
			p_dps_univ_ptg.blink = 0;
			}
		}
	else
		{
		p_dps_univ_ptg.lat.setVisible(1);
		p_dps_univ_ptg.lon.setVisible(1);
		p_dps_univ_ptg.alt.setVisible(1);
		}



        p_dps_univ_ptg.start_time.setText(getprop("/fdm/jsbsim/systems/timer/up-mnvr-time-string"));
    
    }
    
    
    
    return p_dps_univ_ptg;
}


var mon_axis_trafo = func (axis, ang_opt, angle) {

if (axis == 1)
	{
	return angle;
	}
else if (axis == 2)
	{
	if (ang_opt == 0) # pitch
		{
		return -angle;
		}
	else if (ang_opt == 1) # yaw
		{
		var value = angle + 180.0;
		if (value > 360.0) {value = value - 360.0;}
		return value;
		}	
	else if (ang_opt == 2) # roll
		{
		return - angle;
		}
	}

}

var mon_axis_rate_trafo = func (axis, ang_opt, rate) {

if (axis == 1)
	{
	return rate;
	}
else if (axis == 2)
	{
	if (ang_opt == 0) # pitch
		{
		return -rate;
		}
	else if (ang_opt == 1) # yaw
		{
		return rate;
		}
	else if (ang_opt == 2) # roll
		{
		return -rate;
		}
	}

}
