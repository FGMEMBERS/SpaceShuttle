#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_pdrs
# Description: the payload remote handling control page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_pdrs_control = func(device)
{
    var p_dps_pdrs_control = device.addPage("CRTPdrsControl", "p_dps_pdrs_control");

    p_dps_pdrs_control.group = device.svg.getElementById("p_dps_pdrs_control");
    p_dps_pdrs_control.group.setColor(dps_r, dps_g, dps_b);
    
    
    
    p_dps_pdrs_control.ondisplay = func
    {
        device.DPS_menu_title.setText("PDRS CONTROL");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-sm");
    
        var ops_string = major_mode~"1/094/";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_pdrs_control.update = func
    {
    
        
    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_pdrs_control;
}
