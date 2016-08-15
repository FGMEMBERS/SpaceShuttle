#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_memory
# Description: the DPS memory utility page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_memory = func(device)
{
    var p_dps_memory = device.addPage("CRTFault", "p_dps_memory");

    p_dps_memory.group = device.svg.getElementById("p_dps_memory");
    p_dps_memory.group.setColor(dps_r, dps_g, dps_b);
    
   
    
    p_dps_memory.ondisplay = func
    {
        device.DPS_menu_title.setText("GPC MEMORY");
        device.MEDS_menu_title.setText("       DPS MENU");
   
        var ops_string = "0001/000/";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_memory.update = func
    {
    

    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_memory;
}
