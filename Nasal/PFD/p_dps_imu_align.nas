#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_imu_align
# Description: the IMU ALIGN page
#      Author: Thorsten Renk, 2017
#---------------------------------------

var PFD_addpage_p_dps_imu_align = func(device)
{
    var p_dps_imu_align = device.addPage("CRTIMU", "p_dps_imu_align");

    p_dps_imu_align.group = device.svg.getElementById("p_dps_imu_align");
    p_dps_imu_align.group.setColor(dps_r, dps_g, dps_b);
    
    p_dps_imu_align.imu1_stat = device.svg.getElementById("p_dps_imu_align_imu1_stat");
    p_dps_imu_align.imu2_stat = device.svg.getElementById("p_dps_imu_align_imu2_stat");
    p_dps_imu_align.imu3_stat = device.svg.getElementById("p_dps_imu_align_imu3_stat");

    p_dps_imu_align.imu1_stat.enableUpdate();
    p_dps_imu_align.imu2_stat.enableUpdate();
    p_dps_imu_align.imu3_stat.enableUpdate();

    p_dps_imu_align.imu1 = device.svg.getElementById("p_dps_imu_align_imu1");
    p_dps_imu_align.imu2 = device.svg.getElementById("p_dps_imu_align_imu2");
    p_dps_imu_align.imu3 = device.svg.getElementById("p_dps_imu_align_imu3");

    p_dps_imu_align.imu1.enableUpdate();
    p_dps_imu_align.imu2.enableUpdate();
    p_dps_imu_align.imu3.enableUpdate();

    p_dps_imu_align.imu1_temp = device.svg.getElementById("p_dps_imu_align_imu1_temp");
    p_dps_imu_align.imu2_temp = device.svg.getElementById("p_dps_imu_align_imu2_temp");
    p_dps_imu_align.imu3_temp = device.svg.getElementById("p_dps_imu_align_imu3_temp");

    p_dps_imu_align.imu1_temp.enableUpdate();
    p_dps_imu_align.imu2_temp.enableUpdate();
    p_dps_imu_align.imu3_temp.enableUpdate();

    p_dps_imu_align.imu1_stby = device.svg.getElementById("p_dps_imu_align_imu1_stby");
    p_dps_imu_align.imu2_stby = device.svg.getElementById("p_dps_imu_align_imu2_stby");
    p_dps_imu_align.imu3_stby = device.svg.getElementById("p_dps_imu_align_imu3_stby");

    p_dps_imu_align.imu1_stby.enableUpdate();
    p_dps_imu_align.imu2_stby.enableUpdate();
    p_dps_imu_align.imu3_stby.enableUpdate();

    p_dps_imu_align.imu1_oper = device.svg.getElementById("p_dps_imu_align_imu1_oper");
    p_dps_imu_align.imu2_oper = device.svg.getElementById("p_dps_imu_align_imu2_oper");
    p_dps_imu_align.imu3_oper = device.svg.getElementById("p_dps_imu_align_imu3_oper");

    p_dps_imu_align.imu1_oper.enableUpdate();
    p_dps_imu_align.imu2_oper.enableUpdate();
    p_dps_imu_align.imu3_oper.enableUpdate();

    p_dps_imu_align.imu1_des = device.svg.getElementById("p_dps_imu_align_imu1_des");
    p_dps_imu_align.imu2_des = device.svg.getElementById("p_dps_imu_align_imu2_des");
    p_dps_imu_align.imu3_des = device.svg.getElementById("p_dps_imu_align_imu3_des");

    p_dps_imu_align.imu1_des.enableUpdate();
    p_dps_imu_align.imu2_des.enableUpdate();
    p_dps_imu_align.imu3_des.enableUpdate();

    p_dps_imu_align.imu1_sel = device.svg.getElementById("p_dps_imu_align_imu1_sel");
    p_dps_imu_align.imu2_sel = device.svg.getElementById("p_dps_imu_align_imu2_sel");
    p_dps_imu_align.imu3_sel = device.svg.getElementById("p_dps_imu_align_imu3_sel");

    p_dps_imu_align.imu1_sel.enableUpdate();
    p_dps_imu_align.imu2_sel.enableUpdate();
    p_dps_imu_align.imu3_sel.enableUpdate();

    p_dps_imu_align.ena = device.svg.getElementById("p_dps_imu_align_ena");
    p_dps_imu_align.ena.enableUpdate();  

    p_dps_imu_align.imu1_acc_x = device.svg.getElementById("p_dps_imu_align_imu1_acc_x");
    p_dps_imu_align.imu2_acc_x = device.svg.getElementById("p_dps_imu_align_imu2_acc_x");
    p_dps_imu_align.imu3_acc_x = device.svg.getElementById("p_dps_imu_align_imu3_acc_x");

    p_dps_imu_align.imu1_acc_x.enableUpdate();
    p_dps_imu_align.imu2_acc_x.enableUpdate();
    p_dps_imu_align.imu3_acc_x.enableUpdate();

    p_dps_imu_align.imu1_acc_y = device.svg.getElementById("p_dps_imu_align_imu1_acc_y");
    p_dps_imu_align.imu2_acc_y = device.svg.getElementById("p_dps_imu_align_imu2_acc_y");
    p_dps_imu_align.imu3_acc_y = device.svg.getElementById("p_dps_imu_align_imu3_acc_y");

    p_dps_imu_align.imu1_acc_y.enableUpdate();
    p_dps_imu_align.imu2_acc_y.enableUpdate();
    p_dps_imu_align.imu3_acc_y.enableUpdate();

    p_dps_imu_align.imu1_acc_z = device.svg.getElementById("p_dps_imu_align_imu1_acc_z");
    p_dps_imu_align.imu2_acc_z = device.svg.getElementById("p_dps_imu_align_imu2_acc_z");
    p_dps_imu_align.imu3_acc_z = device.svg.getElementById("p_dps_imu_align_imu3_acc_z");

    p_dps_imu_align.imu1_acc_z.enableUpdate();
    p_dps_imu_align.imu2_acc_z.enableUpdate();
    p_dps_imu_align.imu3_acc_z.enableUpdate();

    p_dps_imu_align.imu1_ang_x = device.svg.getElementById("p_dps_imu_align_imu1_ang_x");
    p_dps_imu_align.imu2_ang_x = device.svg.getElementById("p_dps_imu_align_imu2_ang_x");
    p_dps_imu_align.imu3_ang_x = device.svg.getElementById("p_dps_imu_align_imu3_ang_x");

    p_dps_imu_align.imu1_ang_y = device.svg.getElementById("p_dps_imu_align_imu1_ang_y");
    p_dps_imu_align.imu2_ang_y = device.svg.getElementById("p_dps_imu_align_imu2_ang_y");
    p_dps_imu_align.imu3_ang_y = device.svg.getElementById("p_dps_imu_align_imu3_ang_y");

    p_dps_imu_align.imu1_ang_z = device.svg.getElementById("p_dps_imu_align_imu1_ang_z");
    p_dps_imu_align.imu2_ang_z = device.svg.getElementById("p_dps_imu_align_imu2_ang_z");
    p_dps_imu_align.imu3_ang_z = device.svg.getElementById("p_dps_imu_align_imu3_ang_z");

    p_dps_imu_align.imu1_delta_x = device.svg.getElementById("p_dps_imu_align_imu1_delta_x");
    p_dps_imu_align.imu2_delta_x = device.svg.getElementById("p_dps_imu_align_imu2_delta_x");
    p_dps_imu_align.imu3_delta_x = device.svg.getElementById("p_dps_imu_align_imu3_delta_x");

    p_dps_imu_align.imu1_delta_x.enableUpdate();
    p_dps_imu_align.imu2_delta_x.enableUpdate();
    p_dps_imu_align.imu3_delta_x.enableUpdate();

    p_dps_imu_align.imu1_delta_y = device.svg.getElementById("p_dps_imu_align_imu1_delta_y");
    p_dps_imu_align.imu2_delta_y = device.svg.getElementById("p_dps_imu_align_imu2_delta_y");
    p_dps_imu_align.imu3_delta_y = device.svg.getElementById("p_dps_imu_align_imu3_delta_y");

    p_dps_imu_align.imu1_delta_y.enableUpdate();
    p_dps_imu_align.imu2_delta_y.enableUpdate();
    p_dps_imu_align.imu3_delta_y.enableUpdate();

    p_dps_imu_align.imu1_delta_z = device.svg.getElementById("p_dps_imu_align_imu1_delta_z");
    p_dps_imu_align.imu2_delta_z = device.svg.getElementById("p_dps_imu_align_imu2_delta_z");
    p_dps_imu_align.imu3_delta_z = device.svg.getElementById("p_dps_imu_align_imu3_delta_z");

    p_dps_imu_align.imu1_delta_z.enableUpdate();
    p_dps_imu_align.imu2_delta_z.enableUpdate();
    p_dps_imu_align.imu3_delta_z.enableUpdate();

    p_dps_imu_align.star_align = device.svg.getElementById("p_dps_imu_align_star_align");
    p_dps_imu_align.imu_imu = device.svg.getElementById("p_dps_imu_align_imu_imu");
    p_dps_imu_align.matrix = device.svg.getElementById("p_dps_imu_align_matrix");

    p_dps_imu_align.star_align.enableUpdate();
    p_dps_imu_align.imu_imu.enableUpdate();
    p_dps_imu_align.matrix.enableUpdate();

    p_dps_imu_align.ena = device.svg.getElementById("p_dps_imu_align_ena");
    p_dps_imu_align.ena.enableUpdate();

    p_dps_imu_align.imu1_bite_mask = device.svg.getElementById("p_dps_imu_align_imu1_bite_mask");
    p_dps_imu_align.imu2_bite_mask = device.svg.getElementById("p_dps_imu_align_imu2_bite_mask");
    p_dps_imu_align.imu3_bite_mask = device.svg.getElementById("p_dps_imu_align_imu3_bite_mask");

    p_dps_imu_align.imu1_bite = device.svg.getElementById("p_dps_imu_align_imu1_bite");
    p_dps_imu_align.imu2_bite = device.svg.getElementById("p_dps_imu_align_imu2_bite");
    p_dps_imu_align.imu3_bite = device.svg.getElementById("p_dps_imu_align_imu3_bite");

    p_dps_imu_align.mm_read = device.svg.getElementById("p_dps_imu_align_mm_read");

    p_dps_imu_align.exec = device.svg.getElementById("p_dps_imu_align_exec");
    p_dps_imu_align.exec.enableUpdate();

    p_dps_imu_align.nav_thresh = device.svg.getElementById("p_dps_imu_align_nav_thresh");


    p_dps_imu_align.ondisplay = func
    {
        device.DPS_menu_title.setText("IMU ALIGN");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");

        var ops_string = major_mode~"1/"~"021";
        device.DPS_menu_ops.setText(ops_string);
	
	# defaults for items not yet impemented

	p_dps_imu_align.imu1_bite.setText("");
	p_dps_imu_align.imu2_bite.setText("");
	p_dps_imu_align.imu3_bite.setText("");

	p_dps_imu_align.imu1_bite_mask.setText("");
	p_dps_imu_align.imu2_bite_mask.setText("");
	p_dps_imu_align.imu3_bite_mask.setText("");

	p_dps_imu_align.mm_read.setText("");

    	p_dps_imu_align.nav_thresh.setText("3840");

    }
    
    p_dps_imu_align.update = func
    {

	# status messages
    
	p_dps_imu_align.imu1_stat.updateText(SpaceShuttle.imu_system.imu[0].status_string);
    	p_dps_imu_align.imu2_stat.updateText(SpaceShuttle.imu_system.imu[1].status_string);
    	p_dps_imu_align.imu3_stat.updateText(SpaceShuttle.imu_system.imu[2].status_string);
    
	p_dps_imu_align.imu1_temp.updateText(SpaceShuttle.imu_system.imu[0].temp_string);
    	p_dps_imu_align.imu2_temp.updateText(SpaceShuttle.imu_system.imu[1].temp_string);
    	p_dps_imu_align.imu3_temp.updateText(SpaceShuttle.imu_system.imu[2].temp_string);

	
	p_dps_imu_align.imu1.updateText("1"~SpaceShuttle.imu_system.imu[0].get_status_symbol());
	p_dps_imu_align.imu2.updateText("2"~SpaceShuttle.imu_system.imu[1].get_status_symbol());
	p_dps_imu_align.imu3.updateText("3"~SpaceShuttle.imu_system.imu[2].get_status_symbol());


	if (SpaceShuttle.imu_system.imu[0].mode == "OPER")
		{
		p_dps_imu_align.imu1_stby.updateText("");
		p_dps_imu_align.imu1_oper.updateText("*");
		}
	else
		{
		p_dps_imu_align.imu1_stby.updateText("*");
		p_dps_imu_align.imu1_oper.updateText("");
		}

	if (SpaceShuttle.imu_system.imu[1].mode == "OPER")
		{
		p_dps_imu_align.imu2_stby.updateText("");
		p_dps_imu_align.imu2_oper.updateText("*");
		}
	else
		{
		p_dps_imu_align.imu2_stby.updateText("*");
		p_dps_imu_align.imu2_oper.updateText("");
		}

	if (SpaceShuttle.imu_system.imu[2].mode == "OPER")
		{
		p_dps_imu_align.imu3_stby.updateText("");
		p_dps_imu_align.imu3_oper.updateText("*");
		}
	else
		{
		p_dps_imu_align.imu3_stby.updateText("*");
		p_dps_imu_align.imu3_oper.updateText("");
		}

	if (SpaceShuttle.imu_system.imu[0].deselected == 1)
		{
		p_dps_imu_align.imu1_des.updateText("*");
		}
	else
		{
		p_dps_imu_align.imu1_des.updateText("");
		}

	if (SpaceShuttle.imu_system.imu[1].deselected == 1)
		{
		p_dps_imu_align.imu2_des.updateText("*");
		}
	else
		{
		p_dps_imu_align.imu2_des.updateText("");
		}

	if (SpaceShuttle.imu_system.imu[2].deselected == 1)
		{
		p_dps_imu_align.imu3_des.updateText("*");
		}
	else
		{
		p_dps_imu_align.imu3_des.updateText("");
		}



	# accelerations

	var acc_x = getprop("/fdm/jsbsim/systems/navigation/acc-x");
	var acc_y = getprop("/fdm/jsbsim/systems/navigation/acc-y");
	var acc_z = getprop("/fdm/jsbsim/systems/navigation/acc-z");


	p_dps_imu_align.imu1_acc_x.updateText(sprintf("%+1.2f", acc_x + SpaceShuttle.imu_system.imu[0].acc_error_x));
	p_dps_imu_align.imu2_acc_x.updateText(sprintf("%+1.2f", acc_x + SpaceShuttle.imu_system.imu[1].acc_error_x));
	p_dps_imu_align.imu3_acc_x.updateText(sprintf("%+1.2f", acc_x + SpaceShuttle.imu_system.imu[2].acc_error_x));

	p_dps_imu_align.imu1_acc_y.updateText(sprintf("%+1.2f", acc_y + SpaceShuttle.imu_system.imu[0].acc_error_y));
	p_dps_imu_align.imu2_acc_y.updateText(sprintf("%+1.2f", acc_y + SpaceShuttle.imu_system.imu[1].acc_error_y));
	p_dps_imu_align.imu3_acc_y.updateText(sprintf("%+1.2f", acc_y + SpaceShuttle.imu_system.imu[2].acc_error_y));

	p_dps_imu_align.imu1_acc_z.updateText(sprintf("%+1.2f", acc_z + SpaceShuttle.imu_system.imu[0].acc_error_z));
	p_dps_imu_align.imu2_acc_z.updateText(sprintf("%+1.2f", acc_z + SpaceShuttle.imu_system.imu[1].acc_error_z));
	p_dps_imu_align.imu3_acc_z.updateText(sprintf("%+1.2f", acc_z + SpaceShuttle.imu_system.imu[2].acc_error_z));

	# M50 angles

	var sid_ang = getprop("/fdm/jsbsim/systems/pointing/sidereal/sidereal-angle-rad") * 180.0/math.pi;

	var m50_pitch = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/pitch-deg");
	var m50_yaw = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/yaw-deg") + sid_ang - 260.0;
	var m50_roll = -getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/roll-deg");

	p_dps_imu_align.imu1_ang_x.setText(sprintf("%3.2f", m50_roll + SpaceShuttle.imu_system.imu[0].roll_error));
	p_dps_imu_align.imu2_ang_x.setText(sprintf("%3.2f", m50_roll + SpaceShuttle.imu_system.imu[1].roll_error));
	p_dps_imu_align.imu3_ang_x.setText(sprintf("%3.2f", m50_roll + SpaceShuttle.imu_system.imu[2].roll_error));

	p_dps_imu_align.imu1_ang_y.setText(sprintf("%3.2f", m50_pitch + SpaceShuttle.imu_system.imu[0].pitch_error));
	p_dps_imu_align.imu2_ang_y.setText(sprintf("%3.2f", m50_pitch + SpaceShuttle.imu_system.imu[1].pitch_error));
	p_dps_imu_align.imu3_ang_y.setText(sprintf("%3.2f", m50_pitch + SpaceShuttle.imu_system.imu[2].pitch_error));

	p_dps_imu_align.imu1_ang_z.setText(sprintf("%3.2f", m50_yaw + SpaceShuttle.imu_system.imu[0].yaw_error));
	p_dps_imu_align.imu2_ang_z.setText(sprintf("%3.2f", m50_yaw + SpaceShuttle.imu_system.imu[1].yaw_error));
	p_dps_imu_align.imu3_ang_z.setText(sprintf("%3.2f", m50_yaw + SpaceShuttle.imu_system.imu[2].yaw_error));


	# alignment 

	if (SpaceShuttle.imu_system.align_enable == 0)
		{
		p_dps_imu_align.ena.updateText("INH");

		p_dps_imu_align.imu1_delta_x.updateText("  +0.00");
		p_dps_imu_align.imu2_delta_x.updateText("  +0.00");
		p_dps_imu_align.imu3_delta_x.updateText("  +0.00");

		p_dps_imu_align.imu1_delta_y.updateText("  +0.00");
		p_dps_imu_align.imu2_delta_y.updateText("  +0.00");
		p_dps_imu_align.imu3_delta_y.updateText("  +0.00");

		p_dps_imu_align.imu1_delta_z.updateText("  +0.00");
		p_dps_imu_align.imu2_delta_z.updateText("  +0.00");
		p_dps_imu_align.imu3_delta_z.updateText("  +0.00");
		}
	else
		{
		p_dps_imu_align.ena.updateText("ENA");

		p_dps_imu_align.imu1_delta_x.updateText(sprintf("%+3.2f",SpaceShuttle.imu_system.imu[0].delta_roll ));
		p_dps_imu_align.imu2_delta_x.updateText(sprintf("%+3.2f",SpaceShuttle.imu_system.imu[1].delta_roll ));
		p_dps_imu_align.imu3_delta_x.updateText(sprintf("%+3.2f",SpaceShuttle.imu_system.imu[2].delta_roll ));

		p_dps_imu_align.imu1_delta_y.updateText(sprintf("%+3.2f",SpaceShuttle.imu_system.imu[0].delta_pitch ));
		p_dps_imu_align.imu2_delta_y.updateText(sprintf("%+3.2f",SpaceShuttle.imu_system.imu[1].delta_pitch ));
		p_dps_imu_align.imu3_delta_y.updateText(sprintf("%+3.2f",SpaceShuttle.imu_system.imu[2].delta_pitch ));

		p_dps_imu_align.imu1_delta_z.updateText(sprintf("%+3.2f",SpaceShuttle.imu_system.imu[0].delta_yaw ));
		p_dps_imu_align.imu2_delta_z.updateText(sprintf("%+3.2f",SpaceShuttle.imu_system.imu[1].delta_yaw ));
		p_dps_imu_align.imu3_delta_z.updateText(sprintf("%+3.2f",SpaceShuttle.imu_system.imu[2].delta_yaw ));
		}

	if (SpaceShuttle.imu_system.align_in_progress == 0)
		{
		p_dps_imu_align.exec.updateText("");
		}
	else
		{
		p_dps_imu_align.exec.updateText("*");
		}
	

	if (SpaceShuttle.imu_system.alignment_method == 0)
		{
    		p_dps_imu_align.star_align.updateText("*");
    		p_dps_imu_align.imu_imu.updateText("");
    		p_dps_imu_align.matrix.updateText("");
		}
	else if (SpaceShuttle.imu_system.alignment_method == 1)
		{
    		p_dps_imu_align.star_align.updateText("");
    		p_dps_imu_align.imu_imu.updateText(sprintf("%d", SpaceShuttle.imu_system.reference_imu));
    		p_dps_imu_align.matrix.updateText("");
		}
	else
		{
    		p_dps_imu_align.star_align.updateText("");
    		p_dps_imu_align.imu_imu.updateText("");
    		p_dps_imu_align.matrix.updateText("*");
		}

	if (SpaceShuttle.imu_system.imu[0].sel_for_alignment == 1)
		{
		p_dps_imu_align.imu1_sel.updateText("*");
		}
	else	
		{
		p_dps_imu_align.imu1_sel.updateText("");
		}

	if (SpaceShuttle.imu_system.imu[1].sel_for_alignment == 1)
		{
		p_dps_imu_align.imu2_sel.updateText("*");
		}
	else	
		{
		p_dps_imu_align.imu2_sel.updateText("");
		}

	if (SpaceShuttle.imu_system.imu[2].sel_for_alignment == 1)
		{
		p_dps_imu_align.imu3_sel.updateText("*");
		}
	else	
		{
		p_dps_imu_align.imu3_sel.updateText("");
		}

        device.update_common_DPS();
    }
    
    
    
    return p_dps_imu_align;
}
