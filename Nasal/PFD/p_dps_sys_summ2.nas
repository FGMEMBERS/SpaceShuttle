#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_sys_summ2
# Description: GNC systems summary page 2
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_dps_sys_summ2 = func(device)
{
    var p_dps_sys_summ2 = device.addPage("CRTGNC_SUM2", "p_dps_sys_summ2");
    
    
    p_dps_sys_summ2.fwd_rcs_fu_qty = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_fu_qty");
    p_dps_sys_summ2.fwd_rcs_oxid_qty = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_oxid_qty");
    
    p_dps_sys_summ2.left_rcs_fu_qty = device.svg.getElementById("p_dps_sys_summ2_left_rcs_fu_qty");
    p_dps_sys_summ2.left_rcs_oxid_qty = device.svg.getElementById("p_dps_sys_summ2_left_rcs_oxid_qty");
    
    p_dps_sys_summ2.right_rcs_fu_qty = device.svg.getElementById("p_dps_sys_summ2_right_rcs_fu_qty");
    p_dps_sys_summ2.right_rcs_oxid_qty = device.svg.getElementById("p_dps_sys_summ2_right_rcs_oxid_qty");
    
    p_dps_sys_summ2.left_oms_fu_qty = device.svg.getElementById("p_dps_sys_summ2_fu_l");
    p_dps_sys_summ2.left_oms_oxid_qty = device.svg.getElementById("p_dps_sys_summ2_oxid_l");
    
    p_dps_sys_summ2.right_oms_fu_qty = device.svg.getElementById("p_dps_sys_summ2_fu_r");
    p_dps_sys_summ2.right_oms_oxid_qty = device.svg.getElementById("p_dps_sys_summ2_oxid_r");
    
    
    
    p_dps_sys_summ2.f1_vlv = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_manf1_isol");
    p_dps_sys_summ2.f2_vlv = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_manf2_isol");
    p_dps_sys_summ2.f3_vlv = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_manf3_isol");
    p_dps_sys_summ2.f4_vlv = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_manf4_isol");
    p_dps_sys_summ2.f5_vlv = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_manf5_isol");
    
    p_dps_sys_summ2.f1_fail = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_manf1_fail");
    p_dps_sys_summ2.f2_fail = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_manf2_fail");
    p_dps_sys_summ2.f3_fail = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_manf3_fail");
    p_dps_sys_summ2.f4_fail = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_manf4_fail");
    p_dps_sys_summ2.f5_fail = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_manf5_fail");
    
    p_dps_sys_summ2.l1_vlv = device.svg.getElementById("p_dps_sys_summ2_left_rcs_manf1_isol");
    p_dps_sys_summ2.l2_vlv = device.svg.getElementById("p_dps_sys_summ2_left_rcs_manf2_isol");
    p_dps_sys_summ2.l3_vlv = device.svg.getElementById("p_dps_sys_summ2_left_rcs_manf3_isol");
    p_dps_sys_summ2.l4_vlv = device.svg.getElementById("p_dps_sys_summ2_left_rcs_manf4_isol");
    p_dps_sys_summ2.l5_vlv = device.svg.getElementById("p_dps_sys_summ2_left_rcs_manf5_isol");
    
    p_dps_sys_summ2.l1_fail = device.svg.getElementById("p_dps_sys_summ2_left_rcs_manf1_fail");
    p_dps_sys_summ2.l2_fail = device.svg.getElementById("p_dps_sys_summ2_left_rcs_manf2_fail");
    p_dps_sys_summ2.l3_fail = device.svg.getElementById("p_dps_sys_summ2_left_rcs_manf3_fail");
    p_dps_sys_summ2.l4_fail = device.svg.getElementById("p_dps_sys_summ2_left_rcs_manf4_fail");
    p_dps_sys_summ2.l5_fail = device.svg.getElementById("p_dps_sys_summ2_left_rcs_manf5_fail");
    
    p_dps_sys_summ2.r1_vlv = device.svg.getElementById("p_dps_sys_summ2_right_rcs_manf1_isol");
    p_dps_sys_summ2.r2_vlv = device.svg.getElementById("p_dps_sys_summ2_right_rcs_manf2_isol");
    p_dps_sys_summ2.r3_vlv = device.svg.getElementById("p_dps_sys_summ2_right_rcs_manf3_isol");
    p_dps_sys_summ2.r4_vlv = device.svg.getElementById("p_dps_sys_summ2_right_rcs_manf4_isol");
    p_dps_sys_summ2.r5_vlv = device.svg.getElementById("p_dps_sys_summ2_right_rcs_manf5_isol");
    
    p_dps_sys_summ2.r1_fail = device.svg.getElementById("p_dps_sys_summ2_right_rcs_manf1_fail");
    p_dps_sys_summ2.r2_fail = device.svg.getElementById("p_dps_sys_summ2_right_rcs_manf2_fail");
    p_dps_sys_summ2.r3_fail = device.svg.getElementById("p_dps_sys_summ2_right_rcs_manf3_fail");
    p_dps_sys_summ2.r4_fail = device.svg.getElementById("p_dps_sys_summ2_right_rcs_manf4_fail");
    p_dps_sys_summ2.r5_fail = device.svg.getElementById("p_dps_sys_summ2_right_rcs_manf5_fail");
    
    p_dps_sys_summ2.fwd_rcs_oxid_he_p = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_oxid_he_p");
    p_dps_sys_summ2.fwd_rcs_fu_he_p = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_fu_he_p");
    p_dps_sys_summ2.fwd_rcs_oxid_tk_p = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_oxid_tk_p");
    p_dps_sys_summ2.fwd_rcs_fu_tk_p = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_fu_tk_p");
    
    p_dps_sys_summ2.left_rcs_oxid_he_p = device.svg.getElementById("p_dps_sys_summ2_left_rcs_oxid_he_p");
    p_dps_sys_summ2.left_rcs_fu_he_p = device.svg.getElementById("p_dps_sys_summ2_left_rcs_fu_he_p");
    p_dps_sys_summ2.left_rcs_oxid_tk_p = device.svg.getElementById("p_dps_sys_summ2_left_rcs_oxid_tk_p");
    p_dps_sys_summ2.left_rcs_fu_tk_p = device.svg.getElementById("p_dps_sys_summ2_left_rcs_fu_tk_p");
    
    p_dps_sys_summ2.right_rcs_oxid_he_p = device.svg.getElementById("p_dps_sys_summ2_right_rcs_oxid_he_p");
    p_dps_sys_summ2.right_rcs_fu_he_p = device.svg.getElementById("p_dps_sys_summ2_right_rcs_fu_he_p");
    p_dps_sys_summ2.right_rcs_oxid_tk_p = device.svg.getElementById("p_dps_sys_summ2_right_rcs_oxid_tk_p");
    p_dps_sys_summ2.right_rcs_fu_tk_p = device.svg.getElementById("p_dps_sys_summ2_right_rcs_fu_tk_p");
    
    p_dps_sys_summ2.left_oms_he_p = device.svg.getElementById("p_dps_sys_summ2_left_oms_he_p");
    p_dps_sys_summ2.right_oms_he_p = device.svg.getElementById("p_dps_sys_summ2_right_oms_he_p");
    p_dps_sys_summ2.left_oms_oxid_p = device.svg.getElementById("p_dps_sys_summ2_left_oms_oxid_p");
    p_dps_sys_summ2.right_oms_oxid_p = device.svg.getElementById("p_dps_sys_summ2_right_oms_oxid_p");
    p_dps_sys_summ2.left_oms_fuel_p = device.svg.getElementById("p_dps_sys_summ2_left_oms_fuel_p");
    p_dps_sys_summ2.right_oms_fuel_p = device.svg.getElementById("p_dps_sys_summ2_right_oms_fuel_p");
    
    p_dps_sys_summ2.left_rcs_manf1_oxid_p = device.svg.getElementById("p_dps_sys_summ2_left_rcs_manf1_oxid_p");
    p_dps_sys_summ2.left_rcs_manf1_fuel_p = device.svg.getElementById("p_dps_sys_summ2_left_rcs_manf1_fuel_p");
    p_dps_sys_summ2.left_rcs_manf2_oxid_p = device.svg.getElementById("p_dps_sys_summ2_left_rcs_manf2_oxid_p");
    p_dps_sys_summ2.left_rcs_manf2_fuel_p = device.svg.getElementById("p_dps_sys_summ2_left_rcs_manf2_fuel_p");
    p_dps_sys_summ2.left_rcs_manf3_oxid_p = device.svg.getElementById("p_dps_sys_summ2_left_rcs_manf3_oxid_p");
    p_dps_sys_summ2.left_rcs_manf3_fuel_p = device.svg.getElementById("p_dps_sys_summ2_left_rcs_manf3_fuel_p");
    p_dps_sys_summ2.left_rcs_manf4_oxid_p = device.svg.getElementById("p_dps_sys_summ2_left_rcs_manf4_oxid_p");
    p_dps_sys_summ2.left_rcs_manf4_fuel_p = device.svg.getElementById("p_dps_sys_summ2_left_rcs_manf4_fuel_p");
    
    p_dps_sys_summ2.right_rcs_manf1_oxid_p = device.svg.getElementById("p_dps_sys_summ2_right_rcs_manf1_oxid_p");
    p_dps_sys_summ2.right_rcs_manf1_fuel_p = device.svg.getElementById("p_dps_sys_summ2_right_rcs_manf1_fuel_p");
    p_dps_sys_summ2.right_rcs_manf2_oxid_p = device.svg.getElementById("p_dps_sys_summ2_right_rcs_manf2_oxid_p");
    p_dps_sys_summ2.right_rcs_manf2_fuel_p = device.svg.getElementById("p_dps_sys_summ2_right_rcs_manf2_fuel_p");
    p_dps_sys_summ2.right_rcs_manf3_oxid_p = device.svg.getElementById("p_dps_sys_summ2_right_rcs_manf3_oxid_p");
    p_dps_sys_summ2.right_rcs_manf3_fuel_p = device.svg.getElementById("p_dps_sys_summ2_right_rcs_manf3_fuel_p");
    p_dps_sys_summ2.right_rcs_manf4_oxid_p = device.svg.getElementById("p_dps_sys_summ2_right_rcs_manf4_oxid_p");
    p_dps_sys_summ2.right_rcs_manf4_fuel_p = device.svg.getElementById("p_dps_sys_summ2_right_rcs_manf4_fuel_p");
    
    p_dps_sys_summ2.fwd_rcs_manf1_oxid_p = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_manf1_oxid_p");
    p_dps_sys_summ2.fwd_rcs_manf1_fuel_p = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_manf1_fuel_p");
    p_dps_sys_summ2.fwd_rcs_manf2_oxid_p = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_manf2_oxid_p");
    p_dps_sys_summ2.fwd_rcs_manf2_fuel_p = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_manf2_fuel_p");
    p_dps_sys_summ2.fwd_rcs_manf3_oxid_p = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_manf3_oxid_p");
    p_dps_sys_summ2.fwd_rcs_manf3_fuel_p = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_manf3_fuel_p");
    p_dps_sys_summ2.fwd_rcs_manf4_oxid_p = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_manf4_oxid_p");
    p_dps_sys_summ2.fwd_rcs_manf4_fuel_p = device.svg.getElementById("p_dps_sys_summ2_fwd_rcs_manf4_fuel_p");
    
    p_dps_sys_summ2.left_oms_p_vlv = device.svg.getElementById("p_dps_sys_summ2_left_oms_p_vlv");
    p_dps_sys_summ2.right_oms_p_vlv = device.svg.getElementById("p_dps_sys_summ2_right_oms_p_vlv");
    
    p_dps_sys_summ2.left_oms_vlv1_p = device.svg.getElementById("p_dps_sys_summ2_left_oms_vlv1_p");
    p_dps_sys_summ2.left_oms_vlv2_p = device.svg.getElementById("p_dps_sys_summ2_left_oms_vlv2_p");
    p_dps_sys_summ2.right_oms_vlv1_p = device.svg.getElementById("p_dps_sys_summ2_right_oms_vlv1_p");
    p_dps_sys_summ2.right_oms_vlv2_p = device.svg.getElementById("p_dps_sys_summ2_right_oms_vlv2_p");
    
    p_dps_sys_summ2.left_oms_n2_p = device.svg.getElementById("p_dps_sys_summ2_left_oms_n2_p");
    p_dps_sys_summ2.right_oms_n2_p = device.svg.getElementById("p_dps_sys_summ2_right_oms_n2_p");
    p_dps_sys_summ2.left_oms_reg_p = device.svg.getElementById("p_dps_sys_summ2_left_oms_reg_p");
    p_dps_sys_summ2.right_oms_reg_p = device.svg.getElementById("p_dps_sys_summ2_right_oms_reg_p");
    
    p_dps_sys_summ2.left_oms_oxid_ei_p = device.svg.getElementById("p_dps_sys_summ2_left_oms_oxid_ei_p");
    p_dps_sys_summ2.left_oms_fuel_ei_p = device.svg.getElementById("p_dps_sys_summ2_left_oms_fuel_ei_p");
    p_dps_sys_summ2.right_oms_oxid_ei_p = device.svg.getElementById("p_dps_sys_summ2_right_oms_oxid_ei_p");
    p_dps_sys_summ2.right_oms_fuel_ei_p = device.svg.getElementById("p_dps_sys_summ2_right_oms_fuel_ei_p");
    
    
    p_dps_sys_summ2.bfs_inj_t_text = device.svg.getElementById("p_dps_sys_summ2_text5a");
    p_dps_sys_summ2.bfs_inj_t_l = device.svg.getElementById("p_dps_sys_summ2_fu_inj_t_l");
    p_dps_sys_summ2.bfs_inj_t_r = device.svg.getElementById("p_dps_sys_summ2_fu_inj_t_r");
    
    
    
    
    p_dps_sys_summ2.ondisplay = func
    {
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/   /019";
    
    
        device.DPS_menu_title.setText("GNC SYS SUMM 2");
        device.DPS_menu_ops.setText(ops_string);
        device.MEDS_menu_title.setText("       DPS MENU");
    
    # blank the BFS-only properties
    
        p_dps_sys_summ2.bfs_inj_t_text.setText(sprintf(""));
        p_dps_sys_summ2.bfs_inj_t_l.setText(sprintf(""));
        p_dps_sys_summ2.bfs_inj_t_r.setText(sprintf(""));
    
    }
    
    p_dps_sys_summ2.update = func
    {
    
    
        device.update_common_DPS();
    
    
        p_dps_sys_summ2.f1_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-1-status")));
        p_dps_sys_summ2.f2_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-2-status")));
        p_dps_sys_summ2.f3_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-3-status")));
        p_dps_sys_summ2.f4_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-4-status")));
        p_dps_sys_summ2.f5_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-5-status")));
    
        p_dps_sys_summ2.f1_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-f1")));
        p_dps_sys_summ2.f2_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-f2")));
        p_dps_sys_summ2.f3_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-f3")));
        p_dps_sys_summ2.f4_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-f4")));
        p_dps_sys_summ2.f5_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-f5")));
    
        p_dps_sys_summ2.l1_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-1-status")));
        p_dps_sys_summ2.l2_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-2-status")));
        p_dps_sys_summ2.l3_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-3-status")));
        p_dps_sys_summ2.l4_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-4-status")));
        p_dps_sys_summ2.l5_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-5-status")));
    
        p_dps_sys_summ2.l1_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-l1")));
        p_dps_sys_summ2.l2_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-l2")));
        p_dps_sys_summ2.l3_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-l3")));
        p_dps_sys_summ2.l4_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-l4")));
        p_dps_sys_summ2.l5_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-l5")));
    
        p_dps_sys_summ2.r1_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-1-status")));
        p_dps_sys_summ2.r2_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-2-status")));
        p_dps_sys_summ2.r3_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-3-status")));
        p_dps_sys_summ2.r4_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-4-status")));
        p_dps_sys_summ2.r5_vlv.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-5-status")));
    
        p_dps_sys_summ2.r1_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-r1")));
        p_dps_sys_summ2.r2_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-r2")));
        p_dps_sys_summ2.r3_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-r3")));
        p_dps_sys_summ2.r4_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-r4")));
        p_dps_sys_summ2.r5_fail.setText( jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-r5")));
    
    
        p_dps_sys_summ2.left_oms_fu_qty.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[5]/level-lbs")/47.180));
        p_dps_sys_summ2.left_oms_oxid_qty.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[4]/level-lbs")/77.730));
    
        p_dps_sys_summ2.right_oms_fu_qty.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[7]/level-lbs")/47.180));
        p_dps_sys_summ2.right_oms_oxid_qty.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[6]/level-lbs")/77.730));
    
        p_dps_sys_summ2.fwd_rcs_fu_qty.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[13]/level-lbs")/9.280));
        p_dps_sys_summ2.fwd_rcs_oxid_qty.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[12]/level-lbs")/14.770));
    
        p_dps_sys_summ2.left_rcs_fu_qty.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[9]/level-lbs")/9.280));
        p_dps_sys_summ2.left_rcs_oxid_qty.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[8]/level-lbs")/14.770));
    
        p_dps_sys_summ2.right_rcs_fu_qty.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[11]/level-lbs")/9.280));
        p_dps_sys_summ2.right_rcs_oxid_qty.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[10]/level-lbs")/14.770));
    
        p_dps_sys_summ2.fwd_rcs_oxid_he_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/helium-fwd-rcs-pressure-1-sh-psia")));
        p_dps_sys_summ2.fwd_rcs_fu_he_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/helium-fwd-rcs-pressure-2-sh-psia")));
        p_dps_sys_summ2.fwd_rcs_oxid_tk_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-fwd-rcs-blowdown-psia")));
        p_dps_sys_summ2.fwd_rcs_fu_tk_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-fwd-rcs-blowdown-psia")));
    
        p_dps_sys_summ2.left_rcs_oxid_he_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/helium-left-rcs-pressure-1-sh-psia")));
        p_dps_sys_summ2.left_rcs_fu_he_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/helium-left-rcs-pressure-2-sh-psia")));
        p_dps_sys_summ2.left_rcs_oxid_tk_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-left-rcs-blowdown-psia")));
        p_dps_sys_summ2.left_rcs_fu_tk_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-left-rcs-blowdown-psia")));
    
        p_dps_sys_summ2.right_rcs_oxid_he_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/helium-right-rcs-pressure-1-sh-psia")));
        p_dps_sys_summ2.right_rcs_fu_he_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/helium-right-rcs-pressure-2-sh-psia")));
        p_dps_sys_summ2.right_rcs_oxid_tk_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-right-rcs-blowdown-psia")));
        p_dps_sys_summ2.right_rcs_fu_tk_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-right-rcs-blowdown-psia")));
    
        p_dps_sys_summ2.left_oms_he_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/helium-left-oms-pressure-sh-psia")));
        p_dps_sys_summ2.right_oms_he_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/helium-right-oms-pressure-sh-psia")));
        p_dps_sys_summ2.left_oms_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/tanks-left-oms-blowdown-psia")));
        p_dps_sys_summ2.right_oms_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/tanks-right-oms-blowdown-psia"))); 
        p_dps_sys_summ2.left_oms_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/tanks-left-oms-blowdown-psia")));
        p_dps_sys_summ2.right_oms_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/tanks-right-oms-blowdown-psia")));
    
        p_dps_sys_summ2.left_rcs_manf1_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold1-oxidizer-pressure-psia")));
        p_dps_sys_summ2.left_rcs_manf1_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold1-fuel-pressure-psia")));
        p_dps_sys_summ2.left_rcs_manf2_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold2-oxidizer-pressure-psia")));
        p_dps_sys_summ2.left_rcs_manf2_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold2-fuel-pressure-psia"))); 
        p_dps_sys_summ2.left_rcs_manf3_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold3-oxidizer-pressure-psia")));
        p_dps_sys_summ2.left_rcs_manf3_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold3-fuel-pressure-psia")));
        p_dps_sys_summ2.left_rcs_manf4_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold4-oxidizer-pressure-psia")));
        p_dps_sys_summ2.left_rcs_manf4_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold4-fuel-pressure-psia"))); 
    
        p_dps_sys_summ2.right_rcs_manf1_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold1-oxidizer-pressure-psia")));
        p_dps_sys_summ2.right_rcs_manf1_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold1-fuel-pressure-psia")));
        p_dps_sys_summ2.right_rcs_manf2_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold2-oxidizer-pressure-psia")));
        p_dps_sys_summ2.right_rcs_manf2_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold2-fuel-pressure-psia"))); 
        p_dps_sys_summ2.right_rcs_manf3_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold3-oxidizer-pressure-psia")));
        p_dps_sys_summ2.right_rcs_manf3_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold3-fuel-pressure-psia")));
        p_dps_sys_summ2.right_rcs_manf4_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold4-oxidizer-pressure-psia")));
        p_dps_sys_summ2.right_rcs_manf4_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold4-fuel-pressure-psia"))); 
    
        p_dps_sys_summ2.fwd_rcs_manf1_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold1-oxidizer-pressure-psia")));
        p_dps_sys_summ2.fwd_rcs_manf1_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold1-fuel-pressure-psia")));
        p_dps_sys_summ2.fwd_rcs_manf2_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold2-oxidizer-pressure-psia")));
        p_dps_sys_summ2.fwd_rcs_manf2_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold2-fuel-pressure-psia"))); 
        p_dps_sys_summ2.fwd_rcs_manf3_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold3-oxidizer-pressure-psia")));
        p_dps_sys_summ2.fwd_rcs_manf3_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold3-fuel-pressure-psia")));
        p_dps_sys_summ2.fwd_rcs_manf4_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold4-oxidizer-pressure-psia")));
        p_dps_sys_summ2.fwd_rcs_manf4_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold4-fuel-pressure-psia"))); 
    
        p_dps_sys_summ2.left_oms_p_vlv.setText(sprintf(" %s", valve_status_to_string(getprop("/fdm/jsbsim/systems/oms-hardware/engine-left-arm-cmd"))));
        p_dps_sys_summ2.right_oms_p_vlv.setText(sprintf(" %s", valve_status_to_string(getprop("/fdm/jsbsim/systems/oms-hardware/engine-right-arm-cmd"))));
    
        var throttle_left_percent = 100.0 * getprop("/fdm/jsbsim/fcs/throttle-cmd-norm[5]");
        var throttle_right_percent = 100.0 * getprop("/fdm/jsbsim/fcs/throttle-cmd-norm[6]");
    
        p_dps_sys_summ2.left_oms_vlv1_p.setText(sprintf("%3.0f", throttle_left_percent));
        p_dps_sys_summ2.left_oms_vlv2_p.setText(sprintf("%3.0f", throttle_left_percent));
        p_dps_sys_summ2.right_oms_vlv1_p.setText(sprintf("%3.0f", throttle_right_percent)); 
        p_dps_sys_summ2.right_oms_vlv2_p.setText(sprintf("%3.0f", throttle_right_percent));
    
    
        p_dps_sys_summ2.left_oms_n2_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/n2-left-oms-pressure-psia")));
        p_dps_sys_summ2.right_oms_n2_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/n2-right-oms-pressure-psia")));
        p_dps_sys_summ2.left_oms_reg_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/n2-left-reg-pressure-psia")));
        p_dps_sys_summ2.right_oms_reg_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/n2-right-reg-pressure-psia")));
    
        p_dps_sys_summ2.left_oms_oxid_ei_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/chamber-left-inlet-oxidizer-pressure-psia")));
        p_dps_sys_summ2.left_oms_fuel_ei_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/chamber-left-inlet-fuel-pressure-psia"))); 
        p_dps_sys_summ2.right_oms_oxid_ei_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/chamber-right-inlet-oxidizer-pressure-psia"))); 
        p_dps_sys_summ2.right_oms_fuel_ei_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/chamber-right-inlet-fuel-pressure-psia")));
    
    }
    
    return p_dps_sys_summ2;
}
