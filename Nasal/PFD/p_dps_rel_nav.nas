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
       
    p_dps_rel_nav.sv_sel = device.svg.getElementById("p_dps_rel_nav_sv_sel");
	
    p_dps_rel_nav.rng_prop = device.svg.getElementById("p_dps_rel_nav_rng_prop");
    p_dps_rel_nav.rdot_prop = device.svg.getElementById("p_dps_rel_nav_rdot_prop");
    p_dps_rel_nav.theta_prop = device.svg.getElementById("p_dps_rel_nav_theta_prop");
    p_dps_rel_nav.y_prop = device.svg.getElementById("p_dps_rel_nav_y_prop");
    p_dps_rel_nav.ydot_prop = device.svg.getElementById("p_dps_rel_nav_ydot_prop");

    p_dps_rel_nav.ondisplay = func
    {
        device.DPS_menu_title.setText("REL NAV");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/033/";
        device.DPS_menu_ops.setText(ops_string);
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

	var text = "PROP";
	if (getprop("/fdm/jsbsim/systems/rendezvous/sv-select") == 1) {text = "FLTR";}
	p_dps_rel_nav.sv_sel.setText(text);
    
      
    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_rel_nav;
}
