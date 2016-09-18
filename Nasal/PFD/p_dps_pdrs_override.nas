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



    }
    
    p_dps_pdrs_override.update = func
    {

	# switch override enable

	var symbol = "";
	if (getprop("/fdm/jsbsim/systems/rms/software/joint-sw-override") == 1)
		{symbol = "*";}
	p_dps_pdrs_override.jnt_sw_ovrd.setText(symbol);

	symbol = "";
	if (getprop("/fdm/jsbsim/systems/rms/software/mode-sw-override") == 1)
		{symbol = "*";}
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





	


        device.update_common_DPS();
    }
    
    
    
    return p_dps_pdrs_override;
}
