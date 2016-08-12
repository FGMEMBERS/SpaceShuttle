#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_gpc
# Description: the generic CRT GPC/Bus status page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_gpc = func(device)
{
    var p_dps_gpc = device.addPage("CRTGPC", "p_dps_gpc");

    p_dps_gpc.group = device.svg.getElementById("p_dps_gpc");
    p_dps_gpc.group.setColor(dps_r, dps_g, dps_b);
    
    p_dps_gpc.mode = [];
    append(p_dps_gpc.mode, device.svg.getElementById("p_dps_gpc_mode1"));
    append(p_dps_gpc.mode, device.svg.getElementById("p_dps_gpc_mode2"));
    append(p_dps_gpc.mode, device.svg.getElementById("p_dps_gpc_mode3"));
    append(p_dps_gpc.mode, device.svg.getElementById("p_dps_gpc_mode4"));
    append(p_dps_gpc.mode, device.svg.getElementById("p_dps_gpc_mode5"));

    p_dps_gpc.ops = [];
    append(p_dps_gpc.ops, device.svg.getElementById("p_dps_gpc_ops1"));
    append(p_dps_gpc.ops, device.svg.getElementById("p_dps_gpc_ops2"));
    append(p_dps_gpc.ops, device.svg.getElementById("p_dps_gpc_ops3"));
    append(p_dps_gpc.ops, device.svg.getElementById("p_dps_gpc_ops4"));
    append(p_dps_gpc.ops, device.svg.getElementById("p_dps_gpc_ops5"));
    
    p_dps_gpc.ondisplay = func
    {
        device.DPS_menu_title.setText("GPC/BUS STATUS");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/   /006";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_gpc.update = func
    {
    
     	for (var i=0; i< size(SpaceShuttle.gpc_array); i=i+1)
		{
		var gpc = SpaceShuttle.gpc_array[i];

		p_dps_gpc.mode[i].setText(gpc.mode_string);
		p_dps_gpc.ops[i].setText(gpc.mcc_string);

		}
    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_gpc;
}
