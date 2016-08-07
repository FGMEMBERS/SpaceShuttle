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

    p_meds_maint.mdu_rect = [];

    append(p_meds_maint.mdu_rect, device.svg.getElementById("p_meds_maint_rect1"));
    append(p_meds_maint.mdu_rect, device.svg.getElementById("p_meds_maint_rect2"));
    append(p_meds_maint.mdu_rect, device.svg.getElementById("p_meds_maint_rect3"));
    append(p_meds_maint.mdu_rect, device.svg.getElementById("p_meds_maint_rect8"));
    append(p_meds_maint.mdu_rect, device.svg.getElementById("p_meds_maint_rect4"));
    append(p_meds_maint.mdu_rect, device.svg.getElementById("p_meds_maint_rect5"));
    append(p_meds_maint.mdu_rect, device.svg.getElementById("p_meds_maint_rect9"));
    append(p_meds_maint.mdu_rect, device.svg.getElementById("p_meds_maint_rect6"));
    append(p_meds_maint.mdu_rect, device.svg.getElementById("p_meds_maint_rect7"));

    #p_meds_maint.rect1 = device.svg.getElementById("p_meds_maint_rect1");
    #p_meds_maint.rect2 = device.svg.getElementById("p_meds_maint_rect2");
    #p_meds_maint.rect3 = device.svg.getElementById("p_meds_maint_rect3");
    #p_meds_maint.rect4 = device.svg.getElementById("p_meds_maint_rect4");
    #p_meds_maint.rect5 = device.svg.getElementById("p_meds_maint_rect5");
    #p_meds_maint.rect6 = device.svg.getElementById("p_meds_maint_rect6");
    #p_meds_maint.rect7 = device.svg.getElementById("p_meds_maint_rect7");
    #p_meds_maint.rect8 = device.svg.getElementById("p_meds_maint_rect8");
    #p_meds_maint.rect9 = device.svg.getElementById("p_meds_maint_rect9");
    p_meds_maint.rect10 = device.svg.getElementById("p_meds_maint_rect10");
    p_meds_maint.rect11 = device.svg.getElementById("p_meds_maint_rect11");
    p_meds_maint.rect12 = device.svg.getElementById("p_meds_maint_rect12");
    p_meds_maint.rect13 = device.svg.getElementById("p_meds_maint_rect13");
    p_meds_maint.rect14 = device.svg.getElementById("p_meds_maint_rect14");
    p_meds_maint.rect15 = device.svg.getElementById("p_meds_maint_rect15");
    p_meds_maint.rect16 = device.svg.getElementById("p_meds_maint_rect16");
    p_meds_maint.rect17 = device.svg.getElementById("p_meds_maint_rect17");
    p_meds_maint.rect18 = device.svg.getElementById("p_meds_maint_rect18");


    p_meds_maint.ondisplay = func
    {
    
        device.set_DPS_off();
        device.MEDS_menu_title.setText("      MAINTENANCE MENU");
	p_meds_maint.menu_item.setColor(1.0, 1.0, 1.0);
	p_meds_maint.menu_item_frame.setColor(1.0, 1.0, 1.0);

	var port = device.port_selected;

	for (var i=0; i< size(MDU_array); i=i+1)  
		{
		var M = MDU_array[i];

		if (M.PFD.port_selected == port)
			{
			p_meds_maint.mdu_rect[i].setColorFill (0.2, 0.2, 0.6);
			}
		else
			{
			p_meds_maint.mdu_rect[i].setColorFill (0.0, 0.0, 0.0);
			}
		}


    }
    
    p_meds_maint.update = func
    {
	var port = device.port_selected;

	if (port == 1)
		{
		p_meds_maint.rect10.setColorFill (0.2, 0.2, 0.6);
		p_meds_maint.rect11.setColorFill (0.0, 0.0, 0.0);
		p_meds_maint.rect12.setColorFill (0.0, 0.0, 0.0);
		p_meds_maint.rect13.setColorFill (0.0, 0.0, 0.0);
		}
	else if (port == 2)
		{
		p_meds_maint.rect10.setColorFill (0.0, 0.0, 0.0);
		p_meds_maint.rect11.setColorFill (0.2, 0.2, 0.6);
		p_meds_maint.rect12.setColorFill (0.0, 0.0, 0.0);
		p_meds_maint.rect13.setColorFill (0.0, 0.0, 0.0);
		}
	else if (port == 3)
		{
		p_meds_maint.rect10.setColorFill (0.0, 0.0, 0.0);
		p_meds_maint.rect11.setColorFill (0.0, 0.0, 0.0);
		p_meds_maint.rect12.setColorFill (0.2, 0.2, 0.6);
		p_meds_maint.rect13.setColorFill (0.0, 0.0, 0.0);
		}
	


		

    }

    p_meds_maint.offdisplay = func
    {
    
        p_meds_maint.menu_item.setColor(meds_r, meds_g, meds_b);
	p_meds_maint.menu_item_frame.setColor(meds_r, meds_g, meds_b);
    }
    
    
    
    return p_meds_maint;
}
