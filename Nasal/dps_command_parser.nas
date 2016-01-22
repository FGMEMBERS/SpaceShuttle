
# DPS keyboard command parser for the Space Shuttle
# Thorsten Renk 2015

var command_string = "";
var last_command = [];

var header = "";
var body = "";
var value = "";
var end = "";
var b_v_flag = 0;
var length_body = 0;
var length_value = 0;

# OPS key #########################################################

var key_ops = func (kb_id) {

var idp_index = get_IDP_id(kb_id) - 1;

var current_string = getprop("/fdm/jsbsim/systems/dps/command-string", idp_index);

if (current_string == "")
	{header = "OPS";}
else {header = "FAIL";}

var element = "OPS ";
append(last_command, element);
current_string = current_string~element;

setprop("/fdm/jsbsim/systems/dps/command-string", idp_index, current_string);
}

# ITEM key #########################################################

var key_item = func (kb_id) {

var idp_index = get_IDP_id(kb_id) - 1;

var current_string = getprop("/fdm/jsbsim/systems/dps/command-string", idp_index);

if (current_string == "")
	{header = "ITEM";}
else {header = "FAIL";}

var element = "ITEM ";
append(last_command, element);
current_string = current_string~element;

setprop("/fdm/jsbsim/systems/dps/command-string", idp_index, current_string);
}

# SPEC key #########################################################

var key_spec = func (kb_id) {

var idp_index = get_IDP_id(kb_id) - 1;

var current_string = getprop("/fdm/jsbsim/systems/dps/command-string", idp_index);

if (current_string == "")
	{header = "SPEC";}
else {header = "FAIL";}

var element = "SPEC ";
append(last_command, element);
current_string = current_string~element;

setprop("/fdm/jsbsim/systems/dps/command-string", idp_index, current_string);
}

# all symbol keys #########################################################

var key_symbol = func  (kb_id, symbol) {

var idp_index = get_IDP_id(kb_id) - 1;

var current_string = getprop("/fdm/jsbsim/systems/dps/command-string", idp_index);

append(last_command, symbol);
current_string = current_string~symbol;

if ((header == "OPS") or (header == "SPEC") or (header == "ITEM"))
	{
	if (b_v_flag == 0)
		{body = body~symbol; length_body = length_body+1;}
	else
		{value = value~symbol; length_value = length_value+1;}
	}

setprop("/fdm/jsbsim/systems/dps/command-string", idp_index, current_string);
}

# the plus and minus keys ########################################

var key_delimiter = func (kb_id, symbol) {

var idp_index = get_IDP_id(kb_id) - 1;

var current_string = getprop("/fdm/jsbsim/systems/dps/command-string", idp_index);
append(last_command, " "~symbol);
current_string = current_string~" "~symbol;

if ((header == "OPS") or (header == "SPEC") or (header == "ITEM"))
	{
	if (b_v_flag == 0) # we've been entering body		
		{
		b_v_flag = 1;
		value = value~symbol; length_value = length_value+1;
		}
	}
setprop("/fdm/jsbsim/systems/dps/command-string", idp_index, current_string);
}


# CLEAR key #######################################################

var key_clear = func (kb_id) {

var idp_index = get_IDP_id(kb_id) - 1;

var n = size(last_command);

if (n==0) {return;}

var current_string = "";

for (var i = 0; i < (n-1); i=i+1)
	{
	current_string = current_string~last_command[i];
	}
setsize(last_command,n-1);



if ((header == "OPS") or (header == "SPEC") or (header == "ITEM"))
	{
	if (b_v_flag == 1) # we've been entering value
		{
		if (length_value > 1)
			{
			length_value = length_value - 1;
			value = substr(value, 0, length_value);
			print("length: ", length_value);
			}
		else
			{
			b_v_flag = 0;
			value = "";
			length_value = 0;
			}			
		}
	else # we've been entering body
		{
		if (length_body > 0)
			{
			length_body = length_body - 1;
			body = substr(body, 0, length_body);
			}
		else
			{
			header = "";
			}
		}

	}
print(b_v_flag);
print(header, " ", body, " ", value);

setprop("/fdm/jsbsim/systems/dps/command-string", idp_index, current_string);
}

# MSG RESET key #######################################################

var key_msg_reset = func (kb_id) {

SpaceShuttle.cws_last_message_acknowledge = 0;
setprop("/fdm/jsbsim/systems/dps/error-string", "");
}

# FAULT SUMM key #######################################################

var key_fault_summ = func (kb_id) {

var idp_index = get_IDP_id(kb_id) - 1;

page_select(idp_index, "p_dps_fault");
setprop("/fdm/jsbsim/systems/dps/disp", 99);
}

# SYS SUMM key #######################################################

var key_sys_summ = func (kb_id) {

var disp = getprop("/fdm/jsbsim/systems/dps/disp");
var idp_index = get_IDP_id(kb_id) - 1;

var major_function = SpaceShuttle.idp_array[idp_index].get_major_function();

if (major_function == 1)
	{
	if (disp == 18)
		{
		page_select(idp_index, "p_dps_sys_summ2");
		setprop("/fdm/jsbsim/systems/dps/disp", 19);
		}
	else
		{
		page_select(idp_index, "p_dps_sys_summ");
		setprop("/fdm/jsbsim/systems/dps/disp", 18);
		}
	}
else if  (major_function == 2)
	{
	page_select(idp_index, "p_dps_sm_sys_summ2");
	setprop("/fdm/jsbsim/systems/dps/disp-sm", 79);
	}
	
}



# ACK key #######################################################

var key_ack = func (kb_id) {

if (SpaceShuttle.cws_last_message_acknowledge == 1)
	{SpaceShuttle.cws_last_message_acknowledge = 0;}
else
	{
	var num_messages = size(SpaceShuttle.cws_message_array);
	if (num_messages > 1)
		{
		setprop("/fdm/jsbsim/systems/dps/error-string", SpaceShuttle.cws_message_array[num_messages - 2]);
		setsize(SpaceShuttle.cws_message_array, num_messages - 1);
		}
	}

}

# RESUME key #######################################################

var key_resume = func (kb_id) {

var idp_index = get_IDP_id(kb_id) - 1;

var major_function = SpaceShuttle.idp_array[idp_index].get_major_function();

if (major_function == 1)
{
var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
var ops = getprop("/fdm/jsbsim/systems/dps/ops");
var spec = getprop("/fdm/jsbsim/systems/dps/spec");
var disp = getprop("/fdm/jsbsim/systems/dps/disp");



if ((disp > 0) and (spec > 0)) 
	{
	if (spec == 2)
		{
		page_select(idp_index, "p_dps_time");
		}
	else if (spec == 20)
		{
		page_select(idp_index, "p_dps_dap");
		}
	else if (spec == 51)
		{
		page_select(idp_index, "p_dps_override");
		}
	else if (spec == 63)
		{
		page_select(idp_index, "p_dps_pl_bay");
		}
	setprop("/fdm/jsbsim/systems/dps/disp", 0);
	}
else if ((spec > 0) or ((spec == 0) and (disp > 0)))
	{
	if (ops == 1)	
		{
		if ((major_mode == 101) or (major_mode == 102) or (major_mode == 103))
			{
			page_select(idp_index, "p_ascent");
			}
		else
			{
			page_select(idp_index, "p_dps_mnvr");
			}
		}
	else if (ops == 2)
		{
		if (major_mode == 201)
			{
			page_select(idp_index, "p_dps_univ_ptg");
			}
		else
			{
			page_select(idp_index, "p_dps_mnvr");
			}
		}
	else if ( ops == 3)
		{
		if (major_mode == 304)
			{
			page_select(idp_index, "p_entry");
			}
		else if (major_mode == 304)
			{
			page_select(idp_index, "p_vert_sit");
			}
		else
			{
			page_select(idp_index, "p_dps_mnvr");
			}
		}
	setprop("/fdm/jsbsim/systems/dps/spec", 0);
	}
}
else if (major_function == 2)
	{
	var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-sm");

	SpaceShuttle.page_select(idp_index, SpaceShuttle.get_ops_page(major_function, major_mode));


	setprop("/fdm/jsbsim/systems/dps/disp-sm", 0);
	setprop("/fdm/jsbsim/systems/dps/spec-sm", 0);
	}

}

# PRO key #######################################################

var key_pro = func (kb_id) {

var idp_index = get_IDP_id(kb_id) - 1;

var current_string = getprop("/fdm/jsbsim/systems/dps/command-string", idp_index);

var element = " PRO";
append(last_command, element);
current_string = current_string~element;

end = "PRO";

setprop("/fdm/jsbsim/systems/dps/command-string", idp_index, current_string);


command_parse(idp_index);
}

# EXEC key #######################################################

var key_exec = func (kb_id) {

var idp_index = get_IDP_id(kb_id) - 1;

var current_string = getprop("/fdm/jsbsim/systems/dps/command-string", idp_index);

var element = " EXEC";
append(last_command, element);
current_string = current_string~element;

end = "EXEC";

setprop("/fdm/jsbsim/systems/dps/command-string", idp_index, current_string);


command_parse(idp_index);
}


#####################################################################
# OPS/ SPEC dependency checks
#####################################################################

var spec2 = [104, 105, 201, 202, 301, 302, 303];
var spec20 = [201, 202];
var spec51 = [101, 102, 103, 104, 105, 106, 301, 302, 303, 304, 305];
var spec63 = [201, 202];


var test_spec_ops_validity = func (spec, ops) {

var flag = 0;

foreach (var allowed_ops; spec)
	{
	if (allowed_ops == ops) {flag = 1; break;}
	}
print(flag);
return flag;
}

#####################################################################
# IDP ID query
#####################################################################

var get_IDP_id = func (kb_id) {


return SpaceShuttle.kb_array[kb_id - 1].get_idp();

}


#####################################################################
# OPS, SPEC and DISP page calls and auxiliary functions
#####################################################################

# since the commands are sent to an IDP, they will in fact affect all screens at that IDP
# the same way
# moreover OPS transitions will affect the GPC memory content and apply to all screens


var ops_transition = func (idp_index, page_id) {

    var major_function = SpaceShuttle.idp_array[idp_index].get_major_function();

# we now switch over all screens on IDPs showing the same major function which are in dps mode

    foreach (M; SpaceShuttle.MDU_array)
	{
        var index = M.PFD.port_selected - 1;
        var current_major_function = SpaceShuttle.idp_array[index].get_major_function();

        if ((current_major_function == major_function) and (M.PFD.dps_page_flag == 1))
		{
            M.PFD.selectPage(M.PFD.page_index[page_id]);
		}
	}
}



var page_select = func (idp_index, page_id)
{
    foreach (M; SpaceShuttle.MDU_array)
	{
        if ((M.PFD.port_selected == idp_index +1) and (M.PFD.dps_page_flag == 1))
		{
            M.PFD.selectPage(M.PFD.page_index[page_id]);
		}
	}
} 


var get_ops_page  = func (major_function, major_mode)
{
    if (major_function == 1)
	{
        if ((major_mode == 101) or (major_mode == 102) or (major_mode == 103))
            return "p_ascent";
        else if ((major_mode == 104) or (major_mode == 105) or (major_mode == 202) or (major_mode == 301) or (major_mode == 302) or (major_mode == 303))
            return "p_dps_mnvr";
        else if (major_mode == 201)
            return page = "p_dps_univ_ptg";
        else if (major_mode == 304)
            return "p_entry";
        else if (major_mode == 305)
            return "p_vert_sit";
	}
    else if (major_function == 2)
	{
	if (major_mode == 202)
        	return "p_dps_pl_bay";
	else if (major_mode == 201)
		return "p_dps_antenna";
	}
    print("error locating page for ",major_function,",",major_mode);
    return "p_ascent";
}


#####################################################################
# The command parser
#####################################################################


var command_parse = func (idp_index) {

var dps_display_flag = SpaceShuttle.idp_check_dps(idp_index);

if (dps_display_flag == 0)
	{
	setprop("/fdm/jsbsim/systems/dps/command-string", idp_index, "");
	return;
	}


var major_function = SpaceShuttle.idp_array[idp_index].get_major_function();

if (major_function == 0) # IDP isn't working, do nothing
	{
	setprop("/fdm/jsbsim/systems/dps/command-string", idp_index, "");
	return;
	}
else if (major_function == 1)
	{command_parse_gnc (idp_index);}
else if (major_function == 2)
	{command_parse_sm (idp_index);}

}

var command_parse_gnc = func (idp_index) {


var valid_flag = 0;

print(header, " ", body, " ", value);

if ((header == "OPS") and (end =="PRO"))
	{
	var major_mode = int(body);
	print ("Switching to major_mode ", major_mode);
	var current_ops = getprop("/fdm/jsbsim/systems/dps/ops");

	if (major_mode == 101)
		{
		setprop("/fdm/jsbsim/systems/dps/ops", 1);
		setprop("/fdm/jsbsim/systems/dps/major-mode", 101);
		ops_transition(idp_index, "p_ascent");
		valid_flag = 1;
		}
	else if ((major_mode == 102) and (current_ops == 1))
		{
		setprop("/fdm/jsbsim/systems/dps/major-mode", 102);
		ops_transition(idp_index, "p_ascent");
		valid_flag = 1;
		}
	else if ((major_mode == 103) and (current_ops == 1))
		{
		setprop("/fdm/jsbsim/systems/dps/major-mode", 103);
		ops_transition(idp_index, "p_ascent");
		valid_flag = 1;
		}
	else if ((major_mode == 104) and (current_ops == 1))
		{
		setprop("/fdm/jsbsim/systems/dps/major-mode", 104);
		ops_transition(idp_index, "p_dps_mnvr");
		valid_flag = 1;
		}
	else if ((major_mode == 105) and (current_ops == 1))
		{
		setprop("/fdm/jsbsim/systems/dps/major-mode", 105);
		ops_transition(idp_index, "p_dps_mnvr");
		valid_flag = 1;
		}
	else if ((major_mode == 106) and (current_ops == 1))
		{
		setprop("/fdm/jsbsim/systems/dps/major-mode", 106);
		ops_transition(idp_index, "p_dps_mnvr");
		valid_flag = 1;
		}
	if (major_mode == 201)
		{
		setprop("/fdm/jsbsim/systems/dps/ops", 2);
		setprop("/fdm/jsbsim/systems/dps/major-mode", 201);
		ops_transition(idp_index, "p_dps_univ_ptg");
		valid_flag = 1;
		}
	else if ((major_mode == 202) and (current_ops == 2))
		{
		setprop("/fdm/jsbsim/systems/dps/major-mode", 202);
		ops_transition(idp_index, "p_dps_mnvr");
		valid_flag = 1;
		}
	if (major_mode == 301)
		{
		setprop("/fdm/jsbsim/systems/dps/ops", 3);
		setprop("/fdm/jsbsim/systems/dps/major-mode", 301);
		ops_transition(idp_index, "p_dps_mnvr");
		valid_flag = 1;
		}
	else if ((major_mode == 302) and (current_ops == 3))
		{
		setprop("/fdm/jsbsim/systems/dps/major-mode", 302);
		ops_transition(idp_index, "p_dps_mnvr");
		valid_flag = 1;
		}
	else if ((major_mode == 303) and (current_ops == 3))
		{
		setprop("/fdm/jsbsim/systems/dps/major-mode", 303);
		ops_transition(idp_index, "p_dps_mnvr");
		valid_flag = 1;
		}
	else if ((major_mode == 304) and (current_ops == 3))
		{
		SpaceShuttle.traj_display_flag = 3;
		SpaceShuttle.fill_entry1_data();
		setprop("/fdm/jsbsim/systems/dps/major-mode", 304);
		ops_transition(idp_index, "p_entry");
		valid_flag = 1;
		}
	else if ((major_mode == 305) and (current_ops == 3))
		{
		SpaceShuttle.traj_display_flag = 8;
		setprop("/fdm/jsbsim/systems/dps/major-mode", 305);
		ops_transition(idp_index, "p_vert_sit");
		valid_flag = 1;
		}


	if (valid_flag == 1)
		{
		setprop("/fdm/jsbsim/systems/dps/spec", 0);
		setprop("/fdm/jsbsim/systems/dps/disp", 0);
		}

	}

if ((header == "ITEM") and (end = "EXEC"))
	{
	var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
	var spec = getprop("/fdm/jsbsim/systems/dps/spec");

	var item = int(body);

	#print("Major mode: ", major_mode);
	#print("Spec: ", spec);


	if (((major_mode == 104) or (major_mode == 105) or (major_mode == 106) or (major_mode == 202) or (major_mode == 301) or (major_mode == 303)) and (spec == 0))
		{
		if (item == 6)
			{setprop("/fdm/jsbsim/systems/ap/oms-plan/trim-pitch",num(value)); valid_flag = 1;}
		else if (item == 7)
			{setprop("/fdm/jsbsim/systems/ap/oms-plan/trim-yaw-left",num(value)); valid_flag = 1;}
		else if (item == 8)
			{setprop("/fdm/jsbsim/systems/ap/oms-plan/trim-yaw-right",num(value)); valid_flag = 1;}
		else if (item == 9)
			{setprop("/fdm/jsbsim/systems/ap/oms-plan/weight",num(value)); valid_flag = 1;}
		else if (item == 10)
			{
			setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-days", int(value)); 
			SpaceShuttle.set_oms_mnvr_timer();
			valid_flag = 1;
			}
		else if (item == 11)
			{
			setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-hours", int(value)); 
			SpaceShuttle.set_oms_mnvr_timer();
			valid_flag = 1;
			}
		else if (item == 12)
			{
			setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-minutes", int(value)); 
			SpaceShuttle.set_oms_mnvr_timer();
			valid_flag = 1;
			}
		else if (item == 13)
			{
			setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-seconds", int(value)); 
			SpaceShuttle.set_oms_mnvr_timer();
			valid_flag = 1;
			}
		else if (item == 19)
			{setprop("/fdm/jsbsim/systems/ap/oms-plan/dvx",num(value)); valid_flag = 1;}
		else if (item == 20)
			{setprop("/fdm/jsbsim/systems/ap/oms-plan/dvy",num(value)); valid_flag = 1;}
		else if (item == 21)
			{setprop("/fdm/jsbsim/systems/ap/oms-plan/dvz",num(value)); valid_flag = 1;}
		else if (item == 22)
			{
			var burn_plan = getprop("/fdm/jsbsim/systems/ap/oms-plan/burn-plan-available");
			if (burn_plan == 0)
				{
				SpaceShuttle.create_oms_burn_vector();
				setprop("/fdm/jsbsim/systems/ap/oms-mnvr-flag", 0);
				setprop("/fdm/jsbsim/systems/ap/oms-plan/burn-plan-available", 1);
				setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-flag", 0);
				}
			else
				{
				setprop("/fdm/jsbsim/systems/ap/oms-plan/burn-plan-available", 0);
				setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-flag", 0);
				}
			SpaceShuttle.tracking_loop_flag = 0;
			valid_flag = 1;
			}
		else if (item == 23)
			{
			setprop("/fdm/jsbsim/systems/timer/count-to-seconds", SpaceShuttle.oms_burn_target.tig); 
			SpaceShuttle.update_start_count(2);
			SpaceShuttle.blank_start_at();
			valid_flag = 1;
			}
		else if (item == 27)
			{
			setprop("/fdm/jsbsim/systems/ap/track/body-vector-selection", 1);

			var flag = getprop("/fdm/jsbsim/systems/ap/oms-mnvr-flag");
			if (flag == 0) {flag = 1;} else {flag =0;}
			setprop("/fdm/jsbsim/systems/ap/oms-mnvr-flag", flag);
			valid_flag = 1;
			}
		else if (item == 28)
			{
			setprop("/fdm/jsbsim/systems/oms-hardware/gimbal-left-pri-selected", 1);
			setprop("/fdm/jsbsim/systems/oms-hardware/gimbal-left-sec-selected", 0);
			valid_flag = 1;
			}
		else if (item == 29)
			{
			setprop("/fdm/jsbsim/systems/oms-hardware/gimbal-right-pri-selected", 1);
			setprop("/fdm/jsbsim/systems/oms-hardware/gimbal-right-sec-selected", 0);
			valid_flag = 1;
			}
		else if (item == 30)
			{
			setprop("/fdm/jsbsim/systems/oms-hardware/gimbal-left-pri-selected", 0);
			setprop("/fdm/jsbsim/systems/oms-hardware/gimbal-left-sec-selected", 1);
			valid_flag = 1;
			}
		else if (item == 31)
			{
			setprop("/fdm/jsbsim/systems/oms-hardware/gimbal-right-pri-selected", 0);
			setprop("/fdm/jsbsim/systems/oms-hardware/gimbal-right-sec-selected", 1);
			valid_flag = 1;
			}
		else if (item == 32)
			{
			setprop("/fdm/jsbsim/systems/oms-hardware/gimbal-left-pri-selected", 0);
			setprop("/fdm/jsbsim/systems/oms-hardware/gimbal-left-sec-selected", 0);
			valid_flag = 1;
			}
		else if (item == 33)
			{
			setprop("/fdm/jsbsim/systems/oms-hardware/gimbal-right-pri-selected", 0);
			setprop("/fdm/jsbsim/systems/oms-hardware/gimbal-right-sec-selected", 0);
			valid_flag = 1;
			}
		else if (item == 34)
			{
			setprop("/fdm/jsbsim/systems/oms-hardware/gimbal-chk-cmd", 1);
			settimer(func{ setprop("/fdm/jsbsim/systems/oms-hardware/gimbal-chk-cmd", 0);}, 15.0);
			valid_flag = 1;
			}
		else if (item == 36)
			{
			setprop("/fdm/jsbsim/systems/rcs/fwd-dump-arm-cmd", 1);
			valid_flag = 1;
			}
		else if (item == 37)
			{
			if (getprop("/fdm/jsbsim/systems/rcs/fwd-dump-arm-cmd") == 1)
				{setprop("/fdm/jsbsim/systems/rcs/fwd-dump-cmd", 1);}
			valid_flag = 1;
			}
		else if (item == 38)
			{
			setprop("/fdm/jsbsim/systems/rcs/fwd-dump-cmd", 0);
			setprop("/fdm/jsbsim/systems/rcs/fwd-dump-arm-cmd", 0);
			valid_flag = 1;
			}
		}
	


	if ((major_mode == 201) and (spec == 0))
		{
		if (item == 1)
			{
			setprop("/fdm/jsbsim/systems/timer/up-mnvr-time-days", int(value)); 
			SpaceShuttle.set_up_timer();
			valid_flag = 1;
			}
		else if (item == 2)
			{
			setprop("/fdm/jsbsim/systems/timer/up-mnvr-time-hours", int(value)); 
			SpaceShuttle.set_up_timer();
			valid_flag = 1;
			}
		else if (item == 3)
			{
			setprop("/fdm/jsbsim/systems/timer/up-mnvr-time-minutes", int(value)); 
			SpaceShuttle.set_up_timer();
			valid_flag = 1;
			}
		else if (item == 4)
			{
			setprop("/fdm/jsbsim/systems/timer/up-mnvr-time-seconds", int(value)); 
			SpaceShuttle.set_up_timer();
			valid_flag = 1;
			}
		else if (item == 5)
			{setprop("/fdm/jsbsim/systems/ap/ops201/mnvr-roll", num(value)); valid_flag = 1;}
		else if (item == 6)
			{setprop("/fdm/jsbsim/systems/ap/ops201/mnvr-pitch", num(value)); valid_flag = 1;}
		else if (item == 7)
			{setprop("/fdm/jsbsim/systems/ap/ops201/mnvr-yaw", num(value)); valid_flag = 1;}
		else if (item == 8)
			{setprop("/fdm/jsbsim/systems/ap/ops201/tgt-id", int(value)); valid_flag = 1;}
		else if (item == 11)
			{setprop("/fdm/jsbsim/systems/ap/ops201/trk-lat", num(value)); valid_flag = 1;}
		else if (item == 12)
			{setprop("/fdm/jsbsim/systems/ap/ops201/trk-lon", num(value)); valid_flag = 1;}
		else if (item == 14)
			{setprop("/fdm/jsbsim/systems/ap/track/body-vector-selection", int(value)); valid_flag = 1;}
		else if (item == 13)
			{setprop("/fdm/jsbsim/systems/ap/ops201/trk-alt", num(value)); valid_flag = 1;}
		else if (item == 17)
			{setprop("/fdm/jsbsim/systems/ap/track/trk-om", num(value)); valid_flag = 1;}
		else if (item == 18)
			{
 			valid_flag = 1;
			SpaceShuttle.up_future_mnvr_loop_flag = 0;
			SpaceShuttle.manage_up_mnvr(18);
			}
		else if (item == 19)
			{
			valid_flag = 1;
			SpaceShuttle.up_future_mnvr_loop_flag = 0;
			SpaceShuttle.manage_up_mnvr(19);
			}
		else if (item == 20)
			{
			valid_flag = 1;
			SpaceShuttle.up_future_mnvr_loop_flag = 0;
			SpaceShuttle.manage_up_mnvr(20);
			}
		else if (item == 21)
			{
			valid_flag = 1;
			setprop("/fdm/jsbsim/systems/ap/ops201/mnvr-future-flag", 0);
			setprop("/fdm/jsbsim/systems/ap/up-mnvr-flag", 0); 
			SpaceShuttle.tracking_loop_flag = 0;
			SpaceShuttle.up_future_mnvr_loop_flag = 0;
			}

		}
	if (spec == 2)
		{
		if (item == 1)
			{
			setprop("/fdm/jsbsim/systems/timer/time-display-flag", 0); valid_flag = 1;
			}
		else if (item == 2)
			{
			setprop("/fdm/jsbsim/systems/timer/time-display-flag", 1); valid_flag = 1;
			}
		else if (item == 3)
			{
			setprop("/fdm/jsbsim/systems/timer/timer-MET-1-hours", int(value)); 
			SpaceShuttle.set_MET_timer(1);
			valid_flag = 1;
			}
		else if (item == 4)
			{
			setprop("/fdm/jsbsim/systems/timer/timer-MET-1-minutes", int(value)); 
			SpaceShuttle.set_MET_timer(1);
			valid_flag = 1;
			}
		else if (item == 5)
			{
			setprop("/fdm/jsbsim/systems/timer/timer-MET-1-seconds", int(value)); 
			SpaceShuttle.set_MET_timer(1);
			valid_flag = 1;
			}
		else if (item == 6)
			{
			setprop("/fdm/jsbsim/systems/timer/timer-MET-2-hours", int(value)); 
			SpaceShuttle.set_MET_timer(2);
			valid_flag = 1;
			}
		else if (item == 7)
			{
			setprop("/fdm/jsbsim/systems/timer/timer-MET-2-minutes", int(value)); 
			SpaceShuttle.set_MET_timer(2);
			valid_flag = 1;
			}
		else if (item == 8)
			{
			setprop("/fdm/jsbsim/systems/timer/timer-MET-2-seconds", int(value)); 
			SpaceShuttle.set_MET_timer(2);
			valid_flag = 1;
			}
		else if (item == 9)
			{
			setprop("/fdm/jsbsim/systems/timer/crt-timer-hours", int(value)); 
			SpaceShuttle.update_CRT_timer();
			valid_flag = 1;
			}
		else if (item == 10)
			{
			setprop("/fdm/jsbsim/systems/timer/crt-timer-minutes", int(value)); 
			SpaceShuttle.update_CRT_timer();
			valid_flag = 1;
			}
		else if (item == 11)
			{
			setprop("/fdm/jsbsim/systems/timer/crt-timer-seconds", int(value)); 
			SpaceShuttle.update_CRT_timer();
			valid_flag = 1;
			}
		else if (item == 12)
			{
			SpaceShuttle.start_CRT_timer();
			valid_flag = 1;
			}
		else if (item == 13)
			{
			SpaceShuttle.stop_CRT_timer();
			valid_flag = 1;
			}
		else if (item == 14)
			{
			setprop("/fdm/jsbsim/systems/timer/start-at-hours", int(value)); 
			SpaceShuttle.update_start_count(1);
			SpaceShuttle.blank_count_to();
			valid_flag = 1;
			}
		else if (item == 15)
			{
			setprop("/fdm/jsbsim/systems/timer/start-at-minutes", int(value)); 
			SpaceShuttle.update_start_count(1);
			SpaceShuttle.blank_count_to();
			valid_flag = 1;
			}
		else if (item == 16)
			{
			setprop("/fdm/jsbsim/systems/timer/start-at-seconds", int(value)); 
			SpaceShuttle.update_start_count(1);
			SpaceShuttle.blank_count_to();
			valid_flag = 1;
			}
		else if (item == 17)
			{
			setprop("/fdm/jsbsim/systems/timer/count-to-hours", int(value)); 
			SpaceShuttle.update_start_count(2);
			SpaceShuttle.blank_start_at();
			valid_flag = 1;
			}
		else if (item == 18)
			{
			setprop("/fdm/jsbsim/systems/timer/count-to-minutes", int(value)); 
			SpaceShuttle.update_start_count(2);
			SpaceShuttle.blank_start_at();
			valid_flag = 1;
			}
		else if (item == 19)
			{
			setprop("/fdm/jsbsim/systems/timer/count-to-seconds", int(value)); 
			SpaceShuttle.update_start_count(2);
			SpaceShuttle.blank_start_at();
			valid_flag = 1;
			}
		else if (item == 20)
			{
			setprop("/fdm/jsbsim/systems/timer/timer-CRT-hours", int(value)); 
			SpaceShuttle.set_CRT_timer();
			valid_flag = 1;
			}
		else if (item == 21)
			{
			setprop("/fdm/jsbsim/systems/timer/timer-CRT-minutes", int(value)); 
			SpaceShuttle.set_CRT_timer();
			valid_flag = 1;
			}
		else if (item == 22)
			{
			setprop("/fdm/jsbsim/systems/timer/timer-CRT-seconds", int(value)); 
			SpaceShuttle.set_CRT_timer();
			valid_flag = 1;
			}
		else if (item == 23)
			{
			setprop("/fdm/jsbsim/systems/timer/time-tone-duration", int(value));
			valid_flag = 1;
			}
		else if (item == 24)
			{
			setprop("/fdm/jsbsim/systems/timer/delta-GMT-days", int(value)); 
			SpaceShuttle.update_deltaGMT();
			SpaceShuttle.blank_deltaMET();
			valid_flag = 1;
			}
		else if (item == 25)
			{
			setprop("/fdm/jsbsim/systems/timer/delta-GMT-hours", int(value)); 
			SpaceShuttle.update_deltaGMT();
			SpaceShuttle.blank_deltaMET();
			valid_flag = 1;
			}
		else if (item == 26)
			{
			setprop("/fdm/jsbsim/systems/timer/delta-GMT-minutes", int(value)); 
			SpaceShuttle.update_deltaGMT();
			SpaceShuttle.blank_deltaMET();
			valid_flag = 1;
			}
		else if (item == 27)
			{
			setprop("/fdm/jsbsim/systems/timer/delta-GMT-seconds", int(value)); 
			SpaceShuttle.update_deltaGMT();
			SpaceShuttle.blank_deltaMET();
			valid_flag = 1;
			}
		else if (item == 28)
			{
			setprop("/fdm/jsbsim/systems/timer/delta-MET-days", int(value)); 
			SpaceShuttle.update_deltaMET();
			SpaceShuttle.blank_deltaGMT();
			valid_flag = 1;
			}
		else if (item == 29)
			{
			setprop("/fdm/jsbsim/systems/timer/delta-MET-hours", int(value)); 
			SpaceShuttle.update_deltaMET();
			SpaceShuttle.blank_deltaGMT();
			valid_flag = 1;
			}
		else if (item == 30)
			{
			setprop("/fdm/jsbsim/systems/timer/delta-MET-minutes", int(value)); 
			SpaceShuttle.update_deltaMET();
			SpaceShuttle.blank_deltaGMT();
			valid_flag = 1;
			}
		else if (item == 31)
			{
			setprop("/fdm/jsbsim/systems/timer/delta-MET-seconds", int(value)); 
			SpaceShuttle.update_deltaMET();
			SpaceShuttle.blank_deltaGMT();
			valid_flag = 1;
			}
		else if (item == 32)
			{
			SpaceShuttle.load_deltaGMT_MET();
			valid_flag = 1;
			}
		else if (item == 33)
			{
			setprop("/fdm/jsbsim/systems/timer/delta-MET", -getprop("/sim/time/elapsed-sec"));
			valid_flag = 1;
			}
		}


	if (spec == 20)
		{
		if (item == 10)
			{
			setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-rot-rate", value);
			valid_flag =1;
			}
		else if (item == 11)
			{
			setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-att-db", value);
			valid_flag =1;
			}
		else if (item == 12)
			{
			setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-rate-db", value);
			valid_flag =1;
			}
		else if (item == 13)
			{
			setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-rot-pls", value);
			valid_flag =1;
			}
		else if (item == 15)
			{
			var state = getprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-p-opt");
			state = state + 1;
			if (state == 3) {state = 0;}
			setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-p-opt", state);
			valid_flag =1;
			}
		else if (item == 16)
			{
			var state = getprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-y-opt");
			state = state + 1;
			if (state == 3) {state = 0;}
			setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-y-opt", state);
			valid_flag =1;
			}
		else if (item == 23)
			{
			setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-VRN-rot-rate", value);
			valid_flag =1;
			}
		else if (item == 24)
			{
			setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-VRN-att-db", value);
			valid_flag =1;
			}
		else if (item == 25)
			{
			setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-VRN-rate-db", value);
			valid_flag =1;
			}
		else if (item == 30)
			{
			setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-rot-rate", value);
			valid_flag =1;
			}
		else if (item == 31)
			{
			setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-att-db", value);
			valid_flag =1;
			}
		else if (item == 32)
			{
			setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-rate-db", value);
			valid_flag =1;
			}
		else if (item == 33)
			{
			setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-rot-pls", value);
			valid_flag =1;
			}
		else if (item == 35)
			{
			var state = getprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-p-opt");
			state = state + 1;
			if (state == 3) {state = 0;}
			setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-p-opt", state);
			valid_flag =1;
			}
		else if (item == 36)
			{
			var state = getprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-y-opt");
			state = state + 1;
			if (state == 3) {state = 0;}
			setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-y-opt", state);
			valid_flag =1;
			}
		else if (item == 43)
			{
			setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-VRN-rot-rate", value);
			valid_flag =1;
			}
		else if (item == 43)
			{
			setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-VRN-att-db", value);
			valid_flag =1;
			}
		else if (item == 45)
			{
			setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-VRN-rate-db", value);
			valid_flag =1;
			}

		}

	if (spec == 51)
		{
		if (item == 1)
			{
			var status = getprop("/fdm/jsbsim/systems/abort/arm-tal");
			if (status == 0) {status = 1;} else {status = 0;}
			setprop("/fdm/jsbsim/systems/abort/arm-tal", status);
			if (status == 1)
				{setprop("/fdm/jsbsim/systems/abort/arm-ato", 0);}
			valid_flag = 1;
			}
		else if (item == 2)
			{
			var status = getprop("/fdm/jsbsim/systems/abort/arm-ato");
			if (status == 0) {status = 1;} else {status = 0;}
			setprop("/fdm/jsbsim/systems/abort/arm-ato", status);
			if (status == 1)
				{setprop("/fdm/jsbsim/systems/abort/arm-tal", 0);}
			valid_flag = 1;
			}
		else if (item == 3)
			{
			var status_tal = getprop("/fdm/jsbsim/systems/abort/arm-tal");
			var status_ato = getprop("/fdm/jsbsim/systems/abort/arm-ato");
			
			if (status_tal == 1)
				{
				setprop("/fdm/jsbsim/systems/abort/abort-mode", 2);
				setprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode", 2);
				}
			else if (status_ato == 1)
				{
				setprop("/fdm/jsbsim/systems/abort/abort-mode", 3);
				}
			else if (getprop("/fdm/jsbsim/systems/abort/abort-mode") > 0)
				{
				setprop("/fdm/jsbsim/systems/abort/abort-mode", 0);
				setprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode", 1);
				}

			valid_flag = 1;
			}
		else if (item == 4)
			{
			setprop("/fdm/jsbsim/systems/throttle/throttle-mode", 1);
			valid_flag = 1;
			}
		else if (item == 5)
			{
			var status = getprop("/fdm/jsbsim/systems/oms/oms-dump-interconnect-cmd");
			if (status == 0) {status = 1;} else {status = 0;}
			setprop("/fdm/jsbsim/systems/oms/oms-dump-interconnect-cmd", status);
			#if (status == 1) {SpaceShuttle.set_oms_rcs_crossfeed();}
			valid_flag = 1;
			}
		else if (item == 6)
			{
			var status = getprop("/fdm/jsbsim/systems/oms/oms-dump-arm-cmd");
			if (status == 0) {status = 1;} else {status = 0;}
			setprop("/fdm/jsbsim/systems/oms/oms-dump-arm-cmd", status);
			valid_flag = 1;
			}
		else if (item == 7)
			{
			var arm = getprop("/fdm/jsbsim/systems/oms/oms-dump-arm-cmd");
			if (arm == 1)
				{
				setprop("/fdm/jsbsim/systems/oms/oms-dump-cmd", 0);
				SpaceShuttle.toggle_oms_fuel_dump();
				}
			valid_flag = 1;
			}
		else if (item == 8)
			{
			setprop("/fdm/jsbsim/systems/oms/oms-dump-cmd", 1);
			SpaceShuttle.toggle_oms_fuel_dump();
			valid_flag = 1;
			}
		else if (item == 9)
			{
			setprop("/fdm/jsbsim/systems/oms/oms-dump-qty", int(value));
			valid_flag = 1;
			}
		else if (item == 13)
			{
			var status = getprop("/fdm/jsbsim/systems/rcs/aft-dump-arm-cmd");
			if (status == 0) {status = 1;} else {status = 0;}
			setprop("/fdm/jsbsim/systems/rcs/aft-dump-arm-cmd", status);
			valid_flag = 1;
			}
		else if (item == 14)
			{
			setprop("/fdm/jsbsim/systems/rcs/aft-dump-time-s", int(value));
			if ((int(value) > 0) and (getprop("/fdm/jsbsim/systems/rcs/aft-dump-arm-cmd") == 1))
				{
				setprop("/fdm/jsbsim/systems/rcs/aft-dump-cmd", 1);
				SpaceShuttle.aft_rcs_fuel_dump_loop();
				}
			valid_flag = 1;
			}
		else if (item == 15)
			{
			var status = getprop("/fdm/jsbsim/systems/rcs/fwd-dump-arm-cmd");
			if (status == 0) {status = 1;} else {status = 0;}
			setprop("/fdm/jsbsim/systems/rcs/fwd-dump-arm-cmd", status);
			if ((status > 0) and (getprop("/fdm/jsbsim/systems/rcs/fwd-dump-time-s") > 0))
				{
				setprop("/fdm/jsbsim/systems/rcs/fwd-dump-cmd", 1);
				SpaceShuttle.fwd_rcs_fuel_dump_loop();
				}
			valid_flag = 1;
			}
		else if (item == 16)
			{
			setprop("/fdm/jsbsim/systems/rcs/fwd-dump-time-s", int(value));
			if ((int(value) > 0) and (getprop("/fdm/jsbsim/systems/rcs/fwd-dump-arm-cmd") == 1))
				{
				setprop("/fdm/jsbsim/systems/rcs/fwd-dump-cmd", 1);
				SpaceShuttle.fwd_rcs_fuel_dump_loop();
				}
			valid_flag = 1;
			}
		else if (item == 19)
			{
			var status = getprop("/fdm/jsbsim/systems/vectoring/ssme-repos-enable");
			if (status == 0) {status = 1;} else {status = 0;}
			setprop("/fdm/jsbsim/systems/vectoring/ssme-repos-enable", status);
			valid_flag = 1;
			}
		else if (item == 34)
			{
			if ((major_mode == 304) or (major_mode == 305) or (major_mode == 602) or (major_mode == 603))
				{
				var status = getprop("/fdm/jsbsim/systems/navigation/air-data-1-deselect-cmd");
				if (status == 0) {status = 1;} else {status = 0;}
				setprop("/fdm/jsbsim/systems/navigation/air-data-1-deselect-cmd", status);
				valid_flag = 1;
				}
			}
		else if (item == 35)
			{
			if ((major_mode == 304) or (major_mode == 305) or (major_mode == 602) or (major_mode == 603))
				{
				var status = getprop("/fdm/jsbsim/systems/navigation/air-data-3-deselect-cmd");
				if (status == 0) {status = 1;} else {status = 0;}
				setprop("/fdm/jsbsim/systems/navigation/air-data-3-deselect-cmd", status);
				valid_flag = 1;
				}
			}
		else if (item == 36)
			{
			if ((major_mode == 304) or (major_mode == 305) or (major_mode == 602) or (major_mode == 603))
				{
				var status = getprop("/fdm/jsbsim/systems/navigation/air-data-2-deselect-cmd");
				if (status == 0) {status = 1;} else {status = 0;}
				setprop("/fdm/jsbsim/systems/navigation/air-data-2-deselect-cmd", status);
				valid_flag = 1;
				}
			}
		else if (item == 37)
			{
			if ((major_mode == 304) or (major_mode == 305) or (major_mode == 602) or (major_mode == 603))
				{
				var status = getprop("/fdm/jsbsim/systems/navigation/air-data-4-deselect-cmd");
				if (status == 0) {status = 1;} else {status = 0;}
				setprop("/fdm/jsbsim/systems/navigation/air-data-4-deselect-cmd", status);
				valid_flag = 1;
				}
			}
		else if (item == 39)
			{
			if ((major_mode == 102) or (major_mode == 103) or (major_mode == 104) or (major_mode == 105) or (major_mode == 106))
				{
				SpaceShuttle.external_tank_separate();
				valid_flag = 1;
				}
			}
		else if (item == 40)
			{
			if ((major_mode == 104) or (major_mode == 105) or (major_mode == 106))
				{
				setprop("/fdm/jsbsim/systems/mechanical/et-door-cl-latch-cmd", 0);
				setprop("/fdm/jsbsim/systems/mechanical/et-door-left-cmd", 1);
				setprop("/fdm/jsbsim/systems/mechanical/et-door-right-cmd", 1);
				setprop("/fdm/jsbsim/systems/mechanical/et-door-left-latch-cmd", 1);
				setprop("/fdm/jsbsim/systems/mechanical/et-door-right-latch-cmd", 1);
				valid_flag = 1;
				}
			}
		else if (item == 43)
			{
			setprop("/fdm/jsbsim/systems/mechanical/vdoor-cmd", 1);
			valid_flag = 1;
			}
		else if (item == 44)
			{
			setprop("/fdm/jsbsim/systems/mechanical/vdoor-cmd", 0);
			valid_flag = 1;
			}
		else if (item == 50)
			{
			setprop("/fdm/jsbsim/systems/throttle/throttle-mode", 2);
			valid_flag = 1;
			}
		else if (item == 51)
			{
			setprop("/fdm/jsbsim/systems/throttle/throttle-mode", 3);
			valid_flag = 1;
			}

		}


	if (spec == 63)
		{
		if (item == 1)
			{
			setprop("/fdm/jsbsim/systems/mechanical/pb-door-software-acpower-enable", 1);
			valid_flag = 1;
			}
		else if (item == 2)
			{
			setprop("/fdm/jsbsim/systems/mechanical/pb-door-software-acpower-enable", 0);
			valid_flag = 1;
			}
		else if (item == 3)
			{
			var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto");
			if (state == 0) {state = 1;} else {state = 0;}
			setprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto", state);
			valid_flag = 1;
			}
		else if (item == 4)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto") == 0)
				{
				var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-cl5-8-latch-cmd");
				if (state == 0) {state = 1;} else {state = 0;}
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-cl5-8-latch-cmd", state);
				valid_flag = 1;
				}
			}
		else if (item == 5)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto") == 0)
				{
				var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-cl9-12-latch-cmd");
				if (state == 0) {state = 1;} else {state = 0;}
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-cl9-12-latch-cmd", state);
				valid_flag = 1;
				}
			}
		else if (item == 6)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto") == 0)
				{
				var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-cl1-4-latch-cmd");
				if (state == 0) {state = 1;} else {state = 0;}
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-cl1-4-latch-cmd", state);
				valid_flag = 1;
				}
			}
		else if (item == 7)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto") == 0)
				{
				var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-cl13-16-latch-cmd");
				if (state == 0) {state = 1;} else {state = 0;}
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-cl13-16-latch-cmd", state);
				valid_flag = 1;
				}
			}
		else if (item == 8)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto") == 0)
				{
				var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-right-fwd-latch-cmd");
				if (state == 0) {state = 1;} else {state = 0;}
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-right-fwd-latch-cmd", state);
				valid_flag = 1;
				}
			}
		else if (item == 9)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto") == 0)
				{
				var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-right-aft-latch-cmd");
				if (state == 0) {state = 1;} else {state = 0;}
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-right-aft-latch-cmd", state);
				valid_flag = 1;
				}
			}
		else if (item == 10)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto") == 0)
				{
				var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-right-cmd");
				if (state == 0) {state = 1;} else {state = 0;}
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-right-cmd", state);
				valid_flag = 1;
				}
			}
		else if (item == 11)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto") == 0)
				{
				var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-left-fwd-latch-cmd");
				if (state == 0) {state = 1;} else {state = 0;}
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-left-fwd-latch-cmd", state);
				valid_flag = 1;
				}
			}
		else if (item == 12)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto") == 0)
				{
				var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-left-aft-latch-cmd");
				if (state == 0) {state = 1;} else {state = 0;}
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-left-aft-latch-cmd", state);
				valid_flag = 1;
				}
			}
		else if (item == 13)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto") == 0)
				{
				var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-left-cmd");
				if (state == 0) {state = 1;} else {state = 0;}
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-left-cmd", state);
				valid_flag = 1;
				}
			}
		else if (item == 14)
			{
			var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-software-bypass");
			if (state == 0) 	
				{
				state = 1;
				} 
			else 	
				{
				state = 0;
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-software-switch", -2);
				}

			setprop("/fdm/jsbsim/systems/mechanical/pb-door-software-bypass", state);
			valid_flag = 1;
			}
		else if (item == 15)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-software-bypass") == 1)
				{
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-software-switch", 1);
				SpaceShuttle.payload_bay_door_open_auto(0);
				valid_flag = 1;
				}
			}
		else if (item == 16)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-software-bypass") == 1)
				{
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-software-switch", 0);
				valid_flag = 1;
				}
			}
		else if (item == 17)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-software-bypass") == 1)
				{
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-software-switch", -1);
				SpaceShuttle.payload_bay_door_close_auto(0);
				valid_flag = 1;
				}
			}
		}

	}


if ((header == "SPEC") and (end =="PRO"))
	{
	var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
	var spec_num = int(body);
	#print ("Switching to SPEC ", spec_num);

	if ((spec_num == 2) and (test_spec_ops_validity(spec2, major_mode) == 1))
		{
		page_select(idp_index, "p_dps_time");
		setprop("/fdm/jsbsim/systems/dps/spec", 2);
		valid_flag = 1;
		}
	if (spec_num == 18)
		{
		page_select(idp_index, "p_dps_sys_summ");
		setprop("/fdm/jsbsim/systems/dps/disp", 18);
		valid_flag = 1;
		}
	if (spec_num == 19)
		{
		page_select(idp_index, "p_dps_sys_summ2");
		setprop("/fdm/jsbsim/systems/dps/disp", 19);
		valid_flag = 1;
		}
	if ((spec_num == 20) and (test_spec_ops_validity(spec20, major_mode) == 1))
		{
		page_select(idp_index, "p_dps_dap");
		setprop("/fdm/jsbsim/systems/dps/spec", 20);
		valid_flag = 1;
		}
	if ((spec_num == 51) and (test_spec_ops_validity(spec51, major_mode) == 1))
		{
		page_select(idp_index, "p_dps_override");
		setprop("/fdm/jsbsim/systems/dps/spec", 51);
		valid_flag = 1;
		}
	if ((spec_num == 63) and (test_spec_ops_validity(spec63, major_mode) == 1))
		{
		page_select(idp_index, "p_dps_pl_bay");
		setprop("/fdm/jsbsim/systems/dps/spec", 63);
		valid_flag = 1;
		}
	if ((spec_num == 86) )
		{
		page_select(idp_index, "p_dps_apu_hyd");
		setprop("/fdm/jsbsim/systems/dps/disp", 86);
		valid_flag = 1;
		}

	if (spec_num == 99)
		{
		page_select(idp_index, "p_dps_fault");
		# calling the display with SPEC 99 PRO clears all fault messages
		SpaceShuttle.cws_message_array_long = ["","","","","","","","","","","","","","",""];
		setprop("/fdm/jsbsim/systems/dps/disp", 99);
		valid_flag = 1;
		}
	}

# special situation - the exec key being used to fire the OMS burn

var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");

if ((major_mode == 104) or (major_mode == 105) or (major_mode == 106) or (major_mode == 202) or (major_mode == 301) or (major_mode == 303))
	{
	if (getprop("/fdm/jsbsim/systems/dps/command-string["~idp_index~"]") == " EXEC")
		{
		var burn_plan = getprop("/fdm/jsbsim/systems/ap/oms-plan/burn-plan-available");
		var attitude_flag = getprop("/fdm/jsbsim/systems/ap/track/in-attitude");
		
		if ((burn_plan == 1) and (attitude_flag == 1))
			{
			print("Starting OMS burn!");
			var burn_time = getprop("/fdm/jsbsim/systems/ap/oms-plan/tgo-s");
			print("Burn time ", burn_time, " s");
			SpaceShuttle.oms_burn_start(burn_time);
			setprop("/fdm/jsbsim/systems/ap/oms-plan/exec-cmd", 1);
			valid_flag = 1;
			}
		}	

	}


length_body = 0;
length_value = 0;
b_v_flag = 0;
header = "";
body = "";
value = "";
end = "";
setsize(last_command,0);
	setprop("/fdm/jsbsim/systems/dps/command-string", idp_index, "");

if (valid_flag == 0)
	{
	setprop("/fdm/jsbsim/systems/dps/error-string", "ILLEGAL ENTRY");

	}
else 
	{
	#setprop("/fdm/jsbsim/systems/dps/error-string", "");
	setsize(last_command,0);
	}

}


var command_parse_sm = func (idp_index) {


var valid_flag = 0;

print(header, " ", body, " ", value);


if ((header == "OPS") and (end =="PRO"))
	{
	var major_mode = int(body);
	print ("Switching to major_mode ", major_mode);

	if (major_mode == 201)
		{
		setprop("/fdm/jsbsim/systems/dps/major-mode-sm", 201);
		ops_transition(idp_index, "p_dps_antenna");
		valid_flag = 1;
		}

	if (major_mode == 202)
		{
		setprop("/fdm/jsbsim/systems/dps/major-mode-sm", 202);
		ops_transition(idp_index, "p_dps_pl_bay");
		valid_flag = 1;
		}
	}

if ((header == "SPEC") and (end =="PRO"))
	{
	var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-sm");
	var spec_num = int(body);
	if (spec_num == 79) 
		{
		page_select(idp_index, "p_dps_sm_sys_summ2");
		setprop("/fdm/jsbsim/systems/dps/disp-sm", 79);
		valid_flag = 1;
		}
	if (spec_num == 86) 
		{
		page_select(idp_index, "p_dps_apu_hyd");
		setprop("/fdm/jsbsim/systems/dps/disp-sm", 86);
		valid_flag = 1;
		}
	}


if ((header == "ITEM") and (end = "EXEC"))
	{
	var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode-sm");
	var spec = getprop("/fdm/jsbsim/systems/dps/spec-sm");

	var item = int(body);

	print("Major mode: ", major_mode);
	print("Spec: ", spec);


	if ((major_mode == 201) and (spec == 0))
		{
		if (item == 1)
			{
			if (value == "+A")
				{				
				SpaceShuttle.antenna_manager.TDRS_A = 1;
				valid_flag = 1;
				}
			else if (value == "+B")
				{				
				SpaceShuttle.antenna_manager.TDRS_B = 1;
				valid_flag = 1;
				}
			}
		else if (item == 2)
			{
			if (value == "+A")
				{				
				SpaceShuttle.antenna_manager.TDRS_A = 2;
				valid_flag = 1;
				}
			else if (value == "+B")
				{				
				SpaceShuttle.antenna_manager.TDRS_B = 2;
				valid_flag = 1;
				}
			}
		else if (item == 3)
			{
			if (value == "+A")
				{				
				SpaceShuttle.antenna_manager.TDRS_A = 3;
				valid_flag = 1;
				}
			else if (value == "+B")
				{				
				SpaceShuttle.antenna_manager.TDRS_B = 3;
				valid_flag = 1;
				}
			}
		else if (item == 4)
			{
			if (value == "+A")
				{				
				SpaceShuttle.antenna_manager.TDRS_A = 4;
				valid_flag = 1;
				}
			else if (value == "+B")
				{				
				SpaceShuttle.antenna_manager.TDRS_B = 4;
				valid_flag = 1;
				}
			}
		else if (item == 5)
			{
			if (value == "+A")
				{				
				SpaceShuttle.antenna_manager.TDRS_A = 5;
				valid_flag = 1;
				}
			else if (value == "+B")
				{				
				SpaceShuttle.antenna_manager.TDRS_B = 5;
				valid_flag = 1;
				}
			}
		else if (item == 6)
			{
			if (value == "+A")
				{				
				SpaceShuttle.antenna_manager.TDRS_A = 6;
				valid_flag = 1;
				}
			else if (value == "+B")
				{				
				SpaceShuttle.antenna_manager.TDRS_B = 6;
				valid_flag = 1;
				}
			}
		else if (item == 9)
			{
			SpaceShuttle.antenna_manager.TDRS_ku_primary = "A";
			valid_flag = 1;
			}
		else if (item == 10)
			{
			SpaceShuttle.antenna_manager.TDRS_ku_primary = "B";
			valid_flag = 1;
			}
		else if (item == 14)
			{
			SpaceShuttle.antenna_manager.TDRS_s_primary = "A";
			valid_flag = 1;
			}
		else if (item == 15)
			{
			SpaceShuttle.antenna_manager.TDRS_s_primary = "B";
			valid_flag = 1;
			}
		}
	if ((major_mode == 202) and (spec == 0))
		{
		if (item == 1)
			{
			setprop("/fdm/jsbsim/systems/mechanical/pb-door-software-acpower-enable", 1);
			valid_flag = 1;
			}
		else if (item == 2)
			{
			setprop("/fdm/jsbsim/systems/mechanical/pb-door-software-acpower-enable", 0);
			valid_flag = 1;
			}
		else if (item == 3)
			{
			var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto");
			if (state == 0) {state = 1;} else {state = 0;}
			setprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto", state);
			valid_flag = 1;
			}
		else if (item == 4)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto") == 0)
				{
				var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-cl5-8-latch-cmd");
				if (state == 0) {state = 1;} else {state = 0;}
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-cl5-8-latch-cmd", state);
				valid_flag = 1;
				}
			}
		else if (item == 5)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto") == 0)
				{
				var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-cl9-12-latch-cmd");
				if (state == 0) {state = 1;} else {state = 0;}
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-cl9-12-latch-cmd", state);
				valid_flag = 1;
				}
			}
		else if (item == 6)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto") == 0)
				{
				var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-cl1-4-latch-cmd");
				if (state == 0) {state = 1;} else {state = 0;}
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-cl1-4-latch-cmd", state);
				valid_flag = 1;
				}
			}
		else if (item == 7)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto") == 0)
				{
				var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-cl13-16-latch-cmd");
				if (state == 0) {state = 1;} else {state = 0;}
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-cl13-16-latch-cmd", state);
				valid_flag = 1;
				}
			}
		else if (item == 8)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto") == 0)
				{
				var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-right-fwd-latch-cmd");
				if (state == 0) {state = 1;} else {state = 0;}
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-right-fwd-latch-cmd", state);
				valid_flag = 1;
				}
			}
		else if (item == 9)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto") == 0)
				{
				var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-right-aft-latch-cmd");
				if (state == 0) {state = 1;} else {state = 0;}
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-right-aft-latch-cmd", state);
				valid_flag = 1;
				}
			}
		else if (item == 10)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto") == 0)
				{
				var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-right-cmd");
				if (state == 0) {state = 1;} else {state = 0;}
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-right-cmd", state);
				valid_flag = 1;
				}
			}
		else if (item == 11)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto") == 0)
				{
				var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-left-fwd-latch-cmd");
				if (state == 0) {state = 1;} else {state = 0;}
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-left-fwd-latch-cmd", state);
				valid_flag = 1;
				}
			}
		else if (item == 12)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto") == 0)
				{
				var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-left-aft-latch-cmd");
				if (state == 0) {state = 1;} else {state = 0;}
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-left-aft-latch-cmd", state);
				valid_flag = 1;
				}
			}
		else if (item == 13)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-mode-auto") == 0)
				{
				var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-left-cmd");
				if (state == 0) {state = 1;} else {state = 0;}
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-left-cmd", state);
				valid_flag = 1;
				}
			}
		else if (item == 14)
			{
			var state = getprop("/fdm/jsbsim/systems/mechanical/pb-door-software-bypass");
			if (state == 0) 	
				{
				state = 1;
				} 
			else 	
				{
				state = 0;
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-software-switch", -2);
				}

			setprop("/fdm/jsbsim/systems/mechanical/pb-door-software-bypass", state);
			valid_flag = 1;
			}
		else if (item == 15)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-software-bypass") == 1)
				{
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-software-switch", 1);
				SpaceShuttle.payload_bay_door_open_auto(0);
				valid_flag = 1;
				}
			}
		else if (item == 16)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-software-bypass") == 1)
				{
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-software-switch", 0);
				valid_flag = 1;
				}
			}
		else if (item == 17)
			{
			if (getprop("/fdm/jsbsim/systems/mechanical/pb-door-software-bypass") == 1)
				{
				setprop("/fdm/jsbsim/systems/mechanical/pb-door-software-switch", -1);
				SpaceShuttle.payload_bay_door_close_auto(0);
				valid_flag = 1;
				}
			}
		}

	


	}


length_body = 0;
length_value = 0;
b_v_flag = 0;
header = "";
body = "";
value = "";
end = "";
setsize(last_command,0);
	setprop("/fdm/jsbsim/systems/dps/command-string", idp_index, "");

if (valid_flag == 0)
	{
	setprop("/fdm/jsbsim/systems/dps/error-string", "ILLEGAL ENTRY");
	}
else 
	{
	setsize(last_command,0);
	}


}

