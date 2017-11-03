#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_override
# Description: the override page
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_dps_override = func(device)
{
    var p_dps_override = device.addPage("CRTOverride", "p_dps_override");

    p_dps_override.group = device.svg.getElementById("p_dps_override");
    p_dps_override.group.setColor(dps_r, dps_g, dps_b);    

    p_dps_override.etsep_auto =  device.svg.getElementById("p_dps_override_etsep_auto");
    p_dps_override.etsep_sep =  device.svg.getElementById("p_dps_override_etsep_sep");
    p_dps_override.umb_cl =  device.svg.getElementById("p_dps_override_umb_cl");
    
    p_dps_override.adta_h1 =  device.svg.getElementById("p_dps_override_adta_h1");
    p_dps_override.adta_h2 =  device.svg.getElementById("p_dps_override_adta_h2");
    p_dps_override.adta_h3 =  device.svg.getElementById("p_dps_override_adta_h3");
    p_dps_override.adta_h4 =  device.svg.getElementById("p_dps_override_adta_h4");
    
    p_dps_override.adta_M1 =  device.svg.getElementById("p_dps_override_adta_M1");
    p_dps_override.adta_M2 =  device.svg.getElementById("p_dps_override_adta_M2");
    p_dps_override.adta_M3 =  device.svg.getElementById("p_dps_override_adta_M3");
    p_dps_override.adta_M4 =  device.svg.getElementById("p_dps_override_adta_M4");
    
    p_dps_override.adta_a1 =  device.svg.getElementById("p_dps_override_adta_a1");
    p_dps_override.adta_a2 =  device.svg.getElementById("p_dps_override_adta_a2");
    p_dps_override.adta_a3 =  device.svg.getElementById("p_dps_override_adta_a3");
    p_dps_override.adta_a4 =  device.svg.getElementById("p_dps_override_adta_a4");
    
    p_dps_override.adta_des1 =  device.svg.getElementById("p_dps_override_adta_des1");
    p_dps_override.adta_des2 =  device.svg.getElementById("p_dps_override_adta_des2");
    p_dps_override.adta_des3 =  device.svg.getElementById("p_dps_override_adta_des3");
    p_dps_override.adta_des4 =  device.svg.getElementById("p_dps_override_adta_des4");
    
    p_dps_override.adta_l1 =  device.svg.getElementById("p_dps_override_adta_l1");
    p_dps_override.adta_l3 =  device.svg.getElementById("p_dps_override_adta_l3");
    p_dps_override.adta_r2 =  device.svg.getElementById("p_dps_override_adta_r2");
    p_dps_override.adta_r4 =  device.svg.getElementById("p_dps_override_adta_r4");
    
    p_dps_override.arcsdump =  device.svg.getElementById("p_dps_override_arcsdump");
    p_dps_override.frcsdump =  device.svg.getElementById("p_dps_override_frcsdump");
    p_dps_override.frcs_ttg =  device.svg.getElementById("p_dps_override_frcs_ttg");
    p_dps_override.arcs_ttg =  device.svg.getElementById("p_dps_override_arcs_ttg");
    
    p_dps_override.arcsdump.enableUpdate();
    p_dps_override.frcsdump.enableUpdate();
    p_dps_override.frcs_ttg.enableUpdate();
    p_dps_override.arcs_ttg.enableUpdate();

    p_dps_override.icnct1 =  device.svg.getElementById("p_dps_override_icnct1");
    p_dps_override.icnct2 =  device.svg.getElementById("p_dps_override_icnct2");

    p_dps_override.icnct1.enableUpdate();
    p_dps_override.icnct2.enableUpdate();
    

    
    p_dps_override.omsdump_arm =  device.svg.getElementById("p_dps_override_omsdump_arm");
    p_dps_override.omsdump_start =  device.svg.getElementById("p_dps_override_omsdump_start");
    p_dps_override.omsdump_stop =  device.svg.getElementById("p_dps_override_omsdump_stop");
    p_dps_override.omsdump_qty =  device.svg.getElementById("p_dps_override_omsdump_qty");
    p_dps_override.omsdump_ttg =  device.svg.getElementById("p_dps_override_omsdump_ttg");

    p_dps_override.omsdump_arm.enableUpdate();
    p_dps_override.omsdump_start.enableUpdate();
    p_dps_override.omsdump_stop.enableUpdate();
    p_dps_override.omsdump_qty.enableUpdate();
    p_dps_override.omsdump_ttg.enableUpdate();

    p_dps_override.tal =  device.svg.getElementById("p_dps_override_tal");
    p_dps_override.ato =  device.svg.getElementById("p_dps_override_ato");
    p_dps_override.abort =  device.svg.getElementById("p_dps_override_abort");
    
    p_dps_override.throt_max =  device.svg.getElementById("p_dps_override_throt_max");
    p_dps_override.throt_abt =  device.svg.getElementById("p_dps_override_throt_abt");
    p_dps_override.throt_nom =  device.svg.getElementById("p_dps_override_throt_nom");
    
    p_dps_override.elev_auto =  device.svg.getElementById("p_dps_override_elev_auto");
    p_dps_override.elev_fixed =  device.svg.getElementById("p_dps_override_elev_fixed");
    p_dps_override.filter_nom =  device.svg.getElementById("p_dps_override_filter_nom");
    p_dps_override.filter_alt =  device.svg.getElementById("p_dps_override_filter_alt");
    p_dps_override.atmo_nom =  device.svg.getElementById("p_dps_override_atmo_nom");
    p_dps_override.atmo_npole =  device.svg.getElementById("p_dps_override_atmo_npole");
    p_dps_override.atmo_spole =  device.svg.getElementById("p_dps_override_atmo_spole");
    
    p_dps_override.imu1s =  device.svg.getElementById("p_dps_override_imu1s");
    p_dps_override.imu2s =  device.svg.getElementById("p_dps_override_imu2s");
    p_dps_override.imu3s =  device.svg.getElementById("p_dps_override_imu3s");
    p_dps_override.imu1stat =  device.svg.getElementById("p_dps_override_imu1stat");
    p_dps_override.imu2stat =  device.svg.getElementById("p_dps_override_imu2stat");
    p_dps_override.imu3stat =  device.svg.getElementById("p_dps_override_imu3stat");
    p_dps_override.imu1att =  device.svg.getElementById("p_dps_override_imu1att");
    p_dps_override.imu2att =  device.svg.getElementById("p_dps_override_imu2att");
    p_dps_override.imu1des =  device.svg.getElementById("p_dps_override_imu1des");
    p_dps_override.imu2des =  device.svg.getElementById("p_dps_override_imu2des");
    p_dps_override.imu3des =  device.svg.getElementById("p_dps_override_imu3des");

    p_dps_override.imu1des.enableUpdate();
    p_dps_override.imu2des.enableUpdate();
    p_dps_override.imu3des.enableUpdate();

    p_dps_override.imu1s.enableUpdate();
    p_dps_override.imu2s.enableUpdate();
    p_dps_override.imu3s.enableUpdate();

    p_dps_override.imu1stat.enableUpdate();
    p_dps_override.imu2stat.enableUpdate();
    p_dps_override.imu3stat.enableUpdate();

    p_dps_override.imu1att.enableUpdate();
    
    p_dps_override.prl_sys1 =  device.svg.getElementById("p_dps_override_prl_sys1");
    p_dps_override.prl_sys2 =  device.svg.getElementById("p_dps_override_prl_sys2");
    p_dps_override.prl_sys3 =  device.svg.getElementById("p_dps_override_prl_sys3");
    p_dps_override.prl1_aut =  device.svg.getElementById("p_dps_override_prl1_aut");
    p_dps_override.prl2_aut =  device.svg.getElementById("p_dps_override_prl2_aut");
    p_dps_override.prl3_aut =  device.svg.getElementById("p_dps_override_prl3_aut");
    p_dps_override.prl1_des =  device.svg.getElementById("p_dps_override_prl1_des");
    p_dps_override.prl2_des =  device.svg.getElementById("p_dps_override_prl2_des");
    p_dps_override.prl3_des =  device.svg.getElementById("p_dps_override_prl3_des");
    
    p_dps_override.roll_mode =  device.svg.getElementById("p_dps_override_roll_mode");
    p_dps_override.roll_auto =  device.svg.getElementById("p_dps_override_roll_auto");
    p_dps_override.wrap_mode =  device.svg.getElementById("p_dps_override_wrap_mode");
    
    p_dps_override.roll_mode.enableUpdate();
    p_dps_override.roll_auto.enableUpdate();

    p_dps_override.vdoor_open =  device.svg.getElementById("p_dps_override_vdoor_open");
    p_dps_override.vdoor_open_stat =  device.svg.getElementById("p_dps_override_vdoor_open_stat");
    p_dps_override.vdoor_close =  device.svg.getElementById("p_dps_override_vdoor_close");
    p_dps_override.vdoor_close_stat =  device.svg.getElementById("p_dps_override_vdoor_close_stat");
    
    p_dps_override.ssme_repos =  device.svg.getElementById("p_dps_override_ssme_repos");
    p_dps_override.ssme_repos.enableUpdate();
    
    
    
    p_dps_override.ondisplay = func
    {
        device.DPS_menu_title.setText("OVERRIDE");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/051/";
        device.DPS_menu_ops.setText(ops_string);
    
    # blank unsupported functions
        p_dps_override.etsep_auto.setText(sprintf(""));
    
        p_dps_override.elev_auto.setText(sprintf("*"));
        p_dps_override.elev_fixed.setText(sprintf(""));
        p_dps_override.filter_nom.setText(sprintf("*"));
        p_dps_override.filter_alt.setText(sprintf(""));
    
        p_dps_override.imu2att.setText(sprintf(""));

    
        p_dps_override.prl_sys1.setText(sprintf(""));
        p_dps_override.prl_sys2.setText(sprintf(""));
        p_dps_override.prl_sys3.setText(sprintf(""));
        p_dps_override.prl1_aut.setText(sprintf("*"));
        p_dps_override.prl2_aut.setText(sprintf("*"));
        p_dps_override.prl3_aut.setText(sprintf("*"));
        p_dps_override.prl1_des.setText(sprintf(""));
        p_dps_override.prl2_des.setText(sprintf(""));
        p_dps_override.prl3_des.setText(sprintf(""));
    
        #p_dps_override.roll_mode.setText(sprintf("AUTO"));
        #p_dps_override.roll_auto.setText(sprintf(""));
        p_dps_override.wrap_mode.setText(sprintf("INH"));
    
    	# blank ADTA which isn't shown in OPS 1 
        p_dps_override.adta_h1.setText(sprintf(""));
        p_dps_override.adta_h2.setText(sprintf(""));
        p_dps_override.adta_h3.setText(sprintf(""));
        p_dps_override.adta_h4.setText(sprintf(""));
    
        p_dps_override.adta_M1.setText(sprintf(""));
        p_dps_override.adta_M2.setText(sprintf(""));
        p_dps_override.adta_M3.setText(sprintf(""));
        p_dps_override.adta_M4.setText(sprintf(""));
    
        p_dps_override.adta_a1.setText(sprintf(""));
        p_dps_override.adta_a2.setText(sprintf(""));
        p_dps_override.adta_a3.setText(sprintf(""));
        p_dps_override.adta_a4.setText(sprintf(""));
    
        p_dps_override.ssme_repos.updateText(sprintf("")); 
    }
    
    p_dps_override.update = func
    {
    
        var symbol = "";
    
        if (getprop("/controls/shuttle/etsep-in-progress") == 1)
    	{
            symbol = "*";
    	}
    
        p_dps_override.etsep_sep.setText( symbol );
    
        symbol = "";
    
        if ((getprop("/fdm/jsbsim/systems/mechanical/et-door-cl-latch-cmd") == 0) and (getprop("/fdm/jsbsim/systems/mechanical/et-door-right-latch-pos") < 1.0))
    	{
            symbol = "*";
    	}
        p_dps_override.umb_cl.setText( symbol );


    # IMU system

	symbol = "";
	if (SpaceShuttle.imu_system.imu[0].deselected == 1) {symbol = "*";}
        p_dps_override.imu1des.updateText(symbol);

	symbol = "";
	if (SpaceShuttle.imu_system.imu[1].deselected == 1) {symbol = "*";}
        p_dps_override.imu2des.updateText(symbol);

	symbol = "";
	if (SpaceShuttle.imu_system.imu[2].deselected == 1) {symbol = "*";}
        p_dps_override.imu3des.updateText(symbol);

        p_dps_override.imu1s.updateText(SpaceShuttle.imu_system.imu[0].get_status_symbol());
        p_dps_override.imu2s.updateText(SpaceShuttle.imu_system.imu[1].get_status_symbol());
        p_dps_override.imu3s.updateText(SpaceShuttle.imu_system.imu[2].get_status_symbol());

	p_dps_override.imu1stat.updateText(SpaceShuttle.imu_system.imu[0].status_string);
    	p_dps_override.imu2stat.updateText(SpaceShuttle.imu_system.imu[1].status_string);
    	p_dps_override.imu3stat.updateText(SpaceShuttle.imu_system.imu[2].status_string);
    
        p_dps_override.imu1att.updateText(sprintf("%d", SpaceShuttle.imu_system.attitude_source+1));

    # ADTA is shown only in OPS 3 or 6
    
        var ops = getprop("/fdm/jsbsim/systems/dps/ops");
    
        if ((ops == 3) or (ops == 6))
        {

		var alt_raw = getprop("/fdm/jsbsim/systems/navigation/air-data-alt-ft-raw");
		var mach_raw = getprop("/fdm/jsbsim/systems/navigation/air-data-mach-raw");
		var aoa_raw = getprop("/fdm/jsbsim/systems/navigation/air-data-alpha-raw");
	
		var alt1 = SpaceShuttle.air_data_system.adta[0].indicated_alt(alt_raw);
		var alt2 = SpaceShuttle.air_data_system.adta[1].indicated_alt(alt_raw);
		var alt3 = SpaceShuttle.air_data_system.adta[2].indicated_alt(alt_raw);
		var alt4 = SpaceShuttle.air_data_system.adta[3].indicated_alt(alt_raw);
		
		var mach1 = SpaceShuttle.air_data_system.adta[0].indicated_mach(mach_raw);
		var mach2 = SpaceShuttle.air_data_system.adta[1].indicated_mach(mach_raw);
		var mach3 = SpaceShuttle.air_data_system.adta[2].indicated_mach(mach_raw);
		var mach4 = SpaceShuttle.air_data_system.adta[3].indicated_mach(mach_raw);
    
		var alpha1 = SpaceShuttle.air_data_system.adta[0].indicated_aoa(aoa_raw);
		var alpha2 = SpaceShuttle.air_data_system.adta[1].indicated_aoa(aoa_raw);
		var alpha3 = SpaceShuttle.air_data_system.adta[2].indicated_aoa(aoa_raw);
		var alpha4 = SpaceShuttle.air_data_system.adta[3].indicated_aoa(aoa_raw);
    
		if (SpaceShuttle.air_data_system.adta[0].operational == 1)
			{		
			p_dps_override.adta_h1.setText(sprintf("%6.0f", alt1));
		    	p_dps_override.adta_M1.setText(sprintf("%1.2f", mach1));
			p_dps_override.adta_a1.setText(sprintf("%+2.1f", alpha1));
			}
		else
			{
			p_dps_override.adta_h1.setText("");
		    	p_dps_override.adta_M1.setText("");
			p_dps_override.adta_a1.setText("");
			}

		if (SpaceShuttle.air_data_system.adta[1].operational == 1)
			{
			p_dps_override.adta_h2.setText(sprintf("%6.0f", alt2));
		    	p_dps_override.adta_M2.setText(sprintf("%1.2f", mach2));
			p_dps_override.adta_a2.setText(sprintf("%+2.1f", alpha2));
			}
		else
			{
			p_dps_override.adta_h2.setText("");
		    	p_dps_override.adta_M2.setText("");
			p_dps_override.adta_a2.setText("");
			}

		if (SpaceShuttle.air_data_system.adta[2].operational == 1)
			{
			p_dps_override.adta_h3.setText(sprintf("%6.0f", alt3));
		    	p_dps_override.adta_M3.setText(sprintf("%1.2f", mach3));
			p_dps_override.adta_a3.setText(sprintf("%+2.1f", alpha3));
			}
		else
			{
			p_dps_override.adta_h3.setText("");
		    	p_dps_override.adta_M3.setText("");
			p_dps_override.adta_a3.setText("");
			}

		if (SpaceShuttle.air_data_system.adta[3].operational == 1)
			{
			p_dps_override.adta_h4.setText(sprintf("%6.0f", alt4));
		    	p_dps_override.adta_M4.setText(sprintf("%1.2f", mach4));
			p_dps_override.adta_a4.setText(sprintf("%+2.1f", alpha4));
			}
		else
			{
			p_dps_override.adta_h4.setText("");
		    	p_dps_override.adta_M4.setText("");
			p_dps_override.adta_a4.setText("");
			}
        }
    
	var roll_mode = getprop("/fdm/jsbsim/systems/fcs/entry-mode-switch");
	
	if (roll_mode == 0)
		{symbol = "AUTO";}
	else if (roll_mode == 1)
		{symbol = "L GAIN";}
	else 
		{symbol = "NO YJET";}
	p_dps_override.roll_mode.updateText(symbol);

	symbol = "";
	if (getprop("/fdm/jsbsim/systems/fcs/entry-mode-sw-auto-switch") == 1){symbol = "*";}
	p_dps_override.roll_auto.updateText(symbol);

        symbol = "";
        if (SpaceShuttle.air_data_system.adta[0].deselected == 1){symbol = "*";}
        p_dps_override.adta_des1.setText( symbol );
    
    
        symbol = "";
        if (SpaceShuttle.air_data_system.adta[1].deselected == 1){symbol = "*";}
        p_dps_override.adta_des2.setText( symbol ); 
    
        symbol = "";
        if (SpaceShuttle.air_data_system.adta[2].deselected == 1){symbol = "*";}
        p_dps_override.adta_des3.setText( symbol );
    
        symbol = "";
        if (SpaceShuttle.air_data_system.adta[3].deselected == 1){symbol = "*";}
        p_dps_override.adta_des4.setText( symbol );
    

        p_dps_override.adta_l1.setText(SpaceShuttle.air_data_system.adta[0].status_string());
        p_dps_override.adta_l3.setText(SpaceShuttle.air_data_system.adta[2].status_string());
        p_dps_override.adta_r2.setText(SpaceShuttle.air_data_system.adta[1].status_string());
        p_dps_override.adta_r4.setText(SpaceShuttle.air_data_system.adta[3].status_string());


        symbol = "INH";
        if (getprop("/fdm/jsbsim/systems/rcs/aft-dump-arm-cmd") == 1){symbol = "ENA";}
        p_dps_override.arcsdump.updateText( symbol );
    
        symbol = "INH";
        if (getprop("/fdm/jsbsim/systems/rcs/fwd-dump-arm-cmd") == 1){symbol = "ENA";}
        p_dps_override.frcsdump.updateText( symbol );
    
        p_dps_override.frcs_ttg.updateText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/fwd-dump-time-s")));
        p_dps_override.arcs_ttg.updateText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/aft-dump-time-s")));
    
    
        symbol = "INH";
        if (getprop("/fdm/jsbsim/systems/oms/oms-dump-interconnect-cmd") == 1){symbol = "ENA";}
        p_dps_override.icnct1.updateText( symbol );
    
        symbol = "";
        if (getprop("/fdm/jsbsim/systems/oms/oms-dump-interconnect-complete") == 1){symbol = "CPLT";}
        p_dps_override.icnct2.updateText( symbol );
    
        symbol = "";
        if (getprop("/fdm/jsbsim/systems/oms/oms-dump-arm-cmd") == 1){symbol = "*";}
        p_dps_override.omsdump_arm.updateText( symbol );
    
        symbol = "";
        if (getprop("/fdm/jsbsim/systems/oms/oms-dump-cmd") == 1){symbol = "*";}
        p_dps_override.omsdump_start.updateText( symbol );
    
        symbol = "";
        if (getprop("/fdm/jsbsim/systems/oms/oms-dump-cmd") == 0){symbol = "*";}
        p_dps_override.omsdump_stop.updateText( symbol );
    
    
        p_dps_override.omsdump_qty.updateText(sprintf("%d", getprop("/fdm/jsbsim/systems/oms/oms-dump-qty")));
        p_dps_override.omsdump_ttg.updateText(sprintf("%d", getprop("/fdm/jsbsim/systems/oms/oms-dump-ttg-s")));
    
        symbol = "";
        if (getprop("/fdm/jsbsim/systems/abort/arm-tal") == 1) {symbol ="*";}
        p_dps_override.tal.setText( symbol );
    
        symbol = "";
        if (getprop("/fdm/jsbsim/systems/abort/arm-ato") == 1) {symbol ="*";}
        p_dps_override.ato.setText( symbol );
    
        symbol = "";
        if (getprop("/fdm/jsbsim/systems/abort/abort-mode") > 0) {symbol ="*";}
        p_dps_override.abort.setText( symbol );
    
        var throttle_mode = getprop("/fdm/jsbsim/systems/throttle/throttle-mode");
    
        symbol = "";
        if (throttle_mode == 1) {symbol ="*";}
        p_dps_override.throt_max.setText( symbol );
    
        symbol = "";
        if (throttle_mode == 2) {symbol ="*";}
        p_dps_override.throt_abt.setText( symbol );
    
        symbol = "";
        if (throttle_mode == 3) {symbol ="*";}
        p_dps_override.throt_nom.setText( symbol ); 
    
        symbol = "";
        if (getprop("/fdm/jsbsim/systems/mechanical/vdoor-cmd") == 1) {symbol ="*";}
        p_dps_override.vdoor_open.setText( symbol ); 
    
        symbol = "";
        if (getprop("/fdm/jsbsim/systems/mechanical/vdoor-pos") == 1.0) {symbol ="OP";}
        p_dps_override.vdoor_open_stat.setText( symbol ); 
    
        symbol = "";
        if (getprop("/fdm/jsbsim/systems/mechanical/vdoor-cmd") == 0) {symbol ="*";}
        p_dps_override.vdoor_close.setText( symbol ); 
    
        symbol = "";
        if (getprop("/fdm/jsbsim/systems/mechanical/vdoor-pos") == 0.0) {symbol ="CL";}
        p_dps_override.vdoor_close_stat.setText( symbol ); 
    
	symbol = "";
	if (SpaceShuttle.area_nav_set.drag_h_atm_model == 0) {symbol= "*";}
        p_dps_override.atmo_nom.setText(symbol);

	symbol = "";
	if (SpaceShuttle.area_nav_set.drag_h_atm_model == 1) {symbol= "*";}
         p_dps_override.atmo_npole.setText(symbol);

	symbol = "";
	if (SpaceShuttle.area_nav_set.drag_h_atm_model == 2) {symbol= "*";}
        p_dps_override.atmo_spole.setText(symbol);

        if (ops == 3)
        {
            symbol = "INH";
            if (getprop("/fdm/jsbsim/systems/vectoring/ssme-repos-enable") == 1) {symbol ="ENA";}
            p_dps_override.ssme_repos.updateText( symbol ); 
        }
    
        device.update_common_DPS();
    
    }
    
    
    
    
    
    return p_dps_override;
}
