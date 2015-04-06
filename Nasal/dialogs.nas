

var propellant_dlg = gui.Dialog.new("dialog","Aircraft/SpaceShuttle/Dialogs/propellant.xml");
#var propellant_dlg = gui.Dialog.new("dialog","Aircraft/f-14b/Dialogs/external-loads.xml");

#gui.menuEnable("fuel-and-payload", 0);
gui.menuBind("fuel-and-payload", "SpaceShuttle.propellant_dlg.open()");
gui.menuEnable("fuel-and-payload", 1);

