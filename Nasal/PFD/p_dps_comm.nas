#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_comm
# Description: the DPS COMMUNICATIONS page
#      Author: Thorsten Renk, 2017
#---------------------------------------

var PFD_addpage_p_dps_comm = func(device)
{
    var p_dps_comm = device.addPage("CRTComm", "p_dps_comm");

    p_dps_comm.group = device.svg.getElementById("p_dps_comm");
    p_dps_comm.group.setColor(dps_r, dps_g, dps_b);

    p_dps_comm.ant_elec1 = device.svg.getElementById("p_dps_comm_ant_elec1");
    p_dps_comm.ant_elec2 = device.svg.getElementById("p_dps_comm_ant_elec2");

    p_dps_comm.ant_elec1.enableUpdate();
    p_dps_comm.ant_elec2.enableUpdate();
   
    p_dps_comm.preamp1 = device.svg.getElementById("p_dps_comm_preamp1");
    p_dps_comm.preamp2 = device.svg.getElementById("p_dps_comm_preamp2");

    p_dps_comm.preamp1.enableUpdate();
    p_dps_comm.preamp2.enableUpdate();

    p_dps_comm.pwr_out1 = device.svg.getElementById("p_dps_comm_pwr_out1");
    p_dps_comm.pwr_out2 = device.svg.getElementById("p_dps_comm_pwr_out2");

    p_dps_comm.temp1 = device.svg.getElementById("p_dps_comm_temp1");
    p_dps_comm.temp2 = device.svg.getElementById("p_dps_comm_temp2");

    p_dps_comm.xpndr1 = device.svg.getElementById("p_dps_comm_xpndr1");
    p_dps_comm.xpndr2 = device.svg.getElementById("p_dps_comm_xpndr2");

    p_dps_comm.xpndr1.enableUpdate();
    p_dps_comm.xpndr2.enableUpdate();

    p_dps_comm.oper1 = device.svg.getElementById("p_dps_comm_oper1");
    p_dps_comm.oper2 = device.svg.getElementById("p_dps_comm_oper2");

    p_dps_comm.oper1.enableUpdate();
    p_dps_comm.oper2.enableUpdate();

    p_dps_comm.stby1 = device.svg.getElementById("p_dps_comm_stby1");
    p_dps_comm.stby2 = device.svg.getElementById("p_dps_comm_stby2");

    p_dps_comm.stby1.enableUpdate();
    p_dps_comm.stby2.enableUpdate();

    p_dps_comm.bite1 = device.svg.getElementById("p_dps_comm_bite1");
    p_dps_comm.bite2 = device.svg.getElementById("p_dps_comm_bite2");

    p_dps_comm.comsec_bite1 = device.svg.getElementById("p_dps_comm_comsec_bite1");
    p_dps_comm.comsec_bite2 = device.svg.getElementById("p_dps_comm_comsec_bite2");

    p_dps_comm.bit_sync1 = device.svg.getElementById("p_dps_comm_bit_sync1");
    p_dps_comm.bit_sync2 = device.svg.getElementById("p_dps_comm_bit_sync2");

    p_dps_comm.frm_sync1 = device.svg.getElementById("p_dps_comm_frm_sync1");
    p_dps_comm.frm_sync2 = device.svg.getElementById("p_dps_comm_frm_sync2");

    p_dps_comm.frm_sync_ssor1 = device.svg.getElementById("p_dps_comm_frm_sync_ssor1");
    p_dps_comm.frm_sync_ssor2 = device.svg.getElementById("p_dps_comm_frm_sync_ssor2");

    p_dps_comm.mode = device.svg.getElementById("p_dps_comm_mode");
    p_dps_comm.pwr_out = device.svg.getElementById("p_dps_comm_pwr_out");


    p_dps_comm.auto_k_to_s = device.svg.getElementById("p_dps_comm_auto_k_to_s");
    p_dps_comm.auto_s_to_k = device.svg.getElementById("p_dps_comm_auto_s_to_k");

    p_dps_comm.freq = device.svg.getElementById("p_dps_comm_freq");
    p_dps_comm.spm = device.svg.getElementById("p_dps_comm_spm");
    p_dps_comm.cgil_config = device.svg.getElementById("p_dps_comm_cgil_config");
    p_dps_comm.fail_safe = device.svg.getElementById("p_dps_comm_fail_safe");
    p_dps_comm.cctv_cmra_overtmp = device.svg.getElementById("p_dps_comm_cctv_cmra_overtmp");


    p_dps_comm.coding_xmit = device.svg.getElementById("p_dps_comm_coding_xmit");
    p_dps_comm.coding_rcv = device.svg.getElementById("p_dps_comm_coding_rcv");

    p_dps_comm.data_rate_xmit = device.svg.getElementById("p_dps_comm_data_rate_xmit");
    p_dps_comm.data_rate_rcv = device.svg.getElementById("p_dps_comm_data_rate_rcv");

    p_dps_comm.pa_temp = device.svg.getElementById("p_dps_comm_pa_temp");
    p_dps_comm.gimbal_temp_A = device.svg.getElementById("p_dps_comm_gimbal_temp_A");
    p_dps_comm.gimbal_temp_B = device.svg.getElementById("p_dps_comm_gimbal_temp_B");
    p_dps_comm.gryo_temp = device.svg.getElementById("p_dps_comm_gyro_temp");

    p_dps_comm.frm_sync = device.svg.getElementById("p_dps_comm_frm_sync");
    p_dps_comm.ul_data_source = device.svg.getElementById("p_dps_comm_ul_data_source");


    p_dps_comm.pwr_level_ssor = device.svg.getElementById("p_dps_comm_pwr_level_ssor");
    p_dps_comm.pwr_status_ssor = device.svg.getElementById("p_dps_comm_pwr_status_ssor");

    p_dps_comm.proc_stat_ssor1 = device.svg.getElementById("p_dps_comm_proc_stat_ssor1");
    p_dps_comm.proc_stat_ssor2 = device.svg.getElementById("p_dps_comm_proc_stat_ssor2");
    
    p_dps_comm.ondisplay = func
    {
        device.DPS_menu_title.setText("COMMUNICATIONS");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-sm");
	var spec = getprop("/fdm/jsbsim/systems/dps/spec-sm");   
	var spec_string = assemble_spec_string(spec);
    
        var ops_string = major_mode~"1/"~spec_string~"/076";
        device.DPS_menu_ops.setText(ops_string);

	# defaults for functions not yet implemented

    	p_dps_comm.freq.setText("HI");
	p_dps_comm.spm.setText("");
	p_dps_comm.cgil_config.setText("PNL");

    	p_dps_comm.bite1.setText("GOOD");
    	p_dps_comm.bite2.setText("GOOD");

    	p_dps_comm.comsec_bite1.setText("GOOD");
    	p_dps_comm.comsec_bite2.setText("GOOD");

    	p_dps_comm.coding_xmit.setText("OFF");
    	p_dps_comm.coding_rcv.setText("OFF");

   	p_dps_comm.data_rate_xmit.setText("HI");
    	p_dps_comm.data_rate_rcv.setText("HI");

	p_dps_comm.bit_sync1.setText("NO");
	p_dps_comm.bit_sync2.setText("NO");

    	p_dps_comm.frm_sync1.setText("YES");
    	p_dps_comm.frm_sync2.setText("YES");

	p_dps_comm.auto_k_to_s.setText("ENA");
	p_dps_comm.auto_s_to_k.setText("ENA");

	p_dps_comm.fail_safe.setText("INH");
	p_dps_comm.cctv_cmra_overtmp.setText("NO");

    }
    
    p_dps_comm.update = func
    {
    
	var antenna_operational = getprop("/fdm/jsbsim/systems/antenna/s-pm-operational");
        var ant_elec_switch = getprop("/fdm/jsbsim/systems/antenna/s-pm-power-sel-switch");


	if (antenna_operational * ant_elec_switch == 1)
		{
		p_dps_comm.ant_elec1.updateText("ON");
		p_dps_comm.ant_elec2.updateText("");
		}
	else if (antenna_operational * ant_elec_switch == -1)
		{
		p_dps_comm.ant_elec1.updateText("");
		p_dps_comm.ant_elec2.updateText("ON");
		}
	else
		{
		p_dps_comm.ant_elec1.updateText("");
		p_dps_comm.ant_elec2.updateText("");
		}

	var preamp_operational = getprop("/fdm/jsbsim/systems/antenna/s-pm-preamplifier-operational");
	var preamp_switch = getprop("/fdm/jsbsim/systems/antenna/s-pm-preamp-sel-switch");

	if (preamp_operational * preamp_switch == 1)
		{
		p_dps_comm.preamp1.updateText("ON");
		p_dps_comm.preamp2.updateText("");
		}
	else if (preamp_operational * preamp_switch == -1)
		{
		p_dps_comm.preamp1.updateText("");
		p_dps_comm.preamp2.updateText("ON");
		}
	else 
		{
		p_dps_comm.preamp1.updateText("");
		p_dps_comm.preamp2.updateText("");
		}

	var xpndr_operational = getprop("/fdm/jsbsim/systems/antenna/s-pm-xpndr-operational");
	var xpndr_switch = getprop("/fdm/jsbsim/systems/antenna/xpndr-sel-switch");

	if (xpndr_operational * xpndr_switch == 1)
		{
		p_dps_comm.xpndr1.updateText("ON");
		p_dps_comm.xpndr2.updateText("");
		}
	else if (xpndr_operational * xpndr_switch == -1)
		{
		p_dps_comm.xpndr1.updateText("");
		p_dps_comm.xpndr2.updateText("ON");
		}
	else 
		{
		p_dps_comm.xpndr1.updateText("");
		p_dps_comm.xpndr2.updateText("");
		}

	var power_amp_operational = getprop("/fdm/jsbsim/systems/antenna/s-pm-power-amp-operational");
	var power_amp_switch = getprop("/fdm/jsbsim/systems/antenna/s-pm-preamp-operate-switch");
	var power_amp_stby = getprop("/fdm/jsbsim/systems/antenna/s-pm-preamp-standby-switch");


	var nose_temp = K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/nose-temperature-K"));
	var power_amp_watts = 72.0 * power_amp_operational;


	if (power_amp_operational * power_amp_stby == 1)
		{
		p_dps_comm.stby1.updateText("STBY");
		p_dps_comm.stby2.updateText("");
		}
	else if (power_amp_operational * power_amp_stby == -1)
		{
		p_dps_comm.stby1.updateText("");
		p_dps_comm.stby2.updateText("STBY");
		}
	else 
		{
		p_dps_comm.stby1.updateText("");
		p_dps_comm.stby2.updateText("");
		}

	if (power_amp_operational * power_amp_switch == 1)
		{
		p_dps_comm.oper1.updateText("ON");
		p_dps_comm.oper2.updateText("");
		p_dps_comm.pwr_out1.setText(sprintf("%d", int(power_amp_watts) ));
		p_dps_comm.pwr_out2.setText("0");
		p_dps_comm.temp1.setText(sprintf("%d", int(nose_temp + power_amp_watts + 2)));
		p_dps_comm.temp2.setText(sprintf("%d", nose_temp));
		}
	else if (power_amp_operational * power_amp_switch == -1)
		{
		p_dps_comm.oper1.updateText("");
		p_dps_comm.oper2.updateText("ON");
		p_dps_comm.pwr_out1.setText("0");
		p_dps_comm.pwr_out2.setText(sprintf("%d", int(power_amp_watts) ));
		p_dps_comm.temp1.setText(sprintf("%d", nose_temp));
		p_dps_comm.temp2.setText(sprintf("%d", int(nose_temp + power_amp_watts -4)));
		}
	else 
		{
		p_dps_comm.oper1.updateText("");
		p_dps_comm.oper2.updateText("");
		p_dps_comm.pwr_out1.setText("0");
		p_dps_comm.pwr_out2.setText("0");
		p_dps_comm.temp1.setText(sprintf("%d", nose_temp));
		p_dps_comm.temp2.setText(sprintf("%d", nose_temp));
		}

	var ku_mode = SpaceShuttle.antenna_manager.function;

	var string = "";
	if (ku_mode == "COMM") {string = "COMM";} else {string = "RDR";}

	p_dps_comm.mode.setText(string);

	string = "";

	if (SpaceShuttle.antenna_manager.ku_link == 1)
		{string = "KU";}
	else if (SpaceShuttle.antenna_manager.s_link == 1)
		{string = "S";}

	p_dps_comm.ul_data_source.setText(string);

	# Ku antenna power usage and temperature
	
	var TDRS_tgt = SpaceShuttle.antenna_manager.TDRS_ku_tgt;
	var ku_operational = SpaceShuttle.antenna_manager.ku_operational;
	var ku_jettisoned = getprop("/fdm/jsbsim/systems/mechanical/ku-antenna-jettison");

	var ku_power = 5.0;
	
	if (ku_mode == "COMM") 
		{
		if (TDRS_tgt == 1) {ku_power = 15;}
		}


	ku_power = ku_operational * ku_power;
	p_dps_comm.pwr_out.setText(sprintf("%d", int(ku_power) ));

	var pb_temp = getprop("/fdm/jsbsim/systems/thermal-distribution/payload-bay-temperature-K");

	if (ku_jettisoned == 0)
		{
		var ku_temp = K_to_F(pb_temp + 0.5 * ku_power);

	    	p_dps_comm.pa_temp.setText(sprintf("%3.0f", ku_temp));
	    	p_dps_comm.gimbal_temp_A.setText(sprintf("%3.0f", ku_temp-1));
	    	p_dps_comm.gimbal_temp_B.setText(sprintf("%3.0f", ku_temp-3));
	    	p_dps_comm.gryo_temp.setText(sprintf("%3.0f", ku_temp+4));
		}
	else
		{
	    	p_dps_comm.pa_temp.setText("0.0M");
	    	p_dps_comm.gimbal_temp_A.setText("0.0M");
	    	p_dps_comm.gimbal_temp_B.setText("0.0M");
	    	p_dps_comm.gryo_temp.setText("0.0M");
		}


	string = "NO";
	if ((ku_mode == "COMM") and (TDRS_tgt == 1)) {string = "YES";}
 	p_dps_comm.frm_sync.setText(string);


	# UHF system

	var uhf_operational = getprop("/fdm/jsbsim/systems/antenna/uhf-operational");
	var uhf_function = getprop("/fdm/jsbsim/systems/antenna/uhf-sel-switch");
	var uhf_string = getprop("/fdm/jsbsim/systems/antenna/uhf-string-switch");

	if (uhf_operational == 0)
		{
    		p_dps_comm.pwr_level_ssor.setText("+15.0L");
    		p_dps_comm.pwr_status_ssor.setText("0.0L");
		p_dps_comm.proc_stat_ssor1.setText("BAD");
		p_dps_comm.proc_stat_ssor2.setText("BAD");
    		p_dps_comm.frm_sync_ssor1.setText("NO");
    		p_dps_comm.frm_sync_ssor2.setText("NO");
		}
	else
		{
    		p_dps_comm.pwr_level_ssor.setText("+19.1");
    		p_dps_comm.pwr_status_ssor.setText("35.0");

		if (uhf_string == 1)
			{
			p_dps_comm.proc_stat_ssor1.setText("OK");
			p_dps_comm.proc_stat_ssor2.setText("BAD");
	    		p_dps_comm.frm_sync_ssor1.setText("YES");
	    		p_dps_comm.frm_sync_ssor2.setText("NO");
			}
		else	
			{
			p_dps_comm.proc_stat_ssor1.setText("BAD");
			p_dps_comm.proc_stat_ssor2.setText("OK");
	    		p_dps_comm.frm_sync_ssor1.setText("NO");
	    		p_dps_comm.frm_sync_ssor2.setText("YES");
			}
		}




    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_comm;
}
