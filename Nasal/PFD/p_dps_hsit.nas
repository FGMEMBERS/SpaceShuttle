#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_hsit
# Description: the horizontal situation DPS page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_hsit = func(device)
{
    var p_dps_hsit = device.addPage("CRTHsit", "p_dps_hsit");

    p_dps_hsit.group = device.svg.getElementById("p_dps_hsit");
    p_dps_hsit.group.setColor(dps_r, dps_g, dps_b);
    
    p_dps_hsit.altm = device.svg.getElementById("p_dps_hsit_altm");  



    
    p_dps_hsit.ondisplay = func
    {
        device.DPS_menu_title.setText("HORIZ SIT");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/050/";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_hsit.update = func
    {
    
	p_dps_hsit.altm.setText(sprintf("%2.2f", getprop("/instrumentation/altimeter/setting-inhg") ));
      
    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_hsit;
}
