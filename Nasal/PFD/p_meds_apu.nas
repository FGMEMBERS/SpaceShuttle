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

    p_meds_apu.h2o_qty1 = device.svg.getElementById("p_meds_apu_h2o_qty1"); 
    p_meds_apu.h2o_qty2 = device.svg.getElementById("p_meds_apu_h2o_qty2"); 
    p_meds_apu.h2o_qty3 = device.svg.getElementById("p_meds_apu_h2o_qty3"); 

    p_meds_apu.fuel_qty1 = device.svg.getElementById("p_meds_apu_fuel_qty1"); 
    p_meds_apu.fuel_qty2 = device.svg.getElementById("p_meds_apu_fuel_qty2"); 
    p_meds_apu.fuel_qty3 = device.svg.getElementById("p_meds_apu_fuel_qty3"); 

    p_meds_apu.hyd_p1 = device.svg.getElementById("p_dps_apu_hyd_p1"); 
    p_meds_apu.hyd_p2 = device.svg.getElementById("p_dps_apu_hyd_p2"); 
    p_meds_apu.hyd_p3 = device.svg.getElementById("p_dps_apu_hyd_p3"); 

    p_meds_apu.oilT1 = device.svg.getElementById("p_meds_apu_oilT1"); 
    p_meds_apu.oilT2 = device.svg.getElementById("p_meds_apu_oilT2"); 
    p_meds_apu.oilT3 = device.svg.getElementById("p_meds_apu_oilT3"); 

    p_meds_apu.fuelP1 = device.svg.getElementById("p_meds_apu_fuelP1"); 
    p_meds_apu.fuelP2 = device.svg.getElementById("p_meds_apu_fuelP2"); 
    p_meds_apu.fuelP3 = device.svg.getElementById("p_meds_apu_fuelP3"); 



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

	# APU hydrazine fuel

	var fuel_qty1 = getprop("/fdm/jsbsim/propulsion/tank[14]/contents-lbs") / 350.0 ;
	var fuel_qty2 = getprop("/fdm/jsbsim/propulsion/tank[15]/contents-lbs") / 350.0 ;
	var fuel_qty3 = getprop("/fdm/jsbsim/propulsion/tank[16]/contents-lbs") / 350.0 ;

	p_meds_apu.fuel_qty1.setText(sprintf("%3.0f", fuel_qty1 * 100.0));
	p_meds_apu.fuel_qty2.setText(sprintf("%3.0f", fuel_qty2 * 100.0));
	p_meds_apu.fuel_qty3.setText(sprintf("%3.0f", fuel_qty3 * 100.0));


	# hydraulic pressure

	var hyd_p1 = getprop("/fdm/jsbsim/systems/apu/apu/hyd-pressure-psia");
	var hyd_p2 = getprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-pressure-psia");
	var hyd_p3 = getprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-pressure-psia");

	p_meds_apu.hyd_p1.setText(sprintf("%4.0f", hyd_p1 ));
	p_meds_apu.hyd_p2.setText(sprintf("%4.0f", hyd_p2 ));
	p_meds_apu.hyd_p3.setText(sprintf("%4.0f", hyd_p3 ));

	
	# APU oil in temperature

	var oil_in_T1 = K_to_F(getprop("/fdm/jsbsim/systems/apu/apu/oil-in-T-K"));
	var oil_in_T2 = K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[1]/oil-in-T-K"));
	var oil_in_T3 = K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[2]/oil-in-T-K"));

	p_meds_apu.oilT1.setText(sprintf("%4.0f", oil_in_T1 ));
	p_meds_apu.oilT2.setText(sprintf("%4.0f", oil_in_T2 ));
	p_meds_apu.oilT3.setText(sprintf("%4.0f", oil_in_T3 ));

    }

    p_meds_apu.offdisplay = func
    {
    
        p_meds_apu.menu_item.setColor(meds_r, meds_g, meds_b);
	p_meds_apu.menu_item_frame.setColor(meds_r, meds_g, meds_b);
    }
    
    
    
    return p_meds_apu;
}
