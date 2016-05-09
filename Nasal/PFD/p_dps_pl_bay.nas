#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_pl_bay
# Description: the payload bay management page
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_dps_pl_bay = func(device)
{
    var p_dps_pl_bay = device.addPage("CRTPlBay", "p_dps_pl_bay");

    p_dps_pl_bay.group = device.svg.getElementById("p_dps_pl_bay");
    p_dps_pl_bay.group.setColor(dps_r, dps_g, dps_b);
    
    p_dps_pl_bay.acpower_on = device.svg.getElementById("p_dps_pl_bay_acpower_on");
    p_dps_pl_bay.acpower_off = device.svg.getElementById("p_dps_pl_bay_acpower_off");
    
    p_dps_pl_bay.auto_mode = device.svg.getElementById("p_dps_pl_bay_auto_mode");
    
    p_dps_pl_bay.pbd_sw = device.svg.getElementById("p_dps_pl_bay_pbd_sw");
    
    
    
    p_dps_pl_bay.cl1_4_op =  device.svg.getElementById("p_dps_pl_bay_cl1_4_op");
    p_dps_pl_bay.cl1_4_man =  device.svg.getElementById("p_dps_pl_bay_cl1_4_man");
    p_dps_pl_bay.cl1_4_msl =  device.svg.getElementById("p_dps_pl_bay_cl1_4_msl");
    p_dps_pl_bay.cl1_4_as =  device.svg.getElementById("p_dps_pl_bay_cl1_4_as");
    
    p_dps_pl_bay.cl5_8_op =  device.svg.getElementById("p_dps_pl_bay_cl5_8_op");
    p_dps_pl_bay.cl5_8_man =  device.svg.getElementById("p_dps_pl_bay_cl5_8_man");
    p_dps_pl_bay.cl5_8_msl =  device.svg.getElementById("p_dps_pl_bay_cl5_8_msl");
    p_dps_pl_bay.cl5_8_as =  device.svg.getElementById("p_dps_pl_bay_cl5_8_as");
    
    p_dps_pl_bay.cl9_12_op =  device.svg.getElementById("p_dps_pl_bay_cl9_12_op");
    p_dps_pl_bay.cl9_12_man =  device.svg.getElementById("p_dps_pl_bay_cl9_12_man");
    p_dps_pl_bay.cl9_12_msl =  device.svg.getElementById("p_dps_pl_bay_cl9_12_msl");
    p_dps_pl_bay.cl9_12_as =  device.svg.getElementById("p_dps_pl_bay_cl9_12_as");
    
    p_dps_pl_bay.cl13_16_op =  device.svg.getElementById("p_dps_pl_bay_cl13_16_op");
    p_dps_pl_bay.cl13_16_man =  device.svg.getElementById("p_dps_pl_bay_cl13_16_man");
    p_dps_pl_bay.cl13_16_msl =  device.svg.getElementById("p_dps_pl_bay_cl13_16_msl");
    p_dps_pl_bay.cl13_16_as =  device.svg.getElementById("p_dps_pl_bay_cl13_16_as");
    
    
    p_dps_pl_bay.sfwd_op =  device.svg.getElementById("p_dps_pl_bay_sfwd_op");
    p_dps_pl_bay.sfwd_man =  device.svg.getElementById("p_dps_pl_bay_sfwd_man");
    p_dps_pl_bay.sfwd_msl =  device.svg.getElementById("p_dps_pl_bay_sfwd_msl");
    p_dps_pl_bay.sfwd_as =  device.svg.getElementById("p_dps_pl_bay_sfwd_as");
    
    p_dps_pl_bay.saft_op =  device.svg.getElementById("p_dps_pl_bay_saft_op");
    p_dps_pl_bay.saft_man =  device.svg.getElementById("p_dps_pl_bay_saft_man");
    p_dps_pl_bay.saft_msl =  device.svg.getElementById("p_dps_pl_bay_saft_msl");
    p_dps_pl_bay.saft_as =  device.svg.getElementById("p_dps_pl_bay_saft_as");
    
    p_dps_pl_bay.pfwd_op =  device.svg.getElementById("p_dps_pl_bay_pfwd_op");
    p_dps_pl_bay.pfwd_man =  device.svg.getElementById("p_dps_pl_bay_pfwd_man");
    p_dps_pl_bay.pfwd_msl =  device.svg.getElementById("p_dps_pl_bay_pfwd_msl");
    p_dps_pl_bay.pfwd_as =  device.svg.getElementById("p_dps_pl_bay_pfwd_as");
    
    p_dps_pl_bay.paft_op =  device.svg.getElementById("p_dps_pl_bay_paft_op");
    p_dps_pl_bay.paft_man =  device.svg.getElementById("p_dps_pl_bay_paft_man");
    p_dps_pl_bay.paft_msl =  device.svg.getElementById("p_dps_pl_bay_paft_msl");
    p_dps_pl_bay.paft_as =  device.svg.getElementById("p_dps_pl_bay_paft_as");
    
    p_dps_pl_bay.sdoor_op =  device.svg.getElementById("p_dps_pl_bay_sdoor_op");
    p_dps_pl_bay.sdoor_man =  device.svg.getElementById("p_dps_pl_bay_sdoor_man");
    p_dps_pl_bay.sdoor_as =  device.svg.getElementById("p_dps_pl_bay_sdoor_as");
    
    p_dps_pl_bay.pdoor_op =  device.svg.getElementById("p_dps_pl_bay_pdoor_op");
    p_dps_pl_bay.pdoor_man =  device.svg.getElementById("p_dps_pl_bay_pdoor_man");
    p_dps_pl_bay.pdoor_as =  device.svg.getElementById("p_dps_pl_bay_pdoor_as");
    
    p_dps_pl_bay.swbyp =  device.svg.getElementById("p_dps_pl_bay_swbyp");
    
    p_dps_pl_bay.open =  device.svg.getElementById("p_dps_pl_bay_open");
    p_dps_pl_bay.stop =  device.svg.getElementById("p_dps_pl_bay_stop");
    p_dps_pl_bay.close =  device.svg.getElementById("p_dps_pl_bay_close");
    
    p_dps_pl_bay.sfwd_msd =  device.svg.getElementById("p_dps_pl_bay_sfwd_msd");
    p_dps_pl_bay.saft_msd =  device.svg.getElementById("p_dps_pl_bay_saft_msd");
    
    p_dps_pl_bay.pfwd_msd =  device.svg.getElementById("p_dps_pl_bay_pfwd_msd");
    p_dps_pl_bay.paft_msd =  device.svg.getElementById("p_dps_pl_bay_paft_msd");
    
    
    p_dps_pl_bay.ondisplay = func
    {
        device.DPS_menu_title.setText("PL BAY DOORS");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"202/   /";
        device.DPS_menu_ops.setText(ops_string);
    
    # blank autosequence failures as they're not yet supported
    
        p_dps_pl_bay.cl1_4_as.setText(sprintf(""));
        p_dps_pl_bay.cl5_8_as.setText(sprintf(""));
        p_dps_pl_bay.cl9_12_as.setText(sprintf(""));
        p_dps_pl_bay.cl13_16_as.setText(sprintf(""));
        p_dps_pl_bay.sfwd_as.setText(sprintf(""));
        p_dps_pl_bay.saft_as.setText(sprintf(""));
        p_dps_pl_bay.pfwd_as.setText(sprintf(""));
        p_dps_pl_bay.paft_as.setText(sprintf(""));
        p_dps_pl_bay.sdoor_as.setText(sprintf(""));
        p_dps_pl_bay.pdoor_as.setText(sprintf(""));
    }
    
    p_dps_pl_bay.update = func
    {
    
        var symbol1 = "";
        var symbol2 = "";
    
        if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-power") == 1)
    	{symbol1 = "*";}
        else 
    	{symbol2 = "*";}
    
        p_dps_pl_bay.acpower_on.setText( symbol1 );
        p_dps_pl_bay.acpower_off.setText( symbol2 );
    
    
        var status = getprop("/fdm/jsbsim/systems/mechanical/pb-door-cl1-4-latch-pos");
        symbol1 = latch_stat_to_string(status);
        symbol2 = latch_stat_to_microsw(status);
        var symbol3 = "";
        if (symbol1 == "") {symbol3 = "*";}
        p_dps_pl_bay.cl1_4_op.setText(sprintf(" %s", symbol1 ));
        p_dps_pl_bay.cl1_4_msl.setText( symbol2 );
        p_dps_pl_bay.cl1_4_man.setText( symbol3 );
    
        status = getprop("/fdm/jsbsim/systems/mechanical/pb-door-cl5-8-latch-pos");
        symbol1 = latch_stat_to_string(status);
        symbol2 = latch_stat_to_microsw(status);
        symbol3 = "";
        if (symbol1 == "") {symbol3 = "*";}
        p_dps_pl_bay.cl5_8_op.setText(sprintf(" %s", symbol1 ));
        p_dps_pl_bay.cl5_8_msl.setText( symbol2 );
        p_dps_pl_bay.cl5_8_man.setText( symbol3 );
    
        status = getprop("/fdm/jsbsim/systems/mechanical/pb-door-cl9-12-latch-pos");
        symbol1 = latch_stat_to_string(status);
        symbol2 = latch_stat_to_microsw(status);
        symbol3 = "";
        if (symbol1 == "") {symbol3 = "*";}
        p_dps_pl_bay.cl9_12_op.setText(sprintf(" %s", symbol1 ));
        p_dps_pl_bay.cl9_12_msl.setText( symbol2 );
        p_dps_pl_bay.cl9_12_man.setText( symbol3 );
    
        status = getprop("/fdm/jsbsim/systems/mechanical/pb-door-cl13-16-latch-pos");
        symbol1 = latch_stat_to_string(status);
        symbol2 = latch_stat_to_microsw(status);
        symbol3 = "";
        if (symbol1 == "") {symbol3 = "*";}
        p_dps_pl_bay.cl13_16_op.setText(sprintf(" %s", symbol1 ));
        p_dps_pl_bay.cl13_16_msl.setText( symbol2 );
        p_dps_pl_bay.cl13_16_man.setText( symbol3 );
    
    
        var sdoor_status = getprop("/fdm/jsbsim/systems/mechanical/pb-door-right-pos");
        var pdoor_status = getprop("/fdm/jsbsim/systems/mechanical/pb-door-left-pos");
    
        var slfwd_status = getprop("/fdm/jsbsim/systems/mechanical/pb-door-right-fwd-latch-pos");
        var slaft_status = getprop("/fdm/jsbsim/systems/mechanical/pb-door-right-aft-latch-pos");
    
        var plfwd_status = getprop("/fdm/jsbsim/systems/mechanical/pb-door-left-fwd-latch-pos");
        var plaft_status = getprop("/fdm/jsbsim/systems/mechanical/pb-door-left-aft-latch-pos");
    
        var symbol4 = "";
    
        status = slfwd_status; 
        symbol1 = latch_stat_to_string(status);
        symbol2 = latch_stat_to_microsw(status);
        symbol3 = "";
        if (symbol1 == "") {symbol3 = "*";}
        symbol4 = door_stat_to_microsw(status, sdoor_status);
        p_dps_pl_bay.sfwd_op.setText(sprintf(" %s", symbol1 ));
        p_dps_pl_bay.sfwd_msl.setText( symbol2 );
        p_dps_pl_bay.sfwd_man.setText( symbol3 );
        p_dps_pl_bay.sfwd_msd.setText( symbol4 );
    
        status = slaft_status;
        symbol1 = latch_stat_to_string(status);
        symbol2 = latch_stat_to_microsw(status);
        symbol3 = "";
        if (symbol1 == "") {symbol3 = "*";}
        symbol4 = door_stat_to_microsw(status, sdoor_status);
        p_dps_pl_bay.saft_op.setText(sprintf(" %s", symbol1 ));
        p_dps_pl_bay.saft_msl.setText( symbol2 );
        p_dps_pl_bay.saft_man.setText( symbol3 );
        p_dps_pl_bay.saft_msd.setText( symbol4 );
    
        status = plfwd_status;
        symbol1 = latch_stat_to_string(status);
        symbol2 = latch_stat_to_microsw(status);
        symbol3 = "";
        if (symbol1 == "") {symbol3 = "*";}
        symbol4 = door_stat_to_microsw(status, pdoor_status);
        p_dps_pl_bay.pfwd_op.setText(sprintf(" %s", symbol1 ));
        p_dps_pl_bay.pfwd_msl.setText( symbol2 );
        p_dps_pl_bay.pfwd_man.setText( symbol3 );
        p_dps_pl_bay.pfwd_msd.setText( symbol4 );
    
        status = plaft_status;
        symbol1 = latch_stat_to_string(status);
        symbol2 = latch_stat_to_microsw(status);
        symbol3 = "";
        if (symbol1 == "") {symbol3 = "*";}
        symbol4 = door_stat_to_microsw(status, pdoor_status);
        p_dps_pl_bay.paft_op.setText(sprintf(" %s", symbol1 ));
        p_dps_pl_bay.paft_msl.setText( symbol2 );
        p_dps_pl_bay.paft_man.setText( symbol3 );
        p_dps_pl_bay.paft_msd.setText( symbol4 );
    
    
    
    
    
        status = getprop("/fdm/jsbsim/systems/mechanical/pb-door-right-pos");
        symbol1 = door_stat_to_string(status, slfwd_status, slaft_status);
        symbol3 = "";
        if (symbol1 == "") {symbol3 = "*";}
        p_dps_pl_bay.sdoor_op.setText(sprintf(" %s", symbol1 ));
        p_dps_pl_bay.sdoor_man.setText( symbol3 );
    
        status = getprop("/fdm/jsbsim/systems/mechanical/pb-door-left-pos");
        symbol1 = door_stat_to_string(status, plfwd_status, plaft_status);
        symbol3 = "";
        if (symbol1 == "") {symbol3 = "*";}
        p_dps_pl_bay.pdoor_op.setText(sprintf(" %s", symbol1 ));
        p_dps_pl_bay.pdoor_man.setText( symbol3 );
    
    
    
    
        status = getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto");
        if (status == 0) {symbol1 = "";} else {symbol1 = "*";}
        p_dps_pl_bay.auto_mode.setText( symbol1 );
    
        status = getprop("/fdm/jsbsim/systems/mechanical/pb-door-auto-switch");
        if (status == -1) {symbol1 = "CL";}
        else if (status == 0) {symbol1 = "STOP";}
        else if (status == 1) {symbol1 = "OP";}
        else {symbol1 = "FAIL";}
    
        if (getprop("/fdm/jsbsim/systems/failures/payload-bay-switch-condition") < 1.0)
    	{
            symbol1 = "FAIL";
    	}
    
        p_dps_pl_bay.pbd_sw.setText( symbol1 );
    
        status = getprop("/fdm/jsbsim/systems/mechanical/pb-door-software-bypass");
        if (status == 1) {symbol1 = "*";} else {symbol1 = "";}
        p_dps_pl_bay.swbyp.setText( symbol1 );
    
        status = getprop("/fdm/jsbsim/systems/mechanical/pb-door-software-switch");
    
        if (status == 1) {symbol1 = "*";} else {symbol1 = "";}
        p_dps_pl_bay.open.setText( symbol1 );
    
        if (status == 0) {symbol1 = "*";} else {symbol1 = "";}
        p_dps_pl_bay.stop.setText( symbol1 );
    
        if (status == -1) {symbol1 = "*";} else {symbol1 = "";}
        p_dps_pl_bay.close.setText( symbol1 );
    
        device.update_common_DPS();
    
    
    
    }
    
    
    return p_dps_pl_bay;
}
