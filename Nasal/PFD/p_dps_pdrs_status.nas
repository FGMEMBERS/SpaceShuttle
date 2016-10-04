#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_pdrs_status
# Description: the PDRS status page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_pdrs_status = func(device)
{
    var p_dps_pdrs_status = device.addPage("CRTPDRS_status", "p_dps_pdrs_status");

    p_dps_pdrs_status.group = device.svg.getElementById("p_dps_pdrs_status");
    p_dps_pdrs_status.group.setColor(dps_r, dps_g, dps_b);
    
  
    
    p_dps_pdrs_status.ondisplay = func
    {
        device.DPS_menu_title.setText("PDRS STATUS");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-sm");
	var spec =  getprop("/fdm/jsbsim/systems/dps/spec-sm");
	var spec_string = assemble_spec_string(spec);
    
        var ops_string = major_mode~"1/"~spec_string~"/169";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_pdrs_status.update = func
    {
    

    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_pdrs_status;
}
