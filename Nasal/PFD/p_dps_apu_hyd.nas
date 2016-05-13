#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_apu_hyd
# Description: the APU/HYD page
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_dps_apu_hyd = func(device)
{
    var p_dps_apu_hyd = device.addPage("CRTApuHyd", "p_dps_apu_hyd");
    
    p_dps_apu_hyd.group = device.svg.getElementById("p_dps_apu_hyd");
    p_dps_apu_hyd.group.setColor(dps_r, dps_g, dps_b);

    p_dps_apu_hyd.speed_pct_1 = device.svg.getElementById("p_dps_apu_hyd_speed_pct_1");
    p_dps_apu_hyd.speed_pct_2 = device.svg.getElementById("p_dps_apu_hyd_speed_pct_2");
    p_dps_apu_hyd.speed_pct_3 = device.svg.getElementById("p_dps_apu_hyd_speed_pct_3");
    
    p_dps_apu_hyd.fuel_qty_1 = device.svg.getElementById("p_dps_apu_hyd_fuel_qty_1");
    p_dps_apu_hyd.fuel_qty_2 = device.svg.getElementById("p_dps_apu_hyd_fuel_qty_2");
    p_dps_apu_hyd.fuel_qty_3 = device.svg.getElementById("p_dps_apu_hyd_fuel_qty_3");
    
    p_dps_apu_hyd.vlv_a_1 = device.svg.getElementById("p_dps_apu_hyd_vlv_a_1");
    p_dps_apu_hyd.vlv_a_2 = device.svg.getElementById("p_dps_apu_hyd_vlv_a_2");
    p_dps_apu_hyd.vlv_a_3 = device.svg.getElementById("p_dps_apu_hyd_vlv_a_3");
    
    p_dps_apu_hyd.vlv_b_1 = device.svg.getElementById("p_dps_apu_hyd_vlv_b_1");
    p_dps_apu_hyd.vlv_b_2 = device.svg.getElementById("p_dps_apu_hyd_vlv_b_2");
    p_dps_apu_hyd.vlv_b_3 = device.svg.getElementById("p_dps_apu_hyd_vlv_b_3");
    
    p_dps_apu_hyd.oil_t_1 = device.svg.getElementById("p_dps_apu_hyd_oil_t_1");
    p_dps_apu_hyd.oil_t_2 = device.svg.getElementById("p_dps_apu_hyd_oil_t_2");
    p_dps_apu_hyd.oil_t_3 = device.svg.getElementById("p_dps_apu_hyd_oil_t_3");
    
    p_dps_apu_hyd.oil_outt_1 = device.svg.getElementById("p_dps_apu_hyd_oil_outt_1");
    p_dps_apu_hyd.oil_outt_2 = device.svg.getElementById("p_dps_apu_hyd_oil_outt_2");
    p_dps_apu_hyd.oil_outt_3 = device.svg.getElementById("p_dps_apu_hyd_oil_outt_3");
    
    p_dps_apu_hyd.bu_p_1 = device.svg.getElementById("p_dps_apu_hyd_bu_p_1");
    p_dps_apu_hyd.bu_p_2 = device.svg.getElementById("p_dps_apu_hyd_bu_p_2");
    p_dps_apu_hyd.bu_p_3 = device.svg.getElementById("p_dps_apu_hyd_bu_p_3");
    
    p_dps_apu_hyd.h2o_1 = device.svg.getElementById("p_dps_apu_hyd_h2o_1");
    p_dps_apu_hyd.h2o_2 = device.svg.getElementById("p_dps_apu_hyd_h2o_2");
    p_dps_apu_hyd.h2o_3 = device.svg.getElementById("p_dps_apu_hyd_h2o_3");
    
    p_dps_apu_hyd.cntlr_1 = device.svg.getElementById("p_dps_apu_hyd_cntlr_1");
    p_dps_apu_hyd.cntlr_2 = device.svg.getElementById("p_dps_apu_hyd_cntlr_2");
    p_dps_apu_hyd.cntlr_3 = device.svg.getElementById("p_dps_apu_hyd_cntlr_3");
    
    p_dps_apu_hyd.bu_egt_1 = device.svg.getElementById("p_dps_apu_hyd_bu_egt_1");
    p_dps_apu_hyd.bu_egt_2 = device.svg.getElementById("p_dps_apu_hyd_bu_egt_2");
    p_dps_apu_hyd.bu_egt_3 = device.svg.getElementById("p_dps_apu_hyd_bu_egt_3");
    
    p_dps_apu_hyd.egt_1 = device.svg.getElementById("p_dps_apu_hyd_egt_1");
    p_dps_apu_hyd.egt_2 = device.svg.getElementById("p_dps_apu_hyd_egt_2");
    p_dps_apu_hyd.egt_3 = device.svg.getElementById("p_dps_apu_hyd_egt_3");
    
    p_dps_apu_hyd.n2_p_1 = device.svg.getElementById("p_dps_apu_hyd_n2_p_1");
    p_dps_apu_hyd.n2_p_2 = device.svg.getElementById("p_dps_apu_hyd_n2_p_2");
    p_dps_apu_hyd.n2_p_3 = device.svg.getElementById("p_dps_apu_hyd_n2_p_3");
    
    p_dps_apu_hyd.wsb_n2_p_1 = device.svg.getElementById("p_dps_apu_hyd_wsb_n2_p_1");
    p_dps_apu_hyd.wsb_n2_p_2 = device.svg.getElementById("p_dps_apu_hyd_wsb_n2_p_2");
    p_dps_apu_hyd.wsb_n2_p_3 = device.svg.getElementById("p_dps_apu_hyd_wsb_n2_p_3");
    
    p_dps_apu_hyd.accum_p_1 = device.svg.getElementById("p_dps_apu_hyd_accum_p_1");
    p_dps_apu_hyd.accum_p_2 = device.svg.getElementById("p_dps_apu_hyd_accum_p_2");
    p_dps_apu_hyd.accum_p_3 = device.svg.getElementById("p_dps_apu_hyd_accum_p_3");
    
    p_dps_apu_hyd.vlv_at_1 = device.svg.getElementById("p_dps_apu_hyd_vlv_at_1");
    p_dps_apu_hyd.vlv_at_2 = device.svg.getElementById("p_dps_apu_hyd_vlv_at_2");
    p_dps_apu_hyd.vlv_at_3 = device.svg.getElementById("p_dps_apu_hyd_vlv_at_3");
    
    p_dps_apu_hyd.vlv_bt_1 = device.svg.getElementById("p_dps_apu_hyd_vlv_bt_1");
    p_dps_apu_hyd.vlv_bt_2 = device.svg.getElementById("p_dps_apu_hyd_vlv_bt_2");
    p_dps_apu_hyd.vlv_bt_3 = device.svg.getElementById("p_dps_apu_hyd_vlv_bt_3");
    
    p_dps_apu_hyd.rsvr_t_1 = device.svg.getElementById("p_dps_apu_hyd_rsvr_t_1");
    p_dps_apu_hyd.rsvr_t_2 = device.svg.getElementById("p_dps_apu_hyd_rsvr_t_2");
    p_dps_apu_hyd.rsvr_t_3 = device.svg.getElementById("p_dps_apu_hyd_rsvr_t_3");
    
    p_dps_apu_hyd.ggbed_t_1 = device.svg.getElementById("p_dps_apu_hyd_ggbed_t_1");
    p_dps_apu_hyd.ggbed_t_2 = device.svg.getElementById("p_dps_apu_hyd_ggbed_t_2");
    p_dps_apu_hyd.ggbed_t_3 = device.svg.getElementById("p_dps_apu_hyd_ggbed_t_3");
    
    p_dps_apu_hyd.tank_t_1 = device.svg.getElementById("p_dps_apu_hyd_tank_t_1");
    p_dps_apu_hyd.tank_t_2 = device.svg.getElementById("p_dps_apu_hyd_tank_t_2");
    p_dps_apu_hyd.tank_t_3 = device.svg.getElementById("p_dps_apu_hyd_tank_t_3");
    
    p_dps_apu_hyd.blr_t_1 = device.svg.getElementById("p_dps_apu_hyd_blr_t_1");
    p_dps_apu_hyd.blr_t_2 = device.svg.getElementById("p_dps_apu_hyd_blr_t_2");
    p_dps_apu_hyd.blr_t_3 = device.svg.getElementById("p_dps_apu_hyd_blr_t_3");
    
    p_dps_apu_hyd.reg_p_1 = device.svg.getElementById("p_dps_apu_hyd_reg_p_1");
    p_dps_apu_hyd.reg_p_2 = device.svg.getElementById("p_dps_apu_hyd_reg_p_2");
    p_dps_apu_hyd.reg_p_3 = device.svg.getElementById("p_dps_apu_hyd_reg_p_3");
    
    p_dps_apu_hyd.n2_t_1 = device.svg.getElementById("p_dps_apu_hyd_n2_t_1");
    p_dps_apu_hyd.n2_t_2 = device.svg.getElementById("p_dps_apu_hyd_n2_t_2");
    p_dps_apu_hyd.n2_t_3 = device.svg.getElementById("p_dps_apu_hyd_n2_t_3");
    
    p_dps_apu_hyd.vent_t_1 = device.svg.getElementById("p_dps_apu_hyd_vent_t_1");
    p_dps_apu_hyd.vent_t_2 = device.svg.getElementById("p_dps_apu_hyd_vent_t_2");
    p_dps_apu_hyd.vent_t_3 = device.svg.getElementById("p_dps_apu_hyd_vent_t_3");
    
    p_dps_apu_hyd.rsvr_qty_1 = device.svg.getElementById("p_dps_apu_hyd_rsvr_qty_1");
    p_dps_apu_hyd.rsvr_qty_2 = device.svg.getElementById("p_dps_apu_hyd_rsvr_qty_2");
    p_dps_apu_hyd.rsvr_qty_3 = device.svg.getElementById("p_dps_apu_hyd_rsvr_qty_3");
    
    p_dps_apu_hyd.rsvr_p_1 = device.svg.getElementById("p_dps_apu_hyd_rsvr_p_1");
    p_dps_apu_hyd.rsvr_p_2 = device.svg.getElementById("p_dps_apu_hyd_rsvr_p_2");
    p_dps_apu_hyd.rsvr_p_3 = device.svg.getElementById("p_dps_apu_hyd_rsvr_p_3");
    
    p_dps_apu_hyd.tk_p_1 = device.svg.getElementById("p_dps_apu_hyd_tk_p_1");
    p_dps_apu_hyd.tk_p_2 = device.svg.getElementById("p_dps_apu_hyd_tk_p_2");
    p_dps_apu_hyd.tk_p_3 = device.svg.getElementById("p_dps_apu_hyd_tk_p_3");
    
    p_dps_apu_hyd.out_p_1 = device.svg.getElementById("p_dps_apu_hyd_out_p_1");
    p_dps_apu_hyd.out_p_2 = device.svg.getElementById("p_dps_apu_hyd_out_p_2");
    p_dps_apu_hyd.out_p_3 = device.svg.getElementById("p_dps_apu_hyd_out_p_3");
    
    p_dps_apu_hyd.pmp_t_1 = device.svg.getElementById("p_dps_apu_hyd_pmp_t_1");
    p_dps_apu_hyd.pmp_t_2 = device.svg.getElementById("p_dps_apu_hyd_pmp_t_2");
    p_dps_apu_hyd.pmp_t_3 = device.svg.getElementById("p_dps_apu_hyd_pmp_t_3");
    
    p_dps_apu_hyd.vlv_t_1 = device.svg.getElementById("p_dps_apu_hyd_vlv_t_1");
    p_dps_apu_hyd.vlv_t_2 = device.svg.getElementById("p_dps_apu_hyd_vlv_t_2");
    p_dps_apu_hyd.vlv_t_3 = device.svg.getElementById("p_dps_apu_hyd_vlv_t_3");
    
    p_dps_apu_hyd.oil_outp_1 = device.svg.getElementById("p_dps_apu_hyd_oil_outp_1");
    p_dps_apu_hyd.oil_outp_2 = device.svg.getElementById("p_dps_apu_hyd_oil_outp_2");
    p_dps_apu_hyd.oil_outp_3 = device.svg.getElementById("p_dps_apu_hyd_oil_outp_3");
    
    p_dps_apu_hyd.gbx_p_1 = device.svg.getElementById("p_dps_apu_hyd_gbx_p_1");
    p_dps_apu_hyd.gbx_p_2 = device.svg.getElementById("p_dps_apu_hyd_gbx_p_2");
    p_dps_apu_hyd.gbx_p_3 = device.svg.getElementById("p_dps_apu_hyd_gbx_p_3");
    
    p_dps_apu_hyd.byp_vlv_1 = device.svg.getElementById("p_dps_apu_hyd_byp_vlv_1");
    p_dps_apu_hyd.byp_vlv_2 = device.svg.getElementById("p_dps_apu_hyd_byp_vlv_2");
    p_dps_apu_hyd.byp_vlv_3 = device.svg.getElementById("p_dps_apu_hyd_byp_vlv_3");
    
    p_dps_apu_hyd.brg_t_1 = device.svg.getElementById("p_dps_apu_hyd_brg_t_1");
    p_dps_apu_hyd.brg_t_2 = device.svg.getElementById("p_dps_apu_hyd_brg_t_2");
    p_dps_apu_hyd.brg_t_3 = device.svg.getElementById("p_dps_apu_hyd_brg_t_3");
    
    
    
    
    p_dps_apu_hyd.ondisplay = func
    {
        device.DPS_menu_title.setText("APU/HYD");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/   /086";
        device.DPS_menu_ops.setText(ops_string);
    
    # set a few things we don't model explicitly to reasonable values
    
        p_dps_apu_hyd.n2_p_1.setText(sprintf(" 140"));
        p_dps_apu_hyd.n2_p_2.setText(sprintf(" 142"));
        p_dps_apu_hyd.n2_p_3.setText(sprintf(" 141")); 
    
        p_dps_apu_hyd.wsb_n2_p_1.setText(sprintf("2499"));
        p_dps_apu_hyd.wsb_n2_p_2.setText(sprintf("2505"));
        p_dps_apu_hyd.wsb_n2_p_3.setText(sprintf("2501")); 
    
        p_dps_apu_hyd.vlv_at_1.setText(sprintf("  62"));
        p_dps_apu_hyd.vlv_at_2.setText(sprintf("  60"));
        p_dps_apu_hyd.vlv_at_3.setText(sprintf("  61"));
    
        p_dps_apu_hyd.vlv_bt_1.setText(sprintf("  61"));
        p_dps_apu_hyd.vlv_bt_2.setText(sprintf("  61"));
        p_dps_apu_hyd.vlv_bt_3.setText(sprintf("  60"));
    
        p_dps_apu_hyd.tank_t_1.setText(sprintf("  59"));
        p_dps_apu_hyd.tank_t_2.setText(sprintf("  60"));
        p_dps_apu_hyd.tank_t_3.setText(sprintf("  57"));
    
        p_dps_apu_hyd.blr_t_1.setText(sprintf("  65")); 
        p_dps_apu_hyd.blr_t_2.setText(sprintf("  64")); 
        p_dps_apu_hyd.blr_t_3.setText(sprintf("  65"));
    
        p_dps_apu_hyd.reg_p_1.setText(sprintf("  25")); 
        p_dps_apu_hyd.reg_p_2.setText(sprintf("  27")); 
        p_dps_apu_hyd.reg_p_3.setText(sprintf("  26")); 
    
        p_dps_apu_hyd.n2_t_1.setText(sprintf("  59")); 
        p_dps_apu_hyd.n2_t_2.setText(sprintf("  61")); 
        p_dps_apu_hyd.n2_t_3.setText(sprintf("  61")); 
    
        p_dps_apu_hyd.rsvr_qty_1.setText(sprintf("  87")); 
        p_dps_apu_hyd.rsvr_qty_2.setText(sprintf("  86")); 
        p_dps_apu_hyd.rsvr_qty_3.setText(sprintf("  87")); 
    
        p_dps_apu_hyd.rsvr_p_1.setText(sprintf("  54")); 
        p_dps_apu_hyd.rsvr_p_2.setText(sprintf("  56")); 
        p_dps_apu_hyd.rsvr_p_3.setText(sprintf("  55")); 
    
        p_dps_apu_hyd.tk_p_1.setText(sprintf(" 210")); 
        p_dps_apu_hyd.tk_p_2.setText(sprintf(" 214")); 
        p_dps_apu_hyd.tk_p_3.setText(sprintf(" 211")); 
    
        p_dps_apu_hyd.out_p_1.setText(sprintf(" 210")); 
        p_dps_apu_hyd.out_p_2.setText(sprintf(" 214")); 
        p_dps_apu_hyd.out_p_3.setText(sprintf(" 211")); 
    
    }
    
    p_dps_apu_hyd.update = func
    {
    
        p_dps_apu_hyd.speed_pct_1.setText(sprintf("%4.0f", 100.0 * getprop("/fdm/jsbsim/systems/apu/apu/apu-rpm-fraction")));
        p_dps_apu_hyd.speed_pct_2.setText(sprintf("%4.0f", 100.0 * getprop("/fdm/jsbsim/systems/apu/apu[1]/apu-rpm-fraction")));
        p_dps_apu_hyd.speed_pct_3.setText(sprintf("%4.0f", 100.0 * getprop("/fdm/jsbsim/systems/apu/apu[2]/apu-rpm-fraction")));
    
    
        p_dps_apu_hyd.fuel_qty_1.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[14]/level-lbs")/3.5));
        p_dps_apu_hyd.fuel_qty_2.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[15]/level-lbs")/3.5));
        p_dps_apu_hyd.fuel_qty_3.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[16]/level-lbs")/3.5));
    
        p_dps_apu_hyd.vlv_a_1.setText(sprintf("  %s", valve_status_to_string(getprop("/fdm/jsbsim/systems/apu/apu/fuel-valve-status"))));
        p_dps_apu_hyd.vlv_a_2.setText(sprintf("  %s", valve_status_to_string(getprop("/fdm/jsbsim/systems/apu/apu[1]/fuel-valve-status"))));
        p_dps_apu_hyd.vlv_a_3.setText(sprintf("  %s", valve_status_to_string(getprop("/fdm/jsbsim/systems/apu/apu[2]/fuel-valve-status"))));
    
        p_dps_apu_hyd.vlv_b_1.setText(sprintf("  %s", valve_status_to_string(getprop("/fdm/jsbsim/systems/apu/apu/fuel-valve-status"))));
        p_dps_apu_hyd.vlv_b_2.setText(sprintf("  %s", valve_status_to_string(getprop("/fdm/jsbsim/systems/apu/apu[1]/fuel-valve-status"))));
        p_dps_apu_hyd.vlv_b_3.setText(sprintf("  %s", valve_status_to_string(getprop("/fdm/jsbsim/systems/apu/apu[2]/fuel-valve-status"))));
    
        p_dps_apu_hyd.oil_t_1.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu/oil-in-T-K"))));
        p_dps_apu_hyd.oil_t_2.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[1]/oil-in-T-K"))));
        p_dps_apu_hyd.oil_t_3.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[2]/oil-in-T-K"))));
    
        p_dps_apu_hyd.oil_outt_1.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/apu1-temperature-K"))));
        p_dps_apu_hyd.oil_outt_2.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/apu2-temperature-K"))));
        p_dps_apu_hyd.oil_outt_3.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/apu3-temperature-K"))));
    
        p_dps_apu_hyd.bu_p_1.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu/hyd-pressure-psia")));
        p_dps_apu_hyd.bu_p_2.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-pressure-psia")));
        p_dps_apu_hyd.bu_p_3.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-pressure-psia")));
    
        p_dps_apu_hyd.h2o_1.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/propulsion/tank[20]/contents-lbs")/1.42)); 
        p_dps_apu_hyd.h2o_2.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/propulsion/tank[21]/contents-lbs")/1.42)); 
        p_dps_apu_hyd.h2o_3.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/propulsion/tank[22]/contents-lbs")/1.42));  
    
        p_dps_apu_hyd.cntlr_1.setText(sprintf(" %s", wsb_ctrl_to_string(getprop("/fdm/jsbsim/systems/apu/apu/boiler-power-status"))));
        p_dps_apu_hyd.cntlr_2.setText(sprintf(" %s", wsb_ctrl_to_string(getprop("/fdm/jsbsim/systems/apu/apu[1]/boiler-power-status"))));
        p_dps_apu_hyd.cntlr_3.setText(sprintf(" %s", wsb_ctrl_to_string(getprop("/fdm/jsbsim/systems/apu/apu[2]/boiler-power-status"))));
    
        p_dps_apu_hyd.bu_egt_1.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu/egt-K")-3.0)));
        p_dps_apu_hyd.bu_egt_2.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[1]/egt-K")+1.0)));
        p_dps_apu_hyd.bu_egt_3.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[2]/egt-K")-4.0)));
    
        p_dps_apu_hyd.egt_1.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu/egt-K")+1.0)));
        p_dps_apu_hyd.egt_2.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[1]/egt-K")-1.0)));
        p_dps_apu_hyd.egt_3.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[2]/egt-K"))));
    
        p_dps_apu_hyd.accum_p_1.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu/hyd-acc-pressure-psia")));
        p_dps_apu_hyd.accum_p_2.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-acc-pressure-psia")));
        p_dps_apu_hyd.accum_p_3.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-acc-pressure-psia")));
    
        p_dps_apu_hyd.rsvr_t_1.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu/hyd-rsvr-T-K")-3.0))); 
        p_dps_apu_hyd.rsvr_t_2.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-rsvr-T-K")+1.0))); 
        p_dps_apu_hyd.rsvr_t_3.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-rsvr-T-K")))); 
    
        var ggbed_T1 = getprop("/fdm/jsbsim/systems/apu/apu/gg-bed-T-K");
        var ggbed_T1_sym = "";
        if (ggbed_T1 > 540) {ggbed_T1_sym = "H"; ggbed_T1 = 540.0;}
    
        var ggbed_T2 = getprop("/fdm/jsbsim/systems/apu/apu[1]/gg-bed-T-K");
        var ggbed_T2_sym = "";
        if (ggbed_T2 > 540) {ggbed_T2_sym = "H"; ggbed_T2 = 540.0;}
    
        var ggbed_T3 = getprop("/fdm/jsbsim/systems/apu/apu[2]/gg-bed-T-K");
        var ggbed_T3_sym = "";
        if (ggbed_T3 > 540) {ggbed_T3_sym = "H"; ggbed_T3 = 540.0;}
    
        p_dps_apu_hyd.ggbed_t_1.setText(sprintf("%4.0f%s", K_to_F(ggbed_T1), ggbed_T1_sym));
        p_dps_apu_hyd.ggbed_t_2.setText(sprintf("%4.0f%s", K_to_F(ggbed_T2-1.0), ggbed_T2_sym));
        p_dps_apu_hyd.ggbed_t_3.setText(sprintf("%4.0f%s", K_to_F(ggbed_T3+3.0), ggbed_T3_sym));
    
    
        p_dps_apu_hyd.vent_t_1.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu/steam-vent-T-K")-3.0))); 
        p_dps_apu_hyd.vent_t_2.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[1]/steam-vent-T-K")))); 
        p_dps_apu_hyd.vent_t_3.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[2]/steam-vent-T-K")+1.0))); 
    
        p_dps_apu_hyd.pmp_t_1.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu/fuel-pump-T-K")-1.0))); 
        p_dps_apu_hyd.pmp_t_2.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[1]/fuel-pump-T-K")+3.0))); 
        p_dps_apu_hyd.pmp_t_3.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[2]/fuel-pump-T-K")+2.0))); 
    
        p_dps_apu_hyd.vlv_t_1.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu/fuel-pump-T-K")+2.0))); 
        p_dps_apu_hyd.vlv_t_2.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[1]/fuel-pump-T-K")-1.0))); 
        p_dps_apu_hyd.vlv_t_3.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[2]/fuel-pump-T-K")-1.0))); 
    
        p_dps_apu_hyd.oil_outp_1.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu/oil-p-psia")));
        p_dps_apu_hyd.oil_outp_2.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu[1]/oil-p-psia")));
        p_dps_apu_hyd.oil_outp_3.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu[2]/oil-p-psia")));
    
        p_dps_apu_hyd.gbx_p_1.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu/oil-p-psia")-1.0));
        p_dps_apu_hyd.gbx_p_2.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu[1]/oil-p-psia")-2.0));
        p_dps_apu_hyd.gbx_p_3.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu[2]/oil-p-psia")-1.0));
    
        p_dps_apu_hyd.byp_vlv_1.setText(sprintf(" %s", wsb_vlv_to_string(getprop("/fdm/jsbsim/systems/thermal-distribution/spray-boiler-1-switch"))));
        p_dps_apu_hyd.byp_vlv_2.setText(sprintf(" %s", wsb_vlv_to_string(getprop("/fdm/jsbsim/systems/thermal-distribution/spray-boiler-2-switch"))));
        p_dps_apu_hyd.byp_vlv_3.setText(sprintf(" %s", wsb_vlv_to_string(getprop("/fdm/jsbsim/systems/thermal-distribution/spray-boiler-3-switch"))));
    
        p_dps_apu_hyd.brg_t_1.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu/hyd-rsvr-T-K")+3.0)));
        p_dps_apu_hyd.brg_t_2.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-rsvr-T-K")+4.0)));
        p_dps_apu_hyd.brg_t_3.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-rsvr-T-K")+1.0)));
    
        device.update_common_DPS();
    
    
    }
    
    
    
    return p_dps_apu_hyd;
}
