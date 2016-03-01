#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_rel_nav
# Description: the DPS rendezvous navigation page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_rel_nav = func(device)
{
    var p_dps_rel_nav = device.addPage("CRTRelNav", "p_dps_rel_nav");

    p_dps_rel_nav.group = device.svg.getElementById("p_dps_rel_nav");
    p_dps_rel_nav.group.setColor(dps_r, dps_g, dps_b);
    
   
    
    p_dps_rel_nav.ondisplay = func
    {
        device.DPS_menu_title.setText("REL NAV");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/033/";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_rel_nav.update = func
    {
    
      
    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_rel_nav;
}
