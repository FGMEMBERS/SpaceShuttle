### mission control communication for the Space Shuttle
### Thorsten Renk 2017


var mcc_reply = func (string) {

settimer( func {setprop("/sim/messages/ground", string);}, 1.0);

print("MCC: ", string);


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

var mcc_request_process_cog = func {

var trim = getprop("/fdm/jsbsim/systems/various/cg-percentage");

var string = "Atlantis, estimated orbiter trim is  " ~ sprintf("%2.1f", trim) ~ " percent body length.";

mcc_reply(string); 

var ops = getprop("/fdm/jsbsim/systems/dps/ops");

if (ops == 3)
	{
	if ((trim < 66.3) or (trim > 67.5))
		{
		var string = "This is not in the safe range for entry.";
		settimer( func { mcc_reply(string);}, 1.0);
		}
	}

}

var mcc_request_process_qnh = func {

var ops = getprop("/fdm/jsbsim/systems/dps/ops");

if ((ops != 3) and (ops != 6)) {mcc_request_process_error(); return;}

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

delta_x = -int (delta_x/0.3048 / 50.0) * 50; 
delta_y = -int (delta_y/0.3048 / 50.0) * 50; 
delta_z = -int (delta_z/0.3048 / 50.0) * 50; 

var string = "Atlantis, update by Delta x "~delta_x~" ft, Delta y "~delta_y~" ft and Delta z "~delta_z~" ft.";

if ((math.abs(delta_x) < 150.0) and (math.abs(delta_y) < 150.0) and (math.abs(delta_z) < 150.0))
	{
	string = "Atlantis, you do not require a Delta state update.";
	mcc_reply(string);
	return;
	}	

mcc_reply(string);

var delta_vx = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/vx-m_s");
var delta_vy = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/vy-m_s");
var delta_vz = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/vz-m_s");

delta_vx = -int (delta_vx/0.3048 ); 
delta_vy = -int (delta_vy/0.3048 ); 
delta_vz = -int (delta_vz/0.3048 ); 

if ((math.abs(delta_vx) > 1) or (math.abs(delta_vy) > 1) or (math.abs(delta_vz) > 1))
	{
	string = "Update Delta vx "~delta_vx~" ft/s, Delta vy "~delta_vy~" ft/s and Delta vz "~delta_vz~" ft/s.";

	settimer (func {mcc_reply(string);}, 3.0);
	}

}


mcc_request_process_deorbit = func {

# first check whether the request makes any sense

var periapsis = getprop("/fdm/jsbsim/systems/orbital/periapsis-km");
var ops = getprop("/fdm/jsbsim/systems/dps/ops");

if ((periapsis < 150.0) or (ops != 3))
	{mcc_request_process_error(); return;}

# now check whether the selected site is crossed by the groundtrack

var shuttle_pos = geo.aircraft_position();

var tgt_course = shuttle_pos.course_to(SpaceShuttle.landing_site);
var current_course = getprop("/fdm/jsbsim/systems/entry_guidance/groundtrack-course-deg");
var dist = shuttle_pos.distance_to(SpaceShuttle.landing_site);

#print ("Dist_raw: ", dist);

if (tgt_course > 180.0) # we have crossed the target already
	{
	dist = 40073841.80796 - dist;
	}

#print ("TgT: ",tgt_course, " cur: ", current_course, " dist: ", dist);

shuttle_pos = SpaceShuttle.sgeo_move_circle(current_course, dist, shuttle_pos);

var time = dist/getprop("/fdm/jsbsim/systems/entry_guidance/ground-relative-velocity-fps") * 0.3048;

#print ("Time to site: ", time);

var delta_lon = SpaceShuttle.earth_rotation_deg_s * time;

shuttle_pos.set_lon(shuttle_pos.lon() - delta_lon);

var d_test = shuttle_pos.distance_to(SpaceShuttle.landing_site)/1000.0;

print ("Predicted position: ", shuttle_pos.lat(), " ", shuttle_pos.lon());
print ("Distance: ", d_test, " km");


if (d_test > 1000.0)
	{
	var site_string = getprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site");
	var string = "Bad groundtrack for "~site_string;
	mcc_reply(string);
	return;
	}

# now guide the crew to about 170 m/s vertical speed at EI and 3200 miles REI

var apoapsis = getprop("/fdm/jsbsim/systems/orbital/apoapsis-km");
var periapsis = getprop("/fdm/jsbsim/systems/orbital/periapsis-km");

if (math.abs (apoapsis - periapsis) > 25.0)
	{
	var string = "Atlantis, circularize orbit first!";
	mcc_reply(string);
	return;
	}

var v_tgt = 170.0;
var tgt_hp = (-1.0/0.049154) * (v_tgt/math.pow((apoapsis - 121.0), 0.518) - 12.41324);
delta_v = 1.78 * (apoapsis - tgt_hp)/1.853;

print ("Tgt periapsis nm: ", tgt_hp/1.856, " delta v: ", delta_v);


# estimate current REI, then compute TIG from the difference 


var v_intl = getprop("/fdm/jsbsim/velocities/eci-velocity-mag-fps");
var factor = (v_intl - delta_v)/v_intl;

var rei_now = SpaceShuttle.test_rei(factor) + 200.0;# + 375.0 + 3.6556 * periapsis;

print("REI now: ", rei_now);

var time_to_go = (rei_now - 3000.0)*1853. / (getprop("/fdm/jsbsim/systems/entry_guidance/ground-relative-velocity-fps") * 0.3048);

var elapsed = getprop("/sim/time/elapsed-sec");
var TIG = elapsed + getprop("/fdm/jsbsim/systems/timer/delta-MET") + time_to_go;

var TIG_string = SpaceShuttle.seconds_to_stringDHMS(TIG);

var string = "TIG is "~TIG_string;
#print ("TIG is: ", TIG_string);

mcc_reply(string);

string = "Delta vx is "~sprintf("%3.0f", -delta_v);
#print ("Delta vx is: ", string);

settimer( func { mcc_reply(string);}, 1.0);

}


var mcc_check_com = func {

var com_status = getprop("/mission-control/status/comlink");


if (com_status == 0)
	{
	if ((SpaceShuttle.entry_guidance_available == 1) and (getprop("/fdm/jsbsim/systems/entry_guidance/remaining-distance-nm") < 250.0))
		{
		com_status = 1;
		}
	}

if (getprop("/fdm/jsbsim/systems/thermal/nose-temperature-F") > 1000.0)
	{
	com_status = 0;
	}


return com_status;
}

var mcc_request_parse = func {

var request = getprop("/mission-control/comm/request-string");

if (mcc_check_com() == 0)
	{
	return;
	}



if (request == "Current position")
	{mcc_request_process_position();}
else if (request == "Orbiter mass estimate")
	{mcc_request_process_weight();}
else if (request == "Orbiter trim")
	{mcc_request_process_cog();}
else if (request == "Delta state update")
	{mcc_request_process_delta();}
else if (request == "Landing site QNH")
	{mcc_request_process_qnh();}
else if (request == "De-orbit solution")
	{mcc_request_process_deorbit();}
}
