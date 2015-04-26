# high-level failure management for the Space Shuttle

# (low level failures are processed by JSBSim in failures.xml)


# explosion of the orbiter on ascent, nothing remains functional

var orbiter_destroy = func {

# kill main engines

setprop("/fdm/jsbsim/systems/failures/ssme1-condition", 0.0);
setprop("/fdm/jsbsim/systems/failures/ssme2-condition", 0.0);
setprop("/fdm/jsbsim/systems/failures/ssme3-condition", 0.0);

# disconnect the SRBs

SpaceShuttle.SRB_separate();

# remove the tank

setprop("/consumables/fuel/tank[0]/level-norm",0.0);

# destroy aerodynamics

setprop("/fdm/jsbsim/systems/failures/airfoils-pitch-condition", 0.0);
setprop("/fdm/jsbsim/systems/failures/airfoils-roll-condition", 0.0);
setprop("/fdm/jsbsim/systems/failures/airfoils-yaw-condition", 0.0);

setprop("/fdm/jsbsim/systems/failures/aero-structure-condition", 0.05);


}



