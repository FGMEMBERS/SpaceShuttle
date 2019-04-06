
var cdlg_shuttle_view_manager = {

	
	running_flag: 0,
	type: "lookfrom",

	init: func {

		if (me.running_flag == 1) {return;}

		setprop("/controls/shuttle/view-manager-flag", 0);

		me.running_flag = 1;
		var width = 640;
		var height = 480;
		var img_path = "Aircraft/SpaceShuttle/Dialogs/ViewManager/flightdeck_top.png";
						

		me.window = canvas.Window.new([width,height],"dialog").set("title", "Shuttle View Manager");

		# we need to explicitly re-define this to get a handle to stop the update loop
		# upon closing the window

		me.window.del = func()
		{
		  #print("Cleaning up...\n");
		  SpaceShuttle.cdlg_shuttle_view_manager.running_flag = 0;
		  call(canvas.Window.del, [], me);
		};


		var tempCanvas = me.window.createCanvas().set("background", canvas.style.getColor("bg_color"));
		me.root = tempCanvas.createGroup();
		var child=me.root.createChild("image")
				                   .setFile(img_path )
				                   .setTranslation(0,0)
				                   .setSize(width,height);


		var box_size = 60.0;
		var title_bg = [0.7,0.7,0.7,0.7];

		# Commander view

		var view_vec = [-0.6, -0.13, -11.85];		
		var view_offset = [-10,0,0];
		var tgt_vec = [-0.6, -0.13, -11.85];		

		me.view_cdr = cdlg_widget_view_selector.new(me.root, view_vec, view_offset, tgt_vec, box_size, "CDR", 10.0, nil, nil, title_bg, 0.0, 0.0, 10.0);
		me.view_cdr.setTranslation (228,150);
		me.view_cdr.setContextHelp(me.process_context_help);

		# Pilot view

		view_vec = [0.7, -0.13, -11.85];
		view_offset = [-10,0,0];

		me.view_plt = cdlg_widget_view_selector.new(me.root, view_vec, view_offset, tgt_vec, box_size, "PLT", 10.0, nil, nil, title_bg, 0.0, 0.0, 10.0);
		me.view_plt.setTranslation (418,150);
		me.view_plt.setContextHelp(me.process_context_help);

		# Mission specialist view

		view_vec = [0.4, 0.2, -10.9];
		view_offset = [0,-180,0];

		me.view_mission = cdlg_widget_view_selector.new(me.root, view_vec, view_offset, tgt_vec, box_size, "MSN", 10.0, nil, nil, title_bg, 180.0, 0.0, -15.0);
		me.view_mission.setTranslation (418,325);
		me.view_mission.setContextHelp(me.process_context_help);

		# payload specialist view

		view_vec = [-0.4, 0.2, -10.9];
		view_offset = [0,-180,0];

		me.view_payload = cdlg_widget_view_selector.new(me.root, view_vec, view_offset, tgt_vec, box_size, "PLD", 10.0, nil, nil, title_bg, 180.0, 0.0, -15.0);
		me.view_payload.setTranslation (228,325);
		me.view_payload.setContextHelp(me.process_context_help);

		# COAS aft view

		view_vec = [0.269, 0.228, -10.86];
		view_offset = [90,180,0];

		me.view_coas_aft = cdlg_widget_view_selector.new(me.root, view_vec, view_offset, tgt_vec, box_size, "COAS", 10.0, nil, nil, title_bg);
		me.view_coas_aft.setTranslation (418,295);
		me.view_coas_aft.setContextHelp(me.process_context_help);

		# COAS fwd view

		view_vec = [-0.7927, -0.154, -12.154];
		view_offset = [0,0,0];

		me.view_coas_fwd = cdlg_widget_view_selector.new(me.root, view_vec, view_offset, tgt_vec, box_size, "COAS", 10.0, nil, nil, title_bg, 0.0, 0.0, 10.0);
		me.view_coas_fwd.setTranslation (130,90);
		me.view_coas_fwd.setContextHelp(me.process_context_help);

		# R11

		view_vec = [0.748, -0.243, -11.413];
		view_offset = [-30,270.0,0];

		me.view_r11 = cdlg_widget_view_selector.new(me.root, view_vec, view_offset, tgt_vec, box_size, "R11", 10.0, nil, nil, title_bg, 90.0, 0.0, -5.0);
		me.view_r11.setTranslation (500,240);
		me.view_r11.setContextHelp(me.process_context_help);

		# center console

		view_vec = [0.0,-0.607, -11.85];
		view_offset = [-18.0,0.0,0];

		me.view_center_console = cdlg_widget_view_selector.new(me.root, view_vec, view_offset, tgt_vec, box_size, "F7", 10.0, nil, nil, title_bg, 0.0, 0.0, 10.0);
		me.view_center_console.setTranslation (323,200);
		me.view_center_console.setContextHelp(me.process_context_help);

		# O7

		view_vec = [0.0,-0.157, -11.66];
		view_offset = [58.0,0.0,0];

		me.view_O7 = cdlg_widget_view_selector.new(me.root, view_vec, view_offset, tgt_vec, box_size, "O7", 10.0, nil, nil, title_bg);
		me.view_O7.setTranslation (323,230);
		me.view_O7.setContextHelp(me.process_context_help);

		# O15

		view_vec = [0.0,-0.077, -11.248];
		view_offset = [85.0,0.0,0];

		me.view_O15 = cdlg_widget_view_selector.new(me.root, view_vec, view_offset, tgt_vec, box_size, "O15", 10.0, nil, nil, title_bg);
		me.view_O15.setTranslation (323,260);
		me.view_O15.setContextHelp(me.process_context_help);

		# A13

		view_vec = [-0.1,-0.637, -11.06];
		view_offset = [-12.0,180.0,0];

		me.view_A13 = cdlg_widget_view_selector.new(me.root, view_vec, view_offset, tgt_vec, box_size, "A13", 10.0, nil, nil, title_bg, 180.0, 0.0, -15.0);
		me.view_A13.setTranslation (323,325);
		me.view_A13.setContextHelp(me.process_context_help);

		# R4

		view_vec = [1.145,-0.63, -12.08];
		view_offset = [-4.2,180.0,0];

		me.view_R4 = cdlg_widget_view_selector.new(me.root, view_vec, view_offset, tgt_vec, box_size, "R4", 10.0, nil, nil, title_bg, 180.0, 0.0, -15.0);
		me.view_R4.setTranslation (510,90);
		me.view_R4.setContextHelp(me.process_context_help);

		# context help

		me.context_help_text = me.root.createChild("text")
      		.setText("")
		.setColor(0,0,0)
		.setFontSize(15)
		.setFont("LiberationFonts/LiberationMono-Italic.ttf")
		.setAlignment("center-bottom")
		.setRotation(0.0)
		.setTranslation(320, 470.0);
		



		},

		process_context_help: func (event) {

			if (event == "mouseover")
				{
				SpaceShuttle.cdlg_shuttle_view_manager.context_help_text.setText("Click to set view");
				}		
			else if (event == "mouseout")
				{
				SpaceShuttle.cdlg_shuttle_view_manager.context_help_text.setText("");
				}
			
		},





};




var cdlg_shuttle_outside_view_manager = {

	
	running_flag: 0,
	type: "lookat",

	init: func {

		if (me.running_flag == 1) {return;}

		#setprop("/controls/shuttle/view-manager-flag", 0);

		me.running_flag = 1;
		var width = 640;
		var height = 480;
		var img_path = "Aircraft/SpaceShuttle/Dialogs/ViewManager/orbiter_top_pbd_open.png";
						

		me.window = canvas.Window.new([width,height],"dialog").set("title", "Shuttle View Manager");

		# we need to explicitly re-define this to get a handle to stop the update loop
		# upon closing the window

		me.window.del = func()
		{
		  #print("Cleaning up...\n");
		  SpaceShuttle.cdlg_shuttle_outside_view_manager.running_flag = 0;
		  call(canvas.Window.del, [], me);
		};


		var tempCanvas = me.window.createCanvas().set("background", canvas.style.getColor("bg_color"));
		me.root = tempCanvas.createGroup();
		var child=me.root.createChild("image")
				                   .setFile(img_path )
				                   .setTranslation(0,0)
				                   .setSize(width,height);


		var box_size = 60.0;
		var title_bg = [0.7,0.7,0.7,0.7];

		# left wingtip

		var view_vec = [0.0, 0.0, -12.0];		
		var view_offset = [0,0,0];
		var tgt_vec = [-12,0,10];

		me.view_left_wing = cdlg_widget_view_selector.new(me.root, view_vec, view_offset, tgt_vec, box_size, "LWing", 10.0, nil, nil, title_bg, nil, nil, nil);
		me.view_left_wing.setTranslation (210,340);
		me.view_left_wing.setContextHelp(me.process_context_help);
		me.view_left_wing.setType("lookat");

		# right wingtip

		view_vec = [0.0, 0.0, -12.0];		
		view_offset = [0,0,0];
		tgt_vec = [12,0,10];

		me.view_right_wing = cdlg_widget_view_selector.new(me.root, view_vec, view_offset, tgt_vec, box_size, "RWing", 10.0, nil, nil, title_bg, nil, nil, nil);
		me.view_right_wing.setTranslation (430,340);
		me.view_right_wing.setContextHelp(me.process_context_help);
		me.view_right_wing.setType("lookat");

		# Payload bay aft

		view_vec = [0.0, 10.0, -12.0];		
		view_offset = [0,0,0];
		tgt_vec = [0,0,5];

		me.view_aplb = cdlg_widget_view_selector.new(me.root, view_vec, view_offset, tgt_vec, box_size, "APLB", 10.0, nil, nil, title_bg, nil, nil, nil);
		me.view_aplb.setTranslation (320,290);
		me.view_aplb.setContextHelp(me.process_context_help);
		me.view_aplb.setType("lookat");

		# Payload bay center

		view_vec = [0.0, 10.0, -12.0];		
		view_offset = [0,0,0];
		tgt_vec = [0,0,0];

		me.view_cplb = cdlg_widget_view_selector.new(me.root, view_vec, view_offset, tgt_vec, box_size, "CPLB", 10.0, nil, nil, title_bg, nil, nil, nil);
		me.view_cplb.setTranslation (320,230);
		me.view_cplb.setContextHelp(me.process_context_help);
		me.view_cplb.setType("lookat");

		# Payload bay fwd

		view_vec = [0.0, 0.0, -12.0];		
		view_offset = [0,0,0];
		tgt_vec = [0,0,-9];

		me.view_fplb = cdlg_widget_view_selector.new(me.root, view_vec, view_offset, tgt_vec, box_size, "FPLB", 10.0, nil, nil, title_bg, nil, nil, nil);
		me.view_fplb.setTranslation (320,160);
		me.view_fplb.setContextHelp(me.process_context_help);
		me.view_fplb.setType("lookat");

		# Nose

		view_vec = [0.0, 10.0, -12.0];		
		view_offset = [0,0,0];
		tgt_vec = [0,0,-16];

		me.view_nose = cdlg_widget_view_selector.new(me.root, view_vec, view_offset, tgt_vec, box_size, "NOSE", 10.0, nil, nil, title_bg, nil, nil, nil);
		me.view_nose.setTranslation (320,110);
		me.view_nose.setContextHelp(me.process_context_help);
		me.view_nose.setType("lookat");

		# Gear

		view_vec = [0.0, 0.0, -15.0];		
		view_offset = [0,0,0];
		tgt_vec = [0,-7,0];

		me.view_gear = cdlg_widget_view_selector.new(me.root, view_vec, view_offset, tgt_vec, box_size, "GEAR", 10.0, nil, nil, title_bg, nil, nil, nil);
		me.view_gear.setTranslation (210,260);
		me.view_gear.setContextHelp(me.process_context_help);
		me.view_gear.setType("lookat");


		# 60 m distant

		view_vec = [0.0, 0.0, -60.0];		
		view_offset = [0,0,0];
		tgt_vec = [0,0,0];

		me.view_o60 = cdlg_widget_view_selector.new(me.root, view_vec, view_offset, tgt_vec, box_size, " 60m", 10.0, nil, nil, title_bg, nil, nil, nil); 
		me.view_o60.setTranslation (540,100);
		me.view_o60.setContextHelp(me.process_context_help);
		me.view_o60.setType("lookat");

		# 140 m distant

		view_vec = [0.0, 0.0, -140.0];		
		view_offset = [0,0,0];
		tgt_vec = [0,0,0];

		me.view_o140 = cdlg_widget_view_selector.new(me.root, view_vec, view_offset, tgt_vec, box_size, "140m", 10.0, nil, nil, title_bg, nil, nil, nil);
		me.view_o140.setTranslation (540,140);
		me.view_o140.setContextHelp(me.process_context_help);
		me.view_o140.setType("lookat");

		# 250 m distant

		view_vec = [0.0, 0.0, -250.0];		
		view_offset = [0,0,0];
		tgt_vec = [0,0,0];

		me.view_o250 = cdlg_widget_view_selector.new(me.root, view_vec, view_offset, tgt_vec, box_size, "250m", 10.0, nil, nil, title_bg, nil, nil, nil);
		me.view_o250.setTranslation (540,180);
		me.view_o250.setContextHelp(me.process_context_help);
		me.view_o250.setType("lookat");

		# 500 m distant

		view_vec = [0.0, 0.0, -500.0];		
		view_offset = [0,0,0];
		tgt_vec = [0,0,0];

		me.view_o500 = cdlg_widget_view_selector.new(me.root, view_vec, view_offset, tgt_vec, box_size, "500m", 10.0, nil, nil, title_bg, nil, nil, nil);
		me.view_o500.setTranslation (540,220);
		me.view_o500.setContextHelp(me.process_context_help);
		me.view_o500.setType("lookat");

		


		# context help

		me.context_help_text = me.root.createChild("text")
      		.setText("")
		.setColor(0,0,0)
		.setFontSize(15)
		.setFont("LiberationFonts/LiberationMono-Italic.ttf")
		.setAlignment("center-bottom")
		.setRotation(0.0)
		.setTranslation(320, 470.0);
		



		},

		process_context_help: func (event) {

			if (event == "mouseover")
				{
				SpaceShuttle.cdlg_shuttle_outside_view_manager.context_help_text.setText("Click to set view");
				}		
			else if (event == "mouseout")
				{
				SpaceShuttle.cdlg_shuttle_outside_view_manager.context_help_text.setText("");
				}
			
		},





};


var cdlg_shuttle_view_manager_dispatch = func {

	if (getprop("/sim/current-view/internal") == 1)
		{
		cdlg_shuttle_view_manager.init(); 
		}
	else
		{
		cdlg_shuttle_outside_view_manager.init(); 
		}

};


#setlistener("/controls/shuttle/view-manager-flag", func {settimer( func { cdlg_shuttle_view_manager.init();  }, 0.3); });

setlistener("/controls/shuttle/view-manager-flag", func {settimer( func { cdlg_shuttle_view_manager_dispatch();  }, 0.3); });
