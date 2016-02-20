#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_meds_oms_mps
# Description: the OMS/MPS MEDS page
#      Author: Gijs de Rooy, Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_meds_oms_mps = func(device)
{
    var p_meds_oms_mps = device.addPage("MEDSOmsMps", "p_meds_oms_mps");

    p_meds_oms_mps.He_Tk_left = device.svg.getElementById("p_meds_oms_mps_He_Tk_left"); 
    p_meds_oms_mps.He_Tk_center = device.svg.getElementById("p_meds_oms_mps_He_Tk_center"); 
    p_meds_oms_mps.He_Tk_right = device.svg.getElementById("p_meds_oms_mps_He_Tk_right"); 

    p_meds_oms_mps.He_Tk_pneu = device.svg.getElementById("p_meds_oms_mps_He_Tk_pneu"); 


    p_meds_oms_mps.He_reg_right = device.svg.getElementById("p_meds_oms_mps_He_reg_right"); 
    p_meds_oms_mps.He_reg_left = device.svg.getElementById("p_meds_oms_mps_He_reg_left"); 
    p_meds_oms_mps.He_reg_center = device.svg.getElementById("p_meds_oms_mps_He_reg_center"); 

    p_meds_oms_mps.He_reg_pneu = device.svg.getElementById("p_meds_oms_mps_He_reg_pneu"); 

    p_meds_oms_mps.Pc_right = device.svg.getElementById("p_meds_oms_mps_Pc_right"); 
    p_meds_oms_mps.Pc_left = device.svg.getElementById("p_meds_oms_mps_Pc_left"); 
    p_meds_oms_mps.Pc_center = device.svg.getElementById("p_meds_oms_mps_Pc_center"); 

    p_meds_oms_mps.LO2 = device.svg.getElementById("p_meds_oms_mps_LO2"); 
    p_meds_oms_mps.LH2 = device.svg.getElementById("p_meds_oms_mps_LH2"); 

    p_meds_oms_mps.N2_Tk_oleft = device.svg.getElementById("p_meds_oms_mps_N2_Tk_oleft"); 
    p_meds_oms_mps.N2_Tk_oright = device.svg.getElementById("p_meds_oms_mps_N2_Tk_oright"); 

    p_meds_oms_mps.He_Tk_oleft = device.svg.getElementById("p_meds_oms_mps.He_Tk_oleft"); 
    p_meds_oms_mps.He_Tk_oright = device.svg.getElementById("p_meds_oms_mps.He_Tk_oright"); 

    p_meds_oms_mps.Pc_oright = device.svg.getElementById("p_meds_oms_mps_Pc_oright"); 
    p_meds_oms_mps.Pc_oleft = device.svg.getElementById("p_meds_oms_mps_Pc_oleft"); 

    p_meds_oms_mps.menu_item = device.svg.getElementById("MI_1"); 
    p_meds_oms_mps.menu_item_frame = device.svg.getElementById("MI_1_frame"); 
    


    p_meds_oms_mps.ondisplay = func
    {
    
        device.set_DPS_off();
        device.MEDS_menu_title.setText("      SUBSYSTEM MENU");
	p_meds_oms_mps.menu_item.setColor(1.0, 1.0, 1.0);
	p_meds_oms_mps.menu_item_frame.setColor(1.0, 1.0, 1.0);
    

    }
    
    p_meds_oms_mps.update = func
    {
    	p_meds_oms_mps.He_Tk_right.setText("0000");
	p_meds_oms_mps.He_Tk_left.setText("0001");
	p_meds_oms_mps.He_Tk_center.setText("0002");
       	p_meds_oms_mps.He_Tk_pneu.setText("0003");
	p_meds_oms_mps.He_reg_right.setText("0004");
	p_meds_oms_mps.He_reg_left.setText("0005");
 	p_meds_oms_mps.He_reg_center.setText("0006");
	p_meds_oms_mps.Pc_right.setText("007");
	p_meds_oms_mps.Pc_left.setText("008");
	p_meds_oms_mps.Pc_center.setText("009");
	p_meds_oms_mps.He_reg_pneu.setText("0010");
	p_meds_oms_mps.LH2.setText("011");
	p_meds_oms_mps.LO2.setText("012");
	p_meds_oms_mps.N2_Tk_oright.setText("0013");
	p_meds_oms_mps.N2_Tk_oleft.setText("0014");
	p_meds_oms_mps.He_Tk_oleft.setText("0015");
	p_meds_oms_mps.He_Tk_oright.setText("0016");
	p_meds_oms_mps.Pc_oright.setText("017");
	p_meds_oms_mps.Pc_oleft.setText("018");
    }

    p_meds_oms_mps.offdisplay = func
    {
    
        p_meds_oms_mps.menu_item.setColor(meds_r, meds_g, meds_b);
	p_meds_oms_mps.menu_item_frame.setColor(meds_r, meds_g, meds_b);
    }
    
    
    
    return p_meds_oms_mps;
}
