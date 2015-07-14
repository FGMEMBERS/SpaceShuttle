
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
# Auotmatic payload bay opening sequence consists of first unlatching the centerline, then
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
