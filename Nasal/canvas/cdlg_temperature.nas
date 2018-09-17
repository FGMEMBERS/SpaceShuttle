var cdlg_temperature = {

	update_flag:  0,

	init: func {


		var width = 430;
		var height = 616;
		var img_path = "Aircraft/SpaceShuttle/Dialogs/orbiter_top.png";
						



		var window = canvas.Window.new([width,height],"dialog").set("title", "Orbiter Temperature Distribution");

		# we need to explicitly re-define this to get a handle to stop the update loop
		# upon closing the window

		window.del = func()
		{
		  #print("Cleaning up...\n");
		  SpaceShuttle.cdlg_temperature.update_flag = 0;
		  call(canvas.Window.del, [], me);
		};


		var tempCanvas = window.createCanvas().set("background", canvas.style.getColor("bg_color"));
		me.root = tempCanvas.createGroup();
		var child=me.root.createChild("image")
				                   .setFile(img_path )
				                   .setTranslation(0,0)
				                   .setSize(width,height);


		var text_template = [["0.0"]];
		var box_size = 110.0;
		var title_bg = [0.7,0.7,0.7,0.7];
		var box_bg = [0.6,0.6,0.6,0.6];


		me.nose_temp = cdlg_widget_infobox.new(me.root, box_size, "nose", text_template, 10.0, nil, nil, title_bg, nil, box_bg);
		me.nose_temp.setTranslation(215,30);
		me.nose_temp.setUnit(" K");


		me.cabin_temp = cdlg_widget_infobox.new(me.root, box_size, "cabin", text_template, 10.0, nil, nil, title_bg, nil, box_bg);
		me.cabin_temp.setTranslation(215,130);
		me.cabin_temp.setUnit(" K");

		me.interior_temp = cdlg_widget_infobox.new(me.root, box_size, "interior", text_template, 10.0, nil, nil, title_bg, nil, box_bg);
		me.interior_temp.setTranslation(345,130);
		me.interior_temp.setUnit(" K");

		me.avionics_temp = cdlg_widget_infobox.new(me.root, box_size, "avionics", text_template, 10.0, nil, nil, title_bg, nil, box_bg);
		me.avionics_temp.setTranslation(345,190);
		me.avionics_temp.setUnit(" K");

		me.left_temp = cdlg_widget_infobox.new(me.root, box_size, "left fuselage", text_template, 10.0, nil, nil, title_bg, nil, box_bg);
		me.left_temp.setTranslation(85,260);
		me.left_temp.setUnit(" K");

		me.right_temp = cdlg_widget_infobox.new(me.root, box_size, "right fuselage", text_template, 10.0, nil, nil, title_bg, nil, box_bg);
		me.right_temp.setTranslation(345,260);
		me.right_temp.setUnit(" K");

		me.payload_temp = cdlg_widget_infobox.new(me.root, box_size, "payload bay", text_template, 10.0, nil, nil, title_bg, nil, box_bg);
		me.payload_temp.setTranslation(215,330);
		me.payload_temp.setUnit(" K");

		me.aft_temp = cdlg_widget_infobox.new(me.root, box_size, "aft fuselage", text_template, 10.0, nil, nil, title_bg, nil, box_bg);
		me.aft_temp.setTranslation(215,550);
		me.aft_temp.setUnit(" K");

		me.left_oms_temp = cdlg_widget_infobox.new(me.root, box_size, "left OMS pod", text_template, 10.0, nil, nil, title_bg, nil, box_bg);
		me.left_oms_temp.setTranslation(120,490);
		me.left_oms_temp.setUnit(" K");

		me.right_oms_temp = cdlg_widget_infobox.new(me.root, box_size, "right OMS pod", text_template, 10.0, nil, nil, title_bg, nil, box_bg);
		me.right_oms_temp.setTranslation(310,490);
		me.right_oms_temp.setUnit(" K");

		me.freon_in_temp = cdlg_widget_infobox.new(me.root, box_size, "freon loop in", text_template, 10.0, nil, nil, title_bg, nil, box_bg);
		me.freon_in_temp.setTranslation(345,330);
		me.freon_in_temp.setUnit(" K");

		me.freon_out_temp = cdlg_widget_infobox.new(me.root, box_size, "freon loop out", text_template, 10.0, nil, nil, title_bg, nil, box_bg);
		me.freon_out_temp.setTranslation(345,390);
		me.freon_out_temp.setUnit(" K");

		me.tps_temp = cdlg_widget_infobox.new(me.root, box_size, "TPS", text_template, 10.0, nil, nil, title_bg, nil, box_bg);
		me.tps_temp.setTranslation(85,390);
		me.tps_temp.setUnit(" K");


		var stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/units_to_fahrenheit.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/units_to_kelvin.png");

		me.unit_switch = cdlg_widget_img_stack.new(me.root, stack, 126, 142);
		me.unit_switch.setTranslation(20,20);


		# context help

		me.unit_switch.setContextHelp(me.process_context_help);

		me.unit_switch.f = func {SpaceShuttle.cdlg_temperature.switchUnits();}

		me.context_help_text = me.root.createChild("text")
      		.setText("")
		.setColor(0,0,0)
		.setFontSize(15)
		.setFont("LiberationFonts/LiberationMono-Italic.ttf")
		.setAlignment("center-bottom")
		.setRotation(0.0)
		.setTranslation(215, 610);


		me.update_flag = 1;
		me.update();

		},




	update: func {
		
		if (me.update_flag == 0) {return;}

		var T = me.inUnits(getprop("/fdm/jsbsim/systems/thermal-distribution/cabin-temperature-K"));
		me.cabin_temp.setValue(0, T);

		T = me.inUnits(getprop("/fdm/jsbsim/systems/thermal-distribution/nose-temperature-K"));
		me.nose_temp.setValue(0,T);

		T = me.inUnits(getprop("/fdm/jsbsim/systems/thermal-distribution/interior-temperature-K"));
		me.interior_temp.setValue(0,T);

		T = me.inUnits(getprop("/fdm/jsbsim/systems/thermal-distribution/avionics-temperature-K"));
		me.avionics_temp.setValue(0,T);

		T = me.inUnits(getprop("/fdm/jsbsim/systems/thermal-distribution/left-temperature-K"));
		me.left_temp.setValue(0,T);

		T = me.inUnits(getprop("/fdm/jsbsim/systems/thermal-distribution/right-temperature-K"));
		me.right_temp.setValue(0,T);

		T = me.inUnits(getprop("/fdm/jsbsim/systems/thermal-distribution/left-pod-temperature-K"));
		me.left_oms_temp.setValue(0,T);

		T = me.inUnits(getprop("/fdm/jsbsim/systems/thermal-distribution/right-pod-temperature-K"));
		me.right_oms_temp.setValue(0,T);

		T = me.inUnits(getprop("/fdm/jsbsim/systems/thermal-distribution/aft-temperature-K"));
		me.aft_temp.setValue(0,T);

		T = me.inUnits(getprop("/fdm/jsbsim/systems/thermal-distribution/payload-bay-temperature-K"));
		me.payload_temp.setValue(0,T);

		T = me.inUnits(getprop("/fdm/jsbsim/systems/thermal-distribution/tps-temperature-K"));
		me.tps_temp.setValue(0,T);

		T = me.inUnits(getprop("/fdm/jsbsim/systems/thermal-distribution/freon-in-temperature-K"));
		me.freon_in_temp.setValue(0,T);

		T = me.inUnits(getprop("/fdm/jsbsim/systems/thermal-distribution/freon-out-temperature-K"));
		me.freon_out_temp.setValue(0,T);

		settimer (func {me.update();}, 0.1);		

		},

	process_context_help: func (event) {

		if (event == "mouseover")
			{
			SpaceShuttle.cdlg_temperature.context_help_text.setText("Click to change units");
			}		
		else if (event == "mouseout")
			{
			SpaceShuttle.cdlg_temperature.context_help_text.setText("");
			}
	
	},

	switchUnits: func {

		if (me.unit_switch.index == 1)
			{
			me.nose_temp.setUnit(" F");
			me.cabin_temp.setUnit(" F");
			me.interior_temp.setUnit(" F");
			me.avionics_temp.setUnit(" F");
			me.left_temp.setUnit(" F");
			me.right_temp.setUnit(" F");
			me.left_oms_temp.setUnit(" F");
			me.right_oms_temp.setUnit(" F");
			me.payload_temp.setUnit(" F");
			me.tps_temp.setUnit(" F");
			me.aft_temp.setUnit(" F");
			me.freon_in_temp.setUnit(" F");
			me.freon_out_temp.setUnit(" F");
			}
		else
			{
			me.nose_temp.setUnit(" K");
			me.cabin_temp.setUnit(" K");
			me.interior_temp.setUnit(" K");
			me.avionics_temp.setUnit(" K");
			me.left_temp.setUnit(" K");
			me.right_temp.setUnit(" K");
			me.left_oms_temp.setUnit(" K");
			me.right_oms_temp.setUnit(" K");
			me.payload_temp.setUnit(" K");
			me.tps_temp.setUnit(" K");
			me.aft_temp.setUnit(" K");
			me.freon_in_temp.setUnit(" K");
			me.freon_out_temp.setUnit(" K");
			}


	},

	inUnits: func (T) {
		
		if (me.unit_switch.index == 1)
			{
			return me.K_to_F(T);
			}
		else
			{
			return T;
			}
	},

	K_to_F: func (T) {
    		return T * 9.0/5.0 - 459.67;
	},

};
