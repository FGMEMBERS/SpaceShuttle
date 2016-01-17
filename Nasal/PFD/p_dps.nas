#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps
# Description: the dps dispatching page - this isn't a real page
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_dps = func(device)
{
    var p_dps = device.addPage("CRTDefault", "p_dps");
    
    p_dps.blink = 1;
    
    p_dps.update = func
    {
    
print("DPS update ",device.designation);
    # signal that we have a dps page
    
        device.dps_page_flag = 1;
    
    # query the IDP for the major function
    
        var port = device.port_selected;
        var major_function = SpaceShuttle.idp_array[port-1].get_major_function();
    
        if (major_function == 1)
        {
            var ops = getprop("/fdm/jsbsim/systems/dps/ops");
            var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
            if (ops == 1)
    		    device.selectPage(device.p_ascent);
            else if (ops == 2)
    		    device.selectPage(device.p_dps_univ_ptg);
            else if ( ops == 3)
    		{ 
                if ((major_mode == 301) or (major_mode == 302) or (major_mode == 303))
    			{
                    device.selectPage(device.p_dps_mnvr);
    			}
                else if (major_mode == 304)
    			{
                    device.selectPage(device.p_entry);
    			}	
                else
    			{
                    device.selectPage(device.p_vert_sit);
    			}	
    		}
            else 
    		    device.selectPage(device.p_main);
    
    	}
        else if (major_function == 2)
    	{
            device.selectPage(device.p_dps_pl_bay);
    	}
    }
    return p_dps;
}
