#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_ascent
# Description: the ascent PFD page showing the vertical trajectory status
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_ascent = func(device)
{
    var p_ascent = device.addPage("Ascent", "p_ascent");
    
    #
    #
    # Ascent page update
    var p_ascent_view = device.svg.getElementById("ascent_view");
    SpaceShuttle.fill_traj1_data();
    var p_ascent_time = 0;
    var p_ascent_next_update = 0;
    
    
    device.p_ascent_shuttle_sym = device._canvas.createGroup();
    canvas.parsesvg( device.p_ascent_shuttle_sym, "/Nasal/canvas/map/Images/boeingAirplane.svg");
    device.p_ascent_shuttle_sym.setScale(0.3);
    
    p_ascent.throttle = device.svg.getElementById("p_ascent_throttle");
    p_ascent.throttle_text = device.svg.getElementById("p_ascent_throttle_txt");
    
    p_ascent.prplt = device.svg.getElementById("p_ascent_prplt");
    p_ascent.prplt_text = device.svg.getElementById("p_ascent_prplt_txt");
    
    p_ascent.ondisplay = func
    {
        # called once whenever this page goes on display/
        device.p_ascent_shuttle_sym.setScale(0.3);
        device.MEDS_menu_title.setText(sprintf("%s","       DPS MENU"));
    }
    
    p_ascent.offdisplay = func
    {
        device.nom_traj_plot.removeAllChildren();
        device.p_ascent_shuttle_sym.setScale(0.0);
    
        device.set_DPS_off();
    }
    
    p_ascent.update = func
    {
    
        device.update_common_DPS();
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        if (SpaceShuttle.traj_display_flag < 3)
    	{
            var throttle = getprop("/fdm/jsbsim/fcs/throttle-pos-norm");
            if (throttle < 0.67) {throttle = 0.0;} else {throttle = throttle * 100.0;}
            p_ascent.throttle.setText(sprintf("%3.0f",throttle));
            p_ascent.throttle_text.setText(sprintf("THROT"));
    	}
        else
    	{
            p_ascent.throttle.setText(sprintf(""));
            p_ascent.throttle_text.setText(sprintf(""));
    	}
    
        if (major_mode == 103)
    	{
            p_ascent.prplt.setText(sprintf("%3.0f",100.0* getprop("/consumables/fuel/tank/level-norm")));
            p_ascent.prplt_text.setText(sprintf("PRPLT"));
    	}
        else 	
    	{
            p_ascent.prplt.setText(sprintf(""));
            p_ascent.prplt_text.setText(sprintf(""));
    	}
    
        device.nom_traj_plot.removeAllChildren();
    
        SpaceShuttle.ascent_traj_update_set();
    
    
    
        if (SpaceShuttle.traj_display_flag == 1)
    	{
            if (major_mode == 101)
    		{device.DPS_menu_title.setText("LAUNCH TRAJ");}
            else
    		{device.DPS_menu_title.setText("ASCENT TRAJ 1");}
    
    		device.DPS_menu_ops.setText( major_mode~"1/     /");
    	}
        else if ( major_mode == 103)
    	{
            device.DPS_menu_title.setText("ASCENT TRAJ 2");
            device.DPS_menu_ops.setText("1031/     /");
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
    
    
        var x = SpaceShuttle.parameter_to_x(velocity, SpaceShuttle.traj_display_flag);
        var y = SpaceShuttle.parameter_to_y(altitude, SpaceShuttle.traj_display_flag);
    	
        device.p_ascent_shuttle_sym.setTranslation(x,y);
    
    
    };
    
    
    
    
    return p_ascent;
}
