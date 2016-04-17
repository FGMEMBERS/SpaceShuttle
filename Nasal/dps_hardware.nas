
# DPS hardware architecture - simulating the state and relations between GPCs, IDPs, 
# MDUs and keyboards
# Thorsten Renk 2015


###############################################################################
# GPC
###############################################################################

# five GPCs to run software, each with a given memory config

var gpc_array = [];

var gpc = {
	new: func () {
 	var g = { parents: [gpc] };
	g.power = 1;
	g.mode = 2;
	g.mode_string = "RUN";
	g.condition = 1.0;
	g.operational = 1;
	g.state = 2;
	g.mcc = 0;
	g.mcc_string = "SYSTEM";
	g.major_function = "";
	g.ops = 0;
	return g;
	},
	# implementing the function of the mode switch
	set_mode: func (mode) {
		me.mode = mode;
		if (mode == 0)
			{
			me.mode_string = "HALT";
			me.operational = 0;
			}
		else if (mode == 1)
			{
			me.mode_string = "STBY";
			me.operational = 0;
			}
 		else if (mode == 2)
			{
			me.mode_string = "RUN";
			if ((me.power == 1) and (me.condition == 1.0))
				{me.operational = 1;}
			}

	},
	# implementing the power switch
	set_power: func (power) {
		me.power = power;
		if (power == 0)
			{me.operational = 0;}
		else if (power == 1)
			{
			if ((me.mode == 1) and (me.condition == 1.0))
				{me.operational = 1;}
			}


	},
	# set a memory config - see table page 2.6-41
	set_memory: func (mcc) {
		me.mcc = mcc;

		if (mcc == 1)
			{
			me.mcc_string = "G1";
			me.major_function = "GNC";
			me.ops = 1;
			}
		else if (mcc == 2)
			{
			me.mcc_string = "G2";
			me.major_function = "GNC";
			me.ops = 2;
			}
		else if (mcc == 3)
			{
			me.mcc_string = "G3";
			me.major_function = "GNC";
			me.ops = 3;
			}
		else if (mcc == 4)
			{
			me.mcc_string = "S2";
			me.major_function = "SM";
			me.ops = 2;
			}
		else if (mcc == 5)
			{
			me.mcc_string = "S4";
			me.major_function = "SM";
			me.ops = 4;
			}
		else if (mcc == 6)
			{
			me.mcc_string = "P9";
			me.major_function = "PL";
			me.ops = 9;
			}
		else if (mcc == 10)
			{
			me.mcc_string = "BFS";
			me.major_function = "BFS";
			me.ops = 0;
			}
	},
	# query the major function
	get_major_function : func {

		if (me.operational == 1)
			{return me.major_function;}
		else
			{return "NIL";}
	},

	# list what the GPC is doing
	list : func {
		print("Power: ", me.power, " mode: ", me.mode_string, " MCC: ", me.mcc_string);


	},
};


# initialize a standard set of five GPCs with mission-specific software

var init_gpcs = func (stage) {

setsize(gpc_array,0);

if (stage == 0)
	{var gnc_mmc = 1;}
else if (stage == 1)
	{var gnc_mmc = 2;}
else
	{var gnc_mmc = 3;}

# first three GPCs always run PASS GNC

var gpc1 = gpc.new();
gpc1.set_memory (gnc_mmc);
append(gpc_array, gpc1);

var gpc2 = gpc.new();
gpc2.set_memory (gnc_mmc);
append(gpc_array, gpc2);

var gpc3 = gpc.new();
gpc3.set_memory (gnc_mmc);
append(gpc_array, gpc3);

# 4th GPC runs SM when in orbit

var gpc4 = gpc.new();

if (stage == 1)
	{gpc4.set_memory (4);}
else
	{gpc4.set_memory (gnc_mmc);}

append(gpc_array, gpc4);

# last GPC runs BFS

var gpc5 = gpc.new();
gpc5.set_memory (10);
append(gpc_array, gpc5);
}


var gpc_check_available = func (major_function) {

var flag = 0;

foreach (g; gpc_array)
	{
	if ((g.get_major_function() == major_function) and (g.operational == 1))
		{flag = 1; break;}
	}
return flag;
}




###############################################################################
# IDP
###############################################################################



# four IDPs to provide information for the screens

var idp_array = [];

var idp = {
	new: func () {
 	var i = { parents: [idp] };
	i.power = 1;
	i.condition = 1.0;
	i.operational = 1;
	i.major_function = 1;
	i.major_function_string = "GNC";
	i.spec = 0;
	i.disp = 0;
	return i;
	},
	# power switch
	set_power: func (power) {
		me.power = power;
		if (power == 0)
			{me.operational = 0;}
		else if (power == 1)
			{
			if (me.condition == 1.0)
				{me.operational = 1;}
			}
	},
	# major function switch
	set_function: func (major_function) {
		me.major_function = major_function;
		if (major_function == 1)
			{me.major_function_string = "GNC";}
		else if (major_function == 2)
			{me.major_function_string = "SM";}
		else if (major_function == 3)
			{me.major_function_string = "PL";}
	},
	# store and retrieve spec and disp per IDP
	set_spec: func (num) {
		me.spec = num;

	},
	set_disp : func (num) {
		me.disp = num;

	},

	get_spec: func {
		return me.spec;
	},
	get_disp: func {
		return me.disp;
	},


	# query major function
	get_major_function : func {
		if (me.operational == 1)
			{return me.major_function;}
		else
			{return 0;}
	},
	list: func {
		print("Power: ", me.power, " major function: ", me.major_function_string);

	},

	
};



# initialize a standard set of four IDPs in GNC

var init_idps = func  {

setsize(idp_array,0);

var idp1 = idp.new();
idp1.set_function(1);
append(idp_array, idp1);

var idp2 = idp.new();
idp2.set_function(1);
append(idp_array, idp2);

var idp3 = idp.new();
idp3.set_function(1);
append(idp_array, idp3);

var idp4 = idp.new();
idp4.set_function(1);
append(idp_array, idp4);

}

# check whether at least one of the MDUs listening to the current IDP actually does DPS

var idp_check_dps = func (idp_index) {

var flag = 0;

foreach (M; SpaceShuttle.MDU_array)
	{
	if (M.PFD.port_selected == idp_index +1)
		{
		if (M.PFD.dps_page_flag == 1)
			{
			flag =1; break;
			}
		}
	}

return flag;
}


# implements the effect of switching the IDP major function switch

var idp_change_major_function = func (idp_index, major_function) {

var I = idp_array[idp_index];


I.set_function(major_function);

var major_mode = 0;

if (major_function == 1)
	{
	major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
	}
else if (major_function == 2)
	{
	major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-sm");
	}

# SPEC and OPS pages are remembered after major function switches, DISP are not

var new_page = SpaceShuttle.get_ops_page(major_function, major_mode);
if ((I.get_spec() > 0) and (major_function == 1))
	{
	new_page = SpaceShuttle.get_spec_page( I.get_spec());
	I.set_disp(0);
	}

SpaceShuttle.page_select(idp_index, new_page);



}

###############################################################################
# Keyboard
###############################################################################

# three keyboards as input devices 

var kb_array = [];


var kb = {
	new: func () {
 	var k = { parents: [kb] };
	k.condition = 1.0;
	return k;
	},
	assign_idp : func (idp) {
	me.idp = idp;
	}, 
	get_idp: func {
	if (me.condition == 1.0)
		{return me.idp;}
	else
		{return 0;}

	},
};


# initialize a standard set of four IDPs in GNC

var init_keyboards = func  {

setsize(kb_array,0);

# assign CDR and PLT  keyboards symmetrically to IDP 3

var kb1 = kb.new();
kb1.assign_idp(3);
append(kb_array, kb1);

var kb2 = kb.new();
kb2.assign_idp(3);
append(kb_array, kb2);

# PL station keyboard is hard-assigned to IDP 4

var kb3 = kb.new();
kb3.assign_idp(4);
append(kb_array, kb3);

}

###############################################################################
# Listeners to read out property changes, may remove in favour of direct bindings
###############################################################################

setlistener("/fdm/jsbsim/systems/dps/idp-function-switch", func (n) {idp_change_major_function(0,n.getValue()); },0,0);
setlistener("/fdm/jsbsim/systems/dps/idp-function-switch[1]", func (n) {idp_change_major_function(1,n.getValue()); },0,0);
setlistener("/fdm/jsbsim/systems/dps/idp-function-switch[2]", func (n) {idp_change_major_function(2,n.getValue()); },0,0);
setlistener("/fdm/jsbsim/systems/dps/idp-function-switch[3]", func (n) {idp_change_major_function(3,n.getValue()); },0,0);
