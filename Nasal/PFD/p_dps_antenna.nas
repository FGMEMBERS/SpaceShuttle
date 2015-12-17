#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_antenna
# Description: the Antennta  page
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_dps_antenna = func(device)
{
    var p_dps_antenna = device.addPage("CRTAntenna", "p_dps_antenna");
    
    p_dps_antenna.ondisplay = func
    {
        device.DPS_menu_title.setText("ANTENNA");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/   /086";
        device.DPS_menu_ops.setText(ops_string);
    
    }
    
    p_dps_antenna.update = func
    {
        device.update_common_DPS();
    }
    
    
    
    return p_dps_antenna;
}
