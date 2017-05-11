### mission control communication for the Space Shuttle
### Thorsten Renk 2017


var mcc_reply = func (string) {

settimer( func {setprop("/sim/messages/ground", string);}, 1.0);


}


var mcc_request_process_error = func {

var rn = rand();

var string = "";

if (rn < 0.3)
	{string = "Atlantis, please adhere to proper procedures.";}
else if (rn < 0.6)
	{string = "Atlantis, this request makes no sense now.";}
else if (rn < 0.9)
	{string = "Atlantis, verify your checklists.";}
else
	{string =  "I can't do that, Dave.";}

mcc_reply(string); 
}



var mcc_request_process_position = func {


var lat = getprop("/position/latitude-deg");
var lon = getprop("/position/longitude-deg");

var prefix_lat = "north";
if (lat < 0) {prefix_lat = "south";}

var prefix_lon = "east";
if (lon < 0) {prefix_lon = "west";}


var string = "Atlantis, your current position is " ~ sprintf("%3.1f",math.abs(lat)) ~ " degrees "~prefix_lat~" and " ~ sprintf("%3.1f",math.abs(lon)) ~ " degrees "~prefix_lon~".";

mcc_reply(string); 

}


var mcc_request_process_weight = func {

var weight = getprop("/fdm/jsbsim/inertia/weight-lbs");
var indicated_weight = int (weight/1000.0) * 1000;

var string = "Atlantis, estimated orbiter weight is about " ~ indicated_weight ~ " lbs.";

mcc_reply(string); 
}

var mcc_request_process_qnh = func {

var ops = getprop("/fdm/jsbsim/systems/dps/ops");

if (ops != 3) {mcc_request_process_error(); return;}

var qnh = getprop("/environment/pressure-sea-level-inhg");

var string = "Atlantis, set your altimeter to "~sprintf("%2.2f",qnh)~".";

mcc_reply(string);

}


var mcc_request_process_delta = func {

var transponder = getprop("/fdm/jsbsim/systems/antenna/xpndr-sel-switch");

if (transponder == 0)
	{
	var reply = "Atlantis, activate your transponder for radar tracking.";
	mcc_reply(reply);
	return;
	}


var delta_x = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/x-m");
var delta_y = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/y-m");
var delta_z = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/z-m");

var delta_x = -int (delta_x/0.3048 / 50.0) * 50; 
var delta_y = -int (delta_y/0.3048 / 50.0) * 50; 
var delta_z = -int (delta_z/0.3048 / 50.0) * 50; 

var string = "Atlantis, update by Delta x "~delta_x~" ft, Delta y "~delta_y~" ft and Delta z "~delta_z~" ft.";

if ((math.abs(delta_x) < 150.0) and (math.abs(delta_y) < 150.0) and (math.abs(delta_z) < 150.0))
	{
	string = "Atlantis, you do not require a Delta state update.";
	}	

mcc_reply(string);
}


var mcc_request_parse = func {

var request = getprop("/mission-control/comm/request-string");

if (request == "Current position")
	{mcc_request_process_position();}
else if (request == "Orbiter mass estimate")
	{mcc_request_process_weight();}
else if (request == "Delta state update")
	{mcc_request_process_delta();}
else if (request == "Landing site QNH")
	{mcc_request_process_qnh();}

}
