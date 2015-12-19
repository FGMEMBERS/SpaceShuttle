#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_antenna
# Description: the Antennta  page
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_dps_antenna = func(device)
{
    var p_dps_antenna = device.addPage("CRTAntenna", "p_dps_antenna");
    
    p_dps_antenna.stdn = device.svg.getElementById("p_dps_antenna_stdn");
    p_dps_antenna.mode = device.svg.getElementById("p_dps_antenna_mode");
    p_dps_antenna.ant_pm = device.svg.getElementById("p_dps_antenna_ant_pm");
    p_dps_antenna.ant_fm = device.svg.getElementById("p_dps_antenna_ant_fm");



    p_dps_antenna.el_act = device.svg.getElementById("p_dps_antenna_el_act");
    p_dps_antenna.az_act = device.svg.getElementById("p_dps_antenna_az_act");
    p_dps_antenna.el_cmd = device.svg.getElementById("p_dps_antenna_el_cmd");
    p_dps_antenna.az_cmd = device.svg.getElementById("p_dps_antenna_az_cmd");

    p_dps_antenna.lon1 = device.svg.getElementById("p_dps_antenna_lon1");
    p_dps_antenna.lon2 = device.svg.getElementById("p_dps_antenna_lon2");
    p_dps_antenna.lon3 = device.svg.getElementById("p_dps_antenna_lon3");
    p_dps_antenna.lon4 = device.svg.getElementById("p_dps_antenna_lon4");
    p_dps_antenna.lon5 = device.svg.getElementById("p_dps_antenna_lon5");
    p_dps_antenna.lon6 = device.svg.getElementById("p_dps_antenna_lon6");

    p_dps_antenna.view1 = device.svg.getElementById("p_dps_antenna_view1");
    p_dps_antenna.view2 = device.svg.getElementById("p_dps_antenna_view2");
    p_dps_antenna.view3 = device.svg.getElementById("p_dps_antenna_view3");
    p_dps_antenna.view4 = device.svg.getElementById("p_dps_antenna_view4");
    p_dps_antenna.view5 = device.svg.getElementById("p_dps_antenna_view5");
    p_dps_antenna.view6 = device.svg.getElementById("p_dps_antenna_view6");





    p_dps_antenna.ondisplay = func
    {

	p_dps_antenna.lon1.setText(sprintf("%3.0f", SpaceShuttle.com_TDRS_array[0].coord.lon() ));
	p_dps_antenna.lon2.setText(sprintf("%3.0f", SpaceShuttle.com_TDRS_array[1].coord.lon() ));
	p_dps_antenna.lon3.setText(sprintf("%3.0f", SpaceShuttle.com_TDRS_array[2].coord.lon() ));
	p_dps_antenna.lon4.setText(sprintf("%3.0f", SpaceShuttle.com_TDRS_array[3].coord.lon() ));
	p_dps_antenna.lon5.setText(sprintf("%3.0f", SpaceShuttle.com_TDRS_array[4].coord.lon() ));
	p_dps_antenna.lon6.setText(sprintf("%3.0f", SpaceShuttle.com_TDRS_array[5].coord.lon() ));


        device.DPS_menu_title.setText("ANTENNA");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = "2011/   /";
        device.DPS_menu_ops.setText(ops_string);
    
    }
    
    p_dps_antenna.update = func
    {
	p_dps_antenna.stdn.setText(SpaceShuttle.antenna_manager.station); 
	p_dps_antenna.mode.setText(SpaceShuttle.antenna_manager.mode); 

	p_dps_antenna.ant_pm.setText(SpaceShuttle.antenna_manager.quadrant); 
	p_dps_antenna.ant_fm.setText(SpaceShuttle.antenna_manager.hemisphere); 

	p_dps_antenna.el_act.setText(sprintf("%+2.1f", getprop("/controls/shuttle/ku-antenna-beta-deg")));
	p_dps_antenna.az_act.setText(sprintf("%+3.1f", getprop("/controls/shuttle/ku-antenna-alpha-deg")));

	p_dps_antenna.el_cmd.setText(sprintf("%+2.1f", getprop("/controls/shuttle/ku-antenna-beta-deg-cmd")));
	p_dps_antenna.az_cmd.setText(sprintf("%+3.1f", getprop("/controls/shuttle/ku-antenna-alpha-deg-cmd")));

	if (SpaceShuttle.antenna_manager.TDRS_view_array[0] == 1)
		{p_dps_antenna.view1.setText("*");}
	else
		{p_dps_antenna.view1.setText("");}

	if (SpaceShuttle.antenna_manager.TDRS_view_array[1] == 1)
		{p_dps_antenna.view2.setText("*");}
	else
		{p_dps_antenna.view2.setText("");}

	if (SpaceShuttle.antenna_manager.TDRS_view_array[2] == 1)
		{p_dps_antenna.view3.setText("*");}
	else
		{p_dps_antenna.view3.setText("");}

	if (SpaceShuttle.antenna_manager.TDRS_view_array[3] == 1)
		{p_dps_antenna.view4.setText("*");}
	else
		{p_dps_antenna.view4.setText("");}

	if (SpaceShuttle.antenna_manager.TDRS_view_array[4] == 1)
		{p_dps_antenna.view5.setText("*");}
	else
		{p_dps_antenna.view5.setText("");}

	if (SpaceShuttle.antenna_manager.TDRS_view_array[5] == 1)
		{p_dps_antenna.view6.setText("*");}
	else
		{p_dps_antenna.view6.setText("");}


        device.update_common_DPS();
    }
    
    
    
    return p_dps_antenna;
}
