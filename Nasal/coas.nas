##########################################
# COAS pattern 
##########################################

var coas_device = {

	powered: 1,
	brightness: 1.0,
	filter: 0,
	update_loop_flag: 0,
	mountpos: "NONE",
	view: [0.269, 0.228, -10.86],
	

	init: func {

	#print("Initializing COAS pattern");

	me.canvas= canvas.new({
                "name": "COAS",
                    "size": [2048,2048], 
                    "view": [1024, 1024],
                    "mipmapping": 1     
                    });        

        me.canvas.setColorBackground(0.36, 1, 0.3, 0.00);
        me.canvas.addPlacement({"node": "coasglassaft"});
        me.canvas.addPlacement({"node": "coasglassfor"});

	me.root = me.canvas.createGroup();

	var path = "Aircraft/SpaceShuttle/Models/coas_pattern.png";
		
	me.coas_pattern = me.root.createChild("image")
                                   .setFile(path)
                                   .setTranslation(0,0)
                                   .setSize(1024,1024);

    	me.nd_ref_offset_x = props.globals.getNode("/sim/current-view/x-offset-m", 1);
    	me.nd_ref_offset_y = props.globals.getNode("/sim/current-view/y-offset-m", 1);
    	me.nd_ref_offset_z = props.globals.getNode("/sim/current-view/z-offset-m", 1);
               

	me.start_update();

	}, 


	increase_brightness: func {

		me.brightness+=0.05;
		if (me.brightness > 1.0) {me.brightness = 1.0;}

		if (me.powered == 0) {return;}

		var br_alpha = 0.5 + 0.5*me.brightness;
		var color_string = "rgba(255,255,255,"~br_alpha~")";
		me.coas_pattern.set("fill", color_string);

		setprop("/fdm/jsbsim/systems/light/hud-dim-coas-out", 2.0 - me.brightness);


	},

	decrease_brightness: func {

		me.brightness-=0.05;
		if (me.brightness < 0.0) {me.brightness = 0.0;}

		if (me.powered == 0) {return;}

		var br_alpha = 0.5 + 0.5*me.brightness;
		var color_string = "rgba(255,255,255,"~br_alpha~")";
		me.coas_pattern.set("fill", color_string);

		setprop("/fdm/jsbsim/systems/light/hud-dim-coas-out", 2.0 - me.brightness);

	},


	set_brightness: func (bright) {
		
		me.brightness = SpaceShuttle.clamp(bright, 0.0, 1.0);

		if (me.powered == 0) {return;}		

		var br_alpha = 0.5 + 0.5*me.brightness;
		var color_string = "rgba(255,255,255,"~br_alpha~")";
		#print (color_string);
		me.coas_pattern.set("fill", color_string);

		setprop("/fdm/jsbsim/systems/light/hud-dim-coas-out", 2.0 - me.brightness);

	},

	set_filter: func {

		me.filter = 1;
       		me.canvas.setColorBackground(0.8, 0.0, 1.0, 0.25);

	},

	unset_filter: func {

		me.filter = 0;
       		me.canvas.setColorBackground(0.36, 1, 0.3, 0.00);

	},

	toggle_filter: func {

		if (me.filter == 0) {me.set_filter();}
		else {me.unset_filter();}


	},

	mount: func (pos) {

		if (pos == "FWD")
			{
			me.view = [-0.7927, -0.154, -12.154];
			me.mountpos = "FWD";
			setprop("/sim/config/shuttle/show-coas-for", 1);
			setprop("/sim/config/shuttle/show-coas-aft", 0);
			}
		else if (pos == "AFT")
			{
			me.view = [0.269, 0.228, -10.86];
			me.mountpos = "AFT";
			setprop("/sim/config/shuttle/show-coas-for", 0);
			setprop("/sim/config/shuttle/show-coas-aft", 1);
			}
		else
			{
			me.mountpos = "NONE";
			setprop("/sim/config/shuttle/show-coas-for", 0);
			setprop("/sim/config/shuttle/show-coas-aft", 0);
			}
		

	},


	start_update: func {

		if (me.update_loop_flag == 1) {return;}
		me.update_loop_flag = 1;
		me.update();

	},


	update: func {

		if (me.update_loop_flag == 0) {return;}

		var voltage = getprop("/fdm/jsbsim/systems/electrical/ac[2]/voltage");

		if (voltage < 110.0) 
			{me.powered = 0;}
		else if (me.powered == 0)	
			{
			if (voltage > 110.0)
				{
				me.check_power();
				}
			}

		if (me.powered == 1) 
			{

			if (me.mountpos == "AFT")
				{

				var dx = me.view[0] - me.nd_ref_offset_x.getValue();
				var dy = me.view[1] - me.nd_ref_offset_y.getValue();
				var dz = me.view[2] - me.nd_ref_offset_z.getValue();


				me.coas_pattern.setScale(1.0 + dy * 3.4);
				me.coas_pattern.setTranslation (dx * 16000.0 -1500.0 * dy, dz * -16000.0 -1500.0 * dy);
				}

			else if (me.mountpos == "FWD")
				{

				var dx = me.view[0] - me.nd_ref_offset_x.getValue();
				var dy = me.view[1] - me.nd_ref_offset_y.getValue();
				var dz = me.view[2] - me.nd_ref_offset_z.getValue();

				me.coas_pattern.setScale(1.0 + dz * -2.6);
				me.coas_pattern.setTranslation (dx * -14000.0 + dz * 1300.0, dy * 14000.0 + dz * 1300.0);

				}

			}
		else
			{
			me.blank();
			}


		settimer(func {me.update();}, 0.0);
	},

	check_power : func  {

		var cb_status = getprop("/fdm/jsbsim/systems/circuit-breakers/coas");

	
		var mount_for = getprop("/sim/config/shuttle/show-coas-for");
		var mount_aft = getprop("/sim/config/shuttle/show-coas-aft");



		var mounted = 0;

		if ((mount_for == 1) or (mount_aft == 1))
			{
			mounted = 1;
			}

		var switch_status = 0;

		if (mount_for == 1) 
			{switch_status = getprop("/fdm/jsbsim/systems/electrical/hud/coas-pwr-fwd-switch");}
		else if (mount_aft == 1)
			{switch_status = getprop("/fdm/jsbsim/systems/electrical/hud/coas-pwr-aft-switch");}

		var power = 0;



		if ((cb_status == 1) and (switch_status == 1) and (mounted == 1)) 
			{
			power = 1;
			}

		#print ("Cb is now: ", cb_status);
		#print ("Switch is now: ", switch_status);
		#print ("Power is now: ", power);

		if (power == 0)
			{
			me.powered = 0;
			me.update_loop_flag = 0;
			me.blank();
			}
		else 
			{
			me.powered = 1;
			me.set_brightness(me.brightness);
			me.start_update();

			}
		

	},

	blank: func {

			var color_string = "rgba(255,255,255,0)";
			me.coas_pattern.set("fill", color_string);

	},

	check_mount: func {

		var mount_option = getprop("/sim/config/shuttle/COAS-config");

		me.mount (mount_option);

	},


};

coas_device.init();

setlistener("/fdm/jsbsim/systems/circuit-breakers/coas", func { coas_device.check_power() });
setlistener("/fdm/jsbsim/systems/electrical/hud/coas-pwr-aft-switch", func { coas_device.check_power() });
setlistener("/fdm/jsbsim/systems/electrical/hud/coas-pwr-fwd-switch", func { coas_device.check_power() });
#setlistener("/sim/config/shuttle/show-coas-for", func { coas_device.check_power() });
setlistener("/sim/config/shuttle/show-coas-aft", func { coas_device.check_power() });
