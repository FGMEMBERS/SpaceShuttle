#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_fc
# Description: the systems management Fuel Cells page (DISP 69)
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_fc = func(device)
{
    var p_dps_fc = device.addPage("CRTFC", "p_dps_fc");

    p_dps_fc.volts1 = device.svg.getElementById("p_dps_fc_volts1");
    p_dps_fc.volts2 = device.svg.getElementById("p_dps_fc_volts2");
    p_dps_fc.volts3 = device.svg.getElementById("p_dps_fc_volts3");

    p_dps_fc.amps1 = device.svg.getElementById("p_dps_fc_amps1");
    p_dps_fc.amps2 = device.svg.getElementById("p_dps_fc_amps2");
    p_dps_fc.amps3 = device.svg.getElementById("p_dps_fc_amps3");
    
    p_dps_fc.o2flow1 = device.svg.getElementById("p_dps_fc_o2flow1");
    p_dps_fc.o2flow2 = device.svg.getElementById("p_dps_fc_o2flow2");
    p_dps_fc.o2flow3 = device.svg.getElementById("p_dps_fc_o2flow3");

    p_dps_fc.h2flow1 = device.svg.getElementById("p_dps_fc_h2flow1");
    p_dps_fc.h2flow2 = device.svg.getElementById("p_dps_fc_h2flow2");
    p_dps_fc.h2flow3 = device.svg.getElementById("p_dps_fc_h2flow3");
  
    p_dps_fc.o2reac1 = device.svg.getElementById("p_dps_fc_o2reac1");
    p_dps_fc.o2reac2 = device.svg.getElementById("p_dps_fc_o2reac2");
    p_dps_fc.o2reac3 = device.svg.getElementById("p_dps_fc_o2reac3");

    p_dps_fc.h2reac1 = device.svg.getElementById("p_dps_fc_h2reac1");
    p_dps_fc.h2reac2 = device.svg.getElementById("p_dps_fc_h2reac2");
    p_dps_fc.h2reac3 = device.svg.getElementById("p_dps_fc_h2reac3");

    p_dps_fc.h2coolT1 = device.svg.getElementById("p_dps_fc_coolT1");
    p_dps_fc.h2coolT2 = device.svg.getElementById("p_dps_fc_coolT2");
    p_dps_fc.h2coolT3 = device.svg.getElementById("p_dps_fc_coolT3");

    p_dps_fc.dvss1_1 = device.svg.getElementById("p_dps_fc_dvss1_1");
    p_dps_fc.dvss1_2 = device.svg.getElementById("p_dps_fc_dvss1_2");
    p_dps_fc.dvss1_3 = device.svg.getElementById("p_dps_fc_dvss1_3");

    p_dps_fc.dvss2_1 = device.svg.getElementById("p_dps_fc_dvss2_1");
    p_dps_fc.dvss2_2 = device.svg.getElementById("p_dps_fc_dvss2_2");
    p_dps_fc.dvss2_3 = device.svg.getElementById("p_dps_fc_dvss2_3");

    p_dps_fc.dvss3_1 = device.svg.getElementById("p_dps_fc_dvss3_1");
    p_dps_fc.dvss3_2 = device.svg.getElementById("p_dps_fc_dvss3_2");
    p_dps_fc.dvss3_3 = device.svg.getElementById("p_dps_fc_dvss3_3");

    p_dps_fc.fc_ph1 = device.svg.getElementById("p_dps_fc_ph1");
    p_dps_fc.fc_ph2 = device.svg.getElementById("p_dps_fc_ph2");
    p_dps_fc.fc_ph3 = device.svg.getElementById("p_dps_fc_ph3");

    p_dps_fc.h2o_line_ph = device.svg.getElementById("p_dps_fc_h2o_line_ph");

    p_dps_fc.pri_ln_T1 = device.svg.getElementById("p_dps_fc_pri_ln_T1");
    p_dps_fc.pri_ln_T2 = device.svg.getElementById("p_dps_fc_pri_ln_T2");
    p_dps_fc.pri_ln_T3 = device.svg.getElementById("p_dps_fc_pri_ln_T3");

    p_dps_fc.vlv_T1 = device.svg.getElementById("p_dps_fc_vlv_T1");
    p_dps_fc.vlv_T2 = device.svg.getElementById("p_dps_fc_vlv_T2");
    p_dps_fc.vlv_T3 = device.svg.getElementById("p_dps_fc_vlv_T3");

    p_dps_fc.alt_ln_T1 = device.svg.getElementById("p_dps_fc_alt_ln_T1");
    p_dps_fc.alt_ln_T2 = device.svg.getElementById("p_dps_fc_alt_ln_T2");
    p_dps_fc.alt_ln_T3 = device.svg.getElementById("p_dps_fc_alt_ln_T3");
    

    
    p_dps_fc.ondisplay = func
    {
        device.DPS_menu_title.setText("FUEL CELLS");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/   /069";
        device.DPS_menu_ops.setText(ops_string);

    # set defaults for all functions which aren't implemented yet

	p_dps_fc.fc_ph1.setText("");
	p_dps_fc.fc_ph2.setText("");
	p_dps_fc.fc_ph3.setText("");
	p_dps_fc.h2o_line_ph.setText("");

	p_dps_fc.pri_ln_T1.setText("144");
	p_dps_fc.pri_ln_T2.setText("144");
	p_dps_fc.pri_ln_T3.setText("144");

	p_dps_fc.vlv_T1.setText("93");
	p_dps_fc.vlv_T2.setText("93");
	p_dps_fc.vlv_T3.setText("93");

	p_dps_fc.alt_ln_T1.setText("79");
	p_dps_fc.alt_ln_T2.setText("79");
	p_dps_fc.alt_ln_T3.setText("79");

    }
    
    p_dps_fc.update = func
    {

	var voltage1 = getprop("/fdm/jsbsim/systems/electrical/bus1-voltage");
	var voltage2 = getprop("/fdm/jsbsim/systems/electrical/bus2-voltage");
	var voltage3 = getprop("/fdm/jsbsim/systems/electrical/bus3-voltage");

	var power_usage1 = getprop("/fdm/jsbsim/systems/electrical/bus1-power-demand-kW") * 1000.0;
	var power_usage2 = getprop("/fdm/jsbsim/systems/electrical/bus2-power-demand-kW") * 1000.0;
	var power_usage3 = getprop("/fdm/jsbsim/systems/electrical/bus3-power-demand-kW") * 1000.0;



	var amps1 = power_usage1/voltage1;
	var amps2 = power_usage2/voltage2;
	var amps3 = power_usage3/voltage3;

	if (voltage1 == 0.0) {amps1 = 0.0;}
	if (voltage2 == 0.0) {amps2 = 0.0;}
	if (voltage3 == 0.0) {amps3 = 0.0;}

    	p_dps_fc.volts1.setText(sprintf("%2.1f", voltage1 ));
    	p_dps_fc.volts2.setText(sprintf("%2.1f", voltage2 ));
    	p_dps_fc.volts3.setText(sprintf("%2.1f", voltage3 ));

    	p_dps_fc.amps1.setText(sprintf("%3.0f", amps1 ));
    	p_dps_fc.amps2.setText(sprintf("%3.0f", amps2 ));
    	p_dps_fc.amps3.setText(sprintf("%3.0f", amps3 ));
    	
        var o2flow1 = 0.01677 * amps1;
        var o2flow2 = 0.01677 * amps2;
        var o2flow3 = 0.01677 * amps3;

	var h2flow1 = 0.00310559 * amps1;
	var h2flow2 = 0.00310559 * amps2;
	var h2flow3 = 0.00310559 * amps3;

    	p_dps_fc.o2flow1.setText(sprintf("%2.1f", o2flow1 ));
    	p_dps_fc.o2flow2.setText(sprintf("%2.1f", o2flow2 ));
    	p_dps_fc.o2flow3.setText(sprintf("%2.1f", o2flow3 ));

    	p_dps_fc.h2flow1.setText(sprintf("%1.1f", h2flow1 ));
    	p_dps_fc.h2flow2.setText(sprintf("%1.1f", h2flow2 ));
    	p_dps_fc.h2flow3.setText(sprintf("%1.1f", h2flow3 ));


	p_dps_fc.o2reac1.setText(valve_status_to_string(getprop("/fdm/jsbsim/systems/electrical/fc/reactant-valve-status")));
	p_dps_fc.o2reac2.setText(valve_status_to_string(getprop("/fdm/jsbsim/systems/electrical/fc[1]/reactant-valve-status")));
	p_dps_fc.o2reac3.setText(valve_status_to_string(getprop("/fdm/jsbsim/systems/electrical/fc[2]/reactant-valve-status")));

	p_dps_fc.h2reac1.setText(valve_status_to_string(getprop("/fdm/jsbsim/systems/electrical/fc/reactant-valve-status")));
	p_dps_fc.h2reac2.setText(valve_status_to_string(getprop("/fdm/jsbsim/systems/electrical/fc[1]/reactant-valve-status")));
	p_dps_fc.h2reac3.setText(valve_status_to_string(getprop("/fdm/jsbsim/systems/electrical/fc[2]/reactant-valve-status")));
    
	var coolant_T = K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/freon-out-temperature-K"));

 	p_dps_fc.h2coolT1.setText(sprintf("%3.0f", coolant_T+1.0 ));
 	p_dps_fc.h2coolT2.setText(sprintf("%3.0f", coolant_T ));
 	p_dps_fc.h2coolT3.setText(sprintf("%3.0f", coolant_T+3.0 ));

	var fc1_factor = voltage1 / 30.0;
	var fc2_factor = voltage2 / 30.0;
	var fc3_factor = voltage3 / 30.0;

	p_dps_fc.dvss1_1.setText(sprintf("%3.0f", 15 * fc1_factor ));
	p_dps_fc.dvss2_1.setText(sprintf("%3.0f", 12 * fc1_factor ));
	p_dps_fc.dvss3_1.setText(sprintf("%3.0f", 21 * fc1_factor ));

	p_dps_fc.dvss1_2.setText(sprintf("%3.0f", 20 * fc2_factor ));
	p_dps_fc.dvss2_2.setText(sprintf("%3.0f", 16 * fc2_factor ));
	p_dps_fc.dvss3_2.setText(sprintf("%3.0f", 17 * fc2_factor ));

	p_dps_fc.dvss1_3.setText(sprintf("%3.0f", 14 * fc3_factor ));
	p_dps_fc.dvss2_3.setText(sprintf("%3.0f", 13 * fc3_factor ));
	p_dps_fc.dvss3_3.setText(sprintf("%3.0f", 16 * fc3_factor ));


        device.update_common_DPS();
    }
    
    
    
    return p_dps_fc;
}
