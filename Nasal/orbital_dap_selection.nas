# orbital DAP selection scheme for the Space Shuttle
# Thorsten Renk 2016


var orbital_dap_manager = {

	fcs_control_mode: 0,
	major_mode: 0,
	attitude_mode : "INRTL",
	selected_dap: "",
	selected_jets: "PRI",
	selected_z_mode: "NORM",
	selected_device: "RHC",


	dap_select: func (dap) {

		me.get_state();
		
		if ((me.major_mode != 201) and (me.major_mode != 202))
			{
			print("DAP selection is only supported in OPS 2");
			return;
			}

		me.selected_dap = dap;

		if ((me.fcs_control_mode == 20) and (dap == "B"))
			{
			me.set_fcs_control_mode(21);
			}
		else if ((me.fcs_control_mode == 21) and (dap == "A"))
			{
			me.set_fcs_control_mode(20);
			}
		else if ((me.fcs_control_mode == 25) and (dap == "B"))
			{
			me.set_fcs_control_mode(30);
			}
		else if ((me.fcs_control_mode == 30) and (dap == "A"))
			{
			me.set_fcs_control_mode(25);
			}
		else if ((me.fcs_control_mode == 1) and (dap == "B"))
			{
			me.set_fcs_control_mode(32);
			}
		else if ((me.fcs_control_mode == 32) and (dap == "A"))
			{
			me.set_fcs_control_mode(1);
			}
		else if ((me.fcs_control_mode == 31) and (dap == "B"))
			{
			me.set_fcs_control_mode(33);
			}
		else if ((me.fcs_control_mode == 33) and (dap == "A"))
			{
			me.set_fcs_control_mode(31);
			}

		if (dap == "A")
			{			
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/dap-a-select", 1);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/dap-b-select", 0);
			}
		else if (dap == "B")
			{
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/dap-a-select", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/dap-b-select", 1);
			}


	},


	jet_select : func (sys) {

		me.get_state();

		if ((me.major_mode != 201) and (me.major_mode != 202))
			{
			print("Jet system selection is only supported in OPS 2");
			return;
			}

		me.selected_jets = sys;

		if ((me.fcs_control_mode == 20) and (sys == "VRN"))
			{
			me.set_fcs_control_mode(25);
			}
		else if ((me.fcs_control_mode == 21) and (sys == "VRN"))
			{
			me.set_fcs_control_mode(30);
			}
		else if ((me.fcs_control_mode == 25) and ((sys == "PRI") or (sys == "ALT")))
			{
			me.set_fcs_control_mode(20);
			}
		else if ((me.fcs_control_mode == 30) and ((sys == "PRI") or (sys == "ALT")))
			{
			me.set_fcs_control_mode(21);
			}
		else if ((me.fcs_control_mode == 1) and (sys == "VRN"))
			{
			me.set_fcs_control_mode(31);
			}
		else if ((me.fcs_control_mode == 31) and ((sys == "PRI") or (sys == "ALT")))
			{
			me.set_fcs_control_mode(1);
			}
		else if ((me.fcs_control_mode == 32) and (sys == "VRN"))
			{
			me.set_fcs_control_mode(33);
			}
		else if ((me.fcs_control_mode == 33) and ((sys == "PRI") or (sys == "ALT")))
			{
			me.set_fcs_control_mode(32);
			}


		if (sys == "PRI")
			{			
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/pri-select", 1);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/alt-select", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/vrn-select", 0);
			}
		else if (sys == "ALT")
			{
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/pri-select", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/alt-select", 1);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/vrn-select", 0);
			}
		else if (sys == "VRN")
			{
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/pri-select", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/alt-select", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/vrn-select", 1);
			}

	},


	control_select: func (mode) {

		me.get_state();

		if ((me.major_mode != 201) and (me.major_mode != 202) and ((mode == "LVLH") or (mode == "FREE")))
			{
			print("Control mode ", mode ," is only supported in OPS 2");
			return;
			}


		me.attitude_mode = mode;

		if (mode == "INRTL")
			{
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-auto",0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-inertial", 1);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-lvlh", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-free", 0);
			}
		else if (mode == "AUTO")
			{
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-auto",1);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-inertial", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-lvlh", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-free", 0);
			}
		else if (mode == "LVLH")
			{
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-auto",0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-inertial", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-lvlh", 1);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-free", 0);
			}
		else if (mode == "FREE")
			{
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-auto",0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-inertial", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-lvlh", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-free", 1);
			}

		# make sure we don't switch the DAP accidentially when not in orbit

		if ((me.fcs_control_mode == 0) or (me.fcs_control_mode == 10) or (me.fcs_control_mode == 11) or (me.fcs_control_mode == 12) or (me.fcs_control_mode == 13) or (me.fcs_control_mode == 29) or (me.fcs_control_mode == 3) or (me.fcs_control_mode == 4))
			{
			return;
			}

		# don't actually change rotational DAP when we're using THC

		if (me.selected_device == "THC") 
			{
			var target_mode =  me.find_control_mode ("THC", me.selected_dap, mode, me.selected_jets, me.selected_z_mode);
			if (target_mode != -1)
				{
				me.set_fcs_control_mode(target_mode);

				if (mode == "LVLH")
					{
					# give LVLH logic time to clear the last attitude fix
					setprop("/fdm/jsbsim/systems/ap/lvlh/engage-flag", 1);
					settimer( func {setprop("/fdm/jsbsim/systems/ap/lvlh/engage-flag", 0);}, 0);
					}
				}
			
			return;

			}

		
		# otherwise we have a valid DAP selection

		# AUTO always needs to switch OMS TVC off

		if ((me.fcs_control_mode == 11) and (mode == "AUTO"))
			{
			me.set_fcs_control_mode(20);
			return;
			}

		var target_mode =  me.find_control_mode ("RHC", me.selected_dap, mode, me.selected_jets, me.selected_z_mode);

		if (target_mode == -1) {target_mode = 20;}

		me.set_fcs_control_mode(target_mode);

		if (mode == "LVLH")
			{
			# give LVLH logic time to clear the last attitude fix
			setprop("/fdm/jsbsim/systems/ap/lvlh/engage-flag", 1);
			settimer( func {setprop("/fdm/jsbsim/systems/ap/lvlh/engage-flag", 0);}, 0);
			}


	},


	rot_rate_select: func (mode, axis) {

		me.get_state();

		if ((me.major_mode != 201) and (me.major_mode != 202))
			{
			print("Axis rate selection is only supported in OPS 2");
			return;
			}


		if (mode == "DISC")
			{
			if (axis == "PITCH")
				{
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-p-disc", 1);
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-p-pulse", 0);
				}
			else if (axis == "YAW")
				{
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-y-disc", 1);
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-y-pulse", 0);
				}
			else if (axis == "ROLL")
				{
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-r-disc", 1);
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-r-pulse", 0);
				}
			}
		else if (mode == "PULSE")
			{
			if (axis == "PITCH")
				{
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-p-disc", 0);
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-p-pulse", 1);
				}
			else if (axis == "YAW")
				{
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-y-disc", 0);
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-y-pulse", 1);
				}
			else if (axis == "ROLL")
				{
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-r-disc", 0);
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-r-pulse", 1);
				}
			}


	},
	

	translation_mode_select : func (mode, axis) {

		me.get_state();

		if ((me.major_mode != 201) and (me.major_mode != 202))
			{
			print("Translation mode selection is only supported in OPS 2");
			return;
			}

		if (mode == "NORM")
			{
			if (axis == "X")
				{
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-x-norm", 1);
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-x-pulse", 0);
				}
			else if (axis == "Y")
				{
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-y-norm", 1);
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-y-pulse", 0);
				}
			else if (axis == "Z")
				{
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-z-norm", 1);
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-z-pulse", 0);
				}
			}
		else if (mode == "PULSE")
					{
			if (axis == "X")
				{
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-x-norm", 0);
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-x-pulse", 1);
				}
			else if (axis == "Y")
				{
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-y-norm", 0);
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-y-pulse", 1);
				}
			else if (axis == "Z")
				{
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-z-norm", 0);
				setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-z-pulse", 1);
				}
			}

	},


	z_mode_select : func (mode) {

		me.get_state();

		if ((me.major_mode != 201) and (me.major_mode != 202))
			{
			print("Z-mode selection is only supported in OPS 2");
			return;
			}

		me.selected_z_mode = mode;

		if ((me.fcs_control_mode == 2) and (mode == "LOW"))
			{
			me.set_fcs_control_mode(27);
			}
		else if 
			((me.fcs_control_mode == 26) and (mode == "LOW"))
			{
			me.set_fcs_control_mode(28);
			}
		else if ((me.fcs_control_mode == 27) and (mode == "HIGH"))
			{
			me.set_fcs_control_mode(2);
			}
		else if ((me.fcs_control_mode == 28) and (mode == "HIGH"))
			{
			me.set_fcs_control_mode(26);
			}

		if (mode == "NORM")
			{			
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/znorm-select", 1);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/zlow-select", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/zhigh-select", 0);
			}
		else if (mode == "LOW")
			{			
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/znorm-select", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/zlow-select", 1);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/zhigh-select", 0);
			}
		else if (mode == "HIGH")
			{			
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/znorm-select", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/zlow-select", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/zhigh-select", 1);
			}

	},

	toggle_input_device: func {


		if (me.selected_device == "RHC")
			{
			me.input_device_select("THC");
			}
		else
			{
			me.input_device_select("RHC");
			}

	},

	input_device_select: func (device) {

		me.get_state();

		# do not allow to select THC when not in a suitable DAP
		
		if ((me.fcs_control_mode == 0) or (me.fcs_control_mode == 10) or (me.fcs_control_mode == 11) or (me.fcs_control_mode == 12) or (me.fcs_control_mode == 13) or (me.fcs_control_mode == 24) or (me.fcs_control_mode == 29))
			{
			if (device == "THC")
				{
				print ("THC has no function in the current major mode");
				return;
				}
			}

		var target_mode = me.find_control_mode (device, me.selected_dap, me.attitude_mode, me.selected_jets, me.selected_z_mode);

		if (target_mode != -1)
			{
			me.set_fcs_control_mode (target_mode);
			me.selected_device = device;
			setprop("/sim/messages/copilot", device~" active");
			}

	},


	find_control_mode: func (device, dap, control, jets, z_mode) {

		print(device, " ", dap, " ", control, " ", jets, " ", z_mode);

		if (device == "THC")
			{
			if ((z_mode == "NORM") or (z_mode == "HIGH"))
				{
				if ((control == "INRTL") or (control=="LVLH"))
					{return 26;}
				else if (control == "FREE")
					{return 2;}
				}
			else if (z_mode == "LOW")
				{
				if ((control == "INRTL") or (control=="LVLH"))
					{return 28;	}
				else if (control == "FREE")
					{return 27;}
				}
			}
		else if (device == "RHC")
			{
			if ((jets == "PRI") or (jets == "ALT"))
				{
				if ((control == "INRTL") or (control == "AUTO") or (control == "LVLH"))
					{
					if (dap == "A")
						{return 20;}
					else if (dap == "B")
						{return 21;}
					}
				else if (control == "FREE")	
					{
					if (dap == "A")
						{return 1;}
					else if (dap == "B")
						{return 32;}
					}
				
				}
			else if (jets = "VRN")
				{
				if ((control == "INRTL") or (control == "AUTO") or (control == "LVLH"))
					{
					if (dap == "A")
						{return 25;}
					else if (dap == "B")
						{return 30;}
					}
				else if (control == "FREE")
					{
					if (dap == "A")
						{return 31;}
					else if (dap == "B")
						{return 33;}
					}

				}
			}

		setprop("/sim/messages/copilot", "Requested DAP is not implemented, check pushbuttons." );
		return -1;


	},

	get_state: func {

		me.fcs_control_mode = getprop("/fdm/jsbsim/systems/fcs/control-mode");
		me.major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");

		var orbital_dap_inertial = getprop("/fdm/jsbsim/systems/ap/orbital-dap-inertial");
		var orbital_dap_free = getprop("/fdm/jsbsim/systems/ap/orbital-dap-free");
		var orbital_dap_lvlh = getprop("/fdm/jsbsim/systems/ap/orbital-dap-lvlh");
		var orbital_dap_auto = getprop("/fdm/jsbsim/systems/ap/orbital-dap-auto");

		if (orbital_dap_inertial == 1) {me.attitude_mode = "INRTL";}
		else if (orbital_dap_free == 1) {me.attitude_mode = "FREE";}
		else if (orbital_dap_lvlh == 1) {me.attitude_mode = "LVLH";}
		else if (orbital_dap_auto == 1) {me.attitude_mode = "AUTO";}

		var dap_selection = getprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/dap-b-select");
		if (dap_selection == 1) {me.selected_dap = "B";}
		else {me.selected_dap = "A";}

		var jet_selection = getprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/vrn-select");
		if (jet_selection == 1) {me.selected_jets = "VRN";}
		else {me.selected_jets = "PRI";}

		var z_mode = getprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/zlow-select");
		if (z_mode == 1) {me.selected_z_mode = "LOW";}
		else {me.selected_z_mode = "NORM";}

	},


	load_dap: func (dap) {


		if (dap == "TRANSITION")
			{
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-inertial", 1);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-lvlh", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-auto", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-free", 0);

			me.attitude_mode = "INRTL";

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/dap-a-select",0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/dap-b-select",0);

			me.selected_dap = "A";

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/pri-select",0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/alt-select",0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/vrn-select",0);

			me.selected_jets = "PRI";

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-r-disc",0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-r-pulse",0);

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-p-disc",0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-p-pulse",0);

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-y-disc",0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-y-pulse",0);

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-x-norm", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-x-pulse", 0);

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-y-norm", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-y-pulse", 0);

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-z-norm", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-z-pulse", 0);

			me.set_fcs_control_mode(20);
			}
		else if (dap == "ORBIT")
			{
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-inertial", 1);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-lvlh", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-auto", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-free", 0);

			me.attitude_mode = "INRTL";

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/dap-a-select",1);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/dap-b-select",0);

			me.selected_dap = "A";

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/pri-select",1);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/alt-select",0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/vrn-select",0);

			me.selected_jets = "PRI";

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-r-disc",1);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-r-pulse",0);

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-p-disc",1);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-p-pulse",0);

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-y-disc",1);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-y-pulse",0);

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-x-norm", 1);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-x-pulse", 0);

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-y-norm", 1);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-y-pulse", 0);

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-z-norm", 1);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-z-pulse", 0);

			me.set_fcs_control_mode(20);
			}
		else if (dap == "NONE")
			{
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-inertial", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-lvlh", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-auto", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-free", 0);

			me.attitude_mode = "";

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/dap-a-select",0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/dap-b-select",0);

			me.selected_dap = "";

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/pri-select",0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/alt-select",0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/vrn-select",0);

			me.selected_jets = "";

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-r-disc",0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-r-pulse",0);

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-p-disc",0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-p-pulse",0);

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-y-disc",0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/rot-y-pulse",0);

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-x-norm", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-x-pulse", 0);

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-y-norm", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-y-pulse", 0);

			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-z-norm", 0);
			setprop("/fdm/jsbsim/systems/ap/orbital-dap-buttons/trans-z-pulse", 0);

			}


	},
	
	
	set_fcs_control_mode: func (mode) {

		me.fcs_control_mode = mode;
		setprop("/fdm/jsbsim/systems/fcs/control-mode", mode);

		var control_mode_string = "";

		if (mode == 1) {control_mode_string = "RCS ROT DAP-A PLS";}
		else if (mode == 2) {control_mode_string = "RCS translation";}
		else if (mode == 20) {control_mode_string = "RCS ROT DAP-A";}
		else if (mode == 21) {control_mode_string = "RCS ROT DAP-B";}
		else if (mode == 25) {control_mode_string = "RCS DAP-A VERNIER";}
		else if (mode == 26) {control_mode_string = "RCS TRANS ATT HLD";}
		else if (mode == 27) {control_mode_string = "RCS TRANS LOW-Z";}
		else if (mode == 28) {control_mode_string = "RCS TRANS LOW-Z ATT HLD";}
		else if (mode == 30) {control_mode_string = "RCS DAP-B VERNIER";}
		else if (mode == 31) {control_mode_string = "RCS ROT DAP-A PLS VERNIER";}
		else if (mode == 32) {control_mode_string = "RCS ROT DAP-B PLS";}
		else if (mode == 33) {control_mode_string = "RCS ROT DAP-B PLS VERNIER";}

		if (me.attitude_mode == "AUTO")
			{
			control_mode_string = control_mode_string~" AUTO";
			}
		else if (me.attitude_mode == "LVLH")
			{
			control_mode_string = control_mode_string~" LVLH";
			}

		setprop("/controls/shuttle/control-system-string", control_mode_string);

	},

};
