#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_sm_sys_summ2
# Description: the SM SYS SUMM 2 page
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_dps_sm_sys_summ2 = func(device)
{
    var p_dps_sm_sys_summ2 = device.addPage("CRTSMSysSumm2", "p_dps_sm_sys_summ2");
    
    p_dps_sm_sys_summ2.apu1_egt = device.svg.getElementById("p_dps_sm_sys_summ2_apu1_egt");
    p_dps_sm_sys_summ2.apu2_egt = device.svg.getElementById("p_dps_sm_sys_summ2_apu2_egt");
    p_dps_sm_sys_summ2.apu3_egt = device.svg.getElementById("p_dps_sm_sys_summ2_apu3_egt");
    
    p_dps_sm_sys_summ2.apu1_egt_bu = device.svg.getElementById("p_dps_sm_sys_summ2_apu1_egt_bu");
    p_dps_sm_sys_summ2.apu2_egt_bu = device.svg.getElementById("p_dps_sm_sys_summ2_apu2_egt_bu");
    p_dps_sm_sys_summ2.apu3_egt_bu = device.svg.getElementById("p_dps_sm_sys_summ2_apu3_egt_bu");
    
    p_dps_sm_sys_summ2.apu1_oil_in = device.svg.getElementById("p_dps_sm_sys_summ2_apu1_oil_in");
    p_dps_sm_sys_summ2.apu2_oil_in = device.svg.getElementById("p_dps_sm_sys_summ2_apu2_oil_in");
    p_dps_sm_sys_summ2.apu3_oil_in = device.svg.getElementById("p_dps_sm_sys_summ2_apu3_oil_in");
    
    p_dps_sm_sys_summ2.apu1_oil_out = device.svg.getElementById("p_dps_sm_sys_summ2_apu1_oil_out");
    p_dps_sm_sys_summ2.apu2_oil_out = device.svg.getElementById("p_dps_sm_sys_summ2_apu2_oil_out");
    p_dps_sm_sys_summ2.apu3_oil_out = device.svg.getElementById("p_dps_sm_sys_summ2_apu3_oil_out");
    
    p_dps_sm_sys_summ2.apu1_speed = device.svg.getElementById("p_dps_sm_sys_summ2_apu1_speed");
    p_dps_sm_sys_summ2.apu2_speed = device.svg.getElementById("p_dps_sm_sys_summ2_apu2_speed");
    p_dps_sm_sys_summ2.apu3_speed = device.svg.getElementById("p_dps_sm_sys_summ2_apu3_speed");
    
    p_dps_sm_sys_summ2.apu1_fuel = device.svg.getElementById("p_dps_sm_sys_summ2_apu1_fuel");
    p_dps_sm_sys_summ2.apu2_fuel = device.svg.getElementById("p_dps_sm_sys_summ2_apu2_fuel");
    p_dps_sm_sys_summ2.apu3_fuel = device.svg.getElementById("p_dps_sm_sys_summ2_apu3_fuel");
    
    p_dps_sm_sys_summ2.apu1_oil_p = device.svg.getElementById("p_dps_sm_sys_summ2_apu1_oil_p");
    p_dps_sm_sys_summ2.apu2_oil_p = device.svg.getElementById("p_dps_sm_sys_summ2_apu2_oil_p");
    p_dps_sm_sys_summ2.apu3_oil_p = device.svg.getElementById("p_dps_sm_sys_summ2_apu3_oil_p");
    
    p_dps_sm_sys_summ2.hyd1_p = device.svg.getElementById("p_dps_sm_sys_summ2_hyd1_p");
    p_dps_sm_sys_summ2.hyd2_p = device.svg.getElementById("p_dps_sm_sys_summ2_hyd2_p");
    p_dps_sm_sys_summ2.hyd3_p = device.svg.getElementById("p_dps_sm_sys_summ2_hyd3_p");
    
    p_dps_sm_sys_summ2.hyd1_rsvr_t = device.svg.getElementById("p_dps_sm_sys_summ2_hyd1_rsvr_t");
    p_dps_sm_sys_summ2.hyd2_rsvr_t = device.svg.getElementById("p_dps_sm_sys_summ2_hyd2_rsvr_t");
    p_dps_sm_sys_summ2.hyd3_rsvr_t = device.svg.getElementById("p_dps_sm_sys_summ2_hyd3_rsvr_t");
    
    p_dps_sm_sys_summ2.hyd1_rsvr_qty = device.svg.getElementById("p_dps_sm_sys_summ2_hyd1_rsvr_qty");
    p_dps_sm_sys_summ2.hyd2_rsvr_qty = device.svg.getElementById("p_dps_sm_sys_summ2_hyd2_rsvr_qty");
    p_dps_sm_sys_summ2.hyd3_rsvr_qty = device.svg.getElementById("p_dps_sm_sys_summ2_hyd3_rsvr_qty");
    
    p_dps_sm_sys_summ2.hyd1_rsvr_p = device.svg.getElementById("p_dps_sm_sys_summ2_hyd1_rsvr_p");
    p_dps_sm_sys_summ2.hyd2_rsvr_p = device.svg.getElementById("p_dps_sm_sys_summ2_hyd2_rsvr_p");
    p_dps_sm_sys_summ2.hyd3_rsvr_p = device.svg.getElementById("p_dps_sm_sys_summ2_hyd3_rsvr_p");
    
    p_dps_sm_sys_summ2.wb1_h2o_qty = device.svg.getElementById("p_dps_sm_sys_summ2_wb1_h2o_qty");
    p_dps_sm_sys_summ2.wb2_h2o_qty = device.svg.getElementById("p_dps_sm_sys_summ2_wb2_h2o_qty");
    p_dps_sm_sys_summ2.wb3_h2o_qty = device.svg.getElementById("p_dps_sm_sys_summ2_wb3_h2o_qty");
    
    p_dps_sm_sys_summ2.wb1_byp_vlv = device.svg.getElementById("p_dps_sm_sys_summ2_wb1_byp_vlv");
    p_dps_sm_sys_summ2.wb2_byp_vlv = device.svg.getElementById("p_dps_sm_sys_summ2_wb2_byp_vlv");
    p_dps_sm_sys_summ2.wb3_byp_vlv = device.svg.getElementById("p_dps_sm_sys_summ2_wb3_byp_vlv");
    
    
    p_dps_sm_sys_summ2.avbay1_t = device.svg.getElementById("p_dps_sm_sys_summ2_avbay1_t");
    p_dps_sm_sys_summ2.avbay2_t = device.svg.getElementById("p_dps_sm_sys_summ2_avbay2_t");
    p_dps_sm_sys_summ2.avbay3_t = device.svg.getElementById("p_dps_sm_sys_summ2_avbay3_t");
    

    p_dps_sm_sys_summ2.tk1_ph2 = device.svg.getElementById("p_dps_sm_sys_summ2_tk1_ph2");
    p_dps_sm_sys_summ2.tk2_ph2 = device.svg.getElementById("p_dps_sm_sys_summ2_tk2_ph2");
    p_dps_sm_sys_summ2.tk3_ph2 = device.svg.getElementById("p_dps_sm_sys_summ2_tk3_ph2");
    p_dps_sm_sys_summ2.tk4_ph2 = device.svg.getElementById("p_dps_sm_sys_summ2_tk4_ph2");
    p_dps_sm_sys_summ2.tk5_ph2 = device.svg.getElementById("p_dps_sm_sys_summ2_tk5_ph2");

    p_dps_sm_sys_summ2.mf1_ph2 = device.svg.getElementById("p_dps_sm_sys_summ2_mf1_ph2");
    p_dps_sm_sys_summ2.mf2_ph2 = device.svg.getElementById("p_dps_sm_sys_summ2_mf2_ph2");


    p_dps_sm_sys_summ2.tk1_po2 = device.svg.getElementById("p_dps_sm_sys_summ2_tk1_po2");
    p_dps_sm_sys_summ2.tk2_po2 = device.svg.getElementById("p_dps_sm_sys_summ2_tk2_po2");
    p_dps_sm_sys_summ2.tk3_po2 = device.svg.getElementById("p_dps_sm_sys_summ2_tk3_po2");
    p_dps_sm_sys_summ2.tk4_po2 = device.svg.getElementById("p_dps_sm_sys_summ2_tk4_po2");
    p_dps_sm_sys_summ2.tk5_po2 = device.svg.getElementById("p_dps_sm_sys_summ2_tk5_po2");
    
    p_dps_sm_sys_summ2.mf1_po2 = device.svg.getElementById("p_dps_sm_sys_summ2_mf1_po2");
    p_dps_sm_sys_summ2.mf2_po2 = device.svg.getElementById("p_dps_sm_sys_summ2_mf2_po2");

    p_dps_sm_sys_summ2.tk1_htrt1 = device.svg.getElementById("p_dps_sm_sys_summ2_tk1_htrt1");
    p_dps_sm_sys_summ2.tk2_htrt1 = device.svg.getElementById("p_dps_sm_sys_summ2_tk2_htrt1");
    p_dps_sm_sys_summ2.tk3_htrt1 = device.svg.getElementById("p_dps_sm_sys_summ2_tk3_htrt1");
    p_dps_sm_sys_summ2.tk4_htrt1 = device.svg.getElementById("p_dps_sm_sys_summ2_tk4_htrt1");
    p_dps_sm_sys_summ2.tk5_htrt1 = device.svg.getElementById("p_dps_sm_sys_summ2_tk5_htrt1");

    p_dps_sm_sys_summ2.tk1_htrt2 = device.svg.getElementById("p_dps_sm_sys_summ2_tk1_htrt2");
    p_dps_sm_sys_summ2.tk2_htrt2 = device.svg.getElementById("p_dps_sm_sys_summ2_tk2_htrt2");
    p_dps_sm_sys_summ2.tk3_htrt2 = device.svg.getElementById("p_dps_sm_sys_summ2_tk3_htrt2");
    p_dps_sm_sys_summ2.tk4_htrt2 = device.svg.getElementById("p_dps_sm_sys_summ2_tk4_htrt2");
    p_dps_sm_sys_summ2.tk5_htrt2 = device.svg.getElementById("p_dps_sm_sys_summ2_tk5_htrt2");

    p_dps_sm_sys_summ2.avbay1_fan = device.svg.getElementById("p_dps_sm_sys_summ2_avbay1_fan");
    p_dps_sm_sys_summ2.avbay2_fan = device.svg.getElementById("p_dps_sm_sys_summ2_avbay2_fan");



    p_dps_sm_sys_summ2.ondisplay = func
    {
        device.DPS_menu_title.setText("SM SYS SUMM 2");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/   /079";
        device.DPS_menu_ops.setText(ops_string);
    
    # set a few values not modeled explicitly to reasonable values
    
        p_dps_sm_sys_summ2.hyd1_rsvr_qty.setText(sprintf("  87")); 
        p_dps_sm_sys_summ2.hyd2_rsvr_qty.setText(sprintf("  86")); 
        p_dps_sm_sys_summ2.hyd3_rsvr_qty.setText(sprintf("  87")); 
    
        p_dps_sm_sys_summ2.hyd1_rsvr_p.setText(sprintf("  54")); 
        p_dps_sm_sys_summ2.hyd2_rsvr_p.setText(sprintf("  56")); 
        p_dps_sm_sys_summ2.hyd3_rsvr_p.setText(sprintf("  55")); 

	p_dps_sm_sys_summ2.tk1_ph2.setText(sprintf("208")); 
	p_dps_sm_sys_summ2.tk2_ph2.setText(sprintf("208")); 
	p_dps_sm_sys_summ2.tk3_ph2.setText(sprintf("206")); 
	p_dps_sm_sys_summ2.tk4_ph2.setText(sprintf("206")); 
	p_dps_sm_sys_summ2.tk5_ph2.setText(sprintf("206"));

	p_dps_sm_sys_summ2.mf1_ph2.setText(sprintf("208"));
	p_dps_sm_sys_summ2.mf2_ph2.setText(sprintf("207"));

	p_dps_sm_sys_summ2.tk1_po2.setText(sprintf(" 816")); 
	p_dps_sm_sys_summ2.tk2_po2.setText(sprintf(" 813")); 
	p_dps_sm_sys_summ2.tk3_po2.setText(sprintf(" 816")); 
	p_dps_sm_sys_summ2.tk4_po2.setText(sprintf(" 814")); 
	p_dps_sm_sys_summ2.tk5_po2.setText(sprintf(" 814")); 

	p_dps_sm_sys_summ2.mf1_po2.setText(sprintf(" 815"));
	p_dps_sm_sys_summ2.mf2_po2.setText(sprintf(" 815"));
    
   	p_dps_sm_sys_summ2.tk1_htrt1.setText(sprintf("-248")); 
   	p_dps_sm_sys_summ2.tk2_htrt1.setText(sprintf("-248")); 
   	p_dps_sm_sys_summ2.tk3_htrt1.setText(sprintf("-248")); 
   	p_dps_sm_sys_summ2.tk4_htrt1.setText(sprintf("-248")); 
   	p_dps_sm_sys_summ2.tk5_htrt1.setText(sprintf("-248")); 

  	p_dps_sm_sys_summ2.tk1_htrt2.setText(sprintf("-248")); 
   	p_dps_sm_sys_summ2.tk2_htrt2.setText(sprintf("-248")); 
   	p_dps_sm_sys_summ2.tk3_htrt2.setText(sprintf("-248")); 
   	p_dps_sm_sys_summ2.tk4_htrt2.setText(sprintf("-248")); 
   	p_dps_sm_sys_summ2.tk5_htrt2.setText(sprintf("-248")); 

	p_dps_sm_sys_summ2.avbay1_fan.setText("27.4"); 
	p_dps_sm_sys_summ2.avbay2_fan.setText("27.4"); 

    }
    
    p_dps_sm_sys_summ2.update = func
    {
    
        p_dps_sm_sys_summ2.apu1_egt.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu/egt-K")+1.0)));
        p_dps_sm_sys_summ2.apu2_egt.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[1]/egt-K")-1.0)));
        p_dps_sm_sys_summ2.apu3_egt.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[2]/egt-K"))));
    
        p_dps_sm_sys_summ2.apu1_egt_bu.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu/egt-K")-3.0)));
        p_dps_sm_sys_summ2.apu2_egt_bu.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[1]/egt-K")+1.0)));
        p_dps_sm_sys_summ2.apu3_egt_bu.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[2]/egt-K")-4.0)));
    
        p_dps_sm_sys_summ2.apu1_oil_in.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu/oil-in-T-K"))));
        p_dps_sm_sys_summ2.apu2_oil_in.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[1]/oil-in-T-K"))));
        p_dps_sm_sys_summ2.apu3_oil_in.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[2]/oil-in-T-K"))));
    
        p_dps_sm_sys_summ2.apu1_oil_out.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/apu1-temperature-K"))));
        p_dps_sm_sys_summ2.apu2_oil_out.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/apu2-temperature-K"))));
        p_dps_sm_sys_summ2.apu3_oil_out.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/apu3-temperature-K"))));
    
        p_dps_sm_sys_summ2.apu1_oil_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu/oil-p-psia")));
        p_dps_sm_sys_summ2.apu2_oil_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu[1]/oil-p-psia")));
        p_dps_sm_sys_summ2.apu3_oil_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu[2]/oil-p-psia")));
    
        p_dps_sm_sys_summ2.apu1_speed.setText(sprintf("%4.0f", 100.0 * getprop("/fdm/jsbsim/systems/apu/apu/apu-rpm-fraction")));
        p_dps_sm_sys_summ2.apu2_speed.setText(sprintf("%4.0f", 100.0 * getprop("/fdm/jsbsim/systems/apu/apu[1]/apu-rpm-fraction")));
        p_dps_sm_sys_summ2.apu3_speed.setText(sprintf("%4.0f", 100.0 * getprop("/fdm/jsbsim/systems/apu/apu[2]/apu-rpm-fraction")));
    
        p_dps_sm_sys_summ2.hyd1_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu/hyd-pressure-psia")));
        p_dps_sm_sys_summ2.hyd2_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-pressure-psia")));
        p_dps_sm_sys_summ2.hyd3_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-pressure-psia")));
    
        p_dps_sm_sys_summ2.hyd1_rsvr_t.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu/hyd-rsvr-T-K")-3.0))); 
        p_dps_sm_sys_summ2.hyd2_rsvr_t.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-rsvr-T-K")+1.0))); 
        p_dps_sm_sys_summ2.hyd3_rsvr_t.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-rsvr-T-K")))); 
    
    
        p_dps_sm_sys_summ2.apu1_fuel.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[14]/level-lbs")/3.5));
        p_dps_sm_sys_summ2.apu2_fuel.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[15]/level-lbs")/3.5));
        p_dps_sm_sys_summ2.apu3_fuel.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[16]/level-lbs")/3.5));
    
        p_dps_sm_sys_summ2.wb1_h2o_qty.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/propulsion/tank[20]/contents-lbs")/1.42)); 
        p_dps_sm_sys_summ2.wb2_h2o_qty.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/propulsion/tank[21]/contents-lbs")/1.42)); 
        p_dps_sm_sys_summ2.wb3_h2o_qty.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/propulsion/tank[22]/contents-lbs")/1.42));  
    
        p_dps_sm_sys_summ2.wb1_byp_vlv.setText(sprintf(" %s", wsb_vlv_to_string(getprop("/fdm/jsbsim/systems/thermal-distribution/spray-boiler-1-switch"))));
        p_dps_sm_sys_summ2.wb2_byp_vlv.setText(sprintf(" %s", wsb_vlv_to_string(getprop("/fdm/jsbsim/systems/thermal-distribution/spray-boiler-2-switch"))));
        p_dps_sm_sys_summ2.wb3_byp_vlv.setText(sprintf(" %s", wsb_vlv_to_string(getprop("/fdm/jsbsim/systems/thermal-distribution/spray-boiler-3-switch"))));
    
    
    
        p_dps_sm_sys_summ2.avbay1_t.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/avionics-temperature-K")-2.0))); 
        p_dps_sm_sys_summ2.avbay2_t.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/avionics-temperature-K")))); 
        p_dps_sm_sys_summ2.avbay3_t.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/avionics-temperature-K")+1.0))); 
    
    
    
    
        device.update_common_DPS();
    
    
    
    
    }
    
    return p_dps_sm_sys_summ2;
}
