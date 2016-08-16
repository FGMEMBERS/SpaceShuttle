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

    p_dps_memory.ondisplay = func
    {
        device.DPS_menu_title.setText("GPC MEMORY");
        device.MEDS_menu_title.setText("       DPS MENU");
   
        var ops_string = "0001/000/";
        device.DPS_menu_ops.setText(ops_string);

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




    }
    
    p_dps_memory.update = func
    {
    

    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_memory;
}
