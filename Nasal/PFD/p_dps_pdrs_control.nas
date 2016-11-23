#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_pdrs
# Description: the payload remote handling control page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_pdrs_control = func(device)
{
    var p_dps_pdrs_control = device.addPage("CRTPdrsControl", "p_dps_pdrs_control");

    p_dps_pdrs_control.group = device.svg.getElementById("p_dps_pdrs_control");
    p_dps_pdrs_control.group.setColor(dps_r, dps_g, dps_b);
    
    p_dps_pdrs_control.rms_pwr = device.svg.getElementById("p_dps_pdrs_control_rms_pwr");
    p_dps_pdrs_control.io_on = device.svg.getElementById("p_dps_pdrs_control_io_on");
    p_dps_pdrs_control.io_off = device.svg.getElementById("p_dps_pdrs_control_io_off");
    p_dps_pdrs_control.rms_sel = device.svg.getElementById("p_dps_pdrs_control_rms_sel");
    p_dps_pdrs_control.port = device.svg.getElementById("p_dps_pdrs_control_port");
    p_dps_pdrs_control.stbd = device.svg.getElementById("p_dps_pdrs_control_stbd");
    p_dps_pdrs_control.end_eff = device.svg.getElementById("p_dps_pdrs_control_end_eff");
    p_dps_pdrs_control.rms_sn = device.svg.getElementById("p_dps_pdrs_control_rms_sn");


    p_dps_pdrs_control.soft_stop_ena = device.svg.getElementById("p_dps_pdrs_control_soft_stop_ena");
    p_dps_pdrs_control.soft_stop_inh = device.svg.getElementById("p_dps_pdrs_control_soft_stop_inh");
    
    p_dps_pdrs_control.autobrake_ena = device.svg.getElementById("p_dps_pdrs_control_autobrake_ena");
    p_dps_pdrs_control.autobrake_inh = device.svg.getElementById("p_dps_pdrs_control_autobrake_inh");

    p_dps_pdrs_control.pos_enc_ck_ena = device.svg.getElementById("p_dps_pdrs_control_pos_enc_ck_ena");
    p_dps_pdrs_control.pos_enc_ck_inh = device.svg.getElementById("p_dps_pdrs_control_pos_enc_ck_inh");

    p_dps_pdrs_control.pohs_cntl_ena = device.svg.getElementById("p_dps_pdrs_control_pohs_cntl_ena");
    p_dps_pdrs_control.pohs_cntl_inh = device.svg.getElementById("p_dps_pdrs_control_pohs_cntl_inh");

    p_dps_pdrs_control.pl_id = device.svg.getElementById("p_dps_pdrs_control_pl_id");
    p_dps_pdrs_control.pl_init_id = device.svg.getElementById("p_dps_pdrs_control_pl_init_id");

    p_dps_pdrs_control.auto_1 = device.svg.getElementById("p_dps_pdrs_control_auto_1");
    p_dps_pdrs_control.auto_2 = device.svg.getElementById("p_dps_pdrs_control_auto_2");
    p_dps_pdrs_control.auto_3 = device.svg.getElementById("p_dps_pdrs_control_auto_3");
    p_dps_pdrs_control.auto_4 = device.svg.getElementById("p_dps_pdrs_control_auto_4");

    p_dps_pdrs_control.last_pt = device.svg.getElementById("p_dps_pdrs_control_last_pt");
    p_dps_pdrs_control.start_pt = device.svg.getElementById("p_dps_pdrs_control_start_pt");

    p_dps_pdrs_control.endpos_x = device.svg.getElementById("p_dps_pdrs_control_endpos_x");
    p_dps_pdrs_control.endpos_y = device.svg.getElementById("p_dps_pdrs_control_endpos_y");
    p_dps_pdrs_control.endpos_z = device.svg.getElementById("p_dps_pdrs_control_endpos_z");
	
    p_dps_pdrs_control.endatt_p = device.svg.getElementById("p_dps_pdrs_control_endatt_p");
    p_dps_pdrs_control.endatt_y = device.svg.getElementById("p_dps_pdrs_control_endatt_y");
    p_dps_pdrs_control.endatt_r = device.svg.getElementById("p_dps_pdrs_control_endatt_r");

    p_dps_pdrs_control.latches_aft = device.svg.getElementById("p_dps_pdrs_control_latches_aft");
    p_dps_pdrs_control.latches_mid = device.svg.getElementById("p_dps_pdrs_control_latches_mid");
    p_dps_pdrs_control.latches_fwd = device.svg.getElementById("p_dps_pdrs_control_latches_fwd");

    p_dps_pdrs_control.mpm_sto_dply = device.svg.getElementById("p_dps_pdrs_control_mpm_sto_dply");

    p_dps_pdrs_control.mpm_discretes = device.svg.getElementById("p_dps_pdrs_control_mpm_discretes");

    p_dps_pdrs_control.cmd_ck = device.svg.getElementById("p_dps_pdrs_control_cmd_ck");

    p_dps_pdrs_control.cmd_ref_norm = device.svg.getElementById("p_dps_pdrs_control_cmd_ref_norm");
    p_dps_pdrs_control.cmd_ref_camr = device.svg.getElementById("p_dps_pdrs_control_cmd_ref_camr");
    p_dps_pdrs_control.cmd_ref_pl = device.svg.getElementById("p_dps_pdrs_control_cmd_ref_pl");

    p_dps_pdrs_control.wr_range = device.svg.getElementById("p_dps_pdrs_control_wr_range");
    p_dps_pdrs_control.auto_brake_ck = device.svg.getElementById("p_dps_pdrs_control_auto_brake_ck");
    p_dps_pdrs_control.por_display = device.svg.getElementById("p_dps_pdrs_control_por_display");



    p_dps_pdrs_control.ondisplay = func
    {
        device.DPS_menu_title.setText("PDRS CONTROL");
        device.MEDS_menu_title.setText("       DPS MENU");
    
	# defaults for items not yet implemented
    	p_dps_pdrs_control.port.setText("*");
    	p_dps_pdrs_control.stbd.setText("");
	p_dps_pdrs_control.end_eff.setText("1");
	p_dps_pdrs_control.rms_sn.setText("201");
	p_dps_pdrs_control.wr_range.setText("4");
	p_dps_pdrs_control.mpm_sto_dply.setText("PORT");
	p_dps_pdrs_control.por_display.setText("ORB");

    	p_dps_pdrs_control.cmd_ref_norm.setText("*");
    	p_dps_pdrs_control.cmd_ref_camr.setText("");
    	p_dps_pdrs_control.cmd_ref_pl.setText("");

        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-sm");
    
        var ops_string = major_mode~"1/094/";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_pdrs_control.update = func
    {
    
        
	var power_status =  getprop("/fdm/jsbsim/systems/rms/rms-power-switch");
	var string = "OFF";
	if (power_status == -1) {string = "B/U";} 
	else if (power_status == 1) {string = "PRI";}

	p_dps_pdrs_control.rms_pwr.setText(string);  
	

	if (getprop("/fdm/jsbsim/systems/rms/software/io-enable") == 0)
		{
		p_dps_pdrs_control.io_on.setText("");
		p_dps_pdrs_control.io_off.setText("*");
 		p_dps_pdrs_control.rms_sel.setText("");
		} 
	else
		{
		p_dps_pdrs_control.io_on.setText("*");
		p_dps_pdrs_control.io_off.setText("");
 		p_dps_pdrs_control.rms_sel.setText("PORT");
		} 

	if (getprop("/fdm/jsbsim/systems/rms/software/soft-stop-enable") == 0)
		{
		p_dps_pdrs_control.soft_stop_ena.setText("");
		p_dps_pdrs_control.soft_stop_inh.setText("*");
		}
	else
		{
		p_dps_pdrs_control.soft_stop_ena.setText("*");
		p_dps_pdrs_control.soft_stop_inh.setText("");
		}

	if (getprop("/fdm/jsbsim/systems/rms/software/autobrake-enable") == 0)
		{
		p_dps_pdrs_control.autobrake_ena.setText("");
		p_dps_pdrs_control.autobrake_inh.setText("*");
		}
	else
		{
		p_dps_pdrs_control.autobrake_ena.setText("*");
		p_dps_pdrs_control.autobrake_inh.setText("");
		}

	if (getprop("/fdm/jsbsim/systems/rms/software/pos-enc-ck-enable") == 0)
		{
		p_dps_pdrs_control.pos_enc_ck_ena.setText("");
		p_dps_pdrs_control.pos_enc_ck_inh.setText("*");
		}
	else
		{
		p_dps_pdrs_control.pos_enc_ck_ena.setText("*");
		p_dps_pdrs_control.pos_enc_ck_inh.setText("");
		}



	if (getprop("/fdm/jsbsim/systems/rms/software/pohs-cntl-enable") == 0)
		{
		p_dps_pdrs_control.pohs_cntl_ena.setText("");
		p_dps_pdrs_control.pohs_cntl_inh.setText("*");
		}
	else
		{
		p_dps_pdrs_control.pohs_cntl_ena.setText("*");
		p_dps_pdrs_control.pohs_cntl_inh.setText("");
		}

	if (getprop("/fdm/jsbsim/systems/rms/software/autobrake-check") == 1)
		{
		p_dps_pdrs_control.auto_brake_ck.setText("*");
		}
	else
		{
		p_dps_pdrs_control.auto_brake_ck.setText("");
		}


	#p_dps_pdrs_control.endpos_x.setText(sprintf("%3.2f",getprop("/fdm/jsbsim/systems/rms/software/tgt-pos-x")));
	#p_dps_pdrs_control.endpos_y.setText(sprintf("%3.2f",getprop("/fdm/jsbsim/systems/rms/software/tgt-pos-y")));
	#p_dps_pdrs_control.endpos_z.setText(sprintf("%3.2f",getprop("/fdm/jsbsim/systems/rms/software/tgt-pos-z")));

	#p_dps_pdrs_control.endatt_p.setText(sprintf("%3.2f",getprop("/fdm/jsbsim/systems/rms/software/tgt-att-p")));
	#p_dps_pdrs_control.endatt_y.setText(sprintf("%3.2f",getprop("/fdm/jsbsim/systems/rms/software/tgt-att-y")));
	#p_dps_pdrs_control.endatt_r.setText(sprintf("%3.2f",getprop("/fdm/jsbsim/systems/rms/software/tgt-att-r")));

	p_dps_pdrs_control.endpos_x.setText(sprintf("%3.2f",SpaceShuttle.pdrs_auto_seq_manager.opr_cmd_tgt[0]));
	p_dps_pdrs_control.endpos_y.setText(sprintf("%3.2f",SpaceShuttle.pdrs_auto_seq_manager.opr_cmd_tgt[1]));
	p_dps_pdrs_control.endpos_z.setText(sprintf("%3.2f",SpaceShuttle.pdrs_auto_seq_manager.opr_cmd_tgt[2]));

	p_dps_pdrs_control.endatt_p.setText(sprintf("%3.2f",SpaceShuttle.pdrs_auto_seq_manager.opr_cmd_tgt[3]));
	p_dps_pdrs_control.endatt_y.setText(sprintf("%3.2f",SpaceShuttle.pdrs_auto_seq_manager.opr_cmd_tgt[4]));
	p_dps_pdrs_control.endatt_r.setText(sprintf("%3.2f",SpaceShuttle.pdrs_auto_seq_manager.opr_cmd_tgt[5]));

	p_dps_pdrs_control.pl_id.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/rms/software/pl-id")));
	p_dps_pdrs_control.pl_init_id.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/rms/software/pl-init-id")));

	var mpm_status = getprop("/fdm/jsbsim/systems/rms/mpm-deploy-pos");
	var mpm_status_string = "0 0 0 0";
	
	if (mpm_status == 1)
		{
		mpm_status_string = "0 0 1 1";
		}
	else if (mpm_status == 0)
		{
		mpm_status_string = "1 1 0 0";
		}

	p_dps_pdrs_control.mpm_discretes.setText(mpm_status_string);

	var mpm_latch_status = getprop("/fdm/jsbsim/systems/rms/mpm-latch-pos");
	var mpm_ready_latch_status = getprop("/fdm/jsbsim/systems/rms/ready-to-latch");
	mpm_status_string = "0 0 0 0 0 0";
	
	if (mpm_latch_status == 1)
		{
		mpm_status_string = "1 1 0 0 0 0";
		}
	else if (mpm_ready_latch_status == 1)
		{
		mpm_status_string = "0 0 0 0 1 1";
		}
	else if ((mpm_ready_latch_status == 0) and (mpm_latch_status == 1))	
		{
		mpm_status_string = "0 0 1 1 0 0";
		}

	p_dps_pdrs_control.latches_aft.setText(mpm_status_string);
	p_dps_pdrs_control.latches_mid.setText(mpm_status_string);
	p_dps_pdrs_control.latches_fwd.setText(mpm_status_string);

	p_dps_pdrs_control.cmd_ck.setText(getprop("/fdm/jsbsim/systems/rms/software/reach-limit-string"));

	if (SpaceShuttle.pdrs_auto_seq_manager.sequence_slot_array[0] > 0)
		{p_dps_pdrs_control.auto_1.setText(sprintf("%d", SpaceShuttle.pdrs_auto_seq_manager.sequence_slot_array[0]));}
	else
		{p_dps_pdrs_control.auto_1.setText("");}

	if (SpaceShuttle.pdrs_auto_seq_manager.sequence_slot_array[1] > 0)
		{p_dps_pdrs_control.auto_2.setText(sprintf("%d", SpaceShuttle.pdrs_auto_seq_manager.sequence_slot_array[1]));}
	else
		{p_dps_pdrs_control.auto_2.setText("");}

	if (SpaceShuttle.pdrs_auto_seq_manager.sequence_slot_array[2] > 0)
		{p_dps_pdrs_control.auto_3.setText(sprintf("%d", SpaceShuttle.pdrs_auto_seq_manager.sequence_slot_array[2]));}
	else
		{p_dps_pdrs_control.auto_3.setText("");}

	if (SpaceShuttle.pdrs_auto_seq_manager.sequence_slot_array[3] > 0)
		{p_dps_pdrs_control.auto_4.setText(sprintf("%d", SpaceShuttle.pdrs_auto_seq_manager.sequence_slot_array[3]));}
	else
		{p_dps_pdrs_control.auto_4.setText("");}


	var current_point = SpaceShuttle.pdrs_auto_seq_manager.current_index +1;
	
	if (current_point > 0)
		{
		p_dps_pdrs_control.last_pt.setText(sprintf("%d", current_point ));
		}
	else
		{
		p_dps_pdrs_control.last_pt.setText("");
		}

	p_dps_pdrs_control.start_pt.setText(sprintf("%d", SpaceShuttle.pdrs_auto_seq_manager.start_index +1 ));


        device.update_common_DPS();
    }
    
    
    
    return p_dps_pdrs_control;
}
