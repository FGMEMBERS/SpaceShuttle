#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_rcs
# Description: the RCS DPS page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_rcs = func(device)
{
    var p_dps_rcs = device.addPage("CRTRCS", "p_dps_rcs");

    p_dps_rcs.group = device.svg.getElementById("p_dps_rcs");
    p_dps_rcs.group.setColor(dps_r, dps_g, dps_b);
    
    p_dps_rcs.sel_f = device.svg.getElementById("p_dps_rcs_sel_f");
    p_dps_rcs.sel_l = device.svg.getElementById("p_dps_rcs_sel_l");
    p_dps_rcs.sel_r = device.svg.getElementById("p_dps_rcs_sel_r");

    p_dps_rcs.jdesig_y1 = device.svg.getElementById("p_dps_rcs_jdesig_y1");
    p_dps_rcs.jdesig_y2 = device.svg.getElementById("p_dps_rcs_jdesig_y2");
    p_dps_rcs.jdesig_y3 = device.svg.getElementById("p_dps_rcs_jdesig_y3");
    p_dps_rcs.jdesig_y4 = device.svg.getElementById("p_dps_rcs_jdesig_y4");

    p_dps_rcs.jdesig_z1 = device.svg.getElementById("p_dps_rcs_jdesig_z1");
    p_dps_rcs.jdesig_z2 = device.svg.getElementById("p_dps_rcs_jdesig_z2");
    p_dps_rcs.jdesig_z3 = device.svg.getElementById("p_dps_rcs_jdesig_z3");

    p_dps_rcs.jfail_y1 = device.svg.getElementById("p_dps_rcs_jfail_y1");
    p_dps_rcs.jfail_y2 = device.svg.getElementById("p_dps_rcs_jfail_y2");
    p_dps_rcs.jfail_y3 = device.svg.getElementById("p_dps_rcs_jfail_y3");
    p_dps_rcs.jfail_y4 = device.svg.getElementById("p_dps_rcs_jfail_y4");

    p_dps_rcs.jfail_z1 = device.svg.getElementById("p_dps_rcs_jfail_z1");
    p_dps_rcs.jfail_z2 = device.svg.getElementById("p_dps_rcs_jfail_z2");
    p_dps_rcs.jfail_z3 = device.svg.getElementById("p_dps_rcs_jfail_z3");

    p_dps_rcs.jdes_y1 = device.svg.getElementById("p_dps_rcs_jdes_y1");
    p_dps_rcs.jdes_y2 = device.svg.getElementById("p_dps_rcs_jdes_y2");
    p_dps_rcs.jdes_y3 = device.svg.getElementById("p_dps_rcs_jdes_y3");
    p_dps_rcs.jdes_y4 = device.svg.getElementById("p_dps_rcs_jdes_y4");

    p_dps_rcs.jdes_z1 = device.svg.getElementById("p_dps_rcs_jdes_z1");
    p_dps_rcs.jdes_z2 = device.svg.getElementById("p_dps_rcs_jdes_z2");
    p_dps_rcs.jdes_z3 = device.svg.getElementById("p_dps_rcs_jdes_z3");

    p_dps_rcs.jdesi_y1 = device.svg.getElementById("p_dps_rcs_jdesi_y1");
    p_dps_rcs.jdesi_y2 = device.svg.getElementById("p_dps_rcs_jdesi_y2");
    p_dps_rcs.jdesi_y3 = device.svg.getElementById("p_dps_rcs_jdesi_y3");
    p_dps_rcs.jdesi_y4 = device.svg.getElementById("p_dps_rcs_jdesi_y4");

    p_dps_rcs.jdesi_z1 = device.svg.getElementById("p_dps_rcs_jdesi_z1");
    p_dps_rcs.jdesi_z2 = device.svg.getElementById("p_dps_rcs_jdesi_z2");
    p_dps_rcs.jdesi_z3 = device.svg.getElementById("p_dps_rcs_jdesi_z3");

    p_dps_rcs.jpty_y1 = device.svg.getElementById("p_dps_rcs_jpty_y1");
    p_dps_rcs.jpty_y2 = device.svg.getElementById("p_dps_rcs_jpty_y2");
    p_dps_rcs.jpty_y3 = device.svg.getElementById("p_dps_rcs_jpty_y3");
    p_dps_rcs.jpty_y4 = device.svg.getElementById("p_dps_rcs_jpty_y4");

    p_dps_rcs.jpty_z1 = device.svg.getElementById("p_dps_rcs_jpty_z1");
    p_dps_rcs.jpty_z2 = device.svg.getElementById("p_dps_rcs_jpty_z2");
    p_dps_rcs.jpty_z3 = device.svg.getElementById("p_dps_rcs_jpty_z3");


   
    p_dps_rcs.jdesig_z4 = device.svg.getElementById("p_dps_rcs_jdesig_z4");
    p_dps_rcs.jdesig_z5 = device.svg.getElementById("p_dps_rcs_jdesig_z5");
    p_dps_rcs.jdesig_z6 = device.svg.getElementById("p_dps_rcs_jdesig_z6");
    p_dps_rcs.jdesig_z7 = device.svg.getElementById("p_dps_rcs_jdesig_z7");

    p_dps_rcs.jdesig_x1 = device.svg.getElementById("p_dps_rcs_jdesig_x1");
    p_dps_rcs.jdesig_x2 = device.svg.getElementById("p_dps_rcs_jdesig_x2");
    p_dps_rcs.jdesig_x3 = device.svg.getElementById("p_dps_rcs_jdesig_x3");

    p_dps_rcs.jdesig_v1 = device.svg.getElementById("p_dps_rcs_jdesig_v1");
    p_dps_rcs.jdesig_v2 = device.svg.getElementById("p_dps_rcs_jdesig_v2");

    p_dps_rcs.he_p_oxid = device.svg.getElementById("p_dps_rcs_he_p_oxid");
    p_dps_rcs.he_p_fu = device.svg.getElementById("p_dps_rcs_he_p_fu");

    p_dps_rcs.tk_p_oxid = device.svg.getElementById("p_dps_rcs_tk_p_oxid");
    p_dps_rcs.tk_p_fu = device.svg.getElementById("p_dps_rcs_tk_p_fu");

    p_dps_rcs.tk_t_oxid = device.svg.getElementById("p_dps_rcs_tk_t_oxid");
    p_dps_rcs.tk_t_fu = device.svg.getElementById("p_dps_rcs_tk_t_fu");

    p_dps_rcs.tk_qty_oxid = device.svg.getElementById("p_dps_rcs_tk_qty_oxid");
    p_dps_rcs.tk_qty_fu = device.svg.getElementById("p_dps_rcs_tk_qty_fu");

    p_dps_rcs.manf_p1_oxid = device.svg.getElementById("p_dps_rcs_manf_p1_oxid");
    p_dps_rcs.manf_p1_fu = device.svg.getElementById("p_dps_rcs_manf_p1_fu");

    p_dps_rcs.manf_p2_oxid = device.svg.getElementById("p_dps_rcs_manf_p2_oxid");
    p_dps_rcs.manf_p2_fu = device.svg.getElementById("p_dps_rcs_manf_p2_fu");

    p_dps_rcs.manf_p3_oxid = device.svg.getElementById("p_dps_rcs_manf_p3_oxid");
    p_dps_rcs.manf_p3_fu = device.svg.getElementById("p_dps_rcs_manf_p3_fu");

    p_dps_rcs.manf_p4_oxid = device.svg.getElementById("p_dps_rcs_manf_p4_oxid");
    p_dps_rcs.manf_p4_fu = device.svg.getElementById("p_dps_rcs_manf_p4_fu");

    p_dps_rcs.manf_v1_stat = device.svg.getElementById("p_dps_rcs_manf_v1_stat");
    p_dps_rcs.manf_v2_stat = device.svg.getElementById("p_dps_rcs_manf_v2_stat");
    p_dps_rcs.manf_v3_stat = device.svg.getElementById("p_dps_rcs_manf_v3_stat");
    p_dps_rcs.manf_v4_stat = device.svg.getElementById("p_dps_rcs_manf_v4_stat");
    p_dps_rcs.manf_v5_stat = device.svg.getElementById("p_dps_rcs_manf_v5_stat");
    
    p_dps_rcs.ondisplay = func
    {
        device.DPS_menu_title.setText("RCS");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/023/";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_rcs.update = func
    {
	# establish which jet table to show
	var table_index = getprop("/fdm/jsbsim/systems/rcs/jet-table/table-index");



	if (table_index == 1) # forward jets
		{
		p_dps_rcs.sel_f.setText("*");
		p_dps_rcs.sel_l.setText("");
		p_dps_rcs.sel_r.setText("");

		# jet table

		p_dps_rcs.jdesig_y1.setText("F1L");
		p_dps_rcs.jdesig_y2.setText(" 3L");
		p_dps_rcs.jdesig_y3.setText(" 2R");
		p_dps_rcs.jdesig_y4.setText(" 4R");

		p_dps_rcs.jdesig_z1.setText("F1U");
		p_dps_rcs.jdesig_z2.setText(" 3U");
		p_dps_rcs.jdesig_z3.setText(" 2U");
		p_dps_rcs.jdesig_z4.setText("F1D");
		p_dps_rcs.jdesig_z5.setText(" 3D");
		p_dps_rcs.jdesig_z6.setText(" 2D");
		p_dps_rcs.jdesig_z7.setText(" 4D");

		p_dps_rcs.jdesig_x1.setText("F1F");
		p_dps_rcs.jdesig_x2.setText(" 3F");
		p_dps_rcs.jdesig_x3.setText(" 2F");

		p_dps_rcs.jdesig_v1.setText("F5L");
		p_dps_rcs.jdesig_v2.setText(" 5R");

		# failure

		var state = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-F1L-condition");
		if (state < 1.0) {state = 1;} else {state = 0;}
		p_dps_rcs.jfail_y1.setText(jet_status_to_string(state));

		state = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-F3L-condition");
		if (state < 1.0) {state = 1;} else {state = 0;}
		p_dps_rcs.jfail_y2.setText(jet_status_to_string(state));

		state = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-F2R-condition");
		if (state < 1.0) {state = 1;} else {state = 0;}
		p_dps_rcs.jfail_y3.setText(jet_status_to_string(state));

		state = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-F4R-condition");
		if (state < 1.0) {state = 1;} else {state = 0;}
		p_dps_rcs.jfail_y4.setText(jet_status_to_string(state));

		state = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-F1U-condition");
		if (state < 1.0) {state = 1;} else {state = 0;}
		p_dps_rcs.jfail_z1.setText(jet_status_to_string(state));

		state = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-F3U-condition");
		if (state < 1.0) {state = 1;} else {state = 0;}
		p_dps_rcs.jfail_z2.setText(jet_status_to_string(state));

		state = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-F2U-condition");
		if (state < 1.0) {state = 1;} else {state = 0;}
		p_dps_rcs.jfail_z3.setText(jet_status_to_string(state));

		# deselection inhibit

		var symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/F1L-inh") == 1) {symbol = "*";}
		p_dps_rcs.jdesi_y1.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/F3L-inh") == 1) {symbol = "*";}
		p_dps_rcs.jdesi_y2.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/F2R-inh") == 1) {symbol = "*";}
		p_dps_rcs.jdesi_y3.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/F4R-inh") == 1) {symbol = "*";}
		p_dps_rcs.jdesi_y4.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/F1U-inh") == 1) {symbol = "*";}
		p_dps_rcs.jdesi_z1.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/F3U-inh") == 1) {symbol = "*";}
		p_dps_rcs.jdesi_z2.setText(symbol);
	
		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/F2U-inh") == 1) {symbol = "*";}
		p_dps_rcs.jdesi_z3.setText(symbol);

		# deselect

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/F1L-sel") == 0) {symbol = "*";}
		p_dps_rcs.jdes_y1.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/F3L-sel") == 0) {symbol = "*";}
		p_dps_rcs.jdes_y2.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/F2R-sel") == 0) {symbol = "*";}
		p_dps_rcs.jdes_y3.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/F4R-sel") == 0) {symbol = "*";}
		p_dps_rcs.jdes_y4.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/F1U-sel") == 0) {symbol = "*";}
		p_dps_rcs.jdes_z1.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/F3U-sel") == 0) {symbol = "*";}
		p_dps_rcs.jdes_z2.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/F2U-sel") == 0) {symbol = "*";}
		p_dps_rcs.jdes_z3.setText(symbol);

		# priority

   		p_dps_rcs.jpty_y1.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/jet-table/F1L-pty")));
    		p_dps_rcs.jpty_y2.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/jet-table/F3L-pty")));
    		p_dps_rcs.jpty_y3.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/jet-table/F2R-pty")));
    		p_dps_rcs.jpty_y4.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/jet-table/F4R-pty")));

   		p_dps_rcs.jpty_z1.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/jet-table/F1U-pty")));
   		p_dps_rcs.jpty_z2.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/jet-table/F3U-pty")));
   		p_dps_rcs.jpty_z3.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/jet-table/F2U-pty")));


		# propellant flow

		p_dps_rcs.he_p_oxid.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/helium-fwd-rcs-pressure-1-sh-psia"))); 
    		p_dps_rcs.he_p_fu.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/helium-fwd-rcs-pressure-2-sh-psia"))); 

    		p_dps_rcs.tk_p_oxid.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-fwd-rcs-blowdown-psia")));
    		p_dps_rcs.tk_p_fu.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-fwd-rcs-blowdown-psia")));

    		#p_dps_rcs.tk_t_oxid 
   		#p_dps_rcs.tk_t_fu 

    		p_dps_rcs.tk_qty_oxid.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[12]/level-lbs")/14.770)); 
    		p_dps_rcs.tk_qty_fu.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[13]/level-lbs")/9.280));

   		p_dps_rcs.manf_p1_oxid.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold1-oxidizer-pressure-psia")));
    		p_dps_rcs.manf_p1_fu.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold1-fuel-pressure-psia")));

   		p_dps_rcs.manf_p2_oxid.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold2-oxidizer-pressure-psia")));
    		p_dps_rcs.manf_p2_fu.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold2-fuel-pressure-psia"))); 

   		p_dps_rcs.manf_p3_oxid.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold3-oxidizer-pressure-psia")));
    		p_dps_rcs.manf_p3_fu.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold3-fuel-pressure-psia")));

   		p_dps_rcs.manf_p4_oxid.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold4-oxidizer-pressure-psia")));
    		p_dps_rcs.manf_p4_fu.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold4-fuel-pressure-psia"))); 

	    	p_dps_rcs.manf_v1_stat.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-1-status")));
    		p_dps_rcs.manf_v2_stat.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-2-status")));
    		p_dps_rcs.manf_v3_stat.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-3-status")));
    		p_dps_rcs.manf_v4_stat.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-4-status"))); 
    		p_dps_rcs.manf_v5_stat.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-5-status")));


		}
	else if (table_index == 2) # left jets
		{
		p_dps_rcs.sel_f.setText("");
		p_dps_rcs.sel_l.setText("*");
		p_dps_rcs.sel_r.setText("");

		# jet table

		p_dps_rcs.jdesig_y1.setText("L4L");
		p_dps_rcs.jdesig_y2.setText(" 2L");
		p_dps_rcs.jdesig_y3.setText(" 3L");
		p_dps_rcs.jdesig_y4.setText(" 1L");

		p_dps_rcs.jdesig_z1.setText("L4U");
		p_dps_rcs.jdesig_z2.setText(" 2U");
		p_dps_rcs.jdesig_z3.setText(" 1U");
		p_dps_rcs.jdesig_z4.setText("L  ");
		p_dps_rcs.jdesig_z5.setText(" 4D");
		p_dps_rcs.jdesig_z6.setText(" 2D");
		p_dps_rcs.jdesig_z7.setText(" 3D");

		p_dps_rcs.jdesig_x1.setText("L3A");
		p_dps_rcs.jdesig_x2.setText(" 1A");
		p_dps_rcs.jdesig_x3.setText("");

		p_dps_rcs.jdesig_v1.setText("L5L");
		p_dps_rcs.jdesig_v2.setText(" 5D");

		# failure

		var state = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-L4L-condition");
		if (state < 1.0) {state = 1;} else {state = 0;}
		p_dps_rcs.jfail_y1.setText(jet_status_to_string(state));

		state = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-L2L-condition");
		if (state < 1.0) {state = 1;} else {state = 0;}
		p_dps_rcs.jfail_y2.setText(jet_status_to_string(state));

		state = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-L3L-condition");
		if (state < 1.0) {state = 1;} else {state = 0;}
		p_dps_rcs.jfail_y3.setText(jet_status_to_string(state));

		state = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-L1L-condition");
		if (state < 1.0) {state = 1;} else {state = 0;}
		p_dps_rcs.jfail_y4.setText(jet_status_to_string(state));

		state = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-L4U-condition");
		if (state < 1.0) {state = 1;} else {state = 0;}
		p_dps_rcs.jfail_z1.setText(jet_status_to_string(state));

		state = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-L2U-condition");
		if (state < 1.0) {state = 1;} else {state = 0;}
		p_dps_rcs.jfail_z2.setText(jet_status_to_string(state));

		state = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-L1U-condition");
		if (state < 1.0) {state = 1;} else {state = 0;}
		p_dps_rcs.jfail_z3.setText(jet_status_to_string(state));


		# deselection inhibit

		var symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/L4L-inh") == 1) {symbol = "*";}
		p_dps_rcs.jdesi_y1.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/L2L-inh") == 1) {symbol = "*";}
		p_dps_rcs.jdesi_y2.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/L3L-inh") == 1) {symbol = "*";}
		p_dps_rcs.jdesi_y3.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/L1L-inh") == 1) {symbol = "*";}
		p_dps_rcs.jdesi_y4.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/L4U-inh") == 1) {symbol = "*";}
		p_dps_rcs.jdesi_z1.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/L2U-inh") == 1) {symbol = "*";}
		p_dps_rcs.jdesi_z2.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/L1U-inh") == 1) {symbol = "*";}
		p_dps_rcs.jdesi_z3.setText(symbol);

		# deselect

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/L4L-sel") == 0) {symbol = "*";}
		p_dps_rcs.jdes_y1.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/L2L-sel") == 0) {symbol = "*";}
		p_dps_rcs.jdes_y2.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/L3L-sel") == 0) {symbol = "*";}
		p_dps_rcs.jdes_y3.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/L1L-sel") == 0) {symbol = "*";}
		p_dps_rcs.jdes_y4.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/L4U-sel") == 0) {symbol = "*";}
		p_dps_rcs.jdes_z1.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/L2U-sel") == 0) {symbol = "*";}
		p_dps_rcs.jdes_z2.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/L1U-sel") == 0) {symbol = "*";}
		p_dps_rcs.jdes_z3.setText(symbol);

		# priority

   		p_dps_rcs.jpty_y1.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/jet-table/L4L-pty")));
    		p_dps_rcs.jpty_y2.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/jet-table/L2L-pty")));
    		p_dps_rcs.jpty_y3.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/jet-table/L3L-pty")));
    		p_dps_rcs.jpty_y4.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/jet-table/L1L-pty")));

   		p_dps_rcs.jpty_z1.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/jet-table/L4U-pty")));
   		p_dps_rcs.jpty_z2.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/jet-table/L2U-pty")));
   		p_dps_rcs.jpty_z3.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/jet-table/L1U-pty")));

		# propellant flow

		p_dps_rcs.he_p_oxid.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/helium-left-rcs-pressure-1-sh-psia")));
    		p_dps_rcs.he_p_fu.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/helium-left-rcs-pressure-2-sh-psia")));

    		p_dps_rcs.tk_p_oxid.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-left-rcs-blowdown-psia")));
    		p_dps_rcs.tk_p_fu.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-left-rcs-blowdown-psia")));

    		#p_dps_rcs.tk_t_oxid
   		#p_dps_rcs.tk_t_fu

    		p_dps_rcs.tk_qty_oxid.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[8]/level-lbs")/14.770)); 
    		p_dps_rcs.tk_qty_fu.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[9]/level-lbs")/9.280)); 

   		p_dps_rcs.manf_p1_oxid.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold1-oxidizer-pressure-psia")));
    		p_dps_rcs.manf_p1_fu.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold1-fuel-pressure-psia")));

   		p_dps_rcs.manf_p2_oxid.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold2-oxidizer-pressure-psia")));
    		p_dps_rcs.manf_p2_fu.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold2-fuel-pressure-psia"))); 

   		p_dps_rcs.manf_p3_oxid.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold3-oxidizer-pressure-psia")));
    		p_dps_rcs.manf_p3_fu.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold3-fuel-pressure-psia")));

   		p_dps_rcs.manf_p4_oxid.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold4-oxidizer-pressure-psia")));
    		p_dps_rcs.manf_p4_fu.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold4-fuel-pressure-psia"))); 

	    	p_dps_rcs.manf_v1_stat.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-1-status")));
    		p_dps_rcs.manf_v2_stat.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-2-status")));
    		p_dps_rcs.manf_v3_stat.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-3-status")));
    		p_dps_rcs.manf_v4_stat.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-4-status"))); 
    		p_dps_rcs.manf_v5_stat.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-5-status")));

		}
	else # right jets
		{
		p_dps_rcs.sel_f.setText("");
		p_dps_rcs.sel_l.setText("");
		p_dps_rcs.sel_r.setText("*");

		# jet table

		p_dps_rcs.jdesig_y1.setText("R4R");
		p_dps_rcs.jdesig_y2.setText(" 2R");
		p_dps_rcs.jdesig_y3.setText(" 3R");
		p_dps_rcs.jdesig_y4.setText(" 1R");

		p_dps_rcs.jdesig_z1.setText("R4U");
		p_dps_rcs.jdesig_z2.setText(" 2U");
		p_dps_rcs.jdesig_z3.setText(" 1U");
		p_dps_rcs.jdesig_z4.setText("R  ");
		p_dps_rcs.jdesig_z5.setText(" 4D");
		p_dps_rcs.jdesig_z6.setText(" 2D");
		p_dps_rcs.jdesig_z7.setText(" 3D");

		p_dps_rcs.jdesig_x1.setText("R1A");
		p_dps_rcs.jdesig_x2.setText(" 3A");
		p_dps_rcs.jdesig_x3.setText("");

		p_dps_rcs.jdesig_v1.setText("R5R");
		p_dps_rcs.jdesig_v2.setText(" 5D");

		# failure

		var state = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-R4R-condition");
		if (state < 1.0) {state = 1;} else {state = 0;}
		p_dps_rcs.jfail_y1.setText(jet_status_to_string(state));

		state = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-R2R-condition");
		if (state < 1.0) {state = 1;} else {state = 0;}
		p_dps_rcs.jfail_y2.setText(jet_status_to_string(state));

		state = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-R3R-condition");
		if (state < 1.0) {state = 1;} else {state = 0;}
		p_dps_rcs.jfail_y3.setText(jet_status_to_string(state));

		state = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-R1R-condition");
		if (state < 1.0) {state = 1;} else {state = 0;}
		p_dps_rcs.jfail_y4.setText(jet_status_to_string(state));

		state = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-R4U-condition");
		if (state < 1.0) {state = 1;} else {state = 0;}
		p_dps_rcs.jfail_z1.setText(jet_status_to_string(state));

		state = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-R2U-condition");
		if (state < 1.0) {state = 1;} else {state = 0;}
		p_dps_rcs.jfail_z2.setText(jet_status_to_string(state));

		state = getprop("/fdm/jsbsim/systems/failures/rcs/rcs-R1U-condition");
		if (state < 1.0) {state = 1;} else {state = 0;}
		p_dps_rcs.jfail_z3.setText(jet_status_to_string(state));

		# deselection inhibit

		var symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/R4R-inh") == 1) {symbol = "*";}
		p_dps_rcs.jdesi_y1.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/R2R-inh") == 1) {symbol = "*";}
		p_dps_rcs.jdesi_y2.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/R3R-inh") == 1) {symbol = "*";}
		p_dps_rcs.jdesi_y3.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/R1R-inh") == 1) {symbol = "*";}
		p_dps_rcs.jdesi_y4.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/R4U-inh") == 1) {symbol = "*";}
		p_dps_rcs.jdesi_z1.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/R2U-inh") == 1) {symbol = "*";}
		p_dps_rcs.jdesi_z2.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/R1U-inh") == 1) {symbol = "*";}
		p_dps_rcs.jdesi_z3.setText(symbol);

		# deselect

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/R4R-sel") == 0) {symbol = "*";}
		p_dps_rcs.jdes_y1.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/R2R-sel") == 0) {symbol = "*";}
		p_dps_rcs.jdes_y2.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/R3R-sel") == 0) {symbol = "*";}
		p_dps_rcs.jdes_y3.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/R1R-sel") == 0) {symbol = "*";}
		p_dps_rcs.jdes_y4.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/R4U-sel") == 0) {symbol = "*";}
		p_dps_rcs.jdes_z1.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/R2U-sel") == 0) {symbol = "*";}
		p_dps_rcs.jdes_z2.setText(symbol);

		symbol = "";
		if (getprop("/fdm/jsbsim/systems/rcs/jet-table/R1U-sel") == 0) {symbol = "*";}
		p_dps_rcs.jdes_z3.setText(symbol);

		# priority

   		p_dps_rcs.jpty_y1.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/jet-table/R4R-pty")));
    		p_dps_rcs.jpty_y2.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/jet-table/R2R-pty")));
    		p_dps_rcs.jpty_y3.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/jet-table/R3R-pty")));
    		p_dps_rcs.jpty_y4.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/jet-table/R1R-pty")));

   		p_dps_rcs.jpty_z1.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/jet-table/R4U-pty")));
   		p_dps_rcs.jpty_z2.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/jet-table/R2U-pty")));
   		p_dps_rcs.jpty_z3.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/rcs/jet-table/R1U-pty")));

		# propellant flow

		p_dps_rcs.he_p_oxid.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/helium-right-rcs-pressure-1-sh-psia")));
    		p_dps_rcs.he_p_fu.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/helium-right-rcs-pressure-2-sh-psia")));

    		p_dps_rcs.tk_p_oxid.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-right-rcs-blowdown-psia")));
    		p_dps_rcs.tk_p_fu.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-right-rcs-blowdown-psia")));

    		#p_dps_rcs.tk_t_oxid 
   		#p_dps_rcs.tk_t_fu 

    		p_dps_rcs.tk_qty_oxid.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[10]/level-lbs")/14.770)); 
    		p_dps_rcs.tk_qty_fu.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[11]/level-lbs")/9.280));

   		p_dps_rcs.manf_p1_oxid.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold1-oxidizer-pressure-psia")));
    		p_dps_rcs.manf_p1_fu.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold1-fuel-pressure-psia")));

   		p_dps_rcs.manf_p2_oxid.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold2-oxidizer-pressure-psia")));
    		p_dps_rcs.manf_p2_fu.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold2-fuel-pressure-psia"))); 

   		p_dps_rcs.manf_p3_oxid.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold3-oxidizer-pressure-psia")));
    		p_dps_rcs.manf_p3_fu.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold3-fuel-pressure-psia")));

   		p_dps_rcs.manf_p4_oxid.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold4-oxidizer-pressure-psia")));
    		p_dps_rcs.manf_p4_fu.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold4-fuel-pressure-psia"))); 

	    	p_dps_rcs.manf_v1_stat.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-1-status")));
    		p_dps_rcs.manf_v2_stat.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-2-status")));
    		p_dps_rcs.manf_v3_stat.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-3-status")));
    		p_dps_rcs.manf_v4_stat.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-4-status"))); 
    		p_dps_rcs.manf_v5_stat.setText( valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-5-status")));
		
		}    
	

     
    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_rcs;
}
