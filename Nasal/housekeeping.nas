
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
