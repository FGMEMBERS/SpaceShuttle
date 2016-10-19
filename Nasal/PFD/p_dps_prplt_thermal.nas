#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_prplt_thermal
# Description: the SM propellant/thermal display page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_prplt_thermal = func(device)
{
    var p_dps_prplt_thermal = device.addPage("CRTPrpltThermal", "p_dps_prplt_thermal");

    p_dps_prplt_thermal.group = device.svg.getElementById("p_dps_prplt_thermal");
    p_dps_prplt_thermal.group.setColor(dps_r, dps_g, dps_b);
    

    p_dps_prplt_thermal.oms_tk_l_ox = device.svg.getElementById("p_dps_prplt_thermal_oms_tk_l_ox");
    p_dps_prplt_thermal.oms_tk_r_ox = device.svg.getElementById("p_dps_prplt_thermal_oms_tk_r_ox");    

    p_dps_prplt_thermal.oms_tk_l_fu = device.svg.getElementById("p_dps_prplt_thermal_oms_tk_l_fu");
    p_dps_prplt_thermal.oms_tk_r_fu = device.svg.getElementById("p_dps_prplt_thermal_oms_tk_r_fu"); 

    p_dps_prplt_thermal.eng_if_l_ox = device.svg.getElementById("p_dps_prplt_thermal_eng_if_l_ox");
    p_dps_prplt_thermal.eng_if_r_ox = device.svg.getElementById("p_dps_prplt_thermal_eng_if_r_ox");

    p_dps_prplt_thermal.eng_if_l_fu = device.svg.getElementById("p_dps_prplt_thermal_eng_if_l_fu");
    p_dps_prplt_thermal.eng_if_r_fu = device.svg.getElementById("p_dps_prplt_thermal_eng_if_r_fu");

    p_dps_prplt_thermal.ox_vlv_l = device.svg.getElementById("p_dps_prplt_thermal_ox_vlv_l");
    p_dps_prplt_thermal.ox_vlv_r = device.svg.getElementById("p_dps_prplt_thermal_ox_vlv_r");

    p_dps_prplt_thermal.web_keel1_l = device.svg.getElementById("p_dps_prplt_thermal_web_keel1_l");
    p_dps_prplt_thermal.web_keel1_r = device.svg.getElementById("p_dps_prplt_thermal_web_keel1_r");
    p_dps_prplt_thermal.web_keel2_l = device.svg.getElementById("p_dps_prplt_thermal_web_keel2_l");
    p_dps_prplt_thermal.web_keel2_r = device.svg.getElementById("p_dps_prplt_thermal_web_keel2_r");

    p_dps_prplt_thermal.y_ob_l = device.svg.getElementById("p_dps_prplt_thermal_y_ob_l");
    p_dps_prplt_thermal.y_ob_r = device.svg.getElementById("p_dps_prplt_thermal_y_ob_r");

    p_dps_prplt_thermal.y_up_l = device.svg.getElementById("p_dps_prplt_thermal_y_up_l");
    p_dps_prplt_thermal.y_up_r = device.svg.getElementById("p_dps_prplt_thermal_y_up_r");

    p_dps_prplt_thermal.fu_inj_l = device.svg.getElementById("p_dps_prplt_thermal_fu_inj_l");
    p_dps_prplt_thermal.fu_inj_r = device.svg.getElementById("p_dps_prplt_thermal_fu_inj_r");

    p_dps_prplt_thermal.ox_drn_pnl1_l = device.svg.getElementById("p_dps_prplt_thermal_ox_drn_pnl1_l");
    p_dps_prplt_thermal.ox_drn_pnl1_r = device.svg.getElementById("p_dps_prplt_thermal_ox_drn_pnl1_r");

    p_dps_prplt_thermal.ox_drn_pnl2_l = device.svg.getElementById("p_dps_prplt_thermal_ox_drn_pnl2_l");
    p_dps_prplt_thermal.ox_drn_pnl2_r = device.svg.getElementById("p_dps_prplt_thermal_ox_drn_pnl2_r");

    p_dps_prplt_thermal.eng_cover_l = device.svg.getElementById("p_dps_prplt_thermal_eng_cover_l");
    p_dps_prplt_thermal.eng_cover_r = device.svg.getElementById("p_dps_prplt_thermal_eng_cover_r");

    p_dps_prplt_thermal.serv_pnl_l = device.svg.getElementById("p_dps_prplt_thermal_serv_pnl_l");
    p_dps_prplt_thermal.serv_pnl_r = device.svg.getElementById("p_dps_prplt_thermal_serv_pnl_r");

    p_dps_prplt_thermal.gse_serv_pnl_l = device.svg.getElementById("p_dps_prplt_thermal_gse_serv_pnl_l");
    p_dps_prplt_thermal.gse_serv_pnl_r = device.svg.getElementById("p_dps_prplt_thermal_gse_serv_pnl_r");

    p_dps_prplt_thermal.test_he_ox1_l = device.svg.getElementById("p_dps_prplt_thermal_test_he_ox1_l");
    p_dps_prplt_thermal.test_he_ox1_r = device.svg.getElementById("p_dps_prplt_thermal_test_he_ox1_r");

    p_dps_prplt_thermal.test_he_ox2_l = device.svg.getElementById("p_dps_prplt_thermal_test_he_ox2_l");
    p_dps_prplt_thermal.test_he_ox2_r = device.svg.getElementById("p_dps_prplt_thermal_test_he_ox2_r");


    p_dps_prplt_thermal.ondisplay = func
    {
        device.DPS_menu_title.setText("PRPLT THERMAL");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
	var spec = SpaceShuttle.idp_array[device.port_selected-1].get_spec();    
	var spec_string = assemble_spec_string(spec);
    
        var ops_string = major_mode~"1/"~spec_string~"/089";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_prplt_thermal.update = func
    {
    

	# OMS thermal control

	var T_left = K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/left-pod-temperature-K"));
       	var T_right = K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/right-pod-temperature-K"));
    
	var heater_OMS_left_A = getprop("/fdm/jsbsim/systems/oms-hardware/heater-left-A-status");
	var heater_OMS_left_B = getprop("/fdm/jsbsim/systems/oms-hardware/heater-left-B-status");
	var heater_OMS_left = heater_OMS_left_A + heater_OMS_left_B;
	if (heater_OMS_left == 2) {heater_OMS_left = 1;}

	var heater_OMS_right_A = getprop("/fdm/jsbsim/systems/oms-hardware/heater-right-A-status");
	var heater_OMS_right_B = getprop("/fdm/jsbsim/systems/oms-hardware/heater-right-B-status");
	var heater_OMS_right = heater_OMS_right_A + heater_OMS_right_B;
	if (heater_OMS_right == 2) {heater_OMS_right = 1;}

	if ((T_left < 57.0) and (heater_OMS_left == 1)) {T_left = 65.0;}
	if ((T_right < 57.0) and (heater_OMS_right == 1)) {T_right = 65.0;}

        var oms_Pc_left = getprop("/fdm/jsbsim/fcs/throttle-pos-norm[5]");
        var oms_Pc_right = getprop("/fdm/jsbsim/fcs/throttle-pos-norm[6]");

	var T_inj_left = T_left;
	var T_inj_right = T_right;

	if (oms_Pc_left > 0.0)
		{
		T_inj_left = 210.0 + 8.0 * oms_Pc_left;
		}
	if (oms_Pc_right > 0.0)
		{
		T_inj_right = 211.0 + 9.0 * oms_Pc_right;
		}

	p_dps_prplt_thermal.oms_tk_l_ox.setText(sprintf("%d", int(T_left)+1));
    	p_dps_prplt_thermal.oms_tk_r_ox.setText(sprintf("%d", int(T_right)));

    	p_dps_prplt_thermal.oms_tk_l_fu.setText(sprintf("%d", int(T_left)-1));
    	p_dps_prplt_thermal.oms_tk_r_fu.setText(sprintf("%d", int(T_right)-1));

    	p_dps_prplt_thermal.eng_if_l_ox.setText(sprintf("%d", int(T_left)-1));
    	p_dps_prplt_thermal.eng_if_r_ox.setText(sprintf("%d", int(T_right)));

    	p_dps_prplt_thermal.eng_if_l_fu.setText(sprintf("%d", int(T_left)));
    	p_dps_prplt_thermal.eng_if_r_fu.setText(sprintf("%d", int(T_right)));

    	p_dps_prplt_thermal.ox_vlv_l.setText(sprintf("%d", int(T_left)));
    	p_dps_prplt_thermal.ox_vlv_r.setText(sprintf("%d", int(T_right)+1));

    	p_dps_prplt_thermal.web_keel1_l.setText(sprintf("%d", int(T_left)-1));
    	p_dps_prplt_thermal.web_keel1_r.setText(sprintf("%d", int(T_right)));
    	p_dps_prplt_thermal.web_keel2_l.setText(sprintf("%d", int(T_left))); 
    	p_dps_prplt_thermal.web_keel2_r.setText(sprintf("%d", int(T_right)+1));

    	p_dps_prplt_thermal.y_ob_l.setText(sprintf("%d", int(T_left)));
    	p_dps_prplt_thermal.y_ob_r.setText(sprintf("%d", int(T_right)-1));

    	p_dps_prplt_thermal.y_up_l.setText(sprintf("%d", int(T_left)+1));
    	p_dps_prplt_thermal.y_up_r.setText(sprintf("%d", int(T_right)-1));

    	p_dps_prplt_thermal.fu_inj_l.setText(sprintf("%d", int(T_inj_left)));
    	p_dps_prplt_thermal.fu_inj_r.setText(sprintf("%d", int(T_inj_right)));

   	p_dps_prplt_thermal.ox_drn_pnl1_l.setText(sprintf("%d", int(T_left)-4));
    	p_dps_prplt_thermal.ox_drn_pnl1_r.setText(sprintf("%d", int(T_right)-3));

   	p_dps_prplt_thermal.ox_drn_pnl2_l.setText(sprintf("%d", int(T_left)-3));
    	p_dps_prplt_thermal.ox_drn_pnl2_r.setText(sprintf("%d", int(T_right)-4));

    	p_dps_prplt_thermal.eng_cover_l.setText(sprintf("%d", int(T_left)-2));
    	p_dps_prplt_thermal.eng_cover_r.setText(sprintf("%d", int(T_right)-2));

    	p_dps_prplt_thermal.serv_pnl_l.setText(sprintf("%d", int(T_left)-5));
    	p_dps_prplt_thermal.serv_pnl_r.setText(sprintf("%d", int(T_right)-6));

    	p_dps_prplt_thermal.gse_serv_pnl_l.setText(sprintf("%d", int(T_left)-5));
    	p_dps_prplt_thermal.gse_serv_pnl_r.setText(sprintf("%d", int(T_right)-6));

    	p_dps_prplt_thermal.test_he_ox1_l.setText(sprintf("%d", int(T_left)-6));
    	p_dps_prplt_thermal.test_he_ox1_r.setText(sprintf("%d", int(T_right)-7));

    	p_dps_prplt_thermal.test_he_ox2_l.setText(sprintf("%d", int(T_left)-5));
    	p_dps_prplt_thermal.test_he_ox2_r.setText(sprintf("%d", int(T_right)-6));

        device.update_common_DPS();
    }
    
    
    
    return p_dps_prplt_thermal;
}
