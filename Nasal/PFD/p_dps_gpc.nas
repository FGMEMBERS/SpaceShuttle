#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_gpc
# Description: the generic CRT GPC/Bus status page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_gpc = func(device)
{
    var p_dps_gpc = device.addPage("CRTGPC", "p_dps_gpc");

    p_dps_gpc.group = device.svg.getElementById("p_dps_gpc");
    p_dps_gpc.group.setColor(dps_r, dps_g, dps_b);
    
    
    
    p_dps_gpc.ondisplay = func
    {
        device.DPS_menu_title.setText("GPC/BUS STATUS");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/   /006";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_gpc.update = func
    {
    
     
    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_gpc;
}
