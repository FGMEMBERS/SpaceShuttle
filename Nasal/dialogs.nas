

var propellant_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/propellant/dialog","Aircraft/SpaceShuttle/Dialogs/propellant.xml");
var entry_guidance_dlg = gui.Dialog.new("/sim/gui/dialogs/SpaceShuttle/entry_guidance/dialog","Aircraft/SpaceShuttle/Dialogs/entry_guidance.xml");

setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site", "Vandenberg Air Force Base");
setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-lat",34.722);
setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-lon",-120.567);
setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-string", "inactive");

gui.menuBind("fuel-and-payload", "SpaceShuttle.propellant_dlg.open()");
gui.menuEnable("fuel-and-payload", 1);


var update_site = func {

#print("Hello!");

var site_string = getprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site");

var lat = 0.0;
var lon = 0.0;

setprop("/fdm/jsbsim/systems/entry_guidance/guidance-mode",0);
setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-string", "inactive");

if (site_string == "Kennedy Space Center")
	{
	lat = 28.615;
	lon = -80.695;
	}
else if (site_string == "Vandenberg Air Force Base")
	{
	lat = 34.722;
	lon = -120.567;
	}
else if (site_string == "Edwards Air Force Base")
	{
	lat = 34.096;
	lon = -117.884;
	}


setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-lat", lat);
setprop("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site-lon", lon);
SpaceShuttle.landing_site.set_latlon(lat,lon);


}

setlistener("/sim/gui/dialogs/SpaceShuttle/entry_guidance/site", update_site);
