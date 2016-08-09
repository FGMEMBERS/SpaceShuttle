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

    p_meds_maint.mdu_reconf = [];
    append(p_meds_maint.mdu_reconf, device.svg.getElementById("p_meds_maint_reconf1"));
    append(p_meds_maint.mdu_reconf, device.svg.getElementById("p_meds_maint_reconf2"));
    append(p_meds_maint.mdu_reconf, device.svg.getElementById("p_meds_maint_reconf3"));
    append(p_meds_maint.mdu_reconf, device.svg.getElementById("p_meds_maint_reconf8"));
    append(p_meds_maint.mdu_reconf, device.svg.getElementById("p_meds_maint_reconf4"));
    append(p_meds_maint.mdu_reconf, device.svg.getElementById("p_meds_maint_reconf5"));
    append(p_meds_maint.mdu_reconf, device.svg.getElementById("p_meds_maint_reconf9"));
    append(p_meds_maint.mdu_reconf, device.svg.getElementById("p_meds_maint_reconf6"));
    append(p_meds_maint.mdu_reconf, device.svg.getElementById("p_meds_maint_reconf7"));

    p_meds_maint.mdu_bite = [];
    append(p_meds_maint.mdu_bite, device.svg.getElementById("p_meds_maint_bite1"));
    append(p_meds_maint.mdu_bite, device.svg.getElementById("p_meds_maint_bite2"));
    append(p_meds_maint.mdu_bite, device.svg.getElementById("p_meds_maint_bite3"));
    append(p_meds_maint.mdu_bite, device.svg.getElementById("p_meds_maint_bite8"));
    append(p_meds_maint.mdu_bite, device.svg.getElementById("p_meds_maint_bite4"));
    append(p_meds_maint.mdu_bite, device.svg.getElementById("p_meds_maint_bite5"));
    append(p_meds_maint.mdu_bite, device.svg.getElementById("p_meds_maint_bite9"));
    append(p_meds_maint.mdu_bite, device.svg.getElementById("p_meds_maint_bite6"));
    append(p_meds_maint.mdu_bite, device.svg.getElementById("p_meds_maint_bite7"));

    p_meds_maint.mdu_fc = [];
    append(p_meds_maint.mdu_fc, device.svg.getElementById("p_meds_maint_fc1"));
    append(p_meds_maint.mdu_fc, device.svg.getElementById("p_meds_maint_fc2"));
    append(p_meds_maint.mdu_fc, device.svg.getElementById("p_meds_maint_fc3"));
    append(p_meds_maint.mdu_fc, device.svg.getElementById("p_meds_maint_fc8"));
    append(p_meds_maint.mdu_fc, device.svg.getElementById("p_meds_maint_fc4"));
    append(p_meds_maint.mdu_fc, device.svg.getElementById("p_meds_maint_fc5"));
    append(p_meds_maint.mdu_fc, device.svg.getElementById("p_meds_maint_fc9"));
    append(p_meds_maint.mdu_fc, device.svg.getElementById("p_meds_maint_fc6"));
    append(p_meds_maint.mdu_fc, device.svg.getElementById("p_meds_maint_fc7"));

    p_meds_maint.mdu_cst = [];
    append(p_meds_maint.mdu_cst, device.svg.getElementById("p_meds_maint_cst1"));
    append(p_meds_maint.mdu_cst, device.svg.getElementById("p_meds_maint_cst2"));
    append(p_meds_maint.mdu_cst, device.svg.getElementById("p_meds_maint_cst3"));
    append(p_meds_maint.mdu_cst, device.svg.getElementById("p_meds_maint_cst8"));
    append(p_meds_maint.mdu_cst, device.svg.getElementById("p_meds_maint_cst4"));
    append(p_meds_maint.mdu_cst, device.svg.getElementById("p_meds_maint_cst5"));
    append(p_meds_maint.mdu_cst, device.svg.getElementById("p_meds_maint_cst9"));
    append(p_meds_maint.mdu_cst, device.svg.getElementById("p_meds_maint_cst6"));
    append(p_meds_maint.mdu_cst, device.svg.getElementById("p_meds_maint_cst7"));
    

    p_meds_maint.idp_rect = [];

    append(p_meds_maint.idp_rect, device.svg.getElementById("p_meds_maint_rect10"));
    append(p_meds_maint.idp_rect, device.svg.getElementById("p_meds_maint_rect11"));
    append(p_meds_maint.idp_rect, device.svg.getElementById("p_meds_maint_rect12"));
    append(p_meds_maint.idp_rect, device.svg.getElementById("p_meds_maint_rect13"));
 
    p_meds_maint.rect14 = device.svg.getElementById("p_meds_maint_rect14");
    p_meds_maint.rect15 = device.svg.getElementById("p_meds_maint_rect15");
    p_meds_maint.rect16 = device.svg.getElementById("p_meds_maint_rect16");
    p_meds_maint.rect17 = device.svg.getElementById("p_meds_maint_rect17");
    p_meds_maint.rect18 = device.svg.getElementById("p_meds_maint_rect18");


    p_meds_maint.ondisplay = func
    {
    
        device.set_DPS_off();
	if (me.layer_id == "p_meds_maint")
		{
        	device.MEDS_menu_title.setText("      MAINTENANCE MENU");
		}
	else 
		{
        	device.MEDS_menu_title.setText("    MDU CONFIGURATION MENU");
		}


	var port = device.port_selected;

	if (port == 1)
		{
		p_meds_maint.idp_rect[0].setColorFill (0.2, 0.2, 0.6);
		p_meds_maint.idp_rect[1].set("fill", "none");
		p_meds_maint.idp_rect[2].set("fill", "none");
		p_meds_maint.idp_rect[3].set("fill", "none");
		}
	else if (port == 2)
		{
		p_meds_maint.idp_rect[0].set("fill", "none");
		p_meds_maint.idp_rect[1].setColorFill (0.2, 0.2, 0.6);
		p_meds_maint.idp_rect[2].set("fill", "none");
		p_meds_maint.idp_rect[3].set("fill", "none");
		}
	else if (port == 3)
		{
		p_meds_maint.idp_rect[0].set("fill", "none");
		p_meds_maint.idp_rect[1].set("fill", "none");
		p_meds_maint.idp_rect[2].setColorFill (0.2, 0.2, 0.6);
		p_meds_maint.idp_rect[3].set("fill", "none");
		}

	for (var i=0; i< size(MDU_array); i=i+1)  
		{
		var M = MDU_array[i];

		if (M.PFD.port_selected == port)
			{
			p_meds_maint.mdu_rect[i].setColorFill (0.2, 0.2, 0.6);
			}
		else
			{
			p_meds_maint.mdu_rect[i].set("fill", "none");
			}
		}


    }
    
    p_meds_maint.update = func
    {
	var commanding_idp = device.port_selected;
	var idp_index = commanding_idp - 1;

	for (var i=0; i< size(SpaceShuttle.idp_array); i=i+1)
		{
		var condition = SpaceShuttle.idp_array[i].condition;
		var operational = SpaceShuttle.idp_array[i].operational;

		if (operational == 0)
			{
			p_meds_maint.idp_rect[i].setColorFill (1.0, 0.3, 0.3);
			}
		else if (i == idp_index)
			{
			p_meds_maint.idp_rect[i].setColorFill (0.2, 0.2, 0.6);
			}
		else
			{		
			p_meds_maint.idp_rect[i].set("fill", "none");
			}

		}

	for (var i=0; i< size(SpaceShuttle.MDU_array); i=i+1)
		{


		var mdu = SpaceShuttle.MDU_array[i];

		if (mdu.operational == 0)
			{
			p_meds_maint.mdu_rect[i].setColorFill (1.0, 0.3, 0.3);
			p_meds_maint.mdu_reconf[i].setText("");
			p_meds_maint.mdu_fc[i].setText("");
			p_meds_maint.mdu_bite[i].setText("");
			p_meds_maint.mdu_cst[i].setText("");
			}
		else if (commanding_idp == mdu.PFD.port_selected)
			{
			p_meds_maint.mdu_rect[i].setColorFill (0.2, 0.2, 0.6);
			p_meds_maint.mdu_reconf[i].setText("  "~mdu.PFD.reconf_mode);
			p_meds_maint.mdu_fc[i].setText("  "~mdu.PFD.fc_bus_displayed);
			p_meds_maint.mdu_bite[i].setText("  0000");
			p_meds_maint.mdu_cst[i].setText(" NO-CST");
			}
		else if ((commanding_idp == mdu.PFD.primary) or (commanding_idp == mdu.PFD.secondary))
			{
			p_meds_maint.mdu_rect[i].set("fill", "none");
			p_meds_maint.mdu_reconf[i].setText("  "~mdu.PFD.reconf_mode);
			p_meds_maint.mdu_fc[i].setText("  "~mdu.PFD.fc_bus_displayed);
			p_meds_maint.mdu_bite[i].setText("  0000");
			p_meds_maint.mdu_cst[i].setText(" NO-CST");
			}
		else
			{		
			p_meds_maint.mdu_rect[i].set("fill", "none");
			p_meds_maint.mdu_reconf[i].setText("");
			p_meds_maint.mdu_fc[i].setText("");
			p_meds_maint.mdu_bite[i].setText("");
			p_meds_maint.mdu_cst[i].setText("");
			}

		}
	





	

    }

    p_meds_maint.offdisplay = func
    {
    
        p_meds_maint.menu_item.setColor(meds_r, meds_g, meds_b);
	p_meds_maint.menu_item_frame.setColor(meds_r, meds_g, meds_b);
    }
    
    
    
    return p_meds_maint;
}
