#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_cryo
# Description: the generic SM CRYO SYSTEM page (DISP 68)
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_cryo = func(device)
{
    var p_dps_cryo = device.addPage("CRTCryo", "p_dps_cryo");

    p_dps_cryo.group = device.svg.getElementById("p_dps_cryo");
    p_dps_cryo.group.setColor(dps_r, dps_g, dps_b);

    p_dps_cryo.p_o2_1 = device.svg.getElementById("p_dps_cryo_p_o2_1");
    p_dps_cryo.p_o2_2 = device.svg.getElementById("p_dps_cryo_p_o2_2");
    p_dps_cryo.p_o2_3 = device.svg.getElementById("p_dps_cryo_p_o2_3");
    p_dps_cryo.p_o2_4 = device.svg.getElementById("p_dps_cryo_p_o2_4");
    p_dps_cryo.p_o2_5 = device.svg.getElementById("p_dps_cryo_p_o2_5");

    p_dps_cryo.tkp_o2_1 = device.svg.getElementById("p_dps_cryo_tkp_o2_1");
    p_dps_cryo.tkp_o2_2 = device.svg.getElementById("p_dps_cryo_tkp_o2_2");
    p_dps_cryo.tkp_o2_3 = device.svg.getElementById("p_dps_cryo_tkp_o2_3");
    p_dps_cryo.tkp_o2_4 = device.svg.getElementById("p_dps_cryo_tkp_o2_4");
    p_dps_cryo.tkp_o2_5 = device.svg.getElementById("p_dps_cryo_tkp_o2_5");


    p_dps_cryo.T_o2_1 = device.svg.getElementById("p_dps_cryo_T_o2_1");
    p_dps_cryo.T_o2_2 = device.svg.getElementById("p_dps_cryo_T_o2_2");
    p_dps_cryo.T_o2_3 = device.svg.getElementById("p_dps_cryo_T_o2_3");
    p_dps_cryo.T_o2_4 = device.svg.getElementById("p_dps_cryo_T_o2_4");
    p_dps_cryo.T_o2_5 = device.svg.getElementById("p_dps_cryo_T_o2_5");

    p_dps_cryo.qty_o2_1 = device.svg.getElementById("p_dps_cryo_qty_o2_1");
    p_dps_cryo.qty_o2_2 = device.svg.getElementById("p_dps_cryo_qty_o2_2");
    p_dps_cryo.qty_o2_3 = device.svg.getElementById("p_dps_cryo_qty_o2_3");
    p_dps_cryo.qty_o2_4 = device.svg.getElementById("p_dps_cryo_qty_o2_4");
    p_dps_cryo.qty_o2_5 = device.svg.getElementById("p_dps_cryo_qty_o2_5");

    p_dps_cryo.HT1_o2_1 = device.svg.getElementById("p_dps_cryo_HT1_o2_1");
    p_dps_cryo.HT1_o2_2 = device.svg.getElementById("p_dps_cryo_HT1_o2_2");
    p_dps_cryo.HT1_o2_3 = device.svg.getElementById("p_dps_cryo_HT1_o2_3");
    p_dps_cryo.HT1_o2_4 = device.svg.getElementById("p_dps_cryo_HT1_o2_4");
    p_dps_cryo.HT1_o2_5 = device.svg.getElementById("p_dps_cryo_HT1_o2_5");

    p_dps_cryo.HT2_o2_1 = device.svg.getElementById("p_dps_cryo_HT2_o2_1");
    p_dps_cryo.HT2_o2_2 = device.svg.getElementById("p_dps_cryo_HT2_o2_2");
    p_dps_cryo.HT2_o2_3 = device.svg.getElementById("p_dps_cryo_HT2_o2_3");
    p_dps_cryo.HT2_o2_4 = device.svg.getElementById("p_dps_cryo_HT2_o2_4");
    p_dps_cryo.HT2_o2_5 = device.svg.getElementById("p_dps_cryo_HT2_o2_5");

    p_dps_cryo.o2_manfp_1 = device.svg.getElementById("p_dps_cryo_o2_manfp_1");
    p_dps_cryo.o2_manfp_2 = device.svg.getElementById("p_dps_cryo_o2_manfp_2");

    p_dps_cryo.o2_vlv_1 = device.svg.getElementById("p_dps_cryo_o2_vlv_1");
    p_dps_cryo.o2_vlv_2 = device.svg.getElementById("p_dps_cryo_o2_vlv_2");



    p_dps_cryo.p_h2_1 = device.svg.getElementById("p_dps_cryo_p_h2_1");
    p_dps_cryo.p_h2_2 = device.svg.getElementById("p_dps_cryo_p_h2_2");
    p_dps_cryo.p_h2_3 = device.svg.getElementById("p_dps_cryo_p_h2_3");
    p_dps_cryo.p_h2_4 = device.svg.getElementById("p_dps_cryo_p_h2_4");
    p_dps_cryo.p_h2_5 = device.svg.getElementById("p_dps_cryo_p_h2_5");

    p_dps_cryo.tkp_h2_1 = device.svg.getElementById("p_dps_cryo_tkp_h2_1");
    p_dps_cryo.tkp_h2_2 = device.svg.getElementById("p_dps_cryo_tkp_h2_2");
    p_dps_cryo.tkp_h2_3 = device.svg.getElementById("p_dps_cryo_tkp_h2_3");
    p_dps_cryo.tkp_h2_4 = device.svg.getElementById("p_dps_cryo_tkp_h2_4");
    p_dps_cryo.tkp_h2_5 = device.svg.getElementById("p_dps_cryo_tkp_h2_5");

    p_dps_cryo.T_h2_1 = device.svg.getElementById("p_dps_cryo_T_h2_1");
    p_dps_cryo.T_h2_2 = device.svg.getElementById("p_dps_cryo_T_h2_2");
    p_dps_cryo.T_h2_3 = device.svg.getElementById("p_dps_cryo_T_h2_3");
    p_dps_cryo.T_h2_4 = device.svg.getElementById("p_dps_cryo_T_h2_4");
    p_dps_cryo.T_h2_5 = device.svg.getElementById("p_dps_cryo_T_h2_5");

    p_dps_cryo.HT_h2_1 = device.svg.getElementById("p_dps_cryo_HT_h2_1");
    p_dps_cryo.HT_h2_2 = device.svg.getElementById("p_dps_cryo_HT_h2_2");
    p_dps_cryo.HT_h2_3 = device.svg.getElementById("p_dps_cryo_HT_h2_3");
    p_dps_cryo.HT_h2_4 = device.svg.getElementById("p_dps_cryo_HT_h2_4");
    p_dps_cryo.HT_h2_5 = device.svg.getElementById("p_dps_cryo_HT_h2_5");

    p_dps_cryo.qty_h2_1 = device.svg.getElementById("p_dps_cryo_qty_h2_1");
    p_dps_cryo.qty_h2_2 = device.svg.getElementById("p_dps_cryo_qty_h2_2");
    p_dps_cryo.qty_h2_3 = device.svg.getElementById("p_dps_cryo_qty_h2_3");
    p_dps_cryo.qty_h2_4 = device.svg.getElementById("p_dps_cryo_qty_h2_4");
    p_dps_cryo.qty_h2_5 = device.svg.getElementById("p_dps_cryo_qty_h2_5");


    p_dps_cryo.h2_manfp_1 = device.svg.getElementById("p_dps_cryo_h2_manfp_1");
    p_dps_cryo.h2_manfp_2 = device.svg.getElementById("p_dps_cryo_h2_manfp_2");

    p_dps_cryo.h2_vlv_1 = device.svg.getElementById("p_dps_cryo_h2_vlv_1");
    p_dps_cryo.h2_vlv_2 = device.svg.getElementById("p_dps_cryo_h2_vlv_2");







    
    p_dps_cryo.ondisplay = func
    {
        device.DPS_menu_title.setText("CRYO SYSTEM");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-sm");
    
        var ops_string = major_mode~"1/   /068";
        device.DPS_menu_ops.setText(ops_string);


	# the display largely defaults to dummy values, we have no failure modes for the cryo

	p_dps_cryo.p_o2_1.setText("816");
	p_dps_cryo.p_o2_2.setText("813");
	p_dps_cryo.p_o2_3.setText("816");
	p_dps_cryo.p_o2_4.setText("814");
	p_dps_cryo.p_o2_5.setText("814");

	p_dps_cryo.tkp_o2_1.setText("816");
	p_dps_cryo.tkp_o2_2.setText("814");
	p_dps_cryo.tkp_o2_3.setText("817");
	p_dps_cryo.tkp_o2_4.setText("815");
	p_dps_cryo.tkp_o2_5.setText("814");

	p_dps_cryo.o2_manfp_1.setText("815");
	p_dps_cryo.o2_manfp_2.setText("816");

	p_dps_cryo.HT1_o2_1.setText("-248");
	p_dps_cryo.HT1_o2_2.setText("-249");
	p_dps_cryo.HT1_o2_3.setText("-248");
	p_dps_cryo.HT1_o2_4.setText("-248");
	p_dps_cryo.HT1_o2_5.setText("-248");

	p_dps_cryo.HT2_o2_1.setText("-248");
	p_dps_cryo.HT2_o2_2.setText("-248");
	p_dps_cryo.HT2_o2_3.setText("-249");
	p_dps_cryo.HT2_o2_4.setText("-248");
	p_dps_cryo.HT2_o2_5.setText("-248");

	p_dps_cryo.T_o2_1.setText("-249");
	p_dps_cryo.T_o2_2.setText("-248");
	p_dps_cryo.T_o2_3.setText("-248");
	p_dps_cryo.T_o2_4.setText("-248");
	p_dps_cryo.T_o2_5.setText("-249");

	p_dps_cryo.o2_vlv_1.setText("OP");
	p_dps_cryo.o2_vlv_2.setText("OP");

	p_dps_cryo.p_h2_1.setText("208");
	p_dps_cryo.p_h2_2.setText("208");
	p_dps_cryo.p_h2_3.setText("206");
	p_dps_cryo.p_h2_4.setText("206");
	p_dps_cryo.p_h2_5.setText("206");

	p_dps_cryo.tkp_h2_1.setText("209");
	p_dps_cryo.tkp_h2_2.setText("208");
	p_dps_cryo.tkp_h2_3.setText("208");
	p_dps_cryo.tkp_h2_4.setText("207");
	p_dps_cryo.tkp_h2_5.setText("206");

	p_dps_cryo.T_h2_1.setText("-410");
	p_dps_cryo.T_h2_2.setText("-410");
	p_dps_cryo.T_h2_3.setText("-410");
	p_dps_cryo.T_h2_4.setText("-410");
	p_dps_cryo.T_h2_5.setText("-410");

	p_dps_cryo.HT_h2_1.setText("-410");
	p_dps_cryo.HT_h2_2.setText("-410");
	p_dps_cryo.HT_h2_3.setText("-410");
	p_dps_cryo.HT_h2_4.setText("-410");
	p_dps_cryo.HT_h2_5.setText("-410");


	p_dps_cryo.h2_manfp_1.setText("209");
	p_dps_cryo.h2_manfp_2.setText("209");

	p_dps_cryo.h2_vlv_1.setText("OP");
	p_dps_cryo.h2_vlv_2.setText("OP");




    }
    
    p_dps_cryo.update = func
    {
    
	var mission_time = getprop("/fdm/jsbsim/systems/timer/delta-MET") + getprop("/sim/time/elapsed-sec");
	var qty = (1.0 - (mission_time/(86400.0 * 12.0))) * 100.0;
	if (qty < 0.0) {qty = 0.0;}

	p_dps_cryo.qty_o2_1.setText(sprintf("%3.0f", qty ));
	p_dps_cryo.qty_o2_2.setText(sprintf("%3.0f", qty ));
	p_dps_cryo.qty_o2_3.setText(sprintf("%3.0f", qty ));
	p_dps_cryo.qty_o2_4.setText(sprintf("%3.0f", qty ));
	p_dps_cryo.qty_o2_5.setText(sprintf("%3.0f", qty ));

	p_dps_cryo.qty_h2_1.setText(sprintf("%3.0f", qty ));
	p_dps_cryo.qty_h2_2.setText(sprintf("%3.0f", qty ));
	p_dps_cryo.qty_h2_3.setText(sprintf("%3.0f", qty ));
	p_dps_cryo.qty_h2_4.setText(sprintf("%3.0f", qty ));
	p_dps_cryo.qty_h2_5.setText(sprintf("%3.0f", qty ));

        device.update_common_DPS();
    }
    
    
    
    return p_dps_cryo;
}
