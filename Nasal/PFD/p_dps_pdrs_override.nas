#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_pdrs_override
# Description: the payload handling hardware switch override page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_pdrs_override = func(device)
{
    var p_dps_pdrs_override = device.addPage("CRTPdrsOverride", "p_dps_pdrs_override");

    p_dps_pdrs_override.group = device.svg.getElementById("p_dps_pdrs_override");
    p_dps_pdrs_override.group.setColor(dps_r, dps_g, dps_b);
    
    



    p_dps_pdrs_override.ondisplay = func
    {
        device.DPS_menu_title.setText("PDRS OVERRIDE");
        device.MEDS_menu_title.setText("       DPS MENU");
    
	

        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-sm");
    
        var ops_string = major_mode~"1/095/";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_pdrs_override.update = func
    {
    
        
	


        device.update_common_DPS();
    }
    
    
    
    return p_dps_pdrs_override;
}
