#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_meds_spi
# Description: the SPI MEDS page
#      Author: Gijs de Rooy, Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_meds_spi = func(device)
{
    var p_meds_spi = device.addPage("MEDSSpi", "p_meds_spi");


    p_meds_spi.menu_item = device.svg.getElementById("MI_3"); 
    p_meds_spi.menu_item_frame = device.svg.getElementById("MI_3_frame");


    p_meds_spi.ondisplay = func
    {
    
        device.set_DPS_off();
        device.MEDS_menu_title.setText("      SUBSYSTEM MENU");
	p_meds_spi.menu_item.setColor(1.0, 1.0, 1.0);
	p_meds_spi.menu_item_frame.setColor(1.0, 1.0, 1.0);

    

    }
    
    p_meds_spi.update = func
    {
	
	

    }

    p_meds_spi.offdisplay = func
    {
    
        p_meds_spi.menu_item.setColor(meds_r, meds_g, meds_b);
	p_meds_spi.menu_item_frame.setColor(meds_r, meds_g, meds_b);
    }
    
    
    
    return p_meds_spi;
}
