#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_entry
# Description: the entry PFD page showing the vertical trajectory status
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_entry = func(device)
{
    var p_entry = device.addPage("Entry", "p_entry");
    
    p_entry.D_az = device.svg.getElementById("p_entry_D_az");
    p_entry.qbar = device.svg.getElementById("p_entry_qbar");
    p_entry.dref = device.svg.getElementById("p_entry_dref");
    p_entry.bias = device.svg.getElementById("p_entry_bias");
    
    
    
    
    p_entry.ondisplay = func
    {
        # called once whenever this page goes on display
    
        p_entry.bias.setText("+00");
        device.p_ascent_shuttle_sym.setScale(0.3);
        device.MEDS_menu_title.setText("       DPS MENU");
    }
    
    p_entry.offdisplay = func
    {
        device.nom_traj_plot.removeAllChildren();
        device.p_ascent_shuttle_sym.setScale(0.0);
    
        device.set_DPS_off();
    }
    
    p_entry.update = func
    {
    
    
    
        device.update_common_DPS();
    
    
        device.nom_traj_plot.removeAllChildren();
    
        SpaceShuttle.ascent_traj_update_set();
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
    
        if  ((SpaceShuttle.traj_display_flag == 3) and (major_mode == 304))
    	{
            device.DPS_menu_title.setText("ENTRY TRAJ 1");
            device.DPS_menu_ops.setText("3041/     /");
    	}
        else if ((SpaceShuttle.traj_display_flag == 4) and (major_mode == 304))
    	{
            device.DPS_menu_title.setText("ENTRY TRAJ 2");
    	}
        else if ((SpaceShuttle.traj_display_flag == 5) and (major_mode == 304))
    	{
            device.DPS_menu_title.setText("ENTRY TRAJ 3");
    	}
        else if (( SpaceShuttle.traj_display_flag == 6) and (major_mode == 304))
    	{
            device.DPS_menu_title.setText("ENTRY TRAJ 4");
    	}
        else if ((SpaceShuttle.traj_display_flag == 7)and (major_mode == 304))
    	{
            device.DPS_menu_title.setText("ENTRY TRAJ 5");
    	}
    
    
    
        var plot = device.nom_traj_plot.createChild("path", "data")
        .setStrokeLineWidth(2)
        .setColor(0.5,0.6,0.5)
        .moveTo(traj_data[0][0],traj_data[0][1]); 
    
        for (var i = 1; i< (size(traj_data)-1); i=i+1)
        {
            var set = traj_data[i+1];
            plot.lineTo(set[0], set[1]);	
        }
    
        var velocity = SpaceShuttle.ascent_traj_update_velocity();
        var altitude = getprop("/position/altitude-ft");
    
    
        var range = getprop("/fdm/jsbsim/systems/entry_guidance/remaining-distance-nm");
        var x = SpaceShuttle.parameter_to_x(range, SpaceShuttle.traj_display_flag);
        var y = SpaceShuttle.parameter_to_y(velocity, SpaceShuttle.traj_display_flag);
    	
    
    
        device.p_ascent_shuttle_sym.setTranslation(x,y);
    
    
        p_entry.D_az.setText(sprintf("%3.0f",getprop("/fdm/jsbsim/systems/entry_guidance/delta-azimuth-deg")));
        p_entry.qbar.setText(sprintf("%3.1f",getprop("/fdm/jsbsim/aero/qbar-psf")));
        p_entry.dref.setText(sprintf("%3.1f",-32.18 * getprop("/accelerations/nlf")));
    
    };
    
    
    
    return p_entry;
}
