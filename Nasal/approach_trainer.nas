# approach evaluation and training simulation for the Space Shuttle
# Thorsten Renk 2017


var approach = {

	trainer_active: 0,


	reset : func {

		# repair damage, for some reason this needs a delay ???
		
		settimer ( func {
		setprop("/fdm/jsbsim/systems/failures/gear/tire-nose-left-condition", 1.0);
		setprop("/fdm/jsbsim/systems/failures/gear/tire-nose-right-condition", 1.0);
		setprop("/fdm/jsbsim/systems/failures/gear/tire-left-ib-condition", 1.0);
		setprop("/fdm/jsbsim/systems/failures/gear/tire-left-ob-condition", 1.0);
		setprop("/fdm/jsbsim/systems/failures/gear/tire-right-ib-condition", 1.0);
		setprop("/fdm/jsbsim/systems/failures/gear/tire-right-ob-condition", 1.0);
		setprop("/fdm/jsbsim/systems/failures/gear/gearstrut-nose-condition", 1.0);
		setprop("/fdm/jsbsim/systems/failures/gear/gearstrut-left-condition", 1.0);
		setprop("/fdm/jsbsim/systems/failures/gear/gearstrut-right-condition", 1.0);
		}, 0.5);

		# repack chute

		setprop("/controls/shuttle/drag-chute-arm", 0);
		setprop("/controls/shuttle/drag-chute-jettison", 0);
            	setprop("/controls/shuttle/parachute",0);
            	setprop("/controls/shuttle/drag-chute-deploy", 0);
		setprop("/controls/shuttle/drag-chute-deploy-timer", 0);
		setprop("/controls/shuttle/drag-chute-fold", 0);
		setprop("/controls/shuttle/drag-chute-bend", 0);
		setprop("/controls/shuttle/drag-chute-slant", 0);
		setprop("/controls/shuttle/drag-chute-dist", 0);
		setprop("/controls/shuttle/drag-chute-down", 0);
		setprop("/controls/shuttle/drag-chute-string", "in");

		SpaceShuttle.chuteDeployTime = 0;

		# retract gear

		setprop("/controls/gear/gear-down",0);
		setprop("/fdm/jsbsim/contact/unit[3]/z-position",0.0);
		setprop("/fdm/jsbsim/contact/unit[4]/z-position",0.0);
		setprop("/fdm/jsbsim/contact/unit[5]/z-position",0.0);
		setprop("/fdm/jsbsim/systems/landing/landing-gear-arm-cmd", 0);
	
		# center controls

		controls.centerFlightControls();

		# re-init position

		var lat_init = getprop("/sim/presets/latitude-deg");
		var lon_init = getprop("/sim/presets/longitude-deg");
		var heading_init = getprop("/sim/presets/heading-deg");

		var lat_to_m = 110952.0; 
		var lon_to_m  = math.cos(getprop("/position/latitude-deg")*math.pi/180.0) * lat_to_m;
		var m_to_lon = 1.0/lon_to_m;
		var m_to_lat = 1.0/lat_to_m;

		var place_dir = heading_init + 180.0;
		if (place_dir > 360.0) {place_dir = place_dir-360.0;}
		place_dir = place_dir * math.pi/180.0;

		var place_dist = 17000.0; # 11 miles downrange

		var place_x = place_dist * math.sin(place_dir);
		var place_y = place_dist * math.cos(place_dir);

		var place_lat = lat_init + m_to_lat * place_y;
		var place_lon = lon_init + m_to_lon * place_x;
		var place_alt_correct = getprop("/position/altitude-ft");

		setprop("/position/latitude-deg", place_lat); 
		setprop("/position/longitude-deg", place_lon); 
		setprop("/position/altitude-ft", 12000 + place_alt_correct);
	
		setprop("/orientation/pitch-deg", 0.0);
		setprop("/orientation/roll-deg", 0.0);
		setprop("orientation/heading-deg", heading_init);

		# need some time for the PID controllers to adjust to equilibrium flight
		settimer ( func {

		setprop("/orientation/pitch-deg", 0.0);
		setprop("/orientation/roll-deg", 0.0);
		setprop("orientation/heading-deg", heading_init);

		}, 0.5);

		setprop("/velocities/uBody-fps",600.0);
		setprop("/velocities/wBody-fps", 60.0);



		# reset HUD to declutter 0

		setprop("/fdm/jsbsim/systems/hud/declutter-level", 0);


		# re-start the control loop

		#SpaceShuttle.glide_loop();
	

		# reset guidance

		SpaceShuttle.TAEM_guidance_phase = 3;
		settimer(func {SpaceShuttle.approach_guidance_loop();}, 1.0);

		# reset callout management

		SpaceShuttle.gear_arm_message_flag = 0;
		SpaceShuttle.slowdown_loop_flag = 0;

		# reset state vector errors

		setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/vx-m_s", 0.0);
		setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/vy-m_s", 0.0);
		setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/vz-m_s", 0.0);

		setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/x-m", 0.0);
		setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/y-m", 0.0);
		setprop("/fdm/jsbsim/systems/navigation/state-vector/error-prop/z-m", 0.0);

	},

	mark_touchdown: func {

		me.touchdown_pos = geo.aircraft_position();
		me.touchdown_airspeed = getprop("/fdm/jsbsim/velocities/ve-kts");	
		me.touchdown_vspeed = getprop("/fdm/jsbsim/velocities/v-down-fps");

		setprop("/sim/approach-trainer/touchdown-vspeed", me.touchdown_vspeed);
		setprop("/sim/approach-trainer/touchdown-hspeed", me.touchdown_airspeed);
	},

	mark_stop: func {

		me.stop_pos = geo.aircraft_position();

		me.rollout_distance = me.stop_pos.distance_to(me.touchdown_pos);
		setprop("/sim/approach-trainer/rollout-distance", me.rollout_distance/ 0.3048);


	},
	


};
