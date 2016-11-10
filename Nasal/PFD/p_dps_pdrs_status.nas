#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_pdrs_status
# Description: the PDRS status page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_pdrs_status = func(device)
{
    var p_dps_pdrs_status = device.addPage("CRTPDRS_status", "p_dps_pdrs_status");

    p_dps_pdrs_status.group = device.svg.getElementById("p_dps_pdrs_status");
    p_dps_pdrs_status.group.setColor(dps_r, dps_g, dps_b);
    
    p_dps_pdrs_status.ang_sy = device.svg.getElementById("p_dps_pdrs_status_ang_sy");
    p_dps_pdrs_status.ang_sp = device.svg.getElementById("p_dps_pdrs_status_ang_sp");
    p_dps_pdrs_status.ang_ep = device.svg.getElementById("p_dps_pdrs_status_ang_ep");
    p_dps_pdrs_status.ang_wp = device.svg.getElementById("p_dps_pdrs_status_ang_wp");
    p_dps_pdrs_status.ang_wy = device.svg.getElementById("p_dps_pdrs_status_ang_wy");
    p_dps_pdrs_status.ang_wr = device.svg.getElementById("p_dps_pdrs_status_ang_wr");

    p_dps_pdrs_status.pohs_pref_x = device.svg.getElementById("p_dps_pdrs_status_pohs_pref_x");
    p_dps_pdrs_status.pohs_pref_y = device.svg.getElementById("p_dps_pdrs_status_pohs_pref_y");
    p_dps_pdrs_status.pohs_pref_z = device.svg.getElementById("p_dps_pdrs_status_pohs_pref_z");

    p_dps_pdrs_status.pohs_aref_p = device.svg.getElementById("p_dps_pdrs_status_pohs_aref_p");
    p_dps_pdrs_status.pohs_aref_y = device.svg.getElementById("p_dps_pdrs_status_pohs_aref_y");
    p_dps_pdrs_status.pohs_aref_r = device.svg.getElementById("p_dps_pdrs_status_pohs_aref_r");

    p_dps_pdrs_status.pos_x = device.svg.getElementById("p_dps_pdrs_status_pos_x");
    p_dps_pdrs_status.pos_y = device.svg.getElementById("p_dps_pdrs_status_pos_y");
    p_dps_pdrs_status.pos_z = device.svg.getElementById("p_dps_pdrs_status_pos_z");

    p_dps_pdrs_status.trate_act_x = device.svg.getElementById("p_dps_pdrs_status_trate_act_x");
    p_dps_pdrs_status.trate_act_y = device.svg.getElementById("p_dps_pdrs_status_trate_act_y");
    p_dps_pdrs_status.trate_act_z = device.svg.getElementById("p_dps_pdrs_status_trate_act_z");

    p_dps_pdrs_status.trate_cmd_x = device.svg.getElementById("p_dps_pdrs_status_trate_cmd_x");
    p_dps_pdrs_status.trate_cmd_y = device.svg.getElementById("p_dps_pdrs_status_trate_cmd_y");
    p_dps_pdrs_status.trate_cmd_z = device.svg.getElementById("p_dps_pdrs_status_trate_cmd_z");

    p_dps_pdrs_status.att_p = device.svg.getElementById("p_dps_pdrs_status_att_p");
    p_dps_pdrs_status.att_y = device.svg.getElementById("p_dps_pdrs_status_att_y");
    p_dps_pdrs_status.att_r = device.svg.getElementById("p_dps_pdrs_status_att_r");

    p_dps_pdrs_status.rrate_act_p = device.svg.getElementById("p_dps_pdrs_status_rrate_act_p");
    p_dps_pdrs_status.rrate_act_y = device.svg.getElementById("p_dps_pdrs_status_rrate_act_y");
    p_dps_pdrs_status.rrate_act_r = device.svg.getElementById("p_dps_pdrs_status_rrate_act_r");

    p_dps_pdrs_status.rrate_cmd_p = device.svg.getElementById("p_dps_pdrs_status_rrate_cmd_p");
    p_dps_pdrs_status.rrate_cmd_y = device.svg.getElementById("p_dps_pdrs_status_rrate_cmd_y");
    p_dps_pdrs_status.rrate_cmd_r = device.svg.getElementById("p_dps_pdrs_status_rrate_cmd_r");

    p_dps_pdrs_status.rms_sel = device.svg.getElementById("p_dps_pdrs_status_rms_sel");
    p_dps_pdrs_status.por_ref_sel = device.svg.getElementById("p_dps_pdrs_status_por_ref_sel");
    
    p_dps_pdrs_status.last_pt = device.svg.getElementById("p_dps_pdrs_status_last_pt");

    p_dps_pdrs_status.pohs_err = device.svg.getElementById("p_dps_pdrs_status_pohs_err");
    p_dps_pdrs_status.att_err = device.svg.getElementById("p_dps_pdrs_status_att_err");

    p_dps_pdrs_status.ee_rigid = device.svg.getElementById("p_dps_pdrs_status_ee_rigid");
    p_dps_pdrs_status.ee_derig = device.svg.getElementById("p_dps_pdrs_status_ee_derig");

    p_dps_pdrs_status.ee_close = device.svg.getElementById("p_dps_pdrs_status_ee_close");
    p_dps_pdrs_status.ee_open = device.svg.getElementById("p_dps_pdrs_status_ee_open");

    p_dps_pdrs_status.ee_capture = device.svg.getElementById("p_dps_pdrs_status_ee_capture");
    p_dps_pdrs_status.ee_extend = device.svg.getElementById("p_dps_pdrs_status_ee_extend");




    p_dps_pdrs_status.ondisplay = func
    {
        device.DPS_menu_title.setText("PDRS STATUS");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-sm");
	var spec =  getprop("/fdm/jsbsim/systems/dps/spec-sm");
	var spec_string = assemble_spec_string(spec);
    
        var ops_string = major_mode~"1/"~spec_string~"/169";
        device.DPS_menu_ops.setText(ops_string);

	# defaults for functions which are not yet implemented

	p_dps_pdrs_status.rms_sel.setText("PORT");
	p_dps_pdrs_status.por_ref_sel.setText("ORB");
    	p_dps_pdrs_status.pohs_err.setText("0.0");
    	p_dps_pdrs_status.att_err.setText("0.0");


    }
    
    p_dps_pdrs_status.update = func
    {

	# last point

	var current_point = SpaceShuttle.pdrs_auto_seq_manager.current_index +1;
	
	if (current_point > 0)
		{
		p_dps_pdrs_status.last_pt.setText(sprintf("%d", current_point ));
		}
	else
		{
		p_dps_pdrs_status.last_pt.setText("");
		}

    
	# joint angles

    	p_dps_pdrs_status.ang_sy.setText(sprintf("%+5.2f", getprop("/fdm/jsbsim/systems/rms/ang-shoulder-yaw-deg")));
    	p_dps_pdrs_status.ang_sp.setText(sprintf("%+5.2f", getprop("/fdm/jsbsim/systems/rms/ang-shoulder-pitch-deg")));
    	p_dps_pdrs_status.ang_ep.setText(sprintf("%+5.2f", getprop("/fdm/jsbsim/systems/rms/ang-ellbow-pitch-deg")));
    	p_dps_pdrs_status.ang_wp.setText(sprintf("%+5.2f", getprop("/fdm/jsbsim/systems/rms/ang-wrist-pitch-deg"))); 
    	p_dps_pdrs_status.ang_wy.setText(sprintf("%+5.2f", getprop("/fdm/jsbsim/systems/rms/ang-wrist-yaw-deg")));
    	p_dps_pdrs_status.ang_wr.setText(sprintf("%+5.2f", getprop("/fdm/jsbsim/systems/rms/ang-wrist-roll-deg")));

	# position
    
	var pos_x = getprop("/fdm/jsbsim/systems/rms/effector-x") * 39.37;
	var pos_y = getprop("/fdm/jsbsim/systems/rms/effector-y") * 39.37;
	var pos_z = getprop("/fdm/jsbsim/systems/rms/effector-z") * 39.37;


    	p_dps_pdrs_status.pohs_pref_x.setText(sprintf("%+5.0f", pos_x));
    	p_dps_pdrs_status.pohs_pref_y.setText(sprintf("%+5.0f", pos_y));
    	p_dps_pdrs_status.pohs_pref_z.setText(sprintf("%+5.0f", pos_z));

	p_dps_pdrs_status.pos_x.setText(sprintf("%+5.0f", pos_x));
	p_dps_pdrs_status.pos_y.setText(sprintf("%+5.0f", pos_y));
	p_dps_pdrs_status.pos_z.setText(sprintf("%+5.0f", pos_z));


	# pos rates

	var x_rate = getprop("/fdm/jsbsim/systems/rms/ma/x-rate") / 0.3048;
	var y_rate = getprop("/fdm/jsbsim/systems/rms/ma/y-rate") / 0.3048;
	var z_rate = getprop("/fdm/jsbsim/systems/rms/ma/z-rate") / 0.3048;

    	p_dps_pdrs_status.trate_cmd_x.setText(sprintf("%+4.2f", x_rate));
    	p_dps_pdrs_status.trate_cmd_y.setText(sprintf("%+4.2f", y_rate));
    	p_dps_pdrs_status.trate_cmd_z.setText(sprintf("%+4.2f", z_rate));

    	p_dps_pdrs_status.trate_act_x.setText(sprintf("%+4.2f", x_rate));
    	p_dps_pdrs_status.trate_act_y.setText(sprintf("%+4.2f", y_rate));
    	p_dps_pdrs_status.trate_act_z.setText(sprintf("%+4.2f", z_rate));

	# attitude

	var att_p = getprop("/fdm/jsbsim/systems/rms/sum-wrist-yaw-pitch-deg");
	var att_y = getprop("/fdm/jsbsim/systems/rms/sum-wrist-yaw-deg");
	var att_r = getprop("/fdm/jsbsim/systems/rms/ang-wrist-roll-deg");

    	p_dps_pdrs_status.pohs_aref_p.setText(sprintf("%+4.1f", att_p));
    	p_dps_pdrs_status.pohs_aref_y.setText(sprintf("%+4.1f", att_y));
    	p_dps_pdrs_status.pohs_aref_r.setText(sprintf("%+4.1f", att_r));

    	p_dps_pdrs_status.att_p.setText(sprintf("%+4.1f", att_p));
    	p_dps_pdrs_status.att_y.setText(sprintf("%+4.1f", att_y));
    	p_dps_pdrs_status.att_r.setText(sprintf("%+4.1f", att_r));

	# att rates

	var pitch_rate = getprop("/fdm/jsbsim/systems/rms/ma/pitch-rate");
	var yaw_rate = getprop("/fdm/jsbsim/systems/rms/ma/yaw-rate");
	var roll_rate = getprop("/fdm/jsbsim/systems/rms/ma/roll-rate");

    	p_dps_pdrs_status.rrate_act_p.setText(sprintf("%+4.2f", pitch_rate));
    	p_dps_pdrs_status.rrate_act_y.setText(sprintf("%+4.2f", yaw_rate));
    	p_dps_pdrs_status.rrate_act_r.setText(sprintf("%+4.2f", roll_rate));

    	p_dps_pdrs_status.rrate_cmd_p.setText(sprintf("%+4.2f", pitch_rate));
    	p_dps_pdrs_status.rrate_cmd_y.setText(sprintf("%+4.2f", yaw_rate)); 
    	p_dps_pdrs_status.rrate_cmd_r.setText(sprintf("%+4.2f", roll_rate));

	# end effector state

	var effector_attached = getprop("/fdm/jsbsim/systems/rms/effector-attached");
	if (effector_attached != 1) {effector_attached = 0;}

	var effector_rigid = getprop("/fdm/jsbsim/systems/rms/effector-rigid");
	var effector_closed = getprop("/fdm/jsbsim/systems/rms/effector-closed");

	p_dps_pdrs_status.ee_rigid.setText(sprintf("%d", effector_rigid));   
    	p_dps_pdrs_status.ee_derig.setText(sprintf("%d", 1 - effector_rigid));  

    	p_dps_pdrs_status.ee_close.setText(sprintf("%d", effector_closed));  
    	p_dps_pdrs_status.ee_open.setText(sprintf("%d", 1 - effector_closed));  

    	p_dps_pdrs_status.ee_capture.setText(sprintf("%d", effector_attached));  
    	p_dps_pdrs_status.ee_extend.setText(sprintf("%d", 1-effector_attached));  


        device.update_common_DPS();
    }
    
    
    
    return p_dps_pdrs_status;
}
