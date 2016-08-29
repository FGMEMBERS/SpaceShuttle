# orbital DAP selection scheme for the Space Shuttle
# Thorsten Renk 2016


var orbital_dap_manager = {

	fcs_control_mode: 0,
	major_mode: 0,
	attitude_mode : "INRTL",
	selected_dap: "",


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

		if (mode == 20) {control_mode_string = "RCS ROT DAP-A";}
		else if (mode == 21) {control_mode_string = "RCS ROT DAP-B";}
		else if (mode == 25) {control_mode_string = "RCS DAP-A VERNIER";}
		else if (mode == 30) {control_mode_string = "RCS DAP-B VERNIER";}

		if (me.attitude_mode == "AUTO")
			{
			control_mode_string = control_mode_string~" AUTO";
			}

		setprop("/controls/shuttle/control-system-string", control_mode_string);

	},

};
