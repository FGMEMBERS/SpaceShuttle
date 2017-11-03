##########################################
# HUD Brightness Mode Selector
##########################################

var hud_bright_mode = func (name) {

    if (name == "dim-cmd") {
        var hud_dim_cmd = getprop("/fdm/jsbsim/systems/light/hud-dim-cmd");  
        setprop("/fdm/jsbsim/systems/light/hud-light-cmd-norm", hud_dim_cmd);
	CommanderHUD.set_brightness(hud_dim_cmd);
        return;
    }
    if (name == "dim-plt") {
        var hud_dim_plt = getprop("/fdm/jsbsim/systems/light/hud-dim-plt");  
        setprop("/fdm/jsbsim/systems/light/hud-light-plt-norm", hud_dim_plt);
	PilotHUD.set_brightness(hud_dim_plt);
        return;
    }

    var hud_day_mode_norm = .9;
    var hud_night_mode_norm = .6;

    var bright_switch_selection = getprop("/fdm/jsbsim/systems/light/hud-bright-" ~ name);

    if (bright_switch_selection == 2) {
        setprop("/fdm/jsbsim/systems/light/hud-light-" ~ name ~ "-norm", hud_day_mode_norm);
        return;
    }
    if (bright_switch_selection == 0) {
        setprop("/fdm/jsbsim/systems/light/hud-light-" ~ name ~ "-norm", hud_night_mode_norm);
        return;
    }

};







var write_small_label_trans = func (group, text, coords, color) {


if (coords[2] ==1)
	{
	var canvas_text = group.createChild("text")
      	.setText(text)
        .setColor(color[0], color[1], color[2], color[3])
	.setFontSize(12)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setRotation(0.0)
	.setTranslation(coords[0], coords[1]);
	}

}


var rotate = func (x, y, s, c) {

var x1 = c * x - s * y;
var y1 = s * x + c * y;

return [x1, y1];

}

# Space Shuttle HUD
# ---------------------------
# HUD class has dataprovider
# HUD is in two parts however for simplicity we will just have a single piece
# of glass (i.e. canvas) for the pilot / commander. 
# If necessary we can change this to have two huds (see the F-15/Nasal/HUD_main.nas for how this is done)
# ---------------------------
# Richard Harrison: 2015-09-09 : rjh@zaretto.com
# ---------------------------

var ht_xcf = 1024;
var ht_ycf = -1024;
var ht_xco = 0;
var ht_yco = -30;
var ht_debug = 0;

# paste into nasal console for debugging geometry
#SpaceShuttle.CommanderHUD.canvas._node.setValues({
#                           "name": "STS HUD",
#                    "size": [1024,1024], 
#                    "view": [296,216],
#                    "mipmapping": 1     
##                           "mipmapping": 0     
#  });
#SpaceShuttle.svg.setTranslation (-6.0, 37.0);

var pitch_offset = -4.0;
var velocity_vector_offset = -81.0;
var velocity_vector_factor = 23.0;
var pitch_offset2 = -60.0;
var pitch_factor = 20.1;
var alt_range_factor = (9317-191) / 100000; # alt tape size and max value.
var ias_range_factor = (694-191) / 1100;


# general appearance settings

var hud_color = [0.5, 1.0, 0.6, 0.75];
var hud_thickness = 0.6;


var STSHUD = {
	new : func (svgname, canvas_item,tran_x,tran_y){
		var obj = {parents : [STSHUD] };

        obj.canvas= canvas.new({
                "name": "STS HUD",
                    "size": [1024,1024], 
                    "view": [296,216],
                    "mipmapping": 1     
                    });                          
                          
        obj.canvas.addPlacement({"node": canvas_item});
        obj.canvas.setColorBackground(0.36, 1, 0.3, 0.00);


 
        obj.canvas._node.setValues({
                "name": "STS HUD",
                    "size": [1024,1024], 
                    "view": [296,216],                       
                    "mipmapping": 0     
                    });

       

	# the declutter levels
	obj.dc0 = obj.canvas.createGroup();
	obj.dc1 = obj.canvas.createGroup();
	obj.dc2 = obj.canvas.createGroup();
	obj.dc3 = obj.canvas.createGroup();


	# boresight

	var data = [[-6.0, 0.0, 0], [-6.0, 0.0, 1], [6.0,0.0,1], [0.0,-6.0,0.0], [0.0,6.0,1.0]];


	obj.dc3.boresight = obj.dc3.createChild("path", "plot_boresight")
        .setStrokeLineWidth(1.5 * hud_thickness)
	.setTranslation (120, 11)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc3.boresight);





	# flight director

	data = [[5.0, -5.0, 0], [5.0, 5.0, 1], [-5.0, 5.0, 1], [-5.0, -5.0, 1], [5.0, -5.0, 1]];
	append(data, [5.0, 0.0, 0]);
	append(data, [14.0, 0.0, 1]);
	append(data, [-5.0, 0.0, 0]);
	append(data, [-14.0, 0.0, 1]);	
	append(data, [0.0, -5.0, 0]);
	append(data, [0.0, -14.0, 1]);

	obj.dc2.fd = obj.dc2.createChild("path", "plot_fd")
        .setStrokeLineWidth(1.0 * hud_thickness)
	.setTranslation (121, 100)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc2.fd);

	# guidance diamond

	data = [[5.0, 0.0, 0], [0.0, 5.0, 1], [-5.0, 0.0, 1], [0.0, -5.0, 1], [5.0, 0.0, 1]];
	obj.dc2.diamond = obj.dc2.createChild("path", "plot_diamond")
        .setStrokeLineWidth(1.0 * hud_thickness)
	.setTranslation (121, 100)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc2.diamond);

	# velocity vector

	data = draw_circle (4, 20);
	append(data, [4.0, 0.0, 0]);
	append(data, [14.0, 0.0, 1]);
	append(data, [-4.0, 0.0, 0]);
	append(data, [-14.0, 0.0, 1]);	
	append(data, [0.0, -4.0, 0]);
	append(data, [0.0, -14.0, 1]);

	obj.dc2.v_vector = obj.dc2.createChild("path", "plot_vvec")
        .setStrokeLineWidth(1.5 * hud_thickness)
	.setTranslation (120, 11)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc2.v_vector);

	# guidance triangles

	data = [[17.0, 0.0, 0.0], [23.0, 2.0, 1.0], [23.0, -2.0, 1.0], [17.0, 0.0, 1.0], [-17.0, 0.0, 0.0], [-23.0, 2.0, 1.0], [-23.0, -2.0, 1.0], [-17.0, 0.0, 1.0]];
	obj.dc2.guidance = obj.dc2.createChild("path", "plot_guidance")
        .setStrokeLineWidth(0.6 * hud_thickness)
	.setTranslation (120, 11)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc2.guidance);

	# flare triangles

	obj.dc2.flare = obj.dc2.createChild("path", "plot_flare")
        .setStrokeLineWidth(0.6 * hud_thickness)
	.setTranslation (120, 11)
	.setVisible(0)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc2.flare);


	# Speedbrake ladder

	obj.dc2.sb_indicator = obj.dc2.createChild("group");

	data = SpaceShuttle.draw_ladder (40, 2, 0.18, 3, 0.09, 0, 0 , 1);
	obj.dc2.sb_indicator.scale1 = obj.dc2.sb_indicator.createChild("path", "plot_SBscale1")
        .setStrokeLineWidth(1.5 * hud_thickness)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc2.sb_indicator.scale1);

	data = SpaceShuttle.draw_ladder (40, 2, 0.18, 3, 0.09, 0, 1 , 1);
	obj.dc2.sb_indicator.scale2 = obj.dc2.sb_indicator.createChild("path", "plot_SBscale2")
        .setStrokeLineWidth(1.5 * hud_thickness)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc2.sb_indicator.scale2);

	data = SpaceShuttle.draw_tmarker_up_alt();
	obj.dc2.sb_indicator.triangle1 = obj.dc2.sb_indicator.createChild("path", "plot_SBtriangle1")
        .setStrokeLineWidth(1.0 * hud_thickness)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc2.sb_indicator.triangle1);
	obj.dc2.sb_indicator.triangle1.setScale(0.4, 0.8);


	data = SpaceShuttle.draw_tmarker_down_alt();
	obj.dc2.sb_indicator.triangle2 = obj.dc2.sb_indicator.createChild("path", "plot_SBtriangle2")
        .setStrokeLineWidth(1.0 * hud_thickness)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc2.sb_indicator.triangle2);
	obj.dc2.sb_indicator.triangle2.setScale(0.4, 0.8);

	obj.dc2.sb_indicator.setTranslation (160, 180);

	# guidance string

	obj.dc2.gstring = obj.dc2.createChild("text")
      	.setText("OGS")
        .setColor(hud_color)
	.setFontSize(10)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setRotation(0.0)
	.setTranslation(80.0, 180.0);

	# control string

	obj.dc2.cstring = obj.dc2.createChild("text")
      	.setText("CSS")
        .setColor(hud_color)
	.setFontSize(10)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setRotation(0.0)
	.setTranslation(60.0, 200.0);

	# airspeed alphanumerics

	obj.dc2.keas = obj.dc2.createChild("text")
      	.setText("300")
        .setColor(hud_color)
	.setFontSize(10)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setRotation(0.0)
	.setTranslation(50.0, 100.0);

	# altitude alphanumerics

	obj.dc2.altitude = obj.dc2.createChild("text")
      	.setText("13000")
        .setColor(hud_color)
	.setFontSize(10)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setRotation(0.0)
	.setTranslation(160.0, 100.0);

	# Nz alphanumerics

	obj.dc2.Nz = obj.dc2.createChild("text")
      	.setText("1.2G")
        .setColor(hud_color)
	.setFontSize(10)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setRotation(0.0)
	.setTranslation(90.0, 120.0);


	# horizon line

	obj.dc2.horizon = obj.dc2.createChild("group");

	data = [[40.0, 0.0, 0.0], [40.0, 0.0, 0.0], [80.0,0.0,1.0]];
	obj.dc2.horizon.line1 = obj.dc2.horizon.createChild("path", "plot_horizonL")
        .setStrokeLineWidth(1.0 * hud_thickness)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc2.horizon.line1);

	data = [[160.0, 0.0, 0.0], [160.0, 0.0, 0.0], [200.0,0.0,1.0]];
	obj.dc2.horizon.line1 = obj.dc2.horizon.createChild("path", "plot_horizonR")
        .setStrokeLineWidth(1.0 * hud_thickness)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc2.horizon.line1);

	# pitch ladder

	obj.dc1.pitch_ladder = obj.dc1.createChild("group");

	data = SpaceShuttle.draw_ladder (4050, 37, 0.005, 0, 0.09, 1, 0 , 0);

	obj.dc1.pitch_ladder.ladder1 = obj.dc1.pitch_ladder.createChild("path", "plot_PLadder1")
        .setStrokeLineWidth(1.5 * hud_thickness)
	.setTranslation(80.0, 0.0)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc1.pitch_ladder.ladder1);


	obj.dc1.pitch_ladder.ladder2 = obj.dc1.pitch_ladder.createChild("path", "plot_PLadder2")
        .setStrokeLineWidth(1.5 * hud_thickness)
	.setTranslation(140.0, 0.0)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc1.pitch_ladder.ladder2);


	data = SpaceShuttle.draw_ladder (2025, 19, 0.011, 0, 0.09, 1, 0 , 0);

	obj.dc1.pitch_ladder.ladder3 = obj.dc1.pitch_ladder.createChild("path", "plot_PLadder3")
        .setStrokeLineWidth(1.5 * hud_thickness)
	.setTranslation(57.75, -1012.5)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc1.pitch_ladder.ladder3);


	obj.dc1.pitch_ladder.ladder4 = obj.dc1.pitch_ladder.createChild("path", "plot_PLadder4")
        .setStrokeLineWidth(1.5 * hud_thickness)
	.setTranslation(160.25, -1012.5)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc1.pitch_ladder.ladder4);


	data = SpaceShuttle.draw_ladder (1912.5, 18, 0.006, 0, 0.09, 1, 0 , 0);

	obj.dc1.pitch_ladder.ladder5 = obj.dc1.pitch_ladder.createChild("path", "plot_PLadder5")
        .setStrokeLineWidth(1.5 * hud_thickness)
	.setTranslation(57.75, 1068.75)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc1.pitch_ladder.ladder5);


	obj.dc1.pitch_ladder.ladder6 = obj.dc1.pitch_ladder.createChild("path", "plot_PLadder6")
        .setStrokeLineWidth(1.5 * hud_thickness)
	.setTranslation(170.0, 1068.75)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc1.pitch_ladder.ladder6);


	data = SpaceShuttle.draw_ladder (1912.5, 18, 0.006, 0, 0.09, 1, 1 , 2);

	obj.dc1.pitch_ladder.ladder7 = obj.dc1.pitch_ladder.createChild("path", "plot_PLadder7")
        .setStrokeLineWidth(1.5 * hud_thickness)
	.setTranslation(57.75, 1069.25)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc1.pitch_ladder.ladder7);

	obj.dc1.pitch_ladder.ladder8 = obj.dc1.pitch_ladder.createChild("path", "plot_PLadder8")
        .setStrokeLineWidth(1.5 * hud_thickness)
	.setTranslation(182.0, 1069.25)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc1.pitch_ladder.ladder8);


	data = SpaceShuttle.draw_ladder (1912.5, 18, 0.006, 0, 0.09, 1, 0 , 2);

	obj.dc1.pitch_ladder.ladder9 = obj.dc1.pitch_ladder.createChild("path", "plot_PLadder9")
        .setStrokeLineWidth(1.5 * hud_thickness)
	.setTranslation(57.75, -1068.75)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc1.pitch_ladder.ladder9);

	obj.dc1.pitch_ladder.ladder10 = obj.dc1.pitch_ladder.createChild("path", "plot_PLadder10")
        .setStrokeLineWidth(1.5 * hud_thickness)
	.setTranslation(182.0, -1068.75)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc1.pitch_ladder.ladder10);



	for (var i=0; i< 18; i=i+1)
		{
		var label = sprintf("%d", i*5);
		var y = -i * 112.5 - 3.0;
		var coords = [170.0, y, 1];

		write_small_label_trans(obj.dc1.pitch_ladder, label, coords, hud_color);
		}

	for (var i=1; i< 18; i=i+1)
		{
		var label = "-"~sprintf("%d", i*5);
		var y = i * 112.5 - 3.0;
		var coords = [170.0, y, 1];

		write_small_label_trans(obj.dc1.pitch_ladder, label, coords, hud_color);
		}

	# airspeed tape

	obj.dc1.airspeed_tape = obj.dc1.createChild("group");

	data = SpaceShuttle.draw_ladder (3300, 45, 0.003, 0, 0.09, 1, 0 , 0);
	obj.dc1.airspeed_tape.ladder = obj.dc1.airspeed_tape.createChild("path", "plot_Atape")
        .setStrokeLineWidth(1.5 * hud_thickness)
	.setTranslation(30.0,1650.0) 
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc1.airspeed_tape.ladder);


	for (var i=1; i< 45; i=i+1)
		{
		var label = sprintf("%d", i*10);
		var y = i * 75.0 - 38.0;
		var coords = [40.0, y, 1];

		write_small_label_trans(obj.dc1.airspeed_tape, label, coords, hud_color);
		}

	var data = [[-8.0, 0.0, 0], [-8.0, 0.0, 1], [0.0,0.0,1]];
	obj.dc1.airspeed_marker = obj.dc1.createChild("path", "plot_airspeed_marker")
        .setStrokeLineWidth(3 * hud_thickness)
	.setTranslation(23.0, 98.0)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc1.airspeed_marker);

	# altitude tape

	obj.dc1.alt_tape = obj.dc1.createChild("group");

	data = SpaceShuttle.draw_ladder (6600, 89, 0.0015, 0, 0.09, 1, 0 , 0);
	obj.dc1.alt_tape.ladder = obj.dc1.alt_tape.createChild("path", "plot_Alttape")
        .setStrokeLineWidth(1.5 * hud_thickness)
	.setTranslation(190.0,-3300.0) 
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc1.alt_tape.ladder);

	for (var i=1; i< 90; i=i+1)
		{
		var label = sprintf("%d", i-1);
		var y = -i * 75.0 + 38.0;
		var coords = [190.0, y, 1];

		write_small_label_trans(obj.dc1.alt_tape, label, coords, hud_color);
		}

	data = [[0.0, 0.0, 0], [0.0, 0.0, 1], [8.0,0.0,1]];
	obj.dc1.alt_marker = obj.dc1.createChild("path", "plot_alt_marker")
        .setStrokeLineWidth(3 * hud_thickness)
	.setTranslation(203.0, 98.0)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc1.alt_marker);

	# runway symbology

	obj.dc0.rwy = obj.dc0.createChild("group");



	# connector line
	

	obj.dc0.rwy.plot = obj.dc0.rwy.createChild("group");

	obj.dc0.rwy.plot.line = obj.dc0.rwy.plot.createChild("path", "plot_connectorline")
		.setStrokeLineWidth(1.0 * hud_thickness)
		.setColor(hud_color)
		.moveTo(0.0,0.0)
		.lineTo(0.0,0.0);


	# aim point marker

	data = draw_circle (4, 20);

	obj.dc0.rwy.aimpoint_marker = obj.dc0.rwy.createChild("path", "plot_aimpoint_marker")
        .setStrokeLineWidth(1.0 * hud_thickness)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc0.rwy.aimpoint_marker);

	# threshold marker

	obj.dc0.rwy.threshold_marker = obj.dc0.rwy.createChild("path", "plot_threshold_marker")
        .setStrokeLineWidth(1.0 * hud_thickness)
        .setColor(hud_color);
	SpaceShuttle.pfd_segment_draw(data, obj.dc0.rwy.threshold_marker);


	# virtual runway
	

	obj.dc0.rwy.plot.outline = obj.dc0.rwy.createChild("path", "plot_outline")
		.setStrokeLineWidth(1.0 * hud_thickness)
		.setColor(hud_color)
		.moveTo(0.0,0.0)
		.lineTo(0.0,0.0)
		.lineTo(0.0,0.0)
		.lineTo(0.0,0.0);

	return obj;
	},
#
#
# get a text element from the SVG and set the font / sizing
    get_text : func(id, font, size, ratio)
    {
        var el = me.svg.getElementById(id);
        el.setFont(font).setFontSize(size,ratio);
        return el;
    },

#
#
# Get an element from the SVG; handle errors; and apply clip rectangle
# if found (by naming convention : addition of _clip to object name).
    get_element : func(id) {
        var el = me.svg.getElementById(id);
        if (el == nil)
        {
            print("Failed to locate ",id," in SVG");
            return el;
        }
        var clip_el = me.svg.getElementById(id ~ "_clip");
        if (clip_el != nil)
        {
            clip_el.setVisible(0);
            var tran_rect = clip_el.getTransformedBounds();

            var clip_rect = sprintf("rect(%d,%d, %d,%d)", 
                                   tran_rect[1], # 0 ys
                                   tran_rect[2],  # 1 xe
                                   tran_rect[3], # 2 ye
                                   tran_rect[0]); #3 xs
#            print(id," using clip element ",clip_rect, " trans(",tran_rect[0],",",tran_rect[1],"  ",tran_rect[2],",",tran_rect[3],")");
#   see line 621 of simgear/canvas/CanvasElement.cxx
#   not sure why the coordinates are in this order but are top,right,bottom,left (ys, xe, ye, xs)
            el.set("clip", clip_rect);
            el.set("clip-frame", canvas.Element.PARENT);
        }
        return el;
    },

#
#
#


    set_brightness : func (brightness) {



	var current_color = [hud_color[0], hud_color[1], hud_color[2], 0.2 + 0.7 * brightness];

	me.dc0.setColor(current_color);
	me.dc1.setColor(current_color);
	me.dc2.setColor(current_color);
	me.dc3.setColor(current_color);


    },


    update : func(hdp) {
        


var roll_rad = -hdp.roll*3.14159/180.0;
var s_roll = math.sin(roll_rad);
var c_roll = math.cos(roll_rad);  


# parallax correction


var current_x = getprop("/sim/current-view/x-offset-m");
var current_y = getprop("/sim/current-view/y-offset-m");
var current_z = getprop("/sim/current-view/z-offset-m");

var dx = me.view[0] - current_x;
var dy = me.view[1] - current_y;

me.dc0.setTranslation(dx * -1550.0, dy * 1550.0);
me.dc1.setTranslation(dx * -1550.0, dy * 1550.0);
me.dc2.setTranslation(dx * -1550.0, dy * 1550.0);
me.dc3.setTranslation(dx * -1550.0, dy * 1550.0);






var declutter_level = getprop("/fdm/jsbsim/systems/hud/declutter-level");


# Declutter level 1

if (declutter_level > 3)
	{me.dc3.setVisible(0);}
else
	{me.dc3.setVisible(1);}


# Declutter level 2

if (declutter_level < 3)
	{
	me.dc2.setVisible(1);
	
	# velocity vector

	if (SpaceShuttle.TAEM_guidance_phase > 3)
		{
		me.dc2.v_vector.setVisible(1);
		me.dc2.v_vector.setTranslation(hdp.VV_x+121.0, hdp.VV_y * velocity_vector_factor+12.0);
		}
	else
		{
		me.dc2.v_vector.setVisible(0);
		}

	# flight director

	if (SpaceShuttle.TAEM_guidance_phase > 3)
		{
		me.dc2.fd.setVisible(0);
		}
	else
		{
		me.dc2.fd.setVisible(1);
		}


	# guidance triangles

	if (SpaceShuttle.HUD_data_set.MLS_acquired == 1)
		{
		me.dc2.guidance.setVisible(1);
		me.dc2.guidance.setTranslation(hdp.VV_x+121.0, (hdp.pitch + hdp.g_vangle) * 22.5 + 13.0);
		}
	else
		{
		me.dc2.guidance.setVisible(0);
		}


	# flare triangles

	if (SpaceShuttle.TAEM_guidance_phase == 4)
		{
		me.dc2.flare.setVisible(1);
		me.dc2.flare.setTranslation(hdp.VV_x+121.0, (hdp.pitch +  hdp.g_vangle + hdp.g_fangle) * 22.5 + 13.0);
		}
	else
		{
		me.dc2.flare.setVisible(0);
		}



	# speedbrake indicators


	me.dc2.sb_indicator.triangle1.setTranslation(-20.0 + 40.0 * hdp.sb_cmd, 0.0);
	me.dc2.sb_indicator.triangle2.setTranslation(-20.0 + 40.0 * hdp.sb_pos, 0.0);

	# guidance string

	me.dc2.gstring.setText(SpaceShuttle.TAEM_guidance_string);

	# control string
	
	me.dc2.cstring.setText(hdp.control);

	# KEAS alphanumerics

	me.dc2.keas.setVisible(1);
	me.dc2.keas.setText(sprintf("%3.0f", hdp.IAS));

	# TAEM specifics - Nz alphanumerics and guidance diamond

	if (SpaceShuttle.TAEM_guidance_phase < 4)
		{
		me.dc2.Nz.setVisible(1);
		me.dc2.Nz.setText(sprintf("%1.1f", hdp.Nz)~"G");


		me.dc2.diamond.setTranslation(121 + hdp.bank_error, 100 + hdp.pitch_error);

		}
	else
		{
		me.dc2.Nz.setVisible(0);
		me.dc2.diamond.setVisible(0);
		me.dc2.diamond.setTranslation(121 , 100 );
		}

	# Altitude alphanumerics

	me.dc2.altitude.setVisible(1);

	var alt_string = "";
		
	if (hdp.altitude_ft > 100000.0)
		{
		alt_string = "";
		}
	else if (hdp.altitude_ft > 1000.0) 
		{
		alt_string = sprintf("%d", int (hdp.altitude_ft/100) * 100);
		}
	else if (hdp.altitude_ft > 100.0)
		{
		alt_string = sprintf("%d", int (hdp.altitude_ft/10) * 10);
		}
	else if (hdp.altitude_ft > 10.0)
		{
		alt_string = sprintf("%d", int (hdp.altitude_ft));
		}


	me.dc2.altitude.setText(alt_string~hdp.radar_flag);

	# Horizon line

	me.dc2.horizon.setCenter(125.0, 0.0);
	me.dc2.horizon.setRotation(roll_rad);
	me.dc2.horizon.setVisible(1);

	var tr_mag = hdp.pitch * 22.5 + 13;
	var tr_x = s_roll * tr_mag;
	var tr_y = c_roll * tr_mag;
	me.dc2.horizon.setTranslation(-tr_x, tr_y);

	}
else
	{
	me.dc2.setVisible(0);
	}

# Declutter level 1


if (declutter_level < 2)
	{
	me.dc1.setVisible(1);

	# Pitch ladder
	me.dc2.horizon.setVisible(0);

	me.dc1.pitch_ladder.setCenter(120.0, 0.0);
	me.dc1.pitch_ladder.setRotation(roll_rad);

	var tr_mag = hdp.pitch * 22.5 + 13;
	var tr_x = s_roll * tr_mag;
	var tr_y = c_roll * tr_mag;

	me.dc1.pitch_ladder.setTranslation(-tr_x, tr_y);


	# airspeed tape
	me.dc2.keas.setVisible(0);
	me.dc1.airspeed_tape.setTranslation(0.0,-hdp.IAS * 7.5 + 140.0);
	
	# altitude tape

	me.dc2.altitude.setVisible(0);
	me.dc1.alt_tape.setTranslation(0.0, hdp.altitude_ft * 0.075 + 140.0);
	}
else
	{
	me.dc1.setVisible(0);
	}


# declutter level 0

if (declutter_level < 1)
	{

	if ((SpaceShuttle.TAEM_guidance_available == 1) and (SpaceShuttle.TAEM_guidance_phase < 5) )
		{
		me.dc0.rwy.setVisible(1);

		# aim point marker
		var x1 = hdp.hAngle * 26.0;
		var y1 =  (hdp.pitch + hdp.vAngle) * 22.5;
		var vec = rotate(x1, y1, s_roll, c_roll);
		x1 = vec[0] + 115.0; y1 = vec[1] + 13.0;
		me.dc0.rwy.aimpoint_marker.setTranslation(x1, y1);

		# threshold marker
		var x2 = hdp.hTAngle * 26.0;
		var y2 = (hdp.pitch + hdp.vTAngle) * 22.5;
		vec = rotate(x2, y2, s_roll, c_roll);
		x2 = vec[0] + 115.0; y2 = vec[1] + 13.0;
		me.dc0.rwy.threshold_marker.setTranslation(x2, y2);

		# connecting line
		var cmds = [canvas.Path.VG_MOVE_TO, canvas.Path.VG_LINE_TO];
		var ldata = [x1,y1, x2,y2];
		me.dc0.rwy.plot.line.setData(cmds, ldata);


		# virtual runway

		var xnl = hdp.nl_hangle * 26.0 ;
		var ynl =  (hdp.pitch + hdp.nl_vangle) * 22.5;
		vec = rotate(xnl, ynl, s_roll, c_roll);
		xnl = vec[0] + 115.0; ynl = vec[1] + 13.0;

		var xnr = hdp.nr_hangle * 26.0;
		var ynr =  (hdp.pitch + hdp.nr_vangle) * 22.5;
		vec = rotate(xnr, ynr, s_roll, c_roll);
		xnr = vec[0] + 115.0; ynr = vec[1] + 13.0;

		var xfl = hdp.fl_hangle * 26.0;
		var yfl =  (hdp.pitch + hdp.fl_vangle) * 22.5;
		vec = rotate(xfl, yfl, s_roll, c_roll);
		xfl = vec[0] + 115.0; yfl = vec[1] + 13.0;

		var xfr = hdp.fr_hangle * 26.0;
		var yfr =  (hdp.pitch + hdp.fr_vangle) * 22.5;
		vec = rotate(xfr, yfr, s_roll, c_roll);
		xfr = vec[0] + 115.0; yfr = vec[1] + 13.0;
		
		var cmds = [canvas.Path.VG_MOVE_TO, canvas.Path.VG_LINE_TO, canvas.Path.VG_LINE_TO, canvas.Path.VG_LINE_TO, canvas.Path.VG_LINE_TO];
		ldata = [xnl,ynl, xnr,ynr, xfr, yfr, xfl, yfl, xnl, ynl];
		me.dc0.rwy.plot.outline.setData(cmds, ldata);

		}
	else
		{
		me.dc0.rwy.setVisible(0);
		}

	}
else
	{
	me.dc0.rwy.setVisible(0);
	}




     },
    list: [],
};

#
#
# connects the properties to the HUD; did this really to save a few cycles for the two panes on the F-15
var HUD_DataProvider  = {
	new : func (){
		var obj = {parents : [HUD_DataProvider] };

		# store references to the node we poll 

		obj.nd_ref_IAS = props.globals.getNode("/fdm/jsbsim/velocities/ve-kts", 1);
		obj.nd_ref_Nz = props.globals.getNode("/fdm/jsbsim/accelerations/Nz", 1);
		obj.nd_ref_alpha = props.globals.getNode("/fdm/jsbsim/aero/alpha-deg", 1);
		obj.nd_ref_beta = props.globals.getNode("/fdm/jsbsim/aero/beta-deg", 1);
		obj.nd_ref_radar_alt_available = props.globals.getNode("/fdm/jsbsim/systems/navigation/radar-alt-available", 1);
		obj.nd_ref_alt_agl_ft = props.globals.getNode("/position/altitude-agl-ft", 1);
		obj.nd_ref_alt =  props.globals.getNode("/fdm/jsbsim/systems/navigation/state-vector/altitude-ft", 1);
		obj.nd_ref_pitch = props.globals.getNode("/fdm/jsbsim/systems/navigation/state-vector/pitch-deg", 1);
		obj.nd_ref_roll = props.globals.getNode("/fdm/jsbsim/systems/navigation/state-vector/roll-deg", 1);
		obj.nd_ref_channel_pitch =  props.globals.getNode("/fdm/jsbsim/systems/ap/automatic-pitch-control", 1);
		obj.nd_ref_channel_roll =  props.globals.getNode("/fdm/jsbsim/systems/ap/automatic-roll-control", 1);
		obj.nd_ref_sb_pos =  props.globals.getNode("/fdm/jsbsim/fcs/speedbrake-pos-norm", 1);
		obj.nd_ref_sb_cmd =  props.globals.getNode("/fdm/jsbsim/systems/fcs/speedbrake-cmd-norm", 1);
		obj.nd_ref_bank_error =  props.globals.getNode("/fdm/jsbsim/systems/ap/taem/bank-error", 1);
		obj.nd_ref_vspeed_error =  props.globals.getNode("/fdm/jsbsim/systems/ap/taem/vspeed-error", 1);

        return obj;
    },
    update : func() {



	me.IAS = me.nd_ref_IAS.getValue();
	me.Nz = me.nd_ref_Nz.getValue();
	me.alpha = me.nd_ref_alpha.getValue();
	me.beta = me.nd_ref_beta.getValue();


	# if available, use radar altitude below 5000 ft


	me.radar_alt_available = me.nd_ref_radar_alt_available.getValue();
	me.alt_agl_ft = me.nd_ref_alt_agl_ft.getValue();

	me.radar_flag = "";

	if ((me.radar_alt_available == 1) and (me.alt_agl_ft < 5000.0))
		{
		me.altitude_ft = me.alt_agl_ft - 12.0;
		me.radar_flag = "R";
		}	
	else
		{
		me.altitude_ft =  me.nd_ref_alt.getValue();
		}



	me.pitch = me.nd_ref_pitch.getValue();
	me.roll = me.nd_ref_roll.getValue();

	me.vAngle = SpaceShuttle.HUD_data_set.vangle_aim;
	me.vTAngle = SpaceShuttle.HUD_data_set.vangle_threshold;
	me.hAngle  = SpaceShuttle.HUD_data_set.hangle_aim;
	me.hTAngle = SpaceShuttle.HUD_data_set.hangle_threshold;

	me.nl_vangle = SpaceShuttle.HUD_data_set.vangle_nl;
	me.nl_hangle = SpaceShuttle.HUD_data_set.hangle_nl;

	me.nr_vangle = SpaceShuttle.HUD_data_set.vangle_nr;
	me.nr_hangle = SpaceShuttle.HUD_data_set.hangle_nr;

	me.fl_vangle = SpaceShuttle.HUD_data_set.vangle_fl;
	me.fl_hangle = SpaceShuttle.HUD_data_set.hangle_fl;

	me.fr_vangle = SpaceShuttle.HUD_data_set.vangle_fr;
	me.fr_hangle = SpaceShuttle.HUD_data_set.hangle_fr;

	me.g_vangle = SpaceShuttle.HUD_data_set.vangle_guidance;
	me.g_fangle = (me.altitude_ft - 2000.0)/ 250.0;


	var channel_pitch = me.nd_ref_channel_pitch.getValue();
	var channel_roll = me.nd_ref_channel_roll.getValue();

	#me.sb_pos = getprop("/fdm/jsbsim/fcs/speedbrake-pos-norm");
	#me.sb_cmd = getprop("/fdm/jsbsim/systems/fcs/speedbrake-cmd-norm");

	me.sb_pos = me.nd_ref_sb_pos.getValue();
	me.sb_cmd = me.nd_ref_sb_cmd.getValue();

	#me.bank_error = getprop("/fdm/jsbsim/systems/ap/taem/bank-error") * 50.0;
	#me.pitch_error = getprop("/fdm/jsbsim/systems/ap/taem/vspeed-error") * 50.0;

	me.bank_error = me.nd_ref_bank_error.getValue() * 50.0;
	me.pitch_error = me.nd_ref_vspeed_error.getValue() * 50.0;

	me.bank_error = SpaceShuttle.clamp(me.bank_error, -30.0, 30.0);
	me.pitch_error = SpaceShuttle.clamp(me.pitch_error, -30.0, 30.0);

	me.control = "CSS";

	if ((channel_pitch == 1) and (channel_roll == 1))
		{me.control = "AUTO";}
	else if ((channel_pitch == 1) or (channel_roll == 1))
		{me.control = "CSS/AUTO";}

        me.roll_rad = 0.0;
        me.VV_x = me.beta*26.0; # adjust for view
        me.VV_y = (me.alpha); # adjust for view

    },
};

var hud_data_provider = HUD_DataProvider.new();

var CommanderHUD = STSHUD.new("Nasal/HUD/HUD.svg", "HUDImage1", 0,0);
var PilotHUD = STSHUD.new("Nasal/HUD/HUD.svg", "HUDImage2", 0, 0);

CommanderHUD.view = [-0.6, -0.13, -11.6];
CommanderHUD.id = "CDR";
CommanderHUD.set_brightness(1);


PilotHUD.view =  [0.7, -0.13, -11.7];
PilotHUD.id = "PLT";
PilotHUD.set_brightness(1);


var updateHUD = func ()
{  

    var cdr_pwr = getprop("/fdm/jsbsim/systems/electrical/hud/cmd-pwr-switch");
    var plt_pwr = getprop("/fdm/jsbsim/systems/electrical/hud/plt-pwr-switch");

   if ((cdr_pwr == 1) or (plt_pwr == 1))
	{hud_data_provider.update();}
   else
	{return;}

   if (cdr_pwr == 1)
    	{CommanderHUD.update(hud_data_provider);}
   if (plt_pwr == 1)
    	{PilotHUD.update(hud_data_provider);}
}

# update displays at nominal 5hz
var hudrtExec_loop = func
{
    updateHUD();
    settimer(hudrtExec_loop, 0.05);	 # 0.2 is 5hz
}
    
hudrtExec_loop();
