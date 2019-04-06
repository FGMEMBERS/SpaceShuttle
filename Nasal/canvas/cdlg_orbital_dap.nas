var cdlg_orbital_dap = {

	update_flag:  0,

	init: func {


		#var width = 691;
		#var height = 653;

		var width = 518;
		var height = 489;

		var img_path = "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP-panel.png";
						

		var window = canvas.Window.new([width,height],"dialog").set("title", "Orbital DAP");

		# we need to explicitly re-define this to get a handle to stop the update loop
		# upon closing the window

		window.del = func()
		{
		  #print("Cleaning up...\n");
		  SpaceShuttle.cdlg_orbital_dap.update_flag = 0;
		  call(canvas.Window.del, [], me);
		};


		var tempCanvas = window.createCanvas().set("background", canvas.style.getColor("bg_color"));
		me.root = tempCanvas.createGroup();
		var child=me.root.createChild("image")
				                   .setFile(img_path )
				                   .setTranslation(0,0)
						   .setScale(1.333333, 1.33333)
				                   .setSize(width,height);


		# DAP A

		var stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_A_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_A_1.png");

		me.button_DAP_A = cdlg_widget_img_stack.new(me.root, stack, 48, 48);
		me.button_DAP_A.setTranslation(106,105);
		me.button_DAP_A.f = func 
			{
			SpaceShuttle.orbital_dap_manager.dap_select("A");
			 };

		# DAP B


		stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_B_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_B_1.png");

		me.button_DAP_B = cdlg_widget_img_stack.new(me.root, stack, 48, 48);
		me.button_DAP_B.setTranslation(192,105);
		me.button_DAP_B.f = func 
			{
			SpaceShuttle.orbital_dap_manager.dap_select("B");
			 };

		# AUTO
		
		stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_AUTO_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_AUTO_1.png");

		me.button_AUTO = cdlg_widget_img_stack.new(me.root, stack, 48, 48);
		me.button_AUTO.setTranslation(278,105);
		me.button_AUTO.f = func 
			{
			SpaceShuttle.orbital_dap_manager.control_select("AUTO");
			 };

		# INRTL
		
		stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_INRTL_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_INRTL_1.png");

		me.button_INRTL = cdlg_widget_img_stack.new(me.root, stack, 48, 48);
		me.button_INRTL.setTranslation(363,105);
		me.button_INRTL.f = func 
			{
			SpaceShuttle.orbital_dap_manager.control_select("INRTL");
			 };

		# LVLH
		
		stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_LVLH_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_LVLH_1.png");

		me.button_LVLH = cdlg_widget_img_stack.new(me.root, stack, 48, 48);
		me.button_LVLH.setTranslation(449,105);
		me.button_LVLH.f = func 
			{
			SpaceShuttle.orbital_dap_manager.control_select("LVLH");
			 };

		# FREE
		
		stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_FREE_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_FREE_1.png");

		me.button_FREE = cdlg_widget_img_stack.new(me.root, stack, 48, 48);
		me.button_FREE.setTranslation(534,105);
		me.button_FREE.f = func 
			{
			SpaceShuttle.orbital_dap_manager.control_select("FREE");
			 };

		# low Z
		
		stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_low_Z_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_low_Z_1.png");

		me.button_lowZ = cdlg_widget_img_stack.new(me.root, stack, 48, 48);
		me.button_lowZ.setTranslation(191,299);
		me.button_lowZ.f = func 
			{
			SpaceShuttle.orbital_dap_manager.z_mode_select("LOW");
			 };

		# high Z
		
		stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_high_Z_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_high_Z_1.png");

		me.button_highZ = cdlg_widget_img_stack.new(me.root, stack, 48, 48);
		me.button_highZ.setTranslation(273,299);
		me.button_highZ.f = func 
			{
			SpaceShuttle.orbital_dap_manager.z_mode_select("HIGH");
			 };

		# PRI
		
		stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_PRI_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_PRI_1.png");

		me.button_PRI = cdlg_widget_img_stack.new(me.root, stack, 48, 48);
		me.button_PRI.setTranslation(377,299);
		me.button_PRI.f = func 
			{
			SpaceShuttle.orbital_dap_manager.jet_select("PRI");
			 };

		# ALT
		
		stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_ALT_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_ALT_1.png");

		me.button_ALT = cdlg_widget_img_stack.new(me.root, stack, 48, 48);
		me.button_ALT.setTranslation(457,299);
		me.button_ALT.f = func 
			{
			SpaceShuttle.orbital_dap_manager.jet_select("ALT");
			 };

		# VRN
		
		stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_VERN_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_VERN_1.png");

		me.button_VRN = cdlg_widget_img_stack.new(me.root, stack, 48, 48);
		me.button_VRN.setTranslation(537,299);
		me.button_VRN.f = func 
			{
			SpaceShuttle.orbital_dap_manager.jet_select("VRN");
			 };



		# NORM X
		
		stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_NORM_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_NORM_1.png");

		me.button_NORM_X = cdlg_widget_img_stack.new(me.root, stack, 48, 48);
		me.button_NORM_X.setTranslation(112,400);
		me.button_NORM_X.f = func 
			{
			SpaceShuttle.orbital_dap_manager.translation_mode_select("NORM", "X");
			 };

		# NORM Y
		
		stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_NORM_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_NORM_1.png");

		me.button_NORM_Y = cdlg_widget_img_stack.new(me.root, stack, 48, 48);
		me.button_NORM_Y.setTranslation(194,400);
		me.button_NORM_Y.f = func 
			{
			SpaceShuttle.orbital_dap_manager.translation_mode_select("NORM", "Y");
			 };

		# NORM Z
		
		stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_NORM_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_NORM_1.png");

		me.button_NORM_Z = cdlg_widget_img_stack.new(me.root, stack, 48, 48);
		me.button_NORM_Z.setTranslation(272,400);
		me.button_NORM_Z.f = func 
			{
			SpaceShuttle.orbital_dap_manager.translation_mode_select("NORM", "Z");
			 };

		# PULSE X
		
		stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_PULSE_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_PULSE_1.png");

		me.button_PULSE_X = cdlg_widget_img_stack.new(me.root, stack, 48, 48);
		me.button_PULSE_X.setTranslation(112,496);
		me.button_PULSE_X.f = func 
			{
			SpaceShuttle.orbital_dap_manager.translation_mode_select("PULSE", "X");
			 };

		# PULSE Y
		
		stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_PULSE_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_PULSE_1.png");

		me.button_PULSE_Y = cdlg_widget_img_stack.new(me.root, stack, 48, 48);
		me.button_PULSE_Y.setTranslation(194,496);
		me.button_PULSE_Y.f = func 
			{
			SpaceShuttle.orbital_dap_manager.translation_mode_select("PULSE", "Y");
			 };

		# PULSE Z
		
		stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_PULSE_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_PULSE_1.png");

		me.button_PULSE_Z = cdlg_widget_img_stack.new(me.root, stack, 48, 48);
		me.button_PULSE_Z.setTranslation(272,496);
		me.button_PULSE_Z.f = func 
			{
			SpaceShuttle.orbital_dap_manager.translation_mode_select("PULSE", "Z");
			 };


		# DISC ROLL
		
		stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_DISC_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_DISC_1.png");

		me.button_DISC_ROLL = cdlg_widget_img_stack.new(me.root, stack, 48, 48);
		me.button_DISC_ROLL.setTranslation(377,400);
		me.button_DISC_ROLL.f = func 
			{
			SpaceShuttle.orbital_dap_manager.rot_rate_select("DISC", "ROLL");
			 };

		# DISC PITCH
		
		stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_DISC_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_DISC_1.png");

		me.button_DISC_PITCH = cdlg_widget_img_stack.new(me.root, stack, 48, 48);
		me.button_DISC_PITCH.setTranslation(457,400);
		me.button_DISC_PITCH.f = func 
			{
			SpaceShuttle.orbital_dap_manager.rot_rate_select("DISC", "PITCH");
			 };
	
		# DISC YAW
		
		stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_DISC_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_DISC_1.png");

		me.button_DISC_YAW = cdlg_widget_img_stack.new(me.root, stack, 48, 48);
		me.button_DISC_YAW.setTranslation(537,400);
		me.button_DISC_YAW.f = func 
			{
			SpaceShuttle.orbital_dap_manager.rot_rate_select("DISC", "YAW");
			 };

		# PULSE ROLL
		
		stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_PULSE_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_PULSE_1.png");

		me.button_PULSE_ROLL = cdlg_widget_img_stack.new(me.root, stack, 48, 48);
		me.button_PULSE_ROLL.setTranslation(377,496);
		me.button_PULSE_ROLL.f = func 
			{
			SpaceShuttle.orbital_dap_manager.rot_rate_select("PULSE", "ROLL");
			 };

		# PULSE PITCH
		
		stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_PULSE_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_PULSE_1.png");

		me.button_PULSE_PITCH = cdlg_widget_img_stack.new(me.root, stack, 48, 48);
		me.button_PULSE_PITCH.setTranslation(457,496);
		me.button_PULSE_PITCH.f = func 
			{
			SpaceShuttle.orbital_dap_manager.rot_rate_select("PULSE", "PITCH");
			 };

		# PULSE YAW
		
		stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_PULSE_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/OrbitalDAP/DAP_PULSE_1.png");

		me.button_PULSE_YAW = cdlg_widget_img_stack.new(me.root, stack, 48, 48);
		me.button_PULSE_YAW.setTranslation(537,496);
		me.button_PULSE_YAW.f = func 
			{
			SpaceShuttle.orbital_dap_manager.rot_rate_select("PULSE", "YAW");
			 };

		me.root.setScale(0.75, 0.75);

	

		me.update_flag = 1;
		me.update();

		},


	update: func {

		if (me.update_flag == 0) {return;}


		me.button_DAP_A.set_index (getprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/dap-a-select"));
		me.button_DAP_B.set_index (getprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/dap-b-select"));


		me.button_AUTO.set_index (getprop("/fdm/jsbsim/systems/ap/orbital-dap-auto"));
		me.button_INRTL.set_index (getprop("/fdm/jsbsim/systems/ap/orbital-dap-inertial"));
		me.button_LVLH.set_index (getprop("/fdm/jsbsim/systems/ap/orbital-dap-lvlh"));
		me.button_FREE.set_index (getprop("/fdm/jsbsim/systems/ap/orbital-dap-free"));

		me.button_lowZ.set_index (getprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/zlow-select"));
		me.button_highZ.set_index (getprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/zhigh-select"));

		me.button_PRI.set_index (getprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/pri-select"));
		me.button_ALT.set_index (getprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/alt-select"));
		me.button_VRN.set_index (getprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/vrn-select"));

		me.button_NORM_X.set_index (getprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-x-norm"));
		me.button_NORM_Y.set_index (getprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-y-norm"));
		me.button_NORM_Z.set_index (getprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-z-norm"));

		me.button_PULSE_X.set_index (getprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-x-pulse"));
		me.button_PULSE_Y.set_index (getprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-y-pulse"));
		me.button_PULSE_Z.set_index (getprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-z-pulse"));

		me.button_DISC_ROLL.set_index(getprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-r-disc"));
		me.button_DISC_PITCH.set_index(getprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-p-disc"));
		me.button_DISC_YAW.set_index(getprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-y-disc"));

		me.button_PULSE_ROLL.set_index(getprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-r-pulse"));
		me.button_PULSE_PITCH.set_index(getprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-p-pulse"));
		me.button_PULSE_YAW.set_index(getprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-y-pulse"));
		settimer (func {me.update();}, 0.1);		

		},
};
