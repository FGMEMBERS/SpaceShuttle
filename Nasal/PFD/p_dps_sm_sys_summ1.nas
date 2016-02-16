#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_sm_sys_summ1
# Description: the SM system summary page 1
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_sm_sys_summ1 = func(device)
{
    var p_dps_sm_sys_summ1 = device.addPage("CRTSMSysSumm1", "p_dps_sm_sys_summ1");
    

    
    p_dps_sm_sys_summ1.ondisplay = func
    {
        device.DPS_menu_title.setText("SM SYS SUMM 1");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-sm");
    
        var ops_string = major_mode~"1/   /078";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_sm_sys_summ1.update = func
    {
    
       
        device.update_common_DPS();
    }
    
    
    
    return p_dps_sm_sys_summ1;
}
