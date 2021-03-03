//
// Limbani Stand CC-BY-SA Lee Fallat 2021
//

// The Belfry OpenScad Library used for filleting cubes.
include <BOSL/constants.scad>
use <BOSL/shapes.scad>

// This adjusts the number of fragments in shapes.
$fn = 50;

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

arm_height = (stand_height / 2.0);
arm_width = stand_width / 7.0;

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
      thickness + (epsilon * 4.0),
      thickness + (epsilon * 8.0),
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
    clip_male(depth, (radius + epsilon * 2.0));
  }
}

//
// The definitions for a stand.
//

module face(width, depth, height, lip_length) {
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
    cube([
      lip_rotator_gap + epsilon,
      depth + epsilon,
      clip_height 
    ], center = true);
  }
 
  // The  clips to attach the arm and kick. 
  translate([0, -depth + (epsilon * 10.0), (height / 2.0) - (clip_radius * 1.5) / 2.0])
  clip_female(arm_width, clip_radius);

  translate([(-(kick_width / 2.0)) + (clip_bottom_depth / 2.0), -depth + (epsilon * 10.0), 0])
  clip_female(clip_bottom_depth, clip_radius);

  translate([-(-(kick_width / 2.0)) - (clip_bottom_depth / 2.0), -depth + (epsilon * 10.0), 0])
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
  stub_height = ((height * 2.0) - ((clip_height - (height * 2.0)) / 2.0)) - epsilon;

  // The lip
  difference() {
    cuboid(
      [width, depth, height],
      center = true,
      edges = EDGES_Z_BK,
      fillet = height / 2.0
    );

    // Gap to connect face
    translate([
      0,
      (depth / -2.0) + (height / 2.0),
      0
    ])
    cuboid([
        width - ((lip_rotator_stub  - (epsilon * 20.0)) * 2.0),
        height + (epsilon * 10.0),
        (stub_height / 2.0) + epsilon
      ],
      center = true,
      edges = EDGES_Z_BK,
      fillet = height / 2.0
    );
  }

  // Left lip rotator
  translate([
    (width / -2.0) + (lip_rotator_stub / 2.0) - ((epsilon * 20.0) / 2.0),
    (depth / -2.0) - (height / 2.0),
    (stub_height / 2.0) - (height / 2.0)
  ])
  cuboid(
    [lip_rotator_stub - (epsilon * 20.0), height, stub_height],
    center = true,
    edges = EDGES_Z_FR + EDGE_TOP_BK,
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
    edges = EDGES_Z_FR + EDGE_TOP_BK,
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
  translate([0, 0, (height / 2.0) - (clip_radius / 2.0)])
  clip_male(width, thickness);

  difference() {
    translate([0, 0, -thickness])
    cuboid(
      [width, thickness, height - thickness],
      center = true,
      edges = EDGES_X_BOT,
      fillet = thickness / 2.0
    );

    translate([width / -3.0, 0, (height / -2.0) + (thickness / 2.0)])
    cuboid(
      [(width / 3.0) + epsilon, thickness + epsilon, (thickness * 2.0) + epsilon],
      center = true,
      edges = EDGE_TOP_RT,
      fillet = thickness / 2.0
    );
    translate([width / 3.0, 0, (height / -2.0) + (thickness / 2.0)])
    cuboid(
      [(width / 3.0) + epsilon, thickness + epsilon, (thickness * 2.0) + epsilon],
      center = true,
      edges = EDGE_TOP_LF,
      fillet = thickness / 2.0
    );
  }
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

  translate([0, (stand_lip_length / 2.0) - (stand_thickness * 2.0), (stand_height / -2.0) - stand_thickness])
  lip(stand_width, stand_lip_length, stand_thickness);

  translate([0, -stand_thickness * 4.0, (arm_height / 2.0)])
  arm(arm_width, arm_height, stand_thickness, stand_thickness);

  translate([0, -stand_thickness * 8.0, (kick_height / -2.0) - (clip_height / 1.5)])
  kick(kick_width, kick_height, stand_thickness, kick_cut_spacing);
}

color([0.95,0.95,0.95])
stand();
