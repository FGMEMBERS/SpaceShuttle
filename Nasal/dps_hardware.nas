
# DPS hardware architecture - simulating the state and relations between GPCs, IDPs, 
# MDUs and keyboards
# Thorsten Renk 2015-2017

var dps_simulation_detail_level = getprop("/sim/config/shuttle/dps-detail-level");

###############################################################################
# GPC
###############################################################################

# five GPCs to run software, each with a given memory config

var gpc_array = [];

var gpc = {
	new: func (index) {
 	var g = { parents: [gpc] };
	g.index = index;
	g.power = 1;
	g.power_usage = 0.56;
	g.mode = 2;
	g.mode_string = "RUN";
	g.condition = 1.0;
	g.operational = 1;
	g.output_switch = 0;
	g.output_state = 1;
	g.state = 2;
	g.mcc = 0;
	g.mcc_string = "SYSTEM";
	g.major_function = "";
	g.ops = 0;
	g.string1 = "";
	g.string2 = "";
	g.string3 = "";
	g.string4 = "";
	g.pl1 = "";
	g.pl2 = "";
	g.launch1 = "";
	g.launch2 = "";
	g.crt1 = "";
	g.crt2 = "";
	g.crt3 = "";
	g.crt4 = "";
	return g;
	},
	# implementing the function of the mode switch
	set_mode: func (mode) {
		me.mode = mode;
		if (mode == 0)
			{
			me.mode_string = "HALT";
			me.operational = 0;
			if (dps_simulation_detail_level == 1)
				{
				if (me.major_function == "BFS")
					{
					me.ops = 0;
					setprop("/fdm/jsbsim/systems/dps/ops-bfs", 0);
					setprop("/fdm/jsbsim/systems/dps/major-mode-bfs", 0);
					}
				else
					{
					me.ops = 0;
					me.major_function = "SYSTEM";
					}
				}
			setprop("/fdm/jsbsim/systems/dps/gpc"~(me.index+1)~"-mode-talkback", 0);
			}
		else if (mode == 1)
			{
			if (me.major_function == "BFS")
				{
				me.mode_string = "RUN";
				if ((me.power == 1) and (me.condition == 1.0))
					{
					me.operational = 1;
					setprop("/fdm/jsbsim/systems/dps/gpc"~(me.index+1)~"-mode-talkback", 1);
					}
				}
			else
				{
				if (me.mode_string == "RUN")
					{setprop("/fdm/jsbsim/systems/dps/gpc"~(me.index+1)~"-mode-talkback", 0);}
				else 
					{setprop("/fdm/jsbsim/systems/dps/gpc"~(me.index+1)~"-mode-talkback", 1);}
				me.mode_string = "STBY";
				me.operational = 0;
				}

			}
 		else if (mode == 2)
			{
			me.mode_string = "RUN";
			if ((me.power == 1) and (me.condition == 1.0))
				{
				me.operational = 1;
				setprop("/fdm/jsbsim/systems/dps/gpc"~(me.index+1)~"-mode-talkback", 1);
				}
			}

		me.adjust_power_usage();
		me.adjust_output();

	},

	# implementation of the output bus switch

	set_output: func (output) {

		me.output_switch = output;
		me.adjust_output();


	},

	adjust_output: func {

		if (SpaceShuttle.bfs_in_control == 0)
			{
			if (me.output_switch == 0) 
				{
				if ((me.power == 1) and (me.condition == 1.0) and (me.mode == 2) )
					{
					me.output_state = 1;
					}
				else
					{
					me.output_state = 0;
					}
				}
			else 
				{

				me.output_state = 0;
				}
			}
		else
			{
			if (((me.output_switch == 0) or (me.output_switch == 1)) and (me.mcc == 10)) 
				{
				if ((me.power == 1) and (me.condition == 1.0) and (me.mode == 2) )
					{
					me.output_state = 1;
					}
				else
					{
					me.output_state = 0;
					}
				}
			else
				{
				me.output_state = 0;
				}


			}


		setprop("/fdm/jsbsim/systems/dps/gpc"~(me.index+1)~"-bus-talkback", me.output_state);

	},
		

	# implementing the power switch
	set_power: func (power) {
		me.power = power;
		if (power == 0)
			{
			me.operational = 0;
			setprop("/fdm/jsbsim/systems/dps/gpc"~(me.index+1)~"-mode-talkback", 0);

			if (me.major_function == "GNC")
				{
				# clear all PASS software errors

				setprop("/fdm/jsbsim/systems/dps/pass/error-pitch", 0.0);
				setprop("/fdm/jsbsim/systems/dps/pass/error-yaw", 0.0);
				setprop("/fdm/jsbsim/systems/dps/pass/error-roll", 0.0);

				# clear memory config

				if (dps_simulation_detail_level == 1)
					{
					me.set_memory(0);
					}
				}
			}
		else if (power == 1)
			{
			if ((me.mode == 2) and (me.condition == 1.0))
				{me.operational = 1;}
			}

		me.adjust_power_usage();
		me.adjust_output();

	},
	# listener to condition property calls this
	set_condition: func (condition) {
		me.condition = condition;
		if (condition < 1.0)
			{me.operational = 0;}
		else if (condition == 1.0)
			{
			if ((me.mode == 2) and (me.power == 1))
				{me.operational = 1;}
			}


	},
	# power usage

	adjust_power_usage: func {

		if (me.power == 1)
			{
			if ((me.mode == 2) or (me.mode == 1))
				{
				me.power_usage = 0.56;
				}
			else 
				{
				me.power_usage = 0.056;
				}
			}			
		else
			{
			me.power_usage = 0.0;
			}
		setprop("/fdm/jsbsim/systems/dps/gpc"~(me.index+1)~"-power-demand-kW", me.power_usage);
	},
	

	# set a memory config - see table page 2.6-41
	set_memory: func (mcc) {
		me.mcc = mcc;
	
		if (mcc == 0)
			{
			me.mcc_string = "";
			me.major_function = "SYSTEM";
			me.ops = 0;
			}
		else if (mcc == 1)
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
			me.ops = 10;
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
		print("Condition: ", me.condition, " operational: ", me.operational);


	},
};


# the GPC manager takes care of per-set information

var gpc_manager = {

	valid_output: 1,
	valid_output_last: 1,


	to_bfs: func {

	foreach (g; gpc_array)
		{
		g.adjust_output();
		}

	},


	check_output: func {

	var flag = 0;

	foreach (g; gpc_array)
		{


		if (SpaceShuttle.bfs_in_control == 0)
			{
			if ((g.output_state == 1) and (g.major_function == "GNC"))
				{

				if ((g.string1 == "*") or (g.string2 == "*") or (g.string3 == "*") or (g.string4 == "*"))
					{
					flag = 1;
					break;
					}
				}
			}
		else
			{
			if ((g.output_state == 1) and (g.major_function == "BFS"))
				{
				flag = 1;
				break;
				}

			}
		}
		me.valid_output = flag;

		if (me.valid_output != me.valid_output_last)
			{
			setprop("/fdm/jsbsim/systems/dps/valid-output", me.valid_output);
			me.valid_output_last = me.valid_output;

			if (me.valid_output == 0)
				{SpaceShuttle.callout.make ("No GPC is assigned to output data!", "limit");}
			}


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

var gpc1 = gpc.new(0);
gpc1.set_memory (gnc_mmc);
append(gpc_array, gpc1);

var gpc2 = gpc.new(1);
gpc2.set_memory (gnc_mmc);
append(gpc_array, gpc2);

var gpc3 = gpc.new(2);
gpc3.set_memory (gnc_mmc);
append(gpc_array, gpc3);

# 4th GPC runs SM when in orbit

var gpc4 = gpc.new(3);

if (stage == 1)
	{gpc4.set_memory (4);}
else
	{gpc4.set_memory (gnc_mmc);}

append(gpc_array, gpc4);

# last GPC runs BFS

var gpc5 = gpc.new(4);
gpc5.set_memory (10);
gpc5.output_state = 1;
gpc5.output_switch = 1;
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
# NBAT (nominal bus assignment table)
###############################################################################

var nbat = {

	ops: 0,

	string1: 1,
	string2: 2,
	string3: 3,
	string4: 4,

	string1_gnc: 1,
	string2_gnc: 2,
	string3_gnc: 4,
	string4_gnc: 4,

	launch1: 1,
	launch2: 2,
	pl1: 4,
	pl2: 4,
	mm1: 1,
	mm2: 2,

	mm_area_pl: 1,
	mm_area_sm: 1,
	mm_area_gnc: 1,

	crt: [1,2,3,2],
	crt_sm: [4,4,4,4],

	gpc: [1,1,1,1,10],

	config_modified: 0,

	g1_string1: 1,
	g1_string2: 2,
	g1_string3: 3,
	g1_string4: 4,
	g1_launch1: 1,
	g1_launch2: 2,
	g1_pl1: 0,
	g1_pl2: 0,
	g1_mm1: 1,
	g1_mm2: 2,
	g1_crt: [1,2,3,2],
	g1_gpc: [1,1,1,1,10],

	g2_string1: 1,
	g2_string2: 2,
	g2_string3: 3,
	g2_string4: 1,
	g2_launch1: 0,
	g2_launch2: 0,
	g2_pl1: 0,
	g2_pl2: 0,
	g2_mm1: 1,
	g2_mm2: 2,
	g2_crt: [1,2,3,2],
	g2_gpc: [2,2,2,4,10],

	g3_string1: 1,
	g3_string2: 2,
	g3_string3: 3,
	g3_string4: 4,
	g3_launch1: 0,
	g3_launch2: 0,
	g3_pl1: 0,
	g3_pl2: 0,
	g3_mm1: 1,
	g3_mm2: 2,
	g3_crt: [1,2,3,4],
	g3_gpc: [3,3,3,3,10],

	g4_string1: 0,
	g4_string2: 0,
	g4_string3: 0,
	g4_string4: 0,
	g4_launch1: 4,
	g4_launch2: 0,
	g4_pl1: 4,
	g4_pl2: 4,
	g4_mm1: 4,
	g4_mm2: 4,
	g4_crt: [4,4,4,4],
	g4_gpc: [2,2,2,4,10],

	edited_mcc: 0,
	direct_edit_gpc: 0,
	direct_edit_config: 0,
	
	select_ops: func (ops) {

	me.ops = ops;

	if (me.config_modified == 1)
		{return;}

	if ((ops == 1) or (ops == 6))
		{
		me.string1 = me.g1_string1;
		me.string2 = me.g1_string2;
		me.string3 = me.g1_string3;
		me.string4 = me.g1_string4;
		me.launch1 = me.g1_launch1;
		me.launch2 = me.g1_string2;
		me.pl1 = me.g1_pl1;
		me.pl2 = me.g1_pl2;
		me.crt[0] = me.g1_crt[0];
		me.crt[1] = me.g1_crt[1];
		me.crt[2] = me.g1_crt[2];
		me.crt[3] = me.g1_crt[3];
		me.gpc = me.g1_gpc;
		me.mm1 = me.g1_mm1;
		me.mm2 = me.g1_mm2;
		}
	else if (ops == 2)
		{
		me.string1 = me.g2_string1;
		me.string2 = me.g2_string2;
		me.string3 = me.g2_string3;
		me.string4 = me.g2_string4;
		me.launch1 = me.g2_launch1;
		me.launch2 = me.g2_string2;
		me.pl1 = me.g2_pl1;
		me.pl2 = me.g2_pl2;
		me.crt[0] = me.g2_crt[0];
		me.crt[1] = me.g2_crt[1];
		me.crt[2] = me.g2_crt[2];
		me.crt[3] = me.g2_crt[3];
		me.gpc = me.g2_gpc;
		me.mm1 = me.g2_mm1;
		me.mm2 = me.g2_mm2;
		}
	else if (ops == 3)
		{
		me.string1 = me.g3_string1;
		me.string2 = me.g3_string2;
		me.string3 = me.g3_string3;
		me.string4 = me.g3_string4;
		me.launch1 = me.g3_launch1;
		me.launch2 = me.g3_string2;
		me.pl1 = me.g3_pl1;
		me.pl2 = me.g3_pl2;
		me.crt[0] = me.g3_crt[0];
		me.crt[1] = me.g3_crt[1];
		me.crt[2] = me.g3_crt[2];
		me.crt[3] = me.g3_crt[3];
		me.gpc = me.g3_gpc;
		me.mm1 = me.g3_mm1;
		me.mm2 = me.g3_mm2;
		}
	else if (ops == 4)
		{
		me.string1 = me.g4_string1;
		me.string2 = me.g4_string2;
		me.string3 = me.g4_string3;
		me.string4 = me.g4_string4;
		me.launch1 = me.g4_launch1;
		me.launch2 = me.g4_string2;
		me.pl1 = me.g4_pl1;
		me.pl2 = me.g4_pl2;
		me.crt_sm[0] = me.g4_crt[0];
		me.crt_sm[1] = me.g4_crt[1];
		me.crt_sm[2] = me.g4_crt[2];
		me.crt_sm[3] = me.g4_crt[3];
		me.gpc = me.g4_gpc;
		me.mm1 = me.g4_mm1;
		me.mm2 = me.g4_mm2;
		}

	},

	what_gpc_provides: func (major_function) {

		for (var i =0; i< size(gpc_array); i=i+1)
			{
			if (gpc_array[i].get_major_function() == major_function)
				{
				return i+1;
				}
			}
		return -1;
	},

	set_symbols: func (gpc, i) {

		if (me.ops < 4)
			{
			me.string1_gnc = me.string1;
			me.string2_gnc = me.string2;
			me.string3_gnc = me.string3;
			me.string4_gnc = me.string4;
			}

		if ((me.string1 - 1) == i)
			{gpc.string1 = "*";}
		else
			{gpc.string1 = "";}

		if ((me.string2 - 1) == i)
			{gpc.string2 = "*";}
		else
			{gpc.string2 = "";}

		if ((me.string3 - 1) == i)
			{gpc.string3 = "*";}
		else
			{gpc.string3 = "";}

		if ((me.string4 - 1) == i)
			{gpc.string4 = "*";}
		else
			{gpc.string4 = "";}

		if ((me.pl1 - 1) == i)
			{gpc.pl1 = "*";}
		else
			{gpc.pl1 = "";}
		if ((me.pl2 - 1) == i)
			{gpc.pl2 = "*";}
		else
			{gpc.pl2 = "";}

		if ((me.launch1 - 1) == i)
			{gpc.launch1 = "*";}
		else
			{gpc.launch1 = "";}
		if ((me.launch2 - 1) == i)
			{gpc.launch2 = "*";}
		else
			{gpc.launch2 = "";}

		if (gpc.major_function == "SM")
			{
			if ((me.crt_sm[0] - 1) == i)
				{gpc.crt1 = "*";}
			else
				{gpc.crt1 = "";}
			if ((me.crt_sm[1] - 1) == i)
				{gpc.crt2 = "*";}
			else
				{gpc.crt2 = "";}
			if ((me.crt_sm[2] - 1) == i)
				{gpc.crt3 = "*";}
			else
				{gpc.crt3 = "";}
			if ((me.crt_sm[3] - 1) == i)
				{gpc.crt4 = "*";}
			else
				{gpc.crt4 = "";}
			}
		else
			{

			if ((me.crt[0] - 1) == i)
				{gpc.crt1 = "*";}
			else
				{gpc.crt1 = "";}
			if ((me.crt[1] - 1) == i)
				{gpc.crt2 = "*";}
			else
				{gpc.crt2 = "";}
			if ((me.crt[2] - 1) == i)
				{gpc.crt3 = "*";}
			else
				{gpc.crt3 = "";}
			if ((me.crt[3] - 1) == i)
				{gpc.crt4 = "*";}
			else
				{gpc.crt4 = "";}
			}


	},

	init: func {

	for (var i=0; i< size(gpc_array); i=i+1)
		{

		var gpc = gpc_array[i];

		me.set_symbols(gpc, i);
		gpc.set_memory(me.gpc[i]);

		}


	},

	apply_simplex : func  {
				
		var gpc_index = -1;

		for (var i = 0; i< size(me.gpc);i=i+1 )
			{
			if (me.ops == me.gpc[i])
				{
				gpc_index = i;
				break;
				}
			}

		print ("Simplex- OPS: ",me.ops, " to GPC ", gpc_index+1); 

		if (gpc_index > -1)
			{
			var gpc = gpc_array[gpc_index];
			gpc.set_memory(me.gpc[gpc_index]);
			me.set_symbols(gpc, gpc_index);
			}

	},



	apply: func {


	for (var i=0; i< size(gpc_array); i=i+1)
		{

		var gpc = gpc_array[i];

		me.set_symbols(gpc, i);

		if (dps_simulation_detail_level == 1)
			{

			var mod_flag = 0;

			var tgt_mf = "SM";			

			if ((me.ops == 1) or (me.ops == 2) or (me.ops == 3))
				{tgt_mf = "GNC";}
		
			print ("GPC",i, " tgt_mf: ", tgt_mf, " current mf: ", gpc.major_function);

			if (me.ops == me.gpc[i])
				{
				mod_flag = 1;

				if (gpc.operational == 0)
					{mod_flag = 0;}
				if (gpc.major_function != tgt_mf)
					{
					if (gpc.ops == 0)
						{mod_flag = 1;}
					else
						{mod_flag = 0;}
					}

				}
			else if (gpc.major_function == tgt_mf)
				{
				if (gpc.operational == 1)
					{mod_flag = 2;}
				}

			if (mod_flag == 1)
				{
				gpc.set_memory(me.gpc[i]);
				}
			else if (mod_flag == 2)
				{
				gpc.set_memory(0);
				}


			}
		else	
			{
			gpc.set_memory(me.gpc[i]);
			}

		}

	},

	init_string: func {

	for (var i=0; i< size(gpc_array); i=i+1)
		{

		var gpc = gpc_array[i];
		me.set_symbols(gpc,i);
		}


	},


	apply_restring: func {

	me.select_ops(me.ops);

	for (var i=0; i< size(gpc_array); i=i+1)
		{

		var gpc = gpc_array[i];
		me.set_symbols(gpc,i);
		}


	},

	apply_crt: func {

	for (var i=0; i< size(gpc_array); i=i+1)
		{

		var gpc = gpc_array[i];

		if (gpc.major_function == "SM")
			{
			if ((me.crt_sm[0] - 1) == i)
				{gpc.crt1 = "*";}
			else
				{gpc.crt1 = "";}
			if ((me.crt_sm[1] - 1) == i)
				{gpc.crt2 = "*";}
			else
				{gpc.crt2 = "";}
			if ((me.crt_sm[2] - 1) == i)
				{gpc.crt3 = "*";}
			else
				{gpc.crt3 = "";}
			if ((me.crt_sm[3] - 1) == i)
				{gpc.crt4 = "*";}
			else
				{gpc.crt4 = "";}
			}
		else
			{
			if ((me.crt[0] - 1) == i)
				{gpc.crt1 = "*";}
			else
				{gpc.crt1 = "";}
			if ((me.crt[1] - 1) == i)
				{gpc.crt2 = "*";}
			else
				{gpc.crt2 = "";}
			if ((me.crt[2] - 1) == i)
				{gpc.crt3 = "*";}
			else
				{gpc.crt3 = "";}
			if ((me.crt[3] - 1) == i)
				{gpc.crt4 = "*";}
			else
				{gpc.crt4 = "";}
			}



		}

	},


	checkout : func (id) {

		# count whether no GPC is specified or a simplex MF is run twice

		var n_sm = 0;
		var n_bfs = 0;
		var n_sys = 0;
		var n_gnc = 0;
		var tgt_mf = "";

		if (id == 1)
			{
			var cfg_gpc = me.g1_gpc;
			tgt_mf = "GNC";
			}
		else if (id == 2)
			{
			var cfg_gpc = me.g2_gpc;
			tgt_mf = "GNC";
			}
		else if (id == 3)
			{
			var cfg_gpc = me.g3_gpc;
			tgt_mf = "GNC";
			}
		else if (id == 4)
			{
			var cfg_gpc = me.g4_gpc;
			tgt_mf = "SM";
			}

		foreach (g; cfg_gpc)	
			{
			if (g==4)
				{
				n_sm = n_sm + 1;
				}
			else if (g == 10)
				{
				n_bfs = n_bfs + 1;
				}
			else if (g == 0)
				{
				n_sys = n_sys + 1;
				}
			else
				{
				n_gnc = n_gnc + 1;
				}
			}

		# check whether we would overwrite a GPC we can't

		var overwrite_flag = 0;

		for (var i=0; i< size(cfg_gpc); i=i+1)
			{
			if (cfg_gpc[i] == id)
				{
				if ((gpc_array[i].major_function != tgt_mf) and (gpc_array[i].ops !=0))
					{overwrite_flag = 1; break}
				}

			}

		# sort out invalid configs

		if (n_sm > 1)
			{return 0;}
		else if (overwrite_flag == 1)
			{return 0;}
		else if ((id == 2) and (n_gnc == 0))
			{return 0;}
		else if ((id == 3) and (n_gnc == 0))
			{return 0;}
		else
			{return 1;}



	},

};


###############################################################################
# IDP
###############################################################################



# four IDPs to provide information for the screens

var idp_array = [];

var idp = {
	new: func (index) {
 	var i = { parents: [idp] };
	i.power = 1;
	i.index = index;
	i.condition = 1.0;
	i.operational = 1;
	i.major_function = 1;
	i.major_function_string = "GNC";
	i.bfs_major_function = 1;
	i.bfs_major_function_string = "GNC";
	i.spec = 0;
	i.disp = 0;
	i.current_fault_string = "";
	i.fault_array = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""];
	return i;
	},
	# power switch
	set_power: func (power) {
		me.power = power;
		if (power == 0)
			{
			me.operational = 0;
			setprop("/fdm/jsbsim/systems/dps/idp-power-demand-kW["~me.index~"]", 0.0);
			}
		else if (power == 1)
			{
			setprop("/fdm/jsbsim/systems/dps/idp-power-demand-kW["~me.index~"]", 0.0426);
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
		else if (major_function == 4)
			{me.major_function_string = "BFS";}
	},
	# BFS major function

	set_bfs_major_function: func (major_function) {

		me.bfs_major_function = major_function;
		if (major_function == 1)
			{me.bfs_major_function_string = "GNC";}
		else if (major_function == 2)
			{me.bfs_major_function_string = "SM";}

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
	get_bfs_major_function : func {
		if (me.operational == 1)
			{return me.bfs_major_function;}
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

var idp1 = idp.new(0);
idp1.set_function(1);
append(idp_array, idp1);

var idp2 = idp.new(1);
idp2.set_function(1);
append(idp_array, idp2);

var idp3 = idp.new(2);
idp3.set_function(1);
append(idp_array, idp3);

var idp4 = idp.new(3);
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

I.set_bfs_major_function(major_function);
var major_mode = 0;

# if the IDP listens to BFS, major function is BFS and we do not change that

print("IDP ", idp_index+1, " MF ", I.get_major_function(), " ", I.major_function_string); 

if (I.get_major_function() == 4)
	{
	var new_page = "";

	major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-bfs");
	new_page = get_ops_page_bfs(major_function, major_mode);

	SpaceShuttle.page_select(idp_index, new_page);
	I.set_disp(0);
	I.set_spec(0);
	
	return;
	}

I.set_function(major_function);




if (major_function == 1)
	{
	major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
	}
else if (major_function == 2)
	{
	major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-sm");
	}

if (gpc_array[SpaceShuttle.nbat.crt[idp_index]-1].ops == 0)
	{
	major_mode = 0;
	SpaceShuttle.page_select(idp_index, "p_dps_memory");
	return;
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



setlistener("/fdm/jsbsim/systems/failures/dps/gpc-1-condition", func (n) {gpc_array[0].set_condition(n.getValue()); },0,0);
setlistener("/fdm/jsbsim/systems/failures/dps/gpc-2-condition", func (n) {gpc_array[1].set_condition(n.getValue()); },0,0);
setlistener("/fdm/jsbsim/systems/failures/dps/gpc-3-condition", func (n) {gpc_array[2].set_condition(n.getValue()); },0,0);
setlistener("/fdm/jsbsim/systems/failures/dps/gpc-4-condition", func (n) {gpc_array[3].set_condition(n.getValue()); },0,0);
setlistener("/fdm/jsbsim/systems/failures/dps/gpc-5-condition", func (n) {gpc_array[4].set_condition(n.getValue()); },0,0);
