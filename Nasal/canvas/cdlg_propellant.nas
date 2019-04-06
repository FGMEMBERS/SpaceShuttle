var cdlg_propellant = {

	update_flag:  0,
	child_update_flag: 0,
	child_open_flag: 0,
	child_system_flag: -1,
	dlg_flag: 0,
	current_major_mode: 0,


	left_srb: {},
	right_srb: {},
	et: {},

	left_srb_label: {},
	right_srb_label: {},
	et_label: {},

	clickspots: [],		
	clickspots_child: [],

	

	init: func {

		var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");


		var width = 0.0;
		var height = 0.0;
		var img_path = "";

		if (me.update_flag == 1) {return;}

		if ((major_mode == 101) or (major_mode == 102) or (major_mode == 103))
			{
			width = 256;
			height = 512;
			img_path = "Aircraft/SpaceShuttle/Dialogs/propellant_launch.png";
			me.dlg_flag = 0;
			}
		else
			{
			width = 430;
			height = 616;
			img_path = "Aircraft/SpaceShuttle/Dialogs/orbiter_top.png";
			me.dlg_flag = 1;
			}			



		var window = canvas.Window.new([width,height],"dialog").set("title", "Propellant");

		# we need to explicitly re-define this to get a handle to stop the update loop
		# upon closing the window

		window.del = func()
		{
		  #print("Cleaning up...\n");
		  SpaceShuttle.cdlg_propellant.update_flag = 0;
		  call(canvas.Window.del, [], me);
		};


		var prpltCanvas = window.createCanvas().set("background", canvas.style.getColor("bg_color"));
		me.root = prpltCanvas.createGroup();
		var child=me.root.createChild("image")
				                   .setFile(img_path )
				                   .setTranslation(0,0)
				                   .setSize(width,height);

		me.root.addEventListener("click", func(e) {


		me.check_clickspots(e.clientX, e.clientY, "click");
			
		  });



		if (me.dlg_flag == 0) 
			{
			me.init_launch_dlg();
			}
		else
			{
			me.init_orbit_dlg();
			}

		},

	check_clickspots: func (click_x, click_y, event) {


		var flag = 0;			
		for (var i =0; i< size(me.clickspots); i=i+1)
			{
			#print ("Checking clickspot ", i);

			if (me.dlg_flag == me.clickspots[i].tab)
				{
				flag = me.clickspots[i].check_event(click_x, click_y);
				if (flag == 1) {break;}
				}
			}
			if (flag == 1)
				{
				#print ("Click event for spot ", i);

				me.clickspot_events(i, event);
				}

	},

	clickspot_events: func (system, event) {

		if (event == "click")
			{
			
			if (system < 6)
				{
				me.init_secondary_dlg(system);
				}

			}		
	},

	check_clickspots_child: func (event, e) {


		var flag = 0;			
		for (var i =0; i< size(me.clickspots_child); i=i+1)
			{
			#print ("Checking child clickspot ", i);

			if (me.dlg_flag == me.clickspots_child[i].tab)
				{
				flag = me.clickspots_child[i].check_event(e.clientX, e.clientY);
				if (flag == 1) {break;}
				}
			}
			if (flag == 1)
				{
				#print ("Click event for child spot ", i);
				
				if ((event == "click") or (event == "wheel"))
					{me.clickspot_events_child(i, event, me.clickspots_child[i].get_fraction_up(), e.deltaY);}

				}

	},

	clickspot_events_child: func (system, event, fraction, deltaY) {

		#print ("Executing clickspot event for ", event);

		if (event == "click")
			{
			me.set_fuel_fraction(me.child_system_flag, system, fraction);	
			}	

		else if (event == "wheel")
			{
			var current_fraction = me.get_fuel_fraction(me.child_system_flag, system);
			me.set_fuel_fraction(me.child_system_flag, system, current_fraction + 0.01 * deltaY);
			}
	},



	process_context_help: func (event) {

		if (event == "mouseover")
			{
			SpaceShuttle.cdlg_propellant.context_help_text.setText("Click to open detail dialog");
			}		
		else if (event == "mouseout")
			{
			SpaceShuttle.cdlg_propellant.context_help_text.setText("");
			}
	
	},

	process_context_help_child: func (event) {

		#print ("Context help function called with event ", event);

		if (event == "mouseover")
			{
			SpaceShuttle.cdlg_propellant.child_context_help_text.setText("Click/Mousewheel to adjust level");
			}		
		else if (event == "mouseout")
			{
			SpaceShuttle.cdlg_propellant.child_context_help_text.setText("");
			}
		
	},


	init_launch_dlg: func {

		var outer_color = [0.2, 0.2, 0.2, 0.7];
		var fill_color = [0.7, 0.7, 0.7,0.7];
		var text_color = [0,0,0];

		me.left_srb = cdlg_widget_box.new(me.root, 30, 350, outer_color, fill_color);
		me.left_srb.setTranslation(71,460);

		me.right_srb = cdlg_widget_box.new(me.root, 30, 350, outer_color, fill_color);
		me.right_srb.setTranslation(189,460);

		me.left_srb_label = cdlg_widget_property_label.new(me.root, "100%", text_color, outer_color, fill_color);
		me.left_srb_label.setTranslation(70, 100);

		me.right_srb_label = cdlg_widget_property_label.new(me.root, "100%", text_color, outer_color, fill_color);
		me.right_srb_label.setTranslation(185, 100);

		fill_color = [0.7, 0.5, 0.4,0.7];

		me.et = cdlg_widget_box.new(me.root, 70, 350, outer_color, fill_color);
		me.et.setTranslation(130,430);

		me.et_label = cdlg_widget_property_label.new(me.root, "100%", text_color, outer_color, fill_color);
		me.et_label.setTranslation(130, 70);



		me.update_flag = 1;
		me.update_launch_dlg();

	},

	update_launch_dlg: func {

		if (me.update_flag == 0) {return;}

		#print ("Running..");

		var content_srb1 = getprop("/consumables/fuel/tank[1]/level-lbs") /1114092.6;
		var content_srb2 = getprop("/consumables/fuel/tank[2]/level-lbs") /1114092.6;
		var content_et = getprop("/consumables/fuel/tank[0]/level-lbs") /1618634.0;

		me.left_srb_label.updateText(int (content_srb1 * 100.0) ~"%");
		me.right_srb_label.updateText(int (content_srb2 * 100.0) ~"%");
		me.et_label.updateText(int (content_et * 100.0) ~"%");

		me.left_srb.setPercentageHt(content_srb1);
		me.right_srb.setPercentageHt(content_srb2);
		me.et.setPercentageHt(content_et);

		settimer (func {me.update_launch_dlg();}, 0.1);		
		

	},


	init_orbit_dlg: func {

		var outer_color = [0.2, 0.2, 0.2, 0.7];
		var fill_color = [0.7, 0.7, 0.7,0.7];
		var text_color = [0,0,0];

		# OMS tanks

		me.left_oms = cdlg_widget_tank.new(me.root, 40, outer_color, fill_color);
		me.left_oms.setTranslation(130,450);

		me.left_oms_text = cdlg_widget_property_label.new(me.root, "Right OMS", text_color, outer_color, fill_color);
		me.left_oms_text.setTranslation(300, 402);

		me.left_oms_label = cdlg_widget_property_label.new(me.root, "100%", text_color, outer_color, fill_color);
		me.left_oms_label.setTranslation(60, 458.5);


		me.right_oms = cdlg_widget_tank.new(me.root, 40, outer_color, fill_color);
		me.right_oms.setTranslation(300,450);

		me.right_oms_text = cdlg_widget_property_label.new(me.root, "Left OMS", text_color, outer_color, fill_color);
		me.right_oms_text.setTranslation(130, 398);

		me.right_oms_label = cdlg_widget_property_label.new(me.root, "100%", text_color, outer_color, fill_color);
		me.right_oms_label.setTranslation(370.0, 458.5);


		me.kit_oms = cdlg_widget_tank.new(me.root, 40, outer_color, fill_color);
		me.kit_oms.setTranslation(215,350);

		me.kit_oms_text = cdlg_widget_property_label.new(me.root, "OMS kit", text_color, outer_color, fill_color);
		me.kit_oms_text.setTranslation(215, 300);

		me.kit_oms_label = cdlg_widget_property_label.new(me.root, "100%", text_color, outer_color, fill_color);
		me.kit_oms_label.setTranslation(215.0, 420.0);

		# RCS tanks
	
		me.left_rcs = cdlg_widget_tank.new(me.root, 20, outer_color, fill_color);
		me.left_rcs.setTranslation(170,560);

		me.left_rcs_text = cdlg_widget_property_label.new(me.root, "Left RCS", text_color, outer_color, fill_color);
		me.left_rcs_text.setTranslation(150, 523);

		me.left_rcs_label = cdlg_widget_property_label.new(me.root, "100%", text_color, outer_color, fill_color);
		me.left_rcs_label.setTranslation(115.0, 568.5);

		me.right_rcs = cdlg_widget_tank.new(me.root, 20, outer_color, fill_color);
		me.right_rcs.setTranslation(260,560);

		me.right_rcs_text = cdlg_widget_property_label.new(me.root, "Right RCS", text_color, outer_color, fill_color);
		me.right_rcs_text.setTranslation(270, 527);

		me.right_rcs_label = cdlg_widget_property_label.new(me.root, "100%", text_color, outer_color, fill_color);
		me.right_rcs_label.setTranslation(315.0, 568.5);

		me.fwd_rcs = cdlg_widget_tank.new(me.root, 20, outer_color, fill_color);
		me.fwd_rcs.setTranslation(280,100);

		me.fwd_rcs_label = cdlg_widget_property_label.new(me.root, "100%", text_color, outer_color, fill_color);
		me.fwd_rcs_label.setTranslation(335.0,105.0);

		me.fwd_rcs_text = cdlg_widget_property_label.new(me.root, "Fordward RCS", text_color, outer_color, fill_color);
		me.fwd_rcs_text.setTranslation(290, 65.0);


		

		me.context_help_text = me.root.createChild("text")
      		.setText("")
		.setColor(0,0,0)
		.setFontSize(15)
		.setFont("LiberationFonts/LiberationMono-Italic.ttf")
		.setAlignment("center-bottom")
		.setRotation(0.0)
		.setTranslation(215, 610.0);



		# clickspots

		me.cs_left_oms = cdlg_clickspot.new(130.0, 450.0, 40.0, 40.0, 1, "circle");
		append(me.clickspots, me.cs_left_oms);

		me.cs_right_oms = cdlg_clickspot.new(300.0, 450.0, 40.0, 40.0, 1, "circle");
		append(me.clickspots, me.cs_right_oms);
		
		me.cs_left_rcs = cdlg_clickspot.new(170.0, 560.0, 20.0, 20.0, 1, "circle");
		append(me.clickspots, me.cs_left_rcs);
		
		me.cs_right_rcs = cdlg_clickspot.new(260.0, 560.0, 20.0, 20.0, 1, "circle");
		append(me.clickspots, me.cs_right_rcs);
		
		me.cs_fwd_rcs = cdlg_clickspot.new(280.0, 100.0, 20.0, 20.0, 1, "circle");
		append(me.clickspots, me.cs_fwd_rcs);

		me.cs_kit_oms = cdlg_clickspot.new(215.0, 350.0, 40.0, 40.0, 1, "circle");
		append(me.clickspots, me.cs_kit_oms);


		me.update_flag = 1;
		me.update_orbit_dlg();


		# context help

		me.left_oms.setContextHelp(me.process_context_help);
		me.right_oms.setContextHelp(me.process_context_help);
		me.kit_oms.setContextHelp(me.process_context_help);
		me.left_rcs.setContextHelp(me.process_context_help);
		me.right_rcs.setContextHelp(me.process_context_help);
		me.fwd_rcs.setContextHelp(me.process_context_help);

		#me.gauge_test = cdlg_widget_analog_gauge.new(me.root, "Aircraft/SpaceShuttle/Nasal/canvas/gauge.png", "Aircraft/SpaceShuttle/Nasal/canvas/gauge_needle.png");
		#me.gauge_test.setTranslation (50, 150);
		#me.gauge_test.setAngle(30.0);


	},

	update_orbit_dlg: func {

		if (me.update_flag == 0) {return;}

		var oms_kit = getprop("/fdm/jsbsim/systems/oms-hardware/oms-kit-installed");
		var oms_kit_num_tanks = getprop("/fdm/jsbsim/systems/oms-hardware/oms-kit-num-tanks");

		var content_oms_left_ox = getprop("/consumables/fuel/tank[4]/level-lbs")/7773.0;
		var content_oms_left_fu = getprop("/consumables/fuel/tank[5]/level-lbs")/4718.0;
		var content_oms_left = math.min(content_oms_left_ox, content_oms_left_fu);

		var content_oms_right_ox = getprop("/consumables/fuel/tank[6]/level-lbs")/7773.0;
		var content_oms_right_fu = getprop("/consumables/fuel/tank[7]/level-lbs")/4718.0;
		var content_oms_right = math.min(content_oms_right_ox, content_oms_right_fu);


		me.left_oms.setPercentage(content_oms_left);
		me.right_oms.setPercentage(content_oms_right);


		me.left_oms_label.updateText(int (content_oms_left * 100.0) ~"%");
		me.right_oms_label.updateText(int (content_oms_right * 100.0) ~"%");

		if (oms_kit == 1)
			{
			var content_oms_kit_ox = getprop("/consumables/fuel/tank[26]/level-lbs")/(7773.0 * oms_kit_num_tanks);
			var content_oms_kit_fu = getprop("/consumables/fuel/tank[27]/level-lbs")/(4718.0 * oms_kit_num_tanks);
			var content_oms_kit = math.min(content_oms_kit_ox, content_oms_kit_fu);
			me.kit_oms.setPercentage(content_oms_kit);
			me.kit_oms.setVisible(1);
			me.kit_oms_label.updateText(int (content_oms_kit * 100.0) ~"%");
			me.kit_oms_label.setVisible(1);
			me.kit_oms_text.setVisible(1);
			}
		else
			{
			me.kit_oms.setVisible(0);
			me.kit_oms_label.setVisible(0);
			me.kit_oms_text.setVisible(0);
			}




		var content_rcs_left_ox = getprop("/consumables/fuel/tank[8]/level-lbs")/1477.0;
		var content_rcs_left_fu = getprop("/consumables/fuel/tank[9]/level-lbs")/928.0;
		var content_rcs_left = math.min(content_rcs_left_ox, content_rcs_left_fu);
		
		var content_rcs_right_ox = getprop("/consumables/fuel/tank[10]/level-lbs")/1477.0;
		var content_rcs_right_fu = getprop("/consumables/fuel/tank[11]/level-lbs")/928.0;
		var content_rcs_right = math.min(content_rcs_right_ox, content_rcs_right_fu);

		me.left_rcs.setPercentage(content_rcs_left);
		me.right_rcs.setPercentage(content_rcs_right);

		me.left_rcs_label.updateText(int (content_rcs_left * 100.0) ~"%");
		me.right_rcs_label.updateText(int (content_rcs_right * 100.0) ~"%");

		var content_rcs_fwd_ox = getprop("/consumables/fuel/tank[12]/level-lbs")/1477.0;
		var content_rcs_fwd_fu = getprop("/consumables/fuel/tank[13]/level-lbs")/928.0;
		var content_rcs_fwd = math.min(content_rcs_fwd_ox, content_rcs_fwd_fu);

		
		me.fwd_rcs.setPercentage(content_rcs_fwd);
		me.fwd_rcs_label.updateText(int (content_rcs_fwd * 100.0) ~"%");

		settimer (func {me.update_orbit_dlg();}, 0.1);		

	},




	init_secondary_dlg: func (system) {

		if (me.child_open_flag == 1) {return;}

		me.child_open_flag = 1;
		me.child_system_flag = system;

		var width = 400.0;
		var height = 220.0;

		var title = "";

		if (system == 0)
			{
			title = "Left OMS propellant";
			}	
		else if (system == 1)
			{
			title = "Right OMS propellant";
			}
		else if (system == 2)
			{
			title = "Left RCS propellant";
			}
		else if (system == 3)
			{
			title = "Right RCS propellant";
			}
		else if (system == 4)
			{
			title = "Forward RCS propellant";
			}
		else if (system == 5)
			{
			if (getprop("/fdm/jsbsim/systems/oms-hardware/oms-kit-installed") == 0) {return;}

			title = "OMS kit propellant";
			}

		#SpaceShuttle.cdlg_propellant.child_open_flag = 1;

		var window = canvas.Window.new([width,height],"dialog").set("title", title);

		# we need to explicitly re-define this to get a handle to stop the update loop
		# upon closing the window

		window.del = func()
		{
		  #print("Cleaning up...\n");
		  SpaceShuttle.cdlg_propellant.child_update_flag = 0;
		  SpaceShuttle.cdlg_propellant.child_open_flag = 0;
		  SpaceShuttle.cdlg_propellant.child_system_flag = -1;
		  call(canvas.Window.del, [], me);
		};


		var prpltChildCanvas = window.createCanvas().set("background", "#7b8992");
		me.root_child = prpltChildCanvas.createGroup();

		var outer_color = [0.2, 0.2, 0.2, 0.7];
		var fill_color = [0.7, 0.7, 0.7,0.7];

		me.oxidizer = cdlg_widget_tank.new(me.root_child, 50, outer_color, fill_color);
		me.oxidizer.setTranslation(60,100);

		me.oxidizer_text = cdlg_widget_property_label.new(me.root_child, "Oxidizer");
		me.oxidizer_text.setTranslation(70, 25);

		me.oxidizer_text_type = cdlg_widget_property_label.new(me.root_child, "Oxidizer type");
		me.oxidizer_text_type.setTranslation(80, 40);

		me.oxidizer_label = cdlg_widget_property_label.new(me.root_child, "100");
		me.oxidizer_label.setTranslation(60, 170);
		me.oxidizer_label.setUnit("%");
		me.oxidizer_label.setLimits(5.0, 105.0);
		

		me.oxidizer_label_wt = cdlg_widget_property_label.new(me.root_child, "100");
		me.oxidizer_label_wt.setTranslation(60, 190);
		me.oxidizer_label_wt.setUnit(" lbs");
		me.oxidizer_label_wt.formatFunction = func (value) {return sprintf("%4.1f", value);	};

		me.oxidizer_label_pressure = cdlg_widget_property_label.new(me.root_child, "100");
		me.oxidizer_label_pressure.setTranslation(150, 80);
		me.oxidizer_label_pressure.setUnit(" psia");
		me.oxidizer_label_pressure.setLimits(200.0, 312.0);
		me.oxidizer_label_pressure.formatFunction = func (value) {return sprintf("%3.1f", value);	};

		me.oxidizer_label_temp = cdlg_widget_property_label.new(me.root_child, "100");
		me.oxidizer_label_temp.setTranslation(140, 100);

		me.fuel = cdlg_widget_tank.new(me.root_child, 50, outer_color, fill_color);
		me.fuel.setTranslation(260,100);

		me.fuel_text = cdlg_widget_property_label.new(me.root_child, "Fuel");
		me.fuel_text.setTranslation(260, 25);

		me.fuel_text_type = cdlg_widget_property_label.new(me.root_child, "Fuel type");
		me.fuel_text_type.setTranslation(290, 40);

		me.fuel_label = cdlg_widget_property_label.new(me.root_child, "100%");
		me.fuel_label.setTranslation(260, 170);
		me.fuel_label.setUnit("%");
		me.fuel_label.setLimits(5.0, 105.0);

		me.fuel_label_wt = cdlg_widget_property_label.new(me.root_child, "0.0 lbs");
		me.fuel_label_wt.setTranslation(280, 190);
		me.fuel_label_wt.setUnit(" lbs");
		me.fuel_label_wt.formatFunction = func (value) {return sprintf("%4.1f", value);	};


		me.fuel_label_pressure = cdlg_widget_property_label.new(me.root_child, "0.0 psi");
		me.fuel_label_pressure.setTranslation(350, 80);
		me.fuel_label_pressure.setUnit(" psia");
		me.fuel_label_pressure.setLimits(200.0, 312.0);
		me.fuel_label_pressure.formatFunction = func (value) {return sprintf("%3.1f", value);	};
		
		me.fuel_label_temp = cdlg_widget_property_label.new(me.root_child, "0.0 F");
		me.fuel_label_temp.setTranslation(340, 100);


		me.child_context_help_text = me.root_child.createChild("text")
      		.setText("")
		.setColor(0,0,0)
		.setFontSize(15)
		.setFont("LiberationFonts/LiberationMono-Italic.ttf")
		.setAlignment("center-bottom")
		.setRotation(0.0)
		.setTranslation(200, 215.0);




		if ((system == 0) or (system == 1) or (system == 2) or (system == 3) or (system == 4) or (system == 5))
			{
			me.oxidizer_text_type.setText("nitrogen tetroxide");
			me.fuel_text_type.setText("monomethyl hydrazine");

			}

		
		me.child_update_flag = 1;
		me.update_secondary_dlg(system);

		# clickspots

		me.root_child.addEventListener("click", func(e) {
			me.check_clickspots_child("click",e);
			});
			
		me.root_child.addEventListener("wheel", func(e) {
			me.check_clickspots_child("wheel",e);
			});
		

		me.cs_oxidizer = cdlg_clickspot.new(60.0, 100.0, 50.0, 50.0, 1, "circle");
		append(me.clickspots_child, me.cs_oxidizer);

		me.cs_fuel = cdlg_clickspot.new(260.0, 100.0, 50.0, 50.0, 1, "circle");
		append(me.clickspots_child, me.cs_fuel);

		# add context help
		
		me.oxidizer.setContextHelp(me.process_context_help_child);
		me.fuel.setContextHelp(me.process_context_help_child);



	},

	update_secondary_dlg: func (system) {

		if (me.child_update_flag == 0) {return;}

		#print ("Updating system ", system);

		var content_oxidizer = 0;
		var content_fuel = 0;
		var fraction_oxidizer = 0;
		var fraction_fuel = 0;
		var pressure_oxidizer = 0;
		var pressure_fuel = 0;
		var temp_oxidizer = 0;
		var temp_fuel = 0;


	

		if (system == 0)
			{
			content_oxidizer = getprop("/consumables/fuel/tank[4]/level-lbs");
			content_fuel = getprop("/consumables/fuel/tank[5]/level-lbs");
			fraction_oxidizer = content_oxidizer/7773.0;
			fraction_fuel = content_fuel/4718.0;

			pressure_oxidizer = getprop("/fdm/jsbsim/systems/oms-hardware/tanks-left-oms-blowdown-psia");
			pressure_fuel = getprop("/fdm/jsbsim/systems/oms-hardware/tanks-left-oms-blowdown-psia");

			temp_oxidizer = SpaceShuttle.K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/left-pod-temperature-K"));
			var heater_OMS_left = getprop("/fdm/jsbsim/systems/oms-hardware/heater-left-operational");
			if ((temp_oxidizer < 57.0) and (heater_OMS_left == 1)) {temp_oxidizer = 65.0;}
			temp_fuel = temp_oxidizer;
			}
		else if (system == 1)
			{
			content_oxidizer = getprop("/consumables/fuel/tank[6]/level-lbs");
			content_fuel = getprop("/consumables/fuel/tank[7]/level-lbs");
			fraction_oxidizer = content_oxidizer/7773.0;
			fraction_fuel = content_fuel/4718.0;

			pressure_oxidizer = getprop("/fdm/jsbsim/systems/oms-hardware/tanks-right-oms-blowdown-psia");
			pressure_fuel = getprop("/fdm/jsbsim/systems/oms-hardware/tanks-right-oms-blowdown-psia");

			temp_oxidizer = SpaceShuttle.K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/right-pod-temperature-K"));
			var heater_OMS_right = getprop("/fdm/jsbsim/systems/oms-hardware/heater-right-operational");
			if ((temp_oxidizer < 57.0) and (heater_OMS_right == 1)) {temp_oxidizer = 65.0;}
			temp_fuel = temp_oxidizer;
			}
		else if (system == 2)
			{
			content_oxidizer = getprop("/consumables/fuel/tank[8]/level-lbs");
			content_fuel = getprop("/consumables/fuel/tank[9]/level-lbs");
			fraction_oxidizer = content_oxidizer/1477.0;
			fraction_fuel = content_fuel/928.0;
			
			pressure_oxidizer = getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-left-rcs-blowdown-psia");
			pressure_fuel = pressure_oxidizer;
			
			}
		else if (system == 3)
			{
			content_oxidizer = getprop("/consumables/fuel/tank[10]/level-lbs");
			content_fuel = getprop("/consumables/fuel/tank[11]/level-lbs");
			fraction_oxidizer = content_oxidizer/1477.0;
			fraction_fuel = content_fuel/928.0;
			
			pressure_oxidizer = getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-right-rcs-blowdown-psia");
			pressure_fuel = pressure_oxidizer;
			}
		else if (system == 4)
			{
			content_oxidizer = getprop("/consumables/fuel/tank[12]/level-lbs");
			content_fuel = getprop("/consumables/fuel/tank[13]/level-lbs");
			fraction_oxidizer = content_oxidizer/1477.0;
			fraction_fuel = content_fuel/928.0;
			
			pressure_oxidizer = getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-fwd-rcs-blowdown-psia");
			pressure_fuel = pressure_oxidizer;
			}
		else if (system == 5)
			{

			var oms_kit_num_tanks = getprop("/fdm/jsbsim/systems/oms-hardware/oms-kit-num-tanks");

			content_oxidizer = getprop("/consumables/fuel/tank[26]/level-lbs");
			content_fuel = getprop("/consumables/fuel/tank[27]/level-lbs");
			fraction_oxidizer = content_oxidizer/(7773.0 * oms_kit_num_tanks);
			fraction_fuel = content_fuel/(4718.0 * oms_kit_num_tanks);

			pressure_oxidizer = getprop("/fdm/jsbsim/systems/oms-hardware/tanks-kit-oms-blowdown-psia");
			pressure_fuel = getprop("/fdm/jsbsim/systems/oms-hardware/tanks-kit-oms-blowdown-psia");

			temp_oxidizer = SpaceShuttle.K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/right-pod-temperature-K"));
			var heater_OMS_right = getprop("/fdm/jsbsim/systems/oms-hardware/heater-right-operational");
			if ((temp_oxidizer < 57.0) and (heater_OMS_right == 1)) {temp_oxidizer = 65.0;}
			temp_fuel = temp_oxidizer;
			}


		me.oxidizer.setPercentage(fraction_oxidizer);
		me.oxidizer_label.setValue(fraction_oxidizer*100);
		me.oxidizer_label_wt.setValue(content_oxidizer);
		#me.oxidizer_label_pressure.updateText(sprintf("%3.1f", pressure_oxidizer)~" psi");
		me.oxidizer_label_pressure.setValue(pressure_fuel);
		me.oxidizer_label_temp.updateText(sprintf("%3.1f", temp_oxidizer)~" F");

		me.fuel.setPercentage(fraction_fuel);
		me.fuel_label.setValue(fraction_fuel*100);
		me.fuel_label_wt.setValue(content_fuel);
		#me.fuel_label_pressure.updateText(sprintf("%3.1f", pressure_fuel)~" psi");
		me.fuel_label_pressure.setValue(pressure_fuel);
		me.fuel_label_temp.updateText(sprintf("%3.1f", temp_fuel)~" F");

		settimer (func {me.update_secondary_dlg(system);}, 0.1);		

	},


	set_fuel_fraction  : func (system, tank, fraction) {
 
		if (fraction < 0.0) {fraction = 0.0;}

		if (system == 0)
			{
			if (tank == 0)
				{
				var value = fraction * 7773.0;
				setprop("/consumables/fuel/tank[4]/level-lbs", value);
				}
			else if (tank == 1)
				{
				var value = fraction * 4718.0;
				setprop("/consumables/fuel/tank[5]/level-lbs", value);
				}
			}
		else if (system == 1)
			{
			if (tank == 0)
				{
				var value = fraction * 7773.0;
				setprop("/consumables/fuel/tank[6]/level-lbs", value);
				}
			else if (tank == 1)
				{
				var value = fraction * 4718.0;
				setprop("/consumables/fuel/tank[7]/level-lbs", value);
				}
			}
		else if (system == 2)
			{
			if (tank == 0)
				{
				var value = fraction * 1477.0;
				setprop("/consumables/fuel/tank[8]/level-lbs", value);
				}
			else if (tank == 1)
				{
				var value = fraction * 928.0;
				setprop("/consumables/fuel/tank[9]/level-lbs", value);
				}
			}
		else if (system == 3)
			{
			if (tank == 0)
				{
				var value = fraction * 1477.0;
				setprop("/consumables/fuel/tank[10]/level-lbs", value);
				}
			else if (tank == 1)
				{
				var value = fraction * 928.0;
				setprop("/consumables/fuel/tank[11]/level-lbs", value);
				}
			}
		else if (system == 4)
			{
			if (tank == 0)
				{
				var value = fraction * 1477.0;
				setprop("/consumables/fuel/tank[12]/level-lbs", value);
				}
			else if (tank == 1)
				{
				var value = fraction * 928.0;
				setprop("/consumables/fuel/tank[13]/level-lbs", value);
				}
			}
		else if (system == 5)
			{
			var oms_kit_num_tanks = getprop("/fdm/jsbsim/systems/oms-hardware/oms-kit-num-tanks");

			if (tank == 0)
				{
				var value = fraction * 7773.0 * oms_kit_num_tanks;
				setprop("/consumables/fuel/tank[26]/level-lbs", value);
				}
			else if (tank == 1)
				{
				var value = fraction * 4718.0 * oms_kit_num_tanks;
				setprop("/consumables/fuel/tank[27]/level-lbs", value);
				}
			}
	},
	
	get_fuel_fraction  : func (system, tank) {
 
		if (system == 0)
			{
			if (tank == 0)
				{
				return getprop("/consumables/fuel/tank[4]/level-lbs")/7773.0;
				}
			else if (tank == 1)
				{
				return getprop("/consumables/fuel/tank[5]/level-lbs")/4718.0;
				}
			}
		else if (system == 1)
			{
			if (tank == 0)
				{
				return getprop("/consumables/fuel/tank[6]/level-lbs")/7773.0;
				}
			else if (tank == 1)
				{
				return getprop("/consumables/fuel/tank[7]/level-lbs")/4718.0;
				}
			}
		else if (system == 2)
			{
			if (tank == 0)
				{
				return getprop("/consumables/fuel/tank[8]/level-lbs")/1477.0;
				}
			else if (tank == 1)
				{
				return getprop("/consumables/fuel/tank[9]/level-lbs")/928.0;
				}
			}
		else if (system == 3)
			{
			if (tank == 0)
				{
				return getprop("/consumables/fuel/tank[10]/level-lbs")/1477.0;
				}
			else if (tank == 1)
				{
				return getprop("/consumables/fuel/tank[11]/level-lbs")/928.0;
				}
			}
		else if (system == 4)
			{
			if (tank == 0)
				{
				return getprop("/consumables/fuel/tank[12]/level-lbs")/1477.0;
				}
			else if (tank == 1)
				{
				return getprop("/consumables/fuel/tank[13]/level-lbs")/928.0;
				}
			}
		else if (system == 5)
			{
			var oms_kit_num_tanks = getprop("/fdm/jsbsim/systems/oms-hardware/oms-kit-num-tanks");
			if (tank == 0)
				{
				return getprop("/consumables/fuel/tank[26]/level-lbs")/(7773.0 * oms_kit_num_tanks);
				}
			else if (tank == 1)
				{
				return getprop("/consumables/fuel/tank[27]/level-lbs")/(4718.0 * oms_kit_num_tanks);
				}
			}
	},



};

