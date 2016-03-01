#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_meds_oms_mps
# Description: the OMS/MPS MEDS page
#      Author: Gijs de Rooy, Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_meds_apu = func(device)
{
    var p_meds_apu = device.addPage("MEDSApu", "p_meds_apu");

    p_meds_apu.hyd_qty1 = device.svg.getElementById("p_meds_apu_hyd_qty1"); 
    p_meds_apu.hyd_qty2 = device.svg.getElementById("p_meds_apu_hyd_qty2"); 
    p_meds_apu.hyd_qty3 = device.svg.getElementById("p_meds_apu_hyd_qty3"); 

    p_meds_apu.tape_hyd_qty1 = device.svg.getElementById("p_meds_apu_tape_hyd_qty1"); 
    p_meds_apu.tape_hyd_qty2 = device.svg.getElementById("p_meds_apu_tape_hyd_qty2"); 
    p_meds_apu.tape_hyd_qty3 = device.svg.getElementById("p_meds_apu_tape_hyd_qty3"); 

    p_meds_apu.h2o_qty1 = device.svg.getElementById("p_meds_apu_h2o_qty1"); 
    p_meds_apu.h2o_qty2 = device.svg.getElementById("p_meds_apu_h2o_qty2"); 
    p_meds_apu.h2o_qty3 = device.svg.getElementById("p_meds_apu_h2o_qty3");

    p_meds_apu.tape_h2o_qty1 = device.svg.getElementById("p_meds_apu_tape_h2o_qty1"); 
    p_meds_apu.tape_h2o_qty2 = device.svg.getElementById("p_meds_apu_tape_h2o_qty2"); 
    p_meds_apu.tape_h2o_qty3 = device.svg.getElementById("p_meds_apu_tape_h2o_qty3"); 


    p_meds_apu.fuel_qty1 = device.svg.getElementById("p_meds_apu_fuel_qty1"); 
    p_meds_apu.fuel_qty2 = device.svg.getElementById("p_meds_apu_fuel_qty2"); 
    p_meds_apu.fuel_qty3 = device.svg.getElementById("p_meds_apu_fuel_qty3"); 

    p_meds_apu.tape_fuel_qty1 = device.svg.getElementById("p_meds_apu_tape_fuel_qty1"); 
    p_meds_apu.tape_fuel_qty2 = device.svg.getElementById("p_meds_apu_tape_fuel_qty2"); 
    p_meds_apu.tape_fuel_qty3 = device.svg.getElementById("p_meds_apu_tape_fuel_qty3"); 

    p_meds_apu.hyd_p1 = device.svg.getElementById("p_meds_apu_hyd_p1"); 
    p_meds_apu.hyd_p2 = device.svg.getElementById("p_meds_apu_hyd_p2"); 
    p_meds_apu.hyd_p3 = device.svg.getElementById("p_meds_apu_hyd_p3"); 

    p_meds_apu.tape_hyd_p1 = device.svg.getElementById("p_meds_apu_tape_hyd_p1");
    p_meds_apu.tape_hyd_p2 = device.svg.getElementById("p_meds_apu_tape_hyd_p2"); 
    p_meds_apu.tape_hyd_p3 = device.svg.getElementById("p_meds_apu_tape_hyd_p3");  

    p_meds_apu.oilT1 = device.svg.getElementById("p_meds_apu_oilT1"); 
    p_meds_apu.oilT2 = device.svg.getElementById("p_meds_apu_oilT2"); 
    p_meds_apu.oilT3 = device.svg.getElementById("p_meds_apu_oilT3"); 

    p_meds_apu.tape_oilT1 = device.svg.getElementById("p_meds_apu_tape_oilT1"); 
    p_meds_apu.tape_oilT2 = device.svg.getElementById("p_meds_apu_tape_oilT2"); 
    p_meds_apu.tape_oilT3 = device.svg.getElementById("p_meds_apu_tape_oilT3"); 


    p_meds_apu.fuelP1 = device.svg.getElementById("p_meds_apu_fuelP1"); 
    p_meds_apu.fuelP2 = device.svg.getElementById("p_meds_apu_fuelP2"); 
    p_meds_apu.fuelP3 = device.svg.getElementById("p_meds_apu_fuelP3"); 

    p_meds_apu.tape_fuelP1 = device.svg.getElementById("p_meds_apu_tape_fuelP1"); 
    p_meds_apu.tape_fuelP2 = device.svg.getElementById("p_meds_apu_tape_fuelP2"); 
    p_meds_apu.tape_fuelP3 = device.svg.getElementById("p_meds_apu_tape_fuelP3"); 


    p_meds_apu.menu_item = device.svg.getElementById("MI_2"); 
    p_meds_apu.menu_item_frame = device.svg.getElementById("MI_2_frame"); 




    p_meds_apu.ondisplay = func
    {
    
        device.set_DPS_off();
        device.MEDS_menu_title.setText("      SUBSYSTEM MENU");
	p_meds_apu.menu_item.setColor(1.0, 1.0, 1.0);
	p_meds_apu.menu_item_frame.setColor(1.0, 1.0, 1.0);

	# parameters which we do not yet simulate explicitly

	p_meds_apu.hyd_qty1.setText("75");
	p_meds_apu.hyd_qty2.setText("71");
	p_meds_apu.hyd_qty3.setText("73");

	set_tape(p_meds_apu.tape_hyd_qty1, 0.75, 60.7 + 295.8);
	set_tape(p_meds_apu.tape_hyd_qty2, 0.71, 60.7 + 295.8);
	set_tape(p_meds_apu.tape_hyd_qty3, 0.73, 60.7 + 295.8);
    

    }
    
    p_meds_apu.update = func
    {
	
	# water tanks for spray boilers
	
	var h2o_qty1 = getprop("/fdm/jsbsim/propulsion/tank[20]/contents-lbs") / 142.0 ;
	var h2o_qty2 = getprop("/fdm/jsbsim/propulsion/tank[21]/contents-lbs") / 142.0 ;
	var h2o_qty3 = getprop("/fdm/jsbsim/propulsion/tank[22]/contents-lbs") / 142.0 ;

	p_meds_apu.h2o_qty1.setText(sprintf("%3.0f", h2o_qty1 * 100.0));
	p_meds_apu.h2o_qty2.setText(sprintf("%3.0f", h2o_qty2 * 100.0));
	p_meds_apu.h2o_qty3.setText(sprintf("%3.0f", h2o_qty3 * 100.0));

	set_tape(p_meds_apu.tape_h2o_qty1, h2o_qty1, 60.7 + 170.4);
	set_tape(p_meds_apu.tape_h2o_qty2, h2o_qty2, 60.7 + 170.4);
	set_tape(p_meds_apu.tape_h2o_qty3, h2o_qty3, 60.7 + 170.4);

	if (h2o_qty1 < 0.4) 
		{p_meds_apu.tape_h2o_qty1.setColorFill(1.0, 0.0, 0.0);}
	else {p_meds_apu.tape_h2o_qty1.setColorFill(0.0, 1.0, 0.0);}

	if (h2o_qty2 < 0.4) 
		{p_meds_apu.tape_h2o_qty2.setColorFill(1.0, 0.0, 0.0);}
	else {p_meds_apu.tape_h2o_qty2.setColorFill(0.0, 1.0, 0.0);}

	if (h2o_qty3 < 0.4) 
		{p_meds_apu.tape_h2o_qty3.setColorFill(1.0, 0.0, 0.0);}
	else {p_meds_apu.tape_h2o_qty3.setColorFill(0.0, 1.0, 0.0);}

	# APU hydrazine fuel

	var fuel_qty1 = getprop("/fdm/jsbsim/propulsion/tank[14]/contents-lbs") / 350.0 ;
	var fuel_qty2 = getprop("/fdm/jsbsim/propulsion/tank[15]/contents-lbs") / 350.0 ;
	var fuel_qty3 = getprop("/fdm/jsbsim/propulsion/tank[16]/contents-lbs") / 350.0 ;

	p_meds_apu.fuel_qty1.setText(sprintf("%3.0f", fuel_qty1 * 100.0));
	p_meds_apu.fuel_qty2.setText(sprintf("%3.0f", fuel_qty2 * 100.0));
	p_meds_apu.fuel_qty3.setText(sprintf("%3.0f", fuel_qty3 * 100.0));

	set_tape(p_meds_apu.tape_fuel_qty1, fuel_qty1, 63.7+60.7);
	set_tape(p_meds_apu.tape_fuel_qty2, fuel_qty2, 63.7+60.7);
	set_tape(p_meds_apu.tape_fuel_qty3, fuel_qty3, 63.7+60.7);

	if (fuel_qty1 < 0.2) 
		{p_meds_apu.tape_fuel_qty1.setColorFill(1.0, 0.0, 0.0);}
	else {p_meds_apu.tape_fuel_qty1.setColorFill(0.0, 1.0, 0.0);}

	if (fuel_qty2 < 0.2) 
		{p_meds_apu.tape_fuel_qty2.setColorFill(1.0, 0.0, 0.0);}
	else {p_meds_apu.tape_fuel_qty2.setColorFill(0.0, 1.0, 0.0);}

	if (fuel_qty3 < 0.2) 
		{p_meds_apu.tape_fuel_qty3.setColorFill(1.0, 0.0, 0.0);}
	else {p_meds_apu.tape_fuel_qty3.setColorFill(0.0, 1.0, 0.0);}

	# APU hydrazine fuel pressure

	var fuel_p1 = 350.0 * 0.2/ (1.2 -fuel_qty1);
	var fuel_p2 = 350.0 * 0.2/ (1.2 -fuel_qty2);
	var fuel_p3 = 350.0 * 0.2/ (1.2 -fuel_qty3);

	p_meds_apu.fuelP1.setText(sprintf("%4.0f", fuel_p1));
	p_meds_apu.fuelP2.setText(sprintf("%4.0f", fuel_p2));
	p_meds_apu.fuelP3.setText(sprintf("%4.0f", fuel_p3));

	set_tape(p_meds_apu.tape_fuelP1, fuel_p1/500.0, 60.7 + 63.7);
	set_tape(p_meds_apu.tape_fuelP2, fuel_p2/500.0, 60.7 + 63.7);
	set_tape(p_meds_apu.tape_fuelP3, fuel_p3/500.0, 60.7 + 63.7);


	# hydraulic pressure

	var hyd_p1 = getprop("/fdm/jsbsim/systems/apu/apu/hyd-pressure-psia");
	var hyd_p2 = getprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-pressure-psia");
	var hyd_p3 = getprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-pressure-psia");

	p_meds_apu.hyd_p1.setText(sprintf("%4.0f", hyd_p1 ));
	p_meds_apu.hyd_p2.setText(sprintf("%4.0f", hyd_p2 ));
	p_meds_apu.hyd_p3.setText(sprintf("%4.0f", hyd_p3 ));

	set_tape(p_meds_apu.tape_hyd_p1, hyd_p1/4000.0, 60.7 + 295.8);
	set_tape(p_meds_apu.tape_hyd_p2, hyd_p2/4000.0, 60.7 + 295.8);
	set_tape(p_meds_apu.tape_hyd_p3, hyd_p3/4000.0, 60.7 + 295.8);
	
	if ((hyd_p1 < 500.0) or ((hyd_p1 > 1000.0) and (hyd_p1 < 2400.0)))
		{p_meds_apu.tape_hyd_p1.setColorFill(1.0, 0.0, 0.0);}
	else	{p_meds_apu.tape_hyd_p1.setColorFill(0.0, 1.0, 0.0);}

	if ((hyd_p2 < 500.0) or ((hyd_p2 > 1000.0) and (hyd_p2 < 2400.0)))
		{p_meds_apu.tape_hyd_p2.setColorFill(1.0, 0.0, 0.0);}
	else	{p_meds_apu.tape_hyd_p2.setColorFill(0.0, 1.0, 0.0);}

	if ((hyd_p3 < 500.0) or ((hyd_p3 > 1000.0) and (hyd_p3 < 2400.0)))
		{p_meds_apu.tape_hyd_p3.setColorFill(1.0, 0.0, 0.0);}
	else	{p_meds_apu.tape_hyd_p3.setColorFill(0.0, 1.0, 0.0);}

	# APU oil in temperature

	var oil_in_T1 = K_to_F(getprop("/fdm/jsbsim/systems/apu/apu/oil-in-T-K"));
	var oil_in_T2 = K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[1]/oil-in-T-K"));
	var oil_in_T3 = K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[2]/oil-in-T-K"));

	p_meds_apu.oilT1.setText(sprintf("%4.0f", oil_in_T1 ));
	p_meds_apu.oilT2.setText(sprintf("%4.0f", oil_in_T2 ));
	p_meds_apu.oilT3.setText(sprintf("%4.0f", oil_in_T3 ));

	set_tape(p_meds_apu.tape_oilT1, oil_in_T1/500.0, 170.4+60.7);
	set_tape(p_meds_apu.tape_oilT2, oil_in_T2/500.0, 170.4+60.7);
	set_tape(p_meds_apu.tape_oilT3, oil_in_T3/500.0, 170.4+60.7);

	if ((oil_in_T1 < 45.0) or (oil_in_T1 > 290.0))
		{p_meds_apu.tape_oilT1.setColorFill(1.0, 0.0, 0.0);}
	else {p_meds_apu.tape_oilT1.setColorFill(0.0, 1.0, 0.0);}

	if ((oil_in_T2 < 45.0) or (oil_in_T2 > 290.0))
		{p_meds_apu.tape_oilT2.setColorFill(1.0, 0.0, 0.0);}
	else {p_meds_apu.tape_oilT2.setColorFill(0.0, 1.0, 0.0);}

	if ((oil_in_T3 < 45.0) or (oil_in_T3 > 290.0))
		{p_meds_apu.tape_oilT3.setColorFill(1.0, 0.0, 0.0);}
	else {p_meds_apu.tape_oilT3.setColorFill(0.0, 1.0, 0.0);}

    }

    p_meds_apu.offdisplay = func
    {
    
        p_meds_apu.menu_item.setColor(meds_r, meds_g, meds_b);
	p_meds_apu.menu_item_frame.setColor(meds_r, meds_g, meds_b);
    }
    
    
    
    return p_meds_apu;
}
