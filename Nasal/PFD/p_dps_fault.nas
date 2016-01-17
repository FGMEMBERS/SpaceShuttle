#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_fault
# Description: the generic CRT fault page
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_dps_fault = func(device)
{
    var p_dps_fault = device.addPage("CRTFault", "p_dps_fault");
    
    p_dps_fault.string1 = device.svg.getElementById("p_dps_fault_string1");
    p_dps_fault.string2 = device.svg.getElementById("p_dps_fault_string2");
    p_dps_fault.string3 = device.svg.getElementById("p_dps_fault_string3");
    p_dps_fault.string4 = device.svg.getElementById("p_dps_fault_string4");
    p_dps_fault.string5 = device.svg.getElementById("p_dps_fault_string5");
    p_dps_fault.string6 = device.svg.getElementById("p_dps_fault_string6");
    p_dps_fault.string7 = device.svg.getElementById("p_dps_fault_string7");
    p_dps_fault.string8 = device.svg.getElementById("p_dps_fault_string8");
    p_dps_fault.string9 = device.svg.getElementById("p_dps_fault_string9");
    p_dps_fault.string10 = device.svg.getElementById("p_dps_fault_string10");
    p_dps_fault.string11 = device.svg.getElementById("p_dps_fault_string11");
    p_dps_fault.string12 = device.svg.getElementById("p_dps_fault_string12");
    p_dps_fault.string13 = device.svg.getElementById("p_dps_fault_string13");
    p_dps_fault.string14 = device.svg.getElementById("p_dps_fault_string14");
    p_dps_fault.string15 = device.svg.getElementById("p_dps_fault_string15");
    
    p_dps_fault.ondisplay = func
    {
        device.DPS_menu_title.setText("FAULT");
        device.MEDS_menu_title.setText("       DPS MENU");
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/   /099";
        device.DPS_menu_ops.setText(ops_string);
    }
    
    p_dps_fault.update = func
    {
    
        p_dps_fault.string1.setText( SpaceShuttle.cws_message_array_long[0]);
        p_dps_fault.string2.setText( SpaceShuttle.cws_message_array_long[1]);
        p_dps_fault.string3.setText( SpaceShuttle.cws_message_array_long[2]);
        p_dps_fault.string4.setText( SpaceShuttle.cws_message_array_long[3]);
        p_dps_fault.string5.setText( SpaceShuttle.cws_message_array_long[4]);
        p_dps_fault.string6.setText( SpaceShuttle.cws_message_array_long[5]);
        p_dps_fault.string7.setText( SpaceShuttle.cws_message_array_long[6]);
        p_dps_fault.string8.setText( SpaceShuttle.cws_message_array_long[7]);
        p_dps_fault.string9.setText( SpaceShuttle.cws_message_array_long[8]);
        p_dps_fault.string10.setText( SpaceShuttle.cws_message_array_long[9]);
        p_dps_fault.string11.setText( SpaceShuttle.cws_message_array_long[10]);
        p_dps_fault.string12.setText( SpaceShuttle.cws_message_array_long[11]);
        p_dps_fault.string13.setText( SpaceShuttle.cws_message_array_long[12]);
        p_dps_fault.string14.setText( SpaceShuttle.cws_message_array_long[13]);
        p_dps_fault.string15.setText( SpaceShuttle.cws_message_array_long[14]);
    
        device.update_common_DPS();
    }
    
    
    
    return p_dps_fault;
}
