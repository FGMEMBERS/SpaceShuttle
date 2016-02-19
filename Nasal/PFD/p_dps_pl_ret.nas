#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_pl_ret
# Description: the payload retention page (DISP 97)
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_dps_pl_ret = func(device)
{
    var p_dps_pl_ret = device.addPage("CRTPlRet", "p_dps_pl_ret");

    p_dps_pl_ret.group = device.svg.getElementById("p_dps_pl_ret");
    p_dps_pl_ret.group.setColor(dps_r, dps_g, dps_b);
  
    p_dps_pl_ret.rfl1_1 = device.svg.getElementById("p_dps_pl_ret_rfl1_1");  
    p_dps_pl_ret.rfl2_1 = device.svg.getElementById("p_dps_pl_ret_rfl2_1");  
    p_dps_pl_ret.rfl3_1 = device.svg.getElementById("p_dps_pl_ret_rfl3_1");  
    p_dps_pl_ret.rfl4_1 = device.svg.getElementById("p_dps_pl_ret_rfl4_1");  
    p_dps_pl_ret.rfl5_1 = device.svg.getElementById("p_dps_pl_ret_rfl5_1");  
  
    p_dps_pl_ret.lr1_1 = device.svg.getElementById("p_dps_pl_ret_lr1_1");  
    p_dps_pl_ret.lr2_1 = device.svg.getElementById("p_dps_pl_ret_lr2_1");  
    p_dps_pl_ret.lr3_1 = device.svg.getElementById("p_dps_pl_ret_lr3_1");  
    p_dps_pl_ret.lr4_1 = device.svg.getElementById("p_dps_pl_ret_lr4_1");  
    p_dps_pl_ret.lr5_1 = device.svg.getElementById("p_dps_pl_ret_lr5_1");  

    p_dps_pl_ret.rfl1_2 = device.svg.getElementById("p_dps_pl_ret_rfl1_2");  
    p_dps_pl_ret.rfl2_2 = device.svg.getElementById("p_dps_pl_ret_rfl2_2");  
    p_dps_pl_ret.rfl3_2 = device.svg.getElementById("p_dps_pl_ret_rfl3_2");  
    p_dps_pl_ret.rfl4_2 = device.svg.getElementById("p_dps_pl_ret_rfl4_2");  
    p_dps_pl_ret.rfl5_2 = device.svg.getElementById("p_dps_pl_ret_rfl5_2");  
  
    p_dps_pl_ret.lr1_2 = device.svg.getElementById("p_dps_pl_ret_lr1_2");  
    p_dps_pl_ret.lr2_2 = device.svg.getElementById("p_dps_pl_ret_lr2_2");  
    p_dps_pl_ret.lr3_2 = device.svg.getElementById("p_dps_pl_ret_lr3_2");  
    p_dps_pl_ret.lr4_2 = device.svg.getElementById("p_dps_pl_ret_lr4_2");  
    p_dps_pl_ret.lr5_2 = device.svg.getElementById("p_dps_pl_ret_lr5_2");  

    p_dps_pl_ret.rfl1_3 = device.svg.getElementById("p_dps_pl_ret_rfl1_3");  
    p_dps_pl_ret.rfl2_3 = device.svg.getElementById("p_dps_pl_ret_rfl2_3");  
    p_dps_pl_ret.rfl3_3 = device.svg.getElementById("p_dps_pl_ret_rfl3_3");  
    p_dps_pl_ret.rfl4_3 = device.svg.getElementById("p_dps_pl_ret_rfl4_3");  
    p_dps_pl_ret.rfl5_3 = device.svg.getElementById("p_dps_pl_ret_rfl5_3");  
  
    p_dps_pl_ret.lr1_3 = device.svg.getElementById("p_dps_pl_ret_lr1_3");  
    p_dps_pl_ret.lr2_3 = device.svg.getElementById("p_dps_pl_ret_lr2_3");  
    p_dps_pl_ret.lr3_3 = device.svg.getElementById("p_dps_pl_ret_lr3_3");  
    p_dps_pl_ret.lr4_3 = device.svg.getElementById("p_dps_pl_ret_lr4_3");  
    p_dps_pl_ret.lr5_3 = device.svg.getElementById("p_dps_pl_ret_lr5_3"); 


    
    p_dps_pl_ret.ondisplay = func
    {
        device.DPS_menu_title.setText("PL RETENTION");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-sm");
    
        var ops_string = major_mode~"1/   /097";
        device.DPS_menu_ops.setText(ops_string);

	# blank payload positions 2 and 3 as they're not implemented yet

	p_dps_pl_ret.rfl1_2.setText("");
	p_dps_pl_ret.rfl2_2.setText("");
	p_dps_pl_ret.rfl3_2.setText("");
	p_dps_pl_ret.rfl4_2.setText("");
	p_dps_pl_ret.rfl5_2.setText("");

	p_dps_pl_ret.rfl1_3.setText("");
	p_dps_pl_ret.rfl2_3.setText("");
	p_dps_pl_ret.rfl3_3.setText("");
	p_dps_pl_ret.rfl4_3.setText("");
	p_dps_pl_ret.rfl5_3.setText("");

	p_dps_pl_ret.lr1_2.setText("");
	p_dps_pl_ret.lr2_2.setText("");
	p_dps_pl_ret.lr3_2.setText("");
	p_dps_pl_ret.lr4_2.setText("");
	p_dps_pl_ret.lr5_2.setText("");

	p_dps_pl_ret.lr1_3.setText("");
	p_dps_pl_ret.lr2_3.setText("");
	p_dps_pl_ret.lr3_3.setText("");
	p_dps_pl_ret.lr4_3.setText("");
	p_dps_pl_ret.lr5_3.setText("");

    }
    
    p_dps_pl_ret.update = func
    {

	var ready_to_latch = getprop("/fdm/jsbsim/systems/rms/payload-ready-to-latch");   

	var string = "11";
	if (ready_to_latch == 0.0) {string = "00";}

        var latch = getprop("/fdm/jsbsim/systems/rms/retention-latch-1-pos");
	p_dps_pl_ret.lr1_1.setText(ret_latch_to_microsw(latch));
	p_dps_pl_ret.rfl1_1.setText(string);

        var latch = getprop("/fdm/jsbsim/systems/rms/retention-latch-2-pos");
	p_dps_pl_ret.lr2_1.setText(ret_latch_to_microsw(latch));
	p_dps_pl_ret.rfl2_1.setText(string);

        var latch = getprop("/fdm/jsbsim/systems/rms/retention-latch-3-pos");
	p_dps_pl_ret.lr3_1.setText(ret_latch_to_microsw(latch));
	p_dps_pl_ret.rfl3_1.setText(string);

        var latch = getprop("/fdm/jsbsim/systems/rms/retention-latch-4-pos");
	p_dps_pl_ret.lr4_1.setText(ret_latch_to_microsw(latch));
	p_dps_pl_ret.rfl4_1.setText(string);

        var latch = getprop("/fdm/jsbsim/systems/rms/retention-latch-5-pos");
	p_dps_pl_ret.lr5_1.setText(ret_latch_to_microsw(latch));
	p_dps_pl_ret.rfl5_1.setText(string);
    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_pl_ret;
}
