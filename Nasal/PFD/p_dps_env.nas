#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_env
# Description: the SM environemnt CRT page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_env = func(device)
{
    var p_dps_env = device.addPage("CRTEnv", "p_dps_env");

    p_dps_env.group = device.svg.getElementById("p_dps_env");
    p_dps_env.group.setColor(dps_r, dps_g, dps_b);
    
 
    
    p_dps_env.ondisplay = func
    {
        device.DPS_menu_title.setText("ENVIRONMENT");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-sm");
    
        var ops_string = major_mode~"1/   /066";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_env.update = func
    {
    
       
    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_env;
}
