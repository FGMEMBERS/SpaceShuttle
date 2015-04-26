

var create_map = func {

var window = canvas.Window.new([800,600],"dialog");
var mapCanvas = window.createCanvas().set("background", canvas.style.getColor("bg_color"));
var root = mapCanvas.createGroup();


var path = "Aircraft/SpaceShuttle/Dialogs/MapOfEarth.png";
var child=root.createChild("image")
                                   .setFile( path )
                                   .setTranslation(0,0)
                                   .setSize(800,400);

var mapLayout = canvas.HBoxLayout.new();
# assign it to the Canvas
mapCanvas.setLayout(mapLayout);

var label = canvas.gui.widgets.Label.new(root, canvas.style, {wordWrap: 0}); 
label.setText("Shuttle");
mapLayout.addItem(label);

}
