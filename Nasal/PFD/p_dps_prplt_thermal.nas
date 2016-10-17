#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_prplt_thermal
# Description: the SM propellant/thermal display page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_prplt_thermal = func(device)
{
    var p_dps_prplt_thermal = device.addPage("CRTPrpltThermal", "p_dps_prplt_thermal");

    p_dps_prplt_thermal.group = device.svg.getElementById("p_dps_prplt_thermal");
    p_dps_prplt_thermal.group.setColor(dps_r, dps_g, dps_b);
    
    
    p_dps_prplt_thermal.ondisplay = func
    {
        device.DPS_menu_title.setText("PRPLT THERMAL");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
	var spec = SpaceShuttle.idp_array[device.port_selected-1].get_spec();    
	var spec_string = assemble_spec_string(spec);
    
        var ops_string = major_mode~"1/"~spec_string~"/089";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_prplt_thermal.update = func
    {
    
       
    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_prplt_thermal;
}
