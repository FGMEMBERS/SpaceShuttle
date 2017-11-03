# Shuttle carrier aircraft simulation for the Space Shuttle
# Thorsten Renk 2017


var carrier_aircraft =  {

	offset_fwd: [49.213, 0.0, -26.539],
	offset_left: [-11.811, -13.779,  -26.148],
	offset_right: [-11.811, 13.779,  -26.148],

	carrier_airspeed_target: 807.0,
	carrier_course_vector: [0.0, 0.0, 0.0],


	carrier_speed_north: 0.0,
	carrier_speed_east: 0.0,
	carrier_speed_up: 0.0,

	carrier_pitch_target: 8.59,
	carrier_roll_target: 0.0,

	carrier_pitch_rate: 1.0,
	carrier_roll_rate: 1.0,

	att_init_flag: 0,
	transient_dieout_flag: 0,

	carrier_message_flag: 0,

	update_timer: 0.5,

	connected: 0,


	init: func {


		setprop("/orientation/pitch-deg", 8.4);
		setprop("/orientation/roll-deg", 0.0);
		setprop("/velocities/uBody-fps", 800.0);
		setprop("/velocities/wBody-fps", 120.0);

		settimer( func {me.init_carrier(); }, 0.1);
	},

	init_carrier: func {

		var t = getprop("/fdm/jsbsim/simulation/sim-time-sec");

		var x = me.get_current_pos();
		var v = me.get_current_v();

		var up = SpaceShuttle.normalize(x);

		var delta_v = SpaceShuttle.scalar_product(-SpaceShuttle.dot_product(v, up), up);

		var o = me.get_current_offsets();
		var ov = [[0,0,0],[0,0,0],[0,0,0]];

		v = SpaceShuttle.add_vector(v, delta_v);


		#me.carrier_course_vector = SpaceShuttle.normalize(v);

		#me.set_mark(t, x, o, v, ov);

		if (me.connected == 0)
			{
			#settimer( func {me.update_connected();}, 2.5);
			setprop("/fdm/jsbsim/systems/carrier/connected", 1);
			me.connected = 1;
			me.update_connected();
			settimer( func {me.transient_dieout_flag = 1;}, 10);
			}



	},

	change_state: func (p, y, r,  prate, vspeed, speed) {

		if (me.transient_dieout_flag == 0) {vspeed = 0.0;}

		var t = getprop("/fdm/jsbsim/simulation/sim-time-sec");

		var x = me.get_current_pos();
		var v = me.get_current_v();

		var up = SpaceShuttle.normalize(x);

		var current_roll = getprop("/orientation/roll-deg");
		var acc = math.tan(current_roll * math.pi/180.0) * 9.81;
		var vnorm_in = SpaceShuttle.norm(v);
		var vnorm = vnorm_in * 0.3048;

		var R = math.pow(vnorm,2.0)/acc;
		var dyaw = (360.0 * me.update_timer * vnorm) / (2.0 * math.pi * R) ;		
		#print("dyaw: ", dyaw);

		var delta_v = SpaceShuttle.scalar_product(-SpaceShuttle.dot_product(v, up), up);
		delta_v = SpaceShuttle.add_vector(delta_v, SpaceShuttle.scalar_product(vspeed, up));
		v = SpaceShuttle.add_vector(v, delta_v);

		# to deal with any direction changes, we need to subtract
		# the rotational part of the inertial speed before applying delta v



		var lat = getprop("/position/latitude-deg") * math.pi/180.0;
		var lon = getprop("/position/longitude-deg") * math.pi/180.0;		
	
		var v_rot = [-1521.0 * math.sin(lon) * math.cos(lat), 1521.0 * math.cos(lon) * math.cos(lat), 0.0];
		v = SpaceShuttle.subtract_vector (v, v_rot);
		var fwd = SpaceShuttle.normalize(v);
		var right = SpaceShuttle.cross_product(up, fwd);
		delta_v = SpaceShuttle.scalar_product(-math.sin(dyaw * math.pi/180.0) * SpaceShuttle.norm(v), right);
		v = SpaceShuttle.add_vector(v, delta_v);

		
		
		#print("Reduced v: ", v[0], " ", v[1], " ", v[2]);


		v = SpaceShuttle.add_vector(v, v_rot);

		var beta = getprop("/fdm/jsbsim/aero/beta-deg");


		var o = me.get_rotated_offsets(p,y + dyaw + 0.5 * beta ,r);
		#var ov = [[0,0,0],[0,0,0],[0,0,0]];
		var ov = me.get_angular_v (prate);

		#me.carrier_course_vector = SpaceShuttle.normalize(v);

		me.set_mark(t, x, o, v, ov);



	},



	change_state_old: func (p, y, r,  prate, vspeed, speed) {



		vspeed = 0;

		#if (me.transient_dieout_flag = 0) {prate = 0; vspeed = 0.0;}

		
		var t = getprop("/fdm/jsbsim/simulation/sim-time-sec");

		var x = me.get_current_pos();
		var v = me.get_current_v();
		#var v = SpaceShuttle.scalar_product(speed,me.carrier_course_vector);

		var up = SpaceShuttle.normalize(x);
		var delta_v = SpaceShuttle.scalar_product(-SpaceShuttle.dot_product(v, up), up);



		#var o = me.get_rotated_offsets(p,y,r);
		var o = me.get_current_offsets();
		

		delta_v = SpaceShuttle.add_vector(delta_v, SpaceShuttle.scalar_product(vspeed, up));
	


		#var ov = me.get_angular_v (prate);
		var ov = [[0,0,0],[0,0,0],[0,0,0]];

		# make sure we do not lose airspeed
		v = SpaceShuttle.add_vector(v, delta_v);
		#v = SpaceShuttle.scalar_product(speed, SpaceShuttle.normalize(v));		


		me.set_mark(t, x, o, v, ov);


	},

	update_connected: func {


		if (me.connected == 0) {return;}

		var rc = getprop("/orientation/roll-deg");
		var pc = getprop("/orientation/pitch-deg");
		var yc = getprop("/orientation/heading-deg");

		var vspeed = me.carrier_airspeed_target * math.sin((pc - 8.6) * math.pi/180.0);

		var pitch_tgt = me.carrier_pitch_target - pc;
		pitch_tgt = SpaceShuttle.clamp(pitch_tgt, -0.2, 0.2);

		#var yaw_tgt = -getprop("/fdm/jsbsim/aero/beta-deg");
		#yaw_tgt = SpaceShuttle.clamp(yaw_tgt, -0.2, 0.2);
		var yaw_tgt = 0.0;

		var prate = 0.0;

		if  (math.abs(pitch_tgt) == 0.2)
			{
			me.att_init_flag = 1;
			prate = pitch_tgt/me.update_timer * math.pi/180.0;
			pitch_tgt = 0.0 * pitch_tgt;
			}
		else 
			{me.att_init_flag = 0;}
			



		me.change_state(pitch_tgt, 0.0, me.carrier_roll_target - rc, prate, vspeed, 807.0);
			
		#if (math.abs(prate) > 0.0) {print ("End prate test"); return;}	


		if ((me.carrier_message_flag == 0) and (me.carrier_pitch_target == -2.0))
			{
			#setprop("/sim/messages/copilot", "Initiating pitchdown.");
			SpaceShuttle.callout.make("Initiating pitchdown.", "real");
			me.carrier_message_flag = 1;	
			}
		else if ((me.carrier_message_flag == 1) and (math.abs(me.carrier_pitch_target - pc) < 0.05))
			{
			#setprop("/sim/messages/copilot", "Atlantis, you are ready to separate.");
			SpaceShuttle.callout.make("Atlantis, you are ready to separate.", "real");
			me.carrier_message_flag = 2;	
			}

		settimer(func {me.update_connected();}, me.update_timer);
	},


	change_bank_tgt: func (arg) {

		

		me.carrier_roll_target = me.carrier_roll_target + arg;
		if (me.carrier_roll_target > 15.0) {me.carrier_roll_target = 15.0;}
		else if (me.carrier_roll_target < -15.0) {me.carrier_roll_target = -15.0;}

	},		


	disconnect: func {

		if (me.connected == 0) {return;}

		setprop("/fdm/jsbsim/systems/carrier/connected", 0);
		me.connected = 0;


		#setprop("/sim/messages/copilot", "Separation!");
		SpaceShuttle.callout.make("Separation!", "real");
		me.carrier_message_flag = 3;

		me.init_free();
	},


	init_free: func {


		me.sca_coord = geo.aircraft_position();	

		var heading = getprop("/orientation/heading-deg");
		var pitch = getprop("/orientation/pitch-deg");
		var roll = getprop("/orientation/roll-deg");

		SpaceShuttle.place_model("SCA", "Aircraft/SpaceShuttle/Models/SCA/747-123-SCAfree.xml", me.sca_coord.lat(), me.sca_coord.lon(), me.sca_coord.alt(), heading, pitch, roll);

		me.carrier_speed_north = getprop("/fdm/jsbsim/velocities/v-north-fps") * 0.3048;
		me.carrier_speed_east = getprop("/fdm/jsbsim/velocities/v-east-fps") * 0.3048;
		me.carrier_speed_up = -getprop("/fdm/jsbsim/velocities/v-down-fps") * 0.3048;

		me.lat_to_m = 110952.0;
		me.lon_to_m  = math.cos(me.sca_coord.lat()*math.pi/180.0) * lat_to_m;

		me.m_to_lat = 1.0/me.lat_to_m;
		me.m_to_lon = 1.0/me.lon_to_m;	

		settimer( func {me.update_free();}, 0.0);

	},


	update_free: func {

		var dt = getprop("/sim/time/delta-sec");

		var lon = me.sca_coord.lon() + me.carrier_speed_east * me.m_to_lon * dt;
		var lat = me.sca_coord.lat() + me.carrier_speed_north * me.m_to_lat * dt;
		var alt = me.sca_coord.alt() + me.carrier_speed_up * dt;
		
		if (me.carrier_message_flag < 4)
			{
			var shuttle_alt = getprop("/position/altitude-ft") * 0.3048;
			if (shuttle_alt - alt > 10.0)
				{
				SpaceShuttle.callout.make("Vertical clear!", "real");
				me.carrier_message_flag = 4;
				}
			}


		me.sca_coord.set_latlon(lat, lon, alt);
		
		setprop("/controls/shuttle/SCA/latitude-deg", me.sca_coord.lat() );
		setprop("/controls/shuttle/SCA/longitude-deg", me.sca_coord.lon() );
		setprop("/controls/shuttle/SCA/elevation-ft", me.sca_coord.alt() * m_to_ft);

		settimer( func {me.update_free ();}, 0.0);

	},

	get_current_offsets: func {

		var body_x = [getprop("/fdm/jsbsim/systems/pointing/inertial/body-x[0]"), getprop("/fdm/jsbsim/systems/pointing/inertial/body-x[1]"), getprop("/fdm/jsbsim/systems/pointing/inertial/body-x[2]")];

		var body_y = [getprop("/fdm/jsbsim/systems/pointing/inertial/body-y[0]"), getprop("/fdm/jsbsim/systems/pointing/inertial/body-y[1]"), getprop("/fdm/jsbsim/systems/pointing/inertial/body-y[2]")];

		var body_z = [getprop("/fdm/jsbsim/systems/pointing/inertial/body-z[0]"), getprop("/fdm/jsbsim/systems/pointing/inertial/body-z[1]"), getprop("/fdm/jsbsim/systems/pointing/inertial/body-z[2]")];



		var fox =  49.213 * body_x[0] -26.539  * body_z[0];
		var foy =  49.213 * body_x[1] -26.539  * body_z[1];
		var foz =  49.213 * body_x[2] -26.539  * body_z[2];

		var lox =  -11.811 * body_x[0] -13.779 * body_y[0] -26.148  * body_z[0];
		var loy =  -11.811 * body_x[1] -13.779 * body_y[1] -26.148  * body_z[1];
		var loz =  -11.811 * body_x[2] -13.779 * body_y[2] -26.148  * body_z[2];

		var rox =  -11.811 * body_x[0] +13.779 * body_y[0] -26.148  * body_z[0];
		var roy =  -11.811 * body_x[1] +13.779 * body_y[1] -26.148  * body_z[1];
		var roz =  -11.811 * body_x[2] +13.779 * body_y[2] -26.148  * body_z[2];

		return [[fox, foy, foz], [lox, loy, loz], [rox, roy, roz]];
		
	},

	get_rotated_offsets: func (p,y,r) {

		var body_x = [getprop("/fdm/jsbsim/systems/pointing/inertial/body-x[0]"), getprop("/fdm/jsbsim/systems/pointing/inertial/body-x[1]"), getprop("/fdm/jsbsim/systems/pointing/inertial/body-x[2]")];

		var body_y = [getprop("/fdm/jsbsim/systems/pointing/inertial/body-y[0]"), getprop("/fdm/jsbsim/systems/pointing/inertial/body-y[1]"), getprop("/fdm/jsbsim/systems/pointing/inertial/body-y[2]")];

		var body_z = [getprop("/fdm/jsbsim/systems/pointing/inertial/body-z[0]"), getprop("/fdm/jsbsim/systems/pointing/inertial/body-z[1]"), getprop("/fdm/jsbsim/systems/pointing/inertial/body-z[2]")];


		var roffset_fwd = orientTaitBryan(me.offset_fwd, y, p, r);
		var roffset_left = orientTaitBryan(me.offset_left, y, p, r);
		var roffset_right = orientTaitBryan(me.offset_right, y, p, r);

		var fox =  roffset_fwd[0] * body_x[0] + roffset_fwd[2]  * body_z[0];
		var foy =  roffset_fwd[0] * body_x[1] + roffset_fwd[2]  * body_z[1];
		var foz =  roffset_fwd[0] * body_x[2] + roffset_fwd[2]  * body_z[2];

		var lox =  roffset_left[0] * body_x[0] + roffset_left[1] * body_y[0] + roffset_left[2]  * body_z[0];
		var loy =  roffset_left[0] * body_x[1] + roffset_left[1] * body_y[1] + roffset_left[2]  * body_z[1];
		var loz =  roffset_left[0] * body_x[2] + roffset_left[1] * body_y[2] + roffset_left[2]  * body_z[2];

		var rox =  roffset_right[0] * body_x[0] + roffset_right[1] * body_y[0] + roffset_right[2]  * body_z[0];
		var roy =  roffset_right[0] * body_x[1] + roffset_right[1] * body_y[1] + roffset_right[2]  * body_z[1];
		var roz =  roffset_right[0] * body_x[2] + roffset_right[1] * body_y[2] + roffset_right[2]  * body_z[2];

		return [[fox, foy, foz], [lox, loy, loz], [rox, roy, roz]];
		
	},

	get_angular_v: func (prate) {

		# currently pitch rotations only

		var body_z = [getprop("/fdm/jsbsim/systems/pointing/inertial/body-z[0]"), getprop("/fdm/jsbsim/systems/pointing/inertial/body-z[1]"), getprop("/fdm/jsbsim/systems/pointing/inertial/body-z[2]")];

		var fovx = prate * me.offset_fwd[0] * body_z[0];
		var fovy = prate * me.offset_fwd[0] * body_z[1];
		var fovz = prate * me.offset_fwd[0] * body_z[2];

		var lovx = prate * me.offset_left[0] * body_z[0];
		var lovy = prate * me.offset_left[0] * body_z[1];
		var lovz = prate * me.offset_left[0] * body_z[2];

		var rovx = prate * me.offset_right[0] * body_z[0];
		var rovy = prate * me.offset_right[0] * body_z[1];
		var rovz = prate * me.offset_right[0] * body_z[2];

		return [[fovx, fovy, fovz], [lovx, lovy, lovz], [rovx, rovy, rovz]];
	
	},


	get_current_pos : func {

		var x = getprop("/fdm/jsbsim/position/eci-x-ft");
		var y = getprop("/fdm/jsbsim/position/eci-y-ft");
		var z = getprop("/fdm/jsbsim/position/eci-z-ft");

		return [x,y,z];

	},



	get_current_v: func {

		var vx = getprop("/fdm/jsbsim/velocities/eci-x-fps");
		var vy = getprop("/fdm/jsbsim/velocities/eci-y-fps");
		var vz = getprop("/fdm/jsbsim/velocities/eci-z-fps");

		return [vx, vy, vz];
	
	},	

	set_mark: func (t, x, o, v, ov) {

		setprop("/fdm/jsbsim/systems/carrier/mark-t", t);

		#var dxf = getprop("/fdm/jsbsim/systems/carrier/delta-x-fwd-ft");
		#var dyf = getprop("/fdm/jsbsim/systems/carrier/delta-y-fwd-ft");
		#var dzf = getprop("/fdm/jsbsim/systems/carrier/delta-z-fwd-ft");

		#var dxl = getprop("/fdm/jsbsim/systems/carrier/delta-x-left-ft");
		#var dyl = getprop("/fdm/jsbsim/systems/carrier/delta-y-left-ft");
		#var dzl = getprop("/fdm/jsbsim/systems/carrier/delta-z-left-ft");

		#var dxr = getprop("/fdm/jsbsim/systems/carrier/delta-x-right-ft");
		#var dyr = getprop("/fdm/jsbsim/systems/carrier/delta-y-right-ft");
		#var dzr = getprop("/fdm/jsbsim/systems/carrier/delta-z-right-ft");

		var dxf = 0.0;
		var dyf = 0.0;
		var dzf = 0.0;

		var dxl = 0.0;
		var dyl = 0.0;
		var dzl = 0.0;

		var dxr = 0.0;
		var dyr = 0.0;
		var dzr = 0.0;

		setprop("/fdm/jsbsim/systems/carrier/mark-x-fwd", x[0] + o[0][0] + dxf);
		setprop("/fdm/jsbsim/systems/carrier/mark-y-fwd", x[1] + o[0][1] + dyf);
		setprop("/fdm/jsbsim/systems/carrier/mark-z-fwd", x[2] + o[0][2] + dzf);

		setprop("/fdm/jsbsim/systems/carrier/mark-x-left", x[0] + o[1][0] + dxl);
		setprop("/fdm/jsbsim/systems/carrier/mark-y-left", x[1] + o[1][1] + dyl);
		setprop("/fdm/jsbsim/systems/carrier/mark-z-left", x[2] + o[1][2] + dzl);

		setprop("/fdm/jsbsim/systems/carrier/mark-x-right", x[0] + o[2][0] + dxr);
		setprop("/fdm/jsbsim/systems/carrier/mark-y-right", x[1] + o[2][1] + dyr);
		setprop("/fdm/jsbsim/systems/carrier/mark-z-right", x[2] + o[2][2] + dzr);

		setprop("/fdm/jsbsim/systems/carrier/mark-vx-fwd", v[0] + ov[0][0]);
		setprop("/fdm/jsbsim/systems/carrier/mark-vy-fwd", v[1] + ov[0][1]);
		setprop("/fdm/jsbsim/systems/carrier/mark-vz-fwd", v[2] + ov[0][2]);

		setprop("/fdm/jsbsim/systems/carrier/mark-vx-left", v[0] + ov[1][0]);
		setprop("/fdm/jsbsim/systems/carrier/mark-vy-left", v[1] + ov[1][1]);
		setprop("/fdm/jsbsim/systems/carrier/mark-vz-left", v[2] + ov[1][2]);

		setprop("/fdm/jsbsim/systems/carrier/mark-vx-right", v[0] + ov[2][0]);
		setprop("/fdm/jsbsim/systems/carrier/mark-vy-right", v[1] + ov[2][1]);
		setprop("/fdm/jsbsim/systems/carrier/mark-vz-right", v[2] + ov[2][2]);


	},

	set_vmark: func (v, ov) {


		setprop("/fdm/jsbsim/systems/carrier/mark-vx-fwd", v[0] + ov[0][0]);
		setprop("/fdm/jsbsim/systems/carrier/mark-vy-fwd", v[1] + ov[0][1]);
		setprop("/fdm/jsbsim/systems/carrier/mark-vz-fwd", v[2] + ov[0][2]);

		setprop("/fdm/jsbsim/systems/carrier/mark-vx-left", v[0] + ov[1][0]);
		setprop("/fdm/jsbsim/systems/carrier/mark-vy-left", v[1] + ov[1][1]);
		setprop("/fdm/jsbsim/systems/carrier/mark-vz-left", v[2] + ov[1][2]);

		setprop("/fdm/jsbsim/systems/carrier/mark-vx-right", v[0] + ov[2][0]);
		setprop("/fdm/jsbsim/systems/carrier/mark-vy-right", v[1] + ov[2][1]);
		setprop("/fdm/jsbsim/systems/carrier/mark-vz-right", v[2] + ov[2][2]);


	},

	dump_o: func (o) {

		setprop("/diagnostics/fox", o[0][0]);
		setprop("/diagnostics/foy", o[0][1]);
		setprop("/diagnostics/foz", o[0][2]);

		setprop("/diagnostics/lox", o[1][0]);
		setprop("/diagnostics/loy", o[1][1]);
		setprop("/diagnostics/loz", o[1][2]);

		setprop("/diagnostics/rox", o[2][0]);
		setprop("/diagnostics/roy", o[2][1]);
		setprop("/diagnostics/roz", o[2][2]);
		
	},

};
