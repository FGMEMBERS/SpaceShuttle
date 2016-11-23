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

    p_dps_gpc.string1_ff = [];
    append(p_dps_gpc.string1_ff, device.svg.getElementById("p_dps_gpc_string1_ff_1"));
    append(p_dps_gpc.string1_ff, device.svg.getElementById("p_dps_gpc_string1_ff_2"));
    append(p_dps_gpc.string1_ff, device.svg.getElementById("p_dps_gpc_string1_ff_3"));
    append(p_dps_gpc.string1_ff, device.svg.getElementById("p_dps_gpc_string1_ff_4"));
    append(p_dps_gpc.string1_ff, device.svg.getElementById("p_dps_gpc_string1_ff_5"));

    p_dps_gpc.string1_fa = [];
    append(p_dps_gpc.string1_fa, device.svg.getElementById("p_dps_gpc_string1_fa_1"));
    append(p_dps_gpc.string1_fa, device.svg.getElementById("p_dps_gpc_string1_fa_2"));
    append(p_dps_gpc.string1_fa, device.svg.getElementById("p_dps_gpc_string1_fa_3"));
    append(p_dps_gpc.string1_fa, device.svg.getElementById("p_dps_gpc_string1_fa_4"));
    append(p_dps_gpc.string1_fa, device.svg.getElementById("p_dps_gpc_string1_fa_5"));

    p_dps_gpc.string2_ff = [];
    append(p_dps_gpc.string2_ff, device.svg.getElementById("p_dps_gpc_string2_ff_1"));
    append(p_dps_gpc.string2_ff, device.svg.getElementById("p_dps_gpc_string2_ff_2"));
    append(p_dps_gpc.string2_ff, device.svg.getElementById("p_dps_gpc_string2_ff_3"));
    append(p_dps_gpc.string2_ff, device.svg.getElementById("p_dps_gpc_string2_ff_4"));
    append(p_dps_gpc.string2_ff, device.svg.getElementById("p_dps_gpc_string2_ff_5"));

    p_dps_gpc.string2_fa = [];
    append(p_dps_gpc.string2_fa, device.svg.getElementById("p_dps_gpc_string2_fa_1"));
    append(p_dps_gpc.string2_fa, device.svg.getElementById("p_dps_gpc_string2_fa_2"));
    append(p_dps_gpc.string2_fa, device.svg.getElementById("p_dps_gpc_string2_fa_3"));
    append(p_dps_gpc.string2_fa, device.svg.getElementById("p_dps_gpc_string2_fa_4"));
    append(p_dps_gpc.string2_fa, device.svg.getElementById("p_dps_gpc_string2_fa_5"));

    p_dps_gpc.string3_ff = [];
    append(p_dps_gpc.string3_ff, device.svg.getElementById("p_dps_gpc_string3_ff_1"));
    append(p_dps_gpc.string3_ff, device.svg.getElementById("p_dps_gpc_string3_ff_2"));
    append(p_dps_gpc.string3_ff, device.svg.getElementById("p_dps_gpc_string3_ff_3"));
    append(p_dps_gpc.string3_ff, device.svg.getElementById("p_dps_gpc_string3_ff_4"));
    append(p_dps_gpc.string3_ff, device.svg.getElementById("p_dps_gpc_string3_ff_5"));

    p_dps_gpc.string3_fa = [];
    append(p_dps_gpc.string3_fa, device.svg.getElementById("p_dps_gpc_string3_fa_1"));
    append(p_dps_gpc.string3_fa, device.svg.getElementById("p_dps_gpc_string3_fa_2"));
    append(p_dps_gpc.string3_fa, device.svg.getElementById("p_dps_gpc_string3_fa_3"));
    append(p_dps_gpc.string3_fa, device.svg.getElementById("p_dps_gpc_string3_fa_4"));
    append(p_dps_gpc.string3_fa, device.svg.getElementById("p_dps_gpc_string3_fa_5"));

    p_dps_gpc.string4_ff = [];
    append(p_dps_gpc.string4_ff, device.svg.getElementById("p_dps_gpc_string4_ff_1"));
    append(p_dps_gpc.string4_ff, device.svg.getElementById("p_dps_gpc_string4_ff_2"));
    append(p_dps_gpc.string4_ff, device.svg.getElementById("p_dps_gpc_string4_ff_3"));
    append(p_dps_gpc.string4_ff, device.svg.getElementById("p_dps_gpc_string4_ff_4"));
    append(p_dps_gpc.string4_ff, device.svg.getElementById("p_dps_gpc_string4_ff_5"));

    p_dps_gpc.string4_fa = [];
    append(p_dps_gpc.string4_fa, device.svg.getElementById("p_dps_gpc_string4_fa_1"));
    append(p_dps_gpc.string4_fa, device.svg.getElementById("p_dps_gpc_string4_fa_2"));
    append(p_dps_gpc.string4_fa, device.svg.getElementById("p_dps_gpc_string4_fa_3"));
    append(p_dps_gpc.string4_fa, device.svg.getElementById("p_dps_gpc_string4_fa_4"));
    append(p_dps_gpc.string4_fa, device.svg.getElementById("p_dps_gpc_string4_fa_5"));

    p_dps_gpc.pl1 = [];
    append(p_dps_gpc.pl1, device.svg.getElementById("p_dps_gpc_pl1_1"));
    append(p_dps_gpc.pl1, device.svg.getElementById("p_dps_gpc_pl1_2"));
    append(p_dps_gpc.pl1, device.svg.getElementById("p_dps_gpc_pl1_3"));
    append(p_dps_gpc.pl1, device.svg.getElementById("p_dps_gpc_pl1_4"));
    append(p_dps_gpc.pl1, device.svg.getElementById("p_dps_gpc_pl1_5"));

   p_dps_gpc.pl2 = [];
    append(p_dps_gpc.pl2, device.svg.getElementById("p_dps_gpc_pl2_1"));
    append(p_dps_gpc.pl2, device.svg.getElementById("p_dps_gpc_pl2_2"));
    append(p_dps_gpc.pl2, device.svg.getElementById("p_dps_gpc_pl2_3"));
    append(p_dps_gpc.pl2, device.svg.getElementById("p_dps_gpc_pl2_4"));
    append(p_dps_gpc.pl2, device.svg.getElementById("p_dps_gpc_pl2_5"));

    p_dps_gpc.launch1 = [];
    append(p_dps_gpc.launch1, device.svg.getElementById("p_dps_gpc_launch1_1"));
    append(p_dps_gpc.launch1, device.svg.getElementById("p_dps_gpc_launch1_2"));
    append(p_dps_gpc.launch1, device.svg.getElementById("p_dps_gpc_launch1_3"));
    append(p_dps_gpc.launch1, device.svg.getElementById("p_dps_gpc_launch1_4"));
    append(p_dps_gpc.launch1, device.svg.getElementById("p_dps_gpc_launch1_5"));

    p_dps_gpc.launch2 = [];
    append(p_dps_gpc.launch2, device.svg.getElementById("p_dps_gpc_launch2_1"));
    append(p_dps_gpc.launch2, device.svg.getElementById("p_dps_gpc_launch2_2"));
    append(p_dps_gpc.launch2, device.svg.getElementById("p_dps_gpc_launch2_3"));
    append(p_dps_gpc.launch2, device.svg.getElementById("p_dps_gpc_launch2_4"));
    append(p_dps_gpc.launch2, device.svg.getElementById("p_dps_gpc_launch2_5"));

    p_dps_gpc.crt1 = [];
    append(p_dps_gpc.crt1, device.svg.getElementById("p_dps_gpc_crt1_1"));
    append(p_dps_gpc.crt1, device.svg.getElementById("p_dps_gpc_crt1_2"));
    append(p_dps_gpc.crt1, device.svg.getElementById("p_dps_gpc_crt1_3"));
    append(p_dps_gpc.crt1, device.svg.getElementById("p_dps_gpc_crt1_4"));
    append(p_dps_gpc.crt1, device.svg.getElementById("p_dps_gpc_crt1_5"));

    p_dps_gpc.crt2 = [];
    append(p_dps_gpc.crt2, device.svg.getElementById("p_dps_gpc_crt2_1"));
    append(p_dps_gpc.crt2, device.svg.getElementById("p_dps_gpc_crt2_2"));
    append(p_dps_gpc.crt2, device.svg.getElementById("p_dps_gpc_crt2_3"));
    append(p_dps_gpc.crt2, device.svg.getElementById("p_dps_gpc_crt2_4"));
    append(p_dps_gpc.crt2, device.svg.getElementById("p_dps_gpc_crt2_5"));

    p_dps_gpc.crt3 = [];
    append(p_dps_gpc.crt3, device.svg.getElementById("p_dps_gpc_crt3_1"));
    append(p_dps_gpc.crt3, device.svg.getElementById("p_dps_gpc_crt3_2"));
    append(p_dps_gpc.crt3, device.svg.getElementById("p_dps_gpc_crt3_3"));
    append(p_dps_gpc.crt3, device.svg.getElementById("p_dps_gpc_crt3_4"));
    append(p_dps_gpc.crt3, device.svg.getElementById("p_dps_gpc_crt3_5"));

    p_dps_gpc.crt4 = [];
    append(p_dps_gpc.crt4, device.svg.getElementById("p_dps_gpc_crt4_1"));
    append(p_dps_gpc.crt4, device.svg.getElementById("p_dps_gpc_crt4_2"));
    append(p_dps_gpc.crt4, device.svg.getElementById("p_dps_gpc_crt4_3"));
    append(p_dps_gpc.crt4, device.svg.getElementById("p_dps_gpc_crt4_4"));
    append(p_dps_gpc.crt4, device.svg.getElementById("p_dps_gpc_crt4_5"));
    
    p_dps_gpc.ondisplay = func
    {
        device.DPS_menu_title.setText("GPC/BUS STATUS");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
	var spec = SpaceShuttle.idp_array[device.port_selected-1].get_spec();    
	var spec_string = assemble_spec_string(spec);    

        var ops_string = major_mode~"1/"~spec_string~"/006";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_gpc.update = func
    {
    
     	for (var i=0; i< size(SpaceShuttle.gpc_array); i=i+1)
		{
		var gpc = SpaceShuttle.gpc_array[i];

		p_dps_gpc.mode[i].setText(gpc.mode_string);
		p_dps_gpc.ops[i].setText(gpc.mcc_string);
		p_dps_gpc.string1_ff[i].setText(gpc.string1);
		p_dps_gpc.string1_fa[i].setText(gpc.string1);
		p_dps_gpc.string2_ff[i].setText(gpc.string2);
		p_dps_gpc.string2_fa[i].setText(gpc.string2);
		p_dps_gpc.string3_ff[i].setText(gpc.string3);
		p_dps_gpc.string3_fa[i].setText(gpc.string3);
		p_dps_gpc.string4_ff[i].setText(gpc.string4);
		p_dps_gpc.string4_fa[i].setText(gpc.string4);
		p_dps_gpc.pl1[i].setText(gpc.pl1);
		p_dps_gpc.pl2[i].setText(gpc.pl2);
		p_dps_gpc.launch1[i].setText(gpc.launch1);
		p_dps_gpc.launch2[i].setText(gpc.launch2);
		p_dps_gpc.crt1[i].setText(gpc.crt1);
		p_dps_gpc.crt2[i].setText(gpc.crt2);
		p_dps_gpc.crt3[i].setText(gpc.crt3);
		p_dps_gpc.crt4[i].setText(gpc.crt4);

		}
    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_gpc;
}
