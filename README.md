LICENSE
=======

Content on the Space Shuttle has mixed licenses
* http://www.blendswap.com/blends/view/74692: The Cockpit, Imported by R. Harrison,  is covered under <b> Creative Commons License CC-BY </b>
* Work of the Shuttle also available on FGAddon is covered under <b> GPLv2.0 or
later </b>
* http://sourceforge.net/p/fgspaceshuttledev/code/ci/master/tree/: Work of the Shuttle only available on Thorsten Renk repository is currently
with <b>undescribed license</b> but it is submitted to copyrights by its author.


![Thorsten image](http://users.jyu.fi/~trenk/pics/shuttle_FG06.jpg)

![Thorsten image](http://users.jyu.fi/~trenk/pics/shuttle_Earthview01.jpg)

![Thorsten image](http://users.jyu.fi/~trenk/pics/Atlantis_FG.jpg)

<a href="http://users.jyu.fi/~trenk/files/SpaceShuttle.tgz">Download</a> 

ThorstenR Wrote @ <http://forum.flightgear.org/viewtopic.php?f=4&t=25747&start=75#p237994>

* Now uses the more realistic SRB definitions from the JSBSim repo
* A full RCS translation mode
* Realistic handover of controls from RCS to aero during the initial entry phase
* (Rough) modeling of thermal load on the nose cone during ascent and entry
* Phase-specific HUD information
* Tested for ascent, orbital maneuvering, de-orbit, entry and approach, compares reasonably with NASA-published procedures


***

First preview version available. This version is tested for launch and orbital maneuvering only - no work on entry and aerodynamics of the orbiter yet, what you get if you try is completely random.

Usage:

Use --aircraft= SpaceShuttle-launch for the stack to be placed vertical and ready for launch, --aircraft=SpaceShuttle-orbit to start right after MECO on the ascending leg of an orbit, --aircraft=SpaceShuttle only if you know what parameters you need to pass. Do not use --auto-coordination or you will die!

Data:

* Weight and performance data mostly based on 'NASA Space Shuttle - Owner's Workshop Manual - an insight into the design, construction and operation of the NASA Space Shuttle'

* Measurements (thruster positions,...) based on schematics, not actual technical blueprints, may be off by ~5%

* Liftoff weight and thrust within 5% of published values

* SRB thrust characteristics currently not modeled, making the SRBs somewhat too powerful

* simple thrust vectoring of SSME and SRB on ascent - stick controls the vectoring angle, not the roll (pitch, yaw) rate

* transition to fully functioning RCS rotation mode and OMS control in orbit with realistic thruster positions and characteristics

* special Shuttle HUD mode with orbital information

Short user's guide

Ignition sequence
==========

Ignition of the main engines is done via throttle - SSME 1 to 3 ignite as soon as the throttle reaches 65%. This is not enough to achieve liftoff for the normal launch mass of the shutte, however main engine ignition triggers SRB ignition three seconds later. Once both SRBs ignite, the shuttle will lift off the pad rapidly.

Initial launch
=======

Upon ascent, the shuttle is controlled via thrust vectoring of both SSME and SRB. Initially, with the strong SRB thrusters far from the CoG, the launch stack is very maneuverable - don't get used to it.

Once clearing the pad, rotate to the desired launch course, then pull the launch stack gently out of the vertical to an about 70 degree inverted climb (the ride into orbit is done head down...). The external tank is very top-heavy (most of its mass is in the oxygen tank on its top) - take care that the stack doesn't topple too far out of the vertical, or you will never recover. Initially aerodynamical forces on the orbiter will require sizable thrust vectoring, as you clear the atmosphere the need will gradually go away as the flight control systems automatically vector each engine through the CoG.

SRB thrust can not be throttled, however the main engine can, and you will see a callout to throttle back the main engine to 65% after 34 seconds to avoid the highest dynamical pressure during ascent to damage the vehicle (damage is currently not modeled).

SRB separation
=========

SRBs will burn about 128 seconds before they are disconnected. At this point you should be on your launch course, out of the atmosphere at around 200.000 ft and still on a 70 degree climb. Once the SRBs connect, most of your thrust will be gone and since the main engines are very close to the central axis, thrust vectoring efficiency will be dramatically reduced.

In addition, you are now in vacuum, so any yaw, pitch or roll motion will continue indefinitely till it is countered by opposite thrust. The most important thing is to stay on your launch course - if you get a strong yaw drift, you will never make orbit.

Roll the orbiter out of inverted position, decrease climbing angle to 30-40 degrees and try to hold launch course and climb. Watch vertical speed and altitude - pull up once vertical speed starts to reduce to zero to maintain current altitude, don't worry if you start dropping for a minute, if you manage to reach orbital speed it won't matter. Try to level off at about 650.000 ft.

Orbital insertion
=========

If you managed to control launch course and climb, after a few minutes, velocity over ground should climb to 7 km/s. As the tank empties, thrust gets more powerful again, watch g-forces and throttle back as needed to keep the load below 3 g. Eventually you should see the periapsis coming up above zero, meaning that you are about to reach orbit (there'll be another callout). Timing is critical, watch the apoapsis till it reaches the orbital altitude you want to reach, then cut thrust fast and drop the external tank.

Orbital maneuvering
============

Controls now switch to the reaction control system (RCS). Best use the keys to fire thrusters, 5 to cut thrust. Watch yaw, pitch and roll rates in the HUD. Do not leave controls uncentered at any point after maneuvering, not even a bit, you will regret it!

4: roll left
6: roll right
2: pitch up
8: pitch down
[: yaw left
]: yaw right
5: cut thrust

Your apoapsis should be where you want to go (say 650 km), your periapsis about where you are (say 240 km). Use the RCS to align the shuttle with the flightpath ('prograde orientation'). Wait till your altitude rises to the apoapsis, then lower the nose about 15 degrees below the flightpath (the OMS thrusters are located fairly high at the rear fuselage, so to align thrust through the CoG with the flightpath, the nose needs to be down) and use thrust control to ignite the OMS engines for a few minutes ('prograde burn'). Watch the periapsis value climb till it reaches the apoapsis value - congratulations, you've reached a circular orbit.

By Thorsten R
On:
http://forum.flightgear.org/viewtopic.php?f=4&t=25747
