include <../config.scad>
use <./clip.scad>

//
// The cuts in the kick which the arm goes through.
//

function cut_height(height) = height + (extrude * 4.0);

module kick_cut(width = 1, depth = 1, height = 2) {
  translate([width / -2.0, height / -2.0, 0])
  hull() {
    translate([0, height / 2.0, depth])
    linear_extrude(height = extrude) {
        hull() {
          square([width, height]);
      }
    }

    linear_extrude(height = extrude) {
        hull() {
          square([width, height]);
      }
    }
  }
}

module kick_cuts(width, depth, height, total) {
  translate([0, depth / 2.0, ((height * total) + depth) / -2.0])
  for(n = [0 : 1 : total - 1]) {
    translate([0, 0, n * cut_height(height)])
    rotate([90, 0, 0])
    kick_cut(width, depth, height);
  }
}

//
// The kick itself, which holds the weight of the object.
//

module kick(width, depth, height) {
  clips_bottom_z = height / 2.0 + depth;
  clip_depth = width / 5.0;

  translate([-((width / 2.0) - (clip_depth / 2.0)), 0, clips_bottom_z])
  clip_male(clip_depth, depth / 2.0);

  translate([(width / 2.0) - (clip_depth / 2.0), 0, clips_bottom_z])
  clip_male(clip_depth, depth / 2.0);

  difference() {
    cube([width, depth, height], center = true);

    translate([
      depth * -2.0,
      depth / -2.0,
      (height / 2.0) - (depth * 2.0)
    ])
    cube([depth * 4.0, depth, depth * 2.0]);

    translate([0, 0, depth * -1.0])
    kick_cuts(
      depth * 4.0,
      depth + extrude,
      depth + (extrude * 2.0),
      (height / cut_height(depth)) - 2
    );
  }
}

