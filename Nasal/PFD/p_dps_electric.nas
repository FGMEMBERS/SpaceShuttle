#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_electric
# Description: the electric system display (DISP 67)
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_electric = func(device)
{
    var p_dps_electric = device.addPage("CRTElectric", "p_dps_electric");
    
 
    
    p_dps_electric.ondisplay = func
    {
        device.DPS_menu_title.setText("ELECTRIC");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-sm");
    
        var ops_string = major_mode~"1/   /067";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_electric.update = func
    {
    
       
    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_electric;
}
