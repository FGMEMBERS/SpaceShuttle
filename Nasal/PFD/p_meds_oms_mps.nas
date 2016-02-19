#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_meds_oms_mps
# Description: the OMS/MPS MEDS page
#      Author: Gijs de Rooy, Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_meds_oms_mps = func(device)
{
    var p_meds_oms_mps = device.addPage("MEDSOmsMps", "p_meds_oms_mps");

   
    
    p_meds_oms_mps.ondisplay = func
    {
    
        device.MEDS_menu_title.setText("      SUBSYSTEM MENU");
    

    }
    
    p_meds_oms_mps.update = func
    {
    
       
    }
    
    
    
    return p_meds_oms_mps;
}
