
# housekeeping tasks for the Space Shuttle
# Thorsten Renk 2015 - 2017

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
	#setprop("/sim/messages/copilot", "No helium left for a second dump.");
	SpaceShuttle.callout.make("No helium left for a second dump.", "help");
	return;
	}

# check whether the helium system has pressure

var helium_pressurized = getprop("/fdm/jsbsim/systems/mps/helium-system-pressurized");
var manifold_open = getprop("/fdm/jsbsim/systems/mps/LO2-manifold-valve-status");

if ((helium_pressurized == 0) or (manifold_open == 0))
	{
	#setprop("/sim/messages/copilot", "Unable to initiate LO2 dump without helium pressure.");
	SpaceShuttle.callout.make("Unable to initiate LO2 dump without helium pressure.", "help");
	return;
	}


# check how many pre-valves are open

var n_LO2_prevalves = get_num_LO2_prevalves();


if (n_LO2_prevalves == 0)
	{
	#setprop("/sim/messages/copilot", "Unable to initiate LO2 dump with prevalves closed.");
	SpaceShuttle.callout.make("Unable to initiate LO2 dump with prevalves closed.", "help");
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
	setprop("/fdm/jsbsim/systems/mps/propellant-dump-cmd",0);
	setprop("/fdm/jsbsim/propulsion/tank[17]/external-flow-rate-pps", 0.0);
	setprop("/fdm/jsbsim/propulsion/tank[18]/external-flow-rate-pps", 0.0);
	#setprop("/sim/messages/copilot", "Propellant dump completed.");
	SpaceShuttle.callout.make("Propellant dump completed.", "info");
	setprop("/fdm/jsbsim/systems/mps/propellant-dump-density", 0.0);
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

#setprop("/fdm/jsbsim/systems/mps/plume-color-1", 0.7 * getprop("/rendering/scene/diffuse/red"));
#setprop("/fdm/jsbsim/systems/mps/plume-color-2", 0.9 * getprop("/rendering/scene/diffuse/red"));
#setprop("/fdm/jsbsim/systems/mps/plume-color-3", getprop("/rendering/scene/diffuse/red"));

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

# check a ttg requirement because oxidizer may run out before fuel
if ((fuel_current < target_quantity) or (ttg < - 5))
	{
	#print("Fuel dump ends.");
	setprop("/fdm/jsbsim/systems/rcs/oms-rcs-dump-cmd", 0); 
	setprop("/fdm/jsbsim/systems/oms/oms-dump-ttg-s", 0);
	SpaceShuttle.toggle_oms_fuel_dump();
	SpaceShuttle.unset_oms_rcs_crossfeed();
	return;
	}

settimer( func {oms_fuel_dump_loop(target_quantity); } , 1.0);

}


#########################################################################################
# fuel cell purge - needs to check for purge line freezing
#########################################################################################

var fuel_cell_purge_status = 0;

var fuel_cell_purge_manage = func (cell) {

var purge_valve = getprop("/fdm/jsbsim/systems/electrical/fc["~cell~"]/purge-valve-status");

if (purge_valve == 1) {fuel_cell_purge_start(cell);}
else {fuel_cell_purge_stop(cell);}
}

var fuel_cell_purge_start = func (cell) {


var T_line = getprop("/fdm/jsbsim/systems/electrical/purge-line-T");
var p_freeze = 0.0;

var efficiency = getprop("/fdm/jsbsim/systems/electrical/fc["~cell~"]/fc-efficiency");
var efficiency_gain = efficiency / 120.0;

# line temperature should be above 79 F aka 299 K

if (T_line < 299)
	{
	p_freeze = (299 - T_line) * 0.003;
	}
else 
	{
	setprop("/fdm/jsbsim/systems/electrical/purge-line-throughput", 1.0);
	}

print("Initiating fuel cell purge of FC"~(cell+1)~"...");
print("Line freeze probability ", p_freeze);

fuel_cell_purge_status = 1;
fuel_cell_purge_loop (cell, p_freeze, efficiency_gain);

}

var fuel_cell_purge_stop = func (cell) {

print("Fuel cell purge ends.");
fuel_cell_purge_status = 0;

}

var fuel_cell_purge_loop = func (cell, p_freeze, efficiency_gain) {

if (fuel_cell_purge_status == 0) {return;}

var efficiency = getprop("/fdm/jsbsim/systems/electrical/fc["~cell~"]/fc-efficiency");
efficiency = efficiency + efficiency_gain;
if (efficiency > 1.0) {efficiency = 1.0;}
print("Efficiency is now ", efficiency);
setprop("/fdm/jsbsim/systems/electrical/fc["~cell~"]/fc-efficiency", efficiency);

if (rand() < p_freeze) 
	{
	print("Purge line freezing up...");
	efficiency_gain = efficiency_gain * 0.5;
	var throughput = getprop("/fdm/jsbsim/systems/electrical/purge-line-throughput");
	throughput = throughput * 0.5;
	setprop("/fdm/jsbsim/systems/electrical/purge-line-throughput", throughput);
	print("Throughput is now ", throughput);
	}




settimer ( func {fuel_cell_purge_loop(cell, p_freeze, efficiency_gain);}, 1.0);

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
	#setprop("/fdm/jsbsim/systems/mechanical/pb-door-indicator", 0.5);
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
	#setprop("/fdm/jsbsim/systems/mechanical/pb-door-indicator", 1);
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
	#setprop("/fdm/jsbsim/systems/mechanical/pb-door-indicator", 0);
	}

}



#########################################################################################
# Ku antenna pointing
#########################################################################################



var ku_antenna_slew_flag = 0;


var ku_antenna_slew_loop = func () {

ku_antenna_slew_flag = 1;

if ((antenna_manager.rr_mode != "MAN SLEW") and (antenna_manager.rr_mode != "AUTO TRACK")) { ku_antenna_slew_flag = 0; return;}

var elevation = SpaceShuttle.antenna_manager.ku_elevation;
var azimuth = SpaceShuttle.antenna_manager.ku_azimuth;

var vcommand = getprop("/fdm/jsbsim/systems/antenna/ku-antenna-slew-elevation-cmd");
var hcommand = getprop("/fdm/jsbsim/systems/antenna/ku-antenna-slew-azimuth-cmd");

if ((vcommand == 0) and (hcommand == 0)) {ku_antenna_slew_flag = 0;  return;}

# we slew by just commanding the angle a bit further than the value


antenna_manager.ku_antenna_point (azimuth + hcommand, elevation + vcommand);
	


#print ("Slew loop!");

settimer (ku_antenna_slew_loop, 0);
}

var ku_antenna_hold = func () {

var elevation = SpaceShuttle.antenna_manager.ku_elevation;
var azimuth = SpaceShuttle.antenna_manager.ku_azimuth;

antenna_manager.ku_antenna_point (azimuth, elevation);

}


var antenna_manager = {

	quadrant : "",
	selected_quadrant: "GPC",
	hemisphere : "LO",
	station : "",
	mode : "S-HI",
	mode_fm: "S-HI",
	rr_mode : "GPC",
	function: "COMM",
	gpc_io: 1,

	tgt_acquired : 0,
	TDRS_view_array : [0,0,0,0,0,0],
	TDRS_A : 0,
	TDRS_B : 0,
	TDRS_ku_primary : "A",
	TDRS_s_primary : "A",
	TDRS_ku_track : 0,
	TDRS_ku_tgt : 0,
	ku_azimuth : 0.0,
	ku_elevation: 0.0,
	ku_azimuth_cmd: 0.0,
	ku_elevation_cmd: 0.0,
	ku_azimuth_tgt_real: 0.0,
	ku_elevation_tgt_real: 0.0,
	ku_antenna_slew_flag: 0,
	ku_inertial_azimuth: 0.0,
	ku_inertial_elevation: 0.0,
	ku_inertial_azimuth_last: 0.0,
	ku_inertial_elevation_last: 0.0,
	ku_inertial_azimuth_rate : 0.0,
	ku_inertial_elevation_rate : 0.0,

	ku_search_flag: 0,
	ku_search_center_az: 0,
	ku_search_center_el: 0,
	ku_search_cur_az: 0,
	ku_search_cur_el: 0,
	ku_seach_param: 0,

	rr_target: {},
	rr_target_available: 0,
	rvdz_data: 0,

	s_link: 0,
	sfm_link: 0,
	ku_link: 0,
	comlink: 0,
	telemetry: 0,
	comlink_rate: 0,
	telemetry_rate: 0,
	signal_strength_s: 0,
	preamp_gain_s: 0,

	s_pm_operational: 0,
	s_fm_operational: 0,
	preamp_operational: 0,
	ku_operational: 1,

	set_function: func (function) {	
		me.function = function;
	},

	set_quadrant: func (quadrant) {

		me.selected_quadrant = quadrant;
		#print("S-band quadrant", me.selected_quadrant);
	},
	

	set_rr_target: func (coord) {
		me.rr_target = coord;
		me.rr_target_available = 1;
	},

	ku_antenna_search_init: func {

		me.ku_search_center_az = me.ku_azimuth;
		me.ku_search_center_el = me.ku_elevation;
		me.ku_search_param = 0;
		me.ku_search_cur_az = me.ku_azimuth;
		me.ku_search_cur_el = me.ku_elevation;
		me.ku_search_flag = 1;
		print("Initiating Ku antenna search pattern");

	},

	ku_antenna_search_end: func {


		me.ku_search_flag = 0;
		print("Ending Ku antenna search pattern");
	},


	ku_antenna_search: func {

		me.ku_search_param = me.ku_search_param + 0.05;

		if (me.ku_search_param == 10.0) {me.ku_antenna_search_end(); return;}

		var radius = me.ku_search_param * 3.0;
		var angle = me.ku_search_param * 2.0 * math.pi;

		me.ku_search_cur_el = me.ku_search_center_el + radius * math.cos(angle);
		me.ku_search_cur_az = me.ku_search_center_az + radius * math.sin(angle);

		#print("Searching...");
		#print(" Parameter: ", me.ku_search_param);
		#print("Azimuth: ", me.ku_search_cur_az, " Elevation: ", me.ku_search_cur_el);

	},
	


	ku_antenna_point: func (azimuth, elevation) {

		# check whether the antenna is deployed

		if (me.ku_operational == 0) {return;}


		# update commanded position for slew

		me.ku_elevation_cmd = elevation;
		me.ku_azimuth_cmd = azimuth;

		# convert Shuttle body relative azimuth and elevation to antenna angles

		var alpha = azimuth + 200.0;
		if (alpha > 360.0) {alpha = alpha - 360.0;}

		var beta = -22.36 * math.sin((alpha +6.57) * math.pi/180.0);

		beta = beta + elevation;

		setprop("/controls/shuttle/ku-antenna-alpha-deg-cmd", alpha);
		setprop("/controls/shuttle/ku-antenna-beta-deg-cmd", beta);

	},

	ku_antenna_get_angles : func {

		# get current angles and store in hash

		var alpha_cur = getprop("/controls/shuttle/ku-antenna-alpha-deg");
		var beta_cur = getprop("/controls/shuttle/ku-antenna-beta-deg");

		var azimuth = alpha_cur - 200.0;
		if (azimuth < 0.0) {azimuth = azimuth + 360.0;}

		var elevation = beta_cur + 22.36 * math.sin((alpha_cur +6.57) * math.pi/180.0);

		me.ku_azimuth = azimuth;
		me.ku_elevation = elevation;

	},

	ku_antenna_track_TDRS : func (index) {

		var no_gpc_tracking = 0;

		if ((me.gpc_io == 0) and (me.rr_mode != "AUTO TRACK")) {no_gpc_tracking = 1;}

		var angles = SpaceShuttle.com_get_TDRS_azimuth_elevation(index);

		# if we're on target, the antenna compensates for attitude errors in tracking modes
		# if we're not it can't
		
		if ((me.tgt_acquired == 1) and ((me.rr_mode == "GPC") or (me.rr_mode == "AUTO TRACK")))
			{
			if (no_gpc_tracking == 0)
				{
				me.ku_azimuth_cmd =  angles[1];
				me.ku_elevation_cmd = angles[0];
				}
			}
		else
			{
			if (no_gpc_tracking == 0)
				{
				me.ku_azimuth_cmd =  angles[3];
				me.ku_elevation_cmd = angles[2];
				}
			}
		
		me.ku_azimuth_tgt_real = angles[1];
		me.ku_elevation_tgt_real = angles[0];

		#print ("TDRS tracking angles");
		#print ("Real: ", angles[1], " ", angles[0]);
		#print ("GPC : ", angles[3], " ", angles[2]);

		me.ku_antenna_point (me.ku_azimuth_cmd, me.ku_elevation_cmd);

	},

	ku_antenna_track_target : func (coord) {

		var angles = SpaceShuttle.com_get_pointing_azimuth_elevation(coord);

		me.ku_azimuth_cmd =  angles[1];
		me.ku_elevation_cmd = angles[0];

		ku_antenna_point (angles[1], angles[0]);

	},

	comlink_establish: func (system) {

		if (system == "S")
			{
			if (me.s_link == 0)
				{
				me.s_link = 1;
				print ("S-band communication link established");
				me.comlink_rate = me.comlink_rate + 72.0; 
				me.telemetry_rate = me.telemetry_rate + 0.192;
				setprop("/mission-control/status/uplink-data-rate-kbps", me.comlink_rate);
				setprop("/mission-control/status/downlink-data-rate-mbps", me.telemetry_rate);
				}
			}
		else if (system == "Ku")
			{
			if ((me.ku_link == 0) and (me.ku_operational == 1))
				{
				me.ku_link = 1;
				print ("Ku-band communication link established");
				me.comlink_rate = me.comlink_rate + 256.0; 
				me.telemetry_rate = me.telemetry_rate + 50.0; 
				setprop("/mission-control/status/uplink-data-rate-kbps", me.comlink_rate);
				setprop("/mission-control/status/downlink-data-rate-mbps", me.telemetry_rate);
				}
			else if (me.ku_operational == 0)
				{
				me.comlink_remove("Ku");
				}

			}
		else if (system == "S-FM")
			{
			if (me.sfm_link == 0)
				{
				me.sfm_link = 1;
				print ("S-band FM downlink established");
				me.telemetry_rate = me.telemetry_rate + 1.0;
				setprop("/mission-control/status/downlink-data-rate-mbps", me.telemetry_rate);
				}
			}

		if ((me.s_link == 1) or (me.ku_link == 1) or (me.sfm_link == 1))
			{
			if ((me.comlink == 0) and ((me.ku_link == 1) or (me.s_link == 1)))
				{
				me.comlink = 1;
				setprop("/mission-control/status/comlink", 1);

				}
			if (me.telemetry == 0)
				{
				me.telemetry = 1;
				setprop("/mission-control/status/telemetry", 1);
				}

			}
	},

	comlink_remove: func (system) {
		
		if (system == "S")
			{
			if (me.s_link == 1)
				{
				me.s_link = 0;
				print ("S-band communication link lost");
				me.comlink_rate = me.comlink_rate - 72.0; 
				me.telemetry_rate = me.telemetry_rate - 0.192;
				setprop("/mission-control/status/uplink-data-rate-kbps", me.comlink_rate);
				setprop("/mission-control/status/downlink-data-rate-mbps", me.telemetry_rate);
				}
			}
		else if (system == "Ku")
			{
			if (me.ku_link == 1)
				{
				me.ku_link = 0;
				print ("Ku-band communication link lost");
				me.comlink_rate = me.comlink_rate - 256.0;
				me.telemetry_rate = me.telemetry_rate - 50.0; 
				setprop("/mission-control/status/uplink-data-rate-kbps", me.comlink_rate);
				setprop("/mission-control/status/downlink-data-rate-mbps", me.telemetry_rate);
				}
			}
		else if (system == "S-FM")
			{
			if (me.sfm_link == 1)
				{
				me.sfm_link = 0;
				print ("S-band FM downlink lost");
				me.telemetry_rate = me.telemetry_rate - 1.0;
				setprop("/mission-control/status/downlink-data-rate-mbps", me.telemetry_rate);
				}
			}


		if ((me.s_link == 0) and (me.ku_link == 0))
			{
			if (me.comlink == 1)
				{
				me.comlink = 0;
				setprop("/mission-control/status/comlink", 0);
				}
			if ((me.telemetry == 1) and (me.sfm_link == 0))
				{
				me.telemetry = 0;
				setprop("/mission-control/status/telemetry", 0);
				}
			}





	

	},

	update_status: func {

		me.s_pm_operational = getprop("/fdm/jsbsim/systems/antenna/s-pm-operational");
		me.s_fm_operational = getprop("/fdm/jsbsim/systems/antenna/s-fm-operational");
		me.preamp_operational = getprop("/fdm/jsbsim/systems/antenna/s-pm-preamp-operational");
		me.ku_operational = getprop("fdm/jsbsim/systems/mechanical/ku-antenna-operational");

	},



	run: func {

	# update operational status of antennas

	me.update_status();

	# find the closest ground station

	var shuttle_pos = geo.aircraft_position();

	if (((me.mode == "S-HI") or (me.mode == "TDRS")) and (me.preamp_operational == 1))
		{me.preamp_gain_s = 2.5;}
	else
		{me.preamp_gain_s = 0.0;}

	var gs_index = SpaceShuttle.com_find_nearest_station(me.mode, shuttle_pos);
	var los = SpaceShuttle.com_check_LOS_to_station(gs_index, shuttle_pos);

	# we need to re-do this for the S-band FM antenna because the PM antenna may be set to TDRS

	var gs_index_fm = SpaceShuttle.com_find_nearest_station(me.mode_fm, shuttle_pos); 
	var los_fm = SpaceShuttle.com_check_LOS_to_station(gs_index_fm, shuttle_pos);

	if ((me.mode == "S-HI") or (me.mode == "S-LO") or (me.mode == "SGLS"))
		{
			
		if ((los == 1) and (me.s_pm_operational == 1))
			{

			var required_quadrant = com_get_S_quadrant(gs_index, 0, shuttle_pos);

			#print("Required: ", required_quadrant, " selected: ", me.selected_quadrant);
			if (me.selected_quadrant == "GPC")
				{me.quadrant = required_quadrant;}
			else
				{
				if (me.selected_quadrant == required_quadrant)
					{me.quadrant = required_quadrant;}
				else
					{me.quadrant = "";}
				}

			if (me.quadrant == required_quadrant)
				{
				me.signal_strength_s = SpaceShuttle.com_get_signal_strength(shuttle_pos,SpaceShuttle.com_ground_site_array[gs_index].coord, me.preamp_gain_s); 
				me.station = SpaceShuttle.com_ground_site_array[gs_index].string;
				me.comlink_establish("S");
				}
			else
				{
				me.signal_strength_s = 0.0;
				me.comlink_remove("S");
				me.station = "";
				}
			}
		else
			{	
			me.quadrant = "";
			me.station = "";
			me.comlink_remove("S");
			me.signal_strength_s = 0.0;
			}
		}

	# get the S-FM hemisphere, S-FM only ever utilizes ground stations

	if ((los_fm == 1) and (me.s_fm_operational == 1))
		{
		me.hemisphere = SpaceShuttle.com_get_S_hemisphere();
		me.comlink_establish("S-FM");
		}
	else
		{
		me.hemisphere = "";
		me.comlink_remove("S-FM");
		}
		
	
	
	# see which TDRS are in view

	for (var i=0; i <6; i=i+1)
		{
		me.TDRS_view_array[i] = SpaceShuttle.com_check_LOS_to_TDRS(i, shuttle_pos);

		}

	

	# decide which TDRS we want to track

	# first try the primary selection

	var track_index = me.TDRS_A - 1;
	if (me.TDRS_ku_primary == "B") {track_index = me.TDRS_B - 1;}

	var flag = 0;

	if (track_index > 0)
		{
		if (me.TDRS_view_array[track_index] == 1) {flag = 1;}
		}
	
	if (flag == 0) # try the secondary selection
		{
		track_index = me.TDRS_B - 1;
		if (me.TDRS_ku_primary == "B") {track_index = me.TDRS_A - 1;}

		if (track_index > 0)
			{
			if (me.TDRS_view_array[track_index] == 1) {flag = 1;}
			}
		}
	if (flag == 0) # try the first visible
		{
		for (track_index =0; track_index < 6; track_index = track_index+1)
			{
			if (me.TDRS_view_array[track_index] == 1) {break;}
			}
		}

	if (me.mode == "TDRS")   # S-band PM connects to TDRS
		{
		var required_quadrant = com_get_S_quadrant(track_index, 1, shuttle_pos);

		if (me.selected_quadrant == "GPC")
				{me.quadrant = required_quadrant;}
			else
				{
				if (me.selected_quadrant == required_quadrant)
					{me.quadrant = required_quadrant;}
				else
					{me.quadrant = "";}
				}

			if ((me.quadrant == required_quadrant) and (me.preamp_operational == 1))
				{
				me.station = "";
				me.comlink_establish("S");
				me.signal_strength_s = SpaceShuttle.com_get_signal_strength(shuttle_pos,SpaceShuttle.com_TDRS_array[track_index].coord, me.preamp_gain_s); 
				}
			else
				{
				me.comlink_remove("S");
				me.station = "";
				me.signal_strength_s = 0.0;
				}
		}


	me.TDRS_ku_track = track_index +1;

	var do_tracking = 0;

	if ((me.rr_mode == "GPC") or (me.rr_mode == "GPC DESIG")) {do_tracking = 1;}
	if ((me.rr_mode == "AUTO TRACK") and (me.tgt_acquired == 1)) {do_tracking = 1;}

	if (me.ku_search_flag == 1) {do_tracking = 0;}

	if ((me.function == "COMM") and (do_tracking == 1))
		{me.ku_antenna_track_TDRS (track_index);}
	else if ((me.function == "COMM") and (me.ku_search_flag == 1))
		{
		me.ku_antenna_search();
		me.ku_azimuth_cmd = me.ku_search_cur_az;		
		me.ku_elevation_cmd = me.ku_search_cur_el;
		me.ku_antenna_point (me.ku_azimuth_cmd, me.ku_elevation_cmd);
		}
	

	if (me.function != "COMM")
		{
		me.tgt_acquired = 0;
		me.comlink_remove("Ku");
		}

	me.ku_antenna_get_angles();

	# check whether antenna is on target 

	if (do_tracking == 1)
	{
		

		var delta_az = math.abs(me.ku_azimuth_tgt_real - me.ku_azimuth);
		var delta_el = math.abs(me.ku_elevation_tgt_real - me.ku_elevation);

		#print ("Actual: ", me.ku_azimuth, " ", me.ku_elevation);
		#print ("Command: ", me.ku_azimuth_cmd, " ", me.ku_elevation_cmd);
		#print ("Real: ", me.ku_azimuth_tgt_real, " ", me.ku_elevation_tgt_real);

		#print ("Delta az: ", delta_az, " Delta el: ", delta_el);


		if ((delta_az < 1.5) and (delta_el < 1.5))
			{
			me.tgt_acquired = 1;
			if (me.function == "COMM")		
				{
				me.comlink_establish("Ku");
				}
			}
		else
			{
			me.tgt_acquired = 0;
			if (me.function == "COMM")		
				{
				me.comlink_remove("Ku");
				}
			}



	}
	else if ((me.rr_mode == "MAN SLEW") or ((me.rr_mode == "AUTO TRACK") and (me.tgt_acquired == 0))) # we need to check against all TDRS positions
	{
		
		var flag = 0;

		for (var i=0; i<6; i=i+1)
			{
			if ((me.TDRS_view_array[i] == 1) and (flag == 0))
				{
				var angles = SpaceShuttle.com_get_TDRS_azimuth_elevation(i);

				var delta_az = math.abs(me.ku_azimuth - angles[1]);
				var delta_el = math.abs(me.ku_elevation - angles[0]);

				#print (delta_az, " ", delta_el);

				if ((delta_az < 1.5) and (delta_el < 1.5))
					{
					flag = 1;
					}

				}
			}
		me.tgt_acquired = flag;

		if (me.tgt_acquired == 1)
			{
			if (me.function == "COMM")		
				{
				me.comlink_establish("Ku");
				me.ku_search_flag = 0;
				}

			}

		else if (me.tgt_acquired == 0)
			{
			if (me.function == "COMM")		
				{
				me.comlink_remove("Ku");
				}

			}
	

	}


	if ((me.TDRS_view_array[track_index] == 1) and (me.ku_operational == 1) and (me.tgt_acquired == 1))
		{me.TDRS_ku_tgt = 1;}
	else
		{me.TDRS_ku_tgt = 0;}


	# update the talkbacks

	if ((do_tracking == 1) and (me.TDRS_ku_tgt == 1))
		{
		setprop("/fdm/jsbsim/systems/antenna/ku-antenna-tracking", 1);
		}	
	else
		{
		setprop("/fdm/jsbsim/systems/antenna/ku-antenna-tracking", 0);
		}

	if (me.ku_search_flag == 1)
		{
		setprop("/fdm/jsbsim/systems/antenna/ku-antenna-searching", 1);
		}
	else
		{
		setprop("/fdm/jsbsim/systems/antenna/ku-antenna-searching", 0);
		}
	
	# compute inertial attitude change rate if antenna is on target

	if (me.tgt_acquired == 1)
		{
		me.ku_inertial_azimuth_rate = (me.ku_inertial_azimuth - me.ku_inertial_azimuth_last);
		me.ku_inertial_elevation_rate =(me.ku_inertial_elevation - me.ku_inertial_elevation_last);

		me.ku_inertial_azimuth_last = me.ku_inertial_azimuth;
		me.ku_inertial_elevation_last = me.ku_inertial_elevation;
		}

	},

};


#########################################################################################
# Sensors
#########################################################################################

var update_sensors = func {

SpaceShuttle.star_tracker_array[0].run();
SpaceShuttle.star_tracker_array[1].run();

SpaceShuttle.imu_system.run();

#SpaceShuttle.apply_star_tracker_filter();

}

#########################################################################################
# management rountines for internal timers
#########################################################################################

# mission elapsed time

var update_timers = func {


var elapsed = getprop("/sim/time/elapsed-sec");
var MET = elapsed + getprop("/fdm/jsbsim/systems/timer/delta-MET");

var MET_string = SpaceShuttle.seconds_to_stringDHMS (MET);
setprop("/fdm/jsbsim/systems/timer/MET-string", MET_string);

var MET_timer_string = SpaceShuttle.seconds_to_timer_string (MET);
setprop("/fdm/jsbsim/systems/timer/MET-timer-string", MET_timer_string);

var GMT_string =  "000/"~getprop("/sim/time/gmt-string");
setprop("/fdm/jsbsim/systems/timer/GMT-string", GMT_string);

var MET_timer1 = getprop("/fdm/jsbsim/systems/timer/timer-MET-1");

if ((MET_timer1 < MET) and (MET_timer1 > 0))
	{
	setprop("/fdm/jsbsim/systems/timer/timer-MET-1-hours",0);
	setprop("/fdm/jsbsim/systems/timer/timer-MET-1-minutes",0);
	setprop("/fdm/jsbsim/systems/timer/timer-MET-1-seconds",0);
	setprop("/fdm/jsbsim/systems/timer/timer-MET-1-string","");
	setprop("/sim/messages/copilot", "MET timer 1 time tone!");
	setprop("/fdm/jsbsim/systems/dps/error-string", "TIME TONE");
	setprop("/fdm/jsbsim/systems/timer/timer-MET-1", 0);
	}

var MET_timer2 = getprop("/fdm/jsbsim/systems/timer/timer-MET-2");

if ((MET_timer2 < MET) and (MET_timer2 > 0))
	{
	setprop("/fdm/jsbsim/systems/timer/timer-MET-2-hours",0);
	setprop("/fdm/jsbsim/systems/timer/timer-MET-2-minutes",0);
	setprop("/fdm/jsbsim/systems/timer/timer-MET-2-seconds",0);
	setprop("/fdm/jsbsim/systems/timer/timer-MET-2-string","");
	setprop("/sim/messages/copilot", "MET timer 2 time tone!");
	setprop("/fdm/jsbsim/systems/dps/error-string", "TIME TONE");
	setprop("/fdm/jsbsim/systems/timer/timer-MET-2", 0);
	}

var crt_timer_flag = getprop("/fdm/jsbsim/systems/timer/crt-timer-flag");

if (crt_timer_flag == 1)
	{
	var crt_seconds = elapsed + getprop("/fdm/jsbsim/systems/timer/crt-timer");
	var CRT_string = SpaceShuttle.seconds_to_stringDHMS (crt_seconds);
	setprop("/fdm/jsbsim/systems/timer/CRT-string", CRT_string);

	var CRT_timer = getprop("/fdm/jsbsim/systems/timer/timer-CRT");
	if ((CRT_timer < crt_seconds) and (CRT_timer > 0))
		{
		setprop("/fdm/jsbsim/systems/timer/timer-CRT-hours",0);
		setprop("/fdm/jsbsim/systems/timer/timer-CRT-minutes",0);
		setprop("/fdm/jsbsim/systems/timer/timer-CRT-seconds",0);
		setprop("/fdm/jsbsim/systems/timer/timer-CRT-string","");
		setprop("/sim/messages/copilot", "CRT timer time tone!");
		setprop("/fdm/jsbsim/systems/dps/error-string", "TIME TONE");
		setprop("/fdm/jsbsim/systems/timer/timer-CRT", 0);
		}

	}
else if (crt_timer_flag == 2)
	{
	var crt_count_to = getprop("/fdm/jsbsim/systems/timer/count-to");
	var interval_seconds = crt_count_to - MET;
	var CRT_string = SpaceShuttle.seconds_to_stringDHMS (interval_seconds);
	setprop("/fdm/jsbsim/systems/timer/CRT-string", CRT_string);
	
	if (interval_seconds < 0)
		{
		blank_count_to();
		setprop("/fdm/jsbsim/systems/timer/crt-timer-flag",0);
		}
	}


var crt_start_at = getprop("/fdm/jsbsim/systems/timer/start-at");

if ((crt_start_at < MET) and (crt_start_at > 0))
	{
	blank_start_at();
	start_CRT_timer();
	}

}

var update_deltaGMT = func {

var days = getprop("/fdm/jsbsim/systems/timer/delta-GMT-days");
var hours = getprop("/fdm/jsbsim/systems/timer/delta-GMT-hours");
var minutes = getprop("/fdm/jsbsim/systems/timer/delta-GMT-minutes");
var seconds = getprop("/fdm/jsbsim/systems/timer/delta-GMT-seconds");

var delta_GMT = 86400 * days + 3600 * hours + 60 * minutes + seconds;

#setprop("/fdm/jsbsim/systems/timer/delta-GMT", delta_GMT);

var delta_GMT_string = seconds_to_stringDHMS(delta_GMT);

setprop("/fdm/jsbsim/systems/timer/delta-GMT-string", delta_GMT_string);
}


var load_deltaGMT_MET = func {

var days = getprop("/fdm/jsbsim/systems/timer/delta-GMT-days");
var hours = getprop("/fdm/jsbsim/systems/timer/delta-GMT-hours");
var minutes = getprop("/fdm/jsbsim/systems/timer/delta-GMT-minutes");
var seconds = getprop("/fdm/jsbsim/systems/timer/delta-GMT-seconds");

var delta_GMT = 86400 * days + 3600 * hours + 60 * minutes + seconds;

if (delta_GMT > 0)
	{
	setprop("/fdm/jsbsim/systems/timer/delta-GMT", delta_GMT);
	}

days = getprop("/fdm/jsbsim/systems/timer/delta-MET-days");
hours = getprop("/fdm/jsbsim/systems/timer/delta-MET-hours");
minutes = getprop("/fdm/jsbsim/systems/timer/delta-MET-minutes");
seconds = getprop("/fdm/jsbsim/systems/timer/delta-MET-seconds");

var delta_MET = 86400 * days + 3600 * hours + 60 * minutes + seconds;

if (delta_MET > 0)
	{
	setprop("/fdm/jsbsim/systems/timer/delta-MET", delta_MET);
	}

blank_deltaGMT();
blank_deltaMET();


}



var update_deltaMET = func {

var days = getprop("/fdm/jsbsim/systems/timer/delta-MET-days");
var hours = getprop("/fdm/jsbsim/systems/timer/delta-MET-hours");
var minutes = getprop("/fdm/jsbsim/systems/timer/delta-MET-minutes");
var seconds = getprop("/fdm/jsbsim/systems/timer/delta-MET-seconds");

var delta_MET = 86400 * days + 3600 * hours + 60 * minutes + seconds;

#setprop("/fdm/jsbsim/systems/timer/delta-MET", delta_MET);

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

var set_MET_timer = func (index) {

var hours = getprop("/fdm/jsbsim/systems/timer/timer-MET-"~index~"-hours");
var minutes = getprop("/fdm/jsbsim/systems/timer/timer-MET-"~index~"-minutes");
var seconds = getprop("/fdm/jsbsim/systems/timer/timer-MET-"~index~"-seconds");

var timer_seconds = hours * 3600 + minutes * 60 + seconds;

setprop("/fdm/jsbsim/systems/timer/timer-MET-"~index, timer_seconds);

var timer_string = seconds_to_stringHMS(timer_seconds);

setprop("/fdm/jsbsim/systems/timer/timer-MET-"~index~"-string", timer_string);

}


var set_CRT_timer = func {

var hours = getprop("/fdm/jsbsim/systems/timer/timer-CRT-hours");
var minutes = getprop("/fdm/jsbsim/systems/timer/timer-CRT-minutes");
var seconds = getprop("/fdm/jsbsim/systems/timer/timer-CRT-seconds");

var timer_seconds = hours * 3600 + minutes * 60 + seconds;

setprop("/fdm/jsbsim/systems/timer/timer-CRT", timer_seconds);

var timer_string = seconds_to_stringHMS(timer_seconds);

setprop("/fdm/jsbsim/systems/timer/timer-CRT-string", timer_string);
}



var set_up_timer = func {

var days = getprop("/fdm/jsbsim/systems/timer/up-mnvr-time-days");
var hours = getprop("/fdm/jsbsim/systems/timer/up-mnvr-time-hours");
var minutes = getprop("/fdm/jsbsim/systems/timer/up-mnvr-time-minutes");
var seconds = getprop("/fdm/jsbsim/systems/timer/up-mnvr-time-seconds");

var timer_seconds = days * 86400 + hours * 3600 + minutes * 60 + seconds;

setprop("/fdm/jsbsim/systems/timer/up-mnvr-time", timer_seconds);

var timer_string = seconds_to_stringDHMS(timer_seconds);

setprop("/fdm/jsbsim/systems/timer/up-mnvr-time-string", timer_string);

}


var set_oms_mnvr_timer = func {

var days = getprop("/fdm/jsbsim/systems/ap/oms-plan/tig-days");
var hours = getprop("/fdm/jsbsim/systems/ap/oms-plan/tig-hours");
var minutes = getprop("/fdm/jsbsim/systems/ap/oms-plan/tig-minutes");
var seconds = getprop("/fdm/jsbsim/systems/ap/oms-plan/tig-seconds");

var timer_seconds = days * 86400 + hours * 3600 + minutes * 60 + seconds;

setprop("/fdm/jsbsim/systems/ap/oms-plan/tig", timer_seconds);

var timer_string = seconds_to_stringDHMS(timer_seconds);

setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-string", timer_string);

}

var update_CRT_timer = func {

var hours = getprop("/fdm/jsbsim/systems/timer/crt-timer-hours");
var minutes = getprop("/fdm/jsbsim/systems/timer/crt-timer-minutes");
var seconds = getprop("/fdm/jsbsim/systems/timer/crt-timer-seconds");

var timer_seconds = hours * 3600 + minutes * 60 + seconds;
var timer_string = seconds_to_stringHMS(timer_seconds);
setprop("/fdm/jsbsim/systems/timer/crt-timer-string", timer_string);
}

var start_CRT_timer = func {

var hours = getprop("/fdm/jsbsim/systems/timer/crt-timer-hours");
var minutes = getprop("/fdm/jsbsim/systems/timer/crt-timer-minutes");
var seconds = getprop("/fdm/jsbsim/systems/timer/crt-timer-seconds");

var timer_seconds = hours * 3600 + minutes * 60 + seconds;

timer_second = timer_seconds - getprop("/sim/time/elapsed-sec");
setprop("/fdm/jsbsim/systems/timer/crt-timer", timer_second);
setprop("/fdm/jsbsim/systems/timer/crt-timer-flag", 1);

setprop("/fdm/jsbsim/systems/timer/crt-timer-hours",0);
setprop("/fdm/jsbsim/systems/timer/crt-timer-minutes",0);
setprop("/fdm/jsbsim/systems/timer/crt-timer-seconds",0);
setprop("/fdm/jsbsim/systems/timer/crt-timer-string","");

}

var stop_CRT_timer = func {

setprop("/fdm/jsbsim/systems/timer/crt-timer-flag", 0);
setprop("/fdm/jsbsim/systems/timer/CRT-string", "000/00:00:00");
}

var update_start_count = func (index) {

var string = "start-at";

if (index == 2) 
	{
	string = "count-to";
	setprop("/fdm/jsbsim/systems/timer/crt-timer-flag", 2);
	}


var hours = getprop("/fdm/jsbsim/systems/timer/"~string~"-hours");
var minutes = getprop("/fdm/jsbsim/systems/timer/"~string~"-minutes");
var seconds = getprop("/fdm/jsbsim/systems/timer/"~string~"-seconds");
	
var timer_seconds = hours * 3600 + minutes * 60 + seconds;
var timer_string = seconds_to_stringHMS(timer_seconds);
setprop("/fdm/jsbsim/systems/timer/"~string~"-string", timer_string);
setprop("/fdm/jsbsim/systems/timer/"~string, timer_seconds);

}

var blank_start_at = func {

setprop("/fdm/jsbsim/systems/timer/start-at", 0);
setprop("/fdm/jsbsim/systems/timer/start-at-hours", 0);
setprop("/fdm/jsbsim/systems/timer/start-at-minutes", 0);
setprop("/fdm/jsbsim/systems/timer/start-at-seconds", 0);
setprop("/fdm/jsbsim/systems/timer/start-at-string", "");
}

var blank_count_to = func {

setprop("/fdm/jsbsim/systems/timer/count-to", 0);
setprop("/fdm/jsbsim/systems/timer/count-to-hours", 0);
setprop("/fdm/jsbsim/systems/timer/count-to-minutes", 0);
setprop("/fdm/jsbsim/systems/timer/count-to-seconds", 0);
setprop("/fdm/jsbsim/systems/timer/count-to-string", "");
}


#########################################################################################
# management rountines for maneuver timers
#########################################################################################

up_future_mnvr_loop_flag = 0;

var manage_up_mnvr = func (item) {

var elapsed = int(getprop("/sim/time/elapsed-sec"));
var MET = elapsed + getprop("/fdm/jsbsim/systems/timer/delta-MET");

var maneuver_time = getprop("/fdm/jsbsim/systems/timer/up-mnvr-time");

var delta_t = maneuver_time - MET;

if (delta_t < 0) # we start the maneuver immediately
	{
	exec_up_mnvr(item);
	}
else	# we start a timing loop 
	{
	up_future_mnvr_loop_flag = 1;
	up_future_mnvr_loop(item, delta_t);	
	setprop("/fdm/jsbsim/systems/ap/ops201/mnvr-future-flag", 3);
	}


}

var exec_up_mnvr = func (item) {

setprop("/fdm/jsbsim/systems/ap/ops201/mnvr-future-flag", 0);

if (getprop("/fdm/jsbsim/systems/ap/orbital-dap-auto") != 1)
		{
		create_fault_message("    SEL AUTO   ", 1, 3);
		}

if (item == 18)
	{
	SpaceShuttle.create_mnvr_vector();
	setprop("/fdm/jsbsim/systems/ap/up-mnvr-flag", 1);
	SpaceShuttle.tracking_loop_flag = 0;
	return;
	}
else if (item == 19)
	{
	SpaceShuttle.create_trk_vector();
	setprop("/fdm/jsbsim/systems/ap/up-mnvr-flag", 2); 
	SpaceShuttle.tracking_loop_flag = 0;
	return;
	}
else if (item == 20)
	{
	SpaceShuttle.create_rot_mnvr_vector();
	setprop("/fdm/jsbsim/systems/ap/up-mnvr-flag", 3);
	SpaceShuttle.tracking_loop_flag = 0;
	return;
	}


}


var up_future_mnvr_loop = func (item, delta_t) {

#print (delta_t);


if (delta_t == 30)
	{
	if (getprop("/fdm/jsbsim/systems/ap/orbital-dap-auto") != 1)
		{
		create_fault_message("    SEL AUTO   ", 1, 3);
		}
	}

if (delta_t < 0)
	{
	exec_up_mnvr(item);
	return;
	}

if (up_future_mnvr_loop_flag == 0) {return;}

settimer( func{ up_future_mnvr_loop(item, delta_t - 1);}, 1.0);
}


#########################################################################################
# canvas in-cockpit timers
#########################################################################################


var ev_timer =
{

    new : func(designation, model_element)
    {
        var obj = {parents : [ev_timer] };
        obj.designation = designation;
        obj.model_element = model_element;
	obj.time = 0;
	obj.count_flag = 0;
	obj.count_mode = "DOWN";
	obj.set_time = 0;

        var dev_canvas= canvas.new({
                "name": designation,
                    "size": [256,256], 
                    "view": [256,256],                        
                    "mipmapping": 0     
                    });
	dev_canvas.addPlacement({"node": model_element});
	dev_canvas.setColorBackground(0,0,0,0);

	obj._canvas = dev_canvas;

	var root = dev_canvas.createGroup();

	obj.time_string = root.createChild("text")
      	.setText("00:00")
        .setColor(1,0.5,0.1)
	.setFontSize(24)
	.setScale(2.5,6)
	.setFont("DSEG/DSEG7/Classic-MINI/DSEG7ClassicMini-Bold.ttf")
	.setAlignment("center-bottom")
	.setTranslation(130, 210);

    	return obj;
    },

    display : func 
    {

	var display_time = me.time;

	if ((me.count_mode == "UP") and (me.count_flag == 1))
		{
		display_time = me.set_time - me.time;
		}

	var string =  SpaceShuttle.seconds_to_stringMS(display_time);
	if (me.time < 600) {string = "0"~string;}

	me.time_string.setText(string);
    },

    set: func (sec)
    {

	sec = SpaceShuttle.clamp(sec, 0, 3600);
	me.count_flag = 0;
	me.time = sec;
	me.set_time = sec;
	me.display();
	
    },

    start: func
    {
	if (me.count_flag == 1) {return;}
	me.count_flag = 1;
	me.update();
    },

    update: func 
    {
	if (me.count_flag == 0) {return;}

	me.time = me.time - 1;
	if (me.time < 0) {me.time =0; return;}

	me.display();

	settimer (func me.update(), 1.0);
    },

    stop: func
    {
	me.count_flag = 0;
    },

    set_mode: func (mode)
    {
    
	if (mode == "UP") {me.count_mode = "UP";}
	else if (mode == "DOWN") {me.count_mode = "DOWN";}

    },

    change_timer: func (inc)
    {
	me.time = me.time + inc;
	me.time = SpaceShuttle.clamp(me.time, 0, 3600);
    },


};

var ev_timer = ev_timer.new("EventTimerF7", "event-time-glass");
ev_timer._canvas.addPlacement({"node": "A4-event-time-glass"});


var met_timer =
{

    new : func(designation, model_element)
    {
        var obj = {parents : [met_timer] };
        obj.designation = designation;
        obj.model_element = model_element;

        var dev_canvas= canvas.new({
                "name": designation,
                    "size": [128,128], 
                    "view": [128,128],                        
                    "mipmapping": 0     
                    });
	dev_canvas.addPlacement({"node": model_element});
	dev_canvas.setColorBackground(0,0,0,0);

	obj._canvas = dev_canvas;

	var root = dev_canvas.createGroup();

	obj.time_string = root.createChild("text")
      	.setText("00:00:00:00")
        .setColor(1,0.5,0.1)
	.setFontSize(16)
	.setScale(1.1,4)
	.setFont("DSEG/DSEG7/Classic-MINI/DSEG7ClassicMini-Bold.ttf")
	.setAlignment("center-bottom")
	.setTranslation(65, 100);

    	return obj;
    },

    display : func 
    {

	var string =  getprop("/fdm/jsbsim/systems/timer/MET-timer-string");
	me.time_string.setText(string);
    },

    update: func 
    {

	me.display();

	settimer (func me.update(), 1.0);
    },

};


var met_timer = met_timer.new("METTimerA4", "A4-mission-time-glass");
met_timer._canvas.addPlacement({"node": "O3-event-time-glass"});
met_timer.update();


var rms_indicator =
{

    new : func(designation, model_element, parameter)
    {
        var obj = {parents : [rms_indicator] };
        obj.designation = designation;
        obj.model_element = model_element;
	obj.parameter = parameter;

        var dev_canvas= canvas.new({
                "name": designation,
                    "size": [128,128], 
                    "view": [128,128],                        
                    "mipmapping": 0     
                    });
	dev_canvas.addPlacement({"node": model_element});
	dev_canvas.setColorBackground(0,0,0,0);

	obj._canvas = dev_canvas;

	var root = dev_canvas.createGroup();

	obj.string = root.createChild("text")
      	.setText("0.00")
        .setColor(1,0.5,0.1)
	.setFontSize(30)
	.setScale(1,3)
	.setFont("DSEG/DSEG7/Classic-MINI/DSEG7ClassicMini-Bold.ttf")
	.setAlignment("center-bottom")
	.setTranslation(65, 105);

	obj.string.enableUpdate();

    	return obj;
    },

    display : func 
    {

	var string =  sprintf("%3.2f", getprop("/fdm/jsbsim/systems/rms/"~me.parameter));
	me.string.updateText(string);
    },

    update: func 
    {

	me.display();
	settimer (func me.update(), 0.1);
    },

};

var rms_x = rms_indicator.new("RMS_X", "pos-att-ind1-glass", "show-x");
var rms_y = rms_indicator.new("RMS_X", "pos-att-ind2-glass", "show-y");
var rms_z = rms_indicator.new("RMS_X", "pos-att-ind3-glass", "show-z");

rms_x.update();
rms_y.update();
rms_z.update();


var oms_indicator =
{

    new : func(designation, model_element, parameter)
    {
        var obj = {parents : [oms_indicator] };
        obj.designation = designation;
        obj.model_element = model_element;
	obj.parameter = parameter;

        var dev_canvas= canvas.new({
                "name": designation,
                    "size": [128,128], 
                    "view": [128,128],                        
                    "mipmapping": 0     
                    });
	dev_canvas.addPlacement({"node": model_element});
	dev_canvas.setColorBackground(0,0,0,0);

	obj._canvas = dev_canvas;

	var root = dev_canvas.createGroup();

	obj.string = root.createChild("text")
      	.setText("0.00")
        .setColor(1,0.5,0.1)
	.setFontSize(30)
	.setScale(2,2.5)
	.setFont("DSEG/DSEG7/Classic-MINI/DSEG7ClassicMini-Bold.ttf")
	.setAlignment("center-bottom")
	.setTranslation(60, 105);

	obj.string.enableUpdate();

    	return obj;
    },

    display : func 
    {

	var string =  sprintf("%3.0f", getprop("/fdm/jsbsim/systems/oms-hardware/gauges/"~me.parameter));
	me.string.updateText(string);
    },

    update: func 
    {

	me.display();
	settimer (func me.update(), 0.1);
    },

};


var oms_rcs_left = oms_indicator.new("OMS/RCS_Left", "display-qty-left", "display-qty-left");
var oms_rcs_fwd = oms_indicator.new("OMS/RCS_Fwd", "display-qty-fwd", "display-qty-fwd");
var oms_rcs_right = oms_indicator.new("OMS/RCS_Right", "display-qty-right", "display-qty-right");

oms_rcs_left.update();
oms_rcs_fwd.update();
oms_rcs_right.update();

#########################################################################################
# condition manager to check long-term deterioration of fuel cells, hydraulics,...
# if maintenance isn't done properly
#########################################################################################

var condition_manager = {

	run_flag: 0,
	dt: 10.0,
	
	
	# rate at which the equipment condition reduces per second

	fuel_cell_deterioration_rate:  0.00001, # some 12 hours half life
	hyd_pressure_loss_rate: 0.0001, 
	#hyd_pressure_loss_rate: 0.001, 
	hyd_pressure_gain_rate: 0.01,  
	hyd_temp_cooling_rate: 0.0001,
	hyd_temp_eq_rate: 0.001, 

	# internal copies for logging

	fc1_efficiency: 1.0,
	fc2_efficiency: 1.0,
	fc3_efficiency: 1.0,

	hyd1_pressure: 1.0,
	hyd2_pressure: 1.0,
	hyd3_pressure: 1.0,

	hyd1_T_eq: 1.0,
	hyd2_T_eq: 1.0,
	hyd3_T_eq: 1.0,

	pump1_status: 0,
	pump2_status: 0,
	pump3_status: 0,

	oms_left_line_condition : 1.0,
	oms_right_line_condition: 1.0,

	start: func {

		if (me.run_flag == 1) {return;}
		else {me.run_flag = 1; me.update();}

	},

	stop: func {
		
		if (me.run_flag == 1) {me.run_flag = 0;}

	},

	update: func {

		# fuel cell efficiency

		if (getprop("/fdm/jsbsim/systems/electrical/fc/fc-running") == 1.0)
			{
			me.fc1_efficiency = getprop("/fdm/jsbsim/systems/electrical/fc/fc-efficiency");
			me.fc1_efficiency = me.fc1_efficiency - me.fc1_efficiency * me.fuel_cell_deterioration_rate * me.dt;
			setprop("/fdm/jsbsim/systems/electrical/fc/fc-efficiency", me.fc1_efficiency);
			}

		if (getprop("/fdm/jsbsim/systems/electrical/fc[1]/fc-running") == 1.0)
			{
			me.fc2_efficiency = getprop("/fdm/jsbsim/systems/electrical/fc[1]/fc-efficiency");
			me.fc2_efficiency = me.fc2_efficiency - me.fc2_efficiency * me.fuel_cell_deterioration_rate * me.dt;
			setprop("/fdm/jsbsim/systems/electrical/fc[1]/fc-efficiency", me.fc2_efficiency);
			}

		if (getprop("/fdm/jsbsim/systems/electrical/fc[2]/fc-running") == 1.0)
			{
			me.fc3_efficiency = getprop("/fdm/jsbsim/systems/electrical/fc[2]/fc-efficiency");
			me.fc3_efficiency = me.fc3_efficiency - me.fc3_efficiency * me.fuel_cell_deterioration_rate * me.dt;
			setprop("/fdm/jsbsim/systems/electrical/fc[2]/fc-efficiency", me.fc3_efficiency);
			}

		# hydraulic systems

		var n_pumps_active = 0;

		# system 1

		me.hyd1_pressure = getprop("/fdm/jsbsim/systems/apu/apu/circ-pressure-factor");
 		me.hyd1_T_eq= getprop("/fdm/jsbsim/systems/apu/apu/temp-equalization-factor");

		if ((me.hyd1_pressure < 0.94) and (getprop("/fdm/jsbsim/systems/apu/apu/hyd-circ-pump-cmd") == 0))
			{
			setprop("/fdm/jsbsim/systems/apu/apu/hyd-circ-pump-cmd-gpc", 1);
			n_pumps_active = n_pumps_active + 1;
			me.pump1_status = 1;
			}
		else 
			{
			setprop("/fdm/jsbsim/systems/apu/apu/hyd-circ-pump-cmd-gpc", 0);
			me.pump1_status = 0;
			}


		if (getprop("/fdm/jsbsim/systems/apu/apu/hyd-circ-pump") == 1)
			{
			me.hyd1_pressure = me.hyd1_pressure + me.dt * me.hyd_pressure_gain_rate;
			if (me.hyd1_pressure > 1.0) {me.hyd1_pressure = 1.0;}
			me.hyd1_T_eq = me.hyd1_T_eq + me.dt * me.hyd_temp_eq_rate;
			if (me.hyd1_T_eq > 1) {me.hyd1_T_eq = 1;}

			}
		else if (getprop("/fdm/jsbsim/systems/apu/hyd-1-pressurized") == 1)
			{
			me.hyd1_pressure = getprop("/fdm/jsbsim/systems/apu/apu/hyd-main-pressure-psia")/3003.0;
			}
		else
			{
			me.hyd1_pressure = me.hyd1_pressure - me.hyd1_pressure * me.dt * me.hyd_pressure_loss_rate;
			me.hyd1_T_eq = me.hyd1_T_eq - me.dt * me.hyd_temp_cooling_rate;
			if (me.hyd1_T_eq < 0.0) {me.hyd1_T_eq = 0.0;}
			}

		setprop("/fdm/jsbsim/systems/apu/apu/circ-pressure-factor", me.hyd1_pressure);
		setprop("/fdm/jsbsim/systems/apu/apu/temp-equalization-factor", me.hyd1_T_eq);


		# system 2

		me.hyd2_pressure = getprop("/fdm/jsbsim/systems/apu/apu[1]/circ-pressure-factor");
 		me.hyd2_T_eq= getprop("/fdm/jsbsim/systems/apu/apu[1]/temp-equalization-factor");

		if ((me.hyd2_pressure < 0.94) and (getprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-circ-pump-cmd") == 0) and (n_pumps_active == 0))
			{
			setprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-circ-pump-cmd-gpc", 1);
			n_pumps_active = n_pumps_active + 1;
			me.pump2_status = 1;
			}
		else 
			{
			setprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-circ-pump-cmd-gpc", 0);
			me.pump2_status = 0;
			}


		if (getprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-circ-pump") == 1)
			{
			me.hyd2_pressure = me.hyd2_pressure + me.dt * me.hyd_pressure_gain_rate;
			if (me.hyd2_pressure > 1.0) {me.hyd2_pressure = 1.0;}
			me.hyd2_T_eq = me.hyd2_T_eq + me.dt * me.hyd_temp_eq_rate;
			if (me.hyd2_T_eq > 1) {me.hyd2_T_eq = 1;}
			}
		else if (getprop("/fdm/jsbsim/systems/apu/hyd-2-pressurized") == 1)
			{
			me.hyd2_pressure = getprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-main-pressure-psia")/3006.0;
			}
		else
			{
			me.hyd2_pressure = me.hyd2_pressure - me.hyd2_pressure * me.dt * me.hyd_pressure_loss_rate;
			me.hyd2_T_eq = me.hyd2_T_eq - me.dt * me.hyd_temp_cooling_rate;
			if (me.hyd2_T_eq < 0.0) {me.hyd2_T_eq = 0.0;}
			}

		setprop("/fdm/jsbsim/systems/apu/apu[1]/circ-pressure-factor", me.hyd2_pressure);
		setprop("/fdm/jsbsim/systems/apu/apu[1]/temp-equalization-factor", me.hyd2_T_eq);

		# system 3

		me.hyd3_pressure = getprop("/fdm/jsbsim/systems/apu/apu[2]/circ-pressure-factor");
 		me.hyd3_T_eq= getprop("/fdm/jsbsim/systems/apu/apu[2]/temp-equalization-factor");

		if ((me.hyd3_pressure < 0.94) and (getprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-circ-pump-cmd") == 0) and (n_pumps_active == 0))
			{
			setprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-circ-pump-cmd-gpc", 1);
			me.pump3_status = 1;
			}
		else 
			{
			setprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-circ-pump-cmd-gpc", 0);
			me.pump3_status = 0;
			}

		if (getprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-circ-pump") == 1)
			{
			me.hyd3_pressure = me.hyd3_pressure + me.dt * me.hyd_pressure_gain_rate;
			if (me.hyd3_pressure > 1.0) {me.hyd3_pressure = 1.0;}
			me.hyd3_T_eq = me.hyd3_T_eq + me.dt * me.hyd_temp_eq_rate;
			if (me.hyd3_T_eq > 1) {me.hyd3_T_eq = 1;}
			}
		else if (getprop("/fdm/jsbsim/systems/apu/hyd-3-pressurized") == 1)
			{
			me.hyd3_pressure = getprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-main-pressure-psia")/3002.0;
			}
		else
			{
			me.hyd3_pressure = me.hyd3_pressure - me.hyd3_pressure * me.dt * me.hyd_pressure_loss_rate;
			me.hyd3_T_eq = me.hyd3_T_eq - me.dt * me.hyd_temp_cooling_rate;
			if (me.hyd3_T_eq < 0.0) {me.hyd3_T_eq = 0.0;}
			}

		setprop("/fdm/jsbsim/systems/apu/apu[2]/circ-pressure-factor", me.hyd3_pressure);
		setprop("/fdm/jsbsim/systems/apu/apu[2]/temp-equalization-factor", me.hyd3_T_eq);

		# OMS fuel lines
	
		me.oms_left_line_condition = getprop("/fdm/jsbsim/systems/failures/oms/oms-left-fuel-line-condition");

		if (SpaceShuttle.system_temperatures.OMS_left < 275.0)
			{
			me.oms_left_line_condition = me.oms_left_line_condition * 0.99;
			}
		else if (SpaceShuttle.system_temperatures.OMS_left > 288.0)
			{
			me.oms_left_line_condition = me.oms_left_line_condition * 1.02;
			if (me.oms_left_line_condition > 1) {me.oms_left_line_condition = 1;}
			}
		setprop("/fdm/jsbsim/systems/failures/oms/oms-left-fuel-line-condition", me.oms_left_line_condition);

		me.oms_right_line_condition = getprop("/fdm/jsbsim/systems/failures/oms/oms-right-fuel-line-condition");

		if (SpaceShuttle.system_temperatures.OMS_right < 275.0)
			{
			me.oms_right_line_condition = me.oms_right_line_condition * 0.99;
			}
		else if (SpaceShuttle.system_temperatures.OMS_right > 288.0)
			{
			me.oms_right_line_condition = me.oms_right_line_condition * 1.02;
			if (me.oms_right_line_condition > 1) {me.oms_right_line_condition = 1;}
			}
		setprop("/fdm/jsbsim/systems/failures/oms/oms-right-fuel-line-condition", me.oms_right_line_condition);

		#me.list();

		settimer (func me.update(), me.dt);
	},

	list: func {

		var string1 = "OFF";
		if (me.pump1_status == 1) {string1 = "ON";}

		var string2 = "OFF";
		if (me.pump2_status == 1) {string2 = "ON";}

		var string3 = "OFF";
		if (me.pump3_status == 1) {string3 = "ON";}


		print();
		print("Long term system status simulation:");
		print("===============================");
		print("Fuel cell status:");
		print("FC1:  ", sprintf("%1.3f",me.fc1_efficiency), " FC2:  ", sprintf("%1.3f",me.fc2_efficiency), " FC3:  ", sprintf("%1.3f",me.fc3_efficiency));
		print("Hydraulic pressure:");
		print("HYD1: ", sprintf("%4.1f",me.hyd1_pressure * 2600.0), " HYD2: ", sprintf("%4.1f",me.hyd2_pressure * 2600.0), " HYD3: ", sprintf("%4.1f",me.hyd3_pressure * 2600.0));
		print("PUMP1: ", string1, " PUMP2: ", string2, " PUMP3: ", string3);
		print("Temperature equilibration:");
		print("SYS1: ", sprintf("%1.2f", me.hyd1_T_eq), " SYS2: ", sprintf("%1.2f", me.hyd2_T_eq), " SYS3: ", sprintf("%1.2f",me.hyd3_T_eq));
		print("Fuel line status:");
		print("OMS L: ", sprintf("%1.2f",me.oms_left_line_condition), " OMS R: ", sprintf("%1.2f",me.oms_right_line_condition));

	},



};



#########################################################################################
# listeners and code to automatically shut down a manifold for a fail-on condition
#########################################################################################

var auto_manifold_shutdown = func(manifold, state) {

if ((state < 1.0) or (state == 1.0)) {return;}

if (getprop("/fdm/jsbsim/systems/rcs/auto-manf-close") == 0) {return;}

if (manifold == "F1")
	{setprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-1-status", 0);}
else if (manifold == "F2")
	{setprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-2-status", 0);}
else if (manifold == "F3")
	{setprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-3-status", 0);}
else if (manifold == "F4")
	{setprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-4-status", 0);}
else if (manifold == "F5")
	{setprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-5-status", 0);}

}

setlistener("/fdm/jsbsim/systems/cws/jet-fail-f1", func (n) {auto_manifold_shutdown("F1", n.getValue());}, 0,0);
setlistener("/fdm/jsbsim/systems/cws/jet-fail-f2", func (n) {auto_manifold_shutdown("F2", n.getValue());}, 0,0);
setlistener("/fdm/jsbsim/systems/cws/jet-fail-f3", func (n) {auto_manifold_shutdown("F3", n.getValue());}, 0,0);
setlistener("/fdm/jsbsim/systems/cws/jet-fail-f4", func (n) {auto_manifold_shutdown("F4", n.getValue());}, 0,0);
setlistener("/fdm/jsbsim/systems/cws/jet-fail-f5", func (n) {auto_manifold_shutdown("F5", n.getValue());}, 0,0);

#########################################################################################
# listeners and code to model MDU power consumption
#########################################################################################

# base LCD screen power consumption is assumed 35 kW, out of which 10 kW are for fully dimmed unit

var set_MDU_power = func (desig)
{
var MDU_index = -1;

if (desig == "L1") {MDU_index = 0;}
else if (desig == "L2") {MDU_index = 1;}
else if (desig == "C1") {MDU_index = 2;}
else if (desig == "C2") {MDU_index = 3;}
else if (desig == "C3") {MDU_index = 4;}
else if (desig == "C4") {MDU_index = 5;}
else if (desig == "C5") {MDU_index = 6;}
else if (desig == "R1") {MDU_index = 7;}
else if (desig == "R2") {MDU_index = 8;}
else if (desig == "A6") {MDU_index = 9;}

var power_switch_state = getprop("/fdm/jsbsim/systems/electrical/display/"~desig~"-pwr-switch");
var mdu = SpaceShuttle.MDU_array[MDU_index];
var dim_switch_state = mdu.mdu_device_status;

if (power_switch_state == 1) {mdu.operational = 1;}
else {mdu.operational = 0;}

var mdu_power_consumption = (10.0 + 2.5 * (dim_switch_state+1) ) * mdu.operational;

print (mdu.designation, ": Power consumption is now: ", mdu_power_consumption, " W");

setprop("/fdm/jsbsim/systems/electrical/display/"~mdu.designation~"-power-demand-kW", (mdu_power_consumption/1000.0));

}

setlistener("/fdm/jsbsim/systems/electrical/display/L1-pwr-switch", func {set_MDU_power("L1");}, 0,0);
setlistener("/sim/model/shuttle/controls/PFD/mode1", func {set_MDU_power("L1");}, 0,0);

setlistener("/fdm/jsbsim/systems/electrical/display/L2-pwr-switch", func {set_MDU_power("L2");}, 0,0);
setlistener("/sim/model/shuttle/controls/PFD/mode2", func {set_MDU_power("L2");}, 0,0);

setlistener("/fdm/jsbsim/systems/electrical/display/C1-pwr-switch", func {set_MDU_power("C1");}, 0,0);
setlistener("/sim/model/shuttle/controls/PFD/mode3", func {set_MDU_power("C1");}, 0,0);

setlistener("/fdm/jsbsim/systems/electrical/display/C2-pwr-switch", func {set_MDU_power("C2");}, 0,0);
setlistener("/sim/model/shuttle/controls/PFD/mode4", func {set_MDU_power("C2");}, 0,0);

setlistener("/fdm/jsbsim/systems/electrical/display/C3-pwr-switch", func {set_MDU_power("C3");}, 0,0);
setlistener("/sim/model/shuttle/controls/PFD/mode5", func {set_MDU_power("C3");}, 0,0);

setlistener("/fdm/jsbsim/systems/electrical/display/C4-pwr-switch", func {set_MDU_power("C4");}, 0,0);
setlistener("/sim/model/shuttle/controls/PFD/mode6", func {set_MDU_power("C4");}, 0,0);

setlistener("/fdm/jsbsim/systems/electrical/display/C1-pwr-switch", func {set_MDU_power("C5");}, 0,0);
setlistener("/sim/model/shuttle/controls/PFD/mode7", func {set_MDU_power("C5");}, 0,0);

setlistener("/fdm/jsbsim/systems/electrical/display/R1-pwr-switch", func {set_MDU_power("R1");}, 0,0);
setlistener("/sim/model/shuttle/controls/PFD/mode8", func {set_MDU_power("R1");}, 0,0);

setlistener("/fdm/jsbsim/systems/electrical/display/R2-pwr-switch", func {set_MDU_power("R2");}, 0,0);
setlistener("/sim/model/shuttle/controls/PFD/mode9", func {set_MDU_power("R2");}, 0,0);

setlistener("/fdm/jsbsim/systems/electrical/display/A6-pwr-switch", func {set_MDU_power("A6");}, 0,0);
setlistener("/sim/model/shuttle/controls/PFD/mode10", func {set_MDU_power("A6");}, 0,0);

setlistener("/fdm/jsbsim/systems/electrical/display/R11-pwr-switch", func {set_MDU_power("R11");}, 0,0);
setlistener("/sim/model/shuttle/controls/PFD/mode11", func {set_MDU_power("R11");}, 0,0);
