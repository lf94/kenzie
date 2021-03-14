include <../config.scad>
use <./hinge.scad>

//
// The flat side of the face.
//

module flat(dimensions, rotator_gap, hinge_radius) {
  width = dimensions[0];
  depth = dimensions[1];
  height = dimensions[2];

  difference() {
    cube([width, depth, height], center = true);

    // Cut out lip rotators
    translate([
      (width / -2.0) + (rotator_gap / 2.0),
      0,
      (height / -2.0) + (knuckle_height(hinge_radius) / 2.0)])
    cube(
      [rotator_gap, depth, knuckle_height(hinge_radius)],
       center = true
    );

    translate([
      (width / 2.0) - (rotator_gap / 2.0),
      0,
      (height / -2.0) + (knuckle_height(hinge_radius) / 2.0)])
    cube(
      [rotator_gap, depth, knuckle_height(hinge_radius)],
       center = true
    );
  }
}

module face(dimensions, arm_width, kick_width, rotator_gap)
{
  width = dimensions[0];
  depth = dimensions[1];
  height = dimensions[2];

  hinge_bottom_depth = kick_width / 5.0;
  hinge_lip_depth = width / 5.0;
  hinge_radius = depth / 2.0;

  hinge_vertical_align = 0.20;

  // The flat side of the face.
  flat([width, depth, height], rotator_gap, hinge_radius);
 
  // The hinges to attach the arm and kick. 
  translate([
    0,
    (depth / -2.0) - knuckle_height(hinge_radius) / 3.0,
    (height / 2.0) - (knuckle_height(hinge_radius) / 2.0)
  ])
  knuckle(arm_width, hinge_radius);

  translate([
    (kick_width / 2.0) - (hinge_bottom_depth / 2.0),
    (depth / -2.0) - knuckle_height(hinge_radius) / 3.0,
    0
  ])
  knuckle(hinge_bottom_depth, hinge_radius);

  translate([
    -(kick_width / 2.0) + (hinge_bottom_depth / 2.0),
    (depth / -2.0) - knuckle_height(hinge_radius) / 3.0,
    0
  ])
  knuckle(hinge_bottom_depth, hinge_radius);

  // The hinges to attach the lip to the face.
  translate([
    (width / -2.0) + rotator_gap - knuckle_width(rotator_gap) / 2.0,
    hinge_vertical_align,
    (height / -2.0) + (knuckle_height(hinge_radius) / 2.0)])
  rotate([180, 0, 0])
  knuckle(rotator_gap, hinge_radius);

  translate([
    (width / 2.0) - rotator_gap + knuckle_width(rotator_gap) / 2.0,
    hinge_vertical_align,
    (height / -2.0) + (knuckle_height(hinge_radius) / 2.0)])
  rotate([180, 0, 0])
  knuckle(rotator_gap, hinge_radius);
}

