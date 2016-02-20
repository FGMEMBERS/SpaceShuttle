#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_main
# Description: the main menu page showing just selection buttons
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_main = func(device)
{
    var p_main = device.addPage("MainMenu", "p_main");

    
    p_main.up1 = device.svg.getElementById("meds_menu_up_line1"); 
    p_main.up2 = device.svg.getElementById("meds_menu_up_line2"); 
    p_main.up3 = device.svg.getElementById("meds_menu_up_line3"); 
    p_main.up4 = device.svg.getElementById("meds_menu_up_line4"); 
    p_main.up5 = device.svg.getElementById("meds_menu_up_line5"); 
    p_main.up6 = device.svg.getElementById("meds_menu_up_line6"); 

    p_main.ondisplay = func
    {
        device.set_DPS_off();
        device.MEDS_menu_title.setText("      MAIN MENU");
	p_main.up1.setVisible(0);
	p_main.up2.setVisible(0);
	p_main.up3.setVisible(0);
	p_main.up4.setVisible(0);
	p_main.up5.setVisible(0);
	p_main.up6.setVisible(0);
    }

   p_main.offdisplay = func 
    {
	p_main.up1.setVisible(1);
	p_main.up2.setVisible(1);
	p_main.up3.setVisible(1);
	p_main.up4.setVisible(1);
	p_main.up5.setVisible(1);
	p_main.up6.setVisible(1);

    }
    
    
    
    return p_main;
}
