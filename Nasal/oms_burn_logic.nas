# logic to manage OMS burns 
# for the Space Shuttle orbital maneuvering
# Thorsten Renk 2015-2018



######################################
# OMS burn preparation computations
######################################

var oms_burn_target = {
	tig: 0.0, 
	apoapsis:0.0, 
	periapsis: 0.0, 
	rei: 0.0, 
	mark: 0, 
	peg4: 0, 
	propellant_flow: 0.0,
	vgo_x: 0.0,
	vgo_y: 0.0,
	vgo_z: 0.0,
	dvtot: 0.0,
	dvx_mark: 0.0,
	dvy_mark: 0.0,
	dvz_mark: 0.0,
	ops: 0,
	};


var create_oms_burn_vector_peg4 = func {


var H = getprop("/fdm/jsbsim/systems/ap/oms-plan/ht");
var thetaT = getprop("/fdm/jsbsim/systems/ap/oms-plan/theta-t");
var c1 = getprop("/fdm/jsbsim/systems/ap/oms-plan/c1");
var c2 = getprop("/fdm/jsbsim/systems/ap/oms-plan/c2");

var tig = getprop("/fdm/jsbsim/systems/ap/oms-plan/tig");
var MET = getprop("/sim/time/elapsed-sec") + getprop("/fdm/jsbsim/systems/timer/delta-MET");

var ops = getprop("/fdm/jsbsim/systems/dps/ops");

SpaceShuttle.targeting_manager.set_ops(ops);

SpaceShuttle.targeting_manager.parameter_reset();
SpaceShuttle.targeting_manager.capture_current();

SpaceShuttle.targeting_manager.set_acceleration(0.51);
SpaceShuttle.targeting_manager.set_peg4(H * 1852.0, thetaT, c1 * 0.3048, c2, tig - MET);

SpaceShuttle.targeting_manager.start();

#thread.newthread ( func {SpaceShuttle.targeting_manager.evolve(4000.0);});

peg4_holding_loop();

}

var peg4_holding_loop = func {

if (SpaceShuttle.targeting_manager.evolution_finished == 0) 
	{settimer (func {peg4_holding_loop(); }, 1.0);}
else
	{

	if (SpaceShuttle.targeting_manager.peg4_fit_converged == 1)
		{
		setprop("/fdm/jsbsim/systems/ap/oms-plan/dvx", SpaceShuttle.targeting_manager.dvx/0.3048);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/dvy", SpaceShuttle.targeting_manager.dvy/0.3048);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/dvz", SpaceShuttle.targeting_manager.dvz/0.3048);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/peg4-entered", 0);

		setprop("/fdm/jsbsim/systems/ap/oms-plan/burn-plan-available", 1);
		setprop("/fdm/jsbsim/systems/ap/oms-mnvr-flag", 2);

		oms_burn_target.peg4 = 1;

		var ei_lat = SpaceShuttle.targeting_manager.get_latitude();
		var ei_lon = SpaceShuttle.targeting_manager.get_longitude();


		var shuttle_pos = geo.Coord.new();
		shuttle_pos.set_latlon(ei_lat, ei_lon);

	 	#var rei = shuttle_pos.distance_to(landing_site)/1000.0 * 0.539956803456;
		#print ("Numerical REI: ", rei);

		oms_burn_target.rei = shuttle_pos.distance_to(landing_site)/1000.0 * 0.539956803456;

		create_oms_burn_vector();
		}

	else
		{
		SpaceShuttle.callout.make("PEG-4 fit did not converge!", "essential");
		}
	}


}


var create_oms_burn_vector = func {



var dvx = getprop("/fdm/jsbsim/systems/ap/oms-plan/dvx");
var dvy = getprop("/fdm/jsbsim/systems/ap/oms-plan/dvy");
var dvz = getprop("/fdm/jsbsim/systems/ap/oms-plan/dvz");



var dvtot = math.sqrt(dvx*dvx + dvy*dvy + dvz * dvz);

var weight_lb = getprop("/fdm/jsbsim/systems/ap/oms-plan/weight");

if (getprop("/fdm/jsbsim/systems/navigation/state-vector/use-realistic-sv") == 0)
	{weight_lb = getprop("/fdm/jsbsim/inertia/weight-lbs");}

var burn_mode = getprop("/fdm/jsbsim/systems/ap/oms-plan/burn-mode");

var thrust_lb = 12174.0;
oms_burn_target.propellant_flow = 38.28;

if ((burn_mode == 2) or (burn_mode == 3))
	{
	thrust_lb = 0.5 * thrust_lb;
	oms_burn_target.propellant_flow = 0.5 * oms_burn_target.propellant_flow;
	}
else if (burn_mode == 4)
	{
	thrust_lb = 3480.0;
	oms_burn_target.propellant_flow = 0.28 * oms_burn_target.propellant_flow;
	}

var acceleration = thrust_lb/weight_lb;

var burn_time_s = dvtot/(acceleration * 32.17405);
burn_time_s *= 0.99; # better to err on the short side

if (oms_burn_target.peg4 == 1)
	{
	var prop_to_burn = getprop("/fdm/jsbsim/systems/ap/oms-plan/prplt");
	var expected_prop_to_burn = burn_time_s * 38.28;

	if (prop_to_burn > expected_prop_to_burn)
		{
		dvtot = prop_to_burn/expected_prop_to_burn * dvtot;
		dvy = math.sqrt(dvtot*dvtot - dvx*dvx + dvz*dvz);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/dvy", dvy);
		burn_time_s = dvtot/(acceleration * 32.17405);
		}
	
	}


var zero_ang_pitch = 11.4 * sgeo_D2R;
var zero_ang_yaw = 0.0;

if (burn_mode == 2)
	{
	zero_ang_yaw = 8.9 * sgeo_D2R;
	}
else if (burn_mode == 3)
	{
	zero_ang_yaw = -8.9 * sgeo_D2R;
	}

oms_burn_target.vgo_x = dvtot * math.cos(zero_ang_pitch) * math.cos(zero_ang_yaw);
oms_burn_target.vgo_z = dvtot * math.sin(zero_ang_pitch) * math.cos(zero_ang_yaw);
oms_burn_target.vgo_y = dvtot * math.sin(zero_ang_yaw);

oms_burn_target.dvtot = dvtot;


setprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-x", oms_burn_target.vgo_x);
setprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-y", oms_burn_target.vgo_y);
setprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-z", oms_burn_target.vgo_z);

var seconds = math.mod(int(burn_time_s), 60);
var minutes = int (burn_time_s/60.0);

if (seconds<10) {seconds = "0"~seconds;}

var burn_time_string = minutes~":"~seconds;


setprop("/fdm/jsbsim/systems/ap/oms-plan/dvtot", dvtot);
setprop("/fdm/jsbsim/systems/ap/oms-plan/tgo-string", burn_time_string);
setprop("/fdm/jsbsim/systems/ap/oms-plan/tgo-s", int(burn_time_s));

var tx = dvx/dvtot;
var ty = dvy/dvtot;
var tz = dvz/dvtot;

oms_burn_target.tx = tx;
oms_burn_target.ty = ty;
oms_burn_target.tz = tz;
oms_burn_target.dvtot = dvtot;


var MET = getprop("/sim/time/elapsed-sec") + getprop("/fdm/jsbsim/systems/timer/delta-MET");
var tig = getprop("/fdm/jsbsim/systems/ap/oms-plan/tig");

oms_burn_target.tig = tig;

if (tig > MET) # the burn is in the future, need to extrapolate state vector
	{
	setprop("/fdm/jsbsim/systems/ap/oms-plan/apoapsis-nm", 0.0);
	setprop("/fdm/jsbsim/systems/ap/oms-plan/periapsis-nm", 0.0);
	oms_burn_target.time_to_burn = tig - MET;
	oms_future_burn_start(tig - MET);
	return;
	}


settimer(func {tracking_loop_flag = 1; oms_burn_loop(tx, ty, tz, dvtot);}, 0.2);


}


var oms_future_burn_start = func (time) {

#var x = getprop("/fdm/jsbsim/position/eci-x-ft") * 0.3048;
#var y = getprop("/fdm/jsbsim/position/eci-y-ft") * 0.3048;
#var z = getprop("/fdm/jsbsim/position/eci-z-ft") * 0.3048;

#var vx = getprop("/fdm/jsbsim/velocities/eci-x-fps") * 0.3048;
#var vy = getprop("/fdm/jsbsim/velocities/eci-y-fps") * 0.3048;
#var vz = getprop("/fdm/jsbsim/velocities/eci-z-fps") * 0.3048;

#var state_x = [x,y,z];
#var state_v = [vx, vy, vz];

setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-flag", 0);

#SpaceShuttle.state_extrapolate (state_x, state_v, 0.0, time);

var ops = getprop("/fdm/jsbsim/systems/dps/ops");
var burn_time = getprop("/fdm/jsbsim/systems/ap/oms-plan/tgo-s");

SpaceShuttle.targeting_manager.burn_verbose = 1;

SpaceShuttle.targeting_manager.set_ops(ops);
SpaceShuttle.targeting_manager.parameter_reset();
SpaceShuttle.targeting_manager.set_evolution_time(time + burn_time + 10.0);
SpaceShuttle.targeting_manager.capture_current();

SpaceShuttle.targeting_manager.set_acceleration(0.51);
SpaceShuttle.targeting_manager.set_peg7(oms_burn_target.tx * 0.3048 * oms_burn_target.dvtot ,oms_burn_target.ty * 0.3048 * oms_burn_target.dvtot ,oms_burn_target.tz * 0.3048 * oms_burn_target.dvtot, time);

SpaceShuttle.targeting_manager.compute_elements();
SpaceShuttle.targeting_manager.list_elements();

SpaceShuttle.targeting_manager.start();

oms_future_burn_hold();
}

# need to wait till we have the trajectory predicted

var oms_future_burn_hold = func {

#var flag = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-flag");

var flag = SpaceShuttle.targeting_manager.evolution_finished;

print("Computing trajectory prediction...");

if (flag == 1)
	{
	SpaceShuttle.targeting_manager.compute_elements();
	SpaceShuttle.targeting_manager.list_elements();
	setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-flag", 1);
	oms_future_burn_finished();
	return;
	}

settimer(oms_future_burn_hold, 1.0);
}


var oms_future_burn_finished = func {

# retrieve the state vector at ignition time

#var x = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-x")/0.3048;
#var y = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-y")/0.3048;
#var z = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-z")/0.3048;

#var vx = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-vx")/0.3048;
#var vy = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-vy")/0.3048;
#var vz = getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-vz")/0.3048;

#var r = [x,y,z];
#var v = [vx, vy, vz];


#print("Extrapolated state pos: ", x, " ", y, " ", z); 
#print("Extrapolated state vel: ", vx, " ", vy, " ", vz); 

# construct prograde/radial/normal coordinate system for this state vector


#var prograde = [vx, vy, vz];
#var radial = [x, y, z];

#prograde = normalize(prograde);
#radial = normalize(radial);

#radial = orthonormalize(prograde, radial);

#var normal = cross_product (prograde, radial);



# now get the inertial velocity change components for the burn taget

#var tgt0 = oms_burn_target.tx * prograde[0] + oms_burn_target.ty * normal[0] + oms_burn_target.tz * radial[0];
#var tgt1 = oms_burn_target.tx * prograde[1] + oms_burn_target.ty * normal[1] + oms_burn_target.tz * radial[1];
#var tgt2 = oms_burn_target.tx * prograde[2] + oms_burn_target.ty * normal[2] + oms_burn_target.tz * radial[2];

#print("Target:");
#print(tgt0, " ", tgt1, " ", tgt2);

# add the burn target velocity components to the state vector


#var dv = scalar_product(oms_burn_target.dvtot, [tgt0, tgt1, tgt2]);

#v = add_vector(v, dv);



# compute apoapsis and periapsis

#var apses = SpaceShuttle.compute_apses(r,v);

var r = SpaceShuttle.scalar_product(1./0.3048, SpaceShuttle.targeting_manager.pos);
var v = SpaceShuttle.scalar_product(1./0.3048, SpaceShuttle.targeting_manager.vel);

var apses = SpaceShuttle.compute_apses(r, v);
var sea_level_radius_ft = getprop("/fdm/jsbsim/ic/sea-level-radius-ft");

var periapsis_nm = (apses[0] - sea_level_radius_ft)/ 6076.11548556;
var apoapsis_nm = (apses[1] - sea_level_radius_ft)/ 6076.11548556;

print("TA: ", apoapsis_nm, "TP: ", periapsis_nm); 

oms_burn_target.apoapsis = apoapsis_nm;
oms_burn_target.periapsis = periapsis_nm;

var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");

if ((major_mode == 301) or (major_mode == 302) or (major_mode == 303))
	{

	if (oms_burn_target.peg4 == 0) # need to estimate REI
		{
		#print("Extrapolated state reduced vel: ", v[0], " ", v[1], " ", v[2]); 
		var rei = SpaceShuttle.get_rei(r,v);

		# correct REI for empirics and time to interface

		var rei_correction = 375.0 + 3.6556 * periapsis_nm;
		rei_correction = rei_correction - oms_burn_target.time_to_burn * norm(v) * 0.000164578833693;
		# also Earth rotates while we coast, this is very naive

		var lat = getprop("/position/latitude-deg");
		var rot_correction =  math.cos(math.pi * lat/180.0) * 465.0 * oms_burn_target.time_to_burn * 0.000539956803456;

		oms_burn_target.rei = rei + rei_correction + rot_correction;
		}
	}

# start the tracking loop to maneuver into burn attitude

settimer(func {tracking_loop_flag = 1; oms_burn_loop(oms_burn_target.tx, oms_burn_target.ty, oms_burn_target.tz, oms_burn_target.dvtot);}, 0.2); 
}


######################################
# loop to track the OMS burn attitude
######################################

var oms_burn_loop  = func (tx, ty, tz, dvtot) {

if (tracking_loop_flag == 0) {return;}

#print("Tracking..");

var prograde = [getprop("/fdm/jsbsim/systems/pointing/inertial/prograde[0]"),getprop("/fdm/jsbsim/systems/pointing/inertial/prograde[1]"), getprop("/fdm/jsbsim/systems/pointing/inertial/prograde[2]")];

var radial = [getprop("/fdm/jsbsim/systems/pointing/inertial/radial[0]"),getprop("/fdm/jsbsim/systems/pointing/inertial/radial[1]"), getprop("/fdm/jsbsim/systems/pointing/inertial/radial[2]")];

var radial_up = radial;


# prograde and radial don't really form an ON system for eccentric orbits, so we correct that
# we need exact prograde orientation so we tilt the radial base vector for pointing

prograde = normalize(prograde);
radial = orthonormalize(prograde, radial);

var normal = cross_product (prograde, radial);



# vtgt is used to predict the apses, so it uses a pure LVLH system

var vtgt0 = tx * prograde[0] + ty * normal[0] + tz * radial[0];
var vtgt1 = tx * prograde[1] + ty * normal[1] + tz * radial[1];
var vtgt2 = tx * prograde[2] + ty * normal[2] + tz * radial[2];

# the orientation however has to be done taking the 11.4 deg
# thrust axis offset of the OMS into account
# in addition, if the burn is single-engine, there's a ~8.9 deg offset in yaw


# first we need pitch, yaw and roll of the thrust axis

var py = get_pitch_yaw ([tx, ty, tz]);
var tv_roll = getprop("/fdm/jsbsim/systems/ap/oms-plan/tv-roll");
var tv_pitch = py[0] * sgeo_R2D;
var tv_yaw = py[1] * sgeo_R2D;

# then we correct for the 11.4 deg offset - in heads-up attitude that is upward pitch

var burn_mode = getprop("/fdm/jsbsim/systems/ap/oms-plan/burn-mode");

var zero_ang_yaw = 0.0;

if (burn_mode == 2) 
	{
	zero_ang_yaw = -8.9;
	}
else if (burn_mode == 3)
	{
	zero_ang_yaw = 8.9;
	}

var tv_pitch = tv_pitch + 11.4 * math.cos(tv_roll * sgeo_D2R) + zero_ang_yaw * math.sin(tv_roll * sgeo_D2R);
var tv_yaw = tv_yaw + 11.4 * math.sin(tv_roll * sgeo_D2R) + zero_ang_yaw * math.cos(tv_roll * sgeo_D2R);

#print("TV PYR: ",tv_pitch, " ", tv_yaw , " ", tv_roll);

# now we construct the components of the body axis pointing vector

var tv_pointing_body = SpaceShuttle.orientTaitBryan([1,0,0], tv_yaw , tv_pitch, tv_roll);

#print("TV pointing body: ", tv_pointing_body[0], " ", tv_pointing_body[1], " ", tv_pointing_body[2]);
#print("Norm: ", norm(tv_pointing_body));


var tv_secondary_body = SpaceShuttle.orientTaitBryan([0,1,0], tv_yaw , tv_pitch, tv_roll );

# multiplying the components with the inertial system results in the pointing vector

var prograde_rot = scalar_product(tv_pointing_body[0], prograde);
prograde_rot = add_vector(prograde_rot, scalar_product(tv_pointing_body[1], normal) );
prograde_rot = add_vector(prograde_rot, scalar_product(tv_pointing_body[2], radial) );

var normal_rot = scalar_product(tv_secondary_body[0], prograde);
normal_rot = add_vector(normal_rot, scalar_product(tv_secondary_body[1], normal) );
normal_rot = add_vector(normal_rot, scalar_product(tv_secondary_body[2], radial) );

prograde = prograde_rot;
normal = normal_rot;
radial = cross_product (prograde, normal);




setprop("/fdm/jsbsim/systems/ap/track/target-vector[0]", prograde[0]);
setprop("/fdm/jsbsim/systems/ap/track/target-vector[1]", prograde[1]);
setprop("/fdm/jsbsim/systems/ap/track/target-vector[2]", prograde[2]);

setprop("/fdm/jsbsim/systems/ap/track/target-sec[0]", -radial[0]);
setprop("/fdm/jsbsim/systems/ap/track/target-sec[1]", -radial[1]);
setprop("/fdm/jsbsim/systems/ap/track/target-sec[2]", -radial[2]);

setprop("/fdm/jsbsim/systems/ap/track/target-trd[0]", normal[0]);
setprop("/fdm/jsbsim/systems/ap/track/target-trd[1]", normal[1]);
setprop("/fdm/jsbsim/systems/ap/track/target-trd[2]", normal[2]);


# now we compute apoapsis and periapsis if the burn were right now

if (getprop("/fdm/jsbsim/systems/ap/oms-plan/oms-ignited") == 0) # we update the apoapsis and periapsis prediction
	{
	if (getprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-flag") == 0)
		{

		var r = [getprop("/fdm/jsbsim/position/eci-x-ft"), getprop("/fdm/jsbsim/position/eci-y-ft"), getprop("/fdm/jsbsim/position/eci-z-ft")];

		var v = [getprop("/fdm/jsbsim/velocities/eci-x-fps"), getprop("/fdm/jsbsim/velocities/eci-y-fps"), getprop("/fdm/jsbsim/velocities/eci-z-fps")];
	

		var dv = scalar_product(dvtot, [vtgt0, vtgt1, vtgt2]);

		v = add_vector(v, dv);

		var apses = SpaceShuttle.compute_apses(r,v);
		var sea_level_radius_ft = getprop("/fdm/jsbsim/ic/sea-level-radius-ft");

		var periapsis_nm = (apses[0] - sea_level_radius_ft)/ 6076.11548556;
		var apoapsis_nm = (apses[1] - sea_level_radius_ft)/ 6076.11548556;

		var ops = getprop("/fdm/jsbsim/systems/dps/ops");

		if (ops == 3)
			{
			var rei = SpaceShuttle.get_rei(r,v);
			# correct REI for empirics
		
			var rei_correction = 375.0 + 3.6556 * periapsis_nm;
			setprop("/fdm/jsbsim/systems/ap/oms-plan/rei-nm", rei + rei_correction);
			}

		
		setprop("/fdm/jsbsim/systems/ap/oms-plan/apoapsis-nm", apoapsis_nm);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/periapsis-nm", periapsis_nm);
		}
	else # we use the pre-computed apoapsis and periapsis
		{
		setprop("/fdm/jsbsim/systems/ap/oms-plan/apoapsis-nm", oms_burn_target.apoapsis);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/periapsis-nm", oms_burn_target.periapsis);

		var ops = getprop("/fdm/jsbsim/systems/dps/ops");

		if (ops == 3)
			{
			setprop("/fdm/jsbsim/systems/ap/oms-plan/rei-nm", oms_burn_target.rei);
			}
		}
	}

settimer(func {oms_burn_loop(tx, ty, tz, dvtot);}, 0.0);
}


var oms_burn_start = func (time) {


var MET = getprop("/sim/time/elapsed-sec") + getprop("/fdm/jsbsim/systems/timer/delta-MET");
var tig = oms_burn_target.tig; 

# some log output

var x = getprop("/fdm/jsbsim/position/eci-x-ft") * 0.3048;
var y = getprop("/fdm/jsbsim/position/eci-y-ft") * 0.3048;
var z = getprop("/fdm/jsbsim/position/eci-z-ft") * 0.3048;

#print (MET, " ", x, " ", y, " ", z);


if (tig - MET < 0.0) # if we're at or past ignition time, we go
	{
	var burn_mode = getprop("/fdm/jsbsim/systems/ap/oms-plan/burn-mode");

	if (burn_mode == 1)
		{
		# DAP to OMS TVC
		setprop("/fdm/jsbsim/systems/fcs/control-mode", 11);

		# throttles to full
		setprop("/controls/engines/engine[5]/throttle", 1.0);
		setprop("/controls/engines/engine[6]/throttle", 1.0);

		setprop("/fdm/jsbsim/systems/ap/oms-plan/oms-ignited", 1);

		}
	else if (burn_mode == 2)
		{
		# DAP to OMS TVC with wraparound
		setprop("/fdm/jsbsim/systems/fcs/control-mode", 12);

		# throttle left to full
		setprop("/controls/engines/engine[5]/throttle", 1.0);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/oms-ignited", 1);
		}
	else if (burn_mode == 3)
		{
		# DAP to OMS TVC with wraparound
		setprop("/fdm/jsbsim/systems/fcs/control-mode", 12);

		# throttle right to full
		setprop("/controls/engines/engine[6]/throttle", 1.0);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/oms-ignited", 1);
		}
	else if (burn_mode == 4)
		{
		setprop("/fdm/jsbsim/systems/ap/oms-plan/oms-ignited", 1);
		}

	setprop("/fdm/jsbsim/systems/navigation/acc-int-flag", 1);

	# start the burn


	oms_burn_target.mark = getprop("/sim/time/elapsed-sec");
	oms_burn_target.tgo = time;

	oms_burn_target.dvx_mark = getprop("/fdm/jsbsim/systems/navigation/dvx");
	oms_burn_target.dvy_mark = getprop("/fdm/jsbsim/systems/navigation/dvy");
	oms_burn_target.dvz_mark = getprop("/fdm/jsbsim/systems/navigation/dvz");
		
	oms_burn_target.ops = getprop("/fdm/jsbsim/systems/dps/ops");

	oms_burn(time);
		
	}
else # we delay
	{
	settimer(func{ oms_burn_start (time);}, 1.0);
	}

}

var oms_burn_stop = func  {

# back to DAP A
setprop("/fdm/jsbsim/systems/fcs/control-mode", 20);

# obsolete burn plan
setprop("/fdm/jsbsim/systems/ap/oms-plan/burn-plan-available", 0);

# obsolete burn attitude holding
setprop("/fdm/jsbsim/systems/ap/oms-mnvr-flag", 0);

# throttles to off
setprop("/controls/engines/engine[5]/throttle", 0.0);
setprop("/controls/engines/engine[6]/throttle", 0.0);

oms_burn_target.mar = 0.0;


# store last trim values

setprop("/fdm/jsbsim/systems/vectoring/OMS-trim-flag", 0);

var trim_pitch = getprop("/fdm/jsbsim/propulsion/engine[5]/pitch-angle-rad-cmd") * 57.295780 + 11.7;
var trim_yaw_left = getprop("/fdm/jsbsim/propulsion/engine[5]/yaw-angle-rad-cmd") * 57.295780 - 5.7;
var trim_yaw_right = getprop("/fdm/jsbsim/propulsion/engine[6]/yaw-angle-rad-cmd") * 57.295780 + 5.7;

setprop("/fdm/jsbsim/systems/ap/oms-plan/trim-pitch", trim_pitch);
setprop("/fdm/jsbsim/systems/ap/oms-plan/trim-yaw-left", trim_yaw_left);
setprop("/fdm/jsbsim/systems/ap/oms-plan/trim-yaw-right", trim_yaw_right);

# null burn targets

setprop("/fdm/jsbsim/systems/ap/oms-plan/dvx", 0);
setprop("/fdm/jsbsim/systems/ap/oms-plan/dvy", 0);
setprop("/fdm/jsbsim/systems/ap/oms-plan/dvz", 0);

setprop("/fdm/jsbsim/systems/ap/oms-plan/c1", 0);
setprop("/fdm/jsbsim/systems/ap/oms-plan/c2", 0);
setprop("/fdm/jsbsim/systems/ap/oms-plan/ht", 0);
setprop("/fdm/jsbsim/systems/ap/oms-plan/theta-t", 0);
setprop("/fdm/jsbsim/systems/ap/oms-plan/prplt", 0);

#setprop("/fdm/jsbsim/systems/ap/oms-plan/dvtot", 0);
setprop("/fdm/jsbsim/systems/ap/oms-plan/tgo-string", "0:00");
setprop("/fdm/jsbsim/systems/ap/oms-plan/tgo-s", 0);

setprop("/fdm/jsbsim/systems/ap/oms-plan/oms-ignited", 0);

setprop("/fdm/jsbsim/systems/pointing/inertial/attitude/tgt-roll-deg", 0.0);
setprop("/fdm/jsbsim/systems/pointing/inertial/attitude/tgt-pitch-deg", 0.0);
setprop("/fdm/jsbsim/systems/pointing/inertial/attitude/tgt-yaw-deg", 0.0);

#setprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-x", 0.0);
#setprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-y", 0.0);
#setprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-z", 0.0);

setprop("/fdm/jsbsim/systems/ap/oms-plan/exec-cmd", 0);


# remove N2 for purging

var nstarts_left = getprop("/fdm/jsbsim/systems/oms-hardware/n2-left-nstarts");
var nstarts_right = getprop("/fdm/jsbsim/systems/oms-hardware/n2-right-nstarts");

var burn_mode = getprop("/fdm/jsbsim/systems/ap/oms-plan/burn-mode");

if (burn_mode == 1)
	{
	nstarts_left = nstarts_left - 1;
	nstarts_right = nstarts_right -1;
	}
else if (burn_mode == 2)
	{
	nstarts_left = nstarts_left - 1;
	}
else if (burn_mode == 3)
	{
	nstarts_right = nstarts_right - 1;
	}


if (nstarts_left < 0) {nstarts_left = 0;}
if (nstarts_right < 0) {nstarts_right = 0;}

settimer( func {

setprop("/fdm/jsbsim/systems/oms-hardware/n2-left-nstarts", nstarts_left);
setprop("/fdm/jsbsim/systems/oms-hardware/n2-right-nstarts", nstarts_right);

}, 1.0);

tracking_loop_flag = 0;
}

var oms_burn = func (time) {

#if (time < 0.5) {oms_burn_stop(); return;}


# the 1 second timer is too inaccurate, thus we need a framerate-independent timer
var t_remaining = oms_burn_target.tgo - int(getprop("/sim/time/elapsed-sec") - oms_burn_target.mark);


setprop("/fdm/jsbsim/systems/ap/oms-plan/tgo-string", seconds_to_stringMS(t_remaining));
print("OMS burn for ", t_remaining, " seconds");

var weight_lb = getprop("/fdm/jsbsim/systems/ap/oms-plan/weight");
setprop("/fdm/jsbsim/systems/ap/oms-plan/weight", weight_lb - oms_burn_target.propellant_flow);


var dvx = getprop("/fdm/jsbsim/systems/navigation/dvx") - oms_burn_target.dvx_mark;
var dvy = getprop("/fdm/jsbsim/systems/navigation/dvy") - oms_burn_target.dvy_mark;
var dvz = getprop("/fdm/jsbsim/systems/navigation/dvz") - oms_burn_target.dvz_mark;


var dvtot = math.sqrt(dvx*dvx + dvy*dvy + dvz*dvz);

setprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-x", oms_burn_target.vgo_x - dvx);
setprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-y", oms_burn_target.vgo_y - dvy);
setprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-z", oms_burn_target.vgo_z - dvz);

setprop("/fdm/jsbsim/systems/ap/oms-plan/dvtot",  oms_burn_target.dvtot - dvtot);


#if (t_remaining < 0.5)  {oms_burn_stop(); oms_post_burn(); return;}

if (oms_burn_target.vgo_x - dvx < 0.6)  {oms_burn_stop(); oms_post_burn(); return;}

if (getprop("/fdm/jsbsim/systems/dps/ops") != oms_burn_target.ops)
	{
	oms_burn_stop(); return;
	}

if ((getprop("/fdm/jsbsim/systems/oms-hardware/engine-left-arm-cmd") == 0) and  (getprop("/fdm/jsbsim/systems/oms-hardware/engine-right-arm-cmd") == 0))
	{
	oms_burn_stop(); oms_post_burn(); return;
	}

settimer(func {oms_burn(time - 1);}, 0.5);
}


var oms_post_burn = func {

print ("Post Burn Loop!");

var dvx = getprop("/fdm/jsbsim/systems/navigation/dvx") - oms_burn_target.dvx_mark;
var dvy = getprop("/fdm/jsbsim/systems/navigation/dvy") - oms_burn_target.dvy_mark;
var dvz = getprop("/fdm/jsbsim/systems/navigation/dvz") - oms_burn_target.dvz_mark;

var dvtot = math.sqrt(dvx*dvx + dvy*dvy + dvz*dvz);

setprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-x", oms_burn_target.vgo_x - dvx);
setprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-y", oms_burn_target.vgo_y - dvy);
setprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-z", oms_burn_target.vgo_z - dvz);

setprop("/fdm/jsbsim/systems/ap/oms-plan/dvtot",  oms_burn_target.dvtot - dvtot);

if (getprop("/fdm/jsbsim/systems/navigation/acc-int-flag") == 1)
	{
	settimer ( func {oms_post_burn ();}, 0.5);
	}
}


var oms_burn_tgt_reset = func {

setprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-x", 0.0);
setprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-y", 0.0);
setprop("/fdm/jsbsim/systems/ap/oms-plan/vgo-z", 0.0);
setprop("/fdm/jsbsim/systems/ap/oms-plan/dvtot", 0.0);

}


######################################
# approximate AOA and ATO OMS targets
######################################


var compute_oms_abort_tgt = func (tgt_id) {


# tgt_id  1 is an immediate burn to raise apoapsis to 105 miles
# from there we can either circularize (3) or do a steep (4) or shallow (5) de-orbit burn

var apoapsis_miles = getprop("/fdm/jsbsim/systems/orbital/apoapsis-km")/1.853;
var periapsis_miles = getprop("/fdm/jsbsim/systems/orbital/periapsis-km")/1.853;
var current_alt_miles = getprop("/position/altitude-ft")  * 0.00016449001618;

var delta_v = 0.0;

if (tgt_id == 1)
	{

	if (apoapsis_miles > 105.0)
		{
		delta_v = 0.0;
		}
	else 	
		{

		var apoapsis_diff = math.abs(current_alt_miles - apoapsis_miles);
		var periapsis_diff = math.abs(current_alt_miles - periapsis_miles);

		var at_periapsis = 1;
		if (apoapsis_diff < periapsis_diff) {at_periapsis = 0;}

		print("At periapsis: ", at_periapsis);
		print ("Ap: ", apoapsis_miles, " P: ", periapsis_miles, "Cur: ", current_alt_miles);

		if (at_periapsis == 1) # need to raise apoapsis
			{
			var delta_alt = 105.0 - apoapsis_miles;
			delta_v = 1.5 * delta_alt;

			}
		else # need to raise periapsis
			{
			delta_alt = 105.0 - periapsis_miles;
			delta_v = 1.5 * delta_alt;
			}
		}

	}

else if (tgt_id == 3)
	{

        var tta = SpaceShuttle.time_to_apsis();

	print("TTA: ",tta[0], " ", tta[1]);

	if (tta[0] == 2) # we're going to apoapsis
		{

		# set TIG to 2 minutes prior to apsis
		var MET = getprop("/sim/time/elapsed-sec") + getprop("/fdm/jsbsim/systems/timer/delta-MET");
		setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-seconds", MET + tta[1]-120.0);
		SpaceShuttle.set_oms_mnvr_timer();

		var periapsis_tgt = 105.0;


		var delta_alt = periapsis_tgt - periapsis_miles;

		delta_v = 1.5 * delta_alt;
		}
	}
else if ((tgt_id == 4) or (tgt_id == 5)) # we need to do the de-orbit burn opposite to site
	{

	var lon = getprop("/position/longitude-deg");
	var tgt_lon = landing_site.lon() - 160.0;
	var delta_lon = tgt_lon - lon;
	if (lon < 0.0) {lon = lon + 360;}
	if (tgt_lon < 0.0) {tgt_lon = tgt_lon + 360.0;}

	print("Current lon: ", lon, " target lon: ", tgt_lon);
	print("Delta_lon_before: ", delta_lon);
	if (delta_lon < 0.0) {delta_lon = delta_lon + 360.0;} 
	if (delta_lon > 360.0) {delta_lon = delta_lon - 360.0;}

	print("Delta_lon: ", delta_lon);

	var orbital_period = getprop("/fdm/jsbsim/systems/orbital/orbital-period-s");
	var ttb = delta_lon/360.0 * orbital_period;

	# set TIG to 2 minutes prior to 180 degree point
	var MET = getprop("/sim/time/elapsed-sec") + getprop("/fdm/jsbsim/systems/timer/delta-MET");
	setprop("/fdm/jsbsim/systems/ap/oms-plan/tig-seconds", MET + ttb-120.0);
	SpaceShuttle.set_oms_mnvr_timer();

	if (tgt_id == 4) {periapsis_tgt = 25.0;}
	else if (tgt_id == 5) {periapsis_tgt = 50.0;}

	var delta_alt_corr = 0.0;
        var tta = SpaceShuttle.time_to_apsis();
	if (tta[0] == 2) # to apoapsis
		{
		if (ttb < tta[1]) # we burn before reaching apoapsis
			{
			var fraction = ttb/(0.5 * orbital_period);
			delta_alt_corr = (1.0 - fraction) * (apoapsis_miles - periapsis_miles);
			}
		else # we burn on the way to periapsis
			{
			var fraction = (ttb - tta[1])/(0.5 * orbital_period);
			delta_alt_corr = fraction * (apoapsis_miles - periapsis_miles);
			}
		}
	else
		{
		if (ttb < tta[1]) # we burn before reaching periapsis
			{
			var fraction = ttb/(0.5 * orbital_period);
			delta_alt_corr = fraction * (apoapsis_miles - periapsis_miles);
			}
		else # we burn on the way to apoapsis
			{
			var fraction = (ttb - tta[1])/(0.5 * orbital_period);
			delta_alt_corr = (1.0 - fraction) * (apoapsis_miles - periapsis_miles);
			}
		}
	print ("Fraction: ", fraction);
	print ("Delta alt correction: ", delta_alt_corr);

	var delta_alt = periapsis_tgt - periapsis_miles - delta_alt_corr;
	delta_v = 1.5 * delta_alt;

	}
	

setprop("/fdm/jsbsim/systems/ap/oms-plan/dvx",delta_v);
}
