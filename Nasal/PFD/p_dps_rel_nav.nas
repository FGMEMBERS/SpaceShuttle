#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_rel_nav
# Description: the DPS rendezvous navigation page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_rel_nav = func(device)
{
    var p_dps_rel_nav = device.addPage("CRTRelNav", "p_dps_rel_nav");


    p_dps_rel_nav.group = device.svg.getElementById("p_dps_rel_nav");
    p_dps_rel_nav.group.setColor(dps_r, dps_g, dps_b);
    
    p_dps_rel_nav.rndz_nav_enable = device.svg.getElementById("p_dps_rel_rndz_nav_ena");
    p_dps_rel_nav.ku_ant_enable = device.svg.getElementById("p_dps_rel_ku_ant_ena");
    p_dps_rel_nav.meas_enable = device.svg.getElementById("p_dps_rel_nav_meas_ena");

    p_dps_rel_nav.sv_sel = device.svg.getElementById("p_dps_rel_nav_sv_sel");
    p_dps_rel_nav.avg_g = device.svg.getElementById("p_dps_rel_nav_avg_g");

	
    p_dps_rel_nav.rng_prop = device.svg.getElementById("p_dps_rel_nav_rng_prop");
    p_dps_rel_nav.rdot_prop = device.svg.getElementById("p_dps_rel_nav_rdot_prop");
    p_dps_rel_nav.theta_prop = device.svg.getElementById("p_dps_rel_nav_theta_prop");
    p_dps_rel_nav.y_prop = device.svg.getElementById("p_dps_rel_nav_y_prop");
    p_dps_rel_nav.ydot_prop = device.svg.getElementById("p_dps_rel_nav_ydot_prop");

    p_dps_rel_nav.covar_reinit = device.svg.getElementById("p_dps_rel_nav_covar_reinit");
    p_dps_rel_nav.fltr_update = device.svg.getElementById("p_dps_rel_nav_fltr_update");

    p_dps_rel_nav.s_trk = device.svg.getElementById("p_dps_rel_nav_s_trk");
    p_dps_rel_nav.rr = device.svg.getElementById("p_dps_rel_nav_rr");
    p_dps_rel_nav.coas = device.svg.getElementById("p_dps_rel_nav_coas");

    p_dps_rel_nav.rr_mode = device.svg.getElementById("p_dps_rel_nav_rr_mode");

    p_dps_rel_nav.rng_ku = device.svg.getElementById("p_dps_rel_nav_rng_ku");
    p_dps_rel_nav.rdot_ku = device.svg.getElementById("p_dps_rel_nav_rdot_ku");
    p_dps_rel_nav.el_ku = device.svg.getElementById("p_dps_rel_nav_el_ku");
    p_dps_rel_nav.az_ku = device.svg.getElementById("p_dps_rel_nav_az_ku");
    p_dps_rel_nav.omega_p_ku = device.svg.getElementById("p_dps_rel_nav_omega_p_ku");
    p_dps_rel_nav.omega_r_ku = device.svg.getElementById("p_dps_rel_nav_omega_r_ku");

    p_dps_rel_nav.gps_1s_stat = device.svg.getElementById("p_dps_rel_nav_gps_1s_stat");
    p_dps_rel_nav.gps_2s_stat = device.svg.getElementById("p_dps_rel_nav_gps_2s_stat");
    p_dps_rel_nav.gps_3s_stat = device.svg.getElementById("p_dps_rel_nav_gps_3s_stat");

    p_dps_rel_nav.gps_1s_p = device.svg.getElementById("p_dps_rel_nav_gps_1s_p");
    p_dps_rel_nav.gps_2s_p = device.svg.getElementById("p_dps_rel_nav_gps_2s_p");
    p_dps_rel_nav.gps_3s_p = device.svg.getElementById("p_dps_rel_nav_gps_3s_p");

    p_dps_rel_nav.gps_1s_des = device.svg.getElementById("p_dps_rel_nav_gps_1s_des");
    p_dps_rel_nav.gps_2s_des = device.svg.getElementById("p_dps_rel_nav_gps_2s_des");
    p_dps_rel_nav.gps_3s_des = device.svg.getElementById("p_dps_rel_nav_gps_3s_des");


    p_dps_rel_nav.fltr_to_prop = device.svg.getElementById("p_dps_rel_nav_fltr_to_prop");
    p_dps_rel_nav.prop_to_fltr = device.svg.getElementById("p_dps_rel_nav_prop_to_fltr");
    p_dps_rel_nav.orb_to_tgt = device.svg.getElementById("p_dps_rel_nav_orb_to_tgt");
    p_dps_rel_nav.tgt_to_orb = device.svg.getElementById("p_dps_rel_nav_tgt_to_orb");

    p_dps_rel_nav.vely_resid = device.svg.getElementById("p_dps_rel_nav_vely_resid");

    p_dps_rel_nav.rdot_resid = device.svg.getElementById("p_dps_rel_nav_rdot_resid");
    p_dps_rel_nav.rdot_ratio = device.svg.getElementById("p_dps_rel_nav_rdot_ratio");

    p_dps_rel_nav.rng_resid = device.svg.getElementById("p_dps_rel_nav_rng_resid");
    p_dps_rel_nav.rng_ratio = device.svg.getElementById("p_dps_rel_nav_rng_ratio");
    p_dps_rel_nav.rng_acpt = device.svg.getElementById("p_dps_rel_nav_rng_acpt");
    p_dps_rel_nav.rng_rej = device.svg.getElementById("p_dps_rel_nav_rng_rej");
    p_dps_rel_nav.rng_for = device.svg.getElementById("p_dps_rel_nav_rng_for");
    p_dps_rel_nav.rng_inh = device.svg.getElementById("p_dps_rel_nav_rng_inh");
    p_dps_rel_nav.rng_aut = device.svg.getElementById("p_dps_rel_nav_rng_aut");

    p_dps_rel_nav.rdot_resid = device.svg.getElementById("p_dps_rel_nav_rdot_resid");
    p_dps_rel_nav.rdot_ratio = device.svg.getElementById("p_dps_rel_nav_rdot_ratio");
    p_dps_rel_nav.rdot_acpt = device.svg.getElementById("p_dps_rel_nav_rdot_acpt");
    p_dps_rel_nav.rdot_rej = device.svg.getElementById("p_dps_rel_nav_rdot_rej");
    p_dps_rel_nav.rdot_for = device.svg.getElementById("p_dps_rel_nav_rdot_for");
    p_dps_rel_nav.rdot_inh = device.svg.getElementById("p_dps_rel_nav_rdot_inh");
    p_dps_rel_nav.rdot_aut = device.svg.getElementById("p_dps_rel_nav_rdot_aut");

    p_dps_rel_nav.vely_resid = device.svg.getElementById("p_dps_rel_nav_vely_resid");
    p_dps_rel_nav.vely_ratio = device.svg.getElementById("p_dps_rel_nav_vely_ratio");
    p_dps_rel_nav.vely_acpt = device.svg.getElementById("p_dps_rel_nav_vely_acpt");
    p_dps_rel_nav.vely_rej = device.svg.getElementById("p_dps_rel_nav_vely_rej");
    p_dps_rel_nav.vely_for = device.svg.getElementById("p_dps_rel_nav_vely_for");
    p_dps_rel_nav.vely_inh = device.svg.getElementById("p_dps_rel_nav_vely_inh");
    p_dps_rel_nav.vely_aut = device.svg.getElementById("p_dps_rel_nav_vely_aut");


    p_dps_rel_nav.hazx_ratio = device.svg.getElementById("p_dps_rel_nav_hazx_ratio");
    p_dps_rel_nav.hazx_resid = device.svg.getElementById("p_dps_rel_nav_hazx_resid");
    p_dps_rel_nav.hazx_acpt = device.svg.getElementById("p_dps_rel_nav_hazx_acpt");
    p_dps_rel_nav.hazx_rej = device.svg.getElementById("p_dps_rel_nav_hazx_rej");

    p_dps_rel_nav.gps_inh = device.svg.getElementById("p_dps_rel_nav_gps_inh");
    p_dps_rel_nav.gps_for = device.svg.getElementById("p_dps_rel_nav_gps_for");
    p_dps_rel_nav.gps_aut = device.svg.getElementById("p_dps_rel_nav_gps_aut");

    p_dps_rel_nav.node = device.svg.getElementById("p_dps_rel_nav_node");

    p_dps_rel_nav.sv_trans_pos = device.svg.getElementById("p_dps_rel_nav_sv_trans_pos");
    p_dps_rel_nav.sv_trans_vel = device.svg.getElementById("p_dps_rel_nav_sv_trans_vel");

    p_dps_rel_nav.stat1 = device.svg.getElementById("p_dps_rel_nav_stat1");
    p_dps_rel_nav.stat2 = device.svg.getElementById("p_dps_rel_nav_stat2");

    p_dps_rel_nav.gps1_resid = device.svg.getElementById("p_dps_rel_nav_gps1_resid");
    p_dps_rel_nav.gps2_resid = device.svg.getElementById("p_dps_rel_nav_gps2_resid");
    p_dps_rel_nav.gps1_ratio = device.svg.getElementById("p_dps_rel_nav_gps1_ratio");
    p_dps_rel_nav.gps2_ratio = device.svg.getElementById("p_dps_rel_nav_gps2_ratio");
    p_dps_rel_nav.gps1_x = device.svg.getElementById("p_dps_rel_nav_gps1_x");
    p_dps_rel_nav.gps2_x = device.svg.getElementById("p_dps_rel_nav_gps2_x");

    p_dps_rel_nav.update_pos = device.svg.getElementById("p_dps_rel_nav_update_pos");
    p_dps_rel_nav.update_vel = device.svg.getElementById("p_dps_rel_nav_update_vel");

    p_dps_rel_nav.stat_x = device.svg.getElementById("p_dps_rel_nav_stat_x");
    p_dps_rel_nav.stat_y = device.svg.getElementById("p_dps_rel_nav_stat_y");


    p_dps_rel_nav.ondisplay = func
    {
        device.DPS_menu_title.setText("REL NAV");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/033/";
        device.DPS_menu_ops.setText(ops_string);

	# generic values for functions which are not modeled

	p_dps_rel_nav.avg_g.setText("*");
	p_dps_rel_nav.orb_to_tgt.setText("");
	p_dps_rel_nav.tgt_to_orb.setText("");
	p_dps_rel_nav.covar_reinit.setText("");
	p_dps_rel_nav.prop_to_fltr.setText("");
	p_dps_rel_nav.fltr_to_prop.setText("");
	p_dps_rel_nav.gps_1s_stat.setText("");
	p_dps_rel_nav.gps_2s_stat.setText("");
	p_dps_rel_nav.gps_3s_stat.setText("");
	p_dps_rel_nav.gps_1s_p.setText("250");
	p_dps_rel_nav.gps_2s_p.setText("250");
	p_dps_rel_nav.gps_3s_p.setText("250");
	p_dps_rel_nav.rng_acpt.setText("");
    	p_dps_rel_nav.rng_rej.setText("");
    	p_dps_rel_nav.rng_for.setText("");
    	p_dps_rel_nav.rng_inh.setText("*");
    	p_dps_rel_nav.rng_aut.setText("");
	p_dps_rel_nav.rdot_acpt.setText("");
    	p_dps_rel_nav.rdot_rej.setText("");
    	p_dps_rel_nav.rdot_for.setText("");
    	p_dps_rel_nav.rdot_inh.setText("*");
    	p_dps_rel_nav.rdot_aut.setText("");
	p_dps_rel_nav.vely_acpt.setText("");
    	p_dps_rel_nav.vely_rej.setText("");
    	p_dps_rel_nav.vely_for.setText("");
    	p_dps_rel_nav.vely_inh.setText("*");
    	p_dps_rel_nav.vely_aut.setText("");
    	p_dps_rel_nav.gps_inh.setText("*");
    	p_dps_rel_nav.gps_for.setText("");
    	p_dps_rel_nav.gps_aut.setText("");
	p_dps_rel_nav.hazx_acpt.setText("");
    	p_dps_rel_nav.hazx_rej.setText("");
	p_dps_rel_nav.node.setText("00:00:00");
   	p_dps_rel_nav.gps1_resid.setText("");
    	p_dps_rel_nav.gps2_resid.setText("");
    	p_dps_rel_nav.gps1_ratio.setText("");
    	p_dps_rel_nav.gps2_ratio.setText("");
   	p_dps_rel_nav.gps1_x.setText("");
   	p_dps_rel_nav.gps2_x.setText("");
	p_dps_rel_nav.stat_x.setText("");
	p_dps_rel_nav.stat_y.setText("");
    }
    
    p_dps_rel_nav.update = func
    {

	var rel_nav_enable = getprop("/fdm/jsbsim/systems/rendezvous/rel-nav-enable");
	var angle_sensor_selection = getprop("/fdm/jsbsim/systems/rendezvous/angle-sensor-selection");
	var disp_sv_selection = getprop("/fdm/jsbsim/systems/rendezvous/sv-select");

	var symbol = "*";
	if (rel_nav_enable == 0)
		{symbol = "";}
	p_dps_rel_nav.rndz_nav_enable.setText(symbol);

	var meas_enable = getprop("/fdm/jsbsim/systems/rendezvous/meas-enable");

	symbol = "*";
	if (meas_enable == 0)
		{symbol = "";}
	p_dps_rel_nav.meas_enable.setText(symbol);

	# true, propagated and filtered properties

	var range = getprop("/fdm/jsbsim/systems/rendezvous/target/distance-m");
	var range_prop = getprop("/fdm/jsbsim/systems/rendezvous/target/distance-prop-m");

	var rdot = getprop("/fdm/jsbsim/systems/rendezvous/target/ddot-m_s");
	var rdot_prop = getprop("/fdm/jsbsim/systems/rendezvous/target/ddot-prop-m_s");

	var Y = getprop("/fdm/jsbsim/systems/rendezvous/target/Y-m");
	var Y_prop = getprop("/fdm/jsbsim/systems/rendezvous/target/Y-prop-m");

	var Ydot = getprop("/fdm/jsbsim/systems/rendezvous/target/Ydot-m_s");
	var Ydot_prop = getprop("/fdm/jsbsim/systems/rendezvous/target/Ydot-prop-m_s");

	var theta = getprop("/fdm/jsbsim/systems/rendezvous/target/theta");
	var theta_prop = getprop("/fdm/jsbsim/systems/rendezvous/target/theta-prop");

	var filter_quality_pos = SpaceShuttle.get_filter_quality_pos();
	var filter_quality_v = SpaceShuttle.get_filter_quality_v();

	var filter_quality_ang = 1.0;
	if (angle_sensor_selection == 0)
		{filter_quality_ang  = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-star-tracker/quality-ang");}
	else if (angle_sensor_selection == 1)
		{filter_quality_ang  = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-rr/quality-ang");}
	else if (angle_sensor_selection == 2)
		{filter_quality_ang  = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-coas/quality-ang");}

	var range_filtered = filter_quality_pos * range_prop + (1.0 - filter_quality_pos) * range;
	var rdot_filtered = filter_quality_v * rdot_prop + (1.0 - filter_quality_v) * rdot;

	var Y_filtered = filter_quality_pos * Y_prop + (1.0 - filter_quality_pos) * Y;
	var Ydot_filtered = filter_quality_v * Ydot_prop + (1.0 - filter_quality_v) * Ydot;

	var theta_filtered = filter_quality_ang * theta_prop + (1.0 - filter_quality_ang) * theta;

	# if RNDZ NAV is not enabled, the properties are blanked

	if (rel_nav_enable == 0)
		{
 		p_dps_rel_nav.rng_prop.setText("");
    		p_dps_rel_nav.rdot_prop.setText("");
    		p_dps_rel_nav.theta_prop.setText("");
    		p_dps_rel_nav.y_prop.setText("");
    		p_dps_rel_nav.ydot_prop.setText("");
		p_dps_rel_nav.sv_trans_vel.setText("");
		p_dps_rel_nav.sv_trans_pos.setText("");
		}
	else 
		{
		if (disp_sv_selection == 0)
			{
			p_dps_rel_nav.rng_prop.setText(sprintf("%4.3f", range_prop / 1000. / 0.3048));
			p_dps_rel_nav.rdot_prop.setText(sprintf("%+4.2f", rdot_prop / 0.3048));
			p_dps_rel_nav.theta_prop.setText(sprintf("%3.2f", theta_prop));
    			p_dps_rel_nav.y_prop.setText(sprintf("%+2.2f", Y_prop/1000. / 0.3048));
    			p_dps_rel_nav.ydot_prop.setText(sprintf("%+3.1f", Ydot_prop / 0.3048));
			}
		else
			{
			p_dps_rel_nav.rng_prop.setText(sprintf("%4.3f", range_filtered / 1000. / 0.3048));
			p_dps_rel_nav.rdot_prop.setText(sprintf("%+4.2f", rdot_filtered / 0.3048));
			p_dps_rel_nav.theta_prop.setText(sprintf("%3.2f", theta_filtered));
    			p_dps_rel_nav.y_prop.setText(sprintf("%+2.2f", Y_filtered/1000. / 0.3048));
    			p_dps_rel_nav.ydot_prop.setText(sprintf("%+3.1f", Ydot_filtered / 0.3048));
			}

		var ver = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-rndz/v-m_s");
		var v_fltr_minus_prop =  ver - getprop("/fdm/jsbsim/systems/navigation/state-vector/error-rr/rdot-m_s");

		p_dps_rel_nav.sv_trans_vel.setText(sprintf("%2.2f", v_fltr_minus_prop));

		var pos_e = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-rndz/pos-m");
		var pos_fltr_minus_prop = pos_e;
		p_dps_rel_nav.sv_trans_pos.setText(sprintf("%2.2f", pos_fltr_minus_prop / 1000. /0.3048));
		}

	# unless the antenna is tracking, the RR properties are blanked

	var antenna_func = SpaceShuttle.antenna_manager.function;
	var ku_enable = getprop("/fdm/jsbsim/systems/rendezvous/ku-enable");
	var tgt_acquired = SpaceShuttle.antenna_manager.tgt_acquired;

	if (antenna_func == "COMM")
		{p_dps_rel_nav.rr_mode.setText("COMM");}
	else
		{p_dps_rel_nav.rr_mode.setText(SpaceShuttle.antenna_manager.rr_mode);}

	symbol = "*";
	if (ku_enable == 0)
		{symbol = "";}
	p_dps_rel_nav.ku_ant_enable.setText(symbol);

	var rr_active = 1;

	if ((antenna_func == "COMM") or (ku_enable == 0) or (tgt_acquired == 0))
		{
		p_dps_rel_nav.rng_ku.setText("");
		p_dps_rel_nav.rdot_ku.setText("");
		p_dps_rel_nav.el_ku.setText("");
    		p_dps_rel_nav.az_ku.setText("");
    		p_dps_rel_nav.omega_p_ku.setText("");
    		p_dps_rel_nav.omega_r_ku.setText("");
		rr_active = 0;
		}
	else
		{
		var ku_elevation_body = antenna_manager.ku_elevation;
		var ku_azimuth_body = antenna_manager.ku_azimuth;

		var ku_pointing_body = SpaceShuttle.get_vec_az_el(ku_azimuth_body, ku_elevation_body);
		var ku_pointing_inertial = SpaceShuttle.vtransform_body_inertial(ku_pointing_body);
		var angles_inertial = SpaceShuttle.get_pitch_yaw(ku_pointing_inertial);
		var ku_azimuth_inertial = angles_inertial[1] * 180.0/math.pi;
		var ku_elevation_inertial = angles_inertial[0] * 180.0/math.pi;

		antenna_manager.ku_inertial_azimuth = ku_azimuth_inertial;
		antenna_manager.ku_inertial_elevation = ku_elevation_inertial;
		
		var omega_p_ku = antenna_manager.ku_inertial_elevation_rate  * 57297.0;
		var omega_r_ku = antenna_manager.ku_inertial_azimuth_rate  * 57297.0;

		omega_p_ku = SpaceShuttle.clamp(omega_p_ku, -99.0, 99.0);
		omega_r_ku = SpaceShuttle.clamp(omega_r_ku, -99.0, 99.0);

		p_dps_rel_nav.rng_ku.setText(sprintf("%4.3f", range / 1000. / 0.3048));
		p_dps_rel_nav.rdot_ku.setText(sprintf("%+4.2f", rdot / 0.3048));
		p_dps_rel_nav.el_ku.setText(sprintf("%3.1f", ku_elevation_inertial));
    		p_dps_rel_nav.az_ku.setText(sprintf("%3.1f", ku_azimuth_inertial));

		p_dps_rel_nav.omega_p_ku.setText(sprintf("%2.1f", omega_p_ku));
		p_dps_rel_nav.omega_r_ku.setText(sprintf("%2.1f", omega_r_ku));
		}		
	
	symbol = "*";
	if (getprop("/fdm/jsbsim/systems/navigation/gps-1-select") == 1) {symbol = "";}
	p_dps_rel_nav.gps_1s_des.setText(symbol);

	symbol = "*";
	if (getprop("/fdm/jsbsim/systems/navigation/gps-2-select") == 1) {symbol = "";}
	p_dps_rel_nav.gps_2s_des.setText(symbol);

	symbol = "*";
	if (getprop("/fdm/jsbsim/systems/navigation/gps-3-select") == 1) {symbol = "";}
	p_dps_rel_nav.gps_3s_des.setText(symbol);


	var text = "PROP";
	if (disp_sv_selection == 1) {text = "FLTR";}
	p_dps_rel_nav.sv_sel.setText(text);

	text = "ORB";
	if (getprop("/fdm/jsbsim/systems/rendezvous/filter-update") == 1) {text = "TGT";}
	p_dps_rel_nav.fltr_update.setText(text);
    


	symbol = "";
	if (angle_sensor_selection == 0) {symbol = "*";}
	p_dps_rel_nav.s_trk.setText(symbol);

	symbol = "";
	if (angle_sensor_selection == 1) {symbol = "*";}
	p_dps_rel_nav.rr.setText(symbol);

	symbol = "";
	if (angle_sensor_selection == 2) {symbol = "*";}
	p_dps_rel_nav.coas.setText(symbol);

	

    	var pitch_error_prop = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/pitch-deg");
	var yaw_error_prop =  getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/yaw-deg");

	var pitch_error_filtered = filter_quality_ang * pitch_error_prop;
	var yaw_error_filtered = filter_quality_ang * yaw_error_prop;

	# residuals and filters are only shown with REL NAV enabled
	if (rel_nav_enable == 0)
		{
		p_dps_rel_nav.vely_resid.setText("");
		p_dps_rel_nav.vely_ratio.setText("");

		p_dps_rel_nav.hazx_resid.setText("");
		p_dps_rel_nav.hazx_ratio.setText("");

		p_dps_rel_nav.rng_resid.setText("");
		p_dps_rel_nav.rng_ratio.setText("");

		p_dps_rel_nav.rdot_resid.setText("");
		p_dps_rel_nav.rdot_ratio.setText("");
		}
	else
		{
		p_dps_rel_nav.vely_resid.setText(sprintf("%+1.2f", pitch_error_prop - pitch_error_filtered  ));
		p_dps_rel_nav.vely_ratio.setText(sprintf("%1.1f", ((pitch_error_prop - pitch_error_filtered) + 1.0) / 1.0  ));

		p_dps_rel_nav.hazx_resid.setText(sprintf("%+1.2f", yaw_error_prop - yaw_error_filtered ));
		p_dps_rel_nav.hazx_ratio.setText(sprintf("%1.1f", ((yaw_error_prop - yaw_error_filtered) + 1.0) / 1.0  ));

		p_dps_rel_nav.rng_resid.setText(sprintf("%+2.2f", (range - range_prop) / 1000. / 0.3048));
		p_dps_rel_nav.rng_ratio.setText(sprintf("%1.1f", (range / range_prop) ));

		p_dps_rel_nav.rdot_resid.setText(sprintf("%+2.2f", (rdot - rdot_prop) / 0.3048));
		p_dps_rel_nav.rdot_ratio.setText(sprintf("%1.1f", (rdot / rdot_prop) ));

		}

	var update_pos = getprop("/fdm/jsbsim/systems/navigation/state-vector/update-pos");
	var update_vel = getprop("/fdm/jsbsim/systems/navigation/state-vector/update-vel");

	p_dps_rel_nav.update_pos.setText(sprintf("%2.2f", update_pos / 1000. / 0.3048));
	p_dps_rel_nav.update_vel.setText(sprintf("%2.2f", update_vel / 0.3048));
	
	text = "";

	var selected_tracker = -1;

	if (SpaceShuttle.star_tracker_array[1].mode == 2)
		{
		selected_tracker = 1;
		}
	else if (SpaceShuttle.star_tracker_array[0].mode == 2)
		{
		selected_tracker = 0;
		}

	if (selected_tracker > -1)
		{
		p_dps_rel_nav.stat2.setText(SpaceShuttle.star_tracker_array[selected_tracker].failure);
		p_dps_rel_nav.stat1.setText(SpaceShuttle.star_tracker_array[selected_tracker].status);
		}
	else
		{
		p_dps_rel_nav.stat2.setText("");
		p_dps_rel_nav.stat1.setText("");
		}

        device.update_common_DPS();
    }
    
    
    
    return p_dps_rel_nav;
}
