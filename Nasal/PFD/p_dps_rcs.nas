#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_rcs
# Description: the RCS DPS page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_rcs = func(device)
{
    var p_dps_rcs = device.addPage("CRTRCS", "p_dps_rcs");

    p_dps_rcs.group = device.svg.getElementById("p_dps_rcs");
    p_dps_rcs.group.setColor(dps_r, dps_g, dps_b);
    
   
    
    p_dps_rcs.ondisplay = func
    {
        device.DPS_menu_title.setText("RCS");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/023/";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_rcs.update = func
    {
    
     
    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_rcs;
}
