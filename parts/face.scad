include <../config.scad>
use <./clip.scad>

//
// The flat side of the face.
//

module flat(dimensions, rotator_gap, clip_radius) {
  width = dimensions[0];
  depth = dimensions[1];
  height = dimensions[2];

  difference() {
    cube([width, depth, height], center = true);

    // Cut out lip rotators
    translate([
      (width / -2.0) + (rotator_gap / 2.0),
      0,
      (height / -2.0) + (clip_female_height(clip_radius) / 2.0)])
    cube(
      [rotator_gap, depth, clip_female_height(clip_radius)],
       center = true
    );

    translate([
      (width / 2.0) - (rotator_gap / 2.0),
      0,
      (height / -2.0) + (clip_female_height(clip_radius) / 2.0)])
    cube(
      [rotator_gap, depth, clip_female_height(clip_radius)],
       center = true
    );
  }
}

module face(dimensions, arm_width, kick_width, rotator_gap)
{
  width = dimensions[0];
  depth = dimensions[1];
  height = dimensions[2];

  clip_bottom_depth = kick_width / 5.0;
  clip_lip_depth = width / 5.0;
  clip_radius = depth / 2.0;

  clip_vertical_align = 0.20;

  // The flat side of the face.
  flat([width, depth, height], rotator_gap, clip_radius);
 
  // The clips to attach the arm and kick. 
  translate([
    0,
    (depth / -2.0) - clip_female_height(clip_radius) / 3.0,
    (height / 2.0) - (clip_female_height(clip_radius) / 2.0)
  ])
  clip_female(arm_width, clip_radius);

  translate([
    (kick_width / 2.0) - (clip_bottom_depth / 2.0),
    (depth / -2.0) - clip_female_height(clip_radius) / 3.0,
    0
  ])
  clip_female(clip_bottom_depth, clip_radius);

  translate([
    -(kick_width / 2.0) + (clip_bottom_depth / 2.0),
    (depth / -2.0) - clip_female_height(clip_radius) / 3.0,
    0
  ])
  clip_female(clip_bottom_depth, clip_radius);

  // The clips to attach the lip to the face.
  translate([
    (width / -2.0) + rotator_gap - clip_female_width(rotator_gap) / 2.0,
    clip_vertical_align,
    (height / -2.0) + (clip_female_height(clip_radius) / 2.0)])
  rotate([180, 0, 0])
  clip_female(rotator_gap, clip_radius);

  translate([
    (width / 2.0) - rotator_gap + clip_female_width(rotator_gap) / 2.0,
    clip_vertical_align,
    (height / -2.0) + (clip_female_height(clip_radius) / 2.0)])
  rotate([180, 0, 0])
  clip_female(rotator_gap, clip_radius);
}

