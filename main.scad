//
// Limbani Stand CC BY-NC-SA Lee Fallat 2021
//

include <./config.scad>
use <./parts/arm.scad>
use <./parts/hinge.scad>
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

hinge_radius = stand_thickness / 2.0;

kick_width  = stand_width / 1.5;
kick_height = stand_height / 2.0;

lip_rotator_gap = profile * 150.0;
lip_rotator_stub = lip_rotator_gap / 2.0;


module stand() {
  if (face || all) {
    translate([0, 0, 0])
    rotate([-90, 0, 0])
    face([stand_width, stand_thickness, stand_height], arm_width, kick_width, lip_rotator_gap);
  }

  if (lip || all) {
    translate([0, (stand_lip_length / 2.0) - (stand_thickness * 2.0), (stand_height / -2.0) - stand_thickness])
    lip([stand_width, stand_lip_length, stand_thickness], lip_rotator_gap);
  }

  if (arm || all) {
    translate([0, arm_width / 2.0, (arm_height / 2.0) + (stand_thickness * -2.25)])
    rotate([90, 0, 180])
    arm(arm_width, stand_thickness, arm_height);
  }

  if (kick || all) {
    translate([0, (kick_height / -2.0) - pin_height(hinge_radius) / 2.0, (kick_height / -2.0) + (stand_thickness * -1.5)])
    rotate([90, -180, 180])
    kick(kick_width, stand_thickness, kick_height);
  }

  if (hinge) {
    translate([0, stand_width / 3.0, hinge_radius])
    rotate([-90, 0, 0])
    pin(arm_width, hinge_radius);

    translate([0, stand_width / 3.0 - stand_thickness * 3.0, knuckle_height(hinge_radius) / 2.0])
    rotate([-90, 0, 0])
    knuckle(arm_width, hinge_radius);
  }
}

stand();

