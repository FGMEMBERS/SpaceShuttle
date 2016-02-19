#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_fc
# Description: the systems management Fuel Cells page (DISP 69)
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_fc = func(device)
{
    var p_dps_fc = device.addPage("CRTFC", "p_dps_fc");

    p_dps_fc.group = device.svg.getElementById("p_dps_fc");
    p_dps_fc.group.setColor(dps_r, dps_g, dps_b);

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

    p_dps_fc.fc_stackT1 = device.svg.getElementById("p_dps_fc_stackT1");
    p_dps_fc.fc_stackT2 = device.svg.getElementById("p_dps_fc_stackT2");
    p_dps_fc.fc_stackT3 = device.svg.getElementById("p_dps_fc_stackT3");

    p_dps_fc.fc_exitT1 = device.svg.getElementById("p_dps_fc_exitT1");
    p_dps_fc.fc_exitT2 = device.svg.getElementById("p_dps_fc_exitT2");
    p_dps_fc.fc_exitT3 = device.svg.getElementById("p_dps_fc_exitT3");

    p_dps_fc.fc_coolp1 = device.svg.getElementById("p_dps_fc_coolp1");
    p_dps_fc.fc_coolp2 = device.svg.getElementById("p_dps_fc_coolp2");
    p_dps_fc.fc_coolp3 = device.svg.getElementById("p_dps_fc_coolp3");

    p_dps_fc.pump1 = device.svg.getElementById("p_dps_fc_pump1");
    p_dps_fc.pump2 = device.svg.getElementById("p_dps_fc_pump2");
    p_dps_fc.pump3 = device.svg.getElementById("p_dps_fc_pump3");

    p_dps_fc.h2pump1 = device.svg.getElementById("p_dps_fc_h2pump1");
    p_dps_fc.h2pump2 = device.svg.getElementById("p_dps_fc_h2pump2");
    p_dps_fc.h2pump3 = device.svg.getElementById("p_dps_fc_h2pump3");

    p_dps_fc.fc_ready1 = device.svg.getElementById("p_dps_fc_ready1");
    p_dps_fc.fc_ready2 = device.svg.getElementById("p_dps_fc_ready2");
    p_dps_fc.fc_ready3 = device.svg.getElementById("p_dps_fc_ready3");

    p_dps_fc.purge_ln_o2_T = device.svg.getElementById("p_dps_fc_purge_ln_o2_T");
    p_dps_fc.purge_ln_h2_T1 = device.svg.getElementById("p_dps_fc_purge_ln_h2_T1");
    p_dps_fc.purge_ln_h2_T2 = device.svg.getElementById("p_dps_fc_purge_ln_h2_T2");

    p_dps_fc.noz_T_A = device.svg.getElementById("p_dps_fc_noz_T_A");
    p_dps_fc.noz_T_B = device.svg.getElementById("p_dps_fc_noz_T_B");

    p_dps_fc.h2o_rlf_line_T = device.svg.getElementById("p_dps_fc_h2o_rlf_line_T");

    p_dps_fc.htr_sw = device.svg.getElementById("p_dps_fc_htr_sw");

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
    
    p_dps_fc.damps1 = device.svg.getElementById("p_dps_fc_damps1");
    p_dps_fc.damps2 = device.svg.getElementById("p_dps_fc_damps2");
    p_dps_fc.damps3 = device.svg.getElementById("p_dps_fc_damps3");

    
    p_dps_fc.ondisplay = func
    {
        device.DPS_menu_title.setText("FUEL CELLS");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-sm");
    
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

	var voltage1 = getprop("/fdm/jsbsim/systems/electrical/fc/voltage");
	var voltage2 = getprop("/fdm/jsbsim/systems/electrical/fc[1]/voltage");
	var voltage3 = getprop("/fdm/jsbsim/systems/electrical/fc[2]/voltage");

	var bus_connector1 = getprop("/fdm/jsbsim/systems/electrical/fc/bus-connector-status");
	var bus_connector2 = getprop("/fdm/jsbsim/systems/electrical/fc[1]/bus-connector-status");
	var bus_connector3 = getprop("/fdm/jsbsim/systems/electrical/fc[2]/bus-connector-status");

	var power_usage1 = getprop("/fdm/jsbsim/systems/electrical/bus/power-demand-kW") * 1000.0;
	var power_usage2 = getprop("/fdm/jsbsim/systems/electrical/bus[1]/power-demand-kW") * 1000.0;
	var power_usage3 = getprop("/fdm/jsbsim/systems/electrical/bus[2]/power-demand-kW") * 1000.0;



	var amps1 = power_usage1/voltage1 * bus_connector1;
	var amps2 = power_usage2/voltage2 * bus_connector2;
	var amps3 = power_usage3/voltage3 * bus_connector3;

	if (voltage1 == 0.0) {amps1 = 0.0;}
	if (voltage2 == 0.0) {amps2 = 0.0;}
	if (voltage3 == 0.0) {amps3 = 0.0;}

    	p_dps_fc.volts1.setText(sprintf("%2.1f", voltage1 ));
    	p_dps_fc.volts2.setText(sprintf("%2.1f", voltage2 ));
    	p_dps_fc.volts3.setText(sprintf("%2.1f", voltage3 ));

    	p_dps_fc.amps1.setText(sprintf("%3.0f", amps1 ));
    	p_dps_fc.amps2.setText(sprintf("%3.0f", amps2 ));
    	p_dps_fc.amps3.setText(sprintf("%3.0f", amps3 ));

	var throughput = getprop("/fdm/jsbsim/systems/electrical/purge-line-throughput");

	var purge1 = 1.0 + 0.7 * getprop("/fdm/jsbsim/systems/electrical/fc/purge-valve-status")* throughput;
	var purge2 = 1.0 + 0.7 * getprop("/fdm/jsbsim/systems/electrical/fc[1]/purge-valve-status")* throughput;
	var purge3 = 1.0 + 0.7 * getprop("/fdm/jsbsim/systems/electrical/fc[2]/purge-valve-status")* throughput;

    	
        var o2flow1 = 0.01677 * amps1 * purge1 ;
        var o2flow2 = 0.01677 * amps2 * purge2 ;
        var o2flow3 = 0.01677 * amps3 * purge3 ;

	var h2flow1 = 0.00310559 * amps1 * purge1 ;
	var h2flow2 = 0.00310559 * amps2 * purge2 ;
	var h2flow3 = 0.00310559 * amps3 * purge3 ;

	var h2oflow1 = 0.002469 * amps1;
	var h2oflow2 = 0.002469 * amps2;
	var h2oflow3 = 0.002469 * amps3;

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

	p_dps_fc.damps1.setText(sprintf("%3.0f", -3 * fc1_factor ));
	p_dps_fc.damps2.setText(sprintf("%3.0f", 2 * fc2_factor ));
	p_dps_fc.damps3.setText(sprintf("%3.0f", 1 * fc3_factor ));

	var stack_T1 = K_to_F (getprop("/fdm/jsbsim/systems/electrical/fc/stack-temperature-K"));
	var stack_T2 = K_to_F (getprop("/fdm/jsbsim/systems/electrical/fc[1]/stack-temperature-K"));
	var stack_T3 = K_to_F (getprop("/fdm/jsbsim/systems/electrical/fc[2]/stack-temperature-K"));

    	p_dps_fc.fc_stackT1.setText(sprintf("%3.0f", stack_T1 ));
    	p_dps_fc.fc_stackT2.setText(sprintf("%3.0f", stack_T2 ));
    	p_dps_fc.fc_stackT3.setText(sprintf("%3.0f", stack_T3 ));

	var running1 = getprop("/fdm/jsbsim/systems/electrical/fc/fc-running");
	var running2 = getprop("/fdm/jsbsim/systems/electrical/fc[1]/fc-running");
	var running3 = getprop("/fdm/jsbsim/systems/electrical/fc[2]/fc-running");

	var condition1 = getprop("/fdm/jsbsim/systems/failures/fc1-coolant-pump-condition");
	var condition2 = getprop("/fdm/jsbsim/systems/failures/fc2-coolant-pump-condition");
	var condition3 = getprop("/fdm/jsbsim/systems/failures/fc3-coolant-pump-condition");

	p_dps_fc.fc_coolp1.setText(sprintf("%2.0f", 61.0 * condition1 * running1 ));
	p_dps_fc.fc_coolp2.setText(sprintf("%2.0f", 61.0 * condition2 * running2 ));
	p_dps_fc.fc_coolp3.setText(sprintf("%2.0f", 61.0 * condition3 * running3 ));

	if ((running1 == 1) and (coolant_T < (stack_T1 - 60.0))) {exitT1 = 151.0;}
	else {exitT1 = stack_T1;}

	if ((running2 == 1) and (coolant_T < (stack_T2 - 60.0))) {exitT2 = 153.0;}
	else {exitT2 = stack_T2;}

	if ((running3 == 1) and (coolant_T < (stack_T3 - 60.0))) {exitT3 = 150.0;}
	else {exitT3 = stack_T3;}

	p_dps_fc.fc_exitT1.setText(sprintf("%3.0f", exitT1 ));
	p_dps_fc.fc_exitT2.setText(sprintf("%3.0f", exitT2 ));
	p_dps_fc.fc_exitT3.setText(sprintf("%3.0f", exitT3 ));

	var string = "ΔP";
	if ((running1 == 1) and (condition1 > 0.3)) {string= "";}
 	p_dps_fc.pump1.setText(string);

	string = "ΔP";
	if ((running2 == 1) and (condition2 > 0.3)) {string= "";}
 	p_dps_fc.pump2.setText(string);

	string = "ΔP";
	if ((running3 == 1) and (condition3 > 0.3)) {string= "";}
 	p_dps_fc.pump3.setText(string);

	string = "OFF";
	if (running1 == 1) {string = "RDY";}
    	p_dps_fc.fc_ready1.setText(string);

	string = "OFF";
	if (running2 == 1) {string = "RDY";}
    	p_dps_fc.fc_ready2.setText(string);

	string = "OFF";
	if (running3 == 1) {string = "RDY";}
    	p_dps_fc.fc_ready3.setText(string);
	
	string = "OFF";
	if (getprop("/fdm/jsbsim/systems/electrical/h2o-relief-heater-switch") == 1) {string = "A";}
	p_dps_fc.htr_sw.setText(string);

	p_dps_fc.h2pump1.setText(sprintf("%1.1f", h2oflow1 ));
	p_dps_fc.h2pump2.setText(sprintf("%1.1f", h2oflow2 ));
	p_dps_fc.h2pump3.setText(sprintf("%1.1f", h2oflow3 ));

	var purge_T = K_to_F(getprop("/fdm/jsbsim/systems/electrical/purge-line-T"));
	var purge_o2_T = purge_T - 10.0;
	var purge_h2_T1 = purge_T;
	var purge_h2_T2 = purge_T - 39.0;

	var PB_T = K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/payload-bay-temperature-K"));

	if (purge_o2_T < PB_T) {purge_o2_T = PB_T;}
	if (purge_h2_T2 < PB_T) {purge_h2_T2 = PB_T;}

    	p_dps_fc.purge_ln_o2_T.setText(sprintf("%3.0f", purge_o2_T ));
    	p_dps_fc.purge_ln_h2_T1.setText(sprintf("%3.0f", purge_h2_T1 ));
    	p_dps_fc.purge_ln_h2_T2.setText(sprintf("%3.0f", purge_h2_T2 ));

	var h2o_nozzle_T = K_to_F(getprop("/fdm/jsbsim/systems/electrical/h2o-relief-T"));
	var h2o_line_T = K_to_F(getprop("/fdm/jsbsim/systems/electrical/h2o-line-T"));

    	p_dps_fc.noz_T_A.setText(sprintf("%3.0f", h2o_nozzle_T + 1.0 ));
    	p_dps_fc.noz_T_B.setText(sprintf("%3.0f", h2o_nozzle_T  ));

    	p_dps_fc.h2o_rlf_line_T.setText(sprintf("%3.0f", h2o_line_T + 1.0 ));

        device.update_common_DPS();
    }
    
    
    
    return p_dps_fc;
}
