# Space Shuttle PFD
# ---------------------------
# PFD has many pages; the classes here support multiple pages, menu
# operation and the update loop.
# Based on F-15 MPCD
# ---------------------------
# Richard Harrison: 2015-01-23 : rjh@zaretto.com
# addition of DPS pages (old CRT style) Thorsten Renk 2015-2016
# ---------------------------

# pages available are
# * p_ascent (OPS 101, 102, 103)
# * p_entry (OPS 304)
# * p_vert_sit (OPS 305)
# * p_dps_mnvr (OPS 104, 105, 106, 202, 301, 302, 303)
# * p_pds_univ_ptg (OPS 201)
# * p_dps_antenna (SM OPS 202)
# * p_dps_rtls (OPS 601)
# * p_dps_time (SPEC 2)
# * p_dps_dap (SPEC 20)
# * p_dps_strk (SPEC 22)
# * p_dps_rcs (SPEC 23)
# * p_dps_rm_orbit (SPEC 25)
# * p_dps_rel_nav (SPEC 33)
# * p_dps_hsit (SPEC 50)
# * p_dps_override (SPEC 51)
# * p_dps_pl_bay (SM OPS 202, SPEC 63)
# * p_dps_sys_summ (DISP 18)
# * p_dps_sys_summ2 (DISP 19)
# * p_dps_electric (DISP 67)
# * p_dps_cryo (DISP 68)
# * p_dps_fc (DISP 69)
# * p_dps_sm_sys_summ1 (DISP 78)
# * p_dps_sm_sys_summ2 (DISP 79)
# * p_dps_apu_hyd (DISP 86)
# * p_dps_pl_ret (DISP 97)
# * p_dps_fault (DISP 99)

# * p_meds_oms_mps (MEDS OMS/MPS)
# * p_meds_apu	(MEDS APU/HYD)
# * p_meds_spi	(MEDS SPI)

# color definitions

# default CRT-style green for the DPS pages

var dps_r = getprop("/sim/model/shuttle/lighting/dps-red");
var dps_g = getprop("/sim/model/shuttle/lighting/dps-green");
var dps_b = getprop("/sim/model/shuttle/lighting/dps-blue");

# the MEDS menu is in a light blue

var meds_r = 0.2;
var meds_g = 0.8;
var meds_b = 0.8;

var num_menu_buttons = 6; # Number of menu buttons; starting from the bottom left then right, then top, then left.

#
# Include all of the page definitions
io.include("p_helper.nas");

io.include("p_pfd.nas");
io.include("p_main.nas");
io.include("p_subsys.nas");
io.include("p_dps.nas");
io.include("p_dps_fault.nas");
io.include("p_dps_sys_summ.nas");
io.include("p_dps_sys_summ2.nas");
io.include("p_ascent.nas");
io.include("p_dps_rtls.nas");
io.include("p_entry.nas");
io.include("p_vert_sit.nas");
io.include("p_dps_mnvr.nas");
io.include("p_dps_univ_ptg.nas");
io.include("p_dps_apu_hyd.nas");
io.include("p_dps_pl_bay.nas");
io.include("p_dps_rel_nav.nas");
io.include("p_dps_override.nas");
io.include("p_dps_time.nas");
io.include("p_dps_dap.nas");
io.include("p_dps_sm_sys_summ1.nas");
io.include("p_dps_sm_sys_summ2.nas");
io.include("p_dps_antenna.nas");
io.include("p_dps_fc.nas");
io.include("p_dps_strk.nas");
io.include("p_dps_pl_ret.nas");
io.include("p_dps_electric.nas");
io.include("p_dps_cryo.nas");
io.include("p_dps_hsit.nas");
io.include("p_dps_rm_orbit.nas");
io.include("p_dps_rcs.nas");

io.include("p_meds_oms_mps.nas");
io.include("p_meds_apu.nas");
io.include("p_meds_spi.nas");

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
	    me.DPS_menu_idp.setText("");
	    me.DPS_menu_line1.setVisible(0);
	    me.DPS_menu_line2.setVisible(0);
	    me.DPS_menu_line3.setVisible(0);
	    me.DPS_menu_line4.setVisible(0);
	    me.DPS_menu_line_cdr.setVisible(0);
	    me.DPS_menu_line_plt.setVisible(0);

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

	    if (SpaceShuttle.idp_array[idp_index].get_major_function() == 1)
            	{me.DPS_menu_gpc_driver.setText("1");}
	    else
		{me.DPS_menu_gpc_driver.setText("4");}

	    me.DPS_menu_idp.setText(sprintf("%1.0f",port));
	    me.DPS_menu_line1.setVisible(1);
	    me.DPS_menu_line2.setVisible(1);
	    me.DPS_menu_line3.setVisible(1);
	    me.DPS_menu_line4.setVisible(1);

	    if (SpaceShuttle.kb_array[0].get_idp() == port)
		{
		me.DPS_menu_line_cdr.setVisible(1);
		}
	    else
		{
		me.DPS_menu_line_cdr.setVisible(0);
		}

	    if (SpaceShuttle.kb_array[1].get_idp() == port)
		{
		me.DPS_menu_line_plt.setVisible(1);
		}
	    else
		{
		me.DPS_menu_line_plt.setVisible(0);
		}

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
        me.PFD.p_subsys = PFD_addpage_p_subsys(me.PFD);
        me.PFD.p_dps = PFD_addpage_p_dps(me.PFD);
        me.PFD.p_dps_fault = PFD_addpage_p_dps_fault(me.PFD);
        me.PFD.p_dps_sys_summ = PFD_addpage_p_dps_sys_summ(me.PFD);
        me.PFD.p_dps_sys_summ2 = PFD_addpage_p_dps_sys_summ2(me.PFD);
        me.PFD.p_ascent = PFD_addpage_p_ascent(me.PFD);
        me.PFD.p_dps_rtls = PFD_addpage_p_dps_rtls(me.PFD);
        me.PFD.p_entry = PFD_addpage_p_entry(me.PFD);
        me.PFD.p_vert_sit = PFD_addpage_p_vert_sit(me.PFD);
        me.PFD.p_dps_mnvr = PFD_addpage_p_dps_mnvr(me.PFD);
        me.PFD.p_dps_univ_ptg = PFD_addpage_p_dps_univ_ptg(me.PFD);
        me.PFD.p_dps_apu_hyd = PFD_addpage_p_dps_apu_hyd(me.PFD);
        me.PFD.p_dps_pl_bay = PFD_addpage_p_dps_pl_bay(me.PFD);
        me.PFD.p_dps_override = PFD_addpage_p_dps_override(me.PFD);
        me.PFD.p_dps_time = PFD_addpage_p_dps_time(me.PFD);
        me.PFD.p_dps_dap = PFD_addpage_p_dps_dap(me.PFD);
        me.PFD.p_dps_sm_sys_summ1 = PFD_addpage_p_dps_sm_sys_summ1(me.PFD);
        me.PFD.p_dps_sm_sys_summ2 = PFD_addpage_p_dps_sm_sys_summ2(me.PFD);
        me.PFD.p_dps_antenna = PFD_addpage_p_dps_antenna(me.PFD);
        me.PFD.p_dps_fc = PFD_addpage_p_dps_fc(me.PFD);
        me.PFD.p_dps_pl_ret = PFD_addpage_p_dps_pl_ret(me.PFD);
        me.PFD.p_dps_electric = PFD_addpage_p_dps_electric(me.PFD);
        me.PFD.p_dps_cryo = PFD_addpage_p_dps_cryo(me.PFD);
        me.PFD.p_dps_rel_nav = PFD_addpage_p_dps_rel_nav(me.PFD);
        me.PFD.p_dps_strk = PFD_addpage_p_dps_strk(me.PFD);
        me.PFD.p_dps_hsit = PFD_addpage_p_dps_hsit(me.PFD);
        me.PFD.p_dps_rm_orbit = PFD_addpage_p_dps_rm_orbit(me.PFD);
        me.PFD.p_dps_rcs = PFD_addpage_p_dps_rcs(me.PFD);

        me.PFD.p_meds_oms_mps = PFD_addpage_p_meds_oms_mps(me.PFD);
        me.PFD.p_meds_apu = PFD_addpage_p_meds_apu(me.PFD);
        me.PFD.p_meds_spi = PFD_addpage_p_meds_spi(me.PFD);

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


	me.PFD.DPS_menu = me.PFD.svg.getElementById("DPSMenu");
	me.PFD.MEDS_menu = me.PFD.svg.getElementById("MEDSMenu");


 
        me.PFD.DPS_menu_time = me.PFD.svg.getElementById("dps_menu_time");
        me.PFD.DPS_menu_crt_time = me.PFD.svg.getElementById("dps_menu_crt_time");
        me.PFD.DPS_menu_ops = me.PFD.svg.getElementById("dps_menu_OPS");
        me.PFD.DPS_menu_title = me.PFD.svg.getElementById("dps_menu_title");
        me.PFD.DPS_menu_fault_line = me.PFD.svg.getElementById("dps_menu_fault_line");
        me.PFD.DPS_menu_scratch_line = me.PFD.svg.getElementById("dps_menu_scratch_line");
        me.PFD.DPS_menu_gpc_driver = me.PFD.svg.getElementById("dps_menu_gpc_driver");
        me.PFD.DPS_menu_idp = me.PFD.svg.getElementById("dps_menu_idp");
        me.PFD.DPS_menu_line1 = me.PFD.svg.getElementById("dps_menu_line1");
        me.PFD.DPS_menu_line2 = me.PFD.svg.getElementById("dps_menu_line2");
        me.PFD.DPS_menu_line3 = me.PFD.svg.getElementById("dps_menu_line3");
        me.PFD.DPS_menu_line4 = me.PFD.svg.getElementById("dps_menu_line4");
        me.PFD.DPS_menu_line_cdr = me.PFD.svg.getElementById("dps_menu_line_cdr");
        me.PFD.DPS_menu_line_plt = me.PFD.svg.getElementById("dps_menu_line_plt");
        me.PFD.DPS_menu_blink = 1;

        me.PFD.nom_traj_plot = me.PFD._canvas.createGroup();
        me.PFD.limit1_traj_plot = me.PFD._canvas.createGroup();
        me.PFD.limit2_traj_plot = me.PFD._canvas.createGroup();

	me.PFD.symbols = me.PFD._canvas.createGroup();

	# we can't put the display colors into the emissive animation because the screens
	# show different colors, so we set common element colors here and page colors at
	# their pages 

	me.PFD.DPS_menu.setColor(dps_r, dps_g, dps_b);
	me.PFD.MEDS_menu.setColor(meds_r, meds_g, meds_b);
	me.PFD.DPS_menu_line_plt.setColor(1,1,0.3);
	me.PFD.DPS_menu_line_cdr.setColor(1,0.3,0.3);
	me.PFD.DPS_menu_fault_line.setColor(1,0.3,0.3);


        me.setupMenus();
    },

    # Add the menus to each page. 
    setupMenus : func
    {
        me.PFD.p_ascent.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_ascent.addMenuItem(4, "MSG RST", me.PFD.p_ascent);
        me.PFD.p_ascent.addMenuItem(5, "MSG ACK", me.PFD.p_ascent);

        me.PFD.p_dps_rtls.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_rtls.addMenuItem(4, "MSG RST", me.PFD.p_dps_rtls);
        me.PFD.p_dps_rtls.addMenuItem(5, "MSG ACK", me.PFD.p_dps_rtls);
    
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
    
        me.PFD.p_main.addMenuItem(1, "FLT", me.PFD.p_pfd);
        me.PFD.p_main.addMenuItem(2, "SUBSYS", me.PFD.p_subsys);
        me.PFD.p_main.addMenuItem(3, "DPS", me.PFD.p_dps);
        me.PFD.p_main.addMenuItem(4, "MAINT", me.PFD.p_dps_rtls);
        #me.PFD.p_main.addMenuItem(4, "MSG RST", me.PFD.p_main);
        #me.PFD.p_main.addMenuItem(5, "MSG ACK", me.PFD.p_main);

        me.PFD.p_subsys.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_subsys.addMenuItem(1, "OMS", me.PFD.p_meds_oms_mps);
        me.PFD.p_subsys.addMenuItem(2, "APU", me.PFD.p_meds_apu);
        me.PFD.p_subsys.addMenuItem(3, "SPI", me.PFD.p_meds_spi);
        me.PFD.p_subsys.addMenuItem(4, "PORT SEL", me.PFD.p_subsys);
        me.PFD.p_subsys.addMenuItem(5, "MSG ACK", me.PFD.p_subsys);
    
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

        me.PFD.p_dps_fc.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_fc.addMenuItem(4, "MSG RST", me.PFD.p_dps_fc);
        me.PFD.p_dps_fc.addMenuItem(5, "MSG ACK", me.PFD.p_dps_fc);

       	me.PFD.p_dps_strk.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_strk.addMenuItem(4, "MSG RST", me.PFD.p_dps_strk);
        me.PFD.p_dps_strk.addMenuItem(5, "MSG ACK", me.PFD.p_dps_strk);

       	me.PFD.p_dps_hsit.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_hsit.addMenuItem(4, "MSG RST", me.PFD.p_dps_hsit);
        me.PFD.p_dps_hsit.addMenuItem(5, "MSG ACK", me.PFD.p_dps_hsit);

        me.PFD.p_dps_electric.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_electric.addMenuItem(4, "MSG RST", me.PFD.p_dps_electric);
        me.PFD.p_dps_electric.addMenuItem(5, "MSG ACK", me.PFD.p_dps_electric);

        me.PFD.p_dps_cryo.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_cryo.addMenuItem(4, "MSG RST", me.PFD.p_dps_cryo);
        me.PFD.p_dps_cryo.addMenuItem(5, "MSG ACK", me.PFD.p_dps_cryo);

        me.PFD.p_dps_pl_ret.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_pl_ret.addMenuItem(4, "MSG RST", me.PFD.p_dps_pl_ret);
        me.PFD.p_dps_pl_ret.addMenuItem(5, "MSG ACK", me.PFD.p_dps_pl_ret);

        me.PFD.p_dps_sm_sys_summ1.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_sm_sys_summ1.addMenuItem(4, "MSG RST", me.PFD.p_dps_sm_sys_summ1);
        me.PFD.p_dps_sm_sys_summ1.addMenuItem(5, "MSG ACK", me.PFD.p_dps_sm_sys_summ1);    

        me.PFD.p_dps_sm_sys_summ2.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_sm_sys_summ2.addMenuItem(4, "MSG RST", me.PFD.p_dps_sm_sys_summ2);
        me.PFD.p_dps_sm_sys_summ2.addMenuItem(5, "MSG ACK", me.PFD.p_dps_sm_sys_summ2);

        me.PFD.p_dps_rel_nav.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_rel_nav.addMenuItem(4, "MSG RST", me.PFD.p_dps_rel_nav);
        me.PFD.p_dps_rel_nav.addMenuItem(5, "MSG ACK", me.PFD.p_dps_rel_nav);

        me.PFD.p_dps_rm_orbit.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_rm_orbit.addMenuItem(4, "MSG RST", me.PFD.p_dps_rm_orbit);
        me.PFD.p_dps_rm_orbit.addMenuItem(5, "MSG ACK", me.PFD.p_dps_rm_orbit);

        me.PFD.p_dps_rcs.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_dps_rcs.addMenuItem(4, "MSG RST", me.PFD.p_dps_rcs);
        me.PFD.p_dps_rcs.addMenuItem(5, "MSG ACK", me.PFD.p_dps_rcs);

        me.PFD.p_meds_oms_mps.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_meds_oms_mps.addMenuItem(1, "OMS", me.PFD.p_meds_oms_mps);
        me.PFD.p_meds_oms_mps.addMenuItem(2, "APU", me.PFD.p_meds_apu);
        me.PFD.p_meds_oms_mps.addMenuItem(3, "SPI", me.PFD.p_meds_spi);
        me.PFD.p_meds_oms_mps.addMenuItem(4, "PORT SEL", me.PFD.p_meds_oms_mps);
        me.PFD.p_meds_oms_mps.addMenuItem(5, "MSG ACK", me.PFD.p_meds_oms_mps);

       	me.PFD.p_meds_apu.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_meds_apu.addMenuItem(1, "OMS", me.PFD.p_meds_oms_mps);
        me.PFD.p_meds_apu.addMenuItem(2, "APU", me.PFD.p_meds_apu);
        me.PFD.p_meds_apu.addMenuItem(3, "SPI", me.PFD.p_meds_spi);
        me.PFD.p_meds_apu.addMenuItem(4, "PORT SEL", me.PFD.p_meds_apu);
        me.PFD.p_meds_apu.addMenuItem(5, "MSG ACK", me.PFD.p_meds_apu);

       	me.PFD.p_meds_spi.addMenuItem(0, "UP", me.PFD.p_main);
        me.PFD.p_meds_spi.addMenuItem(1, "OMS", me.PFD.p_meds_oms_mps);
        me.PFD.p_meds_spi.addMenuItem(2, "APU", me.PFD.p_meds_apu);
        me.PFD.p_meds_spi.addMenuItem(3, "SPI", me.PFD.p_meds_spi);
        me.PFD.p_meds_spi.addMenuItem(4, "PORT SEL", me.PFD.p_meds_spi);
        me.PFD.p_meds_spi.addMenuItem(5, "MSG ACK", me.PFD.p_meds_spi);

      
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
MEDS_CDR2.PFD.selectPage(MEDS_CDR2.PFD.p_meds_oms_mps);
MEDS_CDR2.PFD.dps_page_flag = 0;
MEDS_CRT1.PFD.selectPage(MEDS_CRT1.PFD.p_dps);
MEDS_CRT1.PFD.dps_page_flag = 1;
MEDS_MFD1.PFD.selectPage(MEDS_MFD1.PFD.p_meds_spi);
MEDS_MFD1.PFD.dps_page_flag = 0;
MEDS_CRT3.PFD.selectPage(MEDS_CRT3.PFD.p_dps);
MEDS_CRT3.PFD.dps_page_flag = 1;
MEDS_CRT2.PFD.selectPage(MEDS_CRT2.PFD.p_dps);
MEDS_CRT2.PFD.dps_page_flag = 1;
MEDS_MFD2.PFD.selectPage(MEDS_MFD2.PFD.p_meds_apu);
MEDS_MFD2.PFD.dps_page_flag = 0;
MEDS_PLT1.PFD.selectPage(MEDS_PLT1.PFD.p_meds_oms_mps);
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
