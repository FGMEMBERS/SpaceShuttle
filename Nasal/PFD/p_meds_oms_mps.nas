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
    
    p_meds_oms_mps.tape_Pc_left = device.svg.getElementById("p_meds_oms_mps_tape_Pc_left"); 
    p_meds_oms_mps.tape_Pc_right = device.svg.getElementById("p_meds_oms_mps_tape_Pc_right"); 
    p_meds_oms_mps.tape_Pc_center = device.svg.getElementById("p_meds_oms_mps_tape_Pc_center"); 

    p_meds_oms_mps.tape_Pc_oleft = device.svg.getElementById("p_meds_oms_mps_tape_Pc_oleft"); 
    p_meds_oms_mps.tape_Pc_oright = device.svg.getElementById("p_meds_oms_mps_tape_Pc_oright"); 


    p_meds_oms_mps.cp1 = device.svg.getElementById("p_meds_oms_mps_cp1"); 

    p_meds_oms_mps.ondisplay = func
    {
    
        device.set_DPS_off();
        device.MEDS_menu_title.setText("      SUBSYSTEM MENU");
	p_meds_oms_mps.menu_item.setColor(1.0, 1.0, 1.0);
	p_meds_oms_mps.menu_item_frame.setColor(1.0, 1.0, 1.0);
    

    }
    
    p_meds_oms_mps.update = func
    {

	var oms_left_N2_pressure = getprop("/fdm/jsbsim/systems/oms-hardware/n2-left-oms-pressure-psia");
	var oms_right_N2_pressure = getprop("/fdm/jsbsim/systems/oms-hardware/n2-left-oms-pressure-psia");

	var oms_left_He_pressure = getprop("/fdm/jsbsim/systems/oms-hardware/helium-left-oms-pressure-psia");
	var oms_right_He_pressure = getprop("/fdm/jsbsim/systems/oms-hardware/helium-right-oms-pressure-psia");

        var oms_Pc_left = getprop("/fdm/jsbsim/fcs/throttle-pos-norm[5]");
        var oms_Pc_right = getprop("/fdm/jsbsim/fcs/throttle-pos-norm[6]");

	oms_Pc_disp_left = oms_Pc_left / 1.2;
	oms_Pc_disp_right = oms_Pc_right  / 1.2;


	p_meds_oms_mps.tape_Pc_oleft.setScale(1.0, oms_Pc_disp_left);
	p_meds_oms_mps.tape_Pc_oleft.setTranslation(0.0, (1.0-oms_Pc_disp_left) * (80.4 + 366));

	if (oms_Pc_left < 0.80)
		{
		p_meds_oms_mps.tape_Pc_oleft.setColor(1.0, 0.0, 0.0);
		p_meds_oms_mps.tape_Pc_oleft.setColorFill(1.0, 0.0, 0.0);
		}
	else
		{
		p_meds_oms_mps.tape_Pc_oleft.setColor(1.0, 1.0, 1.0);
		p_meds_oms_mps.tape_Pc_oleft.setColorFill(1.0, 1.0, 1.0);
		}

	p_meds_oms_mps.tape_Pc_oright.setScale(1.0, oms_Pc_disp_right);
	p_meds_oms_mps.tape_Pc_oright.setTranslation(0.0, (1.0-oms_Pc_disp_right) * (80.4 + 366));

	if (oms_Pc_right < 0.80)
		{
		p_meds_oms_mps.tape_Pc_oright.setColor(1.0, 0.0, 0.0);
		p_meds_oms_mps.tape_Pc_oright.setColorFill(1.0, 0.0, 0.0);
		}
	else
		{
		p_meds_oms_mps.tape_Pc_oright.setColor(1.0, 1.0, 1.0);
		p_meds_oms_mps.tape_Pc_oright.setColorFill(1.0, 1.0, 1.0);
		}

	p_meds_oms_mps.Pc_oleft.setText(sprintf("%3.0f",  oms_Pc_left * 100.0));
	p_meds_oms_mps.Pc_oright.setText(sprintf("%3.0f",  oms_Pc_right * 100.0));

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


	p_meds_oms_mps.N2_Tk_oleft.setText(sprintf("%4.0f", oms_left_N2_pressure));
	p_meds_oms_mps.N2_Tk_oright.setText(sprintf("%4.0f", oms_right_N2_pressure));

	p_meds_oms_mps.He_Tk_oleft.setText(sprintf("%4.0f", oms_left_He_pressure));
	p_meds_oms_mps.He_Tk_oright.setText(sprintf("%4.0f", oms_right_He_pressure));


	var Pc_left = getprop("/fdm/jsbsim/fcs/throttle-pos-norm[0]");
	var Pc_right = getprop("/fdm/jsbsim/fcs/throttle-pos-norm[1]");
	var Pc_center = getprop("/fdm/jsbsim/fcs/throttle-pos-norm[2]");
	
	Pc_disp_left = (Pc_left - 0.45) / (1.09-0.45);
	Pc_disp_right = (Pc_right - 0.45) / (1.09-0.45);
	Pc_disp_center = (Pc_center - 0.45) / (1.09-0.45);

	if (Pc_disp_left < 0.0) {Pc_disp_left = 0.0;}
	if (Pc_disp_right < 0.0) {Pc_disp_right = 0.0;}
	if (Pc_disp_center < 0.0) {Pc_disp_center = 0.0;}
	
	

	p_meds_oms_mps.tape_Pc_left.setScale(1.0, Pc_disp_left);
	p_meds_oms_mps.tape_Pc_left.setTranslation(0.0, (1.0-Pc_disp_left) * (64.2 + 371));

	p_meds_oms_mps.tape_Pc_right.setScale(1.0, Pc_disp_right);
	p_meds_oms_mps.tape_Pc_right.setTranslation(0.0, (1.0-Pc_disp_right) * (64.2 + 371));

	p_meds_oms_mps.tape_Pc_center.setScale(1.0, Pc_disp_center);
	p_meds_oms_mps.tape_Pc_center.setTranslation(0.0, (1.0-Pc_disp_center) * (64.2 + 371));

	if (Pc_left < 0.65)
		{
		p_meds_oms_mps.tape_Pc_left.setColor(1.0, 0.0, 0.0);
		p_meds_oms_mps.tape_Pc_left.setColorFill(1.0, 0.0, 0.0);
		}
	else
		{
		p_meds_oms_mps.tape_Pc_left.setColor(1.0, 1.0, 1.0);
		p_meds_oms_mps.tape_Pc_left.setColorFill(1.0, 1.0, 1.0);
		}

	if (Pc_right < 0.65)
		{	
		p_meds_oms_mps.tape_Pc_right.setColor(1.0, 0.0, 0.0);
		p_meds_oms_mps.tape_Pc_right.setColorFill(1.0, 0.0, 0.0);
		}
	else
		{
		p_meds_oms_mps.tape_Pc_right.setColor(1.0, 1.0, 1.0);
		p_meds_oms_mps.tape_Pc_right.setColorFill(1.0, 1.0, 1.0);
		}

	if (Pc_center < 0.65)
		{
		p_meds_oms_mps.tape_Pc_center.setColor(1.0, 0.0, 0.0);
		p_meds_oms_mps.tape_Pc_center.setColorFill(1.0, 0.0, 0.0);
		}
	else
		{
		p_meds_oms_mps.tape_Pc_center.setColor(1.0, 1.0, 1.0);
		p_meds_oms_mps.tape_Pc_center.setColorFill(1.0, 1.0, 1.0);
		}
	

	Pc_left = Pc_left * 100.0;
	Pc_right = Pc_right * 100.0;
	Pc_center = Pc_center * 100.0;

	p_meds_oms_mps.Pc_right.setText(sprintf("%3.0f", Pc_right));
	p_meds_oms_mps.Pc_left.setText(sprintf("%3.0f", Pc_left));
	p_meds_oms_mps.Pc_center.setText(sprintf("%3.0f", Pc_center));

    }

    p_meds_oms_mps.offdisplay = func
    {
    
        p_meds_oms_mps.menu_item.setColor(meds_r, meds_g, meds_b);
	p_meds_oms_mps.menu_item_frame.setColor(meds_r, meds_g, meds_b);
    }
    
    
    
    return p_meds_oms_mps;
}
