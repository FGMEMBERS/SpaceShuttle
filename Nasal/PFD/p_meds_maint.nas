#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_meds_maint
# Description: the MAINTENANCE MEDS page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_meds_maint = func(device)
{
    var p_meds_maint = device.addPage("MEDSMaint", "p_meds_maint");

   

    p_meds_maint.menu_item = device.svg.getElementById("MI_2"); 
    p_meds_maint.menu_item_frame = device.svg.getElementById("MI_2_frame");

    p_meds_maint.rect1 = device.svg.getElementById("p_meds_maint_rect7");

    p_meds_maint.ondisplay = func
    {
    
        device.set_DPS_off();
        device.MEDS_menu_title.setText("      MAINTENANCE MENU");
	p_meds_maint.menu_item.setColor(1.0, 1.0, 1.0);
	p_meds_maint.menu_item_frame.setColor(1.0, 1.0, 1.0);


	#p_meds_maint.rect1.setColorFill (0.2, 0.2, 0.6);
    }
    
    p_meds_maint.update = func
    {
	

    }

    p_meds_maint.offdisplay = func
    {
    
        p_meds_maint.menu_item.setColor(meds_r, meds_g, meds_b);
	p_meds_maint.menu_item_frame.setColor(meds_r, meds_g, meds_b);
    }
    
    
    
    return p_meds_maint;
}
