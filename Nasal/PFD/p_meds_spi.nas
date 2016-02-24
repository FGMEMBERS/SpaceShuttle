#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_meds_spi
# Description: the SPI MEDS page
#      Author: Gijs de Rooy, Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_meds_spi = func(device)
{
    var p_meds_spi = device.addPage("MEDSSpi", "p_meds_spi");

    p_meds_spi.marker_sb_cmd = device.svg.getElementById("p_meds_spi_marker_sb_cmd"); 
    p_meds_spi.sb_cmd = device.svg.getElementById("p_meds_spi_sb_cmd"); 

    p_meds_spi.marker_sb_act = device.svg.getElementById("p_meds_spi_marker_sb_act"); 
    p_meds_spi.sb_act = device.svg.getElementById("p_meds_spi_sb_act"); 

    p_meds_spi.marker_rudder_deg = device.svg.getElementById("p_meds_spi_marker_aileron_deg"); 
    p_meds_spi.marker_aileron_deg = device.svg.getElementById("p_meds_spi_marker_aileron_fine"); 

    p_meds_spi.marker_body_flap = device.svg.getElementById("p_meds_spi_marker_body_flap"); 

    p_meds_spi.marker_right_inboard = device.svg.getElementById("p_meds_spi_marker_right_inboard"); 
    p_meds_spi.marker_right_outboard = device.svg.getElementById("p_meds_spi_marker_right_outboard"); 

    p_meds_spi.marker_left_inboard = device.svg.getElementById("p_meds_spi_marker_left_inboard"); 
    p_meds_spi.marker_left_outboard = device.svg.getElementById("p_meds_spi_marker_left_outboard"); 

    p_meds_spi.menu_item = device.svg.getElementById("MI_3"); 
    p_meds_spi.menu_item_frame = device.svg.getElementById("MI_3_frame");


    p_meds_spi.ondisplay = func
    {
    
        device.set_DPS_off();
        device.MEDS_menu_title.setText("      SUBSYSTEM MENU");
	p_meds_spi.menu_item.setColor(1.0, 1.0, 1.0);
	p_meds_spi.menu_item_frame.setColor(1.0, 1.0, 1.0);



    }
    
    p_meds_spi.update = func
    {
	# speedbrake	

	var scale_factor_h = 100./63.;

	var sb_pos_norm = getprop("/fdm/jsbsim/fcs/speedbrake-pos-norm");
	var sb_cmd_norm = getprop("/controls/shuttle/speedbrake");

	p_meds_spi.sb_cmd.setText(sprintf("%3.0f", sb_cmd_norm * 100.0));
 	p_meds_spi.sb_act.setText(sprintf("%3.0f", sb_pos_norm * 100.0));

	p_meds_spi.marker_sb_act.setTranslation(sb_pos_norm * 100.0 * scale_factor_h,0);
	p_meds_spi.marker_sb_cmd.setTranslation(sb_cmd_norm * 100.0 * scale_factor_h,0);

	# elevons
	var scale_factor_v = 50.0/16.0;

	var left_outboard = getprop("/fdm/jsbsim/fcs/outboard-elevon-left-pos-deg");
	var left_inboard = getprop("/fdm/jsbsim/fcs/inboard-elevon-left-pos-deg");

	var right_outboard = getprop("/fdm/jsbsim/fcs/outboard-elevon-right-pos-deg");
	var right_inboard = getprop("/fdm/jsbsim/fcs/inboard-elevon-right-pos-deg");

	if (left_inboard < -35.0) {left_inboard = -35.0;}
	if (left_outboard < -35.0) {left_outboard = -35.0;}

	if (right_inboard < -35.0) {right_inboard = -35.0;}
	if (right_outboard < -35.0) {right_outboard = -35.0;}

	if (left_inboard > 20.0) {left_inboard = 20.0;}
	if (left_outboard > 20.0) {left_outboard = 20.0;}

	if (right_inboard > 20.0) {right_inboard = 20.0;}
	if (right_outboard > 20.0) {right_outboard = 20.0;}

	p_meds_spi.marker_left_outboard.setTranslation(0.0, left_outboard * scale_factor_v);
	p_meds_spi.marker_left_inboard.setTranslation(0.0, left_inboard * scale_factor_v);

	p_meds_spi.marker_right_outboard.setTranslation(0.0, right_outboard * scale_factor_v);
	p_meds_spi.marker_right_inboard.setTranslation(0.0, right_inboard * scale_factor_v);

	# body flap

	var scale_factor_b = 100.0/58.0;

	var body_flap_deg = 57.2974 * getprop("/fdm/jsbsim/fcs/bodyflap-pos-rad");
	var body_flap_pct = (body_flap_deg + 18.04868) * 100.0/ 36.097362;

	p_meds_spi.marker_body_flap.setTranslation (0.0, body_flap_pct * scale_factor_b);

	# Aileron

	var scale_factor_a = 50.0/3.1;

	var aileron_deg = 57.2974 * getprop("/fdm/jsbsim/fcs/left-aileron-pos-rad");
	if (aileron_deg < -5.0) {aileron_deg = -5.0;}	
	if (aileron_deg > 5.0) {aileron_deg = 5.0;}	

	p_meds_spi.marker_aileron_deg.setTranslation(aileron_deg * scale_factor_a, 0.0);

	# Rudder

	var scale_factor_r = 50.0/20.0;

	var rudder_deg = 57.2974 * getprop("/fdm/jsbsim/fcs/rudder-pos-rad");
	p_meds_spi.marker_rudder_deg.setTranslation(rudder_deg * scale_factor_r, 0.0);

    }

    p_meds_spi.offdisplay = func
    {
    
        p_meds_spi.menu_item.setColor(meds_r, meds_g, meds_b);
	p_meds_spi.menu_item_frame.setColor(meds_r, meds_g, meds_b);
    }
    
    
    
    return p_meds_spi;
}
