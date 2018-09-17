# canvas dialogs for the Space Shuttle
# Thorsten Renk 2018



io.include("canvas_widgets.nas");
		


# dialog definitions ##############################################################



io.include("cdlg_propellant.nas");
io.include("cdlg_temperature.nas");
io.include("cdlg_keypad.nas");
io.include("cdlg_oms_propellant.nas");






var cdlg_mdu_clone = {
	
	clickspots: [],

	init: func (index) {

		me.index = index;

		if (index == 0) {me.string = "CDR1";}
		else if (index == 1) {me.string = "CDR2";}
		else if (index == 2) {me.string = "CRT1";}
		else if (index == 3) {me.string = "MFD1";}

		var window = canvas.Window.new([512,512],"dialog").set("title", me.string);

		var canvas_clone = SpaceShuttle.MDU_array[index].PFD._canvas;
		window.setCanvas(canvas_clone);

		#me.root = canvas_clone.createGroup();

		me.cs_button1 = cdlg_clickspot.new(70, 495,25,15, 0, "rect");
		append(me.clickspots, me.cs_button1);

		me.cs_button2 = cdlg_clickspot.new(145, 495,25,15, 0, "rect");
		append(me.clickspots, me.cs_button2);

		me.cs_button3 = cdlg_clickspot.new(220, 495,25,15, 0, "rect");
		append(me.clickspots, me.cs_button3);

		me.cs_button4 = cdlg_clickspot.new(295, 495,25,15, 0, "rect");
		append(me.clickspots, me.cs_button4);

		me.cs_button5 = cdlg_clickspot.new(370, 495,25,15, 0, "rect");
		append(me.clickspots, me.cs_button5);

		me.cs_button6 = cdlg_clickspot.new(450, 495,25,15, 0, "rect");
		append(me.clickspots, me.cs_button6);

		canvas_clone.addEventListener("click", func(e) {
		me.check_clickspots(e.clientX, e.clientY, "click");
		  });



	},

	check_clickspots: func (click_x, click_y, event) {


		var flag = 0;			
		for (var i =0; i< size(me.clickspots); i=i+1)
			{

			flag = me.clickspots[i].check_event(click_x, click_y);
			if (flag == 1) {break;}
			
			}
			if (flag == 1)
				{
				print ("Click event for spot ", i);

				me.clickspot_events(i+1, event);
				}

	},

	clickspot_events: func (system, event) {

		if (event == "click")
			{
			
			setprop("/sim/model/shuttle/controls/PFD/button-pressed"~(me.index+1), system);
		settimer ( func {
			setprop("/sim/model/shuttle/controls/PFD/button-pressed"~(me.index+1), 0);
			}, 0.5);

			}		
	},


};


# the old style function is just a wrapper now

var create_MDU_clone = func (index) {



cdlg_mdu_clone.init(index);

return;


}
