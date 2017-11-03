#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_sys_summ1
# Description: the BFS system summary page 1
#      Author: Thorsten Renk, 2017
#---------------------------------------

var PFD_addpage_p_dps_bfs_sys_summ1 = func(device)
{
    var p_dps_bfs_sys_summ1 = device.addPage("CRTBFSSysSumm1", "p_dps_bfs_sys_summ1");

    p_dps_bfs_sys_summ1.group = device.svg.getElementById("p_dps_bfs_sys_summ1");
    p_dps_bfs_sys_summ1.group.setColor(dps_r, dps_g, dps_b);
    
    p_dps_bfs_sys_summ1.pos_rud = device.svg.getElementById("p_dps_bfs_sys_summ1_pos_rud");
    p_dps_bfs_sys_summ1.pos_ail = device.svg.getElementById("p_dps_bfs_sys_summ1_pos_ail");
    p_dps_bfs_sys_summ1.pos_sb = device.svg.getElementById("p_dps_bfs_sys_summ1_pos_sb");
    p_dps_bfs_sys_summ1.pos_bf = device.svg.getElementById("p_dps_bfs_sys_summ1_pos_bf");

    p_dps_bfs_sys_summ1.pos_lob = device.svg.getElementById("p_dps_bfs_sys_summ1_pos_lob");
    p_dps_bfs_sys_summ1.pos_lib = device.svg.getElementById("p_dps_bfs_sys_summ1_pos_lib");
    p_dps_bfs_sys_summ1.pos_rib = device.svg.getElementById("p_dps_bfs_sys_summ1_pos_rib");
    p_dps_bfs_sys_summ1.pos_rob = device.svg.getElementById("p_dps_bfs_sys_summ1_pos_rob");

    p_dps_bfs_sys_summ1.mom_lob = device.svg.getElementById("p_dps_bfs_sys_summ1_mom_lob");
    p_dps_bfs_sys_summ1.mom_lib = device.svg.getElementById("p_dps_bfs_sys_summ1_mom_lib");
    p_dps_bfs_sys_summ1.mom_rib = device.svg.getElementById("p_dps_bfs_sys_summ1_mom_rib");
    p_dps_bfs_sys_summ1.mom_rob = device.svg.getElementById("p_dps_bfs_sys_summ1_mom_rob");

    p_dps_bfs_sys_summ1.mdm_ff = device.svg.getElementById("p_dps_bfs_sys_summ1_mdm_ff");
    p_dps_bfs_sys_summ1.mdm_fa = device.svg.getElementById("p_dps_bfs_sys_summ1_mdm_fa");
    p_dps_bfs_sys_summ1.mdm_pl = device.svg.getElementById("p_dps_bfs_sys_summ1_mdm_pl");

    p_dps_bfs_sys_summ1.fcs_ch = device.svg.getElementById("p_dps_bfs_sys_summ1_fcs_ch");

    p_dps_bfs_sys_summ1.he_tk_p_l = device.svg.getElementById("p_dps_bfs_sys_summ1_he_tk_p_l");
    p_dps_bfs_sys_summ1.he_tk_p_c = device.svg.getElementById("p_dps_bfs_sys_summ1_he_tk_p_c");
    p_dps_bfs_sys_summ1.he_tk_p_r = device.svg.getElementById("p_dps_bfs_sys_summ1_he_tk_p_r");

    p_dps_bfs_sys_summ1.he_tk_p_l.enableUpdate();
    p_dps_bfs_sys_summ1.he_tk_p_c.enableUpdate();
    p_dps_bfs_sys_summ1.he_tk_p_r.enableUpdate();

    p_dps_bfs_sys_summ1.reg_p_a_l = device.svg.getElementById("p_dps_bfs_sys_summ1_reg_p_a_l");
    p_dps_bfs_sys_summ1.reg_p_a_c = device.svg.getElementById("p_dps_bfs_sys_summ1_reg_p_a_c");
    p_dps_bfs_sys_summ1.reg_p_a_r = device.svg.getElementById("p_dps_bfs_sys_summ1_reg_p_a_r");

    p_dps_bfs_sys_summ1.reg_p_a_l.enableUpdate();
    p_dps_bfs_sys_summ1.reg_p_a_c.enableUpdate();
    p_dps_bfs_sys_summ1.reg_p_a_r.enableUpdate();

    p_dps_bfs_sys_summ1.reg_p_b_l = device.svg.getElementById("p_dps_bfs_sys_summ1_reg_p_b_l");
    p_dps_bfs_sys_summ1.reg_p_b_c = device.svg.getElementById("p_dps_bfs_sys_summ1_reg_p_b_c");
    p_dps_bfs_sys_summ1.reg_p_b_r = device.svg.getElementById("p_dps_bfs_sys_summ1_reg_p_b_r");

    p_dps_bfs_sys_summ1.reg_p_b_l.enableUpdate();
    p_dps_bfs_sys_summ1.reg_p_b_c.enableUpdate();
    p_dps_bfs_sys_summ1.reg_p_b_r.enableUpdate();

    p_dps_bfs_sys_summ1.imu = device.svg.getElementById("p_dps_bfs_sys_summ1_imu");
    p_dps_bfs_sys_summ1.tac = device.svg.getElementById("p_dps_bfs_sys_summ1_tac");
    p_dps_bfs_sys_summ1.adta = device.svg.getElementById("p_dps_bfs_sys_summ1_adta");

    p_dps_bfs_sys_summ1.imu.enableUpdate();
    p_dps_bfs_sys_summ1.tac.enableUpdate();
    p_dps_bfs_sys_summ1.adta.enableUpdate();

    p_dps_bfs_sys_summ1.pneu_tk = device.svg.getElementById("p_dps_bfs_sys_summ1_pneu_tk");
    p_dps_bfs_sys_summ1.pneu_reg = device.svg.getElementById("p_dps_bfs_sys_summ1_pneu_reg");
    p_dps_bfs_sys_summ1.pneu_acum = device.svg.getElementById("p_dps_bfs_sys_summ1_pneu_acum");

    p_dps_bfs_sys_summ1.pneu_tk.enableUpdate();
    p_dps_bfs_sys_summ1.pneu_reg.enableUpdate();
    p_dps_bfs_sys_summ1.pneu_acum.enableUpdate();

    p_dps_bfs_sys_summ1.manf_lh2 = device.svg.getElementById("p_dps_bfs_sys_summ1_manf_lh2");
    p_dps_bfs_sys_summ1.manf_lo2 = device.svg.getElementById("p_dps_bfs_sys_summ1_manf_lo2");

    p_dps_bfs_sys_summ1.manf_lh2.enableUpdate();
    p_dps_bfs_sys_summ1.manf_lo2.enableUpdate();

    p_dps_bfs_sys_summ1.ull_lh2_l = device.svg.getElementById("p_dps_bfs_sys_summ1_ull_lh2_l");
    p_dps_bfs_sys_summ1.ull_lh2_c = device.svg.getElementById("p_dps_bfs_sys_summ1_ull_lh2_c");
    p_dps_bfs_sys_summ1.ull_lh2_r = device.svg.getElementById("p_dps_bfs_sys_summ1_ull_lh2_r");

    p_dps_bfs_sys_summ1.ull_lh2_l.enableUpdate();
    p_dps_bfs_sys_summ1.ull_lh2_c.enableUpdate();
    p_dps_bfs_sys_summ1.ull_lh2_r.enableUpdate();

    p_dps_bfs_sys_summ1.ull_lo2_l = device.svg.getElementById("p_dps_bfs_sys_summ1_ull_lo2_l");
    p_dps_bfs_sys_summ1.ull_lo2_c = device.svg.getElementById("p_dps_bfs_sys_summ1_ull_lo2_c");
    p_dps_bfs_sys_summ1.ull_lo2_r = device.svg.getElementById("p_dps_bfs_sys_summ1_ull_lo2_r");

    p_dps_bfs_sys_summ1.ull_lo2_l.enableUpdate();
    p_dps_bfs_sys_summ1.ull_lo2_c.enableUpdate();
    p_dps_bfs_sys_summ1.ull_lo2_r.enableUpdate();

    p_dps_bfs_sys_summ1.gh2_l = device.svg.getElementById("p_dps_bfs_sys_summ1_gh2_l");
    p_dps_bfs_sys_summ1.gh2_c = device.svg.getElementById("p_dps_bfs_sys_summ1_gh2_c");
    p_dps_bfs_sys_summ1.gh2_r = device.svg.getElementById("p_dps_bfs_sys_summ1_gh2_r");

    p_dps_bfs_sys_summ1.gh2_l.enableUpdate();
    p_dps_bfs_sys_summ1.gh2_c.enableUpdate();
    p_dps_bfs_sys_summ1.gh2_r.enableUpdate();

    p_dps_bfs_sys_summ1.go2_l = device.svg.getElementById("p_dps_bfs_sys_summ1_go2_l");
    p_dps_bfs_sys_summ1.go2_c = device.svg.getElementById("p_dps_bfs_sys_summ1_go2_c");
    p_dps_bfs_sys_summ1.go2_r = device.svg.getElementById("p_dps_bfs_sys_summ1_go2_r");

    p_dps_bfs_sys_summ1.go2_l.enableUpdate();
    p_dps_bfs_sys_summ1.go2_c.enableUpdate();
    p_dps_bfs_sys_summ1.go2_r.enableUpdate();

    p_dps_bfs_sys_summ1.dpdt_l = device.svg.getElementById("p_dps_bfs_sys_summ1_dpdt_l");
    p_dps_bfs_sys_summ1.dpdt_c = device.svg.getElementById("p_dps_bfs_sys_summ1_dpdt_c");
    p_dps_bfs_sys_summ1.dpdt_r = device.svg.getElementById("p_dps_bfs_sys_summ1_dpdt_r");

    p_dps_bfs_sys_summ1.dpdt_l.enableUpdate();
    p_dps_bfs_sys_summ1.dpdt_c.enableUpdate();
    p_dps_bfs_sys_summ1.dpdt_r.enableUpdate();

    p_dps_bfs_sys_summ1.ondisplay = func
    {
        device.DPS_menu_title.setText("GNC SYS SUMM 1");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-bfs");
	var spec = SpaceShuttle.idp_array[device.port_selected-1].get_spec();    
	var spec_string = assemble_spec_string(spec);
    
        var ops_string = major_mode~"1/"~spec_string~"/018";
        device.DPS_menu_ops.setText(ops_string);

	# blank items which are not yet implemented

    	p_dps_bfs_sys_summ1.mdm_ff.setText("");
    	p_dps_bfs_sys_summ1.mdm_fa.setText("");
    	p_dps_bfs_sys_summ1.mdm_pl.setText("");
	p_dps_bfs_sys_summ1.fcs_ch.setText("");
    	p_dps_bfs_sys_summ1.imu.setText("");
    }
    
    p_dps_bfs_sys_summ1.update = func
    {

        var mm = getprop("/fdm/jsbsim/systems/dps/major-mode-bfs");

	# Surface positions are only processed in OPS 3, MM 602 and 603

	if ((mm == 301) or (mm == 304) or (mm == 305) or (mm == 602) or (mm == 603)) 
		{
		var lob = getprop("/fdm/jsbsim/fcs/outboard-elevon-left-pos-deg");
		var lib = getprop("/fdm/jsbsim/fcs/inboard-elevon-left-pos-deg");
		var rob = getprop("/fdm/jsbsim/fcs/outboard-elevon-right-pos-deg");
		var rib = getprop("/fdm/jsbsim/fcs/inboard-elevon-right-pos-deg");

		p_dps_bfs_sys_summ1.pos_lob.setText(sprintf("%2.1f", lob)); 
		p_dps_bfs_sys_summ1.pos_lib.setText(sprintf("%2.1f", lib)); 
		p_dps_bfs_sys_summ1.pos_rib.setText(sprintf("%2.1f", rib)); 
		p_dps_bfs_sys_summ1.pos_rob.setText(sprintf("%2.1f", rob)); 

		p_dps_bfs_sys_summ1.mom_lob.setText(sprintf("%2.1f", elevon_norm(lob))); 
		p_dps_bfs_sys_summ1.mom_lib.setText(sprintf("%2.1f", elevon_norm(lib))); 
		p_dps_bfs_sys_summ1.mom_rib.setText(sprintf("%2.1f", elevon_norm(rib))); 
		p_dps_bfs_sys_summ1.mom_rob.setText(sprintf("%2.1f", elevon_norm(rob))); 

	    	p_dps_bfs_sys_summ1.pos_rud.setText(sprintf("%2.1f", 57.2974 * getprop("/fdm/jsbsim/fcs/rudder-pos-rad")));
	    	p_dps_bfs_sys_summ1.pos_ail.setText(sprintf("%2.1f", 57.2974 * getprop("/fdm/jsbsim/fcs/left-aileron-pos-rad"))); 

		p_dps_bfs_sys_summ1.pos_sb.setText(sprintf("%2.1f", 100.0 * getprop("/fdm/jsbsim/fcs/speedbrake-pos-norm")));

		p_dps_bfs_sys_summ1.pos_bf.setText(sprintf("%2.1f", 57.2974 * getprop("/fdm/jsbsim/fcs/bodyflap-pos-rad")));
		}
	else
		{
		p_dps_bfs_sys_summ1.pos_lob.setText(""); 
		p_dps_bfs_sys_summ1.pos_lib.setText(""); 
		p_dps_bfs_sys_summ1.pos_rib.setText(""); 
		p_dps_bfs_sys_summ1.pos_rob.setText(""); 

		p_dps_bfs_sys_summ1.mom_lob.setText(""); 
		p_dps_bfs_sys_summ1.mom_lib.setText(""); 
		p_dps_bfs_sys_summ1.mom_rib.setText(""); 
		p_dps_bfs_sys_summ1.mom_rob.setText(""); 

	    	p_dps_bfs_sys_summ1.pos_rud.setText("");
	    	p_dps_bfs_sys_summ1.pos_ail.setText("");
		p_dps_bfs_sys_summ1.pos_sb.setText("");
		p_dps_bfs_sys_summ1.pos_bf.setText("");

		}
	
    
	# MPS and Helium system are only processed in OPS 1 and 6



	if ((mm == 101) or (mm==102) or (mm == 103) or (mm == 104) or (mm == 601) or (mm == 602) or (mm == 603))
		{
		var mps_left_He_pressure = getprop("/fdm/jsbsim/systems/mps/helium/pressure-psia");
		var mps_right_He_pressure = getprop("/fdm/jsbsim/systems/mps/helium[1]/pressure-psia");
		var mps_center_He_pressure = getprop("/fdm/jsbsim/systems/mps/helium[2]/pressure-psia");
		var mps_pneu_He_pressure = getprop("/fdm/jsbsim/systems/mps/helium[3]/pressure-psia");

		p_dps_bfs_sys_summ1.he_tk_p_l.updateText(sprintf("%4.0f",mps_left_He_pressure));
		p_dps_bfs_sys_summ1.he_tk_p_c.updateText(sprintf("%4.0f",mps_center_He_pressure));
		p_dps_bfs_sys_summ1.he_tk_p_r.updateText(sprintf("%4.0f",mps_right_He_pressure));


		var reg_left_He_pressure = getprop("/fdm/jsbsim/systems/mps/helium/reg-pressure-psia");
		var reg_right_He_pressure = getprop("/fdm/jsbsim/systems/mps/helium[1]/reg-pressure-psia");
		var reg_center_He_pressure = getprop("/fdm/jsbsim/systems/mps/helium[2]/reg-pressure-psia");
		var reg_pneu_He_pressure = getprop("/fdm/jsbsim/systems/mps/helium[3]/reg-pressure-psia");

	    	p_dps_bfs_sys_summ1.reg_p_a_l.updateText(sprintf("%4.0f",reg_left_He_pressure));
	    	p_dps_bfs_sys_summ1.reg_p_a_c.updateText(sprintf("%4.0f",reg_center_He_pressure));
	    	p_dps_bfs_sys_summ1.reg_p_a_r.updateText(sprintf("%4.0f",reg_right_He_pressure));

	    	p_dps_bfs_sys_summ1.reg_p_b_l.updateText(sprintf("%4.0f",reg_left_He_pressure));
	    	p_dps_bfs_sys_summ1.reg_p_b_c.updateText(sprintf("%4.0f",reg_center_He_pressure));
	    	p_dps_bfs_sys_summ1.reg_p_b_r.updateText(sprintf("%4.0f",reg_right_He_pressure));

	    	p_dps_bfs_sys_summ1.pneu_tk.updateText(sprintf("%4.0f",mps_pneu_He_pressure));
	    	p_dps_bfs_sys_summ1.pneu_reg.updateText(sprintf("%4.0f",reg_pneu_He_pressure));
	    	p_dps_bfs_sys_summ1.pneu_acum.updateText(sprintf("%4.0f",reg_pneu_He_pressure - 20.0));

		var eng_l_status = getprop("/fdm/jsbsim/systems/mps/engine/engine-operational");
		var eng_r_status = getprop("/fdm/jsbsim/systems/mps/engine[1]/engine-operational");
		var eng_c_status = getprop("/fdm/jsbsim/systems/mps/engine[2]/engine-operational");

    		p_dps_bfs_sys_summ1.dpdt_l.updateText(sprintf("%3.0f", eng_l_status * 18.0));
    		p_dps_bfs_sys_summ1.dpdt_c.updateText(sprintf("%3.0f", eng_c_status * 18.0));
    		p_dps_bfs_sys_summ1.dpdt_r.updateText(sprintf("%3.0f", eng_r_status * 18.0));

		var prelaunch = getprop("/sim/config/shuttle/prelaunch-flag");

		if (prelaunch == 1)
			{
			eng_l_status = 1.0;
			eng_r_status = 1.0;
			eng_c_status = 1.0;
			}

		var ET_status = getprop("/controls/shuttle/ET-static-model");
		var lo2_ullage_p = 0.0;
		var lh2_ullage_p = 0.0;

		if (ET_status == 1)
			{
			lo2_ullage_p = 23.5;
			lh2_ullage_p = 32.8;
			}

		p_dps_bfs_sys_summ1.ull_lh2_l.updateText(sprintf("%2.2f", eng_l_status * (lh2_ullage_p + 0.1)));
		p_dps_bfs_sys_summ1.ull_lh2_c.updateText(sprintf("%2.2f", eng_c_status * (lh2_ullage_p - 0.2)));
		p_dps_bfs_sys_summ1.ull_lh2_r.updateText(sprintf("%2.2f", eng_r_status * (lh2_ullage_p + 0.3)));

		p_dps_bfs_sys_summ1.ull_lo2_l.updateText(sprintf("%2.2f", eng_l_status * (lo2_ullage_p - 0.2)));
		p_dps_bfs_sys_summ1.ull_lo2_c.updateText(sprintf("%2.2f", eng_c_status * (lo2_ullage_p - 0.3)));
		p_dps_bfs_sys_summ1.ull_lo2_r.updateText(sprintf("%2.2f", eng_r_status * (lo2_ullage_p + 0.1)));

		var eng_mnf_LO2 = getprop("/fdm/jsbsim/systems/mps/lo2-manifold-pressure-psia");
		var eng_mnf_LH2 = getprop("/fdm/jsbsim/systems/mps/lh2-manifold-pressure-psia");

    		p_dps_bfs_sys_summ1.manf_lh2.updateText(sprintf("%3.0f", eng_mnf_LH2));
    		p_dps_bfs_sys_summ1.manf_lo2.updateText(sprintf("%3.0f", eng_mnf_LO2));

    		p_dps_bfs_sys_summ1.gh2_l.updateText(sprintf("%4.0f", eng_l_status * 2435.0));
    		p_dps_bfs_sys_summ1.gh2_c.updateText(sprintf("%4.0f", eng_c_status * 2557.0));
    		p_dps_bfs_sys_summ1.gh2_r.updateText(sprintf("%4.0f", eng_r_status * 2381.0));

    		p_dps_bfs_sys_summ1.go2_l.updateText(sprintf("%4.0f", eng_l_status * 387.0));
    		p_dps_bfs_sys_summ1.go2_c.updateText(sprintf("%4.0f", eng_c_status * 393.0));
    		p_dps_bfs_sys_summ1.go2_r.updateText(sprintf("%4.0f", eng_r_status * 375.0));




		}
	else
		{
		p_dps_bfs_sys_summ1.he_tk_p_l.updateText("");
		p_dps_bfs_sys_summ1.he_tk_p_c.updateText("");
		p_dps_bfs_sys_summ1.he_tk_p_r.updateText("");

	    	p_dps_bfs_sys_summ1.reg_p_a_l.updateText("");
	    	p_dps_bfs_sys_summ1.reg_p_a_c.updateText("");
	    	p_dps_bfs_sys_summ1.reg_p_a_r.updateText("");

	    	p_dps_bfs_sys_summ1.reg_p_b_l.updateText("");
	    	p_dps_bfs_sys_summ1.reg_p_b_c.updateText("");
	    	p_dps_bfs_sys_summ1.reg_p_b_r.updateText("");

	    	p_dps_bfs_sys_summ1.pneu_tk.updateText("");
	    	p_dps_bfs_sys_summ1.pneu_reg.updateText("");
	    	p_dps_bfs_sys_summ1.pneu_acum.updateText("");

		p_dps_bfs_sys_summ1.ull_lh2_l.updateText("");
		p_dps_bfs_sys_summ1.ull_lh2_c.updateText("");
		p_dps_bfs_sys_summ1.ull_lh2_r.updateText("");

		p_dps_bfs_sys_summ1.ull_lo2_l.updateText("");
		p_dps_bfs_sys_summ1.ull_lo2_c.updateText("");
		p_dps_bfs_sys_summ1.ull_lo2_r.updateText("");

    		p_dps_bfs_sys_summ1.manf_lh2.updateText("");
    		p_dps_bfs_sys_summ1.manf_lo2.updateText("");

    		p_dps_bfs_sys_summ1.gh2_l.updateText("");
    		p_dps_bfs_sys_summ1.gh2_c.updateText("");
    		p_dps_bfs_sys_summ1.gh2_r.updateText("");

    		p_dps_bfs_sys_summ1.go2_l.updateText("");
    		p_dps_bfs_sys_summ1.go2_c.updateText("");
    		p_dps_bfs_sys_summ1.go2_r.updateText("");

    		p_dps_bfs_sys_summ1.dpdt_l.updateText("");
    		p_dps_bfs_sys_summ1.dpdt_c.updateText("");
    		p_dps_bfs_sys_summ1.dpdt_r.updateText("");
		}


	# TACAN, MLS and air data are only processed in final phases

	
	if ((mm == 304) or (mm == 305) or (mm == 602) or (mm == 603))
		{
		var string = SpaceShuttle.tacan_system.receiver[0].get_status_string();
		string = string~" "~SpaceShuttle.tacan_system.receiver[1].get_status_string();
		string = string~" "~SpaceShuttle.tacan_system.receiver[2].get_status_string();

		p_dps_bfs_sys_summ1.tac.updateText(string);

		string = SpaceShuttle.air_data_system.adta[0].status_string();
		string = string~" "~SpaceShuttle.air_data_system.adta[1].status_string();
		string = string~" "~SpaceShuttle.air_data_system.adta[2].status_string();
		string = string~" "~SpaceShuttle.air_data_system.adta[3].status_string();

		p_dps_bfs_sys_summ1.adta.updateText(string);

		}
	else
		{
		p_dps_bfs_sys_summ1.tac.updateText("");
		p_dps_bfs_sys_summ1.adta.updateText("");
		}

        device.update_common_DPS();
    }
    
    
    
    return p_dps_bfs_sys_summ1;
}
