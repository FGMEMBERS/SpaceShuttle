#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_main
# Description: the main menu page showing just selection buttons
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_main = func(device)
{
    var p_main = device.addPage("MainMenu", "p_main");

    p_main.group = device.svg.getElementById("p_main");
    p_main.group.setColor(dps_r, dps_g, dps_b);
    
    
    p_main.ondisplay = func
    {
        device.set_DPS_off();
        device.MEDS_menu_title.setText("      MAIN MENU");
    }
    
    
    
    return p_main;
}
