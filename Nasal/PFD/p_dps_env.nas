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

	var o2_valve1 = getprop("/fdm/jsbsim/systems/eclss/oxygen/sys1-o2-supply-valve-status");
	var o2_valve2 = getprop("/fdm/jsbsim/systems/eclss/oxygen/sys2-o2-supply-valve-status");

	var oxygen_flow = 0.582 * getprop("/fdm/jsbsim/systems/eclss/oxygen/cabin-oxygen-available");
	
	if ((o2_valve1 == 1) and (o2_valve2 == 1)) {oxygen_flow = 0.5 * oxygen_flow;}

 	p_dps_env.o2_flow1.setText(sprintf("%2.1f", oxygen_flow * o2_valve1)); 	
	p_dps_env.o2_flow2.setText(sprintf("%2.1f", oxygen_flow * o2_valve2)); 

    	p_dps_env.o2_regp1.setText(sprintf("%3.0f", 101.0 * o2_valve1));
    	p_dps_env.o2_regp2.setText(sprintf("%3.0f", 100.0 * o2_valve2));

        device.update_common_DPS();
    }
    
    
    
    return p_dps_env;
}
