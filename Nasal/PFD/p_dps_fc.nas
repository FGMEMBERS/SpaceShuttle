#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_fc
# Description: the systems management Fuel Cells page 
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_fc = func(device)
{
    var p_dps_fc = device.addPage("CRTFC", "p_dps_fc");
    
  
    
    p_dps_fc.ondisplay = func
    {
        device.DPS_menu_title.setText("FUEL CELLS");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/   /069";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_fc.update = func
    {
    
       
    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_fc;
}
