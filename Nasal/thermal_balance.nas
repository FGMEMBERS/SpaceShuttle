# thermal balance computations for the Space Shuttle
# Thorsten Renk 2015


var thermal_array = [];

var loop_timestep = 1.0;
var rad_timestep = 10.0;
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


var sunpos = func {


var sec_to_rad = 2.0 * math.pi/86400;
var time = getprop("/sim/time/utc/day-seconds");
var sun_angle_rad = getprop("/sim/time/sun-angle-rad");
var lat = getprop("/position/latitude-deg") * math.pi/180.0;
var lon = getprop("/position/longitude-deg") * math.pi/180.0;

var alpha = time * sec_to_rad + lon + math.pi;

sun_z = math.cos(alpha)* math.cos(-lat);
sun_y = -math.sin(alpha);
sun_x = math.cos(alpha) * math.sin(-lat);


var local_sunvec = [sun_x, sun_y, sun_z];

var heading = getprop("/orientation/heading-deg");
var pitch = getprop("/orientation/pitch-deg");
var roll = getprop("/orientation/roll-deg");

if (sun_z < -0.35) {local_sunvec = [0.0, 0.0, 0.0];}


var sun_oriented = SpaceShuttle.orientTaitBryanPassive(local_sunvec, heading, pitch, roll);

return [sun_oriented[0], sun_oriented[1], sun_oriented[2]];
}


var earthpos = func {

var heading = getprop("/orientation/heading-deg");
var pitch = getprop("/orientation/pitch-deg");
var roll = getprop("/orientation/roll-deg");

var down = [0.0, 0.0, -1.0];

return SpaceShuttle.orientTaitBryanPassive(down, heading, pitch, roll);

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


var cabin = thermal_mass.new (3400.0, 897.0, 283.5, 0.6, [-.707, 0.0, 0.707], 32.0, coupling_array1);
append(thermal_array, cabin);

# left fuselage

var coupling_array2 = [];
coupling = heat_transfer.new(5, 60.0);
append(coupling_array2, coupling);
coupling = heat_transfer.new(3, 60.0);
append(coupling_array2, coupling);
coupling = heat_transfer.new(7, 60.0);
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
coupling = heat_transfer.new(7, 60.0);
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
coupling = heat_transfer.new(7, 90.0);
append(coupling_array6, coupling);

var left_pod = thermal_mass.new (3400.0, 897.0, 283.5, 0.6, [0.0, -1.0, 0.0], 20.0, coupling_array6);
append(thermal_array, left_pod);

# aft fuselage

var coupling_array7 = [];
coupling = heat_transfer.new(2, 60.0);
append(coupling_array7, coupling);
coupling = heat_transfer.new(4, 60.0);
append(coupling_array7, coupling);
coupling = heat_transfer.new(5, 60.0);
append(coupling_array7, coupling);
coupling = heat_transfer.new(3, 60.0);
append(coupling_array7, coupling);
coupling = heat_transfer.new(6, 90.0);
append(coupling_array7, coupling);
coupling = heat_transfer.new(8, 90.0);
append(coupling_array7, coupling);
coupling = heat_transfer.new(12, 500.0);
append(coupling_array7, coupling);
coupling = heat_transfer.new(13, 500.0);
append(coupling_array7, coupling);
coupling = heat_transfer.new(14, 500.0);
append(coupling_array7, coupling);

var aft_fuselage = thermal_mass.new (9520.0, 897.0, 283.5, 0.6, [1.0, 0.0, 0.0], 40.0, coupling_array7);
append(thermal_array, aft_fuselage);

# right OMS pod

var coupling_array8 = [];
coupling = heat_transfer.new(7, 90.0);
append(coupling_array8, coupling);

var right_pod = thermal_mass.new (3400.0, 897.0, 283.5, 0.6, [0.0, 1.0, 0.0], 20.0, coupling_array8);
append(thermal_array, right_pod);

# avionics bays

var coupling_array9 = [];
coupling = heat_transfer.new(10, 800.0);
append(coupling_array9, coupling);

var avionics = thermal_mass.new (680.0, 1012.0, 293.5, 1.0, [0.0, 1.0,0.0], 0.0, coupling_array9);
avionics.source = 14000.0;
append(thermal_array, avionics);

# cabin interior

var coupling_array10 = [];
coupling = heat_transfer.new(9, 800.0);
append(coupling_array10, coupling);
coupling = heat_transfer.new(1, 100);
append(coupling_array10, coupling);

var pressure_vessel = thermal_mass.new (3400.0, 1012.0, 293.5, 0.4, [0.0, 1.0, 0.0], 2.0, coupling_array10);
pressure_vessel.source = 980.0;
append(thermal_array, pressure_vessel);

# freon

var coupling_array11 = [];

var freon = thermal_mass.new (200.0, 1000.0, 310.0, 0.9, [0.0, 0.0, 1.0], 41.5, coupling_array11);
append(thermal_array, freon);


# APU 1

var coupling_array12 = [];
coupling = heat_transfer.new(7, 500.0);
append(coupling_array12, coupling);

var apu1 = thermal_mass.new (200.0, 2500.0, 310.0, 1.0, [0.0, 1.0, 0.0], 0.0, coupling_array12);
append(thermal_array, apu1);

# APU 2

var coupling_array13 = [];
coupling = heat_transfer.new(7, 500.0);
append(coupling_array13, coupling);

var apu2 = thermal_mass.new (200.0, 2500.0, 310.0, 1.0, [0.0, 1.0, 0.0], 0.0, coupling_array13);
append(thermal_array, apu2);

# APU 3

var coupling_array14 = [];
coupling = heat_transfer.new(7, 500.0);
append(coupling_array14, coupling);

var apu3 = thermal_mass.new (200.0, 2500.0, 310.0, 1.0, [0.0, 1.0, 0.0], 0.0, coupling_array14);
append(thermal_array, apu3);

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
setprop("/fdm/jsbsim/systems/thermal-distribution/freon-out-temperature-K", thermal_array[11].temperature);
setprop("/fdm/jsbsim/systems/thermal-distribution/apu1-temperature-K", thermal_array[12].temperature);
setprop("/fdm/jsbsim/systems/thermal-distribution/apu2-temperature-K", thermal_array[13].temperature);
setprop("/fdm/jsbsim/systems/thermal-distribution/apu3-temperature-K", thermal_array[14].temperature);

var freon_in_temp = thermal_array[9].temperature;
if (freon_in_temp > 310.0) {freon_in_temp = 310.0;} 
if (thermal_array[11].temperature > freon_in_temp) {freon_in_temp = thermal_array[11].temperature;}

setprop("/fdm/jsbsim/systems/thermal-distribution/freon-in-temperature-K", freon_in_temp);


}


var compute_radiative_balance = func{


sun_normal = sunpos();
sun_normal[0] = -sun_normal[0];
var earth_normal = earthpos();
earth_normal[0] = - earth_normal[0];

#print(sun_normal[0], " ", sun_normal[1], " ", sun_normal[2]);

for (var i = 0; i< size(thermal_array); i=i+1)
	{
	var NdotS = dot (sun_normal, thermal_array[i].normal);
	if (NdotS < 0.0) {NdotS = 0.0;}

	var EdotS = dot (earth_normal, thermal_array[i].normal);
	if (EdotS < 0.0) {EdotS = 0.0;}

	var influx = 1360.0 * NdotS  * thermal_array[i].area * rad_timestep * (1.0 -thermal_array[i].albedo);
	influx = influx + 85.0 * EdotS * thermal_array[i].area * rad_timestep;

	var outflux = thermal_array[i].area  * sigma * math.pow(thermal_array[i].temperature,4.0) * rad_timestep;
	thermal_array[i].thermal_energy = thermal_array[i].thermal_energy + influx - outflux;
	thermal_array[i].temperature = thermal_array[i].thermal_energy / thermal_array[i].mass /thermal_array[i].heat_capacity;



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

	#if (i==11) {print("source: ", source, " sink: ", sink);}

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


var adjust_water = func {

var capacity = getprop("/fdm/jsbsim/systems/atcs/water-loop-heat-transfer");

if (capacity==0.0) {capacity = 30.0;}

thermal_array[9].transfer[0].capacity = capacity;
thermal_array[10].transfer[0].capacity = capacity;

}


var adjust_freon = func {

var T_target = getprop("/fdm/jsbsim/systems/thermal-distribution/interior-set-temperature-K");

var T = thermal_array[10].temperature;
var DT = math.abs(T - T_target);
var step = 0.03 * DT;

var state = getprop("/fdm/jsbsim/systems/thermal-distribution/freon-loop-switch");


if (T > T_target)
	{
	var new_state = state + step;
	if (new_state > 1.0) {new_state = 1.0;}

	setprop("/fdm/jsbsim/systems/thermal-distribution/freon-loop-switch", new_state);		
	}
else
	{
	var new_state = state - step;
	if (new_state < 0.0) {new_state = 0.0;}

	setprop("/fdm/jsbsim/systems/thermal-distribution/freon-loop-switch", new_state);
	}


freon_loop_manager();

}


var adjust_spray_boilers = func {

for (var i = 0; i < 3; i = i+1)
	{
	var source = getprop("/fdm/jsbsim/systems/apu/apu["~i~"]/apu-heat-load");
	thermal_array[12+i].source = source;


	var T = thermal_array[12+i].temperature;
	var state = getprop("/fdm/jsbsim/systems/thermal-distribution/spray-boiler-"~(i+1)~"-switch");

	var state_new = 0.0;

	if (T > 375.) {state_new = (T - 375.0) * 0.02;}
	if (state_new > 1.0) {state_new = 1.0;}

	setprop("/fdm/jsbsim/systems/thermal-distribution/spray-boiler-"~(i+1)~"-switch", state_new);

	var sink_max = getprop("/fdm/jsbsim/systems/apu/apu["~i~"]/boiler-heat-dump-capacity");
	
	var sink = sink_max * state_new;
	
	thermal_array[12+i].sink = sink;

	}

}



var thermal_management_loop = func {

compute_radiative_balance();
compute_source_sink();
compute_transfers();

adjust_water();
adjust_freon();
adjust_spray_boilers();

write_temperatures();

loop_timestep = getprop("/fdm/jsbsim/systems/thermal-distribution/computation-timestep-s");
var speedup = getprop("/sim/speed-up");

loop_timestep = loop_timestep/speedup;

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

var sink_capacity = getprop("/fdm/jsbsim/systems/atcs/freon-sink-capacity");

#print("Freon loop to ", state);

thermal_array[9].sink = 0.106 * sink_capacity * state; 
thermal_array[10].sink = 0.894 * sink_capacity * state; 

#print(sink_capacity);

thermal_array[11].source = sink_capacity * state;

var rad_dump_capacity = getprop("/fdm/jsbsim/systems/atcs/rad-heat-dump-capacity");
thermal_array[11].area = 41.5 * rad_dump_capacity / 17900.0;

var fes_sink = getprop("/fdm/jsbsim/systems/atcs/fes-heat-dump-capacity");

thermal_array[11].sink = fes_sink * state;
}

#setlistener("/fdm/jsbsim/systems/thermal-distribution/water-loop-switch", func { water_loop_manager();},0,0);
#setlistener("/fdm/jsbsim/systems/thermal-distribution/freon-loop-switch", func { freon_loop_manager();},0,0);

# automatically run the loop at startup

settimer(thermal_management_init, 3.0);
