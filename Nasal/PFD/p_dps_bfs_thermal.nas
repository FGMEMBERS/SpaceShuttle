#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_bfs_thermal
# Description: the BFS thermal systems summary page
#      Author: Thorsten Renk, 2017
#---------------------------------------

var PFD_addpage_p_dps_bfs_thermal = func(device)
{
    var p_dps_bfs_thermal = device.addPage("CRTBFSThermal", "p_dps_bfs_thermal");

    p_dps_bfs_thermal.group = device.svg.getElementById("p_dps_bfs_thermal");
    p_dps_bfs_thermal.group.setColor(dps_r, dps_g, dps_b);
    
    p_dps_bfs_thermal.t_bf_prime = device.svg.getElementById("p_dps_bfs_thermal_t_bf_prime");
    p_dps_bfs_thermal.t_rd_prime = device.svg.getElementById("p_dps_bfs_thermal_t_rd_prime");  
    p_dps_bfs_thermal.t_lob_prime = device.svg.getElementById("p_dps_bfs_thermal_t_lob_prime");  
    p_dps_bfs_thermal.t_lib_prime = device.svg.getElementById("p_dps_bfs_thermal_t_lib_prime");  
    p_dps_bfs_thermal.t_rib_prime = device.svg.getElementById("p_dps_bfs_thermal_t_rib_prime");  
    p_dps_bfs_thermal.t_rob_prime = device.svg.getElementById("p_dps_bfs_thermal_t_rob_prime");  

    p_dps_bfs_thermal.t_bf_stby1 = device.svg.getElementById("p_dps_bfs_thermal_t_bf_stby1");
    p_dps_bfs_thermal.t_rd_stby1 = device.svg.getElementById("p_dps_bfs_thermal_t_rd_stby1");  
    p_dps_bfs_thermal.t_lob_stby1 = device.svg.getElementById("p_dps_bfs_thermal_t_lob_stby1");  
    p_dps_bfs_thermal.t_lib_stby1 = device.svg.getElementById("p_dps_bfs_thermal_t_lib_stby1");  
    p_dps_bfs_thermal.t_rib_stby1 = device.svg.getElementById("p_dps_bfs_thermal_t_rib_stby1");  
    p_dps_bfs_thermal.t_rob_stby1 = device.svg.getElementById("p_dps_bfs_thermal_t_rob_stby1");

    p_dps_bfs_thermal.brake_13_lob = device.svg.getElementById("p_dps_bfs_thermal_brake_13_lob");
    p_dps_bfs_thermal.brake_13_lib = device.svg.getElementById("p_dps_bfs_thermal_brake_13_lib");
    p_dps_bfs_thermal.brake_13_rib = device.svg.getElementById("p_dps_bfs_thermal_brake_13_rib");
    p_dps_bfs_thermal.brake_13_rob = device.svg.getElementById("p_dps_bfs_thermal_brake_13_rob");

    p_dps_bfs_thermal.brake_13_lob.enableUpdate();
    p_dps_bfs_thermal.brake_13_lib.enableUpdate();
    p_dps_bfs_thermal.brake_13_rib.enableUpdate();
    p_dps_bfs_thermal.brake_13_rob.enableUpdate();

    p_dps_bfs_thermal.brake_23_lob = device.svg.getElementById("p_dps_bfs_thermal_brake_23_lob");
    p_dps_bfs_thermal.brake_23_lib = device.svg.getElementById("p_dps_bfs_thermal_brake_23_lib");
    p_dps_bfs_thermal.brake_23_rib = device.svg.getElementById("p_dps_bfs_thermal_brake_23_rib");
    p_dps_bfs_thermal.brake_23_rob = device.svg.getElementById("p_dps_bfs_thermal_brake_23_rob");

    p_dps_bfs_thermal.brake_23_lob.enableUpdate();
    p_dps_bfs_thermal.brake_23_lib.enableUpdate();
    p_dps_bfs_thermal.brake_23_rib.enableUpdate();
    p_dps_bfs_thermal.brake_23_rob.enableUpdate();

    p_dps_bfs_thermal.accum_qty1 = device.svg.getElementById("p_dps_bfs_thermal_accum_qty1");
    p_dps_bfs_thermal.accum_qty2 = device.svg.getElementById("p_dps_bfs_thermal_accum_qty2");

    p_dps_bfs_thermal.tire_p_mg_ib_left1 = device.svg.getElementById("p_dps_bfs_thermal_tire_p_mg_ib_left1");
    p_dps_bfs_thermal.tire_p_mg_ib_left2 = device.svg.getElementById("p_dps_bfs_thermal_tire_p_mg_ib_left2");
    p_dps_bfs_thermal.tire_p_mg_ib_right1 = device.svg.getElementById("p_dps_bfs_thermal_tire_p_mg_ib_right1");
    p_dps_bfs_thermal.tire_p_mg_ib_right2 = device.svg.getElementById("p_dps_bfs_thermal_tire_p_mg_ib_right2");

    p_dps_bfs_thermal.tire_p_mg_ib_left1.enableUpdate();
    p_dps_bfs_thermal.tire_p_mg_ib_left2.enableUpdate();
    p_dps_bfs_thermal.tire_p_mg_ib_right1.enableUpdate();
    p_dps_bfs_thermal.tire_p_mg_ib_right2.enableUpdate();

    p_dps_bfs_thermal.tire_p_mg_ob_left1 = device.svg.getElementById("p_dps_bfs_thermal_tire_p_mg_ob_left1");
    p_dps_bfs_thermal.tire_p_mg_ob_left2 = device.svg.getElementById("p_dps_bfs_thermal_tire_p_mg_ob_left2");
    p_dps_bfs_thermal.tire_p_mg_ob_right1 = device.svg.getElementById("p_dps_bfs_thermal_tire_p_mg_ob_right1");
    p_dps_bfs_thermal.tire_p_mg_ob_right2 = device.svg.getElementById("p_dps_bfs_thermal_tire_p_mg_ob_right2");

    p_dps_bfs_thermal.tire_p_mg_ob_left1.enableUpdate();
    p_dps_bfs_thermal.tire_p_mg_ob_left2.enableUpdate();
    p_dps_bfs_thermal.tire_p_mg_ob_right1.enableUpdate();
    p_dps_bfs_thermal.tire_p_mg_ob_right2.enableUpdate();

    p_dps_bfs_thermal.tire_p_ng_left1 = device.svg.getElementById("p_dps_bfs_thermal_tire_p_ng_left1");
    p_dps_bfs_thermal.tire_p_ng_left2 = device.svg.getElementById("p_dps_bfs_thermal_tire_p_ng_left2");
    p_dps_bfs_thermal.tire_p_ng_right1 = device.svg.getElementById("p_dps_bfs_thermal_tire_p_ng_right1");
    p_dps_bfs_thermal.tire_p_ng_right2 = device.svg.getElementById("p_dps_bfs_thermal_tire_p_ng_right2");

    p_dps_bfs_thermal.tire_p_ng_left1.enableUpdate();
    p_dps_bfs_thermal.tire_p_ng_left2.enableUpdate();
    p_dps_bfs_thermal.tire_p_ng_right1.enableUpdate();
    p_dps_bfs_thermal.tire_p_ng_right2.enableUpdate();

    p_dps_bfs_thermal.pmp1 = device.svg.getElementById("p_dps_bfs_thermal_pmp1");
    p_dps_bfs_thermal.pmp2 = device.svg.getElementById("p_dps_bfs_thermal_pmp2");
    p_dps_bfs_thermal.pmp3 = device.svg.getElementById("p_dps_bfs_thermal_pmp3");

    p_dps_bfs_thermal.gg1 = device.svg.getElementById("p_dps_bfs_thermal_gg1");
    p_dps_bfs_thermal.gg2 = device.svg.getElementById("p_dps_bfs_thermal_gg2");
    p_dps_bfs_thermal.gg3 = device.svg.getElementById("p_dps_bfs_thermal_gg3");

    p_dps_bfs_thermal.tk1 = device.svg.getElementById("p_dps_bfs_thermal_tk1");
    p_dps_bfs_thermal.tk2 = device.svg.getElementById("p_dps_bfs_thermal_tk2");
    p_dps_bfs_thermal.tk3 = device.svg.getElementById("p_dps_bfs_thermal_tk3");

    p_dps_bfs_thermal.hyd_blr1 = device.svg.getElementById("p_dps_bfs_thermal_hyd_blr1");
    p_dps_bfs_thermal.hyd_blr2 = device.svg.getElementById("p_dps_bfs_thermal_hyd_blr2");
    p_dps_bfs_thermal.hyd_blr3 = device.svg.getElementById("p_dps_bfs_thermal_hyd_blr3");

    p_dps_bfs_thermal.fdln_la = device.svg.getElementById("p_dps_bfs_thermal_fdln_la");
    p_dps_bfs_thermal.fdln_rb = device.svg.getElementById("p_dps_bfs_thermal_fdln_rb");

    p_dps_bfs_thermal.no_la = device.svg.getElementById("p_dps_bfs_thermal_noz_la");
    p_dps_bfs_thermal.noz_rb = device.svg.getElementById("p_dps_bfs_thermal_noz_rb");

    p_dps_bfs_thermal.top_duct = device.svg.getElementById("p_dps_bfs_thermal_top_duct");
    p_dps_bfs_thermal.evap_hi_load = device.svg.getElementById("p_dps_bfs_thermal_evap_hi_load");
    p_dps_bfs_thermal.oms_xfd_la = device.svg.getElementById("p_dps_bfs_thermal_oms_xfd_la");
    p_dps_bfs_thermal.htr_tmp_pod_la = device.svg.getElementById("p_dps_bfs_thermal_htr_tmp_pod_la");
    p_dps_bfs_thermal.htr_tmp_pod_rb = device.svg.getElementById("p_dps_bfs_thermal_htr_tmp_pod_rb");

    p_dps_bfs_thermal.rad_out_t1 = device.svg.getElementById("p_dps_bfs_thermal_rad_out_t1");
    p_dps_bfs_thermal.rad_out_t2 = device.svg.getElementById("p_dps_bfs_thermal_rad_out_t2");

    p_dps_bfs_thermal.h2o_sup_p1 = device.svg.getElementById("p_dps_bfs_thermal_h2o_sup_p1");

    p_dps_bfs_thermal.rad_out_t1.enableUpdate();
    p_dps_bfs_thermal.rad_out_t2.enableUpdate();

    p_dps_bfs_thermal.h2o_sup_p1.enableUpdate();


    p_dps_bfs_thermal.ondisplay = func
    {
        device.DPS_menu_title.setText("THERMAL");
        device.MEDS_menu_title.setText("       DPS MENU");
    
    
        var ops_string ="0001/   /";
        device.DPS_menu_ops.setText(ops_string);


	# plausible values for items not yet implemented

    	p_dps_bfs_thermal.accum_qty1.setText("27");
    	p_dps_bfs_thermal.accum_qty2.setText("28");

	p_dps_bfs_thermal.pmp1.setText("");
 	p_dps_bfs_thermal.pmp2.setText("");
	p_dps_bfs_thermal.pmp3.setText("");

	p_dps_bfs_thermal.gg1.setText("");
	p_dps_bfs_thermal.gg2.setText("");
	p_dps_bfs_thermal.gg3.setText("");

    	p_dps_bfs_thermal.tk1.setText("");
    	p_dps_bfs_thermal.tk2.setText("");
    	p_dps_bfs_thermal.tk3.setText("");

    	p_dps_bfs_thermal.hyd_blr1.setText("");
    	p_dps_bfs_thermal.hyd_blr2.setText("");
    	p_dps_bfs_thermal.hyd_blr3.setText("");

    	p_dps_bfs_thermal.fdln_la.setText("");
    	p_dps_bfs_thermal.fdln_rb.setText("");

    	p_dps_bfs_thermal.no_la.setText("");
    	p_dps_bfs_thermal.noz_rb.setText("");

    	p_dps_bfs_thermal.top_duct.setText("");
    	p_dps_bfs_thermal.evap_hi_load.setText("");
    	p_dps_bfs_thermal.oms_xfd_la.setText("");
    	p_dps_bfs_thermal.htr_tmp_pod_la.setText("");
    	p_dps_bfs_thermal.htr_tmp_pod_rb.setText("");

    }
    
    p_dps_bfs_thermal.update = func
    {
    

	# temperatures

	var T_nose = getprop("/fdm/jsbsim/systems/thermal-distribution/nose-temperature-K");
	var T_left = getprop("/fdm/jsbsim/systems/thermal-distribution/left-temperature-K");
	var T_right = getprop("/fdm/jsbsim/systems/thermal-distribution/right-temperature-K");
	var T_low = getprop("/fdm/jsbsim/systems/thermal-distribution/tps-temperature-K");
	var T_aft = getprop("/fdm/jsbsim/systems/thermal-distribution/aft-temperature-K");
	var T_freon = getprop("/fdm/jsbsim/systems/thermal-distribution/freon-in-temperature-K");

	# if APUs are running, the hydraulic fluid gets hotter

	var T_hot1 = getprop("/fdm/jsbsim/systems/apu/apu/hyd-rsvr-T-K");
	var T_hot2 = getprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-rsvr-T-K");
	var T_hot3 = getprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-rsvr-T-K");

	var T_av_in1 = (T_nose + T_left + T_right + T_low + T_aft)/5.0;
	var T_av_in2 = T_av_in1;
	var T_av_in3 = T_av_in1;

	T_av1 = getprop("/fdm/jsbsim/systems/thermal-distribution/hyd-reservoir-temperature-K");
	T_av2 = T_av1;
	T_av3 = T_av1;

	if (T_hot1 > T_av1) {T_av1 = T_hot1;}
	if (T_hot2 > T_av2) {T_av2 = T_hot2;}
	if (T_hot3 > T_av3) {T_av3 = T_hot3;}

	if (T_hot1 > T_av_in1) {T_av_in1 = T_hot1;}
	if (T_hot2 > T_av_in2) {T_av_in2 = T_hot2;}
	if (T_hot3 > T_av_in3) {T_av_in3 = T_hot3;}

	var T_lwing = (T_left + T_low)/2.0;
	var T_rwing = (T_right + T_low)/2.0;

	var mix1 = getprop("/fdm/jsbsim/systems/apu/apu/temp-equalization-factor");
	var mix2 = getprop("/fdm/jsbsim/systems/apu/apu[1]/temp-equalization-factor");
	var mix3 = getprop("/fdm/jsbsim/systems/apu/apu[2]/temp-equalization-factor");

    	p_dps_bfs_thermal.t_bf_prime.setText(sprintf("%+d", mix_T_to_F(T_av1, T_aft, mix1)-3)); 
    	p_dps_bfs_thermal.t_bf_stby1.setText(sprintf("%+d", mix_T_to_F(T_av2, T_aft, mix2)));

	p_dps_bfs_thermal.t_rd_prime.setText(sprintf("%+d", mix_T_to_F(T_av1, T_aft, mix1)-1));
    	p_dps_bfs_thermal.t_rd_stby1.setText(sprintf("%+d", mix_T_to_F(T_av2, T_aft, mix2))); 

    	p_dps_bfs_thermal.t_lob_prime.setText(sprintf("%+d", mix_T_to_F(T_av1, T_lwing, mix1)-1)); 
    	p_dps_bfs_thermal.t_lob_stby1.setText(sprintf("%+d", mix_T_to_F(T_av2, T_lwing, mix2))); 

	p_dps_bfs_thermal.t_lib_prime.setText(sprintf("%+d", mix_T_to_F(T_av1, T_lwing, mix1)+3));  
    	p_dps_bfs_thermal.t_lib_stby1.setText(sprintf("%+d", mix_T_to_F(T_av2, T_lwing, mix2)+1)); 

	p_dps_bfs_thermal.t_rib_prime.setText(sprintf("%+d", mix_T_to_F(T_av1, T_rwing, mix1)+1));  
    	p_dps_bfs_thermal.t_rib_stby1.setText(sprintf("%+d", mix_T_to_F(T_av2, T_rwing, mix2)+3));

    	p_dps_bfs_thermal.t_rob_prime.setText(sprintf("%+d", mix_T_to_F(T_av1, T_rwing, mix1))); 
    	p_dps_bfs_thermal.t_rob_stby1.setText(sprintf("%+d", mix_T_to_F(T_av2, T_rwing, mix2)+2)); 
    

	# hydraulic brake pressure

	var hyd_p1 = getprop("/fdm/jsbsim/systems/apu/apu/hyd-pressure-psia");
	var hyd_p2 = getprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-pressure-psia");
	var hyd_p3 = getprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-pressure-psia");

	var hyd_p12 = hyd_p1;
	if (hyd_p2 > hyd_p1) {hyd_p12 = hyd_p2;}
	if (hyd_p12 > 2000.0) {hyd_p12 = 2000.0;}

	var hyd_p23 = hyd_p2;
	if (hyd_p3 > hyd_p2) {hyd_p23 = hyd_p3;}
	if (hyd_p23 > 2000.0) {hyd_p23 = 2000.0;}

	p_dps_bfs_thermal.brake_13_lob.updateText(sprintf("%4.0f", hyd_p12 - 3.0));
	p_dps_bfs_thermal.brake_13_lib.updateText(sprintf("%4.0f", hyd_p12 - 6.0));
	p_dps_bfs_thermal.brake_13_rib.updateText(sprintf("%4.0f", hyd_p12 - 5.0));
	p_dps_bfs_thermal.brake_13_rob.updateText(sprintf("%4.0f", hyd_p12 - 2.0));

	p_dps_bfs_thermal.brake_23_lob.updateText(sprintf("%4.0f", hyd_p23 - 6.0));
	p_dps_bfs_thermal.brake_23_lib.updateText(sprintf("%4.0f", hyd_p23 - 7.0));
	p_dps_bfs_thermal.brake_23_rib.updateText(sprintf("%4.0f", hyd_p23 - 2.0));
	p_dps_bfs_thermal.brake_23_rob.updateText(sprintf("%4.0f", hyd_p23 - 3.0));


	# tire pressures

	var tire_nose_left_condition = getprop("/fdm/jsbsim/systems/failures/gear/tire-nose-left-condition");
	var tire_nose_right_condition = getprop("/fdm/jsbsim/systems/failures/gear/tire-nose-right-condition");
	var tire_left_ib_condition = getprop("/fdm/jsbsim/systems/failures/gear/tire-left-ib-condition");
	var tire_left_ob_condition = getprop("/fdm/jsbsim/systems/failures/gear/tire-left-ob-condition");
	var tire_right_ib_condition = getprop("/fdm/jsbsim/systems/failures/gear/tire-right-ib-condition");
	var tire_right_ob_condition = getprop("/fdm/jsbsim/systems/failures/gear/tire-right-ob-condition");

	p_dps_bfs_thermal.tire_p_mg_ib_left1.updateText(sprintf("%d", int(tire_left_ib_condition * 377.0)));
	p_dps_bfs_thermal.tire_p_mg_ib_left2.updateText(sprintf("%d", int(tire_left_ib_condition * 377.0)));
	p_dps_bfs_thermal.tire_p_mg_ib_right1.updateText(sprintf("%d", int(tire_right_ib_condition * 378.0)));
	p_dps_bfs_thermal.tire_p_mg_ib_right2.updateText(sprintf("%d", int(tire_right_ib_condition * 378.0)));

	p_dps_bfs_thermal.tire_p_mg_ob_left1.updateText(sprintf("%d", int(tire_left_ob_condition * 374.0)));
	p_dps_bfs_thermal.tire_p_mg_ob_left2.updateText(sprintf("%d", int(tire_left_ob_condition * 374.0)));
	p_dps_bfs_thermal.tire_p_mg_ob_right1.updateText(sprintf("%d", int(tire_right_ob_condition * 376.0)));
	p_dps_bfs_thermal.tire_p_mg_ob_right2.updateText(sprintf("%d", int(tire_right_ob_condition * 376.0)));

    	p_dps_bfs_thermal.tire_p_ng_left1.updateText(sprintf("%d", int(tire_nose_left_condition * 368.0)));
    	p_dps_bfs_thermal.tire_p_ng_left2.updateText(sprintf("%d", int(tire_nose_left_condition * 368.0)));
    	p_dps_bfs_thermal.tire_p_ng_right1.updateText(sprintf("%d", int(tire_nose_right_condition * 369.0)));
    	p_dps_bfs_thermal.tire_p_ng_right2.updateText(sprintf("%d", int(tire_nose_right_condition * 369.0)));

	# freon and water loops

	var T_rad = K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/freon-out-temperature-K"));

    	p_dps_bfs_thermal.rad_out_t1.updateText(sprintf("%3.0f",T_rad));
    	p_dps_bfs_thermal.rad_out_t2.updateText(sprintf("%3.0f",T_rad));

	var n2_sys1 = getprop("/fdm/jsbsim/systems/eclss/nitrogen/sys1-pressurized");
	var n2_sys2 = getprop("/fdm/jsbsim/systems/eclss/nitrogen/sys2-pressurized");


	if ((n2_sys1 > 0.0) or (n2_sys2 > 0.0))
		{
		p_dps_bfs_thermal.h2o_sup_p1.updateText("15.7");
		}
	else
		{
		p_dps_bfs_thermal.h2o_sup_p1.updateText("0.0L");
		}


        device.update_common_DPS();
    }
    
    
    
    return p_dps_bfs_thermal;
}
