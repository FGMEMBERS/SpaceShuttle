

var compute_launchpad = func {

var alt = getprop("/position/altitude-ft");
var terrain_alt = getprop("/position/altitude-agl-ft");

var place_alt = (alt - terrain_alt) + 90.0; #214

place_pad(place_alt - 175.0);

}


var place_pad = func (place_alt) {

var lat = getprop("/sim/presets/latitude-deg");
var lon = getprop("/sim/presets/longitude-deg");
var heading = getprop("/sim/presets/heading-deg") + 90.0; #getprop("/orientation/heading-deg");

var lat_to_m = 110952.0; 
var lon_to_m  = math.cos(getprop("/position/latitude-deg")*math.pi/180.0) * lat_to_m;
var m_to_lon = 1.0/lon_to_m;
var m_to_lat = 1.0/lat_to_m;

var delta_lat = 0.0 * m_to_lat;
var delta_lon = 0.0 * m_to_lon;


geo.put_model("Aircraft/SpaceShuttle/Models/Launchpad/launchpad.xml", lat + delta_lat, lon + delta_lon, nil, heading);


}
