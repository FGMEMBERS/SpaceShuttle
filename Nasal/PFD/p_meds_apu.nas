#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_meds_oms_mps
# Description: the OMS/MPS MEDS page
#      Author: Gijs de Rooy, Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_meds_apu = func(device)
{
    var p_meds_apu = device.addPage("MEDSApu", "p_meds_apu");

    p_meds_apu.menu_item = device.svg.getElementById("MI_2"); 
    p_meds_apu.menu_item_frame = device.svg.getElementById("MI_2_frame"); 

    p_meds_apu.ondisplay = func
    {
    
        device.set_DPS_off();
        device.MEDS_menu_title.setText("      SUBSYSTEM MENU");
	p_meds_apu.menu_item.setColor(1.0, 1.0, 1.0);
	p_meds_apu.menu_item_frame.setColor(1.0, 1.0, 1.0);
	
    

    }
    
    p_meds_apu.update = func
    {


    }

    p_meds_apu.offdisplay = func
    {
    
        p_meds_apu.menu_item.setColor(meds_r, meds_g, meds_b);
	p_meds_apu.menu_item_frame.setColor(meds_r, meds_g, meds_b);
    }
    
    
    
    return p_meds_apu;
}
