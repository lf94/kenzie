include <../config.scad>
use <./hinge.scad>

function cut_height(height) = height + (profile * 4.0);

//
// Creating a single cut.
//

module kick_cut(dimensions) {
  width = dimensions[0];
  depth = dimensions[1];
  height = dimensions[2];

  cut_y = height / 2.0;
  cut_ds = [width, height];

  translate([width / -2.0, -cut_y, 0])
  hull() {
    translate([0, cut_y, depth])
    linear_extrude(height = profile) {
      square(cut_ds);
    }
    linear_extrude(height = profile) {
      square(cut_ds);
    }
  }
}

//
// Create many slats/rungs/cuts for the kick.
//

module kick_cuts(dimensions, total) {
  width = dimensions[0];
  depth = dimensions[1];
  height = dimensions[2];

  translate([0, depth / 2.0, ((height * total) + depth) / -2.0])
  for(n = [0 : 1 : total - 1]) {
    translate([0, 0, n * cut_height(height)])
    rotate([90, 0, 0])
    kick_cut(dimensions);
  }
}

//
// The flat part of the kick.
//

module flat(dimensions) {
  width = dimensions[0];
  depth = dimensions[1];
  height = dimensions[2];

  difference() {
    cube([width, depth, height], center = true);
  
    // Cut out space for kicks
    translate([
      depth * -2.0,
      depth / -2.0,
      height / -2.0
    ])
    cube([depth * 4.0, depth, height]);
  }
}

//
// The kick itself, which holds the weight of the object.
//

module kick(width, depth, height) {
  hinges_bottom_z = height / 2.0 + depth;
  hinge_depth = width / 5.0;

  translate([-((width / 2.0) - (hinge_depth / 2.0)), 0, hinges_bottom_z])
  pin(hinge_depth, depth / 2.0);

  translate([(width / 2.0) - (hinge_depth / 2.0), 0, hinges_bottom_z])
  pin(hinge_depth, depth / 2.0);

  flat([width, depth, height]);

  cut_width = depth * 2.0;
  cut_depth = depth / 2.0;
  cut_z = height / 2.0;

  difference() {
    translate([-cut_width, -cut_depth, -cut_z])
    cube([cut_width * 2.0, depth, height]);

    translate([-cut_width, -cut_depth, cut_z - depth])
    cube([cut_width * 2.0, depth, depth]);

    kick_cuts([
        cut_width * 2.0,
        depth + profile,
        depth + (profile * 2.0)
      ],
      (height / cut_height(depth)) - 1
    );
  }
}

