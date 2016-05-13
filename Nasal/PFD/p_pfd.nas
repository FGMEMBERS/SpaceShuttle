#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_pfd
# Description: PFD page
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_pfd = func(device)
{
    var p_pfd = device.addPage("PFD", "p_pfd");
    
    #
    #
    # device page update
    p_pfd.group = device.svg.getElementById("p_pfd");
    p_pfd.group.setColor(dps_r, dps_g, dps_b);

    p_pfd.keas = device.svg.getElementById("p_pfd_keas");
    p_pfd.beta = device.svg.getElementById("p_pfd_beta");
    
    p_pfd.ondisplay = func
    {
        device.set_DPS_off();
        device.dps_page_flag = 0;
        device.MEDS_menu_title.setText("FLIGHT INSTRUMENT MENU");
    }
    
    
    p_pfd.update = func
    {
        # these really need to be deleted when leaving the ascent page - do we have
        # an 'upon exit' functionality here
    
       
        p_pfd.beta.setText(sprintf("%5.1f",getprop("fdm/jsbsim/aero/beta-deg")));
        p_pfd.keas.setText(sprintf("%5.0f",getprop("velocities/airspeed-kt")));
    };
    
    return p_pfd;
}
