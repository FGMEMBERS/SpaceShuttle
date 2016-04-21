#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_helper
# Description: helper functions converting properties to display items
#      Author: Thorsten Renk, 2015
#---------------------------------------

var valve_status_to_string = func (status)
{
    if (status == 0) {return "CL";}
    else {return "OP";}
}

var jet_conditions_to_string = func (con1, con2)
{
if (con1 < 1.0) {return "OFF";} 
else if (con1 > 1.0) {return "ON";}
else if (con2 < 1.0) {return "LK";} 
else {return "";}


}

var jet_status_to_string = func (status)
{
    if (status == 1) {return "OFF";}
    else if (status == 2) {return "ON";}
    if (status == 3) {return "LK";}
    else {return "";}
}

var elevon_norm = func (angle)
{
    if (angle < 0.0) {return 100.0 * angle/40.0;}
    else {return 100.0 * angle/28.0;}
}


var K_to_F = func (T)
{
    return T * 9.0/5.0 - 459.67;
}

var wsb_ctrl_to_string = func (status)
{
    if (status == 1) {return "A/B";}
    else {return "OFF";}
}

var wsb_vlv_to_string = func (status)
{
    if (status > 0.0) {return " OP";}
    else {return "BYP";}
}

var latch_stat_to_string = func (status)
{
    if (status == 0.0) {return "CL";}
    else if (status == 1.0) {return "OP";}
    else {return "";}
}


var door_stat_to_string = func (status, latch_fwd_status, latch_aft_status)
{

    var latch_status = 1;

    if ((latch_fwd_status == 0) and (latch_aft_status == 0))
    {latch_status =0;}

    if ((status == 0) and (latch_status == 0))
    {return "CL";}
    else if ((status == 0) and (latch_status == 1))
    {return "RDY";}
    else if ((status == 1) and (latch_status == 1))
    {return "OP";}
    else
    {return "";}
	
}

var latch_stat_to_microsw = func (status)
{

    if (status == 0.0) {return "1100";}
    else if (status == 1.0) {return "0011";}
    else {return "0000";}
}

var door_stat_to_microsw = func (status, door_status)
{
    if ((status == 0) and (door_status == 0))
    {return "11110";}
    else if ((status > 0) and (door_status == 0))
    {return "01110";}
    else if ((status == 1) and (door_status == 1))
    {return "00001";}
    else
    {return "00000";}
}

var ret_latch_to_microsw = func (status)
{
    if (status == 0) {return "11/00";}
    else if (status == 1) {return "00/11";}
    else {return "00/00";}

}

var jet_option = func (flag)
{

    if (flag == 0) {return "ALL";}
    else if (flag == 1) {return "TAIL";}
    else {return "NOSE";}

}

var set_tape = func (handle, value, offset) {
    handle.setScale(1.0, value);
    handle.setTranslation(0.0, (1.0-value) * offset);
}


var get_filter_quality_pos = func {

var angle_sensor_selection = getprop("/fdm/jsbsim/systems/rendezvous/angle-sensor-selection");

var filter_quality_pos = 1.0;
	
if (angle_sensor_selection == 0)
	{filter_quality_pos  = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-star-tracker/quality-pos");}
else if (angle_sensor_selection == 1)
	{filter_quality_pos  = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-rr/quality-pos");}
else if (angle_sensor_selection == 2)
	{filter_quality_pos  = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-coas/quality-pos");}

return filter_quality_pos;

}


var get_filter_quality_v = func {

var angle_sensor_selection = getprop("/fdm/jsbsim/systems/rendezvous/angle-sensor-selection");

var filter_quality_v = 1.0;
	
if (angle_sensor_selection == 0)
	{filter_quality_v  = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-star-tracker/quality-v");}
else if (angle_sensor_selection == 1)
	{filter_quality_v  = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-rr/quality-v");}
else if (angle_sensor_selection == 2)
	{filter_quality_v  = getprop("/fdm/jsbsim/systems/navigation/state-vector/error-coas/quality-v");}

return filter_quality_v;

}


