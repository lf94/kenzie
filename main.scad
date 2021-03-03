//
// Kenzie Stand ⓒ Lee Fallat 2021
//

// The Belfry OpenScad Library used for filleting cubes.
include <BOSL/constants.scad>
use <BOSL/shapes.scad>

// This adjusts the number of fragments in shapes.
$fn = 20;

// A number to make things barely touch or extend.
epsilon = 0.05;

//
// The measurements are in millimeters.
// Adjust these to create new types of stands.
//

stand_width      = 142.0;
stand_height     = 70.0;
stand_thickness  = 2.5;
stand_lip_length = 20.0;

//
// The following parameters are derived or fixed.
//

arm_height  = (stand_height / 2.0) - stand_thickness;

clip_radius = stand_thickness;
clip_height_scale = 1.5;
clip_depth_scale = 1.75;
clip_height = (clip_radius * clip_height_scale) - epsilon;

kick_width  = stand_width / 1.5;
kick_height = stand_height / 2.0;

kick_cut_spacing = stand_thickness / 2.0;

lip_rotator_gap = 30.0;
lip_rotator_stub = lip_rotator_gap / 2.0;

//
// The cuts in the kick which the arm goes through.
//

function total_kick_cuts(target_height, cut_height) =
target_height / cut_height;

module kick_cut(width = 1, height = 2, depth = 1) {
  translate([0, depth / -2.0, 0])
  rotate([0, 0, 90])
  hull() {
    translate([depth, 0, depth])
    linear_extrude(height = epsilon) {
      hull() {
        translate([0, width, 0]) circle(height / 2.0);
        translate([0, -width, 0]) circle(height / 2.0);
      }
    }

    linear_extrude(height = epsilon) {
      hull() {
        translate([0, width, 0]) circle(height / 2.0);
        translate([0, -width, 0]) circle(height / 2.0);
      }
    }
  }
}

module kick_cuts(height, thickness, spacing) {
  cut_height = thickness + spacing;

  translate([0, thickness / 2.0, -(((height / 2.0) + spacing) + cut_height)])
  for(n = [0 : 1 : total_kick_cuts(height, thickness) + 1]) {
    translate([0, 0, n * cut_height])
    rotate([90, 0, 0])
    kick_cut(
      thickness,
      thickness,
      thickness
    );
  }
}

//
// The definitions for the "rotational" clips.
//

module clip_male(depth, radius) {
  translate([0, 0, radius / -2.0])
  difference() {
    cube([depth, radius, radius], center = true);
    cube([depth / clip_height_scale, radius + epsilon, radius + epsilon], center = true);
  }

  translate([0, 0, 0])
  rotate([0, 90, 0])
  cylinder(depth, r = radius / 2.0, center = true);
}

module clip_female(depth, radius) {
  difference() {
    cuboid([
        (depth / clip_depth_scale) - epsilon,
        radius - epsilon,
        (radius * clip_height_scale) - epsilon
      ],
      center = true,
      edges = EDGES_X_FR,
      fillet = radius / 3.0
    );

    translate([0, (radius / -2.0) + (epsilon * 10.0), 0])
    clip_male(depth, radius);
  }
}

//
// The definitions for a stand.
//

module face(width, depth, height, lip_length) {
  clip_top_depth    = width / 15.0;
  clip_bottom_depth = kick_width / 5.0;
  clip_lip_depth    = width / 5.0;

  // The front face of the stand
  difference() {
    translate([0, 0, 0])
    cuboid(
      [width, depth, height],
      center = true,
      edges = EDGES_Y_ALL,
      fillet = depth / 2.0
    );

    // Cut out lip rotators
    translate([
      (width / -2.0) + (lip_rotator_gap / 2.0),
      0,
      (height / -2.0) + (clip_height / 2.0) - epsilon
    ])
    color([1,0,0])
    cube([
      lip_rotator_gap + epsilon,
      depth + epsilon,
  clip_height 
    ], center = true);

    translate([
      (width / 2.0) - (lip_rotator_gap / 2.0),
      0,
      (height / -2.0) + (clip_height / 2.0) - epsilon
    ])
    color([1,0,0])
    cube([
      lip_rotator_gap + epsilon,
      depth + epsilon,
      clip_height 
    ], center = true);
  }
 
  // The  clips to attach the arm and kick. 
  translate([0, -depth, (height / 2.0) - (clip_radius * 1.5) / 2.0])
  clip_female(clip_top_depth, clip_radius);

  translate([(-(kick_width / 2.0)) + (clip_bottom_depth / 2.0), -depth, 0])
  clip_female(clip_bottom_depth, clip_radius);

  translate([-(-(kick_width / 2.0)) - (clip_bottom_depth / 2.0), -depth, 0])
  clip_female(clip_bottom_depth, clip_radius);

  // Lip rotators
  translate([
    (width / -2.0) + (lip_rotator_gap / 2.0) + ((lip_rotator_gap / clip_depth_scale) / 2.0),
    epsilon / 2.0,
    (height / -2.0) + ((clip_radius * 1.5) / 2.0)
  ])
  clip_female(lip_rotator_gap, clip_radius);

  translate([
    (width / 2.0) - (lip_rotator_gap / 2.0) - ((lip_rotator_gap / clip_depth_scale) / 2.0),
    epsilon / 2.0,
    (height / -2.0) + ((clip_radius * 1.5) / 2.0)
  ])
  clip_female(lip_rotator_gap, clip_radius);

}

module lip(width, depth, height) {
  stub_height =  height + (clip_radius * clip_depth_scale);

  // The lip
  cuboid(
    [width, depth, height],
    center = true,
    edges = EDGES_Z_BK,
    fillet = height / 2.0
  );

  // Left lip rotator
  translate([
    (width / -2.0) + (lip_rotator_stub / 2.0) - ((epsilon * 20.0) / 2.0),
    (depth / -2.0) - (height / 2.0),
    (stub_height / 2.0) - (height / 2.0)
  ])
  cuboid(
    [lip_rotator_stub - (epsilon * 20.0), height, stub_height],
    center = true,
    edges = EDGES_Z_FR,
    fillet = height / 2.0
  );

  translate([
    (width / -2.0) + (lip_rotator_gap / 2.0),
    (depth / -2.0) - (height / 2.0),
    (stub_height / 2.0)
  ])
  rotate([0, 90, 0])
  cylinder(lip_rotator_gap / 1.1, r = clip_radius / 2.0, center = true);

  // Right lip rotator
  translate([
    (width / 2.0) - (lip_rotator_stub / 2.0) + ((epsilon * 20.0) / 2.0),
    (depth / -2.0) - (height / 2.0),
    (stub_height / 2.0) - (height / 2.0)
  ])
  cuboid(
    [lip_rotator_stub - (epsilon * 20.0), height, stub_height],
    center = true,
    edges = EDGES_X_TOP,
    fillet = height / 2.0
  );

  translate([
    (width / 2.0) - (lip_rotator_gap / 2.0),
    (depth / -2.0) - (height / 2.0),
    (stub_height / 2.0)
  ])
  rotate([0, 90, 0])
  cylinder(lip_rotator_gap / 1.1, r = clip_radius / 2.0, center = true);
}

module arm(width, height, thickness, plug_width) {
  thickness_smaller = thickness - (epsilon * 4.0);

  translate([0, 0, (height / 2.0) - (clip_radius / 2.0)])
  clip_male(width * 2.0, thickness);

  translate([0, 0,((height / 2.0) - (clip_radius * 2.0)) - (thickness / 2)])
  cuboid(
    [width * 2.0, thickness, thickness * 2.0],
    center = true,
    edges = EDGES_Y_BOT,
    fillet = thickness / 3.0
  );

  translate([0, 0, -thickness])
  cuboid(
    [width, thickness_smaller, height - thickness],
    center = true,
    edges = EDGES_X_FR + EDGES_X_BK,
    fillet = thickness / 3.0
  );

  translate([0, 0, -(height / 3.0)])
  cuboid(
    [width * 3, thickness_smaller, thickness_smaller],
    center = true,
    edges = EDGES_X_FR,
    fillet = thickness / 3.0
  );
}

module kick(width, height, thickness, cut_spacing) {
  clips_bottom_z = kick_height / 2.0 + clip_radius;
  clip_depth = width / 5.0;

  translate([-((width / 2.0) - (clip_depth / 2.0)), 0, clips_bottom_z])
  clip_male(clip_depth, clip_radius);

  translate([(width / 2.0) - (clip_depth / 2.0), 0, clips_bottom_z])
  clip_male(clip_depth, clip_radius);

  difference() {
    cuboid(
      [width, thickness, height],
      center = true,
      edges = EDGES_Y_BOT,
      fillet = thickness / 2.0
    );
    kick_cuts(height / 2.0, thickness + epsilon, cut_spacing);
  }
}

module stand() {
  translate([0, 0, 0])
  face(stand_width, stand_thickness, stand_height, stand_lip_length);

  translate([0, (stand_lip_length + stand_thickness) / 2.0, (-stand_thickness * 2) - (stand_height / 2.0)])
  lip(stand_width, stand_lip_length, stand_thickness);

  translate([0, -stand_thickness * 4, (stand_height / 4.0)])
  arm(stand_thickness * 2.0, arm_height, stand_thickness, stand_thickness);

  translate([0, -stand_thickness * 8, -(stand_height / 4.0)])
  kick(kick_width, kick_height, stand_thickness, kick_cut_spacing);
}

stand();
