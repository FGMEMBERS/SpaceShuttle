
# class to create a rendezvous planning map for spacecraft
# Thorsten Renk 2019

var cdlg_rendezvous = {

	update_loop_flag: 0,
	target_prox_x: 0.0,
	target_prox_y: 0.0,
	target_prox_z: 0.0,

	target_prox_vx: 0.0,
	target_prox_vy: 0.0,
	target_prox_vz: 0.0,

	target_prox_x_last: 0.0,
	target_prox_y_last: 0.0,
	target_prox_z_last: 0.0,

	tgt_pos: [0.0,0.0,0.0],
	tgt_vel: [0.0, 0.0, 0.0],
	ch_pos: [0.0,0.0,0.0],
	ch_vel: [0.0, 0.0, 0.0],
	ch_pnorm: [0.0, 0.0, 0.0],
	ch_vnorm: [0.0, 0.0, 0.0],
	ch_nnorm: [0.0, 0.0, 0.0],	
	tgt_pnorm: [0.0, 0.0, 0.0],
	tgt_vnorm: [0.0, 0.0, 0.0],

	ch_r: 0.0,
	tgt_r: 0.0,
	tgt_v: 0.0,
	ang: 0.0,
	ang_last: 0.0,
	alpha_dot: 0.0,
	rinc: 0.0,
	
	alpha_dot_array: [0],


	plot_scale: 500,

	history_draw_counter: 0,
	history_is_drawn: 0,

	rinc_compute_counter: 0,

	unit_system: "SI",
	conversion: 1.0,
	length_unit: "m",
	speed_unit: "m/s",


	init: func {

		if (me.update_loop_flag == 1) {return;}

		if (SpaceShuttle.n_orbital_targets == 0) {return;} 

		me.window = canvas.Window.new([800,400],"dialog").set("title", "Rendezvous");

		me.window.del = func()
			{
		  	SpaceShuttle.cdlg_rendezvous.update_loop_flag = 0;
			SpaceShuttle.cdlg_rendezvous.unit_system = "imperial";
			SpaceShuttle.cdlg_rendezvous.switch_units();
		  	call(canvas.Window.del, [], me);
			};
		me.rndCanvas = me.window.createCanvas().set("background", canvas.style.getColor("bg_color"));
		me.root = me.rndCanvas.createGroup();

		# symbols

		me.symbols = me.root.createChild("group", "Symbols");

		var data = SpaceShuttle.draw_shuttle_side();

		me.sym_shuttle = me.symbols.createChild("path", "shuttle")
        	.setStrokeLineWidth(0.25)
        	.setColor(0.0, 0.0, 0.0)
		.moveTo(data[0][0], data[0][1]);

		me.symbol_draw (me.sym_shuttle, data, 0);
		me.sym_shuttle.setScale(5.0);
		me.sym_shuttle.setTranslation(100.0, 100.0);

		data = [[0.0, 0.0], [0.0, 300.0]];
		me.line_vert = me.symbols.createChild("path", "line1")
        	.setStrokeLineWidth(2.0)
        	.setColor(0.0, 0.0, 0.0)
		.moveTo(data[0][0], data[0][1])
		.lineTo(data[1][0], data[1][1]);
		
		me.line_vert.setTranslation(100.0, 50.0);

		me.vert_scale = me.symbols.createChild("text", "line1_text")
			.setText("100 km")
			.setColor(0,0,0)
			.setFontSize(15)
			.setFont("LiberationFonts/LiberationSans-Bold.ttf")
			.setAlignment("center-bottom")
			.setTranslation(100.0, 370.0);

		data = [[0.0, 0.0], [500.0, 0.0]];
		me.line_horiz = me.symbols.createChild("path", "line2")
        	.setStrokeLineWidth(2.0)
        	.setColor(0.0, 0.0, 0.0)
		.moveTo(data[0][0], data[0][1])
		.lineTo(data[1][0], data[1][1]);
		
		me.line_horiz.setTranslation(30.0, 100.0);


		me.horiz_scale = me.symbols.createChild("text", "line2_text")
			.setText("500 km")
			.setColor(0,0,0)
			.setFontSize(15)
			.setFont("LiberationFonts/LiberationSans-Bold.ttf")
			.setAlignment("center-bottom")
			.setTranslation(500.0, 90.0);

		# history graph

		me.history = me.root.createChild("group", "History");



		# alphanumerics

		var text_template = [["0.0"]];
		var box_size = 110.0;
		var title_bg = [0.7,0.7,0.7,0.7];
		var box_bg = [0.6,0.6,0.6,0.6];


		me.an_prox_x = cdlg_widget_infobox.new(me.root, box_size, "x", text_template, 10.0, nil, nil, title_bg, nil, box_bg);
		me.an_prox_x.setTranslation(680,30);
		me.an_prox_x.setUnit(" m");

		me.an_prox_y = cdlg_widget_infobox.new(me.root, box_size, "y", text_template, 10.0, nil, nil, title_bg, nil, box_bg);
		me.an_prox_y.setTranslation(680,90);
		me.an_prox_y.setUnit(" m");

		me.an_prox_z = cdlg_widget_infobox.new(me.root, box_size, "z", text_template, 10.0, nil, nil, title_bg, nil, box_bg);
		me.an_prox_z.setTranslation(680,150);
		me.an_prox_z.setUnit(" m");

		me.an_alpha = cdlg_widget_infobox.new(me.root, box_size, "α", text_template, 10.0, nil, nil, title_bg, nil, box_bg);
		me.an_alpha.formatFunction = func (value) {return sprintf("%1.4f", value);};
		me.an_alpha.setTranslation(680,210);
		me.an_alpha.setUnit("°");


		me.an_alpha_rate = cdlg_widget_infobox.new(me.root, box_size, "α rate", text_template, 10.0, nil, nil, title_bg, nil, box_bg);
		me.an_alpha_rate.formatFunction = func (value) {return sprintf("%1.4f", value);};
		me.an_alpha_rate.setTranslation(680,270);
		me.an_alpha_rate.setUnit("°/min");

		me.an_rinc = cdlg_widget_infobox.new(me.root, box_size, "rel. inc.", text_template, 10.0, nil, nil, title_bg, nil, box_bg);
		me.an_rinc.formatFunction = func (value) {return sprintf("%1.2f", value);};		
		me.an_rinc.setTranslation(680,330);
		me.an_rinc.setVisible(0);
		me.an_rinc.setUnit("°");


		me.an_xdot = cdlg_widget_infobox.new(me.root, box_size, "vx", text_template, 10.0, nil, nil, title_bg, nil, box_bg);
		me.an_xdot.formatFunction = func (value) {return sprintf("%1.1f", value);};		
		me.an_xdot.setTranslation(680,210);
		me.an_xdot.setVisible(0);
		me.an_xdot.setUnit(" m/s");

		me.an_ydot = cdlg_widget_infobox.new(me.root, box_size, "vy", text_template, 10.0, nil, nil, title_bg, nil, box_bg);
		me.an_ydot.formatFunction = func (value) {return sprintf("%1.1f", value);};		
		me.an_ydot.setTranslation(680,270);
		me.an_ydot.setVisible(0);
		me.an_ydot.setUnit(" m/s");

		me.an_zdot = cdlg_widget_infobox.new(me.root, box_size, "vz", text_template, 10.0, nil, nil, title_bg, nil, box_bg);
		me.an_zdot.formatFunction = func (value) {return sprintf("%1.1f", value);};		
		me.an_zdot.setTranslation(680,330);
		me.an_zdot.setVisible(0);
		me.an_zdot.setUnit(" m/s");


		me.an_burn = me.root.createChild("text")
			.setText("")
			.setColor(0.0, 0.0, 0.0)
			.setFontSize(14)
			.setFont("LiberationFonts/LiberationSans-Bold.ttf")
			.setTranslation(140, 50)
			.setAlignment("left-center");

		# buttons


		var stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/Rendezvous/rndz_units_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/Rendezvous/rndz_units_1.png");
		me.button_units = cdlg_widget_img_stack.new(me.root, stack, 126, 42);
		me.button_units.setTranslation(180,340);
		#me.button_units.increment();
		me.button_units.f = func {
		
			SpaceShuttle.cdlg_rendezvous.switch_units();
		};

		stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/Rendezvous/rndz_burn_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/Rendezvous/rndz_burn_1.png");
		me.button_burn = cdlg_widget_img_stack.new(me.root, stack, 126, 42);
		me.button_burn.setTranslation(360,340);
		me.button_burn.f = func {
		
			SpaceShuttle.cdlg_rendezvous.compute_pc_burn();
		};

		# set scale parameter before to avoid wiping history
		me.plot_scale = SpaceShuttle.proximity_manager.plot_scale;
		me.set_scale (SpaceShuttle.proximity_manager.plot_scale);

		me.update_loop_flag = 1;
		me.update();

	},


	set_scale: func (scale) {

		print ("New scale set to ", scale);
		if (scale == 500)
			{
			var text_h = "500 km";
			var text_v = "100 km";

			if (me.unit_system == "imperial")
				{
				text_h = "270 nm";
				text_v = "54 nm";
				}
			me.horiz_scale.setText(text_h);
			me.vert_scale.setText(text_v);
			me.history.setVisible(1);
			if (me.plot_scale != SpaceShuttle.proximity_manager.plot_scale)
				{
				SpaceShuttle.proximity_manager.history_reset = 1;
				me.plot_scale = 500;
				}
			me.history_is_drawn = 0;
			me.an_rinc.setVisible(1);
			}
		else if (scale == 100)
			{
			var text_h = "100 km";
			var text_v = "30 km";

			if (me.unit_system == "imperial")
				{
				text_h = "54 nm";
				text_v = "16 nm";
				}
			me.horiz_scale.setText(text_h);
			me.vert_scale.setText(text_v);

			me.history.setVisible(1);
			me.an_alpha.setVisible(1);
			me.an_alpha_rate.setVisible(1);
			me.an_xdot.setVisible(0);
			me.an_ydot.setVisible(0);
			me.an_zdot.setVisible(0);
			if (me.plot_scale != SpaceShuttle.proximity_manager.plot_scale)
				{
				SpaceShuttle.proximity_manager.history_reset = 1;
				me.plot_scale = 100;
				}
			me.history_is_drawn = 0;
			me.an_rinc.setVisible(0);
			}
		else if (scale == 10)
			{
			var text_h = "10 km";
			var text_v = "5 km";

			if (me.unit_system == "imperial")
				{
				text_h = "28.7 kft";
				text_v = "14.3 kft";
				}
			me.horiz_scale.setText(text_h);
			me.vert_scale.setText(text_v);
			me.plot_scale = 10;
			me.history.setVisible(0);
			me.an_alpha.setVisible(0);
			me.an_alpha_rate.setVisible(0);
			me.an_xdot.setVisible(1);
			me.an_ydot.setVisible(1);
			me.an_zdot.setVisible(1);
			me.an_rinc.setVisible(0);
			me.an_xdot.formatFunction = func (value) {return sprintf("%1.1f", value);};	
			me.an_ydot.formatFunction = func (value) {return sprintf("%1.1f", value);};		
			me.an_zdot.formatFunction = func (value) {return sprintf("%1.1f", value);};
			me.an_prox_x.formatFunction = func (value) {return sprintf("%d", value);};	
			me.an_prox_y.formatFunction = func (value) {return sprintf("%d", value);};			
			me.an_prox_z.formatFunction = func (value) {return sprintf("%d", value);};					
			}
		else if (scale == 0.01)
			{
			var text_h = "10 m";
			var text_v = "5 m";

			if (me.unit_system == "imperial")
				{
				text_h = "28.7 ft";
				text_v = "14.3 ft";
				}
			me.horiz_scale.setText(text_h);
			me.vert_scale.setText(text_v);
			me.plot_scale = 0.01;
			me.history.setVisible(0);
			me.an_alpha.setVisible(0);
			me.an_alpha_rate.setVisible(0);
			me.an_xdot.setVisible(1);
			me.an_ydot.setVisible(1);
			me.an_zdot.setVisible(1);
			me.an_rinc.setVisible(0);
			me.an_xdot.formatFunction = func (value) {return sprintf("%1.2f", value);};	
			me.an_ydot.formatFunction = func (value) {return sprintf("%1.2f", value);};		
			me.an_zdot.formatFunction = func (value) {return sprintf("%1.2f", value);};
			me.an_prox_x.formatFunction = func (value) {return sprintf("%1.1f", value);};
			me.an_prox_y.formatFunction = func (value) {return sprintf("%1.1f", value);};	
			me.an_prox_z.formatFunction = func (value) {return sprintf("%1.1f", value);};		
			}

		else 
			{
			print ("Rendezvous Dialog: Plot scale not implemented!");
			}
		me.history_is_drawn = 0;
		me.draw_history();
		
	},


	update: func {

		if (me.update_loop_flag == 0) {return;}

		#print (SpaceShuttle.proximity_manager.plot_scale, " ", me.plot_scale);
		if (SpaceShuttle.proximity_manager.plot_scale != me.plot_scale)
			{
			me.set_scale (SpaceShuttle.proximity_manager.plot_scale);
			}

		me.ch_pos[0] =  getprop("/fdm/jsbsim/position/eci-x-ft") * 0.3048;
		me.ch_pos[1] =  getprop("/fdm/jsbsim/position/eci-y-ft") * 0.3048;
		me.ch_pos[2] =  getprop("/fdm/jsbsim/position/eci-z-ft") * 0.3048;
		
		me.ch_vel[0] = getprop("/fdm/jsbsim/velocities/eci-x-fps") * 0.3048; 
		me.ch_vel[1] = getprop("/fdm/jsbsim/velocities/eci-y-fps") * 0.3048; 
		me.ch_vel[2] = getprop("/fdm/jsbsim/velocities/eci-z-fps") * 0.3048; 


		if (SpaceShuttle.proximity_manager.iss_model == 0)
			{
			me.tgt_pos =  SpaceShuttle.oTgt.get_inertial_pos();
			me.compute_proximity();

			me.an_alpha_rate.setValue(0, me.alpha_dot);
			me.an_alpha.setValue(0, me.ang * 180.0/math.pi);	
			}
		else
			{
			me.target_prox_x = SpaceShuttle.proximity_manager.target_prox_x;
			me.target_prox_y = SpaceShuttle.proximity_manager.target_prox_y;
			me.target_prox_z = SpaceShuttle.proximity_manager.target_prox_z;

			me.target_prox_vx = SpaceShuttle.proximity_manager.target_prox_vx;
			me.target_prox_vy = SpaceShuttle.proximity_manager.target_prox_vy;
			me.target_prox_vz = SpaceShuttle.proximity_manager.target_prox_vz;

			me.an_xdot.setValue(0, me.target_prox_vx * me.conversion);
			me.an_ydot.setValue(0, me.target_prox_vy * me.conversion);
			me.an_zdot.setValue(0, me.target_prox_vz * me.conversion);

			
			}

		if (me.plot_scale == 500)
			{
			me.compute_rinc();
			me.an_rinc.setValue(0, me.rinc);
			}


		me.an_prox_x.setValue(0, me.target_prox_x * me.conversion);
		me.an_prox_y.setValue(0, me.target_prox_y * me.conversion);
		me.an_prox_z.setValue(0, me.target_prox_z * me.conversion);

		# display PC burn if needed


 		if (me.button_burn.index == 1)	
			{
			var string = "PC burn TIG: ";
			string=string~SpaceShuttle.proximity_manager.node_crossing_burn_time_string;
			string=string~" DY: ";
			string=string~sprintf("%2.1f", SpaceShuttle.proximity_manager.node_crossing_dy);
			me.an_burn.setText(string);
			}
		else
			{
			me.an_burn.setText("");
			}





			


		me.sym_shuttle.setTranslation(me.prox_x_to_x(me.target_prox_x), me.prox_z_to_y(me.target_prox_z));

		me.draw_history();

		settimer (func {me.update();}, 1.0);		

	},

	compute_proximity: func {

		me.ch_r = math.sqrt(math.pow(me.ch_pos[0], 2.0) + math.pow(me.ch_pos[1], 2.0) + math.pow(me.ch_pos[2],2.0));

		me.ch_pnorm[0] = me.ch_pos[0] / me.ch_r;
		me.ch_pnorm[1] = me.ch_pos[1] / me.ch_r;
		me.ch_pnorm[2] = me.ch_pos[2] / me.ch_r;

		#print ("Ch pnorm: ", me.ch_pnorm[0], " ", me.ch_pnorm[1], " " , me.ch_pnorm[2]);

		var norm_tmp = math.sqrt(math.pow(me.ch_vel[0], 2.0) + math.pow(me.ch_vel[1], 2.0) + math.pow(me.ch_vel[2],2.0));

		me.ch_vnorm[0] = me.ch_vel[0] / norm_tmp;
		me.ch_vnorm[1] = me.ch_vel[1] / norm_tmp;
		me.ch_vnorm[2] = me.ch_vel[2] / norm_tmp;

		#print ("Ch vnorm: ", me.ch_vnorm[0], " ", me.ch_vnorm[1], " " , me.ch_vnorm[2]);

		me.nnorm = SpaceShuttle.cross_product(me.ch_pnorm, me.ch_vnorm);
		
		me.tgt_r = math.sqrt(math.pow(me.tgt_pos[0], 2.0) + math.pow(me.tgt_pos[1], 2.0) + math.pow(me.tgt_pos[2],2.0));
		me.tgt_pnorm[0] = me.tgt_pos[0] / me.tgt_r;
		me.tgt_pnorm[1] = me.tgt_pos[1] / me.tgt_r;
		me.tgt_pnorm[2] = me.tgt_pos[2] / me.tgt_r;

		#print ("Tgt pnorm: ", me.tgt_pnorm[0], " ", me.tgt_pnorm[1], " " , me.tgt_pnorm[2]);

		var ang_xt = 0.5 * math.pi - math.acos(SpaceShuttle.dot_product(me.tgt_pnorm, me.nnorm));
		me.delta_ang = math.acos(SpaceShuttle.dot_product(me.ch_pnorm, me.tgt_pnorm));
	
		me.ang = math.acos(math.cos(me.delta_ang) / math.cos(ang_xt));

		var alpha_dot_tmp = (me.ang - me.ang_last) * 180.0/math.pi * 60.0;

		#print (alpha_dot_tmp);

		if (size(me.alpha_dot_array) < 20)
			{
			append(me.alpha_dot_array, alpha_dot_tmp);
			}
		else
			{
			me.alpha_dot_array = SpaceShuttle.delete_from_vector(me.alpha_dot_array,0);
			append(me.alpha_dot_array, alpha_dot_tmp);
			}

		me.alpha_dot = 0;

		for (var i=0; i< size(me.alpha_dot_array); i=i+1)
			{
			me.alpha_dot += me.alpha_dot_array[i];
			}
		me.alpha_dot /= size(me.alpha_dot_array);


		# me.alpha_dot = (me.ang - me.ang_last) * 180.0/math.pi * 60.0;
		me.ang_last = me.ang;
		var sign = 1.0;
		
		if (((me.tgt_pos[0] - me.ch_pos[0]) * me.ch_vnorm[0] + (me.tgt_pos[1] - me.ch_pos[1]) * me.ch_vnorm[1] + (me.tgt_pos[2] - me.ch_pos[2]) * me.ch_vnorm[2]) < 0.0)
			{
			sign = -1.0;
			}

		me.target_prox_x = sign * me.ang * me.ch_r;
		me.target_prox_y = -ang_xt * me.ch_r;
		me.target_prox_z = me.ch_r - me.tgt_r;




	},


	compute_rinc: func {

		if (me.rinc_compute_counter == 0)
			{
			me.tgt_vel =  SpaceShuttle.oTgt.get_inertial_speed();
			me.tgt_v = SpaceShuttle.norm(me.tgt_vel);
			me.tgt_vnorm[0] = me.tgt_vel[0]/me.tgt_v;
			me.tgt_vnorm[1] = me.tgt_vel[1]/me.tgt_v;
			me.tgt_vnorm[2] = me.tgt_vel[2]/me.tgt_v;


			var ch_plane_norm = getprop("/fdm/jsbsim/systems/orbital/plane-norm");
			var ch_plane_x = getprop("/fdm/jsbsim/systems/orbital/plane-x")*ch_plane_norm;
			var ch_plane_y = getprop("/fdm/jsbsim/systems/orbital/plane-y")*ch_plane_norm;
			var ch_plane_z = getprop("/fdm/jsbsim/systems/orbital/plane-z")*ch_plane_norm;


			var ch_plane = [ch_plane_x, ch_plane_y, ch_plane_z];
			var tgt_plane = SpaceShuttle.cross_product(me.tgt_pnorm, me.tgt_vnorm);

			#print ("CH plane: ", ch_plane[0], " ", ch_plane[1], " ", ch_plane[2]);
			#print ("TGT plane: ", tgt_plane[0], " ", tgt_plane[1], " ", tgt_plane[2]);
			#print ("Norms: ", SpaceShuttle.norm(ch_plane), " ", SpaceShuttle.norm (tgt_plane)); 

			me.rinc = math.acos(SpaceShuttle.dot_product(ch_plane, tgt_plane)) * 180.0/math.pi;
			}
		me.rinc_compute_counter+= 1;
		if (me.rinc_compute_counter == 10) {me.rinc_compute_counter = 0;}

	},


	compute_pc_burn: func {

		if (me.button_burn.index == 1)
			{SpaceShuttle.proximity_manager.force_node_check();}
		else
			{me.an_burn.setText("");}

	},

	prox_x_to_x: func (prox_x) {

		if (me.plot_scale == 500)
			{return prox_x / 1162.79 + 100.0;}
		else if (me.plot_scale == 100)
			{return prox_x / 232.55  + 100.0;}
		else if (me.plot_scale == 10)
			{return prox_x / 23.255  + 100.0;}
		else if (me.plot_scale == 0.01)
			{return prox_x / 0.023255  + 100.0;}


	
			

	},

	prox_z_to_y: func (prox_z) {

		if (me.plot_scale == 500)
			{return -prox_z /400.0 + 100.0;}
		else if (me.plot_scale == 100)
			{return -prox_z /120.0 + 100.0;}
		else if (me.plot_scale == 10)
			{return -prox_z /20.0 + 100.0;}
		else if (me.plot_scale == 0.01)
			{return -prox_z /0.020 + 100.0;}

	},

	symbol_draw: func (plot, data) # symbols are drawn as continuous shape
		{

		for (var i = 0; i< size(data) - 1; i=i+1)
			{
			var set = data[i+1]; 
			plot.lineTo(set[0], set[1]);
			}

		},


	draw_history: func {

		if (SpaceShuttle.proximity_manager.history_available == 0) {return;}

		if (me.history_is_drawn == 1)
			{
			me.history_draw_counter = me.history_draw_counter + 1;
			if (me.history_draw_counter == 30) 
				{
				me.history_draw_counter = 0;
				me.history_is_drawn = 0;
				}
			return;
			}

		#print ("History draw command!");

		me.history.removeAllChildren();


		var data = [];
		
		if (size(SpaceShuttle.proximity_manager.prox_history) < 3) {return;}

		for (var i=0; i< size(SpaceShuttle.proximity_manager.prox_history); i=i+1)
			{
			append(data, [me.prox_x_to_x(SpaceShuttle.proximity_manager.prox_history[i][0]), me.prox_z_to_y(SpaceShuttle.proximity_manager.prox_history[i][1]), 1]);
				
			}


		me.history_plot = me.history.createChild("path", "History")
                        .setStrokeLineWidth(2)
                        .setColor(0,0,0)
                        .moveTo(data[0][0],data[0][1]); 

		me.symbol_draw(me.history_plot, data);

		me.history_is_drawn = 1;

	},

	switch_units: func {


		if (me.unit_system == "SI")
			{
			me.length_unit = "ft";
			me.speed_unit = "ft/s";
			me.conversion = 1./0.3048;	
			me.unit_system = "imperial";
			me.an_prox_x.setUnit(" ft");
			me.an_prox_y.setUnit(" ft");
			me.an_prox_z.setUnit(" ft");
			me.an_xdot.setUnit(" ft/s");
			me.an_ydot.setUnit(" ft/s");
			me.an_zdot.setUnit(" ft/s");
			}
		else
			{
			me.length_unit = "m";
			me.speed_unit = "ft/s";
			me.conversion = 1.0;
			me.unit_system = "SI";
			me.an_prox_x.setUnit(" m");
			me.an_prox_y.setUnit(" m");
			me.an_prox_z.setUnit(" m");
			me.an_xdot.setUnit(" m/s");
			me.an_ydot.setUnit(" m/s");
			me.an_zdot.setUnit(" m/s");
			}

	me.set_scale(me.plot_scale);

	},

};
