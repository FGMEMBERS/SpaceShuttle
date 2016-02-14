#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_cryo
# Description: the generic SM CRYO SYSTEM page (DISP 68)
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_cryo = func(device)
{
    var p_dps_cryo = device.addPage("CRTCryo", "p_dps_cryo");
    

    
    p_dps_cryo.ondisplay = func
    {
        device.DPS_menu_title.setText("CRYO SYSTEM");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-sm");
    
        var ops_string = major_mode~"1/   /068";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_cryo.update = func
    {
    

    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_cryo;
}
