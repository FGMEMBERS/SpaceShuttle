#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_dap
# Description: the DAP configuration utility page
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_dps_dap = func(device)
{
    var p_dps_dap = device.addPage("CRTDAP", "p_dps_dap");
    
    
    p_dps_dap.label1 = device.svg.getElementById("p_dps_dap_label1");
    p_dps_dap.label2 = device.svg.getElementById("p_dps_dap_label2");
    p_dps_dap.label3 = device.svg.getElementById("p_dps_dap_label3");
    p_dps_dap.label1a = device.svg.getElementById("p_dps_dap_label1a");
    p_dps_dap.label2a = device.svg.getElementById("p_dps_dap_label2a");
    p_dps_dap.label3a = device.svg.getElementById("p_dps_dap_label3a");
    
    p_dps_dap.dap_a_desig_bright = device.svg.getElementById("p_dps_dap_dap_a_desig_bright");
    p_dps_dap.dap_b_desig_bright = device.svg.getElementById("p_dps_dap_dap_b_desig_bright");
    
    p_dps_dap.a_rot_rate = device.svg.getElementById("p_dps_dap_a_rot_rate");
    p_dps_dap.b_rot_rate = device.svg.getElementById("p_dps_dap_b_rot_rate");
    p_dps_dap.e_rot_rate = device.svg.getElementById("p_dps_dap_e_rot_rate");
    
    p_dps_dap.a_rot_rate_v = device.svg.getElementById("p_dps_dap_a_rot_rate_v");
    p_dps_dap.b_rot_rate_v = device.svg.getElementById("p_dps_dap_b_rot_rate_v");
    p_dps_dap.e_rot_rate_v = device.svg.getElementById("p_dps_dap_e_rot_rate_v");
    
    p_dps_dap.a_att_db = device.svg.getElementById("p_dps_dap_a_att_db");
    p_dps_dap.b_att_db = device.svg.getElementById("p_dps_dap_b_att_db");
    p_dps_dap.e_att_db = device.svg.getElementById("p_dps_dap_e_att_db");
    
    p_dps_dap.a_att_db_v = device.svg.getElementById("p_dps_dap_a_att_db_v");
    p_dps_dap.b_att_db_v = device.svg.getElementById("p_dps_dap_b_att_db_v");
    p_dps_dap.e_att_db_v = device.svg.getElementById("p_dps_dap_e_att_db_v");
    
    p_dps_dap.a_rate_db = device.svg.getElementById("p_dps_dap_a_rate_db");
    p_dps_dap.b_rate_db = device.svg.getElementById("p_dps_dap_b_rate_db");
    p_dps_dap.e_rate_db = device.svg.getElementById("p_dps_dap_e_rate_db");
    
    p_dps_dap.a_rate_db_v = device.svg.getElementById("p_dps_dap_a_rate_db_v");
    p_dps_dap.b_rate_db_v = device.svg.getElementById("p_dps_dap_b_rate_db_v");
    p_dps_dap.e_rate_db_v = device.svg.getElementById("p_dps_dap_e_rate_db_v");
    
    p_dps_dap.a_rate_db_alt = device.svg.getElementById("p_dps_dap_a_rate_db_alt");
    p_dps_dap.b_rate_db_alt = device.svg.getElementById("p_dps_dap_b_rate_db_alt");
    p_dps_dap.e_rate_db_alt = device.svg.getElementById("p_dps_dap_e_rate_db_alt");
    
    p_dps_dap.a_rot_pls = device.svg.getElementById("p_dps_dap_a_rot_pls");
    p_dps_dap.b_rot_pls = device.svg.getElementById("p_dps_dap_b_rot_pls");
    p_dps_dap.e_rot_pls = device.svg.getElementById("p_dps_dap_e_rot_pls");
    
    p_dps_dap.a_rot_pls_v = device.svg.getElementById("p_dps_dap_a_rot_pls_v");
    p_dps_dap.b_rot_pls_v = device.svg.getElementById("p_dps_dap_b_rot_pls_v");
    p_dps_dap.e_rot_pls_v = device.svg.getElementById("p_dps_dap_e_rot_pls_v");
    
    p_dps_dap.a_comp = device.svg.getElementById("p_dps_dap_a_comp");
    p_dps_dap.b_comp = device.svg.getElementById("p_dps_dap_b_comp");
    p_dps_dap.e_comp = device.svg.getElementById("p_dps_dap_e_comp");
    
    p_dps_dap.a_comp_v = device.svg.getElementById("p_dps_dap_a_comp_v");
    p_dps_dap.b_comp_v = device.svg.getElementById("p_dps_dap_b_comp_v");
    p_dps_dap.e_comp_v = device.svg.getElementById("p_dps_dap_e_comp_v");
    
    p_dps_dap.a_cntl_acc = device.svg.getElementById("p_dps_dap_a_cntl_acc");
    p_dps_dap.b_cntl_acc = device.svg.getElementById("p_dps_dap_b_cntl_acc");
    p_dps_dap.e_cntl_acc = device.svg.getElementById("p_dps_dap_e_cntl_acc");
    
    p_dps_dap.a_p_opt = device.svg.getElementById("p_dps_dap_a_p_opt");
    p_dps_dap.b_p_opt = device.svg.getElementById("p_dps_dap_b_p_opt");
    p_dps_dap.e_p_opt = device.svg.getElementById("p_dps_dap_e_p_opt");
    
    p_dps_dap.a_y_opt = device.svg.getElementById("p_dps_dap_a_y_opt");
    p_dps_dap.b_y_opt = device.svg.getElementById("p_dps_dap_b_y_opt");
    p_dps_dap.e_y_opt = device.svg.getElementById("p_dps_dap_e_y_opt");
    
    p_dps_dap.a_tran_pls = device.svg.getElementById("p_dps_dap_a_tran_pls");
    p_dps_dap.b_tran_pls = device.svg.getElementById("p_dps_dap_b_tran_pls");
    p_dps_dap.e_tran_pls = device.svg.getElementById("p_dps_dap_e_tran_pls");
    
    p_dps_dap.a_n_jets = device.svg.getElementById("p_dps_dap_a_n_jets");
    p_dps_dap.b_n_jets = device.svg.getElementById("p_dps_dap_b_n_jets");
    p_dps_dap.e_n_jets = device.svg.getElementById("p_dps_dap_e_n_jets");
    
    p_dps_dap.a_edit = device.svg.getElementById("p_dps_dap_a_edit");
    p_dps_dap.b_edit = device.svg.getElementById("p_dps_dap_b_edit");
    p_dps_dap.e_load = device.svg.getElementById("p_dps_dap_e_load");
    
    p_dps_dap.a_jet_opt = device.svg.getElementById("p_dps_dap_a_jet_opt");
    p_dps_dap.b_jet_opt = device.svg.getElementById("p_dps_dap_b_jet_opt");
    p_dps_dap.e_jet_opt = device.svg.getElementById("p_dps_dap_e_jet_opt");
    
    p_dps_dap.a_on_time = device.svg.getElementById("p_dps_dap_a_on_time");
    p_dps_dap.b_on_time = device.svg.getElementById("p_dps_dap_b_on_time");
    p_dps_dap.e_on_time = device.svg.getElementById("p_dps_dap_e_on_time");
    
    p_dps_dap.a_delay = device.svg.getElementById("p_dps_dap_a_delay");
    p_dps_dap.b_delay = device.svg.getElementById("p_dps_dap_b_delay");
    p_dps_dap.e_delay = device.svg.getElementById("p_dps_dap_e_delay");
    
    
    p_dps_dap.notch_fltr = device.svg.getElementById("p_dps_dap_notch_fltr"); 
    p_dps_dap.xjets_rot = device.svg.getElementById("p_dps_dap_xjets_rot"); 
    p_dps_dap.reboost_cfg = device.svg.getElementById("p_dps_dap_reboost_cfg"); 
    p_dps_dap.intvl = device.svg.getElementById("p_dps_dap_intvl"); 
    
    
    
    
    p_dps_dap.ondisplay = func
    {
        device.DPS_menu_title.setText("DAP CONFIG");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/020/";
        device.DPS_menu_ops.setText(ops_string);
    
    # set defaults for all functions which aren't implemented yet
    
        p_dps_dap.label1.setText(sprintf("PRI" )); 
        p_dps_dap.label2.setText(sprintf("ALT" )); 
        p_dps_dap.label3.setText(sprintf("VERN" )); 
        p_dps_dap.label1a.setText(sprintf("" )); 
        p_dps_dap.label2a.setText(sprintf("" )); 
        p_dps_dap.label3a.setText(sprintf("" )); 
    
        p_dps_dap.dap_a_desig_bright.setText(sprintf("" )); 
        p_dps_dap.dap_b_desig_bright.setText(sprintf("" )); 
    
        p_dps_dap.e_rot_rate.setText(sprintf("_.____" ));
        p_dps_dap.e_rot_rate_v.setText(sprintf("_.____" ));
    
        p_dps_dap.e_att_db.setText(sprintf("__.__" ));
        p_dps_dap.e_att_db_v.setText(sprintf("__.__" ));
    
        p_dps_dap.e_rate_db.setText(sprintf("_.__" ));
        p_dps_dap.e_rate_db_alt.setText(sprintf("_.__" ));
        p_dps_dap.e_rate_db_v.setText(sprintf(".___" ));
    
        p_dps_dap.e_rot_pls.setText(sprintf("_.___" ));
        p_dps_dap.e_rot_pls_v.setText(sprintf("_.___" ));
    
        p_dps_dap.e_comp.setText(sprintf("_.__" ));
        p_dps_dap.e_comp_v.setText(sprintf("_.__" ));
    
        p_dps_dap.a_cntl_acc.setText(sprintf("0" ));
        p_dps_dap.b_cntl_acc.setText(sprintf("0" ));
        p_dps_dap.e_cntl_acc.setText(sprintf("_" ));
    
        p_dps_dap.e_tran_pls.setText(sprintf("_.__" ));
    
        p_dps_dap.a_edit.setText(sprintf("__" ));
        p_dps_dap.b_edit.setText(sprintf("__" ));
    
        p_dps_dap.e_n_jets.setText(sprintf("_" ));
    
        p_dps_dap.e_p_opt.setText(sprintf(""));
        p_dps_dap.e_y_opt.setText(sprintf(""));
    
        p_dps_dap.a_on_time.setText(sprintf("0.08"));
        p_dps_dap.b_on_time.setText(sprintf("0.08"));
        p_dps_dap.e_on_time.setText(sprintf("_.__"));
    
        p_dps_dap.a_delay.setText(sprintf(" 0.00"));
        p_dps_dap.b_delay.setText(sprintf(" 0.00"));
        p_dps_dap.e_delay.setText(sprintf("_.__"));
    
        p_dps_dap.a_jet_opt.setText(sprintf("ALL"));
        p_dps_dap.b_jet_opt.setText(sprintf("ALL"));
        p_dps_dap.e_jet_opt.setText(sprintf("ALL"));
    
        p_dps_dap.e_load.setText(sprintf(""));
        p_dps_dap.notch_fltr.setText(sprintf("")); 
        p_dps_dap.xjets_rot.setText(sprintf("")); 
    
        p_dps_dap.reboost_cfg.setText(sprintf("")); 
        p_dps_dap.intvl.setText(sprintf("10.00")); 
    }
    
    p_dps_dap.update = func
    {
    
        p_dps_dap.a_rot_rate.setText(sprintf("%1.4f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-rot-rate")));
        p_dps_dap.a_rot_rate_v.setText(sprintf("%1.4f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-A-VRN-rot-rate") ));
    
        p_dps_dap.b_rot_rate.setText(sprintf("%1.4f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-rot-rate")));
        p_dps_dap.b_rot_rate_v.setText(sprintf("%1.4f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-B-VRN-rot-rate") ));
    
        p_dps_dap.a_att_db.setText(sprintf("%5.2f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-att-db")));
        p_dps_dap.a_att_db_v.setText(sprintf("%5.3f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-A-VRN-att-db") ));
    
        p_dps_dap.b_att_db.setText(sprintf("%5.2f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-att-db")));
        p_dps_dap.b_att_db_v.setText(sprintf("%5.3f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-B-VRN-att-db") ));
    
        p_dps_dap.a_rate_db.setText(sprintf("%1.2f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-rate-db")));
        p_dps_dap.a_rate_db_alt.setText(sprintf("%1.2f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-A-ALS-rate-db")));
        p_dps_dap.a_rate_db_v.setText(sprintf("%4.2f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-A-VRN-rate-db") ));
    
        p_dps_dap.b_rate_db.setText(sprintf("%1.2f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-rate-db")));
        p_dps_dap.b_rate_db_alt.setText(sprintf("%1.2f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-B-ALT-rate-db")));
        p_dps_dap.b_rate_db_v.setText(sprintf("%4.2f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-B-VRN-rate-db") ));
    
        p_dps_dap.a_rot_pls.setText(sprintf("%5.3f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-rot-pls")));
        p_dps_dap.b_rot_pls.setText(sprintf("%5.3f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-rot-pls")));
    
        p_dps_dap.a_rot_pls_v.setText(sprintf("%5.3f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-A-VRN-rot-pls")));
        p_dps_dap.b_rot_pls_v.setText(sprintf("%5.3f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-B-VRN-rot-pls")));
    
        p_dps_dap.a_comp.setText(sprintf("%4.2f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-comp")));
        p_dps_dap.b_comp.setText(sprintf("%4.2f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-comp")));
    
        p_dps_dap.a_comp_v.setText(sprintf("%4.2f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-A-VRN-comp")));
        p_dps_dap.b_comp_v.setText(sprintf("%4.2f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-B-VRN-comp")));
    
    
        p_dps_dap.a_p_opt.setText( jet_option(getprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-p-opt")));
        p_dps_dap.b_p_opt.setText( jet_option(getprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-p-opt")));
    
        p_dps_dap.a_y_opt.setText( jet_option(getprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-y-opt")));
        p_dps_dap.b_y_opt.setText( jet_option(getprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-y-opt")));
    
    
        p_dps_dap.a_tran_pls.setText(sprintf("%5.3f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-tran-pls")));
        p_dps_dap.b_tran_pls.setText(sprintf("%5.3f", getprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-tran-pls")));
    
        p_dps_dap.a_n_jets.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/ap/spec20/dap-A-ALT-n-jets")));
        p_dps_dap.b_n_jets.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/ap/spec20/dap-B-ALT-n-jets")));
    
        var control_mode = getprop("/fdm/jsbsim/systems/fcs/control-mode");
    
        if ((control_mode == 20) or (control_mode == 21))
    	{
            p_dps_dap.label1a.setText(sprintf("PRI" )); 
            p_dps_dap.label2a.setText(sprintf("" )); 
            p_dps_dap.label3a.setText(sprintf("" ));
    	}
        else
    	{
            p_dps_dap.label1a.setText(sprintf("" )); 
            p_dps_dap.label2a.setText(sprintf("" )); 
            p_dps_dap.label3a.setText(sprintf("VERN" ));
    	} 
    
        if ((control_mode == 20) or (control_mode == 25))
    	{
            p_dps_dap.dap_a_desig_bright.setText(sprintf("DAP A01" )); 
            p_dps_dap.dap_b_desig_bright.setText(sprintf("" )); 
    	}
        else if ((control_mode == 21) or (control_mode == 30))
    	{
            p_dps_dap.dap_a_desig_bright.setText(sprintf("" )); 
            p_dps_dap.dap_b_desig_bright.setText(sprintf("DAP B01" )); 
    	}
        else
    	{
            p_dps_dap.dap_a_desig_bright.setText(sprintf("" )); 
            p_dps_dap.dap_b_desig_bright.setText(sprintf("" )); 
    	}
    
        device.update_common_DPS();
    
    }
    
    
    
    return p_dps_dap;
}
