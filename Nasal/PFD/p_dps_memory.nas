#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_memory
# Description: the DPS memory utility page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_memory = func(device)
{
    var p_dps_memory = device.addPage("CRTFault", "p_dps_memory");

    p_dps_memory.group = device.svg.getElementById("p_dps_memory");
    p_dps_memory.group.setColor(dps_r, dps_g, dps_b);
    
    p_dps_memory.read_write = device.svg.getElementById("p_dps_memory_read_write");
    p_dps_memory.data = device.svg.getElementById("p_dps_memory_data");
    p_dps_memory.bit_set = device.svg.getElementById("p_dps_memory_bit_set");
    p_dps_memory.code = device.svg.getElementById("p_dps_memory_code");
    p_dps_memory.bit_rst = device.svg.getElementById("p_dps_memory_bit_rst");
    p_dps_memory.eng_units = device.svg.getElementById("p_dps_memory_eng_units");
    p_dps_memory.hex = device.svg.getElementById("p_dps_memory_hex");

    p_dps_memory.add_id_28 = device.svg.getElementById("p_dps_memory_add_id_28");
    p_dps_memory.des_29 = device.svg.getElementById("p_dps_memory_des_29");
    p_dps_memory.actual_29 = device.svg.getElementById("p_dps_memory_actual_29");

    p_dps_memory.add_id_30 = device.svg.getElementById("p_dps_memory_add_id_30");
    p_dps_memory.des_31 = device.svg.getElementById("p_dps_memory_des_31");
    p_dps_memory.actual_31 = device.svg.getElementById("p_dps_memory_actual_31");

    p_dps_memory.add_id_32 = device.svg.getElementById("p_dps_memory_add_id_32");
    p_dps_memory.des_33 = device.svg.getElementById("p_dps_memory_des_33");
    p_dps_memory.actual_33 = device.svg.getElementById("p_dps_memory_actual_33");

    p_dps_memory.add_id_34 = device.svg.getElementById("p_dps_memory_add_id_34");
    p_dps_memory.des_35 = device.svg.getElementById("p_dps_memory_des_35");
    p_dps_memory.actual_35 = device.svg.getElementById("p_dps_memory_actual_35");

    p_dps_memory.add_id_36 = device.svg.getElementById("p_dps_memory_add_id_36");
    p_dps_memory.des_37 = device.svg.getElementById("p_dps_memory_des_37");
    p_dps_memory.actual_37 = device.svg.getElementById("p_dps_memory_actual_37");

    p_dps_memory.add_id_38 = device.svg.getElementById("p_dps_memory_add_id_38");
    p_dps_memory.des_39 = device.svg.getElementById("p_dps_memory_des_39");
    p_dps_memory.actual_39 = device.svg.getElementById("p_dps_memory_actual_39");

    p_dps_memory.downlist_gpc = device.svg.getElementById("p_dps_memory_downlist_gpc");
    p_dps_memory.ops0_ena = device.svg.getElementById("p_dps_memory_ops0_ena");
    p_dps_memory.ops3_up = device.svg.getElementById("p_dps_memory_ops3_up");
    p_dps_memory.start_id = device.svg.getElementById("p_dps_memory_start_id");
    p_dps_memory.no_words = device.svg.getElementById("p_dps_memory_no_words");
    p_dps_memory.wds = device.svg.getElementById("p_dps_memory_wds");



    p_dps_memory.config = device.svg.getElementById("p_dps_memory_config");

    p_dps_memory.gpc1 = device.svg.getElementById("p_dps_memory_gpc1");
    p_dps_memory.gpc2 = device.svg.getElementById("p_dps_memory_gpc2");
    p_dps_memory.gpc3 = device.svg.getElementById("p_dps_memory_gpc3");
    p_dps_memory.gpc4 = device.svg.getElementById("p_dps_memory_gpc4");
    p_dps_memory.gpc5 = device.svg.getElementById("p_dps_memory_gpc5");


    p_dps_memory.string1 = device.svg.getElementById("p_dps_memory_string1");
    p_dps_memory.string2 = device.svg.getElementById("p_dps_memory_string2");
    p_dps_memory.string3 = device.svg.getElementById("p_dps_memory_string3");
    p_dps_memory.string4 = device.svg.getElementById("p_dps_memory_string4");
    
    p_dps_memory.pl12 = device.svg.getElementById("p_dps_memory_pl12");

    p_dps_memory.crt1 = device.svg.getElementById("p_dps_memory_crt1");
    p_dps_memory.crt2 = device.svg.getElementById("p_dps_memory_crt2");
    p_dps_memory.crt3 = device.svg.getElementById("p_dps_memory_crt3");
    p_dps_memory.crt4 = device.svg.getElementById("p_dps_memory_crt4");

    p_dps_memory.launch1 = device.svg.getElementById("p_dps_memory_launch1");
    p_dps_memory.launch2 = device.svg.getElementById("p_dps_memory_launch2");

    p_dps_memory.mm1 = device.svg.getElementById("p_dps_memory_mm1");
    p_dps_memory.mm2 = device.svg.getElementById("p_dps_memory_mm2");

    p_dps_memory.mm_pl = device.svg.getElementById("p_dps_memory_mm_pl");
    p_dps_memory.mm_gnc = device.svg.getElementById("p_dps_memory_mm_gnc");
    p_dps_memory.mm_sm = device.svg.getElementById("p_dps_memory_mm_sm");


    p_dps_memory.store_mc = device.svg.getElementById("p_dps_memory_store_mc");
    p_dps_memory.memory_config = device.svg.getElementById("p_dps_memory_mconfig");
    p_dps_memory.gpc = device.svg.getElementById("p_dps_memory_gpc");


    p_dps_memory.ondisplay = func
    {
        device.DPS_menu_title.setText("GPC MEMORY");
        device.MEDS_menu_title.setText("       DPS MENU");

        var port = device.port_selected;
	var gpc = SpaceShuttle.gpc_array[SpaceShuttle.nbat.crt[port-1]-1];   


	if (gpc.ops == 0)
		{        
		device.DPS_menu_ops.setText("0001/   /");
		}
	else
		{
	        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
        	var ops_string = major_mode~"1/000/";
		device.DPS_menu_ops.setText(ops_string);
		}



	# set options not yet implemented to defaults

    	p_dps_memory.read_write.setText("");
    	p_dps_memory.data.setText("*");
    	p_dps_memory.bit_set.setText("");
    	p_dps_memory.code.setText("");
    	p_dps_memory.bit_rst.setText("");
   	p_dps_memory.eng_units.setText("");
   	p_dps_memory.hex.setText("*");

    	p_dps_memory.add_id_28.setText("");
    	p_dps_memory.des_29.setText("");
    	p_dps_memory.actual_29.setText("");

    	p_dps_memory.add_id_30.setText("");
    	p_dps_memory.des_31.setText("");
    	p_dps_memory.actual_31.setText("");

    	p_dps_memory.add_id_32.setText("");
    	p_dps_memory.des_33.setText("");
    	p_dps_memory.actual_33.setText("");

    	p_dps_memory.add_id_34.setText("");
    	p_dps_memory.des_35.setText("");
    	p_dps_memory.actual_35.setText("");

    	p_dps_memory.add_id_36.setText("");
    	p_dps_memory.des_37.setText("");
    	p_dps_memory.actual_37.setText("");

    	p_dps_memory.add_id_38.setText("");
    	p_dps_memory.des_39.setText("");
    	p_dps_memory.actual_39.setText("");

	p_dps_memory.downlist_gpc.setText("");
    	p_dps_memory.ops0_ena.setText("");
	p_dps_memory.ops3_up.setText("");
	p_dps_memory.start_id.setText("");
	p_dps_memory.no_words.setText("");
	p_dps_memory.wds.setText("");


    	p_dps_memory.string1.setText("");
    	p_dps_memory.string2.setText("");
    	p_dps_memory.string3.setText("");
    	p_dps_memory.string4.setText("");
    
    	p_dps_memory.pl12.setText("");

    	p_dps_memory.crt1.setText("");
    	p_dps_memory.crt2.setText("");
    	p_dps_memory.crt3.setText("");
    	p_dps_memory.crt4.setText("");

    	p_dps_memory.launch1.setText("");
    	p_dps_memory.launch2.setText("");

    	p_dps_memory.mm1.setText("");
    	p_dps_memory.mm2.setText("");

    	p_dps_memory.gpc1.setText("");
    	p_dps_memory.gpc2.setText("");
    	p_dps_memory.gpc3.setText("");
    	p_dps_memory.gpc4.setText("");
    	p_dps_memory.gpc5.setText("");

	p_dps_memory.store_mc.setText("");




    }
    
    p_dps_memory.update = func
    {
    
	# memory config

	var mcc = SpaceShuttle.nbat.edited_mcc;

	p_dps_memory.config.setText(mcc_to_string(mcc));

	
	# look at the different NBAT tables
	if (mcc == 1)
		{

		if (SpaceShuttle.nbat.g1_gpc[0] == mcc) {p_dps_memory.gpc1.setText("1");} 
		else {p_dps_memory.gpc1.setText("0");} 
		if (SpaceShuttle.nbat.g1_gpc[1] == mcc) {p_dps_memory.gpc2.setText("2");}
		else {p_dps_memory.gpc2.setText("0");}
		if (SpaceShuttle.nbat.g1_gpc[2] == mcc) {p_dps_memory.gpc3.setText("3");}
		else {p_dps_memory.gpc3.setText("0");}
		if (SpaceShuttle.nbat.g1_gpc[3] == mcc) {p_dps_memory.gpc4.setText("4");}
		else {p_dps_memory.gpc4.setText("0");}
		if (SpaceShuttle.nbat.g1_gpc[4] == mcc) {p_dps_memory.gpc5.setText("5");}
		else {p_dps_memory.gpc5.setText("0");}

		p_dps_memory.string1.setText(sprintf("%d", SpaceShuttle.nbat.g1_string1));
		p_dps_memory.string2.setText(sprintf("%d", SpaceShuttle.nbat.g1_string2));
		p_dps_memory.string3.setText(sprintf("%d", SpaceShuttle.nbat.g1_string3));
		p_dps_memory.string4.setText(sprintf("%d", SpaceShuttle.nbat.g1_string4));

		p_dps_memory.launch1.setText(sprintf("%d", SpaceShuttle.nbat.g1_launch1));
		p_dps_memory.launch2.setText(sprintf("%d", SpaceShuttle.nbat.g1_launch2));

		p_dps_memory.pl12.setText(sprintf("%d", SpaceShuttle.nbat.g1_pl1));

		p_dps_memory.crt1.setText(sprintf("%d", SpaceShuttle.nbat.g1_crt[0]));
		p_dps_memory.crt2.setText(sprintf("%d", SpaceShuttle.nbat.g1_crt[1]));
		p_dps_memory.crt3.setText(sprintf("%d", SpaceShuttle.nbat.g1_crt[2]));
		p_dps_memory.crt4.setText(sprintf("%d", SpaceShuttle.nbat.g1_crt[3]));

    		p_dps_memory.mm1.setText(sprintf("%d", SpaceShuttle.nbat.g1_mm1));
    		p_dps_memory.mm2.setText(sprintf("%d", SpaceShuttle.nbat.g1_mm2));
		}
	else if (mcc == 2)
		{

		if (SpaceShuttle.nbat.g2_gpc[0] == mcc) {p_dps_memory.gpc1.setText("1");} 
		else {p_dps_memory.gpc1.setText("0");} 
		if (SpaceShuttle.nbat.g2_gpc[1] == mcc) {p_dps_memory.gpc2.setText("2");}
		else {p_dps_memory.gpc2.setText("0");}
		if (SpaceShuttle.nbat.g2_gpc[2] == mcc) {p_dps_memory.gpc3.setText("3");}
		else {p_dps_memory.gpc3.setText("0");}
		if (SpaceShuttle.nbat.g2_gpc[3] == mcc) {p_dps_memory.gpc4.setText("4");}
		else {p_dps_memory.gpc4.setText("0");}
		if (SpaceShuttle.nbat.g2_gpc[4] == mcc) {p_dps_memory.gpc5.setText("5");}
		else {p_dps_memory.gpc5.setText("0");}

		p_dps_memory.string1.setText(sprintf("%d", SpaceShuttle.nbat.g2_string1));
		p_dps_memory.string2.setText(sprintf("%d", SpaceShuttle.nbat.g2_string2));
		p_dps_memory.string3.setText(sprintf("%d", SpaceShuttle.nbat.g2_string3));
		p_dps_memory.string4.setText(sprintf("%d", SpaceShuttle.nbat.g2_string4));

		p_dps_memory.launch1.setText(sprintf("%d", SpaceShuttle.nbat.g2_launch1));
		p_dps_memory.launch2.setText(sprintf("%d", SpaceShuttle.nbat.g2_launch2));

		p_dps_memory.pl12.setText(sprintf("%d", SpaceShuttle.nbat.g2_pl1));

		p_dps_memory.crt1.setText(sprintf("%d", SpaceShuttle.nbat.g2_crt[0]));
		p_dps_memory.crt2.setText(sprintf("%d", SpaceShuttle.nbat.g2_crt[1]));
		p_dps_memory.crt3.setText(sprintf("%d", SpaceShuttle.nbat.g2_crt[2]));
		p_dps_memory.crt4.setText(sprintf("%d", SpaceShuttle.nbat.g2_crt[3]));

    		p_dps_memory.mm1.setText(sprintf("%d", SpaceShuttle.nbat.g2_mm1));
    		p_dps_memory.mm2.setText(sprintf("%d", SpaceShuttle.nbat.g2_mm2));
		}
	else if (mcc == 3)
		{
		if (SpaceShuttle.nbat.g3_gpc[0] == mcc) {p_dps_memory.gpc1.setText("1");} 
		else {p_dps_memory.gpc1.setText("0");} 
		if (SpaceShuttle.nbat.g3_gpc[1] == mcc) {p_dps_memory.gpc2.setText("2");}
		else {p_dps_memory.gpc2.setText("0");}
		if (SpaceShuttle.nbat.g3_gpc[2] == mcc) {p_dps_memory.gpc3.setText("3");}
		else {p_dps_memory.gpc3.setText("0");}
		if (SpaceShuttle.nbat.g3_gpc[3] == mcc) {p_dps_memory.gpc4.setText("4");}
		else {p_dps_memory.gpc4.setText("0");}
		if (SpaceShuttle.nbat.g3_gpc[4] == mcc) {p_dps_memory.gpc5.setText("5");}
		else {p_dps_memory.gpc5.setText("0");}

		p_dps_memory.string1.setText(sprintf("%d", SpaceShuttle.nbat.g3_string1));
		p_dps_memory.string2.setText(sprintf("%d", SpaceShuttle.nbat.g3_string2));
		p_dps_memory.string3.setText(sprintf("%d", SpaceShuttle.nbat.g3_string3));
		p_dps_memory.string4.setText(sprintf("%d", SpaceShuttle.nbat.g3_string4));

		p_dps_memory.launch1.setText(sprintf("%d", SpaceShuttle.nbat.g3_launch1));
		p_dps_memory.launch2.setText(sprintf("%d", SpaceShuttle.nbat.g3_launch2));

		p_dps_memory.pl12.setText(sprintf("%d", SpaceShuttle.nbat.g3_pl1));

		p_dps_memory.crt1.setText(sprintf("%d", SpaceShuttle.nbat.g3_crt[0]));
		p_dps_memory.crt2.setText(sprintf("%d", SpaceShuttle.nbat.g3_crt[1]));
		p_dps_memory.crt3.setText(sprintf("%d", SpaceShuttle.nbat.g3_crt[2]));
		p_dps_memory.crt4.setText(sprintf("%d", SpaceShuttle.nbat.g3_crt[3]));

    		p_dps_memory.mm1.setText(sprintf("%d", SpaceShuttle.nbat.g3_mm1));
    		p_dps_memory.mm2.setText(sprintf("%d", SpaceShuttle.nbat.g3_mm2));
		}
	else if (mcc == 4)
		{
		if (SpaceShuttle.nbat.g4_gpc[0] == mcc) {p_dps_memory.gpc1.setText("1");} 
		else {p_dps_memory.gpc1.setText("0");} 
		if (SpaceShuttle.nbat.g4_gpc[1] == mcc) {p_dps_memory.gpc2.setText("2");}
		else {p_dps_memory.gpc2.setText("0");}
		if (SpaceShuttle.nbat.g4_gpc[2] == mcc) {p_dps_memory.gpc3.setText("3");}
		else {p_dps_memory.gpc3.setText("0");}
		if (SpaceShuttle.nbat.g4_gpc[3] == mcc) {p_dps_memory.gpc4.setText("4");}
		else {p_dps_memory.gpc4.setText("0");}
		if (SpaceShuttle.nbat.g4_gpc[4] == mcc) {p_dps_memory.gpc5.setText("5");}
		else {p_dps_memory.gpc5.setText("0");}

		p_dps_memory.string1.setText(sprintf("%d", SpaceShuttle.nbat.g4_string1));
		p_dps_memory.string2.setText(sprintf("%d", SpaceShuttle.nbat.g4_string2));
		p_dps_memory.string3.setText(sprintf("%d", SpaceShuttle.nbat.g4_string3));
		p_dps_memory.string4.setText(sprintf("%d", SpaceShuttle.nbat.g4_string4));

		p_dps_memory.launch1.setText(sprintf("%d", SpaceShuttle.nbat.g4_launch1));
		p_dps_memory.launch2.setText(sprintf("%d", SpaceShuttle.nbat.g4_launch2));

		p_dps_memory.pl12.setText(sprintf("%d", SpaceShuttle.nbat.g4_pl1));

		p_dps_memory.crt1.setText(sprintf("%d", SpaceShuttle.nbat.g4_crt[0]));
		p_dps_memory.crt2.setText(sprintf("%d", SpaceShuttle.nbat.g4_crt[1]));
		p_dps_memory.crt3.setText(sprintf("%d", SpaceShuttle.nbat.g4_crt[2]));
		p_dps_memory.crt4.setText(sprintf("%d", SpaceShuttle.nbat.g4_crt[3]));

    		p_dps_memory.mm1.setText(sprintf("%d", SpaceShuttle.nbat.g4_mm1));
    		p_dps_memory.mm2.setText(sprintf("%d", SpaceShuttle.nbat.g4_mm2));
		}
	else 
		{
		p_dps_memory.gpc1.setText("");
		p_dps_memory.gpc2.setText(""); 
		p_dps_memory.gpc3.setText(""); 
		p_dps_memory.gpc4.setText(""); 
		p_dps_memory.gpc5.setText("");  
		

		p_dps_memory.string1.setText("");
		p_dps_memory.string2.setText("");
		p_dps_memory.string3.setText("");
		p_dps_memory.string4.setText("");

		p_dps_memory.launch1.setText("");
		p_dps_memory.launch2.setText("");

		p_dps_memory.pl12.setText("");

		p_dps_memory.crt1.setText("");
		p_dps_memory.crt2.setText("");
		p_dps_memory.crt3.setText("");
		p_dps_memory.crt4.setText("");

    		p_dps_memory.mm1.setText("");
    		p_dps_memory.mm2.setText("");
		}

	var direct_edit_gpc = SpaceShuttle.nbat.direct_edit_gpc;

	if ((direct_edit_gpc > 0) and (direct_edit_gpc < 6))
		{

    		p_dps_memory.store_mc.setText(SpaceShuttle.gpc_array[direct_edit_gpc -1].mcc_string);
    		p_dps_memory.memory_config.setText(mcc_to_short_string(SpaceShuttle.nbat.direct_edit_config));
    		p_dps_memory.gpc.setText(sprintf("%d",direct_edit_gpc));
		}
	else
		{
    		p_dps_memory.store_mc.setText("");
    		p_dps_memory.memory_config.setText("");
    		p_dps_memory.gpc.setText("");
		}

    	p_dps_memory.mm_pl.setText(sprintf("%d",SpaceShuttle.nbat.mm_area_pl));
    	p_dps_memory.mm_gnc.setText(sprintf("%d",SpaceShuttle.nbat.mm_area_gnc));
    	p_dps_memory.mm_sm.setText(sprintf("%d",SpaceShuttle.nbat.mm_area_sm));
		

    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_memory;
}
