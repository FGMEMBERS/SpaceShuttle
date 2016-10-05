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

    p_dps_pdrs_status.att_p = device.svg.getElementById("p_dps_pdrs_status_att_p");
    p_dps_pdrs_status.att_y = device.svg.getElementById("p_dps_pdrs_status_att_y");
    p_dps_pdrs_status.att_r = device.svg.getElementById("p_dps_pdrs_status_att_r");

    p_dps_pdrs_status.rms_sel = device.svg.getElementById("p_dps_pdrs_status_rms_sel");
    p_dps_pdrs_status.por_ref_sel = device.svg.getElementById("p_dps_pdrs_status_por_ref_sel");
    
    p_dps_pdrs_status.last_pt = device.svg.getElementById("p_dps_pdrs_status_last_pt");

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

        device.update_common_DPS();
    }
    
    
    
    return p_dps_pdrs_status;
}
