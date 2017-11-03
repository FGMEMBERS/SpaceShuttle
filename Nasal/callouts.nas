# voice callouts for the Space Shuttle
# Thorsten Renk 2017

var callout = {

	call_enable: { info: 1, help: 1, limit: 1, failure: 1, real: 1, essential: 1},

	

	make: func (string, type) {

		if (me.call_enable[type] == 1)
			{
			me.process(string);
			}

	},

	process: func (string) {
	
		setprop("/sim/messages/copilot", string);

	},


	init: func {

		me.call_enable.info = getprop("/sim/config/shuttle/callouts/info");
		me.call_enable.help = getprop("/sim/config/shuttle/callouts/help");
		me.call_enable.limit = getprop("/sim/config/shuttle/callouts/limit");
		me.call_enable.failure = getprop("/sim/config/shuttle/callouts/failure");
		me.call_enable.real = getprop("/sim/config/shuttle/callouts/real");
		me.call_enable.essential = getprop("/sim/config/shuttle/callouts/essential");

	},


};

callout.init();

setlistener("/sim/config/shuttle/callouts/info", func (n) {callout.call_enable.info =n.getValue();});
setlistener("/sim/config/shuttle/callouts/help", func (n) {callout.call_enable.help =n.getValue();});
setlistener("/sim/config/shuttle/callouts/limit", func (n) {callout.call_enable.limit =n.getValue();});
setlistener("/sim/config/shuttle/callouts/failure", func (n) {callout.call_enable.failure =n.getValue();});
setlistener("/sim/config/shuttle/callouts/real", func (n) {callout.call_enable.real =n.getValue();});
setlistener("/sim/config/shuttle/callouts/essential", func (n) {callout.call_enable.essential =n.getValue();});
