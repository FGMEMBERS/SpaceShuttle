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

    p_dps_rel_nav.rndz_nav_enable.enableUpdate();
    p_dps_rel_nav.ku_ant_enable.enableUpdate();
    p_dps_rel_nav.meas_enable.enableUpdate();

    p_dps_rel_nav.sv_sel = device.svg.getElementById("p_dps_rel_nav_sv_sel");
    p_dps_rel_nav.avg_g = device.svg.getElementById("p_dps_rel_nav_avg_g");

    p_dps_rel_nav.sv_sel.enableUpdate();
	
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

    p_dps_rel_nav.s_trk.enableUpdate();
    p_dps_rel_nav.rr.enableUpdate();
    p_dps_rel_nav.coas.enableUpdate();

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

    p_dps_rel_nav.rng_for.enableUpdate();
    p_dps_rel_nav.rng_inh.enableUpdate();
    p_dps_rel_nav.rng_aut.enableUpdate();

    p_dps_rel_nav.rdot_resid = device.svg.getElementById("p_dps_rel_nav_rdot_resid");
    p_dps_rel_nav.rdot_ratio = device.svg.getElementById("p_dps_rel_nav_rdot_ratio");
    p_dps_rel_nav.rdot_acpt = device.svg.getElementById("p_dps_rel_nav_rdot_acpt");
    p_dps_rel_nav.rdot_rej = device.svg.getElementById("p_dps_rel_nav_rdot_rej");
    p_dps_rel_nav.rdot_for = device.svg.getElementById("p_dps_rel_nav_rdot_for");
    p_dps_rel_nav.rdot_inh = device.svg.getElementById("p_dps_rel_nav_rdot_inh");
    p_dps_rel_nav.rdot_aut = device.svg.getElementById("p_dps_rel_nav_rdot_aut");

    p_dps_rel_nav.rdot_for.enableUpdate();
    p_dps_rel_nav.rdot_inh.enableUpdate();
    p_dps_rel_nav.rdot_aut.enableUpdate();

    p_dps_rel_nav.vely_resid = device.svg.getElementById("p_dps_rel_nav_vely_resid");
    p_dps_rel_nav.vely_ratio = device.svg.getElementById("p_dps_rel_nav_vely_ratio");
    p_dps_rel_nav.vely_acpt = device.svg.getElementById("p_dps_rel_nav_vely_acpt");
    p_dps_rel_nav.vely_rej = device.svg.getElementById("p_dps_rel_nav_vely_rej");
    p_dps_rel_nav.vely_for = device.svg.getElementById("p_dps_rel_nav_vely_for");
    p_dps_rel_nav.vely_inh = device.svg.getElementById("p_dps_rel_nav_vely_inh");
    p_dps_rel_nav.vely_aut = device.svg.getElementById("p_dps_rel_nav_vely_aut");

    p_dps_rel_nav.vely_for.enableUpdate();
    p_dps_rel_nav.vely_inh.enableUpdate();
    p_dps_rel_nav.vely_aut.enableUpdate();


    p_dps_rel_nav.hazx_ratio = device.svg.getElementById("p_dps_rel_nav_hazx_ratio");
    p_dps_rel_nav.hazx_resid = device.svg.getElementById("p_dps_rel_nav_hazx_resid");
    p_dps_rel_nav.hazx_acpt = device.svg.getElementById("p_dps_rel_nav_hazx_acpt");
    p_dps_rel_nav.hazx_rej = device.svg.getElementById("p_dps_rel_nav_hazx_rej");

    p_dps_rel_nav.gps_inh = device.svg.getElementById("p_dps_rel_nav_gps_inh");
    p_dps_rel_nav.gps_for = device.svg.getElementById("p_dps_rel_nav_gps_for");
    p_dps_rel_nav.gps_aut = device.svg.getElementById("p_dps_rel_nav_gps_aut");

    p_dps_rel_nav.gps_inh.enableUpdate();
    p_dps_rel_nav.gps_for.enableUpdate();
    p_dps_rel_nav.gps_aut.enableUpdate();

    p_dps_rel_nav.node = device.svg.getElementById("p_dps_rel_nav_node");

    p_dps_rel_nav.sv_trans_pos = device.svg.getElementById("p_dps_rel_nav_sv_trans_pos");
    p_dps_rel_nav.sv_trans_vel = device.svg.getElementById("p_dps_rel_nav_sv_trans_vel");

    p_dps_rel_nav.stat1 = device.svg.getElementById("p_dps_rel_nav_stat1");
    p_dps_rel_nav.stat2 = device.svg.getElementById("p_dps_rel_nav_stat2");

    p_dps_rel_nav.stat1.enableUpdate();
    p_dps_rel_nav.stat2.enableUpdate();

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

    p_dps_rel_nav.nd_ref_ku_enable = props.globals.getNode("/fdm/jsbsim/systems/rendezvous/ku-enable", 1);
    p_dps_rel_nav.nd_ref_pitch = props.globals.getNode("/orientation/pitch-deg", 1);
    p_dps_rel_nav.nd_ref_body_vector = props.globals.getNode("/fdm/jsbsim/systems/ap/track/body-vector-selection", 1);

    p_dps_rel_nav.nd_ref_normal0 = props.globals.getNode("/fdm/jsbsim/systems/pointing/inertial/normal[0]", 1);
    p_dps_rel_nav.nd_ref_normal1 = props.globals.getNode("/fdm/jsbsim/systems/pointing/inertial/normal[1]", 1);
    p_dps_rel_nav.nd_ref_normal2 = props.globals.getNode("/fdm/jsbsim/systems/pointing/inertial/normal[2]", 1);

    p_dps_rel_nav.nd_ref_prograde0 = props.globals.getNode("/fdm/jsbsim/systems/pointing/inertial/prograde[0]", 1);
    p_dps_rel_nav.nd_ref_prograde1 = props.globals.getNode("/fdm/jsbsim/systems/pointing/inertial/prograde[1]", 1);
    p_dps_rel_nav.nd_ref_prograde2 = props.globals.getNode("/fdm/jsbsim/systems/pointing/inertial/prograde[2]", 1);

    p_dps_rel_nav.nd_ref_radial0 = props.globals.getNode("/fdm/jsbsim/systems/pointing/inertial/radial[0]", 1);
    p_dps_rel_nav.nd_ref_radial1 = props.globals.getNode("/fdm/jsbsim/systems/pointing/inertial/radial[1]", 1);
    p_dps_rel_nav.nd_ref_radial2 = props.globals.getNode("/fdm/jsbsim/systems/pointing/inertial/radial[2]", 1);

    p_dps_rel_nav.nd_ref_body_x0 = props.globals.getNode("/fdm/jsbsim/systems/pointing/inertial/body-x[0]", 1);
    p_dps_rel_nav.nd_ref_body_x1 = props.globals.getNode("/fdm/jsbsim/systems/pointing/inertial/body-x[1]", 1);
    p_dps_rel_nav.nd_ref_body_x2 = props.globals.getNode("/fdm/jsbsim/systems/pointing/inertial/body-x[2]", 1);

    p_dps_rel_nav.nd_ref_body_z0 = props.globals.getNode("/fdm/jsbsim/systems/pointing/inertial/body-z[0]", 1);
    p_dps_rel_nav.nd_ref_body_z1 = props.globals.getNode("/fdm/jsbsim/systems/pointing/inertial/body-z[1]", 1);
    p_dps_rel_nav.nd_ref_body_z2 = props.globals.getNode("/fdm/jsbsim/systems/pointing/inertial/body-z[2]", 1);

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
	p_dps_rel_nav.rdot_acpt.setText("");
    	p_dps_rel_nav.rdot_rej.setText("");
	p_dps_rel_nav.vely_acpt.setText("");
    	p_dps_rel_nav.vely_rej.setText("");
	p_dps_rel_nav.hazx_acpt.setText("");
    	p_dps_rel_nav.hazx_rej.setText("");
   	p_dps_rel_nav.gps1_x.setText("");
   	p_dps_rel_nav.gps2_x.setText("");
	p_dps_rel_nav.stat_x.setText("");
	p_dps_rel_nav.stat_y.setText("");
    }
    
    p_dps_rel_nav.update = func
    {


	var symbol = "*";
	if (SpaceShuttle.proximity_manager.rel_nav_enable == 0)
		{symbol = "";}
	p_dps_rel_nav.rndz_nav_enable.updateText(symbol);

	var meas_enable = getprop("/fdm/jsbsim/systems/rendezvous/meas-enable");

	symbol = "*";
	if (meas_enable == 0)
		{symbol = "";}
	p_dps_rel_nav.meas_enable.updateText(symbol);

	# true, propagated and filtered properties


	var range = SpaceShuttle.proximity_manager.distance;
	var range_prop = range + SpaceShuttle.proximity_manager.distance_error;
	var range_filtered = range + SpaceShuttle.proximity_manager.distance_error_filtered;
	var range_sensed = SpaceShuttle.proximity_manager.distance_sensed;
	
	var rdot = SpaceShuttle.proximity_manager.ddot;
	var rdot_prop = rdot + SpaceShuttle.proximity_manager.error_rdot;
	var rdot_filtered = rdot + SpaceShuttle.proximity_manager.error_rdot_filtered;

	var Y = SpaceShuttle.proximity_manager.target_prox_y;
	var Y_prop = Y + SpaceShuttle.proximity_manager.error_y;
	var Y_filtered = Y + SpaceShuttle.proximity_manager.error_y_filtered;

	var Ydot = SpaceShuttle.proximity_manager.target_prox_vy;
	var Ydot_prop = Ydot;
	var Ydot_filtered = Ydot;

	#var theta =  p_dps_rel_nav.nd_ref_pitch.getValue();
	var bv_selection = p_dps_rel_nav.nd_ref_body_vector.getValue();

	var theta = 0.0;

	if (SpaceShuttle.proximity_manager.rel_nav_enable == 1)
		{


		var body_full = [];

		if (bv_selection == 1)
			{
			body_full = [p_dps_rel_nav.nd_ref_body_x0.getValue(), p_dps_rel_nav.nd_ref_body_x1.getValue(), p_dps_rel_nav.nd_ref_body_x2.getValue()];
			}
		else if (bv_selection == 2)
			{
			body_full = [-p_dps_rel_nav.nd_ref_body_x0.getValue(), -p_dps_rel_nav.nd_ref_body_x1.getValue(), -p_dps_rel_nav.nd_ref_body_x2.getValue()];
			}
		else if (bv_selection == 3)
			{
			body_full = [p_dps_rel_nav.nd_ref_body_z0.getValue(), p_dps_rel_nav.nd_ref_body_z1.getValue(), p_dps_rel_nav.nd_ref_body_z2.getValue()];
			}

		var normal = [p_dps_rel_nav.nd_ref_normal0.getValue(),p_dps_rel_nav.nd_ref_normal1.getValue(),p_dps_rel_nav.nd_ref_normal2.getValue()];

		var body_projected = SpaceShuttle.subtract_vector(body_full, SpaceShuttle.scalar_product(SpaceShuttle.dot_product(body_full, normal), normal));
		body_projected = SpaceShuttle.normalize (body_projected);

		var prograde = [p_dps_rel_nav.nd_ref_prograde0.getValue(),p_dps_rel_nav.nd_ref_prograde1.getValue(),p_dps_rel_nav.nd_ref_prograde2.getValue()];

		var radial = [p_dps_rel_nav.nd_ref_radial0.getValue(),p_dps_rel_nav.nd_ref_radial1.getValue(),p_dps_rel_nav.nd_ref_radial2.getValue()];

		theta = 180.0/ math.pi * math.acos(SpaceShuttle.clamp(SpaceShuttle.dot_product(body_projected, prograde),-1.0, 1.0));

		if (SpaceShuttle.dot_product(body_projected, radial) < 0.0) {theta = - theta;}



		theta = geo.normdeg(theta);
		}

	var theta_prop = theta;
	var theta_filtered = theta;

	

	var filter_quality_ang = 1.0;
	

	# if RNDZ NAV is not enabled, the properties are blanked

	if (SpaceShuttle.proximity_manager.rel_nav_enable == 0)
		{
 		p_dps_rel_nav.rng_prop.setText("");
    		p_dps_rel_nav.rdot_prop.setText("");
    		p_dps_rel_nav.theta_prop.setText("");
    		p_dps_rel_nav.y_prop.setText("");
    		p_dps_rel_nav.ydot_prop.setText("");
		p_dps_rel_nav.sv_trans_vel.setText("");
		p_dps_rel_nav.sv_trans_pos.setText("");
		p_dps_rel_nav.node.setText("");
		}
	else 
		{
		if (SpaceShuttle.proximity_manager.sv_selection == 0)
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

		p_dps_rel_nav.node.setText(SpaceShuttle.proximity_manager.node_crossing_time_string_short);

		var pos_fltr_minus_prop = math.abs(range_prop - range_filtered);
		var v_fltr_minus_prop = math.abs(rdot_prop - rdot_filtered);

		#var ver = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-rndz/v-m_s");
		#var v_fltr_minus_prop =  ver - getprop("/fdm/jsbsim/systems/navigation/state-vector/error-rr/rdot-m_s");

		p_dps_rel_nav.sv_trans_vel.setText(sprintf("%2.2f", v_fltr_minus_prop / 0.3048));

		#var pos_e = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-rndz/pos-m");

		#var pos_fltr_minus_prop = pos_e;
		p_dps_rel_nav.sv_trans_pos.setText(sprintf("%2.2f", pos_fltr_minus_prop / 1000. /0.3048));
		}

	# unless the antenna is tracking, the RR properties are blanked

	var antenna_func = SpaceShuttle.antenna_manager.function;
	#var ku_enable = getprop("/fdm/jsbsim/systems/rendezvous/ku-enable");
	var ku_enable = p_dps_rel_nav.nd_ref_ku_enable.getValue();
	var tgt_acquired = SpaceShuttle.antenna_manager.tgt_acquired;

	if (antenna_func == "COMM")
		{p_dps_rel_nav.rr_mode.setText("COMM");}
	else
		{p_dps_rel_nav.rr_mode.setText(SpaceShuttle.antenna_manager.rr_mode);}

	symbol = "*";
	if (ku_enable == 0)
		{symbol = "";}
	p_dps_rel_nav.ku_ant_enable.updateText(symbol);



	if ((antenna_func == "COMM") or (ku_enable == 0))
		{
		p_dps_rel_nav.rng_ku.setText("");
		p_dps_rel_nav.rdot_ku.setText("");
		p_dps_rel_nav.el_ku.setText("");
    		p_dps_rel_nav.az_ku.setText("");
    		p_dps_rel_nav.omega_p_ku.setText("");
    		p_dps_rel_nav.omega_r_ku.setText("");
		}
	else if	((tgt_acquired == 0) or (range > 46000.0))	
		{
		var ku_elevation_body = antenna_manager.ku_elevation;
		var ku_azimuth_body = antenna_manager.ku_azimuth;

		p_dps_rel_nav.rng_ku.setText("");
		p_dps_rel_nav.rdot_ku.setText("");
		p_dps_rel_nav.el_ku.setText(sprintf("%3.1f", ku_elevation_body));
    		p_dps_rel_nav.az_ku.setText(sprintf("%3.1f", ku_azimuth_body));
    		p_dps_rel_nav.omega_p_ku.setText("");
    		p_dps_rel_nav.omega_r_ku.setText("");
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

		p_dps_rel_nav.rng_ku.setText(sprintf("%4.3f", range_sensed / 1000. / 0.3048));
		p_dps_rel_nav.rdot_ku.setText(sprintf("%+4.2f", rdot / 0.3048));
		p_dps_rel_nav.el_ku.setText(sprintf("%3.1f", ku_elevation_body));
    		p_dps_rel_nav.az_ku.setText(sprintf("%3.1f", ku_azimuth_body));

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
	if (SpaceShuttle.proximity_manager.sv_selection == 1) {text = "FLTR";}
	p_dps_rel_nav.sv_sel.updateText(text);

	text = "ORB";
	if (getprop("/fdm/jsbsim/systems/rendezvous/filter-update") == 1) {text = "TGT";}
	p_dps_rel_nav.fltr_update.setText(text);
    


	symbol = "";
	if (SpaceShuttle.proximity_manager.angle_sensor_selection == 0) {symbol = "*";}
	p_dps_rel_nav.s_trk.updateText(symbol);

	symbol = "";
	if (SpaceShuttle.proximity_manager.angle_sensor_selection == 1) {symbol = "*";}
	p_dps_rel_nav.rr.updateText(symbol);

	symbol = "";
	if (SpaceShuttle.proximity_manager.angle_sensor_selection == 2) {symbol = "*";}
	p_dps_rel_nav.coas.updateText(symbol);

	

    	var pitch_error_prop = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/pitch-deg");
	var yaw_error_prop =  getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/yaw-deg");

	var pitch_error_filtered = filter_quality_ang * pitch_error_prop;
	var yaw_error_filtered = filter_quality_ang * yaw_error_prop;

	# residuals and filters are only shown with REL NAV enabled
	if (SpaceShuttle.proximity_manager.rel_nav_enable == 0)
		{
		p_dps_rel_nav.vely_resid.setText("");
		p_dps_rel_nav.vely_ratio.setText("");

		p_dps_rel_nav.hazx_resid.setText("");
		p_dps_rel_nav.hazx_ratio.setText("");

		p_dps_rel_nav.rng_resid.setText("");
		p_dps_rel_nav.rng_ratio.setText("");

		p_dps_rel_nav.rdot_resid.setText("");
		p_dps_rel_nav.rdot_ratio.setText("");

   		p_dps_rel_nav.gps1_resid.setText("");
    		p_dps_rel_nav.gps2_resid.setText("");
    		p_dps_rel_nav.gps1_ratio.setText("");
    		p_dps_rel_nav.gps2_ratio.setText("");
		}
	else
		{

		if (SpaceShuttle.proximity_manager.ang_data_good == 1)
			{
			p_dps_rel_nav.vely_resid.setText(sprintf("%+1.2f",  SpaceShuttle.proximity_manager.y_resid  ));
			p_dps_rel_nav.vely_ratio.setText(sprintf("%1.1f",  SpaceShuttle.proximity_manager.y_ratio  ));

			p_dps_rel_nav.hazx_resid.setText(sprintf("%+1.2f",  SpaceShuttle.proximity_manager.z_resid ));
			p_dps_rel_nav.hazx_ratio.setText(sprintf("%1.1f",  SpaceShuttle.proximity_manager.z_ratio ));
			}
		else
			{
			p_dps_rel_nav.vely_resid.setText("");
			p_dps_rel_nav.vely_ratio.setText("");

			p_dps_rel_nav.hazx_resid.setText("");
			p_dps_rel_nav.hazx_ratio.setText("");
			}

		if (SpaceShuttle.proximity_manager.rr_data_good == 1)
			{
			p_dps_rel_nav.rng_resid.setText(sprintf("%+2.2f", SpaceShuttle.proximity_manager.rng_resid));
			p_dps_rel_nav.rng_ratio.setText(sprintf("%1.1f", SpaceShuttle.proximity_manager.rng_ratio ));

			p_dps_rel_nav.rdot_resid.setText(sprintf("%+2.2f", SpaceShuttle.proximity_manager.rdot_resid));
			p_dps_rel_nav.rdot_ratio.setText(sprintf("%1.1f", SpaceShuttle.proximity_manager.rdot_ratio ));

			}
		else
			{
			p_dps_rel_nav.rng_resid.setText("");
			p_dps_rel_nav.rng_ratio.setText("");

			p_dps_rel_nav.rdot_resid.setText("");
			p_dps_rel_nav.rdot_ratio.setText("");
			}


  		p_dps_rel_nav.gps1_resid.setText(sprintf("%+2.2f", SpaceShuttle.proximity_manager.gps_p_resid));
    		p_dps_rel_nav.gps2_resid.setText(sprintf("%+2.2f", SpaceShuttle.proximity_manager.gps_v_resid));
    		p_dps_rel_nav.gps1_ratio.setText(sprintf("%+2.2f", SpaceShuttle.proximity_manager.gps_p_ratio));
    		p_dps_rel_nav.gps2_ratio.setText(sprintf("%+2.2f", SpaceShuttle.proximity_manager.gps_v_ratio));

		}

	#var update_pos = getprop("/fdm/jsbsim/systems/navigation/state-vector/update-pos");
	#var update_vel = getprop("/fdm/jsbsim/systems/navigation/state-vector/update-vel");

	var update_pos = math.sqrt( math.pow(SpaceShuttle.proximity_manager.update_x,2.0) + math.pow(SpaceShuttle.proximity_manager.update_y,2.0) + math.pow(SpaceShuttle.proximity_manager.update_z,2.0));

	var update_vel = SpaceShuttle.proximity_manager.update_rdot;

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
		p_dps_rel_nav.stat2.updateText(SpaceShuttle.star_tracker_array[selected_tracker].failure);
		p_dps_rel_nav.stat1.updateText(SpaceShuttle.star_tracker_array[selected_tracker].status);

		if ((selected_tracker == 1) and (SpaceShuttle.star_tracker_array[1].status == ""))
			{
			p_dps_rel_nav.stat_x.setText(sprintf("%2.1f", SpaceShuttle.star_tracker_array[1].offset_angle_x * 180/math.pi));
			p_dps_rel_nav.stat_y.setText(sprintf("%2.1f", SpaceShuttle.star_tracker_array[1].offset_angle_y * 180/math.pi));
			}
		else
			{
			p_dps_rel_nav.stat_x.setText("");
			p_dps_rel_nav.stat_y.setText("");
			}
		}
	else
		{
		p_dps_rel_nav.stat2.updateText("");
		p_dps_rel_nav.stat1.updateText("");
		p_dps_rel_nav.stat_x.setText("");
		p_dps_rel_nav.stat_y.setText("");
		}


	# AUT, INH and FOR controls

	symbol = "";
	if (SpaceShuttle.proximity_manager.rng_aut == 1) {symbol = "*";}
    	p_dps_rel_nav.rng_aut.updateText(symbol);

	symbol = "";
	if (SpaceShuttle.proximity_manager.rng_inh == 1) {symbol = "*";}
    	p_dps_rel_nav.rng_inh.updateText(symbol);

	symbol = "";
	if (SpaceShuttle.proximity_manager.rng_for == 1) {symbol = "*";}
    	p_dps_rel_nav.rng_for.updateText(symbol);

	symbol = "";
	if (SpaceShuttle.proximity_manager.rdot_aut == 1) {symbol = "*";}
    	p_dps_rel_nav.rdot_aut.updateText(symbol);

	symbol = "";
	if (SpaceShuttle.proximity_manager.rdot_inh == 1) {symbol = "*";}
    	p_dps_rel_nav.rdot_inh.updateText(symbol);

	symbol = "";
	if (SpaceShuttle.proximity_manager.rdot_for == 1) {symbol = "*";}
    	p_dps_rel_nav.rdot_for.updateText(symbol);

	symbol = "";
	if (SpaceShuttle.proximity_manager.y_aut == 1) {symbol = "*";}
    	p_dps_rel_nav.vely_aut.updateText(symbol);

	symbol = "";
	if (SpaceShuttle.proximity_manager.y_inh == 1) {symbol = "*";}
    	p_dps_rel_nav.vely_inh.updateText(symbol);

	symbol = "";
	if (SpaceShuttle.proximity_manager.y_for == 1) {symbol = "*";}
    	p_dps_rel_nav.vely_for.updateText(symbol);

	symbol = "";
	if (SpaceShuttle.proximity_manager.gps_aut == 1) {symbol = "*";}
    	p_dps_rel_nav.gps_aut.updateText(symbol);

	symbol = "";
	if (SpaceShuttle.proximity_manager.gps_inh == 1) {symbol = "*";}
    	p_dps_rel_nav.gps_inh.updateText(symbol);

	symbol = "";
	if (SpaceShuttle.proximity_manager.gps_for == 1) {symbol = "*";}
    	p_dps_rel_nav.gps_for.updateText(symbol);



        device.update_common_DPS();
    }
    
    
    
    return p_dps_rel_nav;
}
