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
# * p_dps_sys_summ (DISP 18)
# * p_dps_sys_summ2 (DISP 19)
# * p_dps_apu_hyd (DISP 86)
# * p_dps_fault (DISP 99)


#
#
# in the SVG each page is a named group - the group name is used to define each page
setprop ("/sim/startup/terminal-ansi-colors",0);

var PFDcanvas= canvas.new({
        "name": "STS PFD",
            "size": [1758,1884], 
            "view": [512,512],                       
            "mipmapping": 1     
            });                          
                          
PFDcanvas.addPlacement({"node": "DisplayL1"});
PFDcanvas.setColorBackground(0,0,0, 0);


# Create a group for the parsed elements
var PFDsvg = PFDcanvas.createGroup();
 
# Parse an SVG file and add the parsed elements to the given group
print("PFD : Load SVG ",canvas.parsesvg(PFDsvg, "Nasal/PFD/PFD.svg"));
PFDsvg.setTranslation (20, 30);

#
# Menu Id's
# 18           6            
# 19           7            
# 20           8            
# 21           9            
# 22           10            
# 23           11          
# Top: 12..17
# Bot: 0..5
var PFD_MenuItem = {
    new : func (menu_id, title, page)
    {
		var obj = {parents : [PFD_MenuItem] };
        obj.page = page;
        obj.menu_id = menu_id;
        obj.title = title;
#        printf("New MenuItem %s,%s,%s",menu_id, title, page);
        return obj;
    },
};

#
#
# Create a new PFD Page 0 needs page id, svg and layer id
var PFD_Page = {
	new : func (title, layer_id, device)
    {
		var obj = {parents : [PFD_Page] };
        obj.title = title;
        obj.device = device;
        obj.layer_id = layer_id;
        obj.menus = [];
#        print("Load page ",title);
        obj.svg = PFDsvg.getElementById(layer_id);
        if(obj.svg == nil)
            printf("Error loading %s: svg layer %s ",title, layer_id);

        return obj;
    },
    setVisible : func(vis)
    {
        if(me.svg != nil)
            me.svg.setVisible(vis);
#        print("Set visible ",me.layer_id);

        if (vis)
        {
            me.ondisplay();
            foreach(mi ;  me.menus)
            {
#                printf("load menu %s %\n",mi.title, mi);
            }
        }
        else
            me.offdisplay();
    },
#
#
# Perform action when button is pushed
    notifyButton : func(button_id) 
    {        foreach(var mi; me.menus)
             {
                 if (mi.menu_id == button_id)
                 {
                     printf("Page: found button %s, selecting page\n",mi.title);
                     me.device.selectPage(mi.page);
                     break;
                 }
             }
    },
# 
# Add an item to a menu
# Params:
#  menu button id (that is set in controls/PFD/button-pressed by the model)
#  title of the menu for the label
#  page that will be selected when pressed
# 
# The corresponding menu for the selected page will automatically be loaded
    addMenuItem : func(menu_id, title, page)
    {
        var nm = PFD_MenuItem.new(menu_id, title, page);
#        printf("New menu %s %s on page ", menu_id, title, page.layer_id);
        append(me.menus, nm);
#        printf("Page %s: add menu %s [%s]",me.layer_id, menu_id, title);
#            foreach(mi ; me.menus)
        #            {
#                printf("--menu %s",mi.title);
        #            }
        return nm;
    },
    update : func
    {
    },
    ondisplay : func
    {
    },
    offdisplay : func
    {
    },
};
var num_menu_buttons = 6; # Number of menu buttons; starting from the bottom left then right, then top, then left.
var PFD_Device =
{
    new : func(svg)
    {
		var obj = {parents : [PFD_Device] };
        obj.svg = svg;
        obj.current_page = nil;
        obj.pages = [];
        obj.buttons = setsize([], num_menu_buttons);

        for(var idx = 0; idx < num_menu_buttons; idx += 1)
        {
            var label_name = sprintf("MI_%d",idx);
            var msvg = obj.svg.getElementById(label_name);
            if (msvg == nil)
                printf("Failed to load  %s",label_name);
            else
            {
                obj.buttons[idx] = msvg;
                obj.buttons[idx].setText(sprintf("M",idx));
            }
        }
#        for(var idx = 0; idx < size(obj.buttons); idx += 1)
        #        {
#            printf("Button %d %s",idx,obj.buttons[idx]);
        #        }
        return obj;
    },
    notifyButton : func(button_id)
    {
        #
        #
# by convention the buttons we have are 0 based; however externally 0 is used
# to indicate no button pushed.
        if (button_id > 0)
        {
            button_id = button_id - 1;
            if (me.current_page != nil)
            {
                printf("Button routing to %s",me.current_page.title);
                me.current_page.notifyButton(button_id);
            }
            else
                printf("Could not locate page for button ",button_id);
        }
    },
    addPage : func(title, layer_id)
    {
        var np = PFD_Page.new(title, layer_id, me);
        append(me.pages, np);
        np.setVisible(0);
        return np;
    },
    update : func
    {
        if (me.current_page != nil)
            me.current_page.update();
    },
    selectPage : func(p)
    {
        if (me.current_page != nil)
            me.current_page.setVisible(0);
        if (me.buttons != nil)
        {
            foreach(var mb ; me.buttons)
                if (mb != nil)
                    mb.setVisible(0);

            foreach(var mi ; p.menus)
            {
                printf("selectPage: load menu %d %s",mi.menu_id, mi.title);
                if (me.buttons[mi.menu_id] != nil)
                {
                    me.buttons[mi.menu_id].setText(mi.title);
                    me.buttons[mi.menu_id].setVisible(1);
                }
                else
                    printf("No corresponding item '%s'",mi.menu_id);
            }
        }
        p.setVisible(1);
        me.current_page = p;
    },
};

var PFD =  PFD_Device.new(PFDsvg);

setlistener("sim/model/shuttle/controls/PFD/button-pressed", func(v)
            {
                if (v != nil)
                {
                    if (v.getValue())
                        pfd_button_pushed = v.getValue();
                    else
                    {
                        printf("Button %d",pfd_button_pushed);
                        PFD.notifyButton(pfd_button_pushed);
                        pfd_button_pushed = 0;
                    }
                }
            });
var pfd_mode = 1;

# SVG access to all common elements in DPS and MEDS page structures

var MEDS_menu_title = PFDsvg.getElementById("MEDS_title");

var DPS_menu_time = PFDsvg.getElementById("dps_menu_time");
var DPS_menu_crt_time = PFDsvg.getElementById("dps_menu_crt_time");
var DPS_menu_ops = PFDsvg.getElementById("dps_menu_OPS");
var DPS_menu_title = PFDsvg.getElementById("dps_menu_title");
var DPS_menu_fault_line = PFDsvg.getElementById("dps_menu_fault_line");
var DPS_menu_scratch_line = PFDsvg.getElementById("dps_menu_scratch_line");
var DPS_menu_gpc_driver = PFDsvg.getElementById("dps_menu_gpc_driver");
var DPS_menu_blink = 1;


# the trajectory plot groups

var nom_traj_plot = PFDcanvas.createGroup();
var limit1_traj_plot = PFDcanvas.createGroup();
var limit2_traj_plot = PFDcanvas.createGroup();

# helper function to turn DPS display items off in MEDS pages

var set_DPS_off = func {

DPS_menu_time.setText(sprintf("%s",""));
DPS_menu_crt_time.setText(sprintf("%s",""));
DPS_menu_ops.setText(sprintf("%s",""));
DPS_menu_title.setText(sprintf("%s",""));
DPS_menu_fault_line.setText(sprintf("%s",""));
DPS_menu_scratch_line.setText(sprintf("%s",""));
DPS_menu_gpc_driver.setText(sprintf("%s",""));

setprop("/fdm/jsbsim/systems/dps/dps-page-flag", 0);
}

var update_common_DPS = func {

DPS_menu_time.setText(sprintf("%s","000/"~getprop("/sim/time/gmt-string")));
DPS_menu_crt_time.setText(sprintf("%s", "000/"~" 0:00:00"));
DPS_menu_scratch_line.setText(sprintf("%s",getprop("/fdm/jsbsim/systems/dps/command-string")));
DPS_menu_gpc_driver.setText(sprintf("%s","1"));

var fault_string = getprop("/fdm/jsbsim/systems/dps/error-string");

if (SpaceShuttle.cws_last_message_acknowledge == 1)
	{
	if (DPS_menu_blink == 0) {fault_string = "";}
	}
DPS_menu_fault_line.setText(sprintf("%s",fault_string ));

if (DPS_menu_blink == 1) {DPS_menu_blink = 0;}
else {DPS_menu_blink = 1;}

setprop("/fdm/jsbsim/systems/dps/dps-page-flag", 1);
}


#########################################################
# helper functions converting properties to display items
#########################################################

var valve_status_to_string = func (status) {

if (status == 0) {return "CL";}
else {return "OP";}

}

var jet_status_to_string = func (status) {

if (status == 1) {return "OFF";}
else if (status == 2) {return "ON";}
if (status == 3) {return "LK";}
else {return "";}
}

var elevon_norm = func (angle) {

if (angle < 0.0) {return 100.0 * angle/40.0;}
else {return 100.0 * angle/28.0;}

}


var K_to_F = func (T) {

return T * 9.0/5.0 - 459.67;

}

var wsb_ctrl_to_string = func (status) {

if (status == 1) {return "A/B";}
else {return "OFF";}

}

var wsb_vlv_to_string = func (status) {

if (status > 0.0) {return " OP";}
else {return "BYP";}

}


# Set listener on the PFD mode button; this could be an on off switch or by convention
# it will also act as brightness; so 0 is off and anything greater is brightness.
# ranges are not pre-defined; it is probably sensible to use 0..10 as an brightness rather
# than 0..1 as a floating value; but that's just my view.
setlistener("sim/model/shuttle/controls/PFD/mode", func(v)
            {
                if (v != nil)
                {
                    var pfd_mode = v.getValue();
#                    print("PFD Mode ",pfd_mode);
#    if (!pfd_mode)
#        PFDcanvas.setVisible(0);
#    else
#        PFDcanvas.setVisible(1);
                }
            });

var p_pfd = PFD.addPage("PFD", "p_pfd");

#
#
# PFD page update
p_pfd.keas = PFDsvg.getElementById("p_pfd_keas");
p_pfd.beta = PFDsvg.getElementById("p_pfd_beta");

p_pfd.ondisplay = func
{
    set_DPS_off();
    MEDS_menu_title.setText(sprintf("%s","FLIGHT INSTRUMENT MENU"));
}


p_pfd.update = func
{
    # these really need to be deleted when leaving the ascent page - do we have
    # an 'upon exit' functionality here

   
    p_pfd.beta.setText(sprintf("%5.1f",getprop("fdm/jsbsim/aero/beta-deg")));
    p_pfd.keas.setText(sprintf("%5.0f",getprop("velocities/airspeed-kt")));
};

#
PFD.selectPage(p_pfd);

#################################################################
# the main menu page showing just selection buttons
#################################################################

var p_main = PFD.addPage("MainMenu", "p_main");




p_main.ondisplay = func
{
set_DPS_off();
MEDS_menu_title.setText(sprintf("%s","      MAIN MENU"));
}



#################################################################
# the dps dispatching page - this isn't a real page
# it just points to the correct page dependent on ops mode
#################################################################

var p_dps = PFD.addPage("CRTDefault", "p_dps");

p_dps.blink = 1;

p_dps.update = func
{
var ops = getprop("/fdm/jsbsim/systems/dps/ops");

if (ops == 1)
	{ PFD.selectPage(p_ascent);}
else if (ops == 2)
	{ PFD.selectPage(p_dps_univ_ptg);}
else if ( ops == 3)
	{ PFD.selectPage(p_dps_mnvr);}
else 
	{PFD.selectPage(p_main);}

}

#################################################################
# the generic CRT fault page 
#################################################################

var p_dps_fault = PFD.addPage("CRTFault", "p_dps_fault");

p_dps_fault.string1 = PFDsvg.getElementById("p_dps_fault_string1");
p_dps_fault.string2 = PFDsvg.getElementById("p_dps_fault_string2");
p_dps_fault.string3 = PFDsvg.getElementById("p_dps_fault_string3");
p_dps_fault.string4 = PFDsvg.getElementById("p_dps_fault_string4");
p_dps_fault.string5 = PFDsvg.getElementById("p_dps_fault_string5");
p_dps_fault.string6 = PFDsvg.getElementById("p_dps_fault_string6");
p_dps_fault.string7 = PFDsvg.getElementById("p_dps_fault_string7");
p_dps_fault.string8 = PFDsvg.getElementById("p_dps_fault_string8");
p_dps_fault.string9 = PFDsvg.getElementById("p_dps_fault_string9");
p_dps_fault.string10 = PFDsvg.getElementById("p_dps_fault_string10");
p_dps_fault.string11 = PFDsvg.getElementById("p_dps_fault_string11");
p_dps_fault.string12 = PFDsvg.getElementById("p_dps_fault_string12");
p_dps_fault.string13 = PFDsvg.getElementById("p_dps_fault_string13");
p_dps_fault.string14 = PFDsvg.getElementById("p_dps_fault_string14");
p_dps_fault.string15 = PFDsvg.getElementById("p_dps_fault_string15");

p_dps_fault.ondisplay = func
{
DPS_menu_title.setText(sprintf("%s","FAULT"));
MEDS_menu_title.setText(sprintf("%s","       DPS MENU"));

var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");

var ops_string = major_mode~"1/   /099";
DPS_menu_ops.setText(sprintf("%s",ops_string));
}

p_dps_fault.update = func
{

p_dps_fault.string1.setText(sprintf("%s", SpaceShuttle.cws_message_array_long[0]));
p_dps_fault.string2.setText(sprintf("%s", SpaceShuttle.cws_message_array_long[1]));
p_dps_fault.string3.setText(sprintf("%s", SpaceShuttle.cws_message_array_long[2]));
p_dps_fault.string4.setText(sprintf("%s", SpaceShuttle.cws_message_array_long[3]));
p_dps_fault.string5.setText(sprintf("%s", SpaceShuttle.cws_message_array_long[4]));
p_dps_fault.string6.setText(sprintf("%s", SpaceShuttle.cws_message_array_long[5]));
p_dps_fault.string7.setText(sprintf("%s", SpaceShuttle.cws_message_array_long[6]));
p_dps_fault.string8.setText(sprintf("%s", SpaceShuttle.cws_message_array_long[7]));
p_dps_fault.string9.setText(sprintf("%s", SpaceShuttle.cws_message_array_long[8]));
p_dps_fault.string10.setText(sprintf("%s", SpaceShuttle.cws_message_array_long[9]));
p_dps_fault.string11.setText(sprintf("%s", SpaceShuttle.cws_message_array_long[10]));
p_dps_fault.string12.setText(sprintf("%s", SpaceShuttle.cws_message_array_long[11]));
p_dps_fault.string13.setText(sprintf("%s", SpaceShuttle.cws_message_array_long[12]));
p_dps_fault.string14.setText(sprintf("%s", SpaceShuttle.cws_message_array_long[13]));
p_dps_fault.string15.setText(sprintf("%s", SpaceShuttle.cws_message_array_long[14]));

update_common_DPS();




}



#################################################################
# GNC systems summary page 1 
#################################################################

var p_dps_sys_summ = PFD.addPage("CRTGNC_SUM1", "p_dps_sys_summ");


p_dps_sys_summ.f1_vlv = PFDsvg.getElementById("p_dps_sys_summ_f1_vlv");
p_dps_sys_summ.f2_vlv = PFDsvg.getElementById("p_dps_sys_summ_f2_vlv");
p_dps_sys_summ.f3_vlv = PFDsvg.getElementById("p_dps_sys_summ_f3_vlv");
p_dps_sys_summ.f4_vlv = PFDsvg.getElementById("p_dps_sys_summ_f4_vlv");
p_dps_sys_summ.f5_vlv = PFDsvg.getElementById("p_dps_sys_summ_f5_vlv");

p_dps_sys_summ.f1_fail = PFDsvg.getElementById("p_dps_sys_summ_f1_fail");
p_dps_sys_summ.f2_fail = PFDsvg.getElementById("p_dps_sys_summ_f2_fail");
p_dps_sys_summ.f3_fail = PFDsvg.getElementById("p_dps_sys_summ_f3_fail");
p_dps_sys_summ.f4_fail = PFDsvg.getElementById("p_dps_sys_summ_f4_fail");
p_dps_sys_summ.f5_fail = PFDsvg.getElementById("p_dps_sys_summ_f5_fail");

p_dps_sys_summ.l1_vlv = PFDsvg.getElementById("p_dps_sys_summ_l1_vlv");
p_dps_sys_summ.l2_vlv = PFDsvg.getElementById("p_dps_sys_summ_l2_vlv");
p_dps_sys_summ.l3_vlv = PFDsvg.getElementById("p_dps_sys_summ_l3_vlv");
p_dps_sys_summ.l4_vlv = PFDsvg.getElementById("p_dps_sys_summ_l4_vlv");
p_dps_sys_summ.l5_vlv = PFDsvg.getElementById("p_dps_sys_summ_l5_vlv");

p_dps_sys_summ.l1_fail = PFDsvg.getElementById("p_dps_sys_summ_l1_fail");
p_dps_sys_summ.l2_fail = PFDsvg.getElementById("p_dps_sys_summ_l2_fail");
p_dps_sys_summ.l3_fail = PFDsvg.getElementById("p_dps_sys_summ_l3_fail");
p_dps_sys_summ.l4_fail = PFDsvg.getElementById("p_dps_sys_summ_l4_fail");
p_dps_sys_summ.l5_fail = PFDsvg.getElementById("p_dps_sys_summ_l5_fail");

p_dps_sys_summ.r1_vlv = PFDsvg.getElementById("p_dps_sys_summ_r1_vlv");
p_dps_sys_summ.r2_vlv = PFDsvg.getElementById("p_dps_sys_summ_r2_vlv");
p_dps_sys_summ.r3_vlv = PFDsvg.getElementById("p_dps_sys_summ_r3_vlv");
p_dps_sys_summ.r4_vlv = PFDsvg.getElementById("p_dps_sys_summ_r4_vlv");
p_dps_sys_summ.r5_vlv = PFDsvg.getElementById("p_dps_sys_summ_r5_vlv");

p_dps_sys_summ.r1_fail = PFDsvg.getElementById("p_dps_sys_summ_r1_fail");
p_dps_sys_summ.r2_fail = PFDsvg.getElementById("p_dps_sys_summ_r2_fail");
p_dps_sys_summ.r3_fail = PFDsvg.getElementById("p_dps_sys_summ_r3_fail");
p_dps_sys_summ.r4_fail = PFDsvg.getElementById("p_dps_sys_summ_r4_fail");
p_dps_sys_summ.r5_fail = PFDsvg.getElementById("p_dps_sys_summ_r5_fail");

p_dps_sys_summ.pos_l_ob = PFDsvg.getElementById("p_dps_sys_summ_pos_l_ob");
p_dps_sys_summ.pos_l_ib = PFDsvg.getElementById("p_dps_sys_summ_pos_l_ib");
p_dps_sys_summ.pos_r_ob = PFDsvg.getElementById("p_dps_sys_summ_pos_r_ob");
p_dps_sys_summ.pos_r_ib = PFDsvg.getElementById("p_dps_sys_summ_pos_r_ib");

p_dps_sys_summ.mom_l_ob = PFDsvg.getElementById("p_dps_sys_summ_mom_l_ob");
p_dps_sys_summ.mom_l_ib = PFDsvg.getElementById("p_dps_sys_summ_mom_l_ib");
p_dps_sys_summ.mom_r_ob = PFDsvg.getElementById("p_dps_sys_summ_mom_r_ob");
p_dps_sys_summ.mom_r_ib = PFDsvg.getElementById("p_dps_sys_summ_mom_r_ib");



p_dps_sys_summ.pos_rud = PFDsvg.getElementById("p_dps_sys_summ_pos_rud");
p_dps_sys_summ.pos_spdbrk = PFDsvg.getElementById("p_dps_sys_summ_pos_spdbrk");
p_dps_sys_summ.pos_bdyflp = PFDsvg.getElementById("p_dps_sys_summ_pos_bdyflp");
p_dps_sys_summ.pos_ail = PFDsvg.getElementById("p_dps_sys_summ_pos_ail");

p_dps_sys_summ.bdyflp_msg = PFDsvg.getElementById("p_dps_sys_summ_bdyflp_msg");
p_dps_sys_summ.rhc_l = PFDsvg.getElementById("p_dps_sys_summ_rhc_l");
p_dps_sys_summ.rhc_r = PFDsvg.getElementById("p_dps_sys_summ_rhc_r");
p_dps_sys_summ.rhc_a = PFDsvg.getElementById("p_dps_sys_summ_rhc_a");
p_dps_sys_summ.thc_l = PFDsvg.getElementById("p_dps_sys_summ_thc_l");
p_dps_sys_summ.thc_a = PFDsvg.getElementById("p_dps_sys_summ_thc_a");
p_dps_sys_summ.sbtc_l = PFDsvg.getElementById("p_dps_sys_summ_sbtc_l");
p_dps_sys_summ.sbtc_r = PFDsvg.getElementById("p_dps_sys_summ_sbtc_r");

p_dps_sys_summ.gpc = PFDsvg.getElementById("p_dps_sys_summ_gpc");
p_dps_sys_summ.mdm_ff = PFDsvg.getElementById("p_dps_sys_summ_mdm_ff");
p_dps_sys_summ.mdm_fa = PFDsvg.getElementById("p_dps_sys_summ_mdm_fa");

p_dps_sys_summ.fcs_ch = PFDsvg.getElementById("p_dps_sys_summ_fcs_ch");
p_dps_sys_summ.imu = PFDsvg.getElementById("p_dps_sys_summ_imu");
p_dps_sys_summ.acc = PFDsvg.getElementById("p_dps_sys_summ_acc");
p_dps_sys_summ.rga = PFDsvg.getElementById("p_dps_sys_summ_rga");
p_dps_sys_summ.tac = PFDsvg.getElementById("p_dps_sys_summ_tac");
p_dps_sys_summ.mls = PFDsvg.getElementById("p_dps_sys_summ_mls");
p_dps_sys_summ.adta = PFDsvg.getElementById("p_dps_sys_summ_adta");



p_dps_sys_summ.ondisplay = func
{
var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");

var ops_string = major_mode~"1/   /018";


DPS_menu_title.setText(sprintf("%s","GNC SYS SUMM 1"));
DPS_menu_ops.setText(sprintf("%s",ops_string));
MEDS_menu_title.setText(sprintf("%s","       DPS MENU"));

# for the moment, we blank failure messages where we can't simulate the mode yet

p_dps_sys_summ.bdyflp_msg.setText(sprintf(""));
p_dps_sys_summ.rhc_l.setText(sprintf(""));
p_dps_sys_summ.rhc_r.setText(sprintf(""));
p_dps_sys_summ.rhc_a.setText(sprintf(""));
p_dps_sys_summ.thc_l.setText(sprintf(""));
p_dps_sys_summ.thc_a.setText(sprintf(""));
p_dps_sys_summ.sbtc_l.setText(sprintf(""));
p_dps_sys_summ.sbtc_r.setText(sprintf(""));

p_dps_sys_summ.gpc.setText(sprintf(""));
p_dps_sys_summ.mdm_ff.setText(sprintf(""));
p_dps_sys_summ.mdm_fa.setText(sprintf(""));

p_dps_sys_summ.fcs_ch.setText(sprintf(""));
p_dps_sys_summ.imu.setText(sprintf(""));
p_dps_sys_summ.acc.setText(sprintf(""));
p_dps_sys_summ.rga.setText(sprintf(""));
p_dps_sys_summ.tac.setText(sprintf(""));
p_dps_sys_summ.mls.setText(sprintf(""));
p_dps_sys_summ.adta.setText(sprintf(""));
}

p_dps_sys_summ.update = func
{


update_common_DPS();



p_dps_sys_summ.r1_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-1-status"))));
p_dps_sys_summ.r2_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-2-status"))));
p_dps_sys_summ.r3_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-3-status"))));
p_dps_sys_summ.r4_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-4-status"))));
p_dps_sys_summ.r5_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-5-status"))));

p_dps_sys_summ.r1_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-r1"))));
p_dps_sys_summ.r2_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-r2"))));
p_dps_sys_summ.r3_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-r3"))));
p_dps_sys_summ.r4_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-r4"))));
p_dps_sys_summ.r5_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-r5"))));

p_dps_sys_summ.l1_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-1-status"))));
p_dps_sys_summ.l2_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-2-status"))));
p_dps_sys_summ.l3_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-3-status"))));
p_dps_sys_summ.l4_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-4-status"))));
p_dps_sys_summ.l5_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-5-status"))));

p_dps_sys_summ.l1_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-l1"))));
p_dps_sys_summ.l2_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-l2"))));
p_dps_sys_summ.l3_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-l3"))));
p_dps_sys_summ.l4_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-l4"))));
p_dps_sys_summ.l5_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-l5"))));

p_dps_sys_summ.f1_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-1-status"))));
p_dps_sys_summ.f2_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-2-status"))));
p_dps_sys_summ.f3_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-3-status"))));
p_dps_sys_summ.f4_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-4-status"))));
p_dps_sys_summ.f5_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-5-status"))));

p_dps_sys_summ.f1_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-f1"))));
p_dps_sys_summ.f2_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-f2"))));
p_dps_sys_summ.f3_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-f3"))));
p_dps_sys_summ.f4_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-f4"))));
p_dps_sys_summ.f5_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-f5"))));

p_dps_sys_summ.pos_l_ob.setText(sprintf("%2.1f", getprop("/fdm/jsbsim/fcs/outboard-elevon-left-pos-deg")));
p_dps_sys_summ.pos_l_ib.setText(sprintf("%2.1f", getprop("/fdm/jsbsim/fcs/inboard-elevon-left-pos-deg")));
p_dps_sys_summ.pos_r_ob.setText(sprintf("%2.1f", getprop("/fdm/jsbsim/fcs/outboard-elevon-right-pos-deg"))); 
p_dps_sys_summ.pos_r_ib.setText(sprintf("%2.1f", getprop("/fdm/jsbsim/fcs/inboard-elevon-right-pos-deg")));

p_dps_sys_summ.mom_l_ob.setText(sprintf("%2.1f", elevon_norm(getprop("/fdm/jsbsim/fcs/outboard-elevon-left-pos-deg"))));
p_dps_sys_summ.mom_l_ib.setText(sprintf("%2.1f", elevon_norm(getprop("/fdm/jsbsim/fcs/inboard-elevon-left-pos-deg"))));
p_dps_sys_summ.mom_r_ob.setText(sprintf("%2.1f", elevon_norm(getprop("/fdm/jsbsim/fcs/outboard-elevon-right-pos-deg"))));
p_dps_sys_summ.mom_r_ib.setText(sprintf("%2.1f", elevon_norm(getprop("/fdm/jsbsim/fcs/inboard-elevon-right-pos-deg"))));

p_dps_sys_summ.pos_rud.setText(sprintf("%2.1f", 57.2974 * getprop("/fdm/jsbsim/fcs/rudder-pos-rad")));
p_dps_sys_summ.pos_spdbrk.setText(sprintf("%2.1f", 100.0 * getprop("/fdm/jsbsim/fcs/speedbrake-pos-norm")));
p_dps_sys_summ.pos_bdyflp.setText(sprintf("%2.1f", 57.2974 * getprop("/fdm/jsbsim/fcs/bodyflap-pos-rad")));
p_dps_sys_summ.pos_ail.setText(sprintf("%2.1f", 57.2974 * getprop("/fdm/jsbsim/fcs/left-aileron-pos-rad")));
}


#################################################################
# GNC systems summary page 2 
#################################################################

var p_dps_sys_summ2 = PFD.addPage("CRTGNC_SUM2", "p_dps_sys_summ2");



p_dps_sys_summ2.fwd_rcs_fu_qty = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_fu_qty");
p_dps_sys_summ2.fwd_rcs_oxid_qty = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_oxid_qty");

p_dps_sys_summ2.left_rcs_fu_qty = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_fu_qty");
p_dps_sys_summ2.left_rcs_oxid_qty = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_oxid_qty");

p_dps_sys_summ2.right_rcs_fu_qty = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_fu_qty");
p_dps_sys_summ2.right_rcs_oxid_qty = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_oxid_qty");

p_dps_sys_summ2.left_oms_fu_qty = PFDsvg.getElementById("p_dps_sys_summ2_fu_l");
p_dps_sys_summ2.left_oms_oxid_qty = PFDsvg.getElementById("p_dps_sys_summ2_oxid_l");

p_dps_sys_summ2.right_oms_fu_qty = PFDsvg.getElementById("p_dps_sys_summ2_fu_r");
p_dps_sys_summ2.right_oms_oxid_qty = PFDsvg.getElementById("p_dps_sys_summ2_oxid_r");



p_dps_sys_summ2.f1_vlv = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_manf1_isol");
p_dps_sys_summ2.f2_vlv = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_manf2_isol");
p_dps_sys_summ2.f3_vlv = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_manf3_isol");
p_dps_sys_summ2.f4_vlv = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_manf4_isol");
p_dps_sys_summ2.f5_vlv = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_manf5_isol");

p_dps_sys_summ2.f1_fail = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_manf1_fail");
p_dps_sys_summ2.f2_fail = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_manf2_fail");
p_dps_sys_summ2.f3_fail = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_manf3_fail");
p_dps_sys_summ2.f4_fail = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_manf4_fail");
p_dps_sys_summ2.f5_fail = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_manf5_fail");

p_dps_sys_summ2.l1_vlv = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_manf1_isol");
p_dps_sys_summ2.l2_vlv = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_manf2_isol");
p_dps_sys_summ2.l3_vlv = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_manf3_isol");
p_dps_sys_summ2.l4_vlv = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_manf4_isol");
p_dps_sys_summ2.l5_vlv = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_manf5_isol");

p_dps_sys_summ2.l1_fail = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_manf1_fail");
p_dps_sys_summ2.l2_fail = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_manf2_fail");
p_dps_sys_summ2.l3_fail = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_manf3_fail");
p_dps_sys_summ2.l4_fail = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_manf4_fail");
p_dps_sys_summ2.l5_fail = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_manf5_fail");

p_dps_sys_summ2.r1_vlv = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_manf1_isol");
p_dps_sys_summ2.r2_vlv = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_manf2_isol");
p_dps_sys_summ2.r3_vlv = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_manf3_isol");
p_dps_sys_summ2.r4_vlv = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_manf4_isol");
p_dps_sys_summ2.r5_vlv = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_manf5_isol");

p_dps_sys_summ2.r1_fail = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_manf1_fail");
p_dps_sys_summ2.r2_fail = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_manf2_fail");
p_dps_sys_summ2.r3_fail = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_manf3_fail");
p_dps_sys_summ2.r4_fail = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_manf4_fail");
p_dps_sys_summ2.r5_fail = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_manf5_fail");

p_dps_sys_summ2.fwd_rcs_oxid_he_p = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_oxid_he_p");
p_dps_sys_summ2.fwd_rcs_fu_he_p = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_fu_he_p");
p_dps_sys_summ2.fwd_rcs_oxid_tk_p = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_oxid_tk_p");
p_dps_sys_summ2.fwd_rcs_fu_tk_p = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_fu_tk_p");

p_dps_sys_summ2.left_rcs_oxid_he_p = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_oxid_he_p");
p_dps_sys_summ2.left_rcs_fu_he_p = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_fu_he_p");
p_dps_sys_summ2.left_rcs_oxid_tk_p = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_oxid_tk_p");
p_dps_sys_summ2.left_rcs_fu_tk_p = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_fu_tk_p");

p_dps_sys_summ2.right_rcs_oxid_he_p = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_oxid_he_p");
p_dps_sys_summ2.right_rcs_fu_he_p = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_fu_he_p");
p_dps_sys_summ2.right_rcs_oxid_tk_p = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_oxid_tk_p");
p_dps_sys_summ2.right_rcs_fu_tk_p = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_fu_tk_p");

p_dps_sys_summ2.left_oms_he_p = PFDsvg.getElementById("p_dps_sys_summ2_left_oms_he_p");
p_dps_sys_summ2.right_oms_he_p = PFDsvg.getElementById("p_dps_sys_summ2_right_oms_he_p");
p_dps_sys_summ2.left_oms_oxid_p = PFDsvg.getElementById("p_dps_sys_summ2_left_oms_oxid_p");
p_dps_sys_summ2.right_oms_oxid_p = PFDsvg.getElementById("p_dps_sys_summ2_right_oms_oxid_p");
p_dps_sys_summ2.left_oms_fuel_p = PFDsvg.getElementById("p_dps_sys_summ2_left_oms_fuel_p");
p_dps_sys_summ2.right_oms_fuel_p = PFDsvg.getElementById("p_dps_sys_summ2_right_oms_fuel_p");

p_dps_sys_summ2.left_rcs_manf1_oxid_p = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_manf1_oxid_p");
p_dps_sys_summ2.left_rcs_manf1_fuel_p = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_manf1_fuel_p");
p_dps_sys_summ2.left_rcs_manf2_oxid_p = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_manf2_oxid_p");
p_dps_sys_summ2.left_rcs_manf2_fuel_p = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_manf2_fuel_p");
p_dps_sys_summ2.left_rcs_manf3_oxid_p = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_manf3_oxid_p");
p_dps_sys_summ2.left_rcs_manf3_fuel_p = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_manf3_fuel_p");
p_dps_sys_summ2.left_rcs_manf4_oxid_p = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_manf4_oxid_p");
p_dps_sys_summ2.left_rcs_manf4_fuel_p = PFDsvg.getElementById("p_dps_sys_summ2_left_rcs_manf4_fuel_p");

p_dps_sys_summ2.right_rcs_manf1_oxid_p = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_manf1_oxid_p");
p_dps_sys_summ2.right_rcs_manf1_fuel_p = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_manf1_fuel_p");
p_dps_sys_summ2.right_rcs_manf2_oxid_p = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_manf2_oxid_p");
p_dps_sys_summ2.right_rcs_manf2_fuel_p = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_manf2_fuel_p");
p_dps_sys_summ2.right_rcs_manf3_oxid_p = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_manf3_oxid_p");
p_dps_sys_summ2.right_rcs_manf3_fuel_p = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_manf3_fuel_p");
p_dps_sys_summ2.right_rcs_manf4_oxid_p = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_manf4_oxid_p");
p_dps_sys_summ2.right_rcs_manf4_fuel_p = PFDsvg.getElementById("p_dps_sys_summ2_right_rcs_manf4_fuel_p");

p_dps_sys_summ2.fwd_rcs_manf1_oxid_p = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_manf1_oxid_p");
p_dps_sys_summ2.fwd_rcs_manf1_fuel_p = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_manf1_fuel_p");
p_dps_sys_summ2.fwd_rcs_manf2_oxid_p = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_manf2_oxid_p");
p_dps_sys_summ2.fwd_rcs_manf2_fuel_p = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_manf2_fuel_p");
p_dps_sys_summ2.fwd_rcs_manf3_oxid_p = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_manf3_oxid_p");
p_dps_sys_summ2.fwd_rcs_manf3_fuel_p = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_manf3_fuel_p");
p_dps_sys_summ2.fwd_rcs_manf4_oxid_p = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_manf4_oxid_p");
p_dps_sys_summ2.fwd_rcs_manf4_fuel_p = PFDsvg.getElementById("p_dps_sys_summ2_fwd_rcs_manf4_fuel_p");

p_dps_sys_summ2.left_oms_p_vlv = PFDsvg.getElementById("p_dps_sys_summ2_left_oms_p_vlv");
p_dps_sys_summ2.right_oms_p_vlv = PFDsvg.getElementById("p_dps_sys_summ2_right_oms_p_vlv");

p_dps_sys_summ2.left_oms_vlv1_p = PFDsvg.getElementById("p_dps_sys_summ2_left_oms_vlv1_p");
p_dps_sys_summ2.left_oms_vlv2_p = PFDsvg.getElementById("p_dps_sys_summ2_left_oms_vlv2_p");
p_dps_sys_summ2.right_oms_vlv1_p = PFDsvg.getElementById("p_dps_sys_summ2_right_oms_vlv1_p");
p_dps_sys_summ2.right_oms_vlv2_p = PFDsvg.getElementById("p_dps_sys_summ2_right_oms_vlv2_p");

p_dps_sys_summ2.left_oms_n2_p = PFDsvg.getElementById("p_dps_sys_summ2_left_oms_n2_p");
p_dps_sys_summ2.right_oms_n2_p = PFDsvg.getElementById("p_dps_sys_summ2_right_oms_n2_p");
p_dps_sys_summ2.left_oms_reg_p = PFDsvg.getElementById("p_dps_sys_summ2_left_oms_reg_p");
p_dps_sys_summ2.right_oms_reg_p = PFDsvg.getElementById("p_dps_sys_summ2_right_oms_reg_p");

p_dps_sys_summ2.left_oms_oxid_ei_p = PFDsvg.getElementById("p_dps_sys_summ2_left_oms_oxid_ei_p");
p_dps_sys_summ2.left_oms_fuel_ei_p = PFDsvg.getElementById("p_dps_sys_summ2_left_oms_fuel_ei_p");
p_dps_sys_summ2.right_oms_oxid_ei_p = PFDsvg.getElementById("p_dps_sys_summ2_right_oms_oxid_ei_p");
p_dps_sys_summ2.right_oms_fuel_ei_p = PFDsvg.getElementById("p_dps_sys_summ2_right_oms_fuel_ei_p");


p_dps_sys_summ2.bfs_inj_t_text = PFDsvg.getElementById("p_dps_sys_summ2_text5a");
p_dps_sys_summ2.bfs_inj_t_l = PFDsvg.getElementById("p_dps_sys_summ2_fu_inj_t_l");
p_dps_sys_summ2.bfs_inj_t_r = PFDsvg.getElementById("p_dps_sys_summ2_fu_inj_t_r");




p_dps_sys_summ2.ondisplay = func
{
var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");

var ops_string = major_mode~"1/   /019";


DPS_menu_title.setText(sprintf("%s","GNC SYS SUMM 2"));
DPS_menu_ops.setText(sprintf("%s",ops_string));
MEDS_menu_title.setText(sprintf("%s","       DPS MENU"));

# blank the BFS-only properties

p_dps_sys_summ2.bfs_inj_t_text.setText(sprintf(""));
p_dps_sys_summ2.bfs_inj_t_l.setText(sprintf(""));
p_dps_sys_summ2.bfs_inj_t_r.setText(sprintf(""));

}

p_dps_sys_summ2.update = func
{


update_common_DPS();


p_dps_sys_summ2.f1_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-1-status"))));
p_dps_sys_summ2.f2_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-2-status"))));
p_dps_sys_summ2.f3_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-3-status"))));
p_dps_sys_summ2.f4_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-4-status"))));
p_dps_sys_summ2.f5_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-fwd-rcs-valve-5-status"))));

p_dps_sys_summ2.f1_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-f1"))));
p_dps_sys_summ2.f2_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-f2"))));
p_dps_sys_summ2.f3_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-f3"))));
p_dps_sys_summ2.f4_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-f4"))));
p_dps_sys_summ2.f5_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-f5"))));

p_dps_sys_summ2.l1_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-1-status"))));
p_dps_sys_summ2.l2_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-2-status"))));
p_dps_sys_summ2.l3_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-3-status"))));
p_dps_sys_summ2.l4_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-4-status"))));
p_dps_sys_summ2.l5_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-left-rcs-valve-5-status"))));

p_dps_sys_summ2.l1_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-l1"))));
p_dps_sys_summ2.l2_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-l2"))));
p_dps_sys_summ2.l3_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-l3"))));
p_dps_sys_summ2.l4_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-l4"))));
p_dps_sys_summ2.l5_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-l5"))));

p_dps_sys_summ2.r1_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-1-status"))));
p_dps_sys_summ2.r2_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-2-status"))));
p_dps_sys_summ2.r3_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-3-status"))));
p_dps_sys_summ2.r4_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-4-status"))));
p_dps_sys_summ2.r5_vlv.setText(sprintf("%s", valve_status_to_string(getprop("/fdm/jsbsim/systems/rcs-hardware/mfold-right-rcs-valve-5-status"))));

p_dps_sys_summ2.r1_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-r1"))));
p_dps_sys_summ2.r2_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-r2"))));
p_dps_sys_summ2.r3_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-r3"))));
p_dps_sys_summ2.r4_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-r4"))));
p_dps_sys_summ2.r5_fail.setText(sprintf("%s", jet_status_to_string(getprop("/fdm/jsbsim/systems/cws/jet-fail-r5"))));


p_dps_sys_summ2.left_oms_fu_qty.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[5]/level-lbs")/47.180));
p_dps_sys_summ2.left_oms_oxid_qty.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[4]/level-lbs")/77.730));

p_dps_sys_summ2.right_oms_fu_qty.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[7]/level-lbs")/47.180));
p_dps_sys_summ2.right_oms_oxid_qty.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[6]/level-lbs")/77.730));

p_dps_sys_summ2.fwd_rcs_fu_qty.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[13]/level-lbs")/9.280));
p_dps_sys_summ2.fwd_rcs_oxid_qty.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[12]/level-lbs")/14.770));

p_dps_sys_summ2.left_rcs_fu_qty.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[9]/level-lbs")/9.280));
p_dps_sys_summ2.left_rcs_oxid_qty.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[8]/level-lbs")/14.770));

p_dps_sys_summ2.right_rcs_fu_qty.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[11]/level-lbs")/9.280));
p_dps_sys_summ2.right_rcs_oxid_qty.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[10]/level-lbs")/14.770));

p_dps_sys_summ2.fwd_rcs_oxid_he_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/helium-fwd-rcs-pressure-1-sh-psia")));
p_dps_sys_summ2.fwd_rcs_fu_he_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/helium-fwd-rcs-pressure-2-sh-psia")));
p_dps_sys_summ2.fwd_rcs_oxid_tk_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-fwd-rcs-blowdown-psia")));
p_dps_sys_summ2.fwd_rcs_fu_tk_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-fwd-rcs-blowdown-psia")));

p_dps_sys_summ2.left_rcs_oxid_he_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/helium-left-rcs-pressure-1-sh-psia")));
p_dps_sys_summ2.left_rcs_fu_he_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/helium-left-rcs-pressure-2-sh-psia")));
p_dps_sys_summ2.left_rcs_oxid_tk_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-left-rcs-blowdown-psia")));
p_dps_sys_summ2.left_rcs_fu_tk_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-left-rcs-blowdown-psia")));

p_dps_sys_summ2.right_rcs_oxid_he_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/helium-right-rcs-pressure-1-sh-psia")));
p_dps_sys_summ2.right_rcs_fu_he_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/helium-right-rcs-pressure-2-sh-psia")));
p_dps_sys_summ2.right_rcs_oxid_tk_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-right-rcs-blowdown-psia")));
p_dps_sys_summ2.right_rcs_fu_tk_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/tanks-right-rcs-blowdown-psia")));

p_dps_sys_summ2.left_oms_he_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/helium-left-oms-pressure-sh-psia")));
p_dps_sys_summ2.right_oms_he_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/helium-right-oms-pressure-sh-psia")));
p_dps_sys_summ2.left_oms_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/tanks-left-oms-blowdown-psia")));
p_dps_sys_summ2.right_oms_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/tanks-right-oms-blowdown-psia"))); 
p_dps_sys_summ2.left_oms_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/tanks-left-oms-blowdown-psia")));
p_dps_sys_summ2.right_oms_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/tanks-right-oms-blowdown-psia")));

p_dps_sys_summ2.left_rcs_manf1_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold1-oxidizer-pressure-psia")));
p_dps_sys_summ2.left_rcs_manf1_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold1-fuel-pressure-psia")));
p_dps_sys_summ2.left_rcs_manf2_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold2-oxidizer-pressure-psia")));
p_dps_sys_summ2.left_rcs_manf2_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold2-fuel-pressure-psia"))); 
p_dps_sys_summ2.left_rcs_manf3_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold3-oxidizer-pressure-psia")));
p_dps_sys_summ2.left_rcs_manf3_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold3-fuel-pressure-psia")));
p_dps_sys_summ2.left_rcs_manf4_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold4-oxidizer-pressure-psia")));
p_dps_sys_summ2.left_rcs_manf4_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/left-mfold4-fuel-pressure-psia"))); 

p_dps_sys_summ2.right_rcs_manf1_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold1-oxidizer-pressure-psia")));
p_dps_sys_summ2.right_rcs_manf1_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold1-fuel-pressure-psia")));
p_dps_sys_summ2.right_rcs_manf2_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold2-oxidizer-pressure-psia")));
p_dps_sys_summ2.right_rcs_manf2_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold2-fuel-pressure-psia"))); 
p_dps_sys_summ2.right_rcs_manf3_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold3-oxidizer-pressure-psia")));
p_dps_sys_summ2.right_rcs_manf3_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold3-fuel-pressure-psia")));
p_dps_sys_summ2.right_rcs_manf4_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold4-oxidizer-pressure-psia")));
p_dps_sys_summ2.right_rcs_manf4_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/right-mfold4-fuel-pressure-psia"))); 

p_dps_sys_summ2.fwd_rcs_manf1_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold1-oxidizer-pressure-psia")));
p_dps_sys_summ2.fwd_rcs_manf1_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold1-fuel-pressure-psia")));
p_dps_sys_summ2.fwd_rcs_manf2_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold2-oxidizer-pressure-psia")));
p_dps_sys_summ2.fwd_rcs_manf2_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold2-fuel-pressure-psia"))); 
p_dps_sys_summ2.fwd_rcs_manf3_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold3-oxidizer-pressure-psia")));
p_dps_sys_summ2.fwd_rcs_manf3_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold3-fuel-pressure-psia")));
p_dps_sys_summ2.fwd_rcs_manf4_oxid_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold4-oxidizer-pressure-psia")));
p_dps_sys_summ2.fwd_rcs_manf4_fuel_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/rcs-hardware/fwd-mfold4-fuel-pressure-psia"))); 

p_dps_sys_summ2.left_oms_p_vlv.setText(sprintf(" %s", valve_status_to_string(getprop("/fdm/jsbsim/systems/oms-hardware/engine-left-arm-cmd"))));
p_dps_sys_summ2.right_oms_p_vlv.setText(sprintf(" %s", valve_status_to_string(getprop("/fdm/jsbsim/systems/oms-hardware/engine-right-arm-cmd"))));

var throttle_left_percent = 100.0 * getprop("/fdm/jsbsim/fcs/throttle-cmd-norm[5]");
var throttle_right_percent = 100.0 * getprop("/fdm/jsbsim/fcs/throttle-cmd-norm[6]");

p_dps_sys_summ2.left_oms_vlv1_p.setText(sprintf("%3.0f", throttle_left_percent));
p_dps_sys_summ2.left_oms_vlv2_p.setText(sprintf("%3.0f", throttle_left_percent));
p_dps_sys_summ2.right_oms_vlv1_p.setText(sprintf("%3.0f", throttle_right_percent)); 
p_dps_sys_summ2.right_oms_vlv2_p.setText(sprintf("%3.0f", throttle_right_percent));


p_dps_sys_summ2.left_oms_n2_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/n2-left-oms-pressure-psia")));
p_dps_sys_summ2.right_oms_n2_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/n2-right-oms-pressure-psia")));
p_dps_sys_summ2.left_oms_reg_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/n2-left-reg-pressure-psia")));
p_dps_sys_summ2.right_oms_reg_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/n2-right-reg-pressure-psia")));

p_dps_sys_summ2.left_oms_oxid_ei_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/chamber-left-inlet-oxidizer-pressure-psia")));
p_dps_sys_summ2.left_oms_fuel_ei_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/chamber-left-inlet-fuel-pressure-psia"))); 
p_dps_sys_summ2.right_oms_oxid_ei_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/chamber-right-inlet-oxidizer-pressure-psia"))); 
p_dps_sys_summ2.right_oms_fuel_ei_p.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/oms-hardware/chamber-right-inlet-fuel-pressure-psia")));

}

#################################################################
# the ascent PFD page showing the vertical trajectory status
#################################################################

var p_ascent = PFD.addPage("Ascent", "p_ascent");

#
#
# Ascent page update
var p_ascent_view = PFDsvg.getElementById("ascent_view");
SpaceShuttle.fill_traj1_data();
var p_ascent_time = 0;
var p_ascent_next_update = 0;


var p_ascent_shuttle_sym = PFDcanvas.createGroup();
canvas.parsesvg( p_ascent_shuttle_sym, "/Nasal/canvas/map/Images/boeingAirplane.svg");
p_ascent_shuttle_sym.setScale(0.3);

p_ascent.throttle = PFDsvg.getElementById("p_ascent_throttle");
p_ascent.throttle_text = PFDsvg.getElementById("p_ascent_throttle_txt");

p_ascent.prplt = PFDsvg.getElementById("p_ascent_prplt");
p_ascent.prplt_text = PFDsvg.getElementById("p_ascent_prplt_txt");

p_ascent.ondisplay = func
{
    # called once whenever this page goes on display/
    p_ascent_shuttle_sym.setScale(0.3);
    MEDS_menu_title.setText(sprintf("%s","       DPS MENU"));
}

p_ascent.offdisplay = func
{
    nom_traj_plot.removeAllChildren();
    p_ascent_shuttle_sym.setScale(0.0);

    set_DPS_off();
}

p_ascent.update = func
{



update_common_DPS();

if (SpaceShuttle.traj_display_flag < 3)
	{
	var throttle = getprop("/controls/engines/engine[0]/throttle");
	if (throttle < 0.67) {throttle = 0.0;} else {throttle = throttle * 100.0;}
	p_ascent.throttle.setText(sprintf("%3.0f",throttle));
	p_ascent.throttle_text.setText(sprintf("THROT"));
	}
else
	{
	p_ascent.throttle.setText(sprintf(""));
	p_ascent.throttle_text.setText(sprintf(""));
	}

if (SpaceShuttle.traj_display_flag == 2)
	{
	p_ascent.prplt.setText(sprintf("%3.0f",100.0* getprop("/consumables/fuel/tank/level-norm")));
	p_ascent.prplt_text.setText(sprintf("PRPLT"));
	}
else 	
	{
	p_ascent.prplt.setText(sprintf(""));
	p_ascent.prplt_text.setText(sprintf(""));
	}

nom_traj_plot.removeAllChildren();

SpaceShuttle.ascent_traj_update_set();

var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");

if (SpaceShuttle.traj_display_flag == 1)
	{
	if (major_mode == 101)
		{DPS_menu_title.setText(sprintf("%s","LAUNCH TRAJ"));}
	else
		{DPS_menu_title.setText(sprintf("%s","ASCENT TRAJ 1"));}

		DPS_menu_ops.setText(sprintf("%s", major_mode~"1/     /"));
	}
else if ((SpaceShuttle.traj_display_flag == 2) or (major_mode == 103))
	{
	DPS_menu_title.setText(sprintf("%s","ASCENT TRAJ 2"));
	DPS_menu_ops.setText(sprintf("%s","1031/     /"));
	}



var plot = nom_traj_plot.createChild("path", "data")
                                   .setStrokeLineWidth(2)
                                   .setColor(0.5,0.6,0.5)
                                   .moveTo(traj_data[0][0],traj_data[0][1]); 

		for (var i = 1; i< (size(traj_data)-1); i=i+1)
			{
			var set = traj_data[i+1];
			plot.lineTo(set[0], set[1]);	
			}

var velocity = SpaceShuttle.ascent_traj_update_velocity();
var altitude = getprop("/position/altitude-ft");


var x = SpaceShuttle.parameter_to_x(velocity, SpaceShuttle.traj_display_flag);
var y = SpaceShuttle.parameter_to_y(altitude, SpaceShuttle.traj_display_flag);
	
p_ascent_shuttle_sym.setTranslation(x,y);


};




#################################################################
# the entry PFD page showing the vertical trajectory status
#################################################################

var p_entry = PFD.addPage("Entry", "p_entry");

p_entry.D_az = PFDsvg.getElementById("p_entry_D_az");
p_entry.qbar = PFDsvg.getElementById("p_entry_qbar");
p_entry.dref = PFDsvg.getElementById("p_entry_dref");
p_entry.bias = PFDsvg.getElementById("p_entry_bias");




p_entry.ondisplay = func
{
    # called once whenever this page goes on display

p_entry.bias.setText(sprintf("%s","+00"));
p_ascent_shuttle_sym.setScale(0.3);
MEDS_menu_title.setText(sprintf("%s","       DPS MENU"));
}

p_entry.offdisplay = func
{
    nom_traj_plot.removeAllChildren();
    p_ascent_shuttle_sym.setScale(0.0);

    set_DPS_off();
}

p_entry.update = func
{



update_common_DPS();


nom_traj_plot.removeAllChildren();

SpaceShuttle.ascent_traj_update_set();

var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");


if  ((SpaceShuttle.traj_display_flag == 3) and (major_mode == 304))
	{
	DPS_menu_title.setText(sprintf("%s","ENTRY TRAJ 1"));
	DPS_menu_ops.setText(sprintf("%s","3041/     /"));
	}
else if ((SpaceShuttle.traj_display_flag == 4) and (major_mode == 304))
	{
	DPS_menu_title.setText(sprintf("%s","ENTRY TRAJ 2"));
	}
else if ((SpaceShuttle.traj_display_flag == 5) and (major_mode == 304))
	{
	DPS_menu_title.setText(sprintf("%s","ENTRY TRAJ 3"));
	}
else if (( SpaceShuttle.traj_display_flag == 6) and (major_mode == 304))
	{
	DPS_menu_title.setText(sprintf("%s","ENTRY TRAJ 4"));
	}
else if ((SpaceShuttle.traj_display_flag == 7)and (major_mode == 304))
	{
	DPS_menu_title.setText(sprintf("%s","ENTRY TRAJ 5"));
	}



var plot = nom_traj_plot.createChild("path", "data")
                                   .setStrokeLineWidth(2)
                                   .setColor(0.5,0.6,0.5)
                                   .moveTo(traj_data[0][0],traj_data[0][1]); 

		for (var i = 1; i< (size(traj_data)-1); i=i+1)
			{
			var set = traj_data[i+1];
			plot.lineTo(set[0], set[1]);	
			}

var velocity = SpaceShuttle.ascent_traj_update_velocity();
var altitude = getprop("/position/altitude-ft");


var range = getprop("/fdm/jsbsim/systems/entry_guidance/remaining-distance-nm");
var x = SpaceShuttle.parameter_to_x(range, SpaceShuttle.traj_display_flag);
var y = SpaceShuttle.parameter_to_y(velocity, SpaceShuttle.traj_display_flag);
	


p_ascent_shuttle_sym.setTranslation(x,y);


p_entry.D_az.setText(sprintf("%3.0f",getprop("/fdm/jsbsim/systems/entry_guidance/delta-azimuth-deg")));
p_entry.qbar.setText(sprintf("%3.1f",getprop("/fdm/jsbsim/aero/qbar-psf")));
p_entry.dref.setText(sprintf("%3.1f",-32.18 * getprop("/accelerations/nlf")));

};



#################################################################
# the vertical situation PFD page showing the TAEM guidance
#################################################################

var p_vert_sit = PFD.addPage("VertSit", "p_vert_sit");



p_vert_sit.ondisplay = func
{
SpaceShuttle.fill_vert_sit1_nom_data();
SpaceShuttle.fill_vert_sit1_SB_data();
SpaceShuttle.fill_vert_sit1_maxLD_data();
SpaceShuttle.traj_display_flag = 8;
p_ascent_shuttle_sym.setScale(0.3);
MEDS_menu_title.setText(sprintf("%s","       DPS MENU"));
DPS_menu_ops.setText(sprintf("%s","3051/     /"));
}

p_vert_sit.offdisplay = func
{
    nom_traj_plot.removeAllChildren();
    limit1_traj_plot.removeAllChildren();
    limit2_traj_plot.removeAllChildren();
    p_ascent_shuttle_sym.setScale(0.0);
    set_DPS_off();
}

p_vert_sit.update = func
{

update_common_DPS();

nom_traj_plot.removeAllChildren();
limit1_traj_plot.removeAllChildren();
limit2_traj_plot.removeAllChildren();

SpaceShuttle.ascent_traj_update_set();




if  (SpaceShuttle.traj_display_flag == 8)
	{
	DPS_menu_title.setText(sprintf("%s","VERT SIT 1"));
	}
else
	{
	DPS_menu_title.setText(sprintf("%s","VERT SIT 2"));
	}


var plot = nom_traj_plot.createChild("path", "data")
                                   .setStrokeLineWidth(2)
                                   .setColor(0.5,0.6,0.5)
                                   .moveTo(traj_data[0][0],traj_data[0][1]); 

		for (var i = 1; i< (size(traj_data)-1); i=i+1)
			{
			var set = traj_data[i+1];
			plot.lineTo(set[0], set[1]);	
			}

var plot_limit1 = limit1_traj_plot.createChild("path", "data")
                                   .setStrokeLineWidth(1)
                                   .setColor(0.5,0.6,0.5)
                                   .moveTo(limit1_data[0][0],limit1_data[0][1]); 

		for (var i = 1; i< (size(limit1_data)-1); i=i+1)
			{
			var set = limit1_data[i+1];
			plot_limit1.lineTo(set[0], set[1]);	
			}

var plot_limit2 = limit2_traj_plot.createChild("path", "data")
                                   .setStrokeLineWidth(1)
                                   .setColor(0.5,0.6,0.5)
                                   .moveTo(limit2_data[0][0],limit2_data[0][1]); 

		for (var i = 1; i< (size(limit2_data)-1); i=i+1)
			{
			var set = limit2_data[i+1];
			plot_limit2.lineTo(set[0], set[1]);	
			}

if (SpaceShuttle.TAEM_guidance_available == 1)
	{
	var altitude = getprop("/position/altitude-ft");
	var range = getprop("/fdm/jsbsim/systems/taem-guidance/distance-to-runway-nm");
	var x = SpaceShuttle.parameter_to_x(range, SpaceShuttle.traj_display_flag);
	var y = SpaceShuttle.parameter_to_y(altitude, SpaceShuttle.traj_display_flag);
	
	p_ascent_shuttle_sym.setTranslation(x,y);
	}


};



#################################################################
# the maneuver page
#################################################################

var p_dps_mnvr = PFD.addPage("CRTMnvr", "p_dps_mnvr");

p_dps_mnvr.oms_pitch_left = PFDsvg.getElementById("p_dps_mnvr_gmbl_l_pitch");
p_dps_mnvr.oms_pitch_right = PFDsvg.getElementById("p_dps_mnvr_gmbl_r_pitch");
p_dps_mnvr.oms_yaw_left = PFDsvg.getElementById("p_dps_mnvr_gmbl_l_yaw");
p_dps_mnvr.oms_yaw_right = PFDsvg.getElementById("p_dps_mnvr_gmbl_r_yaw");

p_dps_mnvr.current_apoapsis = PFDsvg.getElementById("p_dps_mnvr_ha_cur");
p_dps_mnvr.current_periapsis = PFDsvg.getElementById("p_dps_mnvr_hp_cur");
p_dps_mnvr.ha_tgt = PFDsvg.getElementById("p_dps_mnvr_ha_tgt");
p_dps_mnvr.hp_tgt = PFDsvg.getElementById("p_dps_mnvr_hp_tgt");

p_dps_mnvr.fwd_rcs_dump = PFDsvg.getElementById("p_dps_mnvr_fwd_rcs_dump");
p_dps_mnvr.fwd_rcs_arm = PFDsvg.getElementById("p_dps_mnvr_fwd_rcs_arm");
p_dps_mnvr.fwd_rcs_off = PFDsvg.getElementById("p_dps_mnvr_fwd_rcs_off");

p_dps_mnvr.surf_drive_on = PFDsvg.getElementById("p_dps_mnvr_surf_drive_on");
p_dps_mnvr.surf_drive_off = PFDsvg.getElementById("p_dps_mnvr_surf_drive_off");

p_dps_mnvr.oms_both = PFDsvg.getElementById("p_dps_mnvr_oms_both");
p_dps_mnvr.oms_l = PFDsvg.getElementById("p_dps_mnvr_oms_l");
p_dps_mnvr.oms_r = PFDsvg.getElementById("p_dps_mnvr_oms_r");
p_dps_mnvr.rcs_sel = PFDsvg.getElementById("p_dps_mnvr_rcs_sel");

p_dps_mnvr.tv_roll = PFDsvg.getElementById("p_dps_mnvr_tv_roll");

p_dps_mnvr.p = PFDsvg.getElementById("p_dps_mnvr_p");
p_dps_mnvr.ly = PFDsvg.getElementById("p_dps_mnvr_ly");
p_dps_mnvr.ry = PFDsvg.getElementById("p_dps_mnvr_ry");

p_dps_mnvr.wt = PFDsvg.getElementById("p_dps_mnvr_wt");

p_dps_mnvr.tig = PFDsvg.getElementById("p_dps_mnvr_tig");

p_dps_mnvr.dvx = PFDsvg.getElementById("p_dps_mnvr_dvx");
p_dps_mnvr.dvy = PFDsvg.getElementById("p_dps_mnvr_dvy");
p_dps_mnvr.dvz = PFDsvg.getElementById("p_dps_mnvr_dvz");

p_dps_mnvr.load = PFDsvg.getElementById("p_dps_mnvr_load");

p_dps_mnvr.burn_att_roll = PFDsvg.getElementById("p_dps_mnvr_burn_att_roll");
p_dps_mnvr.burn_att_pitch = PFDsvg.getElementById("p_dps_mnvr_burn_att_pitch");
p_dps_mnvr.burn_att_yaw = PFDsvg.getElementById("p_dps_mnvr_burn_att_yaw");

p_dps_mnvr.mnvr = PFDsvg.getElementById("p_dps_mnvr_mnvr");
p_dps_mnvr.active_dap = PFDsvg.getElementById("p_dps_mnvr_active_dap");

p_dps_mnvr.dvtot = PFDsvg.getElementById("p_dps_mnvr_dvtot");
p_dps_mnvr.tgo = PFDsvg.getElementById("p_dps_mnvr_tgo");

p_dps_mnvr.exec = PFDsvg.getElementById("p_dps_mnvr_exec_msg");

p_dps_mnvr.ttapsis_text = PFDsvg.getElementById("p_dps_mnvr_ttapsis_text");
p_dps_mnvr.ttapsis = PFDsvg.getElementById("p_dps_mnvr_ttapsis");

p_dps_mnvr.vgo_x = PFDsvg.getElementById("p_dps_mnvr_vgo_x");
p_dps_mnvr.vgo_y = PFDsvg.getElementById("p_dps_mnvr_vgo_y");
p_dps_mnvr.vgo_z = PFDsvg.getElementById("p_dps_mnvr_vgo_z");


p_dps_mnvr.pri_l = PFDsvg.getElementById("p_dps_mnvr_pri_l");
p_dps_mnvr.pri_r = PFDsvg.getElementById("p_dps_mnvr_pri_r");
p_dps_mnvr.sec_l = PFDsvg.getElementById("p_dps_mnvr_sec_l");
p_dps_mnvr.sec_r = PFDsvg.getElementById("p_dps_mnvr_sec_r");
p_dps_mnvr.off_l = PFDsvg.getElementById("p_dps_mnvr_off_l");
p_dps_mnvr.off_r = PFDsvg.getElementById("p_dps_mnvr_off_r");
p_dps_mnvr.gmbl_ck = PFDsvg.getElementById("p_dps_mnvr_gmbl_ck");

p_dps_mnvr.blink = 0;



p_dps_mnvr.ondisplay = func
{
var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");

var string1 = "";

if (major_mode == 104)
	{string1 = "OMS 1 ";}
else if (major_mode == 105)
	{string1 = "OMS 2 ";}
else if (major_mode == 202)
	{string1 = "ORBIT ";}

var string2 = " EXEC";

if ((major_mode == 106) or (major_mode == 301) or (major_mode == 303))
	{string2 = " COAST";}

var weight = getprop("/fdm/jsbsim/systems/ap/oms-plan/weight");
if (weight ==0) {setprop("/fdm/jsbsim/systems/ap/oms-plan/weight", getprop("/fdm/jsbsim/inertia/weight-lbs"));}

p_dps_mnvr.load.setText(sprintf("%s","LOAD"));

DPS_menu_title.setText(sprintf("%s",string1~"MNVR"~string2));
DPS_menu_ops.setText(sprintf("%s",major_mode~"1/    /"));
MEDS_menu_title.setText(sprintf("%s","       DPS MENU"));
}


p_dps_mnvr.update = func
{

update_common_DPS();


p_dps_mnvr.oms_pitch_left.setText(sprintf("%1.1f",getprop("/fdm/jsbsim/propulsion/engine[5]/pitch-angle-rad") * 57.297));
p_dps_mnvr.oms_pitch_right.setText(sprintf("%1.1f",getprop("/fdm/jsbsim/propulsion/engine[6]/pitch-angle-rad") * 57.297));
p_dps_mnvr.oms_yaw_left.setText(sprintf("%1.1f",getprop("/fdm/jsbsim/propulsion/engine[5]/yaw-angle-rad") * 57.297));
p_dps_mnvr.oms_yaw_right.setText(sprintf("%1.1f",getprop("/fdm/jsbsim/propulsion/engine[6]/yaw-angle-rad") * 57.297));

p_dps_mnvr.current_apoapsis.setText(sprintf("%3.0f",getprop("/fdm/jsbsim/systems/orbital/apoapsis-km")/1.853));
p_dps_mnvr.current_periapsis.setText(sprintf("%3.0f",getprop("/fdm/jsbsim/systems/orbital/periapsis-km")/1.853));

p_dps_mnvr.ha_tgt.setText(sprintf("%3.0f",getprop("/fdm/jsbsim/systems/ap/oms-plan/apoapsis-nm")));
p_dps_mnvr.hp_tgt.setText(sprintf("%3.0f",getprop("/fdm/jsbsim/systems/ap/oms-plan/periapsis-nm")));

var fwd_rcs_dump = getprop("/fdm/jsbsim/systems/rcs/fwd-dump-cmd");
var fwd_rcs_dump_arm = getprop("/fdm/jsbsim/systems/rcs/fwd-dump-arm-cmd");

if ((fwd_rcs_dump == 0) and (fwd_rcs_dump_arm == 0))
	{
	p_dps_mnvr.fwd_rcs_off.setText(sprintf("%s","*"));
	p_dps_mnvr.fwd_rcs_arm.setText(sprintf("%s",""));
	p_dps_mnvr.fwd_rcs_dump.setText(sprintf("%s",""));
	}
else if ((fwd_rcs_dump_arm == 1) and (fwd_rcs_dump == 0))
	{
	p_dps_mnvr.fwd_rcs_off.setText(sprintf("%s",""));
	p_dps_mnvr.fwd_rcs_arm.setText(sprintf("%s","*"));
	p_dps_mnvr.fwd_rcs_dump.setText(sprintf("%s",""));
	}
else
	{
	p_dps_mnvr.fwd_rcs_off.setText(sprintf("%s",""));
	p_dps_mnvr.fwd_rcs_arm.setText(sprintf("%s","*"));
	p_dps_mnvr.fwd_rcs_dump.setText(sprintf("%s","*"));
	}

var control_mode = getprop("/fdm/jsbsim/systems/fcs/control-mode");

if ((control_mode == 24) or (control_mode == 29))
	{
	p_dps_mnvr.surf_drive_on.setText(sprintf("%s","*"));
	p_dps_mnvr.surf_drive_off.setText(sprintf("%s",""));
	}
else
	{
	p_dps_mnvr.surf_drive_on.setText(sprintf("%s",""));
	p_dps_mnvr.surf_drive_off.setText(sprintf("%s","*"));
	}

# right now, we don't have the capability to use single OMS engine burns

p_dps_mnvr.oms_both.setText(sprintf("%s","*"));
p_dps_mnvr.oms_l.setText(sprintf("%s",""));
p_dps_mnvr.oms_r.setText(sprintf("%s",""));
p_dps_mnvr.rcs_sel.setText(sprintf("%s",""));


p_dps_mnvr.tv_roll.setText(sprintf("%3.0f",getprop("fdm/jsbsim/systems/ap/oms-plan/tv-roll")));

p_dps_mnvr.p.setText(sprintf("%1.1f",getprop("fdm/jsbsim/systems/ap/oms-plan/trim-pitch")));
p_dps_mnvr.ly.setText(sprintf("%1.1f",getprop("fdm/jsbsim/systems/ap/oms-plan/trim-yaw-left")));
p_dps_mnvr.ry.setText(sprintf("%1.1f",getprop("fdm/jsbsim/systems/ap/oms-plan/trim-yaw-right")));

p_dps_mnvr.wt.setText(sprintf("%6.0f",getprop("fdm/jsbsim/systems/ap/oms-plan/weight")));

p_dps_mnvr.tig.setText(sprintf("%s",getprop("fdm/jsbsim/systems/ap/oms-plan/tig")));

p_dps_mnvr.dvx.setText(sprintf("%4.1f",getprop("fdm/jsbsim/systems/ap/oms-plan/dvx")));
p_dps_mnvr.dvy.setText(sprintf("%3.1f",getprop("fdm/jsbsim/systems/ap/oms-plan/dvy")));
p_dps_mnvr.dvz.setText(sprintf("%3.1f",getprop("fdm/jsbsim/systems/ap/oms-plan/dvz")));

var tgt_roll = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/tgt-roll-deg");
var tgt_pitch = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/tgt-pitch-deg");
var tgt_yaw = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/tgt-yaw-deg");

p_dps_mnvr.burn_att_roll.setText(sprintf("%+3.2f",tgt_roll));
p_dps_mnvr.burn_att_pitch.setText(sprintf("%+3.2f",tgt_pitch));
p_dps_mnvr.burn_att_yaw.setText(sprintf("%+3.2f",tgt_yaw));

var oms_mnvr_flag = getprop("/fdm/jsbsim/systems/ap/oms-mnvr-flag");
var oms_mnvr_text = "MNVR 27";
if (oms_mnvr_flag == 1) {oms_mnvr_text = "MNVR 27*";}

var dap_text = "FREE";
if (getprop("/fdm/jsbsim/systems/ap/orbital-dap-auto") == 1)
	{dap_text = "AUTO";}
else if(getprop("/fdm/jsbsim/systems/ap/orbital-dap-inertial") == 1)
	{dap_text = "INTRL";}
else if(getprop("/fdm/jsbsim/systems/ap/orbital-dap-lvlh") == 1)
	{dap_text = "LVLH";}


p_dps_mnvr.mnvr.setText(sprintf("%s",oms_mnvr_text));
p_dps_mnvr.active_dap.setText(sprintf("%s",dap_text));


p_dps_mnvr.dvtot.setText(sprintf("%+4.2f",getprop("/fdm/jsbsim/systems/ap/oms-plan/dvtot")));
p_dps_mnvr.tgo.setText(sprintf("%s",getprop("/fdm/jsbsim/systems/ap/oms-plan/tgo-string")));

var attitude_flag = getprop("/fdm/jsbsim/systems/ap/track/in-attitude");
var burn_plan = getprop("/fdm/jsbsim/systems/ap/oms-plan/burn-plan-available");


if (burn_plan == 0)
	{p_dps_mnvr.load.setText(sprintf("%s","LOAD"));}
else
	{p_dps_mnvr.load.setText(sprintf("%s","CNCL"));}

var exec_string = "";

if ((attitude_flag == 1) and (burn_plan == 1))
	{
	exec_string = "EXEC";
	var oms_ignited = getprop("/fdm/jsbsim/systems/ap/oms-plan/oms-ignited");
	
	if (oms_ignited == 0) # blink before ignition
		{
		if (p_dps_mnvr.blink == 0) 
			{p_dps_mnvr.blink = 1; exec_string = "";}
		else
			{p_dps_mnvr.blink = 0;}
		}
	}

p_dps_mnvr.exec.setText(sprintf("%s",exec_string));

var tta = SpaceShuttle.time_to_apsis();

var tta_string = "TTP";
if (tta[0] = 2) {tta_string = "TTA";}

var tta_time = SpaceShuttle.seconds_to_stringMS(tta[1]);

p_dps_mnvr.ttapsis_text.setText(sprintf("%s",tta_string));
p_dps_mnvr.ttapsis.setText(sprintf("%s",tta_time));

p_dps_mnvr.vgo_x.setText(sprintf("%4.1f",getprop("fdm/jsbsim/systems/ap/oms-plan/vgo-x")));
p_dps_mnvr.vgo_y.setText(sprintf("%3.1f",getprop("fdm/jsbsim/systems/ap/oms-plan/vgo-y")));
p_dps_mnvr.vgo_z.setText(sprintf("%3.1f",getprop("fdm/jsbsim/systems/ap/oms-plan/vgo-z"))); 


var gimbal_l_pri = getprop("/fdm/jsbsim/systems/oms-hardware/gimbal-left-pri-selected");
var gimbal_l_sec = getprop("/fdm/jsbsim/systems/oms-hardware/gimbal-left-sec-selected");
var gimbal_r_pri = getprop("/fdm/jsbsim/systems/oms-hardware/gimbal-right-pri-selected");
var gimbal_r_sec = getprop("/fdm/jsbsim/systems/oms-hardware/gimbal-right-sec-selected");

var gsym1 = ""; var gsym2 = ""; var gsym3 = "";

if (gimbal_l_pri == 1) {gsym1 = "*";}
else if (gimbal_l_sec == 1) {gsym2 = "*";}
else {gsym3 = "*";}

p_dps_mnvr.pri_l.setText(sprintf("%s", gsym1));
p_dps_mnvr.sec_l.setText(sprintf("%s", gsym2));
p_dps_mnvr.off_l.setText(sprintf("%s", gsym3));

gsym1 = ""; gsym2 = ""; gsym3 = "";

if (gimbal_r_pri == 1) {gsym1 = "*";}
else if (gimbal_r_sec == 1) {gsym2 = "*";}
else {gsym3 = "*";}

p_dps_mnvr.pri_r.setText(sprintf("%s", gsym1));
p_dps_mnvr.sec_r.setText(sprintf("%s", gsym2));
p_dps_mnvr.off_r.setText(sprintf("%s", gsym3));

var gimbal_check = getprop("/fdm/jsbsim/systems/oms-hardware/gimbal-chk-cmd");

if (gimbal_check == 1) {gsym1 = "*";} else {gsym1 = "";}

p_dps_mnvr.gmbl_ck.setText(sprintf("%s", gsym1));
}

#################################################################
# the universal pointing page
#################################################################

var p_dps_univ_ptg = PFD.addPage("CRTUnivPtg", "p_dps_univ_ptg");

p_dps_univ_ptg.cur_roll = PFDsvg.getElementById("p_dps_univ_ptg_cur_roll");
p_dps_univ_ptg.cur_pitch = PFDsvg.getElementById("p_dps_univ_ptg_cur_pitch");
p_dps_univ_ptg.cur_yaw = PFDsvg.getElementById("p_dps_univ_ptg_cur_yaw");

p_dps_univ_ptg.rate_roll = PFDsvg.getElementById("p_dps_univ_ptg_rate_roll");
p_dps_univ_ptg.rate_pitch = PFDsvg.getElementById("p_dps_univ_ptg_rate_pitch");
p_dps_univ_ptg.rate_yaw = PFDsvg.getElementById("p_dps_univ_ptg_rate_yaw");

p_dps_univ_ptg.tgt_roll = PFDsvg.getElementById("p_dps_univ_ptg_reqd_roll");
p_dps_univ_ptg.tgt_pitch = PFDsvg.getElementById("p_dps_univ_ptg_reqd_pitch");
p_dps_univ_ptg.tgt_yaw = PFDsvg.getElementById("p_dps_univ_ptg_reqd_yaw");

p_dps_univ_ptg.err_roll = PFDsvg.getElementById("p_dps_univ_ptg_err_roll");
p_dps_univ_ptg.err_pitch = PFDsvg.getElementById("p_dps_univ_ptg_err_pitch");
p_dps_univ_ptg.err_yaw = PFDsvg.getElementById("p_dps_univ_ptg_err_yaw");



p_dps_univ_ptg.sel_maneuver = PFDsvg.getElementById("p_dps_univ_ptg_text6");
p_dps_univ_ptg.sel_track = PFDsvg.getElementById("p_dps_univ_ptg_text12");
p_dps_univ_ptg.sel_rot = PFDsvg.getElementById("p_dps_univ_ptg_text15");

p_dps_univ_ptg.body_vector = PFDsvg.getElementById("p_dps_univ_ptg_body_vect");

p_dps_univ_ptg.mo_roll = PFDsvg.getElementById("p_dps_univ_ptg_mo_roll");
p_dps_univ_ptg.mo_pitch = PFDsvg.getElementById("p_dps_univ_ptg_mo_pitch");
p_dps_univ_ptg.mo_yaw = PFDsvg.getElementById("p_dps_univ_ptg_mo_yaw");

p_dps_univ_ptg.tgt_id = PFDsvg.getElementById("p_dps_univ_ptg_tgt_id");
p_dps_univ_ptg.ra = PFDsvg.getElementById("p_dps_univ_ptg_ra");
p_dps_univ_ptg.dec = PFDsvg.getElementById("p_dps_univ_ptg_dec");
p_dps_univ_ptg.lat = PFDsvg.getElementById("p_dps_univ_ptg_lat");
p_dps_univ_ptg.lon = PFDsvg.getElementById("p_dps_univ_ptg_lon");
p_dps_univ_ptg.alt = PFDsvg.getElementById("p_dps_univ_ptg_alt");
p_dps_univ_ptg.om = PFDsvg.getElementById("p_dps_univ_ptg_om");

p_dps_univ_ptg.start_time = PFDsvg.getElementById("p_dps_univ_ptg_start_time");
p_dps_univ_ptg.cmpl_time = PFDsvg.getElementById("p_dps_univ_ptg_mnvr_cpl_time");




p_dps_univ_ptg.ondisplay = func
{
DPS_menu_title.setText(sprintf("%s","UNIV PTG"));
DPS_menu_ops.setText(sprintf("%s","2011/    /"));
MEDS_menu_title.setText(sprintf("%s","       DPS MENU"));


p_dps_univ_ptg.cmpl_time.setText(sprintf("%s","00:00:00"));
}

p_dps_univ_ptg.update = func
{

    # these really need to be deleted when leaving the ascent page - do we have
    # an 'upon exit' functionality here
    nom_traj_plot.removeAllChildren();
    p_ascent_shuttle_sym.setScale(0.0);

update_common_DPS();
var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");

var cur_roll = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/roll-deg");
var cur_pitch = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/pitch-deg");
var cur_yaw = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/yaw-deg");


p_dps_univ_ptg.cur_roll.setText(sprintf("%+3.2f",cur_roll));
p_dps_univ_ptg.cur_pitch.setText(sprintf("%+3.2f",cur_pitch));
p_dps_univ_ptg.cur_yaw.setText(sprintf("%+3.2f",cur_yaw));

var up_mnvr_flag= getprop("/fdm/jsbsim/systems/ap/up-mnvr-flag");

var tgt_roll = cur_roll;
var tgt_pitch = cur_pitch;
var tgt_yaw = cur_yaw;

if ((up_mnvr_flag == 1) or (up_mnvr_flag == 2))
	{	
	tgt_roll = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/tgt-roll-deg");
	tgt_pitch = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/tgt-pitch-deg");
	tgt_yaw = getprop("/fdm/jsbsim/systems/pointing/inertial/attitude/tgt-yaw-deg");
	}

p_dps_univ_ptg.tgt_roll.setText(sprintf("%+3.2f",tgt_roll));
p_dps_univ_ptg.tgt_pitch.setText(sprintf("%+3.2f",tgt_pitch));
p_dps_univ_ptg.tgt_yaw.setText(sprintf("%+3.2f",tgt_yaw));

p_dps_univ_ptg.rate_roll.setText(sprintf("%+3.2f",57.297* getprop("/fdm/jsbsim/velocities/p-rad_sec")));
p_dps_univ_ptg.rate_pitch.setText(sprintf("%+3.2f",57.297 * getprop("/fdm/jsbsim/velocities/q-rad_sec")));
p_dps_univ_ptg.rate_yaw.setText(sprintf("%+3.2f",57.297 * getprop("/fdm/jsbsim/velocities/r-rad_sec")));

var err_roll = 0.0;
var err_pitch = 0.0;
var err_yaw = 0.0;

if ((up_mnvr_flag == 1) or (up_mnvr_flag == 2))
	{	
	err_roll = tgt_roll - cur_roll;
	err_pitch = tgt_pitch - cur_pitch;
	err_yaw = tgt_yaw - cur_yaw;
	}

p_dps_univ_ptg.err_roll.setText(sprintf("%+3.2f", err_roll));
p_dps_univ_ptg.err_pitch.setText(sprintf("%+3.2f", err_pitch));
p_dps_univ_ptg.err_yaw.setText(sprintf("%+3.2f", err_yaw));



if (up_mnvr_flag == 0)
	{
	p_dps_univ_ptg.sel_maneuver.setText(sprintf("%s", "18"));
	p_dps_univ_ptg.sel_track.setText(sprintf("%s", "19"));
	p_dps_univ_ptg.sel_rot.setText(sprintf("%s", "20"));
	}	
else if (up_mnvr_flag == 1)
	{
	p_dps_univ_ptg.sel_maneuver.setText(sprintf("%s", "18 *"));
	p_dps_univ_ptg.sel_track.setText(sprintf("%s", "19"));
	p_dps_univ_ptg.sel_rot.setText(sprintf("%s", "20"));
	}
else if (up_mnvr_flag == 2)
	{
	p_dps_univ_ptg.sel_maneuver.setText(sprintf("%s", "18"));
	p_dps_univ_ptg.sel_track.setText(sprintf("%s", "19 *"));
	p_dps_univ_ptg.sel_rot.setText(sprintf("%s", "20"));
	}
else if (up_mnvr_flag == 3)
	{
	p_dps_univ_ptg.sel_maneuver.setText(sprintf("%s", "18"));
	p_dps_univ_ptg.sel_track.setText(sprintf("%s", "19"));
	p_dps_univ_ptg.sel_rot.setText(sprintf("%s", "20 *"));
	}

p_dps_univ_ptg.mo_roll.setText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/mnvr-roll")));
p_dps_univ_ptg.mo_pitch.setText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/mnvr-pitch")));
p_dps_univ_ptg.mo_yaw.setText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/mnvr-yaw")));

p_dps_univ_ptg.body_vector.setText(sprintf("%d", int(getprop("/fdm/jsbsim/systems/ap/track/body-vector-selection"))));


p_dps_univ_ptg.tgt_id.setText(sprintf("%d", int(getprop("/fdm/jsbsim/systems/ap/ops201/tgt-id"))));
p_dps_univ_ptg.ra.setText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/trk-ra")));
p_dps_univ_ptg.dec.setText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/trk-dec")));
p_dps_univ_ptg.lat.setText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/trk-lat")));
p_dps_univ_ptg.lon.setText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/trk-lon")));
p_dps_univ_ptg.alt.setText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/ops201/trk-alt")));
p_dps_univ_ptg.om.setText(sprintf("%3.2f", getprop("/fdm/jsbsim/systems/ap/track/trk-om")));

p_dps_univ_ptg.start_time.setText(sprintf("%s",getprop("/fdm/jsbsim/systems/ap/ops201/mnvr-timer-string")));

}



#################################################################
# the APU/HYD page
#################################################################

var p_dps_apu_hyd = PFD.addPage("CRTApuHyd", "p_dps_apu_hyd");

p_dps_apu_hyd.speed_pct_1 = PFDsvg.getElementById("p_dps_apu_hyd_speed_pct_1");
p_dps_apu_hyd.speed_pct_2 = PFDsvg.getElementById("p_dps_apu_hyd_speed_pct_2");
p_dps_apu_hyd.speed_pct_3 = PFDsvg.getElementById("p_dps_apu_hyd_speed_pct_3");

p_dps_apu_hyd.fuel_qty_1 = PFDsvg.getElementById("p_dps_apu_hyd_fuel_qty_1");
p_dps_apu_hyd.fuel_qty_2 = PFDsvg.getElementById("p_dps_apu_hyd_fuel_qty_2");
p_dps_apu_hyd.fuel_qty_3 = PFDsvg.getElementById("p_dps_apu_hyd_fuel_qty_3");

p_dps_apu_hyd.vlv_a_1 = PFDsvg.getElementById("p_dps_apu_hyd_vlv_a_1");
p_dps_apu_hyd.vlv_a_2 = PFDsvg.getElementById("p_dps_apu_hyd_vlv_a_2");
p_dps_apu_hyd.vlv_a_3 = PFDsvg.getElementById("p_dps_apu_hyd_vlv_a_3");

p_dps_apu_hyd.vlv_b_1 = PFDsvg.getElementById("p_dps_apu_hyd_vlv_b_1");
p_dps_apu_hyd.vlv_b_2 = PFDsvg.getElementById("p_dps_apu_hyd_vlv_b_2");
p_dps_apu_hyd.vlv_b_3 = PFDsvg.getElementById("p_dps_apu_hyd_vlv_b_3");

p_dps_apu_hyd.oil_t_1 = PFDsvg.getElementById("p_dps_apu_hyd_oil_t_1");
p_dps_apu_hyd.oil_t_2 = PFDsvg.getElementById("p_dps_apu_hyd_oil_t_2");
p_dps_apu_hyd.oil_t_3 = PFDsvg.getElementById("p_dps_apu_hyd_oil_t_3");

p_dps_apu_hyd.oil_outt_1 = PFDsvg.getElementById("p_dps_apu_hyd_oil_outt_1");
p_dps_apu_hyd.oil_outt_2 = PFDsvg.getElementById("p_dps_apu_hyd_oil_outt_2");
p_dps_apu_hyd.oil_outt_3 = PFDsvg.getElementById("p_dps_apu_hyd_oil_outt_3");

p_dps_apu_hyd.bu_p_1 = PFDsvg.getElementById("p_dps_apu_hyd_bu_p_1");
p_dps_apu_hyd.bu_p_2 = PFDsvg.getElementById("p_dps_apu_hyd_bu_p_2");
p_dps_apu_hyd.bu_p_3 = PFDsvg.getElementById("p_dps_apu_hyd_bu_p_3");

p_dps_apu_hyd.h2o_1 = PFDsvg.getElementById("p_dps_apu_hyd_h2o_1");
p_dps_apu_hyd.h2o_2 = PFDsvg.getElementById("p_dps_apu_hyd_h2o_2");
p_dps_apu_hyd.h2o_3 = PFDsvg.getElementById("p_dps_apu_hyd_h2o_3");

p_dps_apu_hyd.cntlr_1 = PFDsvg.getElementById("p_dps_apu_hyd_cntlr_1");
p_dps_apu_hyd.cntlr_2 = PFDsvg.getElementById("p_dps_apu_hyd_cntlr_2");
p_dps_apu_hyd.cntlr_3 = PFDsvg.getElementById("p_dps_apu_hyd_cntlr_3");

p_dps_apu_hyd.bu_egt_1 = PFDsvg.getElementById("p_dps_apu_hyd_bu_egt_1");
p_dps_apu_hyd.bu_egt_2 = PFDsvg.getElementById("p_dps_apu_hyd_bu_egt_2");
p_dps_apu_hyd.bu_egt_3 = PFDsvg.getElementById("p_dps_apu_hyd_bu_egt_3");

p_dps_apu_hyd.egt_1 = PFDsvg.getElementById("p_dps_apu_hyd_egt_1");
p_dps_apu_hyd.egt_2 = PFDsvg.getElementById("p_dps_apu_hyd_egt_2");
p_dps_apu_hyd.egt_3 = PFDsvg.getElementById("p_dps_apu_hyd_egt_3");

p_dps_apu_hyd.n2_p_1 = PFDsvg.getElementById("p_dps_apu_hyd_n2_p_1");
p_dps_apu_hyd.n2_p_2 = PFDsvg.getElementById("p_dps_apu_hyd_n2_p_2");
p_dps_apu_hyd.n2_p_3 = PFDsvg.getElementById("p_dps_apu_hyd_n2_p_3");

p_dps_apu_hyd.wsb_n2_p_1 = PFDsvg.getElementById("p_dps_apu_hyd_wsb_n2_p_1");
p_dps_apu_hyd.wsb_n2_p_2 = PFDsvg.getElementById("p_dps_apu_hyd_wsb_n2_p_2");
p_dps_apu_hyd.wsb_n2_p_3 = PFDsvg.getElementById("p_dps_apu_hyd_wsb_n2_p_3");

p_dps_apu_hyd.accum_p_1 = PFDsvg.getElementById("p_dps_apu_hyd_accum_p_1");
p_dps_apu_hyd.accum_p_2 = PFDsvg.getElementById("p_dps_apu_hyd_accum_p_2");
p_dps_apu_hyd.accum_p_3 = PFDsvg.getElementById("p_dps_apu_hyd_accum_p_3");

p_dps_apu_hyd.vlv_at_1 = PFDsvg.getElementById("p_dps_apu_hyd_vlv_at_1");
p_dps_apu_hyd.vlv_at_2 = PFDsvg.getElementById("p_dps_apu_hyd_vlv_at_2");
p_dps_apu_hyd.vlv_at_3 = PFDsvg.getElementById("p_dps_apu_hyd_vlv_at_3");

p_dps_apu_hyd.vlv_bt_1 = PFDsvg.getElementById("p_dps_apu_hyd_vlv_bt_1");
p_dps_apu_hyd.vlv_bt_2 = PFDsvg.getElementById("p_dps_apu_hyd_vlv_bt_2");
p_dps_apu_hyd.vlv_bt_3 = PFDsvg.getElementById("p_dps_apu_hyd_vlv_bt_3");

p_dps_apu_hyd.rsvr_t_1 = PFDsvg.getElementById("p_dps_apu_hyd_rsvr_t_1");
p_dps_apu_hyd.rsvr_t_2 = PFDsvg.getElementById("p_dps_apu_hyd_rsvr_t_2");
p_dps_apu_hyd.rsvr_t_3 = PFDsvg.getElementById("p_dps_apu_hyd_rsvr_t_3");

p_dps_apu_hyd.ggbed_t_1 = PFDsvg.getElementById("p_dps_apu_hyd_ggbed_t_1");
p_dps_apu_hyd.ggbed_t_2 = PFDsvg.getElementById("p_dps_apu_hyd_ggbed_t_2");
p_dps_apu_hyd.ggbed_t_3 = PFDsvg.getElementById("p_dps_apu_hyd_ggbed_t_3");

p_dps_apu_hyd.tank_t_1 = PFDsvg.getElementById("p_dps_apu_hyd_tank_t_1");
p_dps_apu_hyd.tank_t_2 = PFDsvg.getElementById("p_dps_apu_hyd_tank_t_2");
p_dps_apu_hyd.tank_t_3 = PFDsvg.getElementById("p_dps_apu_hyd_tank_t_3");

p_dps_apu_hyd.blr_t_1 = PFDsvg.getElementById("p_dps_apu_hyd_blr_t_1");
p_dps_apu_hyd.blr_t_2 = PFDsvg.getElementById("p_dps_apu_hyd_blr_t_2");
p_dps_apu_hyd.blr_t_3 = PFDsvg.getElementById("p_dps_apu_hyd_blr_t_3");

p_dps_apu_hyd.reg_p_1 = PFDsvg.getElementById("p_dps_apu_hyd_reg_p_1");
p_dps_apu_hyd.reg_p_2 = PFDsvg.getElementById("p_dps_apu_hyd_reg_p_2");
p_dps_apu_hyd.reg_p_3 = PFDsvg.getElementById("p_dps_apu_hyd_reg_p_3");

p_dps_apu_hyd.n2_t_1 = PFDsvg.getElementById("p_dps_apu_hyd_n2_t_1");
p_dps_apu_hyd.n2_t_2 = PFDsvg.getElementById("p_dps_apu_hyd_n2_t_2");
p_dps_apu_hyd.n2_t_3 = PFDsvg.getElementById("p_dps_apu_hyd_n2_t_3");

p_dps_apu_hyd.vent_t_1 = PFDsvg.getElementById("p_dps_apu_hyd_vent_t_1");
p_dps_apu_hyd.vent_t_2 = PFDsvg.getElementById("p_dps_apu_hyd_vent_t_2");
p_dps_apu_hyd.vent_t_3 = PFDsvg.getElementById("p_dps_apu_hyd_vent_t_3");

p_dps_apu_hyd.rsvr_qty_1 = PFDsvg.getElementById("p_dps_apu_hyd_rsvr_qty_1");
p_dps_apu_hyd.rsvr_qty_2 = PFDsvg.getElementById("p_dps_apu_hyd_rsvr_qty_2");
p_dps_apu_hyd.rsvr_qty_3 = PFDsvg.getElementById("p_dps_apu_hyd_rsvr_qty_3");

p_dps_apu_hyd.rsvr_p_1 = PFDsvg.getElementById("p_dps_apu_hyd_rsvr_p_1");
p_dps_apu_hyd.rsvr_p_2 = PFDsvg.getElementById("p_dps_apu_hyd_rsvr_p_2");
p_dps_apu_hyd.rsvr_p_3 = PFDsvg.getElementById("p_dps_apu_hyd_rsvr_p_3");

p_dps_apu_hyd.tk_p_1 = PFDsvg.getElementById("p_dps_apu_hyd_tk_p_1");
p_dps_apu_hyd.tk_p_2 = PFDsvg.getElementById("p_dps_apu_hyd_tk_p_2");
p_dps_apu_hyd.tk_p_3 = PFDsvg.getElementById("p_dps_apu_hyd_tk_p_3");

p_dps_apu_hyd.out_p_1 = PFDsvg.getElementById("p_dps_apu_hyd_out_p_1");
p_dps_apu_hyd.out_p_2 = PFDsvg.getElementById("p_dps_apu_hyd_out_p_2");
p_dps_apu_hyd.out_p_3 = PFDsvg.getElementById("p_dps_apu_hyd_out_p_3");

p_dps_apu_hyd.pmp_t_1 = PFDsvg.getElementById("p_dps_apu_hyd_pmp_t_1");
p_dps_apu_hyd.pmp_t_2 = PFDsvg.getElementById("p_dps_apu_hyd_pmp_t_2");
p_dps_apu_hyd.pmp_t_3 = PFDsvg.getElementById("p_dps_apu_hyd_pmp_t_3");

p_dps_apu_hyd.vlv_t_1 = PFDsvg.getElementById("p_dps_apu_hyd_vlv_t_1");
p_dps_apu_hyd.vlv_t_2 = PFDsvg.getElementById("p_dps_apu_hyd_vlv_t_2");
p_dps_apu_hyd.vlv_t_3 = PFDsvg.getElementById("p_dps_apu_hyd_vlv_t_3");

p_dps_apu_hyd.oil_outp_1 = PFDsvg.getElementById("p_dps_apu_hyd_oil_outp_1");
p_dps_apu_hyd.oil_outp_2 = PFDsvg.getElementById("p_dps_apu_hyd_oil_outp_2");
p_dps_apu_hyd.oil_outp_3 = PFDsvg.getElementById("p_dps_apu_hyd_oil_outp_3");

p_dps_apu_hyd.gbx_p_1 = PFDsvg.getElementById("p_dps_apu_hyd_gbx_p_1");
p_dps_apu_hyd.gbx_p_2 = PFDsvg.getElementById("p_dps_apu_hyd_gbx_p_2");
p_dps_apu_hyd.gbx_p_3 = PFDsvg.getElementById("p_dps_apu_hyd_gbx_p_3");

p_dps_apu_hyd.byp_vlv_1 = PFDsvg.getElementById("p_dps_apu_hyd_byp_vlv_1");
p_dps_apu_hyd.byp_vlv_2 = PFDsvg.getElementById("p_dps_apu_hyd_byp_vlv_2");
p_dps_apu_hyd.byp_vlv_3 = PFDsvg.getElementById("p_dps_apu_hyd_byp_vlv_3");

p_dps_apu_hyd.brg_t_1 = PFDsvg.getElementById("p_dps_apu_hyd_brg_t_1");
p_dps_apu_hyd.brg_t_2 = PFDsvg.getElementById("p_dps_apu_hyd_brg_t_2");
p_dps_apu_hyd.brg_t_3 = PFDsvg.getElementById("p_dps_apu_hyd_brg_t_3");




p_dps_apu_hyd.ondisplay = func
{
DPS_menu_title.setText(sprintf("%s","APU/HYD"));
MEDS_menu_title.setText(sprintf("%s","       DPS MENU"));

var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");

var ops_string = major_mode~"1/   /086";
DPS_menu_ops.setText(sprintf("%s",ops_string));

# set a few things we don't model explicitly to reasonable values

p_dps_apu_hyd.n2_p_1.setText(sprintf(" 140"));
p_dps_apu_hyd.n2_p_2.setText(sprintf(" 142"));
p_dps_apu_hyd.n2_p_3.setText(sprintf(" 141")); 

p_dps_apu_hyd.wsb_n2_p_1.setText(sprintf("2499"));
p_dps_apu_hyd.wsb_n2_p_2.setText(sprintf("2505"));
p_dps_apu_hyd.wsb_n2_p_3.setText(sprintf("2501")); 

p_dps_apu_hyd.vlv_at_1.setText(sprintf("  62"));
p_dps_apu_hyd.vlv_at_2.setText(sprintf("  60"));
p_dps_apu_hyd.vlv_at_3.setText(sprintf("  61"));

p_dps_apu_hyd.vlv_bt_1.setText(sprintf("  61"));
p_dps_apu_hyd.vlv_bt_2.setText(sprintf("  61"));
p_dps_apu_hyd.vlv_bt_3.setText(sprintf("  60"));

p_dps_apu_hyd.tank_t_1.setText(sprintf("  59"));
p_dps_apu_hyd.tank_t_2.setText(sprintf("  60"));
p_dps_apu_hyd.tank_t_3.setText(sprintf("  57"));

p_dps_apu_hyd.blr_t_1.setText(sprintf("  65")); 
p_dps_apu_hyd.blr_t_2.setText(sprintf("  64")); 
p_dps_apu_hyd.blr_t_3.setText(sprintf("  65"));

p_dps_apu_hyd.reg_p_1.setText(sprintf("  25")); 
p_dps_apu_hyd.reg_p_2.setText(sprintf("  27")); 
p_dps_apu_hyd.reg_p_3.setText(sprintf("  26")); 

p_dps_apu_hyd.n2_t_1.setText(sprintf("  59")); 
p_dps_apu_hyd.n2_t_2.setText(sprintf("  61")); 
p_dps_apu_hyd.n2_t_3.setText(sprintf("  61")); 

p_dps_apu_hyd.rsvr_qty_1.setText(sprintf("  87")); 
p_dps_apu_hyd.rsvr_qty_2.setText(sprintf("  86")); 
p_dps_apu_hyd.rsvr_qty_3.setText(sprintf("  87")); 

p_dps_apu_hyd.rsvr_p_1.setText(sprintf("  54")); 
p_dps_apu_hyd.rsvr_p_2.setText(sprintf("  56")); 
p_dps_apu_hyd.rsvr_p_3.setText(sprintf("  55")); 

p_dps_apu_hyd.tk_p_1.setText(sprintf(" 210")); 
p_dps_apu_hyd.tk_p_2.setText(sprintf(" 214")); 
p_dps_apu_hyd.tk_p_3.setText(sprintf(" 211")); 

p_dps_apu_hyd.out_p_1.setText(sprintf(" 210")); 
p_dps_apu_hyd.out_p_2.setText(sprintf(" 214")); 
p_dps_apu_hyd.out_p_3.setText(sprintf(" 211")); 

}

p_dps_apu_hyd.update = func
{

p_dps_apu_hyd.speed_pct_1.setText(sprintf("%4.0f", 100.0 * getprop("/fdm/jsbsim/systems/apu/apu/apu-rpm-fraction")));
p_dps_apu_hyd.speed_pct_2.setText(sprintf("%4.0f", 100.0 * getprop("/fdm/jsbsim/systems/apu/apu[1]/apu-rpm-fraction")));
p_dps_apu_hyd.speed_pct_3.setText(sprintf("%4.0f", 100.0 * getprop("/fdm/jsbsim/systems/apu/apu[2]/apu-rpm-fraction")));


p_dps_apu_hyd.fuel_qty_1.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[14]/level-lbs")/3.5));
p_dps_apu_hyd.fuel_qty_2.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[15]/level-lbs")/3.5));
p_dps_apu_hyd.fuel_qty_3.setText(sprintf("%4.0f", getprop("/consumables/fuel/tank[16]/level-lbs")/3.5));

p_dps_apu_hyd.vlv_a_1.setText(sprintf("  %s", valve_status_to_string(getprop("/fdm/jsbsim/systems/apu/apu/fuel-valve-status"))));
p_dps_apu_hyd.vlv_a_2.setText(sprintf("  %s", valve_status_to_string(getprop("/fdm/jsbsim/systems/apu/apu[1]/fuel-valve-status"))));
p_dps_apu_hyd.vlv_a_3.setText(sprintf("  %s", valve_status_to_string(getprop("/fdm/jsbsim/systems/apu/apu[2]/fuel-valve-status"))));

p_dps_apu_hyd.vlv_b_1.setText(sprintf("  %s", valve_status_to_string(getprop("/fdm/jsbsim/systems/apu/apu/fuel-valve-status"))));
p_dps_apu_hyd.vlv_b_2.setText(sprintf("  %s", valve_status_to_string(getprop("/fdm/jsbsim/systems/apu/apu[1]/fuel-valve-status"))));
p_dps_apu_hyd.vlv_b_3.setText(sprintf("  %s", valve_status_to_string(getprop("/fdm/jsbsim/systems/apu/apu[2]/fuel-valve-status"))));

p_dps_apu_hyd.oil_t_1.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu/oil-in-T-K"))));
p_dps_apu_hyd.oil_t_2.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[1]/oil-in-T-K"))));
p_dps_apu_hyd.oil_t_3.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[2]/oil-in-T-K"))));

p_dps_apu_hyd.oil_outt_1.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/apu1-temperature-K"))));
p_dps_apu_hyd.oil_outt_2.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/apu2-temperature-K"))));
p_dps_apu_hyd.oil_outt_3.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/thermal-distribution/apu3-temperature-K"))));

p_dps_apu_hyd.bu_p_1.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu/hyd-pressure-psia")));
p_dps_apu_hyd.bu_p_2.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-pressure-psia")));
p_dps_apu_hyd.bu_p_3.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-pressure-psia")));

p_dps_apu_hyd.h2o_1.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/propulsion/tank[20]/contents-lbs")/1.42)); 
p_dps_apu_hyd.h2o_2.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/propulsion/tank[21]/contents-lbs")/1.42)); 
p_dps_apu_hyd.h2o_3.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/propulsion/tank[22]/contents-lbs")/1.42));  

p_dps_apu_hyd.cntlr_1.setText(sprintf(" %s", wsb_ctrl_to_string(getprop("/fdm/jsbsim/systems/apu/apu/boiler-power-status"))));
p_dps_apu_hyd.cntlr_2.setText(sprintf(" %s", wsb_ctrl_to_string(getprop("/fdm/jsbsim/systems/apu/apu[1]/boiler-power-status"))));
p_dps_apu_hyd.cntlr_3.setText(sprintf(" %s", wsb_ctrl_to_string(getprop("/fdm/jsbsim/systems/apu/apu[2]/boiler-power-status"))));

p_dps_apu_hyd.bu_egt_1.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu/egt-K")-3.0)));
p_dps_apu_hyd.bu_egt_2.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[1]/egt-K")+1.0)));
p_dps_apu_hyd.bu_egt_3.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[2]/egt-K")-4.0)));

p_dps_apu_hyd.egt_1.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu/egt-K")+1.0)));
p_dps_apu_hyd.egt_2.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[1]/egt-K")-1.0)));
p_dps_apu_hyd.egt_3.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[2]/egt-K"))));

p_dps_apu_hyd.accum_p_1.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu/hyd-acc-pressure-psia")));
p_dps_apu_hyd.accum_p_2.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-acc-pressure-psia")));
p_dps_apu_hyd.accum_p_3.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-acc-pressure-psia")));

p_dps_apu_hyd.rsvr_t_1.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu/hyd-rsvr-T-K")-3.0))); 
p_dps_apu_hyd.rsvr_t_2.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-rsvr-T-K")+1.0))); 
p_dps_apu_hyd.rsvr_t_3.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-rsvr-T-K")))); 

var ggbed_T1 = getprop("/fdm/jsbsim/systems/apu/apu/gg-bed-T-K");
var ggbed_T1_sym = "";
if (ggbed_T1 > 540) {ggbed_T1_sym = "H"; ggbed_T1 = 540.0;}

var ggbed_T2 = getprop("/fdm/jsbsim/systems/apu/apu[1]/gg-bed-T-K");
var ggbed_T2_sym = "";
if (ggbed_T2 > 540) {ggbed_T2_sym = "H"; ggbed_T2 = 540.0;}

var ggbed_T3 = getprop("/fdm/jsbsim/systems/apu/apu[2]/gg-bed-T-K");
var ggbed_T3_sym = "";
if (ggbed_T3 > 540) {ggbed_T3_sym = "H"; ggbed_T3 = 540.0;}

p_dps_apu_hyd.ggbed_t_1.setText(sprintf("%4.0f%s", K_to_F(ggbed_T1), ggbed_T1_sym));
p_dps_apu_hyd.ggbed_t_2.setText(sprintf("%4.0f%s", K_to_F(ggbed_T2-1.0), ggbed_T2_sym));
p_dps_apu_hyd.ggbed_t_3.setText(sprintf("%4.0f%s", K_to_F(ggbed_T3+3.0), ggbed_T3_sym));


p_dps_apu_hyd.vent_t_1.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu/steam-vent-T-K")-3.0))); 
p_dps_apu_hyd.vent_t_2.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[1]/steam-vent-T-K")))); 
p_dps_apu_hyd.vent_t_3.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[2]/steam-vent-T-K")+1.0))); 

p_dps_apu_hyd.pmp_t_1.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu/fuel-pump-T-K")-1.0))); 
p_dps_apu_hyd.pmp_t_2.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[1]/fuel-pump-T-K")+3.0))); 
p_dps_apu_hyd.pmp_t_3.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[2]/fuel-pump-T-K")+2.0))); 

p_dps_apu_hyd.vlv_t_1.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu/fuel-pump-T-K")+2.0))); 
p_dps_apu_hyd.vlv_t_2.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[1]/fuel-pump-T-K")-1.0))); 
p_dps_apu_hyd.vlv_t_3.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[2]/fuel-pump-T-K")-1.0))); 

p_dps_apu_hyd.oil_outp_1.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu/oil-p-psia")));
p_dps_apu_hyd.oil_outp_2.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu[1]/oil-p-psia")));
p_dps_apu_hyd.oil_outp_3.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu[2]/oil-p-psia")));

p_dps_apu_hyd.gbx_p_1.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu/oil-p-psia")-1.0));
p_dps_apu_hyd.gbx_p_2.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu[1]/oil-p-psia")-2.0));
p_dps_apu_hyd.gbx_p_3.setText(sprintf("%4.0f", getprop("/fdm/jsbsim/systems/apu/apu[2]/oil-p-psia")-1.0));

p_dps_apu_hyd.byp_vlv_1.setText(sprintf(" %s", wsb_vlv_to_string(getprop("/fdm/jsbsim/systems/thermal-distribution/spray-boiler-1-switch"))));
p_dps_apu_hyd.byp_vlv_2.setText(sprintf(" %s", wsb_vlv_to_string(getprop("/fdm/jsbsim/systems/thermal-distribution/spray-boiler-2-switch"))));
p_dps_apu_hyd.byp_vlv_3.setText(sprintf(" %s", wsb_vlv_to_string(getprop("/fdm/jsbsim/systems/thermal-distribution/spray-boiler-3-switch"))));

p_dps_apu_hyd.brg_t_1.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu/hyd-rsvr-T-K")+3.0)));
p_dps_apu_hyd.brg_t_2.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[1]/hyd-rsvr-T-K")+4.0)));
p_dps_apu_hyd.brg_t_3.setText(sprintf("%4.0f", K_to_F(getprop("/fdm/jsbsim/systems/apu/apu[2]/hyd-rsvr-T-K")+1.0)));

update_common_DPS();


}



#
PFD.selectPage(p_pfd);

#
#
# Add the menus to each page. The selected set of menu items is automatically managed

p_ascent.addMenuItem(0, "UP", p_main);
p_ascent.addMenuItem(4, "MSG RST", p_ascent);
p_ascent.addMenuItem(5, "MSG ACK", p_ascent);

p_entry.addMenuItem(0, "UP", p_main);
p_entry.addMenuItem(4, "MSG RST", p_entry);
p_entry.addMenuItem(5, "MSG ACK", p_entry);


p_vert_sit.addMenuItem(0, "UP", p_main);
p_vert_sit.addMenuItem(4, "MSG RST", p_vert_sit);
p_vert_sit.addMenuItem(5, "MSG ACK", p_vert_sit);

p_pfd.addMenuItem(0, "UP", p_main);
p_pfd.addMenuItem(1, "A/E", p_pfd);
p_pfd.addMenuItem(2, "ORBIT", p_pfd);
p_pfd.addMenuItem(3, "DATA", p_pfd);
p_pfd.addMenuItem(4, "MSG RST", p_pfd);
p_pfd.addMenuItem(5, "MSG ACK", p_pfd);

p_main.addMenuItem(0, "FLT", p_pfd);
p_main.addMenuItem(1, "SUB", p_main);
p_main.addMenuItem(2, "DPS", p_dps);
p_main.addMenuItem(3, "MAINT", p_vert_sit);
p_main.addMenuItem(4, "MSG RST", p_main);
p_main.addMenuItem(5, "MSG ACK", p_main);

p_dps_fault.addMenuItem(0, "UP", p_main);
p_dps_fault.addMenuItem(4, "MSG RST", p_dps_fault);
p_dps_fault.addMenuItem(5, "MSG ACK", p_dps_fault);

p_dps_univ_ptg.addMenuItem(0, "UP", p_main);
p_dps_univ_ptg.addMenuItem(4, "MSG RST", p_dps_univ_ptg);
p_dps_univ_ptg.addMenuItem(5, "MSG ACK", p_dps_univ_ptg);

p_dps_mnvr.addMenuItem(0, "UP", p_main);
p_dps_mnvr.addMenuItem(4, "MSG RST", p_dps_mnvr);
p_dps_mnvr.addMenuItem(5, "MSG ACK", p_dps_mnvr);

p_dps_sys_summ.addMenuItem(0, "UP", p_main);
p_dps_sys_summ.addMenuItem(4, "MSG RST", p_dps_sys_summ);
p_dps_sys_summ.addMenuItem(5, "MSG ACK", p_dps_sys_summ);

p_dps_sys_summ2.addMenuItem(0, "UP", p_main);
p_dps_sys_summ2.addMenuItem(4, "MSG RST", p_dps_sys_summ2);
p_dps_sys_summ2.addMenuItem(5, "MSG ACK", p_dps_sys_summ2);

p_dps_apu_hyd.addMenuItem(0, "UP", p_main);
p_dps_apu_hyd.addMenuItem(4, "MSG RST", p_dps_apu_hyd);
p_dps_apu_hyd.addMenuItem(5, "MSG ACK", p_dps_apu_hyd);

var pfd_button_pushed = 0;

var updatePFD = func 
{    if(pfd_mode)
        PFD.update();
}

# update displays at nominal 5hz
var rtExec_loop = func
{
    updatePFD();
    settimer(rtExec_loop, 0.2);	 # 0.2 is 5hz
}
    
rtExec_loop();
