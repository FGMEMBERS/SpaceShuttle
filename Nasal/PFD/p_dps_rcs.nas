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

    p_dps_rcs.jdes_y1 = device.svg.getElementById("p_dps_rcs_jdes_y1");
    p_dps_rcs.jdes_y2 = device.svg.getElementById("p_dps_rcs_jdes_y2");
    p_dps_rcs.jdes_y3 = device.svg.getElementById("p_dps_rcs_jdes_y3");
    p_dps_rcs.jdes_y4 = device.svg.getElementById("p_dps_rcs_jdes_y4");



    p_dps_rcs.jdesig_z1 = device.svg.getElementById("p_dps_rcs_jdesig_z1");
    p_dps_rcs.jdesig_z2 = device.svg.getElementById("p_dps_rcs_jdesig_z2");
    p_dps_rcs.jdesig_z3 = device.svg.getElementById("p_dps_rcs_jdesig_z3");
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

    p_dps_rcs.manf_p5_oxid = device.svg.getElementById("p_dps_rcs_manf_p5_oxid");
    p_dps_rcs.manf_p5_fu = device.svg.getElementById("p_dps_rcs_manf_p5_fu");



    
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

		var symbol = "";
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

   		#p_dps_rcs.manf_p5_oxid
    		#p_dps_rcs.manf_p5_fu

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

		var symbol = "";
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

   		#p_dps_rcs.manf_p5_oxid
    		#p_dps_rcs.manf_p5_fu

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

		var symbol = "";
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

   		#p_dps_rcs.manf_p5_oxid
    		#p_dps_rcs.manf_p5_fu
		
		}    
	

     
    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_rcs;
}
