#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_orbit_tgt
# Description: the CRT orbital targeting page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_orbit_tgt = func(device)
{
    var p_dps_orbit_tgt = device.addPage("CRTOrbitTgt", "p_dps_orbit_tgt");

    p_dps_orbit_tgt.group = device.svg.getElementById("p_dps_orbit_tgt");
    p_dps_orbit_tgt.group.setColor(dps_r, dps_g, dps_b);
    
    p_dps_orbit_tgt.ostate_time = device.svg.getElementById("p_dps_orbit_tgt_ostate_time");

    p_dps_orbit_tgt.ostate_x = device.svg.getElementById("p_dps_orbit_tgt_ostate_x");
    p_dps_orbit_tgt.ostate_y = device.svg.getElementById("p_dps_orbit_tgt_ostate_y");
    p_dps_orbit_tgt.ostate_z = device.svg.getElementById("p_dps_orbit_tgt_ostate_z");

    p_dps_orbit_tgt.ostate_vx = device.svg.getElementById("p_dps_orbit_tgt_ostate_vx");
    p_dps_orbit_tgt.ostate_vy = device.svg.getElementById("p_dps_orbit_tgt_ostate_vy");
    p_dps_orbit_tgt.ostate_vz = device.svg.getElementById("p_dps_orbit_tgt_ostate_vz");

    p_dps_orbit_tgt.mnvr_tig = device.svg.getElementById("p_dps_orbit_tgt_mnvr_tig");
    p_dps_orbit_tgt.mnvr_dvx = device.svg.getElementById("p_dps_orbit_tgt_mnvr_dvx");
    p_dps_orbit_tgt.mnvr_dvy = device.svg.getElementById("p_dps_orbit_tgt_mnvr_dvy");
    p_dps_orbit_tgt.mnvr_dvz = device.svg.getElementById("p_dps_orbit_tgt_mnvr_dvz");
    p_dps_orbit_tgt.mnvr_dvt = device.svg.getElementById("p_dps_orbit_tgt_mnvr_dvt");

    p_dps_orbit_tgt.ondisplay = func
    {
        device.DPS_menu_title.setText("ORBIT TGT");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/034/";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_orbit_tgt.update = func
    {
    
        var GMT_string = getprop("/fdm/jsbsim/systems/timer/GMT-string");
	p_dps_orbit_tgt.ostate_time.setText(GMT_string);

	# right now these show JSBSim rather than M50 inertial - need to change eventually

	var oxpos = getprop("/fdm/jsbsim/position/eci-x-ft")/1000.0;
	var oypos = getprop("/fdm/jsbsim/position/eci-y-ft")/1000.0;
	var ozpos = getprop("/fdm/jsbsim/position/eci-z-ft")/1000.0;
    
	p_dps_orbit_tgt.ostate_x.setText(sprintf("%+5.3f", oxpos));
	p_dps_orbit_tgt.ostate_y.setText(sprintf("%+5.3f", oypos));
	p_dps_orbit_tgt.ostate_z.setText(sprintf("%+5.3f", ozpos));

	var ovx = getprop("/fdm/jsbsim/velocities/eci-x-fps")/1000.0;
	var ovy = getprop("/fdm/jsbsim/velocities/eci-y-fps")/1000.0;
	var ovz = getprop("/fdm/jsbsim/velocities/eci-z-fps")/1000.0;

	p_dps_orbit_tgt.ostate_vx.setText(sprintf("%+2.6f", ovx));
	p_dps_orbit_tgt.ostate_vy.setText(sprintf("%+2.6f", ovy));
	p_dps_orbit_tgt.ostate_vz.setText(sprintf("%+2.6f", ovz));
    
	var mnvr_tig = getprop("/fdm/jsbsim/systems/ap/oms-plan/tig-string");
	var mnvr_dvx = getprop("/fdm/jsbsim/systems/ap/oms-plan/dvx");
	var mnvr_dvy = getprop("/fdm/jsbsim/systems/ap/oms-plan/dvy");
	var mnvr_dvz = getprop("/fdm/jsbsim/systems/ap/oms-plan/dvz");
	var mnvr_dvt = math.sqrt(mnvr_dvx * mnvr_dvx + mnvr_dvy * mnvr_dvy + mnvr_dvz * mnvr_dvz );

	p_dps_orbit_tgt.mnvr_tig.setText(mnvr_tig);
    	p_dps_orbit_tgt.mnvr_dvx.setText(sprintf("%+3.1f", mnvr_dvx));
    	p_dps_orbit_tgt.mnvr_dvy.setText(sprintf("%+2.1f", mnvr_dvy));
    	p_dps_orbit_tgt.mnvr_dvz.setText(sprintf("%+2.1f", mnvr_dvz));
    	p_dps_orbit_tgt.mnvr_dvt.setText(sprintf("%+3.1f", mnvr_dvt));

        device.update_common_DPS();
    }
    
    
    
    return p_dps_orbit_tgt;
}
