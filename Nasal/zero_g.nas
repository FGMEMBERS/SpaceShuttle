###########################################################################
# simulation of objects floating inside the Shuttle flightdeck
###########################################################################

########################################################
# interpolation for flightdeck shape functions 
########################################################

var interpolate2d = func (x, array) {

var n = size(array);

if (n == 0) {return 0.0;}

var i_ref = 0;

for (var i =0; i< n; i=i+1)
	{
	if (array[i][0] > x)
		{
		i_ref = i;
		break;
		}
	}

if (i==n) {return array[n-1][1];}
else if (i==0) {return array[0][1];}

i_ref = i_ref - 1;

return array[i_ref][1] + (array[i_ref+1][1] - array[i_ref][1]) * (x- array[i_ref][0])/(array[i_ref+1][0] - array[i_ref][0]);

}

########################################################
# shape definitions for the flightdeck
########################################################

var shape_FD_upper = [];
var shape_FD_lower = [];
var shape_FD_fwd = [];
var shape_FD_aft = [];
var shape_FD_lr = [];

var init_flightdeck_shape_definitions = func {

# lower

var point = [-0.4, -0.5];
append(shape_FD_lower, point);

point = [-0.35,-0.65];
append(shape_FD_lower, point);

point = [-0.25,-0.75];
append(shape_FD_lower, point);

point = [-0.1,-0.9];
append(shape_FD_lower, point);

point = [0.35,-0.9];
append(shape_FD_lower, point);

point = [0.45,-1.25];
append(shape_FD_lower, point);

point = [1.3,-1.25];
append(shape_FD_lower, point);

point = [1.4,-0.25];
append(shape_FD_lower, point);

point = [1.5,0.0];
append(shape_FD_lower, point);

point = [1.6,0.275];
append(shape_FD_lower, point);


# upper

point = [-0.4,-0.5];
append(shape_FD_upper, point);

point = [-0.35, 0];
append(shape_FD_upper, point);

point = [-0.25,0.2];
append(shape_FD_upper, point);

point = [0, 0.2];
append(shape_FD_upper, point);

point = [0.25, 0.25];
append(shape_FD_upper, point);

point = [0.5,0.275];
append(shape_FD_upper, point);

point = [1.0, 0.3];
append(shape_FD_upper, point);

point = [1.6, 0.275];
append(shape_FD_upper, point);


# forward

point = [-1.3, 0.45];
append(shape_FD_fwd, point);

point = [-0.9, 0.35];
append(shape_FD_fwd, point);

point = [-0.875, -0.1];
append(shape_FD_fwd, point);

point = [-0.75, -0.25];
append(shape_FD_fwd, point);

point = [-0.675, -0.35];
append(shape_FD_fwd, point);

point = [-0.5, -0.4];
append(shape_FD_fwd, point);

point = [0, -0.35];
append(shape_FD_fwd, point);

point = [0.1, -0.25];
append(shape_FD_fwd, point);

point = [0.2, 0.0];
append(shape_FD_fwd, point);

point = [0.25, 0.25];
append(shape_FD_fwd, point);

point = [0.3, 1.0];
append(shape_FD_fwd, point);


# aft

point = [-1.3, 1.1];
append(shape_FD_aft, point);

point = [-0.25, 1.2];
append(shape_FD_aft, point);

point = [0, 1.3];
append(shape_FD_aft, point);

point = [0.275, 1.4];
append(shape_FD_aft, point);

# left/right

point = [-1.2, 0.9];
append(shape_FD_lr, point);

point = [-0.7, 0.9];
append(shape_FD_lr, point);

point = [-0.5, 0.6];
append(shape_FD_lr, point);

point = [0, 0.8];
append(shape_FD_lr, point);

point = [0.1, 0.6];
append(shape_FD_lr, point);

point = [0.2, 0.5];
append(shape_FD_lr, point);

point = [0.275, 0.4];
append(shape_FD_lr, point);

}

init_flightdeck_shape_definitions();


########################################################
# general class to simulate floating objects
########################################################

var zero_g_obj = {

	update_flag :0,
	elasticity: 0.2,
	vx_sgn: 1,
	vy_sgn: 1,
	vz_sgn: 0,
	bflag_x: 0,
	bflag_y: 0,
	bflag_z: 0,

	boundary_forward: -0.35,
	boundary_aft: 1.6,
	boundary_high: 0.3,
	boundary_low: -1.3,
	boundary_left: -1.1,
	boundary_right: 1.1,

	new: func(state, nodepath, name) {
	        var s = { parents: [zero_g_obj] };
		s.state = state;
		s.node_path = nodepath;
		s.name = name;
		return s;
	},

	init: func {
		#print("Init");

		if (me.update_flag == 1) {return;}

		setprop(me.node_path, 1);
		me.update_flag = 1;
		me.update();

	},


	remove: func {

		setprop(me.node_path, 0);
		me.update_flag = 0;
		
	},

	bounce: func (dir) {

		var dt = getprop("/sim/time/delta-sec");

		var el_factor = 1.0 - ((1.0 - me.elasticity)  * dt);

		if (dir == "X")
			{
			me.state.vx = me.state.vx * el_factor;
			me.state.vy = me.state.vy * (1.0 - 0.5 * (1.0 - el_factor));
			me.state.vz = me.state.vz * (1.0 - 0.5 * (1.0 - el_factor));
			}
		else if (dir == "Y")
			{
			me.state.vy = me.state.vy * me.elasticity;
			me.state.vx = me.state.vx * (1.0 - 0.5 * (1.0 - el_factor));
			me.state.vz = me.state.vz * (1.0 - 0.5 * (1.0 - el_factor));
			}
		else if (dir == "Z")
			{
			me.state.vz = me.state.vz * me.elasticity;
			me.state.vy = me.state.vy * (1.0 - 0.5 * (1.0 - el_factor));
			me.state.vx = me.state.vx * (1.0 - 0.5 * (1.0 - el_factor));
			}


	},

	bounce_rot: func {

		me.state.pitch_rate = 5.0 * (rand() - 0.5);
		me.state.yaw_rate = 5.0 * (rand() - 0.5);
		me.state.roll_rate = 5.0 * (rand() - 0.5);
	},

	update: func {



		if (me.update_flag == 0) {return;}

		var ax = getprop("/fdm/jsbsim/accelerations/a-pilot-x-ft_sec2") * 0.3048;
		var ay = -getprop("/fdm/jsbsim/accelerations/a-pilot-y-ft_sec2") * 0.3048;
		var az = getprop("/fdm/jsbsim/accelerations/a-pilot-z-ft_sec2") * 0.3048;

		var az_raw = az;

		# update to current boundary shapes

		me.boundary_high = interpolate2d(me.state.x ,shape_FD_upper);
		me.boundary_low = interpolate2d(me.state.x ,shape_FD_lower);

		me.boundary_forward = interpolate2d(me.state.z ,shape_FD_fwd);
		me.boundary_aft = interpolate2d(me.state.z ,shape_FD_aft);

		me.boundary_right = interpolate2d(me.state.z ,shape_FD_lr)-0.05;
		me.boundary_left = -me.boundary_right+0.05;

		# bouncing off the walls

		if (me.state.x < me.boundary_forward) 
			{
			ax = ax - 10.0 * (me.state.x - me.boundary_forward) * math.abs(me.state.x - me.boundary_forward);
			me.bounce("X");
			me.bflag_x = 1;
			}
		else if (me.state.x > me.boundary_aft) 
			{
			ax = ax - 10.0 * (me.state.x - me.boundary_aft) * math.abs(me.state.x - me.boundary_aft);
			me.bounce("X");			
			me.bflag_x = 1;
			}

		if (me.state.y > me.boundary_right) 
			{
			ay = ay - 10.0 * (me.state.y - me.boundary_right) *  math.abs(me.state.y - me.boundary_right);
			me.bounce("Y");
			me.bflag_y = 1;
			}
		else if (me.state.y < me.boundary_left) 
			{		
			ay = ay - 10.0 * (me.state.y - me.boundary_left) * math.abs(me.state.y - me.boundary_left);
			me.bounce("Y");
			me.bflag_y = 1;
			}

		if (me.state.z > me.boundary_high) 
			{
			az = az - 10.0 * (me.state.z - me.boundary_high) * math.abs(me.state.z - me.boundary_high);
			me.bounce("Z");
			me.bflag_z = 1;
			}
		else if (me.state.z < me.boundary_low) 
			{
			az = az - 10.0 * (me.state.z - me.boundary_low) * math.abs(me.state.z - me.boundary_low);
			me.bounce("Z");
			me.bflag_z = 1;
			}

		me.state.update(ax, ay, az, 0,0,0);

		# check for numerical artifacts when bouncing heavily
		# delayed frames can screw the numerics

		if (math.abs(me.state.vx) > 10.0) {me.state.vx = 0.0;}
		if (math.abs(me.state.vy) > 10.0) {me.state.vy = 0.0;}
		if (math.abs(me.state.vz) > 10.0) {me.state.vz = 0.0;}


		if ((me.vx_sgn != math.sgn(me.state.vx)) and (me.bflag_x == 1))
			{
			#print ("Bounce X!");
			me.vx_sgn = math.sgn(me.state.vx);
			me.bounce_rot();
			}
		if ((me.vy_sgn != math.sgn(me.state.vy)) and (me.bflag_y == 1))
			{
			#print ("Bounce Y!");
			me.vy_sgn = math.sgn(me.state.vy);
			me.bounce_rot();
			}
		if ((me.vz_sgn != math.sgn(me.state.vz)) and (me.bflag_z == 1))
			{
			#print ("Bounce Z!");
			me.vz_sgn = math.sgn(me.state.vz);
			me.bounce_rot();
			}
		
		me.bflag_x = 0;
		me.bflag_y = 0;
		me.bflag_z = 0;

		setprop("/controls/shuttle/"~me.name~"/x", me.state.x);
		setprop("/controls/shuttle/"~me.name~"/y", me.state.y);
		setprop("/controls/shuttle/"~me.name~"/z", me.state.z);

		# correct for cases when object is pulled down by gravity and oriented

		var gravity_factor = 1.0 - SpaceShuttle.clamp((math.abs(az_raw) - 0.1), 0.0, 1.0);

		#print(gravity_factor);

		me.state.pitch = me.state.pitch * gravity_factor;
		me.state.roll = me.state.roll * gravity_factor;


		setprop("/controls/shuttle/"~me.name~"/yaw", me.state.yaw);
		setprop("/controls/shuttle/"~me.name~"/pitch", me.state.pitch);
		setprop("/controls/shuttle/"~me.name~"/roll", me.state.roll);

		settimer (func me.update(), 0.0);

	},

	

};

var scom_state = SpaceShuttle.stateVector.new(0.0, 0.0, 0.0, 0,0,0,0,0,0);
scom_state.yaw_rate = 0.1;
scom_state.pitch_rate = 0.4;

var scom_float = zero_g_obj.new(scom_state, "/sim/config/shuttle/show-floating-scom", "scom");
