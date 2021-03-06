# support for i-loaded mission parameters for the Space Shuttle
# Thorsten Renk 2016

var predefined_failures = [];
var oTgt = {};
var n_orbital_targets = 0;

var failure_pre = {new: func (node, time, probability, value) {
 	var f = { parents: [failure_pre] };
	f.node = node;
	f.time = time;
	f.probability = probability;
	f.value = value;
	f.flag = 0;
	return f;
	},

	test: func (met) {

	if (me.flag == 1) {return;}
	if (met > me.time)
		{
		me.flag = 1;
		if (rand() < me.probability)
			{
			me.execute();

			}
		}
	},

	execute: func {

	setprop(me.node, me.value);

	},
		
};


var mission_init = func {


# load the mission file

var filename = getprop("/mission/filename");

var target = props.globals.getNode("/mission");
var success = io.read_properties("Aircraft/SpaceShuttle/Mission/"~filename, target);

if (success == nil) 
	{
	print("Cannot open mission file ", filename, ", using defaults.");
	io.read_properties("Aircraft/SpaceShuttle/Mission/mission.xml", target);
	}

# launch targets

var stage = getprop("/sim/presets/stage");

if (getprop("/mission/launch/section-defined") and (stage == 0))
	{
	var tgt_inclination = getprop("/mission/launch/target-inclination");
	var tgt_apoapsis = getprop("/mission/launch/target-apoapsis-miles");
	var lat = getprop("/position/latitude-deg");

	# set the menu items - the listener calls the computation of launch azimuth

	if (getprop("/mission/launch/select-north"))
		{
		setprop("/sim/gui/dialogs/SpaceShuttle/auto_launch/select-north", 1);
		setprop("/sim/gui/dialogs/SpaceShuttle/auto_launch/select-south", 0);
		}
	else
		{
		setprop("/sim/gui/dialogs/SpaceShuttle/auto_launch/select-north", 0);
		setprop("/sim/gui/dialogs/SpaceShuttle/auto_launch/select-south", 1);
		}

	var raw = (tgt_inclination - lat)/(90.0 - lat);

	setprop("/sim/gui/dialogs/SpaceShuttle/auto_launch/inclination", raw);
	setprop("/sim/gui/dialogs/SpaceShuttle/auto_launch/apoapsis-target-miles", tgt_apoapsis);

	# auto-launch guidance and autopilot on

	setprop("/fdm/jsbsim/systems/ap/launch/autolaunch-master", 1);

	setprop("/fdm/jsbsim/systems/ap/css-pitch-control", 0);
	setprop("/fdm/jsbsim/systems/ap/automatic-pitch-control", 1);

	setprop("/fdm/jsbsim/systems/ap/css-roll-control", 0);
	setprop("/fdm/jsbsim/systems/ap/automatic-roll-control", 1);

	# i-load TAL site

	var tal_site_index = getprop("/mission/launch/tal-site-index");
	setprop("/fdm/jsbsim/systems/entry_guidance/tal-site-iloaded", tal_site_index);

	# i-load RTLS site

	var rtls_site_index = getprop("/mission/launch/rtls-site-index");
	SpaceShuttle.update_site_by_index(rtls_site_index);

	}

# aborts

if (getprop("/mission/abort/section-defined") and (stage == 0))
	{
	var yaw_steering = getprop("/mission/abort/enable-yaw-steering");
	setprop("/fdm/jsbsim/systems/abort/enable-yaw-steer", yaw_steering);

	var yaw_steer_tgt = getprop("/mission/abort/yaw-steering-target");
	setprop("/fdm/jsbsim/systems/abort/yaw-steer-target", yaw_steer_tgt);

	var ato_vcont = getprop("/mission/abort/ato-v-mssn-cntn");
	setprop("/fdm/jsbsim/systems/abort/ato-v-mssn-cntn", ato_vcont);

	var ato_vlin = getprop("/mission/abort/ato-v-lin");
	setprop("/fdm/jsbsim/systems/abort/ato-v-lin", ato_vlin);

	var ato_vzero = getprop("/mission/abort/ato-v-zero");
	setprop("/fdm/jsbsim/systems/abort/ato-v-zero", ato_vzero);
	}

# configuration

if (getprop("/mission/configuration/section-defined"))
	{
	var et_config = getprop("/mission/configuration/external-tank");
	setprop("/sim/config/shuttle/ET-config", et_config);

	if (getprop("/mission/configuration/payload-explicit"))
		{
		var payload = getprop("/mission/configuration/payload");
		setprop("/sim/config/shuttle/PL-selection", payload);
		SpaceShuttle.update_payload_selection();
		}
	else
		{
		var payload_weight = getprop("/mission/configuration/payload-weight-lbs");
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[5]", payload_weight);
		}

	}

# DAP

if (getprop("/mission/dap/section-defined"))
	{
	var par = getprop("/mission/dap/dap-A-PRI-rot-rate");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-rot-rate", par);
	
	par = getprop("/mission/dap/dap-B-PRI-rot-rate");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-rot-rate", par);

	par = getprop("/mission/dap/dap-A-VRN-rot-rate");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-VRN-rot-rate", par);

	par = getprop("/mission/dap/dap-B-VRN-rot-rate");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-VRN-rot-rate", par);

	par = getprop("/mission/dap/dap-A-PRI-att-db");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-att-db", par);

	par = getprop("/mission/dap/dap-B-PRI-att-db");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-att-db", par);

	par = getprop("/mission/dap/dap-A-VRN-att-db");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-VRN-att-db", par);

	par = getprop("/mission/dap/dap-B-VRN-att-db");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-VRN-att-db", par);

	par = getprop("/mission/dap/dap-A-PRI-rate-db");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-rate-db", par);

	par = getprop("/mission/dap/dap-B-PRI-rate-db");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-rate-db", par);

	par = getprop("/mission/dap/dap-A-VRN-rate-db");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-VRN-rate-db", par);

	par = getprop("/mission/dap/dap-B-VRN-rate-db");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-VRN-rate-db", par);

	par = getprop("/mission/dap/dap-A-ALT-rate-db");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-ALT-rate-db", par);

	par = getprop("/mission/dap/dap-B-ALT-rate-db");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-ALT-rate-db", par);

	par = getprop("/mission/dap/dap-A-PRI-rot-pls");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-rot-pls", par);

	par = getprop("/mission/dap/dap-B-PRI-rot-pls");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-rot-pls", par);

	par = getprop("/mission/dap/dap-A-VRN-rot-pls");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-VRN-rot-pls", par);

	par = getprop("/mission/dap/dap-B-VRN-rot-pl");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-VRN-rot-pl", par);

	par = getprop("/mission/dap/dap-A-PRI-comp");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-comp", par);

	par = getprop("/mission/dap/dap-B-PRI-comp");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-comp", par);

	par = getprop("/mission/dap/dap-A-VRN-comp");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-VRN-comp", par);

	par = getprop("/mission/dap/dap-B-VRN-comp");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-VRN-comp", par);

	par = getprop("/mission/dap/dap-A-PRI-p-opt");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-p-opt", par);

	par = getprop("/mission/dap/dap-B-PRI-p-opt");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-p-opt", par);

	par = getprop("/mission/dap/dap-A-PRI-y-opt");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-y-opt", par);

	par = getprop("/mission/dap/dap-B-PRI-y-opt");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-y-opt", par);

	par = getprop("/mission/dap/dap-A-PRI-tran-pls");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-PRI-tran-pls", par);

	par = getprop("/mission/dap/dap-B-PRI-tran-pls");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-PRI-tran-pls", par);

	par = getprop("/mission/dap/dap-A-ALT-n-jets");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-A-ALT-n-jets", par);

	par = getprop("/mission/dap/dap-B-ALT-n-jets");
	setprop("/fdm/jsbsim/systems/ap/spec20/dap-B-ALT-n-jets", par);

	}

# predefined failures

if (getprop("/mission/failures/section-defined"))
	{

	var modes = props.globals.getNode("/mission/failures", 1).getChildren("mode");

	foreach (m; modes)
		{
		var nstring = m.getValue("node");
		var time = m.getValue("occurs-met-s");
		var probability = m.getValue("probability");
		var value = m.getValue("value");

		#print ("Failure: ", nstring);
		#print ("Time: ", time, " probability: ", probability, " value: ", value);


		var fpre = failure_pre.new(nstring, time, probability, value);
		append(predefined_failures, fpre);

		}

	}

# orbiting objects

if (getprop("/mission/orbital-targets/section-defined"))
	{

	var tgt_label = getprop("/mission/orbital-targets/object-label");
	var tgt_alt = getprop("/mission/orbital-targets/alt-km") * 1000.0;
	var tgt_inc = getprop("/mission/orbital-targets/inclination-deg");
	var tgt_node_lon = getprop("/mission/orbital-targets/node-lon-deg");
	var tgt_anomaly = getprop("/mission/orbital-targets/anomaly-deg");

	oTgt = orbital_target.orbitalTarget.new(tgt_alt, tgt_inc, tgt_node_lon, tgt_anomaly);
	oTgt.label = tgt_label;	
	oTgt.start();
	print("Adding ", tgt_label);

	SpaceShuttle.tgt_history_init();
	n_orbital_targets = 1;
	setprop("/fdm/jsbsim/systems/navigation/orbital-tgt/tgt-id", 1);

	}

}


var mission_post_meco = func {

if (getprop("/mission/post-meco/section-defined"))
	{
	if (getprop("/mission/post-meco/automatic-fuel-dump"))
		{
		setprop("/fdm/jsbsim/systems/mps/LO2-manifold-valve-status", 1);
		setprop("/fdm/jsbsim/systems/propellant/LH2-inboard-status", 1);
		setprop("/fdm/jsbsim/systems/propellant/LH2-outboard-status", 1);
		
		settimer( func {SpaceShuttle.fuel_dump_start();}, 20.0);

		settimer( func {setprop("/fdm/jsbsim/systems/mps/LO2-manifold-valve-status", 0);}, 130.0);
		}

	if (getprop("/mission/post-meco/auto-oms1-burn"))
		{


		var dvx = getprop("/mission/post-meco/oms1-dvx");
		var dvy = getprop("/mission/post-meco/oms1-dvy");
		var dvz = getprop("/mission/post-meco/oms1-dvz");

		setprop("/fdm/jsbsim/systems/ap/oms-plan/dvx", dvx);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/dvy", dvy);
		setprop("/fdm/jsbsim/systems/ap/oms-plan/dvz", dvz);

		var orbiter_weight = getprop("/mission/post-meco/orbiter-weight");
		setprop("/fdm/jsbsim/systems/ap/oms-plan/weight", orbiter_weight);
		#setprop("/fdm/jsbsim/systems/ap/oms-plan/weight", getprop("/fdm/jsbsim/inertia/weight-lbs"));


		# burn plan needs to be computed a frame later to pick up the properties
		settimer( func {
			SpaceShuttle.create_oms_burn_vector();
			setprop("/fdm/jsbsim/systems/ap/oms-mnvr-flag", 0);
			setprop("/fdm/jsbsim/systems/ap/oms-plan/burn-plan-available", 1);
			setprop("/fdm/jsbsim/systems/ap/oms-plan/state-extrapolated-flag", 0);
			SpaceShuttle.tracking_loop_flag = 0; }, 0.2);


		# wait for fuel dump to finish before we start the OMS maneuver
		settimer(func {
			SpaceShuttle.orbital_dap_manager.control_select("AUTO");
			setprop("/fdm/jsbsim/systems/ap/track/body-vector-selection", 1);
			var flag = getprop("/fdm/jsbsim/systems/ap/oms-mnvr-flag");
			if (flag == 0) {flag = 1;} else {flag =0;}
			setprop("/fdm/jsbsim/systems/ap/oms-mnvr-flag", flag); } , 140.0);

		}

	}

	# i-load landing site, we have to do it post-MECO to not interfere with RTLS

if (getprop("/mission/entry/section-defined"))
	{ 
	var landing_site_index = getprop("/mission/entry/landing-site-index");
	SpaceShuttle.update_site_by_index(landing_site_index);
	}

}


var mission_predefined_failures = func {

var elapsed = getprop("/sim/time/elapsed-sec");
var MET = elapsed + getprop("/fdm/jsbsim/systems/timer/delta-MET");

#print ("MET: ", MET);

foreach (var fail;  predefined_failures)
	{
	fail.test(MET);
	}


}

setlistener("/sim/signals/fdm-initialized", func { mission_init(); },0,0);
