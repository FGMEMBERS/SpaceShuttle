# thermal balance computations for the Space Shuttle
# Thorsten Renk 2015


var thermal_array = [];

var loop_timestep = 0.1;
var rad_timestep = 60.0;
var sigma = 5.67e-8; 


# hash for the parts of the shuttle for which heat balance is obtained

var thermal_mass = {
	new: func(mass, heat_capacity, temperature, albedo, normal, area, transfer) {
	        var t = { parents: [thermal_mass] };
		t.mass = mass;	
		t.heat_capacity = heat_capacity;
		t.temperature = temperature;	
		t.albedo = albedo;
		t.normal = normal;
		t.area = area;
		t.transfer = transfer;
		t.source = 0.0;
		t.sink = 0.0;
		t.thermal_energy = t.mass * t.temperature * t.heat_capacity;

	        return t;
	},
};

var heat_transfer = {
	new: func(index, capacity) {
	        var t = { parents: [heat_transfer] };
		t.index = index;
		t.capacity = capacity;
		
		return t;
	},
};

var dot = func (x,y) {

return x[0] * y[0] + x[1] * y[1] + x[2] * y[2];

}


var thermal_management_init = func {

setprop("/fdm/jsbsim/systems/thermal-distribution/time", 0.0);


var coupling = {};

# 0: nose 1: cabin 2: left 3: bay 4: right 5: tps 6: left pod 7: aft 
# 8: right pod 9: avionics 10: interior

# nose and forward RCS module

var coupling_array0 = [];
coupling = heat_transfer.new(1, 15.0);
append(coupling_array0, coupling);
coupling = heat_transfer.new(5, 15.0);
append(coupling_array0, coupling);

var nose = thermal_mass.new (3400.0, 897.0, 283.5, 0.6, [-1.0, 0.0, 0.0], 12.0, coupling_array0);
append(thermal_array, nose);

# exterior of cabin

var coupling_array1 = [];
coupling = heat_transfer.new(0, 15.0);
append(coupling_array1, coupling);
coupling = heat_transfer.new(5, 15.0);
append(coupling_array1, coupling);
#coupling = heat_transfer.new(10, 300);
coupling = heat_transfer.new(10, 100);
append(coupling_array1, coupling);


var cabin = thermal_mass.new (3400.0, 897.0, 283.5, 0.6, [0.0, 1.0, 0.0], 32.0, coupling_array1);
append(thermal_array, cabin);

# left fuselage

var coupling_array2 = [];
coupling = heat_transfer.new(5, 60.0);
append(coupling_array2, coupling);
coupling = heat_transfer.new(3, 60.0);
append(coupling_array2, coupling);

var left_fuselage = thermal_mass.new (10200.0, 897.0, 283.5, 0.6, [0.0, -1.0, 0.0], 192.0, coupling_array2);
append(thermal_array, left_fuselage);

# payload bay

var coupling_array3 = [];
coupling = heat_transfer.new(2, 60.0);
append(coupling_array3, coupling);
coupling = heat_transfer.new(4, 60.0);
append(coupling_array3, coupling);
coupling = heat_transfer.new(7, 60.0);
append(coupling_array3, coupling);

var payload_bay = thermal_mass.new (10200.0, 897.0, 283.5, 0.6, [0.0, 0.0, 1.0], 128.0, coupling_array3);
append(thermal_array, payload_bay);

# right fuselage

var coupling_array4 = [];
coupling = heat_transfer.new(5, 60.0);
append(coupling_array4, coupling);
coupling = heat_transfer.new(3, 60.0);
append(coupling_array4, coupling);

var right_fuselage = thermal_mass.new (10200.0, 897.0, 283.5, 0.6, [0.0, 1.0, 0.0], 192.0, coupling_array4);
append(thermal_array, right_fuselage);

# thermal protection system

var coupling_array5 = [];
coupling = heat_transfer.new(0, 15.0);
append(coupling_array5, coupling);
coupling = heat_transfer.new(1, 15.0);
append(coupling_array5, coupling);
coupling = heat_transfer.new(2, 60.0);
append(coupling_array5, coupling);
coupling = heat_transfer.new(4, 60.0);
append(coupling_array5, coupling);
coupling = heat_transfer.new(7, 60.0);
append(coupling_array5, coupling);

var heat_shield = thermal_mass.new (10200.0, 500.0, 283.5, 0.2, [0.0, 0.0, -1.0], 256.0, coupling_array5);

#heat_shield.source = 100000000.0;

append(thermal_array, heat_shield);

# left OMS pod

var coupling_array6 = [];
coupling = heat_transfer.new(7, 30.0);
append(coupling_array6, coupling);

var left_pod = thermal_mass.new (3400.0, 897.0, 283.5, 0.6, [0.0, -1.0, 0.0], 20.0, coupling_array6);
append(thermal_array, left_pod);

# aft fuselage

var coupling_array7 = [];
coupling = heat_transfer.new(5, 60.0);
append(coupling_array7, coupling);
coupling = heat_transfer.new(3, 60.0);
append(coupling_array7, coupling);
coupling = heat_transfer.new(6, 30.0);
append(coupling_array7, coupling);
coupling = heat_transfer.new(8, 30.0);
append(coupling_array7, coupling);

var aft_fuselage = thermal_mass.new (9520.0, 897.0, 283.5, 0.6, [1.0, 0.0, 0.0], 40.0, coupling_array7);
append(thermal_array, aft_fuselage);

# right OMS pod

var coupling_array8 = [];
coupling = heat_transfer.new(7, 30.0);
append(coupling_array8, coupling);

var right_pod = thermal_mass.new (3400.0, 897.0, 283.5, 0.6, [0.0, 1.0, 0.0], 20.0, coupling_array8);
append(thermal_array, right_pod);

# avionics bays

var coupling_array9 = [];
coupling = heat_transfer.new(10, 800.0);
append(coupling_array9, coupling);

var avionics = thermal_mass.new (680.0, 1012.0, 283.5, 1.0, [0.0, 1.0,0.0], 0.0, coupling_array9);
avionics.source = 14000.0;
append(thermal_array, avionics);

# cabin interior

var coupling_array10 = [];
coupling = heat_transfer.new(9, 800.0);
append(coupling_array10, coupling);
coupling = heat_transfer.new(1, 100);
append(coupling_array10, coupling);

var pressure_vessel = thermal_mass.new (3400.0, 1012.0, 283.5, 0.4, [0.0, 1.0, 0.0], 2.0, coupling_array10);
pressure_vessel.source = 980.0;
append(thermal_array, pressure_vessel);

write_temperatures();

thermal_management_loop();
}


var write_temperatures = func {

setprop("/fdm/jsbsim/systems/thermal-distribution/nose-temperature-K", thermal_array[0].temperature);
setprop("/fdm/jsbsim/systems/thermal-distribution/cabin-temperature-K", thermal_array[1].temperature);
setprop("/fdm/jsbsim/systems/thermal-distribution/left-temperature-K", thermal_array[2].temperature);
setprop("/fdm/jsbsim/systems/thermal-distribution/payload-bay-temperature-K", thermal_array[3].temperature);
setprop("/fdm/jsbsim/systems/thermal-distribution/right-temperature-K", thermal_array[4].temperature);
setprop("/fdm/jsbsim/systems/thermal-distribution/tps-temperature-K", thermal_array[5].temperature);
setprop("/fdm/jsbsim/systems/thermal-distribution/left-pod-temperature-K", thermal_array[6].temperature);
setprop("/fdm/jsbsim/systems/thermal-distribution/aft-temperature-K", thermal_array[7].temperature);
setprop("/fdm/jsbsim/systems/thermal-distribution/right-pod-temperature-K", thermal_array[8].temperature);
setprop("/fdm/jsbsim/systems/thermal-distribution/avionics-temperature-K", thermal_array[9].temperature);
setprop("/fdm/jsbsim/systems/thermal-distribution/interior-temperature-K", thermal_array[10].temperature);
}


var compute_radiative_balance = func{


var sun_normal = [0.707, 0.0, 0.707];


for (var i = 0; i< size(thermal_array); i=i+1)
	{
	var NdotS = dot (sun_normal, thermal_array[i].normal);
	if (NdotS < 0.0) {NdotS = 0.0;}

	var influx = 1360.0 * NdotS  * thermal_array[i].area * rad_timestep * thermal_array[i].albedo;
	var outflux = thermal_array[i].area  * sigma * math.pow(thermal_array[i].temperature,4.0) * rad_timestep;
	thermal_array[i].thermal_energy = thermal_array[i].thermal_energy + influx - outflux;
	thermal_array[i].temperature = thermal_array[i].thermal_energy / thermal_array[i].mass /thermal_array[i].heat_capacity;

#	if (i==3)
#		{
#		print("Payload bay influx: ", influx /rad_timestep / thermal_array[i].area, " outflux: ", outflux /rad_timestep / thermal_array[i].area);
#		}

	}

var time = getprop("/fdm/jsbsim/systems/thermal-distribution/time") ;

setprop("/fdm/jsbsim/systems/thermal-distribution/time", time + 1.0);

#print(time, " ", thermal_array[10].temperature);
#if (time > 30.0)
#	{
#	thermal_array[5].source = 0.0;
#	}

}


var compute_source_sink = func {

for (var i = 0; i< size(thermal_array); i=i+1)
	{
	var source = thermal_array[i].source * rad_timestep;
	var sink = thermal_array[i].sink * rad_timestep;
	thermal_array[i].thermal_energy = thermal_array[i].thermal_energy + source - sink;
	thermal_array[i].temperature = thermal_array[i].thermal_energy / thermal_array[i].mass /thermal_array[i].heat_capacity;

	}
}

var compute_transfers = func {

for (var i = 0; i< size(thermal_array); i=i+1)
	{
	var Ti = thermal_array[i].temperature;


	for (var k = 0; k < size(thermal_array[i].transfer); k =k+1)
		{
		var j = thermal_array[i].transfer[k].index;
		var cj = thermal_array[i].transfer[k].capacity;# * 0.005;


		var Tj = thermal_array[j].temperature;


		# to avoid double-counting, we do heat transfer only if i is at higher T

		if (Ti > Tj)
			{
			var DeltaE = (Ti - Tj) * cj * rad_timestep;
			thermal_array[i].thermal_energy = thermal_array[i].thermal_energy - DeltaE;
			thermal_array[j].thermal_energy = thermal_array[j].thermal_energy + DeltaE;
			thermal_array[i].temperature = thermal_array[i].thermal_energy / thermal_array[i].mass /thermal_array[i].heat_capacity;
			thermal_array[j].temperature = thermal_array[j].thermal_energy / thermal_array[j].mass /thermal_array[j].heat_capacity;

			}
		
		}
	}

}


var thermal_management_loop = func {

compute_radiative_balance();
compute_source_sink();
compute_transfers();

write_temperatures();



settimer (thermal_management_loop, loop_timestep);
}


var water_loop_manager = func {


var state = getprop("/fdm/jsbsim/systems/thermal-distribution/water-loop-switch");

#print("Water loop to ",state);

if (state == 1)
	{
	thermal_array[9].transfer[0].capacity = 800.0;
	thermal_array[10].transfer[0].capacity = 800.0;
	}

if (state == 0)
	{
	thermal_array[9].transfer[0].capacity = 30.0;
	thermal_array[10].transfer[0].capacity = 30.0;
	}
}

var freon_loop_manager = func {

var state = getprop("/fdm/jsbsim/systems/thermal-distribution/freon-loop-switch");

#print("Freon loop to ", state);

thermal_array[9].sink = 1900.0 * state; 
thermal_array[10].sink = 16000.0 * state; 

}

setlistener("/fdm/jsbsim/systems/thermal-distribution/water-loop-switch", func { water_loop_manager();},0,0);
setlistener("/fdm/jsbsim/systems/thermal-distribution/freon-loop-switch", func { freon_loop_manager();},0,0);
