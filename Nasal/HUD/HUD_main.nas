# Space Shuttle HUD, ref 2.7-21 based on F-15
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

var pitch_offset = 12;
var pitch_factor = 19.8;
var pitch_factor_2 = pitch_factor * 180.0 / 3.14159;
var alt_range_factor = (9317-191) / 100000; # alt tape size and max value.
var ias_range_factor = (694-191) / 1100;

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

# Create a group for the parsed elements
        obj.svg = obj.canvas.createGroup();
 
# Parse an SVG file and add the parsed elements to the given group
        print("HUD [",canvas_item,"] Parse SVG ",canvas.parsesvg(obj.svg, svgname));

        obj.svg.setTranslation (-6.0, 37.0);
#        obj.svg.setTranslation (-20.0, 37.0);

#        print("HUD INIT");
 
        obj.canvas._node.setValues({
                "name": "STS HUD",
                    "size": [1024,1024], 
                    "view": [296,216],                       
                    "mipmapping": 0     
                    });
        obj.svg.setTranslation (tran_x,tran_y);
        obj.ladder = obj.get_element("ladder");
        obj.VV = obj.get_element("VelocityVector");
        obj.heading_tape = obj.get_element("heading-scale");
        obj.roll_pointer = obj.get_element("roll-pointer");
        obj.alt_range = obj.get_element("alt_range");
        obj.ias_range = obj.get_element("ias_range");

        obj.window1 = obj.get_text("window1", "condensed.txf",9,1.4);
        obj.window2 = obj.get_text("window2", "condensed.txf",9,1.4);
        obj.window3 = obj.get_text("window3", "condensed.txf",9,1.4);
        obj.window4 = obj.get_text("window4", "condensed.txf",9,1.4);
        obj.window5 = obj.get_text("window5", "condensed.txf",9,1.4);
        obj.window6 = obj.get_text("window6", "condensed.txf",9,1.4);
        obj.window7 = obj.get_text("window7", "condensed.txf",9,1.4);
        obj.window8 = obj.get_text("window8", "condensed.txf",9,1.4);

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
    update : func(hdp) {
        var  roll_rad = -hdp.roll*3.14159/180.0;
  
#pitch ladder
        me.ladder.setTranslation (0.0, hdp.pitch * pitch_factor+pitch_offset);                                           
        me.ladder.setCenter (118,830 - hdp.pitch * pitch_factor-pitch_offset);
        me.ladder.setRotation (roll_rad);
  
# velocity vector
        me.VV.setTranslation (hdp.VV_x, hdp.VV_y * pitch_factor +pitch_offset);

#Altitude
        me.alt_range.setTranslation(0, hdp.measured_altitude * alt_range_factor);

# IAS
        me.ias_range.setTranslation(0, hdp.IAS * ias_range_factor);
     
        if (hdp.range_rate != nil)
        {
            me.window1.setVisible(1);
            me.window1.setText("");
        }
        else
            me.window1.setVisible(0);
  
        me.window7.setText(hdp.window7);

#        me.window8.setText(sprintf("%02d NOWS", hdp.Nz*10));
#        me.window8.setText(sprintf("%02d %02d", hdp.Nz*10, getprop("/fdm/jsbsim/systems/cadc/ows-maximum-g")*10));

#heading tape
        if (hdp.heading < 180)
            me.heading_tape_position = -hdp.heading*54/10;
        else
            me.heading_tape_position = (360-hdp.heading)*54/10;
     
        me.heading_tape.setTranslation (me.heading_tape_position,0);
  
#roll pointer
#roll_pointer.setCenter (118,-50);
        me.roll_pointer.setRotation (roll_rad);

     },
    list: [],
};

#
#
# connects the properties to the HUD; did this really to save a few cycles for the two panes on the F-15
var HUD_DataProvider  = {
	new : func (){
		var obj = {parents : [HUD_DataProvider] };

        return obj;
    },
    update : func() {
        #me.IAS = getprop("/velocities/airspeed-kt");
		me.IAS = getprop("/fdm/jsbsim/velocities/ve-kts");
        me.Nz = getprop("sim/model/spaceshuttle/instrumentation/g-meter/g-max-mooving-average");
        me.WOW = getprop ("/gear/gear[1]/wow") or getprop ("/gear/gear[2]/wow");
        me.alpha = getprop ("fdm/jsbsim/aero/alpha-deg");
        me.beta = getprop ("fdm/jsbsim/aero/beta-deg");
        me.altitude_ft =  getprop ("/position/altitude-ft");
        me.heading =  getprop("/orientation/heading-deg");
        me.mach = getprop ("/velocities/mach");
        me.measured_altitude = getprop("/instrumentation/altimeter/indicated-altitude-ft");
        if (me.measured_altitude == nil)
            me.measured_altitude = me.altitude_ft;
        me.pitch =  getprop ("orientation/pitch-deg");
        me.roll =  getprop ("orientation/roll-deg");
        me.speed = getprop("/fdm/jsbsim/velocities/vt-fps");
        me.v = getprop("/fdm/jsbsim/velocities/v-fps");
        me.w = getprop("/fdm/jsbsim/velocities/w-fps");
        me.range_rate = "0";

        if(getprop("controls/gear/gear-down") or me.alpha > 20)
            me.window7 = sprintf("AOA %d",me.alpha);
        else
            me.window7 = sprintf(" %1.3f",me.mach);

        me.roll_rad = 0.0;
        me.VV_x = -me.beta*10; # adjust for view
        me.VV_y = (me.alpha); # adjust for view

    },
};

var hud_data_provider = HUD_DataProvider.new();

var CommanderHUD = STSHUD.new("Nasal/HUD/HUD.svg", "HUDImage1", 0,0);
var PilotHUD = STSHUD.new("Nasal/HUD/HUD.svg", "HUDImage2", 0, 0);

var updateHUD = func ()
{  
    hud_data_provider.update();
    CommanderHUD.update(hud_data_provider);
    PilotHUD.update(hud_data_provider);
}

# update displays at nominal 5hz
var hudrtExec_loop = func
{
    updateHUD();
    settimer(hudrtExec_loop, 0.05);	 # 0.2 is 5hz
}
    
hudrtExec_loop();
