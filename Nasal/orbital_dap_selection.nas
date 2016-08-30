# orbital DAP selection scheme for the Space Shuttle
# Thorsten Renk 2016


var orbital_dap_manager = {

	fcs_control_mode: 0,
	major_mode: 0,
	attitude_mode : "INRTL",
	selected_dap: "",
	selected_jets: "PRI",
	selected_z_mode: "NORM",


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
		
		# otherwise we have a valid DAP selection

		# AUTO always needs to switch OMS TVC off

		if ((me.fcs_control_mode == 11) and (mode == "AUTO"))
			{
			me.set_fcs_control_mode(20);
			return;
			}

		if ((mode == "AUTO") or (mode == "INRTL"))
			{
			me.set_fcs_control_mode(20);
			}
		else if (mode == "LVLH")
			{
			me.set_fcs_control_mode(20);
			# give LVLH logic time to clear the last attitude fix
			setprop("/fdm/jsbsim/systems/ap/lvlh/engage-flag", 1);
			settimer( func {setprop("/fdm/jsbsim/systems/ap/lvlh/engage-flag", 0);}, 0);
			}
		else if (mode == "FREE")
			{
			me.set_fcs_control_mode(1);
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
	},
	
	set_fcs_control_mode: func (mode) {

		me.fcs_control_mode = mode;
		setprop("/fdm/jsbsim/systems/fcs/control-mode", mode);

		var control_mode_string = "";

		if (mode == 1) {control_mode_string = "RCS ROT PLS";}
		else if (mode == 2) {control_mode_string = "RCS translation";}
		else if (mode == 20) {control_mode_string = "RCS ROT DAP-A";}
		else if (mode == 21) {control_mode_string = "RCS ROT DAP-B";}
		else if (mode == 25) {control_mode_string = "RCS DAP-A VERNIER";}
		else if (mode == 26) {control_mode_string = "RCS TRANS ATT HLD";}
		else if (mode == 27) {control_mode_string = "RCS TRANS LOW-Z";}
		else if (mode == 28) {control_mode_string = "RCS TRANS LOW-Z ATT HLD";}
		else if (mode == 30) {control_mode_string = "RCS DAP-B VERNIER";}

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
