#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_mnvr
# Description: the maneuver page
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_dps_mnvr = func(device)
{
    var p_dps_mnvr = device.addPage("CRTMnvr", "p_dps_mnvr");

    p_dps_mnvr.group = device.svg.getElementById("p_dps_mnvr");
    p_dps_mnvr.group.setColor(dps_r, dps_g, dps_b);
    
    p_dps_mnvr.oms_pitch_left = device.svg.getElementById("p_dps_mnvr_gmbl_l_pitch");
    p_dps_mnvr.oms_pitch_right = device.svg.getElementById("p_dps_mnvr_gmbl_r_pitch");
    p_dps_mnvr.oms_yaw_left = device.svg.getElementById("p_dps_mnvr_gmbl_l_yaw");
    p_dps_mnvr.oms_yaw_right = device.svg.getElementById("p_dps_mnvr_gmbl_r_yaw");
    
    p_dps_mnvr.current_apoapsis = device.svg.getElementById("p_dps_mnvr_ha_cur");
    p_dps_mnvr.current_periapsis = device.svg.getElementById("p_dps_mnvr_hp_cur");
    p_dps_mnvr.ha_tgt = device.svg.getElementById("p_dps_mnvr_ha_tgt");
    p_dps_mnvr.hp_tgt = device.svg.getElementById("p_dps_mnvr_hp_tgt");
    
    p_dps_mnvr.fwd_rcs_dump = device.svg.getElementById("p_dps_mnvr_fwd_rcs_dump");
    p_dps_mnvr.fwd_rcs_arm = device.svg.getElementById("p_dps_mnvr_fwd_rcs_arm");
    p_dps_mnvr.fwd_rcs_off = device.svg.getElementById("p_dps_mnvr_fwd_rcs_off");
    
    p_dps_mnvr.surf_drive_on = device.svg.getElementById("p_dps_mnvr_surf_drive_on");
    p_dps_mnvr.surf_drive_off = device.svg.getElementById("p_dps_mnvr_surf_drive_off");
    
    p_dps_mnvr.oms_both = device.svg.getElementById("p_dps_mnvr_oms_both");
    p_dps_mnvr.oms_l = device.svg.getElementById("p_dps_mnvr_oms_l");
    p_dps_mnvr.oms_r = device.svg.getElementById("p_dps_mnvr_oms_r");
    p_dps_mnvr.rcs_sel = device.svg.getElementById("p_dps_mnvr_rcs_sel");
    
    p_dps_mnvr.tv_roll = device.svg.getElementById("p_dps_mnvr_tv_roll");
    
    p_dps_mnvr.p = device.svg.getElementById("p_dps_mnvr_p");
    p_dps_mnvr.ly = device.svg.getElementById("p_dps_mnvr_ly");
    p_dps_mnvr.ry = device.svg.getElementById("p_dps_mnvr_ry");
    
    p_dps_mnvr.wt = device.svg.getElementById("p_dps_mnvr_wt");
    
    p_dps_mnvr.tig = device.svg.getElementById("p_dps_mnvr_tig");
    
    p_dps_mnvr.dvx = device.svg.getElementById("p_dps_mnvr_dvx");
    p_dps_mnvr.dvy = device.svg.getElementById("p_dps_mnvr_dvy");
    p_dps_mnvr.dvz = device.svg.getElementById("p_dps_mnvr_dvz");
    
    p_dps_mnvr.load = device.svg.getElementById("p_dps_mnvr_load");
    
    p_dps_mnvr.burn_att_roll = device.svg.getElementById("p_dps_mnvr_burn_att_roll");
    p_dps_mnvr.burn_att_pitch = device.svg.getElementById("p_dps_mnvr_burn_att_pitch");
    p_dps_mnvr.burn_att_yaw = device.svg.getElementById("p_dps_mnvr_burn_att_yaw");
    
    p_dps_mnvr.mnvr = device.svg.getElementById("p_dps_mnvr_mnvr");
    p_dps_mnvr.active_dap = device.svg.getElementById("p_dps_mnvr_active_dap");
    
    p_dps_mnvr.dvtot = device.svg.getElementById("p_dps_mnvr_dvtot");
    p_dps_mnvr.tgo = device.svg.getElementById("p_dps_mnvr_tgo");
    
    p_dps_mnvr.exec = device.svg.getElementById("p_dps_mnvr_exec_msg");
    
    p_dps_mnvr.ttapsis_text = device.svg.getElementById("p_dps_mnvr_ttapsis_text");
    p_dps_mnvr.ttapsis = device.svg.getElementById("p_dps_mnvr_ttapsis");
    
    p_dps_mnvr.vgo_x = device.svg.getElementById("p_dps_mnvr_vgo_x");
    p_dps_mnvr.vgo_y = device.svg.getElementById("p_dps_mnvr_vgo_y");
    p_dps_mnvr.vgo_z = device.svg.getElementById("p_dps_mnvr_vgo_z");
    
    
    p_dps_mnvr.pri_l = device.svg.getElementById("p_dps_mnvr_pri_l");
    p_dps_mnvr.pri_r = device.svg.getElementById("p_dps_mnvr_pri_r");
    p_dps_mnvr.sec_l = device.svg.getElementById("p_dps_mnvr_sec_l");
    p_dps_mnvr.sec_r = device.svg.getElementById("p_dps_mnvr_sec_r");
    p_dps_mnvr.off_l = device.svg.getElementById("p_dps_mnvr_off_l");
    p_dps_mnvr.off_r = device.svg.getElementById("p_dps_mnvr_off_r");
    p_dps_mnvr.gmbl_ck = device.svg.getElementById("p_dps_mnvr_gmbl_ck");
    
    p_dps_mnvr.c1 = device.svg.getElementById("p_dps_mnvr_c1");
    p_dps_mnvr.c2 = device.svg.getElementById("p_dps_mnvr_c2");
    p_dps_mnvr.ht = device.svg.getElementById("p_dps_mnvr_ht");
    p_dps_mnvr.tt = device.svg.getElementById("p_dps_mnvr_tt");
    p_dps_mnvr.prplt = device.svg.getElementById("p_dps_mnvr_prplt");

    p_dps_mnvr.tta = device.svg.getElementById("p_dps_mnvr_tta");
    p_dps_mnvr.rei = device.svg.getElementById("p_dps_mnvr_rei");

    p_dps_mnvr.abort_tgt = device.svg.getElementById("p_dps_mnvr_abort_tgt");



    p_dps_mnvr.blink = 0;
    
    
    
    p_dps_mnvr.ondisplay = func
    {
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var string1 = "";
    
        if (major_mode == 104)
    	{string1 = "OMS 1 ";}
        else if (major_mode == 105)
    	{string1 = "OMS 2 ";}
        else if (major_mode == 202)
    	{string1 = "ORBIT ";}
    
        var string2 = " EXEC";
    
        if ((major_mode == 106) or (major_mode == 301) or (major_mode == 303))
    	{string2 = " COAST";}
    
        var weight = getprop("/fdm/jsbsim/systems/ap/oms-plan/weight");
        if (weight ==0) {setprop("/fdm/jsbsim/systems/ap/oms-plan/weight", getprop("/fdm/jsbsim/inertia/weight-lbs"));}
    
        p_dps_mnvr.load.setText("LOAD");
    
        device.DPS_menu_title.setText(string1~"MNVR"~string2);
        device.DPS_menu_ops.setText(major_mode~"1/    /");
        device.MEDS_menu_title.setText("       DPS MENU");

	
	# blank items which aren't implemented yet

   	p_dps_mnvr.c1.setText("");
    	p_dps_mnvr.c2.setText("");
    	p_dps_mnvr.ht.setText("");
    	p_dps_mnvr.tt.setText("");
    	p_dps_mnvr.prplt.setText("");
	p_dps_mnvr.rei.setText("");


    }


    
    
    p_dps_mnvr.update = func
    {
    
        device.update_common_DPS();
    
    
        p_dps_mnvr.oms_pitch_left.setText(sprintf("%1.1f",getprop("/fdm/jsbsim/propulsion/engine[5]/pitch-angle-rad") * 57.297));
        p_dps_mnvr.oms_pitch_right.setText(sprintf("%1.1f",getprop("/fdm/jsbsim/propulsion/engine[6]/pitch-angle-rad") * 57.297));
        p_dps_mnvr.oms_yaw_left.setText(sprintf("%1.1f",getprop("/fdm/jsbsim/propulsion/engine[5]/yaw-angle-rad") * 57.297));
        p_dps_mnvr.oms_yaw_right.setText(sprintf("%1.1f",getprop("/fdm/jsbsim/propulsion/engine[6]/yaw-angle-rad") * 57.297));
    
        p_dps_mnvr.current_apoapsis.setText(sprintf("%3.0f",getprop("/fdm/jsbsim/systems/orbital/apoapsis-km")/1.853));
        p_dps_mnvr.current_periapsis.setText(sprintf("%3.0f",getprop("/fdm/jsbsim/systems/orbital/periapsis-km")/1.853));
    
        p_dps_mnvr.ha_tgt.setText(sprintf("%3.0f",getprop("/fdm/jsbsim/systems/ap/oms-plan/apoapsis-nm")));
        p_dps_mnvr.hp_tgt.setText(sprintf("%3.0f",getprop("/fdm/jsbsim/systems/ap/oms-plan/periapsis-nm")));
    
        var fwd_rcs_dump = getprop("/fdm/jsbsim/systems/rcs/fwd-dump-cmd");
        var fwd_rcs_dump_arm = getprop("/fdm/jsbsim/systems/rcs/fwd-dump-arm-cmd");
    
        if ((fwd_rcs_dump == 0) and (fwd_rcs_dump_arm == 0))
    	{
            p_dps_mnvr.fwd_rcs_off.setText("*");
            p_dps_mnvr.fwd_rcs_arm.setText("");
            p_dps_mnvr.fwd_rcs_dump.setText("");
    	}
        else if ((fwd_rcs_dump_arm == 1) and (fwd_rcs_dump == 0))
    	{
            p_dps_mnvr.fwd_rcs_off.setText("");
            p_dps_mnvr.fwd_rcs_arm.setText("*");
            p_dps_mnvr.fwd_rcs_dump.setText("");
    	}
        else
    	{
            p_dps_mnvr.fwd_rcs_off.setText("");
            p_dps_mnvr.fwd_rcs_arm.setText("*");
            p_dps_mnvr.fwd_rcs_dump.setText("*");
    	}
    
        var control_mode = getprop("/fdm/jsbsim/systems/fcs/control-mode");
    
        if ((control_mode == 24) or (control_mode == 29))
    	{
            p_dps_mnvr.surf_drive_on.setText("*");
            p_dps_mnvr.surf_drive_off.setText("");
    	}
        else
    	{
            p_dps_mnvr.surf_drive_on.setText("");
            p_dps_mnvr.surf_drive_off.setText("*");
    	}
    

	var burn_mode = getprop("/fdm/jsbsim/systems/ap/oms-plan/burn-mode");

	if (burn_mode == 1)
		{
       		p_dps_mnvr.oms_both.setText("*");
        	p_dps_mnvr.oms_l.setText("");
        	p_dps_mnvr.oms_r.setText("");
        	p_dps_mnvr.rcs_sel.setText("");
		}
	else if (burn_mode == 2)
		{
       		p_dps_mnvr.oms_both.setText("");
        	p_dps_mnvr.oms_l.setText("*");
        	p_dps_mnvr.oms_r.setText("");
        	p_dps_mnvr.rcs_sel.setText("");
		}
	else if (burn_mode == 3)
		{
       		p_dps_mnvr.oms_both.setText("");
        	p_dps_mnvr.oms_l.setText("");
        	p_dps_mnvr.oms_r.setText("*");
        	p_dps_mnvr.rcs_sel.setText("");
		}
	else if (burn_mode == 4)
		{
       		p_dps_mnvr.oms_both.setText("");
        	p_dps_mnvr.oms_l.setText("");
        	p_dps_mnvr.oms_r.setText("");
        	p_dps_mnvr.rcs_sel.setText("*");
		}

    
    
        p_dps_mnvr.tv_roll.setText(sprintf("%3.0f",getprop("fdm/jsbsim/systems/ap/oms-plan/tv-roll")));
    
        p_dps_mnvr.p.setText(sprintf("%1.1f",getprop("fdm/jsbsim/systems/ap/oms-plan/trim-pitch")));
        p_dps_mnvr.ly.setText(sprintf("%1.1f",getprop("fdm/jsbsim/systems/ap/oms-plan/trim-yaw-left")));
        p_dps_mnvr.ry.setText(sprintf("%1.1f",getprop("fdm/jsbsim/systems/ap/oms-plan/trim-yaw-right")));
    
        p_dps_mnvr.wt.setText(sprintf("%6.0f",getprop("fdm/jsbsim/systems/ap/oms-plan/weight")));
    
        p_dps_mnvr.tig.setText(getprop("fdm/jsbsim/systems/ap/oms-plan/tig-string"));
    
        p_dps_mnvr.dvx.setText(sprintf("%4.1f",getprop("fdm/jsbsim/systems/ap/oms-plan/dvx")));
        p_dps_mnvr.dvy.setText(sprintf("%3.1f",getprop("fdm/jsbsim/systems/ap/oms-plan/dvy")));
        p_dps_mnvr.dvz.setText(sprintf("%3.1f",getprop("fdm/jsbsim/systems/ap/oms-plan/dvz")));
    
        var tgt_roll = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/tgt-roll-deg");
        var tgt_pitch = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/tgt-pitch-deg");
        var tgt_yaw = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/tgt-yaw-deg");
    
        p_dps_mnvr.burn_att_roll.setText(sprintf("%+3.2f",tgt_roll));
        p_dps_mnvr.burn_att_pitch.setText(sprintf("%+3.2f",tgt_pitch));
        p_dps_mnvr.burn_att_yaw.setText(sprintf("%+3.2f",tgt_yaw));
    
        var oms_mnvr_flag = getprop("/fdm/jsbsim/systems/ap/oms-mnvr-flag");
        var oms_mnvr_text = "MNVR 27";
        if (oms_mnvr_flag == 1) {oms_mnvr_text = "MNVR 27*";}
    
        var dap_text = "FREE";
        if (getprop("/fdm/jsbsim/systems/ap/orbital-dap-auto") == 1)
    	{dap_text = "AUTO";}
        else if(getprop("/fdm/jsbsim/systems/ap/orbital-dap-inertial") == 1)
    	{dap_text = "INRTL";}
        else if(getprop("/fdm/jsbsim/systems/ap/orbital-dap-lvlh") == 1)
    	{dap_text = "LVLH";}
    
    
        p_dps_mnvr.mnvr.setText(oms_mnvr_text);
        p_dps_mnvr.active_dap.setText(dap_text);

        var attitude_flag = getprop("/fdm/jsbsim/systems/ap/track/in-attitude");

	if ((oms_mnvr_flag == 1) and (dap_text == "AUTO") and (attitude_flag == 0))
		{
		var rate = getprop("/fdm/jsbsim/systems/ap/rot-rate-degps");
		var yaw_error = getprop("/fdm/jsbsim/systems/ap/track/yaw-error-deg");
		var pitch_error = getprop("/fdm/jsbsim/systems/ap/track/pitch-error-deg");
		var roll_error = getprop("/fdm/jsbsim/systems/ap/track/roll-error-deg");

		var tt_pitch_yaw = math.max(pitch_error, yaw_error)/rate;
		var tt_roll = math.abs(roll_error)/rate;

		var tta = SpaceShuttle.seconds_to_stringMS (tt_pitch_yaw + tt_roll);
		p_dps_mnvr.tta.setText(tta);
		}
	else
		{
		p_dps_mnvr.tta.setText("");
		}
    
    
        p_dps_mnvr.dvtot.setText(sprintf("%+4.2f",getprop("/fdm/jsbsim/systems/ap/oms-plan/dvtot")));
        p_dps_mnvr.tgo.setText(getprop("/fdm/jsbsim/systems/ap/oms-plan/tgo-string"));
    

        var burn_plan = getprop("/fdm/jsbsim/systems/ap/oms-plan/burn-plan-available");
    
    
        if (burn_plan == 0)
    	{p_dps_mnvr.load.setText("LOAD");}
        else
    	{p_dps_mnvr.load.setText("CNCL");}
    
        var exec_string = "";
    
        var MET = getprop("/sim/time/elapsed-sec") + getprop("/fdm/jsbsim/systems/timer/delta-MET");
    
        var exec_timer_flag = 0;
    
        if (SpaceShuttle.oms_burn_target.tig - MET < 15.0)
    	{
            exec_timer_flag = 1;
    	}
    
        if ((attitude_flag == 1) and (burn_plan == 1) and (exec_timer_flag == 1) )
    	{
            exec_string = "EXEC";
            var exec_cmd = getprop("/fdm/jsbsim/systems/ap/oms-plan/exec-cmd");
            if (exec_cmd == 0) # blink before ignition
    		{
                if (p_dps_mnvr.blink == 0) 
    			{p_dps_mnvr.blink = 1; exec_string = "";}
                else
    			{p_dps_mnvr.blink = 0;}
    		}
    	}
    
        p_dps_mnvr.exec.setText(exec_string);
    
        var tta = SpaceShuttle.time_to_apsis();
    
        var tta_string = "TTP";
        if (tta[0] == 2) {tta_string = "TTA";}
    
        var tta_time = SpaceShuttle.seconds_to_stringMS(tta[1]);
    
        p_dps_mnvr.ttapsis_text.setText(tta_string);
        p_dps_mnvr.ttapsis.setText(tta_time);
    
        p_dps_mnvr.vgo_x.setText(sprintf("%4.1f",getprop("fdm/jsbsim/systems/ap/oms-plan/vgo-x")));
        p_dps_mnvr.vgo_y.setText(sprintf("%3.1f",getprop("fdm/jsbsim/systems/ap/oms-plan/vgo-y")));
        p_dps_mnvr.vgo_z.setText(sprintf("%3.1f",getprop("fdm/jsbsim/systems/ap/oms-plan/vgo-z"))); 
    
    
        var gimbal_l_pri = getprop("/fdm/jsbsim/systems/oms-hardware/gimbal-left-pri-selected");
        var gimbal_l_sec = getprop("/fdm/jsbsim/systems/oms-hardware/gimbal-left-sec-selected");
        var gimbal_r_pri = getprop("/fdm/jsbsim/systems/oms-hardware/gimbal-right-pri-selected");
        var gimbal_r_sec = getprop("/fdm/jsbsim/systems/oms-hardware/gimbal-right-sec-selected");
    
        var gsym1 = ""; var gsym2 = ""; var gsym3 = "";
    
        if (gimbal_l_pri == 1) {gsym1 = "*";}
        else if (gimbal_l_sec == 1) {gsym2 = "*";}
        else {gsym3 = "*";}
    
        p_dps_mnvr.pri_l.setText( gsym1);
        p_dps_mnvr.sec_l.setText( gsym2);
        p_dps_mnvr.off_l.setText( gsym3);
    
        gsym1 = ""; gsym2 = ""; gsym3 = "";
    
        if (gimbal_r_pri == 1) {gsym1 = "*";}
        else if (gimbal_r_sec == 1) {gsym2 = "*";}
        else {gsym3 = "*";}
    
        p_dps_mnvr.pri_r.setText( gsym1);
        p_dps_mnvr.sec_r.setText( gsym2);
        p_dps_mnvr.off_r.setText( gsym3);
    
        var gimbal_check = getprop("/fdm/jsbsim/systems/oms-hardware/gimbal-chk-cmd");
    
        if (gimbal_check == 1) {gsym1 = "*";} else {gsym1 = "";}
    
        p_dps_mnvr.gmbl_ck.setText( gsym1);

	p_dps_mnvr.abort_tgt.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/abort/oms-abort-tgt-id")));
    }
    
    return p_dps_mnvr;
}
