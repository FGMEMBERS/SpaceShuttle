# write the Shuttle state to auto-saved properties
# and resume from those
# Thorsten Renk 2016

var save_state = func {


var lat = getprop("/position/latitude-deg");
setprop("/save/latitude-deg", lat);

var lon = getprop("/position/longitude-deg");
setprop("/save/longitude-deg", lon);

var alt = getprop("/position/altitude-ft");
setprop("/save/altitude-ft", alt);

var heading = getprop("/orientation/heading-deg");
setprop("/save/heading-deg", heading);

var pitch = getprop("/orientation/pitch-deg");
setprop("/save/pitch-deg", pitch);

var roll = getprop("/orientation/roll-deg");
setprop("/save/roll-deg", roll);

var uBody = getprop("/velocities/uBody-fps");
setprop("/save/uBody-fps", uBody);

var vBody = getprop("/velocities/vBody-fps");
setprop("/save/vBody-fps", vBody);

var wBody = getprop("/velocities/wBody-fps");
setprop("/save/wBody-fps", wBody);

print("Current state written!");

}


var resume_state = func {


var lat = getprop("/save/latitude-deg");
setprop("/position/latitude-deg", lat);

var lon = getprop("/save/longitude-deg");
setprop("/position/longitude-deg", lon);

var alt = getprop("/save/altitude-ft");
setprop("/position/altitude-ft", alt);

var heading = getprop("/save/heading-deg");
setprop("/orientation/heading-deg", heading);

var pitch = getprop("/save/pitch-deg");
setprop("/orientation/pitch-deg", pitch);

var roll = getprop("/save/roll-deg");
setprop("/orientation/roll-deg", roll);

var uBody = getprop("/save/uBody-fps");
setprop("/velocities/uBody-fps", uBody);

var vBody = getprop("/save/vBody-fps");
setprop("/velocities/vBody-fps", vBody);

var wBody = getprop("/save/wBody-fps");
setprop("/velocities/wBody-fps", wBody);


print("State resumed!");
}
