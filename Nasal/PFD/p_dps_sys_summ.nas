#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_sys_summ
# Description: GNC systems summary page 1
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_dps_sys_summ = func(device)
{
    var p_dps_sys_summ = device.addPage("CRTGNC_SUM1", "p_dps_sys_summ");
    
    p_dps_sys_summ.f1_vlv = device.svg.getElementById("p_dps_sys_summ_f1_vlv");
    p_dps_sys_summ.f2_vlv = device.svg.getElementById("p_dps_sys_summ_f2_vlv");
    p_dps_sys_summ.f3_vlv = device.svg.getElementById("p_dps_sys_summ_f3_vlv");
    p_dps_sys_summ.f4_vlv = device.svg.getElementById("p_dps_sys_summ_f4_vlv");
    p_dps_sys_summ.f5_vlv = device.svg.getElementById("p_dps_sys_summ_f5_vlv");
    
    p_dps_sys_summ.f1_fail = device.svg.getElementById("p_dps_sys_summ_f1_fail");
    p_dps_sys_summ.f2_fail = device.svg.getElementById("p_dps_sys_summ_f2_fail");
    p_dps_sys_summ.f3_fail = device.svg.getElementById("p_dps_sys_summ_f3_fail");
    p_dps_sys_summ.f4_fail = device.svg.getElementById("p_dps_sys_summ_f4_fail");
    p_dps_sys_summ.f5_fail = device.svg.getElementById("p_dps_sys_summ_f5_fail");
    
    p_dps_sys_summ.l1_vlv = device.svg.getElementById("p_dps_sys_summ_l1_vlv");
    p_dps_sys_summ.l2_vlv = device.svg.getElementById("p_dps_sys_summ_l2_vlv");
    p_dps_sys_summ.l3_vlv = device.svg.getElementById("p_dps_sys_summ_l3_vlv");
    p_dps_sys_summ.l4_vlv = device.svg.getElementById("p_dps_sys_summ_l4_vlv");
    p_dps_sys_summ.l5_vlv = device.svg.getElementById("p_dps_sys_summ_l5_vlv");
    
    p_dps_sys_summ.l1_fail = device.svg.getElementById("p_dps_sys_summ_l1_fail");
    p_dps_sys_summ.l2_fail = device.svg.getElementById("p_dps_sys_summ_l2_fail");
    p_dps_sys_summ.l3_fail = device.svg.getElementById("p_dps_sys_summ_l3_fail");
    p_dps_sys_summ.l4_fail = device.svg.getElementById("p_dps_sys_summ_l4_fail");
    p_dps_sys_summ.l5_fail = device.svg.getElementById("p_dps_sys_summ_l5_fail");
    
    p_dps_sys_summ.r1_vlv = device.svg.getElementById("p_dps_sys_summ_r1_vlv");
    p_dps_sys_summ.r2_vlv = device.svg.getElementById("p_dps_sys_summ_r2_vlv");
    p_dps_sys_summ.r3_vlv = device.svg.getElementById("p_dps_sys_summ_r3_vlv");
    p_dps_sys_summ.r4_vlv = device.svg.getElementById("p_dps_sys_summ_r4_vlv");
    p_dps_sys_summ.r5_vlv = device.svg.getElementById("p_dps_sys_summ_r5_vlv");
    
    p_dps_sys_summ.r1_fail = device.svg.getElementById("p_dps_sys_summ_r1_fail");
    p_dps_sys_summ.r2_fail = device.svg.getElementById("p_dps_sys_summ_r2_fail");
    p_dps_sys_summ.r3_fail = device.svg.getElementById("p_dps_sys_summ_r3_fail");
    p_dps_sys_summ.r4_fail = device.svg.getElementById("p_dps_sys_summ_r4_fail");
    p_dps_sys_summ.r5_fail = device.svg.getElementById("p_dps_sys_summ_r5_fail");
    
    p_dps_sys_summ.pos_l_ob = device.svg.getElementById("p_dps_sys_summ_pos_l_ob");
    p_dps_sys_summ.pos_l_ib = device.svg.getElementById("p_dps_sys_summ_pos_l_ib");
    p_dps_sys_summ.pos_r_ob = device.svg.getElementById("p_dps_sys_summ_pos_r_ob");
    p_dps_sys_summ.pos_r_ib = device.svg.getElementById("p_dps_sys_summ_pos_r_ib");
    
    p_dps_sys_summ.mom_l_ob = device.svg.getElementById("p_dps_sys_summ_mom_l_ob");
    p_dps_sys_summ.mom_l_ib = device.svg.getElementById("p_dps_sys_summ_mom_l_ib");
    p_dps_sys_summ.mom_r_ob = device.svg.getElementById("p_dps_sys_summ_mom_r_ob");
    p_dps_sys_summ.mom_r_ib = device.svg.getElementById("p_dps_sys_summ_mom_r_ib");
    
    
    
    p_dps_sys_summ.pos_rud = device.svg.getElementById("p_dps_sys_summ_pos_rud");
    p_dps_sys_summ.pos_spdbrk = device.svg.getElementById("p_dps_sys_summ_pos_spdbrk");
    p_dps_sys_summ.pos_bdyflp = device.svg.getElementById("p_dps_sys_summ_pos_bdyflp");
    p_dps_sys_summ.pos_ail = device.svg.getElementById("p_dps_sys_summ_pos_ail");
    
    p_dps_sys_summ.bdyflp_msg = device.svg.getElementById("p_dps_sys_summ_bdyflp_msg");
    p_dps_sys_summ.rhc_l = device.svg.getElementById("p_dps_sys_summ_rhc_l");
    p_dps_sys_summ.rhc_r = device.svg.getElementById("p_dps_sys_summ_rhc_r");
    p_dps_sys_summ.rhc_a = device.svg.getElementById("p_dps_sys_summ_rhc_a");
    p_dps_sys_summ.thc_l = device.svg.getElementById("p_dps_sys_summ_thc_l");
    p_dps_sys_summ.thc_a = device.svg.getElementById("p_dps_sys_summ_thc_a");
    p_dps_sys_summ.sbtc_l = device.svg.getElementById("p_dps_sys_summ_sbtc_l");
    p_dps_sys_summ.sbtc_r = device.svg.getElementById("p_dps_sys_summ_sbtc_r");
    
    p_dps_sys_summ.gpc = device.svg.getElementById("p_dps_sys_summ_gpc");
    p_dps_sys_summ.mdm_ff = device.svg.getElementById("p_dps_sys_summ_mdm_ff");
    p_dps_sys_summ.mdm_fa = device.svg.getElementById("p_dps_sys_summ_mdm_fa");
    
    p_dps_sys_summ.fcs_ch = device.svg.getElementById("p_dps_sys_summ_fcs_ch");
    p_dps_sys_summ.imu = device.svg.getElementById("p_dps_sys_summ_imu");
    p_dps_sys_summ.acc = device.svg.getElementById("p_dps_sys_summ_acc");
    p_dps_sys_summ.rga = device.svg.getElementById("p_dps_sys_summ_rga");
    p_dps_sys_summ.tac = device.svg.getElementById("p_dps_sys_summ_tac");
    p_dps_sys_summ.mls = device.svg.getElementById("p_dps_sys_summ_mls");
    p_dps_sys_summ.adta = device.svg.getElementById("p_dps_sys_summ_adta");
    
    
    
    p_dps_sys_summ.ondisplay = func
    {
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/   /018";
    
    
        device.DPS_menu_title.setText("GNC SYS SUMM 1");
        device.DPS_menu_ops.setText(ops_string);
        device.MEDS_menu_title.setText("       DPS MENU");
    
    # for the moment, we blank failure messages where we can't simulate the mode yet
    
        p_dps_sys_summ.bdyflp_msg.setText(sprintf(""));
        p_dps_sys_summ.rhc_l.setText(sprintf(""));
        p_dps_sys_summ.rhc_r.setText(sprintf(""));
        p_dps_sys_summ.rhc_a.setText(sprintf(""));
        p_dps_sys_summ.thc_l.setText(sprintf(""));
        p_dps_sys_summ.thc_a.setText(sprintf(""));
        p_dps_sys_summ.sbtc_l.setText(sprintf(""));
        p_dps_sys_summ.sbtc_r.setText(sprintf(""));
    
        p_dps_sys_summ.gpc.setText(sprintf(""));
        p_dps_sys_summ.mdm_ff.setText(sprintf(""));
        p_dps_sys_summ.mdm_fa.setText(sprintf(""));
    
        p_dps_sys_summ.fcs_ch.setText(sprintf(""));
        p_dps_sys_summ.imu.setText(sprintf(""));
        p_dps_sys_summ.acc.setText(sprintf(""));
        p_dps_sys_summ.rga.setText(sprintf(""));
        p_dps_sys_summ.tac.setText(sprintf(""));
        p_dps_sys_summ.mls.setText(sprintf(""));
        p_dps_sys_summ.adta.setText(sprintf(""));
    }
    
    p_dps_sys_summ.update = func
    {
    
    
        device.update_common_DPS();
    
    
    
        p_dps_sys_summ.r1_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-1-status")));
        p_dps_sys_summ.r2_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-2-status")));
        p_dps_sys_summ.r3_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-3-status")));
        p_dps_sys_summ.r4_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-4-status")));
        p_dps_sys_summ.r5_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-5-status")));
    
        p_dps_sys_summ.r1_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-r1")));
        p_dps_sys_summ.r2_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-r2")));
        p_dps_sys_summ.r3_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-r3")));
        p_dps_sys_summ.r4_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-r4")));
        p_dps_sys_summ.r5_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-r5")));
    
        p_dps_sys_summ.l1_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-1-status")));
        p_dps_sys_summ.l2_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-2-status")));
        p_dps_sys_summ.l3_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-3-status")));
        p_dps_sys_summ.l4_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-4-status")));
        p_dps_sys_summ.l5_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-5-status")));
    
        p_dps_sys_summ.l1_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-l1")));
        p_dps_sys_summ.l2_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-l2")));
        p_dps_sys_summ.l3_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-l3")));
        p_dps_sys_summ.l4_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-l4")));
        p_dps_sys_summ.l5_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-l5")));
    
        p_dps_sys_summ.f1_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-1-status")));
        p_dps_sys_summ.f2_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-2-status")));
        p_dps_sys_summ.f3_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-3-status")));
        p_dps_sys_summ.f4_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-4-status")));
        p_dps_sys_summ.f5_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-5-status")));
    
        p_dps_sys_summ.f1_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-f1")));
        p_dps_sys_summ.f2_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-f2")));
        p_dps_sys_summ.f3_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-f3")));
        p_dps_sys_summ.f4_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-f4")));
        p_dps_sys_summ.f5_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-f5")));
    
        p_dps_sys_summ.pos_l_ob.setText(sprintf("%2.1f", getprop("/fdm/jsbsim/fcs/outboard-elevon-left-pos-deg")));
        p_dps_sys_summ.pos_l_ib.setText(sprintf("%2.1f", getprop("/fdm/jsbsim/fcs/inboard-elevon-left-pos-deg")));
        p_dps_sys_summ.pos_r_ob.setText(sprintf("%2.1f", getprop("/fdm/jsbsim/fcs/outboard-elevon-right-pos-deg"))); 
        p_dps_sys_summ.pos_r_ib.setText(sprintf("%2.1f", getprop("/fdm/jsbsim/fcs/inboard-elevon-right-pos-deg")));
    
        p_dps_sys_summ.mom_l_ob.setText(sprintf("%2.1f", elevon_norm(getprop("/fdm/jsbsim/fcs/outboard-elevon-left-pos-deg"))));
        p_dps_sys_summ.mom_l_ib.setText(sprintf("%2.1f", elevon_norm(getprop("/fdm/jsbsim/fcs/inboard-elevon-left-pos-deg"))));
        p_dps_sys_summ.mom_r_ob.setText(sprintf("%2.1f", elevon_norm(getprop("/fdm/jsbsim/fcs/outboard-elevon-right-pos-deg"))));
        p_dps_sys_summ.mom_r_ib.setText(sprintf("%2.1f", elevon_norm(getprop("/fdm/jsbsim/fcs/inboard-elevon-right-pos-deg"))));
    
        p_dps_sys_summ.pos_rud.setText(sprintf("%2.1f", 57.2974 * getprop("/fdm/jsbsim/fcs/rudder-pos-rad")));
        p_dps_sys_summ.pos_spdbrk.setText(sprintf("%2.1f", 100.0 * getprop("/fdm/jsbsim/fcs/speedbrake-pos-norm")));
        p_dps_sys_summ.pos_bdyflp.setText(sprintf("%2.1f", 57.2974 * getprop("/fdm/jsbsim/fcs/bodyflap-pos-rad")));
        p_dps_sys_summ.pos_ail.setText(sprintf("%2.1f", 57.2974 * getprop("/fdm/jsbsim/fcs/left-aileron-pos-rad")));
    }
    
    
    return p_dps_sys_summ;
}
