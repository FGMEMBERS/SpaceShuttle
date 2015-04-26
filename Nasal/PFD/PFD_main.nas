# Space Shuttle PFD
# ---------------------------
# PFD has many pages; the classes here support multiple pages, menu
# operation and the update loop.
# Based on F-15 MPCD
# ---------------------------
# Richard Harrison: 2015-01-23 : rjh@zaretto.com
# ---------------------------

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
            foreach(mi ;  me.menus)
            {
#                printf("load menu %s %\n",mi.title, mi);
            }
        }
    },
#
#
# Perform action when button is pushed
    notifyButton : func(button_id) 
    {        foreach(var mi; me.menus)
             {
                 if (mi.menu_id == button_id)
                 {
#                     printf("Page: found button %s, selecting page\n",mi.title);
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
#                printf("Button routing to %s",me.current_page.title);
                me.current_page.notifyButton(button_id);
            }
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
#                printf("selectPage: load menu %d %s",mi.menu_id, mi.title);
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
#                        printf("Button %d",pfd_button_pushed);
                        PFD.notifyButton(pfd_button_pushed);
                        pfd_button_pushed = 0;
                    }
                }
            });
var pfd_mode = 1;

#
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
# Add the menus to each page. The selected set of menu items is automatically managed
p_pfd.addMenuItem(0, "UP", p_pfd);
p_pfd.addMenuItem(1, "A/E", p_pfd);
p_pfd.addMenuItem(2, "ORBIT", p_pfd);
p_pfd.addMenuItem(3, "DATA", p_pfd);
p_pfd.addMenuItem(4, "MEDS", p_pfd);
p_pfd.addMenuItem(5, "MEDS", p_pfd);

#p1_2.addMenuItem(1, "A/A", p1_3);
#p1_2.addMenuItem(2, "A/G", p1_3);
#p1_2.addMenuItem(3, "CBT JETT", p1_3);
#p1_2.addMenuItem(4, "WPN LOAD", p1_3);
#p1_2.addMenuItem(9, "M", p_pfd);

#p1_3.addMenuItem(1, "HIGH\n500M", p1_3);
#p1_3.addMenuItem(2, "NML", p1_3);
#p1_3.addMenuItem(3, "A/G", p1_3);
#p1_3.addMenuItem(4, "2/2", p1_3);
#p1_3.addMenuItem(8, "TM\nPWR", p1_3);
#p1_3.addMenuItem(9, "M", p_pfd);

#
#
# PFD page update
p_pfd.keas = PFDsvg.getElementById("p_pfd_keas");
p_pfd.beta = PFDsvg.getElementById("p_pfd_beta");

p_pfd.update = func
{
    p_pfd.beta.setText(sprintf("%5.1f",getprop("fdm/jsbsim/aero/beta-deg")));
    p_pfd.keas.setText(sprintf("%5.0f",getprop("velocities/airspeed-kt")));
};

#
PFD.selectPage(p_pfd);

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
