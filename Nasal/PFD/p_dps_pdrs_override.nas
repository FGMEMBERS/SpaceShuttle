#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_pdrs_override
# Description: the payload handling hardware switch override page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_pdrs_override = func(device)
{
    var p_dps_pdrs_override = device.addPage("CRTPdrsOverride", "p_dps_pdrs_override");

    p_dps_pdrs_override.group = device.svg.getElementById("p_dps_pdrs_override");
    p_dps_pdrs_override.group.setColor(dps_r, dps_g, dps_b);
    

    p_dps_pdrs_override.sh_yaw_sel = device.svg.getElementById("p_dps_pdrs_override_sh_yaw_sel");
    p_dps_pdrs_override.sh_pitch_sel = device.svg.getElementById("p_dps_pdrs_override_sh_pitch_sel");
    p_dps_pdrs_override.el_pitch_sel = device.svg.getElementById("p_dps_pdrs_override_el_pitch_sel");
    p_dps_pdrs_override.wr_pitch_sel = device.svg.getElementById("p_dps_pdrs_override_wr_pitch_sel");
    p_dps_pdrs_override.wr_yaw_sel = device.svg.getElementById("p_dps_pdrs_override_wr_yaw_sel");
    p_dps_pdrs_override.wr_roll_sel = device.svg.getElementById("p_dps_pdrs_override_wr_roll_sel");

    p_dps_pdrs_override.mode_sw_ovrd = device.svg.getElementById("p_dps_pdrs_override_mode_sw_ovrd");
    p_dps_pdrs_override.jnt_sw_ovrd = device.svg.getElementById("p_dps_pdrs_override_jnt_sw_ovrd");
    p_dps_pdrs_override.auto_sw_ovrd = device.svg.getElementById("p_dps_pdrs_override_auto_sw_ovrd");
    p_dps_pdrs_override.rate_sw_ovrd = device.svg.getElementById("p_dps_pdrs_override_rate_sw_ovrd");

    p_dps_pdrs_override.saving_can = device.svg.getElementById("p_dps_pdrs_override_saving_can");
    p_dps_pdrs_override.abe_ovrd_a = device.svg.getElementById("p_dps_pdrs_override_abe_ovrd_a");
    p_dps_pdrs_override.abe_ovrd_b = device.svg.getElementById("p_dps_pdrs_override_abe_ovrd_b");
    p_dps_pdrs_override.abe_ovrd_c = device.svg.getElementById("p_dps_pdrs_override_abe_ovrd_c");

    p_dps_pdrs_override.vernier = device.svg.getElementById("p_dps_pdrs_override_vernier");
    p_dps_pdrs_override.coarse = device.svg.getElementById("p_dps_pdrs_override_coarse");

    p_dps_pdrs_override.orb_unl_sel = device.svg.getElementById("p_dps_pdrs_override_orb_unl_sel");
    p_dps_pdrs_override.orb_unl_ind = device.svg.getElementById("p_dps_pdrs_override_orb_unl_ind");

    p_dps_pdrs_override.orb_ld_sel = device.svg.getElementById("p_dps_pdrs_override_orb_ld_sel");
    p_dps_pdrs_override.orb_ld_ind = device.svg.getElementById("p_dps_pdrs_override_orb_ld_ind");

    p_dps_pdrs_override.single_sel = device.svg.getElementById("p_dps_pdrs_override_single_sel");
    p_dps_pdrs_override.single_ind = device.svg.getElementById("p_dps_pdrs_override_single_ind");

    p_dps_pdrs_override.end_eff_sel = device.svg.getElementById("p_dps_pdrs_override_end_eff_sel");
    p_dps_pdrs_override.end_eff_ind = device.svg.getElementById("p_dps_pdrs_override_end_eff_ind");

    p_dps_pdrs_override.pl_sel = device.svg.getElementById("p_dps_pdrs_override_pl_sel");
    p_dps_pdrs_override.pl_ind = device.svg.getElementById("p_dps_pdrs_override_pl_ind");

    p_dps_pdrs_override.opr_cmd_sel = device.svg.getElementById("p_dps_pdrs_override_opr_cmd_sel");
    p_dps_pdrs_override.opr_cmd_ind = device.svg.getElementById("p_dps_pdrs_override_opr_cmd_ind");

    p_dps_pdrs_override.auto1_sel = device.svg.getElementById("p_dps_pdrs_override_auto1_sel");
    p_dps_pdrs_override.auto1_ind = device.svg.getElementById("p_dps_pdrs_override_auto1_ind");

    p_dps_pdrs_override.auto2_sel = device.svg.getElementById("p_dps_pdrs_override_auto2_sel");
    p_dps_pdrs_override.auto2_ind = device.svg.getElementById("p_dps_pdrs_override_auto2_ind");

    p_dps_pdrs_override.auto3_sel = device.svg.getElementById("p_dps_pdrs_override_auto3_sel");
    p_dps_pdrs_override.auto3_ind = device.svg.getElementById("p_dps_pdrs_override_auto3_ind");

    p_dps_pdrs_override.auto4_sel = device.svg.getElementById("p_dps_pdrs_override_auto4_sel");
    p_dps_pdrs_override.auto4_ind = device.svg.getElementById("p_dps_pdrs_override_auto4_ind");

    p_dps_pdrs_override.test_sel = device.svg.getElementById("p_dps_pdrs_override_test_sel");

    p_dps_pdrs_override.thc = device.svg.getElementById("p_dps_pdrs_override_thc");
    p_dps_pdrs_override.rhc = device.svg.getElementById("p_dps_pdrs_override_rhc");
    p_dps_pdrs_override.hc_axis_ch = device.svg.getElementById("p_dps_pdrs_override_hc_axis_ch");

    p_dps_pdrs_override.loaded_rate = device.svg.getElementById("p_dps_pdrs_override_loaded_rate");
    p_dps_pdrs_override.stowed_ops = device.svg.getElementById("p_dps_pdrs_override_stowed_ops");
    p_dps_pdrs_override.reassign = device.svg.getElementById("p_dps_pdrs_override_reassign");

    p_dps_pdrs_override.ee_temp_sel = device.svg.getElementById("p_dps_pdrs_override_ee_temp_sel");
    p_dps_pdrs_override.crit_temp_sel = device.svg.getElementById("p_dps_pdrs_override_crti_temp_sel");


    p_dps_pdrs_override.ondisplay = func
    {
        device.DPS_menu_title.setText("PDRS OVERRIDE");
        device.MEDS_menu_title.setText("       DPS MENU");
    
	

        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-sm");
    
        var ops_string = major_mode~"1/095/";
        device.DPS_menu_ops.setText(ops_string);

	# default options not implemented yet

    	p_dps_pdrs_override.saving_can.setText("");
    	p_dps_pdrs_override.abe_ovrd_a.setText("");
    	p_dps_pdrs_override.abe_ovrd_b.setText("");
    	p_dps_pdrs_override.abe_ovrd_c.setText("");
    	p_dps_pdrs_override.thc.setText("");
    	p_dps_pdrs_override.rhc.setText("");
 	p_dps_pdrs_override.hc_axis_ch.setText("");
    	p_dps_pdrs_override.loaded_rate.setText("");
    	p_dps_pdrs_override.stowed_ops.setText("");
   	p_dps_pdrs_override.reassign.setText("");
	p_dps_pdrs_override.ee_temp_sel.setText("");
    	p_dps_pdrs_override.crit_temp_sel.setText("");



    }
    
    p_dps_pdrs_override.update = func
    {

	# switch override enable

	var symbol = "";
	if (getprop("/fdm/jsbsim/systems/rms/software/joint-sw-override") == 1)
		{symbol = "*";}
	p_dps_pdrs_override.jnt_sw_ovrd.setText(symbol);

	symbol = "";
	var mode_switch_override = getprop("/fdm/jsbsim/systems/rms/software/mode-sw-override");
	if (mode_switch_override == 1) {symbol = "*";}
	p_dps_pdrs_override.mode_sw_ovrd.setText(symbol);

	symbol = "";
	if (getprop("/fdm/jsbsim/systems/rms/software/auto-sw-override") == 1)
		{symbol = "*";}
	p_dps_pdrs_override.auto_sw_ovrd.setText(symbol);

	symbol = "";
	if (getprop("/fdm/jsbsim/systems/rms/software/rate-sw-override") == 1)
		{symbol = "*";}
	p_dps_pdrs_override.rate_sw_ovrd.setText(symbol);
    
	# joint selection override

        var joint_sel = getprop("/fdm/jsbsim/systems/rms/joint-selection-mode");

	p_dps_pdrs_override.sh_yaw_sel.setText("");
	p_dps_pdrs_override.sh_pitch_sel.setText("");
	p_dps_pdrs_override.el_pitch_sel.setText("");
	p_dps_pdrs_override.wr_yaw_sel.setText("");
	p_dps_pdrs_override.wr_pitch_sel.setText("");
	p_dps_pdrs_override.wr_roll_sel.setText("");

	if (joint_sel == 1) {p_dps_pdrs_override.sh_yaw_sel.setText("*");}
	else if (joint_sel == 2) {p_dps_pdrs_override.sh_pitch_sel.setText("*");}
	else if (joint_sel == 3) {p_dps_pdrs_override.el_pitch_sel.setText("*");}
	else if (joint_sel == 4) {p_dps_pdrs_override.wr_pitch_sel.setText("*");}
	else if (joint_sel == 5) {p_dps_pdrs_override.wr_yaw_sel.setText("*");}
	else if (joint_sel == 6) {p_dps_pdrs_override.wr_roll_sel.setText("*");}


	# rate switch override

	if (getprop("/fdm/jsbsim/systems/rms/vernier-switch") == 0)
		{
 		p_dps_pdrs_override.vernier.setText("");
    		p_dps_pdrs_override.coarse.setText("*");
		}
	else
		{
 		p_dps_pdrs_override.vernier.setText("*");
    		p_dps_pdrs_override.coarse.setText("");
		}


	# drive mode overrides

	p_dps_pdrs_override.orb_unl_sel.setText("");
    	p_dps_pdrs_override.orb_unl_ind.setText("");

    	p_dps_pdrs_override.single_sel.setText("");
    	p_dps_pdrs_override.single_ind.setText("");

    	p_dps_pdrs_override.end_eff_sel.setText("");
    	p_dps_pdrs_override.end_eff_ind.setText("");

    	p_dps_pdrs_override.pl_sel.setText("");
    	p_dps_pdrs_override.pl_ind.setText("");
		
    	p_dps_pdrs_override.opr_cmd_sel.setText("");
    	p_dps_pdrs_override.opr_cmd_ind.setText("");

    	p_dps_pdrs_override.auto1_sel.setText("");
    	p_dps_pdrs_override.auto1_ind.setText("");

    	p_dps_pdrs_override.auto2_sel.setText("");
    	p_dps_pdrs_override.auto2_ind.setText("");

    	p_dps_pdrs_override.auto3_sel.setText("");
    	p_dps_pdrs_override.auto3_ind.setText("");

    	p_dps_pdrs_override.auto4_sel.setText("");
    	p_dps_pdrs_override.auto4_ind.setText("");

    	p_dps_pdrs_override.orb_ld_sel.setText("");
    	p_dps_pdrs_override.orb_ld_ind.setText("");

    	p_dps_pdrs_override.test_sel.setText("");

	var current_mode = getprop("/fdm/jsbsim/systems/rms/drive-selection-mode"); 
	var selected_mode = 0;

	if ((current_mode == 4) or (current_mode == 5)) # we need to look up the string
		{
		var drive_string = getprop("/fdm/jsbsim/systems/rms/drive-selection-string");

		if (drive_string == "AUTO OPR CMD") {current_mode = 4;}
		else if (drive_string == "AUTO 1") {current_mode = 5;}
		else if (drive_string == "AUTO 2") {current_mode = 6;}
		else if (drive_string == "AUTO 3") {current_mode = 7;}
		else if (drive_string == "AUTO 4") {current_mode = 8;}
		}


	if (mode_switch_override == 0)
		{selected_mode = current_mode;}
	else
		{
		selected_mode = getprop("/fdm/jsbsim/systems/rms/software/sw-drive-mode-select");
		if (selected_mode == 0) {selected_mode = 1;}
		}



	if (current_mode == 1)
		{p_dps_pdrs_override.single_ind.setText("*");}
	else if ((current_mode == 2) or (current_mode == 3))
		{p_dps_pdrs_override.orb_unl_ind.setText("*");}
	else if (current_mode == 4)
		{p_dps_pdrs_override.opr_cmd_ind.setText("*");}
	else if (current_mode == 5)
		{p_dps_pdrs_override.auto1_ind.setText("*");}
	else if (current_mode == 6)
		{p_dps_pdrs_override.auto1_ind.setText("*");}
	else if (current_mode == 7)
		{p_dps_pdrs_override.auto1_ind.setText("*");}
	else if (current_mode == 8)
		{p_dps_pdrs_override.auto1_ind.setText("*");}

	if (selected_mode == 1)
		{p_dps_pdrs_override.single_sel.setText("*");}
	else if ((selected_mode == 2) or (selected_mode == 3))
		{p_dps_pdrs_override.orb_unl_sel.setText("*");}
	else if (selected_mode == 4)
		{p_dps_pdrs_override.opr_cmd_sel.setText("*");}
	else if (selected_mode == 5)
		{p_dps_pdrs_override.auto1_sel.setText("*");}
	else if (selected_mode == 6)
		{p_dps_pdrs_override.auto1_sel.setText("*");}
	else if (selected_mode == 7)
		{p_dps_pdrs_override.auto1_sel.setText("*");}
	else if (selected_mode == 8)
		{p_dps_pdrs_override.auto1_sel.setText("*");}


        device.update_common_DPS();
    }
    
    
    
    return p_dps_pdrs_override;
}
