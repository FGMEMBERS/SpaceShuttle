#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_subsys
# Description: the subsystem page showing just selection buttons
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_subsys = func(device)
{
    var p_subsys = device.addPage("SubsysMenu", "p_main");

    

    p_subsys.ondisplay = func
    {
        device.set_DPS_off();
        device.MEDS_menu_title.setText("      SUBSYSTEM MENU");
	
    }

   p_subsys.offdisplay = func 
    {


    }
    
    
    
    return p_subsys;
}
