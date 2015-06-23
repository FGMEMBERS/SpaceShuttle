# thermal balance computations for the Space Shuttle
# Thorsten Renk 2015


var thermal_array = [];

var loop_timestep = 1.0;
var rad_timestep = 60.0;
var sigma = 5.67e-8; 


# hash for the parts of the shuttle for which heat balance is obtained

var thermal_mass = {
	new: func(mass, heat_capacity, temperature, albedo, normal, area) {
	        var t = { parents: [thermal_mass] };
		t.mass = mass;	
		t.heat_capacity = heat_capacity;
		t.temperature = temperature;	
		t.albedo = albedo;
		t.normal = normal;
		t.area = area;
		t.source = 0.0;
		t.sink = 0.0;
		t.thermal_energy = t.mass * t.temperature * t.heat_capacity;

	        return t;
	},
};


var dot = func (x,y) {

return x[0] * y[0] + x[1] * y[1] + x[2] * y[2];

}


var thermal_management_init = func {

setprop("/fdm/jsbsim/systems/thermal-distribution/time", 0.0);

var nose = thermal_mass.new (3400.0, 897.0, 283.5, 0.6, [-1.0, 0.0, 0.0], 12.0);
append(thermal_array, nose);

var cabin = thermal_mass.new (6800.0, 1012.0, 283.5, 0.6, [0.0, 1.0, 0.0], 32.0);
cabin.source = 14000.0;
append(thermal_array, cabin);


var left_fuselage = thermal_mass.new (10200.0, 897.0, 283.5, 0.6, [0.0, -1.0, 0.0], 192.0);
append(thermal_array, left_fuselage);

var payload_bay = thermal_mass.new (10200.0, 897.0, 283.5, 0.6, [0.0, 0.0, 1.0], 128.0);
append(thermal_array, payload_bay);

var right_fuselage = thermal_mass.new (10200.0, 897.0, 283.5, 0.6, [0.0, 1.0, 0.0], 192.0);
append(thermal_array, right_fuselage);

var heat_shield = thermal_mass.new (10200.0, 500.0, 283.5, 0.2, [0.0, 0.0, -1.0], 256.0);
append(thermal_array, heat_shield);

var left_pod = thermal_mass.new (3400.0, 897.0, 283.5, 0.6, [0.0, -1.0, 0.0], 20.0);
append(thermal_array, left_pod);

var aft_fuselage = thermal_mass.new (9520.0, 897.0, 283.5, 0.6, [1.0, 0.0, 0.0], 40.0);
append(thermal_array, aft_fuselage);

var right_pod = thermal_mass.new (3400.0, 897.0, 283.5, 0.6, [0.0, 1.0, 0.0], 20.0);
append(thermal_array, right_pod);

var avionics = thermal_mass.new (680.0, 1012.0, 283.5, 1.0, [0.0, 1.0,0.0], 0.0);
append(thermal_array, avionics);

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
}


var compute_radiative_balance = func{


var sun_normal = [0.0, 0.0, 1.0];


for (var i = 0; i< size(thermal_array); i=i+1)
	{
	var NdotS = dot (sun_normal, thermal_array[i].normal);
	if (NdotS < 0.0) {NdotS = 0.0;}

	var influx = 1360.0 * NdotS  * thermal_array[i].area * rad_timestep * thermal_array[i].albedo;
	var outflux = thermal_array[i].area  * sigma * math.pow(thermal_array[i].temperature,4.0) * rad_timestep;
	thermal_array[i].thermal_energy = thermal_array[i].thermal_energy + influx - outflux;
	thermal_array[i].temperature = thermal_array[i].thermal_energy / thermal_array[i].mass /thermal_array[i].heat_capacity;

	if (i==3)
		{
		print("Payload bay influx: ", influx /rad_timestep / thermal_array[i].area, " outflux: ", outflux /rad_timestep / thermal_array[i].area);
		}

	}

var time = getprop("/fdm/jsbsim/systems/thermal-distribution/time") ;

setprop("/fdm/jsbsim/systems/thermal-distribution/time", time + 1.0);

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


var thermal_management_loop = func {

compute_radiative_balance();
compute_source_sink();

write_temperatures();



settimer (thermal_management_loop, loop_timestep);
}
