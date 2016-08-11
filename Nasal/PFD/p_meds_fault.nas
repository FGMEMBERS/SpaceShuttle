#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_meds_fault
# Description: the IDP FAULT SUMMARY MEDS page
#      Author: Thorsten Renk, 2016
#---------------------------------------

var PFD_addpage_p_meds_fault = func(device)
{
    var p_meds_fault = device.addPage("MEDSFault", "p_meds_fault");

    p_meds_fault.messages = [];

    append(p_meds_fault.messages, device.svg.getElementById("p_meds_fault_message1"));
    append(p_meds_fault.messages, device.svg.getElementById("p_meds_fault_message2"));
    append(p_meds_fault.messages, device.svg.getElementById("p_meds_fault_message3"));
    append(p_meds_fault.messages, device.svg.getElementById("p_meds_fault_message4"));
    append(p_meds_fault.messages, device.svg.getElementById("p_meds_fault_message5"));
    append(p_meds_fault.messages, device.svg.getElementById("p_meds_fault_message6"));
    append(p_meds_fault.messages, device.svg.getElementById("p_meds_fault_message7"));
    append(p_meds_fault.messages, device.svg.getElementById("p_meds_fault_message8"));
    append(p_meds_fault.messages, device.svg.getElementById("p_meds_fault_message9"));
    append(p_meds_fault.messages, device.svg.getElementById("p_meds_fault_message10"));
    append(p_meds_fault.messages, device.svg.getElementById("p_meds_fault_message11"));
    append(p_meds_fault.messages, device.svg.getElementById("p_meds_fault_message12"));
    append(p_meds_fault.messages, device.svg.getElementById("p_meds_fault_message13"));
    append(p_meds_fault.messages, device.svg.getElementById("p_meds_fault_message14"));
    append(p_meds_fault.messages, device.svg.getElementById("p_meds_fault_message15"));

    p_meds_fault.ondisplay = func
    {
    
        device.set_DPS_off();
	var commanding_idp = device.port_selected;
        device.MEDS_menu_title.setText("    IDP"~commanding_idp~" FAULT SUMMARY");
		


    }
    
    p_meds_fault.update = func
    {
	var commanding_idp = device.port_selected;
	var idp_index = commanding_idp - 1;


	for (var i=0; i<15; i=i+1)
		{
		p_meds_fault.messages[i].setText(SpaceShuttle.idp_array[idp_index].fault_array[i]);

		}			


	

    }

    p_meds_fault.offdisplay = func
    {

    }
    
    
    
    return p_meds_fault;
}
