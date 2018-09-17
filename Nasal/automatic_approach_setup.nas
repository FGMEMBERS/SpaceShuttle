# automatic guidance activation for Shuttle approach trainer
# Thorsten Renk 2018


	# if we recognze the airport, we can start guidance
	
	var airport = getprop("/sim/presets/airport-id");

	if (airport == "KTTS")
		{
		SpaceShuttle.update_site_by_index(1);
		if (abs(heading - 150.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for KTTS loaded");
		}
	else if (airport == "KVBG")
		{
		SpaceShuttle.update_site_by_index(2);
		if (abs(heading - 150.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for KVBG loaded");
		}
	else if (airport == "TXKF")
		{
		SpaceShuttle.update_site_by_index(11);
		if (abs(heading - 120.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for TXKF loaded");

		}
	else if (airport == "LFMI")
		{
		SpaceShuttle.update_site_by_index(9);
		if (abs(heading - 150.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for LFMI loaded");

		}
	else if (airport == "GBYD")
		{
		SpaceShuttle.update_site_by_index(7);
		if (abs(heading - 140.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for GBYD loaded");

		}
	else if (airport == "LEZG")
		{
		SpaceShuttle.update_site_by_index(5);
		if (abs(heading - 120.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for LEZG loaded");

		}
	else if (airport == "EGVA")
		{
		SpaceShuttle.update_site_by_index(6);
		if (abs(heading - 90.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for EGVA loaded");

		}
	else if (airport == "LEMO")
		{
		SpaceShuttle.update_site_by_index(8);
		if (abs(heading - 20.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for LEMO loaded");

		}
	else if (airport == "CYHZ")
		{
		SpaceShuttle.update_site_by_index(12);
		if (abs(heading - 50.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for CYHZ loaded");

		}
	else if (airport == "KILM")
		{
		SpaceShuttle.update_site_by_index(13);
		if (abs(heading - 50.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for KILM loaded");

		}
	else if (airport == "KACY")
		{
		SpaceShuttle.update_site_by_index(14);
		if (abs(heading - 130.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for KACY loaded");
		}
	else if (airport == "KMYR")
		{
		SpaceShuttle.update_site_by_index(15);
		if (abs(heading - 180.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for KMYR loaded");
		}
	else if (airport == "KPSM")
		{
		SpaceShuttle.update_site_by_index(17);
		if (abs(heading - 150.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for KPSM loaded");
		}
	else if (airport == "CYQX")
		{
		SpaceShuttle.update_site_by_index(16);
		#print ("Heading: ", heading);
		if (abs(heading - 10.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for CYQX loaded");
		}
	else if (airport == "KNTU")
		{
		SpaceShuttle.update_site_by_index(18);
		#print ("Heading: ", heading);
		if (abs(heading - 10.0) < 50.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for KNTU loaded");
		}
	else if (airport == "SCIP")
		{
		SpaceShuttle.update_site_by_index(30);
		if (abs(heading - 100.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for SCIP loaded");

		}
	else if (airport == "FJDG")
		{
		SpaceShuttle.update_site_by_index(32);
		if (abs(heading - 120.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for FJDG loaded");

		}
	else if (airport == "PHNL")
		{
		SpaceShuttle.update_site_by_index(33);
		if (abs(heading - 80.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for PHNL loaded");
		}
	else if (airport == "BIKF")
		{
		SpaceShuttle.update_site_by_index(34);
		if (abs(heading - 90.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for BIKF loaded");
		}
	else if (airport == "PGUA")
		{
		SpaceShuttle.update_site_by_index(35);
		if (abs(heading - 60.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for PGUA loaded");
		}
	else if (airport == "KEDW")
		{
		SpaceShuttle.update_site_by_index(3);
		if (abs(heading - 60.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for KEDW loaded");
		}
	else if (airport == "GVAC")
		{
		SpaceShuttle.update_site_by_index(36);
		if (abs(heading - 180.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(1);}
		else
			{SpaceShuttle.update_runway_by_flag(0);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for GVAC loaded");
		}
	else if (airport == "FHAW")
		{
		SpaceShuttle.update_site_by_index(37);
		if (abs(heading - 130.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for FHAW loaded");
		}
	else if (airport == "PWAK")
		{
		SpaceShuttle.update_site_by_index(38);
		if (abs(heading - 100.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for PWAK loaded");
		}
	else if (airport == "LPLA")
		{
		SpaceShuttle.update_site_by_index(39);
		if (abs(heading - 150.0) < 20.0) 
			{SpaceShuttle.update_runway_by_flag(0);}
		else
			{SpaceShuttle.update_runway_by_flag(1);}
		SpaceShuttle.TAEM_loop_running = 1;
		SpaceShuttle.compute_entry_guidance_target();
		settimer (func {SpaceShuttle.TAEM_guidance_loop(1, 0.0); }, 1.0);
		print("Automatic approach guidance for LPLA loaded");
		}
