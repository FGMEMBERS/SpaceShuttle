# fire simulation for the Space Shuttle
# Thorsten Renk 2018

var fire_sim = {

	avbay1_on_fire: 0,
	avbay2_on_fire: 0,
	avbay3_on_fire: 0,

	avbay1_fire_intensity: 0.0,
	avbay2_fire_intensity: 0.0,
	avbay3_fire_intensity: 0.0,

	avbay1_damage_probability: 0.8,
	avbay2_damage_probability: 0.8,
	avbay3_damage_probability: 0.8,

	avbay1_halon_available: 1,
	avbay2_halon_available: 1,
	avbay3_halon_available: 1,

	avbay1_halon: 0,
	avbay2_halon: 0,
	avbay3_halon: 0,

	smoke_avbay1: 0.0,
	smoke_avbay2: 0.0,
	smoke_avbay3: 0.0,
	smoke_cabin: 0.0,
	smoke_flightdeck: 0.0,

	smoke_detection: 0,

	verbose_flag: 1,

	fire_evolving: 0,

	# currently we only do fires in avionics bays


	start_fire: func (location) {

		if (location == "avbay1")
			{
			if (me.avbay1_on_fire == 1) {return;}

			me.avbay1_on_fire = 1;
			me.avbay1_fire_intensity = 0.1;
			}
		else if (location == "avbay2")
			{
			if (me.avbay2_on_fire == 1) {return;}

			me.avbay2_on_fire = 1;
			me.avbay2_fire_intensity = 0.1;
			}
		else if (location == "avbay3")
			{
			if (me.avbay3_on_fire == 1) {return;}

			me.avbay3_on_fire = 1;
			me.avbay3_fire_intensity = 0.1;
			}

		if (me.fire_evolving == 0)
			{
			me.fire_evolving = 1;
			me.evolve_fire();
			}

	},

	evolve_fire: func {

		if (me.fire_evolving == 0) {return;}

		if (me.avbay1_on_fire == 1)
			{
			if (rand() < me.avbay1_damage_probability)
				{
				me.damage_avbay_1();
				}


			if (rand() < me.avbay1_fire_intensity)
				{
				me.avbay1_fire_intensity = me.avbay1_fire_intensity + 0.2 * rand();
				if (me.avbay1_fire_intensity > 1.0) {me.avbay1_fire_intensity = 1.0;}
				}

				me.avbay1_damage_probability = 0.5 * me.avbay1_fire_intensity;

			if (me.avbay1_halon == 1)

				{
				me.avbay1_fire_intensity = me.avbay1_fire_intensity - 0.4;
				if (me.avbay1_fire_intensity < 0.0) {me.avbay1_fire_intensity = 0.0;}
				}

			me.smoke_avbay1 = me.smoke_avbay1 + 4.0 * me.avbay1_fire_intensity;

			me.smoke_avbay2 = me.smoke_avbay2 + 0.31 * me.avbay1_fire_intensity;
			me.smoke_avbay3 = me.smoke_avbay3 + 0.28 * me.avbay1_fire_intensity;
			me.smoke_cabin = me.smoke_cabin + 0.24 * me.avbay1_fire_intensity;
			me.smoke_flightdeck = me.smoke_cabin + 0.24 * me.avbay1_fire_intensity;

			if (me.avbay1_fire_intensity == 0) {me.avbay1_on_fire = 0;}

			}

		if (me.avbay2_on_fire == 1)
			{
			if (rand() < me.avbay2_damage_probability)
				{
				me.damage_avbay_2();
				}


			if (rand() < me.avbay2_fire_intensity)
				{
				me.avbay2_fire_intensity = me.avbay2_fire_intensity + 0.2 * rand();
				if (me.avbay2_fire_intensity > 1.0) {me.avbay2_fire_intensity = 1.0;}
				}

				me.avbay2_damage_probability = 0.5 * me.avbay2_fire_intensity;

			if (me.avbay2_halon == 1)

				{
				me.avbay2_fire_intensity = me.avbay2_fire_intensity - 0.4;
				if (me.avbay2_fire_intensity < 0.0) {me.avbay2_fire_intensity = 0.0;}
				}

			me.smoke_avbay2 = me.smoke_avbay2 + 4.0 * me.avbay2_fire_intensity;

			me.smoke_avbay1 = me.smoke_avbay1 + 0.33 * me.avbay2_fire_intensity;
			me.smoke_avbay3 = me.smoke_avbay3 + 0.34 * me.avbay2_fire_intensity;
			me.smoke_cabin = me.smoke_cabin + 0.25 * me.avbay2_fire_intensity;
			me.smoke_flightdeck = me.smoke_cabin + 0.27 * me.avbay2_fire_intensity;


			if (me.avbay2_fire_intensity == 0) {me.avbay2_on_fire = 0;}

			}

		if (me.avbay3_on_fire == 1)
			{
			if (rand() < me.avbay3_damage_probability)
				{
				me.damage_avbay_1();
				}


			if (rand() < me.avbay3_fire_intensity)
				{
				me.avbay3_fire_intensity = me.avbay3_fire_intensity + 0.2 * rand();
				if (me.avbay3_fire_intensity > 1.0) {me.avbay3_fire_intensity = 1.0;}
				}

				me.avbay3_damage_probability = 0.5 * me.avbay3_fire_intensity;

			if (me.avbay3_halon == 1)

				{
				me.avbay3_fire_intensity = me.avbay3_fire_intensity - 0.4;
				if (me.avbay3_fire_intensity < 0.0) {me.avbay3_fire_intensity = 0.0;}
				}

			me.smoke_avbay3 = me.smoke_avbay3 + 4.0 * me.avbay3_fire_intensity;

			me.smoke_avbay2 = me.smoke_avbay2 + 0.26 * me.avbay3_fire_intensity;
			me.smoke_avbay1 = me.smoke_avbay1 + 0.25 * me.avbay3_fire_intensity;
			me.smoke_cabin = me.smoke_cabin + 0.31 * me.avbay3_fire_intensity;
			me.smoke_flightdeck = me.smoke_cabin + 0.32 * me.avbay3_fire_intensity;


			if (me.avbay3_fire_intensity == 0) {me.avbay3_on_fire = 0;}

			}
		
		me.message("Avbay 1: "~me.avbay1_fire_intensity~" "~me.smoke_avbay1);
		me.message("Avbay 2: "~me.avbay2_fire_intensity~" "~me.smoke_avbay2);
		me.message("Avbay 3: "~me.avbay3_fire_intensity~" "~me.smoke_avbay3);


		if ((me.avbay1_on_fire == 0) and (me.avbay2_on_fire == 0) and (me.avbay3_on_fire == 0))
			{
			me.fire_evolving = 0;
			return;
			}

		settimer (func me.evolve_fire(), 10.0);

	},

	damage_avbay_1: func {

		var rn = rand();

		if (rn < 0.111)
			{
			me.message("ACCU destroyed.");
			}
		else if (rn < 0.222)
			{
			me.message("GPC 1 destroyed.");
			setprop("/fdm/jsbsim/systems/failures/dps/gpc-1-condition", 0);
			}
		else if (rn < 0.333)
			{
			me.message("GPC 4 destroyed.");
			setprop("/fdm/jsbsim/systems/failures/dps/gpc-4-condition", 0);
			}
		else if (rn < 0.444)
			{
			me.message("MMU 1 destroyed.");
			}
		else if (rn < 0.555)
			{
			me.message("AC inverters destroyed.");
			}
		else if (rn < 0.666)
			{
			setprop("/fdm/jsbsim/systems/failures/navigation/tacan-1-condition", 0);
			}
		else if (rn < 0.777)
			{
			setprop("/fdm/jsbsim/systems/failures/navigation/mls-1-condition", 0);
			}
		else if (rn < 0.888)
			{
			setprop("/fdm/jsbsim/systems/failures/navigation/radar-alt-1-condition", 0);
			}
		else
			{
			me.message ("ACC assembly 1 destroyed!");
			}
		

	},

	damage_avbay_2: func {

		var rn = rand();

		if (rn < 0.142)
			{
			me.message("GPC 2 destroyed.");
			setprop("/fdm/jsbsim/systems/failures/dps/gpc-2-condition", 0);
			}
		else if (rn < 0.285)
			{
			me.message("GPC 5 destroyed.");
			setprop("/fdm/jsbsim/systems/failures/dps/gpc-5-condition", 0);
			}
		else if (rn < 0.428)
			{
			me.message("MMU 2 destroyed!");
			}
		else if (rn < 0.571)
			{
			setprop("/fdm/jsbsim/systems/failures/navigation/tacan-2-condition", 0);
			}
		else if (rn < 0.714)
			{
			setprop("/fdm/jsbsim/systems/failures/navigation/mls-2-condition", 0);
			}
		else if (rn < 0.857)
			{
			setprop("/fdm/jsbsim/systems/failures/navigation/radar-alt-2-condition", 0);
			}
		else
			{
			me.message ("ACC assembly 2 destroyed!");
			}

	},

	damage_avbay_3: func {

		var rn = rand();

		if (rn < 0.2)
			{
			me.message("GPC 3 destroyed.");
			setprop("/fdm/jsbsim/systems/failures/dps/gpc-3-condition", 0);
			}
		else if (rn < 0.4)
			{
			me.message ("MTU destroyed!");
			}
		else if (rn < 0.6)
			{
			setprop("/fdm/jsbsim/systems/failures/navigation/tacan-3-condition", 0);
			}
		else if (rn < 0.8)
			{
			me.message("MLS 3 destroyed!");
			setprop("/fdm/jsbsim/systems/failures/navigation/mls-3-condition", 0);
			}
		else
			{
			me.message ("ATVC destroyed!");
			}
		
	},


	apply_halon: func (tgt) {

		me.message("Discharging Halon in "~tgt~"!");


		if (tgt == "avbay1")
			{
			if ((getprop("/fdm/jsbsim/systems/fire-suppression/avbay-1-arm-switch") == 1) and (me.avbay1_halon_available == 1))
				{
				me.avbay1_halon = 1;
				me.avbay1_halon_available = 0;


				settimer(func {
				
				setprop("/fdm/jsbsim/systems/fire-suppression/avbay-1-discharge", 1);
				me.avbay1_halon = 0;

					}, 30.0 );

				}
			}
		else if (tgt == "avbay2")
			{
			if ((getprop("/fdm/jsbsim/systems/fire-suppression/avbay-2-arm-switch") == 1) and (me.avbay2_halon_available == 1))
				{
				me.avbay2_halon = 1;
				me.avbay2_halon_available = 0;


				settimer(func {
				
				setprop("/fdm/jsbsim/systems/fire-suppression/avbay-2-discharge", 1);
				me.avbay2_halon = 0;

					}, 30.0 );

				}
			}

		if (tgt == "avbay3")
			{
			if ((getprop("/fdm/jsbsim/systems/fire-suppression/avbay-3-arm-switch") == 1) and (me.avbay3_halon_available == 1))
				{
				me.avbay3_halon = 1;
				me.avbay3_halon_available = 0;


				settimer(func {
				
				setprop("/fdm/jsbsim/systems/fire-suppression/avbay-3-discharge", 1);
				me.avbay3_halon = 0;

					}, 30.0 );

				}
			}

		

	},


	check_smoke_detection: func {


		var flag  = 0;

		if (me.smoke_avbay1 > 2.0)
			{flag = 1;}
		else if (me.smoke_avbay2 > 2.0)
			{flag = 1;}
		else if (me.smoke_avbay3 > 2.0)
			{flag = 1;}
		else if (me.smoke_cabin > 2.0)
			{flag = 1;}
		else if (me.smoke_flightdeck > 2.0)
			{flag = 1;}

		me.smoke_detection = flag;
		return flag;
		

	},

	message: func (string) {


		if (me.verbose_flag == 1)
			{
			print (string);
			}

	},
	

};



