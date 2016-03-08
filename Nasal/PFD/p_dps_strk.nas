#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_strk
# Description: the CRT star tracker operations page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_strk = func(device)
{
    var p_dps_strk = device.addPage("CRTStrk", "p_dps_strk");

    p_dps_strk.group = device.svg.getElementById("p_dps_strk");
    p_dps_strk.group.setColor(dps_r, dps_g, dps_b);
    
    
    
    p_dps_strk.ondisplay = func
    {
        device.DPS_menu_title.setText("S TRK/COAS CNTL");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/022/";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_strk.update = func
    {
    
     
    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_strk;
}
