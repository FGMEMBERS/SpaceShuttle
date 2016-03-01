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
	p_dps_rel_nav.fltr_update.setText("TGT");
	p_dps_rel_nav.gps_1s_stat.setText("");
	p_dps_rel_nav.gps_2s_stat.setText("");
	p_dps_rel_nav.gps_3s_stat.setText("");
	p_dps_rel_nav.gps_1s_p.setText("250");
	p_dps_rel_nav.gps_2s_p.setText("250");
	p_dps_rel_nav.gps_3s_p.setText("250");
    }
    
    p_dps_rel_nav.update = func
    {

	var rel_nav_enable = getprop("/fdm/jsbsim/systems/rendezvous/rel-nav-enable");

	var symbol = "*";
	if (rel_nav_enable == 0)
		{symbol = "";}
	p_dps_rel_nav.rndz_nav_enable.setText(symbol);

	# if RNDZ NAV is not enabled, the properties are blanked

	var range = getprop("/fdm/jsbsim/systems/rendezvous/target/distance-m");
	var rdot = getprop("/fdm/jsbsim/systems/rendezvous/target/ddot-m_s");
	var Y = getprop("/fdm/jsbsim/systems/rendezvous/target/Y-m");
	var Ydot = getprop("/fdm/jsbsim/systems/rendezvous/target/Ydot-m_s");
	var theta = getprop("/fdm/jsbsim/systems/rendezvous/target/theta");

	if (rel_nav_enable == 0)
		{
 		p_dps_rel_nav.rng_prop.setText("");
    		p_dps_rel_nav.rdot_prop.setText("");
    		p_dps_rel_nav.theta_prop.setText("");
    		p_dps_rel_nav.y_prop.setText("");
    		p_dps_rel_nav.ydot_prop.setText("");
		}
	else
		{
		p_dps_rel_nav.rng_prop.setText(sprintf("%4.3f", range / 1000. / 0.3048));
		p_dps_rel_nav.rdot_prop.setText(sprintf("%+4.2f", rdot / 0.3048));
		p_dps_rel_nav.theta_prop.setText(sprintf("%3.2f", theta));
    		p_dps_rel_nav.y_prop.setText(sprintf("%+2.2f", Y/1000. / 0.3048));
    		p_dps_rel_nav.ydot_prop.setText(sprintf("%+3.1f", Ydot / 0.3048));
		}

	# unless the antenna is tracking, the RR properties are blanked

	var antenna_func = SpaceShuttle.antenna_manager.function;
	var ku_enable = getprop("/fdm/jsbsim/systems/rendezvous/ku-enable");

	p_dps_rel_nav.rr_mode.setText(SpaceShuttle.antenna_manager.function);

	symbol = "*";
	if (ku_enable == 0)
		{symbol = "";}
	p_dps_rel_nav.ku_ant_enable.setText(symbol);

	if ((antenna_func == "COMM") or (ku_enable == 0))
		{
		p_dps_rel_nav.rng_ku.setText("");
		p_dps_rel_nav.rdot_ku.setText("");
		p_dps_rel_nav.el_ku.setText("");
    		p_dps_rel_nav.az_ku.setText("");
    		p_dps_rel_nav.omega_p_ku.setText("");
    		p_dps_rel_nav.omega_r_ku.setText("");
		}
	else
		{
		p_dps_rel_nav.rng_ku.setText(sprintf("%4.3f", range / 1000. / 0.3048));
		p_dps_rel_nav.rdot_ku.setText(sprintf("%+4.2f", rdot / 0.3048));
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
	if (getprop("/fdm/jsbsim/systems/rendezvous/sv-select") == 1) {text = "FLTR";}
	p_dps_rel_nav.sv_sel.setText(text);
    
	var angle_sensor_selection = getprop("/fdm/jsbsim/systems/rendezvous/angle-sensor-selection");

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
	
	var pitch_error_sensor = 0.0;
	if (angle_sensor_selection == 0)
		{
		pitch_error_sensor = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-star-tracker/pitch-deg");
		}
	else if (angle_sensor_selection == 2)
		{
		pitch_error_sensor = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-coas/pitch-deg");	
		}

	p_dps_rel_nav.vely_resid.setText(sprintf("%+1.2f", pitch_error_prop - pitch_error_sensor ));

        device.update_common_DPS();
    }
    
    
    
    return p_dps_rel_nav;
}
