#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_apu_thermal
# Description: the APU/environment thermal control page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_apu_thermal = func(device)
{
    var p_dps_apu_thermal = device.addPage("CRTAPUThermal", "p_dps_apu_thermal");

    p_dps_apu_thermal.group = device.svg.getElementById("p_dps_apu_thermal");
    p_dps_apu_thermal.group.setColor(dps_r, dps_g, dps_b);
    
    p_dps_apu_thermal.accum_qty1 = device.svg.getElementById("p_dps_apu_thermal_accum_qty1");
    p_dps_apu_thermal.accum_qty2 = device.svg.getElementById("p_dps_apu_thermal_accum_qty2");

    p_dps_apu_thermal.freon_isol1 = device.svg.getElementById("p_dps_apu_thermal_freon_isol1");
    p_dps_apu_thermal.freon_isol2 = device.svg.getElementById("p_dps_apu_thermal_freon_isol2");

    p_dps_apu_thermal.freon_flow1 = device.svg.getElementById("p_dps_apu_thermal_freon_flow1");
    p_dps_apu_thermal.freon_flow2 = device.svg.getElementById("p_dps_apu_thermal_freon_flow2");

    p_dps_apu_thermal.pl_hx_flow1 = device.svg.getElementById("p_dps_apu_thermal_pl_hx_flow1");
    p_dps_apu_thermal.pl_hx_flow2 = device.svg.getElementById("p_dps_apu_thermal_pl_hx_flow2");

    p_dps_apu_thermal.aft_cp_flow1 = device.svg.getElementById("p_dps_apu_thermal_aft_cp_flow1");
    p_dps_apu_thermal.aft_cp_flow2 = device.svg.getElementById("p_dps_apu_thermal_aft_cp_flow2");

    p_dps_apu_thermal.rad_in_t1 = device.svg.getElementById("p_dps_apu_thermal_rad_in_t1");
    p_dps_apu_thermal.rad_in_t2 = device.svg.getElementById("p_dps_apu_thermal_rad_in_t2");

    p_dps_apu_thermal.rad_out_t1 = device.svg.getElementById("p_dps_apu_thermal_rad_out_t1");
    p_dps_apu_thermal.rad_out_t2 = device.svg.getElementById("p_dps_apu_thermal_rad_out_t2");

    p_dps_apu_thermal.evap_out_t1 = device.svg.getElementById("p_dps_apu_thermal_evap_out_t1");
    p_dps_apu_thermal.evap_out_t2 = device.svg.getElementById("p_dps_apu_thermal_evap_out_t2");

    p_dps_apu_thermal.h2opump_out_p1 = device.svg.getElementById("p_dps_apu_thermal_h2opump_out_p1");
    p_dps_apu_thermal.h2opump_out_p2 = device.svg.getElementById("p_dps_apu_thermal_h2opump_out_p2");

    p_dps_apu_thermal.h2opump_out_t1 = device.svg.getElementById("p_dps_apu_thermal_h2opump_out_t1");
    p_dps_apu_thermal.h2opump_out_t2 = device.svg.getElementById("p_dps_apu_thermal_h2opump_out_t2");
    
    p_dps_apu_thermal.h2opump_out_dp1 = device.svg.getElementById("p_dps_apu_thermal_h2opump_out_dp1");
    p_dps_apu_thermal.h2opump_out_dp2 = device.svg.getElementById("p_dps_apu_thermal_h2opump_out_dp2");

    p_dps_apu_thermal.h2opump_ich_flow1 = device.svg.getElementById("p_dps_apu_thermal_h2opump_ich_flow1");
    p_dps_apu_thermal.h2opump_ich_flow2 = device.svg.getElementById("p_dps_apu_thermal_h2opump_ich_flow2");

    p_dps_apu_thermal.h2opump_accum_qty1 = device.svg.getElementById("p_dps_apu_thermal_h2opump_accum_qty1");
    p_dps_apu_thermal.h2opump_accum_qty2 = device.svg.getElementById("p_dps_apu_thermal_h2opump_accum_qty2");

    p_dps_apu_thermal.h2opump_ich_out_t1 = device.svg.getElementById("p_dps_apu_thermal_h2opump_ich_out_t1");
    p_dps_apu_thermal.h2opump_ich_out_t2 = device.svg.getElementById("p_dps_apu_thermal_h2opump_ich_out_t2");

    p_dps_apu_thermal.h2opump_cab_hx_in_t1 = device.svg.getElementById("p_dps_apu_thermal_h2opump_cab_hx_in_t1");
    p_dps_apu_thermal.h2opump_cab_hx_in_t2 = device.svg.getElementById("p_dps_apu_thermal_h2opump_cab_hx_in_t2");


    p_dps_apu_thermal.apu_fl_tk_surf1 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_tk_surf1");
    p_dps_apu_thermal.apu_fl_tk_surf2 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_tk_surf2");
    p_dps_apu_thermal.apu_fl_tk_surf3 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_tk_surf3");

    p_dps_apu_thermal.apu_fl_tk_htr1 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_tk_htr1");
    p_dps_apu_thermal.apu_fl_tk_htr2 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_tk_htr2");
    p_dps_apu_thermal.apu_fl_tk_htr3 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_tk_htr3");

    p_dps_apu_thermal.apu_fl_test_ln1_1 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_test_ln1_1");
    p_dps_apu_thermal.apu_fl_test_ln1_2 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_test_ln1_2");
    p_dps_apu_thermal.apu_fl_test_ln1_3 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_test_ln1_3");

    p_dps_apu_thermal.apu_fl_test_ln2_1 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_test_ln2_1");
    p_dps_apu_thermal.apu_fl_test_ln2_2 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_test_ln2_2");
    p_dps_apu_thermal.apu_fl_test_ln2_3 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_test_ln2_3");

    p_dps_apu_thermal.apu_fl_feed_ln1 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_feed_ln1");
    p_dps_apu_thermal.apu_fl_feed_ln2 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_feed_ln2");
    p_dps_apu_thermal.apu_fl_feed_ln3 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_feed_ln3");

    p_dps_apu_thermal.apu_fl_pump_in1 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_pump_in1");
    p_dps_apu_thermal.apu_fl_pump_in2 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_pump_in2");
    p_dps_apu_thermal.apu_fl_pump_in3 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_pump_in3");

    p_dps_apu_thermal.apu_fl_drn_ln1_1 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_drn_ln1_1");
    p_dps_apu_thermal.apu_fl_drn_ln1_2 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_drn_ln1_2");
    p_dps_apu_thermal.apu_fl_drn_ln1_3 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_drn_ln1_3");

    p_dps_apu_thermal.apu_fl_drn_ln2_1 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_drn_ln2_1");
    p_dps_apu_thermal.apu_fl_drn_ln2_2 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_drn_ln2_2");
    p_dps_apu_thermal.apu_fl_drn_ln2_3 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_drn_ln2_3");

    p_dps_apu_thermal.apu_fl_out_1 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_out_1");
    p_dps_apu_thermal.apu_fl_out_2 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_out_2");
    p_dps_apu_thermal.apu_fl_out_3 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_out_3");

    p_dps_apu_thermal.apu_fl_byp_ln1 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_byp_ln1");
    p_dps_apu_thermal.apu_fl_byp_ln2 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_byp_ln2");
    p_dps_apu_thermal.apu_fl_byp_ln3 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_byp_ln3");

    p_dps_apu_thermal.apu_fl_gg_sply1 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_gg_sply1");
    p_dps_apu_thermal.apu_fl_gg_sply2 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_gg_sply2");
    p_dps_apu_thermal.apu_fl_gg_sply3 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_gg_sply3");

    p_dps_apu_thermal.apu_fl_h2o_ln1 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_h2o_ln1");
    p_dps_apu_thermal.apu_fl_h2o_ln2 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_h2o_ln2");
    p_dps_apu_thermal.apu_fl_h2o_ln3 = device.svg.getElementById("p_dps_apu_thermal_apu_fl_h2o_ln3");

    p_dps_apu_thermal.evt_lr_duct_1 = device.svg.getElementById("p_dps_apu_thermal_evt_lr_duct_1");
    p_dps_apu_thermal.evt_lr_duct_2 = device.svg.getElementById("p_dps_apu_thermal_evt_lr_duct_2");

    p_dps_apu_thermal.evt_hild_ibob_1 = device.svg.getElementById("p_dps_apu_thermal_evt_hild_ibob_1");
    p_dps_apu_thermal.evt_hild_ibob_2 = device.svg.getElementById("p_dps_apu_thermal_evt_hild_ibob_2");

    p_dps_apu_thermal.evt_noz = device.svg.getElementById("p_dps_apu_thermal_evt_noz");

    p_dps_apu_thermal.evt_top_fwa_1 = device.svg.getElementById("p_dps_apu_thermal_evt_top_fwa_1");
    p_dps_apu_thermal.evt_top_fwa_2 = device.svg.getElementById("p_dps_apu_thermal_evt_top_fwa_2");

    p_dps_apu_thermal.evt_lr_noz_1 = device.svg.getElementById("p_dps_apu_thermal_evt_lr_noz_1");
    p_dps_apu_thermal.evt_lr_noz_2 = device.svg.getElementById("p_dps_apu_thermal_evt_lr_noz_2");

    p_dps_apu_thermal.eflt_fwd_A = device.svg.getElementById("p_dps_apu_thermal_eflt_fwd_A");
    p_dps_apu_thermal.eflt_fwd_B = device.svg.getElementById("p_dps_apu_thermal_eflt_fwd_B");

    p_dps_apu_thermal.eflt_mid1_A = device.svg.getElementById("p_dps_apu_thermal_eflt_mid1_A");
    p_dps_apu_thermal.eflt_mid1_B = device.svg.getElementById("p_dps_apu_thermal_eflt_mid1_B");

    p_dps_apu_thermal.eflt_mid2_A = device.svg.getElementById("p_dps_apu_thermal_eflt_mid2_A");
    p_dps_apu_thermal.eflt_mid2_B = device.svg.getElementById("p_dps_apu_thermal_eflt_mid2_B");

    p_dps_apu_thermal.eflt_aft_A = device.svg.getElementById("p_dps_apu_thermal_eflt_aft_A");
    p_dps_apu_thermal.eflt_aft_B = device.svg.getElementById("p_dps_apu_thermal_eflt_aft_B");

    p_dps_apu_thermal.eflt_topping_A = device.svg.getElementById("p_dps_apu_thermal_eflt_topping_A");
    p_dps_apu_thermal.eflt_topping_B = device.svg.getElementById("p_dps_apu_thermal_eflt_topping_B");

    p_dps_apu_thermal.eflt_accum_A = device.svg.getElementById("p_dps_apu_thermal_eflt_accum_A");
    p_dps_apu_thermal.eflt_accum_B = device.svg.getElementById("p_dps_apu_thermal_eflt_accum_B");

    p_dps_apu_thermal.eflt_hiload_A = device.svg.getElementById("p_dps_apu_thermal_eflt_hiload_A");
    p_dps_apu_thermal.eflt_hiload_B = device.svg.getElementById("p_dps_apu_thermal_eflt_hiload_B");

    p_dps_apu_thermal.ondisplay = func
    {
        device.DPS_menu_title.setText("APU/ENVIRON THERM");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
	var spec = SpaceShuttle.idp_array[device.port_selected-1].get_spec();    
	var spec_string = assemble_spec_string(spec);
    
        var ops_string = major_mode~"1/"~spec_string~"/088";
        device.DPS_menu_ops.setText(ops_string);

	# plausible values for items not yet implemented

    	p_dps_apu_thermal.accum_qty1.setText("27");
    	p_dps_apu_thermal.accum_qty2.setText("28");

    	p_dps_apu_thermal.h2opump_out_t1.setText("63");
    	p_dps_apu_thermal.h2opump_out_t2.setText("64");

    	p_dps_apu_thermal.h2opump_accum_qty1.setText("45");
    	p_dps_apu_thermal.h2opump_accum_qty2.setText("55");

    	p_dps_apu_thermal.h2opump_ich_out_t1.setText("41");
    	p_dps_apu_thermal.h2opump_ich_out_t2.setText("42");

    	p_dps_apu_thermal.h2opump_cab_hx_in_t1.setText("38");
    	p_dps_apu_thermal.h2opump_cab_hx_in_t2.setText("38");

	



    }
    
    p_dps_apu_thermal.update = func
    {

	# freon loops

	var freon_flow1 = getprop("/fdm/jsbsim/systems/atcs/freon-pump-1-active") * 2246.0;
	var freon_flow2 = getprop("/fdm/jsbsim/systems/atcs/freon-pump-2-active") * 2258.0;
	
        p_dps_apu_thermal.freon_flow1.setText(sprintf("%4.0f", freon_flow1));
    	p_dps_apu_thermal.freon_flow2.setText(sprintf("%4.0f", freon_flow2));

    	p_dps_apu_thermal.pl_hx_flow1.setText(sprintf("%4.0f", freon_flow1/8.0));
    	p_dps_apu_thermal.pl_hx_flow2.setText(sprintf("%4.0f", freon_flow2/8.0));

    	p_dps_apu_thermal.aft_cp_flow1.setText(sprintf("%3.0f", freon_flow1/8.5));
    	p_dps_apu_thermal.aft_cp_flow2.setText(sprintf("%3.0f", freon_flow2/8.5));

	var byp1 = getprop("/fdm/jsbsim/systems/atcs/flow-bypass-1-status");
	var byp2 = getprop("/fdm/jsbsim/systems/atcs/flow-bypass-2-status");

	var text = "ISOL";
	if (byp1 == 0) {text = "RAD";}
	p_dps_apu_thermal.freon_isol1.setText(text);

	text = "ISOL";
	if (byp2 == 0) {text = "RAD";}
	p_dps_apu_thermal.freon_isol2.setText(text);

	var rad_in_T1 = K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/freon-in-temperature-K"));
	var rad_in_T2 = rad_in_T1;
	
	var evap_out_T1 = K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/freon-out-temperature-K"));
	var evap_out_T2 = evap_out_T1;

	var rad_out_T1 = evap_out_T1;
	var rad_out_T2 = evap_out_T2;

    	p_dps_apu_thermal.rad_in_t1.setText(sprintf("%3.0f", rad_in_T1)); 
    	p_dps_apu_thermal.rad_in_t2.setText(sprintf("%3.0f", rad_in_T2));  

    	p_dps_apu_thermal.rad_out_t1.setText(sprintf("%3.0f", rad_out_T1)); 
    	p_dps_apu_thermal.rad_out_t2.setText(sprintf("%3.0f", rad_out_T2)); 

    	p_dps_apu_thermal.evap_out_t1.setText(sprintf("%3.0f", evap_out_T1)); 
    	p_dps_apu_thermal.evap_out_t2.setText(sprintf("%3.0f", evap_out_T2)); 
	
	# H2O loops

	var h2o_pump1 = getprop("/fdm/jsbsim/systems/atcs/water-pump-1-active");
	var h2o_pump2 = getprop("/fdm/jsbsim/systems/atcs/water-pump-2-active");

	var water_pressure1 = 20 + h2o_pump1 * 43;
	var water_pressure2 = 23 + h2o_pump2 * 41;

   	p_dps_apu_thermal.h2opump_out_p1.setText(sprintf("%2.0f", water_pressure1));
    	p_dps_apu_thermal.h2opump_out_p2.setText(sprintf("%2.0f", water_pressure2));


    	p_dps_apu_thermal.h2opump_out_dp1.setText(sprintf("%2.0f", water_pressure1-20));
    	p_dps_apu_thermal.h2opump_out_dp2.setText(sprintf("%2.0f", water_pressure2-23)); 

    	p_dps_apu_thermal.h2opump_ich_flow1.setText(sprintf("%3.0f", h2o_pump1 * 777));
    	p_dps_apu_thermal.h2opump_ich_flow2.setText(sprintf("%3.0f", h2o_pump2 * 792));


	# APU fuel

	var T_aft = K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/aft-temperature-K"));

	var T_fuel1 = T_aft;
	if ((getprop("/fdm/jsbsim/systems/apu/apu/heater-tank-operational") == 1) and (T_fuel1 < 68.0))
		{T_fuel1 = 68.0;}

	var T_fuel2 = T_aft;
	if ((getprop("/fdm/jsbsim/systems/apu/apu[1]/heater-tank-operational") == 1) and (T_fuel2 < 69.0))
		{T_fuel2 = 69.0;}

	var T_fuel3 = T_aft;
	if ((getprop("/fdm/jsbsim/systems/apu/apu[2]/heater-tank-operational") == 1) and (T_fuel3 < 68.0))
		{T_fuel3 = 68.0;}

    	p_dps_apu_thermal.apu_fl_tk_surf1.setText(sprintf("%+3.0f",T_fuel1));
    	p_dps_apu_thermal.apu_fl_tk_surf2.setText(sprintf("%+3.0f",T_fuel2));
    	p_dps_apu_thermal.apu_fl_tk_surf3.setText(sprintf("%+3.0f",T_fuel3-1.0));

    	p_dps_apu_thermal.apu_fl_tk_htr1.setText(sprintf("%+3.0f",T_fuel1));
    	p_dps_apu_thermal.apu_fl_tk_htr2.setText(sprintf("%+3.0f",T_fuel2 + 1.0));
    	p_dps_apu_thermal.apu_fl_tk_htr3.setText(sprintf("%+3.0f",T_fuel3));

    	p_dps_apu_thermal.apu_fl_test_ln1_1.setText(sprintf("%+3.0f",T_fuel1 -4.0)); 
    	p_dps_apu_thermal.apu_fl_test_ln1_2.setText(sprintf("%+3.0f",T_fuel2 - 5.0));
    	p_dps_apu_thermal.apu_fl_test_ln1_3.setText(sprintf("%+3.0f",T_fuel3 - 4.0)); 

    	p_dps_apu_thermal.apu_fl_test_ln2_1.setText(sprintf("%+3.0f",T_fuel1 - 5.0));
    	p_dps_apu_thermal.apu_fl_test_ln2_2.setText(sprintf("%+3.0f",T_fuel2 - 5.0));
    	p_dps_apu_thermal.apu_fl_test_ln2_3.setText(sprintf("%+3.0f",T_fuel3 - 4.0));

    	p_dps_apu_thermal.apu_fl_feed_ln1.setText(sprintf("%+3.0f",T_fuel1 - 6.0));
    	p_dps_apu_thermal.apu_fl_feed_ln2.setText(sprintf("%+3.0f",T_fuel2 - 5.0));
    	p_dps_apu_thermal.apu_fl_feed_ln3.setText(sprintf("%+3.0f",T_fuel3 - 6.0));

    	p_dps_apu_thermal.apu_fl_pump_in1.setText(sprintf("%+3.0f",T_fuel1 - 7.0));
    	p_dps_apu_thermal.apu_fl_pump_in2.setText(sprintf("%+3.0f",T_fuel2 - 6.0));
    	p_dps_apu_thermal.apu_fl_pump_in3.setText(sprintf("%+3.0f",T_fuel3 - 4.0));

    	p_dps_apu_thermal.apu_fl_drn_ln1_1.setText(sprintf("%+3.0f",T_fuel1 - 5.0));
    	p_dps_apu_thermal.apu_fl_drn_ln1_2.setText(sprintf("%+3.0f",T_fuel2 - 7.0));
    	p_dps_apu_thermal.apu_fl_drn_ln1_3.setText(sprintf("%+3.0f",T_fuel3 - 7.0));

    	p_dps_apu_thermal.apu_fl_drn_ln2_1.setText(sprintf("%+3.0f",T_fuel1 - 5.0));
    	p_dps_apu_thermal.apu_fl_drn_ln2_2.setText(sprintf("%+3.0f",T_fuel2 - 5.0));
    	p_dps_apu_thermal.apu_fl_drn_ln2_3.setText(sprintf("%+3.0f",T_fuel3 - 5.0));

	# the parts close to the APU and the gas generator are hotter if APU is running

	var gg_bed_T1 = K_to_F(getprop("/fdm/jsbsim/systems/apu/apu/gg-bed-T-K"));
	var gg_bed_T2 = K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[1]/gg-bed-T-K"));
	var gg_bed_T3 = K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[2]/gg-bed-T-K"));

	if (gg_bed_T1 > T_fuel1)
		{T_fuel1 = T_fuel1 + (gg_bed_T1 - T_fuel1)/10.0;}
	if (gg_bed_T2 > T_fuel2)
		{T_fuel2 = T_fuel2 + (gg_bed_T2 - T_fuel2)/10.0;}
	if (gg_bed_T3 > T_fuel3)
		{T_fuel3 = T_fuel3 + (gg_bed_T3 - T_fuel3)/10.0;}

	p_dps_apu_thermal.apu_fl_out_1.setText(sprintf("%+3.0f",T_fuel1 - 1.0)); 
	p_dps_apu_thermal.apu_fl_out_2.setText(sprintf("%+3.0f",T_fuel2 )); 
	p_dps_apu_thermal.apu_fl_out_3.setText(sprintf("%+3.0f",T_fuel3 + 1.0));

	p_dps_apu_thermal.apu_fl_byp_ln1.setText(sprintf("%+3.0f",T_fuel1 - 2.0)); 
	p_dps_apu_thermal.apu_fl_byp_ln2.setText(sprintf("%+3.0f",T_fuel2 - 1.0)); 
	p_dps_apu_thermal.apu_fl_byp_ln3.setText(sprintf("%+3.0f",T_fuel3 - 2.0));

	p_dps_apu_thermal.apu_fl_gg_sply1.setText(sprintf("%+3.0f",T_fuel1 + 4.0));
	p_dps_apu_thermal.apu_fl_gg_sply2.setText(sprintf("%+3.0f",T_fuel2 + 5.0 )); 
	p_dps_apu_thermal.apu_fl_gg_sply3.setText(sprintf("%+3.0f",T_fuel3 + 5.0));

	p_dps_apu_thermal.apu_fl_h2o_ln1.setText(sprintf("%+3.0f",T_fuel1 - 5.0));
	p_dps_apu_thermal.apu_fl_h2o_ln2.setText(sprintf("%+3.0f",T_fuel2 - 5.0)); 
	p_dps_apu_thermal.apu_fl_h2o_ln3.setText(sprintf("%+3.0f",T_fuel3 - 4.0));


	# evaporator temperatures

	var T_duct_topping = T_aft;

	if (getprop("/fdm/jsbsim/systems/atcs/fes-topping-duct-heater-active") == 1)
		{
		if (T_duct_topping < 60.0) {T_duct_topping = 60.0;}
		}

	var T_duct_hiload = T_aft;

	if (getprop("/fdm/jsbsim/systems/atcs/fes-hiload-duct-heater-active") == 1)
		{
		if (T_duct_hiload < 61.0) {T_duct_hiload = 61.0;}
		}

    	p_dps_apu_thermal.evt_lr_duct_1.setText(sprintf("%+3.0f",T_duct_topping));
    	p_dps_apu_thermal.evt_lr_duct_2.setText(sprintf("%+3.0f",T_duct_topping));

    	p_dps_apu_thermal.evt_top_fwa_1.setText(sprintf("%+3.0f",T_duct_topping));
    	p_dps_apu_thermal.evt_top_fwa_2.setText(sprintf("%+3.0f",T_duct_topping));

    	p_dps_apu_thermal.evt_hild_ibob_1.setText(sprintf("%+3.0f",T_duct_hiload));
    	p_dps_apu_thermal.evt_hild_ibob_2.setText(sprintf("%+3.0f",T_duct_hiload-1.0));

	p_dps_apu_thermal.evt_noz.setText(sprintf("%+3.0f",T_duct_hiload));

	var T_nozzle_left = T_aft;

	if (getprop("/fdm/jsbsim/systems/atcs/fes-topping-left-heater-active") == 1)
		{
		if (T_nozzle_left < 62.0) {T_nozzle_left = 62.0;}
		}

	var T_nozzle_right = T_aft;


	if (getprop("/fdm/jsbsim/systems/atcs/fes-topping-right-heater-active") == 1)
		{
		if (T_nozzle_right < 60.0) {T_nozzle_right = 60.0;}
		}

    	p_dps_apu_thermal.evt_lr_noz_1.setText(sprintf("%+3.0f",T_nozzle_left));
    	p_dps_apu_thermal.evt_lr_noz_2.setText(sprintf("%+3.0f",T_nozzle_right));

	# H2O feedlines

	var fdln_A_status = getprop("/fdm/jsbsim/systems/atcs/fes-feedline-A-heater-active");
	var fdln_B_status = getprop("/fdm/jsbsim/systems/atcs/fes-feedline-B-heater-active");

	var T_fdlnA = T_aft;
	var T_fdlnB = T_aft;

	if ((fdln_A_status == 1) and (T_fdlnA < 78.0)) {T_fdlnA = 78.0;}
	if ((fdln_B_status == 1) and (T_fdlnB < 78.0)) {T_fdlnB = 78.0;}

	p_dps_apu_thermal.eflt_fwd_A.setText(sprintf("%+3.0f",T_fdlnA+2.0));
    	p_dps_apu_thermal.eflt_fwd_B.setText(sprintf("%+3.0f",T_fdlnB+2.0));

    	p_dps_apu_thermal.eflt_mid1_A.setText(sprintf("%+3.0f",T_fdlnA+3.0));
    	p_dps_apu_thermal.eflt_mid1_B.setText(sprintf("%+3.0f",T_fdlnB+2.0));

    	p_dps_apu_thermal.eflt_mid2_A.setText(sprintf("%+3.0f",T_fdlnA));
    	p_dps_apu_thermal.eflt_mid2_B.setText(sprintf("%+3.0f",T_fdlnB+1.0));

    	p_dps_apu_thermal.eflt_aft_A.setText(sprintf("%+3.0f",T_fdlnA+1.0));
    	p_dps_apu_thermal.eflt_aft_B.setText(sprintf("%+3.0f",T_fdlnB));

    	p_dps_apu_thermal.eflt_topping_A.setText(sprintf("%+3.0f",T_fdlnA-1.0));
    	p_dps_apu_thermal.eflt_topping_B.setText(sprintf("%+3.0f",T_fdlnB-2.0));

    	p_dps_apu_thermal.eflt_accum_A.setText(sprintf("%+3.0f",T_fdlnA-3.0));
    	p_dps_apu_thermal.eflt_accum_B.setText(sprintf("%+3.0f",T_fdlnB-2.0));

    	p_dps_apu_thermal.eflt_hiload_A.setText(sprintf("%+3.0f",T_fdlnA-3.0));
    	p_dps_apu_thermal.eflt_hiload_B.setText(sprintf("%+3.0f",T_fdlnB-3.0));


        device.update_common_DPS();
    }
    
    
    
    return p_dps_apu_thermal;
}
