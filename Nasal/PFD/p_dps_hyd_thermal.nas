#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_hyd_thermal
# Description: the hydraulics/thermal environment page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_hyd_thermal = func(device)
{
    var p_dps_hyd_thermal = device.addPage("CRTHydThermal", "p_dps_hyd_thermal");

    p_dps_hyd_thermal.group = device.svg.getElementById("p_dps_hyd_thermal");
    p_dps_hyd_thermal.group.setColor(dps_r, dps_g, dps_b);
    
    p_dps_hyd_thermal.mg_ib_left1 = device.svg.getElementById("p_dps_hyd_thermal_mg_ib_left1");
    p_dps_hyd_thermal.mg_ib_left2 = device.svg.getElementById("p_dps_hyd_thermal_mg_ib_left2");
    p_dps_hyd_thermal.mg_ib_right1 = device.svg.getElementById("p_dps_hyd_thermal_mg_ib_right1");
    p_dps_hyd_thermal.mg_ib_right2 = device.svg.getElementById("p_dps_hyd_thermal_mg_ib_right2");    

    p_dps_hyd_thermal.mg_ob_left1 = device.svg.getElementById("p_dps_hyd_thermal_mg_ob_left1");
    p_dps_hyd_thermal.mg_ob_left2 = device.svg.getElementById("p_dps_hyd_thermal_mg_ob_left2");
    p_dps_hyd_thermal.mg_ob_right1 = device.svg.getElementById("p_dps_hyd_thermal_mg_ob_right1");
    p_dps_hyd_thermal.mg_ob_right2 = device.svg.getElementById("p_dps_hyd_thermal_mg_ob_right2"); 

    p_dps_hyd_thermal.ng_left1 = device.svg.getElementById("p_dps_hyd_thermal_ng_left1");
    p_dps_hyd_thermal.ng_left2 = device.svg.getElementById("p_dps_hyd_thermal_ng_left2");
    p_dps_hyd_thermal.ng_right1 = device.svg.getElementById("p_dps_hyd_thermal_ng_right1");
    p_dps_hyd_thermal.ng_right2 = device.svg.getElementById("p_dps_hyd_thermal_ng_right2");

    p_dps_hyd_thermal.accum_p1 = device.svg.getElementById("p_dps_hyd_thermal_accum_p1");
    p_dps_hyd_thermal.accum_p2 = device.svg.getElementById("p_dps_hyd_thermal_accum_p2");
    p_dps_hyd_thermal.accum_p3 = device.svg.getElementById("p_dps_hyd_thermal_accum_p3");

    p_dps_hyd_thermal.cpump_p1 = device.svg.getElementById("p_dps_hyd_thermal_cpump_p1");
    p_dps_hyd_thermal.cpump_p2 = device.svg.getElementById("p_dps_hyd_thermal_cpump_p2");
    p_dps_hyd_thermal.cpump_p3 = device.svg.getElementById("p_dps_hyd_thermal_cpump_p3");

    p_dps_hyd_thermal.bdyflp_pdu1 = device.svg.getElementById("p_dps_hyd_thermal_bdyflp_pdu1");
    p_dps_hyd_thermal.bdyflp_pdu2 = device.svg.getElementById("p_dps_hyd_thermal_bdyflp_pdu2");
    p_dps_hyd_thermal.bdyflp_pdu3 = device.svg.getElementById("p_dps_hyd_thermal_bdyflp_pdu3");
    p_dps_hyd_thermal._bdyflp_fus1 = device.svg.getElementById("p_dps_hyd_thermal_bdyflp_fus1");
    p_dps_hyd_thermal._bdyflp_fus2 = device.svg.getElementById("p_dps_hyd_thermal_bdyflp_fus2");
    p_dps_hyd_thermal._bdyflp_fus3 = device.svg.getElementById("p_dps_hyd_thermal_bdyflp_fus3");

    p_dps_hyd_thermal.rdsb_pdu1 = device.svg.getElementById("p_dps_hyd_thermal_rdsb_pdu1");
    p_dps_hyd_thermal.rdsb_pdu2 = device.svg.getElementById("p_dps_hyd_thermal_rdsb_pdu2");
    p_dps_hyd_thermal.rdsb_pdu3 = device.svg.getElementById("p_dps_hyd_thermal_rdsb_pdu3");
    p_dps_hyd_thermal.rdsb_fus1 = device.svg.getElementById("p_dps_hyd_thermal_rdsb_fus1");
    p_dps_hyd_thermal.rdsb_fus2 = device.svg.getElementById("p_dps_hyd_thermal_rdsb_fus2");
    p_dps_hyd_thermal.rdsb_fus3 = device.svg.getElementById("p_dps_hyd_thermal_rdsb_fus3");

    p_dps_hyd_thermal.elv_lob1 = device.svg.getElementById("p_dps_hyd_thermal_elv_lob1");
    p_dps_hyd_thermal.elv_lob2 = device.svg.getElementById("p_dps_hyd_thermal_elv_lob2");
    p_dps_hyd_thermal.elv_lob3 = device.svg.getElementById("p_dps_hyd_thermal_elv_lob3");
    p_dps_hyd_thermal.elv_lib1 = device.svg.getElementById("p_dps_hyd_thermal_elv_lib1");
    p_dps_hyd_thermal.elv_lib2 = device.svg.getElementById("p_dps_hyd_thermal_elv_lib2");
    p_dps_hyd_thermal.elv_lib3 = device.svg.getElementById("p_dps_hyd_thermal_elv_lib3");

    p_dps_hyd_thermal.elv_rob1 = device.svg.getElementById("p_dps_hyd_thermal_elv_rob1");
    p_dps_hyd_thermal.elv_rob2 = device.svg.getElementById("p_dps_hyd_thermal_elv_rob2");
    p_dps_hyd_thermal.elv_rob3 = device.svg.getElementById("p_dps_hyd_thermal_elv_rob3");
    p_dps_hyd_thermal.elv_rib1 = device.svg.getElementById("p_dps_hyd_thermal_elv_rib1");
    p_dps_hyd_thermal.elv_rib2 = device.svg.getElementById("p_dps_hyd_thermal_elv_rib2");
    p_dps_hyd_thermal.elv_rib3 = device.svg.getElementById("p_dps_hyd_thermal_elv_rib3");

    p_dps_hyd_thermal.lbw2 = device.svg.getElementById("p_dps_hyd_thermal_lbw2");
    p_dps_hyd_thermal.lbw3 = device.svg.getElementById("p_dps_hyd_thermal_lbw3");
    p_dps_hyd_thermal.lbf2 = device.svg.getElementById("p_dps_hyd_thermal_lbf2");
    p_dps_hyd_thermal.lbf3 = device.svg.getElementById("p_dps_hyd_thermal_lbf3");

    p_dps_hyd_thermal.rbw1 = device.svg.getElementById("p_dps_hyd_thermal_rbw1");
    p_dps_hyd_thermal.rbw2 = device.svg.getElementById("p_dps_hyd_thermal_rbw2");
    p_dps_hyd_thermal.rbw3 = device.svg.getElementById("p_dps_hyd_thermal_rbw3");
    p_dps_hyd_thermal.rbf1 = device.svg.getElementById("p_dps_hyd_thermal_rbf1");
    p_dps_hyd_thermal.rbf2 = device.svg.getElementById("p_dps_hyd_thermal_rbf2");
    p_dps_hyd_thermal.rbf3 = device.svg.getElementById("p_dps_hyd_thermal_rbf3");

    p_dps_hyd_thermal.ng_uplk = device.svg.getElementById("p_dps_hyd_thermal_ng_uplk");
    p_dps_hyd_thermal.mfus1 = device.svg.getElementById("p_dps_hyd_thermal_mfus1");
    p_dps_hyd_thermal.mfus2 = device.svg.getElementById("p_dps_hyd_thermal_mfus2");

    p_dps_hyd_thermal.mg_l_uplk = device.svg.getElementById("p_dps_hyd_thermal_mg_l_uplk");
    p_dps_hyd_thermal.mg_r_uplk = device.svg.getElementById("p_dps_hyd_thermal_mg_r_uplk");
    p_dps_hyd_thermal.mg_r_fus = device.svg.getElementById("p_dps_hyd_thermal_mg_r_fus");


    p_dps_hyd_thermal.ondisplay = func
    {
        device.DPS_menu_title.setText("HYD THERMAL");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
	var spec = SpaceShuttle.idp_array[device.port_selected-1].get_spec();    
	var spec_string = assemble_spec_string(spec);
    
        var ops_string = major_mode~"1/"~spec_string~"/087";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_hyd_thermal.update = func
    {

	# hydraulic accumulator pressure

	var p1 = getprop("/fdm/jsbsim/systems/apu/apu/hyd-pressure-psia");
	var p2 = getprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-pressure-psia");
	var p3 = getprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-pressure-psia");

    	p_dps_hyd_thermal.accum_p1.setText(sprintf("%d", int(p1)));
    	p_dps_hyd_thermal.accum_p2.setText(sprintf("%d", int(p2)));
    	p_dps_hyd_thermal.accum_p3.setText(sprintf("%d", int(p3)));

	# hydraulic pump pressure 

	var pump1 = getprop("/fdm/jsbsim/systems/apu/apu/hyd-circ-pump");
	var pump_p1 = 64.0 + pump1 * 290.0;

	var pump2 = getprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-circ-pump");
	var pump_p2 = 68.0 + pump2 * 294.0;

	var pump3 = getprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-circ-pump");
	var pump_p3 = 62.0 + pump3 * 287.0;

	p_dps_hyd_thermal.cpump_p1.setText(sprintf("%d", int(pump_p1))); 
    	p_dps_hyd_thermal.cpump_p2.setText(sprintf("%d", int(pump_p2))); 
    	p_dps_hyd_thermal.cpump_p3.setText(sprintf("%d", int(pump_p3))); 
	
	# temperatures

	var T_nose = getprop("/fdm/jsbsim/systems/thermal-distribution/nose-temperature-K");
	var T_left = getprop("/fdm/jsbsim/systems/thermal-distribution/left-temperature-K");
	var T_right = getprop("/fdm/jsbsim/systems/thermal-distribution/right-temperature-K");
	var T_low = getprop("/fdm/jsbsim/systems/thermal-distribution/tps-temperature-K");
	var T_aft = getprop("/fdm/jsbsim/systems/thermal-distribution/aft-temperature-K");

	var T_av = (T_nose + T_left + T_right + T_low + T_aft)/5.0;
	var T_lwing = (T_left + T_low)/2.0;
	var T_rwing = (T_right + T_low)/2.0;

	var mix1 = getprop("/fdm/jsbsim/systems/apu/apu/temp-equalization-factor");
	var mix2 = getprop("/fdm/jsbsim/systems/apu/apu[1]/temp-equalization-factor");
	var mix3 = getprop("/fdm/jsbsim/systems/apu/apu[2]/temp-equalization-factor");



    	p_dps_hyd_thermal.bdyflp_pdu1.setText(sprintf("%+d", mix_T_to_F(T_av, T_aft, mix1)+1));
    	p_dps_hyd_thermal.bdyflp_pdu2.setText(sprintf("%+d", mix_T_to_F(T_av, T_aft, mix2)-2));
    	p_dps_hyd_thermal.bdyflp_pdu3.setText(sprintf("%+d", mix_T_to_F(T_av, T_aft, mix3)));

    	p_dps_hyd_thermal._bdyflp_fus1.setText(sprintf("%+d", mix_T_to_F(T_av, T_aft, mix1)-3)); 
    	p_dps_hyd_thermal._bdyflp_fus2.setText(sprintf("%+d", mix_T_to_F(T_av, T_aft, mix2)));
    	p_dps_hyd_thermal._bdyflp_fus3.setText(sprintf("%+d", mix_T_to_F(T_av, T_aft, mix3)+1));

    	p_dps_hyd_thermal.rdsb_pdu1.setText(sprintf("%+d", mix_T_to_F(T_av, T_aft, mix1)+2));
    	p_dps_hyd_thermal.rdsb_pdu2.setText(sprintf("%+d", mix_T_to_F(T_av, T_aft, mix2)+1)); 
    	p_dps_hyd_thermal.rdsb_pdu3.setText(sprintf("%+d", mix_T_to_F(T_av, T_aft, mix3)-1));
    
	p_dps_hyd_thermal.rdsb_fus1.setText(sprintf("%+d", mix_T_to_F(T_av, T_aft, mix1)-1));
    	p_dps_hyd_thermal.rdsb_fus2.setText(sprintf("%+d", mix_T_to_F(T_av, T_aft, mix2))); 
    	p_dps_hyd_thermal.rdsb_fus3.setText(sprintf("%+d", mix_T_to_F(T_av, T_aft, mix3)-2));

    	p_dps_hyd_thermal.elv_lob1.setText(sprintf("%+d", mix_T_to_F(T_av, T_lwing, mix1)-1)); 
    	p_dps_hyd_thermal.elv_lob2.setText(sprintf("%+d", mix_T_to_F(T_av, T_lwing, mix2))); 
    	p_dps_hyd_thermal.elv_lob3.setText(sprintf("%+d", mix_T_to_F(T_av, T_lwing, mix3)-1));  
    
	p_dps_hyd_thermal.elv_lib1.setText(sprintf("%+d", mix_T_to_F(T_av, T_lwing, mix1)+3));  
    	p_dps_hyd_thermal.elv_lib2.setText(sprintf("%+d", mix_T_to_F(T_av, T_lwing, mix2)+1)); 
    	p_dps_hyd_thermal.elv_lib3.setText(sprintf("%+d", mix_T_to_F(T_av, T_lwing, mix3)-1));  

    	p_dps_hyd_thermal.elv_rob1.setText(sprintf("%+d", mix_T_to_F(T_av, T_rwing, mix1))); 
    	p_dps_hyd_thermal.elv_rob2.setText(sprintf("%+d", mix_T_to_F(T_av, T_rwing, mix2)+2)); 
    	p_dps_hyd_thermal.elv_rob3.setText(sprintf("%+d", mix_T_to_F(T_av, T_rwing, mix3))); 
    
	p_dps_hyd_thermal.elv_rib1.setText(sprintf("%+d", mix_T_to_F(T_av, T_rwing, mix1)+1));  
    	p_dps_hyd_thermal.elv_rib2.setText(sprintf("%+d", mix_T_to_F(T_av, T_rwing, mix2)+3)); 
    	p_dps_hyd_thermal.elv_rib3.setText(sprintf("%+d", mix_T_to_F(T_av, T_rwing, mix3)+1));  

    	p_dps_hyd_thermal.lbw2.setText(sprintf("%+d", mix_T_to_F(T_av, T_low, mix2)+3)); 
    	p_dps_hyd_thermal.lbw3.setText(sprintf("%+d", mix_T_to_F(T_av, T_low, mix3)+2)); 
    	p_dps_hyd_thermal.lbf2.setText(sprintf("%+d", mix_T_to_F(T_av, T_low, mix2)-1)); 
    	p_dps_hyd_thermal.lbf3.setText(sprintf("%+d", mix_T_to_F(T_av, T_low, mix3)-1));  

    	p_dps_hyd_thermal.rbw1.setText(sprintf("%+d", mix_T_to_F(T_av, T_low, mix1)+3));  
    	p_dps_hyd_thermal.rbw2.setText(sprintf("%+d", mix_T_to_F(T_av, T_low, mix2)));  
    	p_dps_hyd_thermal.rbw3.setText(sprintf("%+d", mix_T_to_F(T_av, T_low, mix3)));   
    
	p_dps_hyd_thermal.rbf1.setText(sprintf("%+d", mix_T_to_F(T_av, T_low, mix1)-3));   
    	p_dps_hyd_thermal.rbf2.setText(sprintf("%+d", mix_T_to_F(T_av, T_low, mix2)+2));   
    	p_dps_hyd_thermal.rbf3.setText(sprintf("%+d", mix_T_to_F(T_av, T_low, mix3)+2));  

   	p_dps_hyd_thermal.ng_uplk.setText(sprintf("%+d", mix_T_to_F(T_av, T_low, mix1))); 
    	p_dps_hyd_thermal.mfus1.setText(sprintf("%+d", mix_T_to_F(T_av, T_low, mix1)-1)); 
    	p_dps_hyd_thermal.mfus2.setText(sprintf("%+d", mix_T_to_F(T_av, T_low, mix1))); 

    	p_dps_hyd_thermal.mg_l_uplk.setText(sprintf("%+d", mix_T_to_F(T_av, T_low, mix1)+1)); 
    	p_dps_hyd_thermal.mg_r_uplk.setText(sprintf("%+d", mix_T_to_F(T_av, T_low, mix1))); 
    	p_dps_hyd_thermal.mg_r_fus.setText(sprintf("%+d", mix_T_to_F(T_av, T_low, mix1)+1)); 

	# tire pressures

	var tire_nose_condition = getprop("/fdm/jsbsim/systems/failures/tire-nose-condition");
	var tire_left_condition = getprop("/fdm/jsbsim/systems/failures/tire-left-condition");
	var tire_right_condition = getprop("/fdm/jsbsim/systems/failures/tire-right-condition");

    	p_dps_hyd_thermal.mg_ib_right1.setText(sprintf("%d", int(tire_right_condition * 378.0)));
    	p_dps_hyd_thermal.mg_ib_right2.setText(sprintf("%d", int(tire_right_condition * 378.0)));
    	p_dps_hyd_thermal.mg_ob_right1.setText(sprintf("%d", int(tire_right_condition * 376.0)));
    	p_dps_hyd_thermal.mg_ob_right2.setText(sprintf("%d", int(tire_right_condition * 376.0)));

    	p_dps_hyd_thermal.mg_ib_left1.setText(sprintf("%d", int(tire_left_condition * 377.0)));
    	p_dps_hyd_thermal.mg_ib_left2.setText(sprintf("%d", int(tire_left_condition * 377.0)));
    	p_dps_hyd_thermal.mg_ob_left1.setText(sprintf("%d", int(tire_left_condition * 374.0)));
    	p_dps_hyd_thermal.mg_ob_left2.setText(sprintf("%d", int(tire_left_condition * 374.0)));

    	p_dps_hyd_thermal.ng_left1.setText(sprintf("%d", int(tire_nose_condition * 368.0)));
    	p_dps_hyd_thermal.ng_left2.setText(sprintf("%d", int(tire_nose_condition * 368.0)));
    	p_dps_hyd_thermal.ng_right1.setText(sprintf("%d", int(tire_nose_condition * 369.0)));
    	p_dps_hyd_thermal.ng_right2.setText(sprintf("%d", int(tire_nose_condition * 369.0)));

        device.update_common_DPS();
    }
    
    
    
    return p_dps_hyd_thermal;
}
