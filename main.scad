// Kenzie Stand ⓒ Lee Fallat 2021
$fn = 20;

stand_width = 142;
stand_height = 70;
stand_thickness = 2.5;
stand_lip_length = 20;

kick_width = stand_width / 1.5;
kick_top_height = (stand_height / 2.0) - stand_thickness;
kick_bottom_height = stand_height / 2.0;

kick_cut_spacing = stand_thickness / 2.0;

clip_radius = stand_thickness;

// A number to make things barely touch or extend.
epsilon = 0.05;

function total_kick_cuts(target_height, cut_height) =
target_height / cut_height;

module kick_cut(width = 1, height = 2, depth = 1) {
  translate([0, -(depth / 2.0), 0])
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
  for(a = [0 : 1 : total_kick_cuts(height, thickness) + 1]) {
    translate([0, 0, a * cut_height])
    rotate([90, 0, 0])
      kick_cut(
        thickness,
        thickness,
        thickness
      );
  }
}

module clip_male(depth, radius) {
  translate([0, 0, -(radius / 2.0)])
  difference() {
    cube([depth, radius, radius], center = true);
    cube([depth / 1.5, radius + epsilon, radius + epsilon], center = true);
  }

  translate([0, 0, 0])
  rotate([0, 90, 0])
    cylinder(depth, r = radius / 2.0, center = true);
}

module clip_female(depth, radius) {
  difference() {
    cube([(depth / 1.75) - epsilon, radius - epsilon, (radius * 1.5) - epsilon], center = true);
    translate([0, -(radius / 2.0) + (epsilon * 10.0), 0])
      clip_male(depth, radius);
  }
}

module face(width, height, thickness, lip_length) {
  clip_top_depth = width / 15.0;
  clip_bottom_depth = kick_width / 5.0;
  clip_lip_depth = width / 5.0;

  // The front face of the stand
  difference() {
    translate([0, 0, 0])
      cube([width, thickness, height], center = true);

    // Cut out lip rotators
    translate([
      -(width / 2.0),
      0,
      -((height / 2.0) - ((clip_radius * 1.5) / 2.0) + epsilon)
    ])
      cube([
        (clip_lip_depth * 1.5) + epsilon,
        thickness + epsilon,
        (clip_radius * 1.5) + epsilon
      ], center = true);
  }
  
  translate([0, -thickness, (height / 2.0) - (clip_radius * 1.5) / 2.0])
    clip_female(clip_top_depth, clip_radius);

  translate([(-(kick_width / 2.0)) + (clip_bottom_depth / 2.0), -thickness, 0])
    clip_female(clip_bottom_depth, clip_radius);

  translate([-(-(kick_width / 2.0)) - (clip_bottom_depth / 2.0), -thickness, 0])
    clip_female(clip_bottom_depth, clip_radius);

  // Lip rotators
  translate([
    -(width / 2.0) + (clip_lip_depth / 2.0),
    epsilon,
    -((height / 2.0) - ((clip_radius * 1.5) / 2.0))
  ])
    clip_female(clip_lip_depth, clip_radius);


  // The lip of the stand
  translate([0, thickness * -2.0, thickness * -2.0])
  union() {
  translate([
    0,
    (lip_length / 2.0) + (thickness / 2.0),
       -(height / 2.0) - (thickness / 2.0)
  ])
  cube([width, lip_length, thickness], center = true);

  t1 =  ((clip_lip_depth * 1.5) - clip_lip_depth) / 2.5;

  translate([
    -(width / 2.0) + (t1 / 2.0),
    epsilon,
    -((height / 2.0) - ((clip_radius * 1.5) / 2.0)) - (thickness / 2.0) - (epsilon
* 4.0)
  ])
    cube([
      t1 + epsilon,
      thickness + epsilon,
      ((clip_radius * 1.5) + thickness) - (epsilon * 8.0)
    ], center = true);

  t2 = (-(width / 2.0)) + (t1 / 1.5); 
  translate([
    t2,
    epsilon,
    -((height / 2.0) - ((clip_radius * 1.5) / 2.0))
  ])
  rotate([0, 90, 0])
    cylinder(clip_lip_depth - (t1 * 2.0), clip_radius / 2.0, clip_radius / 2.0);
  }
}

module kick_top(width, height, thickness, plug_width) {
  thickness_smaller = thickness - (epsilon * 4.0);

  translate([0, 0, (height / 2.0) - (clip_radius / 2.0)])
    clip_male(width * 2.0, thickness);

  translate([0, 0,((height / 2.0) - (clip_radius * 2.0)) - (thickness / 2)])
    cube([width * 2.0, thickness, thickness * 2.0], center = true);

  translate([0, 0, -thickness])
    cube([width, thickness_smaller, height - thickness], center = true);

  translate([0, 0, -(height / 3.0)])
    cube([width * 3, thickness_smaller, thickness_smaller], center = true);
}

module kick_bottom(width, height, thickness, cut_spacing) {
  clips_bottom_z = kick_bottom_height / 2.0 + clip_radius;
  clip_depth = width / 5.0;

  translate([-((width / 2.0) - (clip_depth / 2.0)), 0, clips_bottom_z])
    clip_male(clip_depth, clip_radius);

  translate([(width / 2.0) - (clip_depth / 2.0), 0, clips_bottom_z])
    clip_male(clip_depth, clip_radius);

  difference() {
    cube([width, thickness, height], center = true);
    kick_cuts(height / 2.0, thickness + epsilon, cut_spacing);
  }
}

module stand() {
  face(stand_width, stand_height, stand_thickness, stand_lip_length);
  translate([0, -stand_thickness * 4, (stand_height / 4.0)])
    kick_top(stand_thickness * 2.0, kick_top_height, stand_thickness, stand_thickness);
  translate([0, -stand_thickness * 8, -(stand_height / 4.0)])
    kick_bottom(kick_width, kick_bottom_height, stand_thickness, kick_cut_spacing);
}

stand();
