#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_main
# Description: the main menu page showing just selection buttons
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_meds_autonomous = func(device)
{
    var p_meds_autonomous = device.addPage("AutonomousMenu", "p_meds_autonomous");

    
    p_meds_autonomous.up1 = device.svg.getElementById("meds_menu_up_line1"); 
    p_meds_autonomous.up2 = device.svg.getElementById("meds_menu_up_line2"); 
    p_meds_autonomous.up3 = device.svg.getElementById("meds_menu_up_line3"); 
    p_meds_autonomous.up4 = device.svg.getElementById("meds_menu_up_line4"); 
    p_meds_autonomous.up5 = device.svg.getElementById("meds_menu_up_line5"); 
    p_meds_autonomous.up6 = device.svg.getElementById("meds_menu_up_line6"); 

    p_meds_autonomous.ondisplay = func
    {
        device.set_DPS_off();
        device.MEDS_menu_title.setText("   MDU IS AUTONOMOUS");
	p_meds_autonomous.up1.setVisible(0);
	p_meds_autonomous.up2.setVisible(0);
	p_meds_autonomous.up3.setVisible(0);
	p_meds_autonomous.up4.setVisible(0);
	p_meds_autonomous.up5.setVisible(0);
	p_meds_autonomous.up6.setVisible(0);
    }

   p_meds_autonomous.offdisplay = func 
    {
	p_meds_autonomous.up1.setVisible(1);
	p_meds_autonomous.up2.setVisible(1);
	p_meds_autonomous.up3.setVisible(1);
	p_meds_autonomous.up4.setVisible(1);
	p_meds_autonomous.up5.setVisible(1);
	p_meds_autonomous.up6.setVisible(1);

    }
    
    
    
    return p_meds_autonomous;
}
