#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_pl_ret
# Description: the payload retention page (DISP 97)
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_dps_pl_ret = func(device)
{
    var p_dps_pl_ret = device.addPage("CRTPlRet", "p_dps_pl_ret");
    
  
    
    p_dps_pl_ret.ondisplay = func
    {
        device.DPS_menu_title.setText("PL RETENTION");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/   /097";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_pl_ret.update = func
    {
    
       
    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_pl_ret;
}
