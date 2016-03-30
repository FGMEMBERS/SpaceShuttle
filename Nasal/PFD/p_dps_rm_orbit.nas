#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_rm_orbit
# Description: the generic THC/RHC control page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_rm_orbit = func(device)
{
    var p_dps_rm_orbit = device.addPage("CRTRmOrbit", "p_dps_rm_orbit");

    p_dps_rm_orbit.group = device.svg.getElementById("p_dps_rm_orbit");
    p_dps_rm_orbit.group.setColor(dps_r, dps_g, dps_b);
    
    p_dps_rm_orbit.thcl1_tx = device.svg.getElementById("p_dps_rm_orbit_thcl1_tx");
    p_dps_rm_orbit.thcl1_ty = device.svg.getElementById("p_dps_rm_orbit_thcl1_ty");
    p_dps_rm_orbit.thcl1_tz = device.svg.getElementById("p_dps_rm_orbit_thcl1_tz");
    p_dps_rm_orbit.thcl1_des = device.svg.getElementById("p_dps_rm_orbit_thcl1_des");

    p_dps_rm_orbit.thcl2_tx = device.svg.getElementById("p_dps_rm_orbit_thcl2_tx");
    p_dps_rm_orbit.thcl2_ty = device.svg.getElementById("p_dps_rm_orbit_thcl2_ty");
    p_dps_rm_orbit.thcl2_tz = device.svg.getElementById("p_dps_rm_orbit_thcl2_tz");
    p_dps_rm_orbit.thcl2_des = device.svg.getElementById("p_dps_rm_orbit_thcl2_des");

    p_dps_rm_orbit.thcl3_tx = device.svg.getElementById("p_dps_rm_orbit_thcl3_tx");
    p_dps_rm_orbit.thcl3_ty = device.svg.getElementById("p_dps_rm_orbit_thcl3_ty");
    p_dps_rm_orbit.thcl3_tz = device.svg.getElementById("p_dps_rm_orbit_thcl3_tz");
    p_dps_rm_orbit.thcl3_des = device.svg.getElementById("p_dps_rm_orbit_thcl3_des");

    p_dps_rm_orbit.thca1_tx = device.svg.getElementById("p_dps_rm_orbit_thca1_tx");
    p_dps_rm_orbit.thca1_ty = device.svg.getElementById("p_dps_rm_orbit_thca1_ty");
    p_dps_rm_orbit.thca1_tz = device.svg.getElementById("p_dps_rm_orbit_thca1_tz");
    p_dps_rm_orbit.thca1_des = device.svg.getElementById("p_dps_rm_orbit_thca1_des");

    p_dps_rm_orbit.thca2_tx = device.svg.getElementById("p_dps_rm_orbit_thca2_tx");
    p_dps_rm_orbit.thca2_ty = device.svg.getElementById("p_dps_rm_orbit_thca2_ty");
    p_dps_rm_orbit.thca2_tz = device.svg.getElementById("p_dps_rm_orbit_thca2_tz");
    p_dps_rm_orbit.thca2_des = device.svg.getElementById("p_dps_rm_orbit_thca2_des");

    p_dps_rm_orbit.thca3_tx = device.svg.getElementById("p_dps_rm_orbit_thca3_tx");
    p_dps_rm_orbit.thca3_ty = device.svg.getElementById("p_dps_rm_orbit_thca3_ty");
    p_dps_rm_orbit.thca3_tz = device.svg.getElementById("p_dps_rm_orbit_thca3_tz");
    p_dps_rm_orbit.thca3_des = device.svg.getElementById("p_dps_rm_orbit_thca3_des");
    
    p_dps_rm_orbit.rhcl1_r = device.svg.getElementById("p_dps_rm_orbit_rhcl1_r");
    p_dps_rm_orbit.rhcl1_p = device.svg.getElementById("p_dps_rm_orbit_rhcl1_p");
    p_dps_rm_orbit.rhcl1_y = device.svg.getElementById("p_dps_rm_orbit_rhcl1_y");
    p_dps_rm_orbit.rhcl1_des = device.svg.getElementById("p_dps_rm_orbit_rhcl1_des");

    p_dps_rm_orbit.rhcl2_r = device.svg.getElementById("p_dps_rm_orbit_rhcl2_r");
    p_dps_rm_orbit.rhcl2_p = device.svg.getElementById("p_dps_rm_orbit_rhcl2_p");
    p_dps_rm_orbit.rhcl2_y = device.svg.getElementById("p_dps_rm_orbit_rhcl2_y");
    p_dps_rm_orbit.rhcl2_des = device.svg.getElementById("p_dps_rm_orbit_rhcl2_des");

    p_dps_rm_orbit.rhcl3_r = device.svg.getElementById("p_dps_rm_orbit_rhcl3_r");
    p_dps_rm_orbit.rhcl3_p = device.svg.getElementById("p_dps_rm_orbit_rhcl3_p");
    p_dps_rm_orbit.rhcl3_y = device.svg.getElementById("p_dps_rm_orbit_rhcl3_y");
    p_dps_rm_orbit.rhcl3_des = device.svg.getElementById("p_dps_rm_orbit_rhcl3_des");

    p_dps_rm_orbit.rhcr1_r = device.svg.getElementById("p_dps_rm_orbit_rhcr1_r");
    p_dps_rm_orbit.rhcr1_p = device.svg.getElementById("p_dps_rm_orbit_rhcr1_p");
    p_dps_rm_orbit.rhcr1_y = device.svg.getElementById("p_dps_rm_orbit_rhcr1_y");
    p_dps_rm_orbit.rhcr1_des = device.svg.getElementById("p_dps_rm_orbit_rhcr1_des");

    p_dps_rm_orbit.rhcr2_r = device.svg.getElementById("p_dps_rm_orbit_rhcr2_r");
    p_dps_rm_orbit.rhcr2_p = device.svg.getElementById("p_dps_rm_orbit_rhcr2_p");
    p_dps_rm_orbit.rhcr2_y = device.svg.getElementById("p_dps_rm_orbit_rhcr2_y");
    p_dps_rm_orbit.rhcr2_des = device.svg.getElementById("p_dps_rm_orbit_rhcr2_des");

    p_dps_rm_orbit.rhcr3_r = device.svg.getElementById("p_dps_rm_orbit_rhcr3_r");
    p_dps_rm_orbit.rhcr3_p = device.svg.getElementById("p_dps_rm_orbit_rhcr3_p");
    p_dps_rm_orbit.rhcr3_y = device.svg.getElementById("p_dps_rm_orbit_rhcr3_y");
    p_dps_rm_orbit.rhcr3_des = device.svg.getElementById("p_dps_rm_orbit_rhcr3_des");

    p_dps_rm_orbit.rhca1_r = device.svg.getElementById("p_dps_rm_orbit_rhca1_r");
    p_dps_rm_orbit.rhca1_p = device.svg.getElementById("p_dps_rm_orbit_rhca1_p");
    p_dps_rm_orbit.rhca1_y = device.svg.getElementById("p_dps_rm_orbit_rhca1_y");
    p_dps_rm_orbit.rhca1_des = device.svg.getElementById("p_dps_rm_orbit_rhca1_des");

    p_dps_rm_orbit.rhca2_r = device.svg.getElementById("p_dps_rm_orbit_rhca2_r");
    p_dps_rm_orbit.rhca2_p = device.svg.getElementById("p_dps_rm_orbit_rhca2_p");
    p_dps_rm_orbit.rhca2_y = device.svg.getElementById("p_dps_rm_orbit_rhca2_y");
    p_dps_rm_orbit.rhca2_des = device.svg.getElementById("p_dps_rm_orbit_rhca2_des");

    p_dps_rm_orbit.rhca3_r = device.svg.getElementById("p_dps_rm_orbit_rhca3_r");
    p_dps_rm_orbit.rhca3_p = device.svg.getElementById("p_dps_rm_orbit_rhca3_p");
    p_dps_rm_orbit.rhca3_y = device.svg.getElementById("p_dps_rm_orbit_rhca3_y");
    p_dps_rm_orbit.rhca3_des = device.svg.getElementById("p_dps_rm_orbit_rhca3_des");

    p_dps_rm_orbit.sw_rm_inh = device.svg.getElementById("p_dps_rm_orbit_sw_rm_inh");



    p_dps_rm_orbit.ondisplay = func
    {
        device.DPS_menu_title.setText("RM ORBIT");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/025/";
        device.DPS_menu_ops.setText(ops_string);

	# set defaults for functions which are not yet available

	p_dps_rm_orbit.thcl1_des.setText("");
	p_dps_rm_orbit.thcl2_des.setText("");
	p_dps_rm_orbit.thcl3_des.setText("");

	p_dps_rm_orbit.thca1_des.setText("");
	p_dps_rm_orbit.thca2_des.setText("");
	p_dps_rm_orbit.thca3_des.setText("");

	p_dps_rm_orbit.rhcl1_des.setText("");
	p_dps_rm_orbit.rhcl2_des.setText("");
	p_dps_rm_orbit.rhcl3_des.setText("");

	p_dps_rm_orbit.rhcr1_des.setText("");
	p_dps_rm_orbit.rhcr2_des.setText("");
	p_dps_rm_orbit.rhcr3_des.setText("");

	p_dps_rm_orbit.rhca1_des.setText("");
	p_dps_rm_orbit.rhca2_des.setText("");
	p_dps_rm_orbit.rhca3_des.setText("");

	p_dps_rm_orbit.sw_rm_inh.setText("");
	
    }
    
    p_dps_rm_orbit.update = func
    {
    
	var station = getprop("/sim/current-view/name");
	
	var station_flag = 0;

	if (station == "Pilot"){station_flag = 1;}
	else if (station == "Payload specialist station"){station_flag = 2;}

	var dap_mode = getprop("/fdm/jsbsim/systems/fcs/control-mode");

	var dap_trans = 0;

	if ((dap_mode == 2) or (dap_mode == 26) or (dap_mode == 27) or (dap_mode == 28))
		{dap_trans = 1;}

	var transducer_rudder = getprop("/fdm/jsbsim/fcs/rudder-cmd-norm");
	var transducer_aileron = getprop("/fdm/jsbsim/fcs/aileron-cmd-norm");
	var transducer_elevator = getprop("/fdm/jsbsim/fcs/elevator-cmd-norm");

	var transducer_string_rudder = "";
	var transducer_marker_rudder = "";
	if (transducer_rudder > 0.0) {transducer_string_rudder = "-"; transducer_marker_rudder = "L";} 
	else if (transducer_rudder < 0.0) {transducer_string_rudder = "+"; transducer_marker_rudder = "R";}

	var transducer_string_aileron = "";
	var transducer_marker_aileron = "";
	if (transducer_aileron > 0.0) {transducer_string_aileron = "+"; transducer_marker_aileron = "R";} 
	else if (transducer_aileron < 0.0) {transducer_string_aileron = "-";transducer_marker_aileron = "L";}

	var transducer_string_elevator = "";
	var transducer_marker_elevator = "";
	if (transducer_elevator > 0.0) {transducer_string_elevator = "+"; transducer_marker_elevator ="D";} 
	else if (transducer_elevator < 0.0) {transducer_string_elevator = "-";transducer_marker_elevator ="U";}

	var transducer_percentage_rudder = int(math.abs(transducer_rudder)  * 100.0)~transducer_marker_rudder;
	var transducer_percentage_aileron = int(math.abs(transducer_aileron)  * 100.0)~transducer_marker_aileron;
	var transducer_percentage_elevator = int(math.abs(transducer_elevator)  * 100.0)~transducer_marker_elevator;

	if (transducer_rudder ==0.0) {transducer_percentage_rudder = "";}
	if (transducer_elevator ==0.0) {transducer_percentage_elevator = "";}
	if (transducer_aileron ==0.0) {transducer_percentage_aileron = "";}

	# set the translational readings    

	if ((station_flag == 0) or (station_flag == 1))
	{
	if (dap_trans == 1)
		{
		p_dps_rm_orbit.thcl1_tx.setText(transducer_string_rudder);
		p_dps_rm_orbit.thcl2_tx.setText(transducer_string_rudder);
		p_dps_rm_orbit.thcl3_tx.setText(transducer_string_rudder);

		p_dps_rm_orbit.thcl1_ty.setText(transducer_string_aileron);
		p_dps_rm_orbit.thcl2_ty.setText(transducer_string_aileron);
		p_dps_rm_orbit.thcl3_ty.setText(transducer_string_aileron);

		p_dps_rm_orbit.thcl1_tz.setText(transducer_string_elevator);
		p_dps_rm_orbit.thcl2_tz.setText(transducer_string_elevator);
		p_dps_rm_orbit.thcl3_tz.setText(transducer_string_elevator);
		}

	else
		{
		p_dps_rm_orbit.thcl1_tx.setText("");
		p_dps_rm_orbit.thcl2_tx.setText("");
		p_dps_rm_orbit.thcl3_tx.setText("");

		p_dps_rm_orbit.thcl1_ty.setText("");
		p_dps_rm_orbit.thcl2_ty.setText("");
		p_dps_rm_orbit.thcl3_ty.setText("");

		p_dps_rm_orbit.thcl1_tz.setText("");
		p_dps_rm_orbit.thcl2_tz.setText("");
		p_dps_rm_orbit.thcl3_tz.setText("");
		}
	p_dps_rm_orbit.thca1_tx.setText("");
	p_dps_rm_orbit.thca2_tx.setText("");
	p_dps_rm_orbit.thca3_tx.setText("");

	p_dps_rm_orbit.thca1_ty.setText("");
	p_dps_rm_orbit.thca2_ty.setText("");
	p_dps_rm_orbit.thca3_ty.setText("");

	p_dps_rm_orbit.thca1_tz.setText("");
	p_dps_rm_orbit.thca2_tz.setText("");
	p_dps_rm_orbit.thca3_tz.setText("");
	}
	else # we're controlling from Payload specialist station
	{
	if (dap_trans == 1)
		{
		p_dps_rm_orbit.thca1_tx.setText(transducer_string_rudder);
		p_dps_rm_orbit.thca2_tx.setText(transducer_string_rudder);
		p_dps_rm_orbit.thca3_tx.setText(transducer_string_rudder);

		p_dps_rm_orbit.thca1_ty.setText(transducer_string_aileron);
		p_dps_rm_orbit.thca2_ty.setText(transducer_string_aileron);
		p_dps_rm_orbit.thca3_ty.setText(transducer_string_aileron);

		p_dps_rm_orbit.thca1_tz.setText(transducer_string_elevator);
		p_dps_rm_orbit.thca2_tz.setText(transducer_string_elevator);
		p_dps_rm_orbit.thca3_tz.setText(transducer_string_elevator);
		}

	else
		{
		p_dps_rm_orbit.thca1_tx.setText("");
		p_dps_rm_orbit.thca2_tx.setText("");
		p_dps_rm_orbit.thca3_tx.setText("");

		p_dps_rm_orbit.thca1_ty.setText("");
		p_dps_rm_orbit.thca2_ty.setText("");
		p_dps_rm_orbit.thca3_ty.setText("");

		p_dps_rm_orbit.thca1_tz.setText("");
		p_dps_rm_orbit.thca2_tz.setText("");
		p_dps_rm_orbit.thca3_tz.setText("");
		}
	
	p_dps_rm_orbit.thcl1_tx.setText("");
	p_dps_rm_orbit.thcl2_tx.setText("");
	p_dps_rm_orbit.thcl3_tx.setText("");

	p_dps_rm_orbit.thcl1_ty.setText("");
	p_dps_rm_orbit.thcl2_ty.setText("");
	p_dps_rm_orbit.thcl3_ty.setText("");

	p_dps_rm_orbit.thcl1_tz.setText("");
	p_dps_rm_orbit.thcl2_tz.setText("");
	p_dps_rm_orbit.thcl3_tz.setText("");
	}


	# set the rotational readings

	if (station_flag == 0)
	{
	if (dap_trans == 0)
		{
		p_dps_rm_orbit.rhcl1_y.setText(transducer_percentage_rudder);
		p_dps_rm_orbit.rhcl2_y.setText(transducer_percentage_rudder);
		p_dps_rm_orbit.rhcl3_y.setText(transducer_percentage_rudder);

		p_dps_rm_orbit.rhcl1_p.setText(transducer_percentage_elevator);
		p_dps_rm_orbit.rhcl2_p.setText(transducer_percentage_elevator);
		p_dps_rm_orbit.rhcl3_p.setText(transducer_percentage_elevator);

		p_dps_rm_orbit.rhcl1_r.setText(transducer_percentage_aileron);
		p_dps_rm_orbit.rhcl2_r.setText(transducer_percentage_aileron);
		p_dps_rm_orbit.rhcl3_r.setText(transducer_percentage_aileron);
		}

	else
		{
		p_dps_rm_orbit.rhcl1_y.setText("");
		p_dps_rm_orbit.rhcl2_y.setText("");
		p_dps_rm_orbit.rhcl3_y.setText("");

		p_dps_rm_orbit.rhcl1_p.setText("");
		p_dps_rm_orbit.rhcl2_p.setText("");
		p_dps_rm_orbit.rhcl3_p.setText("");

		p_dps_rm_orbit.rhcl1_r.setText("");
		p_dps_rm_orbit.rhcl2_r.setText("");
		p_dps_rm_orbit.rhcl3_r.setText("");
		}

		p_dps_rm_orbit.rhcr1_y.setText("");
		p_dps_rm_orbit.rhcr2_y.setText("");
		p_dps_rm_orbit.rhcr3_y.setText("");

		p_dps_rm_orbit.rhcr1_p.setText("");
		p_dps_rm_orbit.rhcr2_p.setText("");
		p_dps_rm_orbit.rhcr3_p.setText("");

		p_dps_rm_orbit.rhcr1_r.setText("");
		p_dps_rm_orbit.rhcr2_r.setText("");
		p_dps_rm_orbit.rhcr3_r.setText("");

		p_dps_rm_orbit.rhca1_y.setText("");
		p_dps_rm_orbit.rhca2_y.setText("");
		p_dps_rm_orbit.rhca3_y.setText("");

		p_dps_rm_orbit.rhca1_p.setText("");
		p_dps_rm_orbit.rhca2_p.setText("");
		p_dps_rm_orbit.rhca3_p.setText("");

		p_dps_rm_orbit.rhca1_r.setText("");
		p_dps_rm_orbit.rhca2_r.setText("");
		p_dps_rm_orbit.rhca3_r.setText("");
	}
	else if (station_flag == 1)
	{
	if (dap_trans == 0)
		{
		p_dps_rm_orbit.rhcr1_y.setText(transducer_percentage_rudder);
		p_dps_rm_orbit.rhcr2_y.setText(transducer_percentage_rudder);
		p_dps_rm_orbit.rhcr3_y.setText(transducer_percentage_rudder);

		p_dps_rm_orbit.rhcr1_p.setText(transducer_percentage_elevator);
		p_dps_rm_orbit.rhcr2_p.setText(transducer_percentage_elevator);
		p_dps_rm_orbit.rhcr3_p.setText(transducer_percentage_elevator);

		p_dps_rm_orbit.rhcr1_r.setText(transducer_percentage_aileron);
		p_dps_rm_orbit.rhcr2_r.setText(transducer_percentage_aileron);
		p_dps_rm_orbit.rhcr3_r.setText(transducer_percentage_aileron);
		}

	else
		{
		p_dps_rm_orbit.rhcr1_y.setText("");
		p_dps_rm_orbit.rhcr2_y.setText("");
		p_dps_rm_orbit.rhcr3_y.setText("");

		p_dps_rm_orbit.rhcr1_p.setText("");
		p_dps_rm_orbit.rhcr2_p.setText("");
		p_dps_rm_orbit.rhcr3_p.setText("");

		p_dps_rm_orbit.rhcr1_r.setText("");
		p_dps_rm_orbit.rhcr2_r.setText("");
		p_dps_rm_orbit.rhcr3_r.setText("");
		}

		p_dps_rm_orbit.rhcl1_y.setText("");
		p_dps_rm_orbit.rhcl2_y.setText("");
		p_dps_rm_orbit.rhcl3_y.setText("");

		p_dps_rm_orbit.rhcl1_p.setText("");
		p_dps_rm_orbit.rhcl2_p.setText("");
		p_dps_rm_orbit.rhcl3_p.setText("");

		p_dps_rm_orbit.rhcl1_r.setText("");
		p_dps_rm_orbit.rhcl2_r.setText("");
		p_dps_rm_orbit.rhcl3_r.setText("");

		p_dps_rm_orbit.rhca1_y.setText("");
		p_dps_rm_orbit.rhca2_y.setText("");
		p_dps_rm_orbit.rhca3_y.setText("");

		p_dps_rm_orbit.rhca1_p.setText("");
		p_dps_rm_orbit.rhca2_p.setText("");
		p_dps_rm_orbit.rhca3_p.setText("");

		p_dps_rm_orbit.rhca1_r.setText("");
		p_dps_rm_orbit.rhca2_r.setText("");
		p_dps_rm_orbit.rhca3_r.setText("");
	}
	else if (station_flag == 2)
	{
	if (dap_trans == 0)
		{
		p_dps_rm_orbit.rhca1_y.setText(transducer_percentage_rudder);
		p_dps_rm_orbit.rhca2_y.setText(transducer_percentage_rudder);
		p_dps_rm_orbit.rhca3_y.setText(transducer_percentage_rudder);

		p_dps_rm_orbit.rhca1_p.setText(transducer_percentage_elevator);
		p_dps_rm_orbit.rhca2_p.setText(transducer_percentage_elevator);
		p_dps_rm_orbit.rhca3_p.setText(transducer_percentage_elevator);

		p_dps_rm_orbit.rhca1_r.setText(transducer_percentage_aileron);
		p_dps_rm_orbit.rhca2_r.setText(transducer_percentage_aileron);
		p_dps_rm_orbit.rhca3_r.setText(transducer_percentage_aileron);
		}

	else
		{
		p_dps_rm_orbit.rhca1_y.setText("");
		p_dps_rm_orbit.rhca2_y.setText("");
		p_dps_rm_orbit.rhca3_y.setText("");

		p_dps_rm_orbit.rhca1_p.setText("");
		p_dps_rm_orbit.rhca2_p.setText("");
		p_dps_rm_orbit.rhca3_p.setText("");

		p_dps_rm_orbit.rhca1_r.setText("");
		p_dps_rm_orbit.rhca2_r.setText("");
		p_dps_rm_orbit.rhca3_r.setText("");
		}

		p_dps_rm_orbit.rhcr1_y.setText("");
		p_dps_rm_orbit.rhcr2_y.setText("");
		p_dps_rm_orbit.rhcr3_y.setText("");

		p_dps_rm_orbit.rhcr1_p.setText("");
		p_dps_rm_orbit.rhcr2_p.setText("");
		p_dps_rm_orbit.rhcr3_p.setText("");

		p_dps_rm_orbit.rhcr1_r.setText("");
		p_dps_rm_orbit.rhcr2_r.setText("");
		p_dps_rm_orbit.rhcr3_r.setText("");

		p_dps_rm_orbit.rhcl1_y.setText("");
		p_dps_rm_orbit.rhcl2_y.setText("");
		p_dps_rm_orbit.rhcl3_y.setText("");

		p_dps_rm_orbit.rhcl1_p.setText("");
		p_dps_rm_orbit.rhcl2_p.setText("");
		p_dps_rm_orbit.rhcl3_p.setText("");

		p_dps_rm_orbit.rhcl1_r.setText("");
		p_dps_rm_orbit.rhcl2_r.setText("");
		p_dps_rm_orbit.rhcl3_r.setText("");
	}

	

        device.update_common_DPS();
    }
    
    
    
    return p_dps_rm_orbit;
}
