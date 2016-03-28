#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_rm_orbit
# Description: the generic THC/RHC control page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_rm_orbit = func(device)
{
    var p_dps_rm_orbit = device.addPage("CRTRmOrbit", "p_dps_rm_orbit");

    p_dps_rm_orbit.group = device.svg.getElementById("p_dps_rm_orbit");
    p_dps_rm_orbit.group.setColor(dps_r, dps_g, dps_b);
    
    
    
    p_dps_rm_orbit.ondisplay = func
    {
        device.DPS_menu_title.setText("RM ORBIT");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/025/";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_rm_orbit.update = func
    {
    
     
    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_rm_orbit;
}
