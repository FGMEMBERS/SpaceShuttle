#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_bfs_override
# Description: the BFS override page
#      Author: Thorsten Renk, 2017
#---------------------------------------

var PFD_addpage_p_dps_bfs_override = func(device)
{
    var p_dps_bfs_override = device.addPage("CRTBFSOverride", "p_dps_bfs_override");

    p_dps_bfs_override.group = device.svg.getElementById("p_dps_bfs_override");
    p_dps_bfs_override.group.setColor(dps_r, dps_g, dps_b);

    p_dps_bfs_override.arcsdump =  device.svg.getElementById("p_dps_bfs_override_arcsdump");
    p_dps_bfs_override.frcsdump =  device.svg.getElementById("p_dps_bfs_override_frcsdump");

    p_dps_bfs_override.arcsdump.enableUpdate();
    p_dps_bfs_override.frcsdump.enableUpdate();

    p_dps_bfs_override.frcs_ttg =  device.svg.getElementById("p_dps_bfs_override_frcs_ttg");
    p_dps_bfs_override.arcs_ttg =  device.svg.getElementById("p_dps_bfs_override_arcs_ttg");


    p_dps_bfs_override.frcs_ttg.enableUpdate();
    p_dps_bfs_override.arcs_ttg.enableUpdate();

    p_dps_bfs_override.icnct1 =  device.svg.getElementById("p_dps_bfs_override_icnct1");
    p_dps_bfs_override.icnct2 =  device.svg.getElementById("p_dps_bfs_override_icnct2");

    p_dps_bfs_override.icnct1.enableUpdate(); 
    p_dps_bfs_override.icnct2.enableUpdate();

    p_dps_bfs_override.omsdump_arm =  device.svg.getElementById("p_dps_bfs_override_omsdump_arm");
    p_dps_bfs_override.omsdump_start =  device.svg.getElementById("p_dps_bfs_override_omsdump_start");
    p_dps_bfs_override.omsdump_stop =  device.svg.getElementById("p_dps_bfs_override_omsdump_stop");
    p_dps_bfs_override.omsdump_qty =  device.svg.getElementById("p_dps_bfs_override_omsdump_qty");
    p_dps_bfs_override.omsdump_ttg =  device.svg.getElementById("p_dps_bfs_override_omsdump_ttg");
    
    p_dps_bfs_override.omsdump_arm.enableUpdate(); 
    p_dps_bfs_override.omsdump_start.enableUpdate(); 
    p_dps_bfs_override.omsdump_stop.enableUpdate(); 
    p_dps_bfs_override.omsdump_qty.enableUpdate(); 
    p_dps_bfs_override.omsdump_ttg.enableUpdate(); 

    p_dps_bfs_override.tal =  device.svg.getElementById("p_dps_bfs_override_tal");
    p_dps_bfs_override.ato =  device.svg.getElementById("p_dps_bfs_override_ato");
    p_dps_bfs_override.abort =  device.svg.getElementById("p_dps_bfs_override_abort");
    
    p_dps_bfs_override.tal.enableUpdate();
    p_dps_bfs_override.ato.enableUpdate();
    p_dps_bfs_override.abort.enableUpdate();

    p_dps_bfs_override.throt_max =  device.svg.getElementById("p_dps_bfs_override_throt_max");
    p_dps_bfs_override.throt_abt =  device.svg.getElementById("p_dps_bfs_override_throt_abt");
    p_dps_bfs_override.throt_nom =  device.svg.getElementById("p_dps_bfs_override_throt_nom");
    
    p_dps_bfs_override.throt_max.enableUpdate();
    p_dps_bfs_override.throt_abt.enableUpdate();
    p_dps_bfs_override.throt_nom.enableUpdate();

    p_dps_bfs_override.elev_auto =  device.svg.getElementById("p_dps_bfs_override_elev_auto");
    p_dps_bfs_override.elev_fixed =  device.svg.getElementById("p_dps_bfs_override_elev_fixed");
    p_dps_bfs_override.filter_nom =  device.svg.getElementById("p_dps_bfs_override_filter_nom");
    p_dps_bfs_override.filter_alt =  device.svg.getElementById("p_dps_bfs_override_filter_alt");
    p_dps_bfs_override.atmo_nom =  device.svg.getElementById("p_dps_bfs_override_atmo_nom");
    p_dps_bfs_override.atmo_npole =  device.svg.getElementById("p_dps_bfs_override_atmo_npole");
    p_dps_bfs_override.atmo_spole =  device.svg.getElementById("p_dps_bfs_override_atmo_spole");
    
    p_dps_bfs_override.elev_auto.enableUpdate();
    p_dps_bfs_override.elev_fixed.enableUpdate();
    p_dps_bfs_override.filter_nom.enableUpdate();
    p_dps_bfs_override.filter_alt.enableUpdate();
    p_dps_bfs_override.atmo_nom.enableUpdate();
    p_dps_bfs_override.atmo_npole.enableUpdate();
    p_dps_bfs_override.atmo_spole.enableUpdate();

    p_dps_bfs_override.ssme_repos =  device.svg.getElementById("p_dps_bfs_override_ssme_repos");
    p_dps_bfs_override.ssme_repos.enableUpdate();

    p_dps_bfs_override.imu1_des =  device.svg.getElementById("p_dps_bfs_override_imu1_des");
    p_dps_bfs_override.imu2_des =  device.svg.getElementById("p_dps_bfs_override_imu2_des");
    p_dps_bfs_override.imu3_des =  device.svg.getElementById("p_dps_bfs_override_imu3_des");
    p_dps_bfs_override.imu_att =  device.svg.getElementById("p_dps_bfs_override_imu_att");

    p_dps_bfs_override.imu1_des.enableUpdate();
    p_dps_bfs_override.imu2_des.enableUpdate();
    p_dps_bfs_override.imu3_des.enableUpdate();
    p_dps_bfs_override.imu_att.enableUpdate();

    p_dps_bfs_override.lru1_des =  device.svg.getElementById("p_dps_bfs_override_lru1_des");
    p_dps_bfs_override.lru2_des =  device.svg.getElementById("p_dps_bfs_override_lru2_des");
    p_dps_bfs_override.lru3_des =  device.svg.getElementById("p_dps_bfs_override_lru3_des");
    p_dps_bfs_override.lru4_des =  device.svg.getElementById("p_dps_bfs_override_lru4_des");

    p_dps_bfs_override.rga1_des =  device.svg.getElementById("p_dps_bfs_override_rga1_des");
    p_dps_bfs_override.rga2_des =  device.svg.getElementById("p_dps_bfs_override_rga2_des");
    p_dps_bfs_override.rga3_des =  device.svg.getElementById("p_dps_bfs_override_rga3_des");
    p_dps_bfs_override.rga4_des =  device.svg.getElementById("p_dps_bfs_override_rga4_des");

    p_dps_bfs_override.surf1_des =  device.svg.getElementById("p_dps_bfs_override_surf1_des");
    p_dps_bfs_override.surf2_des =  device.svg.getElementById("p_dps_bfs_override_surf2_des");
    p_dps_bfs_override.surf3_des =  device.svg.getElementById("p_dps_bfs_override_surf3_des");
    p_dps_bfs_override.surf4_des =  device.svg.getElementById("p_dps_bfs_override_surf4_des");
    
    p_dps_bfs_override.wrap_mode =  device.svg.getElementById("p_dps_bfs_override_wrap_mode");
    p_dps_bfs_override.wrap_mode.enableUpdate();

    p_dps_bfs_override.et_umb_dr_close = device.svg.getElementById("p_dps_bfs_override_et_umb_dr_close");
    p_dps_bfs_override.et_umb_dr_close.enableUpdate();

    p_dps_bfs_override.etsep_auto = device.svg.getElementById("p_dps_bfs_override_etsep_auto");
    p_dps_bfs_override.etsep_sep = device.svg.getElementById("p_dps_bfs_override_etsep_sep");

    p_dps_bfs_override.etsep_auto.enableUpdate();
    p_dps_bfs_override.etsep_sep.enableUpdate();

    p_dps_bfs_override.vdoor_open = device.svg.getElementById("p_dps_bfs_override_vdoor_open");
    p_dps_bfs_override.vdoor_open_stat = device.svg.getElementById("p_dps_bfs_override_vdoor_open_stat");

    p_dps_bfs_override.vdoor_open.enableUpdate();
    p_dps_bfs_override.vdoor_open_stat.enableUpdate();

    p_dps_bfs_override.vdoor_close = device.svg.getElementById("p_dps_bfs_override_vdoor_close");
    p_dps_bfs_override.vdoor_close_stat = device.svg.getElementById("p_dps_bfs_override_vdoor_close_stat");

    p_dps_bfs_override.vdoor_close.enableUpdate();
    p_dps_bfs_override.vdoor_close_stat.enableUpdate();

    p_dps_bfs_override.comm = device.svg.getElementById("p_dps_bfs_override_comm");
    p_dps_bfs_override.comm.enableUpdate();

    p_dps_bfs_override.tdrs = device.svg.getElementById("p_dps_bfs_override_tdrs");
    p_dps_bfs_override.stdn_lo = device.svg.getElementById("p_dps_bfs_override_stdn_lo");
    p_dps_bfs_override.stdn_hi = device.svg.getElementById("p_dps_bfs_override_stdn_hi");
    p_dps_bfs_override.sgls = device.svg.getElementById("p_dps_bfs_override_sgls");

    p_dps_bfs_override.tdrs.enableUpdate();
    p_dps_bfs_override.stdn_lo.enableUpdate();
    p_dps_bfs_override.stdn_hi.enableUpdate();
    p_dps_bfs_override.sgls.enableUpdate();

    p_dps_bfs_override.ondisplay = func
    {
        device.DPS_menu_title.setText("OVERRIDE");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-bfs");

        var ops_string = major_mode~"1/051/";
        device.DPS_menu_ops.setText(ops_string);

	# defaults for unsupported items

        p_dps_bfs_override.elev_auto.setText("*");
        p_dps_bfs_override.elev_fixed.setText("");
        p_dps_bfs_override.filter_nom.setText("*");
        p_dps_bfs_override.filter_alt.setText("");

        p_dps_bfs_override.ssme_repos.updateText(sprintf("")); 



	p_dps_bfs_override.lru1_des.setText("");
	p_dps_bfs_override.lru2_des.setText("");
	p_dps_bfs_override.lru3_des.setText("");
	p_dps_bfs_override.lru4_des.setText("");

	p_dps_bfs_override.rga1_des.setText("");
	p_dps_bfs_override.rga2_des.setText("");
	p_dps_bfs_override.rga3_des.setText("");
	p_dps_bfs_override.rga4_des.setText("");

	p_dps_bfs_override.surf1_des.setText("");
	p_dps_bfs_override.surf2_des.setText("");
	p_dps_bfs_override.surf3_des.setText("");
	p_dps_bfs_override.surf4_des.setText("");

        p_dps_bfs_override.etsep_auto.updateText("");

 	p_dps_bfs_override.wrap_mode.updateText("");
    }
    
    p_dps_bfs_override.update = func
    {
    

        var ops = getprop("/fdm/jsbsim/systems/dps/ops-bfs");

	# aborts

	var symbol = "";
        if (getprop("/fdm/jsbsim/systems/abort/arm-tal") == 1) {symbol ="*";}
        p_dps_bfs_override.tal.updateText( symbol );
    
        symbol = "";
        if (getprop("/fdm/jsbsim/systems/abort/arm-ato") == 1) {symbol ="*";}
        p_dps_bfs_override.ato.updateText( symbol );
    
        symbol = "";
        if (getprop("/fdm/jsbsim/systems/abort/abort-mode") > 0) {symbol ="*";}
        p_dps_bfs_override.abort.updateText( symbol );
    
	# throttle

        var throttle_mode = getprop("/fdm/jsbsim/systems/throttle/throttle-mode");
    
        symbol = "";
        if (throttle_mode == 1) {symbol ="*";}
        p_dps_bfs_override.throt_max.updateText( symbol );
    
        symbol = "";
        if (throttle_mode == 2) {symbol ="*";}
        p_dps_bfs_override.throt_abt.updateText( symbol );
    
        symbol = "";
        if (throttle_mode == 3) {symbol ="*";}
        p_dps_bfs_override.throt_nom.updateText( symbol ); 

	# RCS dumps

        symbol = "INH";
        if (getprop("/fdm/jsbsim/systems/rcs/aft-dump-arm-cmd") == 1){symbol = "ENA";}
        p_dps_bfs_override.arcsdump.updateText( symbol );
    
        symbol = "INH";
        if (getprop("/fdm/jsbsim/systems/rcs/fwd-dump-arm-cmd") == 1){symbol = "ENA";}
        p_dps_bfs_override.frcsdump.updateText( symbol );
    
        p_dps_bfs_override.frcs_ttg.updateText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/fwd-dump-time-s")));
        p_dps_bfs_override.arcs_ttg.updateText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/aft-dump-time-s")));

	# OMS dump

symbol = "";
        if (getprop("/fdm/jsbsim/systems/oms/oms-dump-arm-cmd") == 1){symbol = "*";}
        p_dps_bfs_override.omsdump_arm.updateText( symbol );
    
        symbol = "";
        if (getprop("/fdm/jsbsim/systems/oms/oms-dump-cmd") == 1){symbol = "*";}
        p_dps_bfs_override.omsdump_start.updateText( symbol );
    
        symbol = "";
        if (getprop("/fdm/jsbsim/systems/oms/oms-dump-cmd") == 0){symbol = "*";}
        p_dps_bfs_override.omsdump_stop.updateText( symbol );
    
    
        p_dps_bfs_override.omsdump_qty.updateText(sprintf("%d", getprop("/fdm/jsbsim/systems/oms/oms-dump-qty")));
        p_dps_bfs_override.omsdump_ttg.updateText(sprintf("%d", getprop("/fdm/jsbsim/systems/oms/oms-dump-ttg-s")));
    

	# OMS/RCS interconnect

        symbol = "INH";
        if (getprop("/fdm/jsbsim/systems/oms/oms-dump-interconnect-cmd") == 1){symbol = "ENA";}
        p_dps_bfs_override.icnct1.updateText( symbol );
    
        symbol = "";
        if (getprop("/fdm/jsbsim/systems/oms/oms-dump-interconnect-complete") == 1){symbol = "CPLT";}
        p_dps_bfs_override.icnct2.updateText( symbol );

	# atmosphere model

	symbol = "";
	if (SpaceShuttle.area_nav_set.drag_h_atm_model == 0) {symbol= "*";}
        p_dps_bfs_override.atmo_nom.updateText(symbol);

	symbol = "";
	if (SpaceShuttle.area_nav_set.drag_h_atm_model == 1) {symbol= "*";}
         p_dps_bfs_override.atmo_npole.updateText(symbol);

	symbol = "";
	if (SpaceShuttle.area_nav_set.drag_h_atm_model == 2) {symbol= "*";}
        p_dps_bfs_override.atmo_spole.updateText(symbol);

	# ET umbilical door

        symbol = "";
    
        if ((getprop("/fdm/jsbsim/systems/mechanical/et-door-cl-latch-cmd") == 0) and (getprop("/fdm/jsbsim/systems/mechanical/et-door-right-latch-pos") < 1.0))
    		{symbol = "*";}
        p_dps_bfs_override.et_umb_dr_close.updateText(symbol);

	# ET separation

        var symbol = "";
    
        if (getprop("/controls/shuttle/etsep-in-progress") == 1)
    		{symbol = "*";}
    
        p_dps_bfs_override.etsep_sep.updateText( symbol );

	# VENT DOORS



        symbol = "";
        if (getprop("/fdm/jsbsim/systems/mechanical/vdoor-cmd") == 1) {symbol ="*";}
        p_dps_bfs_override.vdoor_open.updateText( symbol ); 
    
        symbol = "";
        if (getprop("/fdm/jsbsim/systems/mechanical/vdoor-pos") == 1.0) {symbol ="OP";}
        p_dps_bfs_override.vdoor_open_stat.updateText( symbol ); 
    
        symbol = "";
        if (getprop("/fdm/jsbsim/systems/mechanical/vdoor-cmd") == 0) {symbol ="*";}
        p_dps_bfs_override.vdoor_close.updateText( symbol ); 
    
        symbol = "";
        if (getprop("/fdm/jsbsim/systems/mechanical/vdoor-pos") == 0.0) {symbol ="CL";}
        p_dps_bfs_override.vdoor_close_stat.updateText( symbol ); 
	

	# COMM

	symbol = "";
	
	if ((SpaceShuttle.antenna_manager.s_link == 1) or (SpaceShuttle.antenna_manager.ku_link == 1))
		{symbol = "LOCK";}

	p_dps_bfs_override.comm.updateText(symbol);

	var antenna_mode = SpaceShuttle.antenna_manager.mode;

	symbol = "";
	if (antenna_mode == "S-HI")
		{symbol = "*";}
	p_dps_bfs_override.stdn_hi.updateText(symbol);
		
	symbol = "";
	if (antenna_mode == "S-LO")
		{symbol = "*";}
	p_dps_bfs_override.stdn_lo.updateText(symbol);

	symbol = "";
	if (antenna_mode == "TDRS")
		{symbol = "*";}
	p_dps_bfs_override.tdrs.updateText(symbol);

	symbol = "";
	if (antenna_mode == "SGLS")
		{symbol = "*";}
	p_dps_bfs_override.sgls.updateText(symbol);

	# OPS 3 specific things

        if (ops == 3)
        {

	# SSME repos

            symbol = "INH";
            if (getprop("/fdm/jsbsim/systems/vectoring/ssme-repos-enable") == 1) {symbol ="ENA";}
            p_dps_bfs_override.ssme_repos.updateText( symbol ); 

	# wrap mode

	p_dps_bfs_override.wrap_mode.updateText("INH");

        }

	# IMUs

	symbol = "";
	if (SpaceShuttle.imu_system.imu[0].deselected == 1) {symbol = "*";}
	p_dps_bfs_override.imu1_des.updateText(symbol);

	symbol = "";
	if (SpaceShuttle.imu_system.imu[1].deselected == 1) {symbol = "*";}
	p_dps_bfs_override.imu2_des.updateText(symbol);

	symbol = "";
	if (SpaceShuttle.imu_system.imu[2].deselected == 1) {symbol = "*";}
	p_dps_bfs_override.imu3_des.updateText(symbol);

	p_dps_bfs_override.imu_att.updateText(sprintf("%d", SpaceShuttle.imu_system.attitude_source+1));
	

    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_bfs_override;
}
