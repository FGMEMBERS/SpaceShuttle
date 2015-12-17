#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_univ_ptg
# Description: the universal pointing page
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_dps_univ_ptg = func(device)
{
    var p_dps_univ_ptg = device.addPage("CRTUnivPtg", "p_dps_univ_ptg");
    
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
    
    p_dps_univ_ptg.body_vector = device.svg.getElementById("p_dps_univ_ptg_body_vect");
    
    p_dps_univ_ptg.mo_roll = device.svg.getElementById("p_dps_univ_ptg_mo_roll");
    p_dps_univ_ptg.mo_pitch = device.svg.getElementById("p_dps_univ_ptg_mo_pitch");
    p_dps_univ_ptg.mo_yaw = device.svg.getElementById("p_dps_univ_ptg_mo_yaw");
    
    p_dps_univ_ptg.tgt_id = device.svg.getElementById("p_dps_univ_ptg_tgt_id");
    p_dps_univ_ptg.ra = device.svg.getElementById("p_dps_univ_ptg_ra");
    p_dps_univ_ptg.dec = device.svg.getElementById("p_dps_univ_ptg_dec");
    p_dps_univ_ptg.lat = device.svg.getElementById("p_dps_univ_ptg_lat");
    p_dps_univ_ptg.lon = device.svg.getElementById("p_dps_univ_ptg_lon");
    p_dps_univ_ptg.alt = device.svg.getElementById("p_dps_univ_ptg_alt");
    p_dps_univ_ptg.om = device.svg.getElementById("p_dps_univ_ptg_om");
    
    p_dps_univ_ptg.start_time = device.svg.getElementById("p_dps_univ_ptg_start_time");
    p_dps_univ_ptg.cmpl_time = device.svg.getElementById("p_dps_univ_ptg_mnvr_cpl_time");
    
    
    
    
    p_dps_univ_ptg.ondisplay = func
    {
        device.DPS_menu_title.setText("UNIV PTG");
        device.DPS_menu_ops.setText("2011/    /");
        device.MEDS_menu_title.setText("       DPS MENU");
    
    
        p_dps_univ_ptg.cmpl_time.setText("00:00:00");
    }
    
    p_dps_univ_ptg.update = func
    {
    
        # these really need to be deleted when leaving the ascent page - do we have
        # an 'upon exit' functionality here
        device.nom_traj_plot.removeAllChildren();
        device.p_ascent_shuttle_sym.setScale(0.0);
    
        device.update_common_DPS();
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var cur_roll = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/roll-deg");
        var cur_pitch = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/pitch-deg");
        var cur_yaw = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/yaw-deg");
    
    
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
            if (tgt_yaw > 360.0) {tgt_yaw = tgt+yaw - 360.0;}
            if (tgt_pitch > 90.0) {tgt_pitch = 180.0 - tgt_pitch;} 
    	}
    
        p_dps_univ_ptg.tgt_roll.setText(sprintf("%+3.2f",tgt_roll));
        p_dps_univ_ptg.tgt_pitch.setText(sprintf("%+3.2f",tgt_pitch));
        p_dps_univ_ptg.tgt_yaw.setText(sprintf("%+3.2f",tgt_yaw));
    
        p_dps_univ_ptg.rate_roll.setText(sprintf("%+3.2f",57.297* getprop("/fdm/jsbsim/velocities/p-rad_sec")));
        p_dps_univ_ptg.rate_pitch.setText(sprintf("%+3.2f",57.297 * getprop("/fdm/jsbsim/velocities/q-rad_sec")));
        p_dps_univ_ptg.rate_yaw.setText(sprintf("%+3.2f",57.297 * getprop("/fdm/jsbsim/velocities/r-rad_sec")));
    
        var err_roll = 0.0;
        var err_pitch = 0.0;
        var err_yaw = 0.0;
    
        if ((up_mnvr_flag == 1) or (up_mnvr_flag == 2) or (up_mnvr_flag == 3))
    	{	
            err_roll = tgt_roll - cur_roll;
            if (err_roll > 180.0) {err_roll = err_roll - 360.0;}
            if (err_roll < -180.0) {err_roll = err_roll + 360.0;}
            err_pitch = tgt_pitch - cur_pitch;
            err_yaw = tgt_yaw - cur_yaw;
    	}
    
        p_dps_univ_ptg.err_roll.setText(sprintf("%+3.2f", err_roll));
        p_dps_univ_ptg.err_pitch.setText(sprintf("%+3.2f", err_pitch));
        p_dps_univ_ptg.err_yaw.setText(sprintf("%+3.2f", err_yaw));
    
    
    
        if (up_mnvr_flag == 0)
    	{
            p_dps_univ_ptg.sel_maneuver.setText( "18");
            p_dps_univ_ptg.sel_track.setText( "19");
            p_dps_univ_ptg.sel_rot.setText( "20");
    	}	
        else if (up_mnvr_flag == 1)
    	{
            p_dps_univ_ptg.sel_maneuver.setText( "18 *");
            p_dps_univ_ptg.sel_track.setText( "19");
            p_dps_univ_ptg.sel_rot.setText( "20");
    	}
        else if (up_mnvr_flag == 2)
    	{
            p_dps_univ_ptg.sel_maneuver.setText( "18");
            p_dps_univ_ptg.sel_track.setText( "19 *");
            p_dps_univ_ptg.sel_rot.setText( "20");
    	}
        else if (up_mnvr_flag == 3)
    	{
            p_dps_univ_ptg.sel_maneuver.setText( "18");
            p_dps_univ_ptg.sel_track.setText( "19");
            p_dps_univ_ptg.sel_rot.setText( "20 *");
    	}
    
        if (up_fut_mnvr_flag == 1)
    	{
            p_dps_univ_ptg.sel_maneuver.setText( "18     *");
            p_dps_univ_ptg.sel_track.setText( "19");
            p_dps_univ_ptg.sel_rot.setText( "20");
    	}
        else if (up_fut_mnvr_flag == 2)
    	{
            p_dps_univ_ptg.sel_maneuver.setText( "18");
            p_dps_univ_ptg.sel_track.setText( "19     *");
            p_dps_univ_ptg.sel_rot.setText( "20");
    	}
        else if (up_fut_mnvr_flag == 3)
    	{
            p_dps_univ_ptg.sel_maneuver.setText( "18");
            p_dps_univ_ptg.sel_track.setText( "19");
            p_dps_univ_ptg.sel_rot.setText( "20     *");
    	}
    
        p_dps_univ_ptg.mo_roll.setText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/mnvr-roll")));
        p_dps_univ_ptg.mo_pitch.setText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/mnvr-pitch")));
        p_dps_univ_ptg.mo_yaw.setText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/mnvr-yaw")));
    
        p_dps_univ_ptg.body_vector.setText(sprintf("%d", body_vector_sel));
    
    
        p_dps_univ_ptg.tgt_id.setText(sprintf("%d", int(getprop("/fdm/jsbsim/systems/ap/ops201/tgt-id"))));
        p_dps_univ_ptg.ra.setText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/trk-ra")));
        p_dps_univ_ptg.dec.setText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/trk-dec")));
        p_dps_univ_ptg.lat.setText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/trk-lat")));
        p_dps_univ_ptg.lon.setText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/trk-lon")));
        p_dps_univ_ptg.alt.setText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/trk-alt")));
        p_dps_univ_ptg.om.setText(sprintf("%3.2f", omicron));
    
        p_dps_univ_ptg.start_time.setText(getprop("/fdm/jsbsim/systems/timer/up-mnvr-time-string"));
    
    }
    
    
    
    return p_dps_univ_ptg;
}
