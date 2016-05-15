#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_orbit_tgt
# Description: the CRT orbital targeting page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_orbit_tgt = func(device)
{
    var p_dps_orbit_tgt = device.addPage("CRTOrbitTgt", "p_dps_orbit_tgt");

    p_dps_orbit_tgt.group = device.svg.getElementById("p_dps_orbit_tgt");
    p_dps_orbit_tgt.group.setColor(dps_r, dps_g, dps_b);
    
    
    p_dps_orbit_tgt.ondisplay = func
    {
        device.DPS_menu_title.setText("ORBIT TGT");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/034/";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_orbit_tgt.update = func
    {
    
    
    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_orbit_tgt;
}
