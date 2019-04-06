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

    p_dps_orbit_tgt.mnvr_n =  device.svg.getElementById("p_dps_orbit_tgt_mnvr_n");
    p_dps_orbit_tgt.mnvr_tig = device.svg.getElementById("p_dps_orbit_tgt_mnvr_tig");
    p_dps_orbit_tgt.mnvr_dvx = device.svg.getElementById("p_dps_orbit_tgt_mnvr_dvx");
    p_dps_orbit_tgt.mnvr_dvy = device.svg.getElementById("p_dps_orbit_tgt_mnvr_dvy");
    p_dps_orbit_tgt.mnvr_dvz = device.svg.getElementById("p_dps_orbit_tgt_mnvr_dvz");
    p_dps_orbit_tgt.mnvr_dvt = device.svg.getElementById("p_dps_orbit_tgt_mnvr_dvt");

    p_dps_orbit_tgt.comp_t1 = device.svg.getElementById("p_dps_orbit_tgt_comp_t1");
    p_dps_orbit_tgt.comp_t2 = device.svg.getElementById("p_dps_orbit_tgt_comp_t2");

    p_dps_orbit_tgt.t1_dx = device.svg.getElementById("p_dps_orbit_tgt_t1_dx");
    p_dps_orbit_tgt.t1_dy = device.svg.getElementById("p_dps_orbit_tgt_t1_dy");
    p_dps_orbit_tgt.t1_dz = device.svg.getElementById("p_dps_orbit_tgt_t1_dz");

    p_dps_orbit_tgt.t1_dxdot = device.svg.getElementById("p_dps_orbit_tgt_t1_dxdot");
    p_dps_orbit_tgt.t1_dydot = device.svg.getElementById("p_dps_orbit_tgt_t1_dydot");
    p_dps_orbit_tgt.t1_dzdot = device.svg.getElementById("p_dps_orbit_tgt_t1_dzdot");

    p_dps_orbit_tgt.t2_dx = device.svg.getElementById("p_dps_orbit_tgt_t2_dx");
    p_dps_orbit_tgt.t2_dy = device.svg.getElementById("p_dps_orbit_tgt_t2_dy");
    p_dps_orbit_tgt.t2_dz = device.svg.getElementById("p_dps_orbit_tgt_t2_dz");
    p_dps_orbit_tgt.t2_dt = device.svg.getElementById("p_dps_orbit_tgt_t2_dt");

    p_dps_orbit_tgt.t1_tig = device.svg.getElementById("p_dps_orbit_tgt_t1_tig");
    p_dps_orbit_tgt.t2_tig = device.svg.getElementById("p_dps_orbit_tgt_t2_tig");
    p_dps_orbit_tgt.base_time = device.svg.getElementById("p_dps_orbit_tgt_base_time");

    p_dps_orbit_tgt.pred_match = device.svg.getElementById("p_dps_orbit_tgt_pred_match");

    p_dps_orbit_tgt.el = device.svg.getElementById("p_dps_orbit_tgt_el");
    p_dps_orbit_tgt.load = device.svg.getElementById("p_dps_orbit_tgt_load");

    p_dps_orbit_tgt.tgt_no = device.svg.getElementById("p_dps_orbit_tgt_tgt_no");


    p_dps_orbit_tgt.ondisplay = func
    {
        device.DPS_menu_title.setText("ORBIT TGT");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/034/";
        device.DPS_menu_ops.setText(ops_string);

	p_dps_orbit_tgt.load.setText("");
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

	var pred_match = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/pred-match-ft");
	p_dps_orbit_tgt.pred_match.setText(sprintf("%7.0f", pred_match));

	var symbol = "";
	if (SpaceShuttle.lambert_manager.t1_in_progress == 1){symbol = "*";}
	p_dps_orbit_tgt.comp_t1.setText(symbol);

	symbol = "";
	if (SpaceShuttle.lambert_manager.t2_in_progress == 1){symbol = "*";}
	p_dps_orbit_tgt.comp_t2.setText(symbol);
	

	p_dps_orbit_tgt.t1_dx.setText(sprintf("%+3.2f", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-dx")));
	p_dps_orbit_tgt.t1_dy.setText(sprintf("%+3.2f", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-dy")));
	p_dps_orbit_tgt.t1_dz.setText(sprintf("%+3.2f", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-dz")));

	p_dps_orbit_tgt.el.setText(sprintf("%+3.2f", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-el-deg")));

	p_dps_orbit_tgt.t1_dxdot.setText(sprintf("%+3.2f", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-dxdot")));
	p_dps_orbit_tgt.t1_dydot.setText(sprintf("%+3.2f", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-dydot")));
	p_dps_orbit_tgt.t1_dzdot.setText(sprintf("%+3.2f", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-dzdot")));

	p_dps_orbit_tgt.t2_dx.setText(sprintf("%+3.2f", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dx")));
	p_dps_orbit_tgt.t2_dy.setText(sprintf("%+3.2f", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dy")));
	p_dps_orbit_tgt.t2_dz.setText(sprintf("%+3.2f", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-dz")));

	var t2_dt = getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-tig") -  getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-tig") ;
	if (t2_dt < 0.0) {t2_dt = 0.0;}

	p_dps_orbit_tgt.t2_dt.setText(sprintf("%+3.2f", t2_dt / 60.0));

   	p_dps_orbit_tgt.t1_tig.setText(getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-tig-string"));
    	p_dps_orbit_tgt.t2_tig.setText(getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t2-tig-string"));
    	p_dps_orbit_tgt.base_time.setText(getprop("/fdm/jsbsim/systems/ap/orbit-tgt/t1-tig-string"));

	p_dps_orbit_tgt.mnvr_n.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/mnvr-n")));
	p_dps_orbit_tgt.tgt_no.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/navigation/orbital-tgt/tgt-id")));

        device.update_common_DPS(sprintf("%d", getprop("/fdm/jsbsim/systems/ap/orbit-tgt/mnvr-n")));
    }
    
    
    
    return p_dps_orbit_tgt;
}
