# payload management for the Space Shuttle

var rms_grab_payload = func {

# get the position and orientation of the effector tip

var effector_x = getprop("/fdm/jsbsim/systems/rms/effector-x");
var effector_y = getprop("/fdm/jsbsim/systems/rms/effector-y");
var effector_z = getprop("/fdm/jsbsim/systems/rms/effector-z");


var effector_yaw = getprop("/fdm/jsbsim/systems/rms/sum-wrist-yaw-deg");
var effector_pitch = getprop("/fdm/jsbsim/systems/rms/sum-wrist-pitch-deg");
var effector_roll = getprop("/fdm/jsbsim/systems/rms/ang-wrist-roll-deg");

# get the payload position

var payload_x = getprop("/fdm/jsbsim/systems/rms/payload/payload-attach-x");
var payload_y = getprop("/fdm/jsbsim/systems/rms/payload/payload-attach-y");
var payload_z = getprop("/fdm/jsbsim/systems/rms/payload/payload-attach-z");

# require agreement in position

var flag = 1;

if (math.abs(effector_x - payload_x) > 0.15) {flag = 0;}
if (math.abs(effector_y - payload_y) > 0.15) {flag = 0;}
if (math.abs(effector_z - payload_z) > 0.15) {flag = 0;}

#print ("x difference: ", math.abs(effector_x - payload_x));
#print ("y difference: ", math.abs(effector_y - payload_y));
#print ("z difference: ", math.abs(effector_z - payload_z));

#if (math.abs(effector_yaw ) > 20.0) {flag = 0;}
#if ((math.abs(effector_pitch ) > 10.0) and (math.abs(effector_pitch) < 80.0)) {flag = 0;}

print ("yaw: ", math.abs(effector_yaw ));
print ("pitch: ", math.abs(effector_yaw ));

if (flag == 0)
	{
	setprop("/sim/messages/copilot", "Failed to grab payload!");
	return;
	}
else
	{
	setprop("/sim/messages/copilot", "Payload successfully attached!");
	setprop("/fdm/jsbsim/systems/rms/effector-attached", 1);
	}

setprop("/fdm/jsbsim/systems/rms/effector-closed", 1);
setprop("/fdm/jsbsim/systems/rms/effector-rigid", 1);

}


var rms_release_payload = func {

	# first check whether we release into space or put into the payload bay

	var status = getprop("/fdm/jsbsim/systems/rms/payload-ready-to-latch");
	
	if (status == 1)
		{
		# we require at least one latch closed to attach the payload firmly

		var is_released = getprop("/fdm/jsbsim/systems/rms/payload-released");

		if (is_released == 0)
			{
			setprop("/sim/messages/copilot", "Payload latched to bay!");
			setprop("/fdm/jsbsim/systems/rms/effector-attached", 0);
			}
	
		}
	else
		{
		setprop("/sim/messages/copilot", "Payload released!");
		setprop("/fdm/jsbsim/systems/rms/effector-attached", 2);
		SpaceShuttle.init_payload();
		}

setprop("/fdm/jsbsim/systems/rms/effector-closed", 0);
setprop("/fdm/jsbsim/systems/rms/effector-rigid", 0);

}


# initial payload selection

var update_payload_selection = func {

var payload_string = getprop("/sim/config/shuttle/PL-selection");

# payload properties to be specified are: 
# 1) the flag to show the right 3d model
# 2) the location of the attachment point (relative to the RMS arm shoulder) - set to zero to make not movable
# 3) the payload mass

# <payload-attach-x type="double">12.75</payload-attach-x>
# <payload-attach-y type="double">2.0</payload-attach-y>
# <payload-attach-z type="double">-1.8</payload-attach-z>

if (payload_string == "none")
	{
	setprop("/sim/config/shuttle/PL-selection-flag", 0);
	setprop("/fdm/jsbsim/systems/rms/payload/payload-attach-x", 0);
	setprop("/fdm/jsbsim/systems/rms/payload/payload-attach-y", 0);
	setprop("/fdm/jsbsim/systems/rms/payload/payload-attach-z", 0);
	setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[5]", 0.0);
	setprop("/sim/config/shuttle/PL-model-path", "");
	}
else if (payload_string == "TDRS demo")
	{
	setprop("/sim/config/shuttle/PL-selection-flag", 1);
	setprop("/fdm/jsbsim/systems/rms/payload/payload-attach-x", 11.50);
	setprop("/fdm/jsbsim/systems/rms/payload/payload-attach-y", 2.0);
	setprop("/fdm/jsbsim/systems/rms/payload/payload-attach-z", -1.8);
	setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[5]", 20000.0);
	setprop("/sim/config/shuttle/PL-model-path", "Aircraft/SpaceShuttle/Models/PayloadBay/TDRS/TDRS_disconnected.xml");
	}
else if (payload_string == "SPARTAN-201")
	{
	setprop("/sim/config/shuttle/PL-selection-flag", 2);
	setprop("/fdm/jsbsim/systems/rms/payload/payload-attach-x", 9.85);
	setprop("/fdm/jsbsim/systems/rms/payload/payload-attach-y", 1.9);
	setprop("/fdm/jsbsim/systems/rms/payload/payload-attach-z", -0.6);
	setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[5]", 2998.2);
	setprop("/sim/config/shuttle/PL-model-path", "Aircraft/SpaceShuttle/Models/PayloadBay/Spartan-201/SPARTAN-201-disconnected.xml");
	}

}

# checks the reach limit of the RMS arm for an operator-specified command - very simplistic still

var check_rms_reach_limit = func {


	#var tgt_x = getprop("/fdm/jsbsim/systems/rms/software/tgt-pos-x");
	#var tgt_y = getprop("/fdm/jsbsim/systems/rms/software/tgt-pos-y");
	#var tgt_z = getprop("/fdm/jsbsim/systems/rms/software/tgt-pos-z");

	var tgt_x = pdrs_auto_seq_manager.opr_cmd_tgt[0];
	var tgt_y = pdrs_auto_seq_manager.opr_cmd_tgt[1];
	var tgt_z = pdrs_auto_seq_manager.opr_cmd_tgt[2];

	var length = math.sqrt(tgt_x * tgt_x + tgt_y * tgt_y + tgt_z * tgt_z);

	if ((length < 0.5) or (length > 14.5)) 
		{
		setprop("/fdm/jsbsim/systems/rms/software/reach-limit-string", "FAIL");
		}
	else
		{
		setprop("/fdm/jsbsim/systems/rms/software/reach-limit-string", "GOOD");
		}
}


# PDRS AUTO sequences ###########################################

# sequence point hash

var pdrs_auto_seq_point = {
	new: func (x, y, z, pitch, yaw, roll, delay) {
 		var p = { parents: [pdrs_auto_seq_point] };
		p.x = x;
		p.y = y;
		p.z = z;
		p.pitch = pitch;
		p.yaw = yaw;
		p.roll = roll;
		p.delay = delay;	
		return p;
	},
};

var pdrs_auto_seq_manager = {

	n_auto_sequences: 0,
	auto_sequence_array: [],
	sequence_slot_array: [-1, -1, -1, -1],

	opr_cmd_loop_flag: 0,
	opr_cmd_tgt: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],

	auto_seq_loop_flag: 0,

	current_index: -1,
	start_index: 0,

	assign_slot: func (slot, index) {

	me.sequence_slot_array[slot] = index;

	},

	append_sequence_array: func (array) {

	append(me.auto_sequence_array, array);

	},

	# operator commanded routine to go to the target point defined on SPEC 94

	opr_cmd_goto_point: func {

		# set target
		setprop("/fdm/jsbsim/systems/rms/software/tgt-pos-x", me.opr_cmd_tgt[0]);
		setprop("/fdm/jsbsim/systems/rms/software/tgt-pos-y", me.opr_cmd_tgt[1]);
		setprop("/fdm/jsbsim/systems/rms/software/tgt-pos-z", me.opr_cmd_tgt[2]);

		setprop("/fdm/jsbsim/systems/rms/software/tgt-att-p", me.opr_cmd_tgt[3]);
		setprop("/fdm/jsbsim/systems/rms/software/tgt-att-y", me.opr_cmd_tgt[4]);
		setprop("/fdm/jsbsim/systems/rms/software/tgt-att-r", me.opr_cmd_tgt[5]);

		# first adjust angle

		setprop("/fdm/jsbsim/systems/rms/drive-selection-mode", 5);
		
		# init management loop

		me.opr_cmd_loop_flag = 1;
		settimer(func me.opr_cmd_loop(), 0.2);
	},


	opr_cmd_loop : func {
	
		if (me.opr_cmd_loop_flag == 0) {return;}

		var att_reached = getprop("/fdm/jsbsim/systems/rms/software/effector-att-reached-flag");
		var pos_reached = getprop("/fdm/jsbsim/systems/rms/software/effector-pos-reached-flag");

		# acquire position once attitude is done

		if ((att_reached == 1) and (pos_reached == 0)) 
			{	

			if (getprop("/fdm/jsbsim/systems/rms/drive-selection-mode") == 5)
				{
				print("PDRS: Attitude acquired, moving into position");	
				setprop("/fdm/jsbsim/systems/rms/drive-selection-mode", 4);
				}
			}

		# correct attitude drift if we are in position

		if ((att_reached == 0) and (pos_reached == 1)) 
			{	
			if (getprop("/fdm/jsbsim/systems/rms/drive-selection-mode") == 4)
				{
				print("PDRS: Position acquired, correcting attitude");		
				setprop("/fdm/jsbsim/systems/rms/drive-selection-mode", 5);
				}
			}

		if ((att_reached == 1) and (pos_reached == 1))
			{
			print("PDRS: Operator commanded point reached");	
			me.opr_cmd_loop_flag = 0;
			setprop("/fdm/jsbsim/systems/rms/drive-selection-mode", 0);
			return;
			}

		settimer( func me.opr_cmd_loop (), 1.0);
	},


	# auto sequence of multiple points

	set_start_index: func (num) {

		me.start_index = num;

	},


	start_sequence: func (slot) {

		me.current_sequence_index = me.sequence_slot_array[slot]-1;

		if (me.current_sequence_index < 0) {return;}
		if (me.current_sequence_index > size(me.auto_sequence_array)-1)
			{
			print ("PDRS: No i-loaded auto sequence of that number available");
			return;
			}
		

		me.current_sequence = me.auto_sequence_array[me.current_sequence_index];
		me.current_sequence_size = size(me.current_sequence);

		if (me.current_sequence_size == 0) {return;}

		me.current_index = me.start_index;

		if (me.current_index > me.current_sequence_size-1)
			{
			print ("PDRS: Point number exceeds points in sequence");
			return;
			}

		print("PDRS: Auto sequence ", me.current_sequence_index, " with ", me.current_sequence_size, " points loaded.");

		# push first point

		var point = me.current_sequence[me.current_index];
		me.sequence_target_point(point);	


		# init management loop

		me.auto_seq_loop_flag = 1;
		setprop("/fdm/jsbsim/systems/rms/drive-selection-mode", 5);
		settimer(func me.auto_sequence_loop(), 0.2);

		
	},

	auto_sequence_loop: func {

		if (me.auto_seq_loop_flag == 0) {return;}


		if (me.current_index > me.current_sequence_size - 1) 
			{
			me.auto_seq_loop_flag = 0;
			print ("PDRS: Auto sequence finished");
			me.current_index = me.current_index -1; # show last point on SPEC 94
			setprop("/fdm/jsbsim/systems/rms/drive-selection-mode", 0);
			return;
			} 

		var att_reached = getprop("/fdm/jsbsim/systems/rms/software/effector-att-reached-flag");
		var pos_reached = getprop("/fdm/jsbsim/systems/rms/software/effector-pos-reached-flag");

		# acquire position once attitude is done

		if ((att_reached == 1) and (pos_reached == 0)) 
			{	

			if (getprop("/fdm/jsbsim/systems/rms/drive-selection-mode") == 5)
				{
				print("PDRS: Attitude acquired, moving into position");	
				setprop("/fdm/jsbsim/systems/rms/drive-selection-mode", 4);
				}
			}

		# correct attitude drift if we are in position

		if ((att_reached == 0) and (pos_reached == 1)) 
			{	
			if (getprop("/fdm/jsbsim/systems/rms/drive-selection-mode") == 4)
				{
				print("PDRS: Position acquired, correcting attitude");		
				setprop("/fdm/jsbsim/systems/rms/drive-selection-mode", 5);
				}
			}

		if ((att_reached == 1) and (pos_reached == 1))
			{
			print("PDRS: Commanded point reached");	

			me.current_index = me.current_index + 1;
			#print("Index is now: ",me.current_index, " size: ", me.current_sequence_size);

			if (me.current_index < me.current_sequence_size)
				{
				print ("PDRS: Pushing target point ", me.current_index);
				var point = me.current_sequence[me.current_index];
				me.sequence_target_point(point);
				}
			
			}


		settimer( func me.auto_sequence_loop (), 1.0);
	},

	
	sequence_target_point: func (point) {

		# set target
		setprop("/fdm/jsbsim/systems/rms/software/tgt-pos-x", point.x);
		setprop("/fdm/jsbsim/systems/rms/software/tgt-pos-y", point.y);
		setprop("/fdm/jsbsim/systems/rms/software/tgt-pos-z", point.z);

		setprop("/fdm/jsbsim/systems/rms/software/tgt-att-p", point.pitch);
		setprop("/fdm/jsbsim/systems/rms/software/tgt-att-y", point.yaw);
		setprop("/fdm/jsbsim/systems/rms/software/tgt-att-r", point.roll);

		# first adjust angle

		setprop("/fdm/jsbsim/systems/rms/drive-selection-mode", 5);
		


	},

};


var add_test_seq = func {


var a = [];
var p = pdrs_auto_seq_point.new(12.0, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0);
append(a, p);

p = pdrs_auto_seq_point.new(10.0, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0);
append(a, p);

p = pdrs_auto_seq_point.new(10.0, 2.0, 0.0, 30.0, 0.0, 0.0, 0.0);
append(a, p);

p = pdrs_auto_seq_point.new(13.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0);
append(a, p);

pdrs_auto_seq_manager.append_sequence_array(a);

var b = [];
p = pdrs_auto_seq_point.new(13.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
append(b, p);

p = pdrs_auto_seq_point.new(12.0, 1.5, 1.0, 30.0, 0.0, 0.0, 0.0);
append(b, p);

p = pdrs_auto_seq_point.new(12.0, 2.0, 1.0, 30.0, 0.0, 0.0, 0.0);
append(b, p);

pdrs_auto_seq_manager.append_sequence_array(b);

#pdrs_auto_seq_manager.assign_slot(0,0);
}

add_test_seq();
