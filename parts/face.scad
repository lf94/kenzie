include <../config.scad>
use <./clip.scad>

module face(dimensions, arm_width, kick_width, rotator_gap)
{
  width = dimensions[0];
  depth = dimensions[1];
  height = dimensions[2];
  clip_bottom_depth = kick_width / 5.0;
  clip_lip_depth = width / 5.0;
  clip_radius = depth / 2.0;

  // The front face of the stand
  difference() {
    cube(
      [width, depth, height],
      center = true
    );

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
 
  // The clips to attach the arm and kick. 
  translate([
    0,
    -clip_radius + (depth / -2.0),
    (height / 2.0) - (clip_female_height(clip_radius) / 2.0) - (extrude * 5.0)
  ])
  clip_female(arm_width, clip_radius);

  translate([
    (kick_width / 2.0) - (clip_bottom_depth / 2.0),
    -clip_radius + (depth / -2.0),
    0
  ])
  clip_female(clip_bottom_depth, clip_radius);

  translate([
    -(kick_width / 2.0) + (clip_bottom_depth / 2.0),
    -clip_radius + (depth / -2.0),
    0
  ])
  clip_female(clip_bottom_depth, clip_radius);

  // The clips to attach the lip to the face.
  translate([
    (width / -2.0) + (rotator_gap / 2.0) + stand_width(rotator_gap) + extrude,
    -extrude,
    (height / -2.0) + (clip_female_height(clip_radius) / 2.0)])
  rotate([180, 0, 0])
  clip_female(rotator_gap, clip_radius);

  translate([
    (width / 2.0) - (rotator_gap / 2.0) - stand_width(rotator_gap) - extrude,
    -extrude,
    (height / -2.0) + (clip_female_height(clip_radius) / 2.0)])
  rotate([180, 0, 0])
  clip_female(rotator_gap, clip_radius);
}

