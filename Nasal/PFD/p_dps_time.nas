#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_dps_time
# Description: the time utility page
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_dps_time = func(device)
{
    var p_dps_time = device.addPage("CRTTime", "p_dps_time");
    
    
    p_dps_time.gmt_delta =  device.svg.getElementById("p_dps_time_gmt_delta");
    p_dps_time.met_delta =  device.svg.getElementById("p_dps_time_met_delta");
    
    p_dps_time.sel_gmt =  device.svg.getElementById("p_dps_time_sel_gmt");
    p_dps_time.sel_met =  device.svg.getElementById("p_dps_time_sel_met");
    
    p_dps_time.mtu_acc1 =  device.svg.getElementById("p_dps_time_mtu_acc1");
    p_dps_time.mtu_acc2 =  device.svg.getElementById("p_dps_time_mtu_acc2");
    p_dps_time.mtu_acc3 =  device.svg.getElementById("p_dps_time_mtu_acc3");
    p_dps_time.gpc_acc =  device.svg.getElementById("p_dps_time_gpc_acc");
    
    p_dps_time.tone1 =  device.svg.getElementById("p_dps_time_tone1");
    p_dps_time.tone2 =  device.svg.getElementById("p_dps_time_tone2");
    p_dps_time.tone3 =  device.svg.getElementById("p_dps_time_tone3");
    
    p_dps_time.gpc1 =  device.svg.getElementById("p_dps_time_gpc1");
    p_dps_time.gpc2 =  device.svg.getElementById("p_dps_time_gpc2");
    p_dps_time.gpc3 =  device.svg.getElementById("p_dps_time_gpc3");
    p_dps_time.gpc4 =  device.svg.getElementById("p_dps_time_gpc4");
    p_dps_time.gpc5 =  device.svg.getElementById("p_dps_time_gpc5");
    
    p_dps_time.duration =  device.svg.getElementById("p_dps_time_duration");
    
    p_dps_time.crttimer_start_at =  device.svg.getElementById("p_dps_time_crttimer_start_at");
    p_dps_time.crttimer_count_to =  device.svg.getElementById("p_dps_time_crttimer_count_to");
    
    
    
    p_dps_time.crttimer_set1 = device.svg.getElementById("p_dps_time_crttimer_set1");
    
    p_dps_time.ondisplay = func
    {
        device.DPS_menu_title.setText(sprintf("%s","TIME"));
        device.MEDS_menu_title.setText(sprintf("%s","       DPS MENU"));
    
        var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");
    
        var ops_string = major_mode~"1/002/";
        device.DPS_menu_ops.setText(sprintf("%s",ops_string));
    
    # zero unusued items
    
        p_dps_time.gpc1.setText(sprintf("" )); 
        p_dps_time.gpc2.setText(sprintf("" )); 
        p_dps_time.gpc3.setText(sprintf("" )); 
        p_dps_time.gpc4.setText(sprintf("" )); 
        p_dps_time.gpc5.setText(sprintf("" )); 
    
    }
    
    p_dps_time.update = func
    {
    
        var time_selected = getprop("/fdm/jsbsim/systems/timer/time-display-flag");
    
        var symbol = "";
        if (time_selected == 0) {symbol = "*";}
        p_dps_time.sel_gmt.setText(sprintf("%s", symbol )); 
    
        var symbol = "";
        if (time_selected == 1) {symbol = "*";}
        p_dps_time.sel_met.setText(sprintf("%s", symbol )); 
    
    
        p_dps_time.gmt_delta.setText(sprintf("%s", getprop("/fdm/jsbsim/systems/timer/delta-GMT-string") )); 
        p_dps_time.met_delta.setText(sprintf("%s", getprop("/fdm/jsbsim/systems/timer/delta-MET-string") )); 
    
        var GMT_string = getprop("/fdm/jsbsim/systems/timer/GMT-string");
    
        p_dps_time.mtu_acc1.setText(sprintf("%s", GMT_string )); 
        p_dps_time.mtu_acc2.setText(sprintf("%s", GMT_string )); 
        p_dps_time.mtu_acc3.setText(sprintf("%s", GMT_string )); 
        p_dps_time.gpc_acc.setText(sprintf("%s", GMT_string )); 
    
        p_dps_time.tone1.setText(sprintf("%s", getprop("/fdm/jsbsim/systems/timer/timer-MET-1-string") )); 
        p_dps_time.tone2.setText(sprintf("%s", getprop("/fdm/jsbsim/systems/timer/timer-MET-2-string") )); 
        p_dps_time.tone3.setText(sprintf("%s", getprop("/fdm/jsbsim/systems/timer/timer-CRT-string") )); 
    
        p_dps_time.crttimer_set1.setText(sprintf("%s", getprop("/fdm/jsbsim/systems/timer/crt-timer-string") )); 
    
        p_dps_time.crttimer_start_at.setText(sprintf("%s", getprop("/fdm/jsbsim/systems/timer/start-at-string") )); 
        p_dps_time.crttimer_count_to.setText(sprintf("%s", getprop("/fdm/jsbsim/systems/timer/count-to-string") )); 
    
    
        p_dps_time.duration.setText(sprintf("%d", getprop("/fdm/jsbsim/systems/timer/time-tone-duration") )); 
    
        device.update_common_DPS();
    
    
    }
    
    
    
    
    return p_dps_time;
}
