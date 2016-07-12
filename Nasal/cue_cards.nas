
# display of cue cards in a canvas window

var show_cue_card = func (path) {

var size = [0,0];
var title = "Cue card";

if (path == "Cuecards/ascent_nominal.png")
	{
	size = [217, 549];
	title = "Ascent ADI - Nominal";
	}

else if (path == "Cuecards/aborts.png")
	{
	size = [659, 650];
	title = "Aborts";
	}
else if (path == "Cuecards/rtls_cdr.png")
	{
	size = [450, 673];
	title = "RTLS Commander";
	}
else if (path == "Cuecards/rtls_plt.png")
	{
	size = [470, 727];
	title = "RTLS Pilot";
	}
else if (path == "Cuecards/tal_redesignation_zza.png")
	{
	size = [632, 500];
	title = "ZZA TAL Redesignation";
	}
else if (path == "Cuecards/oms_part1.png")
	{
	size = [455, 513];
	title = "OMS Burn Part 1";
	}
else if (path == "Cuecards/oms_part2.png")
	{
	size = [423, 377];
	title = "OMS Burn Part 2";
	}
else if (path == "Cuecards/entry_nominal.png")
	{
	size = [214, 550];
	title = "Entry Alpha";
	}

var window = canvas.Window.new(size,"dialog").set("title", title);
var cueCanvas = window.createCanvas().set("background", canvas.style.getColor("bg_color"));
var root = cueCanvas.createGroup();

var child=root.createChild("image")
                                   .setFile( path )
                                   .setTranslation(0,0)
                                   .setSize(size);
}
