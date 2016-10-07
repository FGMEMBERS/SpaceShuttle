#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_hyd_thermal
# Description: the hydraulics/thermal environment page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_hyd_thermal = func(device)
{
    var p_dps_hyd_thermal = device.addPage("CRTHydThermal", "p_dps_hyd_thermal");

    p_dps_hyd_thermal.group = device.svg.getElementById("p_dps_hyd_thermal");
    p_dps_hyd_thermal.group.setColor(dps_r, dps_g, dps_b);
    
    
    p_dps_hyd_thermal.ondisplay = func
    {
        device.DPS_menu_title.setText("HYD THERMAL");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
	var spec = SpaceShuttle.idp_array[device.port_selected-1].get_spec();    
	var spec_string = assemble_spec_string(spec);
    
        var ops_string = major_mode~"1/"~spec_string~"/087";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_hyd_thermal.update = func
    {

    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_hyd_thermal;
}