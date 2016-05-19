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
    


    p_meds_oms_mps.tape_TkP_left = device.svg.getElementById("p_meds_oms_mps_tape_TkP_left"); 
    p_meds_oms_mps.tape_TkP_right = device.svg.getElementById("p_meds_oms_mps_tape_TkP_right"); 
    p_meds_oms_mps.tape_TkP_center = device.svg.getElementById("p_meds_oms_mps_tape_TkP_center"); 
    p_meds_oms_mps.tape_TkP_pneu = device.svg.getElementById("p_meds_oms_mps_tape_TkP_pneu"); 

    p_meds_oms_mps.tape_regP_left = device.svg.getElementById("p_meds_oms_mps_tape_regP_left"); 
    p_meds_oms_mps.tape_regP_right = device.svg.getElementById("p_meds_oms_mps_tape_regP_right"); 
    p_meds_oms_mps.tape_regP_center = device.svg.getElementById("p_meds_oms_mps_tape_regP_center"); 
    p_meds_oms_mps.tape_regP_pneu = device.svg.getElementById("p_meds_oms_mps_tape_regP_pneu"); 


    p_meds_oms_mps.tape_Pc_left = device.svg.getElementById("p_meds_oms_mps_tape_Pc_left"); 
    p_meds_oms_mps.tape_Pc_right = device.svg.getElementById("p_meds_oms_mps_tape_Pc_right"); 
    p_meds_oms_mps.tape_Pc_center = device.svg.getElementById("p_meds_oms_mps_tape_Pc_center"); 

    p_meds_oms_mps.tape_Pc_oleft = device.svg.getElementById("p_meds_oms_mps_tape_Pc_oleft"); 
    p_meds_oms_mps.tape_Pc_oright = device.svg.getElementById("p_meds_oms_mps_tape_Pc_oright"); 

    p_meds_oms_mps.tape_LH2 = device.svg.getElementById("p_meds_oms_mps_tape_LH2"); 
    p_meds_oms_mps.tape_LO2 = device.svg.getElementById("p_meds_oms_mps_tape_LO2"); 

    p_meds_oms_mps.tape_HeTkP_oleft = device.svg.getElementById("p_meds_oms_mps_tape_HeTkP_oleft"); 
    p_meds_oms_mps.tape_HeTkP_oright = device.svg.getElementById("p_meds_oms_mps_tape_HeTkP_oright"); 

    p_meds_oms_mps.tape_N2TkP_oleft = device.svg.getElementById("p_meds_oms_mps_tape_N2TkP_oleft"); 
    p_meds_oms_mps.tape_N2TkP_oright = device.svg.getElementById("p_meds_oms_mps_tape_N2TkP_oright"); 


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

	var mps_left_He_pressure = getprop("/fdm/jsbsim/systems/mps/helium/pressure-psia");
	var mps_right_He_pressure = getprop("/fdm/jsbsim/systems/mps/helium[1]/pressure-psia");
	var mps_center_He_pressure = getprop("/fdm/jsbsim/systems/mps/helium[2]/pressure-psia");
	var mps_pneu_He_pressure = getprop("/fdm/jsbsim/systems/mps/helium[3]/pressure-psia");

	p_meds_oms_mps.He_Tk_left.setText(sprintf("%4.0f", mps_left_He_pressure));
    	p_meds_oms_mps.He_Tk_right.setText(sprintf("%4.0f", mps_right_He_pressure));
	p_meds_oms_mps.He_Tk_center.setText(sprintf("%4.0f", mps_center_He_pressure));
	p_meds_oms_mps.He_Tk_pneu.setText(sprintf("%4.0f", mps_pneu_He_pressure));

	p_meds_oms_mps.He_Tk_oleft.setText(sprintf("%4.0f", oms_left_He_pressure));
	p_meds_oms_mps.He_Tk_oright.setText(sprintf("%4.0f", oms_right_He_pressure));

	var p_He_left_display = (mps_left_He_pressure - 1000.0)/4000.0;
	var p_He_right_display = (mps_right_He_pressure - 1000.0)/4000.0;
	var p_He_center_display = (mps_center_He_pressure - 1000.0)/4000.0;
	var p_He_pneu_display = (mps_pneu_He_pressure - 3000.0)/2000.0;

	var p_He_oleft_display = oms_left_He_pressure/5000.0;
	var p_He_oright_display = oms_right_He_pressure/5000.0;

	if (p_He_left_display < 0.0) {p_He_left_display = 0.0;}
	if (p_He_right_display < 0.0) {p_He_right_display = 0.0;}
	if (p_He_center_display < 0.0) {p_He_center_display = 0.0;}
	if (p_He_pneu_display < 0.0) {p_He_pneu_display = 0.0;}

	p_meds_oms_mps.tape_TkP_left.setScale(1.0, p_He_left_display);
	p_meds_oms_mps.tape_TkP_left.setTranslation(0.0, (1.0-p_He_left_display) * (49.4 + 175));

	p_meds_oms_mps.tape_TkP_right.setScale(1.0, p_He_right_display);
	p_meds_oms_mps.tape_TkP_right.setTranslation(0.0, (1.0-p_He_right_display) * (49.4 + 175));

	p_meds_oms_mps.tape_TkP_center.setScale(1.0, p_He_center_display);
	p_meds_oms_mps.tape_TkP_center.setTranslation(0.0, (1.0-p_He_center_display) * (49.4 + 175));

	p_meds_oms_mps.tape_TkP_pneu.setScale(1.0, p_He_pneu_display);
	p_meds_oms_mps.tape_TkP_pneu.setTranslation(0.0, (1.0-p_He_pneu_display) * (49.4 + 175));

	p_meds_oms_mps.tape_HeTkP_oleft.setScale(1.0, p_He_oleft_display);
	p_meds_oms_mps.tape_HeTkP_oleft.setTranslation(0.0, (1.0-p_He_oleft_display) * (49.5 + 175.6));

	p_meds_oms_mps.tape_HeTkP_oright.setScale(1.0, p_He_oright_display);
	p_meds_oms_mps.tape_HeTkP_oright.setTranslation(0.0, (1.0-p_He_oright_display) * (49.5 + 175.6));

	if (mps_left_He_pressure < 1150.0)
		{p_meds_oms_mps.tape_TkP_left.setColorFill(1.0, 0.0, 0.0);}
	else {p_meds_oms_mps.tape_TkP_left.setColorFill(0.0, 1.0, 0.0);}

	if (mps_right_He_pressure < 1150.0)
		{p_meds_oms_mps.tape_TkP_right.setColorFill(1.0, 0.0, 0.0);}
	else {p_meds_oms_mps.tape_TkP_right.setColorFill(0.0, 1.0, 0.0);}

	if (mps_center_He_pressure < 1150.0)
		{p_meds_oms_mps.tape_TkP_center.setColorFill(1.0, 0.0, 0.0);}
	else {p_meds_oms_mps.tape_TkP_center.setColorFill(0.0, 1.0, 0.0);}

	if (mps_pneu_He_pressure < 3800.0)
		{p_meds_oms_mps.tape_TkP_pneu.setColorFill(1.0, 0.0, 0.0);}
	else {p_meds_oms_mps.tape_TkP_pneu.setColorFill(0.0, 1.0, 0.0);}


	if (oms_left_He_pressure < 1500.0)
		{p_meds_oms_mps.tape_HeTkP_oleft.setColorFill(1.0, 0.0, 0.0);}
	else {p_meds_oms_mps.tape_HeTkP_oleft.setColorFill(0.0, 1.0, 0.0);}

	if (oms_right_He_pressure < 1500.0)
		{p_meds_oms_mps.tape_HeTkP_oright.setColorFill(1.0, 0.0, 0.0);}
	else {p_meds_oms_mps.tape_HeTkP_oright.setColorFill(0.0, 1.0, 0.0);}


	var reg_left_He_pressure = getprop("/fdm/jsbsim/systems/mps/helium/reg-pressure-psia");
	var reg_right_He_pressure = getprop("/fdm/jsbsim/systems/mps/helium[1]/reg-pressure-psia");
	var reg_center_He_pressure = getprop("/fdm/jsbsim/systems/mps/helium[2]/reg-pressure-psia");
	var reg_pneu_He_pressure = getprop("/fdm/jsbsim/systems/mps/helium[3]/reg-pressure-psia");

	p_meds_oms_mps.He_reg_left.setText(sprintf("%4.0f", reg_left_He_pressure));
    	p_meds_oms_mps.He_reg_right.setText(sprintf("%4.0f", reg_right_He_pressure));
	p_meds_oms_mps.He_reg_center.setText(sprintf("%4.0f", reg_center_He_pressure));
	p_meds_oms_mps.He_reg_pneu.setText(sprintf("%4.0f", reg_pneu_He_pressure));

	var reg_left_He_display = (reg_left_He_pressure - 600.0) / 300.0;
	var reg_right_He_display = (reg_right_He_pressure - 600.0) / 300.0;
	var reg_center_He_display = (reg_center_He_pressure - 600.0) / 300.0;
	var reg_pneu_He_display = (reg_pneu_He_pressure - 600.0) / 300.0;

	if (reg_left_He_display <0.0) {reg_left_He_display = 0.0;}
	if (reg_right_He_display <0.0) {reg_right_He_display = 0.0;}
	if (reg_center_He_display <0.0) {reg_center_He_display = 0.0;}
	if (reg_pneu_He_display <0.0) {reg_pneu_He_display = 0.0;}

	p_meds_oms_mps.tape_regP_left.setScale(1.0, reg_left_He_display);
	p_meds_oms_mps.tape_regP_left.setTranslation(0.0, (1.0-reg_left_He_display) * (49.4 + 270.8));

	p_meds_oms_mps.tape_regP_right.setScale(1.0, reg_right_He_display);
	p_meds_oms_mps.tape_regP_right.setTranslation(0.0, (1.0-reg_right_He_display) * (49.4 + 270.8));

	p_meds_oms_mps.tape_regP_center.setScale(1.0, reg_center_He_display);
	p_meds_oms_mps.tape_regP_center.setTranslation(0.0, (1.0-reg_center_He_display) * (49.4 + 270.8));

	p_meds_oms_mps.tape_regP_pneu.setScale(1.0, reg_pneu_He_display);
	p_meds_oms_mps.tape_regP_pneu.setTranslation(0.0, (1.0-reg_pneu_He_display) * (49.4 + 270.8));

        var oms_Pc_left = getprop("/fdm/jsbsim/fcs/throttle-pos-norm[5]");
        var oms_Pc_right = getprop("/fdm/jsbsim/fcs/throttle-pos-norm[6]");

	oms_Pc_disp_left = oms_Pc_left / 1.2;
	oms_Pc_disp_right = oms_Pc_right  / 1.2;


	p_meds_oms_mps.tape_Pc_oleft.setScale(1.0, oms_Pc_disp_left);
	p_meds_oms_mps.tape_Pc_oleft.setTranslation(0.0, (1.0-oms_Pc_disp_left) * (80.4 + 366));

	if (oms_Pc_left < 0.80)
		{p_meds_oms_mps.tape_Pc_oleft.setColorFill(1.0, 0.0, 0.0);}
	else {p_meds_oms_mps.tape_Pc_oleft.setColorFill(1.0, 1.0, 1.0);}

	p_meds_oms_mps.tape_Pc_oright.setScale(1.0, oms_Pc_disp_right);
	p_meds_oms_mps.tape_Pc_oright.setTranslation(0.0, (1.0-oms_Pc_disp_right) * (80.4 + 366));

	if (oms_Pc_right < 0.80)
		{p_meds_oms_mps.tape_Pc_oright.setColorFill(1.0, 0.0, 0.0);}
	else {p_meds_oms_mps.tape_Pc_oright.setColorFill(1.0, 1.0, 1.0);}

	p_meds_oms_mps.Pc_oleft.setText(sprintf("%3.0f",  oms_Pc_left * 100.0));
	p_meds_oms_mps.Pc_oright.setText(sprintf("%3.0f",  oms_Pc_right * 100.0));







	p_meds_oms_mps.N2_Tk_oleft.setText(sprintf("%4.0f", oms_left_N2_pressure));
	p_meds_oms_mps.N2_Tk_oright.setText(sprintf("%4.0f", oms_right_N2_pressure));

	oms_left_N2_disp = oms_left_N2_pressure/ 3000.0;
	oms_right_N2_disp = oms_right_N2_pressure/ 3000.0;

	p_meds_oms_mps.tape_N2TkP_oleft.setScale(1.0, oms_left_N2_disp);
	p_meds_oms_mps.tape_N2TkP_oleft.setTranslation(0.0, (1.0-oms_left_N2_disp) * (49.5 + 270.8));

	p_meds_oms_mps.tape_N2TkP_oright.setScale(1.0, oms_right_N2_disp);
	p_meds_oms_mps.tape_N2TkP_oright.setTranslation(0.0, (1.0-oms_right_N2_disp) * (49.5 + 270.8));

	if (oms_left_N2_pressure < 1200.0)
		{p_meds_oms_mps.tape_N2TkP_oleft.setColorFill(1.0, 0.0, 0.0);}
	else {p_meds_oms_mps.tape_N2TkP_oleft.setColorFill(0.0, 1.0, 0.0);}

	if (oms_right_N2_pressure < 1200.0)
		{p_meds_oms_mps.tape_N2TkP_oright.setColorFill(1.0, 0.0, 0.0);}
	else {p_meds_oms_mps.tape_N2TkP_oright.setColorFill(0.0, 1.0, 0.0);}

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
		{p_meds_oms_mps.tape_Pc_left.setColorFill(1.0, 0.0, 0.0);}
	else {p_meds_oms_mps.tape_Pc_left.setColorFill(1.0, 1.0, 1.0);}

	if (Pc_right < 0.65)
		{p_meds_oms_mps.tape_Pc_right.setColorFill(1.0, 0.0, 0.0);}
	else {p_meds_oms_mps.tape_Pc_right.setColorFill(1.0, 1.0, 1.0);}

	if (Pc_center < 0.65)
		{p_meds_oms_mps.tape_Pc_center.setColorFill(1.0, 0.0, 0.0);}
	else {p_meds_oms_mps.tape_Pc_center.setColorFill(1.0, 1.0, 1.0);}
	

	Pc_left = Pc_left * 100.0;
	Pc_right = Pc_right * 100.0;
	Pc_center = Pc_center * 100.0;

	p_meds_oms_mps.Pc_right.setText(sprintf("%3.0f", Pc_right));
	p_meds_oms_mps.Pc_left.setText(sprintf("%3.0f", Pc_left));
	p_meds_oms_mps.Pc_center.setText(sprintf("%3.0f", Pc_center));



	var eng_mnf_LO2 = 43.0;
	var eng_mnf_LH2 = 53.0;

	p_meds_oms_mps.LH2.setText(sprintf("%3.0f", eng_mnf_LH2));
	p_meds_oms_mps.LO2.setText(sprintf("%3.0f", eng_mnf_LO2));

	eng_mnf_LO2 = eng_mnf_LO2 / 300;
	eng_mnf_LH2 = eng_mnf_LH2 / 300;

	p_meds_oms_mps.tape_LO2.setScale(1.0, eng_mnf_LO2);
	p_meds_oms_mps.tape_LO2.setTranslation(0.0, (1.0-eng_mnf_LO2) * (49.0 + 384.0));

	p_meds_oms_mps.tape_LH2.setScale(1.0, eng_mnf_LH2);
	p_meds_oms_mps.tape_LH2.setTranslation(0.0, (1.0-eng_mnf_LH2) * (49.0 + 384.0));

    }

    p_meds_oms_mps.offdisplay = func
    {
    
        p_meds_oms_mps.menu_item.setColor(meds_r, meds_g, meds_b);
	p_meds_oms_mps.menu_item_frame.setColor(meds_r, meds_g, meds_b);
    }
    
    
    
    return p_meds_oms_mps;
}
