
# housekeeping tasks for the Space Shuttle
# Thorsten Renk 2015

#########################################################################################
# Fuel dump is done after MECO to remove leftover LO2 and LH2 from the feed lines
# by expurging them using helium from the MPS helium system
#########################################################################################

var propellant_dump_completed = 0;


# helper functions to determine number of open valves

var get_num_LO2_prevalves = func {

var n_LO2_prevalves = 0;

if (getprop("/fdm/jsbsim/systems/propellant/LO2-left-prevalve-status") ==1) 
	{n_LO2_prevalves = n_LO2_prevalves+1;}

if (getprop("/fdm/jsbsim/systems/propellant/LO2-right-prevalve-status") ==1) 
	{n_LO2_prevalves = n_LO2_prevalves+1;}

if (getprop("/fdm/jsbsim/systems/propellant/LO2-center-prevalve-status") ==1) 
	{n_LO2_prevalves = n_LO2_prevalves+1;}

return n_LO2_prevalves;
}

var get_num_LH2_prevalves = func {

var n_LH2_prevalves = 0;

if (getprop("/fdm/jsbsim/systems/propellant/LH2-left-prevalve-status") ==1) 
	{n_LH2_prevalves = n_LH2_prevalves+1;}

if (getprop("/fdm/jsbsim/systems/propellant/LH2-right-prevalve-status") ==1) 
	{n_LH2_prevalves = n_LH2_prevalves+1;}

if (getprop("/fdm/jsbsim/systems/propellant/LH2-center-prevalve-status") ==1) 
	{n_LH2_prevalves = n_LH2_prevalves+1;}

return n_LH2_prevalves;
}

var get_num_LH2_drainvalves = func {

var n_LH2_drainvalves = 0;

if (getprop("/fdm/jsbsim/systems/propellant/LH2-inboard-status") ==1) 
	{n_LH2_drainvalves = n_LH2_drainvalves+1;}

if (getprop("/fdm/jsbsim/systems/propellant/LH2-outboard-status") ==1) 
	{n_LH2_drainvalves = n_LH2_drainvalves+1;}


return n_LH2_drainvalves;

}


var fuel_dump_start = func {

# check whether we already did a dump sequence

if (propellant_dump_completed == 1)
	{
	setprop("/sim/messages/copilot", "No helium left for a second dump.");
	return;
	}

# check whether the helium system has pressure

var helium_pressurized = getprop("/fdm/jsbsim/systems/mps/helium-system-pressurized");
var manifold_open = getprop("/fdm/jsbsim/systems/mps/LO2-manifold-valve-status");

if ((helium_pressurized == 0) or (manifold_open == 0))
	{
	setprop("/sim/messages/copilot", "Unable to initiate LO2 dump without helium pressure.");
	return;
	}


# check how many pre-valves are open

var n_LO2_prevalves = get_num_LO2_prevalves();


if (n_LO2_prevalves == 0)
	{
	setprop("/sim/messages/copilot", "Unable to initiate LO2 dump with prevalves closed.");
	return;
	}

# otherwise we can start the dump

print("Starting fuel dump");

setprop("/fdm/jsbsim/systems/mps/propellant-dump-cmd",1);

fuel_dump_loop (0);

}

var fuel_dump_loop = func (counter) {

if (counter == 120) 
	{
	setprop("/fmd/jsbsim/systems/mps/propellant-dump-cmd",0);
	setprop("/fdm/jsbsim/propulsion/tank[17]/external-flow-rate-pps", 0.0);
	setprop("/fdm/jsbsim/propulsion/tank[18]/external-flow-rate-pps", 0.0);
	setprop("/sim/messages/copilot", "Propellant dump completed.");
	propellant_dump_completed = 1;
	return;
	}

var helium_pressurized = getprop("/fdm/jsbsim/systems/mps/helium-system-pressurized");
var manifold_open = getprop("/fdm/jsbsim/systems/mps/LO2-manifold-valve-status");
var n_LO2_prevalves = get_num_LO2_prevalves();
var n_LH2_prevalves = get_num_LH2_prevalves();
var n_LH2_drain_valves = get_num_LH2_drainvalves();

print("LO2 pre: ",n_LO2_prevalves," LH2 pre: ", n_LH2_prevalves, " LH2 drain: ", n_LH2_drain_valves);

var LO2_dump_rate = -17.76 * n_LO2_prevalves * helium_pressurized * manifold_open;
setprop("/fdm/jsbsim/propulsion/tank[18]/external-flow-rate-pps", LO2_dump_rate);

setprop("/fdm/jsbsim/systems/mps/propellant-dump-density", 0.08 * n_LO2_prevalves * helium_pressurized * manifold_open * (1.0 - counter/120.0));

var dump_propulsive_force = 250.0 *  n_LO2_prevalves * helium_pressurized * manifold_open;

if (counter > 90) {dump_propulsive_force = 0.0;}

setprop("/fdm/jsbsim/systems/mps/propellant-dump-force-lb", dump_propulsive_force );

var LH2_dump_rate = - 1.11 * n_LH2_drain_valves * n_LH2_prevalves;
setprop("/fdm/jsbsim/propulsion/tank[17]/external-flow-rate-pps", LH2_dump_rate);

settimer(func {fuel_dump_loop(counter +1 ) },  1.0);
}


#########################################################################################
# RCS fuel dump from the override display is done via countdown timers
#########################################################################################


var fwd_rcs_fuel_dump_loop = func {

var ttg = getprop("/fdm/jsbsim/systems/rcs/fwd-dump-time-s");

ttg = ttg - 1;

setprop("/fdm/jsbsim/systems/rcs/fwd-dump-time-s", ttg);

if (ttg == 0) {setprop("/fdm/jsbsim/systems/rcs/fwd-dump-cmd", 0); return;}

settimer(fwd_rcs_fuel_dump_loop, 1.0);
}



var aft_rcs_fuel_dump_loop = func {

var ttg = getprop("/fdm/jsbsim/systems/rcs/aft-dump-time-s");

ttg = ttg - 1;

setprop("/fdm/jsbsim/systems/rcs/aft-dump-time-s", ttg);

if (ttg == 0) {setprop("/fdm/jsbsim/systems/rcs/aft-dump-cmd", 0); return;}

settimer(aft_rcs_fuel_dump_loop, 1.0);
}


#########################################################################################
# OMS fuel dump timer routine
# dump rates are:
# full OMS dump:  36.0449 lb propellant/sec
# OMS engine only fuel dump: 7.3505 lb propellant/sec
#########################################################################################

var oms_fuel_dump_loop_init = func {

var fuel_current_left = getprop("/consumables/fuel/tank[5]/level-lbs");
var fuel_current_right = getprop("/consumables/fuel/tank[7]/level-lbs");

var fuel_current = fuel_current_left;
if (fuel_current_right > fuel_current_left) {fuel_current = fuel_current_right;}

var tgt_percentage = getprop("/fdm/jsbsim/systems/oms/oms-dump-qty");
var fuel_to_dump = fuel_current * 0.01 * tgt_percentage;
var tgt_quantity = fuel_current - fuel_to_dump;

var dump_mode = getprop("/fdm/jsbsim/systems/oms/oms-dump-interconnect-cmd");

var dump_rate = 7.3505;
if (dump_mode == 1) {dump_rate = 36.0449;}

var ttg = int(fuel_to_dump/dump_rate);

if (dump_mode == 1) {ttg = ttg + 3;}

setprop("/fdm/jsbsim/systems/oms/oms-dump-ttg-s", ttg);

#print("Current: ", fuel_current, " Target: ", tgt_quantity);
#print("Dumping ", fuel_to_dump, " of propellant with ", dump_rate, " lb/s in ", ttg, " seconds.");

oms_fuel_dump_loop(tgt_quantity);

}


var oms_fuel_dump_loop = func (target_quantity) {


var ttg = getprop("/fdm/jsbsim/systems/oms/oms-dump-ttg-s");
ttg = ttg - 1;
setprop("/fdm/jsbsim/systems/oms/oms-dump-ttg-s", ttg);

var fuel_current_left = getprop("/consumables/fuel/tank[5]/level-lbs");
var fuel_current_right = getprop("/consumables/fuel/tank[7]/level-lbs");

var fuel_current = fuel_current_left;
if (fuel_current_right > fuel_current_left) {fuel_current = fuel_current_right;}


#print("Current: ", fuel_current, " Target: ", target_quantity);

# check whether the fuel dump has been terminated by key command

if (getprop("/fdm/jsbsim/systems/oms/oms-dump-cmd") == 0)
	{
	setprop("/fdm/jsbsim/systems/oms/oms-dump-ttg-s", 0);
	return;	
	}

if (fuel_current < target_quantity)
	{
	#print("Fuel dump ends.");
	setprop("/fdm/jsbsim/systems/rcs/oms-rcs-dump-cmd", 0); 
	setprop("/fdm/jsbsim/systems/oms/oms-dump-ttg-s", 0);
	SpaceShuttle.toggle_oms_fuel_dump();
	return;
	}

settimer( func {oms_fuel_dump_loop(target_quantity); } , 1.0);

}


#########################################################################################
# Automatic payload bay opening sequence consists of first unlatching the centerline, then
# left and right gangs, then opening right door, finally left door
#########################################################################################


var payload_bay_door_open_auto = func (stage) {


var power = getprop("/fdm/jsbsim/systems/mechanical/pb-door-power");

if (power == 0.0) {return;}

# payload bay door won't move if the Shuttle is under thermal tension

var T_left = getprop("/fdm/jsbsim/systems/thermal-distribution/left-temperature-K");
var T_right = getprop("/fdm/jsbsim/systems/thermal-distribution/right-temperature-K");

var DeltaT = math.abs(T_left - T_right);

if (DeltaT > 60.0) {return;}

if (stage == 0)
	{
	# first open latch gangs 5-8 and 9-12
	print("PBD open stage 0");
	setprop("/fdm/jsbsim/systems/mechanical/pb-door-indicator", 0.5);
	setprop("/fdm/jsbsim/systems/mechanical/pb-door-cl5-8-latch-cmd", 1);
	setprop("/fdm/jsbsim/systems/mechanical/pb-door-cl9-12-latch-cmd", 1);
	settimer( func{ payload_bay_door_open_auto (1);}, 24.0);
	}

if (stage == 1)
	{
	# first open latch gangs 1-4 and 13-16
	print("PBD open stage 1");
	setprop("/fdm/jsbsim/systems/mechanical/pb-door-cl1-4-latch-cmd", 1);
	setprop("/fdm/jsbsim/systems/mechanical/pb-door-cl13-16-latch-cmd", 1);
	settimer( func{ payload_bay_door_open_auto (2);}, 24.0);
	}

if (stage == 2)
	{
	# unlatch right door
	print("PBD open stage 2");
	setprop("/fdm/jsbsim/systems/mechanical/pb-door-right-fwd-latch-cmd", 1);
	setprop("/fdm/jsbsim/systems/mechanical/pb-door-right-aft-latch-cmd", 1);
	settimer( func{ payload_bay_door_open_auto (3);}, 34.0);
	}

if (stage == 3)
	{
	# open right door
	print("PBD open stage 3");
	setprop("/fdm/jsbsim/systems/mechanical/pb-door-right-cmd", 1);
	settimer( func{ payload_bay_door_open_auto (4);}, 68.0);
	}

if (stage == 4)
	{
	# unlatch left door
	print("PBD open stage 4");
	setprop("/fdm/jsbsim/systems/mechanical/pb-door-left-fwd-latch-cmd", 1);
	setprop("/fdm/jsbsim/systems/mechanical/pb-door-left-aft-latch-cmd", 1);
	settimer( func{ payload_bay_door_open_auto (5);}, 34.0);
	}

if (stage == 5)
	{
	# open left door
	print("PBD open stage 5");
	setprop("/fdm/jsbsim/systems/mechanical/pb-door-left-cmd", 1);
	settimer( func{ payload_bay_door_open_auto (6);}, 68.0);
	}
if (stage == 6)
	{
	print("PBD opening finished.");
	setprop("/fdm/jsbsim/systems/mechanical/pb-door-indicator", 1);
	}
}


var payload_bay_door_close_auto = func (stage) {


var power = getprop("/fdm/jsbsim/systems/mechanical/pb-door-power");

if (power == 0.0) {return;}

# payload bay door won't move if the Shuttle is under thermal tension

var T_left = getprop("/fdm/jsbsim/systems/thermal-distribution/left-temperature-K");
var T_right = getprop("/fdm/jsbsim/systems/thermal-distribution/right-temperature-K");

var DeltaT = math.abs(T_left - T_right);

if (DeltaT > 60.0) {return;}

if (stage == 0)
	{
	# close left door
	print("PBD close stage 0");
	setprop("/fdm/jsbsim/systems/mechanical/pb-door-left-cmd", 0);
	settimer( func{ payload_bay_door_close_auto (1);}, 68.0);
	}
if (stage == 1)
	{
	# latch left door
	print("PBD close stage 1");
	setprop("/fdm/jsbsim/systems/mechanical/pb-door-left-fwd-latch-cmd", 0);
	setprop("/fdm/jsbsim/systems/mechanical/pb-door-left-aft-latch-cmd", 0);
	settimer( func{ payload_bay_door_close_auto (2);}, 34.0);
	}
if (stage == 2)
	{
	# close right door
	print("PBD close stage 2");
	setprop("/fdm/jsbsim/systems/mechanical/pb-door-right-cmd", 0);
	settimer( func{ payload_bay_door_close_auto (3);}, 68.0);
	}
if (stage == 3)
	{
	# latch right door
	print("PBD close stage 3");
	setprop("/fdm/jsbsim/systems/mechanical/pb-door-right-fwd-latch-cmd", 0);
	setprop("/fdm/jsbsim/systems/mechanical/pb-door-right-aft-latch-cmd", 0);
	settimer( func{ payload_bay_door_close_auto (4);}, 34.0);
	}
if (stage == 4)
	{
	# close latch gangs 1-4 and 13-16
	print("PBD close stage 4");
	setprop("/fdm/jsbsim/systems/mechanical/pb-door-cl1-4-latch-cmd", 0);
	setprop("/fdm/jsbsim/systems/mechanical/pb-door-cl13-16-latch-cmd", 0);
	settimer( func{ payload_bay_door_close_auto (5);}, 24.0);
	}
if (stage == 5)
	{
	# close latch gangs 5-8 and 9-12
	print("PBD close stage 5");
	setprop("/fdm/jsbsim/systems/mechanical/pb-door-cl5-8-latch-cmd", 0);
	setprop("/fdm/jsbsim/systems/mechanical/pb-door-cl9-12-latch-cmd", 0);
	settimer( func{ payload_bay_door_close_auto (6);}, 24.0);
	}
if (stage == 6)
	{
	print("PBD closing finished.");
	setprop("/fdm/jsbsim/systems/mechanical/pb-door-indicator", 0);
	}

}


#########################################################################################
# management rountines for internal timers
#########################################################################################

# mission elapsed time

var update_timers = func {


var MET = getprop("/sim/time/elapsed-sec") + getprop("/fdm/jsbsim/systems/timer/delta-MET");


var MET_string = SpaceShuttle.seconds_to_stringDHMS (elapsed);
setprop("/fdm/jsbsim/systems/timer/MET-string", MET_string);

}

var update_deltaGMT = func {

var days = getprop("/fdm/jsbsim/systems/timer/delta-GMT-days");
var hours = getprop("/fdm/jsbsim/systems/timer/delta-GMT-hours");
var minutes = getprop("/fdm/jsbsim/systems/timer/delta-GMT-minutes");
var seconds = getprop("/fdm/jsbsim/systems/timer/delta-GMT-seconds");

var delta_GMT = 86400 * days + 3600 * hours + 60 * minutes + seconds;

setprop("/fdm/jsbsim/systems/timer/delta-GMT", delta_GMT);

var delta_GMT_string = seconds_to_stringDHMS(delta_GMT);

setprop("/fdm/jsbsim/systems/timer/delta-GMT-string", delta_GMT_string);

}



var update_deltaMET = func {

var days = getprop("/fdm/jsbsim/systems/timer/delta-MET-days");
var hours = getprop("/fdm/jsbsim/systems/timer/delta-MET-hours");
var minutes = getprop("/fdm/jsbsim/systems/timer/delta-MET-minutes");
var seconds = getprop("/fdm/jsbsim/systems/timer/delta-MET-seconds");

var delta_MET = 86400 * days + 3600 * hours + 60 * minutes + seconds;

setprop("/fdm/jsbsim/systems/timer/delta-MET", delta_MET);

var delta_MET_string = seconds_to_stringDHMS(delta_MET);

setprop("/fdm/jsbsim/systems/timer/delta-MET-string", delta_MET_string);

}

var blank_deltaMET = func {

setprop("/fdm/jsbsim/systems/timer/delta-MET-days", 0);
setprop("/fdm/jsbsim/systems/timer/delta-MET-hours", 0);
setprop("/fdm/jsbsim/systems/timer/delta-MET-minutes", 0);
setprop("/fdm/jsbsim/systems/timer/delta-MET-seconds", 0);
setprop("/fdm/jsbsim/systems/timer/delta-MET-string", "");
}

var blank_deltaGMT = func {

setprop("/fdm/jsbsim/systems/timer/delta-GMT-days", 0);
setprop("/fdm/jsbsim/systems/timer/delta-GMT-hours", 0);
setprop("/fdm/jsbsim/systems/timer/delta-GMT-minutes", 0);
setprop("/fdm/jsbsim/systems/timer/delta-GMT-seconds", 0);
setprop("/fdm/jsbsim/systems/timer/delta-GMT-string", "");
}
