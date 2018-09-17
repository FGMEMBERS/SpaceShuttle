var cdlg_oms_propellant = {

	update_flag:  0,

	init: func {


		var width = 545;
		var height = 762;
		var img_path = "Aircraft/SpaceShuttle/Dialogs/oms_panel.png";
						

		var window = canvas.Window.new([width,height],"dialog").set("title", "OMS Propellant flow");

		# we need to explicitly re-define this to get a handle to stop the update loop
		# upon closing the window

		window.del = func()
		{
		  #print("Cleaning up...\n");
		  SpaceShuttle.cdlg_oms_propellant.update_flag = 0;
		  call(canvas.Window.del, [], me);
		};


		var tempCanvas = window.createCanvas().set("background", canvas.style.getColor("bg_color"));
		me.root = tempCanvas.createGroup();
		var child=me.root.createChild("image")
				                   .setFile(img_path )
				                   .setTranslation(0,0)
				                   .setSize(width,height);

		# left isolation A

		var stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/oms_switch_down.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/oms_switch_up.png");

		me.switch_left_isolation_A = cdlg_widget_img_stack.new(me.root, stack, 50, 50);
		me.switch_left_isolation_A.setTranslation(219,440);
		me.switch_left_isolation_A.f = func 
			{
			var state = getprop("/fdm/jsbsim/systems/oms-hardware/tank-left-oms-valve-A-status");
			if (state == 0) {state = 1;} else {state = 0;}
			setprop("/fdm/jsbsim/systems/oms-hardware/tank-left-oms-valve-A-status", state);
			 };

		# left isolation B


		me.switch_left_isolation_B = cdlg_widget_img_stack.new(me.root, stack, 50, 50);
		me.switch_left_isolation_B.setTranslation(298,443);
		me.switch_left_isolation_B.f = func 
			{
			var state = getprop("/fdm/jsbsim/systems/oms-hardware/tank-left-oms-valve-B-status");
			if (state == 0) {state = 1;} else {state = 0;}
			setprop("/fdm/jsbsim/systems/oms-hardware/tank-left-oms-valve-B-status", state);
			 };

		# right isolation A

		me.switch_right_isolation_A = cdlg_widget_img_stack.new(me.root, stack, 50, 50);
		me.switch_right_isolation_A.setTranslation(387,444);
		me.switch_right_isolation_A.f = func 
			{
			var state = getprop("/fdm/jsbsim/systems/oms-hardware/tank-right-oms-valve-A-status");
			if (state == 0) {state = 1;} else {state = 0;}
			setprop("/fdm/jsbsim/systems/oms-hardware/tank-right-oms-valve-A-status", state);
			 };

		# right isolation B

		me.switch_right_isolation_B = cdlg_widget_img_stack.new(me.root, stack, 50, 50);
		me.switch_right_isolation_B.setTranslation(468,445);
		me.switch_right_isolation_B.f = func 
			{
			var state = getprop("/fdm/jsbsim/systems/oms-hardware/tank-right-oms-valve-B-status");
			if (state == 0) {state = 1;} else {state = 0;}
			setprop("/fdm/jsbsim/systems/oms-hardware/tank-right-oms-valve-B-status", state);
			 };


		# left crossfeed A

		me.switch_left_crossfeed_A = cdlg_widget_img_stack.new(me.root, stack, 50, 50);
		me.switch_left_crossfeed_A.setTranslation(213,651);
		me.switch_left_crossfeed_A.f = func 
			{
			var state = getprop("/fdm/jsbsim/systems/oms-hardware/crossfeed-left-oms-valve-A-status");
			if (state == 0) {state = 1;} else {state = 0;}
			setprop("/fdm/jsbsim/systems/oms-hardware/crossfeed-left-oms-valve-A-status", state);
			 };

		# left crossfeed B

		me.switch_left_crossfeed_B = cdlg_widget_img_stack.new(me.root, stack, 50, 50);
		me.switch_left_crossfeed_B.setTranslation(295,651);
		me.switch_left_crossfeed_B.f = func 
			{
			var state = getprop("/fdm/jsbsim/systems/oms-hardware/crossfeed-left-oms-valve-B-status");
			if (state == 0) {state = 1;} else {state = 0;}
			setprop("/fdm/jsbsim/systems/oms-hardware/crossfeed-left-oms-valve-B-status", state);
			 };

		# right crossfeed A

		me.switch_right_crossfeed_A = cdlg_widget_img_stack.new(me.root, stack, 50, 50);
		me.switch_right_crossfeed_A.setTranslation(382,654);
		me.switch_right_crossfeed_A.f = func 
			{
			var state = getprop("/fdm/jsbsim/systems/oms-hardware/crossfeed-right-oms-valve-A-status");
			if (state == 0) {state = 1;} else {state = 0;}
			setprop("/fdm/jsbsim/systems/oms-hardware/crossfeed-right-oms-valve-A-status", state);
			 };

		# right crossfeed B

		me.switch_right_crossfeed_B = cdlg_widget_img_stack.new(me.root, stack, 50, 50);
		me.switch_right_crossfeed_B.setTranslation(464,654);
		me.switch_right_crossfeed_B.f = func 
			{
			var state = getprop("/fdm/jsbsim/systems/oms-hardware/crossfeed-right-oms-valve-B-status");
			if (state == 0) {state = 1;} else {state = 0;}
			setprop("/fdm/jsbsim/systems/oms-hardware/crossfeed-right-oms-valve-B-status", state);
			 };

		# left He isolation A

		me.switch_left_He_isolation_A = cdlg_widget_img_stack.new(me.root, stack, 50, 50);
		me.switch_left_He_isolation_A.setTranslation(223,97);
		me.switch_left_He_isolation_A.f = func 
			{
			var state = getprop("/fdm/jsbsim/systems/oms-hardware/helium-left-oms-valve-A-status");
			if (state == 0) {state = 1;} else {state = 0;}
			setprop("/fdm/jsbsim/systems/oms-hardware/helium-left-oms-valve-A-status", state);
			 };



		# left He isolation B

		me.switch_left_He_isolation_B = cdlg_widget_img_stack.new(me.root, stack, 50, 50);
		me.switch_left_He_isolation_B.setTranslation(305,96);
		me.switch_left_He_isolation_B.f = func 
			{
			var state = getprop("/fdm/jsbsim/systems/oms-hardware/helium-left-oms-valve-B-status");
			if (state == 0) {state = 1;} else {state = 0;}
			setprop("/fdm/jsbsim/systems/oms-hardware/helium-left-oms-valve-B-status", state);
			 };

		# right He isolation A

		me.switch_right_He_isolation_A = cdlg_widget_img_stack.new(me.root, stack, 50, 50);
		me.switch_right_He_isolation_A.setTranslation(395,96);
		me.switch_right_He_isolation_A.f = func 
			{
			var state = getprop("/fdm/jsbsim/systems/oms-hardware/helium-right-oms-valve-A-status");
			if (state == 0) {state = 1;} else {state = 0;}
			setprop("/fdm/jsbsim/systems/oms-hardware/helium-right-oms-valve-A-status", state);
			 };

		# right He isolation B

		me.switch_right_He_isolation_B = cdlg_widget_img_stack.new(me.root, stack, 50, 50);
		me.switch_right_He_isolation_B.setTranslation(476,95);
		me.switch_right_He_isolation_B.f = func 
			{
			var state = getprop("/fdm/jsbsim/systems/oms-hardware/helium-right-oms-valve-B-status");
			if (state == 0) {state = 1;} else {state = 0;}
			setprop("/fdm/jsbsim/systems/oms-hardware/helium-right-oms-valve-B-status", state);
			 };


		setsize(stack, 0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/oms_talkback_cl.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/oms_talkback_op.png");

		# left isolation A talkback

		me.tb_left_isolation_A = cdlg_widget_img_stack.new(me.root, stack, 40, 40, 2);
		me.tb_left_isolation_A.setTranslation(233,344);	

		# left isolation B talkback

		me.tb_left_isolation_B = cdlg_widget_img_stack.new(me.root, stack, 40, 40, 2);
		me.tb_left_isolation_B.setTranslation(303,344);	

		# right isolation A talkback

		me.tb_right_isolation_A = cdlg_widget_img_stack.new(me.root, stack, 40, 40, 2);
		me.tb_right_isolation_A.setTranslation(396,345);

		# right isolation B talkback

		me.tb_right_isolation_B = cdlg_widget_img_stack.new(me.root, stack, 40, 40, 2);
		me.tb_right_isolation_B.setTranslation(466,345);

		# left crossfeed A talkback

		me.tb_left_crossfeed_A = cdlg_widget_img_stack.new(me.root, stack, 40, 40, 2);
		me.tb_left_crossfeed_A.setTranslation(232,542);	

		# left crossfeed B talkback

		me.tb_left_crossfeed_B = cdlg_widget_img_stack.new(me.root, stack, 40, 40, 2);
		me.tb_left_crossfeed_B.setTranslation(298,543);	

		# right crossfeed A talkback

		me.tb_right_crossfeed_A = cdlg_widget_img_stack.new(me.root, stack, 40, 40, 2);
		me.tb_right_crossfeed_A.setTranslation(394,544);

		# right crossfeed B talkback

		me.tb_right_crossfeed_B = cdlg_widget_img_stack.new(me.root, stack, 40, 40, 2);
		me.tb_right_crossfeed_B.setTranslation(462,545);		
	

		me.update_flag = 1;
		me.update();

		},


	update: func {

		if (me.update_flag == 0) {return;}

		var left_isolation_A = getprop("/fdm/jsbsim/systems/oms-hardware/tank-left-oms-valve-A-status");
		var left_isolation_B = getprop("/fdm/jsbsim/systems/oms-hardware/tank-left-oms-valve-B-status");

		me.switch_left_isolation_A.set_index (left_isolation_A);
		me.tb_left_isolation_A.set_index (left_isolation_A);

		me.switch_left_isolation_B.set_index (left_isolation_B);
		me.tb_left_isolation_B.set_index (left_isolation_B);

		var right_isolation_A = getprop("/fdm/jsbsim/systems/oms-hardware/tank-right-oms-valve-A-status");
		var right_isolation_B = getprop("/fdm/jsbsim/systems/oms-hardware/tank-right-oms-valve-B-status");

		me.switch_right_isolation_A.set_index (right_isolation_A);
		me.tb_right_isolation_A.set_index (right_isolation_A);

		me.switch_right_isolation_B.set_index (right_isolation_B);
		me.tb_right_isolation_B.set_index (right_isolation_B);

		var left_crossfeed_A = getprop("/fdm/jsbsim/systems/oms-hardware/crossfeed-left-oms-valve-A-status");
		var left_crossfeed_B = getprop("/fdm/jsbsim/systems/oms-hardware/crossfeed-left-oms-valve-B-status");
		
		me.tb_left_crossfeed_A.set_index (left_crossfeed_A);
		me.tb_left_crossfeed_B.set_index (left_crossfeed_B);
		me.switch_left_crossfeed_A.set_index (left_crossfeed_A);
		me.switch_left_crossfeed_B.set_index (left_crossfeed_B);

		var right_crossfeed_A = getprop("/fdm/jsbsim/systems/oms-hardware/crossfeed-right-oms-valve-A-status");
		var right_crossfeed_B = getprop("/fdm/jsbsim/systems/oms-hardware/crossfeed-right-oms-valve-B-status");

		me.tb_right_crossfeed_A.set_index (right_crossfeed_A);
		me.tb_right_crossfeed_B.set_index (right_crossfeed_B);
		me.switch_right_crossfeed_A.set_index (right_crossfeed_A);
		me.switch_right_crossfeed_B.set_index (right_crossfeed_B);


		var left_helium_A = getprop("/fdm/jsbsim/systems/oms-hardware/helium-left-oms-valve-A-status");
		var left_helium_B = getprop("/fdm/jsbsim/systems/oms-hardware/helium-left-oms-valve-B-status");

		me.switch_left_He_isolation_A.set_index(left_helium_A);
		me.switch_left_He_isolation_B.set_index(left_helium_B);

		var right_helium_A = getprop("/fdm/jsbsim/systems/oms-hardware/helium-right-oms-valve-A-status");
		var right_helium_B = getprop("/fdm/jsbsim/systems/oms-hardware/helium-right-oms-valve-B-status");

		me.switch_right_He_isolation_A.set_index(right_helium_A);
		me.switch_right_He_isolation_B.set_index(right_helium_B);

		settimer (func {me.update();}, 0.1);		

		},
};
