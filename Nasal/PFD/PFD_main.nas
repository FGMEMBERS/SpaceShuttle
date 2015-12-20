# Space Shuttle PFD
# ---------------------------
# PFD has many pages; the classes here support multiple pages, menu
# operation and the update loop.
# Based on F-15 MPCD
# ---------------------------
# Richard Harrison: 2015-01-23 : rjh@zaretto.com
# addition of DPS pages (old CRT style) Thorsten Renk 2015
# ---------------------------

# pages available are
# * p_ascent (OPS 101, 102, 103)
# * p_entry (OPS 304)
# * p_vert_sit (OPS 305)
# * p_dps_mnvr (OPS 104, 105, 106, 202, 301, 302, 303)
# * p_pds_univ_ptg (OPS 201)
# * p_dps_antenna (SM OPS 202)
# * p_dps_time (SPEC 2)
# * p_dps_dap (SPEC 20)
# * p_dps_override (SPEC 51)
# * p_dps_pl_bay (SM OPS 202, SPEC 63)
# * p_dps_sys_summ (DISP 18)
# * p_dps_sys_summ2 (DISP 19)
# * p_dps_sm_sys_summ2 (DISP 79)
# * p_dps_apu_hyd (DISP 86)
# * p_dps_fault (DISP 99)

var num_menu_buttons = 6; # Number of menu buttons; starting from the bottom left then right, then top, then left.

#
# Include all of the page definitions
io.include("p_helper.nas");

io.include("p_pfd.nas");
io.include("p_main.nas");
io.include("p_dps.nas");
io.include("p_dps_fault.nas");
io.include("p_dps_sys_summ.nas");
io.include("p_dps_sys_summ2.nas");
io.include("p_ascent.nas");
io.include("p_entry.nas");
io.include("p_vert_sit.nas");
io.include("p_dps_mnvr.nas");
io.include("p_dps_univ_ptg.nas");
io.include("p_dps_apu_hyd.nas");
io.include("p_dps_pl_bay.nas");
io.include("p_dps_override.nas");
io.include("p_dps_time.nas");
io.include("p_dps_dap.nas");
io.include("p_dps_sm_sys_summ2.nas");
io.include("p_dps_antenna.nas");

io.include("MFD_Generic.nas");

var MDU_Device =
{
#
# create new MEDS device. This is the main interface (from our code) to the MEDS device
# Each MEDS device will contain the underlying PFD device object, the SVG, and the canvas
# Parameters
# - designation - Flightdeck Label on the device
# - model_element - name of the 3d model element that is to be used for drawing
# - primary_port - 
# - secondary_port - 
# - selected_port
    new : func(designation, model_element, primary_port, secondary_port, selected_port, model_index)
    {
        var obj = {parents : [MDU_Device] };
        obj.designation = designation;
        obj.model_element = model_element;
        var dev_canvas= canvas.new({
                "name": designation,
                    "size": [1758,1884], 
                    "view": [512,512],                       
                    "mipmapping": 1     
                    });                          

        dev_canvas.addPlacement({"node": model_element});
        dev_canvas.setColorBackground(0,0,0, 0);
# Create a group for the parsed elements
        obj.PFDsvg = dev_canvas.createGroup();
        var pres = canvas.parsesvg(obj.PFDsvg, "Nasal/PFD/PFD.svg");
# Parse an SVG file and add the parsed elements to the given group
        printf("MEDS : %s Load SVG %s",designation,pres);
        obj.PFDsvg.setTranslation (20, 30);
#
# create the object that will control all of this
        obj.PFD = PFD_Device.new(obj.PFDsvg, num_menu_buttons, "MI_");
        obj.PFD._canvas = dev_canvas;
        obj.PFD.primary = primary_port;
        obj.PFD.secondary = secondary_port;
        obj.PFD.port_selected = selected_port;
        obj.PFD.dps_page_flag = 0;
        obj.PFD.designation = designation;
        obj.mdu_device_status = 1;
        obj.model_index = model_index; # numeric index (1 to 9, left to right) used to connect the buttons in the cockpit to the display
        obj.PFD.set_DPS_off = func
        {
            me.DPS_menu_time.setText("");
            me.DPS_menu_crt_time.setText("");
            me.DPS_menu_ops.setText("");
            me.DPS_menu_title.setText("");
            me.DPS_menu_fault_line.setText("");
            me.DPS_menu_scratch_line.setText("");
            me.DPS_menu_gpc_driver.setText("");
#setprop("/fdm/jsbsim/systems/dps/dps-page-flag", 0);
        };

        obj.PFD.update_common_DPS = func
        {
            var time_string = "";

            if (getprop("/fdm/jsbsim/systems/timer/time-display-flag") == 0)
            {
                time_string = "000/"~getprop("/sim/time/gmt-string");
            }
            else
            {
                time_string = getprop("/fdm/jsbsim/systems/timer/MET-string");
            }


            var port = me.port_selected;
            var idp_index = port - 1;

            me.DPS_menu_time.setText(time_string);
            me.DPS_menu_crt_time.setText(getprop("/fdm/jsbsim/systems/timer/CRT-string"));
            me.DPS_menu_scratch_line.setText(getprop("/fdm/jsbsim/systems/dps/command-string", idp_index));
            me.DPS_menu_gpc_driver.setText("1");

            var fault_string = getprop("/fdm/jsbsim/systems/dps/error-string");

            if (SpaceShuttle.cws_last_message_acknowledge == 1)
            {
                if (me.DPS_menu_blink == 0) {fault_string = "";}
            }
            me.DPS_menu_fault_line.setText(fault_string);

            if (me.DPS_menu_blink == 1) {me.DPS_menu_blink = 0;}
            else {me.DPS_menu_blink = 1;}

#setprop("/fdm/jsbsim/systems/dps/dps-page-flag", 1);
        };
        obj.addPages();
        return obj;
    },

    addPages : func
    {
        me.PFD.p_pfd = PFD_addpage_p_pfd(me.PFD);
        me.PFD.p_main = PFD_addpage_p_main(me.PFD);
        me.PFD.p_dps = PFD_addpage_p_dps(me.PFD);
        me.PFD.p_dps_fault = PFD_addpage_p_dps_fault(me.PFD);
        me.PFD.p_dps_sys_summ = PFD_addpage_p_dps_sys_summ(me.PFD);
        me.PFD.p_dps_sys_summ2 = PFD_addpage_p_dps_sys_summ2(me.PFD);
        me.PFD.p_ascent = PFD_addpage_p_ascent(me.PFD);
        me.PFD.p_entry = PFD_addpage_p_entry(me.PFD);
        me.PFD.p_vert_sit = PFD_addpage_p_vert_sit(me.PFD);
        me.PFD.p_dps_mnvr = PFD_addpage_p_dps_mnvr(me.PFD);
        me.PFD.p_dps_univ_ptg = PFD_addpage_p_dps_univ_ptg(me.PFD);
        me.PFD.p_dps_apu_hyd = PFD_addpage_p_dps_apu_hyd(me.PFD);
        me.PFD.p_dps_pl_bay = PFD_addpage_p_dps_pl_bay(me.PFD);
        me.PFD.p_dps_override = PFD_addpage_p_dps_override(me.PFD);
        me.PFD.p_dps_time = PFD_addpage_p_dps_time(me.PFD);
        me.PFD.p_dps_dap = PFD_addpage_p_dps_dap(me.PFD);
        me.PFD.p_dps_sm_sys_summ2 = PFD_addpage_p_dps_sm_sys_summ2(me.PFD);
        me.PFD.p_dps_antenna = PFD_addpage_p_dps_antenna(me.PFD);

        setlistener("sim/model/shuttle/controls/PFD/button-pressed"~me.model_index, 
                    func(v)
                    {
                        if (v != nil)
                        {
                            if (v.getValue())
                                me.pfd_button_pushed = v.getValue();
                            else
                            {
                                printf("%s: Button %d",me.designation, me.pfd_button_pushed);
                                me.PFD.notifyButton(me.pfd_button_pushed);
                                me.pfd_button_pushed = 0;
                            }
                        }
                    });

# Set listener on the PFD mode button; this could be an on off switch or by convention
# it will also act as brightness; so 0 is off and anything greater is brightness.
# ranges are not pre-defined; it is probably sensible to use 0..10 as an brightness rather
# than 0..1 as a floating value; but that's just my view.
        setlistener("sim/model/shuttle/controls/PFD/mode"~me.model_index, func(v)
                    {
                        if (v != nil)
                        {
                            me.mdu_device_status = v.getValue();
                            print("MDU Mode ",me.designation," ",me.mdu_device_status);
                            if (!me.mdu_device_status)
                                me.PFDsvg.setVisible(0);
                            else
                                me.PFDsvg.setVisible(1);
                        }
                    });

        me.PFD.pfd_button_pushed = 0;

# SVG access to all common elements in DPS and MEDS page structures

        me.PFD.MEDS_menu_title = me.PFD.svg.getElementById("MEDS_title");

        me.PFD.DPS_menu_time = me.PFD.svg.getElementById("dps_menu_time");
        me.PFD.DPS_menu_crt_time = me.PFD.svg.getElementById("dps_menu_crt_time");
        me.PFD.DPS_menu_ops = me.PFD.svg.getElementById("dps_menu_OPS");
        me.PFD.DPS_menu_title = me.PFD.svg.getElementById("dps_menu_title");
        me.PFD.DPS_menu_fault_line = me.PFD.svg.getElementById("dps_menu_fault_line");
        me.PFD.DPS_menu_scratch_line = me.PFD.svg.getElementById("dps_menu_scratch_line");
        me.PFD.DPS_menu_gpc_driver = me.PFD.svg.getElementById("dps_menu_gpc_driver");
        me.PFD.DPS_menu_blink = 1;

        me.PFD.nom_traj_plot = me.PFD._canvas.createGroup();
        me.PFD.limit1_traj_plot = me.PFD._canvas.createGroup();
        me.PFD.limit2_traj_plot = me.PFD._canvas.createGroup();

        me.setupMenus();
    },

    # Add the menus to each page. 
    setupMenus : func
    {
        me.PFD.p_ascent.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_ascent.addMenuItem(4, "MSG RST", me.PFD.p_ascent);
        me.PFD.p_ascent.addMenuItem(5, "MSG ACK", me.PFD.p_ascent);
    
        me.PFD.p_entry.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_entry.addMenuItem(4, "MSG RST", me.PFD.p_entry);
        me.PFD.p_entry.addMenuItem(5, "MSG ACK", me.PFD.p_entry);
    
    
        me.PFD.p_vert_sit.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_vert_sit.addMenuItem(4, "MSG RST", me.PFD.p_vert_sit);
        me.PFD.p_vert_sit.addMenuItem(5, "MSG ACK", me.PFD.p_vert_sit);
    
        me.PFD.p_pfd.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_pfd.addMenuItem(1, "A/E", me.PFD.p_pfd);
        me.PFD.p_pfd.addMenuItem(2, "ORBIT", me.PFD.p_pfd);
        me.PFD.p_pfd.addMenuItem(3, "DATA", me.PFD.p_pfd);
        me.PFD.p_pfd.addMenuItem(4, "MSG RST", me.PFD.p_pfd);
        me.PFD.p_pfd.addMenuItem(5, "MSG ACK", me.PFD.p_pfd);
    
        me.PFD.p_main.addMenuItem(0, "FLT", me.PFD.p_pfd);
        me.PFD.p_main.addMenuItem(1, "SUB", me.PFD.p_main);
        me.PFD.p_main.addMenuItem(2, "DPS", me.PFD.p_dps);
        me.PFD.p_main.addMenuItem(3, "MAINT", me.PFD.p_dps_antenna);
        me.PFD.p_main.addMenuItem(4, "MSG RST", me.PFD.p_main);
        me.PFD.p_main.addMenuItem(5, "MSG ACK", me.PFD.p_main);
    
        me.PFD.p_dps_fault.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_fault.addMenuItem(4, "MSG RST", me.PFD.p_dps_fault);
        me.PFD.p_dps_fault.addMenuItem(5, "MSG ACK", me.PFD.p_dps_fault);
    
        me.PFD.p_dps_univ_ptg.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_univ_ptg.addMenuItem(4, "MSG RST", me.PFD.p_dps_univ_ptg);
        me.PFD.p_dps_univ_ptg.addMenuItem(5, "MSG ACK", me.PFD.p_dps_univ_ptg);
    
        me.PFD.p_dps_mnvr.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_mnvr.addMenuItem(4, "MSG RST", me.PFD.p_dps_mnvr);
        me.PFD.p_dps_mnvr.addMenuItem(5, "MSG ACK", me.PFD.p_dps_mnvr);
    
        me.PFD.p_dps_sys_summ.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_sys_summ.addMenuItem(4, "MSG RST", me.PFD.p_dps_sys_summ);
        me.PFD.p_dps_sys_summ.addMenuItem(5, "MSG ACK", me.PFD.p_dps_sys_summ);
    
        me.PFD.p_dps_sys_summ2.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_sys_summ2.addMenuItem(4, "MSG RST", me.PFD.p_dps_sys_summ2);
        me.PFD.p_dps_sys_summ2.addMenuItem(5, "MSG ACK", me.PFD.p_dps_sys_summ2);
    
        me.PFD.p_dps_apu_hyd.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_apu_hyd.addMenuItem(4, "MSG RST", me.PFD.p_dps_apu_hyd);
        me.PFD.p_dps_apu_hyd.addMenuItem(5, "MSG ACK", me.PFD.p_dps_apu_hyd);
    
        me.PFD.p_dps_antenna.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_antenna.addMenuItem(4, "MSG RST", me.PFD.p_dps_antenna);
        me.PFD.p_dps_antenna.addMenuItem(5, "MSG ACK", me.PFD.p_dps_antenna);

        me.PFD.p_dps_pl_bay.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_pl_bay.addMenuItem(4, "MSG RST", me.PFD.p_dps_pl_bay);
        me.PFD.p_dps_pl_bay.addMenuItem(5, "MSG ACK", me.PFD.p_dps_pl_bay);
    
        me.PFD.p_dps_override.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_override.addMenuItem(4, "MSG RST", me.PFD.p_dps_override);
        me.PFD.p_dps_override.addMenuItem(5, "MSG ACK", me.PFD.p_dps_override);
    
        me.PFD.p_dps_time.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_time.addMenuItem(4, "MSG RST", me.PFD.p_dps_time);
        me.PFD.p_dps_time.addMenuItem(5, "MSG ACK", me.PFD.p_dps_time);
    
        me.PFD.p_dps_dap.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_dap.addMenuItem(4, "MSG RST", me.PFD.p_dps_dap);
        me.PFD.p_dps_dap.addMenuItem(5, "MSG ACK", me.PFD.p_dps_dap);
    
        me.PFD.p_dps_sm_sys_summ2.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_sm_sys_summ2.addMenuItem(4, "MSG RST", me.PFD.p_dps_sm_sys_summ2);
        me.PFD.p_dps_sm_sys_summ2.addMenuItem(5, "MSG ACK", me.PFD.p_dps_sm_sys_summ2);
    },

    update : func
    {
        if(me.mdu_device_status)
            me.PFD.update();
    },

    switchPorts : func 
    {
    	if (me.PFD.port_selected == me.PFD.primary)
            me.PFD.port_selected = me.PFD.secondary;
        else
            me.PFD.port_selected = me.PFD.primary;
    },
};

# the PFD object really should be called an MDU - we attach the port connections to the IDPs and the selection

var MDU_array = [];

var MEDS_CDR1 =  MDU_Device.new("CDR1", "DisplayL1", 3, 1, 3, 1);
var MEDS_CDR2 =  MDU_Device.new("CDR2", "DisplayL2", 1, 2, 1, 2);
var MEDS_CRT1 =  MDU_Device.new("CRT1", "DisplayC1", 1, 1, 1, 3);
var MEDS_MFD1 =  MDU_Device.new("MFD1", "DisplayC2", 2, 3, 2, 4);
var MEDS_CRT3 =  MDU_Device.new("CRT3", "DisplayC3", 3, 3, 3, 5);
var MEDS_CRT2 =  MDU_Device.new("CRT2", "DisplayC4", 2, 2, 2, 6);
var MEDS_MFD2 =  MDU_Device.new("MFD2", "DisplayC5", 1, 3, 1, 7);
var MEDS_PLT1 =  MDU_Device.new("PLT1", "DisplayR1", 2, 3, 2, 8);
var MEDS_PLT2 =  MDU_Device.new("PLT2", "DisplayR2", 3, 2, 3, 9);

# all generated devices should be appended to the MDU array, then the parsers can do the appropriate
# OPS transitions etc. on all MDUs connected to a given IDP

append(MDU_array, MEDS_CDR1);
append(MDU_array, MEDS_CDR2);
append(MDU_array, MEDS_CRT1);
append(MDU_array, MEDS_MFD1);
append(MDU_array, MEDS_CRT3);
append(MDU_array, MEDS_CRT2);
append(MDU_array, MEDS_MFD2);
append(MDU_array, MEDS_PLT1);
append(MDU_array, MEDS_PLT2);


#    
# Select the appropriate default page on each device.
MEDS_CDR1.PFD.selectPage(MEDS_CDR1.PFD.p_pfd);
MEDS_CDR1.PFD.dps_page_flag = 0;
MEDS_CDR2.PFD.selectPage(MEDS_CDR2.PFD.p_pfd);
MEDS_CDR2.PFD.dps_page_flag = 0;
MEDS_CRT1.PFD.selectPage(MEDS_CRT1.PFD.p_dps);
MEDS_CRT1.PFD.dps_page_flag = 1;
MEDS_MFD1.PFD.selectPage(MEDS_MFD1.PFD.p_pfd);
MEDS_MFD1.PFD.dps_page_flag = 0;
MEDS_CRT3.PFD.selectPage(MEDS_CRT3.PFD.p_dps);
MEDS_CRT3.PFD.dps_page_flag = 1;
MEDS_CRT2.PFD.selectPage(MEDS_CRT2.PFD.p_dps);
MEDS_CRT2.PFD.dps_page_flag = 1;
MEDS_MFD2.PFD.selectPage(MEDS_MFD2.PFD.p_pfd);
MEDS_MFD2.PFD.dps_page_flag = 0;
MEDS_PLT1.PFD.selectPage(MEDS_PLT1.PFD.p_pfd);
MEDS_PLT1.PFD.dps_page_flag = 0;
MEDS_PLT2.PFD.selectPage(MEDS_PLT2.PFD.p_pfd);
MEDS_PLT2.dps_page_flag = 0;
    
var frame_device_update_id = 0;


# update displays at nominal 5hz
var rtExec_loop = func
{
# logic to not update all displays per frame.
# this could be written many ways; e.g. to update say 1 device from each side per each timer event
# (so we could do 3 displays per timer event)
# or, as is currently done just to iterate through the devices and just do one per frame.

    if (frame_device_update_id >= size(MDU_array))
        frame_device_update_id = 0;

    if (frame_device_update_id < size(MDU_array))
        MDU_array[frame_device_update_id].update();

    frame_device_update_id = frame_device_update_id+1;

    settimer(rtExec_loop, 0.1);	 # 0.1 is 10hz - so each device will be updated once per second. This may need revising upwards
}
    
rtExec_loop();
