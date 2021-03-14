include <../config.scad>
use <./hinge.scad>

//
// The flat side of the face.
//

module flat(dimensions, rotator_gap, hinge_radius) {
  width = dimensions[0];
  depth = dimensions[1];
  height = dimensions[2];

  hinge_x = (width / 2.0) - (rotator_gap / 2.0);
  hinge_z = (height / -2.0) + (knuckle_height(hinge_radius) / 2.0);
  hinge_ds = [rotator_gap, depth, knuckle_height(hinge_radius)];

  difference() {
    // The flat part of the face.
    cube([width, depth, height], center = true);

    // Cut out space for hinges.
    translate([-hinge_x, 0, hinge_z])
    cube(hinge_ds, center = true);

    translate([hinge_x, 0, hinge_z])
    cube(hinge_ds, center = true);
  }
}

module face(dimensions, arm_width, kick_width, rotator_gap) {
  width = dimensions[0];
  depth = dimensions[1];
  height = dimensions[2];

  hinge_bottom_depth = kick_width / 5.0;
  hinge_lip_depth = width / 5.0;
  hinge_radius = depth / 2.0;

  hinge_vertical_align = 0.20;

  hinge_x = (kick_width / 2.0) - (hinge_bottom_depth / 2.0);
  hinge_y = (depth / -2.0) - knuckle_height(hinge_radius) / 3.0;
  hinge_z = (height / 2.0) - (knuckle_height(hinge_radius) / 2.0);

  hinge_lip_x
    = (width / 2.0)
    - rotator_gap
    + knuckle_width(rotator_gap) / 2.0;

  // The flat side of the face.
  flat([width, depth, height], rotator_gap, hinge_radius);
 
  // The hinge to attach the arm.
  translate([0, hinge_y, hinge_z])
  knuckle(arm_width, hinge_radius);

  // The hinges to attach the kick.
  translate([hinge_x, hinge_y, 0])
  knuckle(hinge_bottom_depth, hinge_radius);

  translate([-hinge_x, hinge_y, 0])
  knuckle(hinge_bottom_depth, hinge_radius);

  // The hinges to attach the lip to the face.
  translate([ -hinge_lip_x, hinge_vertical_align, -hinge_z])
  rotate([180, 0, 0])
  knuckle(rotator_gap, hinge_radius);

  translate([hinge_lip_x, hinge_vertical_align, -hinge_z])
  rotate([180, 0, 0])
  knuckle(rotator_gap, hinge_radius);
}

