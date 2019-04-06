

# class to create a ground trajectory display for spacecraft
# Thorsten Renk 2018



var cdlg_traj_map = {

	update_loop_flag: 0,
	task_group: 0,
	lat: 0.0,
	lon: 0.0,
	earth_motion_deg_s: 0.00417807462088067,
	earth_radius_m: 6378138.12,
	
	num_points_prediction: 36,
	num_points_horizon: 0,

	trajectory_draw_counter: 0,
	trajectory_is_drawn: 0,

	horizon_draw_counter: 0,
	horizon_is_drawn: 0,

	history_draw_counter: 0,
	history_is_drawn: 0,
	history_draw_flag: 0,

	com_site_flag: 0,
	comsites_are_drawn: 0,

	land_site_flag: 0,
	land_sites_are_drawn: 0,

	MET: 0,

	init: func {

		if (me.update_loop_flag == 1) {return;}

		me.window = canvas.Window.new([900,450],"dialog").set("title", "Trajectory Map");

		me.window.del = func()
			{
		  	SpaceShuttle.cdlg_traj_map.update_loop_flag = 0;
			removelistener(SpaceShuttle.cdlg_traj_map.listener1);
			removelistener(SpaceShuttle.cdlg_traj_map.listener2);
		  	call(canvas.Window.del, [], me);
			};

		me.mapCanvas = me.window.createCanvas().set("background", canvas.style.getColor("bg_color"));
		me.root = me.mapCanvas.createGroup();


		var path = "Aircraft/SpaceShuttle/Dialogs/MapOfEarth.png";
		me.map_image=me.root.createChild("image")
                                   .setFile( path )
                                   .setTranslation(0,0)
                                   .setSize(900,450);

		# symbols

		me.symbols = me.root.createChild("group", "Symbols");

		var data = SpaceShuttle.draw_shuttle_top();
		
	 	me.sym_shuttle = me.symbols.createChild("path", "shuttle")
        	.setStrokeLineWidth(0.25)
        	.setColor(0.0, 0.0, 0.0)
		.moveTo(data[0][0], data[0][1]);

		me.symbol_draw (me.sym_shuttle, data, 0);
		me.sym_shuttle.setScale(5.0);


		data =  SpaceShuttle.draw_circle(8, 10);

	 	me.sym_sel_landing_site = me.symbols.createChild("path", "landing site")
        	.setStrokeLineWidth(2.0)
        	.setColor(1.0, 0.0, 0.0)
		.moveTo(data[0][0], data[0][1]);

		me.symbol_draw (me.sym_sel_landing_site, data, 0);

		data =  SpaceShuttle.draw_circle(3, 6);

	 	me.sym_sel_landing_site_inner = me.symbols.createChild("path", "landing site")
        	.setStrokeLineWidth(2.0)
        	.setColor(1.0, 0.0, 0.0)
		.setColorFill(1.0, 0.0, 0.0)
		.moveTo(data[0][0], data[0][1]);

		me.symbol_draw (me.sym_sel_landing_site_inner, data, 0);

		me.update_landing_site();

		data =  SpaceShuttle.draw_circle(4, 8);

	 	me.sym_oms_burn = me.symbols.createChild("path", "OMS burn")
        	.setStrokeLineWidth(2.0)
        	.setColor(0.0, 0.0, 0.0)
		.setColorFill(0.0, 0.0, 0.0)
		.moveTo(data[0][0], data[0][1]);

		me.symbol_draw (me.sym_oms_burn, data, 0);
		me.sym_oms_burn.setVisible(0);

		me.sym_oms_burn_label = me.symbols.createChild("text")
			.setText("")
			.setColor(0.0, 0.0, 0.0)
			.setFontSize(14)
			.setFont("LiberationFonts/LiberationMono-Regular.ttf")
			.setAlignment("left-center");
		me.sym_oms_burn_label.setVisible(0);

		data =  SpaceShuttle.draw_circle(4, 8);

		me.sym_otgt = me.symbols.createChild("group", "Targets");
		me.sym_otgt_sym = me.sym_otgt.createChild("path", "Target symbol")
        	.setStrokeLineWidth(2.0)
        	.setColor(0.0, 0.0, 0.0)
		.setColorFill(0.0, 0.0, 0.0)
		.moveTo(data[0][0], data[0][1]);

		me.symbol_draw (me.sym_otgt_sym, data, 0);

		me.sym_otgt_label = me.sym_otgt.createChild("text")
			.setText(SpaceShuttle.oTgt.label)
			.setColor(0.0, 0.0, 0.0)
			.setFontSize(14)
			.setFont("LiberationFonts/LiberationMono-Regular.ttf")
			.setAlignment("left-center");
		me.sym_otgt_label.setTranslation(5,0);

		if (SpaceShuttle.n_orbital_targets > 0) 
			{me.sym_otgt.setVisible(1);}
		else
			{me.sym_otgt.setVisible(0);}

		# alphanumerics

		me.alphanumerics = me.root.createChild("group", "Alphanumerics");

		data = SpaceShuttle.draw_rect(350,50);

	 	me.an_bg = me.symbols.createChild("path", "Alphanumerics background")
        	.setStrokeLineWidth(1.0)
        	.setColor(1.0, 1.0, 1.0, 1.0)
		.setColorFill(1.0, 1.0, 1.0, 0.5)
		.moveTo(data[0][0], data[0][1]);

		me.symbol_draw (me.an_bg, data, 0);

		me.an_bg.setTranslation(700, 60);


		me.an_met = me.alphanumerics.createChild("text")
			.setText("")
			.setColor(0.0, 0.0, 0.0)
			.setFontSize(14)
			.setFont("LiberationFonts/LiberationMono-Regular.ttf")
			.setTranslation(550, 50)
			.setAlignment("left-center");

		me.an_landing_site = me.alphanumerics.createChild("text")
			.setText("")
			.setColor(0.0, 0.0, 0.0)
			.setFontSize(14)
			.setFont("LiberationFonts/LiberationMono-Regular.ttf")
			.setTranslation(550, 70)
			.setAlignment("left-center");



		# graphs

		me.graphs = me.root.createChild("group", "Graphs");
		me.horizon = me.root.createChild("group", "Horizon");
		me.comsites = me.root.createChild("group", "Comsites");
		me.landsites = me.root.createChild("group", "Landing Sites");
		me.history = me.root.createChild("group", "History");

		# buttons

		var stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/TrajectoryMap/prediction_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/TrajectoryMap/prediction_1.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/TrajectoryMap/prediction_2.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/TrajectoryMap/prediction_3.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/TrajectoryMap/prediction_4.png");

		me.button_prediction = cdlg_widget_img_stack.new(me.root, stack, 126, 42);
		me.button_prediction.setTranslation(40,400);
		me.button_prediction.increment();
		me.button_prediction.f = func {
		
			if (me.index == 0)
				{SpaceShuttle.cdlg_traj_map.num_points_prediction = 0;}
			else if (me.index == 1)
				{SpaceShuttle.cdlg_traj_map.num_points_prediction = 36;}
			else if (me.index == 2)
				{SpaceShuttle.cdlg_traj_map.num_points_prediction = 64;}
			else if (me.index == 3)
				{SpaceShuttle.cdlg_traj_map.num_points_prediction = 72;}
			else if (me.index == 4)
				{SpaceShuttle.cdlg_traj_map.num_points_prediction = 108;}

			SpaceShuttle.cdlg_traj_map.trajectory_is_drawn = 0;
		};

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/TrajectoryMap/horizon_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/TrajectoryMap/horizon_1.png");
		

		me.button_horizon = cdlg_widget_img_stack.new(me.root, stack, 126, 42);
		me.button_horizon.setTranslation(220,400);
		me.button_horizon.increment();
		me.button_horizon.f = func {
		
			if (me.index == 0)
				{SpaceShuttle.cdlg_traj_map.num_points_horizon = 20;}
			else if (me.index == 1)
				{SpaceShuttle.cdlg_traj_map.num_points_horizon = 0;}

			SpaceShuttle.cdlg_traj_map.horizon_is_drawn = 0;
		};


		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/TrajectoryMap/comsites_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/TrajectoryMap/comsites_1.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/TrajectoryMap/comsites_2.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/TrajectoryMap/comsites_3.png");
		

		me.button_comsites = cdlg_widget_img_stack.new(me.root, stack, 126, 42);
		me.button_comsites.setTranslation(400,400);
		me.button_comsites.f = func {
		
			SpaceShuttle.cdlg_traj_map.com_site_flag = me.index;
			SpaceShuttle.cdlg_traj_map.comsites_are_drawn = 0;
		};

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/TrajectoryMap/landing_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/TrajectoryMap/landing_1.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/TrajectoryMap/landing_2.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/TrajectoryMap/landing_3.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/TrajectoryMap/landing_4.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/TrajectoryMap/landing_5.png");
		
		me.button_landsites = cdlg_widget_img_stack.new(me.root, stack, 126, 42);
		me.button_landsites.setTranslation(580,400);
		me.button_landsites.f = func {
		
			SpaceShuttle.cdlg_traj_map.land_site_flag = me.index;
			SpaceShuttle.cdlg_traj_map.land_sites_are_drawn = 0;
		};

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/TrajectoryMap/history_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/TrajectoryMap/history_1.png");

		me.button_history = cdlg_widget_img_stack.new(me.root, stack, 126, 42);
		me.button_history.setTranslation(760,400);
		me.button_history.f = func {
		
			SpaceShuttle.cdlg_traj_map.history_draw_flag = me.index;
			SpaceShuttle.cdlg_traj_map.history_is_drawn = 0;
		};

		# listeners

		me.listener1 = setlistener("/sim/gui/dialogs/SpaceShuttle/entry_guidance/runway", func {

			me.update_landing_site();  

			});

		me.listener2 = setlistener("/fdm/jsbsim/systems/ap/oms-plan/burn-plan-available", func {

			if (getprop("/fdm/jsbsim/systems/ap/oms-plan/burn-plan-available") == 1)
				{
				me.show_burn(1);
				}
			else
				{
				me.show_burn(0);
				}

			});





		me.update_loop_flag = 1;
		me.update();


		},


	update: func {

		if (me.update_loop_flag == 0) {return;}

		me.lat = getprop("/position/latitude-deg");
		me.lon = getprop("/position/longitude-deg");

		var x =  me.lon_to_x(me.lon);
		var y =  me.lat_to_y(me.lat);

		var heading = getprop("/orientation/heading-deg") * 3.1415/180.0;

		#print (x, " ", y);

		me.sym_shuttle.setTranslation(x,y);
		me.sym_shuttle.setRotation(heading);

		me.MET = getprop("/sim/time/elapsed-sec") + getprop("/fdm/jsbsim/systems/timer/delta-MET");


		if (SpaceShuttle.n_orbital_targets > 0)
			{

			var lla = SpaceShuttle.oTgt.get_latlonalt();
			x = me.lon_to_x(lla[1]);
			y = me.lat_to_y(lla[0]);
			me.sym_otgt.setTranslation(x,y);
			me.sym_otgt.setVisible(1);

			}


		# task groups

		if (me.task_group == 0)
			{
			me.task_predict_traj();
			}
		else if (me.task_group == 1)
			{
			me.task_horizon();
			}
		else if (me.task_group == 2)
			{
			me.task_comsites();
			}
		else if (me.task_group == 3)
			{
			me.task_landsites();
			}
		else if (me.task_group == 4)
			{
			me.task_alphanumerics();
			}
		else if (me.task_group == 5)
			{
			me.task_history();
			}
		


		me.task_group = me.task_group + 1;
		if (me.task_group == 10) {me.task_group = 0;}

		settimer (func {me.update();}, 0.1);		

		},



	task_predict_traj: func {

		if (me.trajectory_is_drawn == 1)
			{
			me.trajectory_draw_counter = me.trajectory_draw_counter + 1;
			if (me.trajectory_draw_counter == 10) 
				{
				me.trajectory_draw_counter = 0;
				me.trajectory_is_drawn = 0;
				}
			return;
			}

		var apoapsis_alt = getprop("/fdm/jsbsim/systems/orbital/apoapsis-ft");

		if (apoapsis_alt < 400000.0) {return;}


		#print ("Trajectory prediction");
		
		var course = getprop("/fdm/jsbsim/velocities/course-deg");
		var dist_inc = 1113162.27244333;

		var eccentricity = getprop("/fdm/jsbsim/systems/orbital/eccentricity");
		var true_anomaly = getprop("/fdm/jsbsim/systems/orbital/true-anomaly-rad");
		var mean_anomaly = me.true_to_mean (true_anomaly, eccentricity);
		var orbital_period = getprop("/fdm/jsbsim/systems/orbital/orbital-period-s");
		var periapsis_alt = getprop("/fdm/jsbsim/systems/orbital/periapsis-ft");


		var time_inc = orbital_period / 36.0;
		var anomaly_inc = 2.0 * math.pi/ 36.0;

		var predCoord = geo.Coord.new();
		predCoord.set_latlon(me.lat, me.lon);

		var dist = 0.0;
		var pred_anomaly = 0.0;
		var pred_time = 0.0;
		var pred_alt = 0.0;


		var data = [];

		if (periapsis_alt > 450000.0)
			{
			for (var i=0; i< me.num_points_prediction; i=i+1)
				{

				predCoord.set_latlon(me.lat, me.lon);		
				SpaceShuttle.sgeo_move_circle(course, i * dist_inc, predCoord);
		
				var set = [0,0,1];


				set[0] = predCoord.lon();
				set[1] = predCoord.lat();

				pred_anomaly = true_anomaly + i * anomaly_inc;
				pred_anomaly = me.true_to_mean(pred_anomaly, eccentricity) - mean_anomaly;

				pred_time = pred_anomaly / (2.0 * math.pi) * orbital_period;
			



				set[0] = set[0] - pred_time * me.earth_motion_deg_s;


				set[0] = me.lon_to_x(set[0]);
				set[1] = me.lat_to_y(set[1]);
			
				append(data, set);
				}
			}
		else 
			{

			var semimajor = getprop("/fdm/jsbsim/systems/orbital/semimajor-axis-length-ft");
			var dash_flag = 2;

			for (var i=0; i< 144; i=i+1)
				{
	
				predCoord.set_latlon(me.lat, me.lon);		
				SpaceShuttle.sgeo_move_circle(course, i * dist_inc * 0.25, predCoord);
		
				var set = [0,0,1];


				set[0] = predCoord.lon();
				set[1] = predCoord.lat();

				pred_anomaly = true_anomaly + i * 0.25 * anomaly_inc;
		
				pred_alt = semimajor * (1.0 - math.pow(eccentricity, 2.0))/(1.0 + eccentricity * math.cos(pred_anomaly));
				pred_alt = pred_alt - SpaceShuttle.geoid_radius(set[1])/0.3048;

				if (i==0) {print ("Current altitude should be about: ", pred_alt);}

				if (pred_alt < 0.0) {break;}

				if (pred_alt < 400000.0)
					{
					if (dash_flag == 2) {dash_flag = 1;}
					else if (dash_flag == 1) {dash_flag = 0;} 
					else {dash_flag = 1;}
					}

				pred_anomaly = me.true_to_mean(pred_anomaly, eccentricity) - mean_anomaly;

				pred_time = pred_anomaly / (2.0 * math.pi) * orbital_period;
			



				set[0] = set[0] - pred_time * me.earth_motion_deg_s;


				set[0] = me.lon_to_x(set[0]);
				set[1] = me.lat_to_y(set[1]);
				if (dash_flag > 0) {set[2] = 1;} else {set[2] = 0;}

			
				append(data, set);
				}


			}


		me.graphs.removeAllChildren();

		if (me.num_points_prediction == 0) {return;}

		me.prediction_plot = me.graphs.createChild("path", "Prediction")
                        .setStrokeLineWidth(2)
                        .setColor(1,0,0)
                        .moveTo(data[0][0],data[0][1]); 

		me.trajectory_draw(me.prediction_plot, data);
		me.trajectory_is_drawn = 1;

		},

	task_horizon: func {


		if (me.horizon_is_drawn == 1)
			{
			me.horizon_draw_counter = me.horizon_draw_counter + 1;
			if (me.horizon_draw_counter == 10) 
				{
				me.horizon_draw_counter = 0;
				me.horizon_is_drawn = 0;
				}
			return;
			}

		var altitude = getprop("/position/altitude-ft") * 0.3048;		

		var horizon_distance = math.sqrt(2.0 * me.earth_radius_m * altitude + math.pow(altitude, 2.0));
		
		var data = [];
		var horizCoord = geo.Coord.new();
		
		for (var i=0; i< me.num_points_horizon; i=i+1)
			{
			horizCoord.set_latlon(me.lat, me.lon);	
			course = i * 360./ me.num_points_horizon;

			SpaceShuttle.sgeo_move_circle(course, horizon_distance, horizCoord);

			var set = [0,0,1];
			set[0] = horizCoord.lon();
			set[1] = horizCoord.lat();

			set[0] = me.lon_to_x(set[0]);
			set[1] = me.lat_to_y(set[1]);
			
			append(data, set);
			}
		


		me.horizon.removeAllChildren();

		if (me.num_points_horizon == 0) {return;}

		var set = [data[0][0], data[0][1], 1];
		append(data, set);

		me.horizon_plot = me.horizon.createChild("path", "Horizon")
                        .setStrokeLineWidth(2)
                        .setColor(0,0,1)
                        .moveTo(data[0][0],data[0][1]); 

		me.trajectory_draw(me.horizon_plot, data);


		},


	task_comsites: func {

		if (me.comsites_are_drawn == 1) {return;}
		
		me.comsites.removeAllChildren();

		var data = SpaceShuttle.draw_circle(3, 6);

		for (var i=0; i< size(SpaceShuttle.com_ground_site_array); i=i+1)
			{

			var mode = SpaceShuttle.com_ground_site_array[i].mode;

			if (((me.com_site_flag == 1) and (mode == "STDN")) or ((me.com_site_flag == 2) and (mode == "SGLS")) or (me.com_site_flag == 3))
				{
				var site_sym = me.comsites.createChild("path", "Site")
		                .setStrokeLineWidth(2)
		                .setColor(1,0,0)
				.setColorFill(1,0,0)
		                .moveTo(data[0][0],data[0][1]);

				me.symbol_draw(site_sym, data);

				var x = me.lon_to_x(SpaceShuttle.com_ground_site_array[i].coord.lon());
				var y = me.lat_to_y(SpaceShuttle.com_ground_site_array[i].coord.lat());

				var text = SpaceShuttle.com_ground_site_array[i].string;


				var site_label = me.comsites.createChild("text")
				      	.setText(text)
					.setColor(0.0, 0.0, 0.0)
					.setFontSize(14)
					.setFont("LiberationFonts/LiberationMono-Bold.ttf")
					.setAlignment("left-center");

				site_sym.setTranslation(x,y);
				site_label.setTranslation(x+6, y);
				}
			}


		me.comsites_are_drawn = 1;
	},



	task_landsites: func {

		if (me.land_sites_are_drawn == 1) {return;}
		
		me.landsites.removeAllChildren();

		if (me.land_site_flag == 0) {return;}

		var data = SpaceShuttle.draw_circle(3, 6);

		for (var i=0; i< size(SpaceShuttle.landing_site_array); i=i+1)
			{

			var draw_flag = 0;
			var function = SpaceShuttle.landing_site_array[i].function;

			if ((me.land_site_flag == 1) and (function == "regular")) {draw_flag = 1;}
			else if ((me.land_site_flag == 2) and (function == "TAL")) {draw_flag = 1;}
			else if ((me.land_site_flag == 3) and (function == "ECAL")) {draw_flag = 1;}
			else if ((me.land_site_flag == 4) and (function == "emergency")) {draw_flag = 1;}
			else if (me.land_site_flag == 5) {draw_flag = 1;}

			if (draw_flag == 1)		
				{
				var site_sym = me.landsites.createChild("path", "Site")
				       .setStrokeLineWidth(2)
				       .setColor(1,0,0)
				       .setColorFill(1,0,0)
				       .moveTo(data[0][0],data[0][1]);

				me.symbol_draw(site_sym, data);

				var x = me.lon_to_x(SpaceShuttle.landing_site_array[i].coord.lon());
				var y = me.lat_to_y(SpaceShuttle.landing_site_array[i].coord.lat());

				var text = SpaceShuttle.landing_site_array[i].shortname;
				var offset = SpaceShuttle.landing_site_array[i].text_vertical_offset;

				var site_label = me.landsites.createChild("text")
				 	.setText(text)
					.setColor(0.0, 0.0, 0.0)
					.setFontSize(14)
					.setFont("LiberationFonts/LiberationMono-Regular.ttf")
					.setAlignment("left-center");

				site_sym.setTranslation(x,y);
				site_label.setTranslation(x+6, y + offset);
				}
				
			}


		me.land_sites_are_drawn = 1;
	},


	update_landing_site: func {

		#print ("Listener firing");

		settimer( func {

		var x = me.lon_to_x(SpaceShuttle.landing_site.lon());
		var y = me.lat_to_y(SpaceShuttle.landing_site.lat());

		me.sym_sel_landing_site.setTranslation(x,y);
		me.sym_sel_landing_site_inner.setTranslation(x,y);

		}, 0.1);


	},

	task_alphanumerics: func {

		me.an_met.setText("MET: "~SpaceShuttle.seconds_to_stringDHMS(me.MET));
		me.an_landing_site.setText("Landing site:"~getprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site"));

	},

	task_history: func {


		if (me.history_is_drawn == 1)
			{
			me.history_draw_counter = me.history_draw_counter + 1;
			if (me.history_draw_counter == 25) 
				{
				me.history_draw_counter = 0;
				me.history_is_drawn = 0;
				}
			return;
			}


		me.history.removeAllChildren();

		if (me.history_draw_flag == 0) {return;}

		var data = [];
		var skip_flag = 0;

		for (var i=0; i< size(SpaceShuttle.history); i=i+1)
			{
			
			if ((i< 5) or (i > size (SpaceShuttle.history) - 5))			
				{
				skip_flag = 0;
				}
			else 
				{
				skip_flag = skip_flag + 1;
				if (skip_flag == 5) {skip_flag = 0;}
				}

			if (skip_flag == 0)
				{
				append(data, [me.lon_to_x(SpaceShuttle.history[i][0]), me.lat_to_y(SpaceShuttle.history[i][1]), 1]);
				}

			}


		me.history_plot = me.history.createChild("path", "History")
                        .setStrokeLineWidth(2)
                        .setColor(0,0,1)
                        .moveTo(data[0][0],data[0][1]); 

		me.trajectory_draw(me.history_plot, data);

		me.history_is_drawn = 1;


	},


	show_burn: func (flag) {


		print ("OMS burn routines");

		if (flag == 0)
			{
			me.sym_oms_burn.setVisible(0);
			me.sym_oms_burn_label.setVisible(0);
			me.sym_oms_burn_label.setText("");
			}
		else
			{

			var tig = SpaceShuttle.oms_burn_target.tig;

			
			if (tig - me.MET < 0) {return;}

			var orbital_period = getprop("/fdm/jsbsim/systems/orbital/orbital-period-s");

			var ang_to_burn = 2.0 * math.pi * (tig - me.MET)/orbital_period;

			var true_anomaly = getprop("/fdm/jsbsim/systems/orbital/true-anomaly-rad");
			var eccentricity = getprop("/fdm/jsbsim/systems/orbital/eccentricity");
			var mean_anomaly = me.true_to_mean (true_anomaly, eccentricity);
			var course = getprop("/fdm/jsbsim/velocities/course-deg");
			
			mean_anomaly = mean_anomaly + ang_to_burn;
			var true_anomaly_delta = me.mean_to_true(mean_anomaly, eccentricity) - true_anomaly;

			

			var burnCoord = geo.Coord.new();

			burnCoord.set_latlon(me.lat, me.lon);		
			SpaceShuttle.sgeo_move_circle(course, true_anomaly_delta * me.earth_radius_m , burnCoord);
		
			var x = me.lon_to_x (burnCoord.lon() - (tig-me.MET) * me.earth_motion_deg_s);
			var y = me.lat_to_y (burnCoord.lat());

			me.sym_oms_burn.setVisible(1);
			me.sym_oms_burn.setTranslation(x,y);

			me.sym_oms_burn_label.setVisible(1);
			me.sym_oms_burn_label.setTranslation(x + 7.0,y);
			
			me.sym_oms_burn_label.setText("TIG: "~getprop("/fdm/jsbsim/systems/ap/oms-plan/tig-string"));

			}

	},



	symbol_draw: func (plot, data) # symbols are drawn as continuous shape
		{

		for (var i = 0; i< size(data) - 1; i=i+1)
			{
			var set = data[i+1]; 
			plot.lineTo(set[0], set[1]);
			}

		},

	trajectory_draw: func (plot, data) # trajectories need to skip boundaries
		{

		var draw_flag = 0;


		for (var i = 0; i< size(data) - 1; i=i+1)
			{
			var set = data[i+1]; 

			draw_flag = 0;

			if ((data[i][0] > 700.0) and (data[i+1][0] < 200.0))
				{draw_flag = 1;}
			else if ((data[i][0] < 200.0) and (data[i+1][0] > 700.0))
				{draw_flag = -1;}


			if (draw_flag == 0)
				{
				if (set[2] == 1)
					{
					plot.lineTo(set[0], set[1]);
					}
				else
					{
					plot.moveTo(set[0], set[1]);
					}
				}
			else if (draw_flag == 1)
				{
				plot.lineTo( 900.0 + set[0], set[1]);
				plot.moveTo(set[0], set[1]);
				}
			else if (draw_flag == -1)
				{
				plot.lineTo(set[0] - 900.0, set[1]);
				plot.moveTo(set[0], set[1]);
				}
			}

		},
	

	lat_to_y: func (lat) {

		return 225.0 - lat /90. * 225.0;
		},

	lon_to_x: func (lon) {

		if (lon < -180.0) {lon = lon + 360.0;}
		return 450.0 + lon /180. * 450.0;
		},

	mean_to_true: func (M, e) {

		# computes the true anomaly given the mean anomaly M and eccentricity e in a power series		

		var res = M;
		res = res + (2.0 * e - 0.25 * math.pow(e, 3.0)) * math.sin(M);
		res = res + 1.2 * math.pow(e,2.0) * math.sin(2.0 * M);
		res = res + 1.0833333 * math.pow(e,3.0) * math.sin(3.0 * M);

		return res;
		},

	true_to_mean: func (n, e) {

		var M = n;
		M = M - 2.0 * e * math.sin(n);
		M = M + (0.75 * math.pow(e, 2.0) + 0.125 * math.pow(e,4.0)) * math.sin(2.0 * n);
		M = M - 0.33333 * math.pow(e,3.0) * math.sin(3.0 * n);

		return M;
		},



};
