#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_env
# Description: the SM environemnt CRT page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_dps_env = func(device)
{
    var p_dps_env = device.addPage("CRTEnv", "p_dps_env");

    p_dps_env.group = device.svg.getElementById("p_dps_env");
    p_dps_env.group.setColor(dps_r, dps_g, dps_b);
    

    p_dps_env.avbay_temp1 = device.svg.getElementById("p_dps_env_avbay_temp1");
    p_dps_env.avbay_temp2 = device.svg.getElementById("p_dps_env_avbay_temp2");
    p_dps_env.avbay_temp3 = device.svg.getElementById("p_dps_env_avbay_temp3");    

    p_dps_env.avbay_fan_dp1 = device.svg.getElementById("p_dps_env_avbay_fan_dp1");
    p_dps_env.avbay_fan_dp2 = device.svg.getElementById("p_dps_env_avbay_fan_dp2");
    p_dps_env.avbay_fan_dp3 = device.svg.getElementById("p_dps_env_avbay_fan_dp3");

    p_dps_env.imu_fan_A = device.svg.getElementById("p_dps_env_imu_fan_A");
    p_dps_env.imu_fan_B = device.svg.getElementById("p_dps_env_imu_fan_B");
    p_dps_env.imu_fan_C = device.svg.getElementById("p_dps_env_imu_fan_C");

    p_dps_env.o2_flow1 = device.svg.getElementById("p_dps_env_o2_flow1");
    p_dps_env.o2_flow2 = device.svg.getElementById("p_dps_env_o2_flow2");

    p_dps_env.o2_regp1 = device.svg.getElementById("p_dps_env_o2_regp1");
    p_dps_env.o2_regp2 = device.svg.getElementById("p_dps_env_o2_regp2");

    p_dps_env.n2_flow1 = device.svg.getElementById("p_dps_env_n2_flow1");
    p_dps_env.n2_flow2 = device.svg.getElementById("p_dps_env_n2_flow2");

    p_dps_env.n2_regp1 = device.svg.getElementById("p_dps_env_n2_reg_p1");
    p_dps_env.n2_regp2 = device.svg.getElementById("p_dps_env_n2_reg_p2");

    p_dps_env.ppo2a = device.svg.getElementById("p_dps_env_ppo2a");
    p_dps_env.ppo2b = device.svg.getElementById("p_dps_env_ppo2b");
    p_dps_env.ppo2c = device.svg.getElementById("p_dps_env_ppo2c");

    p_dps_env.cabin_press = device.svg.getElementById("p_dps_env_cabin_press");


    p_dps_env.ondisplay = func
    {
        device.DPS_menu_title.setText("ENVIRONMENT");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-sm");
    
        var ops_string = major_mode~"1/   /066";
        device.DPS_menu_ops.setText(ops_string);

	# defaults for items that aren't yet implemented

    	p_dps_env.imu_fan_A.setText("");
    	p_dps_env.imu_fan_B.setText("*");
    	p_dps_env.imu_fan_C.setText("");


    }
    
    p_dps_env.update = func
    {
    
       	p_dps_env.avbay_temp1.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/avionics-temperature-K")-2.0))); 
    	p_dps_env.avbay_temp2.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/avionics-temperature-K")))); 
    	p_dps_env.avbay_temp3.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/avionics-temperature-K")+1.0))); 
    

    	p_dps_env.avbay_fan_dp1.setText(sprintf("%1.2f", getprop("/fdm/jsbsim/systems/eclss/avbay/fan-cooling-effect") * 3.80)); 
    	p_dps_env.avbay_fan_dp2.setText(sprintf("%1.2f", getprop("/fdm/jsbsim/systems/eclss/avbay[1]/fan-cooling-effect") * 3.77)); 
    	p_dps_env.avbay_fan_dp3.setText(sprintf("%1.2f", getprop("/fdm/jsbsim/systems/eclss/avbay[2]/fan-cooling-effect") * 3.92));  

	# oxygen system

	var airflow_in = getprop("/fdm/jsbsim/systems/eclss/cabin/air-gain-rate-lb_h");

	var o2_valve1 = getprop("/fdm/jsbsim/systems/eclss/oxygen/sys1-o2-supply-valve-status");
	var o2_valve2 = getprop("/fdm/jsbsim/systems/eclss/oxygen/sys2-o2-supply-valve-status");

	var oxygen_flow = getprop("/fdm/jsbsim/systems/eclss/cabin/oxygen-in-fraction-av") * airflow_in;
	
	if ((o2_valve1 == 1) and (o2_valve2 == 1)) {oxygen_flow = 0.5 * oxygen_flow;}

 	p_dps_env.o2_flow1.setText(sprintf("%2.1f", oxygen_flow * o2_valve1)); 	
	p_dps_env.o2_flow2.setText(sprintf("%2.1f", oxygen_flow * o2_valve2)); 

    	p_dps_env.o2_regp1.setText(sprintf("%3.0f", 101.0 * o2_valve1));
    	p_dps_env.o2_regp2.setText(sprintf("%3.0f", 100.0 * o2_valve2));

	# nitrogen system
	
	var n2_sys1 = getprop("/fdm/jsbsim/systems/eclss/nitrogen/sys1-pressurized");
	var n2_sys2 = getprop("/fdm/jsbsim/systems/eclss/nitrogen/sys2-pressurized");

    	p_dps_env.n2_regp1.setText(sprintf("%3.0f", 203.0 * n2_sys1));
    	p_dps_env.n2_regp2.setText(sprintf("%3.0f", 198.0 * n2_sys2));

	var nitrogen_flow = getprop("/fdm/jsbsim/systems/eclss/cabin/nitrogen-in-fraction-av") * airflow_in;

	if ((n2_sys1 == 1) and (n2_sys2 == 1)) {nitrogen_flow = 0.5 * nitrogen_flow;}

    	p_dps_env.n2_flow1.setText(sprintf("%2.1f", nitrogen_flow * n2_sys1));
    	p_dps_env.n2_flow2.setText(sprintf("%2.1f", nitrogen_flow * n2_sys2));

    	# pressures

    	p_dps_env.ppo2a.setText(sprintf("%2.1f", getprop("/fdm/jsbsim/systems/eclss/cabin/ppo2-psi")));
    	p_dps_env.ppo2b.setText(sprintf("%2.1f", getprop("/fdm/jsbsim/systems/eclss/cabin/ppo2-psi")+0.1));
    	p_dps_env.ppo2c.setText(sprintf("%2.1f", getprop("/fdm/jsbsim/systems/eclss/cabin/ppo2-psi")));

	p_dps_env.cabin_press.setText(sprintf("%2.1f", getprop("/fdm/jsbsim/systems/eclss/cabin/air-pressure-psi")));

        device.update_common_DPS();
    }
    
    
    
    return p_dps_env;
}
