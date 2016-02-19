#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_sm_sys_summ1
# Description: the SM system summary page 1
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_sm_sys_summ1 = func(device)
{
    var p_dps_sm_sys_summ1 = device.addPage("CRTSMSysSumm1", "p_dps_sm_sys_summ1");
        
    p_dps_sm_sys_summ1.group = device.svg.getElementById("p_dps_sm_sys_summ1");
    p_dps_sm_sys_summ1.group.setColor(dps_r, dps_g, dps_b);

    p_dps_sm_sys_summ1.volts_fc1 = device.svg.getElementById("p_dps_sm_sys_summ1_volts_fc1");
    p_dps_sm_sys_summ1.volts_fc2 = device.svg.getElementById("p_dps_sm_sys_summ1_volts_fc2");
    p_dps_sm_sys_summ1.volts_fc3 = device.svg.getElementById("p_dps_sm_sys_summ1_volts_fc3");

    p_dps_sm_sys_summ1.amps_fc1 = device.svg.getElementById("p_dps_sm_sys_summ1_amps_fc1");
    p_dps_sm_sys_summ1.amps_fc2 = device.svg.getElementById("p_dps_sm_sys_summ1_amps_fc2");
    p_dps_sm_sys_summ1.amps_fc3 = device.svg.getElementById("p_dps_sm_sys_summ1_amps_fc3");

    p_dps_sm_sys_summ1.reac_vlv_1 = device.svg.getElementById("p_dps_sm_sys_summ1_reac_vlv_1");
    p_dps_sm_sys_summ1.reac_vlv_2 = device.svg.getElementById("p_dps_sm_sys_summ1_reac_vlv_2");
    p_dps_sm_sys_summ1.reac_vlv_3 = device.svg.getElementById("p_dps_sm_sys_summ1_reac_vlv_3");

    p_dps_sm_sys_summ1.stackT_1 = device.svg.getElementById("p_dps_sm_sys_summ1_stackT_1");
    p_dps_sm_sys_summ1.stackT_2 = device.svg.getElementById("p_dps_sm_sys_summ1_stackT_2");
    p_dps_sm_sys_summ1.stackT_3 = device.svg.getElementById("p_dps_sm_sys_summ1_stackT_3");

    p_dps_sm_sys_summ1.exitT_1 = device.svg.getElementById("p_dps_sm_sys_summ1_exitT_1");
    p_dps_sm_sys_summ1.exitT_2 = device.svg.getElementById("p_dps_sm_sys_summ1_exitT_2");
    p_dps_sm_sys_summ1.exitT_3 = device.svg.getElementById("p_dps_sm_sys_summ1_exitT_3");

    p_dps_sm_sys_summ1.coolp_1 = device.svg.getElementById("p_dps_sm_sys_summ1_coolp_1");
    p_dps_sm_sys_summ1.coolp_2 = device.svg.getElementById("p_dps_sm_sys_summ1_coolp_2");
    p_dps_sm_sys_summ1.coolp_3 = device.svg.getElementById("p_dps_sm_sys_summ1_coolp_3");

    p_dps_sm_sys_summ1.pump1 = device.svg.getElementById("p_dps_sm_sys_summ1_pump1");
    p_dps_sm_sys_summ1.pump2 = device.svg.getElementById("p_dps_sm_sys_summ1_pump2");
    p_dps_sm_sys_summ1.pump3 = device.svg.getElementById("p_dps_sm_sys_summ1_pump3");

    p_dps_sm_sys_summ1.volts_mn1 = device.svg.getElementById("p_dps_sm_sys_summ1_volts_mn1");
    p_dps_sm_sys_summ1.volts_mn2 = device.svg.getElementById("p_dps_sm_sys_summ1_volts_mn2");
    p_dps_sm_sys_summ1.volts_mn3 = device.svg.getElementById("p_dps_sm_sys_summ1_volts_mn3");

    p_dps_sm_sys_summ1.volts_ess1 = device.svg.getElementById("p_dps_sm_sys_summ1_volts_ess1");
    p_dps_sm_sys_summ1.volts_ess2 = device.svg.getElementById("p_dps_sm_sys_summ1_volts_ess2");
    p_dps_sm_sys_summ1.volts_ess3 = device.svg.getElementById("p_dps_sm_sys_summ1_volts_ess3");

    p_dps_sm_sys_summ1.volts_cntl1_1 = device.svg.getElementById("p_dps_sm_sys_summ1_volts_cntl1_1");
    p_dps_sm_sys_summ1.volts_cntl1_2 = device.svg.getElementById("p_dps_sm_sys_summ1_volts_cntl1_2");
    p_dps_sm_sys_summ1.volts_cntl1_3 = device.svg.getElementById("p_dps_sm_sys_summ1_volts_cntl1_3");

    p_dps_sm_sys_summ1.volts_cntl2_1 = device.svg.getElementById("p_dps_sm_sys_summ1_volts_cntl2_1");
    p_dps_sm_sys_summ1.volts_cntl2_2 = device.svg.getElementById("p_dps_sm_sys_summ1_volts_cntl2_2");
    p_dps_sm_sys_summ1.volts_cntl2_3 = device.svg.getElementById("p_dps_sm_sys_summ1_volts_cntl2_3");

    p_dps_sm_sys_summ1.volts_cntl3_1 = device.svg.getElementById("p_dps_sm_sys_summ1_volts_cntl3_1");
    p_dps_sm_sys_summ1.volts_cntl3_2 = device.svg.getElementById("p_dps_sm_sys_summ1_volts_cntl3_2");
    p_dps_sm_sys_summ1.volts_cntl3_3 = device.svg.getElementById("p_dps_sm_sys_summ1_volts_cntl3_3");

    p_dps_sm_sys_summ1.volt_phiA_1 = device.svg.getElementById("p_dps_sm_sys_summ1_volt_phiA_1");
    p_dps_sm_sys_summ1.volt_phiA_2 = device.svg.getElementById("p_dps_sm_sys_summ1_volt_phiA_2");
    p_dps_sm_sys_summ1.volt_phiA_3 = device.svg.getElementById("p_dps_sm_sys_summ1_volt_phiA_3");

    p_dps_sm_sys_summ1.volt_phiB_1 = device.svg.getElementById("p_dps_sm_sys_summ1_volt_phiB_1");
    p_dps_sm_sys_summ1.volt_phiB_2 = device.svg.getElementById("p_dps_sm_sys_summ1_volt_phiB_2");
    p_dps_sm_sys_summ1.volt_phiB_3 = device.svg.getElementById("p_dps_sm_sys_summ1_volt_phiB_3");

    p_dps_sm_sys_summ1.volt_phiC_1 = device.svg.getElementById("p_dps_sm_sys_summ1_volt_phiC_1");
    p_dps_sm_sys_summ1.volt_phiC_2 = device.svg.getElementById("p_dps_sm_sys_summ1_volt_phiC_2");
    p_dps_sm_sys_summ1.volt_phiC_3 = device.svg.getElementById("p_dps_sm_sys_summ1_volt_phiC_3");

    p_dps_sm_sys_summ1.amps_phiA_1 = device.svg.getElementById("p_dps_sm_sys_summ1_amps_phiA_1");
    p_dps_sm_sys_summ1.amps_phiA_2 = device.svg.getElementById("p_dps_sm_sys_summ1_amps_phiA_2");
    p_dps_sm_sys_summ1.amps_phiA_3 = device.svg.getElementById("p_dps_sm_sys_summ1_amps_phiA_3");

    p_dps_sm_sys_summ1.amps_phiB_1 = device.svg.getElementById("p_dps_sm_sys_summ1_amps_phiB_1");
    p_dps_sm_sys_summ1.amps_phiB_2 = device.svg.getElementById("p_dps_sm_sys_summ1_amps_phiB_2");
    p_dps_sm_sys_summ1.amps_phiB_3 = device.svg.getElementById("p_dps_sm_sys_summ1_amps_phiB_3");

    p_dps_sm_sys_summ1.amps_phiC_1 = device.svg.getElementById("p_dps_sm_sys_summ1_amps_phiC_1");
    p_dps_sm_sys_summ1.amps_phiC_2 = device.svg.getElementById("p_dps_sm_sys_summ1_amps_phiC_2");
    p_dps_sm_sys_summ1.amps_phiC_3 = device.svg.getElementById("p_dps_sm_sys_summ1_amps_phiC_3");
    

    p_dps_sm_sys_summ1.DVSS1_1 = device.svg.getElementById("p_dps_sm_sys_summ1_DVSS1_1");
    p_dps_sm_sys_summ1.DVSS1_2 = device.svg.getElementById("p_dps_sm_sys_summ1_DVSS1_2");
    p_dps_sm_sys_summ1.DVSS1_3 = device.svg.getElementById("p_dps_sm_sys_summ1_DVSS1_3");

    p_dps_sm_sys_summ1.DVSS2_1 = device.svg.getElementById("p_dps_sm_sys_summ1_DVSS2_1");
    p_dps_sm_sys_summ1.DVSS2_2 = device.svg.getElementById("p_dps_sm_sys_summ1_DVSS2_2");
    p_dps_sm_sys_summ1.DVSS2_3 = device.svg.getElementById("p_dps_sm_sys_summ1_DVSS2_3");

    p_dps_sm_sys_summ1.DVSS3_1 = device.svg.getElementById("p_dps_sm_sys_summ1_DVSS3_1");
    p_dps_sm_sys_summ1.DVSS3_2 = device.svg.getElementById("p_dps_sm_sys_summ1_DVSS3_2");
    p_dps_sm_sys_summ1.DVSS3_3 = device.svg.getElementById("p_dps_sm_sys_summ1_DVSS3_3");

    p_dps_sm_sys_summ1.cabin = device.svg.getElementById("p_dps_sm_sys_summ1_cabin");

    p_dps_sm_sys_summ1.lr_1 = device.svg.getElementById("p_dps_sm_sys_summ1_lr_1");
    p_dps_sm_sys_summ1.lr_2 = device.svg.getElementById("p_dps_sm_sys_summ1_lr_2");

    p_dps_sm_sys_summ1.avbay1_1 = device.svg.getElementById("p_dps_sm_sys_summ1_avbay1_1");
    p_dps_sm_sys_summ1.avbay1_2 = device.svg.getElementById("p_dps_sm_sys_summ1_avbay1_2");

    p_dps_sm_sys_summ1.avbay2_1 = device.svg.getElementById("p_dps_sm_sys_summ1_avbay2_1");
    p_dps_sm_sys_summ1.avbay2_2 = device.svg.getElementById("p_dps_sm_sys_summ1_avbay2_2");

    p_dps_sm_sys_summ1.avbay3_1 = device.svg.getElementById("p_dps_sm_sys_summ1_avbay3_1");
    p_dps_sm_sys_summ1.avbay3_2 = device.svg.getElementById("p_dps_sm_sys_summ1_avbay3_2");

    p_dps_sm_sys_summ1.press = device.svg.getElementById("p_dps_sm_sys_summ1_press");
    p_dps_sm_sys_summ1.dPdt = device.svg.getElementById("p_dps_sm_sys_summ1_dPdt");
    p_dps_sm_sys_summ1.eq = device.svg.getElementById("p_dps_sm_sys_summ1_eq");

    p_dps_sm_sys_summ1.o2_conc = device.svg.getElementById("p_dps_sm_sys_summ1_o2_conc");
    p_dps_sm_sys_summ1.ppo2_1 = device.svg.getElementById("p_dps_sm_sys_summ1_ppo2_1");
    p_dps_sm_sys_summ1.ppo2_2 = device.svg.getElementById("p_dps_sm_sys_summ1_ppo2_2");

    p_dps_sm_sys_summ1.fan_dp = device.svg.getElementById("p_dps_sm_sys_summ1_fan_dp");
    p_dps_sm_sys_summ1.hx_out_T = device.svg.getElementById("p_dps_sm_sys_summ1_hx_out_T");

    p_dps_sm_sys_summ1.o2flow_1 = device.svg.getElementById("p_dps_sm_sys_summ1_o2flow_1");
    p_dps_sm_sys_summ1.o2flow_2 = device.svg.getElementById("p_dps_sm_sys_summ1_o2flow_2");

    p_dps_sm_sys_summ1.n2flow_1 = device.svg.getElementById("p_dps_sm_sys_summ1_n2flow_1");
    p_dps_sm_sys_summ1.n2flow_2 = device.svg.getElementById("p_dps_sm_sys_summ1_n2flow_2");

    p_dps_sm_sys_summ1.imu_A = device.svg.getElementById("p_dps_sm_sys_summ1_imu_A");
    p_dps_sm_sys_summ1.imu_B = device.svg.getElementById("p_dps_sm_sys_summ1_imu_B");
    p_dps_sm_sys_summ1.imu_C = device.svg.getElementById("p_dps_sm_sys_summ1_imu_C");




    p_dps_sm_sys_summ1.kW = device.svg.getElementById("p_dps_sm_sys_summ1_kW");
    p_dps_sm_sys_summ1.total_amps = device.svg.getElementById("p_dps_sm_sys_summ1_total_amps");



    p_dps_sm_sys_summ1.ondisplay = func
    {
        device.DPS_menu_title.setText("SM SYS SUMM 1");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-sm");
    
        var ops_string = major_mode~"1/   /078";
        device.DPS_menu_ops.setText(ops_string);

	# set defaults for values not yet implemented

   	p_dps_sm_sys_summ1.cabin.setText("0.0");

    	p_dps_sm_sys_summ1.lr_1.setText("0.0");
    	p_dps_sm_sys_summ1.lr_2.setText("0.0");

    	p_dps_sm_sys_summ1.avbay1_1.setText("0.0");
    	p_dps_sm_sys_summ1.avbay1_2.setText("0.0");

    	p_dps_sm_sys_summ1.avbay2_1.setText("0.0");
    	p_dps_sm_sys_summ1.avbay2_2.setText("0.0");

    	p_dps_sm_sys_summ1.avbay3_1.setText("0.0");
    	p_dps_sm_sys_summ1.avbay3_2.setText("0.0");

	p_dps_sm_sys_summ1.press.setText("14.0");
	p_dps_sm_sys_summ1.eq.setText("+.00");
 	p_dps_sm_sys_summ1.dPdt.setText("+.000");

	p_dps_sm_sys_summ1.ppo2_1.setText("3.00");
	p_dps_sm_sys_summ1.ppo2_2.setText("3.00");

	p_dps_sm_sys_summ1.o2_conc.setText("21.4");

	p_dps_sm_sys_summ1.fan_dp.setText("5.0");

 	p_dps_sm_sys_summ1.hx_out_T.setText("46");

 	p_dps_sm_sys_summ1.o2flow_1.setText("0.0"); 	
	p_dps_sm_sys_summ1.o2flow_2.setText("0.0");

 	p_dps_sm_sys_summ1.n2flow_1.setText("0.0"); 	
	p_dps_sm_sys_summ1.n2flow_2.setText("0.0");

	p_dps_sm_sys_summ1.imu_A.setText("");
	p_dps_sm_sys_summ1.imu_B.setText("");
	p_dps_sm_sys_summ1.imu_C.setText("");
    }
    
    p_dps_sm_sys_summ1.update = func
    {
    
	var fc_voltage1 = getprop("/fdm/jsbsim/systems/electrical/fc/voltage");
	var fc_voltage2 = getprop("/fdm/jsbsim/systems/electrical/fc[1]/voltage");
	var fc_voltage3 = getprop("/fdm/jsbsim/systems/electrical/fc[2]/voltage");

	var bus_connector1 = getprop("/fdm/jsbsim/systems/electrical/fc/bus-connector-status");
	var bus_connector2 = getprop("/fdm/jsbsim/systems/electrical/fc[1]/bus-connector-status");
	var bus_connector3 = getprop("/fdm/jsbsim/systems/electrical/fc[2]/bus-connector-status");

	var power_usage1 = getprop("/fdm/jsbsim/systems/electrical/bus/power-demand-kW") * 1000.0;
	var power_usage2 = getprop("/fdm/jsbsim/systems/electrical/bus[1]/power-demand-kW") * 1000.0;
	var power_usage3 = getprop("/fdm/jsbsim/systems/electrical/bus[2]/power-demand-kW") * 1000.0;

	var fc_amps1 = power_usage1/fc_voltage1 * bus_connector1;
	var fc_amps2 = power_usage2/fc_voltage2 * bus_connector2;
	var fc_amps3 = power_usage3/fc_voltage3 * bus_connector3;

	if (fc_voltage1 == 0.0) {fc_amps1 = 0.0;}
	if (fc_voltage2 == 0.0) {fc_amps2 = 0.0;}
	if (fc_voltage3 == 0.0) {fc_amps3 = 0.0;}

    	p_dps_sm_sys_summ1.volts_fc1.setText(sprintf("%2.1f", fc_voltage1 ));
    	p_dps_sm_sys_summ1.volts_fc2.setText(sprintf("%2.1f", fc_voltage2 ));
    	p_dps_sm_sys_summ1.volts_fc3.setText(sprintf("%2.1f", fc_voltage3 ));

    	p_dps_sm_sys_summ1.amps_fc1.setText(sprintf("%3.0f", fc_amps1 ));
    	p_dps_sm_sys_summ1.amps_fc2.setText(sprintf("%3.0f", fc_amps2 ));
    	p_dps_sm_sys_summ1.amps_fc3.setText(sprintf("%3.0f", fc_amps3 ));

	var voltage_mainA = getprop("/fdm/jsbsim/systems/electrical/bus/voltage");
	var voltage_mainB = getprop("/fdm/jsbsim/systems/electrical/bus[1]/voltage");
	var voltage_mainC = getprop("/fdm/jsbsim/systems/electrical/bus[2]/voltage");
	var voltage_essential = getprop("/fdm/jsbsim/systems/electrical/essential-bus/voltage");
       
	p_dps_sm_sys_summ1.volts_mn1.setText(sprintf("%2.1f", voltage_mainA ));
	p_dps_sm_sys_summ1.volts_mn2.setText(sprintf("%2.1f", voltage_mainB ));
	p_dps_sm_sys_summ1.volts_mn3.setText(sprintf("%2.1f", voltage_mainC ));

    	p_dps_sm_sys_summ1.volts_ess1.setText(sprintf("%2.1f", voltage_essential ));
    	p_dps_sm_sys_summ1.volts_ess2.setText(sprintf("%2.1f", voltage_essential ));
    	p_dps_sm_sys_summ1.volts_ess3.setText(sprintf("%2.1f", voltage_essential ));

	p_dps_sm_sys_summ1.volts_cntl1_1.setText(sprintf("%2.1f", voltage_essential * 0.991));
	p_dps_sm_sys_summ1.volts_cntl1_2.setText(sprintf("%2.1f", voltage_essential * 0.991));
	p_dps_sm_sys_summ1.volts_cntl1_3.setText(sprintf("%2.1f", voltage_essential * 0.991));

	p_dps_sm_sys_summ1.volts_cntl2_1.setText(sprintf("%2.1f", voltage_essential * 0.991));
	p_dps_sm_sys_summ1.volts_cntl2_2.setText(sprintf("%2.1f", voltage_essential * 0.991));
	p_dps_sm_sys_summ1.volts_cntl2_3.setText(sprintf("%2.1f", voltage_essential * 0.991));

	p_dps_sm_sys_summ1.volts_cntl3_1.setText(sprintf("%2.1f", voltage_essential * 0.991));
	p_dps_sm_sys_summ1.volts_cntl3_2.setText(sprintf("%2.1f", voltage_essential * 0.991));
	p_dps_sm_sys_summ1.volts_cntl3_3.setText(sprintf("%2.1f", voltage_essential * 0.991));

	var voltage_ac1 = getprop("/fdm/jsbsim/systems/electrical/ac/voltage");
	var voltage_ac2 = getprop("/fdm/jsbsim/systems/electrical/ac[1]/voltage");
	var voltage_ac3 = getprop("/fdm/jsbsim/systems/electrical/ac[2]/voltage");

	var power_ac1 = getprop("/fdm/jsbsim/systems/electrical/ac/power-demand-kW");
	var power_ac2 = getprop("/fdm/jsbsim/systems/electrical/ac[1]/power-demand-kW");
	var power_ac3 = getprop("/fdm/jsbsim/systems/electrical/ac[2]/power-demand-kW");

	var amps_ac1 = power_ac1 * 1000.0 /voltage_ac1;
	var amps_ac2 = power_ac2 * 1000.0 /voltage_ac2;
	var amps_ac3 = power_ac3 * 1000.0 /voltage_ac3;

	if (voltage_ac1 == 0.0) {amps_ac1 = 0.0;}
	if (voltage_ac2 == 0.0) {amps_ac2 = 0.0;}
	if (voltage_ac3 == 0.0) {amps_ac3 = 0.0;}

 	p_dps_sm_sys_summ1.volt_phiA_1.setText(sprintf("%3.0f", voltage_ac1));
 	p_dps_sm_sys_summ1.volt_phiA_2.setText(sprintf("%3.0f", voltage_ac2));
 	p_dps_sm_sys_summ1.volt_phiA_3.setText(sprintf("%3.0f", voltage_ac3));

 	p_dps_sm_sys_summ1.volt_phiB_1.setText(sprintf("%3.0f", voltage_ac1));
 	p_dps_sm_sys_summ1.volt_phiB_2.setText(sprintf("%3.0f", voltage_ac2));
 	p_dps_sm_sys_summ1.volt_phiB_3.setText(sprintf("%3.0f", voltage_ac3));

 	p_dps_sm_sys_summ1.volt_phiC_1.setText(sprintf("%3.0f", voltage_ac1));
 	p_dps_sm_sys_summ1.volt_phiC_2.setText(sprintf("%3.0f", voltage_ac2));
 	p_dps_sm_sys_summ1.volt_phiC_3.setText(sprintf("%3.0f", voltage_ac3));

 	p_dps_sm_sys_summ1.amps_phiA_1.setText(sprintf("%2.1f", amps_ac1/3.));
 	p_dps_sm_sys_summ1.amps_phiA_2.setText(sprintf("%2.1f", amps_ac2/3.));
 	p_dps_sm_sys_summ1.amps_phiA_3.setText(sprintf("%2.1f", amps_ac3/3.));

 	p_dps_sm_sys_summ1.amps_phiB_1.setText(sprintf("%2.1f", amps_ac1/3.));
 	p_dps_sm_sys_summ1.amps_phiB_2.setText(sprintf("%2.1f", amps_ac2/3.));
 	p_dps_sm_sys_summ1.amps_phiB_3.setText(sprintf("%2.1f", amps_ac3/3.));

 	p_dps_sm_sys_summ1.amps_phiC_1.setText(sprintf("%2.1f", amps_ac1/3.));
 	p_dps_sm_sys_summ1.amps_phiC_2.setText(sprintf("%2.1f", amps_ac2/3.));
 	p_dps_sm_sys_summ1.amps_phiC_3.setText(sprintf("%2.1f", amps_ac3/3.));

	var fc1_factor = fc_voltage1 / 30.0;
	var fc2_factor = fc_voltage2 / 30.0;
	var fc3_factor = fc_voltage3 / 30.0;


	p_dps_sm_sys_summ1.DVSS1_1.setText(sprintf("%3.0f", 15 * fc1_factor ));
	p_dps_sm_sys_summ1.DVSS2_1.setText(sprintf("%3.0f", 12 * fc1_factor ));
	p_dps_sm_sys_summ1.DVSS3_1.setText(sprintf("%3.0f", 21 * fc1_factor ));

	p_dps_sm_sys_summ1.DVSS1_2.setText(sprintf("%3.0f", 20 * fc2_factor ));
	p_dps_sm_sys_summ1.DVSS2_2.setText(sprintf("%3.0f", 16 * fc2_factor ));
	p_dps_sm_sys_summ1.DVSS3_2.setText(sprintf("%3.0f", 17 * fc2_factor ));

	p_dps_sm_sys_summ1.DVSS1_3.setText(sprintf("%3.0f", 14 * fc3_factor ));
	p_dps_sm_sys_summ1.DVSS2_3.setText(sprintf("%3.0f", 13 * fc3_factor ));
	p_dps_sm_sys_summ1.DVSS3_3.setText(sprintf("%3.0f", 16 * fc3_factor ));

	var stack_T1 = K_to_F (getprop("/fdm/jsbsim/systems/electrical/fc/stack-temperature-K"));
	var stack_T2 = K_to_F (getprop("/fdm/jsbsim/systems/electrical/fc[1]/stack-temperature-K"));
	var stack_T3 = K_to_F (getprop("/fdm/jsbsim/systems/electrical/fc[2]/stack-temperature-K"));

 	p_dps_sm_sys_summ1.stackT_1.setText(sprintf("%+3.0f", stack_T1 ));
 	p_dps_sm_sys_summ1.stackT_2.setText(sprintf("%+3.0f", stack_T2 ));
 	p_dps_sm_sys_summ1.stackT_3.setText(sprintf("%+3.0f", stack_T3 ));

	var running1 = getprop("/fdm/jsbsim/systems/electrical/fc/fc-running");
	var running2 = getprop("/fdm/jsbsim/systems/electrical/fc[1]/fc-running");
	var running3 = getprop("/fdm/jsbsim/systems/electrical/fc[2]/fc-running");

	var condition1 = getprop("/fdm/jsbsim/systems/failures/fc1-coolant-pump-condition");
	var condition2 = getprop("/fdm/jsbsim/systems/failures/fc2-coolant-pump-condition");
	var condition3 = getprop("/fdm/jsbsim/systems/failures/fc3-coolant-pump-condition");

	p_dps_sm_sys_summ1.coolp_1.setText(sprintf("%2.0f", 61.0 * condition1 * running1 ));
	p_dps_sm_sys_summ1.coolp_2.setText(sprintf("%2.0f", 61.0 * condition2 * running2 ));
	p_dps_sm_sys_summ1.coolp_3.setText(sprintf("%2.0f", 61.0 * condition3 * running3 ));

	var coolant_T = K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/freon-out-temperature-K"));

	if ((running1 == 1) and (coolant_T < (stack_T1 - 60.0))) {exitT1 = 151.0;}
	else {exitT1 = stack_T1;}

	if ((running2 == 1) and (coolant_T < (stack_T2 - 60.0))) {exitT2 = 153.0;}
	else {exitT2 = stack_T2;}

	if ((running3 == 1) and (coolant_T < (stack_T3 - 60.0))) {exitT3 = 150.0;}
	else {exitT3 = stack_T3;}

	p_dps_sm_sys_summ1.exitT_1.setText(sprintf("%3.0f", exitT1 ));
	p_dps_sm_sys_summ1.exitT_2.setText(sprintf("%3.0f", exitT2 ));
	p_dps_sm_sys_summ1.exitT_3.setText(sprintf("%3.0f", exitT3 ));

	p_dps_sm_sys_summ1.reac_vlv_1.setText(valve_status_to_string(getprop("/fdm/jsbsim/systems/electrical/fc/reactant-valve-status")));
	p_dps_sm_sys_summ1.reac_vlv_2.setText(valve_status_to_string(getprop("/fdm/jsbsim/systems/electrical/fc[1]/reactant-valve-status")));
	p_dps_sm_sys_summ1.reac_vlv_3.setText(valve_status_to_string(getprop("/fdm/jsbsim/systems/electrical/fc[2]/reactant-valve-status")));

	var string = "ΔP";
	if ((running1 == 1) and (condition1 > 0.3)) {string= "";}
 	p_dps_sm_sys_summ1.pump1.setText(string);

	string = "ΔP";
	if ((running2 == 1) and (condition2 > 0.3)) {string= "";}
 	p_dps_sm_sys_summ1.pump2.setText(string);

	string = "ΔP";
	if ((running3 == 1) and (condition3 > 0.3)) {string= "";}
 	p_dps_sm_sys_summ1.pump3.setText(string);

	p_dps_sm_sys_summ1.kW.setText(sprintf("%3.1f", getprop("/fdm/jsbsim/systems/electrical/total-power-demand-kW"))); 	
	p_dps_sm_sys_summ1.total_amps.setText(sprintf("%3.0f", fc_amps1 + fc_amps2 + fc_amps3));

        device.update_common_DPS();
    }
    
    
    
    return p_dps_sm_sys_summ1;
}
