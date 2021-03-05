//
// Limbani Stand CC BY-NC-SA Lee Fallat 2021
//

include <./config.scad>
use <./parts/arm.scad>
use <./parts/clip.scad>
use <./parts/face.scad>
use <./parts/kick.scad>
use <./parts/lip.scad>

//
// The measurements are in millimeters.
// Adjust these to create new types of stands.
//

stand_width      = 142.0;
stand_height     = 55.0;
stand_thickness  = 2.5;
stand_lip_length = 20.0;

//
// The following parameters are derived or fixed.
//

arm_height = (stand_height / 2.0) + (stand_thickness * 2.0);
arm_width = stand_width / 7.0;

clip_radius = stand_thickness / 2.0;

kick_width  = stand_width / 1.5;
kick_height = stand_height / 2.0;

lip_rotator_gap = extrude * 150.0;
lip_rotator_stub = lip_rotator_gap / 2.0;


module stand() {
  translate([0, 0, 0])
  face([stand_width, stand_thickness, stand_height], arm_width, kick_width, lip_rotator_gap);

  translate([0, (stand_lip_length / 2.0) - (stand_thickness * 2.0), (stand_height / -2.0) - stand_thickness])
  lip([stand_width, stand_lip_length, stand_thickness], lip_rotator_gap);

  translate([0, -stand_thickness * 4.0, (arm_height / 2.0) + (stand_thickness * -2.25)])
  arm(arm_width, stand_thickness, arm_height);

  translate([0, -stand_thickness * 8.0, (kick_height / -2.0) + (stand_thickness * -1.5)])
  kick(kick_width, stand_thickness, kick_height);
}

stand();

