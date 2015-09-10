
# DPS keyboard command parser for the Space Shuttle
# Thorsten Renk 2015

var command_string = "";
var last_command = [];

# OPS key #########################################################

var key_ops = func {

var current_string = getprop("/fdm/jsbsim/systems/dps/command-string");

var element = "OPS ";
append(last_command, element);
current_string = current_string~element;

setprop("/fdm/jsbsim/systems/dps/command-string", current_string);
}

# all symbol keys #########################################################

var key_symbol = func  (symbol) {

var current_string = getprop("/fdm/jsbsim/systems/dps/command-string");

append(last_command, symbol);
current_string = current_string~symbol;

setprop("/fdm/jsbsim/systems/dps/command-string", current_string);
}



# CLEAR key #######################################################

var key_clear = func {

var n = size(last_command);

if (n==0) {return;}

var current_string = "";

for (var i = 0; i < (n-1); i=i+1)
	{
	current_string = current_string~last_command[i];
	}
setsize(last_command,n-1);

setprop("/fdm/jsbsim/systems/dps/command-string", current_string);
}

# MSG RESET key #######################################################

var key_msg_reset = func {


setprop("/fdm/jsbsim/systems/dps/error-string", "");
}


# PRO key #######################################################

var key_pro = func {

var current_string = getprop("/fdm/jsbsim/systems/dps/command-string");

var element = " PRO";
append(last_command, element);
current_string = current_string~element;

setprop("/fdm/jsbsim/systems/dps/command-string", current_string);


command_parse();
}


#####################################################################
# The command parser
#####################################################################

var command_parse = func {

var current_string = getprop("/fdm/jsbsim/systems/dps/command-string");

var valid_flag = 0;

if (valid_flag == 0)
	{
	setprop("/fdm/jsbsim/systems/dps/error-string", "ILLEGAL ENTRY");
	}
else 
	{
	setprop("/fdm/jsbsim/systems/dps/error-string", "");
	}




}
